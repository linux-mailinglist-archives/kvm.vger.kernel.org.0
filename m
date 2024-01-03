Return-Path: <kvm+bounces-5598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EE7982374D
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 22:54:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 465DE1C248A5
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 21:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E61E41DA32;
	Wed,  3 Jan 2024 21:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ze1yS6OV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE371DA26
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 21:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5ee22efe5eeso74083737b3.3
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 13:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704318858; x=1704923658; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6n/47+Omzg5WW5UuXFIT8z2kd1nVf1+Oyec4DhB9CBk=;
        b=ze1yS6OVsxYmBJDO2kfTot9d8dp4/iF6NtpejlQDx3ljvsg+xRIkOVIfVihVBn+4da
         nqPgY8zKa89xLlRUEVSZE9a5003Rl4dC9G3aHjnqloIn43831eCsHtUdO0AJW/9yDSEo
         YnyuBOcLF80JqM7V2Ri61QGKBKm4zY3/SZKdpPhUgqvmKYvuwLvTr2/h93Y5aToBOYgS
         53A1ZZGHAgaGn+i7tsMiZ5OV1/0BgnThDcRUocUOx2JF8nlRgzOfcxA13AynsqlY8Gdp
         BxR65sVG2bQaYtD/5UUp3OLPFcocO7S3ycpt/xmyYQIEuhZyax/TkPabVnNWAUyg9iN2
         p0OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704318858; x=1704923658;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6n/47+Omzg5WW5UuXFIT8z2kd1nVf1+Oyec4DhB9CBk=;
        b=A09wflxyXft/YYRWaUoei4+CZZM4r8GYF4yWX3dAtdfG9yztW3FUxPTYY7ssBHRjIM
         oTtNbN+ER8ErqZqYHkp8hapQDkrE7PvOe7R6XE2oDqj70BFZZ8MYsDNPRwehY9pGR5IS
         Oq2E2hVsXl/tKLNAOKbv9u6oC4smM7Pw90N83Z/d/d+3PS8LDHfcjoo9S8G6gr/0h4hu
         YU7Zc9ndm2hNUlJlPf/jkwKnN2V8PytuQpsrb9FDtOdilE9H/FH6h5y0S9089TUVzX0X
         WLng1Pcpnd6p24yPWU3id9ash/7yx6leo3Zeud84BdlJdE70b8zzAt6F3WfVTkTiMMj7
         lBcA==
X-Gm-Message-State: AOJu0YwjkC1DJ8MXdyeFGAJ1+M28m1MlN5FBdyxUEBBkS5A88zr/hPrS
	zpsZY7YIVQ5CEFhFbJEo6T8/W7eFVpUAC/PLWQ==
X-Google-Smtp-Source: AGHT+IEidGpXt5gaj/ABpGUG3ooyKuvz0WPbn+5pxN5I1gVInlRuzP1wBPKXhizuNht3BpgAbUleFKmCO+M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:aa49:0:b0:5f2:bc90:f1ed with SMTP id
 z9-20020a81aa49000000b005f2bc90f1edmr1581934ywk.4.1704318857883; Wed, 03 Jan
 2024 13:54:17 -0800 (PST)
Date: Wed, 3 Jan 2024 13:54:16 -0800
In-Reply-To: <864b9717-46d2-4c1d-a84c-0784caf952f3@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240102232136.38778-1-Ashish.Kalra@amd.com> <ZZSqkm5WNEUuuA_h@google.com>
 <b82bb32b-3348-4c18-b07e-34f523ae93b5@amd.com> <ZZXNXNZkCW8e1G5i@google.com> <864b9717-46d2-4c1d-a84c-0784caf952f3@amd.com>
Message-ID: <ZZXXiFEEr7m2JitG@google.com>
Subject: Re: [PATCH] x86/sev: Add support for allowing zero SEV ASIDs.
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	thomas.lendacky@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	joro@8bytes.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 03, 2024, Ashish Kalra wrote:
> On 1/3/2024 3:10 PM, Sean Christopherson wrote:
> > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > index d0c580607f00..bfac6d17462a 100644
> > > > --- a/arch/x86/kvm/svm/sev.c
> > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > @@ -143,8 +143,20 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
> > > >    static int sev_asid_new(struct kvm_sev_info *sev)
> > > >    {
> > > > -       int asid, min_asid, max_asid, ret;
> > > > +       /*
> > > > +        * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
> > > > +        * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.  Note, the
> > > > +        * min ASID can end up larger than the max if basic SEV support is
> > > > +        * effectively disabled by disallowing use of ASIDs for SEV guests.
> > > > +        */
> > > > +       unsigned int min_asid = sev->es_active ? 1 : min_sev_asid;
> > > > +       unsigned int max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
> > > > +       unsigned int asid;
> > > >           bool retry = true;
> > > > +       int ret;
> > > > +
> > > > +       if (min_asid > max_asid)
> > > > +               return -ENOTTY;
> > > This will still return -EBUSY to user.
> > Huh?  The above is obviously -ENOTTY, and I don't see anything in the call stack
> > that will convert it to -EBUSY.
> 
> Actually, sev_asid_new() returning failure to sev_guest_init() will cause it
> to return -EBUSY to user.

Argh, I see it now.  That too should be fixed, e.g.

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d0c580607f00..79eb11083ad5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -246,21 +246,20 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
        struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-       int asid, ret;
+       int ret;
 
        if (kvm->created_vcpus)
                return -EINVAL;
 
-       ret = -EBUSY;
        if (unlikely(sev->active))
-               return ret;
+               return -EINVAL;
 
        sev->active = true;
        sev->es_active = argp->id == KVM_SEV_ES_INIT;
-       asid = sev_asid_new(sev);
-       if (asid < 0)
+       ret = sev_asid_new(sev);
+       if (ret < 0)
                goto e_no_asid;
-       sev->asid = asid;
+       sev->asid = ret;
 
        ret = sev_platform_init(&argp->error);
        if (ret)


