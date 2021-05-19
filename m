Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F53388588
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 05:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353209AbhESDjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 23:39:06 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:58316 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353062AbhESDin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 23:38:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621395444; x=1652931444;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=XoLfldzKjzXULUqSb/9j8oDbpGaBOWg9IDKkdw7b2CQ=;
  b=Npwpg+DG0FUDQp7+y/okeBPdBsV10ycKPCazCpj3g2JSDg0qnEB2HiOc
   xvEIsjthPKfh7Opj3nUerz7odMYnNZUMeojaLfniZ69JLlgp3wWYbVrCZ
   ukExpjqACnKBwl+rDOlA2Dtn95PjoSfxdbVmWW1UXxyCeww71w7SpLnQ4
   QYXh/I72ZjXnUqtXOegdDCDm/Kr23lmpAPqq+FX2rfxqNBGEbCPDx74eR
   54BZkcOLUyicyx9B011nmJpj09IaKVQYpumZqwqd2+Rz4hcUxQoIrgD0i
   99ueAHj2VLf7rwsuKWWPL/z2h+xq3tobm4TmfYwdHdzge0QyWpZ/Fqevs
   g==;
IronPort-SDR: 652UJDP4bW6RYDN1xw5v0dATC4/TFn7DoMuyLmXFJEvZhOTN9T5mtuNpxuan2rqycHRKpvaaVD
 aoxM2Kt78KNJi36K9BxIOaltaDKk+HqRXKCJ6iFtrNlkBK7Vuxv2R6ZQ1i4PszUyUfPtU7P1+0
 0KTN7IAnblQle988UBtP3uwmziNwC2vmKG/KdZrv9U7MCMJynLs7IDBeXaQfAazIxEtNTjGc5L
 yh4oDZTnBMAWcTEtVgAXtZMog8bNj8k9rg1SLz4uATwJAAY3Swo1j9H3IFptbiEmgvDxBHC3Jj
 /Ic=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; 
   d="scan'208";a="168652827"
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.42])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 11:37:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TeA7DWoFNhOyPvA4R9/4kmSw9jZhYWWMDzfw7IyGPgBzRZGalsPZGuXzQwJzmwfm64IhFND8nun5C1XiHjJbt2CD02+HvdPjyTu44TOUbrJ3Z6U4HIC1HZ0yluEea61zrr2RMKLk3YIOB5KAieBhMwUoPbxcfMFq14iiILFnuS29HnhZGR5Xz8F3ygpZQLuJZkDN1ompm8z+g8ki+729y4tezojE1QLaPhYtdpAGOoijJJrmnVXJ9JI7oB71MU4US7BYxTQPYZgHJqt/fSHJvKI9nGQneVzXCyjgnNhjpJDYfreA/UUwkdDcYKRmVqZbUR6DEZx41SwK9JSPaCemgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZ29rlUYIdZjQDRFdMiimyDqdkf0ji1dopQ9NmMaRow=;
 b=LVj/lDaVvE+F9LT/Xr5tfvPM+wVpq5IBZb9eDLvPybWGZgzZYeE/F+c6wa6UJSsUbYzgJYZl+glOhilk8h9zTfXNfPTXjWPSsKQuElEGZsJH/DBFKTApdkBUOC+Onnu6o57LKaIixo1P3+NteIxtVO5dSfNbMqIcptf5seo3qdaLsvsTHk2skCn/5DNS18x5nAvkVrIwxSioySfamk0KqN+g/FBRbrYxsp2tdzcHQMUSAO0czABRPKxGefgV+nwlGdxZf9KDdG/ZdaQW5vbrlxu6H4S8tnNM4bS8JbMWf3cH5NWBch4KyM45k2qLDtcxcyWbS2CWkJLQwruZXCMI4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZ29rlUYIdZjQDRFdMiimyDqdkf0ji1dopQ9NmMaRow=;
 b=TiIk/plH64zzLIkfmcEwM74ehG+QcEhcKuKmn+EhCuBYACxZIKKvMaAPIBcyqlotJfkyAttiy0Pq/XWHMel4uefiM/7FNGe5kg2lR/tsJms8cijwP40htGw15kpsG/2pezB4PAS556ESM4/7xeuK+spMR9Sy+hDl70BZyr12mL0=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7745.namprd04.prod.outlook.com (2603:10b6:5:35a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Wed, 19 May
 2021 03:37:22 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50%4]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 03:37:22 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v18 13/18] RISC-V: KVM: FP lazy save/restore
Date:   Wed, 19 May 2021 09:05:48 +0530
Message-Id: <20210519033553.1110536-14-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210519033553.1110536-1-anup.patel@wdc.com>
References: <20210519033553.1110536-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.32.148]
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.32.148) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 03:37:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee0cef98-cda3-400e-5523-08d91a77695b
X-MS-TrafficTypeDiagnostic: CO6PR04MB7745:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB7745C4C42F0BA8620DD46BEC8D2B9@CO6PR04MB7745.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a8BLuefEOgccnlfQ4WiqeOyIPOM24jXs8VFMY7W+Hup5NrDbg9PPN7oMWSfWej6uXJvMa01S+aY4Dt3IBiMrA0D+uwoDwJL75RmTLyz0ZQ7/3Bt/mR3vsazpU6sXV3wkmdtqL4puEyzsvFYezrXpqE+GIrDu4SmyCcwJ33rPga7F5UnRQ07B0544XOxbHOehJIjDD3+MQ36N3OVFzEdEiSi9Q16xDCxQjWL5NFYXkcxqVxZ7Ln5JxV4bTSwmuPc8vdNh7hFbH0A9uKBSTQ9Hl2fxNRqNpPA1nAWQWMaqnP6hbT35ZKyg6/pHcgViSjzVWvimJRkhG5e0zaePm7z2963Y1UVfGyS0OdzLWG808GGEtvylFxbUbB5s/x0BJueEfN7HSiJ0uqDN4DnqgTFHMZt2jUyok9l+4vyznxj2e9tg47JuUGIoLh25xNRfoZVQefjxlTLkISRcj8nnbYuunWU9hCNdzeRZqDzag/0hkgL5FyJJXvoq1EmfPMVrtMYO9XFMm1tLxa996ZtwvsJoFLSAiuhWjiiCvcjltvT8u26gqFIN3kyuf4P8Qc84ikt0n9OnhTAL43WOh3RTSIML9o1ESn0xwDmC2rSDXiep8OcQYc9w94Udv7A6vqfvCvBKT+YW3ALseMgjXALNw60Zjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(7416002)(1076003)(66946007)(478600001)(2906002)(186003)(956004)(2616005)(26005)(16526019)(36756003)(8676002)(44832011)(6666004)(55016002)(7696005)(52116002)(8886007)(86362001)(38350700002)(30864003)(66476007)(4326008)(54906003)(5660300002)(110136005)(83380400001)(66556008)(316002)(38100700002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wQz/64QVocLlWSjEpdfVuQdCeUTkOJkmklTQTaMkmrp5Zv9i5JUM1+JTIy56?=
 =?us-ascii?Q?R5Y/vJF0DB0BpeYNlkLB2/d8U7uKJxVlvp7/bpTaVMXVrjACoLkqebAPdBsa?=
 =?us-ascii?Q?mTlE2XHT8jagx1bM4w05EVK3HEJn3OqoGm00I64SlS9dZllwu4c5PmdEKh+F?=
 =?us-ascii?Q?WgGVHh356hShj9/Uk9g67eYWlt2DLCzm063YOlmyowlzLpcIJz9tN7SL4uvs?=
 =?us-ascii?Q?J7kR2qEfDCgkmvRKRVi/I6UN0zoRTv/x9eoReZAot61AmGeUhcIdzbRU3MH0?=
 =?us-ascii?Q?ddUSk9D71l/BbF2dSTRwkFtqTzCKVYTRcoxwElNoHG1FxadESHfLlc4vdWR0?=
 =?us-ascii?Q?6WjUqTkVp1/MrYFMfuhaZwejdcXcJkBtzPXfPRtw30evEdiEqBPH+KwpW/r/?=
 =?us-ascii?Q?fo3cEWrhnQvE/AXxNQxujhtm9RvaOlt6QZOol0lwu9C67K4sMPYqmRObn10Q?=
 =?us-ascii?Q?vbdZ2mgtKtcCQ32DVjjvDoKW3lGwgRCiNOiqZTwMo/ZBlh+9Hig+nfW4jAO0?=
 =?us-ascii?Q?GHLYXtSOksGdh/QMU8m+U0mIYjw3MPhxKs2gUDi6xEc9jptDIj+RF54WVI34?=
 =?us-ascii?Q?uBs3gaoLAhT5PTaJSW9m3uiyq1sA6OhBYO171IApqkuAb5QgV89GaEE/3+AM?=
 =?us-ascii?Q?s6MC6Ra//k8T3pHVMFZZP8axuNxJN7w/mWejSnYhGDbCd6Req6amG42JiKtH?=
 =?us-ascii?Q?SQ1jB1bOXbrjbBMbFb9DBHUewjJO8UWr+0L5dRt4NrTwNNBVd47mNoeTl0h+?=
 =?us-ascii?Q?s9Mi1UIVzkChyj3+e1d34WqjUx2wbfOo1noPMRfikBY5wPxglhKdctU5aP6R?=
 =?us-ascii?Q?A37lJp8cW2chQkh+vcLGYFlvyyZVqW6NgSysdk+CJxgTMuSo+dCx82R1ChpE?=
 =?us-ascii?Q?uyingkvu2HWQcBH1xw7dp9rF4GOZRcaaHNSU3vQHd/K5+xTw2WvG20RJXUhF?=
 =?us-ascii?Q?WkYXOyeBIhIsxVLq8+3j3UwCUYEnUeqP5pEk1aZ0kg099Fek04RWe4I91rgw?=
 =?us-ascii?Q?PvBdrHvxvXOQ2ZQV7CDP7vHXH0YWLTpbq3+JIsJrQvWG3a6/f7sFK9FueXnA?=
 =?us-ascii?Q?9AdodiOVvOfOb9Jx2zlcLgz0B8VKtV9rVs6IGFhIt+0fq+/xEHFiKoypES6x?=
 =?us-ascii?Q?4DKTfU8tgNCuHS9snXUbWkFfWhWryO4lasqsUV2R1xvVhKNAul8MruW1vmqn?=
 =?us-ascii?Q?XTVB127/s8moIsv+GTLRv0uauv0LE/1zRhf3D5SSqUv7bjrB43NfRyQ8Dn5i?=
 =?us-ascii?Q?djXExfseYifIjMvN2cCS8rVXs/MqpvfAeL9zZ65qkX4BqYRpLieM80o3U2QD?=
 =?us-ascii?Q?9XhTAZcdluI09kY77o862M5A?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee0cef98-cda3-400e-5523-08d91a77695b
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 03:37:22.2561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PTrpaaXq2gNkue8M20K/BmTTRF2Q0k2tJ6ZijmGOhtLMoQUzebmcbGijMRylHXy6WwIYcKZOPgK4VEx6kFIMLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7745
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
 arch/riscv/kvm/riscv_offsets.c    |  72 +++++++++++++
 arch/riscv/kvm/vcpu.c             |  91 ++++++++++++++++
 arch/riscv/kvm/vcpu_switch.S      | 174 ++++++++++++++++++++++++++++++
 4 files changed, 342 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 0134201afb8c..834c6986cc2d 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -130,6 +130,7 @@ struct kvm_cpu_context {
 	unsigned long sepc;
 	unsigned long sstatus;
 	unsigned long hstatus;
+	union __riscv_fp_state fp;
 };
 
 struct kvm_vcpu_csr {
@@ -244,6 +245,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			struct kvm_cpu_trap *trap);
 
 void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch);
+void __kvm_riscv_fp_f_save(struct kvm_cpu_context *context);
+void __kvm_riscv_fp_f_restore(struct kvm_cpu_context *context);
+void __kvm_riscv_fp_d_save(struct kvm_cpu_context *context);
+void __kvm_riscv_fp_d_restore(struct kvm_cpu_context *context);
 
 int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
 int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
diff --git a/arch/riscv/kvm/riscv_offsets.c b/arch/riscv/kvm/riscv_offsets.c
index 3c92d2a1ee82..eafa51955dfb 100644
--- a/arch/riscv/kvm/riscv_offsets.c
+++ b/arch/riscv/kvm/riscv_offsets.c
@@ -94,5 +94,77 @@ int main(void)
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
 	return 0;
 }
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index b6f19ca35562..f2f2321507e6 100644
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
@@ -189,6 +271,7 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 			vcpu->arch.isa = reg_val;
 			vcpu->arch.isa &= riscv_isa_extension_base(NULL);
 			vcpu->arch.isa &= KVM_RISCV_ISA_ALLOWED;
+			kvm_riscv_vcpu_fp_reset(vcpu);
 		} else {
 			return -EOPNOTSUPP;
 		}
@@ -593,6 +676,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_riscv_vcpu_timer_restore(vcpu);
 
+	kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
+	kvm_riscv_vcpu_guest_fp_restore(&vcpu->arch.guest_context,
+					vcpu->arch.isa);
+
 	vcpu->cpu = cpu;
 }
 
@@ -602,6 +689,10 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 	vcpu->cpu = -1;
 
+	kvm_riscv_vcpu_guest_fp_save(&vcpu->arch.guest_context,
+				     vcpu->arch.isa);
+	kvm_riscv_vcpu_host_fp_restore(&vcpu->arch.host_context);
+
 	csr_write(CSR_HGATP, 0);
 
 	csr->vsstatus = csr_read(CSR_VSSTATUS);
diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
index 68d461729fd2..cc81891c66d4 100644
--- a/arch/riscv/kvm/vcpu_switch.S
+++ b/arch/riscv/kvm/vcpu_switch.S
@@ -225,3 +225,177 @@ ENTRY(__kvm_riscv_unpriv_trap)
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

