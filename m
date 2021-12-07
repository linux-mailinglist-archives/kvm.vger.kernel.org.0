Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4806346BA61
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 12:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhLGLwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 06:52:30 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6284 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231392AbhLGLwa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 06:52:30 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B79HsMA004042;
        Tue, 7 Dec 2021 11:48:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=0ley19ptHkvwF+MZAeRKHeKvNE/jvBdhsdPPC84XZ+0=;
 b=WpsILFul7RFBWG3qylULhA3dXa4Sv3Jczi9vLKcKJEZNEiKgyXFkzszSojbisMbLV0E9
 NNkRdzcIRnEgxGwwBOSww0Gc3FdD/LODBs5hzI73ja1pfVC64yVvDa7TRkz5dvrH4H7w
 rus2dEGHNM4ZttyH0wTONoSQ2Cnz1wiF8gTKBHUdno50at2Ncgk+prKYSUiRkmoDGXNd
 t82PUC4MzRuUIbZtSfgIK2u5ScP4Dv7hQbpjHx7ieRS1T1q5Hp4EGt0V/NfJe6D2WiZx
 Zd0oNWeabPK6MhMVM+51E6N+oabJvoyesZGe1t8eAjgoMqC7CRPhc2Mqy1eg2Up63eIL aQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cscwcdaxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 11:48:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B7BkfRQ004513;
        Tue, 7 Dec 2021 11:48:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3020.oracle.com with ESMTP id 3cr1snu8eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 11:48:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e4VbhQdubOX4ZtLsiAsZGzbxHoafCaEdjvVrAQWSMEYsq7NMkt85IRhM29ft65Qtzap+63lXwzFpNavhbcqXy6QTB+sFwGSRNJ8+ejwi7wbf37qcG3oH8+P25KykXdxnmkbYayAhdkg53uFjJ2eO5j/3onLxAb/Ecp1EAlzufr8Bc6MnlXsw9KuxZztaxY57dnFqR/RVwjEVtyMjlQ7n4I5mESjzj5ZTiXlrBCcVovRCaB2JbJngh5vULnswusO2L+1vNrM/Z4eKWQ3QFKTOg9eYyGMO/Rvwdmq9MZiQzIl8thJoaJlS6muSY6CYBOEt+0EwPQ0OePHf4N33MB/QjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ley19ptHkvwF+MZAeRKHeKvNE/jvBdhsdPPC84XZ+0=;
 b=Zfk55Rpc19650hwLFmSU5wYp7LrP6NFFXruaoCwo43wCvBZjR1Cr8A/6psIx1rpBBSFyCOOPK6QgVl0BTB1mliRfxsv9YomOoo8K34Fr+1uu0rerafa7M6MEwx6yTKwDH3qWY6pUcKRpGoaKMhwIsJ5LpvTrRfuv1HhvcMIdWWL7tPqROIItQMeG5WpvMWJmGQBgC22NV5pMwsgQVigQFZ9rIg+b7AT/GznIh6JkwU3hZ0pGta/myvh7DVAUhqHTfbg913LW9ZL+JDJ6TtWSo6f/4AuTU+LHEidKijWPoMxXEHqE09ogEXaTAHaNpkdszKC7qL50ZCQ5dhKu/U3niA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ley19ptHkvwF+MZAeRKHeKvNE/jvBdhsdPPC84XZ+0=;
 b=XryPIIIkK7XE71BIPeqTKijfABMJHciN/zstWDeGcSp4hckbkxqKEuXY5ewNA7/zhSxhhIyu0ftntau5UZbPl/wTOevZIDsPcnXvSqOMPL+btt36hqRyJtdHYrfBqDFlkxyxGxZzhSF+4n7UZhKwEWCG3mVchnJElHH9ujiLSao=
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32) by CY4PR10MB1608.namprd10.prod.outlook.com
 (2603:10b6:910:9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 11:48:50 +0000
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::fcb1:e595:35ee:6233]) by CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::fcb1:e595:35ee:6233%5]) with mapi id 15.20.4755.021; Tue, 7 Dec 2021
 11:48:50 +0000
Date:   Tue, 7 Dec 2021 14:48:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Cc:     Jason Wang <jasowang@redhat.com>, Eli Cohen <elic@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v3] vduse: vduse: check that offsets are within bounds
Message-ID: <20211207114835.GA31153@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM6PR10CA0051.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:80::28) To CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by AM6PR10CA0051.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:80::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Tue, 7 Dec 2021 11:48:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee50196a-e2c1-4888-16f9-08d9b97788e4
X-MS-TrafficTypeDiagnostic: CY4PR10MB1608:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1608A1B702284B90B4FB7C5C8E6E9@CY4PR10MB1608.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t5ezR0NObTAg6wugvOD43zsQ9OQuzwzaqN0ELHlQ/xnYXrBcIYb6FVAVxIOFwaV8HeHZ/ohvE/MI07bx0F+7Zcs4ivvjIddrA8lJR8kxGE4KjNWFlKmlNArUKiBDG9AAZ7GcWvrja7Xw5VTFIxKuUufRfBMHgwUHoUrc8Yjqm19feIskWn6U7DtLYrU/pON8r0pr/4GoVd7xoaEO9Bv3LAgaI19yr8/QsRLtq+Kkiiz03geFNiaojjETCB0bGyy0ayAwAssRfYZrAj+EFvn4UdUqE9kAf2efFQkdNMXOPR/H8sjoemYdsKR7rLYoaUA/fhlOQ1o8bc2mMbiw3uiHSunCXLAccshQNf/d4lEbRjxCDo5pj6FVRUD6wYmZf5gQaDgwjeW8CqiY+bvMUhfxAgHM6sOI18HgYdfWPGBpkE4E2+E8xf2y5wp1sJPb75z1Xg3r4S/P9cqrlTJJt5efGsUoSzdJsG2S+lgaHJiDZgiDMbpllRiQJLsEpHa4iSHIsqnF+jUlIc55AXjvJH2HgZ87fZf1u8KyqrrvZDPC410K4xEntZch/JwBRVAY6FglyTn+q4PDHs3L/TRyJ/d4QZ3kcOIGqOGB0y3J5Kv9jMbmdObMZ58R1/nBmTXECtzp+EUbmYGhoT7kbntrlrhfhRI0E9/z2wY3iALZNWvddctehGmSNK6ctO9iwvnEZIfxtANH9rVYMLk5UW8O08mu8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2358.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(2906002)(86362001)(9686003)(55016003)(316002)(83380400001)(4326008)(54906003)(110136005)(186003)(7416002)(9576002)(6496006)(66556008)(66476007)(38100700002)(1076003)(8676002)(33656002)(8936002)(33716001)(508600001)(38350700002)(66946007)(52116002)(26005)(956004)(44832011)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V4vNMh7ey0MQvwXBlvcklzgj5wRrHiRG9O02GhRjaMSBmTLdZJo/fzhZXM9T?=
 =?us-ascii?Q?xJv6IlU2UaHJvHw/Kri9sNLFRSzcVOH1kBwSJv2ktUmEP8B3bFNK9B9jd+kF?=
 =?us-ascii?Q?5c66vDVO9pashMNY+yxqNjrxOHunJSW/0TZ3KX0dlJqsrn+VqEA5HO5jVlUF?=
 =?us-ascii?Q?vrOEV08+rRGtfxf4VajCauD+675984T30/CfN8w/gb5amaGiKJxY0qZGEJJE?=
 =?us-ascii?Q?d+BVS5fenWWUI3e4BvzEHv7umETYcr1DC0G91LLrawutTH/UXpJ6/s1sGfUq?=
 =?us-ascii?Q?42z9rdqdYboeKqoOHXqhwU9E0Gjui/SpncxcQyT5ObQjD8S7iSJP+tjyUjC7?=
 =?us-ascii?Q?Rr6x12KTOesOR9V19N8Lh33w8PtPEtMLtojvgbKC7MNqreXdfOTG/Iv0ZacR?=
 =?us-ascii?Q?7NWtLHZVnsiqMiJ5pC0S5HJGKBs29nJ+mwJLddtBL23wh+naT0kTzT3ZA86w?=
 =?us-ascii?Q?yZ6exb1DAhBAX4iQ4CvWCKxOvivqLCW6grDjlDc1CMza2kICZKpThsv/1mkc?=
 =?us-ascii?Q?GvvC+bVhfPfTzYy18O37FkXPt03sXOZTUSDo4B6EBM6uHL7y6pYfgzgpBMXH?=
 =?us-ascii?Q?AOyq+m2bfiRF/lDPN4yszxZheYB1BNiMElzPUlCtBPGKH0+zIGNBdL7bXJv1?=
 =?us-ascii?Q?6QtccJkMdiMBLtUvWEh7d2Igvi7tDz/V0FNVqstVE3mAeHq8LfyebyE1IG5/?=
 =?us-ascii?Q?dnJzB6awfcG9yaa9EOT7W0WeiC2a2QdBP1Ji5MWtBhRbfGXI53ZmeW+iI1l7?=
 =?us-ascii?Q?83XRdOtqcbcuZS1a3xTnG0DvIG07TMEtu8Bv+MvAgvy0ShygZRdzcujMspbb?=
 =?us-ascii?Q?YmPvm2sYCxXHucs3jJbgR/nOhNIsN+bywHlL8zLu1w/UqTGtkdzXwCs7CYD9?=
 =?us-ascii?Q?9qa42z96p1TJHHkTLUjKE9bTYqPUMCe7vq4QYDFponesc6IS1Q8oq02jmnjg?=
 =?us-ascii?Q?Bxz4Wr7ua4Lefjd6A5i0jjg9KD7iOrU4u9D1JocVqgjxm5opRpc+1tUw24Wp?=
 =?us-ascii?Q?0mwcz5z5JeeoK0S6Jh0dgtt83zqHgAE2is6sONxqjlI7LyOVaTdEBmYvmuKs?=
 =?us-ascii?Q?gViGB77FK7+z8hT0E8yEDPJ3Zdvg6ohaaTWNX7JErrxwzoZoWNbENl2nN5VN?=
 =?us-ascii?Q?1vBRzU3fICh5bDxbmKxPFOySQKE9yx0QP2/T9wM7MPnBYZb7fogDxUKHbAGr?=
 =?us-ascii?Q?BVU0plsxX73HduDZ8TKJmuxQEs2o+Sg+PR70aX0OmDtig7TWs7T8omSHMU7B?=
 =?us-ascii?Q?V2LLBC2vhpa3Df0l8EqJxoZSuPWbM6DXZNR9rvu9IBoqdpsfHKCE0fWhIRTr?=
 =?us-ascii?Q?kVnGevZS1OMf6kc3XXdLojdBBzV/qkYJgsqtr4bb0xaWCve7e88Tb6KH/3rQ?=
 =?us-ascii?Q?A543JEh+Uc1nNC/v/Q2JdAJKygembEBRK/4NHTJfp9U82q38VDPvNRmixRfP?=
 =?us-ascii?Q?TZAbOgOHpIXWE0hD55c8YQsL6RkTtEt+QJeWWY1oJT6BQGSqGzxzO+wV5OT4?=
 =?us-ascii?Q?ksj+0ZZMBAbh0xwzkD9X2YtNvpuKYxHheNuTkLtnfT+iWnwEn9jNxNp39y2t?=
 =?us-ascii?Q?tB/X9dwoFDm5N/5m448QfAitFrsic9LOzqJVymQ3fH5Oiy8o58CIBPOr1I7n?=
 =?us-ascii?Q?Nr9876xlolPW327faP9Fb7IgoUkzHNioOkIgpC9mbOeh8+O/SK2xV1hpQ7NW?=
 =?us-ascii?Q?OEZbEvOHQ60pivnEidSvqAn/DTE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee50196a-e2c1-4888-16f9-08d9b97788e4
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2358.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 11:48:50.3219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VDcGLQjR2LcWWICfca7KhgVb5v6IjL5y3q5qnWxBuE3E3UB/avHiUcb2P5c7SJsCya6D5MC41ol1AOfWNVWE4ZnXs7Rwkn/whRsmj01Un7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1608
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070068
X-Proofpoint-ORIG-GUID: ysk95o_aBPxkH3AE1c2tAXGd3XyncdKF
X-Proofpoint-GUID: ysk95o_aBPxkH3AE1c2tAXGd3XyncdKF
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In vduse_dev_ioctl(), the "config.offset" comes from the user.  There
needs to a check to prevent it being out of bounds.  The "config.offset"
and "dev->config_size" variables are both type u32.  So if the offset is
out of bounds then the "dev->config_size - config.offset" subtraction
results in a very high u32 value.

The vhost_vdpa_config_validate() function has a similar issue, but there
the "size" is long type so the subtraction works on 64bit system and
this change only affects 32bit systems.

Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: the first version had a reversed if statement
v3: fix vhost_vdpa_config_validate() as pointed out by Yongji Xie.

 drivers/vdpa/vdpa_user/vduse_dev.c | 3 ++-
 drivers/vhost/vdpa.c               | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index c9204c62f339..1a206f95d73a 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -975,7 +975,8 @@ static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
 			break;
 
 		ret = -EINVAL;
-		if (config.length == 0 ||
+		if (config.offset > dev->config_size ||
+		    config.length == 0 ||
 		    config.length > dev->config_size - config.offset)
 			break;
 
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 29cced1cd277..e3c4f059b21a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -197,7 +197,7 @@ static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
 	struct vdpa_device *vdpa = v->vdpa;
 	long size = vdpa->config->get_config_size(vdpa);
 
-	if (c->len == 0)
+	if (c->len == 0 || c->off > size)
 		return -EINVAL;
 
 	if (c->len > size - c->off)
-- 
2.20.1

