Return-Path: <kvm+bounces-67530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E991D07B6A
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 09:08:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 27EE2304A130
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 08:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF952F0C7F;
	Fri,  9 Jan 2026 08:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YxJbWqIK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A3E2ECD39
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 08:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767946078; cv=none; b=iYEknPn4YYwMH9c4DxgV0ROrwK/yJE+JVDDbT2z5sQhnIBPMMcnTpnVaHq2HIjq8AThOxR0yXtkMm29zwngaGFxwuUL3Wwl2+WsEpkCmciCB+SJG6jJhO0d1AD/gbAIYv9Wc1PFTRsDB8QGIQEMfL00Csold35JfWE8XelGHCB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767946078; c=relaxed/simple;
	bh=HqWHOD1/sRewHQvmvEgl6Gm70RXP2cY4D7p1ExHpYNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlWyqL+zdqEFazXgyyXNwvkcok3xpgTDI8D1L2k8poX6QzNDLbV0jpojnK1NaIkC8pG8EGni4+fmoSqnTSED/lUJk8nn6jv3Nx96MAUL6ck4VP3AODzHOicjmw8T00mX895YTUNPQVYxK+Te7oyClo2Y3oO0bmazAAH8iiyWC7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YxJbWqIK; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6097Cp1V2533826;
	Fri, 9 Jan 2026 08:07:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=lNOII
	rFODQaNC2ZDsVuxvf9P0BIuEF8bFyedc9e5vws=; b=YxJbWqIK8rGXZv+5ErvN3
	Fycs3d4/Ruz+ZVBUzNvq4dYqcAvLlE7O+QpKPlS0Di+oOKlG7IqXLXDfrJ2YYYF5
	zecJs8V86g/Hy4NPAWgsWfdv1ctCtVFCSaDKgGLVf6Ddxzdzy/+8dHzh7Ue2BZ4t
	q5zVbbEArCmqWaOEcZ7SzB+0tCvsmDAzBIDZeIsqgDaxf7mjbDEPdcTxv4Zlv8PC
	27fMsHkmpseM5C+AIRfQCnhUO3KDBOJu6fV4+15MaEiusPtbuHOiY8yKOglgBAAu
	lPRPe6crCkOp6Fpg7ogxN8kkXvba93iha3+zXTh5wlEd0Nouj6SEyTx7TUVQIcMl
	A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bjw3bg1h9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Jan 2026 08:07:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6096PHPj017260;
	Fri, 9 Jan 2026 08:07:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjpcbmc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Jan 2026 08:07:23 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60987KrP009653;
	Fri, 9 Jan 2026 08:07:22 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4besjpcbj1-2;
	Fri, 09 Jan 2026 08:07:22 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com, zide.chen@intel.com
Subject: [PATCH v9 1/5] target/i386/kvm: set KVM_PMU_CAP_DISABLE if "-pmu" is configured
Date: Thu,  8 Jan 2026 23:53:56 -0800
Message-ID: <20260109075508.113097-2-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260109075508.113097-1-dongli.zhang@oracle.com>
References: <20260109075508.113097-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-09_02,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601090056
X-Authority-Analysis: v=2.4 cv=KIJXzVFo c=1 sm=1 tr=0 ts=6960b73b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=QyXUC8HyAAAA:8 a=I5TUGnRYk-IH75UTjikA:9 cc=ntf awl=host:12110
X-Proofpoint-GUID: jRANaL4NnF3zKbn4jt8xOfSZptpx-Rq9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA5MDA1NiBTYWx0ZWRfX41F2Y8XrdSJ7
 jS4b8T6KS+jyQAMBbPe2OxqjSsxvlcLYPFk4ho1rhmB/hUZ1oeTocrtmglId44RraCvYJAnlgYb
 oFacMe9yaNBRJLbNg4CDUoFWsLZONvLrXEfhA8HYMUH4gkXzRYOO3U3t7+r43MEEvKdB68hCIxk
 TnGR6fyQti5NZW/R6UL454jMW0jhveqQomlQ/RwGwIlkbz0F+EBWwAORNc/SYvIxjcJ5p6A0EBv
 TBJKC+TKYW6LVfUK1BYdRUN01x1E/N3Dl5/uVktWR9Z4KLp9NF1tz5LNg6BsbgHwobs7HUYWQY9
 1pxb9yntfbuFa7iEjZoPpV4ICOIrdf0Whvyre2pH3sMrIG060wTO3NZdiYLMe0rx84e93T6GGVA
 fUPoP9qF6lHABpvGTieDAYYdpF5xlfBNau5mprGbgoqKXmEBywzv2i7PUXf432QyHsIg2OcNJB4
 noxkGrQo0GI6+uBjv0Roq1247GiY0/DOjLOHU/mc=
X-Proofpoint-ORIG-GUID: jRANaL4NnF3zKbn4jt8xOfSZptpx-Rq9

Although AMD PERFCORE and PerfMonV2 are removed when "-pmu" is configured,
there is no way to fully disable KVM AMD PMU virtualization. Neither
"-cpu host,-pmu" nor "-cpu EPYC" achieves this.

As a result, the following message still appears in the VM dmesg:

[    0.263615] Performance Events: AMD PMU driver.

However, the expected output should be:

[    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
[    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled

This occurs because AMD does not use any CPUID bit to indicate PMU
availability.

To address this, KVM_CAP_PMU_CAPABILITY is used to set KVM_PMU_CAP_DISABLE
when "-pmu" is configured.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
Changed since v1:
  - Switch back to the initial implementation with "-pmu".
https://lore.kernel.org/all/20221119122901.2469-3-dongli.zhang@oracle.com
  - Mention that "KVM_PMU_CAP_DISABLE doesn't change the PMU behavior on
    Intel platform because current "pmu" property works as expected."
Changed since v2:
  - Change has_pmu_cap to pmu_cap.
  - Use (pmu_cap & KVM_PMU_CAP_DISABLE) instead of only pmu_cap in if
    statement.
  - Add Reviewed-by from Xiaoyao and Zhao as the change is minor.
Changed since v5:
  - Re-base on top of most recent mainline QEMU.
  - To resolve conflicts, move the PMU related code before the
    call site of is_tdx_vm().
Changed since v6:
  - Add Reviewed-by from Dapeng Mi.

 target/i386/kvm/kvm.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 7b9b740a8e..c98832f423 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -179,6 +179,8 @@ static int has_triple_fault_event;
 
 static bool has_msr_mcg_ext_ctl;
 
+static int pmu_cap;
+
 static struct kvm_cpuid2 *cpuid_cache;
 static struct kvm_cpuid2 *hv_cpuid_cache;
 static struct kvm_msr_list *kvm_feature_msrs;
@@ -2080,6 +2082,33 @@ full:
 
 int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
 {
+    static bool first = true;
+    int ret;
+
+    if (first) {
+        first = false;
+
+        /*
+         * Since Linux v5.18, KVM provides a VM-level capability to easily
+         * disable PMUs; however, QEMU has been providing PMU property per
+         * CPU since v1.6. In order to accommodate both, have to configure
+         * the VM-level capability here.
+         *
+         * KVM_PMU_CAP_DISABLE doesn't change the PMU
+         * behavior on Intel platform because current "pmu" property works
+         * as expected.
+         */
+        if ((pmu_cap & KVM_PMU_CAP_DISABLE) && !X86_CPU(cpu)->enable_pmu) {
+            ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
+                                    KVM_PMU_CAP_DISABLE);
+            if (ret < 0) {
+                error_setg_errno(errp, -ret,
+                                 "Failed to set KVM_PMU_CAP_DISABLE");
+                return ret;
+            }
+        }
+    }
+
     if (is_tdx_vm()) {
         return tdx_pre_create_vcpu(cpu, errp);
     }
@@ -3391,6 +3420,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
+
     return 0;
 }
 
-- 
2.39.3


