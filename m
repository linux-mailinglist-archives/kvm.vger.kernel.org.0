Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6238388585
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 05:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353168AbhESDi7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 23:38:59 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:13988 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353063AbhESDii (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 23:38:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621395442; x=1652931442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=rLBC/NuLFehCYfxeYSjutLacWd2LtOc2WW/ph5EurNs=;
  b=px0miMBzRg9xoRM27QdTkG27KgFrF/Vch6vSKIByzCwrCLaweAzus+Zm
   yDrozpRQKQBQOQf9Qj0fooqK6AZEe0j1n3T61I7HkUmYtCIG9cOYr3f12
   2vPSd/Au1VzDILkDF+PfjnGKznWpc9jj7RbAJZ/omQDANgEMfD4bLPYhn
   ZJW2Gw0pvyuHBG/W0wj/n4ddZtC/Q2K28TfaZxxF//CGYMIfgsMvgGigK
   pQWPetOdvuS3WAWErBdMCMwOAqo9L3do5blB+mHZr7TVhyAd333fVG6CN
   nnjU6vLswe2dtRIro5R2syfCW8E3J9Hl3Nekh4QYFU5sLt0d45N29uYzu
   A==;
IronPort-SDR: dHzSLJUOxkqd+XsiF+LxODCXP9DTY3Tyn/yYiIZQkSJvqZ9hoqHuaTwvd08HV+wxyDAK+uzRGL
 OUdKwQ5Xh9YEN2xL298yWi+7I7qTZddV/n1k2t2+/evm7R2DIYbQoT5S0PRJl8qichGcEhxv5R
 MHfTFjEcTSZYXYcPWJ84WVuZ55DQqQMZNwOCI8nTS051cAAoxMkXSLbBt6GRypSUDOit4cEwqQ
 NvJfypkQv1Nn/FrC+kXJR7cHBMT2wSfMU4olcqop+ci8Zs/BIsTmfe7tlhJb+gY3QDEtdQeHi6
 Fk4=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; 
   d="scan'208";a="272597314"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 11:37:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RH9Ka7DYrx7tDfJsXlLpTPB33cJjy5VeeCmITwSyct0XnDXyMLYb+oN4llJGuOI2AAasfLA7uIZSeNFN0uN/rtPz6LUMtm2f3Mpn67JAqtVdAuYHFYjasbE3eccb+zv2yF5JsPLfTawFrYBDfTI4mjs3+/0yoYt5E4gnYpnULjIQJFvl8RgbxPldJHd2YIBCijwvFxLAD735Y2SE4R3sdDtJdcui9h7gyVXuGtakUFPo/D97zeVuo/j+FNslzCCeuPT/8MiiPngkrOMfMZ/i9N2ugQTxqJ/vew97/EehT2fDIIUld2JuY6VcrsL+v1ij1Ys2TWEIJv+835Gdteaphw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQ8x2cl33YzZYT+DxooqykRyCsQ5RQJiykNjTXBZEYU=;
 b=NfRY6+VkXovCFhY6quYlxFMsvNUGA1SbkJVPtGZy2/Bq8FfkPwek+c1KO6T0gsvl4q1/noqcqUcU8OWJg/UX1M3FlN+LX6xj5eED5RSE/VjtMDhyYsmCgWc12jznCtwvIww4FpPw9tXGTbgHCfvO4OnOY7ofjEvV7yydUxTLXzo+FJ6oKlkk+ejJ7nsw3s2UBCL89uxBzEUVRDttt3/MKe6Avcl/Dz86KOQuivbK3PBw+bMn+kVqVLZhdpLKoyQL000JvH0KODyGVbvlTsRGZgSLxT+NonB0StmLQJvTnFXcvNGg4DYMal2cj4sD821IOJJH2MukFzTXzOvNMF5ogQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQ8x2cl33YzZYT+DxooqykRyCsQ5RQJiykNjTXBZEYU=;
 b=sjg+9+VDPpO1gr3cO1EkVn6Gu3yLho89kd9Cv4NT6W/m1WiMxwx6k0DZvgo+H04NGvB1yLNZ9YAP9yYwE9aXsZBWzsE+XWfLrP/vbWBRX/qAoKA/soJ/yaNq0ttQou5rsz9ZemJHSqelQPeC0Q/cMGVgd13Mu9LjI+ODq68+3tk=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7761.namprd04.prod.outlook.com (2603:10b6:5:35f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 19 May
 2021 03:37:17 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50%4]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 03:37:17 +0000
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
        linux-staging@lists.linux.dev, Anup Patel <anup.patel@wdc.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH v18 12/18] RISC-V: KVM: Add timer functionality
Date:   Wed, 19 May 2021 09:05:47 +0530
Message-Id: <20210519033553.1110536-13-anup.patel@wdc.com>
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
Received: from wdc.com (122.179.32.148) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 03:37:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d82c1100-cf42-4ac6-9c19-08d91a77666d
X-MS-TrafficTypeDiagnostic: CO6PR04MB7761:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB7761C8B658A2D34C0516EBED8D2B9@CO6PR04MB7761.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:862;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VOQSqlmVLZBvXwrdeh2ZGDotZs4esnrpSffDgS9PLc8HaBF5pW/EYQCl9jcjwvC4v9/LSUItE0E2PaAThKblfff3s8N3cCXHe8tX4vgI+xl8/p/H5aOBftP8La6fMzFDoEweVzmsbayKf2jiqQ9Vp9NW00ppXgdJA4zU45n8ie0LXj1qhEgJAOwq6If/Q+ldHRloTXx/3t0Ddh7ja87q82A7547MMkSlwqnjqGIbZ5Kvslz7VRkmFRlMlKsb0v53o6uXHDqMZfwmTg6DEpd4Nna+MUCrCyS/tXWV4SKP6NIc/cbdYMRZ3OR6CRCpEZAhZrXf5iAoDt4PnKIMgqxWYuL64LROfH0ZkJdoDMo6H98ng9cVsmeuZg9unAEx8EGmwc5LDRynYfutnUQnoak6n+huDFPpwgDBSRLO5MNV35dLr6UQMSua0kt5bqq1j7FzD9ohQdFSWY5++pAAmUn756jf5WSTfEFGSJbKA3kjqtfe3T3IWEzcBLYhvZ7x35dxlztuYBpGsMAPgPatLWqmalp6UE28dR9ldvpfeaJCX4+N6YlAM23jV4O0Ql58GDk/is3mKgo3SxnKPpQfaGwyNqUiYrJZAWlot0oHTHufZUzetMBQaLBugg+cJ8d/7FA22U4Hr2ZOstWQZRygZxZ9Pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(316002)(38350700002)(55016002)(38100700002)(66476007)(66946007)(1076003)(2616005)(186003)(5660300002)(4326008)(26005)(8936002)(478600001)(86362001)(2906002)(52116002)(7696005)(16526019)(110136005)(83380400001)(8676002)(6666004)(66556008)(36756003)(30864003)(7416002)(956004)(54906003)(44832011)(8886007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uxiMcDug6ET9NKBxdfOgG5EzLgqk+1NtgG6xzmkV1kfIfW/B4G2OB/KJezpW?=
 =?us-ascii?Q?g8q2/Z9Fmo+6jDNZpdu1AAHk5jX4zMtOV3pp0ZBB0PVgWKwryhhTwXm7YPFB?=
 =?us-ascii?Q?WnmK1o1/CmlxDyKQ6yvYhs/RicveKT9W0JsW1VDUVh7Mx4IL8dj8Evr3amKw?=
 =?us-ascii?Q?7dvrQxY7o1NjjWubMczkMn1CzJi9BAgoTxfIHNO1Og8mEOQvpEVQAJ8aNnDk?=
 =?us-ascii?Q?+7ZPzybMeC9oUUmzUWsOIf4+XErY8z4gOd4wmm6Y7j/8pxT2gzPYm1p6YXLD?=
 =?us-ascii?Q?G6ci6eigbTLkdFOGIjvsh6vbu8Kb7TAkbkehP41hNeFDVXCQXvGlB5piHYbT?=
 =?us-ascii?Q?UhpTMrENrwc+2ZFmagy5oCmsZ5MNhNh1utFf9dxBZRIyFAqjekGkeaY4AxzX?=
 =?us-ascii?Q?zT8XdY+VEJiQElD5QWMZKJZfD5zzX6nIqEOXcW9MCl9JxPKVehOr0bYnI6xt?=
 =?us-ascii?Q?uFbGH9bVawpUdeXkGgIDYyIH+g8fXBCK69vdxFoNGFqesemvLZy6GKfhau28?=
 =?us-ascii?Q?c9mkHM8E0pDKZH1fNl5gum2nOxJa1lrj2Y+rkFEUiLdEROn/hX20oIsZfgqd?=
 =?us-ascii?Q?vTZheTuUcHdy9TS+9sjJmoZlDiGNo/BJmci68zyBmb28V+Jne8+hCQM1fcaS?=
 =?us-ascii?Q?v+4KHmlPmmcouOdDaSWbhl4qIvj/Ph2oD3i5n4JxdQ7eWPQuluWv76M2rwoG?=
 =?us-ascii?Q?uuCNpbFNxLEnwC2upp375i9qs+Qugo6eL6nAc5VtpzTwgb3edpujw+kXVHki?=
 =?us-ascii?Q?A4pOVmggaR3+0BY34XQ4UrMa0WXKs6xkmXmjYz5czlwJwcSRGwJcKFxvSjq8?=
 =?us-ascii?Q?Mrr5KdM/+gFvghUBhVrMNoEG2ezflvMNCWGyVgocOCy8vDZvplWUEs/OpQPi?=
 =?us-ascii?Q?ESFf/p2UOcFRv1+yBka1Re8DYyV1wuhqnl+VtV++2rDxrBjFU2zV2Z6/iLUL?=
 =?us-ascii?Q?bX4zdh269aP9V6W7XgpjVlMMDGa6VcTWyd2mPen+NtUnBClR0gn5otLLGPKR?=
 =?us-ascii?Q?KxNjopv0hFK5woWtKfRaXcK37VNFA21LSKEo8StlxEFHWZLkgPAjftp64RbA?=
 =?us-ascii?Q?s6Me1JyAFeJvV+oNfiSjBKleRuJf7l9Cb8gGJffteggEVumuEZ6z61MXvvNG?=
 =?us-ascii?Q?3suVOkgmawOtium2Py9eViYoNHSFQJRNSq0KchlqTebmkxWEr8dFfqJiM30n?=
 =?us-ascii?Q?wUVHMJfPpacl4CXD7Psk123vpA+krJW21ADMpQBCCmsXnfCVXUTS3R2rI59B?=
 =?us-ascii?Q?XXr6vSIC0vsZ4kWdi3gvdjrPil9Dd4m95A6jnVUTe1Kiud5v2DkITk9VG2EF?=
 =?us-ascii?Q?VXXn0k23LwrkA45Iu1wfWwX8?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d82c1100-cf42-4ac6-9c19-08d91a77666d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 03:37:17.3039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X0MgV2gwb/dbqEpfqjyuQyu+XD0+645VA3JPTbbKFMDSh5LJm/XhCN84YXcu0qASvpxfpWLR9cGRo8cO5rV4lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7761
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

The RISC-V hypervisor specification doesn't have any virtual timer
feature.

Due to this, the guest VCPU timer will be programmed via SBI calls.
The host will use a separate hrtimer event for each guest VCPU to
provide timer functionality. We inject a virtual timer interrupt to
the guest VCPU whenever the guest VCPU hrtimer event expires.

This patch adds guest VCPU timer implementation along with ONE_REG
interface to access VCPU timer state from user space.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/riscv/include/asm/kvm_host.h       |   7 +
 arch/riscv/include/asm/kvm_vcpu_timer.h |  44 +++++
 arch/riscv/include/uapi/asm/kvm.h       |  17 ++
 arch/riscv/kvm/Makefile                 |   2 +-
 arch/riscv/kvm/vcpu.c                   |  14 ++
 arch/riscv/kvm/vcpu_timer.c             | 225 ++++++++++++++++++++++++
 arch/riscv/kvm/vm.c                     |   2 +-
 drivers/clocksource/timer-riscv.c       |   9 +
 include/clocksource/timer-riscv.h       |  16 ++
 9 files changed, 334 insertions(+), 2 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
 create mode 100644 arch/riscv/kvm/vcpu_timer.c
 create mode 100644 include/clocksource/timer-riscv.h

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 51fe663b5093..0134201afb8c 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/kvm.h>
 #include <linux/kvm_types.h>
+#include <asm/kvm_vcpu_timer.h>
 
 #ifdef CONFIG_64BIT
 #define KVM_MAX_VCPUS			(1U << 16)
@@ -65,6 +66,9 @@ struct kvm_arch {
 	/* stage2 page table */
 	pgd_t *pgd;
 	phys_addr_t pgd_phys;
+
+	/* Guest Timer */
+	struct kvm_guest_timer timer;
 };
 
 struct kvm_mmio_decode {
@@ -180,6 +184,9 @@ struct kvm_vcpu_arch {
 	unsigned long irqs_pending;
 	unsigned long irqs_pending_mask;
 
+	/* VCPU Timer */
+	struct kvm_vcpu_timer timer;
+
 	/* MMIO instruction details */
 	struct kvm_mmio_decode mmio_decode;
 
diff --git a/arch/riscv/include/asm/kvm_vcpu_timer.h b/arch/riscv/include/asm/kvm_vcpu_timer.h
new file mode 100644
index 000000000000..375281eb49e0
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vcpu_timer.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *	Atish Patra <atish.patra@wdc.com>
+ */
+
+#ifndef __KVM_VCPU_RISCV_TIMER_H
+#define __KVM_VCPU_RISCV_TIMER_H
+
+#include <linux/hrtimer.h>
+
+struct kvm_guest_timer {
+	/* Mult & Shift values to get nanoseconds from cycles */
+	u32 nsec_mult;
+	u32 nsec_shift;
+	/* Time delta value */
+	u64 time_delta;
+};
+
+struct kvm_vcpu_timer {
+	/* Flag for whether init is done */
+	bool init_done;
+	/* Flag for whether timer event is configured */
+	bool next_set;
+	/* Next timer event cycles */
+	u64 next_cycles;
+	/* Underlying hrtimer instance */
+	struct hrtimer hrt;
+};
+
+int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles);
+int kvm_riscv_vcpu_get_reg_timer(struct kvm_vcpu *vcpu,
+				 const struct kvm_one_reg *reg);
+int kvm_riscv_vcpu_set_reg_timer(struct kvm_vcpu *vcpu,
+				 const struct kvm_one_reg *reg);
+int kvm_riscv_vcpu_timer_init(struct kvm_vcpu *vcpu);
+int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu);
+int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu);
+int kvm_riscv_guest_timer_init(struct kvm *kvm);
+
+#endif
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index f7e9dc388d54..08691dd27bcf 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -74,6 +74,18 @@ struct kvm_riscv_csr {
 	unsigned long scounteren;
 };
 
+/* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_timer {
+	__u64 frequency;
+	__u64 time;
+	__u64 compare;
+	__u64 state;
+};
+
+/* Possible states for kvm_riscv_timer */
+#define KVM_RISCV_TIMER_STATE_OFF	0
+#define KVM_RISCV_TIMER_STATE_ON	1
+
 #define KVM_REG_SIZE(id)		\
 	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
 
@@ -96,6 +108,11 @@ struct kvm_riscv_csr {
 #define KVM_REG_RISCV_CSR_REG(name)	\
 		(offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
 
+/* Timer registers are mapped as type 4 */
+#define KVM_REG_RISCV_TIMER		(0x04 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_TIMER_REG(name)	\
+		(offsetof(struct kvm_riscv_timer, name) / sizeof(__u64))
+
 #endif
 
 #endif /* __LINUX_KVM_RISCV_H */
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 98b294cbd96d..4f90443ab1ef 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -10,7 +10,7 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
 kvm-objs := $(common-objs-y)
 
 kvm-objs += main.o vm.o vmid.o tlb.o mmu.o
-kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o
+kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index cbaf14502c25..b6f19ca35562 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -55,6 +55,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
 
+	kvm_riscv_vcpu_timer_reset(vcpu);
+
 	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
 	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
 }
@@ -82,6 +84,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	cntx->hstatus |= HSTATUS_SPVP;
 	cntx->hstatus |= HSTATUS_SPV;
 
+	/* Setup VCPU timer */
+	kvm_riscv_vcpu_timer_init(vcpu);
+
 	/* Reset VCPU */
 	kvm_riscv_reset_vcpu(vcpu);
 
@@ -94,6 +99,9 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	/* Cleanup VCPU timer */
+	kvm_riscv_vcpu_timer_deinit(vcpu);
+
 	/* Flush the pages pre-allocated for Stage2 page table mappings */
 	kvm_riscv_stage2_flush_cache(vcpu);
 }
@@ -334,6 +342,8 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
 		return kvm_riscv_vcpu_set_reg_core(vcpu, reg);
 	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
 		return kvm_riscv_vcpu_set_reg_csr(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_TIMER)
+		return kvm_riscv_vcpu_set_reg_timer(vcpu, reg);
 
 	return -EINVAL;
 }
@@ -347,6 +357,8 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
 		return kvm_riscv_vcpu_get_reg_core(vcpu, reg);
 	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
 		return kvm_riscv_vcpu_get_reg_csr(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_TIMER)
+		return kvm_riscv_vcpu_get_reg_timer(vcpu, reg);
 
 	return -EINVAL;
 }
@@ -579,6 +591,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_riscv_stage2_update_hgatp(vcpu);
 
+	kvm_riscv_vcpu_timer_restore(vcpu);
+
 	vcpu->cpu = cpu;
 }
 
diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
new file mode 100644
index 000000000000..ca08c420bf0a
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -0,0 +1,225 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Atish Patra <atish.patra@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <linux/uaccess.h>
+#include <clocksource/timer-riscv.h>
+#include <asm/kvm_csr.h>
+#include <asm/delay.h>
+#include <asm/kvm_vcpu_timer.h>
+
+static u64 kvm_riscv_current_cycles(struct kvm_guest_timer *gt)
+{
+	return get_cycles64() + gt->time_delta;
+}
+
+static u64 kvm_riscv_delta_cycles2ns(u64 cycles,
+				     struct kvm_guest_timer *gt,
+				     struct kvm_vcpu_timer *t)
+{
+	unsigned long flags;
+	u64 cycles_now, cycles_delta, delta_ns;
+
+	local_irq_save(flags);
+	cycles_now = kvm_riscv_current_cycles(gt);
+	if (cycles_now < cycles)
+		cycles_delta = cycles - cycles_now;
+	else
+		cycles_delta = 0;
+	delta_ns = (cycles_delta * gt->nsec_mult) >> gt->nsec_shift;
+	local_irq_restore(flags);
+
+	return delta_ns;
+}
+
+static enum hrtimer_restart kvm_riscv_vcpu_hrtimer_expired(struct hrtimer *h)
+{
+	u64 delta_ns;
+	struct kvm_vcpu_timer *t = container_of(h, struct kvm_vcpu_timer, hrt);
+	struct kvm_vcpu *vcpu = container_of(t, struct kvm_vcpu, arch.timer);
+	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
+
+	if (kvm_riscv_current_cycles(gt) < t->next_cycles) {
+		delta_ns = kvm_riscv_delta_cycles2ns(t->next_cycles, gt, t);
+		hrtimer_forward_now(&t->hrt, ktime_set(0, delta_ns));
+		return HRTIMER_RESTART;
+	}
+
+	t->next_set = false;
+	kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_VS_TIMER);
+
+	return HRTIMER_NORESTART;
+}
+
+static int kvm_riscv_vcpu_timer_cancel(struct kvm_vcpu_timer *t)
+{
+	if (!t->init_done || !t->next_set)
+		return -EINVAL;
+
+	hrtimer_cancel(&t->hrt);
+	t->next_set = false;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles)
+{
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
+	u64 delta_ns;
+
+	if (!t->init_done)
+		return -EINVAL;
+
+	kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_TIMER);
+
+	delta_ns = kvm_riscv_delta_cycles2ns(ncycles, gt, t);
+	t->next_cycles = ncycles;
+	hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MODE_REL);
+	t->next_set = true;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_get_reg_timer(struct kvm_vcpu *vcpu,
+				 const struct kvm_one_reg *reg)
+{
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
+	u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_TIMER);
+	u64 reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(u64))
+		return -EINVAL;
+	if (reg_num >= sizeof(struct kvm_riscv_timer) / sizeof(u64))
+		return -EINVAL;
+
+	switch (reg_num) {
+	case KVM_REG_RISCV_TIMER_REG(frequency):
+		reg_val = riscv_timebase;
+		break;
+	case KVM_REG_RISCV_TIMER_REG(time):
+		reg_val = kvm_riscv_current_cycles(gt);
+		break;
+	case KVM_REG_RISCV_TIMER_REG(compare):
+		reg_val = t->next_cycles;
+		break;
+	case KVM_REG_RISCV_TIMER_REG(state):
+		reg_val = (t->next_set) ? KVM_RISCV_TIMER_STATE_ON :
+					  KVM_RISCV_TIMER_STATE_OFF;
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_set_reg_timer(struct kvm_vcpu *vcpu,
+				 const struct kvm_one_reg *reg)
+{
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
+	u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_TIMER);
+	u64 reg_val;
+	int ret = 0;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(u64))
+		return -EINVAL;
+	if (reg_num >= sizeof(struct kvm_riscv_timer) / sizeof(u64))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	switch (reg_num) {
+	case KVM_REG_RISCV_TIMER_REG(frequency):
+		ret = -EOPNOTSUPP;
+		break;
+	case KVM_REG_RISCV_TIMER_REG(time):
+		gt->time_delta = reg_val - get_cycles64();
+		break;
+	case KVM_REG_RISCV_TIMER_REG(compare):
+		t->next_cycles = reg_val;
+		break;
+	case KVM_REG_RISCV_TIMER_REG(state):
+		if (reg_val == KVM_RISCV_TIMER_STATE_ON)
+			ret = kvm_riscv_vcpu_timer_next_event(vcpu, reg_val);
+		else
+			ret = kvm_riscv_vcpu_timer_cancel(t);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	};
+
+	return ret;
+}
+
+int kvm_riscv_vcpu_timer_init(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+
+	if (t->init_done)
+		return -EINVAL;
+
+	hrtimer_init(&t->hrt, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	t->hrt.function = kvm_riscv_vcpu_hrtimer_expired;
+	t->init_done = true;
+	t->next_set = false;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	ret = kvm_riscv_vcpu_timer_cancel(&vcpu->arch.timer);
+	vcpu->arch.timer.init_done = false;
+
+	return ret;
+}
+
+int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu)
+{
+	return kvm_riscv_vcpu_timer_cancel(&vcpu->arch.timer);
+}
+
+void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
+{
+	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
+
+#ifdef CONFIG_64BIT
+	csr_write(CSR_HTIMEDELTA, gt->time_delta);
+#else
+	csr_write(CSR_HTIMEDELTA, (u32)(gt->time_delta));
+	csr_write(CSR_HTIMEDELTAH, (u32)(gt->time_delta >> 32));
+#endif
+}
+
+int kvm_riscv_guest_timer_init(struct kvm *kvm)
+{
+	struct kvm_guest_timer *gt = &kvm->arch.timer;
+
+	riscv_cs_get_mult_shift(&gt->nsec_mult, &gt->nsec_shift);
+	gt->time_delta = -get_cycles64();
+
+	return 0;
+}
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 00a1a88008be..253c45ee20f9 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -26,7 +26,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return r;
 	}
 
-	return 0;
+	return kvm_riscv_guest_timer_init(kvm);
 }
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index c51c5ed15aa7..1767f8bf2013 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -13,10 +13,12 @@
 #include <linux/delay.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
+#include <linux/module.h>
 #include <linux/sched_clock.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/interrupt.h>
 #include <linux/of_irq.h>
+#include <clocksource/timer-riscv.h>
 #include <asm/smp.h>
 #include <asm/sbi.h>
 #include <asm/timex.h>
@@ -79,6 +81,13 @@ static int riscv_timer_dying_cpu(unsigned int cpu)
 	return 0;
 }
 
+void riscv_cs_get_mult_shift(u32 *mult, u32 *shift)
+{
+	*mult = riscv_clocksource.mult;
+	*shift = riscv_clocksource.shift;
+}
+EXPORT_SYMBOL_GPL(riscv_cs_get_mult_shift);
+
 /* called directly from the low-level interrupt handler */
 static irqreturn_t riscv_timer_interrupt(int irq, void *dev_id)
 {
diff --git a/include/clocksource/timer-riscv.h b/include/clocksource/timer-riscv.h
new file mode 100644
index 000000000000..d7f455754e60
--- /dev/null
+++ b/include/clocksource/timer-riscv.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *	Atish Patra <atish.patra@wdc.com>
+ */
+
+#ifndef __TIMER_RISCV_H
+#define __TIMER_RISCV_H
+
+#include <linux/types.h>
+
+extern void riscv_cs_get_mult_shift(u32 *mult, u32 *shift);
+
+#endif
-- 
2.25.1

