Return-Path: <kvm+bounces-42785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E567BA7CF6A
	for <lists+kvm@lfdr.de>; Sun,  6 Apr 2025 20:16:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0272170B64
	for <lists+kvm@lfdr.de>; Sun,  6 Apr 2025 18:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7535619AD5C;
	Sun,  6 Apr 2025 18:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RI0HJfeh"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0E013C8EA
	for <kvm@vger.kernel.org>; Sun,  6 Apr 2025 18:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743963396; cv=none; b=T39eRhavMVjYe3fDWwyvvib3AbmZorD5nnsLryp/xNbJdDbJ8iQGmByoAAu4no+8lTK+g2BuHIsVJrt8YnftL454gICeGx6epKOgUoZvJLLJGjCefgo4Br+mG2kvYakthowXj80HZpt8qQjh/XlWXIpt8TMztWHTdCfEIHYhqTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743963396; c=relaxed/simple;
	bh=ksoIiuj6A0MyclOiN9aSsulnJVmUzD7Lz9V6oyIGZ24=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O/pM/5Uv0XAqHJeMvVz28eLWiOIxeP1vSz+DoN+w/dJj4JkJr1FMKvg+XIefElMHj+yW8fZuqgWSfe08QF4G/8qptsRNILlN10tJ3IYdUZcPXZ2QV5/4wkhPhguEklgSjU0/uj6t/bTMLABOoqqGp8UhAwOdXu4hhBkAt+pYzTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RI0HJfeh; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743963382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S93UKdhObdvlpcU/FcRzIW0uhpMd7EvcOLuxG0UINpk=;
	b=RI0HJfehh0GA78yb7DIYDAHCR7yGkWUf90gpLVs40PskfCgXEvxDu97Tm+0pBjoeRnmavN
	9apFmBWXbLLTIV0I+lC094J0BbdCTA0vQoa5U2TBEO92dL2ag2NkKmYMp76R5cNnwIKCdL
	hE4/vexq3n9ro30PqCJWSh6C/fbYcxI=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Mingwei Zhang <mizhang@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/2] KVM : selftests: arm64: Explicitly set the page attrs to Inner-Shareable
Date: Sun,  6 Apr 2025 11:16:13 -0700
Message-Id: <174396331752.3282387.4731776469161725499.b4-ty@linux.dev>
In-Reply-To: <20250405001042.1470552-1-rananta@google.com>
References: <20250405001042.1470552-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Sat, 05 Apr 2025 00:10:40 +0000, Raghavendra Rao Ananta wrote:
> The series fixes a conflict in memory attributes in some
> implementations,
> such as Neoverse-N3, that causes a data abort in guest EL1 with FSC
> 0x35 (IMPLEMENTATION DEFINED fault (Unsupported Exclusive or Atomic
> access)).
> 
> Patch-1 is a cleanup patch that replaces numbers (and comments) to
> using proper macros for hardware configuration, such as registers and
> page-table entries.
> 
> [...]

I cleaned up the changelog on patch 2 per the discussion + added a note
about the interaction with LPA2.

Applied to fixes, thanks!

[1/2] KVM: selftests: arm64: Introduce and use hardware-definition macros
      https://git.kernel.org/kvmarm/kvmarm/c/d8d78398e550
[2/2] KVM: selftests: arm64: Explicitly set the page attrs to Inner-Shareable
      https://git.kernel.org/kvmarm/kvmarm/c/c8631ea59b65

--
Best,
Oliver

