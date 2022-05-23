Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D301531847
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiEWTc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 15:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiEWTas (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 15:30:48 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84701C9EF4
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 12:11:55 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id rq11so8724500ejc.4
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 12:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GKuhVwdI2PSDzjfEeGhQuSaCmL7WkJ4Pjq+MMOgKKfw=;
        b=MBRDdCfTjSLJ3I74wuQ57k7FV8aceen8qHC0jzIojlJie0kYyM3Y7PX1NOu8nWxwtn
         6dEHJE0acBSWcu81EB8iIa7li6VxzaQfzCH8A3oW1mUceLbmnyN6rfewHdQaAMNJsbZ4
         Vlh0O1epalpHlRFRDJQIAA6STbiP9/mYI/Pfy4ibZFjISV/9Ulpu/fRiBRWu2NuILx9P
         QWwHqJvmiOR+hIjS0mbZPmyc7ouzo9+Xkn9CSPaJw6EjG6jWkfUjXduCk9W+gSPfooPP
         f0FOf0qu1BpsuFgV3DLGOwy0k2yK6JLO7yEd9g2CotURfh5wDYV9UlI83Ar3GwWRAYg4
         bEkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GKuhVwdI2PSDzjfEeGhQuSaCmL7WkJ4Pjq+MMOgKKfw=;
        b=NGKPWKc05AkUJsrx9jk04Wu9/F7QxEl+y7jSkIKl+VGHjVSN8IR7j+nbyTJ/lMY3tO
         +x+l6XLW2Hi/hSSCnvRhi8kE1+7xMj7HV0bDVXlX+Cr/MpoVFOQleWlUz15yjql7nz/S
         i3WSm3kfs89F7GnnWmYkYdeOILIPz+VMXZ5egW9mTwVyXWwUusYIalyh8vXupH0+/zkW
         extpdnaLac5ZEjoKLrDbZ5RFIVEkS38Mumc2CrjdF+Z7Sdz2RirE895eFG7xHbyfMWzt
         U0cLXumUt9+kUhVKr/UC9p6eNjoUwid8P1LXzGftPuUGOFG+ALy+TwAAEBp57vqowaQK
         tDVg==
X-Gm-Message-State: AOAM532tyu/3Y3TaD4A3HaZwcvG7IPIVv5Ujp98pqWKJyfRq9UJCyJb7
        asbeicRuRk9wo6mu6ODnuoe//zJ/RxB1Fg==
X-Google-Smtp-Source: ABdhPJxE8PGe99VFpv5KQxu/pdLGL0xpUrg5xshj0GR8LZCPCPoXgVrPqXF/flDJskJO/hCkVNw7IQ==
X-Received: by 2002:a17:906:5d06:b0:6fe:94f7:b187 with SMTP id g6-20020a1709065d0600b006fe94f7b187mr21693631ejt.591.1653333113974;
        Mon, 23 May 2022 12:11:53 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id va14-20020a17090711ce00b006fef51aa566sm889781ejb.2.2022.05.23.12.11.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 12:11:53 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <f7d260a6-3616-9901-97b9-7ce0a35357fc@redhat.com>
Date:   Mon, 23 May 2022 21:11:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] KVM: set_msr_mce: Permit guests to ignore single-bit ECC
 errors
Content-Language: en-US
To:     Lev Kujawski <lkujaw@member.fsf.org>, kvm@vger.kernel.org
References: <20220521081511.187388-1-lkujaw@member.fsf.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220521081511.187388-1-lkujaw@member.fsf.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/21/22 10:15, Lev Kujawski wrote:
> Certain guest operating systems (e.g., UNIXWARE) clear bit 0 of
> MC1_CTL to ignore single-bit ECC data errors.  Single-bit ECC data
> errors are always correctable and thus are safe to ignore because they
> are informational in nature rather than signaling a loss of data
> integrity.
> 
> Prior to this patch, these guests would crash upon writing MC1_CTL,
> with resultant error messages like the following:
> 
> error: kvm run failed Operation not permitted
> EAX=fffffffe EBX=fffffffe ECX=00000404 EDX=ffffffff
> ESI=ffffffff EDI=00000001 EBP=fffdaba4 ESP=fffdab20
> EIP=c01333a5 EFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ES =0108 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> CS =0100 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
> SS =0108 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> DS =0108 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> FS =0000 00000000 ffffffff 00c00000
> GS =0000 00000000 ffffffff 00c00000
> LDT=0118 c1026390 00000047 00008200 DPL=0 LDT
> TR =0110 ffff5af0 00000067 00008b00 DPL=0 TSS32-busy
> GDT=     ffff5020 000002cf
> IDT=     ffff52f0 000007ff
> CR0=8001003b CR2=00000000 CR3=0100a000 CR4=00000230
> DR0=00000000 DR1=00000000 DR2=00000000 DR3=00000000
> DR6=ffff0ff0 DR7=00000400
> EFER=0000000000000000
> Code=08 89 01 89 51 04 c3 8b 4c 24 08 8b 01 8b 51 04 8b 4c 24 04 <0f>
> 30 c3 f7 05 a4 6d ff ff 10 00 00 00 74 03 0f 31 c3 33 c0 33 d2 c3 8d
> 74 26 00 0f 31 c3
> 
> Signed-off-by: Lev Kujawski <lkujaw@member.fsf.org>
> ---
>   arch/x86/kvm/x86.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4790f0d7d40b..128dca4e7bb7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3215,10 +3215,13 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			/* only 0 or all 1s can be written to IA32_MCi_CTL
>   			 * some Linux kernels though clear bit 10 in bank 4 to
>   			 * workaround a BIOS/GART TBL issue on AMD K8s, ignore
> -			 * this to avoid an uncatched #GP in the guest
> +			 * this to avoid an uncatched #GP in the guest.
> +			 *
> +			 * UNIXWARE clears bit 0 of MC1_CTL to ignore
> +			 * correctable, single-bit ECC data errors.
>   			 */
>   			if ((offset & 0x3) == 0 &&
> -			    data != 0 && (data | (1 << 10)) != ~(u64)0)
> +			    data != 0 && (data | (1 << 10) | 1) != ~(u64)0)
>   				return -1;
>   
>   			/* MCi_STATUS */

Queued, thanks.

Paolo
