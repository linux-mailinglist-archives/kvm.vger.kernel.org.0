Return-Path: <kvm+bounces-51601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A262AF9675
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 17:13:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33457542175
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 15:12:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED3029B790;
	Fri,  4 Jul 2025 15:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cPVq4pas"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436FA1A76D4
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 15:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751641982; cv=none; b=kfvDTMYPEbhuZCSIFZjfWxs1nTm10T0esEwXv0OSzFmtigySuuo9nOHJCDz1CkQs1sKroQsemDSdd8PWqfw+XDDk7czWZ/utKxUPdjv4wn3i86VCsTbByeKAD6OZXZinCsUbjOOm9vQlwOiTGO56vKeHW1Y98rnEcD2lxGz+Bgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751641982; c=relaxed/simple;
	bh=C3R6ndvVfqHw2+mN8wRj6Mg2GLCHpzq/7hp+tGlpp18=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JV/3fBgx6iITDSr+28OxUsnbvb/fPr3lrhWviJ0gfuipcTv8OF4NKT49XD+lG9JXxBv1QaRAyKcjD6bDPXQPWSj5X9C6jLf4GRzpukPvU2+mFauPjr/gno7nibLhqFti1QlA+9RqrwefUzl3ZyPb+sKmna8H0c+c7QFTiVTkdqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cPVq4pas; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751641976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=muPd8ALb5wcmT6P5lEUElOFpEadSmXSUQz2XkdW4i10=;
	b=cPVq4pasQ4CgcqfXj7bto9SHoNcU2IB5CFsvqnCCfvBph9UqAHPr+IwSpBKHDBU7HYE/6C
	5DFpU9IgZspaKhaRXVePObGfr2yLvFnV5eRlJgHqWZS8ld/lGN488jkUMdgLuf28MG5ZRU
	xBFnh3r8Ez8MFJv4EBrw5DUs/bZ/Cck=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Cc: alexandru.elisei@arm.com,
	cleger@rivosinc.com,
	jesse@rivosinc.com,
	jamestiotio@gmail.com,
	Atish Patra <atishp@rivosinc.com>
Subject: [kvm-unit-tests PATCH 0/2] riscv: Add kvmtool support
Date: Fri,  4 Jul 2025 17:12:55 +0200
Message-ID: <20250704151254.100351-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The first patch is for arm's scripts. It adds a check that I found
useful on the riscv side. The second patch enables riscv to use
kvmtool too.

Andrew Jones (2):
  arm/arm64: Ensure proper host arch with kvmtool
  riscv: Add kvmtool support

 README.md     |   7 ++--
 arm/run       |   5 +++
 configure     |  12 ++++--
 riscv/efi/run |   6 +++
 riscv/run     | 110 +++++++++++++++++++++++++++++++++++---------------
 5 files changed, 101 insertions(+), 39 deletions(-)

-- 
2.49.0


