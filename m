Return-Path: <kvm+bounces-45730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF627AAE445
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 17:15:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FED69A48C0
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 15:14:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40AFE28A3F1;
	Wed,  7 May 2025 15:14:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72CE028A1E5;
	Wed,  7 May 2025 15:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746630844; cv=none; b=FFzifoJOaUrkegiH7ucdIrOL3NrRGZEeH8MgpNJGpa2WSJWx2116iGSJJbYmNkoIzBB6iALPEvqvNcJ94gt21CKdY6wZo0dG7RnFO1nyOnYdzMCGt7Yssmx1j7NaAuQSROGZo5wZbI8gCFbA9LpJI5GwIr0Cjl4bZ5hBklqddTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746630844; c=relaxed/simple;
	bh=CxfhpbMP4qaQtlNUTdJLxs3/lp8nrWkLU5/6X22c1IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOcs2luWYU7FchhUnHjZ4BrnqZeFemHBQ5aDxBJY8MGRAFCZpIGuv+kUmQuhtj1XzHxpfthFVzUwIaKldSHhEVWbvXyNKD3IsiTLtfSixgudAKEv43XCGCgchzyEVCNuUI45MdpLuzlTYpZa5Ui6Tg1H3q3MuGJqWCyxynEwW1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E3A9C22EA;
	Wed,  7 May 2025 08:13:52 -0700 (PDT)
Received: from localhost.localdomain (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D8D3E3F58B;
	Wed,  7 May 2025 08:13:59 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: andrew.jones@linux.dev,
	eric.auger@redhat.com,
	lvivier@redhat.com,
	thuth@redhat.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	nrb@linux.ibm.com,
	david@redhat.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	will@kernel.org,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	joey.gouly@arm.com,
	andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH v3 14/16] scripts/mkstandalone: Export $TARGET
Date: Wed,  7 May 2025 16:12:54 +0100
Message-ID: <20250507151256.167769-15-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507151256.167769-1-alexandru.elisei@arm.com>
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

$TARGET is needed for the test runner to decide if it should use qemu or
kvmtool, so export it.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 scripts/mkstandalone.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index 4f666cefe076..3b2caf198b00 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -47,6 +47,7 @@ generate_test ()
 	config_export ARCH_NAME
 	config_export TARGET_CPU
 	config_export DEFAULT_QEMU_CPU
+	config_export TARGET
 
 	echo "echo BUILD_HEAD=$(cat build-head)"
 
-- 
2.49.0


