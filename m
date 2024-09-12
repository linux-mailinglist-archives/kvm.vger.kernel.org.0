Return-Path: <kvm+bounces-26680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF08C9765F0
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:43:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A87D8282BAA
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E93019CC36;
	Thu, 12 Sep 2024 09:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="6ihIYS/I"
X-Original-To: kvm@vger.kernel.org
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8896195980
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 09:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726134231; cv=none; b=bKfLUwepG//fNhu+3BfZC9waIs/suGmTSVUNLN1HcjmEwZxeejE6pwIM8zp8xzl1wQCJ57kBW01CUqhA30zT2ZYyZv7ibfjxzkJqkbpugDF1Qo+Wljhgjfgf8fRPyAsk3eavgsgatOBXU2ZogfbaHeVH5GpdiSgt6dp7Zk5D8lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726134231; c=relaxed/simple;
	bh=48szM/r3pAFHd4aAvgoXl/M2aveRZ8dfftc/W4I8gY4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ftQ5agh3dsQe9cb/Y9LkDAyPyqjRaGaII7mIFRE5qN7TBrWrFD6QNHFXS0YN1n/X2rAhoTjhlEiXncuLyP5FI1VA2bS2//ZCBaj9YBI0zg3HTasfWXOOhZs3B6ohf7v9zVUGQLDevpiVKLDKRJtb1Kkwk1sIlf5rSCLDX/b91tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=6ihIYS/I; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p4ffe1f47.dip0.t-ipconnect.de [79.254.31.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id DCAC7289ACF;
	Thu, 12 Sep 2024 11:43:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1726134228;
	bh=48szM/r3pAFHd4aAvgoXl/M2aveRZ8dfftc/W4I8gY4=;
	h=Date:From:To:Subject:From;
	b=6ihIYS/Injzm+VOn2CeVrvgtxytxqEBWVZRUjt3NavrIqFeB+xi44pdxJJmeJF7SS
	 tXL9cI/uIrf7QOXHBJseTxP2fWkJw/2xywLZIQZlrw1XB+xdLFj4QYQf0E0X8E+aX0
	 o8BnHd/rzAHE6kWw8XVZjHTYZFnplaWsBZhaOLTuP+KzbqdhAeCXiyz9UbF0UM90ty
	 yQBnqnVk9/FJMjFriNFovQVzMbMsTyNIrIGnzGu1eJLX/ApjLRwzRInPMD6ezh84tb
	 NN29uipFtztVF5hmTQQ/BjdnK+e9ZJJtfN1zrSg8J77EGJsVJgGmi5GBmFKDLbwtg7
	 LO77RzW8OZT7Q==
Date: Thu, 12 Sep 2024 11:43:47 +0200
From: =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To: svsm-devel@coconut-svsm.dev, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Invitation to COCONUT-SVSM BoF at Linux Plumbers Conference
Message-ID: <ZuK30-Ug790Vbhck@8bytes.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

The COCONUT-SVSM community wants to invite the Linux, virtualisation, and
confidential computing communities to our BoF at the Linux Plumbers
Conference next week in Vienna.

We hope to gather ideas, discuss problems and get input for the next
year of development. It is scheduled for Thursday, September 19th at 5pm
in Room 1.14. Details are at this link:

	https://lpc.events/event/18/contributions/1980/

Hope to see you all there!

Regards,

	Jörg

