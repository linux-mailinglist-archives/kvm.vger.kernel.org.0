Return-Path: <kvm+bounces-41123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89766A6207F
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 23:35:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE1A9421377
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 22:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F4320550C;
	Fri, 14 Mar 2025 22:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hyxCfitb"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFAA204F6A
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 22:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741991680; cv=none; b=lhbpHJ8yZ9+Zq0xkj3pX/0a0mwcN36eGMynOeOPPWx/ovBkGzQFTCpD1neDcXXiIEZsYc4QkMmisr/WO+zAa7kpQmNq9uPAu/qR1BuKe0RAPIdPOGl6nKOplN6cSolaR8HWm8i6kCWkzQSHizmvSmvjNp59yKQfmKgwMPiDjny0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741991680; c=relaxed/simple;
	bh=PI3qpl/Os+oDiKonnhdp5LSgH4uy+R7Wr6DL0QZM0kg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B9AdS/sGFMMBtw7MEH4A+tEw8gmwEXRrnc+UFpjsdEV1DOROFiKXlB3rqxVdo+cOgwfB9Plj1Kd4FleOSglgvWYiMxpm5Ma+iXNtVTLi0c6WBsPFqfzOYRDhFVW3NQ9U+gMheAncN10VuHcworCkMUfaqAbRlQ2aUTTtF0+a4Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hyxCfitb; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741991676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z8ht/DCn7aPa+Qq2t7+UlM5jrTFYFcOoFzFNyBPpZzM=;
	b=hyxCfitby4M6F14nzoyGMnbi19xMaH68kRxIMQ4Xn5lSOKekANDqh4dMoiIbAVQOnPQaYP
	C8Te820LUFmwOajdWNTiXnHHdbW5Ofy+ovEfgRXeqT6+LB3/0a1ODCjsDwkxc0Pkfw6XR0
	6ZquAjSk2MhLrp8lu0zgwicQu70vfqQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC kvmtool 6/9] arm64: Move remaining kvm/* headers
Date: Fri, 14 Mar 2025 15:25:13 -0700
Message-Id: <20250314222516.1302429-7-oliver.upton@linux.dev>
In-Reply-To: <20250314222516.1302429-1-oliver.upton@linux.dev>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Move the remaining kvm/* headers into the top-level ARM include path.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/include/kvm/fdt-arch.h         | 6 ------
 arm/{aarch64 => }/include/kvm/barrier.h    | 0
 arm/include/{arm-common => kvm}/fdt-arch.h | 0
 3 files changed, 6 deletions(-)
 delete mode 100644 arm/aarch64/include/kvm/fdt-arch.h
 rename arm/{aarch64 => }/include/kvm/barrier.h (100%)
 rename arm/include/{arm-common => kvm}/fdt-arch.h (100%)

diff --git a/arm/aarch64/include/kvm/fdt-arch.h b/arm/aarch64/include/kvm/fdt-arch.h
deleted file mode 100644
index e448bf1..0000000
diff --git a/arm/aarch64/include/kvm/barrier.h b/arm/include/kvm/barrier.h
similarity index 100%
rename from arm/aarch64/include/kvm/barrier.h
rename to arm/include/kvm/barrier.h
diff --git a/arm/include/arm-common/fdt-arch.h b/arm/include/kvm/fdt-arch.h
similarity index 100%
rename from arm/include/arm-common/fdt-arch.h
rename to arm/include/kvm/fdt-arch.h
-- 
2.39.5


