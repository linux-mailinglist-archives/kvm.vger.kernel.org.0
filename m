Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B9C2D1A66
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgLGUSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgLGUSR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 15:18:17 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BF8C061749
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 12:17:36 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id q3so9953797pgr.3
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 12:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VJ0XPkN5limbnOIbfso1HOSFC2zTzU++0WgXCfC7JjA=;
        b=UBtbtJcSWP3Tckif1oaiQ+rSXWtoeYXDG30l2WVS3Hj7XqUiWrOugwurUxlGcRrpCu
         gqI2d3oUkzNENuRsxvq7NNlhXMQmi4e+p5+9fNWM87AvKsEbMDhuDfr8tj3V/SlDO3pT
         YrajN6nap4q8NtkCAjC71FX+WZ6IcD43AVvycmkHuQQN2PaDE7DlOsQvcSmoWk9tPCSj
         pDTttc13BUcQa05AtBxWBTJx4BTobUJVpJY4vF+s46K+CxzEv+M0fhRmG4kHB4XN9nMm
         tWRcG5yBZzPys7zSot5VIs9PYpM3tZTMvCBz2creeW24fHL4jCIKPBLz3cxmsVhO1uyU
         T6SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VJ0XPkN5limbnOIbfso1HOSFC2zTzU++0WgXCfC7JjA=;
        b=iJCQ6L5n4aApyy/WoPLh7ioqVoFpfbNzEs5rCZlC4K1YFGSkWU5KTJxlIDZXQxxBbV
         nfLlQOCPPS8vArQVpBSWhYdz4SXiEMj1pEz0GdoiU8Ql4cvk/lJvuN9+rXNZWlb6nv4i
         Srryq8u65j8ekw+LvxcA3u4MX/uhyDNF7A2MpwMCeiEuA6+a65FEF5pJyR4d2yAc/WXc
         vz35r5KttsqE8RdDgZuPASRLlqBUjI3OtARblA1emIH5IsB0q5KHxiSqBGMoDag7q4QN
         D5Va5ZzWvrTWvOlDcoDUBf8Wn3rQ8EgwtsyI6tqO30rGCiJLImTd12KC/Ixsy1h7xNTI
         IuNg==
X-Gm-Message-State: AOAM530vhz3TTO/+WKEKZB2Zr1f8W9eBr2Lbe8IQbnk5AQQ1ALVNSAMd
        UmIALUvgw+tUNoCAeKTc5pQoZw==
X-Google-Smtp-Source: ABdhPJxy2dchQ3ncv5FqfgUmhRqBObVaicStmi/i6/UZbGXaMsN0epzaMG1PLmJd2fXHR3SmXO/Gfg==
X-Received: by 2002:a17:90b:388:: with SMTP id ga8mr532949pjb.108.1607372256081;
        Mon, 07 Dec 2020 12:17:36 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id z29sm12909085pgk.88.2020.12.07.12.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 12:17:35 -0800 (PST)
Date:   Mon, 7 Dec 2020 12:17:29 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 1/2 v4] KVM: nSVM: Check reserved values for 'Type' and
 invalid vectors in EVENTINJ
Message-ID: <X86N2c7ZG5fAToND@google.com>
References: <20201207194129.7543-1-krish.sadhukhan@oracle.com>
 <20201207194129.7543-2-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207194129.7543-2-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 07, 2020, Krish Sadhukhan wrote:
> According to sections "Canonicalization and Consistency Checks" and "Event
> Injection" in APM vol 2
> 
>     VMRUN exits with VMEXIT_INVALID error code if either:
>       - Reserved values of TYPE have been specified, or
>       - TYPE = 3 (exception) has been specified with a vector that does not
> 	correspond to an exception (this includes vector 2, which is an NMI,
> 	not an exception).
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  arch/x86/include/asm/svm.h |  4 ++++
>  arch/x86/kvm/svm/nested.c  | 14 ++++++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 71d630bb5e08..d676f140cd19 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -341,9 +341,13 @@ struct vmcb {
>  #define SVM_EVTINJ_TYPE_MASK (7 << SVM_EVTINJ_TYPE_SHIFT)
>  
>  #define SVM_EVTINJ_TYPE_INTR (0 << SVM_EVTINJ_TYPE_SHIFT)
> +#define SVM_EVTINJ_TYPE_RESV1 (1 << SVM_EVTINJ_TYPE_SHIFT)
>  #define SVM_EVTINJ_TYPE_NMI (2 << SVM_EVTINJ_TYPE_SHIFT)
>  #define SVM_EVTINJ_TYPE_EXEPT (3 << SVM_EVTINJ_TYPE_SHIFT)
>  #define SVM_EVTINJ_TYPE_SOFT (4 << SVM_EVTINJ_TYPE_SHIFT)
> +#define SVM_EVTINJ_TYPE_RESV5 (5 << SVM_EVTINJ_TYPE_SHIFT)
> +#define SVM_EVTINJ_TYPE_RESV6 (6 << SVM_EVTINJ_TYPE_SHIFT)
> +#define SVM_EVTINJ_TYPE_RESV7 (7 << SVM_EVTINJ_TYPE_SHIFT)
>  
>  #define SVM_EVTINJ_VALID (1 << 31)
>  #define SVM_EVTINJ_VALID_ERR (1 << 11)
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 9e4c226dbf7d..fa51231c1f24 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -212,6 +212,9 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>  
>  static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>  {
> +	u8 type, vector;
> +	bool valid;
> +
>  	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
>  		return false;
>  
> @@ -222,6 +225,17 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>  	    !npt_enabled)
>  		return false;
>  
> +	valid = control->event_inj & SVM_EVTINJ_VALID;
> +	type = control->event_inj & SVM_EVTINJ_TYPE_MASK;

The mask is shifted by 8, which means type is guaranteed to be 0 since the value
will be truncated when casting to a u8.  I'm somewhat surprised neither
checkpatch nor checkpatch warns.  The types are also shifted, so the easiest
thing is probably to store it as a u32, same as event_inj.  I suspect your test
passes because type==0 is INTR and the test always injects #DE, which is likely
an illegal vector.

> +	if (valid && (type == SVM_EVTINJ_TYPE_RESV1 ||
> +	    type >= SVM_EVTINJ_TYPE_RESV5))
> +		return false;
> +
> +	vector = control->event_inj & SVM_EVTINJ_VEC_MASK;
> +	if (valid && (type == SVM_EVTINJ_TYPE_EXEPT))
> +		if (vector == NMI_VECTOR || vector > 31)

Preferred style is to combine these into a single statement.

> +			return false;
> +
>  	return true;
>  }
>  
> -- 
> 2.27.0
> 
