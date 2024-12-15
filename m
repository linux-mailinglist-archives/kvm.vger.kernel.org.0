Return-Path: <kvm+bounces-33829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A510B9F256E
	for <lists+kvm@lfdr.de>; Sun, 15 Dec 2024 19:51:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C955C16477F
	for <lists+kvm@lfdr.de>; Sun, 15 Dec 2024 18:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A79141B87CF;
	Sun, 15 Dec 2024 18:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ranguvar.io header.i=@ranguvar.io header.b="cqbhMGbZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-4323.proton.ch (mail-4323.proton.ch [185.70.43.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59E426AD0;
	Sun, 15 Dec 2024 18:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734288664; cv=none; b=pLJ1Wh046cS4CyuRDjMS/edeN2d/uYJ1OA0HQOidMuN0befOyT2ukEyRAkrsuGnB2yxOcKys4ZTufjeNbyfRxVp5oTChefa1NTAkv5Z6LyGtIDx7BICufZBh9vt1zMX0ABQClbcMvGfwdYDQJ0oHrz15G44wlbu43yaxO7MVr1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734288664; c=relaxed/simple;
	bh=7/Dgqqcjbm6yKbTp8//eYY4ngx6e+/q0fiDNY3v30QU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JKNSQjcfjB6uNBa0Dz6fP/bjPCQzOZXP9Xbm9QODhoNW/ecklyl4k21ESQd/bcXx0bnMBhPQnsoAvnPNl8GkSqmwwVMAVyZ95IKDBtmpUh8our8J5olVS8qVcJHYtT55o4mYC5FkPEiKomb5LfzdLyWTh4XaOmtMa8ifRU2rRiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ranguvar.io; spf=pass smtp.mailfrom=ranguvar.io; dkim=pass (2048-bit key) header.d=ranguvar.io header.i=@ranguvar.io header.b=cqbhMGbZ; arc=none smtp.client-ip=185.70.43.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ranguvar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ranguvar.io
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ranguvar.io;
	s=protonmail3; t=1734288652; x=1734547852;
	bh=7/Dgqqcjbm6yKbTp8//eYY4ngx6e+/q0fiDNY3v30QU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=cqbhMGbZK+KNUUMxX3obwFI4a7pmi9gXJCtW0YSJ/UKs2bNK4nl7o1aks9XMu6ikd
	 GZ/r7DDRm88TWqYtS7QIMxADynHoIFrcR+YbGIybVIwaZfjgIniJE6AG5wbyTl06vR
	 XfNIqeJ6xlbGd6beOKg+fL/usWTYc762oxZKGaFgEWG2xifqijB2bWrdqdAGBvxZ2p
	 JercwAhGAqOtQ3w+Q1PIdY1DHMxU+NVlPfGHadXUbCHMRQ6qom9YFr9+CkdLAIRa4w
	 1z4pZIwW490aFIPEpT+ssWnjnRD2s2iKD4RBBnLAdNC7i/SlypB+kl+OlkSYpVUcmN
	 L6m7G7GwV+aWw==
Date: Sun, 15 Dec 2024 18:50:47 +0000
To: Peter Zijlstra <peterz@infradead.org>
From: Ranguvar <ranguvar@ranguvar.io>
Cc: "regressions@lists.linux.dev" <regressions@lists.linux.dev>, "regressions@leemhuis.info" <regressions@leemhuis.info>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [REGRESSION][BISECTED] from bd9bbc96e835: cannot boot Win11 KVM guest
Message-ID: <fShmVVohdysEOcF0kM7iw3wVZhoCx4aNsqS3JlreZjMMMjGAilrVaBtF_hooXSDKL5-GrlNZPXLB7sD6hHflU8T4Rn4Gdncs_OfgapXLQPQ=@ranguvar.io>
In-Reply-To: <20241214183924.GC10560@noisy.programming.kicks-ass.net>
References: <nscDY8Zl-c9zxKZ0qGQX8eqpyHf-84yh3mPJWUUWkaNsx5A06rvv6tBOQSXXFjZzXeQl_ZVUbgGvK9yjH6avpoOwmZZkm3FSILtaz2AHgLk=@ranguvar.io> <20241214183924.GC10560@noisy.programming.kicks-ass.net>
Feedback-ID: 7618196:user:proton
X-Pm-Message-ID: 92e6293f4752c10039e1de9cdcf0a1e3c52683f1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Saturday, December 14th, 2024 at 18:39, Peter Zijlstra <peterz@infradead=
.org> wrote:
> Do the patches here:
>=20
> https://lkml.kernel.org/r/20241213032244.877029-1-vineeth@bitbyteword.org
>=20
> help?

I was able to apply both patches to Arch's 6.12.4 along with the svm.c regr=
ession patch.
Unfortunately it's the same broken behavior and kernel messages as bd9bbc96=
e835.
=20
> I'm not really skilled with the whole virt thing, and I definitely do
> not have Windows guests at hand. If the above patches do not work; would
> it be possible to share an image or something?

I'm not sure if the fault is triggered by the pinned CPU cores, the PCIe pa=
ssthrough, or the NVIDIA graphics driver on guest side.
I'm also unsure if then a Windows installation ISO or Linux live ISO might =
suffice to trigger the bug.

Unfortunately this guest cannot be taken down very often during this month.
As time allows though I will attempt to create a reduced and generified cop=
y of my domain xml file such that you could import it using `virsh define` =
and then add some install or OS image.

Just let me know if I should test anything else or if you have any ideas ab=
out approaching with debug tools.

Thank you again.
- Devin

