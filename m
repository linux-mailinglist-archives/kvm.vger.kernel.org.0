Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5597347BC71
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 10:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236063AbhLUJGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 04:06:02 -0500
Received: from mail-mw2nam12on2075.outbound.protection.outlook.com ([40.107.244.75]:19937
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236054AbhLUJF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 04:05:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DscEfVfHTSjfOqQIA3kZmztjgQb2X1jCwZTaX3cyGgK0p+8850vGSQ3PJItdZqaWLbkBgxteXkhQIKZuCkGbdUXbEzrCUrZPo6563DyWdq4f98Wtx35SGbU6NgUHSME+VsYWNQGTurKBaW9wQ/nhderk8VyoizrYekQ8c94F2r12KtXIr3BnnQKW9d03dWOvnzETzcXrcBhrF9NK2KTDDyv2F3RzpHVhWIZ+Z91xPF9itWtHAcmwrgyfWU8Kq4Vy66D8VaWTrooTzfpC+89BwU0wgRN0JNxt9T6ZZbPOyHf9nWozNs2POdLd0nH5vWdeyy1recxG2U7C12JFdX5Csw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=idCRmkspddIsTrTnN4sXVvRn11UCUN/PbBSkZZGaU2E=;
 b=D1DB6EnDf2N5FMKOMddZnYpOIJEveKbPdxhkFGOPUz2ZPHTfqVcu1Ut6vdYfzEgGVUe8zCqcTJ67wTPG4axm0NQxgWK4FoB4jjjm6zT6NzAPOFlxVa4VQ/4Sud4e8IAHmmy8uoHUdgVn1QprKaz2U18A1vIOTSPwUceyyAzCnR2sB1YxUEK3VtSio77/c2i4yXMKz4fLugWIAA3+6/3lRD60Ij47W0dnBqUShHvQDIImzk1d+eFlW1pmxbUMDd9oTCPo2xzS2HSnL76LnCDgnjE2C+vPvUeYTL6Af8I3/5+yK3scxLLAgObVaPjyC718BIMCOlOm+hXqMp2wKXDLYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idCRmkspddIsTrTnN4sXVvRn11UCUN/PbBSkZZGaU2E=;
 b=GEHhEIQWpcHerJlo44rG22Q7eVItz1UHwpoAQgtHfdHuutKR7OOq2ki9ZfhLxZkVwbC42GQZDaG8xuvxCYjHkQpiLnmORbaiFSsjftZCUpustijKP4kGUawmLQ1aGUDXSBvbCMMo+oyXcOR/Ed40TesAKCLWKiUJwj3PtgjcGluMtwX9ZVpCZI5ddQtl+CXmN0i+xIUTypJhEIpe5lzOUs1B4PSCobfnPFeKHtwQ16/kJ84CfHT3Be85uACihUNaMJpfakWrNX+ekelyUEl0kQ+iUfnLj+8bznTnE45u/WYqUJBPMRlRIu+ht5nbgGEDNsDdROv1sZpo8ckLKRv7zg==
Received: from DM5PR22CA0022.namprd22.prod.outlook.com (2603:10b6:3:101::32)
 by BY5PR12MB3811.namprd12.prod.outlook.com (2603:10b6:a03:1a1::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 09:05:56 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:101:cafe::1f) by DM5PR22CA0022.outlook.office365.com
 (2603:10b6:3:101::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14 via Frontend
 Transport; Tue, 21 Dec 2021 09:05:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Tue, 21 Dec 2021 09:05:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Dec
 2021 09:05:55 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (172.20.187.5) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.986.9; Tue, 21 Dec 2021 01:05:54 -0800
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <wanpengli@tencent.com>, <vkuznets@redhat.com>, <mst@redhat.com>,
        <somduttar@nvidia.com>, <kechenl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v2 1/3] KVM: x86: only allow exits disable before vCPUs created
Date:   Tue, 21 Dec 2021 01:04:47 -0800
Message-ID: <20211221090449.15337-2-kechenl@nvidia.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211221090449.15337-1-kechenl@nvidia.com>
References: <20211221090449.15337-1-kechenl@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc8e974b-8d3f-47a6-9821-08d9c461190f
X-MS-TrafficTypeDiagnostic: BY5PR12MB3811:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB381185F8B3B6707F1C9B457BCA7C9@BY5PR12MB3811.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AyadwvcX7/8o7nbqCjbiUebcHeBsf9Mtd/2Ek33IWqMk/ruYbAfKCwE1QaPjaWTW5fbBWzYa8BHrRz+iFd9Rn6DZUenvn7Vi9nzQDoxstEPXd2ODZ2iyz415svfEbiGaVZg62UI/LiyyPnZI3DNjWTNTthFA8TWf7wZ8ZeiIukkDMyY0+RLAUow0KGoeQPa+32UMK3xzJRMvTNvX5pH3BM6wrej7EB9G24eGFhkfdgSsqP3hx6+Dx5ZR//Z4VctD/fmJhcNCnEH3ERaSta3h7V00QK7D6GqX51va5RY/K0WcyqoSQUb4YcnT1lXltcje+lph5FSf6S87efoVlpRSeKzrrgEzfTbVS3Rzy02tr9ihEK5eKLSlMKaQ3xyEJIdExRxtquhcc13d/SIfqMbBWISljxZV2cDS/6E+rk94iV9DCV7rd48Kzy5wu9S5UonN+kQLTeSEKzCs3kC4ESNh9J43n6jJNgcNgS9Q2XUKrmAsaZRL/jmdkBdrGfgCYyu1jU9Kbna5EElfDiN/jv7Pzjmcy+BAe1FXYSwsN+nmU55dkOnMR+GKM77qo4fuNMU85h9o05eCSlbUIMTekGHlSvVolUViIQ0otaXtndXHKpGtgzs7d6/wKZv+hEc9V8peQ3xHszEakqEqlO0795HyIeHKQqtQrBGjfvULqXtx5L0YVBKjNSd6YMtLN9jiJO1UXUCiWVSlGhtplpk2y+IKyS14+tn6iu9+o4ypX+bVrcM4NIA9Oge5OeWHar5NB8XUeo1avSKOVeeGlwjGEO1fM4I4XL9HHamiK6Jlh3+bHcVo6NaCM1IbthSYYTEgnM+BW7JXMxw9DkGBqSAuZpTo7A==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(34020700004)(5660300002)(16526019)(36860700001)(426003)(8936002)(2906002)(186003)(40460700001)(336012)(36756003)(86362001)(1076003)(47076005)(4326008)(508600001)(26005)(70586007)(70206006)(54906003)(83380400001)(81166007)(8676002)(110136005)(2616005)(82310400004)(6666004)(316002)(356005)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 09:05:55.9802
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc8e974b-8d3f-47a6-9821-08d9c461190f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3811
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since VMX and SVM both would never update the control bits if exits
are disable after vCPUs are created, only allow setting exits
disable flag before vCPU creation.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kechen Lu <kechenl@nvidia.com>
---
 Documentation/virt/kvm/api.rst | 1 +
 arch/x86/kvm/x86.c             | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aeeb071c7688..d1c50b95bbc1 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6581,6 +6581,7 @@ branch to guests' 0x200 interrupt vector.
 :Architectures: x86
 :Parameters: args[0] defines which exits are disabled
 :Returns: 0 on success, -EINVAL when args[0] contains invalid exits
+          or if any vCPU has already been created
 
 Valid bits in args[0] are::
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0cf1082455df..37529c0c279d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5764,6 +5764,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
 			break;
 
+		mutex_lock(&kvm->lock);
+		if (kvm->created_vcpus)
+			goto disable_exits_unlock;
+
 		if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
 			kvm_can_mwait_in_guest())
 			kvm->arch.mwait_in_guest = true;
@@ -5774,6 +5778,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
 			kvm->arch.cstate_in_guest = true;
 		r = 0;
+disable_exits_unlock:
+		mutex_unlock(&kvm->lock);
 		break;
 	case KVM_CAP_MSR_PLATFORM_INFO:
 		kvm->arch.guest_can_read_msr_platform_info = cap->args[0];
-- 
2.30.2

