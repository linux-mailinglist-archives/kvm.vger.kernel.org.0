Return-Path: <kvm+bounces-432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A150A7DF996
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 19:10:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD32A1F227F7
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C70C21116;
	Thu,  2 Nov 2023 18:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KqjE7CDQ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389D8208A4
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 18:10:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D801B1BFD
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 11:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698948344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6IPJfYqJMcuWmfDMW5B8K/I4a8oxp1YUbqsh/E0scRE=;
	b=KqjE7CDQi19XTYESY2EYqe4xRGZme6DjZPMTrsn2lhOOKW7U/k0+mmkBFmZ7vJIAzwUkCL
	hC07iUiLm3CeKnf6al3s8fyTszSA/4XOEUOme1ff7gLZOieIEmKSJyhBVMDNnsFMbS0z/Y
	DzlxGze+nTNmhgoDMEzSSpkMYPek0LA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-qWcf7iluPDqs41jPsvaWJQ-1; Thu, 02 Nov 2023 14:05:43 -0400
X-MC-Unique: qWcf7iluPDqs41jPsvaWJQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4092164ee4eso8118545e9.3
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 11:05:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698948342; x=1699553142;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6IPJfYqJMcuWmfDMW5B8K/I4a8oxp1YUbqsh/E0scRE=;
        b=ioqyMLYAI/sSXXIciWXz2xk4+YgAJLsOkLgXzA2A/zxU5s+W17No7d9ygBDvWF+VqW
         NT+CAl7L7TMKjmKyB2/tE1zGIDkSh+9yCL3I4+wkvcN3hL6WmEby0AlAeWk2iOJDTJ1h
         HkyyAmxRRwPIWxe24KHOLz77lrc5tIZUhFEOxv+ey/pJkNk5sAg6q8LW926GqxdCsYW2
         4oRM+Qi+axKocl/HjUVskChN8otMpINmonH/8smrDvOJt12B7i5bIVmRH3YSf5nAXCu3
         5btaeqH+IKNLfj3A+OSAt04Ep9ty5C4C97Ofn1HBvbwkQrg3vdl1yox/yxafH2oqpKDi
         nJdA==
X-Gm-Message-State: AOJu0Ywz+AKYmYrM7eec1WSVB+Wdop44GdnBVJCe27bcygQOWUyX16HX
	kvgWgeuYDwEi/RoP8MYQlPcylsNzV1anCxaOdpqIHixU871ICWoYEodlZ4mMTKk1NzyfDaDV1YW
	uPnSzzJyi7wR+
X-Received: by 2002:a05:600c:358a:b0:408:59d4:f3d8 with SMTP id p10-20020a05600c358a00b0040859d4f3d8mr16794432wmq.18.1698948342121;
        Thu, 02 Nov 2023 11:05:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHAlC49b/Dk9paixZtEXaBZIUjHhjIuxXx22nKYwlZN4YkB8UVGGQfELNbvGYpzXRyfqIZy/A==
X-Received: by 2002:a05:600c:358a:b0:408:59d4:f3d8 with SMTP id p10-20020a05600c358a00b0040859d4f3d8mr16794402wmq.18.1698948341521;
        Thu, 02 Nov 2023 11:05:41 -0700 (PDT)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id v23-20020a05600c215700b004083a105f27sm3602087wml.26.2023.11.02.11.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 11:05:41 -0700 (PDT)
Message-ID: <874ae0019fb33784520270db7d5213af0d42290d.camel@redhat.com>
Subject: Re: [PATCH 3/9] KVM: x86: SVM: Pass through shadow stack MSRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: nikunj@amd.com, John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	weijiang.yang@intel.com, rick.p.edgecombe@intel.com, seanjc@google.com, 
	x86@kernel.org, thomas.lendacky@amd.com, bp@alien8.de
Date: Thu, 02 Nov 2023 20:05:39 +0200
In-Reply-To: <c65817b0-7fa6-7c0b-6423-5f33062c9665@amd.com>
References: <20231010200220.897953-1-john.allen@amd.com>
	 <20231010200220.897953-4-john.allen@amd.com>
	 <8484053f-2777-eb55-a30c-64125fbfc3ec@amd.com>
	 <ZS7PubpX4k/LXGNq@johallen-workstation>
	 <c65817b0-7fa6-7c0b-6423-5f33062c9665@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-10-18 at 16:57 +0530, Nikunj A. Dadhania wrote:
> On 10/17/2023 11:47 PM, John Allen wrote:
> > On Thu, Oct 12, 2023 at 02:31:19PM +0530, Nikunj A. Dadhania wrote:
> > > On 10/11/2023 1:32 AM, John Allen wrote:
> > > > If kvm supports shadow stack, pass through shadow stack MSRs to improve
> > > > guest performance.
> > > > 
> > > > Signed-off-by: John Allen <john.allen@amd.com>
> > > > ---
> > > >  arch/x86/kvm/svm/svm.c | 26 ++++++++++++++++++++++++++
> > > >  arch/x86/kvm/svm/svm.h |  2 +-
> > > >  2 files changed, 27 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > index e435e4fbadda..984e89d7a734 100644
> > > > --- a/arch/x86/kvm/svm/svm.c
> > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > @@ -139,6 +139,13 @@ static const struct svm_direct_access_msrs {
> > > >  	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
> > > >  	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
> > > >  	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
> > > > +	{ .index = MSR_IA32_U_CET,                      .always = false },
> > > > +	{ .index = MSR_IA32_S_CET,                      .always = false },
> > > > +	{ .index = MSR_IA32_INT_SSP_TAB,                .always = false },
> > > > +	{ .index = MSR_IA32_PL0_SSP,                    .always = false },
> > > > +	{ .index = MSR_IA32_PL1_SSP,                    .always = false },
> > > > +	{ .index = MSR_IA32_PL2_SSP,                    .always = false },
> > > > +	{ .index = MSR_IA32_PL3_SSP,                    .always = false },
> > > 
> > > First three MSRs are emulated in the patch 1, any specific reason for skipping MSR_IA32_PL[0-3]_SSP ?
> > 
> > I'm not sure what you mean. 
> 
> MSR_IA32_U_CET, MSR_IA32_S_CET and MSR_IA32_INT_SSP_TAB are selectively emulated and there is no good explanation why MSR_IA32_PL[0-3]_SSP do not need emulation. Moreover, MSR interception is initially set (i.e. always=false) for MSR_IA32_PL[0-3]_SSP.
> 

Let me explain:

Passing through an MSR and having code for reading/writing it in svm_set_msr/svm_get_msr are two different things:

Passing through an MSR means that the guest can read/write the msr freely (that assumes that this can't cause harm to the host),
but either KVM or the hardware usually swaps the guest MSR value with host msr value on vm entry/exit.

Therefore the function of svm_set_msr/svm_get_msr is to obtain the saved guest msr value while the guest is not running for various use cases (for example for migration).

In case of MSR_IA32_U_CET, MSR_IA32_S_CET and MSR_IA32_INT_SSP_TAB the hardware itself loads the guest values from the vmcb on VM entry and saves the modified guest values
to the vmcb on vm exit, thus correct way of reading/writing the guest value is to read/write it from/to the vmcb field.


Now why other CET msrs are not handled by svm_set_msr/svm_get_msr? 
The answer is that those msrs are not saved/restored by SVM microcode, and instead their guest values remain
during the VMexit.

The CET common code which I finally finished reviewing last night, context switches them together with the rest of guest FPU state using xsaves/xrstors instruction,
and if the KVM wants to read these msrs, the common code will first load the guest FPU state and then read/write the msrs using regular rdmsr/wrmsr.


> > The PLx_SSP MSRS should be getting passed
> > through here unless I'm misunderstanding something.
> 
> In that case, intercept should be cleared from the very beginning.
> 
> +	{ .index = MSR_IA32_PL0_SSP,                    .always = true },
> +	{ .index = MSR_IA32_PL1_SSP,                    .always = true },
> +	{ .index = MSR_IA32_PL2_SSP,                    .always = true },
> +	{ .index = MSR_IA32_PL3_SSP,                    .always = true },

.always is only true when a MSR is *always* passed through. CET msrs are only passed through when CET is supported.

Therefore I don't expect that we ever add another msr to this list which has .always = true.

In fact the .always = True for X86_64 arch msrs like MSR_GS_BASE/MSR_FS_BASE and such is not 100% correct too - 
when we start a VM which doesn't have cpuid bit X86_FEATURE_LM, these msrs should not exist and I think that we have a
kvm unit test that fails because of this on 32 bit but I didn't bother yet to fix it.

.always probably needs to be dropped completely.


So IMHO this patch is correct (I might have missed something though):

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

> 
> Regards
> Nikunj
> 
> 



