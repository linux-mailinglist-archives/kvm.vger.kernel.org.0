Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045DC3231E3
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 21:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbhBWUKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 15:10:18 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39198 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbhBWUJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 15:09:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NK4a8O022746;
        Tue, 23 Feb 2021 20:08:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=JneJPKbSra/GI9r1iQ0mWuD3uWqlyEAq2XW8g0EpLgU=;
 b=UsQYVKnyPBXawPBlXGVsuw3I8QA70v62BjGtpBzkpWDAkEVv5nm4p8FwY2Pe33J437Vt
 /h9tctd4N3/sXUQTEAFFiMNyYE0+IQWFIxYuXQt2bGAUa1zronsLNQBeJKz5vPOxJuR/
 Ey1FK/IvCbr1yAZlzFri1BUr+zMPbF++5KJT/TrtZJ8ARzZSgJ9RDyGIeePn1kBcPgLH
 VgHqTUaUTtmfW2/SaazU9xBOD1qnTTxH/rXq7BBvCEPyOS7pa0kaDcOb3LhOqTSIZ6hw
 3MurbsC9iXWqm1zHYCjvo5px6O/QKNVn/NHDnU3oQrFMdJmYz2rgmBqTaOaVdXEwqnAD gQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36ugq3fjer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:08:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NK6Vd5106920;
        Tue, 23 Feb 2021 20:08:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3030.oracle.com with ESMTP id 36ucbxyc3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:08:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mLOVrg6ZY+r/aWmYEqaPuvlFGWOEnBW6+E/2uj44lZ3yoLOirxwjPeb5kbk8zKHjjRFgQHy4O+WktJuLyL4gXbLfc+vG5bLNhzAQrq7ldmsfpQbicgtM/0s2LmL905eaZlRZMXlAaVPY/gnou2zWhv2RCn9rIL2mKGj4kPNIetfjDm0LVO6BRBMguCGz48nqdsX4BAhklrRlBjwcEpqX5BJOAy4O3VhpW5x1+Ho7jolJzRVO9C59jSRAIo6rQ1KBvqZRpxnn/Dx2aPgpssOGu0aJBCaqm9iePOA/7OZldmOmMC/GWuJxQN9tb1Bje7R/jHoCAp9zD35itVpYGlCKug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JneJPKbSra/GI9r1iQ0mWuD3uWqlyEAq2XW8g0EpLgU=;
 b=W2CH0Z+oDyRi1o1BkA/ailrOX0h7Heo3ROw0VPbxSYazMjLI/XU1Uuw9s5FQk0lHNDS5v2BONNbuKaOdDdKG+QRMFvatzwQ1pF9qAmJ0U6casXLG08+6Rbe4z30PVMKfik1A1ay9mM5jvd9P3ePkBuWCHzJyOs8FwzXL3KS4MhxwRIrCS9P8HL+Qvparo0FKRFqLDoz6g0hByjMeXkhx4PDRduhFpxxBgM8TGUJfzNC4+oVQVDf3BgBrGpJGfxKn4zhz1vrg+XYkR8WATNLf+uAGsYUugHzonrnGoxZFo8zJc9xUJTCwh+t4ftLDfdGKulkBHfsQdZGsF667JH6Euw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JneJPKbSra/GI9r1iQ0mWuD3uWqlyEAq2XW8g0EpLgU=;
 b=O0G1EwCINm9A+I4JMwWBEzm4KqLaT0+aIB5Dw/p3b73LJKWLNPa/gQw4/DiEEvxkWAjRKUqttzAcmYuL8lVLvJGRsMvpfITT5EFDuB19XhqzKQnKGBlwwYvG2UPJhpXfq5/IV4Ecthg+qEvVUm6xDvKmGBGipSqSxvVDORhnIu0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Tue, 23 Feb
 2021 20:08:14 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 20:08:14 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 0/4 v3] nSVM: Test host RFLAGS.TF on VMRUN
Date:   Tue, 23 Feb 2021 14:19:54 -0500
Message-Id: <20210223191958.24218-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.200.29]
X-ClientProxiedBy: BY3PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:254::31) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.200.29) by BY3PR05CA0026.namprd05.prod.outlook.com (2603:10b6:a03:254::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.10 via Frontend Transport; Tue, 23 Feb 2021 20:08:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c72b458b-2b08-4464-b9d7-08d8d836c039
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:
X-Microsoft-Antispam-PRVS: <SN6PR10MB3022A0FA1AE19E40413DEF3681809@SN6PR10MB3022.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qEgQKTQhcfc9rxMw8Ix88DrMtQ7NWsEECYIC4cHFAC+Vxu/28n2VdXmr5YlE+QlVovLbaoiJPtVIi/q1tLI8MCmKvZpDhX3IBeHEIhLEQFvo8ciJUSaOkWAcuO98dculNrMyOGJyjttg4uXfcfdzjbOfAh29MXvXblBL1scCFFV6OgpMsp53wnG4zuBqf6IbPIF6vvrQmR3iUAoi2feCcIuwjx16hZnHpHqYeoS/zB2srUijFl/RyWcLcmEaS4SkYebhGZa2J284A0oRIEvgaGq7EADn6YkO8tElCgSy4K+p2vX+0D3CRMXGeQR3JBT1XqlieZcQZdtcZ+jq8/94VbkDVpEMjOuzv/4KLZN0BmTM+HpMHJtTzIUe9Cf+qQibgSpxOHXMl6TBivNcrLK+4fN2wbh59hPMnAGO1Vp1sleMOvEYwdrDo13AnsdMG3BEmT6GKa0qHmnFNf7uLj239eFZbXfz+3VVvBsEU2P8x+/p2fsdsY1ctk3eIlobGfgTNIpIL0OqSXHKUeJr130q+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(396003)(376002)(136003)(66946007)(26005)(86362001)(7696005)(66476007)(66556008)(52116002)(1076003)(186003)(44832011)(16526019)(36756003)(6666004)(316002)(956004)(2616005)(6916009)(5660300002)(6486002)(4326008)(83380400001)(2906002)(478600001)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8dm8XTjH+YxMiNPorIDX8aKlwmiPzY0wmD255lypIY0+E3+kSDR7Se2PUlYt?=
 =?us-ascii?Q?BFgyjYhh+M5mM9PRZpZyV6uS0f6LCu4Hz2wOUPLxYp2v3qiIf7/TJ8TpLt9N?=
 =?us-ascii?Q?6RKdbq/NeqYJWnwozDBXrVCZ8SpM0oZL7SvfnfvI9mKq0vOjXhwX70vaJ4fr?=
 =?us-ascii?Q?KjtKU4WbR8fFsR68mpHa+SUIJZvvZWyLQ5yNbhRsnm0T2qJuoKPmBYuaJkRg?=
 =?us-ascii?Q?blTbwoVUmdUetLoOP5L9xN8HHtBz9HKeXidXxhdiqLpL3jnC+V87O6dgSrMT?=
 =?us-ascii?Q?pY7fuYD5aPbQq6hgCX7PPvHjugESKvmpTaeNpMFiMD8tl43b0Z+zCG127Sac?=
 =?us-ascii?Q?JFZPyHFHMJYvGmIlMOC59nbYWYaX23XzEnrL9puLGF4vE9Y3cu/NHtRQhSGW?=
 =?us-ascii?Q?CZF3VYnaAdVCqFaIuwsDkXO4L4hhH/LuWo33mj8EyhvfMA/VRwecWjduuYrJ?=
 =?us-ascii?Q?aDGGbnC5YzRiMDtuwW4jY5xJQsodvNMyOXEbEErbWl0hHaByYJ2vuNuviPCf?=
 =?us-ascii?Q?DYBJxOeT+ISNXCjwXorL4mKulfwkn+8bdYLQ45XrYS7z4Qh2/vPenDf1k8bY?=
 =?us-ascii?Q?D06sglJKceBoGit2vDW4N3l0eIvR7WQU1DcQo2L4aNWnmTc2r2dPL7hdU31K?=
 =?us-ascii?Q?Abvo2/CV4w1WMDheTZ9qOFHSo8SBIVvY0wXqA+lmEjjsfA5HrjyTbomEnqdC?=
 =?us-ascii?Q?Z+8OW2C3poME7hlZJyUgaUW7wpQP3VP/ya6y7Jxiw2LdHFa71qBweRGF4DQ/?=
 =?us-ascii?Q?2l+cwhAp3k+V97mpgJSVVpit6wGOKSEInDMAVAF0uQTQxHKLNUWxByfbh9Cj?=
 =?us-ascii?Q?oc+n8z+XAkKw4OgEMmvjQclqQPjIx6IEL3F/yJV1+5CB6RPuoYaoEo17REqv?=
 =?us-ascii?Q?vbBIGBr9dMmpvgI3/217mF2bAIMzXBFbje/fi6lFPlW8lCTb/rzbnb4r2wg9?=
 =?us-ascii?Q?HOaZ6D4Tu36vu/yOVqCTEiA1Kw2oqAUM5K3evXQA1TEIRgJ3FaO7FYazNXq1?=
 =?us-ascii?Q?OtW1Jz/oPeY71FooErHsu5+eZKMrxZIExaLMrkadCB50EGCfk0jpgizMBr+c?=
 =?us-ascii?Q?3qJk+uWGL1Q8l4fz/DUw7RiN9l5m36TH/eR0IXeMvzzeQYnZh17yFOR4po3D?=
 =?us-ascii?Q?LWJjDbyYY+Ya0t0dENDrPd/pHaVZDbbQ2vTEk4gYKmHvffNnhxxeAaXJL3CV?=
 =?us-ascii?Q?DvAnL507vGK5JgrSGsQEziY50SQc6mp4QjpmmvHhRknI40bJFrQIOJq3edEB?=
 =?us-ascii?Q?JMu9XR0CaLSLcE2gP+DfYQs3vPiIGlp8Bgs2b8Tz3MPkoIKK5huIna+otZs/?=
 =?us-ascii?Q?Imev/TVYa//GZZ77ewrJfXkh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c72b458b-2b08-4464-b9d7-08d8d836c039
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 20:08:14.1435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6pBitsZ0h/dkbioGhnXxsR7IOyaGXSH3307eCUeE3m/knbrNegcVsCNW2jqXIkTbNVYD8+7yjpLVmF9I6Z/sZdDtlHtM9Lq1dtUNkxgppEQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3022
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=828 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230169
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=997
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230169
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2 -> v3:
        Patch# 1: It's a new patch for SVM. It fixes the SVM bug that advances
                  the RIP following the #VMEXIT from a VMRUN that is being
                  single-stepped.
        Patch# 2: It's a new patch for the test framework. It adds a utility
                   function to read the current RIP.
        Patch# 3: It's a new patch for the test framework. It adds an 
                  assembly label to the VMRUN instruction so that the RIP
                  of VMRUN can be known to tests.
        Patch# 4: It's the updated test from v2. The test uses the VMRUN
                  instruction label, added by the previous patch, in order
                  know its RIP. The part of the test that tests single-stepping
                  on VMRUN, uses the difference between the VMRUN RIP and its
                  next RIP, in order to determine success.

[PATCH 1/4 v3] KVM: nSVM: Do not advance RIP following VMRUN completion if the
[PATCH 2/4 v3] KVM: X86: Add a utility function to read current RIP
[PATCH 3/4 v3] KVM: nSVM: Add assembly label to VMRUN instruction
[PATCH 4/4 v3] KVM: nSVM: Test effect of host RFLAGS.TF on VMRUN

 arch/x86/kvm/svm/svm.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Krish Sadhukhan (1):
      nSVM: Do not advance RIP following VMRUN completion if the latter is single-stepped

 lib/x86/processor.h |   7 ++++
 x86/svm.c           |  16 ++++++--
 x86/svm_tests.c     | 115 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 134 insertions(+), 4 deletions(-)

Krish Sadhukhan (3):
      KVM: X86: Add a utility function to read current RIP
      KVM: nSVM: Add assembly label to VMRUN instruction
      nSVM: Test effect of host RFLAGS.TF on VMRUN

