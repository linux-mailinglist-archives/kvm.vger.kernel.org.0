Return-Path: <kvm+bounces-14519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 360278A2C84
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:37:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA4BF1F22F3A
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93FFD5914E;
	Fri, 12 Apr 2024 10:35:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD71A58ADD
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918127; cv=none; b=AbkTJFLQc9mYr9f5pBhOpu69brGWwrQbaABymG/850ki7rVKs7cI3DEAOoRrgaSexKOg5CKTdO/lEBVJbu4zu+WRTWc8JsMiMQZGOx65pjEz9KYgybd99aF8zfntr6dGM7yK+QGgkNVyDEzv4uiCnmIQc47q8TLiw2QXG5/qNDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918127; c=relaxed/simple;
	bh=2THgtbRlTwJYeGbAnghVfP1xwsjWqEvVuoyJkyltP9M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sZaqT+TEhaTijwheSToWFx4J7eEwkQqzDYHkK7/P/oY0pHgbGrXyVjVM5xHgKpw5WCttVHBQZSTYIwicmKM2igo1Hg0fIMOG1A0czj89NvpSj6UGuJ6xByU9pL9hmaga3aFV5q3UlHk+OSAxGeeFBAcnOHmRX5sxCkLIIn1Y60M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A0500165C;
	Fri, 12 Apr 2024 03:35:54 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A91793F64C;
	Fri, 12 Apr 2024 03:35:23 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 33/33] NOT-FOR-MERGING: add run-realm-tests
Date: Fri, 12 Apr 2024 11:34:08 +0100
Message-Id: <20240412103408.2706058-34-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexandru Elisei <alexandru.elisei@arm.com>

Until we add support for KVMTOOL to run the tests using the
scripts, provide a temporary script to run all the Realm tests.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Co-developed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/run-realm-tests | 112 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)
 create mode 100755 arm/run-realm-tests

diff --git a/arm/run-realm-tests b/arm/run-realm-tests
new file mode 100755
index 00000000..839f2bfc
--- /dev/null
+++ b/arm/run-realm-tests
@@ -0,0 +1,112 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0-only
+# Copyright (C) 2023, Arm Ltd
+# All rights reserved
+#
+
+TASKSET=${TASKSET:-taskset}
+LKVM=${LKVM:-lkvm}
+ARGS="--realm --restricted_mem --irqchip=gicv3 --console=serial --network mode=none --nodefaults --loglevel error"
+PMU_ARGS="--pmu --pmu-counters=8"
+
+TESTDIR="."
+while getopts "d:" option; do
+	case "${option}" in
+		d) TESTDIR=${OPTARG};;
+		?)
+			exit 1
+			;;
+	esac
+done
+if [[ ! -d ${TESTDIR} ]]; then
+	echo "Invalid directory: ${TESTDIR}"
+	exit 1
+fi
+
+function set_all_cpu_except {
+	cpu_except=$1
+	pushd /sys/devices/system/cpu
+	for c in $(find . -maxdepth 1 -type d -name "cpu[0-9]*")
+	do
+		if [ $(basename $c) != "cpu${cpu_except}" ]
+		then
+			echo $2 > $c/online
+		fi
+	done
+	popd
+}
+
+function run_on_cpu0 {
+	# Check if we have TASKSET command available
+	$TASKSET --help &>/dev/null
+	no_taskset=$?
+	if [ $no_taskset -eq 0 ]
+	then
+		cmd_prefix="$TASKSET -c 0 "
+	else
+		set_all_cpu_except 0 0
+		cmd_prefix=""
+	fi
+
+	while read cmd
+	do
+		echo "Running on CPU0: ${cmd}"
+		${cmd_prefix} ${cmd}
+	done
+
+	if [ $no_taskset -ne 0 ]
+	then
+		set_all_cpu_except 0 1
+	fi
+}
+
+function run_tests {
+	DIR="$1"
+
+	$LKVM run $ARGS -c 2 -m 16 -k $DIR/selftest.flat -p "setup smp=2 mem=16"
+	$LKVM run $ARGS -c 2 -m 6 -k $DIR/selftest.flat -p "setup smp=2 sve-vl=128" --sve-vl=128
+	$LKVM run $ARGS -c 2 -m 6 -k $DIR/selftest.flat -p "setup smp=2 sve-vl=256" --sve-vl=256
+	$LKVM run $ARGS -c 1 -m 16 -k $DIR/selftest.flat -p "vectors-kernel"
+	$LKVM run $ARGS -c 1 -m 16 -k $DIR/selftest.flat -p "vectors-user"
+	$LKVM run $ARGS -c 4 -m 32 -k $DIR/selftest.flat -p "smp"
+	$LKVM run $ARGS -c 4 -m 32 -k $DIR/selftest.flat -p "memstress"
+
+	$LKVM run $ARGS -c 1 -m 32 -k $DIR/realm-ns-memory.flat
+
+	$LKVM run $ARGS -c 4 -m 32 -k $DIR/psci.flat
+
+	$LKVM run $ARGS -c 4 -m 32 -k $DIR/gic.flat -p "ipi"
+	$LKVM run $ARGS -c 4 -m 32 -k $DIR/gic.flat -p "active"
+
+	$LKVM run $ARGS -c 1 -m 16 -k $DIR/timer.flat
+	$LKVM run $ARGS $PMU_ARGS -c 2 -m 16 -k $DIR/pmu.flat -p "cycle-counter 0"
+	$LKVM run $ARGS $PMU_ARGS -c 2 -m 16 -k $DIR/pmu.flat -p "pmu-event-introspection"
+	$LKVM run $ARGS $PMU_ARGS -c 2 -m 16 -k $DIR/pmu.flat -p "pmu-event-counter-config"
+	$LKVM run $ARGS $PMU_ARGS -c 2 -m 16 -k $DIR/pmu.flat -p "pmu-basic-event-count"
+	$LKVM run $ARGS $PMU_ARGS -c 2 -m 16 -k $DIR/pmu.flat -p "pmu-mem-access"
+	$LKVM run $ARGS $PMU_ARGS -c 2 -m 16 -k $DIR/pmu.flat -p "pmu-mem-access-reliability"
+	$LKVM run $ARGS $PMU_ARGS -c 2 -m 16 -k $DIR/pmu.flat -p "pmu-sw-incr"
+	$LKVM run $ARGS $PMU_ARGS -c 2 -m 16 -k $DIR/pmu.flat -p "pmu-chained-counters"
+	$LKVM run $ARGS $PMU_ARGS -c 2 -m 16 -k $DIR/pmu.flat -p "pmu-chained-sw-incr"
+	$LKVM run $ARGS $PMU_ARGS -c 2 -m 16 -k $DIR/pmu.flat -p "pmu-chain-promotion"
+	$LKVM run $ARGS $PMU_ARGS -c 2 -m 16 -k $DIR/pmu.flat -p "pmu-overflow-interrupt"
+
+	$LKVM run $ARGS -c 1 -m 16 -k $DIR/realm-rsi.flat -p "version"
+	$LKVM run $ARGS -c 1 -m 16 -k $DIR/realm-rsi.flat -p "host_call hvc"
+	$LKVM run $ARGS -c 1 -m 16 -k $DIR/realm-sea.flat
+
+	$LKVM run $ARGS -c 1 -m 24 -k $DIR/realm-attest.flat -p "attest"
+	$LKVM run $ARGS -c 2 -m 24 -k $DIR/realm-attest.flat -p "attest_smp"
+	$LKVM run $ARGS -c 1 -m 24 -k $DIR/realm-attest.flat -p "extend"
+	$LKVM run $ARGS -c 2 -m 24 -k $DIR/realm-attest.flat -p "extend_smp"
+	$LKVM run $ARGS -c 1 -m 24 -k $DIR/realm-attest.flat -p "extend_and_attest"
+	$LKVM run $ARGS -c 1 -m 24 -k $DIR/realm-attest.flat -p "measurement"
+
+	run_on_cpu0 << EOF
+$LKVM run $ARGS -c 4 -m 64 -k $DIR/fpu.flat
+$LKVM run $ARGS -c 4 -m 64 --sve-vl 128 -k $DIR/fpu.flat
+EOF
+
+}
+
+run_tests "${TESTDIR}"
-- 
2.34.1


