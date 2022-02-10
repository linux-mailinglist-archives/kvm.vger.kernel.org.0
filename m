Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764874B12EC
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 17:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244310AbiBJQgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 11:36:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244285AbiBJQgw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 11:36:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75892137
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H+SJ/8jiWh1yqA7v50jSrldDjAEMOLgFk+1GemkI9co=;
        b=OjKQjdvqI66HIhFDk+UAt1Ynn64KThZp7Ni3mzqrJz7J18HxnNw45kSFYey1i2Ah+ZrQnn
        h1FVFcobbqqV/eu9SDF3LihzchklrUTuhB3Zrm/G5k0AGUGJ2mKKLwqJ+3pnBXzkcEoPog
        TBTJEwe1VX79vdnz0l2UQRdgfWEFdr8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-B_Avj9H_OrG1GBkytmBSNg-1; Thu, 10 Feb 2022 11:36:51 -0500
X-MC-Unique: B_Avj9H_OrG1GBkytmBSNg-1
Received: by mail-ej1-f72.google.com with SMTP id qo24-20020a170907213800b006c7479720ddso3006612ejb.2
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:36:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H+SJ/8jiWh1yqA7v50jSrldDjAEMOLgFk+1GemkI9co=;
        b=aYWf40lEtV8k5igiTLURfHAPjd3I796gSEe8scdOeMLzaIHNV2Bl/Q6gHIItuxmXLc
         qMabNSbPmZU/8LhcBiFTIa4DNed0PnCfgKFqy3kkcQZABFqqCV1Pf3j+VbVVLYI96YFZ
         CQI488t0m9gbjv71ZVQ6CDQGR9Vnp3LfUoBaCRnaFEpMijs7LKGFVO2iHTpNf0j0LeiM
         LB3nbrF01WnlIlJzarIKbQ/Rl9oxfGQQGaHrk2Tho7vXkM6Wse87wgppNkbUdXq++UI7
         4ikuNFdH1ndhntYsiaWuK9d6Ye6zHTlPcA7BxDsF22UKYsAasAWBO51GUolFNT5fS1Vd
         70tw==
X-Gm-Message-State: AOAM532jUKhr7zOEap+ysx2lzaVeu8neKpg4SCAae0TaGVd/P0iKGQb1
        68YGK0CSxKpXa53cD6cAMNpIam9Q8ZzBDOSJ1/MYpuJHDpayapnagu1Cwi258wQR5PKkq1yJrj8
        0ZenQ27FSSD1N
X-Received: by 2002:a17:907:7e92:: with SMTP id qb18mr7386259ejc.555.1644511010333;
        Thu, 10 Feb 2022 08:36:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxj9sY5pMOYIOBuRdGDDcyfQz6bxkiuJax77x8qRDfWDnHYKBW8dd3yXbZ6EKAQ5L3qvK4moA==
X-Received: by 2002:a17:907:7e92:: with SMTP id qb18mr7386243ejc.555.1644511010094;
        Thu, 10 Feb 2022 08:36:50 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.240])
        by smtp.googlemail.com with ESMTPSA id cz12sm4919441edb.30.2022.02.10.08.36.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:36:49 -0800 (PST)
Message-ID: <7d142721-bdbc-1d82-64b5-9df4368f1c67@redhat.com>
Date:   Thu, 10 Feb 2022 17:33:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.16 6/8] KVM: SVM: Explicitly require
 DECODEASSISTS to enable SEV support
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Liam Merwick <liam.merwick@oracle.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185635.48730-1-sashal@kernel.org>
 <20220209185635.48730-6-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185635.48730-6-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/22 19:56, Sasha Levin wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> [ Upstream commit c532f2903b69b775d27016511fbe29a14a098f95 ]
> 
> Add a sanity check on DECODEASSIST being support if SEV is supported, as
> KVM cannot read guest private memory and thus relies on the CPU to
> provide the instruction byte stream on #NPF for emulation.  The intent of
> the check is to document the dependency, it should never fail in practice
> as producing hardware that supports SEV but not DECODEASSISTS would be
> non-sensical.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
> Message-Id: <20220120010719.711476-5-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/svm/sev.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index be28831412209..932afd713a02c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2099,8 +2099,13 @@ void __init sev_hardware_setup(void)
>   	if (!sev_enabled || !npt_enabled)
>   		goto out;
>   
> -	/* Does the CPU support SEV? */
> -	if (!boot_cpu_has(X86_FEATURE_SEV))
> +	/*
> +	 * SEV must obviously be supported in hardware.  Sanity check that the
> +	 * CPU supports decode assists, which is mandatory for SEV guests to
> +	 * support instruction emulation.
> +	 */
> +	if (!boot_cpu_has(X86_FEATURE_SEV) ||
> +	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_DECODEASSISTS)))
>   		goto out;
>   
>   	/* Retrieve SEV CPUID information */

NACK

