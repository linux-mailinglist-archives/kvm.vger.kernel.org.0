Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4D04FC020
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 17:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347724AbiDKPSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 11:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347716AbiDKPSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 11:18:31 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B65C31DC7
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 08:16:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RaZQ1s4AZwWfHVy6Ao4YwzvacoyTcLGdTLpALasGVXDZRhu79gFGGFcL8nI1GOOsfCfQ27zRkn96Ek7wmnIYbKbm4wbp7+cfnfx4ksr/BFWUw5jvZbFLc2oMeZYVDrGjOTU+3Gi8uuGBWpRrGzjX0i/Qu6n0huZwr9djq7rAGIUnFoUJaM2UJDyDP6AugS4CaRhyCR/sygPR1d57f+J1IxyPawb3wnGl65lrFHjGuy//M3A6KSZV/Ja7vJKD23tp0smvK4jZkMEy6xZTbs5/fYI+JvNoIG3AMZmlETGIRduAmKQIFro22mBN4RMpWVvCi5ViFJwPwITY2SrbsuILXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zb+wX33e72s2JWwps1Zk2u3B2IKnmICrG34JnxN3JSI=;
 b=BAMDc4DUv2nWGOFFUSnQCWOSCU7EPg1XVXg0f87582io5y0ewZ79x7faLK5W4PAyLSJowcACUV6VHzVw1UE/uXUEjhva8W8Dv5gSNk1S4LhITbP+mf+MAkjFEOL0GtYOqHmw6HyxJ0awtH5bYDxypJk66tGLecA5CIiJMIe110WeM8UkMoJ8DCl/+aiA1Ub4Mslkqt8YCquzkNrAHmPaCFJiS0cPCB7BFu7AUYKD2YCLccWSowuORWaXKK7pnw8hJl+xWoVvAtST7OHqtvi76oYOjKUJpafh47apct53rBA48quGb7XT7LXtaVucrF4S/VKa39qJRHZW7ut4IvDHvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zb+wX33e72s2JWwps1Zk2u3B2IKnmICrG34JnxN3JSI=;
 b=Q54NSGZHEYEVDHLmVe/f0pG7TJ/qONzFh2cByuPMenFj9VHEp4p8tSiUYLBJJJL1OLyfsqBRuDX6f3bvewTb3TEo3kzSY34pKC9cL1BEaUOponZC22vi1NFnD5k8mncN/Yuh8gReQ5Zfx4NfXlS22dBtfV/rDkAZL3o2ItAHtoVxDJoZPuiLNJRUDmSdcznUaxkb38JirfZahEkRy67tWx96CljSw60VWXmT4R7jPu0nCAUpLTtijDtvikxHG5ZihbbYJdFtrrAgzIzRufZFjvMOn3zt0TnYz2Xe0nqzRsEGRBBEdphBPegnSqFxGP82gqkBIKZ114rpgjaRQsW+eA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB5927.namprd12.prod.outlook.com (2603:10b6:510:1da::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 11 Apr
 2022 15:16:13 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 15:16:13 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH v3 0/4] Make the iommu driver no-snoop block feature consistent
Date:   Mon, 11 Apr 2022 12:16:04 -0300
Message-Id: <0-v3-2cf356649677+a32-intel_no_snoop_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0177.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::32) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6680ef55-863f-4bc3-0b2e-08da1bce35c8
X-MS-TrafficTypeDiagnostic: PH7PR12MB5927:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB5927F79C6FAB0334F03DA397C2EA9@PH7PR12MB5927.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eKayUfg96dhSEioBcbkmAbm3JveRrQIzFNm+0dcKfOaIn/QJkMW9vukisZ2YWu8PvYZxpYJ83HbXadhedt8IZ8fuR5oT+6kKYEo9baXjMCHoOdjVeWf8knQwPXXcNjVRxcZuvddZl8mg6wCxBFgFHlcqEz+jQiwlk4QBh7XlkuFn5xqGmRS3aybisJQNisRlOi61sI66AUUuTFWfR04MUltsqOuGC2TVjtGJZUB1C+2jcp3MWIt29rkZUaIoRYm8UKull1IFgFeELKBzVex/a7mUkEy7ZXMnzm/E5tuh0BX3Mm3AkYpHdWDhOAODeBgVqBcLJzVFDrGE9LdzwoXkRTlRIYijYivnxt6UDmrbwqtsSDuusPVD+bdltH8MN2ZrXC9JV7eZFMIxq8Zl3mUpoKptgDvSDxrEVw/NKSgRc8hLgzNCZ9AJ6zGi2cKVlOkhiMjF/vGb3uQ1U68f2C7Fumot5DqTi71Dwzjw8eKrWkEs8EiJn6iGWLF3l7NOnldRcZhjKfj6dJgmxpcI6LfJzjqYNCbP/RHOb0LGmbOlRWLIoCl6mphdVkG4B+nW+ZSB7iKtR87cqFm5nLWbmbstTSiByD+UF3T/0/Gy4xSLTlWqTwdPUdSbEMQhtboPVQT4XTqhnBEHvlmt7+a7Nxx1PUsa8t1yZf7O1hYg5RZta7wpHwBY8r5wjqDeiXZ/Cx8oHM4ZCQwiN/8BLUSErjby9EKMhZsUdzze+tt/w0a6VAwD6d7quFET/k5LehlTpR5joqlRmVOAnS5TjrZkV9Ns/P/dRUl3GP1g5LNvAKx6gp7lpAwT5BT/bjkCFu16VBXi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(54906003)(6512007)(38100700002)(8676002)(508600001)(6666004)(6506007)(8936002)(5660300002)(2616005)(4326008)(110136005)(966005)(316002)(83380400001)(86362001)(66946007)(66556008)(36756003)(66476007)(7416002)(186003)(26005)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jrqgg0XlLwlTMRNydUrxQbBkMp9uT+dNtXCL2pDphkCzmb+nl6tEfscxNeos?=
 =?us-ascii?Q?XPPbFS2Cp8wrdqX8jf+vZxAXiyxVIn1XxBXKxVxUrl5VYkrVOlvjevQrzHzD?=
 =?us-ascii?Q?LrwZ5wffrLPOnEXQ6FzQjeHRgvAjpM1sOGSPFR+/6CNljtG/GvD92jXn772A?=
 =?us-ascii?Q?XoBJJ4W+Cq3fbrhhvkI8uDFzKy3GyjobN1FluBAx4uQdcQrgUiB4k6/QDXtj?=
 =?us-ascii?Q?96S9j6dEUNNegddNhfkY3xZQ29xdBGpXB9t78b6MaYkBoyJ8Pj0N8FXnA4gQ?=
 =?us-ascii?Q?SDYGacZ48Vkmeen4hIbkdHbBGe6pZVNaF3WhQKFH1Z8I9gpYsj3Ui4gKobz8?=
 =?us-ascii?Q?2z5q1ZjheyYFhUlsICwL2eRScUyR+aabzsWzsyJRUHDo09iODWzhJToOltHg?=
 =?us-ascii?Q?rtkzQ1GPyKnmvOajmZe44Rg91IOyR93pXnTo4mQQEVkG0wIDu9wTvC4Re8EC?=
 =?us-ascii?Q?7r7kfYgVsmdkGtJlYHDllJBK5TU5EXWyAoKKmd3uux19NDb6Wj66fwNIEFtI?=
 =?us-ascii?Q?Z/Q77k+gOV8H1VFdkytGfnbeUESaQxmHZtmBtkxn+P1KErpo/OzPz051vDwG?=
 =?us-ascii?Q?kZLcR5UUPJZGLQfmUnwJMTX6GyIIvxHOt2skmF9i0AjCqJ7WojIi0+lgB7ND?=
 =?us-ascii?Q?L5SmXmSdDCvACK3JZQkntZ+Y2aFI4Clulzqu9ztLAXMb3+axIebb3LZdVUcG?=
 =?us-ascii?Q?4lRes35Wybi3o79ssSNqrqqvJObuusan4M4sK1W0vy4dDSInQfrznXVplEzk?=
 =?us-ascii?Q?BPjOyfES/h/8pegvNNFBhVAC18AJcTAsRBZGA+p9VA4tESD64GtNmHVMUAZW?=
 =?us-ascii?Q?pdWA48feTJk9gbZlWe0OqJefah81GzaOYc/mEtPTpLIVu5wMH9xucFNmoYFq?=
 =?us-ascii?Q?sJGzC8TBEgQe9rqEbnqCLJP302k8Cs16z3eX3DzV9zNvBV51CQibI6eNI4qd?=
 =?us-ascii?Q?2lQpnbEx2QHAH5Z2ZNB+XTBequd62YatCtCi2ofE3JrTnL4absxUylsU+Mxd?=
 =?us-ascii?Q?4XkjZtZoBWXjxY0I22M6aMuZZRfNlPXf4psWbpW79OvObfe12oaruM9JSbQ2?=
 =?us-ascii?Q?sjutjYICeZYVarCs4rv/KA9otzZkAqcQgdl5RbSNWwzGsf2ERpB9gcjjo++u?=
 =?us-ascii?Q?LTkDeRLZWo1GXBDk9z+8P4O63hUOP5/kp1XkMw0AYdeDHuteGfU/RZfVZLTz?=
 =?us-ascii?Q?+ENWt9aAbdBmGv8m0+i5xsqy+x8e/I342P1+JZ9s6uuZ7dZ0xAy7YcF/mJUQ?=
 =?us-ascii?Q?HLdPu3LGla+aFp3dr4QmeJOqttUpNktz3FbkE44ije8VOXk5BRX2JRi5roGM?=
 =?us-ascii?Q?4f5k5nuwb6L+nMVmysQiAYAXAR7umy6RH00OJ8Cgccw//5uGIEE9cNcdc/Wo?=
 =?us-ascii?Q?FRkjOVSUfNr415Z17FrS+VNGXQsUh9+zz/1O6dkQX/iechxWa+1K8hIWaiil?=
 =?us-ascii?Q?z+FLbPbsaNpbrX2NO/2+91Eih2qHZ1BHIOe8hl2dlVJlCq5fAHHeqs6M4kUR?=
 =?us-ascii?Q?W3KcrGqPqxmgM4HSEiC0G253ytqqSGJiQa3caKfTzM+4Gq0lBK0Y9JsWhkvS?=
 =?us-ascii?Q?6CcPhAOBpc9y1UfQ2oTF6bmiQzeFC4GUwbmZhkZJuRBPCOyoH1ZN88Qt5l+V?=
 =?us-ascii?Q?sCyyhWeizo/M6wbNkD9ppT4BR17Tb0fZSok+Frft6WnK+cZtyQgbzNeazlQh?=
 =?us-ascii?Q?HKHmqusYzBlYJ5Lv0ozunUrXSV11r1TQ4lyOVJfXIBlkaaQY67qSFrLNe4YY?=
 =?us-ascii?Q?Fl1WT0Q6DA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6680ef55-863f-4bc3-0b2e-08da1bce35c8
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 15:16:10.8830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i4CXLfb0MCKbfq7itXJCzdE3ET7ck0C7OeXSerHa/o3i3GokA4jvkr7MLussfaeb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5927
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PCIe defines a 'no-snoop' bit in each the TLP which is usually implemented
by a platform as bypassing elements in the DMA coherent CPU cache
hierarchy. A driver can command a device to set this bit on some of its
transactions as a micro-optimization.

However, the driver is now responsible to synchronize the CPU cache with
the DMA that bypassed it. On x86 this may be done through the wbinvd
instruction, and the i915 GPU driver is the only Linux DMA driver that
calls it.

The problem comes that KVM on x86 will normally disable the wbinvd
instruction in the guest and render it a NOP. As the driver running in the
guest is not aware the wbinvd doesn't work it may still cause the device
to set the no-snoop bit and the platform will bypass the CPU cache.
Without a working wbinvd there is no way to re-synchronize the CPU cache
and the driver in the VM has data corruption.

Thus, we see a general direction on x86 that the IOMMU HW is able to block
the no-snoop bit in the TLP. This NOP's the optimization and allows KVM to
to NOP the wbinvd without causing any data corruption.

This control for Intel IOMMU was exposed by using IOMMU_CACHE and
IOMMU_CAP_CACHE_COHERENCY, however these two values now have multiple
meanings and usages beyond blocking no-snoop and the whole thing has
become confused. AMD IOMMU has the same feature and same IOPTE bits
however it unconditionally blocks no-snoop.

Change it so that:
 - IOMMU_CACHE is only about the DMA coherence of normal DMAs from a
   device. It is used by the DMA API/VFIO/etc when the user of the
   iommu_domain will not be doing manual cache coherency operations.

 - IOMMU_CAP_CACHE_COHERENCY indicates if IOMMU_CACHE can be used with the
   device.

 - The new optional domain op enforce_cache_coherency() will cause the
   entire domain to block no-snoop requests - ie there is no way for any
   device attached to the domain to opt out of the IOMMU_CACHE behavior.
   This is permanent on the domain and must apply to any future devices
   attached to it.

Ideally an iommu driver should implement enforce_cache_coherency() so that
DMA API domains allow the no-snoop optimization. This leaves it available
to kernel drivers like i915. VFIO will call enforce_cache_coherency()
before establishing any mappings and the domain should then permanently
block no-snoop.

If enforce_cache_coherency() fails VFIO will communicate back through to
KVM into the arch code via kvm_arch_register_noncoherent_dma()
(only implemented by x86) which triggers a working wbinvd to be made
available to the VM.

While other iommu drivers are certainly welcome to implement
enforce_cache_coherency(), it is not clear there is any benefit in doing
so right now.

This is on github: https://github.com/jgunthorpe/linux/commits/intel_no_snoop

Joerg, I think we are ready with this now - if there are no futher
comments I won't resend it unless there is some conflict with rc3. Thanks
everyone!

v3:
 - Rename dmar_domain->enforce_no_snoop to dmar_domain->force_snooping
 - Accumulate acks
 - Rebase to 5.18-rc2
 - Revise commit language
v2: https://lore.kernel.org/r/0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com
 - Abandon removing IOMMU_CAP_CACHE_COHERENCY - instead make it the cap
   flag that indicates IOMMU_CACHE is supported
 - Put the VFIO tests for IOMMU_CACHE at VFIO device registration
 - In the Intel driver remove the domain->iommu_snooping value, this is
   global not per-domain
v1: https://lore.kernel.org/r/0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (4):
  iommu: Introduce the domain op enforce_cache_coherency()
  vfio: Move the Intel no-snoop control off of IOMMU_CACHE
  iommu: Redefine IOMMU_CAP_CACHE_COHERENCY as the cap flag for
    IOMMU_CACHE
  vfio: Require that devices support DMA cache coherence

 drivers/iommu/amd/iommu.c       |  7 +++++++
 drivers/iommu/intel/iommu.c     | 17 +++++++++++++----
 drivers/vfio/vfio.c             |  7 +++++++
 drivers/vfio/vfio_iommu_type1.c | 30 +++++++++++++++++++-----------
 include/linux/intel-iommu.h     |  2 +-
 include/linux/iommu.h           |  7 +++++--
 6 files changed, 52 insertions(+), 18 deletions(-)


base-commit: ce522ba9ef7e2d9fb22a39eb3371c0c64e2a433e
-- 
2.35.1

