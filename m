Return-Path: <kvm+bounces-6096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A99A982B235
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 16:55:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D01991C24FF5
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 15:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C2DE4F8AA;
	Thu, 11 Jan 2024 15:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zl7+pKwq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338DF4F898
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 15:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5efb07ddb0fso79882137b3.0
        for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 07:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704988505; x=1705593305; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1SJUm7xO3Evzayv5fC2fSXpyvL1vUufTgbZOsh5liOg=;
        b=Zl7+pKwq2AnSvsPfGc1+z5i3yP+FHpL4gEUCqX1HeoMN/N2RXJjd9FakZeHWIrx02Q
         Kyrf9wN2awuptcH+LPEbfnFLtKi9BSObdNeUUuH5f4tUCRV7k8yhEilGetlQH4Nk5uCQ
         lVpqkEZXLO7qYMOKAgxNcY7ZUhZYv0Me0i94yNQxquxN/J4lznpvZueCuwwiR+9B8n44
         rdEIV3DanXkaNjQx0qW4bioRWruW6ZYotkVjFtD3Zpyh3+qha0JNtEQYH3xYVL9WpaQz
         zdvWLwKbyLVE+2sVqTFHryOUsL2bys/jJZQurJzLLxFbWJchZoN/iTMYBVoZbNPSq+tF
         GX8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704988505; x=1705593305;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1SJUm7xO3Evzayv5fC2fSXpyvL1vUufTgbZOsh5liOg=;
        b=ll4ubmFLJajHPoY2Hpp7uLCjbUrWw2VZkwuC2cXT8atLj/9QfiPuKH8GYwXsq6Ngya
         uOn3I5Hkke45jTmdXwHmHXUWK3ws1Mf1VkRZ/iYpPCnYAEm9UuqS+LMWHpxzsiAH6//V
         YgFYyLO2pc+VdUj17sPHuqq490lYAJUWfLXinvUEj5U1okZAcuw1TBa/ZmPGxJ39ACP6
         mrJmeMZvayCX0T6Vn7QxqdrNFAP9Sn1yTsc/A0hlhq02GyhjFOYs4Le0l7yNmt30hYCl
         wF/4E+nL7STTnMUofeVrxiLUA7Oq0p7ivJ+fvGTsy6E2sT3mhAR5AZFny4y68+pfRWdY
         Bbbw==
X-Gm-Message-State: AOJu0YxH8fxwTN3VpPg6ZDNIeRenYA2CEOX+9nOqlLuDQIVZO9nf6gXb
	Cby7FeGS66rl6Vx00ZqvUs30Y8ECq0cXurlDfg==
X-Google-Smtp-Source: AGHT+IF1xWCjoIQItZuGu9eaJfriQfTcMrLXNiNbqnl8d06y5JDsVMVmQ5EttlPeW+v5bIyKr5TNPgCcIgM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3486:b0:5fb:636b:4b4d with SMTP id
 fo6-20020a05690c348600b005fb636b4b4dmr162765ywb.3.1704988505161; Thu, 11 Jan
 2024 07:55:05 -0800 (PST)
Date: Thu, 11 Jan 2024 07:55:03 -0800
In-Reply-To: <bug-218259-28872-oOlnHKCFQq@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-218259-28872@https.bugzilla.kernel.org/> <bug-218259-28872-oOlnHKCFQq@https.bugzilla.kernel.org/>
Message-ID: <ZaAPV7cNTRVTmn7g@google.com>
Subject: Re: [Bug 218259] High latency in KVM guests
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 18, 2023, bugzilla-daemon@kernel.org wrote:
> > I think the kernel is preemptible:
> 
> Ya, not fully preemptible (voluntary only), but the important part is that KVM
> will drop mmu_lock if there is contention (which is a "requirement" for the bug
> that Yan encountered).

For posterity, the above is wrong.  Volutary preemption isn't _supposed_ to enable
yielding of contended spinlocks/rwlocks, but due to a bug with dynamic preemption,
the behavior got enabled for all preempt models:

https://lore.kernel.org/all/20240110214723.695930-1-seanjc@google.com

