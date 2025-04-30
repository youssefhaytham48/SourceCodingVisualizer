function SourceCodingVisualizer()

    % Create Main UI Figure
    fig = uifigure('Name', 'Coding Techniques Comparison', ...
                   'Position', [500 300 420 500], ...
                   'Color', [1 1 1]);

    % Header Panel
    header = uipanel(fig, ...
        'Title', '', ...
        'Position', [0 460 420 40], ...
        'BackgroundColor', [0.2 0.4 0.7]);

    titleLabel = uilabel(header, ...
        'Text', 'CODING TECHNIQUES COMPARISON', ...
        'FontWeight', 'bold', ...
        'FontSize', 14, ...
        'FontColor', [1 1 1], ...
        'Position', [60 5 300 30], ...
        'HorizontalAlignment', 'center');

    % Input Panel
    inputPanel = uipanel(fig, ...
        'Title', 'Input Parameters', ...
        'FontWeight', 'bold', ...
        'Position', [20 320 380 120]);

    uilabel(inputPanel, ...
        'Text', 'Symbols (space-separated):', ...
        'Position', [10 70 180 20]);
    user_s = uieditfield(inputPanel, 'text', ...
        'Position', [10 50 360 25]);

    uilabel(inputPanel, ...
        'Text', 'Probabilities (space-separated):', ...
        'Position', [10 25 200 20]);
    user_p = uieditfield(inputPanel, 'text', ...
        'Position', [10 5 360 25]);

    % Output Panel
    outputPanel = uipanel(fig, ...
        'Title', 'Results', ...
        'FontWeight', 'bold', ...
        'Position', [20 130 380 180]);

    output = uilistbox(outputPanel, ...
        'Position', [10 10 360 140], ...
        'FontName', 'Verdana', ...
        'FontWeight', 'bold', ...
        'FontSize', 12);

    % Buttons
    uibutton(fig, 'push', ...
        'Text', 'FANO', ...
        'Position', [30 70 100 40], ...
        'BackgroundColor', [0.2 0.4 0.8], ...
        'FontColor', 'white', ...
        'FontWeight', 'bold', ...
        'ButtonPushedFcn', @(btn,event) btn_callback_fano(user_s, user_p, output));

    uibutton(fig, 'push', ...
        'Text', 'HUFFMAN', ...
        'Position', [160 70 100 40], ...
        'BackgroundColor', [0.8 0.3 0.2], ...
        'FontColor', 'white', ...
        'FontWeight', 'bold', ...
        'ButtonPushedFcn', @(btn,event) btn_callback_huffman(user_s, user_p, output));

    uibutton(fig, 'push', ...
        'Text', 'LEMPEL-ZIV', ...
        'Position', [290 70 100 40], ...
        'BackgroundColor', [0.3 0.6 0.2], ...
        'FontColor', 'white', ...
        'FontWeight', 'bold', ...
        'ButtonPushedFcn', @(btn,event) btn_callback_lz(user_s, output));
end

% Fano Coding Callback
function btn_callback_fano(user_s, user_p, output)
    s = strsplit(user_s.Value);
    p = str2num(user_p.Value);

    if length(s) ~= length(p)
        output.Items = {'Probabilities Mismatched With Symbols'}; return;
    end
    if abs(sum(p) - 1) > 1e-6
        output.Items = {'Sum of Probabilities Should Be One'}; return;
    end

    n = length(p);
    [sorted_p, indexing] = sort(p, 'descend');
    sorted_s = s(indexing);
    alpha = cumsum([0, sorted_p(1:end-1)]);

    len = zeros(1,n);
    binary = cell(1,n);
    for i = 1:n
        len(i) = ceil(log2(1 / sorted_p(i)));
        binary{i} = dec2bin(floor(alpha(i) * 2^len(i)), len(i));
    end

    results = {'Fano Coding:'};
    for i = 1:n
        results{end+1} = sprintf('%s (%.2f): %s', sorted_s{i}, sorted_p(i), binary{i});
    end

    output.Items = results;
end

% Huffman Coding Callback
function btn_callback_huffman(user_s, user_p, output)
    s = strsplit(user_s.Value);
    p = str2num(user_p.Value);

    if length(s) ~= length(p)
        output.Items = {'Probabilities Mismatched With Symbols'}; return;
    end
    if abs(sum(p) - 1) > 1e-6
        output.Items = {'Sum of Probabilities Should Be One'}; return;
    end

    [dict, ~] = huffmandict(s, p);

    results = {'Huffman Coding:'};
    for i = 1:length(dict)
        code = sprintf('%d', dict{i,2});
        results{end+1} = sprintf('%s (%.2f): %s', dict{i,1}, p(i), code);
    end

    output.Items = results;
end

% Lempel-Ziv 
function btn_callback_lz(user_s, output)
    seq = user_s.Value;
    res = {'=== LEMPEL-ZIV (LZ78) ==='};

    if ~ischar(seq)
        seq = char(seq);
    end

    dict = containers.Map('KeyType','char','ValueType','double');
    nextCode = 1; pos = 1;
    outputPairs = {};

    while pos <= length(seq)
        cur = ''; idx = 0;
        for len = 1:length(seq)-pos+1
            sub = seq(pos:pos+len-1);
            if isKey(dict, sub)
                cur = sub;
                idx = dict(sub);
            else
                break;
            end
        end

        if pos + length(cur) <= length(seq)
            ch = seq(pos + length(cur));
            outputPairs{end+1} = {idx, ch}; 
            dict([cur ch]) = nextCode;
            nextCode = nextCode + 1;
            pos = pos + length(cur) + 1;
        else
            if idx > 0
                outputPairs{end+1} = {idx, ''}; 
            else
                outputPairs{end+1} = {0, seq(pos)}; 
            end
            pos = pos + length(cur);
        end
    end

    res{end+1} = '--- Custom Binary Output ---';
    binaryList = {};
    totalPairs = numel(outputPairs);
    idxBits = ceil(log2(totalPairs + 1));
    if idxBits < 1
        idxBits = 1;
    end

    for i = 1:totalPairs
        pair = outputPairs{i};
        idx = pair{1};
        ch = pair{2};

        idxBinary = dec2bin(idx, idxBits);
        if ch == 'A'
            chBinary = '1';
        elseif ch == 'B'
            chBinary = '0';
        else
            chBinary = '';
        end

        fullBinary = [idxBinary chBinary];
        binaryList{end+1} = fullBinary; 
        res{end+1} = sprintf('Pair %d: (%d, %s) → %s', i, idx, ch, fullBinary);
    end

    res{end+1} = ' ';
    res{end+1} = ['Final Encoded Output: {' strjoin(binaryList, ' ') '}'];

    output.Items=res;
end