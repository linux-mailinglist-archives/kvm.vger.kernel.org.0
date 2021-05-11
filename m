Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A1737ABFB
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 18:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhEKQdj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 12:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbhEKQdh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 12:33:37 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DB3C06174A
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 09:32:30 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id a11so11085942plh.3
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 09:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q2ni1lpo6eZfrOeYDNiY72rk6fdjiV9wOq6yilL34q4=;
        b=IvWQ4WNvCaECQTkaF4wkPEbTSo0tu88cWJtmd0Hlv/D4yW6IT+Lo0PzaUOodz7kZKT
         cUomfi+tBd4T/2ngipNLY5NFjrWsgLMX1WYwNTIdc/CdBW8xEcNbTpO3U+jUPaVsoqh9
         7Dh9U8MnndWsgOmC7REHTr/ka+YZGVKDDi0IO/yK6nPwe0UVweu2x711DcosRVSxFy7P
         ulS5i9J0iGkP3HkXq66hBUb5TKa2xCySrLURhsZa0UHHfVczOa+u+HaQunJHvAlUADWY
         4rxTf81SzDMw8XVxp4mC6zkNOZTWrPwN2kwm5H+yWJAizncjaW7nCWlyEVInkEOri4T6
         sc9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q2ni1lpo6eZfrOeYDNiY72rk6fdjiV9wOq6yilL34q4=;
        b=H83C3y3ot4qD0K/Xs6ilibltcHs/O3KQIdS6SkQ1RbsgOJYbQLe8w8ZD/AtrHJ1JLI
         tpRELCgH4rdghIsjnxssZSGUDdrskaRaITXQaZSKts1LsbUpmah85CACX6pAdT+Jp9z5
         X9CYt0igp1Yo0oylyBuib1i7Bo7Tm5viAgjzstPOvWf17JUBPF1lHBYBkm+PfNtOD2IG
         4d2j9ORIHXMfpofhCw/ntoVued0qsosWvhZUhXrlYf4lJErew7miAMiR3Xd8I1/kyCrb
         VvbE9SRAXJu0k0uZbpacJn+sr9syQdMVVmv/yOKTtrIdIXuqP2dPVnmGjai8hRS6GC03
         +Zzw==
X-Gm-Message-State: AOAM530mKhV10V97HYUvkh3sxLMRR+j6FWxgxZgkwXedWFm2lYW6GGob
        VFmfBxKGrpg5mfsL/OqdMEGNwg==
X-Google-Smtp-Source: ABdhPJzhNyKOBCyrzqZdEAhYC9RjWUp8GZ5bqaQORU6m+Ipjr+WNn+sTxahOJpc3om3dVaX3U9B5NA==
X-Received: by 2002:a17:90a:730c:: with SMTP id m12mr5963052pjk.111.1620750749299;
        Tue, 11 May 2021 09:32:29 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id n27sm14385126pfv.142.2021.05.11.09.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 09:32:28 -0700 (PDT)
Date:   Tue, 11 May 2021 16:32:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 5/7] KVM: nVMX: Reset eVMCS clean fields data from
 prepare_vmcs02()
Message-ID: <YJqxmJg0HajlfDa/@google.com>
References: <20210511111956.1555830-1-vkuznets@redhat.com>
 <20210511111956.1555830-6-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511111956.1555830-6-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021, Vitaly Kuznetsov wrote:
> When nested state migration happens during L1's execution, it
> is incorrect to modify eVMCS as it is L1 who 'owns' it at the moment.
> At lease genuine Hyper-v seems to not be very happy when 'clean fields'
> data changes underneath it.
> 
> 'Clean fields' data is used in KVM twice: by copy_enlightened_to_vmcs12()
> and prepare_vmcs02_rare() so we can reset it from prepare_vmcs02() instead.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 3257a2291693..1661e2e19560 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2090,9 +2090,6 @@ void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
>  
>  	if (vmx->nested.hv_evmcs) {
>  		copy_vmcs12_to_enlightened(vmx);
> -		/* All fields are clean */
> -		vmx->nested.hv_evmcs->hv_clean_fields |=
> -			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
>  	} else {
>  		copy_vmcs12_to_shadow(vmx);
>  	}

Looks like this makes both paths single lines, i.e. the curly braces can be
dropped.

> @@ -2636,6 +2633,12 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  
>  	kvm_rsp_write(vcpu, vmcs12->guest_rsp);
>  	kvm_rip_write(vcpu, vmcs12->guest_rip);
> +
> +	/* Mark all fields as clean so L1 hypervisor can set what's dirty */
> +	if (hv_evmcs)
> +		vmx->nested.hv_evmcs->hv_clean_fields |=
> +			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
> +
>  	return 0;
>  }
>  
> -- 
> 2.30.2
> 
