Return-Path: <kvm+bounces-1094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FF747E4C7F
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 00:10:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 101E11C20D80
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 23:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9693330676;
	Tue,  7 Nov 2023 23:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kr0OE8g5"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8AC30667
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 23:10:05 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6C1199B
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:10:05 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc281f1214so49519115ad.2
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 15:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699398604; x=1700003404; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+MhGzAd189djAcHtpfQuANQf9GCRzOFZiv20M9Q/FQY=;
        b=Kr0OE8g57m6fmvWbd9Fn7l1PjEP/0pwffK6GpFHKYIrKVGAa8fD7Qn/s+4MjrBv2gE
         Cj697TN97TnaNVnCcdHOMuO5y2jPI3Lixh3TVQiBab3xTKy5iQ2nFW6EuPK7cGEId86P
         LxcloMJlqBVGzDSygTLwVhnpSrDO2wAulGcIjSqvPyS+OsephMFJKNaa7FLHOGEX8QVP
         heKeX2K2mNBMCvKoQGVDUU9rlxO1wYm/ZMKUH1ebqGN9uWLPV+MwZ8RvV2R5JexC1emW
         05eOgvW4YH6So7Yjg1SL2M9bHfTS1yHI8JkuILIKpz8NhKDdhTY4GPV8Vf9lUwNaSijl
         Ohag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699398604; x=1700003404;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+MhGzAd189djAcHtpfQuANQf9GCRzOFZiv20M9Q/FQY=;
        b=MVdYeyd4tWUJCDqbmKdcE/Ne1Qf9WqrZWTTDQdvQ/Mhku7+3zJCBRbSuf4bb08q4O+
         ECYuuwrxwWYM7A+5dxKZX1Bujy8SDf6RcLIkdk20GnaEKj41NjQ5tYF/WAi+3t9xxFEV
         UwhXSPmZmcSeBr+4ZKjN6tXy1rakTgmaDvsJaWVRFZnpndwLAmk9aMUaxgpJCTRx2nF/
         XH/g9sGSH4t7FNKCwO0QcqAXwkLKdfaV4IZZQk7Rn3qwvHza11yhsk3Nvgffa0odjiBY
         LWUpLsqD0d+nAygoN8sn1iYggAAFLLKm4Oi2en4+P+RCe+DT+RBo97hdHo1vdfzHiI8R
         pICw==
X-Gm-Message-State: AOJu0YwX5tF8rPU7wXKNkUNiaO00hn9m+gYpoC+UnezyKdQC+yRhM0xa
	3F/aI3/8SZUFIdxr34019HJ9qN6sT6I=
X-Google-Smtp-Source: AGHT+IHXw4ruuMN9510jTMEQylrvlGOQL4x+riapUEeOGqH+xy8A01/RrDz2wfubezgYgQbwN6JnNYGVgd4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:6b02:b0:1cc:3597:9e2f with SMTP id
 o2-20020a1709026b0200b001cc35979e2fmr7836plk.2.1699398604419; Tue, 07 Nov
 2023 15:10:04 -0800 (PST)
Date: Tue, 7 Nov 2023 15:10:02 -0800
In-Reply-To: <2b27196c2b5d10625e10ea73e9f270c7ef0bf5a0.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231010200220.897953-1-john.allen@amd.com> <20231010200220.897953-4-john.allen@amd.com>
 <8484053f-2777-eb55-a30c-64125fbfc3ec@amd.com> <ZS7PubpX4k/LXGNq@johallen-workstation>
 <c65817b0-7fa6-7c0b-6423-5f33062c9665@amd.com> <874ae0019fb33784520270db7d5213af0d42290d.camel@redhat.com>
 <ZUkYPfxHmMZB03iv@google.com> <2b27196c2b5d10625e10ea73e9f270c7ef0bf5a0.camel@redhat.com>
Message-ID: <ZUrDyqXAQZsQzCzl@google.com>
Subject: Re: [PATCH 3/9] KVM: x86: SVM: Pass through shadow stack MSRs
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: nikunj@amd.com, John Allen <john.allen@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, weijiang.yang@intel.com, 
	rick.p.edgecombe@intel.com, x86@kernel.org, thomas.lendacky@amd.com, 
	bp@alien8.de
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 07, 2023, Maxim Levitsky wrote:
> Since no sane L1 hypervisor will ever allow access to all its msrs from L2,
> it might make sense to always use a dedicated MSR bitmap for L2.

Hmm, there might be a full passthrough use case out there, but in general, yeah,
I agree.  I think even kernel hardening use cases where the "hypervisor" is just
a lowvisor would utilize MSR bitmaps to prevent modifying the de-privileged
kernel from modifying select MSRs.

> Also since all sane L1 hypervisors do use a msr bitmap means that
> dedicated code path that doesn't use it is not well tested.
> 
> On VMX if I am not mistaken, this is not an issue because either all
> MSRS are intercepted or a bitmap is used.

Yep, if the MSR bitmaps aren't used then all MSR accesses are intercepted.

