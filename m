Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B75636A0C
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 20:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbiKWTsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 14:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239928AbiKWTrv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 14:47:51 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2055.outbound.protection.outlook.com [40.107.100.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E22DF03D
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 11:47:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nhIYsU1bOVopX6g2PSRD2qpmeLGvvH1htDfXLD90dPMcsZBeLHlq1blm1Tb0GxlxaQqalxXL5tGe0YQN+8Y7NqcTQsA8tZnLlDXYOvS51/ewBleyyQq6RUtfsJ3NT+HCqV84a1iT5nHf7s9es8HjFZvdIh8fdHX4lRNMOyaJzeNfyByij6uIm3JNMtvTFnHRDeW5uV07wVApmyrfuqfYB4rHOpbqxjS2X3bNaiDU9/OhrJ0xWZaFxWyFx6w/FOs3WXXsBpvDZPD5bMd6lNh82WdIbOUD2zomK2A0EZVGss1C7kr5goFGWK6w9J+JVdShSsZRdUEptKsjVr5GzgFDDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pX1+YMOZwglFPAjDtpCjCuKsKxgGCRO8ncLH+LNu+Ow=;
 b=ZoG8GLC1oveX+unm3FtPqh2E00Id3JGUoJZnKcCwWwLXkQkErWUMund3SLo2CKllYcp5khAg0gTdF/4ORjQx/j1BYHjdr2/Eqqnfa2azxrntqSOrCxu1XCk6Uu1j+yGaMcsK0J3psc1hvokt8PZ8jjsAR9JC+kwob/wrXNt7CL2qL1sYzTL4mMJLGQnmPxVEjJS8FZLoDmD3dbmAsehIqoOLhb7+GpDNYShOg72feiXBVOA1M+Qo1Zn2pu24/raM39GTbtJIW+Xu0H5ahvkbvvxf4s1G49qMKUXYC0ofjxBvX9fbBz/dp1jDmqKBBhzfrZo2zCcrfbQe7SyQ4PlRkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pX1+YMOZwglFPAjDtpCjCuKsKxgGCRO8ncLH+LNu+Ow=;
 b=PuE+UAWLtHWPNdtzSe47TCPHxOt6laMQaPrion7YcbOdKQkmxU+2/NDr/+p2W1+0UVf8m5F1XxxfxL8IDrnjlw1Xm2C8kw3PLRGfNiupDyaalt7n+vYK0RXmWXO01ITJb8lJhpkfZ9dMXIJnoxlNVCD2bpBhpQIFuV2DEJvsVW4EEqeBbNFcF3aF0MhSgNtwFb+CRgo99sihLzy4Lqxj+9bLaJVSQQ4AOEopDC3mCNB5sLqIH04MnleqBx3HkffWaPg/fbpCYNwSJWboYUAN0EtZpiudunBqrnHqAV4kuq4UUBaxsNrN5bPDMXYzC2RVtW1BsAeSkfmd3kOJIJuuVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB7766.namprd12.prod.outlook.com (2603:10b6:8:101::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 19:47:46 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 19:47:46 +0000
Date:   Wed, 23 Nov 2022 15:47:45 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: Re: [PATCH v3 04/11] vfio: Move storage of allow_unsafe_interrupts
 to vfio_main.c
Message-ID: <Y3544WmLZArbtbLn@nvidia.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <4-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <20221117131451.7d884cdc.alex.williamson@redhat.com>
 <Y3embh+09Fqu26wJ@nvidia.com>
 <20221118133646.7c6421e7.alex.williamson@redhat.com>
 <Y3wtAPTqKJLxBRBg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3wtAPTqKJLxBRBg@nvidia.com>
X-ClientProxiedBy: MN2PR10CA0005.namprd10.prod.outlook.com
 (2603:10b6:208:120::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB7766:EE_
X-MS-Office365-Filtering-Correlation-Id: acb90814-dd4b-4a1a-cd23-08dacd8b9841
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l0vRhVAj0yS02jL9rNgLzrUcBqi2mLqMEYeX71VENvnC2TNRAeJ1Owx1xnj7z9Bq6WoTTWDdB/t4d7dq5q95/6wThAfapYy9xerDCKxAWLsNAY/fY5UTh/xVgPLl2ZeO/cLJXtYIrb94sUrSgJpWiwMGfLkvE3IcQwE9UqN7XjycoAC8Px0LHUHiLZf0u2edPXMAIwKx9WdSvmqEUbTc5qRCH7uoyiYtLrudfvRVJ4gbokW2XA1DXPw9s4w4evQ9CUdVQOqM8XweYEJ8NMAaCU3NiwZH8CsDK6phyRbYxkbyxauXXx0lDxY/Pp1GSL0HdrVGR8DY7LxzbjJuxoHiCdEFgsxn41BGbN55ciE6iUzFCo+RJZRbdd5SK0MgYm+MXSlpxLh7Tjdpd/nTIiAzpjlPyM5NBglFmg8xdLG0UZdm01PNXZoa5mbEr2vcGeodk9WAb2M4OA026oOl8qywNaoGtWTWcnLOss2KVP3lL65V5cbpN9XGSrMwvYde3wr0xtC1u+kzjiW29Q+IvP1m7n6LaRbVnCgo4EvXItvNRfjxWNsBEoAZ4MYx08oeml1yZ8naH9K0VTLVGfZXIJWoTf/K9gqbrYhMPauZgEGFCxYD6dcwABfW8vlzsI+1frGvSURRIDiULcs1b2ereet3JQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(451199015)(8936002)(6916009)(6512007)(6506007)(26005)(54906003)(478600001)(36756003)(86362001)(83380400001)(186003)(2616005)(2906002)(6486002)(38100700002)(7416002)(316002)(66476007)(41300700001)(8676002)(66556008)(4326008)(66946007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LSq30rMCyYOJUFdh8qnFX5knN6L+oBELs03LGe7GoMupo8HWrZbNIs+62ie7?=
 =?us-ascii?Q?A1Oe1F7rVJ5nMaTXRDqWR+aE9857Pv66gtkWkg+FdcjFvJH3An2+IjoWPw3U?=
 =?us-ascii?Q?p7vUEHwuYzYHgAPHA+k6Swlw86+Td0OLAh/DvYWvoCq4UFyon/C7ZhyolEdW?=
 =?us-ascii?Q?JrEFuX5089LDFA4EA5iNdmaRi3mOe3fQgP8vpot95J3MkAVBRewSERri+fIL?=
 =?us-ascii?Q?0Mxc/0KJ4h+XGfuFwvY8vgFpHj4zWktujwQ0wrN++CFywA4XXYYXhfK5N07A?=
 =?us-ascii?Q?8rpk/iQF9yvah+XsZ3hL0OcIRoU+dGtbdTm5C1u969/3W6vt+8uM+73OpVxO?=
 =?us-ascii?Q?frOCdeOA/yYCmGoRxnxRynXR7oP9WjjYwRjB36aNfpHD23YJmS3HFuIfXp94?=
 =?us-ascii?Q?lNbIgyBC2PPKpnrau6MpWrKFRpVLfdQCkjXd4i0q7r4E7boba6vzriL9+J4M?=
 =?us-ascii?Q?745ffg+3OgmptL3TpD0yovSOvyWQbEatLqrYYY8IL5nsfYhpQePJjE+JmH+I?=
 =?us-ascii?Q?GqRegoWEopTRhv81PBuMeFTHMhO9F7TijuUmaMZyjTvMNTPotAA9I8m0n2az?=
 =?us-ascii?Q?5w03PHYedfxONwRVHzOjR08JIqOadH1PK+c2eHjERFEMwdHwYdXvmeWD4EV3?=
 =?us-ascii?Q?3C8cUsi2DKTELRUlG0xpgd9oBz0BtIEKyyidVaEWSPB5FbVjylwzMVoukRWd?=
 =?us-ascii?Q?AB65W9QQQSGgHl8BbpT5d3vTIPciiJbQkp7jiyAI6BYuQbvEeQwTUlQJLpIg?=
 =?us-ascii?Q?AqG8tBE1DiHpTCX92Je3QCIYvxHLFOf4UGCQIzNtvUUzFVYeFrpzT08VGLck?=
 =?us-ascii?Q?4w5bI7N3Jl9J0/yjkbqABcguInTfz5jkidX3JR8dDlVbbc4SOsrpvfGOIu0U?=
 =?us-ascii?Q?0/qnfFt2k2O/KAZcWCt82zDdlEmXU+4nsf0jPDbg3o6ApePJejoMON/vsmRq?=
 =?us-ascii?Q?GI05Un6x+fihMxFtcmJUakRSELzzI4f3Q8Q+xA+0OkbWeECmZzs4JNAHTeIC?=
 =?us-ascii?Q?rXyU4Wy+4XtwHmfU6UHkDYADGdhq5HNCvPKDX/jrTPsWwQOOprFtsCVA3eLw?=
 =?us-ascii?Q?jUU0lnNgpgtSDqZdICS6TYqQr0+Ai9d7YoaxiMi6flTHum42iime4TCYVXEj?=
 =?us-ascii?Q?IkgnVDATAaY77iDo8Wi02g545jzSzSZJ1PDQGy9BlwGtRcWNkCWcBELX8C5z?=
 =?us-ascii?Q?m1XcCYmHyufzHXswmx+8HrLcJWspEmVkkZ3sT8jy0YHgQ7G4O1V4M04Tfpnn?=
 =?us-ascii?Q?uIkUKUPM9j8DCJb8Ze2SFNWx4TMqTaDZQPwgFgVoGLYqTP0RtOmdEP4kkOsK?=
 =?us-ascii?Q?3f4R/SscR+pVjSEfvqAkJrfV9gRVAGRF7W2MDLwuIONgF82oObouR1CeGijt?=
 =?us-ascii?Q?iDLbICILWvYp8x8j/yK8HA46j07o6IqJ6Sd+QEWMEpiD7EtvIA+mAWl+STS6?=
 =?us-ascii?Q?CRvfObxwKOYmYF30Sy1vjUhpjRs0Md/DhvmDtKWrE+ZHzE9Hcw5ZRRJRzMKs?=
 =?us-ascii?Q?BP55hhWgAHPRwCjK0wGYibcNPNh3D3hh6KFqGwm0PCagsiv4mMlXYmbYIGvi?=
 =?us-ascii?Q?VttR9KKvLCt9lsqxGmo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acb90814-dd4b-4a1a-cd23-08dacd8b9841
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 19:47:46.6974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YP6zoc2MyQQr9WsecQvysc/sAe3WD3Zfhdazk7l1a+GkOi8E6GG+iCaBIVgr2vAz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7766
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 21, 2022 at 09:59:28PM -0400, Jason Gunthorpe wrote:
> On Fri, Nov 18, 2022 at 01:36:46PM -0700, Alex Williamson wrote:
> > On Fri, 18 Nov 2022 11:36:14 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > 
> > > On Thu, Nov 17, 2022 at 01:14:51PM -0700, Alex Williamson wrote:
> > > > On Wed, 16 Nov 2022 17:05:29 -0400
> > > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > >   
> > > > > This legacy module knob has become uAPI, when set on the vfio_iommu_type1
> > > > > it disables some security protections in the iommu drivers. Move the
> > > > > storage for this knob to vfio_main.c so that iommufd can access it too.
> > > > > 
> > > > > The may need enhancing as we learn more about how necessary
> > > > > allow_unsafe_interrupts is in the current state of the world. If vfio
> > > > > container is disabled then this option will not be available to the user.
> > > > > 
> > > > > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > > > > Tested-by: Yi Liu <yi.l.liu@intel.com>
> > > > > Tested-by: Lixiao Yang <lixiao.yang@intel.com>
> > > > > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > > > Tested-by: Yu He <yu.he@intel.com>
> > > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > > ---
> > > > >  drivers/vfio/vfio.h             | 2 ++
> > > > >  drivers/vfio/vfio_iommu_type1.c | 5 ++---
> > > > >  drivers/vfio/vfio_main.c        | 3 +++
> > > > >  3 files changed, 7 insertions(+), 3 deletions(-)  
> > > > 
> > > > It's really quite trivial to convert to a vfio_iommu.ko module to host
> > > > a separate option for this.  Half of the patch below is undoing what's
> > > > done here.  Is your only concern with this approach that we use a few
> > > > KB more memory for the separate module?  
> > > 
> > > My main dislike is that it just seems arbitary to shunt iommufd
> > > support to a module when it is always required by vfio.ko. In general
> > > if you have a module that is only ever used by 1 other module, you
> > > should probably just combine them. It saves memory and simplifies
> > > operation (eg you don't have to unload a zoo of modules during
> > > development testing)
> > 
> > These are all great reasons for why iommufd should host this option, as
> > it's fundamentally part of the DMA isolation of the device, which vfio
> > relies on iommufd to provide in this case. 
> 
> Fine, lets do that.

It looks like this:

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 07d4dcc0dbf5e1..6d088af776034b 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -9,6 +9,13 @@
 #include "io_pagetable.h"
 #include "iommufd_private.h"
 
+static bool allow_unsafe_interrupts;
+module_param(allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(
+	allow_unsafe_interrupts,
+	"Allow IOMMUFD to bind to devices even if the platform cannot isolate "
+	"the MSI interrupt window. Enabling this is a security weakness.");
+
 /*
  * A iommufd_device object represents the binding relationship between a
  * consuming driver and the iommufd. These objects are created/destroyed by
@@ -127,8 +134,7 @@ EXPORT_SYMBOL_NS_GPL(iommufd_device_unbind, IOMMUFD);
 
 static int iommufd_device_setup_msi(struct iommufd_device *idev,
 				    struct iommufd_hw_pagetable *hwpt,
-				    phys_addr_t sw_msi_start,
-				    unsigned int flags)
+				    phys_addr_t sw_msi_start)
 {
 	int rc;
 
@@ -174,12 +180,11 @@ static int iommufd_device_setup_msi(struct iommufd_device *idev,
 	 * historical compat with VFIO allow a module parameter to ignore the
 	 * insecurity.
 	 */
-	if (!(flags & IOMMUFD_ATTACH_FLAGS_ALLOW_UNSAFE_INTERRUPT))
+	if (!allow_unsafe_interrupts)
 		return -EPERM;
-
 	dev_warn(
 		idev->dev,
-		"Device interrupts cannot be isolated by the IOMMU, this platform in insecure. Use an \"allow_unsafe_interrupts\" module parameter to override\n");
+		"MSI interrupt window cannot be isolated by the IOMMU, this platform in insecure. Use the \"allow_unsafe_interrupts\" module parameter to override\n");
 	return 0;
 }
 
@@ -195,8 +200,7 @@ static bool iommufd_hw_pagetable_has_group(struct iommufd_hw_pagetable *hwpt,
 }
 
 static int iommufd_device_do_attach(struct iommufd_device *idev,
-				    struct iommufd_hw_pagetable *hwpt,
-				    unsigned int flags)
+				    struct iommufd_hw_pagetable *hwpt)
 {
 	phys_addr_t sw_msi_start = 0;
 	int rc;
@@ -226,7 +230,7 @@ static int iommufd_device_do_attach(struct iommufd_device *idev,
 	if (rc)
 		goto out_unlock;
 
-	rc = iommufd_device_setup_msi(idev, hwpt, sw_msi_start, flags);
+	rc = iommufd_device_setup_msi(idev, hwpt, sw_msi_start);
 	if (rc)
 		goto out_iova;
 
@@ -268,8 +272,7 @@ static int iommufd_device_do_attach(struct iommufd_device *idev,
  * Automatic domain selection will never pick a manually created domain.
  */
 static int iommufd_device_auto_get_domain(struct iommufd_device *idev,
-					  struct iommufd_ioas *ioas,
-					  unsigned int flags)
+					  struct iommufd_ioas *ioas)
 {
 	struct iommufd_hw_pagetable *hwpt;
 	int rc;
@@ -284,7 +287,7 @@ static int iommufd_device_auto_get_domain(struct iommufd_device *idev,
 		if (!hwpt->auto_domain)
 			continue;
 
-		rc = iommufd_device_do_attach(idev, hwpt, flags);
+		rc = iommufd_device_do_attach(idev, hwpt);
 
 		/*
 		 * -EINVAL means the domain is incompatible with the device.
@@ -303,7 +306,7 @@ static int iommufd_device_auto_get_domain(struct iommufd_device *idev,
 	}
 	hwpt->auto_domain = true;
 
-	rc = iommufd_device_do_attach(idev, hwpt, flags);
+	rc = iommufd_device_do_attach(idev, hwpt);
 	if (rc)
 		goto out_abort;
 	list_add_tail(&hwpt->hwpt_item, &ioas->hwpt_list);
@@ -324,7 +327,6 @@ static int iommufd_device_auto_get_domain(struct iommufd_device *idev,
  * @idev: device to attach
  * @pt_id: Input a IOMMUFD_OBJ_IOAS, or IOMMUFD_OBJ_HW_PAGETABLE
  *         Output the IOMMUFD_OBJ_HW_PAGETABLE ID
- * @flags: Optional flags
  *
  * This connects the device to an iommu_domain, either automatically or manually
  * selected. Once this completes the device could do DMA.
@@ -332,8 +334,7 @@ static int iommufd_device_auto_get_domain(struct iommufd_device *idev,
  * The caller should return the resulting pt_id back to userspace.
  * This function is undone by calling iommufd_device_detach().
  */
-int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id,
-			  unsigned int flags)
+int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id)
 {
 	struct iommufd_object *pt_obj;
 	int rc;
@@ -347,7 +348,7 @@ int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id,
 		struct iommufd_hw_pagetable *hwpt =
 			container_of(pt_obj, struct iommufd_hw_pagetable, obj);
 
-		rc = iommufd_device_do_attach(idev, hwpt, flags);
+		rc = iommufd_device_do_attach(idev, hwpt);
 		if (rc)
 			goto out_put_pt_obj;
 
@@ -360,7 +361,7 @@ int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id,
 		struct iommufd_ioas *ioas =
 			container_of(pt_obj, struct iommufd_ioas, obj);
 
-		rc = iommufd_device_auto_get_domain(idev, ioas, flags);
+		rc = iommufd_device_auto_get_domain(idev, ioas);
 		if (rc)
 			goto out_put_pt_obj;
 		break;
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 5a7ce4d9fbae0a..da50feb24b6e1d 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -108,12 +108,9 @@ EXPORT_SYMBOL_GPL(vfio_iommufd_physical_unbind);
 
 int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
 {
-	unsigned int flags = 0;
 	int rc;
 
-	if (vfio_allow_unsafe_interrupts)
-		flags |= IOMMUFD_ATTACH_FLAGS_ALLOW_UNSAFE_INTERRUPT;
-	rc = iommufd_device_attach(vdev->iommufd_device, pt_id, flags);
+	rc = iommufd_device_attach(vdev->iommufd_device, pt_id);
 	if (rc)
 		return rc;
 	vdev->iommufd_attached = true;
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 3378714a746274..ce5fe3fc493b4e 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -216,6 +216,4 @@ extern bool vfio_noiommu __read_mostly;
 enum { vfio_noiommu = false };
 #endif
 
-extern bool vfio_allow_unsafe_interrupts;
-
 #endif
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 186e33a006d314..23c24fe98c00d4 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -44,8 +44,9 @@
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
 #define DRIVER_DESC     "Type1 IOMMU driver for VFIO"
 
+static bool allow_unsafe_interrupts;
 module_param_named(allow_unsafe_interrupts,
-		   vfio_allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
+		   allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(allow_unsafe_interrupts,
 		 "Enable VFIO IOMMU support for on platforms without interrupt remapping support.");
 
@@ -2281,7 +2282,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		    iommu_group_for_each_dev(iommu_group, (void *)IOMMU_CAP_INTR_REMAP,
 					     vfio_iommu_device_capable);
 
-	if (!vfio_allow_unsafe_interrupts && !msi_remap) {
+	if (!allow_unsafe_interrupts && !msi_remap) {
 		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
 		       __func__);
 		ret = -EPERM;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 451a07eb702b34..593d45f43a16ba 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -52,9 +52,6 @@ static struct vfio {
 	struct ida			device_ida;
 } vfio;
 
-bool vfio_allow_unsafe_interrupts;
-EXPORT_SYMBOL_GPL(vfio_allow_unsafe_interrupts);
-
 static DEFINE_XARRAY(vfio_device_set_xa);
 static const struct file_operations vfio_group_fops;
 
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index bf2b3ea5f90fd2..9d1afd417215d0 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -21,11 +21,7 @@ struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
 					   struct device *dev, u32 *id);
 void iommufd_device_unbind(struct iommufd_device *idev);
 
-enum {
-	IOMMUFD_ATTACH_FLAGS_ALLOW_UNSAFE_INTERRUPT = 1 << 0,
-};
-int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id,
-			  unsigned int flags);
+int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id);
 void iommufd_device_detach(struct iommufd_device *idev);
 
 struct iommufd_access_ops {
