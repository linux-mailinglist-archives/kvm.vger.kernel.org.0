Return-Path: <kvm+bounces-29626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D2CA9AE4BC
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 14:28:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BE3E1C20E2D
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 12:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1C81D5AAC;
	Thu, 24 Oct 2024 12:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cTg5vrLd"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231341D5165
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 12:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729772928; cv=none; b=a/j5p7DVjLGX5KALI4U3E1Md4lOsBD7fYipiliqcIDnvZytBd8+lFc40tEbNYjHz0SEQD5Hra3JaJNHmJPQMXMHW3npncwiYsYLxsOuqOvXrFDycqVtOruGsDTd5KAL4Rc8DToyHs7QdsImE60SQQXnPBKCyjItIDFOsUc/ObDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729772928; c=relaxed/simple;
	bh=fVoG9mOSmW4e3iG2TcU+ssjpJo9J3K0wxWPT5LnY8YI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I8+i7lcStxBChss7YNP6SoNEbe2vpEa4NWc0B8KemvyQdEAM4r50/iJ+Va1YD+YrqtQDzKJhPFjJXHSrvGHd0Gqc/7IbLb2GN85GdS9tjYXPYkGKAMcqHT9PNAA8J6m3M1R0440YHBHc4tkhItZuAF9LPb2p6UOqzAFgsdKGY4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cTg5vrLd; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729772922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FtV0byj1D4lseB8uYVo+8vFbBCxuFY8V71mq8CNJMoM=;
	b=cTg5vrLdY8c22a4uUz45tqJIXsKU46NMpvSor68jpaeDv8lq7d+o24GMKgrsX52xVgmXW3
	n0brfTkAkcMxfN00gZZXW4o7e0npNJBnhHGUyvg2E70q5DgF5f7mo3mdHR5AJDz9a4Tvtu
	rtJygLD7zsY65SDMxhzhMzq6K4i6N8Q=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: cade.richard@gmail.com,
	atishp@rivosinc.com,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 0/2] riscv: sbi: Add IPI tests
Date: Thu, 24 Oct 2024 14:28:40 +0200
Message-ID: <20241024122839.71753-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Repost Cade's IPI test patch[1] with all the changes pointed out in the
last review and more.

Based-on: https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi

[1] https://lore.kernel.org/all/20240826065106.20281-1-cade.richard@berkeley.edu/

Andrew Jones (1):
  riscv: Add sbi_send_ipi_broadcast

Cade Richard (1):
  riscv: sbi: Add IPI extension tests

 lib/riscv/asm/sbi.h |   1 +
 lib/riscv/sbi.c     |   7 ++-
 riscv/sbi.c         | 149 +++++++++++++++++++++++++++++++++++++++++++-
 riscv/unittests.cfg |   1 +
 4 files changed, 155 insertions(+), 3 deletions(-)

-- 
2.47.0


