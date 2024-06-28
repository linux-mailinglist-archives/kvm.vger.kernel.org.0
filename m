Return-Path: <kvm+bounces-20697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 197D491C8F3
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 00:12:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7696CB21D20
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 22:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ED0080C02;
	Fri, 28 Jun 2024 22:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZgKHV6wG"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C547FBC3
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 22:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719612731; cv=none; b=S2Kq8pr3jT4ciPxKVN6x8EBM5gm+DHkb5Sa+9JNUlWLBA251YXrvvHuB2ykZNfIYn3zd+aFvbi++LGQajxzEkWr8LzdPBKN2xK55lqyf3wErxWwAK7EB5SOMQkRTrLOs2pil/hiZKJTaGYisZJBBGkpVlQF7/jxjwLjYHJ75HP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719612731; c=relaxed/simple;
	bh=yJqB0mdMI1pDxH77FtwVHZNj+V0J5g2Ib9kjx+6Bjn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AdPGdXI/WztjMdxxLr2GhfksI+5sXPSEg1UfIIGi4Eevxe3WlWPTIEDhsWczvMR6sgObYKTKStcnxA3DoDEN8gjjJNpJqv8ArykqutwBWWNcQBMpFEWZFKLLcWvfR2beLHk85ChyUYfLk94o4BwScHR29O116UkrjUhsHzOr3b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZgKHV6wG; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: changyuanl@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719612727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S3fbo5VQ87JWvffxjJKYzZzEnljo6EpxDkG+tSmQM1o=;
	b=ZgKHV6wGVRTi252g9l2ZsctbUiJEa0C1VmKK0j9ZYLakzgJ/2qrI+SQ7m8Axp9tk9rlT/7
	arXmLgwaUpqoG81y2Lvtfk+CDLPyWWZGK/siB+xrFGlc7CSNkwp+iBPkDaNUvF3AafaqnG
	FJe+xSPPca17cdPgJLw1k4Ky3bAG67U=
X-Envelope-To: corbet@lwn.net
X-Envelope-To: oliver.upton@linux.dev
X-Envelope-To: linux-doc@vger.kernel.org
X-Envelope-To: kvm@vger.kernel.org
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Changyuan Lyu <changyuanl@google.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] Documentation: Fix typo `BFD`
Date: Fri, 28 Jun 2024 22:11:44 +0000
Message-ID: <171961239511.3148149.12047258552361783439.b4-ty@linux.dev>
In-Reply-To: <20240623164542.2999626-1-changyuanl@google.com>
References: <20240623164542.2999626-1-changyuanl@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Sun, 23 Jun 2024 09:45:39 -0700, Changyuan Lyu wrote:
> BDF is the acronym for Bus, Device, Function.
> 
> 

Applied to kvmarm/next, thanks!

[1/3] Documentation: Fix typo `BFD`
      https://git.kernel.org/kvmarm/kvmarm/c/dc1d234cdd4a
[2/3] Documentation: Enumerate allowed value macros of `irq_type`
      https://git.kernel.org/kvmarm/kvmarm/c/03bd36a387b8
[3/3] Documentation: Correct the VGIC V2 CPU interface addr space size
      https://git.kernel.org/kvmarm/kvmarm/c/810ecbefdd54

--
Best,
Oliver

