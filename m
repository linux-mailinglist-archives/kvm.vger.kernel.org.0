Return-Path: <kvm+bounces-66821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C9F44CE8ED9
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 08:55:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 659B53002066
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 07:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C25892FDC4D;
	Tue, 30 Dec 2025 07:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TtEySgR5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B1C2FE05D
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 07:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767081327; cv=none; b=j61x0608elCHdSaL4wmbNM6RSXrIC3nY352H7VqLmcwi1TppuwBBreK83CxqaVOgik7DArVckgBSst/CiKC/88vof+ijb3OVUqQ2GJtD2CmJqfPazWhywd4qdUGHUBY65WM/Ww1cbPwiAOySR4kBPRp7FjUlagOpXpNqW7x6Vvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767081327; c=relaxed/simple;
	bh=Z4VQ+EtDEu7E8elRQTZ60XglA/ohyy2vMdA0rCBdGbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRQivE1Uk5b5+T3QiNqGFTDhvdNS7+fJ/mua6/eN9Z68CYjQxCXtX4l7oYad3bH13NmJqA4x5AAVjrwi2MU//XvJxZlnnnj93zgVAl/L4PxgLckzJIqRm4vSCogUcq7/GGD18jQat+EszCscXkrd744p18f5+slCtjoN1Lm51LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TtEySgR5; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BU3L6V53307838;
	Tue, 30 Dec 2025 07:55:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=nEmGZ
	FyWnA3msHhlVrm0U6RumbIoqP5IRpvGV1ajfg8=; b=TtEySgR5P6jXUo9AaOJzS
	tyfUOTFwFNFRUJWDPQKKtaM8VKO12tMHpp5RjJYj+Qg9pHFXCeRCwMrtH7geagRC
	hf0pngVihCVkpwVrNa8fay4PBFqESC9pX82WhWaDGR+1E0Jm2LnT3kdEWKx7ud1b
	tVcSLt7q5/NTU4yk46bRBGIo9BrEENDUqT0BqdyzJFHhHcPIBQAaMNtrrSh9Uh36
	Qjd1l23wWahCe0FxPVGjHGSTC62WSqWP3RvqCda/EiBSHJIFR2SK0nnM1ckLb3vz
	8rB9Vnkj492vtBZjpYTkn+WpUQDNUu4GVbmDQMg84DiCdyvOMDpcuFgZkDf73nKk
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba6c8tb2g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Dec 2025 07:55:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BU7ehbi017273;
	Tue, 30 Dec 2025 07:55:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wbp6d3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Dec 2025 07:55:01 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5BU7smZv005421;
	Tue, 30 Dec 2025 07:55:01 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ba5wbp6aa-7;
	Tue, 30 Dec 2025 07:55:00 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
Subject: [PATCH v8 6/7] target/i386/kvm: support perfmon-v2 for reset
Date: Mon, 29 Dec 2025 23:42:45 -0800
Message-ID: <20251230074354.88958-7-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251230074354.88958-1-dongli.zhang@oracle.com>
References: <20251230074354.88958-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_07,2025-12-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512300070
X-Authority-Analysis: v=2.4 cv=a4E9NESF c=1 sm=1 tr=0 ts=69538557 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8
 a=zd2uoN0lAAAA:8 a=YKGenqcJedeHRtipQB0A:9 cc=ntf awl=host:12109
X-Proofpoint-GUID: pBBxWXZmiuUQ5LCCX2UaRYS1rnh7pv15
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMwMDA3MCBTYWx0ZWRfXxdqALatmX5nX
 fukiyWK986QuvB3ePFQ8aZe9lV+BtEpIKKqbxofOXdnlEsRFtlR+/MBmVHEICRMWVTG7tDKaxsW
 uZHzrzZrl3e8MXyXhvRtjkOYZ68/DeBVzcte8xu2ayvfI+Nhd7Y2WkTq8E2DI0x/ZuqymrReTiH
 V7mcCTTfXmbm2ezokKYCYdWKqqPB5uctChq5byr/zm6wi6J6XWtGHlI/iJu9HGLvFGGNPYlQHse
 89Fcn4mgxcswYq6Qp9Li48bLonXbHsX9Xa0MvajnRssp2bTsGA5RN6UiobrHKhl/x+KIEHfo3Nu
 YUaJR/awAYjqVeZ4KMuxgGjjMGEZUTQVyN09cKWUlDSCqLCtYwVs8ke9B5aeS9EOYuKod8S2U/i
 ocspF6sfOsV7yWbqGSJwG8FxBWSvggz4Z5I3oswerSxhK0wwsOFvN2dYClocM8nxrLk3dsKoaAU
 GAVhZK4UTIvMQnd8HxJVKQsNLeb4AFbA5GbBgmOA=
X-Proofpoint-ORIG-GUID: pBBxWXZmiuUQ5LCCX2UaRYS1rnh7pv15

Since perfmon-v2, the AMD PMU supports additional registers. This update
includes get/put functionality for these extra registers.

Similar to the implementation in KVM:

- MSR_CORE_PERF_GLOBAL_STATUS and MSR_AMD64_PERF_CNTR_GLOBAL_STATUS both
use env->msr_global_status.
- MSR_CORE_PERF_GLOBAL_CTRL and MSR_AMD64_PERF_CNTR_GLOBAL_CTL both use
env->msr_global_ctrl.
- MSR_CORE_PERF_GLOBAL_OVF_CTRL and MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR
both use env->msr_global_ovf_ctrl.

No changes are needed for vmstate_msr_architectural_pmu or
pmu_enable_needed().

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Sandipan Das <sandipan.das@amd.com>
---
Changed since v1:
  - Use "has_pmu_version > 1", not "has_pmu_version == 2".
Changed since v2:
  - Use cpuid_find_entry() instead of cpu_x86_cpuid().
  - Change has_pmu_version to pmu_version.
  - Cap num_pmu_gp_counters with MAX_GP_COUNTERS.
Changed since v4:
  - Add Reviewed-by from Sandipan.

 target/i386/cpu.h     |  4 ++++
 target/i386/kvm/kvm.c | 48 +++++++++++++++++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index c1649d1247..c6dab03a92 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -506,6 +506,10 @@ typedef enum X86Seg {
 #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
 
+#define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS       0xc0000300
+#define MSR_AMD64_PERF_CNTR_GLOBAL_CTL          0xc0000301
+#define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR   0xc0000302
+
 #define MSR_K7_EVNTSEL0                 0xc0010000
 #define MSR_K7_PERFCTR0                 0xc0010004
 #define MSR_F15H_PERF_CTL0              0xc0010200
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index b8e9c9192b..99837048b8 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2169,6 +2169,16 @@ static void kvm_init_pmu_info_amd(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
     }
 
     num_pmu_gp_counters = AMD64_NUM_COUNTERS_CORE;
+
+    c = cpuid_find_entry(cpuid, 0x80000022, 0);
+    if (c && (c->eax & CPUID_8000_0022_EAX_PERFMON_V2)) {
+        pmu_version = 2;
+        num_pmu_gp_counters = c->ebx & 0xf;
+
+        if (num_pmu_gp_counters > MAX_GP_COUNTERS) {
+            num_pmu_gp_counters = MAX_GP_COUNTERS;
+        }
+    }
 }
 
 static bool is_host_compat_vendor(CPUX86State *env)
@@ -4254,13 +4264,14 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
             uint32_t step = 1;
 
             /*
-             * When PERFCORE is enabled, AMD PMU uses a separate set of
-             * addresses for the selector and counter registers.
-             * Additionally, the address of the next selector or counter
-             * register is determined by incrementing the address of the
-             * current register by two.
+             * When PERFCORE or PerfMonV2 is enabled, AMD PMU uses a
+             * separate set of addresses for the selector and counter
+             * registers. Additionally, the address of the next selector or
+             * counter register is determined by incrementing the address
+             * of the current register by two.
              */
-            if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
+            if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE ||
+                pmu_version > 1) {
                 sel_base = MSR_F15H_PERF_CTL0;
                 ctr_base = MSR_F15H_PERF_CTR0;
                 step = 2;
@@ -4272,6 +4283,15 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
                 kvm_msr_entry_add(cpu, sel_base + i * step,
                                   env->msr_gp_evtsel[i]);
             }
+
+            if (pmu_version > 1) {
+                kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
+                                  env->msr_global_status);
+                kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR,
+                                  env->msr_global_ovf_ctrl);
+                kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
+                                  env->msr_global_ctrl);
+            }
         }
 
         /*
@@ -4806,13 +4826,14 @@ static int kvm_get_msrs(X86CPU *cpu)
         uint32_t step = 1;
 
         /*
-         * When PERFCORE is enabled, AMD PMU uses a separate set of
-         * addresses for the selector and counter registers.
+         * When PERFCORE or PerfMonV2 is enabled, AMD PMU uses a separate
+         * set of addresses for the selector and counter registers.
          * Additionally, the address of the next selector or counter
          * register is determined by incrementing the address of the
          * current register by two.
          */
-        if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
+        if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE ||
+            pmu_version > 1) {
             sel_base = MSR_F15H_PERF_CTL0;
             ctr_base = MSR_F15H_PERF_CTR0;
             step = 2;
@@ -4822,6 +4843,12 @@ static int kvm_get_msrs(X86CPU *cpu)
             kvm_msr_entry_add(cpu, ctr_base + i * step, 0);
             kvm_msr_entry_add(cpu, sel_base + i * step, 0);
         }
+
+        if (pmu_version > 1) {
+            kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
+            kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, 0);
+            kvm_msr_entry_add(cpu, MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, 0);
+        }
     }
 
     if (env->mcg_cap) {
@@ -5137,12 +5164,15 @@ static int kvm_get_msrs(X86CPU *cpu)
             env->msr_fixed_ctr_ctrl = msrs[i].data;
             break;
         case MSR_CORE_PERF_GLOBAL_CTRL:
+        case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
             env->msr_global_ctrl = msrs[i].data;
             break;
         case MSR_CORE_PERF_GLOBAL_STATUS:
+        case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
             env->msr_global_status = msrs[i].data;
             break;
         case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+        case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
             env->msr_global_ovf_ctrl = msrs[i].data;
             break;
         case MSR_CORE_PERF_FIXED_CTR0 ... MSR_CORE_PERF_FIXED_CTR0 + MAX_FIXED_COUNTERS - 1:
-- 
2.39.3


