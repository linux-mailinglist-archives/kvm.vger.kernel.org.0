Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F9F257956
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 14:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgHaMeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 08:34:24 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:45740 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbgHaMbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 08:31:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598877106; x=1630413106;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=8B6bTRzKI42nkyG5exSG2i22j+cKFNLVAfDr3Qb6J0I=;
  b=KtTu9KaZfrjvo3d71KcCDGzsq7F67Y7ZknwNm4pDqnA1xgUR7dO9xYmD
   gi9GXBUG/YtEv8jik49T2HTyS2ZP8QDf5liqRM/d5HKEdf6D89ChjMRXT
   a2QEu7+6O/mazD5OAvRgmh4SW/XVRsUMwvyS8GL5rss18c9fmdqhzdkBP
   rr7LDaZO664ZBTUXqXYb3z5EK8KY4TLLWPZnZ19IJbuZ3vPZdXgz3bplj
   Er07Us/TOVPveDiL/cQBbEohriCnYzaTL0FTysq38tUKCL83cTBKeXt0n
   gZJdQDQcwHpvuYPyRRDQcAc7Xii5A5sAo6E6L6I5zmHFkK7ayl6VfwyoN
   w==;
IronPort-SDR: wn34dTHH5PpYJPxkYLaMtNWPUsff0eyfPHC61kMcv1cXJ+2DIu0P47REfM01hqnjIQl8+xjouo
 xzLA+JuUztOBSUXFe20dhuVeA2Hpk8XRJKYedq9o68bBFCLFIF4KOnFMwiGog+Sn/2ToWIe53W
 wIiRo8QrsjZ6eNko3D1BBOIbzcZViF/3WcCbOg9SAUancZWQjN+gFVpk8Qyjs2rTBTPWNLLFAS
 FXh1WoUhDF4gKrLHsyZ8qAZmeqG7ZyAUwxOgyQD3FKhG2RnC+i9NP+McIIt3WNPK3S1qZUotEZ
 Bok=
X-IronPort-AV: E=Sophos;i="5.76,375,1592841600"; 
   d="scan'208";a="255743396"
Received: from mail-sn1nam02lp2050.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.50])
  by ob1.hgst.iphmx.com with ESMTP; 31 Aug 2020 20:31:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvI3gG4w5aGLl1VdzmyQiKP78VcIq1O2XEEVFjAu7EV8yF9e62orJ+PKrc9d4eGnWMtz0FRTsFnunpi0GeqQGA/sxTRqvmGaRZ5A0PnlFZGd57N74nJy9zGa9ByLrTGxBhoKsFrbscTwiue9ctH1MCeTtNRYO63++lM0vl1XMKXgPNglo6GLexi0ulSXN+EfCpO268HGcM5RzjG/MlInfeEFYiwENDGjh3ZRBhbXIKvBKMM/svhS3nHcc1YsDV/l7gFbdNoY7Jnewe9fvtTeXukUH+SsTXm1VjlxvR8lZwGxxWuNL+vGy4MRjW/fXfbG5guxo3g1XsS0JYLoOJWNpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mmcJ93UlDPmB3s6ExKNAd+jV2GoiWwklLHNyBhuPNk=;
 b=QvCzCKlK6BCmQ5Iwz+LL8MdrTrNlm4SdjuSdYWIxrQCM6Kur3xzzPv8JyysCdmBFXo1k3bzAktE9oDpWL7xfk0JcXVSxqRl8PsF1HXHwDtgbuUi7GpeKMj6ZHpVBY4B6N6UYzZeEqUntYxZZx1gERhtKi3zKFSDkevCiz47a7ZN7OrRI3PPERqdA9SXQBDSKgtnZ0lf8oMhJdaUai8sqh1CmUdeqAA/DPgFSMMOvNeKxRAAU5LPk+rmcQfLHKwGuvoS/8M1RxoVmvgk9iHYZqmLPDWJfhk6eX5Qj95UomztN8m4x9VWfXa4pGmzngE6JxBrsd6wdQLUN4MRS33+Xgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mmcJ93UlDPmB3s6ExKNAd+jV2GoiWwklLHNyBhuPNk=;
 b=MGw2VpnVnDf9UPgiGdU4Jdx4H6X0Bz51FiiYj08gVRzJqFG1EfaXzIIZgrCRYvEiOxp+ZRHcma68okWFzZgRvelauMCSNxCSyfjzeVXR+E9tq3ZAl7FC1Y68o0aQdr89eZ5+9dbwHRMLHKQq2ABAX3RJv+UIbQClorU+AvJ21u4=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6092.namprd04.prod.outlook.com (2603:10b6:5:12b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Mon, 31 Aug
 2020 12:31:44 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e%7]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 12:31:44 +0000
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
Subject: [PATCH v14 13/17] RISC-V: KVM: FP lazy save/restore
Date:   Mon, 31 Aug 2020 18:00:11 +0530
Message-Id: <20200831123015.336047-14-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831123015.336047-1-anup.patel@wdc.com>
References: <20200831123015.336047-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BM1PR0101CA0046.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:1a::32) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BM1PR0101CA0046.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:1a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 12:31:40 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.192]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 073781d4-0b25-42f4-8112-08d84da9d225
X-MS-TrafficTypeDiagnostic: DM6PR04MB6092:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB609207DC91C5AB450E8EE0728D510@DM6PR04MB6092.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bf7NAVmnUDq6sTQyz9RN3DYsnvX7N3q+vWbYuhX8h3qdpRAKNJFe8ZwMcG+GOWaTpfnH30VRbihI5Eo+pgqWiH4L2ExF0ynw19MArMJmVcEYRejz4rg2l3KbMN5iME83gkxf1SEVCzcgoDZg2h0wrHvzt6f6YLDBWaO9hp2wumxeGO8G3KKqiWUH7kGax3xSkBPZIZBWSe9m8rqk8q/7FvVZmTTOqTBl3022g8IjKnpCTnMnjSkVYYChnsJw1NnG7IgJDGGzkg5FXVGApA9Hfy5hWEF6ShIiYKjYR1ZIUF9Q4BmLEnyjrW7rCM9rts0uWkTnVCpP/KMsudTTsJ1hXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(44832011)(6666004)(52116002)(8676002)(86362001)(36756003)(478600001)(6486002)(7416002)(30864003)(110136005)(8936002)(54906003)(83380400001)(66946007)(1076003)(66556008)(2906002)(26005)(186003)(66476007)(956004)(316002)(16576012)(4326008)(5660300002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: CexP2qZO8QUPhCOW5ipWIQ93XgdqHGtBFEWArw5RBPkLWvRjnBELP3K6kpKUuqjIB5iVTUGxXnq8jCjGQ0eAD6azZvxhB1RuRT4BT1+kZ/7v6M/ARCt0uRl/i8HKAr7JWo5N/ALE3UWo4PKn3gFqxMaO4+TAgWs8A787caCJ+Mt5XmwyKQwRws36yEZ/PJhZ12dx+oASQYkhGsCYMMtQeu8QVoTw8J0TnWXNMrHJSJO9QOrEnr6/qEbGCRQ5vYHcfZhx3r5nXpgwjFalWJrLsIajE582mfIEUCuaP4zfafo8yvacJNO6EYT2saDwDfzSXWo42e+9lny0GvItRmUu1HN5kRgL8W8ADNcbfV7dH/1Lslg9QB7t57Er+QzC++bePfISiEc/0ETdDu/KBj1UhuDZho1XURteUYRDj71TnUv6gnDktUOoA5zoBDYf8IRKsaMSLs/iugvncsq+am7gLKXIUyaeLW2ODI9NAQm8+oahe/1r9k/4C1Enpbl6fOpWfc1/0BktWqm/CLStxewiO9q5sfladpbWUEv6/cLoQgM2owFKETQKLi43Gmd2bxHCz4i2wb6PpG/e/3c6psq3zBuwsmwiKSkwfoekmtt7+kKyziK6ryOsyZAOrcB+jX1c7TcR/MphJrizPnkJLCiKAg==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 073781d4-0b25-42f4-8112-08d84da9d225
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 12:31:44.7177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6eJKU7+Hb0T8+FphBOTzqiNOUkfO1enRnj5o8DGA+zPdwiLK0UP9KdilF3X+2TRwTCSznbNcfwEFdZeuf8aTFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6092
Sender: kvm-owner@vger.kernel.org
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
index cde94c0239d6..63fbcea8bc70 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -190,6 +190,78 @@ void asm_offsets(void)
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

