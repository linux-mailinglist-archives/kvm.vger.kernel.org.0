Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34831652213
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbiLTOKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbiLTOKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:10:14 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B9C1B1ED
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:10:12 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso11192092wme.5
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 06:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=5YjevtEnwWRrn/Y14vn4Mu1mr6HH9xHw8E32RhBx4ck=;
        b=miCqYwbt74ualW0C08Gzfhr11vvmnRYSiMVFpLy7UF9el+3jr3SESepND/x4fuLIXh
         bii8PLIdJ66TGkWaWdpBrVHQtmZQjpPZgHPoOuD2PYqhA0iURQ/V/jkWlajV1Th+5EMm
         gBETyIP7Q+CSLuqSHrrVNb5dmfqKTRstVjjzEBBVAIX6huCGVPdtWVlpEBYnN4Qw/j52
         td2VLm05tosNXr3BMHVC6/ZxSclU/CrSuiO90KG77RCWUdACRGfxnq9bdH5Pw/ECkSt2
         xc8FIanf5hnB5oMpC/miKvTwmlxc7ciXo44i6pN6dPqN7yL97OZvaHSoGGQQu4/zWp9I
         19gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5YjevtEnwWRrn/Y14vn4Mu1mr6HH9xHw8E32RhBx4ck=;
        b=2Y05A3heFgqCb5fpAKpoTP5Al7hanz5j3yJClIpSN10hneSIVFIEMfdN7ehbtIkVFF
         fT3oElynT0JEFDmLS91VhBC8eafLgjry3IERk8bORKfeTYeGj4ikBlnQBy/1BF8HxR8F
         0PVyvzZ9wr91KNamtBM2Cc8RawNptHzrIVMCUea7F8vSKVQsxRAMtygsRY4wcnxN3C8j
         S8AgRKwUeqsqbkkmj/WsbnwAbVvSoQ9WVbBNQ47mH0IxcCaEifBzsBnZebOquQBW9v34
         dRfUKCKSu91urLObsPQ+LatnFHaY1rkEozqoB15zBpcHa4q86/BplQPsIHlwnuaQZy3s
         qxIg==
X-Gm-Message-State: AFqh2kqb9qraF1enDnHFSyXUMovAdQRCXg3lrhRgRqx8sJ6Ss9ad+9SM
        vPw/GMSLUGmhY1aNS6ocyDU=
X-Google-Smtp-Source: AMrXdXsCvMrh51ge+U3lDKV1xoucGJnYgeU8vcoDBGLqZuV0hcWhgOM5VUGFoRpYCJnu+OCWoLSIWA==
X-Received: by 2002:a05:600c:4f83:b0:3d3:56ce:5673 with SMTP id n3-20020a05600c4f8300b003d356ce5673mr6625952wmq.6.1671545410796;
        Tue, 20 Dec 2022 06:10:10 -0800 (PST)
Received: from [192.168.6.89] (54-240-197-236.amazon.com. [54.240.197.236])
        by smtp.gmail.com with ESMTPSA id n15-20020a1c720f000000b003cf4ec90938sm15828913wmc.21.2022.12.20.06.10.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 06:10:10 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <94fb9782-816d-e7a1-81f2-b5a3fa563bbd@xen.org>
Date:   Tue, 20 Dec 2022 14:10:09 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] KVM: x86/xen: Fix memory leak in
 kvm_xen_write_hypercall_page()
Content-Language: en-US
To:     Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, seanjc@google.com, pbonzini@redhat.com
References: <20221216005204.4091927-1-mhal@rbox.co>
Organization: Xen Project
In-Reply-To: <20221216005204.4091927-1-mhal@rbox.co>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/12/2022 00:52, Michal Luczaj wrote:
> Release page irrespectively of kvm_vcpu_write_guest() return value.
> 
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---
> # cat /sys/kernel/debug/kmemleak
> unreferenced object 0xffff888131eff000 (size 4096):
>    comm "xen_hcall_leak", pid 949, jiffies 4294753212 (age 11.943s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<00000000e2915da4>] __kmalloc_node_track_caller+0x44/0xa0
>      [<00000000a9f05df2>] memdup_user+0x26/0x90
>      [<000000008e647779>] kvm_xen_write_hypercall_page+0xaa/0x160 [kvm]
>      [<00000000e5da0818>] vmx_set_msr+0x8d3/0x1090 [kvm_intel]
>      [<000000003f0226a5>] __kvm_set_msr+0x6f/0x1a0 [kvm]
>      [<00000000d3dc90c4>] kvm_emulate_wrmsr+0x4b/0x120 [kvm]
>      [<00000000093585d7>] vmx_handle_exit+0x1b6/0x710 [kvm_intel]
>      [<000000006fa8c15e>] vcpu_run+0xfbf/0x16f0 [kvm]
>      [<00000000891f7860>] kvm_arch_vcpu_ioctl_run+0x1d2/0x650 [kvm]
>      [<000000001b8d2d97>] kvm_vcpu_ioctl+0x223/0x6d0 [kvm]
>      [<00000000e7aa7a58>] __x64_sys_ioctl+0x85/0xc0
>      [<00000000c41da0be>] do_syscall_64+0x55/0x80
>      [<000000001635e1c8>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
>   arch/x86/kvm/xen.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index f3098c0e386a..61953248bc0c 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -879,6 +879,8 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
>   						 instructions, sizeof(instructions)))
>   				return 1;
>   		}
> +
> +		return 0;

I'd prefer dropping this hunk...

>   	} else {
>   		/*
>   		 * Note, truncation is a non-issue as 'lm' is guaranteed to be
> @@ -889,6 +891,7 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
>   		u8 blob_size = lm ? kvm->arch.xen_hvm_config.blob_size_64
>   				  : kvm->arch.xen_hvm_config.blob_size_32;
>   		u8 *page;
> +		int ret;
>   
>   		if (page_num >= blob_size)
>   			return 1;
> @@ -899,12 +902,11 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
>   		if (IS_ERR(page))
>   			return PTR_ERR(page);
>   
> -		if (kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE)) {
> -			kfree(page);
> -			return 1;
> -		}
> +		ret = kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE);
> +		kfree(page);
> +
> +		return !!ret;

... making this

if (ret)
     return 1;

>   	}
> -	return 0;

... and then leaving this alone too.

   Paul

>   }
>   
>   int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)

