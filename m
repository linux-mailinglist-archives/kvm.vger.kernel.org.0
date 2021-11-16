Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA1745299C
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 06:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbhKPF14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 00:27:56 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:41812 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233995AbhKPF0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 00:26:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637040190; x=1668576190;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=BQZ1Za9H9U0aUcvgBReFX+tUxwlb3hEC3mtu5JmRPXg=;
  b=jhXz1N15bOYp1ysouKDF00ioIMyDu1lrD4MlYo9NRbFcewQMJQCGCitA
   eLW6MlfnXLUaFILk/8GeqNuu1GsXA01EHd5bev9cp6dWVdRLLPPH1E47r
   BzibD5pATSR3+9VZO0tHhN4FJtG/b4RYNVivRev/uOG/i90n5QFHR94z1
   QxqW0ffPwPiS+wT+uIpAFuiJmYY0W7qVE4271NV/CiLWMXyfv2r8SMwrB
   YKsonnbCekC/Temad13kbmcrNYx5A8yvcdsFjnTNGSXkvETrJUr6+2cMu
   tlG236bThVlr0fNFCiEcVkPGXaUHSyrilwt1fsqpf/2FD/Bwq3hvt+Igc
   g==;
X-IronPort-AV: E=Sophos;i="5.87,237,1631548800"; 
   d="scan'208";a="289638126"
Received: from mail-bn8nam08lp2046.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.46])
  by ob1.hgst.iphmx.com with ESMTP; 16 Nov 2021 13:22:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4OKAulvYNlHAp5qSUH6+llW5WZ0qSUMKFbr/bZ+a0YFO4/fKN80el54Q+wYVy9kaANnaSG9o/JdJ3x2m1lwakGT5F9Jx7lMWnxZc8Vq0NPQZV/SRvZGYxsL8NZHJUkGiLQWbLnIQtDUKuq7WmQJbSrKjLyoyefsZfulUUhp141Z6iuMgSzjS7oCege56KEdnp+hluc2zxcgysgLuKihNPns4ouRn9oUvYDqOOGdVMK8LfkdOYw1RlvqV8mrOJGSCnr2khr628lT2jEt4PVEIOJqJs0IDwoFohesNwD7q9LlFcNf1/T9fp2074AG1a2yVfyKlukxqe+iSLphtbHxxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/IR3wBcbUaY52UvbQXJeYgkLVfOx+Vj1u/MVm22uS1s=;
 b=A8N6wZu+nhmgR9o/fj8e6PdipEJ3gK1w4bWednAGbiw0H/c/4aPHLeYPL/DuM15BBD3TnBr9mqCgDb9TyGlB3kg/MOw/VH/QPFfdKayrBARf5h+CJiWirTocV764ZMXljM1lGZlGhOKtQGcfSUfnahY8Ppv1hahcH2fqcDGDib4gOEjauU21Adf9SAHwuNrjL/arA61279wTd+1eRCW2m0usJksgMASj789TjuyvYtNzA1DG2JtXagQ0XcLTGCfDs9QIIkn1zJJomZremlChXocoQ5WKAX+R3SeZ6duls6/Q1zzOZJcmPnvyo9Hsk9+rA6TUmGPyUQl64VYzDSFn4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IR3wBcbUaY52UvbQXJeYgkLVfOx+Vj1u/MVm22uS1s=;
 b=Y8sleGOvHbDF7pkgy9GDX68lrkWQc41GFpTGbL2BgL5w5iCUE406zOT6gh4ARebHzBx0bdKCzEWpCW0DqeJ2iirQmYqqP4sHl7/pkHRxJ48ezEOt2RzOCNiyi5xqlF8LhqjvMgWBAXaeVvtNdUSV+y2pHB1GlRVrQmPlSLXhHMQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8347.namprd04.prod.outlook.com (2603:10b6:303:136::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Tue, 16 Nov
 2021 05:22:13 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%9]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 05:22:12 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>
Subject: [PATCH v10 kvmtool 4/8] riscv: Implement Guest/VM VCPU arch functions
Date:   Tue, 16 Nov 2021 10:51:26 +0530
Message-Id: <20211116052130.173679-5-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116052130.173679-1-anup.patel@wdc.com>
References: <20211116052130.173679-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0166.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::36) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (223.182.253.112) by MA1PR01CA0166.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25 via Frontend Transport; Tue, 16 Nov 2021 05:22:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70c166e2-9a7b-4399-fea1-08d9a8c10ba0
X-MS-TrafficTypeDiagnostic: CO6PR04MB8347:
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
X-Microsoft-Antispam-PRVS: <CO6PR04MB834739403DA63C3C4057DDB58D999@CO6PR04MB8347.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7JT6u4Xj+/WYNgbO2gSirUx1QzteYGnEYz9gnTlhGDaMeYHzsqSZmDFE75SkqxE9zBYbHVGAZO1wLUHlJ18C3bLT37sy45WxImVhV+Riw+CSF74/Au1gwjYWBHMjQvXgf7QqiU7M4rHsm7+dFbG29yUkwqTWhP0d0Hlmb+S0InS4vFnnON86URU5sSAuwbu/PPg+2zorpCYERIYJhdkIXEBzPAcj0w8yQBn/r/wlpXWeZlzTSit6SbWPfGpcdzM6eyu9Z3L0ilC0uKEyUU8MTZsWAQvZw6I+P7ofJLBhuu0y5YaW0rA76YU/5An8Lo1nsLrd3t1w6JTen7tdiqXDlPxw9rXzpni0doSiZllTIPTAIzBRS4EznFJCGs1Yr1rvjzLcGJmiA+0odIpnWpkq8KXyG7ShUOgUFUClXXmOMQZEE/NkxZ67/V71ePDEhZUyA+37LWnB9NVr9R4RVXLxKHQHXFEsPvN/pgP1NTflb2CefP9q4PE5s7e8T55VTBMjvASLq7WeQmuEBw9BVPbz+ZgbMb/rHLFGggIeNjXfy0Tex+/h8D53zcE9Kj+8KKibZSlQhDOaK2RVSfvsVY+2oDyrPZQhsHlZs4t3gxIY7O7xtxmDF7jbdGLXurYVaWw8RQ7ZfFnQyOz1kAcfs56YC4BiUwErnhJNpb9G4WDy+mpBS1WGrSGdJA80JkWLjgDjemNNo7gsMw4PHrayZjz0IQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(186003)(4326008)(54906003)(956004)(6666004)(1076003)(2616005)(26005)(38350700002)(508600001)(86362001)(38100700002)(82960400001)(36756003)(52116002)(7696005)(8676002)(66556008)(2906002)(8936002)(83380400001)(5660300002)(316002)(66476007)(66946007)(8886007)(30864003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yJG6HkQz7btfvBOSsKa7dCtoWo7xpSaA5xYyPcqY4AbaFhjoJUl5qZghSoHg?=
 =?us-ascii?Q?pgtCn/LquhISNfTbozQrjKQvKM4SUcYA2oUJkb9waRsyOTR8M9ByIdTqH7oz?=
 =?us-ascii?Q?pcx271QuiDb7Qadhp3lDTRyHYGEr/Mau5u8VyrrNAaogKgqHvMBjR0c+mfVA?=
 =?us-ascii?Q?vrXRNqTCZg895vVY2QJXzjotJFEzYYPmKVNKTSFj/jzZm1kHEZTKKdfCN9l8?=
 =?us-ascii?Q?9CYd0W6ahW8YwslymB9RTOcY5ulLIg8ITcFlm28Ecn8TUYf/MVcMXbRhvGH6?=
 =?us-ascii?Q?CA1tXIcfohVybkDxC6q5kiNRNCwEg3oKMsf4KWJA5ZIvFu7OCMd+0S8TZlVW?=
 =?us-ascii?Q?PWQ0PTmt69adUgReZgifv+2CrxzK6dHyqleqjwd8UelNWZKnQx74Duf23Xhe?=
 =?us-ascii?Q?XHWmhb1MpV59Kq7BMb9FwBu0TNF2yVyYMRMoiwK9bUCjHO7K/5WkwFh+n+BV?=
 =?us-ascii?Q?Klw8VF/YV6s8tJDRxCQ9B38MGemcBJWpzAx5c5/1VoNavC+dYuyhz/Kmv3kT?=
 =?us-ascii?Q?xmwAXMrUeHaQcxnfrQ2g7w/KUr5PulZqX1TzKhV3nDQLpvtkRNgU2CgpMnMq?=
 =?us-ascii?Q?c0TxADx7uHuAABbNIOhR6AR+wPgMTKsbhV/jf9ntcg91+L0xCfUMFzk9e5c5?=
 =?us-ascii?Q?9Q9PS2Y9/lCV3AlHp3wacX0seGUij74+2ps8VXXOc5DTjzKhnUmX6foUDYEh?=
 =?us-ascii?Q?MZITYT0DhGCzaca0oEKCRsaEYCav8tG7dxHdpA0U8UYxRYT9bDwEHaqof/Eh?=
 =?us-ascii?Q?Cniy7OvMbdON+UGzeUmgJ8ANurw8vwj6pb1+yxpfmn79vDBpo95TVIp1iIjg?=
 =?us-ascii?Q?6+mv4aRBPapa02R/W/dfMKTK3IwwLt4NGyHvgK2+DB0vDjL1uX1BMnImy62c?=
 =?us-ascii?Q?+cAJOFxt5AVVowxcfhFy2dN/99wL7KYhPRzQsJjkAxNTrM987cT30zD8kc6O?=
 =?us-ascii?Q?0U43aLniIepykh8jEBNz/oDFknKrQbOgSs+wSuvPXkhN+iXjr2RuNc0hApx9?=
 =?us-ascii?Q?szQLai+7EH1WqAPgYmC2hI7PEEPU1ajp+z5V6GZ7v8KEWlv3ZvaNzYCEm1dT?=
 =?us-ascii?Q?m6DY97yG6F+7FwPxtegJ9NqOEEz4UNszyvtg8paMXNWY97+6d7KNr5f0I5tV?=
 =?us-ascii?Q?AAl+JG1tTcNcZssuPw9J+MwqBsIBzIjrhBM8Z0CmSjmZu2E7G0BJDuY60a9x?=
 =?us-ascii?Q?YIVAgsUVy20wTJteKAzEnms5U2PeOJedIv8TYECX277NKn0LwIRaqJojEJaQ?=
 =?us-ascii?Q?WuH7HJO8gchY3fRLBa8IgGGDcq0/EMgi3CayxYbGLU4MGmx1nTWF8SSz9nVn?=
 =?us-ascii?Q?Q1Gsd9oJpkh+SnNdfnhEmfym6GMo5SklOZH2BomOnxyJ/PlbSEa/ES4RMMuE?=
 =?us-ascii?Q?hG9Go1q9PahnX1t6h+KDa+zmBSsWE4RMqNvSk4SY7J8rVt5uZqLD4zgLuOSl?=
 =?us-ascii?Q?rcBVHINtRVRheRzCOlPPj123fNQnO2XnC+pY0XacsK9X8wzfXjSDg0sOHH0B?=
 =?us-ascii?Q?X2c9pEQC+GJFYgZCRhIOOFBZBxorO4RpinQgvrjJayKuYsrEYPURO3Jthe0t?=
 =?us-ascii?Q?9QWJdLAZyVNT5urhktUW7TRynY1ZKhhUbZ+wDbOdcLl+57ltRPyztIMNWkG5?=
 =?us-ascii?Q?GMR/Iy5joCkdMLVyHpIAYg8=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70c166e2-9a7b-4399-fea1-08d9a8c10ba0
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 05:22:12.8463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uVMshI/cGMe9retM8jKSD5da0CVwrpT7+whIxvdUswodnbsSo0SP4+CV/VEtZYeTc2QheAmDQ8JXH4bihlLhDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8347
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements kvm_cpu__<xyz> Guest/VM VCPU arch functions.

These functions mostly deal with:
1. VCPU allocation and initialization
2. VCPU reset
3. VCPU show/dump code
4. VCPU show/dump registers

We also save RISC-V ISA, XLEN, and TIMEBASE frequency for each VCPU
so that it can be later used for generating Guest/VM FDT.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 riscv/include/kvm/kvm-cpu-arch.h |   4 +
 riscv/kvm-cpu.c                  | 393 ++++++++++++++++++++++++++++++-
 2 files changed, 390 insertions(+), 7 deletions(-)

diff --git a/riscv/include/kvm/kvm-cpu-arch.h b/riscv/include/kvm/kvm-cpu-arch.h
index ae6ae0a..78fcd01 100644
--- a/riscv/include/kvm/kvm-cpu-arch.h
+++ b/riscv/include/kvm/kvm-cpu-arch.h
@@ -12,6 +12,10 @@ struct kvm_cpu {
 
 	unsigned long   cpu_id;
 
+	unsigned long	riscv_xlen;
+	unsigned long	riscv_isa;
+	unsigned long	riscv_timebase;
+
 	struct kvm	*kvm;
 	int		vcpu_fd;
 	struct kvm_run	*kvm_run;
diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index e4b8fa5..8adaddd 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -17,10 +17,88 @@ int kvm_cpu__get_debug_fd(void)
 	return debug_fd;
 }
 
+static __u64 __kvm_reg_id(__u64 type, __u64 idx, __u64  size)
+{
+	return KVM_REG_RISCV | type | idx | size;
+}
+
+#if __riscv_xlen == 64
+#define KVM_REG_SIZE_ULONG	KVM_REG_SIZE_U64
+#else
+#define KVM_REG_SIZE_ULONG	KVM_REG_SIZE_U32
+#endif
+
+#define RISCV_CONFIG_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CONFIG, \
+					     KVM_REG_RISCV_CONFIG_REG(name), \
+					     KVM_REG_SIZE_ULONG)
+
+#define RISCV_CORE_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CORE, \
+					     KVM_REG_RISCV_CORE_REG(name), \
+					     KVM_REG_SIZE_ULONG)
+
+#define RISCV_CSR_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CSR, \
+					     KVM_REG_RISCV_CSR_REG(name), \
+					     KVM_REG_SIZE_ULONG)
+
+#define RISCV_TIMER_REG(name)	__kvm_reg_id(KVM_REG_RISCV_TIMER, \
+					     KVM_REG_RISCV_TIMER_REG(name), \
+					     KVM_REG_SIZE_U64)
+
 struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 {
-	/* TODO: */
-	return NULL;
+	struct kvm_cpu *vcpu;
+	u64 timebase = 0;
+	unsigned long isa = 0;
+	int coalesced_offset, mmap_size;
+	struct kvm_one_reg reg;
+
+	vcpu = calloc(1, sizeof(struct kvm_cpu));
+	if (!vcpu)
+		return NULL;
+
+	vcpu->vcpu_fd = ioctl(kvm->vm_fd, KVM_CREATE_VCPU, cpu_id);
+	if (vcpu->vcpu_fd < 0)
+		die_perror("KVM_CREATE_VCPU ioctl");
+
+	reg.id = RISCV_CONFIG_REG(isa);
+	reg.addr = (unsigned long)&isa;
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (config.isa)");
+
+	reg.id = RISCV_TIMER_REG(frequency);
+	reg.addr = (unsigned long)&timebase;
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (timer.frequency)");
+
+	mmap_size = ioctl(kvm->sys_fd, KVM_GET_VCPU_MMAP_SIZE, 0);
+	if (mmap_size < 0)
+		die_perror("KVM_GET_VCPU_MMAP_SIZE ioctl");
+
+	vcpu->kvm_run = mmap(NULL, mmap_size, PROT_RW, MAP_SHARED,
+			     vcpu->vcpu_fd, 0);
+	if (vcpu->kvm_run == MAP_FAILED)
+		die("unable to mmap vcpu fd");
+
+	coalesced_offset = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION,
+				 KVM_CAP_COALESCED_MMIO);
+	if (coalesced_offset)
+		vcpu->ring = (void *)vcpu->kvm_run +
+			     (coalesced_offset * PAGE_SIZE);
+
+	reg.id = RISCV_CONFIG_REG(isa);
+	reg.addr = (unsigned long)&isa;
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die("KVM_SET_ONE_REG failed (config.isa)");
+
+	/* Populate the vcpu structure. */
+	vcpu->kvm		= kvm;
+	vcpu->cpu_id		= cpu_id;
+	vcpu->riscv_isa		= isa;
+	vcpu->riscv_xlen	= __riscv_xlen;
+	vcpu->riscv_timebase	= timebase;
+	vcpu->is_running	= true;
+
+	return vcpu;
 }
 
 void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
@@ -29,7 +107,7 @@ void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
 
 void kvm_cpu__delete(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	free(vcpu);
 }
 
 bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
@@ -40,12 +118,43 @@ bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
 
 void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
 }
 
 void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_mp_state mp_state;
+	struct kvm_one_reg reg;
+	unsigned long data;
+
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_MP_STATE, &mp_state) < 0)
+		die_perror("KVM_GET_MP_STATE failed");
+
+	/*
+	 * If MP state is stopped then it means Linux KVM RISC-V emulates
+	 * SBI v0.2 (or higher) with HART power managment and give VCPU
+	 * will power-up at boot-time by boot VCPU. For such VCPU, we
+	 * don't update PC, A0 and A1 here.
+	 */
+	if (mp_state.mp_state == KVM_MP_STATE_STOPPED)
+		return;
+
+	reg.addr = (unsigned long)&data;
+
+	data	= kvm->arch.kern_guest_start;
+	reg.id	= RISCV_CORE_REG(regs.pc);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (pc)");
+
+	data	= vcpu->cpu_id;
+	reg.id	= RISCV_CORE_REG(regs.a0);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (a0)");
+
+	data	= kvm->arch.dtb_guest_start;
+	reg.id	= RISCV_CORE_REG(regs.a1);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (a1)");
 }
 
 int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
@@ -55,10 +164,280 @@ int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
 
 void kvm_cpu__show_code(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	struct kvm_one_reg reg;
+	unsigned long data;
+	int debug_fd = kvm_cpu__get_debug_fd();
+
+	reg.addr = (unsigned long)&data;
+
+	dprintf(debug_fd, "\n*PC:\n");
+	reg.id = RISCV_CORE_REG(regs.pc);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (show_code @ PC)");
+
+	kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
+
+	dprintf(debug_fd, "\n*RA:\n");
+	reg.id = RISCV_CORE_REG(regs.ra);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (show_code @ RA)");
+
+	kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
+}
+
+static void kvm_cpu__show_csrs(struct kvm_cpu *vcpu)
+{
+	struct kvm_one_reg reg;
+	struct kvm_riscv_csr csr;
+	unsigned long data;
+	int debug_fd = kvm_cpu__get_debug_fd();
+
+	reg.addr = (unsigned long)&data;
+	dprintf(debug_fd, "\n Control Status Registers:\n");
+	dprintf(debug_fd,   " ------------------------\n");
+
+	reg.id		= RISCV_CSR_REG(sstatus);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (sstatus)");
+	csr.sstatus = data;
+
+	reg.id		= RISCV_CSR_REG(sie);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (sie)");
+	csr.sie = data;
+
+	reg.id		= RISCV_CSR_REG(stvec);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (stvec)");
+	csr.stvec = data;
+
+	reg.id		= RISCV_CSR_REG(sip);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (sip)");
+	csr.sip = data;
+
+	reg.id		= RISCV_CSR_REG(satp);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (satp)");
+	csr.satp = data;
+
+	reg.id		= RISCV_CSR_REG(stval);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (stval)");
+	csr.stval = data;
+
+	reg.id		= RISCV_CSR_REG(scause);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (SCAUSE)");
+	csr.scause = data;
+
+	reg.id		= RISCV_CSR_REG(sscratch);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (sscartch)");
+	csr.sscratch = data;
+	dprintf(debug_fd, " SSTATUS:  0x%016lx\n", csr.sstatus);
+	dprintf(debug_fd, " SIE:      0x%016lx\n", csr.sie);
+	dprintf(debug_fd, " STVEC:    0x%016lx\n", csr.stvec);
+	dprintf(debug_fd, " SIP:      0x%016lx\n", csr.sip);
+	dprintf(debug_fd, " SATP:     0x%016lx\n", csr.satp);
+	dprintf(debug_fd, " STVAL:    0x%016lx\n", csr.stval);
+	dprintf(debug_fd, " SCAUSE:   0x%016lx\n", csr.scause);
+	dprintf(debug_fd, " SSCRATCH: 0x%016lx\n", csr.sscratch);
 }
 
 void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	struct kvm_one_reg reg;
+	unsigned long data;
+	int debug_fd = kvm_cpu__get_debug_fd();
+	struct kvm_riscv_core core;
+
+	reg.addr = (unsigned long)&data;
+
+	reg.id		= RISCV_CORE_REG(mode);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (mode)");
+	core.mode = data;
+
+	reg.id		= RISCV_CORE_REG(regs.pc);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (pc)");
+	core.regs.pc = data;
+
+	reg.id		= RISCV_CORE_REG(regs.ra);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (ra)");
+	core.regs.ra = data;
+
+	reg.id		= RISCV_CORE_REG(regs.sp);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (sp)");
+	core.regs.sp = data;
+
+	reg.id		= RISCV_CORE_REG(regs.gp);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (gp)");
+	core.regs.gp = data;
+
+	reg.id		= RISCV_CORE_REG(regs.tp);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (tp)");
+	core.regs.tp = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t0);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t0)");
+	core.regs.t0 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t1);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t1)");
+	core.regs.t1 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t2);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t2)");
+	core.regs.t2 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s0);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s0)");
+	core.regs.s0 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s1);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s1)");
+	core.regs.s1 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a0);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a0)");
+	core.regs.a0 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a1);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a1)");
+	core.regs.a1 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a2);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a2)");
+	core.regs.a2 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a3);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a3)");
+	core.regs.a3 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a4);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a4)");
+	core.regs.a4 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a5);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a5)");
+	core.regs.a5 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a6);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a6)");
+	core.regs.a6 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a7);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a7)");
+	core.regs.a7 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s2);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s2)");
+	core.regs.s2 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s3);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s3)");
+	core.regs.s3 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s4);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s4)");
+	core.regs.s4 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s5);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s5)");
+	core.regs.s5 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s6);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s6)");
+	core.regs.s6 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s7);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s7)");
+	core.regs.s7 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s8);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s8)");
+	core.regs.s8 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s9);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s9)");
+	core.regs.s9 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s10);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s10)");
+	core.regs.s10 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s11);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s11)");
+	core.regs.s11 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t3);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t3)");
+	core.regs.t3 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t4);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t4)");
+	core.regs.t4 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t5);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t5)");
+	core.regs.t5 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t6);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t6)");
+	core.regs.t6 = data;
+
+	dprintf(debug_fd, "\n General Purpose Registers:\n");
+	dprintf(debug_fd,   " -------------------------\n");
+	dprintf(debug_fd, " MODE:  0x%lx\n", data);
+	dprintf(debug_fd, " PC: 0x%016lx   RA: 0x%016lx SP: 0x%016lx GP: 0x%016lx\n",
+		core.regs.pc, core.regs.ra, core.regs.sp, core.regs.gp);
+	dprintf(debug_fd, " TP: 0x%016lx   T0: 0x%016lx T1: 0x%016lx T2: 0x%016lx\n",
+		core.regs.tp, core.regs.t0, core.regs.t1, core.regs.t2);
+	dprintf(debug_fd, " S0: 0x%016lx   S1: 0x%016lx A0: 0x%016lx A1: 0x%016lx\n",
+		core.regs.s0, core.regs.s1, core.regs.a0, core.regs.a1);
+	dprintf(debug_fd, " A2: 0x%016lx   A3: 0x%016lx A4: 0x%016lx A5: 0x%016lx\n",
+		core.regs.a2, core.regs.a3, core.regs.a4, core.regs.a5);
+	dprintf(debug_fd, " A6: 0x%016lx   A7: 0x%016lx S2: 0x%016lx S3: 0x%016lx\n",
+		core.regs.a6, core.regs.a7, core.regs.s2, core.regs.s3);
+	dprintf(debug_fd, " S4: 0x%016lx   S5: 0x%016lx S6: 0x%016lx S7: 0x%016lx\n",
+		core.regs.s4, core.regs.s5, core.regs.s6, core.regs.s7);
+	dprintf(debug_fd, " S8: 0x%016lx   S9: 0x%016lx S10: 0x%016lx S11: 0x%016lx\n",
+		core.regs.s8, core.regs.s9, core.regs.s10, core.regs.s11);
+	dprintf(debug_fd, " T3: 0x%016lx   T4: 0x%016lx T5: 0x%016lx T6: 0x%016lx\n",
+		core.regs.t3, core.regs.t4, core.regs.t5, core.regs.t6);
+
+	kvm_cpu__show_csrs(vcpu);
 }
-- 
2.25.1

