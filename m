Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCCA5842C1
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 17:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiG1PPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 11:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiG1PPt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 11:15:49 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B7F42AC0;
        Thu, 28 Jul 2022 08:15:47 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id s9so2578666edd.8;
        Thu, 28 Jul 2022 08:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=f3YBoHwrtP3HFypeBuasmlOKhF1f/UhmYbErWI6N/fc=;
        b=WYTWn1DiXpYspI+NywPkxEe/ysA2nR9YEuRV068M+fak5tujvSlmFE9T5dSKzerkQz
         rhu7x5SE6J0xVi1FqVo0IWVop9EeaMZJOIHdx52Pkm7R3AKI2Q8iu47IDy5ZmTnl9Oaj
         s3Ry5fueSsyEZfrcNurGvvl/KiGSqaIt7FIcifZdvBKihliIb4HtyqUa55K+n007HqAV
         P74SlSfMnhxWlyRTwZYBHO0/JRFJuChu7bMcwneYZ4CwPRVKkU9WT9c6QRdh3sqO3sDF
         +Ohpypizx27sFtCLIY0bdShtnvKYve3fEcZLclpnDasLj9QK/y+Qq3c0g08g1Q0IIwJH
         JCkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=f3YBoHwrtP3HFypeBuasmlOKhF1f/UhmYbErWI6N/fc=;
        b=iqumtjwaDXFC7SfE9OUjV1ltNYhRapkVeGNYFcwnoiSUZi4WKmYCpi9mSb/552KaPx
         QesOuWMdy/QeI0uMK4dOaWssexCQF+A7sadsLeF8/dIzzNk9eu34b+YC385zqc8dSjLg
         eVWcATpPGkP/bY5Rlic/Ht2F305IRbzKujIT2QUEaMGXLwYGVXxTH7s3LKZlN2+EfVjn
         JrhOAm8iYQfk41fPaUmNLbXi0kicG+mkkkGq61t6T2wZAHcncSt8oQu/cV0kUoRIl275
         7SRyQC71fqjwlOwQLJSByfGXTAvh9LPNcAuupw7IXiJGuf/EOqFB1FXF90QVdw/MO+tR
         +rvg==
X-Gm-Message-State: AJIora8BcnUKG2GeRfhLqypWdEb+WoJrYfqbRBGWO/CIrtPCUOsXQ+sD
        8aekaZPooujUCOFQilXTuXQUUXBUCcqImA==
X-Google-Smtp-Source: AGRyM1vVXhUN1KcD3RSxtVt3dCoOXmbB6SS8wdJneDm2ze+tg0M7l5szCpJe5yh481zYBeCz30yfCw==
X-Received: by 2002:a05:6402:51ce:b0:43c:4326:26d3 with SMTP id r14-20020a05640251ce00b0043c432626d3mr14301428edd.411.1659021345521;
        Thu, 28 Jul 2022 08:15:45 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id w1-20020aa7da41000000b0043a4de1d421sm830746eds.84.2022.07.28.08.15.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 08:15:44 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <a9da5c1e-eca9-b3e7-3224-c9d5a26287fb@redhat.com>
Date:   Thu, 28 Jul 2022 17:15:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] KVM: SVM: Dump Virtual Machine Save Area (VMSA) to klog
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@profian.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Harald Hoyer <harald@profian.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
References: <20220728050919.24113-1-jarkko@profian.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220728050919.24113-1-jarkko@profian.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/28/22 07:09, Jarkko Sakkinen wrote:
> As Virtual Machine Save Area (VMSA) is essential in troubleshooting
> attestation, dump it to the klog with the KERN_DEBUG level of priority.
> 
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Suggested-by: Harald Hoyer <harald@profian.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
> ---
>   arch/x86/kvm/svm/sev.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0c240ed04f96..6d44aaba321a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -603,6 +603,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>   	save->xss  = svm->vcpu.arch.ia32_xss;
>   	save->dr6  = svm->vcpu.arch.dr6;
>   
> +	pr_debug("Virtual Machine Save Area (VMSA):\n");
> +	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
> +
>   	return 0;
>   }
>   

Queued, thanks.

Paolo
