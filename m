Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12AE93EAD56
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 00:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238410AbhHLWrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 18:47:24 -0400
Received: from mail-co1nam11on2065.outbound.protection.outlook.com ([40.107.220.65]:4320
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235927AbhHLWrY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 18:47:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmpieRXmpfdsSE9S0i7iA1AbmhoUc6vB6wQOfEC+oM4KOe5urXnrFUcWI/H2AybEiO7hVGlVgyXxRVeLKGZnk3fxLJHwfotBLRQOeb0tqNXel7pAtocxi/+F0u3udel+iAYYgzyfu+rV3lTdg73hSrBs7V2hs75hwyVgCb+cbxdvFYhl3BURAmsDNmrUyM8cBKHfRlUTDL+lQS9kdos994iZMzh+WehfRHWkeR6Vw+sBTisRaOtCCiUGf64nKSNs7buGupt9/m+k3SZHLJlRNle/vPAG2qoBpViSYTx3fHCcANXST4CLGEOg3qJwKh0XFL/S3BST9hy53iYBdxW9uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4idl6fxm0VQzCJ1n0Os5i1kGDwV61Ya4nCSgc0KbzM=;
 b=enkXhLw3/TC7OvHO3uI2Q3TbnwJIVfFzXLMo8aS0NJN2/GcnvtcsSHx6UJ+quaWev1U3jTE8XRRPs9DfA4eEWwPjt4jFyauf8DWy35B7l+MkdKSOuplU4+BZ+tAPaI86tSVvI5MzfruE+vHOTuJsnRmfDvNcN7IfTBLSAnOpj0PXN+bZlrDqRpLQ5PkCVNNFhdRPsloRkCK2GeB5L0L679jAjLy2usQKiMQYBME+49P6Hr0bEkm4KsYYXFIhygNSk0BX8GpDoDYEmMlh8AMro5LNsPpA2EI0juYToSx4l8SxvD40Mlo3EkQLUzGMDSSEAZ/hc38ACgplaDMPsjMJvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4idl6fxm0VQzCJ1n0Os5i1kGDwV61Ya4nCSgc0KbzM=;
 b=AEjW4bB8nxTCPhihZmkEn1H2UTsKDYkO0+vLXFjh38uiQItomJS7Yrv8FrcgQZlDVEmSYQjVeeD1lrRwvae4UEkZ1o75cD6Bp2X3bwstTz4k7BW/QKTj+gFWfkm1WP6SNuLKjXqNsQ3NuQTKOWQPeMJq+thz5PYxFdrlxKxd5/8=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MW3PR12MB4555.namprd12.prod.outlook.com (2603:10b6:303:59::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Thu, 12 Aug
 2021 22:46:56 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e%6]) with mapi id 15.20.4394.026; Thu, 12 Aug 2021
 22:46:56 +0000
Subject: [kvm-unit-tests PATCH v2 0/2] Couple of SVM unit test fixes
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, thuth@redhat.com, drjones@redhat.com,
        kvm@vger.kernel.org, babu.moger@amd.com
Date:   Thu, 12 Aug 2021 17:46:53 -0500
Message-ID: <162880829114.21995.10386671727462287172.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0101.namprd04.prod.outlook.com
 (2603:10b6:805:f2::42) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SN6PR04CA0101.namprd04.prod.outlook.com (2603:10b6:805:f2::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Thu, 12 Aug 2021 22:46:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bdb6e92-fe5c-41fd-8b07-08d95de315ef
X-MS-TrafficTypeDiagnostic: MW3PR12MB4555:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR12MB4555BA6F4109FB4C23518EF395F99@MW3PR12MB4555.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D/nEQrMzzLkltj1WRtYjUjRJdfsUb532lqlRhg7zM8UTPwVbSz2+0cpbYKEOHaKI3kTC3n4v7jIOGOz3koeFgyix11korW2ip7MG8FHSAuy6JXvg/1Tw8DyVvHg6r6LIZy3IXulf0KBzz3E2xgRHJp57sVnd1DzhrldyF/nxoCAE0nllrywzmNLcqQjbxi+0uRba4nRbzcg44u4T+2a0CwJkwIwUx9AhCdyYnSxcfxALxyA8rTJaZD01oW6ZRG0GiuMch+7HJIYaXbWn2aSmKkCDGSprWolCCTDrCSIL/03mVzVoI2o4fy0t3Q3XCyF3myWjm3bH8q6Wa4q/EH5bHnDf8JzdxkwpMPuM9hXv+ugTHRhXv7BOAi1C7B5j20qh3gJjzL101NpLRV/tD0J6H3Vl/SsapyoRE6SZBs20KZ7GUNSbOS2zZv+yTn1xawG2AsS78S12973vYs5PBWr9io2Z0MbGHzy5fF1shEN/qb5K3DNw5hydW4heQbIlv9tcWH17q/GOZlB6f/2rhOVXQNR3JcIfXokCiZgCk5qTIR04u5q0pHsIspKxCZkX+2A+yW04B6N+DQ49KwiKeaPE9kX5Tecnd17Xdwyz8S87Osdt9ku3QDDIHZ/aXreu5wqa/g3PJ2JSog6hqRBEkSdZI/H1G+WPqATguA84g1c7JsTkjGEK1wuTVfI8l4xsIUpOwpNYeMnoOYpyAqm6MTnmXc7MudeZRxCebaWKOCBq8JbjVUku5HlBqAKcauXfvbt0tBVk2msf8L5w/LZ/hMOyHDMoaupPrE5wmyaDq/21K0w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(396003)(136003)(39860400002)(346002)(366004)(83380400001)(4744005)(9686003)(8936002)(86362001)(103116003)(66476007)(6486002)(66556008)(38100700002)(956004)(38350700002)(33716001)(16576012)(66946007)(316002)(8676002)(26005)(6916009)(966005)(2906002)(5660300002)(478600001)(4326008)(52116002)(44832011)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXJwc2g0d2V2REovcjlOdU1yNEFUZm12ZmVKeFJsU1B5Nlozd2NTaU8zUXRN?=
 =?utf-8?B?SW9SQ1FmY0xCTDNOcGJPK0kxcUNuRkpPNnR0d01Pc0ZwMytWYTRwdFp6TnY4?=
 =?utf-8?B?eGJsYklYQ0ZpdjEzdCtiY29GWnBBZ2ErWnRaQW90akw1ZUlobGtwZFJIeW03?=
 =?utf-8?B?WWFkR2JYMFltSHIxQkF5OXdOZG9ZWTI4ZlMxbVdzQ2J3MXJCMmtvMmZaR0Y5?=
 =?utf-8?B?VjZLdUJtWi9UMDF3OFExZHJvejZLbGJ6ZWQvSHVoQkVFZ0xNcHZWaVk0bWVT?=
 =?utf-8?B?NUpmRzBFYWl4UnFNWUYyTGVBcHMwZGhsVUUvRGd5KzdwNG0vVHRsTFd3ZXc1?=
 =?utf-8?B?a2xxSlpwNSthNHluWlgzYmhxZTF2THlRWkdldW4vM0NuTzFlNjdlNU5iYWZk?=
 =?utf-8?B?ZHRYalZxYnFrdURhYVZYcTBMSEFJUlhlUStoZHZhZVVFUTcxN0c3b3ZDbWV6?=
 =?utf-8?B?K2VHRi9iNURzQk5GNlNtQWwxZkFMQXIvVUZwVktNZ1VMTGNRWXNjcEc3UkpP?=
 =?utf-8?B?cENONVl5elN2TFFNVVZJL05kUkZLdGJINkVzcXg0Z2hBQ1JkdVpqOEhXTlhl?=
 =?utf-8?B?RC9FRkZzN1VuSGQrdVgxRS9qRlVKRWNBclZrNzVhUVdQaTBsMTBSaHJOcDNQ?=
 =?utf-8?B?aFk1NUhMSVVFN0xKSHNnQW1JMmZoKzBqR09JRDJmS25FWk8zSG44MU53OW55?=
 =?utf-8?B?ZVJnMzZZU0s1dXRoc01RdlF5K0xxTWJuSldWMHRjR24zdXhuZGNMWEZmMzlW?=
 =?utf-8?B?UlVYSytPOC95ME1LT1JDZ1RJVXVHMWJjbGxxNVpVWStmUnJ3YXUwc2ZxUStX?=
 =?utf-8?B?L2FKdmhWOWZFSWtqV1lybmhuamEyU2hoeTZoTDNCMFRtQUs2a0E2UHBObXdE?=
 =?utf-8?B?d2JzUmNiYytzUnBCWkUzVk51MVZjNktUTmFPWVhjMDJVT2pqRk9xYUN0bkdX?=
 =?utf-8?B?dnl5bnlJUGhuZTVsa3J3dFhxZlI4Y3NrZ1RIb1F2QjlPcHd5Z3B1ZHZkWVVU?=
 =?utf-8?B?c2EzLzByd1ZSdXFHTW5hQ1pOUzV3R0d2T1JNVWxZSzhKbnVicE4xRVQ4blk4?=
 =?utf-8?B?RDU0TkdvdFA2N3JBNlhDRWRLckhOUnFBTGRLUUlZWEN2TW5mOVE3NnVrR2lM?=
 =?utf-8?B?QnJSRmUyUnM1cHY4ZUNVMjVZbytVSEZpRVdrTHQrVXprOWNOR3BNUWp5MWRN?=
 =?utf-8?B?Q0lCdnZWUlpQRDZBZlZWOW5FS01VOWliYVg0UzIvUlcrMk5ZbjBLaVJrM2xY?=
 =?utf-8?B?WXJjNFhJZTRVY1NaZjZ1bTVraWpsMmZObmJuelBMSlY0UTlxU0VYeW1WM05s?=
 =?utf-8?B?RXU5WU1NdHk5Mmw0eDJPczJDQkdsV3p2SktwdjdXalo2TXc4QWcrT3o4eDFI?=
 =?utf-8?B?OHlBMWVSdEZmWTN6ZXlUNVMrcTFRMmJNbUFnUnpUSzlTZWtvR2d4YlAxWGt2?=
 =?utf-8?B?c2tyVHVBT2cycmgzRDgvTGtsY2VDWEUxeWZBWlNwZmZZa1Nzblp1ZFZrZUZH?=
 =?utf-8?B?bXhYaU1BS3hYenBZelNqQ1Z6dkRDUG1JRkZTc25mV2t3OVlhUnhQbHNEeTNF?=
 =?utf-8?B?SHBnVVloZUw0ajNHWlhCTEZic1k1VTJSMSthYlVhRFA0T0JUbVR4YkFQd1pa?=
 =?utf-8?B?amMwb3hiVTVrTjNzVE9pRGkvb1Uzejl1Sy9nZXhTYjc0TEozQTZsekx6aXA3?=
 =?utf-8?B?eDBKc3F5U3dxOWM1ZFo1THNBN2JGd01nd3pnMkJJVDNlR1luK3I0d05nT0ps?=
 =?utf-8?Q?WEngu0ufdvVaJhxp/6lg8e5GQZtP6663AEa6j9q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bdb6e92-fe5c-41fd-8b07-08d95de315ef
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 22:46:55.8108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XlbT9JaNEDbGiLDuJooMIEonA676Kk8l9bxSU+52Bjf+t9YBgsJAzPNskWcIiFqi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4555
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series fixes couple of unittest failures for SVM.
1.The test ./x86/access is failing with timeout.
2.The test ./x86/svm failure with infinite loop.
---
v2:
 1. Modified the check in ac_test_legal to limit the number of test
    combinations based on comments from Paolo Bonzini and Sean Christopherson.
 2. Changed the rdrand function's retry method. Kept the retry outside the
    function. Tom Lendacky commented that RDRAND instruction can sometimes
    loop forever without setting the carry flag.
  
v1:
 https://lore.kernel.org/kvm/162826604263.32391.7580736822527851972.stgit@bmoger-ubuntu/

Babu Moger (2):
      x86: access: Fix timeout failure by limiting number of tests
      nSVM: Fix NPT reserved bits test hang


 lib/x86/processor.h |   11 +++++++++++
 x86/access.c        |   11 +++++++----
 x86/svm_tests.c     |   28 ++++++++++++++++++++++++----
 3 files changed, 42 insertions(+), 8 deletions(-)

--
