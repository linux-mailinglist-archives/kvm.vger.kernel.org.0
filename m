Return-Path: <kvm+bounces-55694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16C84B34EBC
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 00:02:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D781816EA93
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 22:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94192265626;
	Mon, 25 Aug 2025 22:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=msa.hinet.net header.i=@msa.hinet.net header.b="ll9V+V29"
X-Original-To: kvm@vger.kernel.org
Received: from cdmsr2.hinet.net (210-65-1-144.hinet-ip.hinet.net [210.65.1.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECC927F749
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 22:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.65.1.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756159330; cv=none; b=KBCnqTtPRLaWkCD7ayGv0AX4JbTsQNmJ4FE3oZsR/PCsVZg8/TaBnfzaCp0/2fw2+qdet0tldeJvaa6vG7z1unupBP7uusC3ReLTRWYnqlzgC/D87OnqgYo7+wNWm+o11amS9IMuhlAYlGj2ghXTI9SzE0eMrMc9amx5mNzNOoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756159330; c=relaxed/simple;
	bh=hWJIO2sws/xStZhhfgrVZZx6ZEda2KaT4k2a8/ohfp8=;
	h=Message-ID:From:To:Subject:Date:MIME-Version:Content-Type; b=ggatbDrx8qREQjhlZvnxf2Wx34mTbvSCsAEZ3sG8K2W+Snkm3CtLCXZkFag9WNymCHYCbMx8FXCLHKOTOFxLErXLD2MHDg8/qdBw1ul7n4yusJBhwykrkE8SLNbSkXhYxlw+mJuah/XBoUkRfSTMC3etR0kpYYngF/DhcZzGAqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=msa.hinet.net; spf=pass smtp.mailfrom=msa.hinet.net; dkim=pass (1024-bit key) header.d=msa.hinet.net header.i=@msa.hinet.net header.b=ll9V+V29; arc=none smtp.client-ip=210.65.1.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=msa.hinet.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=msa.hinet.net
Received: from cmsr8.hinet.net ([10.199.216.87])
	by cdmsr2.hinet.net (8.15.2/8.15.2) with ESMTPS id 57PM26Gb897229
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO)
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 06:02:06 +0800
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=msa.hinet.net;
	s=default; t=1756159326; bh=q2zIQ6Xs/MiAhflU3xx/I4yghck=;
	h=From:To:Subject:Date;
	b=ll9V+V29f43FBYbytLORdz15HN/0P4TaOMDc509/ETCG33CWcoVkNZnG4pq/gbeyS
	 wldnQiRX0qMYGm3NXKwBNLTcft9V/X5w2j+XLLRi5qTDaR2pA+8RE5YJAkmJ79ve8+
	 cxvVBby1ow+ZFtOFhNCcSU5YGvfUmcvNEIOWjDVw=
Received: from [127.0.0.1] (114-39-114-13.dynamic-ip.hinet.net [114.39.114.13])
	by cmsr8.hinet.net (8.15.2/8.15.2) with ESMTPS id 57PLuZhw763237
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 05:56:38 +0800
Message-ID: <89efae1c40ed53a2cf59f71c2aedf3f22fa84f093a9980592c1e29607db36b1d@msa.hinet.net>
From: Procurement <europe-salesbond@msa.hinet.net>
Reply-To: europe-sales@albinayah-group.com
To: kvm@vger.kernel.org
Subject: September Order - RFQ
Date: Mon, 25 Aug 2025 14:56:38 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=AKpXSxtd c=1 sm=1 tr=0 ts=68acdc17
	a=Hxnu99zK1Rpeg0qIOr+BTQ==:117 a=kj9zAlcOel0A:10 a=woOiZ7w2AAAA:8
	a=Gp9z5yGasSGPIeDKQg4A:9 a=CjuIK1q_8ugA:10 a=y8FzcybzHWbWVUxH3U7b:22

Hi,

Please kindly quote best price for your following products:

Include:
1.Price
2.Delivery term
3.Quote expiry : September

Thanks!

Kamal Prasad

Manager

Albinayah.com

