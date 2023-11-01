Return-Path: <kvm+bounces-337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F04D77DE7F5
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 23:15:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EE43DB20E41
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 22:15:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A88901BDEF;
	Wed,  1 Nov 2023 22:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dWGA/jlP"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904BD11CBB
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 22:15:03 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54AFE120
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 15:15:01 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7cf717bacso5366967b3.1
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 15:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698876900; x=1699481700; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AZUx8eyAtnd4MLrDQkE9b5iSo4ODlmVMuEOqA88XPCE=;
        b=dWGA/jlP9KYXfHOq1B00FLV+q8SPT/y6NA8JG7F33GlEvEXnG+6ziFJIWB3okmKtch
         zC+mfXw0NArJ/jU9+1qmvN0fljuLMMm7huD0CSpsk1B1VLNvh+ZvbJMU3fUvGxPic02L
         Xjl8CwPV719HHh6Nkp4cmg9imx6c2fUimE26px+68GCZXnCP2h5xY7UBZBzoXSEgnaDx
         qrcMrVAeNL+HqtTTMQGmb6oxNUz3euu1HVapnzboheNBb1+zcOl+U6HtZBxAySICEMgt
         Ny1RU0leyW9I1FnY2cq1EVGok7HZWN+6boEraD3kUezeHtjyCrxh7m4UTBW03/aukFgy
         FT9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698876900; x=1699481700;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AZUx8eyAtnd4MLrDQkE9b5iSo4ODlmVMuEOqA88XPCE=;
        b=oc7Z3WdvyMSIhoCpBLZ7J+EmLdj7oNZxuG4oAYIFNwi5o2C9p1KXvL21qpjj3TCxtZ
         jV2b09ia6BvkcPaxYMlC3YXTYATGXUWK+dUoL4S8b4RY9JfVDUy2ttAydzi/Uv4MUxl2
         6hMwt7pWFb3rEEP1kkwFhl8GdAoaEfPLoy4c+Lt3As6BjvBCIGQPZbUEe+NyPMYcI+/o
         CbH53BRdOgFDyWTzbMX4xfpk3WZ+Nqj9M0hkRI+MNJms4szxrwcLZ+4/Ycg/6HUQp+tR
         iY+lSdm8VwVtjBp1YZyq31RyB1FOiutZrYK5NfmmMrYeH0+bMckzLqKN9zzKn4G9CcGP
         VhhQ==
X-Gm-Message-State: AOJu0YyrtMmjVyiQRFF9KH3P6dKxLgbO0I/+G8y4AmbVzNfwJAsIQfDv
	J0555Sy0LjBllV1S4dxyZ+jAPnrOj1M=
X-Google-Smtp-Source: AGHT+IEXfjGw9mEX6v8vrZsfhwz+lK/Ks4rEmpGGTr1iX9SweIr9i1OP2rAJI23eUzGqrvJaXd4EC2JTg1g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8689:0:b0:d9a:3bee:255c with SMTP id
 z9-20020a258689000000b00d9a3bee255cmr316101ybk.7.1698876900547; Wed, 01 Nov
 2023 15:15:00 -0700 (PDT)
Date: Wed, 1 Nov 2023 15:14:58 -0700
In-Reply-To: <c07416ff2919f0aa30d3a810ccdfbed8c387ce0a.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-24-weijiang.yang@intel.com> <c07416ff2919f0aa30d3a810ccdfbed8c387ce0a.camel@redhat.com>
Message-ID: <ZULN4vMwP1t_mKg7@google.com>
Subject: Re: [PATCH v6 23/25] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dave.hansen@intel.com, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> > @@ -685,6 +686,13 @@ void kvm_set_cpu_caps(void)
> >  		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
> >  	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
> >  		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
> > +	/*
> > +	 * The feature bit in boot_cpu_data.x86_capability could have been
> > +	 * cleared due to ibt=off cmdline option, then add it back if CPU
> > +	 * supports IBT.
> > +	 */
> > +	if (cpuid_edx(7) & F(IBT))
> > +		kvm_cpu_cap_set(X86_FEATURE_IBT);
> 
> The usual policy is that when the host doesn't support a feature, then the guest
> should not support it either. On the other hand, for this particular feature,
> it is probably safe to use it. Just a point for a discussion.

Agreed, this needs extra justification.  It's "safe" in theory, but if the admin
disabled IBT because of a ucode bug, then all bets are off.

I'm guessing this was added because of the virtualization hole?  I.e. if KVM
allows CR4.CET=1 for shadow stacks, then KVM can't (easily?) prevent the guest
from also using IBT.

