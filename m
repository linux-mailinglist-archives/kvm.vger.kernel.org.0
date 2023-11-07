Return-Path: <kvm+bounces-1042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C884E7E481D
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:20:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D00E1B20E99
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 368FF358B1;
	Tue,  7 Nov 2023 18:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JgjIHqyQ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F095D358A5
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 18:20:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CECFB0
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 10:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699381210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CIrX8yzdRcgaUlR140dceKARZTzBkQcALUFzRiLkSM4=;
	b=JgjIHqyQns4lv9ZF2u9vhjhP7UAx77z6UO2/iEw4IkUAwWPUclX2NWTcQNU0XPLu+IaVvT
	tvu4wd5SRszE3DSNb9/3WDZJ664hqOuVAWNU4BRnHOu/mblR4ehjbeG743wDYWYKO0zjeD
	GvV36BrdUdr61NKtl7H9lFMu1oWMjo4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-wjsBEZ_bOxmEHAtWc1LpQw-1; Tue, 07 Nov 2023 13:20:07 -0500
X-MC-Unique: wjsBEZ_bOxmEHAtWc1LpQw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-32de9f93148so3149031f8f.2
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 10:20:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699381206; x=1699986006;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CIrX8yzdRcgaUlR140dceKARZTzBkQcALUFzRiLkSM4=;
        b=waS9NFNWseBiRX7a2kJ8KdIRI4PILmXiM3WFNwUXq1AdlNPBVMXVbSXNCnM/2UH5No
         dLA43Yy0+F7t0rYPqXYXowgVZC5TIIGcJFci89Xtq7piU49FRfkHVLAod7OnI3IkGoBO
         D/bMYsp+ltHhpBPvSMzOl8Oj5Wz/C0P/4lIKhWMH/gtR80O4RULWGiscSLbYYqDDYNNB
         QQF5Wc1x807Rlc9+CxCsAREohMaKjQXgELdQtmU/gsWUo4QDoNfMM7ExvYP4zMzSw1b8
         VF+bNhcyQBV9WT/MgGjLqEDtXKCpCgIxJnBEHJo0f6DISt3MASVsaYm6tT5sSyGf6OUw
         JnSA==
X-Gm-Message-State: AOJu0Yyi/evkeFBmfVsoa7RlvEsdPcW7DiIoDblAK9KYBEAgo4oKv9XP
	NTFUvgQgIQFETfXzuVBnJZcDHNIvmBznNlqESeEnvEbJ2OtconEWyucDgdkOIYPFG3DKaQlf1OV
	3dABV2RDPRds/VzL29Nfs
X-Received: by 2002:adf:fd8d:0:b0:321:68fa:70aa with SMTP id d13-20020adffd8d000000b0032168fa70aamr28273900wrr.9.1699381206048;
        Tue, 07 Nov 2023 10:20:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGGYfquYiUPbszRtdTWIZp3BhzaSiH9Sx0a3duijCjXrtvUiIEt23V3KyXLGrnPbGbaSlW5NA==
X-Received: by 2002:adf:fd8d:0:b0:321:68fa:70aa with SMTP id d13-20020adffd8d000000b0032168fa70aamr28273880wrr.9.1699381205719;
        Tue, 07 Nov 2023 10:20:05 -0800 (PST)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id o15-20020adfcf0f000000b003296b488961sm2984893wrj.31.2023.11.07.10.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 10:20:05 -0800 (PST)
Message-ID: <2b27196c2b5d10625e10ea73e9f270c7ef0bf5a0.camel@redhat.com>
Subject: Re: [PATCH 3/9] KVM: x86: SVM: Pass through shadow stack MSRs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: nikunj@amd.com, John Allen <john.allen@amd.com>, kvm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, pbonzini@redhat.com, weijiang.yang@intel.com,
  rick.p.edgecombe@intel.com, x86@kernel.org, thomas.lendacky@amd.com,
 bp@alien8.de
Date: Tue, 07 Nov 2023 20:20:03 +0200
In-Reply-To: <ZUkYPfxHmMZB03iv@google.com>
References: <20231010200220.897953-1-john.allen@amd.com>
	 <20231010200220.897953-4-john.allen@amd.com>
	 <8484053f-2777-eb55-a30c-64125fbfc3ec@amd.com>
	 <ZS7PubpX4k/LXGNq@johallen-workstation>
	 <c65817b0-7fa6-7c0b-6423-5f33062c9665@amd.com>
	 <874ae0019fb33784520270db7d5213af0d42290d.camel@redhat.com>
	 <ZUkYPfxHmMZB03iv@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2023-11-06 at 08:45 -0800, Sean Christopherson wrote:
> On Thu, Nov 02, 2023, Maxim Levitsky wrote:
> > On Wed, 2023-10-18 at 16:57 +0530, Nikunj A. Dadhania wrote:
> > > On 10/17/2023 11:47 PM, John Allen wrote:
> > > In that case, intercept should be cleared from the very beginning.
> > > 
> > > +	{ .index = MSR_IA32_PL0_SSP,                    .always = true },
> > > +	{ .index = MSR_IA32_PL1_SSP,                    .always = true },
> > > +	{ .index = MSR_IA32_PL2_SSP,                    .always = true },
> > > +	{ .index = MSR_IA32_PL3_SSP,                    .always = true },
> > 
> > .always is only true when a MSR is *always* passed through. CET msrs are only
> > passed through when CET is supported.
> > 
> > Therefore I don't expect that we ever add another msr to this list which has
> > .always = true.
> > 
> > In fact the .always = True for X86_64 arch msrs like MSR_GS_BASE/MSR_FS_BASE
> > and such is not 100% correct too - when we start a VM which doesn't have
> > cpuid bit X86_FEATURE_LM, these msrs should not exist and I think that we
> > have a kvm unit test that fails because of this on 32 bit but I didn't bother
> > yet to fix it.
> > 
> > .always probably needs to be dropped completely.
> 
> FWIW, I have a half-baked series to clean up SVM's MSR interception code and
> converge the SVM and VMX APIs.  E.g. set_msr_interception_bitmap()'s inverted
> polarity confuses me every time I look at its usage.

100% agree. Any refactoring here is very welcome!

> 
> I can hunt down the branch if someone plans on tackling this code.

One of the things I don't like that much in the SVM msr's bitmap code
is that it uses L1's msr bitmap when the guest's msr interception is disabled,
and the combined msr bitmap otherwise.

This is very fragile and one mistake away from a CVE.

Since no sane L1 hypervisor will ever allow access to all its msrs from L2,
it might make sense to always use a dedicated MSR bitmap for L2.

Also since all sane L1 hypervisors do use a msr bitmap means that
dedicated code path that doesn't use it is not well tested.

On VMX if I am not mistaken, this is not an issue because either all
MSRS are intercepted or a bitmap is used.

> 

Best regards,
	Maxim Levitsky


