Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5D949B80E
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 16:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1582744AbiAYPzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 10:55:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1582697AbiAYPxd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 10:53:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643126008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bNm6xJMnoq6zW3mNekeLpnh8KifXaMMeaJAVDRk+IBI=;
        b=ScMmfZClB2HUkfVTdsyhZwEnXPElkniKNx9kRQbinrX66Aq808keCPqRgMmj3fJ4faN9XS
        bEnH0t3aSihfJIpyLwqptCR6RBX5D1V2I+IDRLsTuoR2Pt5kn0w4VMM9sQBhtfMKxkZIl9
        4WUoefVJXa5t6zl0OutUD+WISaIpbew=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-rH-QoxZqNWq7sBwKPVZobA-1; Tue, 25 Jan 2022 10:53:26 -0500
X-MC-Unique: rH-QoxZqNWq7sBwKPVZobA-1
Received: by mail-ej1-f72.google.com with SMTP id q19-20020a1709064c9300b006b39291ff3eso3586256eju.5
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 07:53:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bNm6xJMnoq6zW3mNekeLpnh8KifXaMMeaJAVDRk+IBI=;
        b=d9ZDCFwCgLB3aixDEnk8HywfWFh6G/6fIBrgZ/slpYbkrP0l4wSs8Y83BSRnq1380/
         r/S9IMX07rhhevUEM3yyQKVy8lF/D2N+T3d2yS7bsfsE1cr1tmyXYzB69JDvmlBrSnDx
         VS3OseGtxWHxChnkhlN/Ny39H6s3mBeheHFdjLp7kJ8Q2VlpbiHXWx1wcEfdlOYPpLJm
         1vcaaYYFY2rTs3t02eZnjYkQSyWyjsStlqm2E/TJaMsSnVmfHYJmfXm9LUKMes5kzLyu
         tnQl2KIOpsMLCiesAbLlBmlMKNXKBLVqDTVuWCsaG3+RAzTyMvf78kGcS87jcxfX9N6t
         M9nw==
X-Gm-Message-State: AOAM533ZWLfPMEPpfYmyb9giHhwQE6SbRO2DIhrrIOgxmgqrDYRb7Rll
        qx1AfSry2T9c5VgbZWJQe33QOxMTo5mtx831gahMJbPF1adWkNRSHK8AFZBLy60v0HyOHScIxgm
        CQjhUcAlZZIF2
X-Received: by 2002:a17:907:20ad:: with SMTP id pw13mr16398323ejb.73.1643126005536;
        Tue, 25 Jan 2022 07:53:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz7y8BjckoEZ7cIu9yG4/V2ksHmeMid11visjnsyfjxuoipmJpu/7QfnaghrmqM09p9GLazZA==
X-Received: by 2002:a17:907:20ad:: with SMTP id pw13mr16398296ejb.73.1643126005168;
        Tue, 25 Jan 2022 07:53:25 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id z8sm6351431ejc.151.2022.01.25.07.53.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 07:53:24 -0800 (PST)
Message-ID: <efc05e35-b37f-5d9b-d00e-f4f2edc0441b@redhat.com>
Date:   Tue, 25 Jan 2022 16:53:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 2/5] KVM: SVM: hyper-v: Enable Enlightened MSR-Bitmap
 support for real
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
References: <20211220152139.418372-1-vkuznets@redhat.com>
 <20211220152139.418372-3-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211220152139.418372-3-vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/20/21 16:21, Vitaly Kuznetsov wrote:
> Commit c4327f15dfc7 ("KVM: SVM: hyper-v: Enlightened MSR-Bitmap support")
> introduced enlightened MSR-Bitmap support for KVM-on-Hyper-V but it didn't
> actually enable the support. Similar to enlightened NPT TLB flush and
> direct TLB flush features, the guest (KVM) has to tell L0 (Hyper-V) that
> it's using the feature by setting the appropriate feature fit in VMCB
> control area (sw reserved fields).
> 
> Fixes: c4327f15dfc7 ("KVM: SVM: hyper-v: Enlightened MSR-Bitmap support")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   arch/x86/kvm/svm/svm_onhyperv.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
> index cdbcfc63d171..489ca56212c6 100644
> --- a/arch/x86/kvm/svm/svm_onhyperv.h
> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
> @@ -46,6 +46,9 @@ static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
>   	if (npt_enabled &&
>   	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB)
>   		hve->hv_enlightenments_control.enlightened_npt_tlb = 1;
> +
> +	if (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)
> +		hve->hv_enlightenments_control.msr_bitmap = 1;
>   }
>   
>   static inline void svm_hv_hardware_setup(void)

Queued this one for now.

Paolo

