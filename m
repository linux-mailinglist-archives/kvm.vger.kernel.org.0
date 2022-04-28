Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD65E513D1D
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 23:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352077AbiD1VOd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 17:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352057AbiD1VOa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 17:14:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32387728F5
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 14:11:12 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SJhxBQ018608;
        Thu, 28 Apr 2022 21:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=zgIZjcA4iD6WN9W/kzOYtZ3hn3kNUgQYd9tt52kX++M=;
 b=iwWTmT9Wj/z0yRwcAglKCzLXpN1mIDAvrraraa3zx/CsMHwC6mXki9orCtJSIziOhr3m
 7ODNi41xwWm6saJgOzQpGQuinnOrDKLCzPaJWXgw2axKhKWNWpDhe57DBqF3TlH4zfNF
 sc5D88ab5jUqww99i7SzslEv25N8vjAQIPidtxLp8Zr38LUB/YZOklyM38uMtamS9GhG
 5pLqU+FYn/+/XMGWxWgbkdQQieap0nMYevvD9lMaAEl7P0YQNiJy9crZ1Nvb0vIl/J/n
 ZQuUSFufe8XxOvh/Wv00R+hsrcgAKo70QfmKbuYg2elhxZY54j0MDEV6o3SN2HgELRWz +g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb5k59fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:10:33 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23SL6d5F028734;
        Thu, 28 Apr 2022 21:10:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5ype8nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 21:10:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oQk1WNJSDBkzuxDm0HRGOuc6V3OPnXPKlqIPAqLnyZrBpQJEhaIWykHmOch6L7w0QKo0ktTi34Cq8teKs9f96vi0oN591j24VpgtqBhTvbTQTyWEYjOIIIt3KsYKokT0NA1Z5/kgiRdciroWeLJo7j2YTmveNvrCyu0wPnfVMVfUNVaWW1N0nih7lMthrLTHc80T+DSdytn43luNGL7ahspDRpR2AsLQrraPRF9FfILTmhU4CuYIbVBF6dDMGcn655wfWmWiteiGSu1L2mfyVnLASCxTK3Ajakfcw1VwXMtUyCrotZfoo57C77H3As76Eue61w8hpYSZ28ur26gK4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zgIZjcA4iD6WN9W/kzOYtZ3hn3kNUgQYd9tt52kX++M=;
 b=CXRBPQNZEGFgUn+2KQ5cXwaghPZBCfsS7+6GY+/O2PcqLMc91CyXaV92Y3o63kJsKafNcAseBYjYgtHaN7qKObyvn4cXGrgeJiehdm30RuM9fSfN1idPEU6I4tTOfoguykbCigO5elPm5YrEU3UScSWRPF8HTEzRpsR/3Znn44Tuv16JY3gwvG450KvcZ1sPelASCW+OKu2lTeru036L8OcolecyRupD3om91BJSI3Y6Kku+r2uFyENtcUmY6/4sd0jiO79yY2rG/LTy8sII8o2LKjV/oS4fZSsJ1iLxQD68/mkensC5ZT/ZJTeBALcKvmTIkUgxMHihJDkQgMaNzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgIZjcA4iD6WN9W/kzOYtZ3hn3kNUgQYd9tt52kX++M=;
 b=Uw0w3djnmCtB6lVpJXkBngtZUKoj+HFYZ+RW9S42dcekTsSY9dqi62DrhhPibmZenWXMFIfqKtuDA2sOxB9xs22/kq5roDpNTv2yMqOZ1yoY7RvxnHAV//Vkkz4/Yr5Ufjh4TBn/S1FhWJwpQRdbdHUNKP1gqsMOaLZQPLgxWAw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1564.namprd10.prod.outlook.com (2603:10b6:3:9::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Thu, 28 Apr 2022 21:10:29 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Thu, 28 Apr 2022
 21:10:29 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux-foundation.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Date:   Thu, 28 Apr 2022 22:09:14 +0100
Message-Id: <20220428210933.3583-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c994a7b-6b1b-487d-0506-08da295b8610
X-MS-TrafficTypeDiagnostic: DM5PR10MB1564:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB15643C7CBE05B253527F6564BBFD9@DM5PR10MB1564.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZI2sMhX9y7xHkczx+X0T5+Xbx304uZyho6HIrokE6hEJxBOTStV9M8kqL/coHgvL6X8NI86FBE3nUoBfpQ4R3Hy0WYiywL6s4F7ZxvWec9dITFSvjSblRAGjcpVDOkmnaS1Tjefz3HW0OB0aM3+yV1rAM2SEwHdUu82C8zPVBRwuev9kD6s3sEuyv8F3YbzuXxcrjqldmmLsNjXXrRiOheD7bS3eUoAUunjTR4XvGefTzbfq4MYtQKRrpUV7Yo50H/npIAEV6/LSolEUhdD51S0rFTqZvxekSYOWyv45ON82rSq3ix0oZQuDtqJePj4fnshbwqQ8jGXy49pTyN8GeGIW+gWEeif9wnla9K9QK5Jlgib/9BFmV9d1zZfCZHj6RKBAail3aNM1tZ0EO72Xz4PF5EIDGV7rscUaRV/QyduO0oiomMZHw8BgVx4ULXfXWXjJMdsrHlyGougodqMGgobdV46CKjkrFpPM4hMDdKF7At0sPSm3muqMNQlhjpLXPW1CZzZgBJq/F/N3j1IuoYZSyA3oRI1uIysZRh/qiZgcEzjxgIpa81Iyivfk/Eu1RUDGnu/VFRomS+6zDwdoOHnL2qtKroOIVl562lQJo3K+FNi3quGaUAjp6exOxfWoqBIkklxd+GrjPWA7cH/rj6NvU+/VQasCPY6nhQ2ZowRXxsGhyOOa0Vs37VkYD4vFjrqg0ByWIZD43+6bjA7pbZfETKIwDAI+6VwdZ17qbfVGJ1XPGutJut9wNqwsEfR2fcZl00tD25qkyMPW9fWs9TFV9xIt2ALBmQaB7fKNyatfA5+yWhVX2PpJUZKKGUV7t7xQBrMr+OZDwLzwYVFDVMMIRtQSsCit4UjjbSh8SB8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(186003)(86362001)(66946007)(66556008)(4326008)(66476007)(8676002)(2616005)(36756003)(1076003)(103116003)(8936002)(5660300002)(7416002)(30864003)(26005)(6512007)(6486002)(6916009)(966005)(83380400001)(54906003)(508600001)(6506007)(38350700002)(38100700002)(6666004)(2906002)(52116002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I5/2fL/V3x1egTp+6ntBbsHX9YcrZc8jsp8sGDSU83IXC+1/GlvDjqLUxT/u?=
 =?us-ascii?Q?QIV4T5ZC4Z3MY3sgV+irJiztMK5pTYhMKwkEtEQ3/qgIOB7R7QE0pA5qczGJ?=
 =?us-ascii?Q?UoMMLoew6ycdeC6Sv/bRIBkB4T3+DqQEw3L9d1zgx1DLEtbEv6Q4VQpjmt6k?=
 =?us-ascii?Q?9BjDHCuGT8FeV23fIjYSphgTKR9YYQgyiUmVPTwM/15floVUc8nfn+hHkZ3e?=
 =?us-ascii?Q?3BAqOwcnUeZKzuxM65Roy8fsf7vdy6ecQDM+CTVsl38pAZpC4hu1+fhWeyMh?=
 =?us-ascii?Q?fYxFHlRnBnr/qv4ok/Enud2U/Eel5/Yl5hb21551iSHd7ky32pYdQtEG4pbw?=
 =?us-ascii?Q?SmELt6QRserOtJZxyDFCYD3gmZ/HEsul/FE3sQV9eDjLgxUNY89T3bJ/lwqN?=
 =?us-ascii?Q?H+YAtNDJHRdeH2Cpy/EsatP5p3pBHSdxxcAYazuKp8I3tjtvq1k0ltsI0frW?=
 =?us-ascii?Q?yMf8hp+EBMedcZ+6fQZu13qqeui6sWfzxFou5b/TV4j2ZB5atmor5rYf1uU4?=
 =?us-ascii?Q?R8skcA6e/HNc6DtA8FKQHRxHvQg+vRH4QGh8GDqD1OukwSisn9W/PJ1Zgpr1?=
 =?us-ascii?Q?awrrIxbsS3CGOfMieyzlGpcGSF46V9fTCp+eUbYW/oKnl5IU7ioKRaHU2eOl?=
 =?us-ascii?Q?YLZfs9CeOljdx2CUCy561M/5JjWbUIgreItlb+v8S0CMq4UtkUcM253INFXB?=
 =?us-ascii?Q?9tYwPUm0wNlykJUVGfIt8FX9p6KOWTmG6Y3xAOcten/PI7xamvV2qBaOJU7+?=
 =?us-ascii?Q?TzzjFCT/OJwiG5U5YfNCIY4w6cdSxl38p2BVR6hGH0tBrEvV+lhW08alVvCQ?=
 =?us-ascii?Q?4UsnECgAugeYkPDEXi9G3+VefFNStjEmdZuzNFJPNTmjy+vKmmVFLVOhyGP3?=
 =?us-ascii?Q?xWS6Wb4Z3F1KEY7+xmXMrYOtt7MJd3KP9JetyUEdpD8g//1vvmafqs/dkFWW?=
 =?us-ascii?Q?TSmGMN7NnkvOoyts100wEpggYNITD00zPPvwxMgx2gCHSrZm5jynamRrJeoO?=
 =?us-ascii?Q?trrsXkQHU0QWki6Y5N+jIXmjCC1GL9sHAu/fpPdtLHhu0mHgS2EYG7ijsbno?=
 =?us-ascii?Q?P8MuiRSN76BVlwYQtskGCsZtdhsDmSEO8jSSogXNiF542/AfzGW7zBA+FuK0?=
 =?us-ascii?Q?QjGevGjk6ynqJzTDl8UIX7lAjnL3rneEdhsorqVepewrbtQVtt+OBzBkolF4?=
 =?us-ascii?Q?Knh9uarnPv9mxXs00G1qBqQkKIdN1vKVl3HKW1D0scWviVOTPghyHWX1xpfl?=
 =?us-ascii?Q?0JWPXNgDgw1Ze8XScraCslkfVDTBgxV0JDgglLjqVgmlme7of7wifFTzYrbf?=
 =?us-ascii?Q?kQ3eNRSVdJk2chlJXShDs+7/F4ogJMuGg89dwPs/lvqirfMAax4E39DnpnGx?=
 =?us-ascii?Q?ogEOQSlSD3CWjQHjyvYz/gA3oxe2G8Ud8HiF9TGGMQqJgSGfHPuHuiaaEDDR?=
 =?us-ascii?Q?on+8d0oBIUp7bTs88q5sfcfyB87qgu4+L0Dhz8gwZG1z9JWmB0kZZ7pVDfXU?=
 =?us-ascii?Q?yd7gVjVIkq/cB3sGBgp/4GchbXuy4oBV80yD7W3TlX4nzUksR9zG3wBkgvRi?=
 =?us-ascii?Q?7or3TsTcikITGevQFttH74ctRFtqGHvskPMH1jjvzt8gbvmaPKAbUhr/IsNh?=
 =?us-ascii?Q?N2tidyByRugriScKbFP3vf23FOjmah9HPOJJeaFkNWMe31Toxdef2RZtpaiA?=
 =?us-ascii?Q?tHDi14CkZSVqeM4hvf/HxTVka0y2uRbt0RiDv3HAYMAiHaQRONkZ6nq7HNYr?=
 =?us-ascii?Q?s90/uc987HnjTvrnhdpWdhKcUO8SDvY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c994a7b-6b1b-487d-0506-08da295b8610
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 21:10:29.7430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: puPDTHwMNl/DHdMJ+soZRx4zNqRJUJA2qAZKqBN9E/ri+gjim4bk8Cen4Qbr2WPmhIuBgd5/Wm8MIjObOJswPtlFZx3bnViBKeQZu+Kmxaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-28_04:2022-04-28,2022-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280125
X-Proofpoint-GUID: Y7VCf5AtqsgDpWafQAIaUX7FGzCBlSiW
X-Proofpoint-ORIG-GUID: Y7VCf5AtqsgDpWafQAIaUX7FGzCBlSiW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Presented herewith is a series that extends IOMMUFD to have IOMMU
hardware support for dirty bit in the IOPTEs.

Today, AMD Milan (which been out for a year now) supports it while ARM
SMMUv3.2+ alongside VT-D rev3.x are expected to eventually come along.
The intended use-case is to support Live Migration with SR-IOV, with IOMMUs
that support it. Yishai Hadas will be soon submiting an RFC that covers the
PCI device dirty tracker via vfio.

At a quick glance, IOMMUFD lets the userspace VMM create the IOAS with a
set of a IOVA ranges mapped to some physical memory composing an IO
pagetable. This is then attached to a particular device, consequently
creating the protection domain to share a common IO page table
representing the endporint DMA-addressable guest address space.
(Hopefully I am not twisting the terminology here) The resultant object
is an hw_pagetable object which represents the iommu_domain
object that will be directly manipulated. For more background on
IOMMUFD have a look at these two series[0][1] on the kernel and qemu
consumption respectivally. The IOMMUFD UAPI, kAPI and the iommu core
kAPI is then extended to provide:

 1) Enabling or disabling dirty tracking on the iommu_domain. Model
as the most common case of changing hardware protection domain control
bits, and ARM specific case of having to enable the per-PTE DBM control
bit. The 'real' tracking of whether dirty tracking is enabled or not is
stored in the vendor IOMMU, hence no new fields are added to iommufd
pagetable structures.

 2) Read the I/O PTEs and marshal its dirtyiness into a bitmap. The bitmap
thus describe the IOVAs that got written by the device. While performing
the marshalling also vendors need to clear the dirty bits from IOPTE and
allow the kAPI caller to batch the much needed IOTLB flush.
There's no copy of bitmaps to userspace backed memory, all is zerocopy
based. So far this is a test-and-clear kind of interface given that the
IOPT walk is going to be expensive. It occured to me to separate
the readout of dirty, and the clearing of dirty from IOPTEs.
I haven't opted for that one, given that it would mean two lenghty IOPTE
walks and felt counter-performant.

 3) Unmapping an IOVA range while returning its dirty bit prior to
unmap. This case is specific for non-nested vIOMMU case where an
erronous guest (or device) DMAing to an address being unmapped at the
same time.

[See at the end too, on general remarks, specifically the one regarding
 probing dirty tracking via a dedicated iommufd cap ioctl]

The series is organized as follows:

* Patches 1-3: Takes care of the iommu domain operations to be added and
extends iommufd io-pagetable to set/clear dirty tracking, as well as
reading the dirty bits from the vendor pagetables. The idea is to abstract
iommu vendors from any idea of how bitmaps are stored or propagated back to
the caller, as well as allowing control/batching over IOTLB flush. So
there's a data structure and an helper that only tells the upper layer that
an IOVA range got dirty. IOMMUFD carries the logic to pin pages, walking
the bitmap user memory, and kmap-ing them as needed. IOMMU vendor just has
an idea of a 'dirty bitmap state' and recording an IOVA as dirty by the
vendor IOMMU implementor.

* Patches 4-5: Adds the new unmap domain op that returns whether the IOVA
got dirtied. I separated this from the rest of the set, as I am still
questioning the need for this API and whether this race needs to be
fundamentally be handled. I guess the thinking is that live-migration
should be guest foolproof, but how much the race happens in pratice to
deem this as a necessary unmap variant. Perhaps maybe it might be enough
fetching dirty bits prior to the unmap? Feedback appreciated.

* Patches 6-8: Adds the UAPIs for IOMMUFD, vfio-compat and selftests.
We should discuss whether to include the vfio-compat or not. Given how
vfio-type1-iommu perpectually dirties any IOVA, and here I am replacing
with the IOMMU hw support. I haven't implemented the perpectual dirtying
given his lack of usefullness over an IOMMU-backed implementation (or so
I think). The selftests, test mainly the principal workflow, still needs
to get added more corner cases.

Note: Given that there's no capability for new APIs, or page sizes or
etc, the userspace app using IOMMUFD native API would gather -EOPNOTSUPP
when dirty tracking is not supported by the IOMMU hardware.

For completeness and most importantly to make sure the new IOMMU core ops
capture the hardware blocks, all the IOMMUs that will eventually get IOMMU A/D
support were implemented. So the next half of the series presents *proof of
concept* implementations for IOMMUs:

* Patches 9-11: AMD IOMMU implementation, particularly on those having
HDSup support. Tested with a Qemu amd-iommu with HDSUp emulated,
and also on a AMD Milan server IOMMU.

* Patches 12-17: Adapts the past series from Keqian Zhu[2] but reworked
to do the dynamic set/clear dirty tracking, and immplicitly clearing
dirty bits on the readout. Given the lack of hardware and difficulty
to get this in an emulated SMMUv3 (given the dependency on the PE HTTU
and BBML2, IIUC) then this is only compiled tested. Hopefully I am not
getting the attribution wrong.

* Patches 18-19: Intel IOMMU rev3.x implementation. Tested with a Qemu
based intel-iommu with SSADS/SLADS emulation support.

To help testing/prototypization, qemu iommu emulation bits were written
to increase coverage of this code and hopefully make this more broadly
available for fellow contributors/devs. A separate series is submitted right
after this covering the Qemu IOMMUFD extensions for dirty tracking, alongside
its x86 iommus emulation A/D bits. Meanwhile it's also on github
(https://github.com/jpemartins/qemu/commits/iommufd)

Remarks / Observations:

* There's no capabilities API in IOMMUFD, and in this RFC each vendor tracks
what has access in each of the newly added ops. Initially I was thinking to
have a HWPT_GET_DIRTY to probe how dirty tracking is supported (rather than
bailing out with EOPNOTSUP) as well as an get_dirty_tracking
iommu-core API. On the UAPI, perhaps it might be better to have a single API
for capabilities in general (similar to KVM)  and at the simplest is a subop
where the necessary info is conveyed on a per-subop basis?

* The UAPI/kAPI could be generalized over the next iteration to also cover
Access bit (or Intel's Extended Access bit that tracks non-CPU usage).
It wasn't done, as I was not aware of a use-case. I am wondering
if the access-bits could be used to do some form of zero page detection
(to just send the pages that got touched), although dirty-bits could be
used just the same way. Happy to adjust for RFCv2. The algorithms, IOPTE
walk and marshalling into bitmaps as well as the necessary IOTLB flush
batching are all the same. The focus is on dirty bit given that the
dirtyness IOVA feedback is used to select the pages that need to be transfered
to the destination while migration is happening.
Sidebar: Sadly, there's a lot less clever possible tricks that can be
done (compared to the CPU/KVM) without having the PCI device cooperate (like
userfaultfd, wrprotect, etc as those would turn into nepharious IOMMU
perm faults and devices with DMA target aborts).
If folks thing the UAPI/iommu-kAPI should be agnostic to any PTE A/D
bits, we can instead have the ioctls be named after
HWPT_SET_TRACKING() and add another argument which asks which bits to
enabling tracking (IOMMUFD_ACCESS/IOMMUFD_DIRTY/IOMMUFD_ACCESS_NONCPU).
Likewise for the read_and_clear() as all PTE bits follow the same logic
as dirty. Happy to readjust if folks think it is worthwhile.

* IOMMU Nesting /shouldn't/ matter in this work, as it is expected that we
only care about the first stage of IOMMU pagetables for hypervisors i.e.
tracking dirty GPAs (and not caring about dirty GIOVAs).

* Dirty bit tracking only, is not enough. Large IO pages tend to be the norm
when DMA mapping large ranges of IOVA space, when really the VMM wants the
smallest granularity possible to track(i.e. host base pages). A separate bit
of work will need to take care demoting IOPTE page sizes at guest-runtime to
increase/decrease the dirty tracking granularity, likely under the form of a
IOAS demote/promote page-size within a previously mapped IOVA range.

Feedback is very much appreciated!

[0] https://lore.kernel.org/kvm/0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com/
[1] https://lore.kernel.org/kvm/20220414104710.28534-1-yi.l.liu@intel.com/
[2] https://lore.kernel.org/linux-arm-kernel/20210413085457.25400-1-zhukeqian1@huawei.com/

	Joao

TODOs:
* More selftests for large/small iopte sizes;
* Better vIOMMU+VFIO testing (AMD doesn't support it);
* Performance efficiency of GET_DIRTY_IOVA in various workloads;
* Testing with a live migrateable VF;

Jean-Philippe Brucker (1):
  iommu/arm-smmu-v3: Add feature detection for HTTU

Joao Martins (16):
  iommu: Add iommu_domain ops for dirty tracking
  iommufd: Dirty tracking for io_pagetable
  iommufd: Dirty tracking data support
  iommu: Add an unmap API that returns dirtied IOPTEs
  iommufd: Add a dirty bitmap to iopt_unmap_iova()
  iommufd: Dirty tracking IOCTLs for the hw_pagetable
  iommufd/vfio-compat: Dirty tracking IOCTLs compatibility
  iommufd: Add a test for dirty tracking ioctls
  iommu/amd: Access/Dirty bit support in IOPTEs
  iommu/amd: Add unmap_read_dirty() support
  iommu/amd: Print access/dirty bits if supported
  iommu/arm-smmu-v3: Add read_and_clear_dirty() support
  iommu/arm-smmu-v3: Add set_dirty_tracking_range() support
  iommu/arm-smmu-v3: Add unmap_read_dirty() support
  iommu/intel: Access/Dirty bit support for SL domains
  iommu/intel: Add unmap_read_dirty() support

Kunkun Jiang (2):
  iommu/arm-smmu-v3: Add feature detection for BBML
  iommu/arm-smmu-v3: Enable HTTU for stage1 with io-pgtable mapping

 drivers/iommu/amd/amd_iommu.h               |   1 +
 drivers/iommu/amd/amd_iommu_types.h         |  11 +
 drivers/iommu/amd/init.c                    |  12 +-
 drivers/iommu/amd/io_pgtable.c              | 100 +++++++-
 drivers/iommu/amd/iommu.c                   |  99 ++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 135 +++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  14 ++
 drivers/iommu/intel/iommu.c                 | 152 +++++++++++-
 drivers/iommu/intel/pasid.c                 |  76 ++++++
 drivers/iommu/intel/pasid.h                 |   7 +
 drivers/iommu/io-pgtable-arm.c              | 232 ++++++++++++++++--
 drivers/iommu/iommu.c                       |  71 +++++-
 drivers/iommu/iommufd/hw_pagetable.c        |  79 ++++++
 drivers/iommu/iommufd/io_pagetable.c        | 253 +++++++++++++++++++-
 drivers/iommu/iommufd/io_pagetable.h        |   3 +-
 drivers/iommu/iommufd/ioas.c                |  35 ++-
 drivers/iommu/iommufd/iommufd_private.h     |  59 ++++-
 drivers/iommu/iommufd/iommufd_test.h        |   9 +
 drivers/iommu/iommufd/main.c                |   9 +
 drivers/iommu/iommufd/pages.c               |  79 +++++-
 drivers/iommu/iommufd/selftest.c            | 137 ++++++++++-
 drivers/iommu/iommufd/vfio_compat.c         | 221 ++++++++++++++++-
 include/linux/intel-iommu.h                 |  30 +++
 include/linux/io-pgtable.h                  |  20 ++
 include/linux/iommu.h                       |  64 +++++
 include/uapi/linux/iommufd.h                |  78 ++++++
 tools/testing/selftests/iommu/Makefile      |   1 +
 tools/testing/selftests/iommu/iommufd.c     | 135 +++++++++++
 28 files changed, 2047 insertions(+), 75 deletions(-)

-- 
2.17.2

