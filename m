Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2754636850D
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 18:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238140AbhDVQk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 12:40:28 -0400
Received: from mail-mw2nam10on2053.outbound.protection.outlook.com ([40.107.94.53]:20929
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237972AbhDVQkY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 12:40:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DVK8sJ6ze9eXkRFPQLI3PKepXKswusTDEDvlj9H4EUa2U7NJ6ANU9aVG6MqxroJcV2wlZh9QqEgX/yY4w0XdR5NWKccl6o5eD+wU3eRxr/O6bmGJTVjKc1m/MUIbYrPT7uSZ+VXHz5qXIkhBhf7UoQYzoHqfQN7okAXaAV8lQq3W83lNNqRNUpan1sS6Tu1XqPpRt0sYn6+kNnrvvu/zKe1LGoxZAuh+xADk+jioXZbwGNJrz+6BRShQpI1gy98NX1Eyc9NhUgdXzSsCICybEbrBF0Q3yRU+pjz5ljIZ7ClRPsKV/9SKetsRuZV4S2yVMAC16hfwDgawiNNf2USy7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=srVjAMBmxP5PLZiGofLL8o3oZArSe1UjnDwIqbxVB0w=;
 b=XixCSndnr0WvJ0DOE8U8i3zkW8pKfwpZJ/krKgYw8EbuyQ2c5NAdO9KA3HEiwksUC/bqD1Wtu9wnHWvIiFF+/U5WNibw4X54vqPGqAxo+8S87J+Obmi9Bv7OIAWl+/5dJii5ewO/oDej7FCGzrb8SEjDnn/4tQkQnU5cka24TSofbvgZRVYQl3JAznUDCa1eYnVDh3Cqz8nF+yNlM8+IL1WnyTdYVWF7aATxvZmhJMOQz9X0PXH5uicH05W+t8m7zNAdviEZpkK2ThU1UamWbz9C8BYXsynp5XESXRt+Fm96srdfmgsH9nhX8fD7DxiNvEiLM0GWpJH4MW5o1ubmFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=srVjAMBmxP5PLZiGofLL8o3oZArSe1UjnDwIqbxVB0w=;
 b=oII7xo8tPkbuXgU22Rt+6qMufpGYCCo4uw3jVsm2ztUJ4C4+I7aYf2RrTtssQs9Hz6JXuJ8KnG5dDr6uzNdtK0PLD1R+dpuves9kH8BWV1hGj8vw4fZqxT3sAylHTnLOohFjSdaUYlmy/WZewflSA8dPxSLSV5RIgiFTzUcg8Xc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2446.namprd12.prod.outlook.com (2603:10b6:802:26::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 16:39:47 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.023; Thu, 22 Apr 2021
 16:39:47 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        Ashish.Kalra@amd.com, Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 4/4] docs: kvm: fix inline emphasis string warning for KVM_SEV_SEND_START
Date:   Thu, 22 Apr 2021 11:38:36 -0500
Message-Id: <20210422163836.27117-5-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210422163836.27117-1-brijesh.singh@amd.com>
References: <20210422163836.27117-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0059.prod.exchangelabs.com (2603:10b6:800::27) To
 SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN2PR01CA0059.prod.exchangelabs.com (2603:10b6:800::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 16:39:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd90b252-ee90-46d4-4e4e-08d905ad3d9b
X-MS-TrafficTypeDiagnostic: SN1PR12MB2446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB24464A43BFA4DF96EA55BF71E5469@SN1PR12MB2446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ohq5+eLemu3Pc9v9HJsS2fuGF70SI7rgA8b53F9ekOxtR+hmQJb1c/99JCYxXz0UyHkRzC+AgKZn8fL/Yq6srs5YNG235fZtG/HRI08pdREgBtMSwYA7FCJZbCrL/88jYImixKUNS0rZ/+bZjm7xQjyJwHNIE4OmYDCYKmVwCg0qoMgCIunV90jpHfzeR2Vyn4U8CCpgG2S2+EjX5ZQc5bBIy+Rs7tpKAPjywvoAdT1ldrGtQ1X6362on6aKejaiNOtHdscDoGbDcd3K7WGpqj9l1EnwI6hkAT4dORvu1iw1E1eo7QnOBVhCf4jCASo0NGKvunQFaxRztGzUuCJuu5UABKFDQtniDLfxIhxIC/NM6h0VBaG6WV4Sx2ADXrWrPfKAEytWH+xchaoGVwdvilowhN8ACYpM2fk3jKt+CHbQjftoTfmENs7Aoy8tw43APj7AFyBe60Zem+9SKjdcvUYiwQFOHR8yLvG+HH1+HiW2M8cfGhW9os6vn3jn9FCpwU62pyTFer5o0PWIDo49JarCiJwkhwpaRju3S+RxOXwHOVWPn/IV3nZqiOoip59U1pJyAPgjF6QztiDzmrJzorWMJMic0blPuepN/MFI9VqABa4otyJi+gnLQjit9IhjHMC/la1/c63SC54iWL/Kxqf3HMptlzRYQ02jE1EaRcs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(39850400004)(366004)(66476007)(86362001)(2906002)(186003)(4744005)(1076003)(66556008)(5660300002)(16526019)(6666004)(7696005)(6486002)(66946007)(38100700002)(478600001)(8936002)(36756003)(38350700002)(26005)(8676002)(52116002)(316002)(2616005)(956004)(44832011)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4ICE8jCKXg/tstnVgBJzSnLunCe6F+Fy8eD9Q3bldSZU7ADcbgixnd5tG7mT?=
 =?us-ascii?Q?jPJzGcKYCLQzvLBgx4lnue/0JIxg4xCUzmFRl03j9wtyEd5TyV+4XyzOGmG2?=
 =?us-ascii?Q?6JGZgW0KE53vLh+QU9i1+T4odN5jR4V2SR1Mnhq6Y58Op+InzlJRbTJ4MtVF?=
 =?us-ascii?Q?OM4JEjyepgq7MYqHaboKtrh8kprX2MaZnBIoxQ37k+kjKsK+UYsTReXPFXU6?=
 =?us-ascii?Q?iDbSOjvRvrs/KQGFx1WFFZJmR1ullpfWT65cXz+WQz0bRBLhQWUkSAaJ0BlQ?=
 =?us-ascii?Q?Wx8ZICyNC8kA4PCj15XZyWekErP/GIW/p5DZ2qF1iGsqk3HQIvn560bxy/2h?=
 =?us-ascii?Q?jXDlh/zkjgY36NKUPy3NDrYcA8CqpvwvksHARCPNcv64HJG7AFPAQza+oQ1N?=
 =?us-ascii?Q?uu9OMvDgx/cFLmjm1roj1H+APW5+yj4oYWzB4B+vaoS+2Y8srtBYoGCITqcv?=
 =?us-ascii?Q?8ZCVYEbQAGMu2pY5aZLzqMBdjIM2M9B7xyfnQTa0cYpEQhP+HnELcA9Hq3IF?=
 =?us-ascii?Q?VyCvaZ3MHFCMnJDUl2bqZurZUN3q5PvvopaFCV1nT3LXYz3phRwBgVOSoQsD?=
 =?us-ascii?Q?obu54w8IsEkMU4tIUQ/E9lQsNoRpAfwy7/TCbprRE8MfCJt2ubj66TWPFAl+?=
 =?us-ascii?Q?d90UCbXJtI2Uhj8SaperNqTGO51kCev3yeM1eTld0EM8OyG1DDyf8nu2aNfw?=
 =?us-ascii?Q?MKHxSxozhgE/QyVBDAjuWsJ22/l2t1RrbeIkfehu6T4vM7KMEaLQ+YMsYLd4?=
 =?us-ascii?Q?CaxB3J41ymHS0k4M3KolFyQ8p3swFErJFKbzQJyPcxzHonu6L1xPSmGDuJXW?=
 =?us-ascii?Q?WHero1W74If5eecEtZxHgsJMhaNXvvZn+NjiUvjOxPZpfRM/8P33ClEIpNx2?=
 =?us-ascii?Q?7iDYdwSuyNEWhriTxy36TyatmNw4KWjasT+cke4omk87JmUfZ0+yJqL4EQKp?=
 =?us-ascii?Q?c0R/LIQTPHhPXR30/EEN6ahrazJ+J72w3rPsxMhVWZnntriz1E/qcl29A0BU?=
 =?us-ascii?Q?2UHPCpHdHVjmoUjw9qf1fWUeq0kNePGsRI7LJlLoPUAo83rk6ey/5BAYqLMJ?=
 =?us-ascii?Q?Ls1aTN/AUFz+fQmwX3Ae03QVoYGCBUGNelrsNK6wZQVdaUvKWemgkvxu8yhJ?=
 =?us-ascii?Q?gtvTEPYziY2Fe0E+fh/8zCtFLL9MFIn/4PyF6EPqLYDnpsE3LzSZVqOzXaOM?=
 =?us-ascii?Q?EYnxJAGc/bqUMc21zy8xpxOw9v6vqK4EU6sS9soK5KvN8GwE2pu2EbagH2jf?=
 =?us-ascii?Q?KFCjFwhB6GWXV3fFe/kybWPJVnrClBYGCoV6YE1KD2j5BsRZ4pXgcQU44lyk?=
 =?us-ascii?Q?uHuxYiRJ3MS7+7OfsrTkqfT2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd90b252-ee90-46d4-4e4e-08d905ad3d9b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 16:39:47.1574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HxPSZhAOjaEFnVjcB/XnSzJTeFK1TrpajuPMKH0OpdKubGJ/eUD+vMGs+NNNBH9+hFeipnJBsbG+uJWzk2f8QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2446
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the following warning seen with 'make htmldocs'

WARNING: Inline emphasis start-string without end-string

Fixes: 4cfdd47d6d95 ("KVM: SVM: Add KVM_SEV SEND_START command")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 Documentation/virt/kvm/amd-memory-encryption.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index eef3eff799fe..b45f2358e143 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -304,6 +304,7 @@ Parameters (in): struct kvm_sev_send_start
 Returns: 0 on success, -negative on error
 
 ::
+
         struct kvm_sev_send_start {
                 __u32 policy;                 /* guest policy */
 
-- 
2.17.1

