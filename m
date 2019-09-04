Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58B66A8D62
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732148AbfIDQvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 12:51:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49680 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731599AbfIDQvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 12:51:16 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8BB0D793E5
        for <kvm@vger.kernel.org>; Wed,  4 Sep 2019 16:51:15 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id e14so12181195wrd.23
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 09:51:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9ch2yRu/1UMeEEeXUDrxGR/7MMqaQ7cney0UU8nsuvs=;
        b=iw8ztuBycFIts1Y1XXq4gCZIYJuhys49Z4bBUofyXiHJoOSuUfKCcaJ1nGi869ojn+
         ru/OIAUHgmhVAB0bb/rRFczwGRHf5/InWsH9L51gAb0MIwM1GVRFM1HccYcuOFYArL7d
         vmFfrSfiCp7FTOSHsq/eTZ6sxpnDxk35fc5taVzSH101+WM2W4+sFVJjy8ZMOwsOyrnD
         LAM+ilQ+Pt1D6OUqlLvtsKIR/WR6FDYmrHtWS54RETaIAldlqQ8KvJj/4RWlI3wdJIPf
         AINLsRoAYfoaYLtItfDf46FaT+xyL8eAdbtDDyqWin/IP+8NmcZTgQa2dXgjr75ui6Ja
         66AA==
X-Gm-Message-State: APjAAAWKsX94wqU54kk8OEhyLAxPX8LbYA9G0fHKDGGBkKGff+QNW0r4
        QYqgumOV7TEQmEdPZ2JgQZiLa6sQuBVhvhoZZMKfX7vht4lcKhq8Zz8wkk4Qiq84O7n0yLuIRIV
        WjwWR+bPwYxTH
X-Received: by 2002:adf:ed43:: with SMTP id u3mr36365486wro.37.1567615874243;
        Wed, 04 Sep 2019 09:51:14 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxHBa0idxTjAKNoG3Q3CWPd4Ez6pT4zaSdkd9c2ydR0FVKrUw00zcuvSTi1Mva5IcXPmfKBdw==
X-Received: by 2002:adf:ed43:: with SMTP id u3mr36365468wro.37.1567615874017;
        Wed, 04 Sep 2019 09:51:14 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b136sm4435135wme.18.2019.09.04.09.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 09:51:13 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     Janakarajan.Natarajan@amd.com, jmattson@google.com,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [Patch] KVM: SVM: Fix svm_xsaves_supported
In-Reply-To: <20190904001422.11809-1-aaronlewis@google.com>
References: <20190904001422.11809-1-aaronlewis@google.com>
Date:   Wed, 04 Sep 2019 18:51:12 +0200
Message-ID: <87o900j98f.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Aaron Lewis <aaronlewis@google.com> writes:

> AMD allows guests to execute XSAVES/XRSTORS if supported by the host.  This is different than Intel as they have an additional control bit that determines if XSAVES/XRSTORS can be used by the guest. Intel also has intercept bits that might prevent the guest from intercepting the instruction as well. AMD has none of that, not even an Intercept mechanism.  AMD simply allows XSAVES/XRSTORS to be executed by the guest if also supported by the host.
>

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)

> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/kvm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 1f220a85514f..b681a89f4f7e 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -5985,7 +5985,7 @@ static bool svm_mpx_supported(void)
>  
>  static bool svm_xsaves_supported(void)
>  {
> -	return false;
> +	return boot_cpu_has(X86_FEATURE_XSAVES);
>  }
>  
>  static bool svm_umip_emulated(void)

I had a similar patch in my stash when I tried to debug Hyper-V 2016
not being able to boot on KVM. I may have forgotten some important
details, but if I'm not mistaken XSAVES comes paired with MSR_IA32_XSS
and some OSes may actually try to write there, in particular I've
observed Hyper-V 2016 trying to write '0'. Currently, we only support
MSR_IA32_XSS in vmx code, this will need to be extended to SVM.

Currently, VMX code only supports writing '0' to MSR_IA32_XSS:

	case MSR_IA32_XSS:
		if (!vmx_xsaves_supported() ||
		    (!msr_info->host_initiated &&
		     !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
		       guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
			return 1;
		/*
		 * The only supported bit as of Skylake is bit 8, but
		 * it is not supported on KVM.
		 */
		if (data != 0)
			return 1;


we will probably need the same limitation for SVM, however, I'd vote for
creating separate kvm_x86_ops->set_xss() implementations.

-- 
Vitaly
