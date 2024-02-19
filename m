Return-Path: <kvm+bounces-9079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FA8385A3AA
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 13:42:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4B411F24299
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 12:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C11AA2EB14;
	Mon, 19 Feb 2024 12:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FqazskGA"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BF931A61;
	Mon, 19 Feb 2024 12:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708346504; cv=none; b=HBk6pxyzgeRCURslIF3rSO0cdK4MLh0P/dSWjBMTH1/Wxt3rm7F+1W6EyiciRyj80OjOluUdnpRv8kmaNdUueuevrTLZulM5u0NGzdvwOUZOVTAAJHKV2Xr9PKpl+bmlb6NBTB0lF4WqbsDvpA1eBLGlfKPHDgagx9XQkf8bRjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708346504; c=relaxed/simple;
	bh=YgB8bpox6CHO4HS+BLBPrLShfx43p09D/cP0Ha4A9r0=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=XoBKqoHKGVs4ye57KHMwHAU/UV0qhwvdsa+YltivDYZ7h3ecZxsVMuVBgBikDnpZtd5xOjIgvd/Yh6fyid4u+iVU/uJOcY9mduuV+WoaBP2yVevtezousPCpEgBeSdFoo9KWevjJxt7ovJBy0hM9limCFWhIYIN9GDQPfBlp95A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FqazskGA; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:In-Reply-To:Subject:CC:To:From:Date:Sender:Reply-To:
	Content-ID:Content-Description:References;
	bh=YgB8bpox6CHO4HS+BLBPrLShfx43p09D/cP0Ha4A9r0=; b=FqazskGAihUFmn2PMNOYy+OoyE
	enbU/OaqK+RVXvzow7HrmLXP0jx5GYA46xITxIKMLd8btSsr5oiE3MlYDnMXl8QKaw9YSkHEn/AlX
	X3yu8k4TXTw6/ETTwwCGhngL0IsIwwWLsSxt+atQZuM9YZbVVyovjtaVWMyehps1fVpv2ARC98bWV
	FYr+O16s/uH72vvrjlkpPbmZ4WmbeD435mZTPiCSZ2SN9a6aBJaLpHD7uOlqQRRoR2wGo2d31qVq2
	DSIPGB0O0Z52Znd6/41rLTdnuclLdZHP67tBFOH5lC18QbsXP2p5ubyZjawVU+1100vmhBH/IfDi0
	UoSwRTiA==;
Received: from [2a00:23ee:1988:d251:f9bd:7f7c:4ea2:d047] (helo=[IPv6:::1])
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rc2xl-00000001F3c-0qpI;
	Mon, 19 Feb 2024 12:41:37 +0000
Date: Mon, 19 Feb 2024 12:41:34 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: oliver.sang@intel.com
CC: dwmw@amazon.co.uk, kvm@vger.kernel.org, lkp@intel.com, oe-lkp@lists.linux.dev
Subject: =?US-ASCII?Q?Re=3A_=5Bdwmw2=3Apfncache=5D_=5BKVM=5D__cc69506d1?= =?US-ASCII?Q?9=3A_WARNING=3Abad=5Funlock=5Fbalance=5Fdetected?=
User-Agent: K-9 Mail for Android
In-Reply-To: <202402191553.bd17cf2a-oliver.sang@intel.com>
Message-ID: <5CAEFA29-CF72-41C6-A58B-34DC67391394@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

Thanks=2E Looks like this is for an older version of the patch from a branc=
h in my tree, and already fixed in the version I coincidentally posted to t=
he list just yesterday=2E

