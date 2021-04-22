Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DE936850B
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 18:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238106AbhDVQk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 12:40:26 -0400
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:61792
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237920AbhDVQkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 12:40:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RFSP5HpYYYLmcwLqZqPB6Tqmm+iykQMQ5dbxMUE6S1BsW0YAXrI5hWsaSlwYVtSIupdMvq21htDdcrukRuHCWQeiVjomi8Y7r9Y0tKtAYTNy4JZa7FuE6AwhI5zPE8DoKkKcd3DrAbdd/Qu7pdlMSLZxhcJ4mecbvOYVlo9wRT0/MULINDvxVazowIL0csCdEZi+ZHZB8OBKggKp/m++dg8G4zRuqq8+RH5nzA1PWey+FZS/tqF72uwkCNqhEr2zG/71dirBwJ03bxzZzOYoJ51NTZOjgOBs30XM/RJU2B8mtGpDxiVXCHYMSsa3aHkY0NeOv/pio6IXm7ozQUMfOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKW8Betutlx583j2ne8bboN+lfkQNHJNO7OIEIj6B/c=;
 b=bxE1sAUCChnece2rcIAbojRMU1kjndHpa3/QlrJow1e6YZhQCTwQRDqd57pc2WPkhaMGgIYI1bVlja0Y2ihrsLgVpYtgTrZE+Vzy8t2Oca/okyqnxtubWT36BhCDiAfqOU8QhHOgJ4qVgWKnL/3HlWn1RFmoWqaXjOs93szhKZW6NR6f/V2FKmzhvWSH9rpSadnkOB0SQ+Znub4srgNbhhpCPYGl/bh9Ww5+02VZ1m8q9jW8X3nvSln8YyJ/yUOU1pMmaF/EuegZCdyZ12qrHyqDZ1bBjV0AXzAj+qEz4KMDa+rf57tk6xs/GwQZ5wBA6Bn5ntUrDsNq1auGHwstAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKW8Betutlx583j2ne8bboN+lfkQNHJNO7OIEIj6B/c=;
 b=YTlCm5poUPpnvfcw7piZ8c60O5HaZam7MrAXRYQlvueMVLVqffTqPP3GEzXhpLWMn7L6I9N1seoq0EKZBPSVAk2FjDIArC/CoAyKUxXgcW/LnrhXHD9jpHhgI+d25OJPLsNptEH/s6u4a3Xl2IejvAIt4NVhbEvXFV6PeEfL0zY=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Thu, 22 Apr
 2021 16:39:46 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.023; Thu, 22 Apr 2021
 16:39:46 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        Ashish.Kalra@amd.com, Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 2/4] docs: kvm: fix underline too sort warning for KVM_SEV_RECEIVE_UPDATE_DATA
Date:   Thu, 22 Apr 2021 11:38:34 -0500
Message-Id: <20210422163836.27117-3-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210422163836.27117-1-brijesh.singh@amd.com>
References: <20210422163836.27117-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0059.prod.exchangelabs.com (2603:10b6:800::27) To
 SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN2PR01CA0059.prod.exchangelabs.com (2603:10b6:800::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 16:39:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd4f7468-6e0e-4681-202e-08d905ad3d0a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4495922ECB84508B09C72A8BE5469@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aaUjN+75853zapLG8l/UtlVD6ru+TWTdBzikMA451rXS43dbzsq/2+YSNSLYyJjbliLU5jC64sLbbpv1krtXk9p2dPSwwrKvkO9YobRiQM2azfgbV/iuT/FpQEmJVnoRh6hZbPEOtUTQcm6fytuHH18ycVKAX0suIwIjdwezVNTIBOgT5jHWlR8V6KBdolg4R+b23Rf+/TMsmcajQSMHpwT1zfX/4aiIhdwBH1c8eHcITz5oqsO5bG/6TFRi/PwW4XZmNGPG5Ae5Y8JD/q5SliS+vJ0ijrJx0FXIpnyslqv7vh8ytQ9+e8ce+PxqLkWi6Ajp/FqN3V/RrzxogQdy0SnVSal6UOSf7sTOX+7f4FlfA3WGsusnBhmZcKpfkITQ4CzirVQoyuj0WBbftenQQUudlFAe+E4gWM1eXTNy3Zfw3mB6/LPFXp+DbnAkv5SdcUVt0KmkbVq1NO6BPjtsqrTw9j9vc71dcXTfxrbgCQDXtEx39WU/6uCNVRt0MMCf1/eYm6pDJlXG6mGtacGR5aR99tuMrDYpQRQi1gerxopb8fZtrOFrOvwk0Ac3JVkv7IUy0eXrREctZ+H7kh3gvd6UvfL+IqBkBAn0H9sulM27oQARf9l4i27X5bYMLO6oKwTlJ4Vad7N5mF653n7HkSmPock5wUjqkFLgGWyul90=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(346002)(396003)(39850400004)(26005)(8676002)(66476007)(6486002)(4744005)(956004)(1076003)(16526019)(2616005)(36756003)(478600001)(4326008)(5660300002)(186003)(83380400001)(316002)(44832011)(38100700002)(38350700002)(6666004)(7696005)(66556008)(2906002)(86362001)(66946007)(8936002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QakPFCdbprdZgYufxlgUmgqHITAxLvQFrbdtWmyqLl/9gW8aOtL6WjvomIR4?=
 =?us-ascii?Q?uYeQLs0PFm4JF8qzRSs3MwKF0R80S8dZq1E44OAfH7EHqILjpi/5VjpOe794?=
 =?us-ascii?Q?M7EDdER+7N+tFxjgbUBhgnHYHmU+lhVZRB2BioxqAmksjua7yMnJVUifujOv?=
 =?us-ascii?Q?2MfpYUSPxSGj/8Pt5wHxjxTN5cHp5SiE17CVHJ3g9FXNtp6ygEIhmD/a4LWK?=
 =?us-ascii?Q?vVqDrh23LAhncSQmO90cT8nn5AViqT/3qgHbEE0GJED2arKlET+w24lv+Ddn?=
 =?us-ascii?Q?B3ADNOn//VRD+ymToBxKGVw1pD7MuM8unMGrSUgzTksjg8mT1B17oOkbH1Ml?=
 =?us-ascii?Q?t0PYIRpF4kmuqFs1l8NQof+GjPiiYcmryVM2pb7pf46DGCsEZMDguxQ0kM/2?=
 =?us-ascii?Q?ztfagE9mwLzu51zSw3T47Bz3eJbw9nVT49xFYJQHe6UYuObTcxbuv2iV0r+s?=
 =?us-ascii?Q?8uORP8eEwH9VXSqFe7yMEVH3Doeym38bTbb38BYRjz+QBT71v5do4zCkuQUr?=
 =?us-ascii?Q?jar0BczHA9aonjh9G0Cz4rVyNdPUbkwJVzdTxdYXnQJajovKDDm5rFOMsbiM?=
 =?us-ascii?Q?PCc/1RVREmygshlgMCjj9aKFzXS58LSfwRpHqY9IBNnaU+s5wPfO45E5fc6T?=
 =?us-ascii?Q?/6OdP+RKLsUmM9cCLYz4WeM5u0gwcgoDh5VKtYCE82rUlSL0i6pFVJVe8Mbh?=
 =?us-ascii?Q?ovBFtG9KrjMDYKfDXuIXz1M1wwk76bzqWPQKf5EYz2GHH0v/G6TISwtGq/Cs?=
 =?us-ascii?Q?gg4c8GVI3jlZysfwyN3/iPZkkk6XdwkeTDMk182E6a5d4sXKU0hNgNS8wyyd?=
 =?us-ascii?Q?1VDxvDXm5Ch+YJ7r+w376qoOStgA1MAvN87IaMk4USFUFUogbUFGJp2103Qi?=
 =?us-ascii?Q?rGaSeAnh/VCpnARhvfVNy8ueOl0iMQq0M7zCWgBiKJrIBD/d6YlONgLqD+7i?=
 =?us-ascii?Q?0489OJcv0AtpOsftrBZuQFIucljHovNXjnbeZBk3w3eMmLx4SfqkP0FXP9FU?=
 =?us-ascii?Q?3CVs6GZUXhI5RINWmkdzCEBzJKDXSBhfG95EzvsWZmgFPENy8yKQUH6huDoD?=
 =?us-ascii?Q?ucMir1V5pMfHPWvxcH6ntY7Yo9cXx4o34VMS+kHci6JyOULkxJehCqM5AL7v?=
 =?us-ascii?Q?nDXg9IaO/NDPfjem9Y2V2S7gudxXkhSzX9AxwkptNvgIlhJxA4ovSfxjhc4q?=
 =?us-ascii?Q?rSkgud53BQWE51TxS1Jad+NjbjKKOfZln3EikTitczXLwdJOZ3bNLRuVcgr4?=
 =?us-ascii?Q?byDRxcQpz2OlfHsVbEP7i9rKEQ/jxR+PVTSxgUrkq0G8xGQbGxzuOHDzYp8l?=
 =?us-ascii?Q?z/wKkGP6yo1v3tLyxigmJKoD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd4f7468-6e0e-4681-202e-08d905ad3d0a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 16:39:46.2380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WHpbJYThSqjFrrT/ZcYKSEFvX1ozm4sPthYUYc/LO4TprekaYHCCLZFET2kOYOPmQfbs9Ai6+Su9j+BXo/2FSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes: 15fb7de1a7f5 ("KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command)"
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 Documentation/virt/kvm/amd-memory-encryption.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 07f8633b61cd..bc8e5b7f0c35 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -395,7 +395,7 @@ On success, the 'handle' field contains a new handle and on error, a negative va
 For more details, see SEV spec Section 6.12.
 
 16. KVM_SEV_RECEIVE_UPDATE_DATA
-----------------------------
+-------------------------------
 
 The KVM_SEV_RECEIVE_UPDATE_DATA command can be used by the hypervisor to copy
 the incoming buffers into the guest memory region with encryption context
-- 
2.17.1

