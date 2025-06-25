Return-Path: <kvm+bounces-50725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49A3EAE88B4
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:49:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF3D9680E75
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:49:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C41E29E0FA;
	Wed, 25 Jun 2025 15:49:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ADFF2C1A2;
	Wed, 25 Jun 2025 15:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750866561; cv=none; b=YzUdA1jyUm/DbO00lVcjxf7NWviU1HWJTbmh0HkWYdvRlfqHrSv/skKikZSDBMI2b5H0bCjxyqzC85YQkL6hcnDUDBEwW+toGfa/dRuuVfU7P78maRlUkKxBKsmLVhIfDGxZMKcxGrrrc3ztD+/yQH0ZaD3kwgXl/idkB9biiOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750866561; c=relaxed/simple;
	bh=Ne6SmFuTOWR3eh/T9Je5zt5W+tEQOcpeJQNnbNd0MoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bappH+COYCYG+7bAqriC7zmN7zCyx+u/Jw6Kc1a3O0zRbHDAK9uKAaoaAFZEHa80Yn4DMnhBVe+n/h081e91xuG+IkZJ4xjg3orgpgZkpAGugz7ytkBuVWVp+SLIswi/RDP23fzyzVgyu/DAw48BKi3CE4ZOt3wXNhpJbXjX9hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE1A32680;
	Wed, 25 Jun 2025 08:49:00 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D6E13F58B;
	Wed, 25 Jun 2025 08:49:14 -0700 (PDT)
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
	andre.przywara@arm.com,
	shahuang@redhat.com
Subject: [kvm-unit-tests PATCH v4 11/13] scripts/mkstandalone: Export $TARGET
Date: Wed, 25 Jun 2025 16:48:11 +0100
Message-ID: <20250625154813.27254-12-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250625154813.27254-1-alexandru.elisei@arm.com>
References: <20250625154813.27254-1-alexandru.elisei@arm.com>
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
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 scripts/mkstandalone.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
index ebf425564af5..5a23bb59879e 100755
--- a/scripts/mkstandalone.sh
+++ b/scripts/mkstandalone.sh
@@ -47,6 +47,7 @@ generate_test ()
 	config_export ARCH_NAME
 	config_export TARGET_CPU
 	config_export DEFAULT_QEMU_CPU
+	config_export TARGET
 
 	echo "echo BUILD_HEAD=$(cat build-head)"
 
-- 
2.50.0


