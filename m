Return-Path: <kvm+bounces-116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6876D7DBF17
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 18:36:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00089B20E56
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 17:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B70C4199B5;
	Mon, 30 Oct 2023 17:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IJ+HG5gm"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC2B1945E
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 17:36:39 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4EC93
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 10:36:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da03ef6fc30so4400847276.0
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 10:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698687398; x=1699292198; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8vz5wnkmcum9q1qyUnxUAw0SL2P8FyU7ENITNbJXLW0=;
        b=IJ+HG5gmjGGXOT93f4QQPYaODHQbGWsLrxBlu9v1CiL/tQZc49J7kkSCcpVbTJYjAl
         frOe/7O1B1ApWk6iP402yUruSSXgE/82RqaAv/5FV35aAPliA6eeGS+HJ2vkI2WEGCtn
         dijCEVQt3sBDAZxiBpGVdGEpxJaTm6FOeboGz1oRPOKH5mHhWzQyYUg2HHkIQGVhS79v
         lxhf7U8dEJl7pa4xVL77Zre8jZoPCsoRieZkSEdMDZzxCSda/AG/966WYAuNpvlxpA9e
         aPHM4Vc1rY0dI03YZ+PMBICToB+YJXrPao3gOGSW6wjtN4Xf2dM7gU3jKE+mMzRoFTmR
         5Q7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698687398; x=1699292198;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8vz5wnkmcum9q1qyUnxUAw0SL2P8FyU7ENITNbJXLW0=;
        b=AC/XdZXhuXfrWiFrJYNOjt7YWnRBCQEsi/RAJ0juBakHQMJUU+YxySgBCXJBu2cfe9
         x75RbkDOi50LpyL4Yn8qHBFhWBLJbLuBzt1NZfmc2lHsm+OetkdlXuPja+BJMVVUqHzr
         L0jdONW/1M0XNu5+yl2C9QR+MLdqauucbLFI8rBDqfwAYdOkGWexUYeNyocA3GAOlNkJ
         CqObschpQ0mwZzd6r9mHSOnRnw2auNnhJ13CrUlt/Q2NgjKzpPG3EOvfqdsmK57KPK4t
         exHZfN1fLA6xW15giuFzFXOViIgZMe1dVZRhZOj8ycFi9R/GUBowYMwuuDyxMCpI9Haj
         CKrw==
X-Gm-Message-State: AOJu0YzTc/ky82n4kv1lt5WI04QCnwEKuixSZwNGmLfqGkRw5fS9NSP2
	elNJCeD13z39xoIShB9/f9qfcO2MKbM=
X-Google-Smtp-Source: AGHT+IEEffbEmQjd4o2X7fGwPqKpFD/uxoIxAWj4vvpPaQwpwy726tAOw84DngpKljDqNb2fsvt5pi0rExE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:a93:b0:d9a:e6ae:ddb7 with SMTP id
 cd19-20020a0569020a9300b00d9ae6aeddb7mr186866ybb.7.1698687398064; Mon, 30 Oct
 2023 10:36:38 -0700 (PDT)
Date: Mon, 30 Oct 2023 10:36:36 -0700
In-Reply-To: <146168ae-900d-4eee-9a47-a1ba2ea57aa6@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231030141728.1406118-1-nik.borisov@suse.com>
 <ZT_UtjWSKCwgBxb_@google.com> <146168ae-900d-4eee-9a47-a1ba2ea57aa6@redhat.com>
Message-ID: <ZT_ppBmxdd6917cl@google.com>
Subject: Re: [PATCH] KVM: x86: User mutex guards to eliminate __kvm_x86_vendor_init()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 30, 2023, Paolo Bonzini wrote:
> On 10/30/23 17:07, Sean Christopherson wrote:
> > On Mon, Oct 30, 2023, Nikolay Borisov wrote:
> > > Current separation between (__){0,1}kvm_x86_vendor_init() is superfluos as
> > 
> > superfluous
> > 
> > But this intro is actively misleading.  The double-underscore variant most definitely
> > isn't superfluous, e.g. it eliminates the need for gotos reduces the probability
> > of incorrect error codes, bugs in the error handling, etc.  It _becomes_ superflous
> > after switching to guard(mutex).
> > 
> > IMO, this is one of the instances where the then solution problem appoach is
> > counter-productive.  If there are no objections, I'll massage the change log to
> > the below when applying (for 6.8, in a few weeks).
> 
> I think this is a "Speak Now or Forever Rest in Peace" situation.  I'm going
> to wait a couple days more for reviews to come in, post a v14 myself, and
> apply the series to kvm/next as soon as Linus merges the 6.7 changes.  The
> series will be based on the 6.7 tags/for-linus, and when 6.7-rc1 comes up,
> I'll do this to straighten the history:

Heh, I'm pretty sure you meant to respond to the guest_memfd series.

> 	git checkout kvm/next
> 	git tag -s -f kvm-gmem HEAD
> 	git reset --hard v6.7-rc1
> 	git merge tags/kvm-gmem
> 	# fix conflict with Christian Brauner's VFS series
> 	git commit
> 	git push kvm
> 
> 6.8 is not going to be out for four months, and I'm pretty sure that
> anything discovered within "a few weeks" can be applied on top, and the
> heaviness of a 35-patch series will outweigh any imperfections by a long
> margin).
> 
> (Full disclosure: this is _also_ because I want to apply this series to the
> RHEL kernel, and Red Hat has a high level of disdain for non-upstream
> patches.  But it's mostly because I want all dependencies to be able to move
> on and be developed on top of stock kvm/next).

