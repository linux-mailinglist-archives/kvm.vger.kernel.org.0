Return-Path: <kvm+bounces-20092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EDA08910847
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A7411C22284
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 14:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFE441AED28;
	Thu, 20 Jun 2024 14:29:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3311A8C1B;
	Thu, 20 Jun 2024 14:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718893794; cv=none; b=pYh/aI9qkRHcSrEBOPbKvazF/3cCYdKyRHSmwrefiU3epAyfg+Aik6PqhrM9zorBuAvDUNh6BtSnxwn35bNen06rMgxVCxw//jVUkUGySOwbbC5sea8m2G+RDC5z+uHTdMVT74ucOlXaQ6lGHV9KR618nBt5HrMygGVPe+qZG10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718893794; c=relaxed/simple;
	bh=HYqrSolIuyZA636QNZOF8U7twJdCUuYRTq9G7WcmKB8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=RJrzUffV8ePx8PiqhwM3UBydrMYk72nDL696oS73T2CGwPTExVmzLYxgzxQYeNJnyulzGmUTOHt+ln0844Dlahhc3E1ykBnBFUNLC8mv+ScE0nM3+BjZVCs/ZOA96PEerDbQlqkVRbp46zIYCBD10e5yE/F1PcegbPuaZDRc310=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4W4jYl3rsWz4w2H;
	Fri, 21 Jun 2024 00:29:47 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com, corbet@lwn.net, Gautam Menghani <gautam@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20240605113913.83715-1-gautam@linux.ibm.com>
References: <20240605113913.83715-1-gautam@linux.ibm.com>
Subject: Re: [PATCH v2 0/2] Fix doorbell emulation for v2 API on PPC
Message-Id: <171889374983.827284.3419155044368284562.b4-ty@ellerman.id.au>
Date: Fri, 21 Jun 2024 00:29:09 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Wed, 05 Jun 2024 17:09:08 +0530, Gautam Menghani wrote:
> Doorbell emulation for KVM on PAPR guests is broken as support for DPDES
> was not added in initial patch series [1].
> Add DPDES support and doorbell handling support for V2 API.
> 
> [1] lore.kernel.org/linuxppc-dev/20230914030600.16993-1-jniethe5@gmail.com
> 
> Changes in v2:
> 1. Split DPDES support into its own patch
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/2] arch/powerpc/kvm: Add DPDES support in helper library for Guest state buffer
      https://git.kernel.org/powerpc/c/55dfb8bed6fe8bda390cc71cca878d11a9407099
[2/2] arch/powerpc/kvm: Fix doorbell emulation for v2 API
      https://git.kernel.org/powerpc/c/54ec2bd9e0173b75daf84675d07c56584f96564b

cheers

