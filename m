Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2136730E43A
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 21:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbhBCUuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 15:50:09 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:38946 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbhBCUtc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 15:49:32 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 113Kdoln011008;
        Wed, 3 Feb 2021 20:48:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=MMAIGVidxAoUcHFDQVwPcGjXu3GebjAX1UdGntEwyM8=;
 b=h4IU900LhcefsDikO8hfpNGEAn/mBCVE/dYPBB4OwOE2W1qcI+EFVxUHekuxy+6HYy4t
 HC6wm3PSIxJrWVA2KaUf9XrFIPtH2EmdHlBbZVYP9DwhE6CPu94n1DNL9tL2G/XjrHCU
 7m8KB7NnOfh65RGNQbQY5D1ulIBGvBswhyOxnrrx7qf+YdFGwClBQMPiUYfKzCRTXeZh
 h+jJkwkZbTGQTVqbVBiJaHe2C7dZ8F5ExwbXqMg/DtbTyfID3+D7lVC26bfR8LbmjtUB
 IHreOkaxyCNAKcyEle/I8VDRLS5VUOkN+MZ9MXjCQ+zCpH7188rUv4cru2xw/81X6CNx FA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36cvyb2btc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 20:48:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 113Kj3ib135633;
        Wed, 3 Feb 2021 20:48:14 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2044.outbound.protection.outlook.com [104.47.74.44])
        by aserp3020.oracle.com with ESMTP id 36dhc1qb23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Feb 2021 20:48:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AwSImoLETAhnSv5Cyd64OiVosNhEOaHvJOswl5N1/BozarU/TENjwThGQApvZD7zTyPW8neKEs+/2ojsEnhuMJixqrljNwd+6fepB/ryZaHm7GSOih6PjopsnXTDtRAaMvFLr9gO3GJ5O26GcE+YrfQK9bCwdw5bvNPOvHb3Bn8UvtKf7zjWNuDbzgPXpaAqjnDacVzA+lPaD2gLtlPDI1XSWB+xaDuEK7H8mJXEv/BcM5maTnPZmU4SXphUpjtvGCvtd7l8e2E9fjlgcSa932CpepSs4Ul1R4WxGC9VE5YNGtF1sw4km2qkXJtdw7tHSuYqUd/nN1ppJ8KeY5DoQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMAIGVidxAoUcHFDQVwPcGjXu3GebjAX1UdGntEwyM8=;
 b=U+ilUR1f30dldmFskp4a+1reneH2G5oHlurHB8PP15juBxMPCPNqlWi0X5BIoNn/NwxKjV1uOE8oevEGnTDINKhO8gtcVK8QVMBsqLQciB1L3SfRNS20dNu4i0KD60SW+D9iuQoTzWNeVr15dQNeSKRsEq6LUZ/aFdb4U0CQ0d78cr0YfsKQzhIe6DKu6pFhlNwCUhSgh+lPA7CexeLI2hb2YQH1N0oOXPwabPq1maIa17asDEZh7DguptOffp6fNynq33mFk+s4yR0BpJRANxvMsn1tLt4xWD+12siPtUk4I90BpOArP5y88PKN/eCj9mjAUrw6QluYwmTifVu0XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMAIGVidxAoUcHFDQVwPcGjXu3GebjAX1UdGntEwyM8=;
 b=SivXX1r1v2FGZI7JDeI/44jhuDzuvwf+3z1Ak8hlJHsNSBbVZC/quS0hn0NNyNf/QCgB/Kn2CouQH8rmxUjFxi9uVyETdT3BOtV+wQmAO2iUN5XwhUiV0aYJree99zkryyiTlOrvBhBs+nfy5TDRu6PK7LvvcKot28EzsnrmDrU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR10MB1774.namprd10.prod.outlook.com (2603:10b6:301:9::13)
 by CO1PR10MB4691.namprd10.prod.outlook.com (2603:10b6:303:92::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Wed, 3 Feb
 2021 20:48:12 +0000
Received: from MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183]) by MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183%3]) with mapi id 15.20.3805.027; Wed, 3 Feb 2021
 20:48:12 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH 0/3] vfio/type1: batch page pinning
Date:   Wed,  3 Feb 2021 15:47:53 -0500
Message-Id: <20210203204756.125734-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.30.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [98.229.125.203]
X-ClientProxiedBy: BL1PR13CA0215.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::10) To MWHPR10MB1774.namprd10.prod.outlook.com
 (2603:10b6:301:9::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (98.229.125.203) by BL1PR13CA0215.namprd13.prod.outlook.com (2603:10b6:208:2bf::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.15 via Frontend Transport; Wed, 3 Feb 2021 20:48:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b941c865-641c-4b62-ea56-08d8c885056c
X-MS-TrafficTypeDiagnostic: CO1PR10MB4691:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4691A36C636AF39F8AE2D1E4D9B49@CO1PR10MB4691.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /d7HnNDxQNkYkE4P1L+IglWA4wlK1+MexfPHP6/jkJBJdz2Zjy7IxoqehqsLkWckcBlhxFyK2JvPX7m/XFS4nyULLa9pPOLjRnj7wzl4AisuEbz/g5V+xNXhmYNRT3aZM25+j1q9iH9xIQogsPlA0HE4Jw1UtKOz0ydHzva2KOw58zCtRvT8UnGd83nuMwEmZIkOzarIdmYyWaTRUYsClNPE6XaogcUqQczUxX7Alv/Bx0Mj+J5K8T/sLL0I+I3bo37n+pxXvvA7BU90dzRSnRrTh/NmdkpDb3Y9Bsqu6MSV6WzPJ+w49O4hXkYGRbF0g/AZ2y2l69EDOCHhf+1GCg5To85WZ1n0wslFFUbLzDRGrMhjsDz8BKf7c19uUNi/bNrPDJ/grkFBAdL1HY6umfFbh39gM8+IHyvujksXtbiSp0GWby9HES1+D9Zq6vTw29UOZmrc1bELXvZUftSbj3bJPu/uh4zpo1lbcuf7qSxQ0pKWWW3Jk8+nm7fd4OURws55aXxlpAXmvRMi8dKld20fPgaCWomfBBHxeIfQbzd3aa+vvVQImEqYgIxtEfm+N+HudYpPTHVXZ66KIpyUjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1774.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(136003)(346002)(103116003)(6486002)(478600001)(36756003)(107886003)(4326008)(66946007)(8936002)(1076003)(16526019)(5660300002)(110136005)(54906003)(26005)(186003)(6506007)(69590400011)(52116002)(8676002)(86362001)(83380400001)(316002)(2906002)(6512007)(956004)(66476007)(66556008)(2616005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?aWu3+1Z3V9AVCUfRRd6DZ5Rk8CMIS0EVp6cyWgbkJtNQtUvKTOigd57IbJl1?=
 =?us-ascii?Q?Amv5jUcLjpT6crrdsyeHZCBKJ3XqvnhJzxcKYizDUGZQ1xjQDsNO/6lWXUyh?=
 =?us-ascii?Q?iwwRmlU6/oOPZB6XtNu14c5S8lX6mq60YvNjYbtekVcMmcsGkCJNYqTes3sf?=
 =?us-ascii?Q?6RlZ2FMq2/84w4EsTiwxjVNwSFZh82t+ozz08VaLkEYy6hiSgsUMA5Vg6eDj?=
 =?us-ascii?Q?g65QnChbq5lBv3vwkcioqHmard+d+0faSKvcdDAR/2HbZ61dMeBAak47pl+P?=
 =?us-ascii?Q?4gxUnHmB8synmPLIUkFqr1sZ1Wu1ZeIwebvNtmUNqRs3XMRyc7hpVGlUfxQJ?=
 =?us-ascii?Q?6yEBt7P/WI1Z4QSjUaPYdRJyH0Njg4OO7tsNDQWgeqeKx/YZSLDqoE1oPiiV?=
 =?us-ascii?Q?5sxHhUk3qDbxvOKFmbUen+oiKsri8P9tqsSW7egoOGiwxJVVCMV4G3OgiJyY?=
 =?us-ascii?Q?7+R4skfxkfXPoaHKLQlgAfOjg6V0BdOVA7bXsiBSaM7IoOnvNF/pGxxVGndt?=
 =?us-ascii?Q?gARwZ4+sQGat7USfxzWPx9odDeMu7uK3CWHDzd80qYXLHLW4g51gmAtFCVf2?=
 =?us-ascii?Q?XTbVOp0wHNNGCH9xjGOM06tLfCgrqr5a8O8t4/pw5+hxHEBBT7OSuWdMSVBZ?=
 =?us-ascii?Q?y/5hJhFMDMw6PW5E2bZxtDlQkXMFZyBSu96dr+TW1/iA25756I07F49fhUXK?=
 =?us-ascii?Q?iyhKZnb5ZUYnoQAzOx/arz8DTacArHxEadX/PkvxEF7Eob6EF01IrpxDcIuB?=
 =?us-ascii?Q?O/RJG+FQf1iKKcEDWsf99XChYOK9JWB+Qo21K5lYD9ZpEMpkLQCfvMPoW7Mp?=
 =?us-ascii?Q?lofVxGpAEuD4hqIKmovaWZPPNdqredlfO+Pp1R+b9ta7eMBVmgRgvTc34QMM?=
 =?us-ascii?Q?RsOyslZO95qZhAdNi8u8H7ziLRe+g9uJJBTr13nyS8bzJPPB5IUE63IryXzZ?=
 =?us-ascii?Q?UG599T1xHe/NShNhzkQUr/4a06M50ooOMJOmfujRbzAeoFbObNCweygLdEh8?=
 =?us-ascii?Q?KG3M10JLBl5WCwTZdScJAslABumr6bi0XPLhosjaMIipanyUsvijcgEZpUax?=
 =?us-ascii?Q?ahgnO2RlBDXC8uO8xEr71srEKXqHEmkdX1srHn/OowG9Q2BJSsoNoBUyG7Lh?=
 =?us-ascii?Q?So77SOlRQOlMIdLfkTspLUxAX32BZgTc+Zzkbs9LPJt/X6JSoZEFk+umDGms?=
 =?us-ascii?Q?Id1mjtkiTO7Tqa/Lxytpiub3PCvTKG6e5ILgamFBLJrZNP0lORC8G+JYJkM3?=
 =?us-ascii?Q?udUiyeIzHRTqxj1Au32qSkU8i9siHbOYIZgyNkW/xnfglzW8ndpOSVkWG20j?=
 =?us-ascii?Q?qloUfOyNYFQqXq6ZoPAQxEj7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b941c865-641c-4b62-ea56-08d8c885056c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1774.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 20:48:12.2693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t/IpXgvLJ7L6pLKSu14R5FJ+lli0MVXX6bJxHsmerNCB8l0eaWBDtjTv4BO0w96ZRAMfWshDsdils87AhAEdkzgD/xDmndIpz3I9OoQ7mr0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4691
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102030124
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9884 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030123
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

The VFIO type1 driver is calling pin_user_pages_remote() once per 4k page, so
let's do it once per 512 4k pages to bring VFIO in line with other drivers such
as IB and vDPA.

qemu guests with at least 2G memory start about 8% faster on a Xeon server,
with more detailed results in the last changelog.

Thanks to Matthew, who first suggested the idea to me.

Daniel


Test Cases
----------

 1) qemu passthrough with IOMMU-capable PCI device

 2) standalone program to hit
        vfio_pin_map_dma() -> vfio_pin_pages_remote()

 3) standalone program to hit
        vfio_iommu_replay() -> vfio_pin_pages_remote()

Each was run...

 - with varying sizes
 - with/without disable_hugepages=1
 - with/without LOCKED_VM exceeded

I didn't test vfio_pin_page_external() because there was no readily available
hardware, but the changes there are pretty minimal.

Series based on v5.11-rc6.


Daniel Jordan (3):
  vfio/type1: change success value of vaddr_get_pfn()
  vfio/type1: prepare for batched pinning with struct vfio_batch
  vfio/type1: batch page pinning

 drivers/vfio/vfio_iommu_type1.c | 213 +++++++++++++++++++++++---------
 1 file changed, 154 insertions(+), 59 deletions(-)


base-commit: 1048ba83fb1c00cd24172e23e8263972f6b5d9ac
-- 
2.30.0

