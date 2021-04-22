Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3A2368508
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 18:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238011AbhDVQkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 12:40:24 -0400
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:61792
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236627AbhDVQkW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 12:40:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RK2UQYFA2DrXKkQ+m91Dra79rZ23uTGHb68bz3IXwQnHCv52GzCG/eLr37utKO5H6R5SZUgUXguMHGKbwy4l7Y1o0Zcu6naSXR821gH+HAVQYET2WuGpzMnO3VbuMOtd1zOrCTP2hYFx1hKNVhffGSGjWscZLKqNE1eDXp0soiCJm988pZzGgne67wBbmTWAJMWx5ScZzIIaIMvqO8GMDVmdI6m4TYn9KruKGe1uaPSmoRTXl0qolRorLXOiyX76RCYN8jpCszKchtPyRn0wEcHqPoUK2n3dbfdONSo9rkdY5oS1l6luI6vkmPdi7uXoeIxAH0yjoOGg9c9XYilIiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=suPWH9bl0K1+mahnGBn6QWxHfYVbSDId4Kaw+uxxWog=;
 b=nBvwEXHYF5BYOSHCI+XuG2CNK0p8PkBpYRwYQTxTN/4lGn+rcmWqYX6hauswKNvZcd8i0HKd+vTyEO8UShbvJCdIoGaXp8FEHlMLwYMxU4Cu+4vyqVuW/xhvR2xvqbI8w++WZyqrpUDh5NzpcKi8QTxfQFR5KOGdhgDxW2L2Fq2H9lA2RL9QSlBtuJn/PW4wKdncgXWis3PkzyDvYVMWoP4+ZTVpaVc68MGBFnlhXElB63PRPt4MA/KBNj8BFh5QKnJvhaz+t0LVdyfmuAdwsq7hiDRzEFf35UKd8m+du0JMVHyEIBftgFIDUlUYliN1uyEFTNm5fUzBpkPNwp2ixQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=suPWH9bl0K1+mahnGBn6QWxHfYVbSDId4Kaw+uxxWog=;
 b=b1RwjPw1a5hFd9j/qV9NNZMwzzaQ2vpArt5pg1EkbJtdYGcOr5ZLENc2+/UNCv/AtnqmUMf29qMvCtd00/bFtMmbJBuZjyOwwofHx88uAY9UL9K9rTryq3AfE+ZhMEgj/B+tDcPqsR5BrUqBc+ArGC7EFLx2QgfkE/fVMX/l8CQ=
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
Subject: [PATCH 1/4] docs: kvm: fix underline too short warning for KVM_SEV_RECEIVE_START
Date:   Thu, 22 Apr 2021 11:38:33 -0500
Message-Id: <20210422163836.27117-2-brijesh.singh@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2cb90bb3-e98a-40e6-f541-08d905ad3cc5
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4495139D6D3A33B9349D6540E5469@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zvsn9QEoe4xcP3av5gp6yHnC3T18+wS7FjZWd0wPYkEcaXzm+l0BOmjNtugoeY/FT09Rk0lgXFi4Zh5XhOMS+le0Tjz+xuyGHINQfZzoOSDi9aHtQRtLOyG4z1uwKBe1YgkKfkKSwBTyw0XwLqq5swxX3Fd+uAuDByxUHA8aBZj/aaQM43olaKlEOrpefXnYymaw5eHNidFCxbiNX7UK+NEq/dIASVOE5l8iWBc7qK/E/JSWIImwlOu1/nh3qcLpb/rxaDcqGU28nT/q8UAupbv0FLCchj95TcPXMdBF7LXkBrKWYLiR/KxZ+VClNczUGQ5vQVhWchYJa3InmhfFvOhrOVS+VMPV44A7sW5zuGpy7m33beoIMXf0EHp6qdHdoeQrecQrGCPocpXaXwiONKw6VGrWbg/AasZZujESOfDT63wmhjx7GeVVs5Q5vkZnIr2d/XOrAZgWWXt/qzi6czLwyq+yTjPgKo9Q5Y5CiDuRsKiTSrEu13TZfCoMd/jH/qjbFSvCvIusu0J5tL6MeNJFCpm8XRVz09yUQkuYTA8Xg8js7O3bPE5XDQowxsjrif3znsDeaVNBbvDRHwsNgL6ENHnXfZa8pusVjFRK/bbXYjPBsLF/SA9LcGYBJk/AO1vl61JK5D6azIHYam0uZsLShyi+T4Afw013oWuQUQc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(346002)(396003)(39850400004)(26005)(8676002)(66476007)(6486002)(4744005)(956004)(1076003)(16526019)(2616005)(36756003)(478600001)(4326008)(5660300002)(186003)(83380400001)(316002)(44832011)(38100700002)(38350700002)(6666004)(7696005)(66556008)(2906002)(86362001)(66946007)(8936002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tBDC5xr8cB4SRcKTLw4DCPkaz7tonT/1Ta4hbtMxpjsp4BEoOdQzJ9S4hGXh?=
 =?us-ascii?Q?Z0fMbW77FkotiSdtJbfcAfAAwL9QIDZeA743eXz1VxDN5QrhRIiBHybtLyJe?=
 =?us-ascii?Q?siihyd20AD/Ogg0ZgOqG4pHgqmhIk7sbgvivFiMotxqAc3+t7Lu9n4xddSyP?=
 =?us-ascii?Q?M8HRxjwSy1kz3QeNMWqR5Te6ewDRT466e0kmg9XtLlA8qjuRruKef8c4sS4+?=
 =?us-ascii?Q?tQjBaicPdyGsIIGYGprHYVD6rhAET9G7VKVEGZyA+cqnGPCoX5564m/l3Shb?=
 =?us-ascii?Q?EXaKNMQzCljA6S7vAY+VohS7ZQW+mVym5NAQzKzjZ9fWRVf/8/KhqId0fM9f?=
 =?us-ascii?Q?3UmzP/SpqF2+DLmQXn2DrIbnJzVeFOCxF5XPvPtfur+JeeycNHhEmoYuP5pG?=
 =?us-ascii?Q?idxRwC2qxOjtszAuWco/ATmCx7oF3jY/n7AtukB8WCXW/+0COWshgo24SeP4?=
 =?us-ascii?Q?9nKkSpq86k0LFTVI30G8My4Fxge9+Fe01MZQZwhvGZZOYgnJf9jAsZi1dCR/?=
 =?us-ascii?Q?qsIn+VgEmdVc2h73lAWKX/imz+z8p9icX3fppZEi8jXvuozZvSLeySY8ftiX?=
 =?us-ascii?Q?09ZUfEGDbmQYk50BqWEksZCQg1o3BNETY53z+3Xnp0wXVBqqvlfyvHQ/Jqw6?=
 =?us-ascii?Q?qaVf0ysJnPY0qZH7rVwU08JvcrYykI4rJtyM3+XySXRhLf+9EfRHq3rUA/JX?=
 =?us-ascii?Q?j7UEDPMR+NAWKfpn9w7qsK05yW5GuSGfV4Sw55g82jtfbxLF+Sa7UtwMkW9H?=
 =?us-ascii?Q?P/2CSPoJ1ohqKbLraWx4SAu+HFo3mOyFnGhM53Gt0lt9xXiJUEgOcRIvIpDM?=
 =?us-ascii?Q?0xBO3/1WWcWF7p1zoM9gC1tMSwsXRYTcj7c7E0d8T9jBuImD8IieRJ7X766c?=
 =?us-ascii?Q?7/IoHDkEBeiiLb3/dErMPDRfR0QBrFwaC2jjoOEo5a8Sy9/AWbphGOdj3iUp?=
 =?us-ascii?Q?wqJpewsKsFE4rHC1/G4WbRlDn2AP4qH2bel9IFINfJD4k/jM4dax1xwZ8qXg?=
 =?us-ascii?Q?yN4RQ2uZbC7yS8azsgFwdSUmqvUBkDq6m42ZWYelBZWO2+0PWkTqLRJfNJLj?=
 =?us-ascii?Q?tIrdMF5meusjk6cdxA6dAr+fOJVJZ8wbzGyNF+VsedE/SOsQTiwphLcw8cyd?=
 =?us-ascii?Q?wMjUoPXWjEqm3Ym8BN9BGZWcSzoSIsPvdY8uH0h8cyJbALBSl+BKblBPxFBV?=
 =?us-ascii?Q?P5N7XiocmeFoStIF6QQJPdzjMJwowFQFxjkz0OcwqUz8GPPICnZk/c77qg/g?=
 =?us-ascii?Q?Qu5Ix4v8M+e2ps4T+vS022oNEnNhWDm2+F5FeO2s/RDvArNkG4yt1hL4qlEE?=
 =?us-ascii?Q?U/Fm+y60Q0G9vbGPRe/3WOjC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cb90bb3-e98a-40e6-f541-08d905ad3cc5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 16:39:45.7962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ivVo258cHORq6Kj1lsO4ESenGFZKkrCUERpbwOeteb1zwbv0le7zdl6Cha5u0sNl7xVh6hGUxhGimoXYaiauOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes: af43cbbf954b ("KVM: SVM: Add support for KVM_SEV_RECEIVE_START command")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 Documentation/virt/kvm/amd-memory-encryption.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 907adfe60090..07f8633b61cd 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -366,7 +366,7 @@ migration can restart with a new target later.
 Returns: 0 on success, -negative on error
 
 15. KVM_SEV_RECEIVE_START
-------------------------
+--------------------------
 
 The KVM_SEV_RECEIVE_START command is used for creating the memory encryption
 context for an incoming SEV guest. To create the encryption context, the user must
-- 
2.17.1

