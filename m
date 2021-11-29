Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A807461A3E
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 15:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345566AbhK2OvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 09:51:13 -0500
Received: from mail-sn1anam02on2053.outbound.protection.outlook.com ([40.107.96.53]:30786
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232397AbhK2OtM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 09:49:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nu0RZ4AcsDRHeu7P9ZV/Kv0wkZ77V7kf/snJesVpdgzMGX4/qhdlN9LHy1lhJqEXWrCuQdQ8OcFqu5mrWhIIv573pTnLbJWtP1gALISVUBZsItCHWZ8IwBmYZCKPQR2118DQaiNpdcYvtgLMLqd6y513i45H1fGwAbMfXcvTU3yN+RBCBuLTOZf54hRnMLWizsO6SANDIeEIEKNwXON+6jwOBDZFbtQ1YTTRIJwmu7pMaLAs3w9NdoMeimCCpgrdT1wFNsL3h9pLx9eQvmAz2rR4e00dEbDiX5lqPTlk2ZxNyZpVmjq3dK2AJ1qFmoPmrO+IZABum04P2+jOz1SwyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9FVwLYzVSA1t6UWlgMf2oXCl3a3szVlfs/dMe1jg9vo=;
 b=ejR/2vb8qe2emem1e7H/gRxo8ov+EEmY/uROIGd53cRO2x+1w4dgJjUjLJqkgaJuJrSgsVAHOwX8ulVYjTHUCwpeU/uUYzslO5Pzo3f/ctI+94R5OllAx/IoVSG2xBRZVC+Njwqi4frRgk02uov79vAJgGFF+XUFeOxxecUAmEmDCl56aDA9IHDK/UfTHePlzSTaY0RlM2ktA+Pe12qysP2rEbL71B81dma81CgS4m7vpbNn4D84C31OHJWLApwKjRuSCAi27AAwvQYlMWyeB8aoCQYvAk7U+I+AaCxaC/yZ3/+4ZNEExjI+Q9OT4oU27B7bz615VOIgcfCQOvntwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9FVwLYzVSA1t6UWlgMf2oXCl3a3szVlfs/dMe1jg9vo=;
 b=kZvm18Xad4YgNVmMi+F0HnyQatuVgvX+dBoQ1UvUiL3kqxcBD5NS2AI0xl+/l0O8aXX3tlOmlz4HrCEgI8H+xmltqlS003Avw5ej5r6FoUYACMQno/nMK389aTohKMZ28C+5d3WE/rFKWr9BLPgjHC/lE8XyCzBWm5Gj7b8BcblJXexiv/amT9keSmXA+CqEWoU+jyjB2Fp9FHic2fDImEF2t/8biFJ//zpKS9dEYouKHOdhoF0lqDROtw81qykut0kxlJRJQrLrpqPBsiyq8Hlpz4X9+UmwmgcXj8OiUkKXRaK9IFR9AW5hPQIs0tX2HHvxmHEgh/n5Q3WkqyX2BA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5319.namprd12.prod.outlook.com (2603:10b6:208:317::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Mon, 29 Nov
 2021 14:45:53 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%8]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 14:45:53 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH RFC v2] vfio: Documentation for the migration region
Date:   Mon, 29 Nov 2021 10:45:52 -0400
Message-Id: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0035.namprd02.prod.outlook.com
 (2603:10b6:207:3c::48) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR02CA0035.namprd02.prod.outlook.com (2603:10b6:207:3c::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24 via Frontend Transport; Mon, 29 Nov 2021 14:45:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mrhui-004H0z-9P; Mon, 29 Nov 2021 10:45:52 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d438ee9e-4ca8-4337-d66e-08d9b346f190
X-MS-TrafficTypeDiagnostic: BL1PR12MB5319:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53199768662F7AC70745CDBCC2669@BL1PR12MB5319.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cb0cv7UARvMkjPPhjwBpy6+Agrid7piDgGf08Z8Dc5H3BZsZguW+x1HmYZSkZnZoeXhBxUPf+lH8J5PTrMahuW7+LI3/odswhEnvFNMRIgHXBhKS3eR+ET8T9lDRNoz/u0J5ImI2qQX6Nyww8eoLGvq1HR2QDKsvvzsBltOkZDHs4l+Eue+0HSDAojjEIDJNcVaWKBOagga0DXjJcbKhn7EUdsmfBZ1kvgc9exKUnMLEXGzQEISsgAE/ri8rPcVm9bOOPKPSjlEmpSnp2eqqolLqzhLA0SlT1Yv0H/sAXETBd+YLz7JsPMTW4JakiPZcZwadC7AdtVdVIV+PO66yuMSNLaARnG/IHZXN/iMENtEQIpP/VpZrTCSquHvM3ZrMg/B1mfgYDpuubykjnBCdQECHewLcnIg274ygm+zH26+b8iusVRLUIHEaOi4ArGu0Kukpm7RyV59heGh49DqflpgtnU/L01VfpDPXXCop2mCT+MxglGjt/1E0jEAMXKSMkYNseipwLOETCLHMVH79MteEc/Yl61ZkjMcjAOUS/06Nq3+/qOIcWge8e+By6Z/cFeWjZXqkt+mEuPdfYnhsUle5mDISVjwkRlpZIj74RxTUmsXrRyxxH1z6qUZ/LpSGAZWqIsQ9SZiDScrbDQpuePKMwvAUWh6RL+lbuZ3UCvOVkuosKKfUaGxSYjoHnPIut/i6WskCJ5tZoONchI1pSDru9pCto8Q2g3JIxTeFzRbqSs4ofKwrnaHTuSCYrk1MyhDNbRMlwH4kzJVR9k/pbXreFoodxVx8ibDcGT1jFcg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(30864003)(26005)(66556008)(66476007)(66946007)(9746002)(38100700002)(9786002)(8936002)(316002)(508600001)(36756003)(186003)(8676002)(4326008)(86362001)(5660300002)(107886003)(2906002)(54906003)(426003)(2616005)(110136005)(966005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9oyc0BsHROv5qPBUfI2VFwetKHshJ9oy/pZzIvJRsmSjwGaYIs1MCeKqkbjO?=
 =?us-ascii?Q?0hviS9D7apbEMsWm/mbtRH5JI8fztwyC/Hnup+6Osx6YZM1vGXKfQZKJcJ3l?=
 =?us-ascii?Q?CcOQydRc4Q4Xf6tc4sFF5e1IBAUDZIaSL+Lydt1iHZzOMyq0vJmXBfVUXSiC?=
 =?us-ascii?Q?5TfTHxe4qyVf14mJ+6aDBZLtSfLLxZyrZ19MlQABNVNAYyEcpTIQ/lUZb7e8?=
 =?us-ascii?Q?rK6ID2sQdYf4d+5XYoHL8R+15KwZPiFChv5Vm6lcLADHjBvpDcVsR+Efdvk+?=
 =?us-ascii?Q?JdWec4VwQbXmHpAz0jmiCsEj5YIKymY4xR/yRI8TSl3iza4j7y1hY0PrLeo9?=
 =?us-ascii?Q?n+YARYvFW+ri4TgbLQWoe0qOYe4Z0xzk2cxkENc7bHcmmHLwKb364aajg65o?=
 =?us-ascii?Q?BTkVyd/sGY/QvVh++csaDHbFsYvmcLb1jo/zDo1sRbytgCox/M7wJf6ATHr1?=
 =?us-ascii?Q?5+ymx6rJvGhjLP17u+W+0PvKjK9wwrJBqsyqCzRMJ47GvAtXHwyXHL52Tj0h?=
 =?us-ascii?Q?j3LvmRhuwj2mWupOPUG7j5+80xRo6gHO61XlaFROKg6IYrTs2xudyjFgBZg8?=
 =?us-ascii?Q?8ne3yXIXkeGobQ22ULU5JpLgrwNyoeVYT3cHmXIEkxXuAmSuYOPa5mwfz1U9?=
 =?us-ascii?Q?d+ZI6vwl6xlLMFhvtEfrP+uwpBETps2QprIXTrapELmSmJjSiiBTN8kb46d+?=
 =?us-ascii?Q?sAsvk3qEDE1awk509J/KzbNGndKDc6Vj0MhCHgKhKh5jyxvDVfnBu8KPvUbf?=
 =?us-ascii?Q?CAhSrwFdIbF8pSfTx3Bp7wVjWa3MDMGzbUT3aessh1RaF9PgvQJ2uTd9wkWP?=
 =?us-ascii?Q?eqzaTiJG7VceqVWb/7jqcPIHU1b3e3ZQF9g6aEMK5jPscOakZkw2QJwO049l?=
 =?us-ascii?Q?0xT7H46scWxuhRXVYfM6VePWON4YYj1/C6Vw43Bhddigy9E4FL83jbDiN1nt?=
 =?us-ascii?Q?YZZKD8sdqji5RLTRYhAtW3UDfQwJQLVLE4AomXJ4icLyKorwEXlT0mORXl5M?=
 =?us-ascii?Q?/r4/V4DBDFuKiu/EYPrVMT3D+uI+BzRlB9Dcb0mmGTwlr7osTE4NwiAZdMfL?=
 =?us-ascii?Q?lvBOpK/24Uj6NPoyypsDR9USY2ZeSw3FM7HvdvdGfd7lfPduXLT8fel/3M0B?=
 =?us-ascii?Q?NVLbCV61uLaLK9ICjBYe/qwrdKkfXvRfljY4Lqbn/fi6RTOGTwGJJSIYaX10?=
 =?us-ascii?Q?ACs3dQnzJfs1vbfa+ZWviDineReAfBdskOYhmu5PamF+cVSMYfM0RIdD2jJu?=
 =?us-ascii?Q?lIMq5DRjRoMOoAEDvgLBr71RPtIpvV8CwAAl+oFTlKFSFjVpOV55IsmklmHu?=
 =?us-ascii?Q?6WVY9DYAbUzZhOSPrEAti4/A0sSE5PO0a4RBaz4eai0QrPwP8ywbh8gtbBrP?=
 =?us-ascii?Q?ANow+b0k/C27/4Zdk5r4mU3RIQOtIi7QxlCtvEsBMHGb0X87nlLhGqMGECVJ?=
 =?us-ascii?Q?4D6leMbqvonsfpNclH2PHP7AOq/ON5NzVx4MyKBp763dx+J/Tisy5isWZ5hu?=
 =?us-ascii?Q?O6kWUMBADbQQrEWDGP+4qFePpNjt9NUe7PdxjxgwCdxSn6nmUJOls5CMzqId?=
 =?us-ascii?Q?czUxMpg8wwShVszLzfo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d438ee9e-4ca8-4337-d66e-08d9b346f190
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 14:45:53.3351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LmMdfsSrCikzzLYzwVk1Bh2GgG75VL+eivZ/zP95tKTbhx8oRJd27gix+ZDNxdG2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5319
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide some more complete documentation for the migration regions
behavior, specifically focusing on the device_state bits and the whole
system view from a VMM.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/driver-api/vfio.rst | 277 +++++++++++++++++++++++++++++-
 1 file changed, 276 insertions(+), 1 deletion(-)

Alex/Cornelia, here is the second draft of the requested documentation I promised

We think it includes all the feedback from hns, Intel and NVIDIA on this mechanism.

Our thinking is that NDMA would be implemented like this:

   +#define VFIO_DEVICE_STATE_NDMA      (1 << 3)

And a .add_capability ops will be used to signal to userspace driver support:

   +#define VFIO_REGION_INFO_CAP_MIGRATION_NDMA    6

I've described DIRTY TRACKING as a seperate concept here. With the current
uAPI this would be controlled by VFIO_IOMMU_DIRTY_PAGES_FLAG_START, with our
change in direction this would be per-tracker control, but no semantic change.

Upon some agreement we'll include this patch in the next iteration of the mlx5
driver along with the NDMA bits.

v2:
 - RST fixups for sphinx rendering
 - Inclue the priority order for multi-bit-changes
 - Add a small discussion on devices like hns with migration control inside
   the same function as is being migrated.
 - Language cleanups from v1, the diff says almost every line was touched in some way
v1: https://lore.kernel.org/r/0-v1-0ec87874bede+123-vfio_mig_doc_jgg@nvidia.com

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index c663b6f978255b..d9be47570f878c 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -242,7 +242,282 @@ group and can access them as follows::
 VFIO User API
 -------------------------------------------------------------------------------
 
-Please see include/linux/vfio.h for complete API documentation.
+Please see include/uapi/linux/vfio.h for complete API documentation.
+
+-------------------------------------------------------------------------------
+
+VFIO migration driver API
+-------------------------------------------------------------------------------
+
+VFIO drivers that support migration implement a migration control register
+called device_state in the struct vfio_device_migration_info which is in its
+VFIO_REGION_TYPE_MIGRATION region.
+
+The device_state controls both device action and continuous behavior.
+Setting/clearing bit groups triggers device action, and each bit controls a
+continuous device behavior.
+
+Along with the device_state the migration driver provides a data window which
+allows streaming migration data into or out of the device.
+
+A lot of flexibility is provided to user-space in how it operates these
+bits. What follows is a reference flow for saving device state in a live
+migration, with all features, and an illustration how other external non-VFIO
+entities (VCPU_RUNNING and DIRTY_TRACKING) the VMM controls fit in.
+
+  RUNNING, VCPU_RUNNING
+     Normal operating state
+  RUNNING, DIRTY_TRACKING, VCPU_RUNNING
+     Log DMAs
+
+     Stream all memory
+  SAVING | RUNNING, DIRTY_TRACKING, VCPU_RUNNING
+     Log internal device changes (pre-copy)
+
+     Stream device state through the migration window
+
+     While in this state repeat as desired:
+
+	Atomic Read and Clear DMA Dirty log
+
+	Stream dirty memory
+  SAVING | NDMA | RUNNING, VCPU_RUNNING
+     vIOMMU grace state
+
+     Complete all in progress IO page faults, idle the vIOMMU
+  SAVING | NDMA | RUNNING
+     Peer to Peer DMA grace state
+
+     Final snapshot of DMA dirty log (atomic not required)
+  SAVING
+     Stream final device state through the migration window
+
+     Copy final dirty data
+  0
+     Device is halted
+
+and the reference flow for resuming:
+
+  RUNNING
+     Issue VFIO_DEVICE_RESET to clear the internal device state
+  0
+     Device is halted
+  RESUMING
+     Push in migration data. Data captured during pre-copy should be
+     prepended to data captured during SAVING.
+  NDMA | RUNNING
+     Peer to Peer DMA grace state
+  RUNNING, VCPU_RUNNING
+     Normal operating state
+
+If the VMM has multiple VFIO devices undergoing migration then the grace
+states act as cross device synchronization points. The VMM must bring all
+devices to the grace state before advancing past it.
+
+The above reference flows are built around specific requirements on the
+migration driver for its implementation of the migration_state input.
+
+The migration_state cannot change asynchronously, upon writing the
+migration_state the driver will either keep the current state and return
+failure, return failure and go to ERROR, or succeed and go to the new state.
+
+Event triggered actions happen when user-space requests a new migration_state
+that differs from the current migration_state. Actions happen on a bit group
+basis:
+
+ SAVING | RUNNING
+   The device clears the data window and begins streaming 'pre copy' migration
+   data through the window. Devices that cannot log internal state changes
+   return a 0 length migration stream.
+
+ SAVING | !RUNNING
+   The device captures its internal state that is not covered by internal
+   logging, as well as any logged changes.
+
+   The device clears the data window and begins streaming the captured
+   migration data through the window. Devices that cannot log internal state
+   changes stream all their device state here.
+
+ RESUMING
+   The data window is cleared, opened, and can receive the migration data
+   stream.
+
+ !RESUMING
+   All the data transferred into the data window is loaded into the device's
+   internal state. The migration driver can rely on user-space issuing a
+   VFIO_DEVICE_RESET prior to starting RESUMING.
+
+   To abort a RESUMING issue a VFIO_DEVICE_RESET.
+
+   If the migration data is invalid then the ERROR state must be set.
+
+Continuous actions are in effect when migration_state bit groups are active:
+
+ RUNNING | NDMA
+   The device is not allowed to issue new DMA operations.
+
+   Whenever the kernel returns with a migration_state of NDMA there can be no
+   in progress DMAs.
+
+ !RUNNING
+   The device should not change its internal state. Further implies the NDMA
+   behavior above.
+
+ SAVING | !RUNNING
+   RESUMING | !RUNNING
+   The device may assume there are no incoming MMIO operations.
+
+   Internal state logging can stop.
+
+ RUNNING
+   The device can alter its internal state and must respond to incoming MMIO.
+
+ SAVING | RUNNING
+   The device is logging changes to the internal state.
+
+ ERROR
+   The behavior of the device is largely undefined. The device must be
+   recovered by issuing VFIO_DEVICE_RESET or closing the device file
+   descriptor.
+
+   However, devices supporting NDMA must behave as though NDMA is asserted
+   during ERROR to avoid corrupting other devices or a VM during a failed
+   migration.
+
+When multiple bits change in the migration_state they may describe multiple
+event triggered actions, and multiple changes to continuous actions.  The
+migration driver must process them in a priority order:
+
+ - SAVING | RUNNING
+ - NDMA
+ - !RUNNING
+ - SAVING | !RUNNING
+ - RESUMING
+ - !RESUMING
+ - RUNNING
+ - !NDMA
+
+In general, userspace can issue a VFIO_DEVICE_RESET ioctl and recover the
+device back to device_state RUNNING. When a migration driver executes this
+ioctl it should discard the data window and set migration_state to RUNNING as
+part of resetting the device to a clean state. This must happen even if the
+migration_state has errored. A freshly opened device FD should always be in
+the RUNNING state.
+
+The migration driver has limitations on what device state it can affect. Any
+device state controlled by general kernel subsystems must not be changed
+during RESUME, and SAVING must tolerate mutation of this state. Change to
+externally controlled device state can happen at any time, asynchronously, to
+the migration (ie interrupt rebalancing).
+
+Some examples of externally controlled state:
+ - MSI-X interrupt page
+ - MSI/legacy interrupt configuration
+ - Large parts of the PCI configuration space, ie common control bits
+ - PCI power management
+ - Changes via VFIO_DEVICE_SET_IRQS
+
+During !RUNNING, especially during SAVING and RESUMING, the device may have
+limitations on what it can tolerate. An ideal device will discard/return all
+ones to all incoming MMIO, PIO, or equivalent operations (exclusive of the
+external state above) in !RUNNING. However, devices are free to have undefined
+behavior if they receive incoming operations. This includes
+corrupting/aborting the migration, dirtying pages, and segfaulting user-space.
+
+However, a device may not compromise system integrity if it is subjected to a
+MMIO. It cannot trigger an error TLP, it cannot trigger an x86 Machine Check
+or similar, and it cannot compromise device isolation.
+
+There are several edge cases that user-space should keep in mind when
+implementing migration:
+
+- Device Peer to Peer DMA. In this case devices are able issue DMAs to each
+  other's MMIO regions. The VMM can permit this if it maps the MMIO memory into
+  the IOMMU.
+
+  As Peer to Peer DMA is a MMIO touch like any other, it is important that
+  userspace suspend these accesses before entering any device_state where MMIO
+  is not permitted, such as !RUNNING. This can be accomplished with the NDMA
+  state. Userspace may also choose to remove MMIO mappings from the IOMMU if the
+  device does not support NDMA and rely on that to guarantee quiet MMIO.
+
+  The Peer to Peer Grace States exist so that all devices may reach RUNNING
+  before any device is subjected to a MMIO access.
+
+  Failure to guarantee quiet MMIO may allow a hostile VM to use P2P to violate
+  the no-MMIO restriction during SAVING or RESUMING and corrupt the migration
+  on devices that cannot protect themselves.
+
+- IOMMU Page faults handled in user-space can occur at any time. A migration
+  driver is not required to serialize in-progress page faults. It can assume
+  that all page faults are completed before entering SAVING | !RUNNING. Since
+  the guest VCPU is required to complete page faults the VMM can accomplish
+  this by asserting NDMA | VCPU_RUNNING and clearing all pending page faults
+  before clearing VCPU_RUNNING.
+
+  Device that do not support NDMA cannot be configured to generate page faults
+  that require the VCPU to complete.
+
+- pre-copy allows the device to implement a dirty log for its internal state.
+  During the SAVING | RUNNING state the data window should present the device
+  state being logged and during SAVING | !RUNNING the data window should present
+  the unlogged device state as well as the changes from the internal dirty log.
+
+  On RESUME these two data streams are concatenated together.
+
+  pre-copy is only concerned with internal device state. External DMAs are
+  covered by the separate DIRTY_TRACKING function.
+
+- Atomic Read and Clear of the DMA log is a HW feature. If the tracker
+  cannot support this, then NDMA could be used to synthesize it less
+  efficiently.
+
+- NDMA is optional. If the device does not support this then the NDMA States
+  are pushed down to the next step in the sequence and various behaviors that
+  rely on NDMA cannot be used.
+
+- Migration control registers inside the same iommu_group as the VFIO device.
+  This immediately raises a security concern as user-space can use Peer to Peer
+  DMA to manipulate these migration control registers concurrently with
+  any kernel actions.
+
+  A device driver operating such a device must ensure that kernel integrity
+  cannot be broken by hostile user space operating the migration MMIO
+  registers via peer to peer, at any point in the sequence. Notably the kernel
+  cannot use DMA to transfer any migration data.
+
+  However, as discussed above in the "Device Peer to Peer DMA" section, it can
+  assume quiet MMIO as a condition to have a successful and uncorrupted
+  migration.
+
+To elaborate details on the reference flows, they assume the following details
+about the external behaviors:
+
+ !VCPU_RUNNING
+   User-space must not generate dirty pages or issue MMIO, PIO or equivalent
+   operations to devices.  For a VMM this would typically be controlled by
+   KVM.
+
+ DIRTY_TRACKING
+   Clear the DMA log and start DMA logging
+
+   DMA logs should be readable with an "atomic test and clear" to allow
+   continuous non-disruptive sampling of the log.
+
+   This is controlled by VFIO_IOMMU_DIRTY_PAGES_FLAG_START on the container
+   fd.
+
+ !DIRTY_TRACKING
+   Freeze the DMA log, stop tracking and allow user-space to read it.
+
+   If user-space is going to have any use of the dirty log it must ensure that
+   all DMA is suspended before clearing DIRTY_TRACKING, for instance by using
+   NDMA or !RUNNING on all VFIO devices.
+
+
+TDB - discoverable feature flag for NDMA
+TDB IMS xlation
+TBD PASID xlation
 
 VFIO bus driver API
 -------------------------------------------------------------------------------

base-commit: ae0351a976d1880cf152de2bc680f1dff14d9049
-- 
2.34.0

