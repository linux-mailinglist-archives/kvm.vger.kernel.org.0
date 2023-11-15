Return-Path: <kvm+bounces-1828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30D957EC392
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 14:27:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CFC401F26ECE
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 13:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA8631A712;
	Wed, 15 Nov 2023 13:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a/oJLhc+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62353DDAA
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 13:27:13 +0000 (UTC)
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A3FA1
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 05:27:12 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6c334d2fcc5so6783962b3a.0
        for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 05:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700054832; x=1700659632; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=67VCtaGV/e+lwlaWVR9CnUK5q5agNeqRm+nDDRKAEZQ=;
        b=a/oJLhc+8u1hy/keGxA5NPp0JULrhJVoRy1ikQCIK6eSYcCg0NLr1oG4tmnt973Wop
         sZ9SxAfwO6j03IV26rt0JeLRUyERcA0/8VVr8ca2Us12xd6rUzCjmHWlljMPbLxJUWgP
         PNmg4cKhkMoSbBD5SOgNutWOcMVDINCUg+Pd/MGoyeXmiV0ISo+xyI7f5KwrILT5nBvG
         eMRZE1SHurgbvnkMrRFco0Q2bgTvg8zxJIZ4o9MUY3aqZXEzDm29mEx3bYj2o6E3PZae
         1zVNauyCXIUHZCWt7TaVijMdwGcw+WrgTFYFEdREmB5SdUdZmvST0/iPO84BAY7d2r+i
         umDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700054832; x=1700659632;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=67VCtaGV/e+lwlaWVR9CnUK5q5agNeqRm+nDDRKAEZQ=;
        b=tH6P3pyj34Z0dQ/WlWxA7MK9LmI3jGGB3/ZQCgwJpuGRpFC/xlk9g341oUN6M9iiLS
         vBTsnZMFzLgz0UxPaiVR4l3fDQwIuD+Yf2Yamj1sa28XiAOvbGXA/DTweWaSMhEEsJkm
         j1wdYEPQ0V75o+hq1jE6LLoO2UWu2zL5LNweOeNXe7H47x7q5ZsgylFY5yAn9am33BL/
         9TBCPmtD6ZUJpCnJdGigiJEad/FPLI+BkySZfi3lHJ4lOc79oVmWpWiEx2+G5QyLuB2Y
         pjJUS+QJFJ7DGVHfyAvsfcZ2XpZFXNLK+htQfJzb3FhL4w/3zwqZgsbCmJS3Rp7qSb6g
         d3Tg==
X-Gm-Message-State: AOJu0YwlTZPT14GHvDmNsyHzVSK2+1X4NR8hlH2+nfNH5QOCstT2nLXs
	VPkjHV4TgihrxV3TzWvfeNOO6snzWEo=
X-Google-Smtp-Source: AGHT+IGQR9cTjt05emGJhEyHPqzcgKgeZVrV7cmq3OqY3waoSr8ME/Sjqg2R+aGyNwoMMrIHA0Zvr8M1Dm0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8b83:b0:6c0:ec5b:bb2d with SMTP id
 ig3-20020a056a008b8300b006c0ec5bbb2dmr3053306pfb.2.1700054831789; Wed, 15 Nov
 2023 05:27:11 -0800 (PST)
Date: Wed, 15 Nov 2023 05:27:10 -0800
In-Reply-To: <d377806e-43af-4ac7-8e7a-291fb19a2091@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-25-weijiang.yang@intel.com> <ZUHSTEGpdWGjL93M@chao-email>
 <d377806e-43af-4ac7-8e7a-291fb19a2091@intel.com>
Message-ID: <ZVTGlLYViK07rE55@google.com>
Subject: Re: [PATCH v6 24/25] KVM: nVMX: Introduce new VMX_BASIC bit for event
 error_code delivery to L1
From: Sean Christopherson <seanjc@google.com>
To: Weijiang Yang <weijiang.yang@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dave.hansen@intel.com, peterz@infradead.org, 
	rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 15, 2023, Weijiang Yang wrote:
> On 11/1/2023 12:21 PM, Chao Gao wrote:
> > On Thu, Sep 14, 2023 at 02:33:24AM -0400, Yang Weijiang wrote:
> > > @@ -2846,12 +2846,16 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
> > > 		    CC(intr_type == INTR_TYPE_OTHER_EVENT && vector != 0))
> > > 			return -EINVAL;
> > > 
> > > -		/* VM-entry interruption-info field: deliver error code */
> > > -		should_have_error_code =
> > > -			intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
> > > -			x86_exception_has_error_code(vector);
> > > -		if (CC(has_error_code != should_have_error_code))
> > > -			return -EINVAL;
> > > +		if (!prot_mode || intr_type != INTR_TYPE_HARD_EXCEPTION ||
> > > +		    !nested_cpu_has_no_hw_errcode_cc(vcpu)) {
> > > +			/* VM-entry interruption-info field: deliver error code */
> > > +			should_have_error_code =
> > > +				intr_type == INTR_TYPE_HARD_EXCEPTION &&
> > > +				prot_mode &&
> > > +				x86_exception_has_error_code(vector);
> > > +			if (CC(has_error_code != should_have_error_code))
> > > +				return -EINVAL;
> > > +		}
> > prot_mode and intr_type are used twice, making the code a little hard to read.
> > 
> > how about:
> > 		/*
> > 		 * Cannot deliver error code in real mode or if the
> > 		 * interruption type is not hardware exception. For other
> > 		 * cases, do the consistency check only if the vCPU doesn't
> > 		 * enumerate VMX_BASIC_NO_HW_ERROR_CODE_CC.
> > 		 */
> > 		if (!prot_mode || intr_type != INTR_TYPE_HARD_EXCEPTION) {
> > 			if (CC(has_error_code))
> > 				return -EINVAL;
> > 		} else if (!nested_cpu_has_no_hw_errcode_cc(vcpu)) {
> > 			if (CC(has_error_code != x86_exception_has_error_code(vector)))
> > 				return -EINVAL;
> > 		}

Or maybe go one step further and put the nested_cpu_has...() check inside the CC()
macro so that it too will be captured on error.  It's a little uglier though, and
I doubt providing that extra information will matter in practice, so definitely
feel free to stick with Chao's version.

		if (!prot_mode || intr_type != INTR_TYPE_HARD_EXCEPTION) {
			if (CC(has_error_code))
				return -EINVAL;
		} else if (CC(!nested_cpu_has_no_hw_errcode_cc(vcpu) &&
			      has_error_code != x86_exception_has_error_code(vector))) {
			return -EINVAL;
		}

