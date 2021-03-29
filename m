Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE6034C275
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 06:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhC2EU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 00:20:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10480 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229557AbhC2EUm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 00:20:42 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12T44q3M133617;
        Mon, 29 Mar 2021 00:20:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=nidEAHcqt5oRwPX0irtxD+lH45PPxRhgh7dlmgWaGv8=;
 b=Gr8DP6V4bO5QDNRlw05h7hwL4fMYHluThJFX3kM/6/bzDxb37Odg+KmpCmKnd4kbaSmY
 R7mohdyh3xXejpIoezbmTTPR94oXr3sRlTpGftKJAy4KD6v3gEU0tzBfg69rg6KKyrEp
 j/E37E4/e6lwN7K1K9KHE14zAlyyyVX9ePZQBvYV1wszzVnPYzTYpN4qyVTgtDmHfilH
 tsQL1WX6c0DSFT1OUlJHCpUPYT4cAdpJnxShQlZubFmNdezBfDxI+Hj+bmKT7z3CRrYW
 hkLMjzdLjMvvSTVVrsdHsrJ1QyWGYYbaYFmBvUzzvX8ue47fjPaIbBeU8RIoyHLYdugr 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37k24y59bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 00:20:11 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12T45CMM135547;
        Mon, 29 Mar 2021 00:20:11 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37k24y59ar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 00:20:11 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12T4GsQu032272;
        Mon, 29 Mar 2021 04:20:08 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 37hvb89f01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 04:20:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12T4K6Et39780798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 04:20:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 725064C044;
        Mon, 29 Mar 2021 04:20:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA8844C04A;
        Mon, 29 Mar 2021 04:20:03 +0000 (GMT)
Received: from bangoria.ibmuc.com (unknown [9.199.34.103])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Mar 2021 04:20:03 +0000 (GMT)
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
To:     paulus@samba.org, david@gibson.dropbear.id.au
Cc:     ravi.bangoria@linux.ibm.com, mpe@ellerman.id.au, mikey@neuling.org,
        pbonzini@redhat.com, mst@redhat.com, clg@kaod.org,
        qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        cohuck@redhat.com
Subject: [PATCH v2 3/3] ppc: Enable 2nd DAWR support on p10
Date:   Mon, 29 Mar 2021 09:49:06 +0530
Message-Id: <20210329041906.213991-4-ravi.bangoria@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329041906.213991-1-ravi.bangoria@linux.ibm.com>
References: <20210329041906.213991-1-ravi.bangoria@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: U3nPNUFKFkD_Dv-ZHTw_5t1IGgYJz4ba
X-Proofpoint-GUID: R-KEI4hfpmCeteUBAtstcuXoo6_7bucG
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_02:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 adultscore=0 clxscore=1015 bulkscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290029
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As per the PAPR, bit 0 of byte 64 in pa-features property indicates
availability of 2nd DAWR registers. i.e. If this bit is set, 2nd 
DAWR is present, otherwise not. Use KVM_CAP_PPC_DAWR1 capability to
find whether kvm supports 2nd DAWR or not. If it's supported, allow
user to set the pa-feature bit in guest DT using cap-dawr1 machine
capability.

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
---
 hw/ppc/spapr.c                  | 34 ++++++++++++++++++++++++++++++++++
 hw/ppc/spapr_caps.c             | 32 ++++++++++++++++++++++++++++++++
 include/hw/ppc/spapr.h          |  6 +++++-
 target/ppc/cpu.h                |  2 ++
 target/ppc/kvm.c                | 12 ++++++++++++
 target/ppc/kvm_ppc.h            |  7 +++++++
 target/ppc/translate_init.c.inc | 17 ++++++++++++++++-
 7 files changed, 108 insertions(+), 2 deletions(-)

diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index d56418c..4df0a37 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -241,6 +241,31 @@ static void spapr_dt_pa_features(SpaprMachineState *spapr,
         /* 60: NM atomic, 62: RNG */
         0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 60 - 65 */
     };
+    uint8_t pa_features_310[] = { 66, 0,
+        /* 0: MMU|FPU|SLB|RUN|DABR|NX, 1: fri[nzpm]|DABRX|SPRG3|SLB0|PP110 */
+        /* 2: VPM|DS205|PPR|DS202|DS206, 3: LSD|URG, SSO, 5: LE|CFAR|EB|LSQ */
+        0xf6, 0x1f, 0xc7, 0xc0, 0x80, 0xf0, /* 0 - 5 */
+        /* 6: DS207 */
+        0x80, 0x00, 0x00, 0x00, 0x00, 0x00, /* 6 - 11 */
+        /* 16: Vector */
+        0x00, 0x00, 0x00, 0x00, 0x80, 0x00, /* 12 - 17 */
+        /* 18: Vec. Scalar, 20: Vec. XOR, 22: HTM */
+        0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 18 - 23 */
+        /* 24: Ext. Dec, 26: 64 bit ftrs, 28: PM ftrs */
+        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 24 - 29 */
+        /* 30: MMR, 32: LE atomic, 34: EBB + ext EBB */
+        0x80, 0x00, 0x80, 0x00, 0xC0, 0x00, /* 30 - 35 */
+        /* 36: SPR SO, 38: Copy/Paste, 40: Radix MMU */
+        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 36 - 41 */
+        /* 42: PM, 44: PC RA, 46: SC vec'd */
+        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 42 - 47 */
+        /* 48: SIMD, 50: QP BFP, 52: String */
+        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 48 - 53 */
+        /* 54: DecFP, 56: DecI, 58: SHA */
+        0x80, 0x00, 0x80, 0x00, 0x80, 0x00, /* 54 - 59 */
+        /* 60: NM atomic, 62: RNG, 64: DAWR1 */
+        0x80, 0x00, 0x80, 0x00, 0x00, 0x00, /* 60 - 65 */
+    };
     uint8_t *pa_features = NULL;
     size_t pa_size;
 
@@ -256,6 +281,10 @@ static void spapr_dt_pa_features(SpaprMachineState *spapr,
         pa_features = pa_features_300;
         pa_size = sizeof(pa_features_300);
     }
+    if (ppc_check_compat(cpu, CPU_POWERPC_LOGICAL_3_10, 0, cpu->compat_pvr)) {
+        pa_features = pa_features_310;
+        pa_size = sizeof(pa_features_310);
+    }
     if (!pa_features) {
         return;
     }
@@ -279,6 +308,9 @@ static void spapr_dt_pa_features(SpaprMachineState *spapr,
          * in pa-features. So hide it from them. */
         pa_features[40 + 2] &= ~0x80; /* Radix MMU */
     }
+    if (spapr_get_cap(spapr, SPAPR_CAP_DAWR1)) {
+        pa_features[66] |= 0x80;
+    }
 
     _FDT((fdt_setprop(fdt, offset, "ibm,pa-features", pa_features, pa_size)));
 }
@@ -2003,6 +2035,7 @@ static const VMStateDescription vmstate_spapr = {
         &vmstate_spapr_cap_ccf_assist,
         &vmstate_spapr_cap_fwnmi,
         &vmstate_spapr_fwnmi,
+        &vmstate_spapr_cap_dawr1,
         NULL
     }
 };
@@ -4539,6 +4572,7 @@ static void spapr_machine_class_init(ObjectClass *oc, void *data)
     smc->default_caps.caps[SPAPR_CAP_LARGE_DECREMENTER] = SPAPR_CAP_ON;
     smc->default_caps.caps[SPAPR_CAP_CCF_ASSIST] = SPAPR_CAP_ON;
     smc->default_caps.caps[SPAPR_CAP_FWNMI] = SPAPR_CAP_ON;
+    smc->default_caps.caps[SPAPR_CAP_DAWR1] = SPAPR_CAP_OFF;
     spapr_caps_add_properties(smc);
     smc->irq = &spapr_irq_dual;
     smc->dr_phb_enabled = true;
diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
index 9ea7ddd..9c39a21 100644
--- a/hw/ppc/spapr_caps.c
+++ b/hw/ppc/spapr_caps.c
@@ -523,6 +523,27 @@ static void cap_fwnmi_apply(SpaprMachineState *spapr, uint8_t val,
     }
 }
 
+static void cap_dawr1_apply(SpaprMachineState *spapr, uint8_t val,
+                               Error **errp)
+{
+    if (!val) {
+        return; /* Disable by default */
+    }
+
+    if (tcg_enabled()) {
+        error_setg(errp,
+                "DAWR1 not supported in TCG. Try appending -machine cap-dawr1=off");
+    } else if (kvm_enabled()) {
+        if (!kvmppc_has_cap_dawr1()) {
+            error_setg(errp,
+                "DAWR1 not supported by KVM. Try appending -machine cap-dawr1=off");
+        } else if (kvmppc_set_cap_dawr1(val) < 0) {
+            error_setg(errp,
+                "DAWR1 not supported by KVM. Try appending -machine cap-dawr1=off");
+        }
+    }
+}
+
 SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM] = {
     [SPAPR_CAP_HTM] = {
         .name = "htm",
@@ -631,6 +652,16 @@ SpaprCapabilityInfo capability_table[SPAPR_CAP_NUM] = {
         .type = "bool",
         .apply = cap_fwnmi_apply,
     },
+    [SPAPR_CAP_DAWR1] = {
+        .name = "dawr1",
+        .description = "Allow DAWR1",
+        .index = SPAPR_CAP_DAWR1,
+        .get = spapr_cap_get_bool,
+        .set = spapr_cap_set_bool,
+        .type = "bool",
+        .apply = cap_dawr1_apply,
+    },
+
 };
 
 static SpaprCapabilities default_caps_with_cpu(SpaprMachineState *spapr,
@@ -771,6 +802,7 @@ SPAPR_CAP_MIG_STATE(nested_kvm_hv, SPAPR_CAP_NESTED_KVM_HV);
 SPAPR_CAP_MIG_STATE(large_decr, SPAPR_CAP_LARGE_DECREMENTER);
 SPAPR_CAP_MIG_STATE(ccf_assist, SPAPR_CAP_CCF_ASSIST);
 SPAPR_CAP_MIG_STATE(fwnmi, SPAPR_CAP_FWNMI);
+SPAPR_CAP_MIG_STATE(dawr1, SPAPR_CAP_DAWR1);
 
 void spapr_caps_init(SpaprMachineState *spapr)
 {
diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index b8985fa..00c8341 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -74,8 +74,10 @@ typedef enum {
 #define SPAPR_CAP_CCF_ASSIST            0x09
 /* Implements PAPR FWNMI option */
 #define SPAPR_CAP_FWNMI                 0x0A
+/* DAWR1 */
+#define SPAPR_CAP_DAWR1                 0x0B
 /* Num Caps */
-#define SPAPR_CAP_NUM                   (SPAPR_CAP_FWNMI + 1)
+#define SPAPR_CAP_NUM                   (SPAPR_CAP_DAWR1 + 1)
 
 /*
  * Capability Values
@@ -366,6 +368,7 @@ struct SpaprMachineState {
 #define H_SET_MODE_RESOURCE_SET_DAWR0           2
 #define H_SET_MODE_RESOURCE_ADDR_TRANS_MODE     3
 #define H_SET_MODE_RESOURCE_LE                  4
+#define H_SET_MODE_RESOURCE_SET_DAWR1           5
 
 /* Flags for H_SET_MODE_RESOURCE_LE */
 #define H_SET_MODE_ENDIAN_BIG    0
@@ -921,6 +924,7 @@ extern const VMStateDescription vmstate_spapr_cap_nested_kvm_hv;
 extern const VMStateDescription vmstate_spapr_cap_large_decr;
 extern const VMStateDescription vmstate_spapr_cap_ccf_assist;
 extern const VMStateDescription vmstate_spapr_cap_fwnmi;
+extern const VMStateDescription vmstate_spapr_cap_dawr1;
 
 static inline uint8_t spapr_get_cap(SpaprMachineState *spapr, int cap)
 {
diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
index cd02d65..6a60416 100644
--- a/target/ppc/cpu.h
+++ b/target/ppc/cpu.h
@@ -1460,9 +1460,11 @@ typedef PowerPCCPU ArchCPU;
 #define SPR_PSPB              (0x09F)
 #define SPR_DPDES             (0x0B0)
 #define SPR_DAWR0             (0x0B4)
+#define SPR_DAWR1             (0x0B5)
 #define SPR_RPR               (0x0BA)
 #define SPR_CIABR             (0x0BB)
 #define SPR_DAWRX0            (0x0BC)
+#define SPR_DAWRX1            (0x0BD)
 #define SPR_HFSCR             (0x0BE)
 #define SPR_VRSAVE            (0x100)
 #define SPR_USPRG0            (0x100)
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 298c1f8..35daec2 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -89,6 +89,7 @@ static int cap_ppc_count_cache_flush_assist;
 static int cap_ppc_nested_kvm_hv;
 static int cap_large_decr;
 static int cap_fwnmi;
+static int cap_dawr1;
 
 static uint32_t debug_inst_opcode;
 
@@ -138,6 +139,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     cap_ppc_nested_kvm_hv = kvm_vm_check_extension(s, KVM_CAP_PPC_NESTED_HV);
     cap_large_decr = kvmppc_get_dec_bits();
     cap_fwnmi = kvm_vm_check_extension(s, KVM_CAP_PPC_FWNMI);
+    cap_dawr1 = kvm_vm_check_extension(s, KVM_CAP_PPC_DAWR1);
     /*
      * Note: setting it to false because there is not such capability
      * in KVM at this moment.
@@ -2078,6 +2080,16 @@ int kvmppc_set_fwnmi(PowerPCCPU *cpu)
     return kvm_vcpu_enable_cap(cs, KVM_CAP_PPC_FWNMI, 0);
 }
 
+bool kvmppc_has_cap_dawr1(void)
+{
+    return !!cap_dawr1;
+}
+
+int kvmppc_set_cap_dawr1(int enable)
+{
+    return kvm_vm_enable_cap(kvm_state, KVM_CAP_PPC_DAWR1, 0, enable);
+}
+
 int kvmppc_smt_threads(void)
 {
     return cap_ppc_smt ? cap_ppc_smt : 1;
diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
index 989f61a..b13e8ab 100644
--- a/target/ppc/kvm_ppc.h
+++ b/target/ppc/kvm_ppc.h
@@ -63,6 +63,8 @@ bool kvmppc_has_cap_htm(void);
 bool kvmppc_has_cap_mmu_radix(void);
 bool kvmppc_has_cap_mmu_hash_v3(void);
 bool kvmppc_has_cap_xive(void);
+bool kvmppc_has_cap_dawr1(void);
+int kvmppc_set_cap_dawr1(int enable);
 int kvmppc_get_cap_safe_cache(void);
 int kvmppc_get_cap_safe_bounds_check(void);
 int kvmppc_get_cap_safe_indirect_branch(void);
@@ -341,6 +343,11 @@ static inline bool kvmppc_has_cap_xive(void)
     return false;
 }
 
+static inline bool kvmppc_has_cap_dawr1(void)
+{
+    return false;
+}
+
 static inline int kvmppc_get_cap_safe_cache(void)
 {
     return 0;
diff --git a/target/ppc/translate_init.c.inc b/target/ppc/translate_init.c.inc
index 879e6df..93937ee 100644
--- a/target/ppc/translate_init.c.inc
+++ b/target/ppc/translate_init.c.inc
@@ -7765,6 +7765,21 @@ static void gen_spr_book3s_207_dbg(CPUPPCState *env)
                         KVM_REG_PPC_CIABR, 0x00000000);
 }
 
+static void gen_spr_book3s_310_dbg(CPUPPCState *env)
+{
+    gen_spr_book3s_207_dbg(env);
+    spr_register_kvm_hv(env, SPR_DAWR1, "DAWR1",
+                        SPR_NOACCESS, SPR_NOACCESS,
+                        SPR_NOACCESS, SPR_NOACCESS,
+                        &spr_read_generic, &spr_write_generic,
+                        KVM_REG_PPC_DAWR1, 0x00000000);
+    spr_register_kvm_hv(env, SPR_DAWRX1, "DAWRX1",
+                        SPR_NOACCESS, SPR_NOACCESS,
+                        SPR_NOACCESS, SPR_NOACCESS,
+                        &spr_read_generic, &spr_write_generic,
+                        KVM_REG_PPC_DAWRX1, 0x00000000);
+}
+
 static void gen_spr_970_dbg(CPUPPCState *env)
 {
     /* Breakpoints */
@@ -8727,7 +8742,7 @@ static void init_proc_POWER8(CPUPPCState *env)
     /* Common Registers */
     init_proc_book3s_common(env);
     gen_spr_sdr1(env);
-    gen_spr_book3s_207_dbg(env);
+    gen_spr_book3s_310_dbg(env);
 
     /* POWER8 Specific Registers */
     gen_spr_book3s_ids(env);
-- 
2.7.4

