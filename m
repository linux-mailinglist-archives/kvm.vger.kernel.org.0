Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA554595CB
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 20:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240250AbhKVT4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 14:56:33 -0500
Received: from mail-dm6nam10on2069.outbound.protection.outlook.com ([40.107.93.69]:37608
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231444AbhKVT4c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 14:56:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ia5Kb4SX7pzYPXDZja/s/YcGvO/MebGMKjydolgoScN3t2/2XY6cwYHvrd6Id2/LQK8Mmko6p2qvdf34CDoIGVnUW/QnXMUWOCfWUT5Rjvy+F46dEBjc5B3psp1tdj6QAtMTJ1I8kmsSH6gPx+AdoRIPFWt8VST+lAAPAgDjixJC+IMQXANUoGHK4+ehTnGMOcICKMbSeLBTjusZ9OmWvEFNME+WFIpWe02Rj7pHoINl4eqOtVPsjO34d9EtlwMG+rrw1PJUll1nFREWhMd+ZHoXDzApsw7ulPPV5iPOzQtnjMDv8gEZRTvNIsMTksnzUUMyGahdfmwbfG1qEe/fGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SwGsl7eBG64wZYeHsgwNmC6ctJatbLadEQvRaCYxbqg=;
 b=apZbHD2sDxK3mwRl2UFJWk7SvPIqroVnl9xxI/3yjwzw2JHOeiyeF/i6x5u7k3NPHc3AN16CyhnrnNIeKkTzYhzbdSIMsvrzvqemLNvUAEFsEdQkyZnt8RS9AFv7+Q67yvXfcAqlvZCMN8ajMjmhKLE+WV+VOND274W+GYHoeTfaIXnJUbyyQru5Ywk0eFDx9PzdSKBs/uGP7NP1eA5IIcOXKSAmiWl5chU//CCxNq4PpffSs0A2USQ11nixg7ZXzebgRO2Od8N/acFLQMHj4EA3yoKyEmKkYQz3w0cP2Kle7wICPdT8l+L4tAUjX9p0M2Jp+a41J9KwXNmfrBw6UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SwGsl7eBG64wZYeHsgwNmC6ctJatbLadEQvRaCYxbqg=;
 b=dUt/AIaTGhajGp9mdDokLxbXWiQ4vllBUxxxbO+u032OlOlzVWlo7zK9tZ65nt+tZa02r5FOcnK0dWhafW7JmSfpcyB8P595qCX9VU4MEvWfiDot+xVY+awKiqDKm1rL6dCtdn73hcQkOXQJr2gyrrouIuJ8+C2dongwyAF+HUPXeKLPF37+h6UhmEo3MF+Llq4UtGL4Ztdc8MtdG5pnty3P2lJwwMwU49K943E8KgHBIXA//ByYa7MQnrbnrwZGfem2rcPZ+rk32ENiSUgKgWWv/KE/Ade/RI1oCmxqyJlMtDX0swJ3dQrstFhrzD5lKvVPQP3gHznEqw3+/5FcoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5077.namprd12.prod.outlook.com (2603:10b6:208:310::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Mon, 22 Nov
 2021 19:53:22 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 19:53:22 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH RFC] vfio: Documentation for the migration region
Date:   Mon, 22 Nov 2021 15:53:21 -0400
Message-Id: <0-v1-0ec87874bede+123-vfio_mig_doc_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0146.namprd03.prod.outlook.com
 (2603:10b6:208:32e::31) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0146.namprd03.prod.outlook.com (2603:10b6:208:32e::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Mon, 22 Nov 2021 19:53:22 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mpFNR-00DxRG-Go; Mon, 22 Nov 2021 15:53:21 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c2c9945-33c8-4624-3e95-08d9adf1bd38
X-MS-TrafficTypeDiagnostic: BL1PR12MB5077:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5077E3AD9F09760933E4CF1BC29F9@BL1PR12MB5077.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ct009zX5gGJcEpBW0ZURPQLxD+DpICE/q77o6A4J7ttqsLfTR+SlkKp5Nt3B6On4VdI8R9UK7FG7r/NMZipDIYiHqAodzevnsv4FP6pXsutkD/MiIxIaQHkYD4050NgozPfrglL4mJHk6xtTzAF/8u8YZTSbEmxAAUjzy9p7dLqzKM00NSkTSvhk8UkBIi/8WJrWJtg+hlnCJ4qVk1+ymHZsJbH0hVktX33hlA9skcxD+LIhysLbeyG5v75gKmrP3QUqJzmG6fYjRqL+yj55POOLsIBdZV3qxBTPhAtO6m0wMlm/OW6xyUICDDgnN4DXziqi1oQMYvDQZA8xIYtIBXfDyWwpeSf5Uu+omkUcICr02Zrgrx41bIyNB0GapM7RSRiEOvgIaTd/Nww07qX487VKOYQ65RSFa23qqD8MgW11llRX6x2AT4TZaHPz9EjXF/dz8rSHLp+E2P4w6zr5FgehWItCOp7hp/2ygsI8rNumlvDxS25IKV0ncZlaXe+FzMb8U1oBXzXi2hK7gLkIULoi4j0zs3Bl+qsucdy+ebEbT4wvg2bAz1gJ9yMsxbJyzVuxyaBvW5b+iDmwz9rHSpNih5ry2cXkwD4Sei5KSnH0mwYuL5YEigcuhmhxvBocalN42L2zlBrkLMZq5NHIM8rIjnww3/bjejV4HgPDR8BsHmKqp1xRhFKSGVsbI+2HVyIPnjBrBgzCQLPRe/eiIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(110136005)(8936002)(54906003)(508600001)(66556008)(8676002)(38100700002)(86362001)(2906002)(316002)(36756003)(9746002)(5660300002)(186003)(9786002)(2616005)(30864003)(4326008)(26005)(83380400001)(426003)(107886003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e9e5CcFFcU3pVb5YOWFYNQoadRToKr/bqXc6LqoQTNhXkk9aBN4R3Qiacc86?=
 =?us-ascii?Q?jL/qfHVXI0VJ9DZeK5uMKFEkfn22IY7NfHUdbc8DqzIhVklZ+pNYexIzkl8g?=
 =?us-ascii?Q?sw+zQT115CnbnsZsDwWKHp4A1xL2L9mGyU1ZyYP1Aj4MxDt7yxryCT2eGNLS?=
 =?us-ascii?Q?fjsJo4tyUy+SllheuG2CuhI6S9o2F5aTIrEzzpJSEfLc9ajBxx/ptyLnqwbi?=
 =?us-ascii?Q?zhSdZESdlk0Y9Yv0ILqbeb+57B1oNUWyLBc9CaFAl3W0sdiym7nNFBcUPmxg?=
 =?us-ascii?Q?mdlehixg4mZSWgkGbcOrC1Jknt47e+ZN88lLcPbR1tVkMhYsEVGF8ounenmd?=
 =?us-ascii?Q?MMSAWF23mWjphicYYaZalFEE/8ubqEVdqqVisLTziUsE0Q9yfSjL5CIJWALC?=
 =?us-ascii?Q?ywNw1mQbISfgSKRt/SQbD7kDKetgXKhFJPF8rWSDUim2Vmx5gLuGO5ThaS5m?=
 =?us-ascii?Q?/Urv3bfwOOoous+SUZFyKpdloHQIFPYdwgimHaeP1W/3LBuWbQ5g45Ux+yCG?=
 =?us-ascii?Q?O505rchKwdyLW0hHIy+dMlRw8ENSQVJcGZjbaCQzhnNMxtH44uelJu8IK3R0?=
 =?us-ascii?Q?MeRAgnH7lk4ZIDowkqARne3nEsW7Ip2GPw8MHVMFBa5W5Hae4uc/3nLMwchb?=
 =?us-ascii?Q?+YLpD+L9d/xKYpAuTBXsprycCh5IX7ULNzoWYNpQOU0WGOI74mek9xRvZXfC?=
 =?us-ascii?Q?31pMpLRa+qaIkysOiK0AAE1QgsaSL0Tr4XIrznfybfPvHmlu3yOZf+c3OXK1?=
 =?us-ascii?Q?6TXp5JMGJg+79/zOi1+mi5RGWsR9kmv9gChEJHJvxXH6CLJx32adfOh7jBUm?=
 =?us-ascii?Q?zPQyF/BhaKK9L4wxSNwNOPi5DhxtEHQzgN/mJ72rdQJgomt7gFyC448q5nEG?=
 =?us-ascii?Q?4gEid3KreNqX0sQkqV/yaaTYyTKz0y0/HX+kOOYcx1G1YeJd2uidCv13rYHl?=
 =?us-ascii?Q?DXyuYA8xQWnlmnBlR4PE8Mfz4aMI4kIIonk6JJsn++jj44oDBj1gVXmH2AqX?=
 =?us-ascii?Q?RwU57mkviW7P5iCtSMidXcHJVXnr/IOaS2JpxtLrf5G+Kb99gd8xaSifTpjU?=
 =?us-ascii?Q?hDCV/bGGntHNzYgxAwLGS7b43YeJrI79gImbobeBss+LkRQBDxeiADwpKwBv?=
 =?us-ascii?Q?GbC6MxNuXl/DD2bidx9RZ6RB/LVx+63kIjkQI2CJC7mIYvw9iBLXpw+L/i0g?=
 =?us-ascii?Q?ZHwsHFM/nbLi+GLBapurLk3DJkETp/8e+kimcg5C8o3njkcqN6Ud18KW6nHU?=
 =?us-ascii?Q?nc+Rjqb1qil3QTxR3HjI1iG88pTO8+Hy7AmRySjbs7Q3EFWPSDRcxqfk8dwz?=
 =?us-ascii?Q?18ozQ9VWNmf0moP7e9cXd+kkrwe/TmcCye1yIL+ZXUv4iK1EWeyAzb/P491t?=
 =?us-ascii?Q?Ld67VkLygj0/vcGe+pqwwdb0CIZlErXYn2sXaMSWM5dFIrEb4vM3ExmupZvT?=
 =?us-ascii?Q?FcxkE83r858KsOPyGm6k4bbaTprioJwQbK7GL1kt1/0PafmDMeWWz6ZdbeMn?=
 =?us-ascii?Q?JjqyF8ZYyrgdLa7H+k+H9FKfwcP1QhnIpuJvsWgmnZwsYSqn7CNJ8UsTepj3?=
 =?us-ascii?Q?hbQjogVR9Kyc9YQKEMY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2c9945-33c8-4624-3e95-08d9adf1bd38
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 19:53:22.4323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XFgmdSF/wmrO8pQxHt+b15CISJuMJpjY836NRfTIMDNVZBtpYib4I7glUxjOI2Nd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide some more complete documentation for the migration region's
behavior, specifically focusing on the device_state bits and the whole
system view from a VMM.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/driver-api/vfio.rst | 208 +++++++++++++++++++++++++++++-
 1 file changed, 207 insertions(+), 1 deletion(-)

Alex/Cornelia, here is the first draft of the requested documentation I promised

We think it includes all the feedback from hns, Intel and NVIDIA on this mechanism.

Our thinking is that NDMA would be implemented like this:

   +#define VFIO_DEVICE_STATE_NDMA      (1 << 3)

And a .add_capability ops will be used to signal to userspace driver support:

   +#define VFIO_REGION_INFO_CAP_MIGRATION_NDMA    6

I've described DIRTY TRACKING as a seperate concept here. With the current
uAPI this would be controlled by VFIO_IOMMU_DIRTY_PAGES_FLAG_START, with our
change in direction this would be per-tracker control, but no semantic change.

Upon some agreement we'll include this patch in the next iteration of the mlx5 driver
along with the NDMA bits.

Thanks,
Jason

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index c663b6f978255b..b28c6fb89ee92f 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -242,7 +242,213 @@ group and can access them as follows::
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
+The device_state triggers device action both when bits are set/cleared and
+continuous behavior for each bit. For VMMs they can also control if the VCPUs in
+a VM are executing (VCPU RUNNING) and if the IOMMU is logging DMAs (DIRTY
+TRACKING). These two controls are not part of the device_state register, KVM
+will be used to control the VCPU and VFIO_IOMMU_DIRTY_PAGES_FLAG_START on the
+container controls dirty tracking.
+
+Along with the device_state the migration driver provides a data window which
+allows streaming migration data into or out of the device.
+
+A lot of flexibility is provided to userspace in how it operates these bits. The
+reference flow for saving device state in a live migration, with all features:
+
+  RUNNING, VCPU_RUNNING
+     Normal operating state
+  RUNNING, DIRTY TRACKING, VCPU RUNNING
+     Log DMAs
+     Stream all memory
+  SAVING | RUNNING, DIRTY TRACKING, VCPU RUNNING
+     Log internal device changes (pre-copy)
+     Stream device state through the migration window
+
+     While in this state repeat as desired:
+	Atomic Read and Clear DMA Dirty log
+	Stream dirty memory
+  SAVING | NDMA | RUNNING, VCPU RUNNING
+     vIOMMU grace state
+     Complete all in progress IO page faults, idle the vIOMMU
+  SAVING | NDMA | RUNNING
+     Peer to Peer DMA grace state
+     Final snapshot of DMA dirty log (atomic not required)
+  SAVING
+     Stream final device state through the migration window
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
+  RUNNING, VCPU RUNNING
+     Normal operating state
+
+If the VMM has multiple VFIO devices undergoing migration then the grace states
+act as cross device synchronization points. The VMM must bring all devices to
+the grace state before advancing past it.
+
+To support these operations the migration driver is required to implement
+specific behaviors around the device_state.
+
+Actions on Set/Clear:
+ - SAVING | RUNNING
+   The device clears the data window and begins streaming 'pre copy' migration
+   data through the window. Device that cannot log internal state changes return
+   a 0 length migration stream.
+
+ - SAVING | !RUNNING
+   The device captures its internal state and begins streaming migration data
+   through the migration window
+
+ - RESUMING
+   The data window is opened and can receive the migration data.
+
+ - !RESUMING
+   All the data transferred into the data window is loaded into the device's
+   internal state. The migration driver can rely on userspace issuing a
+   VFIO_DEVICE_RESET prior to starting RESUMING.
+
+ - DIRTY TRACKING
+   On set clear the DMA log and start logging
+
+   On clear freeze the DMA log and allow userspace to read it. Userspace must
+   take care to ensure that DMA is suspended before clearing DIRTY TRACKING, for
+   instance by using NDMA.
+
+   DMA logs should be readable with an "atomic test and clear" to allow
+   continuous non-disruptive sampling of the log.
+
+Continuous Actions:
+  - NDMA
+    The device is not allowed to issue new DMA operations.
+    Before NDMA returns all in progress DMAs must be completed.
+
+  - !RUNNING
+    The device should not change its internal state. Implies NDMA. Any internal
+    state logging can stop.
+
+  - SAVING | !RUNNING
+    RESUMING | !RUNNING
+    The device may assume there are no incoming MMIO operations.
+
+  - RUNNING
+    The device can alter its internal state and must respond to incoming MMIO.
+
+  - SAVING | RUNNING
+    The device is logging changes to the internal state.
+
+  - !VCPU RUNNING
+    The CPU must not generate dirty pages or issue MMIO operations to devices.
+
+  - DIRTY TRACKING
+    DMAs are logged
+
+  - ERROR
+    The behavior of the device is undefined. The device must be recovered by
+    issuing VFIO_DEVICE_RESET.
+
+In general, userspace can issue a VFIO_DEVICE_RESET ioctl and recover the device
+back to device_state RUNNING. When a migration driver executes this ioctl it
+should discard the data window and set migration_state to RUNNING. This must
+happen even if the migration_state has errored. A freshly opened device FD
+should always be in the RUNNING state.
+
+The migration driver has limitations on what device state it can affect. Any
+device state controlled by general kernel subsystems must not be changed during
+RESUME, and SAVING must tolerate mutation of this state. Change to externally
+controlled device state can happen at any time, asynchronously, to the migration
+(ie interrupt rebalancing).
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
+ones to all incoming MMIO/PIO operations (exclusive of the external state above)
+in !RUNNING. However, devices are free to have undefined behavior if they
+receive MMIOs. This includes corrupting/aborting the migration, dirtying pages,
+and segfaulting userspace.
+
+However, a device may not compromise system integrity if it is subjected to a
+MMIO. It can not trigger an error TLP, it can not trigger a Machine Check, and
+it can not compromise device isolation.
+
+There are several edge cases that userspace should keep in mind when
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
+  device does not support NDMA, and rely on that to guarantee quiet MMIO.
+
+  The P2P Grace States exist so that all devices may reach RUNNING before any
+  device is subjected to a MMIO access.
+
+  Failure to guarentee quiet MMIO may allow a hostile VM to use P2P to violate
+  the no-MMIO restriction during SAVING and corrupt the migration on devices
+  that cannot protect themselves.
+
+- IOMMU Page faults handled in userspace can occur at any time. A migration
+  driver is not required to serialize in-progress page faults. It can assume
+  that all page faults are completed before entering SAVING | !RUNNING. Since
+  the guest VCPU is required to complete page faults the VMM can accomplish this
+  by asserting NDMA | VCPU_RUNNING and clearing all pending page faults before
+  clearing VCPU_RUNNING.
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
+  covered by the DIRTY TRACK function.
+
+- Atomic Read and Clear of the DMA log is a HW feature. If the tracker
+  cannot support this, then NDMA could be used to synthesize it less
+  efficiently.
+
+- NDMA is optional, if the device does not support this then the NDMA States
+  are pushed down to the next step in the sequence and various behaviors that
+  rely on NDMA cannot be used.
+
+TDB - discoverable feature flag for NDMA
+TDB IMS xlation
+TBD PASID xlation
 
 VFIO bus driver API
 -------------------------------------------------------------------------------

base-commit: ae0351a976d1880cf152de2bc680f1dff14d9049
-- 
2.33.1

