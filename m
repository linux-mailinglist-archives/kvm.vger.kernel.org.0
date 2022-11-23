Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A89636925
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 19:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239359AbiKWSmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 13:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239595AbiKWSmD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 13:42:03 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026C27EBEE
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 10:42:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8Em13sRhVsQcoi4tkd9yw9W/lS/6UOxsA8r6V8oCG7JacJdtH2kSCpJAIqEr0jV2e7oD8OW5ypHRgmBH0iIIYmqCSh+6kzcs1oLBmI/ey+tFWXa039ns69NBDKBp1kMCBcEL6rkpncleW01eGSFUIlEiIXpBPR+ANAjGUqKOSWxEAyZuEftQhp0iEFzlbjEwYtlrrMHsG8X+m4XBQmlIH8zr6/61UugyeI5NUpz2YMEHv2Tvitym25j/ov6NoFKVrzPLWYIb32q4oJ9v+YcNRiGwwi0mHw3QH8VR5YiMHoViYBmZubzifKjSbk3wY0OVE1Ek2vkDzhc/CBsOJEGUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1LMrfnPrY0450IcnzmQR1sNjB9AGxcIYcngya9+T+zk=;
 b=hBGneuxeYi9SPQd68v66hWqvAfkP0FXeDWrwZv9G74mRuGbYDbghtLfYBKBkzBqBrcCy4Ceb2gMMRJLfH7xMOZXZ1vXG/2NVQ4kai0GNnsbjBXsH+VEe/xQlezb6x4kogL6wPmVzdxU0xRIm9gjf1CMWY3AMOhMYCYARTMf4ZFSXWcJRN0sqqzQrdPbrmVkCFv2VqViJ4PFJC+y6NmCAYmQdu/vezfHGHqgE16CZs2LL4LNdZwRLSV7ddvkPKFrwS5sMLWzBI5s4PjMGzNR8lqeXpw+y7PC0EBRXN5al2WHiJcVbSq2n2usnPc+noo5R17mqP2Ufd0zTLa29z1Dyhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1LMrfnPrY0450IcnzmQR1sNjB9AGxcIYcngya9+T+zk=;
 b=h++nZeF3ZXMJpKx0qkOAvIYSih9VhWH7l37DTXDGLYHkMjIf+AJjj6O0nYgeE1VqdvIo5nmuAsz5D7hFii1t0dgIXVnVwyBnZAFbNx6fAWI7dm20y4hb07WjlWd2+BprHT8gRzFqS+evDTlaZYCcizQR6M5SBvEFq7+9XmsofrWEodOJHVcMJYIrcgyIGSqGGSNsPUSyfUvnfhvzGTkb27M4m1Ry3ZwRKkT4vWhRWDIRJXRUv7NNqltXtSYtBkM2B/5QbPj8FV3V52US0ZgGBz5oYhp+oGkXYyPygitZVwypdOnaRMq3Gt0HUeYKuBzGxCMEy7o4E3+qzaBwx/X0Vw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB8026.namprd12.prod.outlook.com (2603:10b6:806:34b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 18:42:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 18:42:00 +0000
Date:   Wed, 23 Nov 2022 14:41:58 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        eric.auger@redhat.com, cohuck@redhat.com, nicolinc@nvidia.com,
        yi.y.sun@linux.intel.com, chao.p.peng@linux.intel.com,
        mjrosato@linux.ibm.com, kvm@vger.kernel.org
Subject: Re: [RFC 00/10]  Move group specific code into group.c
Message-ID: <Y35pdp/PqA2TMx9w@nvidia.com>
References: <20221123150113.670399-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123150113.670399-1-yi.l.liu@intel.com>
X-ClientProxiedBy: BLAP220CA0015.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB8026:EE_
X-MS-Office365-Filtering-Correlation-Id: a7d58731-cc45-4b5a-5c33-08dacd8267e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RGLZiMER7orzdoOpfLWDIqw4XFXM/ebS3Y3M04ghxqLFowkGZyX9CeAc9x4DwULl83AXd/cN3jfYJ/F+F4uekRU0g/hOcjF3/x36BOCEq8Vs5nMoaVT9r/GoiCq+wz8jxpvz54PTzljF16cB0siRBjD8ZhKFD0cvxr6nKqH3JKg31MLdWfxrPvSmzUR0N5GyiYeO4uisnUN8p/FTjD4mOFTAORKfpgt8voBJZhU6be5FSsBGH8Xa0OvM2ZGEm0ZTcgqDoXlay8rYLubmrS1CxhGCAc+mYgxXoQtqb3VrvObQwDCe750b0nMaxAjNSIhQ5Mbocm3sxIbuusG2sguwy80h01KwdT0GBRFn6dH+gBJketRiq2rogK2NCcksg0R95I1x1DgbpxXUQuMYybb0v0P2HOUFIislZDEsZ0I2+q0EyPIyVmVJhfku56Zu7vvU8KYI2Ahclw4b4xl+SULrPw3uuz/L4M083Bz7iczk/qhom5ZWEfcBCNYNHJAimVyl+ysk97MhohlUcDOLD1OaaqRegarE8+LmHWvEeDcAQwlKWxTMTIlQbBGhqB8DciOEtpykDYGNnv1ksXhBDAncCK/+7L5e4Cfj0qQauREadWKHnVT840K+vpnuWtKdSzxM13rwWhjEs+rIjAezPfo+jg9BPGckmV5q4LgDdEUlKeEfOdd+XgTNBaz983xsHg79nUHAGepAS80NF0i4vrtAwTe4NaIYRgswOyJa5NoCwI826klII/3zq6zHvzr10BhKd317ZMfYsNbH3StExOpT4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(86362001)(36756003)(41300700001)(2616005)(8936002)(478600001)(186003)(5660300002)(2906002)(316002)(30864003)(6512007)(6916009)(6506007)(66946007)(66476007)(8676002)(66556008)(4326008)(26005)(38100700002)(6486002)(83380400001)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OQCtSuyMrIQ/83t7FdNjAfjqK3xY4Ce+BsUc2ijcCMawVMpwAHTU+IgpOWvr?=
 =?us-ascii?Q?+STRvcz9Ge7X/OYsXh5+TDJPSKAJEzDhLv06t60ZunJaLE4LPnU2LnXOJ5/c?=
 =?us-ascii?Q?DJfF9W4LbgWgwgTp1CG568Fl5GCgabXVoXBIMFs/gZ8iha1AZP8wOTnlSKom?=
 =?us-ascii?Q?zihdyey4UsSO7/j3e1eU60acB2eoYS5td+z+g2lNdEVDtcJG2dUrqsW/uE9j?=
 =?us-ascii?Q?NyIIsfVEbhWISUorravUCUEbVDu/qt1Wr09TdVFwVyDG7wViySpR8PO9nslu?=
 =?us-ascii?Q?iofY0ZerW7QyxiA5+BdXVyKyakrfsw9nAy+LU2l4u+8FwmubNyXvktnUXk9c?=
 =?us-ascii?Q?Y8slgZVI+ucdF2Xi2/2FKvvRc0y2s79L7O5hKo9DX4RwaENj0wAx65p12c+S?=
 =?us-ascii?Q?Gblo9an0HhYJmGRGMEVkiKQSrtgoKi3oaHGXUT0yBT9xLOYyIqmQYzWHNAUS?=
 =?us-ascii?Q?vuDfpcKglQvPWerC9mPsi1O/nUYDB+k55IW7VGjQN2n04+6w0YIhCXXlQhfN?=
 =?us-ascii?Q?Qv2SywYIm9D2OmhDXZ0sqEoXCnGLXNUym0p7T0AYNP2tSEQMn1m+N4XqNWpW?=
 =?us-ascii?Q?RdXa+8I+aXdq6Qow28Kny8fPh3ZQYIztoyxjNXvcvGBbtqAPYSjf3WCwv47v?=
 =?us-ascii?Q?kNSRG7dL9adKvDYmYnbUH9EeE6eXI2ZutUQZOnKLJ0Mvi01HxSpBtvBGt0FU?=
 =?us-ascii?Q?+eHcPOJN/cJzjhgldzi5aIp4P8ZhVgtQ2Sy/IAepoWiguf50E2Yvx7blbJH0?=
 =?us-ascii?Q?LYW+LXJR9CPK5fBtGIq3pksX8K/oV89I05TpzIlyPLNF1WrLPb9orLi2Oj/N?=
 =?us-ascii?Q?5KaAfV86EYWpSboL6XpfpzU2QyMT9GUNsjChWWQaz51MaSiXQo55HFuEqZiQ?=
 =?us-ascii?Q?hTlAoB0EfUydXzA7kTtoGS9/evQnXuEuYI/U+BE473fPXyCP4JX4k67/ojfO?=
 =?us-ascii?Q?wiKiem86Z8qYE7h9RTJTpcXXjaU1QRMUvwgqIkCgpNMPq6c1iLtTfNO7LWHg?=
 =?us-ascii?Q?Hlfv3dJD3xVw2lG3gdfrcTPEE7JnhACMvtqd0igeOQmBq4GFN+C1nqZezN+R?=
 =?us-ascii?Q?K/PSCIDbk+acTM9zl8xzo2QMbpDe5SzMfJ3tqI0RccI3VpuPI9LmJocCWUmZ?=
 =?us-ascii?Q?OsIiYSzHafS8OAumznNZO5nvH3d0GuE7DoTWCti5WI1NM/UiVNQRDc8I5z+s?=
 =?us-ascii?Q?6hNJFjwnhKIK3J4KVPRYR4NwmGn1FXLooZFlq4IQnFKe0tqIHnSdDaN3MEGH?=
 =?us-ascii?Q?yc1lS3qCXc7k6hyPWAtSB4KqIRqpcfnNPozaBZ6p1vYV6DE0d2JwnebO8dDy?=
 =?us-ascii?Q?fdzZ0iKL8NhR8eaPVlL39bvDmwdil9TNZlDlPeWVGA6JIuAD8oSl0SQoStb3?=
 =?us-ascii?Q?DI1jhmDyNuuDV7+dGULPv38/jPN7K7UIsMhXcgXyMFC1xpLeMNxub2yLBedT?=
 =?us-ascii?Q?zjQC+USWAWoujiPYR+ao4ioXTa1JxSJC+djOAaM9Lit07R6z3mWSLjEQTEKW?=
 =?us-ascii?Q?kGyau+u8MMg2RX5axSOmubsIIay2+udwcmErcTTMJVt5nlJIUS/zEjhxCrjW?=
 =?us-ascii?Q?LRmIFtBADYLxyZzCYB0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d58731-cc45-4b5a-5c33-08dacd8267e5
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 18:42:00.0435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oBBM3Sq92fEuVE7txYVlT7PA6UjA2eu4IDaLYHgP8raMDG2Q6HY678ABc1Q31PPc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8026
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022 at 07:01:03AM -0800, Yi Liu wrote:
> With the introduction of iommufd[1], VFIO is towarding to provide device
> centric uAPI after adapting to iommufd. With this trend, existing VFIO
> group infrastructure is optional once VFIO converted to device centric.
> 
> This series moves the group specific code out of vfio_main.c, prepares
> for compiling group infrastructure out after adding vfio device cdev[2]
> 
> Complete code in below branch:
> 
> https://github.com/yiliu1765/iommufd/commits/vfio_group_split_rfcv1
> 
> This is based on Jason's "Connect VFIO to IOMMUFD"[3] and my "Make mdev driver
> dma_unmap callback tolerant to unmaps come before device open"[4]
> 
> [1] https://lore.kernel.org/all/0-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com/
> [2] https://github.com/yiliu1765/iommufd/tree/wip/vfio_device_cdev
> [3] https://lore.kernel.org/kvm/063990c3-c244-1f7f-4e01-348023832066@intel.com/T/#t
> [4] https://lore.kernel.org/kvm/20221123134832.429589-1-yi.l.liu@intel.com/T/#t

I looked at this for a while, I think you should squish the below into
the series too.

A good goal is to make it so we can compile out vfio_device::group
entirely when group.c is disabled. This makes the compile time
checking stronger (adjust the cdev patch to do this). It means
removing all device->group references from vfio_main.c, which the
below does:

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index d8ef098c1f74a6..3a69839c65ff75 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -476,8 +476,8 @@ void vfio_device_remove_group(struct vfio_device *device)
 	put_device(&group->dev);
 }
 
-struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
-					    enum vfio_group_type type)
+static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
+						   enum vfio_group_type type)
 {
 	struct iommu_group *iommu_group;
 	struct vfio_group *group;
@@ -526,7 +526,7 @@ static bool vfio_group_has_device(struct vfio_group *group, struct device *dev)
 	return false;
 }
 
-struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
+static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 {
 	struct iommu_group *iommu_group;
 	struct vfio_group *group;
@@ -577,6 +577,22 @@ struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
 	return group;
 }
 
+int vfio_device_set_group(struct vfio_device *device, enum vfio_group_type type)
+{
+	struct vfio_group *group;
+
+	if (type == VFIO_IOMMU)
+		group = vfio_group_find_or_alloc(device->dev);
+	else
+		group = vfio_noiommu_group_alloc(device->dev, type);
+	if (IS_ERR(group))
+		return PTR_ERR(group);
+
+	/* Our reference on group is moved to the device */
+	device->group = group;
+	return 0;
+}
+
 void vfio_device_group_register(struct vfio_device *device)
 {
 	mutex_lock(&device->group->device_lock);
@@ -632,8 +648,10 @@ void vfio_device_group_unuse_iommu(struct vfio_device *device)
 	mutex_unlock(&device->group->group_lock);
 }
 
-struct kvm *vfio_group_get_kvm(struct vfio_group *group)
+struct kvm *vfio_device_get_group_kvm(struct vfio_device *device)
 {
+	struct vfio_group *group = device->group;
+
 	mutex_lock(&group->group_lock);
 	if (!group->kvm) {
 		mutex_unlock(&group->group_lock);
@@ -643,24 +661,8 @@ struct kvm *vfio_group_get_kvm(struct vfio_group *group)
 	return group->kvm;
 }
 
-void vfio_group_put_kvm(struct vfio_group *group)
-{
-	mutex_unlock(&group->group_lock);
-}
-
-void vfio_device_group_finalize_open(struct vfio_device *device)
+void vfio_device_put_group_kvm(struct vfio_device *device)
 {
-	mutex_lock(&device->group->group_lock);
-	if (device->group->container)
-		vfio_device_container_register(device);
-	mutex_unlock(&device->group->group_lock);
-}
-
-void vfio_device_group_abort_open(struct vfio_device *device)
-{
-	mutex_lock(&device->group->group_lock);
-	if (device->group->container)
-		vfio_device_container_unregister(device);
 	mutex_unlock(&device->group->group_lock);
 }
 
@@ -779,9 +781,9 @@ bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_file_has_dev);
 
-bool vfio_group_has_container(struct vfio_group *group)
+bool vfio_device_has_container(struct vfio_device *device)
 {
-	return group->container;
+	return device->group->container;
 }
 
 static char *vfio_devnode(struct device *dev, umode_t *mode)
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 670c9c5a55f1fc..e69bfcefee400e 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -70,19 +70,16 @@ struct vfio_group {
 	struct iommufd_ctx		*iommufd;
 };
 
+int vfio_device_set_group(struct vfio_device *device,
+			  enum vfio_group_type type);
 void vfio_device_remove_group(struct vfio_device *device);
-struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
-					    enum vfio_group_type type);
-struct vfio_group *vfio_group_find_or_alloc(struct device *dev);
 void vfio_device_group_register(struct vfio_device *device);
 void vfio_device_group_unregister(struct vfio_device *device);
 int vfio_device_group_use_iommu(struct vfio_device *device);
 void vfio_device_group_unuse_iommu(struct vfio_device *device);
-struct kvm *vfio_group_get_kvm(struct vfio_group *group);
-void vfio_group_put_kvm(struct vfio_group *group);
-void vfio_device_group_finalize_open(struct vfio_device *device);
-void vfio_device_group_abort_open(struct vfio_device *device);
-bool vfio_group_has_container(struct vfio_group *group);
+struct kvm *vfio_device_get_group_kvm(struct vfio_device *device);
+void vfio_device_put_group_kvm(struct vfio_device *device);
+bool vfio_device_has_container(struct vfio_device *device);
 int __init vfio_group_init(void);
 void vfio_group_cleanup(void);
 
@@ -142,12 +139,12 @@ int vfio_container_attach_group(struct vfio_container *container,
 void vfio_group_detach_container(struct vfio_group *group);
 void vfio_device_container_register(struct vfio_device *device);
 void vfio_device_container_unregister(struct vfio_device *device);
-int vfio_group_container_pin_pages(struct vfio_group *group,
+int vfio_device_container_pin_pages(struct vfio_device *device,
 				   dma_addr_t iova, int npage,
 				   int prot, struct page **pages);
-void vfio_group_container_unpin_pages(struct vfio_group *group,
+void vfio_device_container_unpin_pages(struct vfio_device *device,
 				      dma_addr_t iova, int npage);
-int vfio_group_container_dma_rw(struct vfio_group *group,
+int vfio_device_container_dma_rw(struct vfio_device *device,
 				dma_addr_t iova, void *data,
 				size_t len, bool write);
 
@@ -187,21 +184,21 @@ static inline void vfio_device_container_unregister(struct vfio_device *device)
 {
 }
 
-static inline int vfio_group_container_pin_pages(struct vfio_group *group,
-						 dma_addr_t iova, int npage,
-						 int prot, struct page **pages)
+static inline int vfio_device_container_pin_pages(struct vfio_device *device,
+						  dma_addr_t iova, int npage,
+						  int prot, struct page **pages)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline void vfio_group_container_unpin_pages(struct vfio_group *group,
-						    dma_addr_t iova, int npage)
+static inline void vfio_device_container_unpin_pages(struct vfio_device *device,
+						     dma_addr_t iova, int npage)
 {
 }
 
-static inline int vfio_group_container_dma_rw(struct vfio_group *group,
-					      dma_addr_t iova, void *data,
-					      size_t len, bool write)
+static inline int vfio_device_container_dma_rw(struct vfio_device *device,
+					       dma_addr_t iova, void *data,
+					       size_t len, bool write)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index a7b966b4f3fc86..3108e92a5cb20b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -260,17 +260,10 @@ void vfio_free_device(struct vfio_device *device)
 EXPORT_SYMBOL_GPL(vfio_free_device);
 
 static int __vfio_register_dev(struct vfio_device *device,
-		struct vfio_group *group)
+			       enum vfio_group_type type)
 {
 	int ret;
 
-	/*
-	 * In all cases group is the output of one of the group allocation
-	 * functions and we have group->drivers incremented for us.
-	 */
-	if (IS_ERR(group))
-		return PTR_ERR(group);
-
 	if (WARN_ON(device->ops->bind_iommufd &&
 		    (!device->ops->unbind_iommufd ||
 		     !device->ops->attach_ioas)))
@@ -283,16 +276,19 @@ static int __vfio_register_dev(struct vfio_device *device,
 	if (!device->dev_set)
 		vfio_assign_device_set(device, device);
 
-	/* Our reference on group is moved to the device */
-	device->group = group;
-
 	ret = dev_set_name(&device->device, "vfio%d", device->index);
 	if (ret)
-		goto err_out;
+		return ret;
 
-	ret = device_add(&device->device);
+	ret = vfio_device_set_group(device, type);
 	if (ret)
-		goto err_out;
+		return ret;
+
+	ret = device_add(&device->device);
+	if (ret) {
+		vfio_device_remove_group(device);
+		return ret;
+	}
 
 	/* Refcounting can't start until the driver calls register */
 	refcount_set(&device->refcount, 1);
@@ -300,15 +296,12 @@ static int __vfio_register_dev(struct vfio_device *device,
 	vfio_device_group_register(device);
 
 	return 0;
-err_out:
-	vfio_device_remove_group(device);
-	return ret;
 }
 
 int vfio_register_group_dev(struct vfio_device *device)
 {
-	return __vfio_register_dev(device,
-		vfio_group_find_or_alloc(device->dev));
+	return __vfio_register_dev(device, VFIO_IOMMU);
+
 }
 EXPORT_SYMBOL_GPL(vfio_register_group_dev);
 
@@ -318,8 +311,7 @@ EXPORT_SYMBOL_GPL(vfio_register_group_dev);
  */
 int vfio_register_emulated_iommu_dev(struct vfio_device *device)
 {
-	return __vfio_register_dev(device,
-		vfio_noiommu_group_alloc(device->dev, VFIO_EMULATED_IOMMU));
+	return __vfio_register_dev(device, VFIO_EMULATED_IOMMU);
 }
 EXPORT_SYMBOL_GPL(vfio_register_emulated_iommu_dev);
 
@@ -386,7 +378,7 @@ static int vfio_device_first_open(struct vfio_device *device)
 	if (ret)
 		goto err_module_put;
 
-	kvm = vfio_group_get_kvm(device->group);
+	kvm = vfio_device_get_group_kvm(device);
 	if (!kvm) {
 		ret = -EINVAL;
 		goto err_unuse_iommu;
@@ -398,12 +390,12 @@ static int vfio_device_first_open(struct vfio_device *device)
 		if (ret)
 			goto err_container;
 	}
-	vfio_group_put_kvm(device->group);
+	vfio_device_put_group_kvm(device);
 	return 0;
 
 err_container:
 	device->kvm = NULL;
-	vfio_group_put_kvm(device->group);
+	vfio_device_put_group_kvm(device);
 err_unuse_iommu:
 	vfio_device_group_unuse_iommu(device);
 err_module_put:
@@ -1199,8 +1191,8 @@ int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
 	/* group->container cannot change while a vfio device is open */
 	if (!pages || !npage || WARN_ON(!vfio_assert_device_open(device)))
 		return -EINVAL;
-	if (vfio_group_has_container(device->group))
-		return vfio_group_container_pin_pages(device->group, iova,
+	if (vfio_device_has_container(device))
+		return vfio_device_container_pin_pages(device, iova,
 						      npage, prot, pages);
 	if (device->iommufd_access) {
 		int ret;
@@ -1237,8 +1229,8 @@ void vfio_unpin_pages(struct vfio_device *device, dma_addr_t iova, int npage)
 	if (WARN_ON(!vfio_assert_device_open(device)))
 		return;
 
-	if (vfio_group_has_container(device->group)) {
-		vfio_group_container_unpin_pages(device->group, iova,
+	if (vfio_device_has_container(device)) {
+		vfio_device_container_unpin_pages(device, iova,
 						 npage);
 		return;
 	}
@@ -1276,9 +1268,9 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
 	if (!data || len <= 0 || !vfio_assert_device_open(device))
 		return -EINVAL;
 
-	if (vfio_group_has_container(device->group))
-		return vfio_group_container_dma_rw(device->group, iova,
-						   data, len, write);
+	if (vfio_device_has_container(device))
+		return vfio_device_container_dma_rw(device, iova, data, len,
+						    write);
 
 	if (device->iommufd_access) {
 		unsigned int flags = 0;
