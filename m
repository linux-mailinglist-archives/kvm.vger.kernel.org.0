Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6B831FCE5
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 17:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbhBSQOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 11:14:31 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46672 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhBSQOW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Feb 2021 11:14:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JG9kIc047729;
        Fri, 19 Feb 2021 16:13:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=bVjF1+RjAnffvnw7iAX0KyOJrk/f9r164jRnov3l7qE=;
 b=kowaW01je9JNDxC+EjxnMRGkhRAXGEWllCR/e4JEIy4RQmdiHJ9zO8S1YkjWnSsTnaDk
 pDUzyD0b7Cmz7ni3UT2Q0B2Na39IIwCyHb3hXGEEGzZX4asbfT4ZPTWiqDWUkc5MQFI1
 uR0o9d3Ebdg+jMkk5bIlkbsRVlca5g+bC/MJBsnDVtIsJycQOhL8SEIk87Jq3S8+Tre7
 35F2fZz9+MJcgJla95fTv4R6O01is84SauvYE+KSxnJEWCD+6jq4lABT1BHFRCgh+0gZ
 T/h/obE85OsbUYrFH9uS2hnFxMzmfQf2gMVWVlxNSZ+XmWKtiumXro+oObu1JJxai96I nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36pd9ahj5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 16:13:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11JGAHqc113531;
        Fri, 19 Feb 2021 16:13:22 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by userp3030.oracle.com with ESMTP id 36prq226rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 16:13:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eefgWqWZoFrMvktIlGSoUsy1dpiIRHoibZewghIVgXU6R3nvdgdv3Cme+A9uovW/5HTVXw/9WuOn/JGefU4XpILmY+vfYf1S9oHI/2/iEF+mZHeSTpgQyhKgz6/AAiQf27PIGBQYZ2Pez4MtLHMZy/m7eCIfjbMnVWAyRA4GGDTdoVFtKBuDAkXGMyvvUjRK2lrDjQW4nP9s+j7apzFkcLSKGa9ljo5hY3KdI9i+0G9ZL+69G1et2yTaRYcRbn7ln0x9hKv+y9WKKMkguyDI6xwdUa0ow3pMsYecCu0/tJLBm0LwdszaUl91QKPWXaMiePQzUCOOpAjGwvFfgTsyng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVjF1+RjAnffvnw7iAX0KyOJrk/f9r164jRnov3l7qE=;
 b=VhkQz3RBFMlzUu23aGim6qQ+1Qvg2+zAntWrY4gzHSKl411X8McH42CujWi1yhqa8vFGXMD7NSwonhsxf/gdRtQtZpsIK+Sy76w0wWNXUEPVZpcTfL7THNRDApbRcVxuPImFeXfgYsQFRSAkJx98qusqrjXcrfOjiwcvfVEFBRMPwJm0XDzk3aZdaOTc/oVo9tcZXBW94aYxe7I5SoVMgAgx33HwksDQ2N3OqxXQe44Vl9U8yXZBsnDCX7QIp7EdJORUEcJFN9UJEH1UQ3uVdLF8WS32D8zLK4J3ZnSLWfgDkL1b50bBdQ6KRecDv8wSR4t6R63DQXfVYWTFccSZDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVjF1+RjAnffvnw7iAX0KyOJrk/f9r164jRnov3l7qE=;
 b=o/az6rCpRFncgmJU72DSMMfe3XFHQwTa1hibmy4hVlatoV3bPrgWeTWk8PahQ/h+yNAN5tDestFOXrNGJnet5Lwramgpx7VU06PcRE4blUWjG6KyZCLzJBlo78VshHnQbXYbizglrb+u4iwWErUfBLBvzHQag0q5hvvUk3TAqYE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR10MB1774.namprd10.prod.outlook.com (2603:10b6:301:9::13)
 by MWHPR1001MB2157.namprd10.prod.outlook.com (2603:10b6:301:32::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.27; Fri, 19 Feb
 2021 16:13:19 +0000
Received: from MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183]) by MWHPR10MB1774.namprd10.prod.outlook.com
 ([fe80::24eb:1300:dd70:4183%3]) with mapi id 15.20.3846.042; Fri, 19 Feb 2021
 16:13:19 +0000
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v2 0/3] vfio/type1: Batch page pinning
Date:   Fri, 19 Feb 2021 11:13:02 -0500
Message-Id: <20210219161305.36522-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.30.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [98.229.125.203]
X-ClientProxiedBy: BL0PR0102CA0052.prod.exchangelabs.com
 (2603:10b6:208:25::29) To MWHPR10MB1774.namprd10.prod.outlook.com
 (2603:10b6:301:9::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (98.229.125.203) by BL0PR0102CA0052.prod.exchangelabs.com (2603:10b6:208:25::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend Transport; Fri, 19 Feb 2021 16:13:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e11312b1-1146-42ea-070d-08d8d4f145a9
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2157:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB215781D75E9EE81DAD4F3041D9849@MWHPR1001MB2157.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U3CttiRU4H6WM9KUzWCRZG4ljEz38tLIpavZ9WqCMjlJvL1GdLJoHBsZqNGn0OigXxkOW//wV/my4VsNuhZ8vae/gpVMwR1291tCT9C+nsOhW9crn44VY44vLQErkh/VNM32HHcCMRyL8ZTtmBnJsdxu5mf91GuE8AyAa2gJm/UPd6ruZsntvw0xkux2FUJpErVaaQoy0HzapwfpGpo57x/vG1wWVF/QLsNPO3T36nB1j9AQU1zBKOi9A4z1ZWsMi8CFuCpo2pNy8q8jIb0N1DThqwtYUBRWcvvHftXIBfZ9/jQW4S58ZDbuGqYqC7p06zVIerCdXhPvuf3yWkfkpRyyP1X3IQ9OG9DRBv2D/6q8Njt0WSZd3P+qp/EMTwaA35vV03zi/ysgWM20Fp5W0EMRBs1X46P/gWm2kDYts3nAEXq4zbvTWU6aZti06LaB7kkjPjz9aw0/dx8mFdEIoaHAmoB5+TmCUaaN0Nf1GpB8b96piFrxj57aliqEKXHPk57UQgZdFg+aRQU5bFJdtBoOXC2ejquswdB4uMOHnJ2AHKN5ERdXDh7LonqMthkR8MiTVDR210kB4FLTd+cRxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1774.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8936002)(107886003)(66946007)(1076003)(6486002)(6506007)(956004)(5660300002)(86362001)(83380400001)(8676002)(66556008)(54906003)(478600001)(103116003)(2616005)(110136005)(6666004)(69590400012)(2906002)(52116002)(26005)(186003)(36756003)(6512007)(66476007)(16526019)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7PrW7/G2xdlLBTUnbwTC+acsu/Dj4U4sAAu8gFE7A3Uj9s0pVj7h35H+jWrp?=
 =?us-ascii?Q?yn/Hyl3DJ4LA3ij6RJANnqEIFfnh2fSNNzNFkayPmicMdosZ5SNgP+ZKHwBf?=
 =?us-ascii?Q?Pf93HwkvOLA+ytbbdXhc9NViZP3GrxAEszKZl1zPgDhdhmsDygjyL8wY2ScH?=
 =?us-ascii?Q?wpqp+fZPR7U5f/PO7Yu/+Dm85Z9ejVO3AV6HrYRIm60vcjxkMt18jLvZFwg1?=
 =?us-ascii?Q?RJI1N6pXki3N6Xm6gE+b23T6a6hK1EUvmkgVuwshYEhzPst8Ev7/XnfsnoEf?=
 =?us-ascii?Q?BIq8LtY08cdN7nYemR5mnyt4s4bxesB0BW5LUHBpgQ6kXGXpDEFRelhK3p4+?=
 =?us-ascii?Q?fa5yBrtixOJAPBvl4wLVoVUlEP8Ica0VkywViWM8e5/J8YEuElHHrlm2Gq5n?=
 =?us-ascii?Q?wp+9UOEa0RisPApu2gLwhQbEKT53/fh2PJCF7mBv8Q/Ue1OuYhf7ARQ6++zl?=
 =?us-ascii?Q?idBk7+RxYwF0DXaYRcRZ3sBHO9l7dX4pp7KRY2PyOv/aur12aonbKl+S75OL?=
 =?us-ascii?Q?L1FhP+yf/DKZWoiW8UXdRNLhv9jcgo8gNuKucNaRR3QRtrjJyU850Dmeb5we?=
 =?us-ascii?Q?VYrkFfn+x/QnznWOeliIjMHEoffBui+mUyGTpuwMsPirhkPgpYjBP/8yAZwe?=
 =?us-ascii?Q?kQnVikFgUW1qymi4XMLnpIrgRPFhpFW3E35wyi/3gQSAOFH2r8Qm6F/dFBuD?=
 =?us-ascii?Q?/kV2shwiAvlDCQ8AfFOnOCzwnP+FYMhAwS1R1RxFJA092P9oEe5X7n/PIWR+?=
 =?us-ascii?Q?csi6KJRNvuDk9kihDCkXMKNgLRi67Z4zeIEt+nQGYqyQEl7yEcTbVMuaCGxu?=
 =?us-ascii?Q?1u2SLKITLrnC8wFq6rFDmxFe9DshCSVGbICgRU7jWfAYMgBSDpHeIdZ0iWhO?=
 =?us-ascii?Q?0Exvtqq+WyszoN3OrhW6P1Jh+OZ27tqlUIivEOOgNxnIQwNhlyFOS+v4DCkt?=
 =?us-ascii?Q?k3Bx5se+AKIKUoNrMd4nbacCHfjDVi3LLH+toj4lezaHKW9bUdnupwlf2LZW?=
 =?us-ascii?Q?E6rP7zekfXdMpPpj8teHDMdfGUh125Pd40gt2E73IHi/TOUbPlqBe3YTbsdC?=
 =?us-ascii?Q?dom0iH1yRFNF4IJNoKsD42hsOAhQ3gI4PVMypgaRDlikOIM1dUIVWffL3aG9?=
 =?us-ascii?Q?fxW1n1BhFU9G25vMBvCegWflnKgwiHY3Z3+Jxb0ucQnOYPULdkCux5hpKJNw?=
 =?us-ascii?Q?BeTecH1fadXRlBQbnnXxtjTjJhp8LrpXMXTK9b6gtvABvIvtQktonxkBsF2a?=
 =?us-ascii?Q?/HGOgl4+3V75OBP1XWqAU2HgCVIMWydsbUril7hfUR2JY0EtTJE+ls9l6ShS?=
 =?us-ascii?Q?BC2dtyzOzbUuhS2Q7BqzbfML?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e11312b1-1146-42ea-070d-08d8d4f145a9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1774.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 16:13:19.5816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ned8SBIbiHAp76DLCTpDA/4sQ+8JM0bVMIHUD+u8BGZCjq+ulmlqjxslql2eTECPxBQNcMc/1/Lo8HqNY0iaIxR5Se/6cho7njSsHxhX1k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2157
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190127
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190127
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
 - Fixed missing error unwind in patch 3 (Alex).  After more thought,
   the ENODEV case is fine, so it stayed the same.

 - Rebased on linux-vfio.git/next (no conflicts).

---

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

Daniel Jordan (3):
  vfio/type1: Change success value of vaddr_get_pfn()
  vfio/type1: Prepare for batched pinning with struct vfio_batch
  vfio/type1: Batch page pinning

 drivers/vfio/vfio_iommu_type1.c | 215 +++++++++++++++++++++++---------
 1 file changed, 155 insertions(+), 60 deletions(-)

base-commit: 76adb20f924f8d27ed50d02cd29cadedb59fd88f
-- 
2.30.1

