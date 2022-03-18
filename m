Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5FCC4DDFEC
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239507AbiCRR3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239628AbiCRR3I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:29:08 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D0C1D7639
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 10:27:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ejDs+sDJjtuMd8VREClzs1pMcgfXV++8drItxxT8lGk8eSM0S40rubUSZoFZFMeOtEHdV9wG114kgrckXcFMrAo/v+LYmTqDad+y/m5m93ECJewVvSv+ARRQexqBcMI4kJQpl8Tkf7TnsRgLNaUMhRGUn7hw1u9NzXY7A9NNWw3cOjYfh1lNElRPBYNO3WtrZq5UCWO/M/oz3KqR0fX5kZFVg6jLmIEoBXaApecQWDSzkdkQPL4j1G9qSRYOgTViw6xsudGzlj1dD1QspwwEozPiSr7f2H1xt4weTHIYuVXh2Q5I+XsOTZw1kkOO4QU4L8WMEB/071II2xqUM55e0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G+NIYmZvEuR2qPslGCgHBcIaYAVqGDq9BpbRITMn+Ig=;
 b=WhZAipCh3ljmWhNqJiY5XnNGtCL19JGjhQxurI316mYRSQ0wzqM1L4bXhki3e0LLbA39HfZsYXx5koh5sg4KLErtRj0thy0euZYnhkCA4hXy1vt71oBQk9MWNz7dTuoGOvHv87chgNjcAL9U1Qw4M9phSS1wWlVoaiVoY/zUkqKDm5TCsyTzqqGKzbmD5A9STRMZhDkrBVV5AFzxOhVQuh1t7dbMaWfeMWGGHR3iGNIMKAoFqRM33aLqgjJew2m77NohBKRUzs7q3/3KSyhIwBSjlyt0AoI9zaneBNzRoX568rnIScnPzKOsIY8qASU/IslGc32PkOT4uYJ08rptiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+NIYmZvEuR2qPslGCgHBcIaYAVqGDq9BpbRITMn+Ig=;
 b=k2FhgqcvHX6YIRMxlHAfJvbzI4pWMlXzqi1IiXJcvDSOjpp0FJWRSliymipD2irXBAni9pC6yHB6/RktQfmVaQJGSsSoY9caUPFPT3jW3WiRJpHhBm3TrHp0Gj712ikKvIsIXvOvnpugq2bS7gz9SeqMF7LqvO7W95hOoM6sPrtt4GLiAjZDCrvgbqYxLftTaaeCl+fbDR76QpDGxDsJfpS1Ggb+I2WsJDDxoPaa68YG6+CmbDMYePrU8Lnela33X+JGOikjf2nK0SxpyA8tqUBsSgn1ffPNHb7z7l+PY4Pbo54zhuZ4ZaSSfQSj/1/+5r3aEbyNN9NG9K/aN5jmUA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3951.namprd12.prod.outlook.com (2603:10b6:208:16b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 17:27:43 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 17:27:43 +0000
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
Subject: [PATCH RFC 00/12] IOMMUFD Generic interface
Date:   Fri, 18 Mar 2022 14:27:25 -0300
Message-Id: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0012.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54c6f11d-2246-445b-8d2a-08da09049a56
X-MS-TrafficTypeDiagnostic: MN2PR12MB3951:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB395101FDB0E52134C2E8CC7FC2139@MN2PR12MB3951.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ypX54g1u3HImMjoOBomYp0LWJcZSeZmK5Do3XrlYEtzV7lfN9gmUR5bjYdtrk8/IOt3If56pqurcnlXjCJdG0EEgiF9fDflj8WcMWSY67xM2A4HWd+ziKt9EI/rJpZ9q+CodG9aaUz/VGvQHm1ITHOoVUM61hvaeobOzmbrjsi5PC+O8/04l5yea9grSUu7EUzxXzI3B0HGonY8YJfz2BTwsvZroWv5k6M/cvLdCDspi5hQVvgNak37CBlW2DwXGDjpeRgHSZH/OVyH77BxL5xi/YSNRWRh606s2GIIqLYh0zGJRxLnMhColnhQzkES5kzRGx50f6m/NvZt8e5+UQ6Q7ogSo0ks2CoBC+bzUEovew2ieQI9C+gY7P9WRBNJL0fhjzIrRWC1JQ+U3PbW5RUNiCnY1KJ7queqcRwEMeWebRcqy+gDe0nIUitX+vCIaPT/Q2n60JW5gW0Ry7eDE4o/B1aurPA+3qXGzlQcFbSYi7AK5r/HMEIFW5Cc1Hy2irMnJMRG2qyfpHmWxTwGWc5gBZuhJSoXWC8sWMmpPloq+4716z+COESOrlaAa3Ru8660VbUUEFPkeip9H4VLOJdnKzn9L7DXjjh2OUhnxl20G3WvGgSCQCKZp5NZhIwsDwqbcFWi+QImunlTzR83O91oH4LG5q49pK7bx9rckP9g1eue8BSPJo2liWnLd5uzli03MJMHdk9QlxSnm27y6Qw53cIyTmRv9LvCjrjdAzhlYr9T2QlMd9WAAKW759y/9Tv+MFZN36WD9KJN3ujiWegluZ+eeE1IhirNQ9NtC3snEbXPiyR5f9O5tHR+jNlvxtlN5yf061FGMR2i9grg5CYfN3bXNzrDCPYRCKQx3V4M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(7416002)(4326008)(2906002)(86362001)(508600001)(8676002)(6512007)(6506007)(6666004)(5660300002)(8936002)(109986005)(66946007)(26005)(66476007)(186003)(316002)(66556008)(2616005)(36756003)(966005)(38100700002)(6486002)(54906003)(4216001)(266003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jqq1kx4cVjn2ithiqQYGW670zg4Ce93Mo+HQMOq+vg7iIALyOVM7dthowZSW?=
 =?us-ascii?Q?/XU4kADuSb8tn4Ge2IQdVpBBo1NUXq3U5ZFNUmlS0rgf57wSM+qGhnpZG7Xy?=
 =?us-ascii?Q?fylVW6DvRcF901bwHymVUZFnIo1nxy1g85GcShnkObV5YvzkGEM0gBcens5k?=
 =?us-ascii?Q?4dCLqXiWJRKYGhqkE8Ji5FAgTXxpzyBe9Q42+U3k1bnZBfVix9qZ6gfUZgie?=
 =?us-ascii?Q?0l1gajTCksQ4fxwJWzQeuE8LuSpfjeaccqgxDDzu+vvTJVz1NITjfMBqXYIu?=
 =?us-ascii?Q?G76Ez26+3hP512sQcV7++20luMMBEFCN1bHq3xtlJ0cdQ0kUJik2cBEJMYS2?=
 =?us-ascii?Q?WwzlR7TJpbmjxm6U/DlBx4e6qgOLYN9G7VuE/cYIqgCDR1zC+yOYVKQvbONJ?=
 =?us-ascii?Q?88pX1hUN9IknYeV4PZg6fXAlXht9orBnTZWUhhyB47GR+Y4UqFYeHBh0X0VX?=
 =?us-ascii?Q?iZeSwWL/kOWF2lJ2EBmbC3OLQILJUae4cAW1+dLTtnUBsx5f3pipi2MskYru?=
 =?us-ascii?Q?WgHtT2SuUaMbn5out8YQyzveWIsmL48K36KvJYBdlrNOVLb70yNUq/tZ/Kj/?=
 =?us-ascii?Q?s+3BSghy8koK2ymV8hiV7FbDIAfmNCprdp368QaoGCDKHLbzwQmvw/FHvWh9?=
 =?us-ascii?Q?dBFDD4g1N8d15YG98DPu0Zbs5T1ELgg/nlaJ6Phyi4150565m4AOHHkPe1eN?=
 =?us-ascii?Q?4TII1eVBF3fogY+A+a7BY4+kEknlEMXJBa4fKdmfY0l+xPTzTZeLF4JH4LO/?=
 =?us-ascii?Q?FvNTBIVci1imECL1GpCtTC74wC/vNdSioDYDDIRAIigrO3N5nDkLz2FIHXrI?=
 =?us-ascii?Q?XeCixm2DDwJxeZZvsba1Y4n7c29Op8B6WZuTb7vqzWXqWzGGO4gcFHYRn8Hf?=
 =?us-ascii?Q?EkoG2j4j0qpbP3cYyFZFuxM5pV3oUhAgrODw8LNbdTkZi3AmmxF+1EZqjc0p?=
 =?us-ascii?Q?fvmHiAp7VCdllZSleGotH3LFqWMcIL8ILoev0cipR7bskQ8GHX6R6poIF+CY?=
 =?us-ascii?Q?/0inaRm41ebirM2039UYZG+g60JEcyC+7t06SscAIDKnkoFOyNnrUAnv5vjK?=
 =?us-ascii?Q?JTQgIZdit1socte6/1TnsOkUdB9mpgaYTupSBgRJ1OjHh8ReoBOzLTZPN1L0?=
 =?us-ascii?Q?/OUT4tsFa0DKF1APnIRIFNmU8KWUzHsXsUQF1TB25vwS9k4XoLk5y2qFFGQy?=
 =?us-ascii?Q?WKW1tWEx5A/0ZQ30/mWUNJGOPar8/qDwXdsktgdOe/jVfGSIIuMUFzld83Bx?=
 =?us-ascii?Q?6BcpCkHG859MYYUEQWcWt9GabE7b11PxKAAr1AJgIp/zQO6JLLIFjs2RaAHc?=
 =?us-ascii?Q?w6bkLYILULlVbNGJQbaVT/EJWQMUdxQQb4m7jShCikNp/+NNpBqqykthYWy7?=
 =?us-ascii?Q?8gOAcKL4pJEdjNWM9otQnyh0ZjDjvv4pl70bFtG2cSPpBH3YGrXZd0597LHj?=
 =?us-ascii?Q?Krvkt7ihFbT/n80lMLaIIcuVuVhvdxyr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54c6f11d-2246-445b-8d2a-08da09049a56
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 17:27:40.1947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fsTle1cAnrtPKo2lq/mrnLUfJbz/1VeQ4VoxXKaGJiG1zmi5/XYvwe7xk1PsgcEg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3951
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

iommufd is the user API to control the IOMMU subsystem as it relates to
managing IO page tables that point at user space memory.

It takes over from drivers/vfio/vfio_iommu_type1.c (aka the VFIO
container) which is the VFIO specific interface for a similar idea.

We see a broad need for extended features, some being highly IOMMU device
specific:
 - Binding iommu_domain's to PASID/SSID
 - Userspace page tables, for ARM, x86 and S390
 - Kernel bypass'd invalidation of user page tables
 - Re-use of the KVM page table in the IOMMU
 - Dirty page tracking in the IOMMU
 - Runtime Increase/Decrease of IOPTE size
 - PRI support with faults resolved in userspace

As well as a need to access these features beyond just VFIO, VDPA for
instance, but other classes of accelerator HW are touching on these areas
now too.

The v1 series proposed re-using the VFIO type 1 data structure, however it
was suggested that if we are doing this big update then we should also
come with a data structure that solves the limitations that VFIO type1
has. Notably this addresses:

 - Multiple IOAS/'containers' and multiple domains inside a single FD

 - Single-pin operation no matter how many domains and containers use
   a page

 - A fine grained locking scheme supporting user managed concurrency for
   multi-threaded map/unmap

 - A pre-registration mechanism to optimize vIOMMU use cases by
   pre-pinning pages

 - Extended ioctl API that can manage these new objects and exposes
   domains directly to user space

 - domains are sharable between subsystems, eg VFIO and VDPA

The bulk of this code is a new data structure design to track how the
IOVAs are mapped to PFNs.

iommufd intends to be general and consumable by any driver that wants to
DMA to userspace. From a driver perspective it can largely be dropped in
in-place of iommu_attach_device() and provides a uniform full feature set
to all consumers.

As this is a larger project this series is the first step. This series
provides the iommfd "generic interface" which is designed to be suitable
for applications like DPDK and VMM flows that are not optimized to
specific HW scenarios. It is close to being a drop in replacement for the
existing VFIO type 1.

This is part two of three for an initial sequence:
 - Move IOMMU Group security into the iommu layer
   https://lore.kernel.org/linux-iommu/20220218005521.172832-1-baolu.lu@linux.intel.com/
 * Generic IOMMUFD implementation
 - VFIO ability to consume IOMMUFD
   An early exploration of this is available here:
    https://github.com/luxis1999/iommufd/commits/iommufd-v5.17-rc6

Various parts of the above extended features are in WIP stages currently
to define how their IOCTL interface should work.

At this point, using the draft VFIO series, unmodified qemu has been
tested to operate using iommufd on x86 and ARM systems.

Several people have contributed directly to this work: Eric Auger, Kevin
Tian, Lu Baolu, Nicolin Chen, Yi L Liu. Many more have participated in the
discussions that lead here, and provided ideas. Thanks to all!

This is on github: https://github.com/jgunthorpe/linux/commits/iommufd

# S390 in-kernel page table walker
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>
# AMD Dirty page tracking
Cc: Joao Martins <joao.m.martins@oracle.com>
# ARM SMMU Dirty page tracking
Cc: Keqian Zhu <zhukeqian1@huawei.com>
Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
# ARM SMMU nesting
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
# Map/unmap performance
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
# VDPA
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
# Power
Cc: David Gibson <david@gibson.dropbear.id.au>
# vfio
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: kvm@vger.kernel.org
# iommu
Cc: iommu@lists.linux-foundation.org
# Collaborators
Cc: "Chaitanya Kulkarni" <chaitanyak@nvidia.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (11):
  interval-tree: Add a utility to iterate over spans in an interval tree
  iommufd: File descriptor, context, kconfig and makefiles
  kernel/user: Allow user::locked_vm to be usable for iommufd
  iommufd: PFN handling for iopt_pages
  iommufd: Algorithms for PFN storage
  iommufd: Data structure to provide IOVA to PFN mapping
  iommufd: IOCTLs for the io_pagetable
  iommufd: Add a HW pagetable object
  iommufd: Add kAPI toward external drivers
  iommufd: vfio container FD ioctl compatibility
  iommufd: Add a selftest

Kevin Tian (1):
  iommufd: Overview documentation

 Documentation/userspace-api/index.rst         |    1 +
 .../userspace-api/ioctl/ioctl-number.rst      |    1 +
 Documentation/userspace-api/iommufd.rst       |  224 +++
 MAINTAINERS                                   |   10 +
 drivers/iommu/Kconfig                         |    1 +
 drivers/iommu/Makefile                        |    2 +-
 drivers/iommu/iommufd/Kconfig                 |   22 +
 drivers/iommu/iommufd/Makefile                |   13 +
 drivers/iommu/iommufd/device.c                |  274 ++++
 drivers/iommu/iommufd/hw_pagetable.c          |  142 ++
 drivers/iommu/iommufd/io_pagetable.c          |  890 +++++++++++
 drivers/iommu/iommufd/io_pagetable.h          |  170 +++
 drivers/iommu/iommufd/ioas.c                  |  252 ++++
 drivers/iommu/iommufd/iommufd_private.h       |  231 +++
 drivers/iommu/iommufd/iommufd_test.h          |   65 +
 drivers/iommu/iommufd/main.c                  |  346 +++++
 drivers/iommu/iommufd/pages.c                 | 1321 +++++++++++++++++
 drivers/iommu/iommufd/selftest.c              |  495 ++++++
 drivers/iommu/iommufd/vfio_compat.c           |  401 +++++
 include/linux/interval_tree.h                 |   41 +
 include/linux/iommufd.h                       |   50 +
 include/linux/sched/user.h                    |    2 +-
 include/uapi/linux/iommufd.h                  |  223 +++
 kernel/user.c                                 |    1 +
 lib/interval_tree.c                           |   98 ++
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/iommu/.gitignore      |    2 +
 tools/testing/selftests/iommu/Makefile        |   11 +
 tools/testing/selftests/iommu/config          |    2 +
 tools/testing/selftests/iommu/iommufd.c       | 1225 +++++++++++++++
 30 files changed, 6515 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/userspace-api/iommufd.rst
 create mode 100644 drivers/iommu/iommufd/Kconfig
 create mode 100644 drivers/iommu/iommufd/Makefile
 create mode 100644 drivers/iommu/iommufd/device.c
 create mode 100644 drivers/iommu/iommufd/hw_pagetable.c
 create mode 100644 drivers/iommu/iommufd/io_pagetable.c
 create mode 100644 drivers/iommu/iommufd/io_pagetable.h
 create mode 100644 drivers/iommu/iommufd/ioas.c
 create mode 100644 drivers/iommu/iommufd/iommufd_private.h
 create mode 100644 drivers/iommu/iommufd/iommufd_test.h
 create mode 100644 drivers/iommu/iommufd/main.c
 create mode 100644 drivers/iommu/iommufd/pages.c
 create mode 100644 drivers/iommu/iommufd/selftest.c
 create mode 100644 drivers/iommu/iommufd/vfio_compat.c
 create mode 100644 include/linux/iommufd.h
 create mode 100644 include/uapi/linux/iommufd.h
 create mode 100644 tools/testing/selftests/iommu/.gitignore
 create mode 100644 tools/testing/selftests/iommu/Makefile
 create mode 100644 tools/testing/selftests/iommu/config
 create mode 100644 tools/testing/selftests/iommu/iommufd.c


base-commit: d1c716ed82a6bf4c35ba7be3741b9362e84cd722
-- 
2.35.1

