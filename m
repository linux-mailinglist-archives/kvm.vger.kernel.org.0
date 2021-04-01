Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6D6351B3F
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbhDASHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:07:04 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:44330 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235192AbhDASBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 14:01:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617300102; x=1648836102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=yKC6T1cn/n6ZmNEddxWSkzk+2WPSVMzQ7LWz+0gPzwQ=;
  b=UxnPXJJTQCIuggXyyel1xFcInPSMGH++kYSctMX0yGofNWOXixwi2JJ0
   ZIq+RXhaxJk7iB9T40OOx83lz1XzmnGJVPwvx36e1YGzXQNBES/08wp45
   QMUBMPQXwZlxxgy9EB5oMXMQaXVxSen9Z/mIU9S8vugYuJYZ/+ukGTWJp
   dnBBQNNpIhEYzpOi+8Lz3a7FYGqI/a3SeJ4cWv3afRxDbRaQEhPvgZ8Z8
   uf0YiiZ1JhKbx9URkiMok5ojTisJiG+fkl/MHKEOyXQ55jCwX41nEfKpL
   FZ777Zp7vQXCMqAQs84sNUzH5m85+nOsb8LW8fR02oPEpwP5iND73LQ6m
   g==;
IronPort-SDR: aFnl+sdjqUAVZ3UKYgzWinVoG5V9OWfeiBn5tYBw0r6bVw1W4YkNjMXViQG4iPhiSOp9NS6Vtb
 ekxv5EwJgOta5Yb932ib4c3/MMIkGVpmSzsujfDRII/Rmu4oec1SiBRNGe0igNbeU+vVzx/apL
 oJx4TyEq4H0bzL22nSciZLEva7yvDdboDTPeRv+nUfS75N0eOepQ9e2xhmpkcTX3JNr2QiB6wn
 HB5HWooehPTeF8xFqgTb2ftBpFdNFMbuNawWFzOOysdvolMQsYnI30uI4uxKIMofMrkgcPRpME
 ulE=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="164582951"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:38:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SU+KxXQI25Si2LPl6NUUM1Kiu+IZXQdTHobavyOTItWi1DsWG6OJ24FBZtPWxjZnqHoSpN7b2BcJdRXxMz1REk6Iik/kri7VSHR+OMC4Olr6DbeG42h4qoeJ6KTS3CAFz2gmb0+2kZ7ZvuTdFSjUq8HzKphYU3WSgUtIgpydjDSG+/cttogAHK3RpPuNKQ2yFE04zMm6OXzP4xAVeJp/2mFEAESYkfVrHltDASKC8naDgrSGQm+7J7gc+T7FeiodCm5ZAO+/fXGgbMm5UHnva51DjtLjD9MIXtIkA7pZPsR0NbhK53fvaI04Hj+CgpgdyWFqNJp1nRSMMf9OgxBz2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYM8x9HNzmrCTwe/nuEOvCzUn6qGHKxEMdFcgjHi25E=;
 b=GPgcxrotgAo6IHDd2zJtnSEmjBffzgDN/UK0eKQ1U6/4/ZLmdRFoqgQ8ttXlKO5aBjABUj1R3e4sjK0HGp+S2u58ttnKo2/NlK7QHYVr3hRQUr+0aLT9QA0m9Z6sc7k8CqUWNEPb74U1srXkD9eLEJ2AYJPyUbO4Bz1pNCcqI2M39SBU4iS43YVjXLmFa3r/p4JQkk2kAAgEJt/RZSc2rLkHFyD9uuxfDon2/50MqE4kZjBO6HEom3/XeRXe40wC/NbOZi/godfOiYtYu/8J/i75IfxBy2L2IgqgnnsnyToCi9L5O8fgTaMkcgGCcSxFH7wCFpNfVOD8z7GBxLjxPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYM8x9HNzmrCTwe/nuEOvCzUn6qGHKxEMdFcgjHi25E=;
 b=mZXwYLItEazuD6w220wzHoW5D8k6N9CgHqstcyErHDht6CC0BWmiR8r0DWqWJwZO5x6dFgdpHAQ+5W9a3DEt7kNjUpfYTfLVxDatUFGhFZdR+MOOXrJuG9oajcJQaoSU5USIeejEt6HmZX6nF6qKjhAQXMplO6W0LXKYqAYe5Rg=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6528.namprd04.prod.outlook.com (2603:10b6:5:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 1 Apr
 2021 13:37:54 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:37:54 +0000
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
Subject: [PATCH v17 11/17] RISC-V: KVM: Implement MMU notifiers
Date:   Thu,  1 Apr 2021 19:04:29 +0530
Message-Id: <20210401133435.383959-12-anup.patel@wdc.com>
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
Received: from wdc.com (122.179.112.210) by MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 13:37:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fa069e8-dc62-4b77-0db2-08d8f5135a0d
X-MS-TrafficTypeDiagnostic: DM6PR04MB6528:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB6528CC8D7B589720538F56898D7B9@DM6PR04MB6528.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rkCG4GyQDwVts5yJoP5GYEPyvhGOW6jduKodlN0zzu8kgQNCMxynXRRQu7vLLJdLJqnz8Iva5icq2Kk/GYpvgMGkgHhIFefD4MlNRHbAiJ3Rx4LPxWwt3hFA7zQk/JaCfNncERTHDX2npSRCxl8WqemWzO2PYzZsXfGW32bkopoQcsh5P+1d+6+iox79AFQp8vIcInz+1UH+uW65KPpHwYsc+zpd8lfwpYgnF1J5Rf+0A10HCVzNo1xp9+dg03MytItsBI9bVpGhoWo/q5PhR99T88ZWdknf6/crujQuO+L4ddZewKRYYOm1KUunUBUyDLG4Wr9HmpTJ8dyCV5lU41N6CaqQ+C8/1eyXGoWAbX3CZbwUtdjt7XvQeVlj2Vh0NpsFCT2pI45JPK2HBqia/8VEcFExgYrwU9/Etd+GPlkiRJoYS6C7xnhSF7zlk6sZbMdZnqom4YBs0sC7Pv5jcJ7MDAGZNRVkvSpZ5OrOqYXxYOstH9AWCkukeQugvtzLvJXONSjS0ot8jEHOUjS428tAGYFSgBN12NpDkIXcEStqJcLPIYc+Iax1Kk9+rWCTaThsil/uY08OPlXxDicQs/jycy14H9em2vw7N023XmLuHBZLcaccmUxGRawqljjt1VegrqUGef/iZNaUbD8oV7DWpwTAd30rNFc/q9dhF+8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(8886007)(16526019)(36756003)(186003)(4326008)(956004)(2616005)(6666004)(316002)(66556008)(478600001)(26005)(66476007)(2906002)(54906003)(7416002)(1076003)(8936002)(55016002)(86362001)(83380400001)(8676002)(52116002)(110136005)(7696005)(5660300002)(38100700001)(44832011)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ZlfPN3zi6V8Tqz8wTUrNFiqjupNkMuaX5s2mrZCWN1YPazAowFqLHP678PRg?=
 =?us-ascii?Q?4/I/EJgOzDikR85po/txcIGVS3r0bmLygNQzgVRPog+GeYaI6UUecvKGKFsV?=
 =?us-ascii?Q?9U4Zer2Y/baGv3QYrhc05P1OQbmVUurZQzQfDyy9Ol9QSBOFc2nACCfCQPKT?=
 =?us-ascii?Q?vddnKGURmyDsZlXZ0pw9H/7MGSMMuI3ymF3Fu6s/+GDPWmuc1a6LlQQDlJVU?=
 =?us-ascii?Q?7DY+bJHt4xzM43gSf5t6NiZpT4ZJV+XDG0zrykJgdqRbwt7EnpBrsrmOfrO/?=
 =?us-ascii?Q?QymLN6Nl+ave3QyPfMtiImEL9IXRU6iQQl84MTRirJL7pbUvO7JzGGW1Pr2d?=
 =?us-ascii?Q?hM895U6nZsYKOGzORGI4d+YgLhv3WCBpqMz9UiaYcsMCbM5OA1DNWQiA/56s?=
 =?us-ascii?Q?ZUcpdytnqbxApDqQPPO8yxJi7xPzV1lJ05MJYm1RBTRf0cFSUbTj2g3VsDFR?=
 =?us-ascii?Q?oFjaOnB5Tlpfx2iZP5JjkrOAjxS/srW3nhkcLYUjKFGJFmL4Bhy2VJt8n6fQ?=
 =?us-ascii?Q?Qcqw59qJE9K1fmvkdcrf6xc3EcqXOFzZVuW6uMHZpm/ol0weL9x5yrWdqjWl?=
 =?us-ascii?Q?gRQH/3QjV8zWTq6KbXFdSfzncllVvCitJw8knIQhRlLZBZoodqFM5G8AnNCr?=
 =?us-ascii?Q?jrXKhqz23n35DTj51OqplohvbYT2L+A2Nz53WSH8NpGnZURjIc3UaStvhndm?=
 =?us-ascii?Q?fhS9uhofWxNiS243o7SyyEyLO905/lBo34MWYf7EuHE+1YRisC1umpgvXUZH?=
 =?us-ascii?Q?hQJ/7Jo/WqmxtWidQgI7isBKP9gPa+oOYClUwTMYA2j5wQesXFlUaBBRk59B?=
 =?us-ascii?Q?dSqjf4TR3MAS22x59UG8vMHmbsPPIQkRHQA99RX6UtE79kLqoVnDdfwllGFb?=
 =?us-ascii?Q?RJk2Qp3UIlqXO5OcytSjjyYQtqBlkJuHkoVpQrcPYDiOEkrmkWqKwj9qYUaU?=
 =?us-ascii?Q?UGqgo507sOLBIc8XjghgjN/NNcWOj4G29e1vjzE646dY3h1SOyZ3JLg2poXM?=
 =?us-ascii?Q?o8pdM8mDXAanDPneJ5VFF9J4gak7wDsEZ2RxZoNqO7P12f0mhB0TFsvlIgga?=
 =?us-ascii?Q?ZU6qhmqLjkGpmcy3sldhIYwtDKyZLH0QQknCI7nnfAi+9T1m8vjEvA9wRCus?=
 =?us-ascii?Q?2Rc4WAfuyBYwRx0IGhKkiUxfZM+5YXN7jcHdix+4eyjv2TcjIpCPLc6Cwjni?=
 =?us-ascii?Q?tYaFCiyJtyNLc1DFWp25j7X8HMfIoiz76bU2FY4fyjqYrejBHe55SIS4aAEL?=
 =?us-ascii?Q?yXKVaWZUzaI9DIelYKyYNrlBIOlrGVRWq7NtxOv2Ij9TjyNJVJoVwn8NRzPQ?=
 =?us-ascii?Q?UKCZjvSz3NPPjIrbL6Lai8V3ZWl7o0VMIlxywzW32pXsqw=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fa069e8-dc62-4b77-0db2-08d8f5135a0d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:37:54.0791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rC6uHZJtOP6TNiNmwgLpghwNbFH+1A8f+t9QQRISrPh306LMgxDK74EyUteqtptZDB1bBg9zXS+moJorEqvzdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6528
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements MMU notifiers for KVM RISC-V so that Guest
physical address space is in-sync with Host physical address space.

This will allow swapping, page migration, etc to work transparently
with KVM RISC-V.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/kvm_host.h |   7 ++
 arch/riscv/kvm/Kconfig            |   1 +
 arch/riscv/kvm/mmu.c              | 144 +++++++++++++++++++++++++++++-
 arch/riscv/kvm/vm.c               |   1 +
 4 files changed, 149 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index f80c394312b8..4e318137d82a 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -202,6 +202,13 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
+#define KVM_ARCH_WANT_MMU_NOTIFIER
+int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start,
+			unsigned long end, unsigned int flags);
+int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
+int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
+
 void __kvm_riscv_hfence_gvma_vmid_gpa(unsigned long gpa, unsigned long vmid);
 void __kvm_riscv_hfence_gvma_vmid(unsigned long vmid);
 void __kvm_riscv_hfence_gvma_gpa(unsigned long gpa);
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index 633063edaee8..a712bb910cda 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -20,6 +20,7 @@ if VIRTUALIZATION
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support (EXPERIMENTAL)"
 	depends on RISCV_SBI && MMU
+	select MMU_NOTIFIER
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	select KVM_MMIO
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 4c533a41b887..b64704aaed7d 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -296,7 +296,8 @@ static void stage2_op_pte(struct kvm *kvm, gpa_t addr,
 	}
 }
 
-static void stage2_unmap_range(struct kvm *kvm, gpa_t start, gpa_t size)
+static void stage2_unmap_range(struct kvm *kvm, gpa_t start,
+			       gpa_t size, bool may_block)
 {
 	int ret;
 	pte_t *ptep;
@@ -321,6 +322,13 @@ static void stage2_unmap_range(struct kvm *kvm, gpa_t start, gpa_t size)
 
 next:
 		addr += page_size;
+
+		/*
+		 * If the range is too large, release the kvm->mmu_lock
+		 * to prevent starvation and lockup detector warnings.
+		 */
+		if (may_block && addr < end)
+			cond_resched_lock(&kvm->mmu_lock);
 	}
 }
 
@@ -404,6 +412,38 @@ static int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
 
 }
 
+static int handle_hva_to_gpa(struct kvm *kvm,
+			     unsigned long start,
+			     unsigned long end,
+			     int (*handler)(struct kvm *kvm,
+					    gpa_t gpa, u64 size,
+					    void *data),
+			     void *data)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
+	int ret = 0;
+
+	slots = kvm_memslots(kvm);
+
+	/* we only care about the pages that the guest sees */
+	kvm_for_each_memslot(memslot, slots) {
+		unsigned long hva_start, hva_end;
+		gfn_t gpa;
+
+		hva_start = max(start, memslot->userspace_addr);
+		hva_end = min(end, memslot->userspace_addr +
+					(memslot->npages << PAGE_SHIFT));
+		if (hva_start >= hva_end)
+			continue;
+
+		gpa = hva_to_gfn_memslot(hva_start, memslot) << PAGE_SHIFT;
+		ret |= handler(kvm, gpa, (u64)(hva_end - hva_start), data);
+	}
+
+	return ret;
+}
+
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 					     struct kvm_memory_slot *slot,
 					     gfn_t gfn_offset,
@@ -543,7 +583,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	spin_lock(&kvm->mmu_lock);
 	if (ret)
 		stage2_unmap_range(kvm, mem->guest_phys_addr,
-				   mem->memory_size);
+				   mem->memory_size, false);
 	spin_unlock(&kvm->mmu_lock);
 
 out:
@@ -551,6 +591,96 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	return ret;
 }
 
+static int kvm_unmap_hva_handler(struct kvm *kvm,
+				 gpa_t gpa, u64 size, void *data)
+{
+	unsigned int flags = *(unsigned int *)data;
+	bool may_block = flags & MMU_NOTIFIER_RANGE_BLOCKABLE;
+
+	stage2_unmap_range(kvm, gpa, size, may_block);
+	return 0;
+}
+
+int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start,
+			unsigned long end, unsigned int flags)
+{
+	if (!kvm->arch.pgd)
+		return 0;
+
+	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, &flags);
+	return 0;
+}
+
+static int kvm_set_spte_handler(struct kvm *kvm,
+				gpa_t gpa, u64 size, void *data)
+{
+	pte_t *pte = (pte_t *)data;
+
+	WARN_ON(size != PAGE_SIZE);
+	stage2_set_pte(kvm, 0, NULL, gpa, pte);
+
+	return 0;
+}
+
+int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
+{
+	unsigned long end = hva + PAGE_SIZE;
+	kvm_pfn_t pfn = pte_pfn(pte);
+	pte_t stage2_pte;
+
+	if (!kvm->arch.pgd)
+		return 0;
+
+	stage2_pte = pfn_pte(pfn, PAGE_WRITE_EXEC);
+	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &stage2_pte);
+
+	return 0;
+}
+
+static int kvm_age_hva_handler(struct kvm *kvm,
+				gpa_t gpa, u64 size, void *data)
+{
+	pte_t *ptep;
+	u32 ptep_level = 0;
+
+	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
+
+	if (!stage2_get_leaf_entry(kvm, gpa, &ptep, &ptep_level))
+		return 0;
+
+	return ptep_test_and_clear_young(NULL, 0, ptep);
+}
+
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
+{
+	if (!kvm->arch.pgd)
+		return 0;
+
+	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
+}
+
+static int kvm_test_age_hva_handler(struct kvm *kvm,
+				    gpa_t gpa, u64 size, void *data)
+{
+	pte_t *ptep;
+	u32 ptep_level = 0;
+
+	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE);
+	if (!stage2_get_leaf_entry(kvm, gpa, &ptep, &ptep_level))
+		return 0;
+
+	return pte_young(*ptep);
+}
+
+int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
+{
+	if (!kvm->arch.pgd)
+		return 0;
+
+	return handle_hva_to_gpa(kvm, hva, hva,
+				 kvm_test_age_hva_handler, NULL);
+}
+
 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 			 struct kvm_memory_slot *memslot,
 			 gpa_t gpa, unsigned long hva, bool is_write)
@@ -565,7 +695,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 	struct kvm_mmu_page_cache *pcache = &vcpu->arch.mmu_page_cache;
 	bool logging = (memslot->dirty_bitmap &&
 			!(memslot->flags & KVM_MEM_READONLY)) ? true : false;
-	unsigned long vma_pagesize;
+	unsigned long vma_pagesize, mmu_seq;
 
 	mmap_read_lock(current->mm);
 
@@ -604,6 +734,8 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 		return ret;
 	}
 
+	mmu_seq = kvm->mmu_notifier_seq;
+
 	hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writeable);
 	if (hfn == KVM_PFN_ERR_HWPOISON) {
 		send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
@@ -622,6 +754,9 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 
 	spin_lock(&kvm->mmu_lock);
 
+	if (mmu_notifier_retry(kvm, mmu_seq))
+		goto out_unlock;
+
 	if (writeable) {
 		kvm_set_pfn_dirty(hfn);
 		mark_page_dirty(kvm, gfn);
@@ -635,6 +770,7 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 	if (ret)
 		kvm_err("Failed to map in stage2\n");
 
+out_unlock:
 	spin_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(hfn);
 	kvm_release_pfn_clean(hfn);
@@ -671,7 +807,7 @@ void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
 
 	spin_lock(&kvm->mmu_lock);
 	if (kvm->arch.pgd) {
-		stage2_unmap_range(kvm, 0UL, stage2_gpa_size);
+		stage2_unmap_range(kvm, 0UL, stage2_gpa_size, false);
 		pgd = READ_ONCE(kvm->arch.pgd);
 		kvm->arch.pgd = NULL;
 		kvm->arch.pgd_phys = 0;
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 6cde69a82252..00a1a88008be 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -49,6 +49,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
+	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_READONLY_MEM:
-- 
2.25.1

