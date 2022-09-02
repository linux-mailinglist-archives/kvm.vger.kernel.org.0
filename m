Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3441D5AB912
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 21:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiIBT7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 15:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiIBT7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 15:59:37 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04hn2227.outbound.protection.outlook.com [52.100.161.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B7C20F71
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 12:59:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=njopD44fPEwHvUd0XsIg2fREJA/1bh4o+TlfVT+zv1p1ndw7ovvjjiphKj6XV42Gx4tw6l2Hum6242kSnm/01Q6cHvDNX5CBzr9nrMn0He3HoQkop60qTRCA9hh50xdt6ICJ1cqfD4I+mvGx3TIn3GgJZ9hIx8lm8rgMLVoH9H7wh8amfEaViAau/eP0R1P8wkn7qIhR4NQdrCPFvlnSDxM8JamPCSEksiXhahhjAyoPJrohNYaDyb8TdFO91LxnFdYJv6NBqoDD3zxSEK5DdLnPT+LpT0PW7J2zgUzCzejY5YDF0whJwVHdzaidCcEsleh60Z9qdw1/bortjw/0zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bhzi9e3gCIZnw3iHu9dkJx5jaQ6Nl2UgbzDqhVOrc/g=;
 b=BiN07MXIgjKaLifuiE3zexaHTlsJRrLEImNVcOWWxeeNB/DZp99U1D3GvEXcnsv4Sz7LDSy/QdduLYeGF6oBIyFCPfuOBP2nHAlLLvlCeC60ctLoFIMHGmjWiyBGgaMDGHquOjGBeQ7fR3YvynAF+BOrCT+ULlnaCIFyf0/0FmUtYSt9yI3CVXihrPhkYa44cI+gnAHZN9/iNVWxKBggXI7txaUr8Ux0rXfq+KaeB46ngnw4ECI2AKIRo3qJJIDXBTbI2V31i9+7BC+HIrI8Tzi39jWKadE7MXkYX2tunxZNCO86Pf2Hxs4A1l9G5UpDNPERyhhi6m/iJDfESXVT0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhzi9e3gCIZnw3iHu9dkJx5jaQ6Nl2UgbzDqhVOrc/g=;
 b=nsdOzGH5rp9xDaDLFedq0Qdg28AjUh/snUpI1OtZK0rPzcvcUbJMa3wsKBCTq7lcmDoyHbsvLFxWLznlIj2oGq7QTuVwvuGa9Mzxo4U2qGWRXjyhig749h568s+0iQorlOsivcQdFj+NeC2JfsDvqHJkpk0AQ9unnHs8Cu6aotLtLYOpz0L8+EF8UPjmCNTFo5xB/stjaZoGekq/Ih2MsP2VC34HVJ5RKv/o1C/YGA/yT3LnMWxPo1n5nsW94X9aEky5od0Zgq/MRwBMJcTX5CmlaSl4t7/49tc+hg2RlWLV6xHRH9OfGdH3eKcVOCn4u3FyA9QEpANop4d3su2YzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB6566.namprd12.prod.outlook.com (2603:10b6:8:8d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 19:59:34 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.016; Fri, 2 Sep 2022
 19:59:34 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
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
Subject: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Date:   Fri,  2 Sep 2022 16:59:16 -0300
Message-Id: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0100.namprd03.prod.outlook.com
 (2603:10b6:208:32a::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5da3d41c-eabf-46ef-753c-08da8d1da657
X-MS-TrafficTypeDiagnostic: DM4PR12MB6566:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?AH6kwZ1SWEHokiHxk7zYUXcBExq4632N3cBdm2Ma7AVxWyu2PJq2+QYiz+VE?=
 =?us-ascii?Q?lP0Hc24WBBmI6xUdSqfLImRjhW7OpCtH2v8p18ysD7Ph3bSofONdqgycchnz?=
 =?us-ascii?Q?nlaBAFe0IICOxoDtq7zk9TnFluLh69utEBBgB0KS/wbdJD+tLrk98zjaZqOv?=
 =?us-ascii?Q?2TbVbTObd++7S2CQQVR0ZuZIlSO+amIZqSp8T8PwII3JJSTSt3O3QrHTe7qT?=
 =?us-ascii?Q?42PrmjGkOvROdFgZEHat8/FTw03MQL3UN8bvoFf83xAZQBD90T2M/3Y7kFIb?=
 =?us-ascii?Q?Q+2C88h+tyl7JMJHTtTcqIdmMiuGULRva5TQfUhbiRlU7mw/TGk9u5RkhPpR?=
 =?us-ascii?Q?GizThWofs4JMjijw790YUZta3Ub7LmD0RX+MKbneLdXhtcCsc1wvFarJoER3?=
 =?us-ascii?Q?69mONBN2ndKkV3W3Je+dCFVbDff8cJM+BifjintBEQ+jQwf8BkGJ3UGdoWCo?=
 =?us-ascii?Q?AclvkSSjCsWhKohNBVPIR2mIeQxd7xGM1L41xKCcp2tGTeHXnD7mrM/r0o37?=
 =?us-ascii?Q?qndAiQxKIAonfaIB8Y7rTwBpmt8FsfMX7VqDTNxJQ5mkYfCOX9iQzTNeL4cM?=
 =?us-ascii?Q?NKOxx2Hv0bo4ym/umK0iLT6EmIQewl+PGU0O+/UZUq9/JcA7ktFlJ2lyWdoI?=
 =?us-ascii?Q?/Uxxdo8ywpqrSpuucgoAwqVXbg6Lz/bc5Az3VxnvhG/LwRm+tw791vEOGkk0?=
 =?us-ascii?Q?8xDzJv4ewK2EoJl74/Co/hITtXme8FAZEpJBiPBfgheeeOU47Ezn2XjVJsu5?=
 =?us-ascii?Q?tM6ja53v6ubYWaeoP+Zs7x/Nj0wy1TK7XP7JdWz05h9ddvrgWGP/ARhPFrGb?=
 =?us-ascii?Q?rHrcSLpxa8+9xNyCveGj2MArbWpJQhuBF/pbb/oC2Fu6V7rdBW9AgepyMp/K?=
 =?us-ascii?Q?xBYWeCjvQh4IDkpOyhQoEv0DK/VaTHNMfcgAEFIASyYJDl+8Dz4kHXXFTfXz?=
 =?us-ascii?Q?oOg2UjHOmfOdGfGsqh1xfLW5Nt0C6PuJBXs4XtTG+FWKzHsHc/Hc5MSkeehD?=
 =?us-ascii?Q?i3lAuoJ0GYsaISsP79C9CUachfbnMFeTomtrQMbvvEIsS7rLEpcKmlMYxwCk?=
 =?us-ascii?Q?QWOzyQJGjfZbEeyIaB8NqBfoXFVRY6ALHIdyTyTHIitbNC4M6+jg58xYSsZy?=
 =?us-ascii?Q?pnwpi8g276wGRQRb+xcSf2/1qxuW8QohBIBb0rkIVq/CWbRFC/pLb9OarUtW?=
 =?us-ascii?Q?Dar34mmIYmjOx/P8P0QxYpaZVvjuHSjvyJwGxRC/CtIRLfCbvT/zNnSLtcof?=
 =?us-ascii?Q?0Q8iQwWcZEta1KZm9xnhVdLs5SLXpgfxQv41/mn41OIhT6ZCISdvkcGg+b07?=
 =?us-ascii?Q?jIKjerWo1n2NZ+t2uzd0qmWTv1GWZFdBbroCY8V3tTvQJ8wvG7LNoeAIgkoM?=
 =?us-ascii?Q?mtNAjYetUEUCwut0JWP6JMEtZO5kN7OR90AeyWpgR2uZcWW24LP93wML9QSR?=
 =?us-ascii?Q?dIqDSQq191sQejxhhnPhAC65V1UhTV2F0dcdaFYLBFdf1kTgy4lJ0VBJWN1X?=
 =?us-ascii?Q?66/C+qLIlZJm9EOpU/ZLG9ZFAfWTUVcU51Ur?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:9;SRV:;IPV:NLI;SFV:SPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(30864003)(5660300002)(109986005)(6506007)(36756003)(966005)(83380400001)(41300700001)(8936002)(6666004)(6486002)(478600001)(2906002)(38100700002)(66476007)(8676002)(66946007)(66556008)(4326008)(86362001)(54906003)(7416002)(26005)(6512007)(186003)(2616005)(316002)(4216001)(266003)(41533002);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b8B1IbZ4zuJ13jJFXQDcwVwW+5/T9C8qej/XVKMZs7AF6H+KaEKl0WMI18+T?=
 =?us-ascii?Q?RkFX+aw3V7RJHDI9oRFx4ZgCLR9nQFPJvEWKwzTib1had0klpY7gQP0Zf1N/?=
 =?us-ascii?Q?vlFzklJ1QnrSrLuqX1HpYvYrUSjXJTin8jB+ZdBpaM8MIUwTQypqvtzKms0g?=
 =?us-ascii?Q?jK0olKmoWw0ts9L+vRDgs/BK/Xyq2K1en8CITZUfFNCbJgxugkIxHAcKg/C5?=
 =?us-ascii?Q?G2SIhcv6Bnq/HoV+ldhuhOwyC5yDPP0FQKpA0ifbLxX9UBcaeckGMH7FNKLl?=
 =?us-ascii?Q?wEYi2gyMuExfSBTW0UXM4JKBmcFkpzT6bPa3aFb+7CThOpId5hOvTdypRx96?=
 =?us-ascii?Q?QDV6wf5mh4xPZutpNuMgu6Ybzm8mKr14pXzL4HYviQDl08VzoH0ynIopPD0C?=
 =?us-ascii?Q?PQ/3FDpOEd9ngwNSu8vAZMBd8sMf3EfOwUzbw2g1wxdoDdPG+q+xaSx+48DE?=
 =?us-ascii?Q?L4+xO3akEMq+W0F/Jp7ElMqmlX1WmtP5tFOmOn3u4DXu8xrawsk14Thz5Hac?=
 =?us-ascii?Q?KSFLVKZpFJk4sM238umuz8AzZYvIhCk8v3sAPlQzTRPLaBGGvUMwdj2o5jCD?=
 =?us-ascii?Q?9cdCe0OFc+rl+x/nNGnvxs5SJmpL4IVZ1pJWuUfgY34N0xC7DTqSLovjYSnQ?=
 =?us-ascii?Q?if91zFJrsCYkZupIwnYWkPjZlw1gzdSLUoaT2Q3pYzZnl7svx8HWM9yQhuyH?=
 =?us-ascii?Q?ydJ7IAsrnUvHUrPMkoTaZr52RLCPyxeSvna9yc9Zw/MDm+DdzGjw64Ttu9gV?=
 =?us-ascii?Q?2khlfqLv/z5FIV+B0ZjaUw5T33o9b+Qq5jm9kLhm2RlrlW3VDcxG3xb2S7mg?=
 =?us-ascii?Q?LG8fNLPL0GzdJiqa9Vae1z4xkM+H8uMsOBYcXK/h4Qa0RQbfAjjWvmn+dn+0?=
 =?us-ascii?Q?HUwh59O0tgUD2Zwvi5nbw+L6xCPSuJ6SEvcYye7n6K/K6oOJSi4nwOw1M0PT?=
 =?us-ascii?Q?pfVNVjqZXmTjNclMdbOoYFltVe5taJRAopPE4/3lOosCZylKNdPG4NFtLCr9?=
 =?us-ascii?Q?kwv9ADttCqisRZ7bA4NaCCnN9o+u0V272l/czToCX/4Fp5AVts6ZrDob4MM3?=
 =?us-ascii?Q?DzTZ75eWCk5Np5WuzpytK2t+4MEvIlY9egOoJGpFGpsxxRtl5yx3HTYwbKzm?=
 =?us-ascii?Q?eKwQY7Y6tafDPHv4pZlaY5Co282mxD65CbyoQsRs9b0aXC/noRCRmfWVB5O2?=
 =?us-ascii?Q?pvMEkDXWEcMZtOgk980Tpg2qWqfcyMdTw/nSo84aZUi5wvaPYMLyAZ31dLHG?=
 =?us-ascii?Q?8zVmD8pLLebNfW0wEPBs058xMFQH+BNGH349HtT8odqnMlyS9IQl0YCoQgu6?=
 =?us-ascii?Q?YfcAlk+S22KsCV8ePaIdw5vkabM18+q6lckQS2k+VJhDZuHv6B35AR5QBo1t?=
 =?us-ascii?Q?Sh/x4uQhwkJRcDmQtGU6HEdzRx21t4qvGsX3XGW/txsh6CdgsTUodjpaTq4j?=
 =?us-ascii?Q?PHOt8SmMVKdDuHHy0gch8UmO7+g0fDDfTyujZpRMZzIWoSOSyx42lSHPaStJ?=
 =?us-ascii?Q?voHn1tOJ8mJOp/Dl6vSTo5uSv4cbsb7WYoRuJkiOIBhxIAfRhvRI43ooRUE0?=
 =?us-ascii?Q?l+7i3mVAM+jXEE7z4QQL7TWRkKp42gZl8oK8pRz2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5da3d41c-eabf-46ef-753c-08da8d1da657
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 19:59:31.2226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bJAwZjLRNAn5Ktax5tBQtvwnGbfB+NjqE6FY5Ag0NsiFnXdHFhW0p40HYVMT7NSx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6566
X-Spam-Status: No, score=2.8 required=5.0 tests=AXB_X_FF_SEZ_S,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
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

As well as a need to access these features beyond just VFIO, from VDPA for
instance. Other classes of accelerator HW are touching on these areas now
too.

The pre-v1 series proposed re-using the VFIO type 1 data structure,
however it was suggested that if we are doing this big update then we
should also come with an improved data structure that solves the
limitations that VFIO type1 has. Notably this addresses:

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

Several follow-on series are being prepared:

- Patches integrating with qemu in native mode:
  https://github.com/yiliu1765/qemu/commits/qemu-iommufd-6.0-rc2

- A completed integration with VFIO now exists that covers "emulated" mdev
  use cases now, and can pass testing with qemu/etc in compatability mode:
  https://github.com/jgunthorpe/linux/commits/vfio_iommufd

- A draft providing system iommu dirty tracking on top of iommufd,
  including iommu driver implementations:
  https://github.com/jpemartins/linux/commits/x86-iommufd

  This pairs with patches for providing a similar API to support VFIO-device
  tracking to give a complete vfio solution:
  https://lore.kernel.org/kvm/20220901093853.60194-1-yishaih@nvidia.com/

- Userspace page tables aka 'nested translation' for ARM and Intel iommu
  drivers:
  https://github.com/nicolinc/iommufd/commits/iommufd_nesting

- "device centric" vfio series to expose the vfio_device FD directly as a
  normal cdev, and provide an extended API allowing dynamically changing
  the IOAS binding:
  https://github.com/yiliu1765/iommufd/commits/iommufd-v6.0-rc2-nesting-0901

- Drafts for PASID and PRI interfaces are included above as well

Overall enough work is done now to show the merit of the new API design
and at least draft solutions to many of the main problems.

Several people have contributed directly to this work: Eric Auger, Joao
Martins, Kevin Tian, Lu Baolu, Nicolin Chen, Yi L Liu. Many more have
participated in the discussions that lead here, and provided ideas. Thanks
to all!

The v1 iommufd series has been used to guide a large amount of preparatory
work that has now been merged. The general theme is to organize things in
a way that makes injecting iommufd natural:

 - VFIO live migration support with mlx5 and hisi_acc drivers.
   These series need a dirty tracking solution to be really usable.
   https://lore.kernel.org/kvm/20220224142024.147653-1-yishaih@nvidia.com/
   https://lore.kernel.org/kvm/20220308184902.2242-1-shameerali.kolothum.thodi@huawei.com/

 - Significantly rework the VFIO gvt mdev and remove struct
   mdev_parent_ops
   https://lore.kernel.org/lkml/20220411141403.86980-1-hch@lst.de/

 - Rework how PCIe no-snoop blocking works
   https://lore.kernel.org/kvm/0-v3-2cf356649677+a32-intel_no_snoop_jgg@nvidia.com/

 - Consolidate dma ownership into the iommu core code
   https://lore.kernel.org/linux-iommu/20220418005000.897664-1-baolu.lu@linux.intel.com/

 - Make all vfio driver interfaces use struct vfio_device consistently
   https://lore.kernel.org/kvm/0-v4-8045e76bf00b+13d-vfio_mdev_no_group_jgg@nvidia.com/

 - Remove the vfio_group from the kvm/vfio interface
   https://lore.kernel.org/kvm/0-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com/

 - Simplify locking in vfio
   https://lore.kernel.org/kvm/0-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com/

 - Remove the vfio notifiter scheme that faces drivers
   https://lore.kernel.org/kvm/0-v4-681e038e30fd+78-vfio_unmap_notif_jgg@nvidia.com/

 - Improve the driver facing API for vfio pin/unpin pages to make the
   presence of struct page clear
   https://lore.kernel.org/kvm/20220723020256.30081-1-nicolinc@nvidia.com/

 - Clean up in the Intel IOMMU driver
   https://lore.kernel.org/linux-iommu/20220301020159.633356-1-baolu.lu@linux.intel.com/
   https://lore.kernel.org/linux-iommu/20220510023407.2759143-1-baolu.lu@linux.intel.com/
   https://lore.kernel.org/linux-iommu/20220514014322.2927339-1-baolu.lu@linux.intel.com/
   https://lore.kernel.org/linux-iommu/20220706025524.2904370-1-baolu.lu@linux.intel.com/
   https://lore.kernel.org/linux-iommu/20220702015610.2849494-1-baolu.lu@linux.intel.com/

 - Rework s390 vfio drivers
   https://lore.kernel.org/kvm/20220707135737.720765-1-farman@linux.ibm.com/

 - Normalize vfio ioctl handling
   https://lore.kernel.org/kvm/0-v2-0f9e632d54fb+d6-vfio_ioctl_split_jgg@nvidia.com/

This is about 168 patches applied since March, thank you to everyone
involved in all this work!

Currently there are a number of supporting series still in progress:
 - Simplify and consolidate iommu_domain/device compatability checking
   https://lore.kernel.org/linux-iommu/20220815181437.28127-1-nicolinc@nvidia.com/

 - Align iommu SVA support with the domain-centric model
   https://lore.kernel.org/linux-iommu/20220826121141.50743-1-baolu.lu@linux.intel.com/

 - VFIO API for dirty tracking (aka dma logging) managed inside a PCI
   device, with mlx5 implementation
   https://lore.kernel.org/kvm/20220901093853.60194-1-yishaih@nvidia.com

 - Introduce a struct device sysfs presence for struct vfio_device
   https://lore.kernel.org/kvm/20220901143747.32858-1-kevin.tian@intel.com/

 - Complete restructuring the vfio mdev model
   https://lore.kernel.org/kvm/20220822062208.152745-1-hch@lst.de/

 - DMABUF exporter support for VFIO to allow PCI P2P with VFIO
   https://lore.kernel.org/r/0-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com

 - Isolate VFIO container code in preperation for iommufd to provide an
   alternative implementation of it all
   https://lore.kernel.org/kvm/0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com

 - Start to provide iommu_domain ops for power
   https://lore.kernel.org/all/20220714081822.3717693-1-aik@ozlabs.ru/

Right now there is no more preperatory work sketched out, so this is the
last of it.

This series remains RFC as there are still several important FIXME's to
deal with first, but things are on track for non-RFC in the near future.

This is on github: https://github.com/jgunthorpe/linux/commits/iommufd

v2:
 - Rebase to v6.0-rc3
 - Improve comments
 - Change to an iterative destruction approach to avoid cycles
 - Near rewrite of the vfio facing implementation, supported by a complete
   implementation on the vfio side
 - New IOMMU_IOAS_ALLOW_IOVAS API as discussed. Allows userspace to
   assert that ranges of IOVA must always be mappable. To be used by a VMM
   that has promised a guest a certain availability of IOVA. May help
   guide PPC's multi-window implementation.
 - Rework how unmap_iova works, user can unmap the whole ioas now
 - The no-snoop / wbinvd support is implemented
 - Bug fixes
 - Test suite improvements
 - Lots of smaller changes (the interdiff is 3k lines)
v1: https://lore.kernel.org/r/0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com

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
Cc: iommu@lists.linux.dev
# Collaborators
Cc: "Chaitanya Kulkarni" <chaitanyak@nvidia.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Yi Liu <yi.l.liu@intel.com>
# s390
Cc: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (12):
  interval-tree: Add a utility to iterate over spans in an interval tree
  iommufd: File descriptor, context, kconfig and makefiles
  kernel/user: Allow user::locked_vm to be usable for iommufd
  iommufd: PFN handling for iopt_pages
  iommufd: Algorithms for PFN storage
  iommufd: Data structure to provide IOVA to PFN mapping
  iommufd: IOCTLs for the io_pagetable
  iommufd: Add a HW pagetable object
  iommufd: Add kAPI toward external drivers for physical devices
  iommufd: Add kAPI toward external drivers for kernel access
  iommufd: vfio container FD ioctl compatibility
  iommufd: Add a selftest

Kevin Tian (1):
  iommufd: Overview documentation

 .clang-format                                 |    1 +
 Documentation/userspace-api/index.rst         |    1 +
 .../userspace-api/ioctl/ioctl-number.rst      |    1 +
 Documentation/userspace-api/iommufd.rst       |  224 +++
 MAINTAINERS                                   |   10 +
 drivers/iommu/Kconfig                         |    1 +
 drivers/iommu/Makefile                        |    2 +-
 drivers/iommu/iommufd/Kconfig                 |   22 +
 drivers/iommu/iommufd/Makefile                |   13 +
 drivers/iommu/iommufd/device.c                |  580 +++++++
 drivers/iommu/iommufd/hw_pagetable.c          |   68 +
 drivers/iommu/iommufd/io_pagetable.c          |  984 ++++++++++++
 drivers/iommu/iommufd/io_pagetable.h          |  186 +++
 drivers/iommu/iommufd/ioas.c                  |  338 ++++
 drivers/iommu/iommufd/iommufd_private.h       |  266 ++++
 drivers/iommu/iommufd/iommufd_test.h          |   74 +
 drivers/iommu/iommufd/main.c                  |  392 +++++
 drivers/iommu/iommufd/pages.c                 | 1301 +++++++++++++++
 drivers/iommu/iommufd/selftest.c              |  626 ++++++++
 drivers/iommu/iommufd/vfio_compat.c           |  423 +++++
 include/linux/interval_tree.h                 |   47 +
 include/linux/iommufd.h                       |  101 ++
 include/linux/sched/user.h                    |    2 +-
 include/uapi/linux/iommufd.h                  |  279 ++++
 kernel/user.c                                 |    1 +
 lib/interval_tree.c                           |   98 ++
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/iommu/.gitignore      |    2 +
 tools/testing/selftests/iommu/Makefile        |   11 +
 tools/testing/selftests/iommu/config          |    2 +
 tools/testing/selftests/iommu/iommufd.c       | 1396 +++++++++++++++++
 31 files changed, 7451 insertions(+), 2 deletions(-)
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


base-commit: b90cb1053190353cc30f0fef0ef1f378ccc063c5
-- 
2.37.3

