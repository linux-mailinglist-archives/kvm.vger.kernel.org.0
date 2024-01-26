Return-Path: <kvm+bounces-7170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84FE683DBCC
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 15:26:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B85191C2151E
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 330FA200DB;
	Fri, 26 Jan 2024 14:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lILEaTU4"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E88200AE
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279074; cv=none; b=lclrWTeASLITU4+C6WmK+wQlrHXbxK4leHuHCNmt4+dbRbETm+vq2KHF/RDQEsm4tXqv4Ve6nNyy4S+v9xJ0D6Jp5JI4N1fmJt1TRbbEsuABAfG09rw/bC4Yhdb6DftOwiZpGw9iLYaJ0/G83slHLbRaQRzsHf8D/AvRQA4ZMIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279074; c=relaxed/simple;
	bh=Lwxr3T+cfJEtbD54mSmzNgQX2Z5bUUs7cauujdhT2IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=DpS33sKlk/TGgpP39TN6zz+0rhPWKtsCZn/UUUSjPXl+un5JKPBVEw+LkDfammKJ6kJEny4xhyo/e+TOrvFxX/oxaGnIl//Jv0pUaux4sQwg/I2ZeiG7HzKjG8kdLYvLSMsQD2Y9JyU0hHJbtFH/pM2lNOVjLLzTMmAxgsGaTk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lILEaTU4; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X8VFzrw4pKeHz0xjQzxcc7aoy02nR4XaRu+jtTXZzoA=;
	b=lILEaTU4VBqY29rZHsaMSJGIV4DifavLVMs316Ci6VHYoKBBlavaVQBxgTxVzjE7chsdBb
	Hna/G9EA6k0SAX4mriUqsAFO1rOSTExwkBT761Ih8Dyo4wS+OR902msOaBzal1+58lBOXY
	GxqqzSNDsgrUEXqbGvAoJPAi3XtrmxU=
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
Subject: [kvm-unit-tests PATCH v2 24/24] MAINTAINERS: Add riscv
Date: Fri, 26 Jan 2024 15:23:49 +0100
Message-ID: <20240126142324.66674-50-andrew.jones@linux.dev>
In-Reply-To: <20240126142324.66674-26-andrew.jones@linux.dev>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
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
Reviewed-by: Thomas Huth <thuth@redhat.com>
Acked-by: Thomas Huth <thuth@redhat.com>
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


