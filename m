Return-Path: <kvm+bounces-6803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EEA7983A2C5
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 08:21:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C05B1F256FC
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 07:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 600B117C6E;
	Wed, 24 Jan 2024 07:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fc3Dk11F"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4CA17C65
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 07:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080762; cv=none; b=tVTeJDbm8m5PYny+OFgheNnU8Lo4Lsu038+zU8y7ZSlv6Ym9qYmWlrtx2mvfhsYejPNGsVLL/zpF69RjOHt3MKXpmtPvKEyofEqhHw34qZX3l3tLUBd5MQy0lKZerCKgy7VJo59SxuLbf8Sni46Ir6hwJvzoleRXhM24Mzbg/P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080762; c=relaxed/simple;
	bh=LTHRcOyFFc/POoPgDVsamww5oZXpgWr8D7yWNJAuL38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=EQZo6t6yBDg7qvPUVnnFa+UqwJHsv3JxDbk+rWUcXGETid07mx2OdOCeW8yqU1Djaerj4luat5ZJUv1YNAbm5Ha68WNFhXIJtvXXsPymICJKH+bmqoshElijZHBGizmjKUoEOliTmtG4Bm5ru1zGLzLrXQtAAzrPYPA87SBEEpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fc3Dk11F; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706080759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4NF/KYhfN5NlP2yR4ZiBemy8uaGL5WfIBOw+Or+8VUU=;
	b=fc3Dk11FiAsQtBayb5XqPVAN46rzUUeFe7csAl0QgdFnEmobhWi+6d5bNOhjD/XH/NJuHJ
	we+mrGLlK8mbmln1RmEpsUkbh/NWh5D/r3ax5KqRlHiNQKQ43MQKyH/u5FJR/XOi90L2H9
	DZX3V7MQcvBU/UcqWY2hUEwikmu0Ejk=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH 24/24] MAINTAINERS: Add riscv
Date: Wed, 24 Jan 2024 08:18:40 +0100
Message-ID: <20240124071815.6898-50-andrew.jones@linux.dev>
In-Reply-To: <20240124071815.6898-26-andrew.jones@linux.dev>
References: <20240124071815.6898-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Most of the support for riscv is now in place. Let's make it official
and start adding tests!

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 958735fbfd79..a2fa437da5c9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -94,6 +94,14 @@ F: powerpc/
 F: lib/powerpc/
 F: lib/ppc64/
 
+RISCV
+M: Andrew Jones <andrew.jones@linux.dev>
+S: Supported
+L: kvm-riscv@lists.infradead.org
+F: riscv/
+F: lib/riscv/
+T: https://gitlab.com/jones-drew/kvm-unit-tests.git
+
 S390X
 M: Janosch Frank <frankja@linux.ibm.com>
 M: Claudio Imbrenda <imbrenda@linux.ibm.com>
-- 
2.43.0


