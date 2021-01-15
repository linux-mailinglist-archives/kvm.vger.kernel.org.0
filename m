Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E7F2F78B0
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731426AbhAOMVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:21:33 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:35875 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731278AbhAOMVa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:21:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610713725; x=1642249725;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=gmbL1GEibmkXDOU4mHnOqLm/iNHrZfhTNucsbK/1V0g=;
  b=TxEtBdd29JeMwHZ/EW12ylfrx8RfY9gTQLjqglhojOi+diNe28mp5vWj
   p6JVrKiZNVa1OsX0vjCCg2lo8e/jlC9L7Gh8JFk+o1F9a2MAH34wH12oe
   lC/gFLBsEk2LEIdSujstEBkdrnXRAVrTpULNOssJziCika9uBPROyRT2t
   bjP43DQfXH+FKBnVQKRBl1fCwXN9xPTBvmNJqVas7lNHRH1UJ9hgoNFqR
   JU2dcjtdIi51aiEiMtTR3/MQD69BuZsPej4NHePpT4MyQPdpIKus3V5Gj
   qulCBXDD58VqcgnfcKMfexBVwNuAktCmvIFwD8Tph+aFOfd1bcm2JMHI2
   Q==;
IronPort-SDR: UMKckfZZQQaEQplvpriqTQRM8hO83eECJuZueiGLmWYMvFjl0VGxWO0h0yIzKY1MkGaj6vQOtg
 KRj8TqXYw/TagQpMASKMKpsrqA0y3iYtHriC7E5p7v7HcEdwBzxRev2nJgggUbDswYO0lZUPIW
 RXjg+njzj0FjC5xrWtx2wlNjXA1MZaftnPFD5hPlWHaXdJG4Rd73JgRLp9vPSwdj/YVFp6yskA
 Lbx1+doNJifzNI3sJ607zqMcn1gJ9k/vm7TpbKG5Hz3OavW+wzphNxkdwxIa7/sHj79LuqrC3E
 tmc=
X-IronPort-AV: E=Sophos;i="5.79,349,1602518400"; 
   d="scan'208";a="261441384"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2021 20:27:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwpdNEo4KNgUpAQngy/BVBLoAZg/WX/l0SGafhMXics5HPuKQoArb0/oFiFeN9uklAIL3alqhAXB7ORD4xw9Ofl1RFFbCkHcmySX1r1wHFKYEq9ynMsMCMWnor4mjJYrP2kNshLvJvEF/ymYmOeP/Q4ZMYzWAd+5jHLorm4IFRhzc2+xxqYYl4BCD2E4bPNmWbsQl56GtpPJjZ+p9SXPG3SSny4yc2QHn9EE+R2OhAOlqnKG76eDiyNH0IW8DoyF/b+97MtcLfBY1upErBLQHaoiHUx5+TiOQHQwFiuFdBsTPLE+2NILDMAlihngjsqfa78nUEGaJvwKEngmtFWxDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z8nsZ2ZbgyYmKvozdNQP3VVBxzRLuEpgDmwZZ6rszQo=;
 b=Lh5hy9ZYMp0DJGH0MH6k4cf3WC5msnI1Efn2MO9j9AnlIINVdxja9zmxt8Fl30xmFZxlfj+anen6FJTkRaAqubxegBWZ+hKt9xKzJa2TSSdxTXYWGa/9A8lmR7v0qE+zl37dCRLxy/5bXVxFy01F44+eGkA2vqUVD8jgzZLMIFxwDwlj8gj/31BPLmu2QT+eS7QgX4ytqa+/rlRmc1bkaXxJW/bI7dHnk+Z9e6G41VmqoiTH9skD/Iyf+DO1OemyziUoKOVi6Dytt0mzRi2ZM8opYuakCNUqzePYz93aRtcwD4YNMNiaDCdYEXPk9dBEsdyFQfROsRNfk7qXwzv0OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z8nsZ2ZbgyYmKvozdNQP3VVBxzRLuEpgDmwZZ6rszQo=;
 b=AWSVGFJHVMvNtRpOnTH/rrHS3E2fMVzouP7+GYHhKX2E/3CJ2TeF02Fz215e7r3wvNHjIUXAVaitlqH9IHMymAR/JLLuihVI+tG2Qf+rTUEvgY+JRUxNhUE9bF7X8ne/Uvgqu7M/Xv96dqYhngSYwR4BwCAYXJ7DqSe6A9bKkxA=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB4330.namprd04.prod.outlook.com (2603:10b6:5:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 15 Jan
 2021 12:20:22 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97%5]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 12:20:22 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v16 13/17] RISC-V: KVM: FP lazy save/restore
Date:   Fri, 15 Jan 2021 17:48:42 +0530
Message-Id: <20210115121846.114528-14-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115121846.114528-1-anup.patel@wdc.com>
References: <20210115121846.114528-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.167.152.18]
X-ClientProxiedBy: MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::34) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.167.152.18) by MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 12:20:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 05c324bc-817b-4afe-2032-08d8b94fee39
X-MS-TrafficTypeDiagnostic: DM6PR04MB4330:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB43304220BD128DADFC5711068DA70@DM6PR04MB4330.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZLto9lNjtXdoKBd5KJL0b60x012UzEgK3wbYugiLij8h7CoyCkcyFvJDRbMEy3pYj7qJKp6S22rbvt8sKo3XujlNQzKFSxZuFUwf4V44YO2iYvmnLnnzlI2cr8v5cwhyP7SWWoGQL9LWNVl525jE45Ei8Mk9O5saglqOo/VoHT864aG3CC2SYHTK24vAlCJfyA82DBnNk3E27O6Ifz8SIfAn9kEx95f22704bUgeih/rXq0JAes9aOl9cgjIFV/7cZXTqCGZC3UyRdPHtncjEoWXMDPghSLRk/eUeRbT3tIXPoPHo8rHkhedUlq6nCBTpf5q+ACFium2tGBhEesFc1GPHawRORufxwRxRC/TdI41IDDmjs0r+GCIN41SaLlGts8SyWoLRBECuu7lLT7EZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(7416002)(66946007)(316002)(1076003)(66476007)(8936002)(110136005)(186003)(66556008)(86362001)(16526019)(36756003)(44832011)(6666004)(7696005)(4326008)(26005)(52116002)(30864003)(8676002)(2616005)(478600001)(2906002)(54906003)(956004)(8886007)(55016002)(83380400001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?O9X94iQkWADhd3Cqsoq31bExGjqG6bConoFbDGZhR0vLeDv8Q3cHEHv2S2x9?=
 =?us-ascii?Q?Gun00b8KZ8d2+HPHSPNdQEMuJMeCXYWeVWGllzMADxuoblrPAxQEWXF/TEnQ?=
 =?us-ascii?Q?dWBbnxR/bLrpelma5gfUJf+ByrU083GR+eA8kjR2cZ0viQ7GGd/CrFw96KJ2?=
 =?us-ascii?Q?lhxN+XToqdDVqcTwUXoMVUJH0Gi8bTNPJuLrnd0ko0PgHMq43dMck5u6Y2Mg?=
 =?us-ascii?Q?ztbGgC01jYnvhKxjzBXqKPSWVPmsJ1FsCN3XNdiD+66EDoyXWJGfRSUVjdoc?=
 =?us-ascii?Q?ZI9m0cealE/OX7F/r9Cc8QbojFM2Q/ZOMYmAfdGRk4/gnueXs0hDsTTtt+QU?=
 =?us-ascii?Q?2o3Os5b5of8eK7uXNO9Hcb5xzNP2vpLFB0Vo1BUdm6tiR+C3Ndhg60yxk2mo?=
 =?us-ascii?Q?BwTCOjoR0LVF/B6GUWOIXKtk1IGURgEnNFmyvfV9gdLPaY1uPR1iSFHPGbCG?=
 =?us-ascii?Q?2uKPelTy7Oane+uj5VmsfaPqqvB2/86jJgHcT2kr5aw9Fr5I7+wN9VsNHVsb?=
 =?us-ascii?Q?1pNGlz9ViTPnWf/y/2V3G8ez9C7qMfMarxZbxRjPn0dWh8P7IfZPlbA9cYz+?=
 =?us-ascii?Q?KdcVJviJA9s8c6M0zCGrKdunpPKAb7I4OMupMGonR6x1jvVG/IslIQMwb0WH?=
 =?us-ascii?Q?XH9rhJ3FPqs6M+XA3mu6Xnkt8rdRdidfD8x8gJAiVrb7UbxULVtrax7d47xc?=
 =?us-ascii?Q?OdoMFC1LD5wk9CzhtNSPw940RBHYjfZRFqpKaT40r82HqBm20R5RYTyMcbh4?=
 =?us-ascii?Q?GCe6WK24oMrOkWuF0TTOObIFq1oi3q85CRxE0YrBzeRRXsFxj6Qmx2mCi63V?=
 =?us-ascii?Q?fVSnvqD/3AWsS8Njco+wbmMjGTjSQLDyGn44kYya869S9N9+9CkV5PlV/JIv?=
 =?us-ascii?Q?UDrGAaQrLYVpH9IKwxX/Cl+UKbWvNlxQ7JF+oRDxrmhuEYlVZNFnNk/H2iAK?=
 =?us-ascii?Q?NvpM1yanjyPkqUiR7ko3nEv4qXSCluGLP6hXoaoWxFVLbapOU9lprCU2mW9/?=
 =?us-ascii?Q?Yx6K?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05c324bc-817b-4afe-2032-08d8b94fee39
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 12:20:22.8278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PU8A6IfnjIoA7sDwbD6+jOWxjTxMQaL22XM5jrx/xvCp+TzbODPrQEKYF12DmOwYiuPNsVDyplBgzRxWXdug1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4330
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

This patch adds floating point (F and D extension) context save/restore
for guest VCPUs. The FP context is saved and restored lazily only when
kernel enter/exits the in-kernel run loop and not during the KVM world
switch. This way FP save/restore has minimal impact on KVM performance.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/kvm_host.h |   5 +
 arch/riscv/kernel/asm-offsets.c   |  72 +++++++++++++
 arch/riscv/kvm/vcpu.c             |  91 ++++++++++++++++
 arch/riscv/kvm/vcpu_switch.S      | 174 ++++++++++++++++++++++++++++++
 4 files changed, 342 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index dcdc7816a799..6d97a8eab206 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -131,6 +131,7 @@ struct kvm_cpu_context {
 	unsigned long sepc;
 	unsigned long sstatus;
 	unsigned long hstatus;
+	union __riscv_fp_state fp;
 };
 
 struct kvm_vcpu_csr {
@@ -251,6 +252,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			struct kvm_cpu_trap *trap);
 
 void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch);
+void __kvm_riscv_fp_f_save(struct kvm_cpu_context *context);
+void __kvm_riscv_fp_f_restore(struct kvm_cpu_context *context);
+void __kvm_riscv_fp_d_save(struct kvm_cpu_context *context);
+void __kvm_riscv_fp_d_restore(struct kvm_cpu_context *context);
 
 int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
 int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index a205b3c21ff8..bf6dadafeb95 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -192,6 +192,78 @@ void asm_offsets(void)
 	OFFSET(KVM_ARCH_TRAP_HTVAL, kvm_cpu_trap, htval);
 	OFFSET(KVM_ARCH_TRAP_HTINST, kvm_cpu_trap, htinst);
 
+	/* F extension */
+
+	OFFSET(KVM_ARCH_FP_F_F0, kvm_cpu_context, fp.f.f[0]);
+	OFFSET(KVM_ARCH_FP_F_F1, kvm_cpu_context, fp.f.f[1]);
+	OFFSET(KVM_ARCH_FP_F_F2, kvm_cpu_context, fp.f.f[2]);
+	OFFSET(KVM_ARCH_FP_F_F3, kvm_cpu_context, fp.f.f[3]);
+	OFFSET(KVM_ARCH_FP_F_F4, kvm_cpu_context, fp.f.f[4]);
+	OFFSET(KVM_ARCH_FP_F_F5, kvm_cpu_context, fp.f.f[5]);
+	OFFSET(KVM_ARCH_FP_F_F6, kvm_cpu_context, fp.f.f[6]);
+	OFFSET(KVM_ARCH_FP_F_F7, kvm_cpu_context, fp.f.f[7]);
+	OFFSET(KVM_ARCH_FP_F_F8, kvm_cpu_context, fp.f.f[8]);
+	OFFSET(KVM_ARCH_FP_F_F9, kvm_cpu_context, fp.f.f[9]);
+	OFFSET(KVM_ARCH_FP_F_F10, kvm_cpu_context, fp.f.f[10]);
+	OFFSET(KVM_ARCH_FP_F_F11, kvm_cpu_context, fp.f.f[11]);
+	OFFSET(KVM_ARCH_FP_F_F12, kvm_cpu_context, fp.f.f[12]);
+	OFFSET(KVM_ARCH_FP_F_F13, kvm_cpu_context, fp.f.f[13]);
+	OFFSET(KVM_ARCH_FP_F_F14, kvm_cpu_context, fp.f.f[14]);
+	OFFSET(KVM_ARCH_FP_F_F15, kvm_cpu_context, fp.f.f[15]);
+	OFFSET(KVM_ARCH_FP_F_F16, kvm_cpu_context, fp.f.f[16]);
+	OFFSET(KVM_ARCH_FP_F_F17, kvm_cpu_context, fp.f.f[17]);
+	OFFSET(KVM_ARCH_FP_F_F18, kvm_cpu_context, fp.f.f[18]);
+	OFFSET(KVM_ARCH_FP_F_F19, kvm_cpu_context, fp.f.f[19]);
+	OFFSET(KVM_ARCH_FP_F_F20, kvm_cpu_context, fp.f.f[20]);
+	OFFSET(KVM_ARCH_FP_F_F21, kvm_cpu_context, fp.f.f[21]);
+	OFFSET(KVM_ARCH_FP_F_F22, kvm_cpu_context, fp.f.f[22]);
+	OFFSET(KVM_ARCH_FP_F_F23, kvm_cpu_context, fp.f.f[23]);
+	OFFSET(KVM_ARCH_FP_F_F24, kvm_cpu_context, fp.f.f[24]);
+	OFFSET(KVM_ARCH_FP_F_F25, kvm_cpu_context, fp.f.f[25]);
+	OFFSET(KVM_ARCH_FP_F_F26, kvm_cpu_context, fp.f.f[26]);
+	OFFSET(KVM_ARCH_FP_F_F27, kvm_cpu_context, fp.f.f[27]);
+	OFFSET(KVM_ARCH_FP_F_F28, kvm_cpu_context, fp.f.f[28]);
+	OFFSET(KVM_ARCH_FP_F_F29, kvm_cpu_context, fp.f.f[29]);
+	OFFSET(KVM_ARCH_FP_F_F30, kvm_cpu_context, fp.f.f[30]);
+	OFFSET(KVM_ARCH_FP_F_F31, kvm_cpu_context, fp.f.f[31]);
+	OFFSET(KVM_ARCH_FP_F_FCSR, kvm_cpu_context, fp.f.fcsr);
+
+	/* D extension */
+
+	OFFSET(KVM_ARCH_FP_D_F0, kvm_cpu_context, fp.d.f[0]);
+	OFFSET(KVM_ARCH_FP_D_F1, kvm_cpu_context, fp.d.f[1]);
+	OFFSET(KVM_ARCH_FP_D_F2, kvm_cpu_context, fp.d.f[2]);
+	OFFSET(KVM_ARCH_FP_D_F3, kvm_cpu_context, fp.d.f[3]);
+	OFFSET(KVM_ARCH_FP_D_F4, kvm_cpu_context, fp.d.f[4]);
+	OFFSET(KVM_ARCH_FP_D_F5, kvm_cpu_context, fp.d.f[5]);
+	OFFSET(KVM_ARCH_FP_D_F6, kvm_cpu_context, fp.d.f[6]);
+	OFFSET(KVM_ARCH_FP_D_F7, kvm_cpu_context, fp.d.f[7]);
+	OFFSET(KVM_ARCH_FP_D_F8, kvm_cpu_context, fp.d.f[8]);
+	OFFSET(KVM_ARCH_FP_D_F9, kvm_cpu_context, fp.d.f[9]);
+	OFFSET(KVM_ARCH_FP_D_F10, kvm_cpu_context, fp.d.f[10]);
+	OFFSET(KVM_ARCH_FP_D_F11, kvm_cpu_context, fp.d.f[11]);
+	OFFSET(KVM_ARCH_FP_D_F12, kvm_cpu_context, fp.d.f[12]);
+	OFFSET(KVM_ARCH_FP_D_F13, kvm_cpu_context, fp.d.f[13]);
+	OFFSET(KVM_ARCH_FP_D_F14, kvm_cpu_context, fp.d.f[14]);
+	OFFSET(KVM_ARCH_FP_D_F15, kvm_cpu_context, fp.d.f[15]);
+	OFFSET(KVM_ARCH_FP_D_F16, kvm_cpu_context, fp.d.f[16]);
+	OFFSET(KVM_ARCH_FP_D_F17, kvm_cpu_context, fp.d.f[17]);
+	OFFSET(KVM_ARCH_FP_D_F18, kvm_cpu_context, fp.d.f[18]);
+	OFFSET(KVM_ARCH_FP_D_F19, kvm_cpu_context, fp.d.f[19]);
+	OFFSET(KVM_ARCH_FP_D_F20, kvm_cpu_context, fp.d.f[20]);
+	OFFSET(KVM_ARCH_FP_D_F21, kvm_cpu_context, fp.d.f[21]);
+	OFFSET(KVM_ARCH_FP_D_F22, kvm_cpu_context, fp.d.f[22]);
+	OFFSET(KVM_ARCH_FP_D_F23, kvm_cpu_context, fp.d.f[23]);
+	OFFSET(KVM_ARCH_FP_D_F24, kvm_cpu_context, fp.d.f[24]);
+	OFFSET(KVM_ARCH_FP_D_F25, kvm_cpu_context, fp.d.f[25]);
+	OFFSET(KVM_ARCH_FP_D_F26, kvm_cpu_context, fp.d.f[26]);
+	OFFSET(KVM_ARCH_FP_D_F27, kvm_cpu_context, fp.d.f[27]);
+	OFFSET(KVM_ARCH_FP_D_F28, kvm_cpu_context, fp.d.f[28]);
+	OFFSET(KVM_ARCH_FP_D_F29, kvm_cpu_context, fp.d.f[29]);
+	OFFSET(KVM_ARCH_FP_D_F30, kvm_cpu_context, fp.d.f[30]);
+	OFFSET(KVM_ARCH_FP_D_F31, kvm_cpu_context, fp.d.f[31]);
+	OFFSET(KVM_ARCH_FP_D_FCSR, kvm_cpu_context, fp.d.fcsr);
+
 	/*
 	 * THREAD_{F,X}* might be larger than a S-type offset can handle, but
 	 * these are used in performance-sensitive assembly so we can't resort
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 45ff6761b89c..d039f17f106d 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -35,6 +35,86 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ NULL }
 };
 
+#ifdef CONFIG_FPU
+static void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu)
+{
+	unsigned long isa = vcpu->arch.isa;
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+
+	cntx->sstatus &= ~SR_FS;
+	if (riscv_isa_extension_available(&isa, f) ||
+	    riscv_isa_extension_available(&isa, d))
+		cntx->sstatus |= SR_FS_INITIAL;
+	else
+		cntx->sstatus |= SR_FS_OFF;
+}
+
+static void kvm_riscv_vcpu_fp_clean(struct kvm_cpu_context *cntx)
+{
+	cntx->sstatus &= ~SR_FS;
+	cntx->sstatus |= SR_FS_CLEAN;
+}
+
+static void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx,
+					 unsigned long isa)
+{
+	if ((cntx->sstatus & SR_FS) == SR_FS_DIRTY) {
+		if (riscv_isa_extension_available(&isa, d))
+			__kvm_riscv_fp_d_save(cntx);
+		else if (riscv_isa_extension_available(&isa, f))
+			__kvm_riscv_fp_f_save(cntx);
+		kvm_riscv_vcpu_fp_clean(cntx);
+	}
+}
+
+static void kvm_riscv_vcpu_guest_fp_restore(struct kvm_cpu_context *cntx,
+					    unsigned long isa)
+{
+	if ((cntx->sstatus & SR_FS) != SR_FS_OFF) {
+		if (riscv_isa_extension_available(&isa, d))
+			__kvm_riscv_fp_d_restore(cntx);
+		else if (riscv_isa_extension_available(&isa, f))
+			__kvm_riscv_fp_f_restore(cntx);
+		kvm_riscv_vcpu_fp_clean(cntx);
+	}
+}
+
+static void kvm_riscv_vcpu_host_fp_save(struct kvm_cpu_context *cntx)
+{
+	/* No need to check host sstatus as it can be modified outside */
+	if (riscv_isa_extension_available(NULL, d))
+		__kvm_riscv_fp_d_save(cntx);
+	else if (riscv_isa_extension_available(NULL, f))
+		__kvm_riscv_fp_f_save(cntx);
+}
+
+static void kvm_riscv_vcpu_host_fp_restore(struct kvm_cpu_context *cntx)
+{
+	if (riscv_isa_extension_available(NULL, d))
+		__kvm_riscv_fp_d_restore(cntx);
+	else if (riscv_isa_extension_available(NULL, f))
+		__kvm_riscv_fp_f_restore(cntx);
+}
+#else
+static void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu)
+{
+}
+static void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx,
+					 unsigned long isa)
+{
+}
+static void kvm_riscv_vcpu_guest_fp_restore(struct kvm_cpu_context *cntx,
+					    unsigned long isa)
+{
+}
+static void kvm_riscv_vcpu_host_fp_save(struct kvm_cpu_context *cntx)
+{
+}
+static void kvm_riscv_vcpu_host_fp_restore(struct kvm_cpu_context *cntx)
+{
+}
+#endif
+
 #define KVM_RISCV_ISA_ALLOWED	(riscv_isa_extension_mask(a) | \
 				 riscv_isa_extension_mask(c) | \
 				 riscv_isa_extension_mask(d) | \
@@ -55,6 +135,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
 
+	kvm_riscv_vcpu_fp_reset(vcpu);
+
 	kvm_riscv_vcpu_timer_reset(vcpu);
 
 	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
@@ -204,6 +286,7 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 			vcpu->arch.isa = reg_val;
 			vcpu->arch.isa &= riscv_isa_extension_base(NULL);
 			vcpu->arch.isa &= KVM_RISCV_ISA_ALLOWED;
+			kvm_riscv_vcpu_fp_reset(vcpu);
 		} else {
 			return -EOPNOTSUPP;
 		}
@@ -608,6 +691,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_riscv_vcpu_timer_restore(vcpu);
 
+	kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
+	kvm_riscv_vcpu_guest_fp_restore(&vcpu->arch.guest_context,
+					vcpu->arch.isa);
+
 	vcpu->cpu = cpu;
 }
 
@@ -617,6 +704,10 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 	vcpu->cpu = -1;
 
+	kvm_riscv_vcpu_guest_fp_save(&vcpu->arch.guest_context,
+				     vcpu->arch.isa);
+	kvm_riscv_vcpu_host_fp_restore(&vcpu->arch.host_context);
+
 	csr_write(CSR_HGATP, 0);
 
 	csr->vsstatus = csr_read(CSR_VSSTATUS);
diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
index 13fb56906da2..d200d59eaa33 100644
--- a/arch/riscv/kvm/vcpu_switch.S
+++ b/arch/riscv/kvm/vcpu_switch.S
@@ -224,3 +224,177 @@ ENTRY(__kvm_riscv_unpriv_trap)
 	REG_S	a1, (KVM_ARCH_TRAP_HTINST)(a0)
 	sret
 ENDPROC(__kvm_riscv_unpriv_trap)
+
+#ifdef	CONFIG_FPU
+	.align 3
+	.global __kvm_riscv_fp_f_save
+__kvm_riscv_fp_f_save:
+	csrr t2, CSR_SSTATUS
+	li t1, SR_FS
+	csrs CSR_SSTATUS, t1
+	frcsr t0
+	fsw f0,  KVM_ARCH_FP_F_F0(a0)
+	fsw f1,  KVM_ARCH_FP_F_F1(a0)
+	fsw f2,  KVM_ARCH_FP_F_F2(a0)
+	fsw f3,  KVM_ARCH_FP_F_F3(a0)
+	fsw f4,  KVM_ARCH_FP_F_F4(a0)
+	fsw f5,  KVM_ARCH_FP_F_F5(a0)
+	fsw f6,  KVM_ARCH_FP_F_F6(a0)
+	fsw f7,  KVM_ARCH_FP_F_F7(a0)
+	fsw f8,  KVM_ARCH_FP_F_F8(a0)
+	fsw f9,  KVM_ARCH_FP_F_F9(a0)
+	fsw f10, KVM_ARCH_FP_F_F10(a0)
+	fsw f11, KVM_ARCH_FP_F_F11(a0)
+	fsw f12, KVM_ARCH_FP_F_F12(a0)
+	fsw f13, KVM_ARCH_FP_F_F13(a0)
+	fsw f14, KVM_ARCH_FP_F_F14(a0)
+	fsw f15, KVM_ARCH_FP_F_F15(a0)
+	fsw f16, KVM_ARCH_FP_F_F16(a0)
+	fsw f17, KVM_ARCH_FP_F_F17(a0)
+	fsw f18, KVM_ARCH_FP_F_F18(a0)
+	fsw f19, KVM_ARCH_FP_F_F19(a0)
+	fsw f20, KVM_ARCH_FP_F_F20(a0)
+	fsw f21, KVM_ARCH_FP_F_F21(a0)
+	fsw f22, KVM_ARCH_FP_F_F22(a0)
+	fsw f23, KVM_ARCH_FP_F_F23(a0)
+	fsw f24, KVM_ARCH_FP_F_F24(a0)
+	fsw f25, KVM_ARCH_FP_F_F25(a0)
+	fsw f26, KVM_ARCH_FP_F_F26(a0)
+	fsw f27, KVM_ARCH_FP_F_F27(a0)
+	fsw f28, KVM_ARCH_FP_F_F28(a0)
+	fsw f29, KVM_ARCH_FP_F_F29(a0)
+	fsw f30, KVM_ARCH_FP_F_F30(a0)
+	fsw f31, KVM_ARCH_FP_F_F31(a0)
+	sw t0, KVM_ARCH_FP_F_FCSR(a0)
+	csrw CSR_SSTATUS, t2
+	ret
+
+	.align 3
+	.global __kvm_riscv_fp_d_save
+__kvm_riscv_fp_d_save:
+	csrr t2, CSR_SSTATUS
+	li t1, SR_FS
+	csrs CSR_SSTATUS, t1
+	frcsr t0
+	fsd f0,  KVM_ARCH_FP_D_F0(a0)
+	fsd f1,  KVM_ARCH_FP_D_F1(a0)
+	fsd f2,  KVM_ARCH_FP_D_F2(a0)
+	fsd f3,  KVM_ARCH_FP_D_F3(a0)
+	fsd f4,  KVM_ARCH_FP_D_F4(a0)
+	fsd f5,  KVM_ARCH_FP_D_F5(a0)
+	fsd f6,  KVM_ARCH_FP_D_F6(a0)
+	fsd f7,  KVM_ARCH_FP_D_F7(a0)
+	fsd f8,  KVM_ARCH_FP_D_F8(a0)
+	fsd f9,  KVM_ARCH_FP_D_F9(a0)
+	fsd f10, KVM_ARCH_FP_D_F10(a0)
+	fsd f11, KVM_ARCH_FP_D_F11(a0)
+	fsd f12, KVM_ARCH_FP_D_F12(a0)
+	fsd f13, KVM_ARCH_FP_D_F13(a0)
+	fsd f14, KVM_ARCH_FP_D_F14(a0)
+	fsd f15, KVM_ARCH_FP_D_F15(a0)
+	fsd f16, KVM_ARCH_FP_D_F16(a0)
+	fsd f17, KVM_ARCH_FP_D_F17(a0)
+	fsd f18, KVM_ARCH_FP_D_F18(a0)
+	fsd f19, KVM_ARCH_FP_D_F19(a0)
+	fsd f20, KVM_ARCH_FP_D_F20(a0)
+	fsd f21, KVM_ARCH_FP_D_F21(a0)
+	fsd f22, KVM_ARCH_FP_D_F22(a0)
+	fsd f23, KVM_ARCH_FP_D_F23(a0)
+	fsd f24, KVM_ARCH_FP_D_F24(a0)
+	fsd f25, KVM_ARCH_FP_D_F25(a0)
+	fsd f26, KVM_ARCH_FP_D_F26(a0)
+	fsd f27, KVM_ARCH_FP_D_F27(a0)
+	fsd f28, KVM_ARCH_FP_D_F28(a0)
+	fsd f29, KVM_ARCH_FP_D_F29(a0)
+	fsd f30, KVM_ARCH_FP_D_F30(a0)
+	fsd f31, KVM_ARCH_FP_D_F31(a0)
+	sw t0, KVM_ARCH_FP_D_FCSR(a0)
+	csrw CSR_SSTATUS, t2
+	ret
+
+	.align 3
+	.global __kvm_riscv_fp_f_restore
+__kvm_riscv_fp_f_restore:
+	csrr t2, CSR_SSTATUS
+	li t1, SR_FS
+	lw t0, KVM_ARCH_FP_F_FCSR(a0)
+	csrs CSR_SSTATUS, t1
+	flw f0,  KVM_ARCH_FP_F_F0(a0)
+	flw f1,  KVM_ARCH_FP_F_F1(a0)
+	flw f2,  KVM_ARCH_FP_F_F2(a0)
+	flw f3,  KVM_ARCH_FP_F_F3(a0)
+	flw f4,  KVM_ARCH_FP_F_F4(a0)
+	flw f5,  KVM_ARCH_FP_F_F5(a0)
+	flw f6,  KVM_ARCH_FP_F_F6(a0)
+	flw f7,  KVM_ARCH_FP_F_F7(a0)
+	flw f8,  KVM_ARCH_FP_F_F8(a0)
+	flw f9,  KVM_ARCH_FP_F_F9(a0)
+	flw f10, KVM_ARCH_FP_F_F10(a0)
+	flw f11, KVM_ARCH_FP_F_F11(a0)
+	flw f12, KVM_ARCH_FP_F_F12(a0)
+	flw f13, KVM_ARCH_FP_F_F13(a0)
+	flw f14, KVM_ARCH_FP_F_F14(a0)
+	flw f15, KVM_ARCH_FP_F_F15(a0)
+	flw f16, KVM_ARCH_FP_F_F16(a0)
+	flw f17, KVM_ARCH_FP_F_F17(a0)
+	flw f18, KVM_ARCH_FP_F_F18(a0)
+	flw f19, KVM_ARCH_FP_F_F19(a0)
+	flw f20, KVM_ARCH_FP_F_F20(a0)
+	flw f21, KVM_ARCH_FP_F_F21(a0)
+	flw f22, KVM_ARCH_FP_F_F22(a0)
+	flw f23, KVM_ARCH_FP_F_F23(a0)
+	flw f24, KVM_ARCH_FP_F_F24(a0)
+	flw f25, KVM_ARCH_FP_F_F25(a0)
+	flw f26, KVM_ARCH_FP_F_F26(a0)
+	flw f27, KVM_ARCH_FP_F_F27(a0)
+	flw f28, KVM_ARCH_FP_F_F28(a0)
+	flw f29, KVM_ARCH_FP_F_F29(a0)
+	flw f30, KVM_ARCH_FP_F_F30(a0)
+	flw f31, KVM_ARCH_FP_F_F31(a0)
+	fscsr t0
+	csrw CSR_SSTATUS, t2
+	ret
+
+	.align 3
+	.global __kvm_riscv_fp_d_restore
+__kvm_riscv_fp_d_restore:
+	csrr t2, CSR_SSTATUS
+	li t1, SR_FS
+	lw t0, KVM_ARCH_FP_D_FCSR(a0)
+	csrs CSR_SSTATUS, t1
+	fld f0,  KVM_ARCH_FP_D_F0(a0)
+	fld f1,  KVM_ARCH_FP_D_F1(a0)
+	fld f2,  KVM_ARCH_FP_D_F2(a0)
+	fld f3,  KVM_ARCH_FP_D_F3(a0)
+	fld f4,  KVM_ARCH_FP_D_F4(a0)
+	fld f5,  KVM_ARCH_FP_D_F5(a0)
+	fld f6,  KVM_ARCH_FP_D_F6(a0)
+	fld f7,  KVM_ARCH_FP_D_F7(a0)
+	fld f8,  KVM_ARCH_FP_D_F8(a0)
+	fld f9,  KVM_ARCH_FP_D_F9(a0)
+	fld f10, KVM_ARCH_FP_D_F10(a0)
+	fld f11, KVM_ARCH_FP_D_F11(a0)
+	fld f12, KVM_ARCH_FP_D_F12(a0)
+	fld f13, KVM_ARCH_FP_D_F13(a0)
+	fld f14, KVM_ARCH_FP_D_F14(a0)
+	fld f15, KVM_ARCH_FP_D_F15(a0)
+	fld f16, KVM_ARCH_FP_D_F16(a0)
+	fld f17, KVM_ARCH_FP_D_F17(a0)
+	fld f18, KVM_ARCH_FP_D_F18(a0)
+	fld f19, KVM_ARCH_FP_D_F19(a0)
+	fld f20, KVM_ARCH_FP_D_F20(a0)
+	fld f21, KVM_ARCH_FP_D_F21(a0)
+	fld f22, KVM_ARCH_FP_D_F22(a0)
+	fld f23, KVM_ARCH_FP_D_F23(a0)
+	fld f24, KVM_ARCH_FP_D_F24(a0)
+	fld f25, KVM_ARCH_FP_D_F25(a0)
+	fld f26, KVM_ARCH_FP_D_F26(a0)
+	fld f27, KVM_ARCH_FP_D_F27(a0)
+	fld f28, KVM_ARCH_FP_D_F28(a0)
+	fld f29, KVM_ARCH_FP_D_F29(a0)
+	fld f30, KVM_ARCH_FP_D_F30(a0)
+	fld f31, KVM_ARCH_FP_D_F31(a0)
+	fscsr t0
+	csrw CSR_SSTATUS, t2
+	ret
+#endif
-- 
2.25.1

