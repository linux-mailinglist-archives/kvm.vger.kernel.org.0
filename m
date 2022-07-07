Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C0D56A64C
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 16:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbiGGO4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 10:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236278AbiGGOzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 10:55:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F4357259;
        Thu,  7 Jul 2022 07:54:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267EiEwC001051;
        Thu, 7 Jul 2022 14:54:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=co+SUFnbzpb0M0xWw2xHu2btNQ++o54+qkPn2kXpKlM=;
 b=BWAZpIOS0h28id5QOHDDMpi+RgpVwUMV6nEHnF0vWEPqL3O0G5V6kqENjPG1bPF6hG/l
 4hris4SEcU0+KFizWT2mUYXkqELH4gmy8slJrZ36aKD2qj5y46RQ4y5ka3ROZNS35CGy
 cQt49Wrl7TatW17aPtlR+ijzaCi8nfw8OHvIt0PwPVwo4TIHtXfPcujyWn/QElPTe3Ue
 guqRA694XA1rjTZ6qU8s5s4N/iaMkYXPFAnU7htN4lqeOjvBHXCIb/+WEb/09K4dUP+M
 ECDCCiRD/UAqDlvqPfcvCl4Z/z2Z/dcRonKenC0eV85loxcqAbOOVb+8AqbsTH/DI6lv Tw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4uby5eam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 14:54:09 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267EjLrw028824;
        Thu, 7 Jul 2022 14:54:07 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h4ud6rkpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 14:54:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvUcMjGfsJUjtRq0mh/EMKsNjzlUUn4Aqk4df9tH4OiU7WlENxqq2KcMooeCBalds/l2CalSGUOwB9XIx6XegzU+nEKDiiH1gg9Mz4H/loby1UX210PVcbjlKADjocc6Ny2km9QkbzfjZ5mZ9tG7F8jGkdnzW21iMFeYJvz5TcmpSRzDOIXm2LtC5YTWXC4CCuw0h0EQwgKM7uZ2aHmacrTQ5aXGt37NW3cJtJrnkOCxBtbr9BTc45cI+yqBaYVYiRkfGpPJDQvQmA38SAmHlgMKNqd54k1a3Gi4lKQ2UwTfvgI4/BgeMP6MCiIlo2uMabLAa2Qj0i2ZVyl09iYUhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=co+SUFnbzpb0M0xWw2xHu2btNQ++o54+qkPn2kXpKlM=;
 b=UlXu2KEOTHUWygMCVd8DXbLrAWYDXnRCQQWKtNmx4SRgcqFkWi6ex944BuK4DQRqJKRVgnKrTgue7418lCtAOYNU6KxT4efqNJuRkcaW0CfF5+ApaCIUrqJhE2zgVGHw5BrbfJbA38rJl6kITGNMbI3j3tWnDPOaPJLGganHj7T+6/5YsoebUQMgDZJkrnMShlrZCh1F8RwSKIuKT38DTt5OKBulFrJZXBQCPFq9nvupNB3DdyneVSOsz/SWS+E90eN7PGlYXF/L6+w0cW6ErOyummWHW8yGFYUFnAk7u/UfU2m25/u18d3SwmAMPmvKCd/aXrPbRHGx600TEuaBMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=co+SUFnbzpb0M0xWw2xHu2btNQ++o54+qkPn2kXpKlM=;
 b=twr3qcYjZPhTjfepaEfllIqUStaS75RmEceXGey29QzzK9aGsTRZkFh0dijYh/pvZeXUFjrCaHYncT23B94YH8dXXN2eoW7EETakm8jKXSkq8cYJFM3IuHRKg0jhi81/X68MAhDF2QbzPH0td2xsi5uSsY5es5UxssRA8DwNXLI=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by IA1PR10MB6100.namprd10.prod.outlook.com
 (2603:10b6:208:3ab::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 7 Jul
 2022 14:54:05 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 14:54:05 +0000
Date:   Thu, 7 Jul 2022 17:53:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Leon Romanovsky <leon@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] vfio/mlx5: clean up overflow check
Message-ID: <YsbzgQQ4bg6v+iTS@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0115.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::12) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 364df5ef-8172-4588-1cfd-08da602889f5
X-MS-TrafficTypeDiagnostic: IA1PR10MB6100:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A1A9O5N2RFiZy8nSkKP/q3ARMPcOVRQ8kuj8YH6+XRrUU35sHw/CNepO1YVoA2ivcNod8mbu/2ARAkYcyJTL5U5Mt8145oP1jzitnqHysszai1zCB+1ULWR4HKu0ilvRLFJb16hMQ1G4JZOl86dCQZq5egVN4RrbyMVEvQObzCRpc8OewjQF5fQ7qhU183CfWzE+McTCUEbayXcgtHPemnriDQ6OCnXnXd1yzd7lQfSzGBiNOnpJjsHn8SeZUgODUYQSyHl+agVBNnjH21RF01ieYuddt1SFhdIe+ATSO9cJebmdDVIV08+4TbwuqLoa+TIsRtKzthy26niIduugnvgrzmZviugMG0re9R/qIwuBJbqmKabdYawO1XlNAdnONscnkU0TsZASLWclcF7JMwCP3B9xfEx+GbInmn+lKuA6A/tymuJ10w7DheBGbwSgLi0AjV4unoHizs0ZIDGwByyZcW3HgRBMhbU/sXGRbNXtAEGXu+aPI8QI6SL4afa1V8abVgWFIthkDYypbh88iP3iAkMSjk3hFvMPnw+ZkSjFT/iPg2JwiHnMrR19EZr49crYroH8VuKvzfkPDtM8aWihlewYlPFv02tZogd/tDSkOcVd2bj/zxg+/AkCjR8kqzhoBxnAG5xVUgCD80qPH8FS0LUUE3CT15R3T99+dTIHIyWML8Y390BF0XaYt8LkwM8kHLg/bpT1fgIFVPRtyOVj/URbjcxXwhYhcWuf1ty1KTHhlESHH/493OlqPOzTWBx+USbbJ7TcMljE28q7qMEEvdXxPF2ODtb/6p2qBwI7ehaYMjZ3Ke0zjAlXV9/D+27cSVj12NPZ7bXeuA1f+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(346002)(39860400002)(136003)(366004)(396003)(4326008)(66946007)(66476007)(8936002)(83380400001)(7416002)(66556008)(8676002)(6486002)(9686003)(478600001)(44832011)(33716001)(26005)(54906003)(316002)(5660300002)(6512007)(38350700002)(6506007)(2906002)(38100700002)(6916009)(41300700001)(186003)(86362001)(52116002)(6666004)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2gGS1W3hxAFzEGFHnDDyScZ0ZjHTtTf7A2jAuLQh/OCyPoowu1nbmsXzf00R?=
 =?us-ascii?Q?evP9wWg6Mcq62/1QGett4FeowVnfENl5jELtNmHwrEXr8i58Ne3Y7jmmOGVt?=
 =?us-ascii?Q?qNdN2WpyOn3jonKjTaEoQWthD0hsKXifUISuhzXJSqMdK9W3k62WONaG3ePF?=
 =?us-ascii?Q?4gmdm2V55mw2WhkrLEy86TVMMmoOo8dgZS84UQxi82VIIOALsL+J0+V2+Nc5?=
 =?us-ascii?Q?JFQ5n9OvdZByErorx5bRE2+hjkA48B0oGd0wnkSBwtXgurxBGEQN3D9I3B1Z?=
 =?us-ascii?Q?ndmoKFAimL5pdT6qqI5Q9zgtELfg5agkqfJyTeQmYsCUPeS4XYxv1eLSsYtp?=
 =?us-ascii?Q?V03XPaMOqvkzlQk744Fypb8O1/kTvD89anW4BNq0GLcvtDW4qKB9QHgmBFwl?=
 =?us-ascii?Q?mqPZsB1YXRaUVmN3EH+Thate4fEUzsg8MN6wH9nSqIim4leunfRIzCs/OMma?=
 =?us-ascii?Q?X7rXXq+8M39O4GTqBPSufzvd9kwwUgzqmZ5YBwYKBh5pc05ctFcL0fhUSFnC?=
 =?us-ascii?Q?T8iJETShOJnE5w8jzL6DJmsYcBNGd6n383kB+nPm/80Wnm8AZoesFJhtSZG7?=
 =?us-ascii?Q?7VwSiCxptEzVApEY8nnEfSScseW/5jkvyBY1JKM5rGs+DkkwWRKN7MkQXyvO?=
 =?us-ascii?Q?XEoicshljpyHHvrDZJWN8Xu5Tc+fa5YalyR9fjtx7pnL2Kp2gP7XEl0yvUta?=
 =?us-ascii?Q?/yrP1fJQg9x8L5UPXJ7fEAUARkEvkj0xVlHyHNmHuxdWDXrpe51+tPAzehli?=
 =?us-ascii?Q?N6LO3tNkd6w0skGy0ZC9bB+XrWlGKXfFYR1rJRRLmkLcMrzXxNBMReBz4i/3?=
 =?us-ascii?Q?z5oT7uBUlwvCZt0CerOwcBu7Gs7roEr4Ji5ZS3rIr0rAO5RBK8n9oZ2yLD48?=
 =?us-ascii?Q?aVGqFLg8bgcI4662jyUg0vvf+y7m1UvF5DtdQ2O9wPtygKIQyhc1asZYwSYa?=
 =?us-ascii?Q?d2vpk5erCN6F3d8m47OuEw0gAgqM+SdfHfvxVo0JwgAYvmXvTvMyD2tScFy6?=
 =?us-ascii?Q?3gaFeeMhQLrPgqi2d9Gp5AiPbLS62VQiVGWMsj/mM3G4VHkwYmLmpCuAHVsy?=
 =?us-ascii?Q?b9wA70T3cTeNZ010HyrmfAyetTxDj5t6w9Kgi6PE9BHtnT6gX6Dz1KNtDMMX?=
 =?us-ascii?Q?K1NTKzZ220bsPkUH7TQPIaWezfK0HcC+vZ4dqcAyeHuM5iUIscYTswmKf4Og?=
 =?us-ascii?Q?+AZua5JqJ3sv0vLfqUg07Mh+4pAINuJ0pu6ooWR8P6vo5xDW1D1voY05XShV?=
 =?us-ascii?Q?SvvsZA9JmjXj+np4RPzRxxb6EaQl+AtRxUQFPETsUG/r4zxcGX9K2Yzw2+ui?=
 =?us-ascii?Q?JNVwckJPOkwEUVWfbutyHen9EI0mWDw73ISAsxtNwJBQurNRZNiIptifMx5O?=
 =?us-ascii?Q?fyHNTzYrvEbzcWsfFyholanGvQUCqaAve3z3SgZTkpTKkKH5EGSdXyxRR3qo?=
 =?us-ascii?Q?AA4ASmIMTH2MqMSPFi1zXQuwaiwuVTNjshHR9P0dm5znVq5IOKnVZ9+oUfPx?=
 =?us-ascii?Q?Mpi3XwRC0BuN1iY9DeAvm2DCPsrLGWhNNZ8sy5n7w2hUJltHC73Ykvq9Mu1f?=
 =?us-ascii?Q?QB31X75FTw6+vK7yOdndj1KHOt2QKQmkuqj3R2Hr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 364df5ef-8172-4588-1cfd-08da602889f5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 14:54:05.7253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +at03cn+q4+xn67SHCLuTmeBkjvCtz/gj1xX8HfKQbNCxs19G9R6DFbMUtbTcbtz9hAidQUmUauv/yXNfE9uLZOWa7stBujpiI974y1Ugpw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6100
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_12:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070058
X-Proofpoint-ORIG-GUID: xArhoxJuktsP3FBJH_FBs4KfJ7YJMxhQ
X-Proofpoint-GUID: xArhoxJuktsP3FBJH_FBs4KfJ7YJMxhQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The casting on this overflow check is not done correctly, but
fortunately checks in the callers should prevent this from affecting
runtime.

The "len" variable is unsigned long while "*pos" and "requested_length"
are signed long long.  Imagine "len" was ULONG_MAX and "*pos" was 2.
Then "ULONG_MAX + 2 = 1" which is an integer overflow so it will be
caught.  However if we cast "len" to a long long then it becomes
"-1 + 2 = 1" which is not an integer overflow and will not be caught.

However "len" cannot actually be that high and the check for "*pos < 0"
means that this cannot happen.  Still it's worth cleaning up just as a
hardenning measure and so that it's not copy and pasted to other places.

Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devices")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/vfio/pci/mlx5/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index a9b63d15c5d3..c65dca59caec 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -271,15 +271,15 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 				   size_t len, loff_t *pos)
 {
 	struct mlx5_vf_migration_file *migf = filp->private_data;
-	loff_t requested_length;
+	unsigned long requested_length;
 	ssize_t done = 0;
 
 	if (pos)
 		return -ESPIPE;
 	pos = &filp->f_pos;
 
-	if (*pos < 0 ||
-	    check_add_overflow((loff_t)len, *pos, &requested_length))
+	if (*pos < 0 || *pos > ULONG_MAX ||
+	    check_add_overflow(len, (unsigned long)*pos, &requested_length))
 		return -EINVAL;
 
 	if (requested_length > MAX_MIGRATION_SIZE)
-- 
2.35.1

