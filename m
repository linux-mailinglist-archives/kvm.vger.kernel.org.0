Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4509352066
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 22:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbhDAUJZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 16:09:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39114 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235441AbhDAUJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 16:09:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 131K3uBO169124;
        Thu, 1 Apr 2021 20:09:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=uWERgh9ZNrR2nUt3jUJqojV2/ReFRZpkHTfavMn0fSM=;
 b=Kk9Mf988zzoTK82TbD/78PU/NUiedVZrJxIxqW1snwS4k9NQdWO2RfsF7bfmYoqjWKYm
 hiYWEbMd+oZQAAMA1lq5ip5lHbWMnDwUbLrjjKtEtK8nRGtzaitD3WGz24FkZzaqAGkX
 fFHkGwlGuM7nW3WPayKQheuD/g6tgHyWpnMu2lNG05ID+FUxvxFs01N5VLpxEjArn13v
 uXrUyKmac1wy7PEOfVHdiIFQ87je6PIq0A3/by8tduy7Ujt48Qq3q9AI9ro36Xh5G15E
 0bdqZd4t0QqsOlEVCmnQ2htWkrBxCstRm5X+3qbJYHn0/N+YssRGaad8sag7JtfIj+gC 6A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37n2akk3bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Apr 2021 20:09:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 131K0kXc043054;
        Thu, 1 Apr 2021 20:09:20 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2057.outbound.protection.outlook.com [104.47.45.57])
        by userp3020.oracle.com with ESMTP id 37n2pb03xp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Apr 2021 20:09:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nprB4sMlF8ElKqXMVmf8wqwYcwZKcq4xgXE1sax34TkY9CKwolbco12R3tRQsIUU3yYp0AGHzlLDCSbWhpm4Jf/AKTWIBPPac8UorKK1UdweqhrwfBc17fJR34swuhpsucBh/9tcAGan2Iaq73quKtvUTmzZmjNuZVomzHcB1S6pTcobgthUO3Jo5R8ltYtfMQ1o2TfsrpTL1diqv7NvkBkJGmAxoCN5auHkQLTuJy/AXISQu9Y/KTCCar1qZH4MUvCgz1+WEfjmsTo+l1d3kHBr6u0ijz9HerC+vsXDofv36Fl8gCDmMoSQKFXe5WcLxA/P8kbm7qO2uKC9T2h8ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWERgh9ZNrR2nUt3jUJqojV2/ReFRZpkHTfavMn0fSM=;
 b=MWhd1OAROeX15tue6q0TNULAiN0ntFSrtZgbpRFZlcSm1pjXSQ6+YC0hZBZoP2h2//L3nM8hfUa7BTilcfVq+8M+7k0HRgY1olFdrLI5M9l5jtqMeCl83Wn/u6eoSezGLNpf7r0uT5IOJLbBw7RmoY0IS0lnp4Idj5U527xxBYRO2UgqEgMn5mCx+cNaYftPEZWK0rO6J9M+ofarG0Cf64RpCHAf/pif64jvmrhB5f3IusVR+o6z3AtRlqDzhM4Yo9AXXpQ93tdjc6yjc/Zie7fLOet3CLp/U2/1JhTAwOMXA6KPMFOKUB22bGG9LF0L7doirfQZ7w4LgQtxSgiltQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWERgh9ZNrR2nUt3jUJqojV2/ReFRZpkHTfavMn0fSM=;
 b=NxZ5D4uFWpI3x0Sc3d5/A6mZvYs0qmfeg13SINoQoJVnjDGZSE6TisCDhltDN5rNmRIxuIXn5z+Jnlt8r1DODfbpWOvTniZR0uOYIaV5htHIey1rTMDhuOq5Ebl3DcksE4QrK2USMfRL8DKUXwlWlKkvbwUDLeXeFKltDDA4PdM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3019.namprd10.prod.outlook.com (2603:10b6:5:6f::23) by
 DM5PR1001MB2091.namprd10.prod.outlook.com (2603:10b6:4:2c::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.33; Thu, 1 Apr 2021 20:09:19 +0000
Received: from DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::35bb:f60f:d7e1:7b2b]) by DM6PR10MB3019.namprd10.prod.outlook.com
 ([fe80::35bb:f60f:d7e1:7b2b%3]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 20:09:19 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 0/5 v5] KVM: nSVM: Check addresses of MSR bitmap and IO bitmap tables on vmrun of nested guests
Date:   Thu,  1 Apr 2021 15:20:28 -0400
Message-Id: <20210401192033.91150-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.29]
X-ClientProxiedBy: BYAPR21CA0015.namprd21.prod.outlook.com
 (2603:10b6:a03:114::25) To DM6PR10MB3019.namprd10.prod.outlook.com
 (2603:10b6:5:6f::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by BYAPR21CA0015.namprd21.prod.outlook.com (2603:10b6:a03:114::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.0 via Frontend Transport; Thu, 1 Apr 2021 20:09:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f5fb2c8-f738-4f3d-82e1-08d8f54a082f
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2091:
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2091CC8636882B46BE25162E817B9@DM5PR1001MB2091.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SXmi+EigRlLkFSUi84dj+8oTB6yONzaxXe6O5c+wBGS3lLsdVo/i9xaDpeZA9u5rJv0406Q71WPlzIWHUXL3g1pwS22SmJmMEaVJWlcG3apJy6a2mdgITOmZFXzuGpKed4jHGSWqFniMxGpjgqbcn/5jAny3fSZkGeKJa5zcjd+AeiBSaJUEMI19Ut2cT3Tv0ekxpbAdRs8uCzgr0KL1tkTmvXP/zW6uOQ98siXoKk/sN5EWa6TqqUEHk1oUAD0PiszvUzyppmI7X1BUkB2OjcEjBYhMJ5o1I/WqjUWio5VL3I5aMSSSlZ1nTBElynkIEnnU5MRWppThOPFGcRki5Q3qYATtXgK3biHwQwP6kHiSWkAHBLeglAGQRacjaqraqIxIxy3/vWhIVFQM/MyhFNhFZh6dtDa6TF6bX9PXNyr4jt24QByGDhYHirDJlZpxXr8Xz+IyjFkNbW82qa1JDW0l7/QYlXNVTNfTkxDK14EgUHMZnWOhrfjNOjY/fB/tvTd8Y9zb17ZueTwcqX+0/9n58CpDlG1kyqy1aEWhep+WOmcwpJM1C4Wlld6m4TU4OZJdn2a/qhFo+ccdUXTrNCavCFXZCSUvuBBt2gq2Gco63N7chYGMrdPamoPgwC6JCe2SsQIo/FnnOzoHCF8goA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3019.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(39860400002)(396003)(66476007)(86362001)(2616005)(66946007)(4326008)(2906002)(186003)(6486002)(6666004)(36756003)(316002)(38100700001)(8936002)(7696005)(478600001)(5660300002)(8676002)(16526019)(66556008)(83380400001)(6916009)(44832011)(956004)(26005)(1076003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qMi7geoCQMtIYajGiPmKYZzM+La12VJt3ZJRRoI1FXcHrO/cb6AnIa1/GWdQ?=
 =?us-ascii?Q?gTKaNCu8n2aYv+71IE9P2TJLwo/CiTyl2FxVnl8q+gcwF8hbg5pgnmLj3muM?=
 =?us-ascii?Q?eabTzF60TaVcUoRmD2pD87uNA/WRWJpIQraVnqq9ZaltXBrszoT8N7O6rEWe?=
 =?us-ascii?Q?k1sM/q09g3KmiYF1DlXh6pJYzzzq092CMcKhjHm8aztLxlN7errwIpEDyhrf?=
 =?us-ascii?Q?Q+ik81Awu3H1JJS+iQDeDZp/1nLveRSi/cjRZvoUnW443CDqW0jlqp2wJhuv?=
 =?us-ascii?Q?PLqaCNbePAzbOGvIuhz2O4m6NYb3Ewf0rKZKm9NU+936JCPSN0n2KNzYuIHh?=
 =?us-ascii?Q?z0AB9nAAh0TmiH3zRGdUxTFclPFrjBnbKGQsAJzTxtPgw+vbo+iF/5o6HQuA?=
 =?us-ascii?Q?MGFkSwsM/Rpv0HwPolnwER9YO7t2UkMF9D+yXTxNTjnpTh0D43pxjwPvg+ln?=
 =?us-ascii?Q?fmiiJMz+WJZvcEcODH62Mhvh6l5GafBGyGoeuyhiRbWxTj0B7B1FZv/fwdHY?=
 =?us-ascii?Q?QoVvms0M2cOKw2iqXaBNAeGP+6Fi+iFYQLRlpZWkwQWAMFAhyKwpa3Gpu0lv?=
 =?us-ascii?Q?fihGDyJ8Myal/MLFaKRuNZY/XiztVjOKwfe718+LXPlE1kCz/l2HWlbQ13gI?=
 =?us-ascii?Q?xUNyn3F3Mn00YmU3nEQBw3W8qXsoZZxfISeRTvXu1G0mttEVxwVUs2lAUEOD?=
 =?us-ascii?Q?WOPjkxqalGCPOgMCZW2cKrLoB27+knEW1XRUvFAs5TtwmX8nedEerTOpbX1u?=
 =?us-ascii?Q?ljtrq6fCP6PQvbVZ43HiR0FbLo5AflxC/Vgkh9ealRy+d+HJsBweo5f+XCqm?=
 =?us-ascii?Q?SAoUeFG4K3mIY1X6KSRXdxWUC8Yr7YBcSw0TB6DR8pMk/JyU/o8yeVYn297Q?=
 =?us-ascii?Q?JYRAoPGvbyOio77VTqyda5Fwz3vsKYgUJGUgONM37jUwJD8xLcFByy3cEcRP?=
 =?us-ascii?Q?ARm9Tq4mBS5T7/W2vednd4N+0IgqIvB6HTqBwY7yrr7LFQZmSMpvHMdMVx3Y?=
 =?us-ascii?Q?xStvkjHP3Hy4w6FeFe2KaTmfLuqMifHEHPMt/dCNwXrHUxoSqUyuTcKelWYG?=
 =?us-ascii?Q?LZZAPSiJ+Jtb5eIrwnpxlKS2cNs23mFZqQ+W3opA1EOxQOWUVcDfiwwzsZJq?=
 =?us-ascii?Q?AGA27yvkmob/1xoovJZ0Y8R5jq3m6ZSBhB9R+wYNjMrub6Yvv0xNFI2j/7ok?=
 =?us-ascii?Q?sC711Nmx4s6q7/jkkRJbdWT7v8aXJYUuRJ4YNBL1DDexh/zdQjqUJIT/5OuG?=
 =?us-ascii?Q?M2527XE5RPEMn2fVYNGY+krmF2VpP6Ad80b2bfL/FJmjppBm33zBecjLfOLD?=
 =?us-ascii?Q?NUNL+Pm6CvWlLi6CMZye88k6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f5fb2c8-f738-4f3d-82e1-08d8f54a082f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3019.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 20:09:19.0099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NRuzPIWp6PHdy4DccuBqQ75S/KCW36m/C4BK1REI10M9mls5gaJzZbKeVNKn21/I6PZKcSli3kNjwQwH5STKg7JIH34URy+g/H5ZTc2Lcl8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2091
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104010128
X-Proofpoint-ORIG-GUID: CNuQdGe6emIXG1svYnwZl9hjQRegRIVA
X-Proofpoint-GUID: CNuQdGe6emIXG1svYnwZl9hjQRegRIVA
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 phishscore=0
 bulkscore=0 adultscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 suspectscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104010128
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v4 -> v5:
        1. In patch# 1, the actual size of the MSRPM and IOPM tables are now
	   defined. The initialization code for the tables has been adjusted
	   accordingly.
	2. In patch# 2, the checks have been adjusted based on the actual
	   size of the tables. The check for IOPM has also been fixed.
	3. In patch# 4, a new test case has been added. This new test uses
	   an address whose last byte touched the limit of the maximum
	   physical address.

[PATCH 1/5 v5] KVM: SVM: Define actual size of IOPM and MSRPM tables
[PATCH 2/5 v5] nSVM: Check addresses of MSR and IO permission maps
[PATCH 3/5 v5] KVM: nSVM: Cleanup in nested_svm_vmrun()
[PATCH 4/5 v5] nSVM: Test addresses of MSR and IO permissions maps
[PATCH 5/5 v5] SVM: Use ALIGN macro when aligning 'io_bitmap_area'

 arch/x86/kvm/svm/nested.c | 59 +++++++++++++++++++++++++++++------------------
 arch/x86/kvm/svm/svm.c    | 20 ++++++++--------
 arch/x86/kvm/svm/svm.h    |  3 +++
 3 files changed, 50 insertions(+), 32 deletions(-)

Krish Sadhukhan (3):
      KVM: SVM: Define actual size of IOPM and MSRPM tables
      nSVM: Check addresses of MSR and IO permission maps
      KVM: nSVM: Cleanup in nested_svm_vmrun()

 x86/svm.c       |  2 +-
 x86/svm_tests.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 2 deletions(-)

Krish Sadhukhan (2):
      nSVM: Test addresses of MSR and IO permissions maps
      SVM: Use ALIGN macro when aligning 'io_bitmap_area'

