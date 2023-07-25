Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E957618B0
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 14:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbjGYMq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 08:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233555AbjGYMqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 08:46:50 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA5C1FC2
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 05:46:45 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3fbef8ad9bbso55214845e9.0
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 05:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690289204; x=1690894004;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vGZfR87BHs9oeqzgBVuatJQdA+4mkMBaJLIsLtfbPMk=;
        b=IdvQAPz4rzNdx7OL8RFglwYMiu6cp6MbguEYYalyfgi7NSkgrAQkZpthCM0XwLInGr
         j+/HMKAampiViKRO0eA54kSBi6rADyaLSAcZ6PIL+dZxJ1OpkBjHUXWCNlcC9x+nmf7k
         Qe6LCbezvt4NmXC7dnEKILuHWIvd7gnimZnCPnZGJD6POnyJq3u/FOgi1lfhqFhA6M3b
         ReDzcZ5jHHVzu6ySPu41T497968lBBU2YeIdArFulHFOzROh91lwlVqxbhVxtsw9rX9o
         F66+lw5Q8qkCKf3OR25EyClr9Eo8QEalfqR3kYtZGGTLjwWIFXlSE5r9OPNoDGLuP2L1
         NWug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690289204; x=1690894004;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vGZfR87BHs9oeqzgBVuatJQdA+4mkMBaJLIsLtfbPMk=;
        b=eZtBIgDK3HPeLkad5v7xCYWWt/t4Ysg7JlRCoQFVe0mYr1FTSrWzHKTbrFePpLwrsN
         TmtcP6txBez4QT85is4twCSb+ibHnuNLqy056Yq3W1NFR8qKlpnagG709ChnzyGnHoTm
         rHfhmRk46rm0kFNA8X2nkcRBomFHLNi/yka3p5tIR5M0fY9jEyZLlM/+p78DYnGNrZed
         1QGJcLr0yOOuDXDA5D9LCh04G6lkHO+l9yO5SeYkNHs498hPhWrik6kF2Typyxi6ani0
         WQqJLc8zE5lkQurSM/h9gzMKu+wPgzuQE0va5/GwVIANTb6WH+a5pNliBMi9KLOyFgXF
         J2sg==
X-Gm-Message-State: ABy/qLZYbulvo+kG4bw+YS31gAtNr0Bv+Y94sBKxG23ztD6RsSg+/Y7f
        HllPTahws1Q9ei15qfeXvnkjnA==
X-Google-Smtp-Source: APBJJlH7WkK29a1HlMg6KsiP2yOw/oo3i/E0wfXrqpWMfC///b2qFLXwgOEIQBSoqt5Hwa+hxrpOXg==
X-Received: by 2002:a7b:c4d8:0:b0:3fb:d1db:545b with SMTP id g24-20020a7bc4d8000000b003fbd1db545bmr10280852wmk.20.1690289204286;
        Tue, 25 Jul 2023 05:46:44 -0700 (PDT)
Received: from [192.168.69.115] ([176.187.203.142])
        by smtp.gmail.com with ESMTPSA id x3-20020a05600c21c300b003fa95890484sm13210500wmj.20.2023.07.25.05.46.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 05:46:43 -0700 (PDT)
Message-ID: <c090e018-9761-4cc0-61ce-780ff70e318a@linaro.org>
Date:   Tue, 25 Jul 2023 14:46:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v2] kvm: Remove KVM_CREATE_IRQCHIP support assumption
Content-Language: en-US
To:     Andrew Jones <ajones@ventanamicro.com>, qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, peter.maydell@linaro.org,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, thuth@redhat.com,
        dbarboza@ventanamicro.com, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, qemu-s390x@nongnu.org
References: <20230725122601.424738-2-ajones@ventanamicro.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230725122601.424738-2-ajones@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/7/23 14:26, Andrew Jones wrote:
> Since Linux commit 00f918f61c56 ("RISC-V: KVM: Skeletal in-kernel AIA
> irqchip support") checking KVM_CAP_IRQCHIP returns non-zero when the
> RISC-V platform has AIA. The cap indicates KVM supports at least one
> of the following ioctls:
> 
>    KVM_CREATE_IRQCHIP
>    KVM_IRQ_LINE
>    KVM_GET_IRQCHIP
>    KVM_SET_IRQCHIP
>    KVM_GET_LAPIC
>    KVM_SET_LAPIC
> 
> but the cap doesn't imply that KVM must support any of those ioctls
> in particular. However, QEMU was assuming the KVM_CREATE_IRQCHIP
> ioctl was supported. Stop making that assumption by introducing a
> KVM parameter that each architecture which supports KVM_CREATE_IRQCHIP
> sets. Adding parameters isn't awesome, but given how the
> KVM_CAP_IRQCHIP isn't very helpful on its own, we don't have a lot of
> options.
> 
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
> 
> While this fixes booting guests on riscv KVM with AIA it's unlikely
> to get merged before the QEMU support for KVM AIA[1] lands, which
> would also fix the issue. I think this patch is still worth considering
> though since QEMU's assumption is wrong.
> 
> [1] https://lore.kernel.org/all/20230714084429.22349-1-yongxuan.wang@sifive.com/
> 
> v2:
>    - Move the s390x code to an s390x file. [Thomas]
>    - Drop the KVM_CAP_IRQCHIP check from the top of kvm_irqchip_create(),
>      as it's no longer necessary.
> 
>   accel/kvm/kvm-all.c    | 16 ++++------------
>   include/sysemu/kvm.h   |  1 +
>   target/arm/kvm.c       |  3 +++
>   target/i386/kvm/kvm.c  |  2 ++
>   target/s390x/kvm/kvm.c | 11 +++++++++++
>   5 files changed, 21 insertions(+), 12 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

