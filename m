Return-Path: <kvm+bounces-456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 527937DFD3F
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 00:22:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7C00B21425
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 23:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6C43224E4;
	Thu,  2 Nov 2023 23:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zCIKELSS"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E97224D2
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 23:22:31 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86BC136
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 16:22:30 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5afe220cadeso20418197b3.3
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 16:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698967350; x=1699572150; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8YRkB8htpyDPTu6BgYSX0PLd58VnN26LAJgP50Ott6I=;
        b=zCIKELSSbx95KtavTspW4KdKDJgIf1MadCCL3+dncSnAH6dDxDEol72AJReT+zBGEN
         zOA/x59duzPx24gsj3uvZjaMPD5WAFlPQvQD5SQ5c7+nNzABmNNW9yQDgiaHQpiMBIgb
         A+r0ixHj4K2elL+vaIRsuNsBOgJPWnBQYdigZBZdVAW2sDg+5oRHNLcv95pDVIliROFH
         xbGg0axSBAYiJOpKSiRVnp4EWUibkskOI2GjkJWw9ZOl7G3Fx82atei0GXDFgzbqGDT6
         fm3CCb0GL1MC7IhRxg1/dHoeUxJ1JXMKRqY6JCe1IvrlrloNxUdEI28EusT+SldLnFsQ
         uMjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698967350; x=1699572150;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8YRkB8htpyDPTu6BgYSX0PLd58VnN26LAJgP50Ott6I=;
        b=FH+pJ0qrORGo0b9AAla6p9Zbwy1+hAQAmwhZkTnk4R/dHvFZDmgbedsFr75dl0UKil
         1iUOWyXfEok3XCkm97/t9rvafNfUIj5eWZuqiidiYSrZDUDPsE6iAChpiDXjMWl5+9iM
         lx1QskwOe4qi2JDpq3bnFmJecPOGlcUehV4jK/VPBjItPuK8unU+hoZcm9TcxS58fk6y
         90C4kfukpdISzRrbz2R/TprA41DW5gJLQVhkZfvXDSgWqxzxlsdu3ahK3YgoknVPnvJh
         UwMG2QpeT7QHfnSmjQGoBHf5vSyHkRqaAJzyTTqawEgNCXJ9YyVQWPvgG1MlVzNOn+QB
         zc3Q==
X-Gm-Message-State: AOJu0YzYrqT0C5B0BCo0t+mAYzUILu5BPclscb2Zq51c3d1DoZJP/8Z/
	BWp2LL4Ju0+UlsV9JQ5OP2/l9seCfd0=
X-Google-Smtp-Source: AGHT+IFpguaXjs1mFtQIBReFFSAFNL6cabRLrkwBDxjS6lYP3wyg0FizgaCLqz3Go16Ls1bDM+ff9pyh/ZM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:830d:0:b0:576:af04:3495 with SMTP id
 t13-20020a81830d000000b00576af043495mr19461ywf.9.1698967349975; Thu, 02 Nov
 2023 16:22:29 -0700 (PDT)
Date: Thu, 2 Nov 2023 16:22:28 -0700
In-Reply-To: <5e413e05de559971cdc2d1a9281a8a271590f62b.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231010200220.897953-1-john.allen@amd.com> <20231010200220.897953-7-john.allen@amd.com>
 <5e413e05de559971cdc2d1a9281a8a271590f62b.camel@redhat.com>
Message-ID: <ZUQvNIE9iU5TqJfw@google.com>
Subject: Re: [PATCH 6/9] KVM: SVM: Add MSR_IA32_XSS to the GHCB for hypervisor kernel
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: John Allen <john.allen@amd.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pbonzini@redhat.com, weijiang.yang@intel.com, rick.p.edgecombe@intel.com, 
	x86@kernel.org, thomas.lendacky@amd.com, bp@alien8.de
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Maxim Levitsky wrote:
> On Tue, 2023-10-10 at 20:02 +0000, John Allen wrote:
> > @@ -3032,6 +3037,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
> >  		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
> >  			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
> >  	}
> > +
> > +	if (kvm_caps.supported_xss)
> > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 1, 1);
> 
> This is not just a virtualization hole. This allows the guest to set MSR_IA32_XSS
> to whatever value it wants, and thus it might allow XSAVES to access some host msrs
> that guest must not be able to access.
> 
> AMD might not yet have such msrs, but on Intel side I do see various components
> like 'HDC State', 'HWP state' and such.

The approach AMD has taken with SEV-ES+ is to have ucode context switch everything
that the guest can access.  So, in theory, if/when AMD adds more XCR0/XSS-based
features, that state will also be context switched.

Don't get me wrong, I hate this with a passion, but it's not *quite* fatally unsafe,
just horrific.

> I understand that this is needed so that #VC handler could read this msr, and
> trying to read it will cause another #VC which is probably not allowed (I
> don't know this detail of SEV-ES)
> 
> I guess #VC handler should instead use a kernel cached value of this msr
> instead, or at least KVM should only allow reads and not writes to it.

Nope, doesn't work.  In addition to automatically context switching state, SEV-ES
also encrypts the guest state, i.e. KVM *can't* correctly virtualize XSS (or XCR0)
for the guest, because KVM *can't* load the guest's desired value into hardware.

The guest can do #VMGEXIT (a.k.a. VMMCALL) all it wants to request a certain XSS
or XCR0, and there's not a damn thing KVM can do to service the request.

