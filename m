Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C584B4DDFE6
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239621AbiCRR3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239616AbiCRR3D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:29:03 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CCF1D7619
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 10:27:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQlHTa1uNmYZOrgM4tLtS99m0ZYJOxNpiBZl8WwApGaxgHTTZUl9ZT8vF2FemRIZ9+vkGBJzVA+PaTsDx/kqOgYPBAri7xfKl4oYPL5Idap8w0yRNQsetV00mgSMX3G8zOZvpE61apxDlD+HxHtR8NoTWUB7VSetXjENthUhpVTXt5RKSCyeBtD0fQ0E6AnBK3yhxUp0G/5WmomTamowChyfHwyKo/gD7p6FzYt/7INHXYT8TErYItMLQcjB37ZQre2WkawewjJh5OX5yCTXBqjY4fmGX45OI5KuPqU4INtK4p7H02oluSG5CxSN+OIUylaRMCxhUGghwd6EVdVfWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jIGG5BLcvrDLQ3Q9nAcyh2iHW915UQaHOMPiT4zJJzk=;
 b=lgqJnf6p3aVWo++6YFc9iot98mTGsJnS5a7+yhikppBZvgHFbPqWab6LEUjvj3JWqc5z2zV5vCv6ZXITfBhoGU4sq1MvnNJlYbxgQYiwyz7wIlGas1RFL8cQCdHdOEyGTJKApBVDROmMAkqFI+0MliPAO6wFrD5ClbvAIIsfet4vyGG/KaP/+hP/tEnGn3K9Gfskh9DdAfeNfHp5NRcg570uF9aI3yNCpARSTKucpG1nQVvgO0CwxjEVIbXgcSpOfDT/61RqDCv+heyNusKfLn7oe+pY0H9W9uwMac9iCZt+Z0jH/wfffaqmw/zCKWx7h8V3bGSAxHrXlgCk+ccxAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIGG5BLcvrDLQ3Q9nAcyh2iHW915UQaHOMPiT4zJJzk=;
 b=n0J3rpbJR0b0agEtWFMa0154FavfdytnkHcADWr3wuSlbYICw2eo4+qNHZSdCQ5sFYcTVUe48l+TmT/jCvsN8FOLc9SD+4WWxbTaC0SoKfoMF1fN6L0ddP0C4Kn2YrbvP0eu3UGC9l+t9WwnIiVSF81BKDHKG8UD4u583kIdWhXBRn07gf92oXLSbO7SgVLTjghIGbZ9OMwaFVsqt5HDR+Xqi86ArejYFbjfdEv3KgnietkOwa9V3ZL+KhGYsEfrOY4EECoNnIseaH9G3aSk+rCCAM47XdIeeKsv/X4qF2pGEPgv8iWi+Fo+CZTz0jZX1PfjYZD/Q4UGtp/sS7t+lQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3630.namprd12.prod.outlook.com (2603:10b6:208:cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Fri, 18 Mar
 2022 17:27:39 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 17:27:39 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH RFC 02/12] iommufd: Overview documentation
Date:   Fri, 18 Mar 2022 14:27:27 -0300
Message-Id: <2-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0220.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffba083b-65ee-46d6-d2e7-08da0904999e
X-MS-TrafficTypeDiagnostic: MN2PR12MB3630:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3630553FE8436E43568DD95FC2139@MN2PR12MB3630.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xD81PL0OgG+cQhJXaXdLL3lXI0jeQjFHJ5oAppBafE+nPM5IPKNQf1QYPKymuFcXQhNKEClqkAsIoJmEDq5ig6okhX90WTJsAdw1yBwfzv1LJfjIyRRwXb+aXrnEqip4BJ8jaPHEp9nRrsCI8DK6Hwi6Wwj3BOVWdZTwfjkYRSi6buaMwvJowpoAZ9cvxYZDPEFuSyZF5pT/CM6Z2tmsEm2gs0iFDL7ch9FlezpLZ3THC6u0ZhJej2nnkbGKL5L6dMmT31DjWF1EP4hnhqznXXliioo/RUDPwG1/tOW9TyN8uwGyC5gDHf0kRiDxauJHguTpY6L5YpZTuV7kyhE6wrRRjhBrQpQkQuaWvOYoSb5ClfAYuets33m/DmpJf9BP4315GOXop0u02ebVttrcejUfdQ3F/tmcIWpSY2i6KxGnk2cyu9AYK1epCUPIwk/PI8iBdidFiJ3qdV2rmFYkHq6Rj156XNyG3pFQ+TB3VFCRyYvMrpY8B8BroGkqMaaZgUtlQpck2q8gRPy/xB7a3qk+u9bV56vQprtBWPc2kJMAi4bmQC1Zb7pzlmuajrykz+DKvzp3/H95VQaWFO5tTVS2BQoehgBU3QOafdf/Kntw/GD3rWub1YjHmOEuaEBXBbZio7Rsqj3x3Ku2V13eVPrJc0fz9ftq+37QYDoWQmeFfdeSyJ+Uy3oT7WI6/szrrakBBNBZzlzg0zV5alnShw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(508600001)(186003)(6666004)(8676002)(4326008)(8936002)(6486002)(83380400001)(7416002)(66946007)(5660300002)(66476007)(66556008)(6512007)(109986005)(54906003)(2906002)(316002)(38100700002)(6506007)(2616005)(36756003)(86362001)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?faWJOWldlKxztok7y4MjKg4fSyyf+vf/fPqlkiTq5PK6JBteeWoGKMkzryHW?=
 =?us-ascii?Q?T0bX7MaE36qiNe3KeREHkiuf01YPezzaBRDPUrov/NBxYvnUTqb3fiWvgKyu?=
 =?us-ascii?Q?JuAEY4zcoJZQPUQiXLn5+V34jZ3JT1paDhav6M1MRUzh71ddD3JgOIOW6uKT?=
 =?us-ascii?Q?2JQq/7/B0CUSP4ti5Bc8RxXRv8Ru9/jQfpAmE/5Ia4Oa7LOLkPc1LvsqNIm/?=
 =?us-ascii?Q?95aivST4lyGu8Bw3Pr6k6HbORrwuX4enWaOm98olDpGYN8CH/cNYLCeV8Zrj?=
 =?us-ascii?Q?OGhHHmeECNvZytTOiDr0/zNwd0qULeiY4oohOiagIPH51/vAPW5fsPwUazs5?=
 =?us-ascii?Q?FcQnMh+xMGBJubNaytinfY4CCd3FbnPAEfoaauxjBzwLdlZRn9GA0CffsYO5?=
 =?us-ascii?Q?cx1O86YCCiOhBK7GYoejMD8ZgRfeVV1FQSRx6RqPu+QGwVOYMJpLZmwQ6RS9?=
 =?us-ascii?Q?vp+9PGQ3c7MJthVZ3A2QHhBEAn2vHwx//0cVHQQ2TeVAXgC7tr3bXnUXQypV?=
 =?us-ascii?Q?p7lWem/rF0AxojjHu0RJDRzPBaMjtEbdf9u8bQd6+E2SzFcRwgDmguGXCFuk?=
 =?us-ascii?Q?ubyn6NUhale+KKCxKH1InIr7jlZltK+Plu8VJb6AsyfxutDRofV3kKuq7Wp2?=
 =?us-ascii?Q?r0lvKPXGoOlEgdMcMM8tMFkfhDVteqv9VX2/q0915tgsyNbJWyhYY0pz/tOb?=
 =?us-ascii?Q?FWY/Ozve7X/9yKsjMMiF5ze9sjF+8I9V7P/WU1+RwPptWRepq2kdikSdHhyy?=
 =?us-ascii?Q?vVsN83ARyyd3J3EAVkL9ji1lfnmAlATcu1C+rK7Qz7bvGf6jWM96jAp3jmgv?=
 =?us-ascii?Q?jcHwdU7VcXViNZ7i6VGmcuf6g/AtB7oEzzHm+FBz++wwcBghQUklpD0T4dJh?=
 =?us-ascii?Q?ElduOUyBPCMAx4JyKsc2T8SBqFnKvlPmvcvFVeUqZANEn6vmfCS+4xrSbUFE?=
 =?us-ascii?Q?T9FSRhnSs9NtHywq2Mz566jTqmBiss8TOpb4xKJaNbAZRSXjv9doVmkWNRxM?=
 =?us-ascii?Q?xpNsuW/t0aKz9qT+vQpu8JNgELHtUuFr1cUYJIijtu/IBYCxMWfEPcbOZ8DQ?=
 =?us-ascii?Q?y4IPBkrvP+GEUXDJpZ5xMjb0sEU2HJaDhzGQooreTycpu0V0n4Jqtv62MhhQ?=
 =?us-ascii?Q?m4UorGoSKYkC9B1mA8hVUKXXVVgIWqErZCEc7SOTEl3sLuMKXx0+znXugckn?=
 =?us-ascii?Q?hW87MT9MUCGZOLV+NBV4rwyoevH1KELZh1TIXKof3VE1fmIdJBp+4Kfa3lLg?=
 =?us-ascii?Q?QFuwG1fUDjOoghtQ0cx2KMFNU4cW51VdY3Bc3VRlP0SgjhYzmmzG9Dy9thLR?=
 =?us-ascii?Q?6WZZxeYIMSfOvWoKJXnAt9LtDeoeOFIABJQlzb0p1rxKF8VlGugzw3GOwZZU?=
 =?us-ascii?Q?zXWTd/AqrxJVkRu13JDAxFJuVFP9KB4f3+dw9ozs22oJ3FJgagCowlffpeMe?=
 =?us-ascii?Q?zhRhTLgMLYH9wWBzLvfHGzajuor7Q/xG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffba083b-65ee-46d6-d2e7-08da0904999e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 17:27:39.0063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v3eMAEAVu/sphERuecjPjOxKQHYM5jnxPZgJBQ/5vJt82pKWWTAf0Tgkq9uCOtp1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3630
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kevin Tian <kevin.tian@intel.com>

Add iommufd to the documentation tree.

Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/userspace-api/index.rst   |   1 +
 Documentation/userspace-api/iommufd.rst | 224 ++++++++++++++++++++++++
 2 files changed, 225 insertions(+)
 create mode 100644 Documentation/userspace-api/iommufd.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index a61eac0c73f825..3815f013e4aebd 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -25,6 +25,7 @@ place where this information is gathered.
    ebpf/index
    ioctl/index
    iommu
+   iommufd
    media/index
    sysfs-platform_profile
    vduse
diff --git a/Documentation/userspace-api/iommufd.rst b/Documentation/userspace-api/iommufd.rst
new file mode 100644
index 00000000000000..38035b3822fd23
--- /dev/null
+++ b/Documentation/userspace-api/iommufd.rst
@@ -0,0 +1,224 @@
+.. SPDX-License-Identifier: GPL-2.0+
+
+=======
+IOMMUFD
+=======
+
+:Author: Jason Gunthorpe
+:Author: Kevin Tian
+
+Overview
+========
+
+IOMMUFD is the user API to control the IOMMU subsystem as it relates to managing
+IO page tables that point at user space memory. It intends to be general and
+consumable by any driver that wants to DMA to userspace. Those drivers are
+expected to deprecate any proprietary IOMMU logic, if existing (e.g.
+vfio_iommu_type1.c).
+
+At minimum iommufd provides a universal support of managing I/O address spaces
+and I/O page tables for all IOMMUs, with room in the design to add non-generic
+features to cater to specific hardware functionality.
+
+In this context the capital letter (IOMMUFD) refers to the subsystem while the
+small letter (iommufd) refers to the file descriptors created via /dev/iommu to
+run the user API over.
+
+Key Concepts
+============
+
+User Visible Objects
+--------------------
+
+Following IOMMUFD objects are exposed to userspace:
+
+- IOMMUFD_OBJ_IOAS, representing an I/O address space (IOAS) allowing map/unmap
+  of user space memory into ranges of I/O Virtual Address (IOVA).
+
+  The IOAS is a functional replacement for the VFIO container, and like the VFIO
+  container copies its IOVA map to a list of iommu_domains held within it.
+
+- IOMMUFD_OBJ_DEVICE, representing a device that is bound to iommufd by an
+  external driver.
+
+- IOMMUFD_OBJ_HW_PAGETABLE, wrapping an actual hardware I/O page table (i.e. a
+  single struct iommu_domain) managed by the iommu driver.
+
+  The IOAS has a list of HW_PAGETABLES that share the same IOVA mapping and the
+  IOAS will synchronize its mapping with each member HW_PAGETABLE.
+
+All user-visible objects are destroyed via the IOMMU_DESTROY uAPI.
+
+Linkage between user-visible objects and external kernel datastructures are
+reflected by dotted line arrows below, with numbers referring to certain
+operations creating the objects and links::
+
+  _________________________________________________________
+ |                         iommufd                         |
+ |       [1]                                               |
+ |  _________________                                      |
+ | |                 |                                     |
+ | |                 |                                     |
+ | |                 |                                     |
+ | |                 |                                     |
+ | |                 |                                     |
+ | |                 |                                     |
+ | |                 |        [3]                 [2]      |
+ | |                 |    ____________         __________  |
+ | |      IOAS       |<--|            |<------|          | |
+ | |                 |   |HW_PAGETABLE|       |  DEVICE  | |
+ | |                 |   |____________|       |__________| |
+ | |                 |         |                   |       |
+ | |                 |         |                   |       |
+ | |                 |         |                   |       |
+ | |                 |         |                   |       |
+ | |                 |         |                   |       |
+ | |_________________|         |                   |       |
+ |         |                   |                   |       |
+ |_________|___________________|___________________|_______|
+           |                   |                   |
+           |              _____v______      _______v_____
+           | PFN storage |            |    |             |
+           |------------>|iommu_domain|    |struct device|
+                         |____________|    |_____________|
+
+1. IOMMUFD_OBJ_IOAS is created via the IOMMU_IOAS_ALLOC uAPI. One iommufd can
+   hold multiple IOAS objects. IOAS is the most generic object and does not
+   expose interfaces that are specific to single IOMMU drivers. All operations
+   on the IOAS must operate equally on each of the iommu_domains that are inside
+   it.
+
+2. IOMMUFD_OBJ_DEVICE is created when an external driver calls the IOMMUFD kAPI
+   to bind a device to an iommufd. The external driver is expected to implement
+   proper uAPI for userspace to initiate the binding operation. Successful
+   completion of this operation establishes the desired DMA ownership over the
+   device. The external driver must set driver_managed_dma flag and must not
+   touch the device until this operation succeeds.
+
+3. IOMMUFD_OBJ_HW_PAGETABLE is created when an external driver calls the IOMMUFD
+   kAPI to attach a bound device to an IOAS. Similarly the external driver uAPI
+   allows userspace to initiate the attaching operation. If a compatible
+   pagetable already exists then it is reused for the attachment. Otherwise a
+   new pagetable object (and a new iommu_domain) is created. Successful
+   completion of this operation sets up the linkages among an IOAS, a device and
+   an iommu_domain. Once this completes the device could do DMA.
+
+   Every iommu_domain inside the IOAS is also represented to userspace as a
+   HW_PAGETABLE object.
+
+   NOTE: Future additions to IOMMUFD will provide an API to create and
+   manipulate the HW_PAGETABLE directly.
+
+One device can only bind to one iommufd (due to DMA ownership claim) and attach
+to at most one IOAS object (no support of PASID yet).
+
+Currently only PCI device is allowed.
+
+Kernel Datastructure
+--------------------
+
+User visible objects are backed by following datastructures:
+
+- iommufd_ioas for IOMMUFD_OBJ_IOAS.
+- iommufd_device for IOMMUFD_OBJ_DEVICE.
+- iommufd_hw_pagetable for IOMMUFD_OBJ_HW_PAGETABLE.
+
+Several terminologies when looking at these datastructures:
+
+- Automatic domain, referring to an iommu domain created automatically when
+  attaching a device to an IOAS object. This is compatible to the semantics of
+  VFIO type1.
+
+- Manual domain, referring to an iommu domain designated by the user as the
+  target pagetable to be attached to by a device. Though currently no user API
+  for userspace to directly create such domain, the datastructure and algorithms
+  are ready for that usage.
+
+- In-kernel user, referring to something like a VFIO mdev that is accessing the
+  IOAS and using a 'struct page \*' for CPU based access. Such users require an
+  isolation granularity smaller than what an iommu domain can afford. They must
+  manually enforce the IOAS constraints on DMA buffers before those buffers can
+  be accessed by mdev. Though no kernel API for an external driver to bind a
+  mdev, the datastructure and algorithms are ready for such usage.
+
+iommufd_ioas serves as the metadata datastructure to manage how IOVA ranges are
+mapped to memory pages, composed of:
+
+- struct io_pagetable holding the IOVA map
+- struct iopt_areas representing populated portions of IOVA
+- struct iopt_pages representing the storage of PFNs
+- struct iommu_domain representing the IO page table in the IOMMU
+- struct iopt_pages_user representing in-kernel users of PFNs
+- struct xarray pinned_pfns holding a list of pages pinned by
+   in-kernel Users
+
+The iopt_pages is the center of the storage and motion of PFNs. Each iopt_pages
+represents a logical linear array of full PFNs. PFNs are stored in a tiered
+scheme:
+
+ 1) iopt_pages::pinned_pfns xarray
+ 2) An iommu_domain
+ 3) The origin of the PFNs, i.e. the userspace pointer
+
+PFN have to be copied between all combinations of tiers, depending on the
+configuration (i.e. attached domains and in-kernel users).
+
+An io_pagetable is composed of iopt_areas pointing at iopt_pages, along with a
+list of iommu_domains that mirror the IOVA to PFN map.
+
+Multiple io_pagetable's, through their iopt_area's, can share a single
+iopt_pages which avoids multi-pinning and double accounting of page consumption.
+
+iommufd_ioas is sharable between subsystems, e.g. VFIO and VDPA, as long as
+devices managed by different subsystems are bound to a same iommufd.
+
+IOMMUFD User API
+================
+
+.. kernel-doc:: include/uapi/linux/iommufd.h
+
+IOMMUFD Kernel API
+==================
+
+The IOMMUFD kAPI is device-centric with group-related tricks managed behind the
+scene. This allows the external driver calling such kAPI to implement a simple
+device-centric uAPI for connecting its device to an iommufd, instead of
+explicitly imposing the group semantics in its uAPI (as VFIO does).
+
+.. kernel-doc:: drivers/iommu/iommufd/device.c
+   :export:
+
+VFIO and IOMMUFD
+----------------
+
+Connecting VFIO device to iommufd can be done in two approaches.
+
+First is a VFIO compatible way by directly implementing the /dev/vfio/vfio
+container IOCTLs by mapping them into io_pagetable operations. Doing so allows
+the use of iommufd in legacy VFIO applications by symlinking /dev/vfio/vfio to
+/dev/iommufd or extending VFIO to SET_CONTAINER using an iommufd instead of a
+container fd.
+
+The second approach directly extends VFIO to support a new set of device-centric
+user API based on aforementioned IOMMUFD kernel API. It requires userspace
+change but better matches the IOMMUFD API semantics and easier to support new
+iommufd features when comparing it to the first approach.
+
+Currently both approaches are still work-in-progress.
+
+There are still a few gaps to be resolved to catch up with VFIO type1, as
+documented in iommufd_vfio_check_extension().
+
+Future TODOs
+============
+
+Currently IOMMUFD supports only kernel-managed I/O page table, similar to VFIO
+type1. New features on the radar include:
+
+ - Binding iommu_domain's to PASID/SSID
+ - Userspace page tables, for ARM, x86 and S390
+ - Kernel bypass'd invalidation of user page tables
+ - Re-use of the KVM page table in the IOMMU
+ - Dirty page tracking in the IOMMU
+ - Runtime Increase/Decrease of IOPTE size
+ - PRI support with faults resolved in userspace
-- 
2.35.1

