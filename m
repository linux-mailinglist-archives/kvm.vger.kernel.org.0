Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9972D3762
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 01:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730589AbgLIAGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 19:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgLIAGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 19:06:02 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EDAC0613CF
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 16:05:22 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id q25so494326oij.10
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 16:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MmDUknZbPdoOOOe7WkzxUZQ1fpq6zqZ4xwNAy8krZNU=;
        b=b1hcCLKDRny55X7kM4SfG+K3WbqEOqAJGiusqUOUVVsFRXakdW7RelaLI4UbIrxb0S
         5LnWnS3GbhR62PdMJ1iZ6bu4fe8npetcr/Lihga3B9wqOHMBcqONQLDsU/80K7Jzd5wx
         RPTbiqHRqCe0GLSYHPIhJdehmdF+/W0G1d06isSRx6klC7kq0byqIaKbAk+EsgzgyWyp
         kox4jbj7l9VF5FVdnVLRSqtgi8uk+PSqqK7yNMuUiMJeu3b/cgdEmnjuAn4ga+xHqYzj
         H7NJZXe58W5rVKM1jycqQl2zzXCLh7J9cQ0hF39EWBof9FK8Tozj9AmoquLlGPlSte3i
         2G7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MmDUknZbPdoOOOe7WkzxUZQ1fpq6zqZ4xwNAy8krZNU=;
        b=fjId7Gdhl1UQ+70t2lXAVCetpKH+gM5xYdjdMsHn9KUG335ZPo/VVES+2CzMH+eaqr
         8HG6uOz7Nhx3aEBlbjJsVrMum8EluEomdQEziDAFyQr28MBhHNgPGP6dgEzlNmL9u//D
         1yLImCz+wGr6FKxg1mV8YvrSicEm2yxeC647dz9+t05MJODzlLWmdl4qcB4Xy5yQw93Z
         xCXwS05+BLmp3bf1P9lEX2XgnwNQujFxF7A6DSzbdi65sM0TTHrwmaFW5D6lIdWb87Ts
         RVxC0vosPBg0bRrvtaU+X9TSvKJ3GMolUPeFhF3tcvwwnAZR3ktWZPXmBljkUGgxdYWy
         fijw==
X-Gm-Message-State: AOAM532i575Mndui45PMv+RD2TvNGyeAoVEbnOJLAIL4YLirBfuEKikU
        dzM2dASMVdXIyF9LvknpBgzN8Q==
X-Google-Smtp-Source: ABdhPJxQUw34FDhia5F1bFPgZKf08UqJf1dqRMoPcDDU7488cayhesVtgx8SYUmL7PhDSr3cBog13w==
X-Received: by 2002:aca:f3c6:: with SMTP id r189mr301659oih.83.1607472321823;
        Tue, 08 Dec 2020 16:05:21 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id k13sm85929otl.72.2020.12.08.16.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 16:05:21 -0800 (PST)
Subject: Re: [PATCH 16/17] target/mips: Introduce decode tree bindings for MSA
 opcodes
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20201208003702.4088927-1-f4bug@amsat.org>
 <20201208003702.4088927-17-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <c36ea51b-59e0-22a0-ebb1-9f1224df32b5@linaro.org>
Date:   Tue, 8 Dec 2020 18:05:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201208003702.4088927-17-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 6:37 PM, Philippe Mathieu-Daudé wrote:
> Introduce the 'mod-msa32' decodetree config for the 32-bit MSA ASE.
> 
> We decode the branch instructions, and all instructions based
> on the MSA opcode.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate.h         |  1 +
>  target/mips/mod-msa32.decode    | 24 ++++++++++++++++++++++++
>  target/mips/mod-msa_translate.c | 31 +++++++++++++++++++++++++++++++
>  target/mips/meson.build         |  5 +++++
>  4 files changed, 61 insertions(+)
>  create mode 100644 target/mips/mod-msa32.decode

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

