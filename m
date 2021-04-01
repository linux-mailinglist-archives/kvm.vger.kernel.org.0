Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3D0351B4A
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236570AbhDASH0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:07:26 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:63053 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235935AbhDASB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 14:01:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617300120; x=1648836120;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=LKQso+P3munqI2+F0S/hLt4BLGVSp0LzQJP5O8ehvQE=;
  b=nrl2EfUA6k3OyIZtcKFBSXtvzkNzegxiGk0YspEiXQX0ezUEx6wY4TV5
   vYLoH+yjkxvZN97evmu3q5tIzZo2Rq5fPPWbwNPZvmIlDVt5/Yd2qFEs2
   a9Rlzt+OvWxxQVVhK+oS2bCBBPwdNROA4nLViM49/NpToVasZ/Cm8efJz
   X+Mu1PhTe2i37hZtSrF7gK83cW5q9Tqc1w0FvZLGoLGvkRIB/aNtEmvoa
   UDcBmLi368JcfMNqhj7wwx4yGShZ7akdJR6QLeCwLOqzf0VXCAXQUTpRW
   e1pPI1cFESwZdiy2xgzIgMoW3l3mMpr9qHDFuJRqK38nulLc53BiVXZjR
   g==;
IronPort-SDR: daqZM6fbD20GWChD+QQ3CNEZNBfbBCDcJE7w0+nlYYRVZwSVwi4qQE+UwCxcTVyawDdi6aTBy5
 iTUZNDGzmiXTI7fC4ElQWgi6fOHy1PhgaHEueo58Wpd0bjlGsmwrcNX5blD1L7ymgsfeSneLQU
 sLon8Xl57mOwudkEOF5AR6gHsRkfdu9S2UEWQ6gubK2f89HrQLgWVCY0tdhK150so64lQxhwP8
 9rltmTGfu6W6aUZYvW8faHj9Lvae2SajwWB9T0LXpbSzThp6D+9tEtG/cYaxznrdrtwoXEvhlW
 28I=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="163447564"
Received: from mail-co1nam11lp2177.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.177])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:38:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H6MzvMtyhLvu8rAYgKusgDTdUabZyf/jVu0WMPX6lYkD6XrXPWjtCxGX31UFiBEhzeiRnMvOwu9m54F3gYY94pz7g6Il9vb2U9V3rpqVzeaFiquViRGA4PeWNskhhffvdTTT1Wti72R0riFpOLScWtjMLKaraB17q5O1ppfnGGZ3mLMe0kJCJyBdr/58iWlFAj5fStWEKbj6S8HDMIT9kNsaLWZXI6t047qnhld1MIcaXuvUqLL5bwkEQF0YGp6rOXVF9g4dVAmExkgjkBrzeV+qk9d4uy9pIFbDLd2pQwqL2HzzTtQt2Ol56AuRK5QNLOaR2Z/t75lmfADSHZX7Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTxl2SuRO+qGTprND4NHsyjTPrezNAUnzftRwohlM0I=;
 b=koYC7DsWYRkp0CSNp4f15nFk93UuNwqOFtfBWaELEUfIbzVMVHJDFOm4IKYkAlMDHg44PH0qiiiIwjZaQRhhz6BTN1WUR12oYz7L5nj5uz7OpTlZAbqDXStL7Ik3kyDGwRsyjacsNGXKPIaXtmlFHxGzAxH+TBWi43Cl2CdGm+mQu5iZMOoQ5/oI4vsQerYp8J08xTbWWI+TWN8ITXfpd0CoLFmNUYjuyKdmMn9MxXisFE7dMoTsdcoy9G3gCYyGYkpDzIVGkamQRayl+5HHel2lek/6diTbLwGycy1ENNo43rKuwMBw1QOw2X4Inl4gBuF7QBo+92XLyabNeHRnyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTxl2SuRO+qGTprND4NHsyjTPrezNAUnzftRwohlM0I=;
 b=Y0sd150ALKcd/ZxHa4Mc/rLIM7mi9J/va5IbP27Eqa8+h55T2/6QHRxOheAaLRJEE0hpEqSAWghboQl6ItzY18t/YEGcbp0h9h53dIZks0MuUcIGDa0P/ehxfUKRGJ/EGK+Oi/FK94igHN/dK7/MFi1WDSO9oBf60OnSJ82V4Ak=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6528.namprd04.prod.outlook.com (2603:10b6:5:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 1 Apr
 2021 13:38:34 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:38:34 +0000
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
Subject: [PATCH v17 13/17] RISC-V: KVM: FP lazy save/restore
Date:   Thu,  1 Apr 2021 19:04:31 +0530
Message-Id: <20210401133435.383959-14-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210401133435.383959-1-anup.patel@wdc.com>
References: <20210401133435.383959-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.112.210]
X-ClientProxiedBy: MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::20) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.112.210) by MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 13:38:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44b987a9-49b7-412b-aeb3-08d8f5137242
X-MS-TrafficTypeDiagnostic: DM6PR04MB6528:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB6528077EEB31A7C0B95612128D7B9@DM6PR04MB6528.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gnc5WillHqTNimAmWMRXbqdk1TvR627qJHAHr75y6aE8QuU7HEgQCSM3WCNnHxQjbCDNAU8uZFFh6KH9IDWNFtTeLNb/Wjbu5lPqEy5pU5/gQn0slmz4/EnfPuaTwLWe2ZX3nrAdOu1r0/Z1v6bcWXdf8x02DYE59IUjxJxuJCI29RfxBzZMOKu6XAaoYe4Ml7u8+ZP09tVS+OWJW3rPMILDb2CdeTxHT+LKQhFRSJeuLUukyTiMTAscKu2F17LeJxbhKMeS+Ap6GAjNeYo3ZO0XtVfZ6RBTN4oulAVg2KdOgdA5yhK0DuRgtJGLEsrnTniYt2jn4/FjoqyEl6hizKBVnk2YB686WrlqSvhR4+A57rB3qBQkYoViOsKlZdosnvCMteGHiYb0RVKWNThXr3I+vpzxk0dNhFMPDFymXPAFXVD2Zw3tS8PEfiMRskuDgjClecFM/3yJosA7QcMiwJ0xq/2r4PkdnvaAXEEvuPSpSrke23BRAJUY2fhc6GGLOmBNZB+g9H8vt7jw/T/6BbXGYllj1Uq5bCr6ftUP4Rdw1ZZK6emkGrXDE9qp0wmx7U6pou3tWoosdlyGip5fgXvWe1G4caN1V5Z27pb7izpjzAsPJ0Gd7wDMCSViCMwwcfRU/6lJZKrW4ylmB1rG9KnFam0qPPvbPs/uSqru9rk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(8886007)(16526019)(36756003)(186003)(4326008)(956004)(2616005)(6666004)(316002)(66556008)(478600001)(26005)(66476007)(2906002)(54906003)(7416002)(1076003)(8936002)(55016002)(86362001)(83380400001)(8676002)(52116002)(110136005)(7696005)(5660300002)(38100700001)(30864003)(44832011)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?g1l471LxF+gK0aJyZ+zRkpGqKEs+oaQmseT2JusJnDMrJmQo1AgqF0hp5EsU?=
 =?us-ascii?Q?qliy/F10nTL9Hz0bvCtfJg3ypxX+IZ+X5qnDcVJmjOfZGInYFqlFAOAQPsSQ?=
 =?us-ascii?Q?JidQVR2YxADzP+gkAReAuhZRScqaldQ4kasjIMqjiQ0CVQuJ/FGMNThtP8yW?=
 =?us-ascii?Q?t8qXmj+GotNqNAE2e3TBH5hJOoLwOTFsHxJ49mnCSiW0wreUmXxtfEoS1Pwb?=
 =?us-ascii?Q?l1t0a6b4sPV7EEX2OJUghOxyJTVMyDnmHRvpoUfpryQJ2h0IklXeklZd70fj?=
 =?us-ascii?Q?ZuXc0XhRnFNGWKONfkhAVSo/cxw7Hn9OvXUX4OaSR0r1u1VltcrxJB11jJCa?=
 =?us-ascii?Q?bUv4d807luLtOoV0lB4PZ+NwUN/oPP5YiG9u1IGe+pnlgYeS6fo0k0uKrCyK?=
 =?us-ascii?Q?5HhuU0KzkXkxHX5eh6ubgdHO4VPECqIVITTMMFufQEJTBGMMTVLym1+pUiDy?=
 =?us-ascii?Q?FkxedIozfpD5doWy7kj/LIKF79bPP2ebGNza/YHVwxi4ACZp3Cgl7haK5idx?=
 =?us-ascii?Q?0z8j+6MOMCWxM1MwXuxRinDW7YgAupArqAa3bVYbYn7ELrNsgQFTWWxCS7DX?=
 =?us-ascii?Q?4LEO8fGPdTUQfgVgN04fW1vjVlPvUZYlwBsxsc2qrwuYtXHUaqvb0y1xfETc?=
 =?us-ascii?Q?tNhVrmSPIe4hV/erQ8azNWKwwPvvgm7qz9evKc3e+shYafkHAPmtZuUmdLLF?=
 =?us-ascii?Q?Y8f+14L8lqJYXvzuIv4gNbDuc+z5wdZ5IvsY/zbM8gsIFKN8KB+hZUZ+0reU?=
 =?us-ascii?Q?rDvLU/5mK0V3T4NssM9CmjVz/cX8/s20tosw93FQZ6DwMhcNYAkEKONBR4IY?=
 =?us-ascii?Q?iKNAgrQDJxVvgbSKXVFtSJ+cLTjXtQ0U+tsAUmRZw2k2Dk79LVtTVVXkPfXI?=
 =?us-ascii?Q?UkHkwGo0maH/C295b6N/Zg/Y5535ggD6HpJyShi2h+YVVXtZBeydTxNvHzzo?=
 =?us-ascii?Q?lipLr6mM1j6iV5JXy9yU5VIOuGlRlLjjoM4cs627Tq0rwJtxHyu7qjdFx71V?=
 =?us-ascii?Q?P1iyiv/52qsoWZIg97yrAxkefuks9Bu9+cotNSApDxffX9cHvKbarYCcIWes?=
 =?us-ascii?Q?o/9bxUSfKVy5h8ppCNqKkAIh8lrxZ7RAPUkyjR2YynB6XqzARDC5rl4OcuKH?=
 =?us-ascii?Q?PbTxVKZmbTQeYtKqfTReWQyF7pMUk1QtWw+zq+nk17vMvRecYPLTou2+OmAb?=
 =?us-ascii?Q?BmsIxvZ5kDz1XU7t8c0qRYy9++VepCkjirA2X/PUp1w5wuIVhlH1TEMPTn2a?=
 =?us-ascii?Q?N+AQRoG7xiwBZnEYgyW2JGLDXGPXvDNvzpvupIzcwN7z6jCe03KG+39fbLWK?=
 =?us-ascii?Q?OktImi8tjbbL/qq7GHgXvJJnDrNpqLdZi0JV5UTWLDhiog=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44b987a9-49b7-412b-aeb3-08d8f5137242
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:38:34.4540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jEGbUmMM8qs7FKlzs5r2ln6b/vMrpdu/z/Ue2LzAk8J8l3tGv9+YUq3MPAyE89oJLRNjCxyFnB1MoLZPc8UwtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6528
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
index 20308046d5df..c6e717087a25 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -130,6 +130,7 @@ struct kvm_cpu_context {
 	unsigned long sepc;
 	unsigned long sstatus;
 	unsigned long hstatus;
+	union __riscv_fp_state fp;
 };
 
 struct kvm_vcpu_csr {
@@ -250,6 +251,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			struct kvm_cpu_trap *trap);
 
 void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch);
+void __kvm_riscv_fp_f_save(struct kvm_cpu_context *context);
+void __kvm_riscv_fp_f_restore(struct kvm_cpu_context *context);
+void __kvm_riscv_fp_d_save(struct kvm_cpu_context *context);
+void __kvm_riscv_fp_d_restore(struct kvm_cpu_context *context);
 
 int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
 int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index 21e7cf76948d..c7252b76d3af 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -195,6 +195,78 @@ void asm_offsets(void)
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
index e242431dca66..581fa55f7232 100644
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
index e22721e1b892..029a28a195c6 100644
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

