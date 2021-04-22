Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED2236850A
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 18:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238067AbhDVQkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 12:40:25 -0400
Received: from mail-mw2nam10on2053.outbound.protection.outlook.com ([40.107.94.53]:20929
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236780AbhDVQkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 12:40:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aRdzkie25Whp+J4wfivUK+DeybKCu+dE1W484nMPVftJ4NAysTv3d9R3NZ4Q+YA4Idu+jF7iREu9xvNv9giEpJXe5O3aESH9+H2rLCpkq/Lzk/iiCvk6b7CHrDdCbTrKxyBn2jLCk48dHXLFma/jUH0Zf3ilBMm+nswzidIsPaVG7eVwbN8oPvzmVL2iUG/pds2M7p61ETs3RiqjS8NQ4zfMBKAZKzV8a73dHr28fN5mnADRP7Wgq4l2OZVeYz8oKJI6WGi+6IaeLjTvjxr2ANpZsMbpaURPTakq4roeTzLtsOFtGsijzX+b/4mLfeAE2vM7fhlFsMNRaIYM4AmHhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VACaQmzjscsfqBWYkWKr4G4uGiFzlyPe0+NoL3EeEU=;
 b=dB4rU23Id+yOz9bQm5Vye2Sh9AirZg8UxcnmFwExNuqQA2DA0qxiqr+AgKiYHOO25gcfNfha7c3CcE51EKh31sp2xx8iLVcqVsF/U2cKhyML5lRHbNOT2Sq0F8ap1LqJxp+M26IWTl2j1py2qjNqKPhqwgPqKZ8MnpDp1MaL5UGp59+jhFqIgQEY9m/7k6fFl8dhghctoDwSw6VfXAWM4dT3sWniahelqtUluuxGT66ADHazN62bsta/g69CLw2LTxNSjo82vjk4mGHzIpjVx7B5DsvczjCpxyCU8M+TjCay5YAt6LIVGBsPU5SxRNv9hO4WMnhLKM6Eilsqhr3Slg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VACaQmzjscsfqBWYkWKr4G4uGiFzlyPe0+NoL3EeEU=;
 b=sik7MsZvZ3ZMnnLEc5IHSS6I/vRyVjzF1Ff3suMs/jAocUCGPA02YbmNGomSAsFRcxcWdtntR5VkmhqIxZW87J+LpkPzURxwpIsGiAMZEUK8ixSKL2S/QGuvxvUbBTA8V8K/o9DKRcCBMOIT/itF+IzRQxbDSaFb3T6qOB2jlls=
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
Subject: [PATCH 3/4] docs: kvm: fix underline too short warning for KVM_SEV_RECEIVE_FINISH
Date:   Thu, 22 Apr 2021 11:38:35 -0500
Message-Id: <20210422163836.27117-4-brijesh.singh@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: d4f29026-e7ab-4d99-0554-08d905ad3d53
X-MS-TrafficTypeDiagnostic: SN1PR12MB2446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2446E33C2C8EFEB5DA8B00DBE5469@SN1PR12MB2446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hPTAe5YuthKvY+NM4fvZfHs/eSqU8bedNqv7fzvtsPky4jnWKoY0HhRp8EzVf5ZDE6lvw39zcklzLS0rFoveL9qA+T4iE5n02pWaXmD5rOVF2lLdjG6E+SPi9IkJTvUx4VyDXth1yMqm5DEw8m1KLJTK49k+Ds0gdPyH7MpagdGy5UUKq3kSZSvWpM+rcFGD+lLyZO9UZlic6HGVXW0+wnwLFrqDz/AHuUyHp9V+i0mkJto78VXMB+fIoQ0UnxbTIfS6kJO9HYLnrzst8wQ3X6RNLaFHJJy8D+igsONPHcvd514GafwEeHKyRplKPmNw2Ye0GxwWE47X3jQcsrqiMbQujpootNRNDFiRAPRofQebLuji6AJjW4S86aTA9x/zu12V75ETgAURdpjqJ2INEEWSzNx9YQVvWVwpwHlXkbEPyHPV/oGK+SWKEhC4IhFGrdIGZhi2FZlVNitwRSLoYaG4FEd7POIDQEJgE3urtkE/9wKFYoYP2UPM+I7laPEqpy1Uh5HbhcviHh8P/5Aa/bHTQUleagycEK9M399kU4tPp2kbpm5luir6zdJbWas9cUIZ6Y1HMfwa1yi3bpet0tLQfInfYLh6qkjiHCwzliyfbG/h2nib25Ip6dhYa6/RsgjYp40seMeZowGXlAB7Mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(39850400004)(366004)(66476007)(86362001)(2906002)(186003)(4744005)(1076003)(66556008)(5660300002)(16526019)(6666004)(7696005)(6486002)(66946007)(38100700002)(478600001)(8936002)(36756003)(38350700002)(26005)(8676002)(52116002)(316002)(2616005)(956004)(44832011)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+ul/8fPsGyB2L3PVjW5KXYSRXvgJMOzDRdvX+9ZeUHjVY0GxAxsUaZOR/04L?=
 =?us-ascii?Q?lDWKh3IzGBXtuvYuFWQRBBa/Tw2kw2UuK5HMMaX7MBY6iEcZlHKVGnuo/kfS?=
 =?us-ascii?Q?dadASI0a2TuVWYwQLXt21bZHvzpJIXowprXsBUAKXqzpIeSv31J3jIDpwtSk?=
 =?us-ascii?Q?Be0M2PjHD0p9fCvFqdgpYiQgYmd8SynlgkAcYY1kGDkXS0HyNaUG6jOwzOIE?=
 =?us-ascii?Q?lSjwNOkpNxT+MJE8gV3q7VS9prM1fenZl1QKtLJ+Pw5hAdLcN6K8ZiPJFjbe?=
 =?us-ascii?Q?1T5FKe4W2g+akBwYcwZCHU8SVCpnPiyoLB7UUTA6GuhT775p4M7ptBmuep3u?=
 =?us-ascii?Q?6wuTIKwGz/O+AQsCe9Zbu7bjMOyb//Bc0DWi2TKFOOEJsWDX83Ompdqmw+Er?=
 =?us-ascii?Q?6j15+bblTae+JtFbyvIypATTI8qt2zlnLOcfYxAouhplb1+OaubanD910Wnr?=
 =?us-ascii?Q?ULhRIgxGCNeDep5LRNnW5wf/9/6tNHLgY39ALrWzV6xrmqBxW08vGJZCU3sS?=
 =?us-ascii?Q?RRMg093g1J/BvpbEwB42qCQG+PPOK8dRVh8pPQ/QYMajpH8QYXbmG1NykMhn?=
 =?us-ascii?Q?yMW7Z4HZAYJL85Mwv1Ngm84Kjzak1IpuyK9rjwP9ehSau3cEy+KkwRHst4W0?=
 =?us-ascii?Q?pXRooVVI5IJMgTTFoq4VRFivkymh1tPd543hPp34eL6BIhPepsdfTx3pgkfZ?=
 =?us-ascii?Q?8GUZPTIirBAoo/mV/yeOkvp4x4lCazyQEvdOAfrGmmQ/Ag4iU23eQSr2V9IJ?=
 =?us-ascii?Q?X+mPJb/nvjXLU6pIhWhU7ieQYAee81yJcrS2Jd+lZBfvO2ai5ix4lXuBz9ux?=
 =?us-ascii?Q?Jg30s02Bu8qcxLo6lM68j+59TDTlkn8+FH2FonH96hEEuzo+2nGLl/hzzd1/?=
 =?us-ascii?Q?64Hk5ac5sualR1fGzYlrBswXXmwEjVPVfPrbmnr8m6Y/hnM8PFWTJR8EAgz1?=
 =?us-ascii?Q?WuZmg7cly9HRyDa0et7p/gKunXx1nkwrlhlkGiqfiDPdPe1HboZjbIfrzcrE?=
 =?us-ascii?Q?I4MZFErLXuJKJTjZlRugmgjVDktsvfo/cLyhbcqdDEbDYCoJ9xMiV0o173gR?=
 =?us-ascii?Q?YiLs+pkHtQMLtz3WYIE7r5bAc8x6bMdPvLkN+qd/ZoQdw9hz1LFjt2wTKlgE?=
 =?us-ascii?Q?cFcMptDQcziQVxQVt2/V65eaT+vR/j8R4Kkb6fHigwCvHiVyv/7IRtRfTuo1?=
 =?us-ascii?Q?wfNu3kow1n2BJ2tPCGWKHRWzwblNHBeQun3rDSDo7l+Rfq/CDix0QHpyuDgQ?=
 =?us-ascii?Q?uplVnARBJvnkYOjsy+RVR+j+s26iEiwzZtI5vlKpoT9BHw92zQ0/CvjoO5Um?=
 =?us-ascii?Q?KLEyZaKETukQosOJdT3pOBXo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4f29026-e7ab-4d99-0554-08d905ad3d53
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 16:39:46.7057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r0uylHc5MsbYtqW7QtnNpwYOgxbfOur+ib4/0qSQkczASb6uVzsL9z10ThhPRsfyGyTOvW1tmt4uicgHKCam0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2446
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes: 6a443def87d2 ("KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 Documentation/virt/kvm/amd-memory-encryption.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index bc8e5b7f0c35..eef3eff799fe 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -419,7 +419,7 @@ Returns: 0 on success, -negative on error
         };
 
 17. KVM_SEV_RECEIVE_FINISH
-------------------------
+--------------------------
 
 After completion of the migration flow, the KVM_SEV_RECEIVE_FINISH command can be
 issued by the hypervisor to make the guest ready for execution.
-- 
2.17.1

