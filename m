Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEBA79AB4B
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 22:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjIKUrJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241297AbjIKPGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 11:06:06 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81D31B9
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 08:06:00 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-502a25ab777so4567686e87.2
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 08:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694444759; x=1695049559; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d7LOky8NcfwGAuWJ42oVUPUIAPebXa+3JQ/Lqf8kx4w=;
        b=guDpJBsPDEvauLqWU0btQlicdUy4fWxDziCVoG7eRz10/61OEDRUXKLxxTdcZkfi2K
         m4KqPE8UE5UeN+p7E/wgIdyX0VtHQhcZme9yW/OiHZiTGZHY3aDe8uKxJg2I7zL0zwO+
         DgDPBvoXVtXBwTcQxeFVg5okvikuUPGdgW43qYAQnDY4Utjh2w4R3dQNm7ktPtIwS1tO
         njNM3Ge3UjGNcFl6pPOodlFTex3wUkkHb60B9ddKqftul/QnPnUtcIKYbUErwcCDZ+L7
         KazATGqKMSdpoAUegugOQUw37uN0cm/+a2KIVcYJmt/G7qhT8P9VEEI3oiARF7/M12WM
         +OIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694444759; x=1695049559;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d7LOky8NcfwGAuWJ42oVUPUIAPebXa+3JQ/Lqf8kx4w=;
        b=lYTJZQOXQePD+N2VSTv7lobgpwartypBFpeIbOBBJLwYxgDlT8+JjR6gMiFlkm5DU5
         B8fqhJYV0kbTztWSJNG8NhT9mNuYSMajaWP3WY2mo7IzZ4TEoT5tSIDfgKlJRsa0D7Q2
         duXMK51Dn5LytnHQNX3Kp8WEMVbShzaYqBNFPa1grnaRG0O5xKFYPstoc/quwUsds8+4
         epRnx1w6dE3WAFwkRn4yGFka5SV1ipUOmHd8XpFCU9jjgwweBBSgtKoScLAlJ5lcdJ7O
         biCNRNOQqXDAOwhkkCBx1QPdrqxESsN2CBh+gnQjJdUve7WT1cjTYj0D3QI32Lun872N
         5HBw==
X-Gm-Message-State: AOJu0YymUjJWiMXVwI/ouYUyRl5Sp4sVKIP1Fy8hEV4VsrgVBO0Qe7Us
        AYScIba6RFP9GDBsUssIWlr4fA==
X-Google-Smtp-Source: AGHT+IEVB7SD5N85FLnF+qJrO5y4IE9g1kgV5jAopR4fDmyrLrWsbkmRNOsP57hOIZK40pf28RltuQ==
X-Received: by 2002:a05:6512:2212:b0:4fe:db6:cb41 with SMTP id h18-20020a056512221200b004fe0db6cb41mr9127047lfu.39.1694444758877;
        Mon, 11 Sep 2023 08:05:58 -0700 (PDT)
Received: from [192.168.69.115] (tfy62-h01-176-171-221-76.dsl.sta.abo.bbox.fr. [176.171.221.76])
        by smtp.gmail.com with ESMTPSA id g2-20020a50ee02000000b0051e2670d599sm4759103eds.4.2023.09.11.08.05.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Sep 2023 08:05:58 -0700 (PDT)
Message-ID: <28c832bc-2fbf-8caa-e141-51288fc0d544@linaro.org>
Date:   Mon, 11 Sep 2023 17:05:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v2] target/i386: Re-introduce few KVM stubs for Clang
 debug builds
Content-Language: en-US
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>
References: <20230911131507.24943-1-philmd@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230911131507.24943-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/9/23 15:15, Philippe Mathieu-Daudé wrote:
> Since commits 3adce820cf..ef1cf6890f, When building on
> a x86 host configured as:
> 
>    $ ./configure --cc=clang \
>      --target-list=x86_64-linux-user,x86_64-softmmu \
>      --enable-debug
> 
> we get:
> 
>    [71/71] Linking target qemu-x86_64
>    FAILED: qemu-x86_64
>    /usr/bin/ld: libqemu-x86_64-linux-user.fa.p/target_i386_cpu.c.o: in function `cpu_x86_cpuid':
>    cpu.c:(.text+0x1374): undefined reference to `kvm_arch_get_supported_cpuid'
>    /usr/bin/ld: libqemu-x86_64-linux-user.fa.p/target_i386_cpu.c.o: in function `x86_cpu_filter_features':
>    cpu.c:(.text+0x81c2): undefined reference to `kvm_arch_get_supported_cpuid'
>    /usr/bin/ld: cpu.c:(.text+0x81da): undefined reference to `kvm_arch_get_supported_cpuid'
>    /usr/bin/ld: cpu.c:(.text+0x81f2): undefined reference to `kvm_arch_get_supported_cpuid'
>    /usr/bin/ld: cpu.c:(.text+0x820a): undefined reference to `kvm_arch_get_supported_cpuid'
>    /usr/bin/ld: libqemu-x86_64-linux-user.fa.p/target_i386_cpu.c.o:cpu.c:(.text+0x8225): more undefined references to `kvm_arch_get_supported_cpuid' follow
>    clang: error: linker command failed with exit code 1 (use -v to see invocation)
>    ninja: build stopped: subcommand failed.
> 
> '--enable-debug' disables optimizations (CFLAGS=-O0).
> 
> While at this (un)optimization level GCC eliminate the
> following dead code:
> 
>    if (0 && foo()) {
>        ...
>    }
> 
> Clang does not. This was previously documented in commit 2140cfa51d
> ("i386: Fix build by providing stub kvm_arch_get_supported_cpuid()").
> 
> Fix by partially reverting those commits, restoring a pair of stubs
> for the unoptimized Clang builds.
> 
> Reported-by: Kevin Wolf <kwolf@redhat.com>
> Suggested-by: Daniel P. Berrangé <berrange@redhat.com>
> Fixes: 3adce820cf ("target/i386: Remove unused KVM stubs")
> Fixes: ef1cf6890f ("target/i386: Allow elision of kvm_hv_vpindex_settable()")
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/i386/kvm/kvm-stub.c  | 31 +++++++++++++++++++++++++++++++
>   target/i386/kvm/meson.build |  2 ++
>   2 files changed, 33 insertions(+)
>   create mode 100644 target/i386/kvm/kvm-stub.c

Patch superseded, see v3:
https://lore.kernel.org/qemu-devel/20230911142729.25548-1-philmd@linaro.org/
