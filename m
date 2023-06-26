Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77AB73DC39
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 12:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjFZK2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 06:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjFZK2e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 06:28:34 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADB5E66
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 03:28:26 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2b6a16254a4so10915351fa.0
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 03:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687775304; x=1690367304;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SlLbl4k7Er5MQ2EA7lMi/0F7IALSlRv5Fiy4Evgi9NE=;
        b=Ssjc1BHbGaR9A4gKSXlL7IVZE/RfC/VGfw7qGPcCGJUtq9CC+jBNbe559pNwfsI6s1
         jZHODCoCYY+pTqKbr69r+oXXajtEuTi5cyKRmkhAWtGeg1H52yUdvp/CLyRVKAOAsi5+
         LVd472ZxTDuyTYNs0hvqOeTv2O3b7OySo5tFjj/xpUEFSsgKCNO3QLDLTawpraCwFOa4
         eKOaHA490v9OBloda9XgGX2pmLtyDYbrFP4/p7Z+xZpWdAsrZ/AOu3f8MMpnVsfbnrM5
         4+ngYIfYzBFi/rNNw9YYrzJD1iPiWkk+apccKInd5WEg3NjgchuC9M3+ngKXpIXGrMeu
         YDnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687775304; x=1690367304;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SlLbl4k7Er5MQ2EA7lMi/0F7IALSlRv5Fiy4Evgi9NE=;
        b=e3Vt9qINzKFuTAB5VqaQyKNQrbc3xtAkvRZwwuPcx7pNWbEblE0/X7naD72Pc4Nhuy
         6FYHWklz1SkCcCuMPAcgQC7XxdCiG/Tr6oFSHACVuGtoiY28uU2KzEVRVmaUYQ17O91U
         SPlYOadi/3jIgnnJFEqQLZZ9zdDhkwdRz7VEqabho4KXNwI6fQnHVuOFuFftJjbtZA2r
         zu4jzMbbc42ATHGgy0V7Ti0BpTM4UnSnAd3xk5MI9OT06L6moZZIJEhRG0P9aVC85l5C
         yZQgXqEkA5UCwBYHfsCG9lo+peGtHZzd26vi86e9lbvJ4gjVKkqw4srpeKZTm2aaqpDm
         0VLA==
X-Gm-Message-State: AC+VfDyXh8T7J04nFwd9/R8vPVFbBki5dx/a8GASfnCph1CXMowncm6K
        16Gt/HCWGAtD903upgtY7aB+1Q==
X-Google-Smtp-Source: ACHHUZ7oJcNjPAQBg785ZTjQJK+Q1euOzsgaxFLR4hb3MnQ9cnOnNLL9QSgex5oep26+zntiSFw3kw==
X-Received: by 2002:a2e:9619:0:b0:2b6:a59c:5e02 with SMTP id v25-20020a2e9619000000b002b6a59c5e02mr765933ljh.20.1687775304450;
        Mon, 26 Jun 2023 03:28:24 -0700 (PDT)
Received: from [192.168.69.115] ([176.187.199.226])
        by smtp.gmail.com with ESMTPSA id i16-20020aa7c710000000b0051a2d4d85fesm2653281edq.75.2023.06.26.03.28.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jun 2023 03:28:23 -0700 (PDT)
Message-ID: <961c855a-81ea-c628-3e67-81877a748027@linaro.org>
Date:   Mon, 26 Jun 2023 12:28:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH] MIPS: KVM: Fix NULL pointer dereference
Content-Language: en-US
To:     Huacai Chen <chenhuacai@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>
Cc:     linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
References: <20230626074919.1871944-1-chenhuacai@loongson.cn>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230626074919.1871944-1-chenhuacai@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/6/23 09:49, Huacai Chen wrote:
> After commit 45c7e8af4a5e3f0bea4ac209 ("MIPS: Remove KVM_TE support") we
> get a NULL pointer dereference when creating a KVM guest:
> 
> [  146.243409] Starting KVM with MIPS VZ extensions
> [  149.849151] CPU 3 Unable to handle kernel paging request at virtual address 0000000000000300, epc == ffffffffc06356ec, ra == ffffffffc063568c
> [  149.849177] Oops[#1]:
> [  149.849182] CPU: 3 PID: 2265 Comm: qemu-system-mip Not tainted 6.4.0-rc3+ #1671
> [  149.849188] Hardware name: THTF CX TL630 Series/THTF-LS3A4000-7A1000-ML4A, BIOS KL4.1F.TF.D.166.201225.R 12/25/2020
> [  149.849192] $ 0   : 0000000000000000 000000007400cce0 0000000000400004 ffffffff8119c740
> [  149.849209] $ 4   : 000000007400cce1 000000007400cce1 0000000000000000 0000000000000000
> [  149.849221] $ 8   : 000000240058bb36 ffffffff81421ac0 0000000000000000 0000000000400dc0
> [  149.849233] $12   : 9800000102a07cc8 ffffffff80e40e38 0000000000000001 0000000000400dc0
> [  149.849245] $16   : 0000000000000000 9800000106cd0000 9800000106cd0000 9800000100cce000
> [  149.849257] $20   : ffffffffc0632b28 ffffffffc05b31b0 9800000100ccca00 0000000000400000
> [  149.849269] $24   : 9800000106cd09ce ffffffff802f69d0
> [  149.849281] $28   : 9800000102a04000 9800000102a07cd0 98000001106a8000 ffffffffc063568c
> [  149.849293] Hi    : 00000335b2111e66
> [  149.849295] Lo    : 6668d90061ae0ae9
> [  149.849298] epc   : ffffffffc06356ec kvm_vz_vcpu_setup+0xc4/0x328 [kvm]
> [  149.849324] ra    : ffffffffc063568c kvm_vz_vcpu_setup+0x64/0x328 [kvm]
> [  149.849336] Status: 7400cce3 KX SX UX KERNEL EXL IE
> [  149.849351] Cause : 1000000c (ExcCode 03)
> [  149.849354] BadVA : 0000000000000300
> [  149.849357] PrId  : 0014c004 (ICT Loongson-3)
> [  149.849360] Modules linked in: kvm nfnetlink_queue nfnetlink_log nfnetlink fuse sha256_generic libsha256 cfg80211 rfkill binfmt_misc vfat fat snd_hda_codec_hdmi input_leds led_class snd_hda_intel snd_intel_dspcfg snd_hda_codec snd_hda_core snd_pcm snd_timer snd serio_raw xhci_pci radeon drm_suballoc_helper drm_display_helper xhci_hcd ip_tables x_tables
> [  149.849432] Process qemu-system-mip (pid: 2265, threadinfo=00000000ae2982d2, task=0000000038e09ad4, tls=000000ffeba16030)
> [  149.849439] Stack : 9800000000000003 9800000100ccca00 9800000100ccc000 ffffffffc062cef4
> [  149.849453]         9800000102a07d18 c89b63a7ab338e00 0000000000000000 ffffffff811a0000
> [  149.849465]         0000000000000000 9800000106cd0000 ffffffff80e59938 98000001106a8920
> [  149.849476]         ffffffff80e57f30 ffffffffc062854c ffffffff811a0000 9800000102bf4240
> [  149.849488]         ffffffffc05b0000 ffffffff80e3a798 000000ff78000000 000000ff78000010
> [  149.849500]         0000000000000255 98000001021f7de0 98000001023f0078 ffffffff81434000
> [  149.849511]         0000000000000000 0000000000000000 9800000102ae0000 980000025e92ae28
> [  149.849523]         0000000000000000 c89b63a7ab338e00 0000000000000001 ffffffff8119dce0
> [  149.849535]         000000ff78000010 ffffffff804f3d3c 9800000102a07eb0 0000000000000255
> [  149.849546]         0000000000000000 ffffffff8049460c 000000ff78000010 0000000000000255
> [  149.849558]         ...
> [  149.849565] Call Trace:
> [  149.849567] [<ffffffffc06356ec>] kvm_vz_vcpu_setup+0xc4/0x328 [kvm]
> [  149.849586] [<ffffffffc062cef4>] kvm_arch_vcpu_create+0x184/0x228 [kvm]
> [  149.849605] [<ffffffffc062854c>] kvm_vm_ioctl+0x64c/0xf28 [kvm]
> [  149.849623] [<ffffffff805209c0>] sys_ioctl+0xc8/0x118
> [  149.849631] [<ffffffff80219eb0>] syscall_common+0x34/0x58
> 
> The root cause is the deletion of kvm_mips_commpage_init() leaves vcpu->
> arch.cop0 NULL. So fix it by make cop0 from a pointer to an embed object.

"by making ... to an embedded object."

> 
> Fixes: 45c7e8af4a5e3f0bea4ac209 ("MIPS: Remove KVM_TE support")
> Cc: stable@vger.kernel.org

Reported-by: Yu Zhao <yuzhao@google.com>

> Suggested-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>   arch/mips/include/asm/kvm_host.h |  6 +++---
>   arch/mips/kvm/emulate.c          | 22 +++++++++++-----------
>   arch/mips/kvm/mips.c             | 16 ++++++++--------
>   arch/mips/kvm/trace.h            |  8 ++++----
>   arch/mips/kvm/vz.c               | 20 ++++++++++----------
>   5 files changed, 36 insertions(+), 36 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

