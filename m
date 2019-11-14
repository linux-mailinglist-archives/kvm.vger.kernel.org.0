Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31E2CFCF7B
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfKNUP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:15:57 -0500
Received: from mail-eopbgr730059.outbound.protection.outlook.com ([40.107.73.59]:60877
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727321AbfKNUP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:15:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrpsETg+Q4YQuIV6On1msS9y1hc2ACbqp9OZMl13pWyFUkq3+ees5TWKz7VrZbPGNCojRQPUSzKFYbL2ZxvanDAKpvDrEUtWR8N2vzNW691zNyLiIbUAwKEdsj2b1cSkDRnnGXbKKr1ePxDeCh+mGLgBqeZbN2Jod4FbSK47UxocR7Nl2W1DCkMLrAGLFEmknlJ96JT1Ista++slfeLG65QLDIHfGwWJNn/tzCuzQUBYeq4TQ9zngikQ+pvx+Tm0HsVtQoi9Upgaq8VrpUw9sGMKNUe8+L5NYqBx+UFI0C9fXYyp1blILz1CQn7Xc7QZWNdDo61yc8zZQ8UODbaYnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGHihURf06v5KccYKBAUcyiOdnmOcn3m9c4AlEKwMGs=;
 b=M9RCcXR0tFTlK3H9xWI4PniUNoUavNE6jZLPz2Pkb2o5cGG2hTpWAN2m9Pwbf19yhMXxpRTzJ0aeH8HWCH6I31YVbK5zSzHWgRGjq/eQ+ELxxMd2NtelVMPZ24yculoTpHyg7JsAA/A9IaFjpb7M4uagdgeDmmslCb5Va7EGZFp672WiE/56nhTrbfdRMY3rbmI6bCgOKTYAfoldCGOGghXyjs011p0CvPk1/YJnx9XLxwFHYX3K02iw4ukvyG94FibVmXtoOMcFf64CAky+svL/iIpw6gPH8jxs4D0LYRR7qFW5jLtjDrqczUdbsrZRezFdxXZaLLtYorB9sS2e9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OGHihURf06v5KccYKBAUcyiOdnmOcn3m9c4AlEKwMGs=;
 b=2+jNRl/K/HPM7WD7PFRAlambZPlwjkd9pk7uQyvNIBSB2MOe6PR/lGx7ibgh+wIpyg8JHX6w84ADfBrBDn3vH3v+yUVk4yhpRGfrSogPAaBjCR7ryGbEuNyiZRASD5gJTdgPN1huomu/Amiwx08JnoDXkukiJ2YLmqV6BuArsAg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:50 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:50 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 15/18] kvm: lapic: Clean up APIC predefined macros
Date:   Thu, 14 Nov 2019 14:15:17 -0600
Message-Id: <1573762520-80328-16-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0099.namprd12.prod.outlook.com
 (2603:10b6:802:21::34) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
MIME-Version: 1.0
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e217d3fd-966b-4b38-3c59-08d7693f7186
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3739FA4A79071F50D8EF4342F3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(16586007)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(478600001)(99286004)(81166006)(26005)(14444005)(476003)(5660300002)(44832011)(386003)(446003)(52116002)(51416003)(76176011)(50466002)(6666004)(36756003)(11346002)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /zBmmLhKp0Hzgt99bAiHslBE4JyF9v8yjKp4ChxdNrPo4AyNygc0Ya5PtN7V86xFVKUkwOYFoRDPcMbeUOYkvoblHRgRdjYAfXeAQCBFxxbky101QspUxOQiff2ZJAlmk74Y731IXI03iWKVq8p3AL1y0qy05Xjk/9cdV9HmAbpOH3jLFOyKRXZwwAuUEIRpw8IFSDdinUYwxwIRQBBy8GhpHGbmqf5n24CyU7xHffyObI06SNEpVwe0UvKYGCDgRrhC6vTDVmuZ/AQnIE/g1AaOasJStaSTigMMHslpBKQ+QVNbF8M2FjFMtbzmbbIQCFU4ZMeWjW0roaeVdeyqEYmXUuVll3BJhDt2uKEuZ43yYh6gZkjvKxFUVXc/jbLy1e4HxV1M4ovWhV5CsJCH8J5j/gizqraZOu+lL1bdlzSLng6VmxiNL5KkGGKakdwd
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e217d3fd-966b-4b38-3c59-08d7693f7186
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:50.6662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cl0mUE50Lx4duuiB5ZPE+464RS6bADe0WWCdQCDjQCZGguv/UKgDhMKI70ymyKFSvfrxcBurPA9kAHWyf2xygA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move these duplicated predefined macros to the header file so that
it can be re-used in other places.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kvm/lapic.c | 13 +++++--------
 arch/x86/kvm/lapic.h |  1 +
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 7678f32..4713c30 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -56,9 +56,6 @@
 #define APIC_VERSION			(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
 #define LAPIC_MMIO_LENGTH		(1 << 12)
 /* followed define is not in apicdef.h */
-#define APIC_SHORT_MASK			0xc0000
-#define APIC_DEST_NOSHORT		0x0
-#define APIC_DEST_MASK			0x800
 #define MAX_APIC_VECTOR			256
 #define APIC_VECTORS_PER_REG		32
 
@@ -573,9 +570,9 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 	irq.level = (icr & APIC_INT_ASSERT) != 0;
 	irq.trig_mode = icr & APIC_INT_LEVELTRIG;
 
-	if (icr & APIC_DEST_MASK)
+	if (icr & KVM_APIC_DEST_MASK)
 		return -KVM_EINVAL;
-	if (icr & APIC_SHORT_MASK)
+	if (icr & KVM_APIC_SHORT_MASK)
 		return -KVM_EINVAL;
 
 	rcu_read_lock();
@@ -806,7 +803,7 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 
 	ASSERT(target);
 	switch (short_hand) {
-	case APIC_DEST_NOSHORT:
+	case KVM_APIC_DEST_NOSHORT:
 		if (dest_mode == APIC_DEST_PHYSICAL)
 			return kvm_apic_match_physical_addr(target, mda);
 		else
@@ -1202,10 +1199,10 @@ static void apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 
 	irq.vector = icr_low & APIC_VECTOR_MASK;
 	irq.delivery_mode = icr_low & APIC_MODE_MASK;
-	irq.dest_mode = icr_low & APIC_DEST_MASK;
+	irq.dest_mode = icr_low & KVM_APIC_DEST_MASK;
 	irq.level = (icr_low & APIC_INT_ASSERT) != 0;
 	irq.trig_mode = icr_low & APIC_INT_LEVELTRIG;
-	irq.shorthand = icr_low & APIC_SHORT_MASK;
+	irq.shorthand = icr_low & KVM_APIC_SHORT_MASK;
 	irq.msi_redir_hint = false;
 	if (apic_x2apic_mode(apic))
 		irq.dest_id = icr_high;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index f6ef1ce..d49d85b 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -10,6 +10,7 @@
 #define KVM_APIC_SIPI		1
 #define KVM_APIC_LVT_NUM	6
 
+#define KVM_APIC_DEST_NOSHORT	0x0
 #define KVM_APIC_SHORT_MASK	0xc0000
 #define KVM_APIC_DEST_MASK	0x800
 
-- 
1.8.3.1

