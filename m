Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF65254BF25
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 03:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238761AbiFOBRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 21:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbiFOBRO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 21:17:14 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF532A720;
        Tue, 14 Jun 2022 18:17:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXEW1jtCmlUxkDXm2Nf6EOXgMv2cSB64ihHXiNQ+0zr9zNtvTbQOZ82h0dBtKinUboqM6JMyl8SAqNBuIW7FmpsG905LqLAf2Px3m83Ww5Uxk1V4jy3utfaFT2AKUhLDa/+0EGP+9Js7jEIBh7t7zSfHht8DWpCiF7p3d4AjazgxT0y3g3iWyMwmxdNgS79WXvspuQ/jJkgcKDOCTjaQdtx6gnNMHBC5TnIU7e74B4at017+phaK5RweGgTUP1x4WLnXQlG7TIm1MaYvhPdZpGNcLZF9sGau1ENFUSvFjkS0dSr82jDkWSU/gk66ONdpGkuMiAE9l/Lhqx1Iv6x8AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GIwLnEbVk8hlZfhkVEeyots2gpBoQWKS5Xh6mUr26Og=;
 b=Jljun276cLaxPZvYL9DAyfKA1X6hO8zo8PVDJsU2oLlz2B0VbvkyEfSw0oIMmaF34ymDGtOmy75wm9WGdzqnoiozJSTR66ipCXMIRHXl38bVo2IszBdR2xqmo2Vua/kmYg3Sxtu9Ge9ixsC3XeIMkqAZgEV72L/OAOvkjjB5BvkYcwoaKV2VWfJpiL4KBD+nJtZu89oKWZlwPf8ARpPfnBT0xhOSU5jYZJ5UPYnUeMvx2ANvh7xTggM/01moZdK07eXHUr8B/42y0jBMjiFjogN61Kd4fE4IH0fsBOH6FGrsyTJGQxCALapduuK01YriX1IFQ1IVnuQg8YHzR4wtww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GIwLnEbVk8hlZfhkVEeyots2gpBoQWKS5Xh6mUr26Og=;
 b=rAAep5TWCNqYMArnDqxwb+QdWCKX/pPyQ14igazFlV4bLutWbUWg6mOCnkjdu8clkFyZ12J/C+fGGYrj4LvBQN6zzfaeL5tikRRq7MbQY/+gbEqi+ubiNkvO/4iPossGKQjN0w8/o4wSc51FQHkYzruKJNZixq6zZH2ykU4DAyvq86JuuAUq7LPin3Nc7nAEfI9Qvjpa+/381RIAk8dtUO4p4nnAxCFKsak1vH8N8xaKtxGJFxGqL9G7wK5FtG8BMQIbADQVuuTbRmcLfI0ssd8hpMyi9t97bYlPI0XPOwikmETWxHSd0ZAPlThekYdMG7anScABX6Ches7NiKZ9fg==
Received: from DS7PR03CA0042.namprd03.prod.outlook.com (2603:10b6:5:3b5::17)
 by PH0PR12MB5404.namprd12.prod.outlook.com (2603:10b6:510:d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Wed, 15 Jun
 2022 01:17:11 +0000
Received: from DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::4f) by DS7PR03CA0042.outlook.office365.com
 (2603:10b6:5:3b5::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.22 via Frontend
 Transport; Wed, 15 Jun 2022 01:17:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT036.mail.protection.outlook.com (10.13.172.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 01:17:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 15 Jun
 2022 01:17:10 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (10.126.230.35) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 14 Jun 2022 18:17:09 -0700
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <vkuznets@redhat.com>, <somduttar@nvidia.com>,
        <kechenl@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v3 1/7] KVM: x86: only allow exits disable before vCPUs created
Date:   Tue, 14 Jun 2022 18:16:16 -0700
Message-ID: <20220615011622.136646-2-kechenl@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2f8b7306-e234-4708-f8c8-08da4e6cc620
X-MS-TrafficTypeDiagnostic: PH0PR12MB5404:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB540485595BB544E5C804F3CBCAAD9@PH0PR12MB5404.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IyrHq9qn4kD72E2H58EXbdusWL3yCO/1n5YcqhcqPm8D+sfAp7GFt49Ym53cFOny4usexcdi+bwf+Wwx0JtzRojETjWHQHi+kc9KfakDXgvsnhW/JxWcK76p6mCxR9KvgjWXZD/Mih5ms8pHPMhFNWlBADBvlrfuO87tOFHoyvNmLL5kkKZEp3I4Ffbl0jrzpgY0+MEQgQgndpwhc4a5YSQXY+1IzQv7sj1SdlK95mq+N59v/2S+JXAkWm3gahn2O22IZvDxZEgW9eQ27wtI4UH+aAcUDN4qGvJM+X+kmfZXpY8hPY/2uqeqDaDgww4QhKH4wye9FhePwuO9Ci5XomKTvXPl2c5UqYRWSEiuGuoH5hzrBKkumwMvV1BsXWVqkU/FlXvU3OG2j0EiUDUBdj/4GzL3n2d2M9yvVdqzdq/zgR0YvU1FfWlmYn/74FYn6lk7pAHP//wPXVk0tSPiq7PN7RmkKhArgQYOLZ+EbULzuWxSKDDIVrX0PApDCh+fA4wN7Dffc6DLwnkIW9vjwKIypMHqreP1K8LLRRTmdlEkt+aXOUZx9m2lxLbK5ezy0yQ9Qqxac6FUTntcBqcIoippYgqu4sd1xgmavDhbcK5Q/oZzqLGbrrHkLc1pWBoYRTOWGP4nXP0X48P+VakXd4QIAMHUk4qBH8YgBaDTQJ6ifQ0AfNXiKo4c+b16Acd/+tXzcYv4iCQvcNvfrtzxnw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(36840700001)(40470700004)(46966006)(2906002)(2616005)(8936002)(508600001)(70206006)(4326008)(8676002)(26005)(83380400001)(70586007)(54906003)(186003)(86362001)(6666004)(47076005)(336012)(1076003)(426003)(40460700003)(356005)(7696005)(82310400005)(5660300002)(16526019)(36860700001)(316002)(110136005)(36756003)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 01:17:11.2736
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f8b7306-e234-4708-f8c8-08da4e6cc620
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5404
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

Since VMX and SVM both would never update the control bits if exits
are disable after vCPUs are created, only allow setting exits
disable flag before vCPU creation.

Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable MWAIT
intercepts")

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kechen Lu <kechenl@nvidia.com>
---
 Documentation/virt/kvm/api.rst | 1 +
 arch/x86/kvm/x86.c             | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 11e00a46c610..d0d8749591a8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6933,6 +6933,7 @@ branch to guests' 0x200 interrupt vector.
 :Architectures: x86
 :Parameters: args[0] defines which exits are disabled
 :Returns: 0 on success, -EINVAL when args[0] contains invalid exits
+          or if any vCPU has already been created
 
 Valid bits in args[0] are::
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 158b2e135efc..3ac6329e6d43 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6006,6 +6006,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
 			break;
 
+		mutex_lock(&kvm->lock);
+		if (kvm->created_vcpus)
+			goto disable_exits_unlock;
+
 		if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
 			kvm_can_mwait_in_guest())
 			kvm->arch.mwait_in_guest = true;
@@ -6016,6 +6020,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
 			kvm->arch.cstate_in_guest = true;
 		r = 0;
+disable_exits_unlock:
+		mutex_unlock(&kvm->lock);
 		break;
 	case KVM_CAP_MSR_PLATFORM_INFO:
 		kvm->arch.guest_can_read_msr_platform_info = cap->args[0];
-- 
2.32.0

