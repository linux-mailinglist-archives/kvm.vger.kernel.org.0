Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC193314BF
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 18:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhCHRZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 12:25:33 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39670 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbhCHRZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 12:25:11 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 128HJAvF040345;
        Mon, 8 Mar 2021 17:25:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=63QGh+BrI11sMRz5cCZ1Avt7DW6pw/kd4kO2jw1o/cI=;
 b=UWX5f3/wusKPsvvDcGzAOuj+bcHacrWnBACbMUtc+fJprvth3SGLDLZTxgCBivRJk9uP
 xE2shCw+YIO1um7xOOaauDT+sx4ZZg1GC88eOR6kVGQ/iwas5pCGDJwMsCIEpYqMl1m/
 7+nnjJm9Ts/vy45z3r6HNue4rcpWSZywAODWhmtZuGq6Okd2gjygpOtDcg5WtQv77nvU
 7txyNoA7+dzTJd7252jLtkSadIyXxu/aRqas/QHYtOfjcVg8ATidmVqI9p3pEipdla6B
 42WQW7gj8FRrnIUFPM65kBdoo2VFij3p01DzCdtcjwxtTa7WBDLXZFB7bKEjpOs7e/zR zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3742cn4cps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Mar 2021 17:25:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 128HLOnc138608;
        Mon, 8 Mar 2021 17:25:07 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3030.oracle.com with ESMTP id 374kamh1vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Mar 2021 17:25:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKCLU+6//r5+BzbKk/vbdsrlsHBx25HUIsgzlvwMXoCDxa7Dz4JM/TF9rHCw5K7TDrL5s8hZynCFBEjq7WzBAwgRJwp/ZO4RXIeSAOQ+RSv4Rd2yEIN4NYxt2zWRH5KXWBc/mm+8pAblLGl4TguAHe4OzIHa5m5ADbg9+9LvCHf+JdZskp4GiSdgwMnX/PBP6KhnIVj166aSi9+saPeTcXS28uzkTqyI4WRDrf35Mj8vMzl/QHJN1OM1v9ssE+A18wxUZwSORye6Hcimlxy+on66BXsSSXtt31e4QMqSdiTjHtKVbM2rZ+kPNDFe//51SnCHpDAnqzPS1BuPKepiUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63QGh+BrI11sMRz5cCZ1Avt7DW6pw/kd4kO2jw1o/cI=;
 b=TirXu4ZjcKQRGHKj/p8bA7gUYz77sinHzZLX1s6OZHuf8wriv3UWz1SDKT6lD9q3Ai3HB/bZEMu32lK+nsCqKwSSYSR54hh15eWYupcO1xcInYVI0tdappd7ksDB56oLdL4DQAmtyHtXcE8a8qOVRdfncE/cD7FDVZjvm0EOEcJWwf/C35fjtvj2tdEZbc3+mpz2R+4vtDzbS5O5fJ6E4vLRuFAaZceYtPwlNbp8aIutWcWXw/lEg/b4LdbmY7j2BEmnT8Rr499iEwHFUTpaXgoT0wgQS+zw+xsctHVCFc2KlH11ucZOmmYVS4A9YVtZ40IywVTg5gBQiwzTJoNYIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63QGh+BrI11sMRz5cCZ1Avt7DW6pw/kd4kO2jw1o/cI=;
 b=u19gccwyTXH5XUysSiYXzxr2JbBwp83ShZM0Y9fuH+aHItiPzJuh3fAzHrS+JW1ygz1UoFWqEr61yNE7OseNaQUu4h1mhgbweI790r4k1tdQ1rc5iKRs38JW8GGVcmjIqBDHoYX0VdiwYMeGOpHHR3TtzXTPL8Ju3nlRCwZILi0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR10MB1774.namprd10.prod.outlook.com (2603:10b6:301:9::13)
 by MWHPR10MB1663.namprd10.prod.outlook.com (2603:10b6:301:7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Mon, 8 Mar
 2021 17:25:04 +0000
Received: from MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183]) by MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183%3]) with mapi id 15.20.3890.038; Mon, 8 Mar 2021
 17:25:04 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH] vfio/type1: fix vaddr_get_pfns() return in vfio_pin_page_external()
Date:   Mon,  8 Mar 2021 12:24:52 -0500
Message-Id: <20210308172452.38864-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.30.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [98.229.125.203]
X-ClientProxiedBy: MN2PR02CA0010.namprd02.prod.outlook.com
 (2603:10b6:208:fc::23) To MWHPR10MB1774.namprd10.prod.outlook.com
 (2603:10b6:301:9::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (98.229.125.203) by MN2PR02CA0010.namprd02.prod.outlook.com (2603:10b6:208:fc::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 17:25:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 223c7d56-ce17-44ab-6be3-08d8e2571ca2
X-MS-TrafficTypeDiagnostic: MWHPR10MB1663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB166310CDC4C0754EFCEA74ADD9939@MWHPR10MB1663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7dIKuLrfeShtBGfKpeJ6cXhLfM7VRqHNV18vgkW84M/aZfFFvVn4q+/lRyoMoyoOEEMhOMsXccNhelx9ksoJzKadaG5NzrzIAJjhWzkyhh7R435/sU1c/DjjDn0PPTAub6LM47Ji5w4G8/XJwDcxvtUSep9F+Nb6bfQCYwYHR5Ci2SfvS7wGPRd8s2LkdlrT1dwpVedN8ISvl9PyFS/D6ysX24H+U8tmtaQPs0ZN3l6U8Si1cUgaxwHzsPGED953Bb+ZteuSUGYwDAPHPCfcOEf8ruQ3PxypxIALpIiilR8Ck6smdCSCqI1vhuPTel5iQsmR12Q9c98mo0Rxl/2xzD/A0V2avDDwYTYx1tV+eJ/b9+sr8OvbNqwiSgaAQ8l7epaj8ieVJTm4ve8F1GwRu54I5T6Vshtr3fH73T8folCcMk0ewTYJtLRqSpGdbM+70Gqzk7iHqHYKfilxNCag3BJsTOFpY+eGpLeWnL3JwuIogCJb3H0YIe8h4kw+WSIYLN3uu4KviIqsjNp/A+15Vi6wfxwTjBEU59Xdnh9n9a3QBvaqVQsHaQS0+LZJKj6kPszaLP0d5e0RU7OfFUo1eA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1774.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(376002)(366004)(396003)(103116003)(956004)(2616005)(478600001)(5660300002)(6512007)(26005)(4326008)(69590400012)(52116002)(1076003)(66946007)(186003)(83380400001)(316002)(6486002)(16526019)(6666004)(66476007)(107886003)(8936002)(36756003)(8676002)(110136005)(2906002)(6506007)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ErWwq4rz8/A/y1jnRNy/Ay0ijHnH11f2osdRc30k59UQPFstRYgvorUrYZIz?=
 =?us-ascii?Q?8Ckzb3/13JDm5RYwJNikK7rQ/OolYkZFeWW1t/4YZoRAaDYTwrTd8Ouz+RS1?=
 =?us-ascii?Q?lB2VtQQ4UaOX9Ghxxlx5D56eKYselzy4Mvn99N0NTJqonx1TeJx9gk6GJLeR?=
 =?us-ascii?Q?PM8CVuDFuuO8fp5NzmZH5M5OoUlzGvYCGv8G8Oc8CXe9aOvXy9uw9ee2GBR+?=
 =?us-ascii?Q?RTe9VUO673gi5Sm2A0BSNvugd5fdhhSQuM7ydPFHT4N8fBHwSr0UwWOuR1Zy?=
 =?us-ascii?Q?tBSg88Dv++i5AmESIP4iA7uIISJ2DFvU7pt7/qo6g/AVuNGwF0R0lPLdNxEY?=
 =?us-ascii?Q?fSRJR9bRLwD5+QkYs1jrs9vp6dGDnYaJAzMe8NDmNWVb02fime1YfT0SZUJP?=
 =?us-ascii?Q?sQKvLYBF2nSXkRpoN+GlkNh2RQt9t6SUdOHgobC7yz5hZy2QXcshIw0NVta7?=
 =?us-ascii?Q?I0VWn/j+aK8OPosI5wFK9Qy9Xi01GblYAhnw17J02rUelEsqdBpjgBJnAENY?=
 =?us-ascii?Q?QPh3zyd1FFtJjze7enycsWxQhjrxapJwbCy6D+s/e9ypM2UDH5FB9fT0W2ip?=
 =?us-ascii?Q?TblawYj1yzDLNmj92NJ0at86cXBAg6etBrgpFQ/F2E58a4iWqoRG3LVFpQGC?=
 =?us-ascii?Q?SZHS3RNGHnO6vZBCiG5luXbp8uBH688hPByWfVdyi8b2h/Fux9r82jsLUyYC?=
 =?us-ascii?Q?8zEdIzMZbHPBfH7ApNJZUJdvaN/A0lchqgcTOApJubdGa8B4roUNAqG3A9X9?=
 =?us-ascii?Q?4kDag62nEHClJcvx7KD+/y/j2E+xeuYtQBAWNepoU+mJmdXRzWRklbWFhNEV?=
 =?us-ascii?Q?/gK6Yb4ODoVNsCcW3WxxaQeX1Ke2q5eMHE08zJR7wvv2X4NrYQkoaB4QEc82?=
 =?us-ascii?Q?OrcPyYqKvgpesZ8CnqJL5Zb7DrBhMnw3pGeJbAEsILs65aEoKXcDyqeJevDM?=
 =?us-ascii?Q?IbPxZJobKm/dTMRYFVT1sptHoHQgebYVpSUv/cJaqTLVsLPb5+hp+JYU1FsO?=
 =?us-ascii?Q?YG7iGxNNBV6xdc4GHEtGc5Wdt+MoYmefEsRh/1OLMwYSwSBibd1XZObJ7EG3?=
 =?us-ascii?Q?rKrD8yZN3QzKnLczCW/JVrzobW4WLrAMHv9+ZcFefvesjP0eaaWrLvTw+/L+?=
 =?us-ascii?Q?aahTSEE94+u0Cqx9B6sAVf7vBM+Rng6HkVSS6JnhoHB2Q/zyIq3le/9vZEYa?=
 =?us-ascii?Q?Uoa8s3Fvg8gouYYXQ2kuIjN6utXfNe1jO/YRUVKJ44TC/8kxeP3uN1CJD8az?=
 =?us-ascii?Q?vzOp9B+J2XBlX2RB+HgqV82bjfoQXqOvb0sbxUzJuPHqSxPulGdH01Py04xZ?=
 =?us-ascii?Q?c2JO5WuIUya2Lg6qKJl/q8ci?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 223c7d56-ce17-44ab-6be3-08d8e2571ca2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1774.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 17:25:04.5332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A3chzYMhkPWyTWOKxsZWa/KKnpNJcu2nytW3g5BKZWIfEgx4ONS/SGZldpCEQlxtdr0B3Ye9+qXXatNm94/5CNY8sa4ZmXaH9OR9+6tSVT8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9917 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080092
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9917 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 clxscore=1015 phishscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103080092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vaddr_get_pfns() now returns the positive number of pfns successfully
gotten instead of zero.  vfio_pin_page_external() might return 1 to
vfio_iommu_type1_pin_pages(), which will treat it as an error, if
vaddr_get_pfns() is successful but vfio_pin_page_external() doesn't
reach vfio_lock_acct().

Fix it up in vfio_pin_page_external().  Found by inspection.

Fixes: be16c1fd99f4 ("vfio/type1: Change success value of vaddr_get_pfn()")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---

I couldn't test this due to lack of hardware.

 drivers/vfio/vfio_iommu_type1.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 4bb162c1d649..2a0e3b3ce206 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -785,7 +785,12 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 		return -ENODEV;
 
 	ret = vaddr_get_pfns(mm, vaddr, 1, dma->prot, pfn_base, pages);
-	if (ret == 1 && do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
+	if (ret != 1)
+		goto out;
+
+	ret = 0;
+
+	if (do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
 		ret = vfio_lock_acct(dma, 1, true);
 		if (ret) {
 			put_pfn(*pfn_base, dma->prot);
@@ -797,6 +802,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 		}
 	}
 
+out:
 	mmput(mm);
 	return ret;
 }

base-commit: 144c79ef33536b4ecb4951e07dbc1f2b7fa99d32
-- 
2.30.1

