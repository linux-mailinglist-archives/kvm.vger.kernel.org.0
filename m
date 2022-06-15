Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33DF754BF29
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 03:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239774AbiFOBRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 21:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237660AbiFOBR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 21:17:26 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B96E8F;
        Tue, 14 Jun 2022 18:17:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMChFS1NYgNm8IwYVTmi9oxDSJbUDG9wzARGl3SLBQgI6j3N5J10ra3b0bsTaZ2BIkjUcXpodMB9zrWQKccJPIQrLjqsFexC/JgFEw7zF1lYJSnsA4GBZPLQoC/ayjWTmK7DiphuD9IyeQZW5Ug7M0e7tvUuczrwTqe8/20HWVkbmstRXBWZK0h44u4VCFLAbC9+Gll3ArIp4Nwz3iTV+mxoRW+6PEY0zCFOtHK3+3ceobUOJkhbfXo1mb0COqthvqQOzYsHtBlwf50Nrwq1761mP1dfPzCzatGq5ZG78nPtMK2oAOQLqmQJfcMnFHM3S2YbqO1dfIBjFrnxl6He7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=itzBB1s549zwx+HLN6JHjb/QhcfxIdYDE7FeNHKawA0=;
 b=dd3QhDTuy8tUr4zRbk7ojFcmB5r7TEBlRGEsntbfhNRSzaDwneV42kJUsSr1/rvfyZhDiDJgO55G4dShFh6INS/qe4IPYgDHELeTZbRKg90ZThj4nqYhdLTkhBfdXv6tV4ZKhbYLkzAbK2feaNp6t4i3C4eY0ocFW31XNdMd9md70KAZULGD0jPR3kXVSCURpOfOHW0yZUKbeAF2Vsfy5QJ3IjHDNiiRY0G7N7WSfzbwAHgUNEOiY7ZM/y/3jLj65QX/uQVMIhtxCAfzsiF8ueU9kej4qzQlJGhboWGUmAqAaTRzkJqY66hyXvAvoksqzCyyShC6rAC1ielOIhdqDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itzBB1s549zwx+HLN6JHjb/QhcfxIdYDE7FeNHKawA0=;
 b=ftUq+7VCzEwe570b4txYsd61Qqsau4qQmc5jCfe7FevLuGylhxpNMfvPg+PyPMvUKzwUb4r3gKfz3CTV2N7X/BkddsTQzpqV9ypv2dZ25dnwx1KK8IjZUx4Rmne8TtK81XZuHO4FT5p15yZkfyyIhaC3iqbKpMdRzxJ8OAIt+ZaTchKh/Qu7j2R+64OHyCwNWMzimlJOEJGijJZoboB7MT45zNIBUPVXPtlpaPBreB+Y9uuW4Ex3b2aBlKflR0oGE6KzNVzzwjlniEjPzQyVGoQTxkQl9rCrR5gVf5dtPkmx7tIqiePlWwGxNhCumDlOj6g8FtC3/m6cHYlYMQWf3A==
Received: from DM6PR03CA0066.namprd03.prod.outlook.com (2603:10b6:5:100::43)
 by DM6PR12MB4153.namprd12.prod.outlook.com (2603:10b6:5:212::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Wed, 15 Jun
 2022 01:17:21 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::f5) by DM6PR03CA0066.outlook.office365.com
 (2603:10b6:5:100::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.19 via Frontend
 Transport; Wed, 15 Jun 2022 01:17:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 01:17:21 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 15 Jun
 2022 01:17:21 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (10.126.230.35) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 14 Jun 2022 18:17:20 -0700
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <vkuznets@redhat.com>, <somduttar@nvidia.com>,
        <kechenl@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v3 4/7] KVM: x86: Let userspace re-enable previously disabled exits
Date:   Tue, 14 Jun 2022 18:16:19 -0700
Message-ID: <20220615011622.136646-5-kechenl@nvidia.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220615011622.136646-1-kechenl@nvidia.com>
References: <20220615011622.136646-1-kechenl@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18485cef-8b2f-4d7e-468e-08da4e6ccc5d
X-MS-TrafficTypeDiagnostic: DM6PR12MB4153:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB415337739D90076D1F38BDCCCAAD9@DM6PR12MB4153.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qQ5KFMWJE5GklRMAk/rriWtlSlzf0gqHSUeZSZTuSC9XXE5krvSk/ewazp+1/i366PEeHBbLp3fzqhboj7Kd7im7gj4NcJIoZLfmcNJMcQ9jsn7SmgrAaa4vGBQd666peg1mJgHssaYmUSK1zRv90z5kD8WpVgW9E0jaQTXveeuDMONTfGYxcA+GTFZ/PK0sFIBeav0yqIKu7zDXaL8GrcEqqLpBJY+kUlqsUk376mhqxhA6eTf/1gMDyiQFQei5qtq0orZ6k49B7xJNQUgOVSOcwrBFPDdXSni0e7aF7PBbCgRlfW+V1Q13tHa9WX6MSP4Gtqzh+aBb74EnU+JugRldDwiSqP5GygjYGlgaxZv+Km4TYFT9G6Fcl68FddVvr3GLbb6LHaeLyi3prRqqqZoVS1g0M/D+HrdtOItspDe6VeQZuFulnqtdqY2Y5TQAvFubTMTzW+wZs0pq0Yl40yhuM37o14Lx4nSPoCL8TRALDhDOavHet3nzIrbZyvO2H5H4xtVZKL4EZhRQFWAJxbC78wO3yFjEUyf3Z8k/5AziEGdTNX1EYfs29c2el61a9kyNKapgOb1DlOhFK4z2UZwkY0To1pQHan5lSjIdmIezEUmWPZL/jaluEuzyogOjrxAAkzTQ9Vq0mGtONhUUPO8Pb7mSDFiLKabbgegzF2w8SdkK3yEhMt5hy9FpBom/3yrw5CbOoi2gC0j3W8NYeQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(46966006)(36840700001)(40470700004)(8936002)(508600001)(81166007)(5660300002)(40460700003)(356005)(110136005)(54906003)(316002)(70586007)(8676002)(4326008)(70206006)(86362001)(1076003)(83380400001)(16526019)(2616005)(186003)(336012)(26005)(2906002)(82310400005)(7696005)(426003)(47076005)(36860700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 01:17:21.7039
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18485cef-8b2f-4d7e-468e-08da4e6ccc5d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4153
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Add an OVERRIDE flag to KVM_CAP_X86_DISABLE_EXITS allow userspace to
re-enable exits and/or override previous settings.  There's no real use
case for the the per-VM ioctl, but a future per-vCPU variant wants to let
userspace toggle interception while the vCPU is running; add the OVERRIDE
functionality now to provide consistent between between the per-VM and
per-vCPU variants.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst |  5 +++++
 arch/x86/kvm/x86.c             | 39 +++++++++++++++++++++++-----------
 include/uapi/linux/kvm.h       |  4 +++-
 3 files changed, 35 insertions(+), 13 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d0d8749591a8..89e13b6783b5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6941,6 +6941,7 @@ Valid bits in args[0] are::
   #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
   #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
   #define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
+  #define KVM_X86_DISABLE_EXITS_OVERRIDE         (1ull << 63)
 
 Enabling this capability on a VM provides userspace with a way to no
 longer intercept some instructions for improved latency in some
@@ -6949,6 +6950,10 @@ physical CPUs.  More bits can be added in the future; userspace can
 just pass the KVM_CHECK_EXTENSION result to KVM_ENABLE_CAP to disable
 all such vmexits.
 
+By default, this capability only disables exits.  To re-enable an exit, or to
+override previous settings, userspace can set KVM_X86_DISABLE_EXITS_OVERRIDE,
+in which case KVM will enable/disable according to the mask (a '1' == disable).
+
 Do not enable KVM_FEATURE_PV_UNHALT if you disable HLT exits.
 
 7.14 KVM_CAP_S390_HPAGE_1M
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f31ebbb1b94f..7cc8ac550bc7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4201,11 +4201,10 @@ static inline bool kvm_can_mwait_in_guest(void)
 
 static u64 kvm_get_allowed_disable_exits(void)
 {
-	u64 r = KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE |
-		KVM_X86_DISABLE_EXITS_CSTATE;
+	u64 r = KVM_X86_DISABLE_VALID_EXITS;
 
-	if(kvm_can_mwait_in_guest())
-		r |= KVM_X86_DISABLE_EXITS_MWAIT;
+	if (!kvm_can_mwait_in_guest())
+		r &= ~KVM_X86_DISABLE_EXITS_MWAIT;
 
 	return r;
 }
@@ -5264,6 +5263,28 @@ static int kvm_vcpu_ioctl_device_attr(struct kvm_vcpu *vcpu,
 	return r;
 }
 
+
+#define kvm_ioctl_disable_exits(a, mask)				     \
+({									     \
+	if (!kvm_can_mwait_in_guest())                                       \
+		(mask) &= KVM_X86_DISABLE_EXITS_MWAIT;                       \
+	if ((mask) & KVM_X86_DISABLE_EXITS_OVERRIDE) {			     \
+		(a).mwait_in_guest = (mask) & KVM_X86_DISABLE_EXITS_MWAIT;   \
+		(a).hlt_in_guest = (mask) & KVM_X86_DISABLE_EXITS_HLT;	     \
+		(a).pause_in_guest = (mask) & KVM_X86_DISABLE_EXITS_PAUSE;   \
+		(a).cstate_in_guest = (mask) & KVM_X86_DISABLE_EXITS_CSTATE; \
+	} else {							     \
+		if ((mask) & KVM_X86_DISABLE_EXITS_MWAIT)		     \
+			(a).mwait_in_guest = true;			     \
+		if ((mask) & KVM_X86_DISABLE_EXITS_HLT)			     \
+			(a).hlt_in_guest = true;			     \
+		if ((mask) & KVM_X86_DISABLE_EXITS_PAUSE)		     \
+			(a).pause_in_guest = true;			     \
+		if ((mask) & KVM_X86_DISABLE_EXITS_CSTATE)		     \
+			(a).cstate_in_guest = true;			     \
+	}								     \
+})
+
 static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 				     struct kvm_enable_cap *cap)
 {
@@ -6018,14 +6039,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (kvm->created_vcpus)
 			goto disable_exits_unlock;
 
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT)
-			kvm->arch.mwait_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
-			kvm->arch.hlt_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
-			kvm->arch.pause_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
-			kvm->arch.cstate_in_guest = true;
+		kvm_ioctl_disable_exits(kvm->arch, cap->args[0]);
+
 		r = 0;
 disable_exits_unlock:
 		mutex_unlock(&kvm->lock);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5088bd9f1922..f2e76e436be5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -814,10 +814,12 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
 #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
+#define KVM_X86_DISABLE_EXITS_OVERRIDE	     (1ull << 63)
 #define KVM_X86_DISABLE_VALID_EXITS          (KVM_X86_DISABLE_EXITS_MWAIT | \
                                               KVM_X86_DISABLE_EXITS_HLT | \
                                               KVM_X86_DISABLE_EXITS_PAUSE | \
-                                              KVM_X86_DISABLE_EXITS_CSTATE)
+                                              KVM_X86_DISABLE_EXITS_CSTATE | \
+					      KVM_X86_DISABLE_EXITS_OVERRIDE)
 
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
-- 
2.32.0

