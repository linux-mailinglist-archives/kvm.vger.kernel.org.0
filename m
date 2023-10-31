Return-Path: <kvm+bounces-191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 446147DCD93
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 14:14:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8D071B21041
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 13:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77EC913AE2;
	Tue, 31 Oct 2023 13:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nmBmoon7"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328EA125CD
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 13:14:23 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A93FD;
	Tue, 31 Oct 2023 06:14:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTMUGS+8SVrsdf57LFMdkZHGU3JEv+w+OUtPGcjZ2t5sGDxBP+ry3YH2It+Abipyg9rv4gmVUTLObP/MDtpBUEM64MlcwcY5N13XgnUTdEP7ifeaWHFSaLpSoB75EBOvVEnpl9B108JDOQmXy6tzM4dof8xss+SQfZz6Bt8UwPYdrE6XdEq2iGc1KVvtjqoEb354gmAG6tsM/JWJMcrTG5PMKiU3Nm3a4NCqzsxL7YoTv54qb/zw+FqPxTQpOfCdIebW8XPaiAxV3tid0H6/sB2DV/pEQRmRxJrCwGHqhZdweDm0eGQ+S19TNTPSKhaq2n2049xLGQ+jbOjm73lg0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N2SL7L3IDOZ+2rf5XUYQail7YRxo+8Hzd2ljfeGty/A=;
 b=VBsCTPj7LSLIkIVOHEUGOOuymJSdNSW+dGwKcHS/uTPn0lTT6cvGOCGugrdEsBVNR+jcA8zYqxxUk6Op4nXrC+2cqJxQOLx9OCx1r2A8r5vuDD/fDQhIDYSq/N4oc6aqcdH9f0UD094H9munUWqQHtRmlioolUVT9DQ0Jng6ve8i4U7ZTmQkWUHQlfuBlflzEfcTI+28sEBjGAADGYQQ0ZGIbS12qTUJVup2UmJz6V8nzk3BaHQlAWzAps2YnZqAgT1u09o4qbJ4tFXQowrdDsOj1ZPU9pyNq9mTrygir0BqD+uK7GF5cF8hoHea3Ovl/4MKEQR+kHsOl7//FSV09g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2SL7L3IDOZ+2rf5XUYQail7YRxo+8Hzd2ljfeGty/A=;
 b=nmBmoon7IpIPmYmRRmBlOYmHm7U/ugABATGJp8yLITfNo14Lluk8jeEZQFeBF0UzzAbz7nko0T4Z23XVEAIlmQ0UIsAJA/99Nhi9I6GEw2jmjAuzjW/qkHI3PV6pCAK7v9q0V52q16E7241HxwMdviknE4w9oru8CHzQP3XLkdf6+M8TSXnqy9ATS+xVaGKHjo9lTKHsByAXnE1VxphbCLE92cOdoPFCdjLWTo5r2YloltpPUQ7elcpG8FILnsGz3TSI18SqKZtevpZeU9iocaDm2cD0rQqqWAkWOrEtItCsTj1EucuwzKWf/8zEino+n14Saq8i1vBHRdUCjVFPpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB7550.namprd12.prod.outlook.com (2603:10b6:8:10e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.29; Tue, 31 Oct
 2023 13:14:18 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::b53a:1092:9be2:cfb9]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::b53a:1092:9be2:cfb9%4]) with mapi id 15.20.6933.027; Tue, 31 Oct 2023
 13:14:18 +0000
Date: Tue, 31 Oct 2023 10:14:17 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20231031131417.GA1815719@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5Nphx7FMM3LpZnMs"
Content-Disposition: inline
X-ClientProxiedBy: BLAPR03CA0131.namprd03.prod.outlook.com
 (2603:10b6:208:32e::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB7550:EE_
X-MS-Office365-Filtering-Correlation-Id: f0317a2d-8339-4140-2899-08dbda1349c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TQH5WGtshxt8vmrkYz7ooiBoawLOpbhWC6jk4U4qnUysMiggzUKID85QOBXLXPxDRMpPPY36B0aMDJrHy068ETzWpukhIRDihQJ+v7p7+2g135yMtNcK/Mce69V6XNbL1iVcbm2w+ecvR8WfblwpP/K1aDQoS5gxz+CUoFcAcnqjZpHcd9JwBzS9ncKdrqKqr07MBPKczgf4sPj+IV+cWhSVpt6XG4Wo7igckzC4yj8XNt9UNxOO2y8sELx4BVs9ExFfbDDFdkpdp1WCeUy8Rz/n3zAlG+yLqPQhvGT5w7w7kx+y/MKYBc3RJvKzVOBSksT8aOQp7qGA5s8wWBFJk7ylDbi59Zy2mJnwzu6lhQbCQGjhheEJqyz3cSf7Z3R5SMWJj5ekb3dy2lkZkyBWruh9PM1skqVyGLU3PTmrf7ys3//24Q2o/KXQu4WiYkJ3K8jHXdMZVAVeCiF3r1QElTYaC7qMtAWd7dcPvYadR8Apc/OecgcO+VM+ZS1QKgwQYa2wDfG1/kXQgMNRmTKqZhq9sIk7zZTExeYC5UMZSZ5XeXllltl1yEG4+ijQQQGJMqqYJGVFy6+WT9gw4JL9b5zcSGWomHvBXpI9hMnRFTAah0dcnv6AXhrHjnKr2EXzGz4EYvo+oBAb6qJFIWiRalXYcDJAb4R66MrCC52OfK44RkUu6y+TP5JI/0Xu1COn
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(366004)(376002)(136003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(26005)(1076003)(6512007)(2616005)(6506007)(44144004)(478600001)(21480400003)(83380400001)(6486002)(4001150100001)(2906002)(30864003)(41300700001)(66556008)(5660300002)(66946007)(966005)(66476007)(8936002)(8676002)(4326008)(316002)(6916009)(33656002)(38100700002)(86362001)(36756003)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uzp80Rq/ZhRLIiCcDPeHLEwdarg1493C3MFcKYMFjADEDBJIBXHRKe2hnmAg?=
 =?us-ascii?Q?0X0TMzbEC3g+05fJ+dwlMVEMJzygkGn4b7H36w1+AABR8fbYJHLiVQjZvppD?=
 =?us-ascii?Q?KY5+ugxWyqW+42L8ORu1zMnhhJylyzFCUwOmf5WH/J0PVTkxqx8OldUdHf4/?=
 =?us-ascii?Q?boOUe8UKh08BpUQHCqBEjmP3ekzI1jjdPm56+Av5nsQoqt4LQCZ1bUUdrDCr?=
 =?us-ascii?Q?I2WA7zt0gfuAtRlfMzTfrzl6FOzDuUlgo7sN2Ri1k0on0WF87bQFSgCCxyB4?=
 =?us-ascii?Q?s8TskaIWAptoUshURal+XX/Vvq/6WQpdipR81aEjmBMCLEk+0rYarPv8wang?=
 =?us-ascii?Q?6ERO4YUmCnbWhf51CGX9c/0/3sLaF0Bf25z7hDKFBmwk0Rz/f2RvNznYyhc0?=
 =?us-ascii?Q?qblgP2LcQScQvjTazQPj21ceW2vFyPfj3jIFn4NB/R/uIX0CV9eMsGrXAnkO?=
 =?us-ascii?Q?h5Tl4K0XJXaKDzA/ymzSGYAte7yPLwxLp8efC07/ZKk3LKOVSAeQWkEMhdMg?=
 =?us-ascii?Q?fetoKLf4kiY8ajEJy1dB4ZjS2lx9htJhJWyuiwA4xdWI9Hw5xBcCTNRu1OjT?=
 =?us-ascii?Q?e086TzFmL8Dk9z2lY49jP50QZ6J0RchhdW7mAOGna3iABIPnWvPr+LOIlpLt?=
 =?us-ascii?Q?atVKeT5fXq3+2/Vww+NcIXQD2Qlo7vN5FUSB8GmllnqfpG0gIfKtNuusW3Za?=
 =?us-ascii?Q?2x7NRKBELbzl4MOhGtaYcWBBTvRuYE2Sev9mgdKWGywVN0Hp3p/wOX+WGFdC?=
 =?us-ascii?Q?ImKMgg2m2KkCPr65a9mgXSWfEgYSxTV2un5XvNClg+atB9AL1QlN0Hm2odlk?=
 =?us-ascii?Q?nabTElrgUswMCsgI9aOp1Fx9jKfiRD8VCPHT2b8gdARz3L++oLpGzz1nRSU/?=
 =?us-ascii?Q?4SX5xWKSXo4Fw1BYvIeyUkA53+1dt1fhPdYfsqpZVsQJWZUUY8qU78bYTf9z?=
 =?us-ascii?Q?ogllOlaibxW3jZ9uGZMYSX2QMSed4kziy3LzJrCSqpOeDdZBwk4SNg3pIEpU?=
 =?us-ascii?Q?v+x74ihOl86n8GP+NB9lfmTkcAG4iL2CuE9hd7s82pD2F3u+oEhg00lB3i2e?=
 =?us-ascii?Q?98uIcISSRrmGk41RP6Ja5/s7yxf9tOm1jbuDyq0BFTkFJRx0SCt9zzyfR2Ut?=
 =?us-ascii?Q?XDTq0i4sX5qd9VVCUlP/h1y4INEVlAiba1Vv17kuKAW5GWITqPSypmvtxfcV?=
 =?us-ascii?Q?qiM/7Es9KQotEFsZFubQORl826NYLH28kwUtmJjBghYv3KOfTMZpXEScLgbZ?=
 =?us-ascii?Q?GDEzSdO9Go/CdooJAGxCggbnn26TC7BDfPECX0LOjMR6raes4Qo59FfOQSo/?=
 =?us-ascii?Q?/G2UJsSjXUmFq9J8NipjKZYyeUkRPfPIOsIHlu0lsYhzJFF78pczfqCfdj+6?=
 =?us-ascii?Q?zaaNSLMv3Uh9AihN/Yd4iA2XvAPKCc4+mFQIsGOYr3l4sWSgx/UMi/gCeppQ?=
 =?us-ascii?Q?w15k2e6/uyX3vOfumNQymydoYCI9pm+8t+MHQQofnVglQfrBeYG3N6qzAe3U?=
 =?us-ascii?Q?Ve6L1QtKjUtfVWXA+l9z2suqz3BNgCl3y4WhUNBzs0wiPVmNEkjnxWqT4TtP?=
 =?us-ascii?Q?ppE2y/7B6wFbZzX9GTUVtl2SMTtH5tadBRRLKsv3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0317a2d-8339-4140-2899-08dbda1349c1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2023 13:14:18.1225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3UXHIm8l67Q39iTdnWD9VRymvmu5/r6ls1GR1cURbHBTfgYj/txdY0XImo3Hmb7T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7550

--5Nphx7FMM3LpZnMs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

This PR includes the dirty tracking and first part of the nested
translation items for iommufd, details in the tag.

For those following, these series are still progressing:

- User page table invalidation:
 https://lore.kernel.org/r/20231020092426.13907-1-yi.l.liu@intel.com
 https://lore.kernel.org/r/20231020093719.18725-1-yi.l.liu@intel.com

- ARM SMMUv3 nested translation:
 https://lore.kernel.org/all/cover.1683688960.git.nicolinc@nvidia.com/

- Draft AMD IOMMU nested translation:
 https://lore.kernel.org/all/20230621235508.113949-1-suravee.suthikulpanit@amd.com/

- ARM SMMUv3 Dirty tracking:
 https://github.com/jpemartins/linux/commits/smmu-iommufd-v3

There is also a lot of ongoing work to consistently and generically enable
PASID and SVA support in all the IOMMU drivers:

 SMMUv3:
   https://lore.kernel.org/r/0-v1-e289ca9121be+2be-smmuv3_newapi_p1_jgg@nvidia.com
   https://lore.kernel.org/r/0-v1-afbb86647bbd+5-smmuv3_newapi_p2_jgg@nvidia.com
 AMD:
   https://lore.kernel.org/all/20231016104351.5749-1-vasant.hegde@amd.com/
   https://lore.kernel.org/all/20231013151652.6008-1-vasant.hegde@amd.com/
 Intel:
   https://lore.kernel.org/r/20231017032045.114868-1-tina.zhang@intel.com

RFC patches for PASID support in iommufd & vfio:
 https://lore.kernel.org/all/20230926092651.17041-1-yi.l.liu@intel.com/
 https://lore.kernel.org/all/20230926093121.18676-1-yi.l.liu@intel.com/

IO page faults and events delivered to userspace through iommufd:
 https://lore.kernel.org/all/20231026024930.382898-1-baolu.lu@linux.intel.com/

RFC patches exploring support for the first Intel Scalable IO Virtualization
(SIOV r1) device are posted:
 https://lore.kernel.org/all/20231009085123.463179-1-yi.l.liu@intel.com/

Along with qemu patches implementing iommufd:
 https://lore.kernel.org/all/20231016083223.1519410-1-zhenzhong.duan@intel.com/

There are some conflicts with Joerg's main iommu tree, most are of the append
to list type of conflict. A few notes:

drivers/iommu/iommufd/selftest.c needs a non-conflict hunk:

- static struct iommu_domain *mock_domain_alloc(unsigned int iommu_domain_type)
- {
-       if (iommu_domain_type == IOMMU_DOMAIN_BLOCKED)
-               return &mock_blocking_domain;
-       if (iommu_domain_type == IOMMU_DOMAIN_UNMANAGED)
-               return mock_domain_alloc_paging(NULL);
-       return NULL;
- }
-

drivers/iommu/iommufd/selftest.c should be:

@@@ -466,10 -293,8 +450,9 @@@ static const struct iommu_ops mock_ops
        .owner = THIS_MODULE,
        .pgsize_bitmap = MOCK_IO_PAGE_SIZE,
        .hw_info = mock_domain_hw_info,
-       .domain_alloc = mock_domain_alloc,
+       .domain_alloc_paging = mock_domain_alloc_paging,
 +      .domain_alloc_user = mock_domain_alloc_user,
        .capable = mock_domain_capable,
-       .set_platform_dma_ops = mock_domain_set_plaform_dma_ops,

include/linux/iommu.h should be:

 - * @domain_alloc: allocate iommu domain
 + * @domain_alloc: allocate and return an iommu domain if success. Otherwise
 + *                NULL is returned. The domain is not fully initialized until
 + *                the caller iommu_domain_alloc() returns.
 + * @domain_alloc_user: Allocate an iommu domain corresponding to the input
 + *                     parameters as defined in include/uapi/linux/iommufd.h.
 + *                     Unlike @domain_alloc, it is called only by IOMMUFD and
 + *                     must fully initialize the new domain before return.
 + *                     Upon success, if the @user_data is valid and the @parent
 + *                     points to a kernel-managed domain, the new domain must be
 + *                     IOMMU_DOMAIN_NESTED type; otherwise, the @parent must be
 + *                     NULL while the @user_data can be optionally provided, the
 + *                     new domain must support __IOMMU_DOMAIN_PAGING.
 + *                     Upon failure, ERR_PTR must be returned.
+  * @domain_alloc_paging: Allocate an iommu_domain that can be used for
+  *                       UNMANAGED, DMA, and DMA_FQ domain types.

The rest were straightforward.

The tag for-linus-iommufd-merged with my merge resolution to your tree
is also available to pull.

Thanks,
Jason

The following changes since commit ce9ecca0238b140b88f43859b211c9fdfd8e5b70:

  Linux 6.6-rc2 (2023-09-17 14:40:24 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to b2b67c997bf74453f3469d8b54e4859f190943bd:

  iommufd: Organize the mock domain alloc functions closer to Joerg's tree (2023-10-30 18:01:56 -0300)

----------------------------------------------------------------
iommufd for 6.7

This branch has three new iommufd capabilities:

 - Dirty tracking for DMA. AMD/ARM/Intel CPUs can now record if a DMA
   writes to a page in the IOPTEs within the IO page table. This can be used
   to generate a record of what memory is being dirtied by DMA activities
   during a VM migration process. A VMM like qemu will combine the IOMMU
   dirty bits with the CPU's dirty log to determine what memory to
   transfer.

   VFIO already has a DMA dirty tracking framework that requires PCI
   devices to implement tracking HW internally. The iommufd version
   provides an alternative that the VMM can select, if available. The two
   are designed to have very similar APIs.

 - Userspace controlled attributes for hardware page
   tables (HWPT/iommu_domain). There are currently a few generic attributes
   for HWPTs (support dirty tracking, and parent of a nest). This is an
   entry point for the userspace iommu driver to control the HW in detail.

 - Nested translation support for HWPTs. This is a 2D translation scheme
   similar to the CPU where a DMA goes through a first stage to determine
   an intermediate address which is then translated trough a second stage
   to a physical address.

   Like for CPU translation the first stage table would exist in VM
   controlled memory and the second stage is in the kernel and matches the
   VM's guest to physical map.

   As every IOMMU has a unique set of parameter to describe the S1 IO page
   table and its associated parameters the userspace IOMMU driver has to
   marshal the information into the correct format.

   This is 1/3 of the feature, it allows creating the nested translation
   and binding it to VFIO devices, however the API to support IOTLB and
   ATC invalidation of the stage 1 io page table, and forwarding of IO
   faults are still in progress.

The series includes AMD and Intel support for dirty tracking. Intel
support for nested translation.

Along the way are a number of internal items:

 - New iommu core items: ops->domain_alloc_user(), ops->set_dirty_tracking,
   ops->read_and_clear_dirty(), IOMMU_DOMAIN_NESTED, and iommu_copy_struct_from_user

 - UAF fix in iopt_area_split()

 - Spelling fixes and some test suite improvement

----------------------------------------------------------------
GuokaiXu (1):
      iommufd: Fix spelling errors in comments

Jason Gunthorpe (4):
      iommufd: Rename IOMMUFD_OBJ_HW_PAGETABLE to IOMMUFD_OBJ_HWPT_PAGING
      iommufd/device: Wrap IOMMUFD_OBJ_HWPT_PAGING-only configurations
      iommufd: Add iopt_area_alloc()
      iommufd: Organize the mock domain alloc functions closer to Joerg's tree

Joao Martins (19):
      vfio/iova_bitmap: Export more API symbols
      vfio: Move iova_bitmap into iommufd
      iommufd/iova_bitmap: Move symbols to IOMMUFD namespace
      iommu: Add iommu_domain ops for dirty tracking
      iommufd: Add a flag to enforce dirty tracking on attach
      iommufd: Add IOMMU_HWPT_SET_DIRTY_TRACKING
      iommufd: Add IOMMU_HWPT_GET_DIRTY_BITMAP
      iommufd: Add capabilities to IOMMU_GET_HW_INFO
      iommufd: Add a flag to skip clearing of IOPTE dirty
      iommu/amd: Add domain_alloc_user based domain allocation
      iommu/amd: Access/Dirty bit support in IOPTEs
      iommu/vt-d: Access/Dirty bit support for SS domains
      iommufd/selftest: Expand mock_domain with dev_flags
      iommufd/selftest: Test IOMMU_HWPT_ALLOC_DIRTY_TRACKING
      iommufd/selftest: Test IOMMU_HWPT_SET_DIRTY_TRACKING
      iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_BITMAP
      iommufd/selftest: Test out_capabilities in IOMMU_GET_HW_INFO
      iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_BITMAP_NO_CLEAR flag
      iommufd/selftest: Fix page-size check in iommufd_test_dirty()

Koichiro Den (1):
      iommufd: Fix missing update of domains_itree after splitting iopt_area

Lu Baolu (6):
      iommu: Add IOMMU_DOMAIN_NESTED
      iommu/vt-d: Extend dmar_domain to support nested domain
      iommu/vt-d: Add helper for nested domain allocation
      iommu/vt-d: Add helper to setup pasid nested translation
      iommu/vt-d: Add nested domain allocation
      iommu/vt-d: Disallow read-only mappings to nest parent domain

Nicolin Chen (10):
      iommufd/selftest: Iterate idev_ids in mock_domain's alloc_hwpt test
      iommufd/selftest: Rework TEST_LENGTH to test min_size explicitly
      iommufd: Correct IOMMU_HWPT_ALLOC_NEST_PARENT description
      iommufd: Only enforce cache coherency in iommufd_hw_pagetable_alloc
      iommufd: Derive iommufd_hwpt_paging from iommufd_hw_pagetable
      iommufd: Share iommufd_hwpt_alloc with IOMMUFD_OBJ_HWPT_NESTED
      iommufd: Add a nested HW pagetable object
      iommu: Add iommu_copy_struct_from_user helper
      iommufd/selftest: Add nested domain allocation for mock domain
      iommufd/selftest: Add coverage for IOMMU_HWPT_ALLOC with nested HWPTs

Yi Liu (11):
      iommu: Add new iommu op to create domains owned by userspace
      iommufd: Use the domain_alloc_user() op for domain allocation
      iommufd: Flow user flags for domain allocation to domain_alloc_user()
      iommufd: Support allocating nested parent domain
      iommufd/selftest: Add domain_alloc_user() support in iommu mock
      iommu/vt-d: Add domain_alloc_user op
      iommu: Pass in parent domain with user_data to domain_alloc_user op
      iommu/vt-d: Enhance capability check for nested parent domain allocation
      iommufd: Add data structure for Intel VT-d stage-1 domain allocation
      iommu/vt-d: Make domain attach helpers to be extern
      iommu/vt-d: Set the nested domain to a device

 drivers/iommu/Kconfig                            |   4 +
 drivers/iommu/amd/Kconfig                        |   1 +
 drivers/iommu/amd/amd_iommu_types.h              |  12 +
 drivers/iommu/amd/io_pgtable.c                   |  68 ++++
 drivers/iommu/amd/iommu.c                        | 147 ++++++++-
 drivers/iommu/intel/Kconfig                      |   1 +
 drivers/iommu/intel/Makefile                     |   2 +-
 drivers/iommu/intel/iommu.c                      | 156 +++++++++-
 drivers/iommu/intel/iommu.h                      |  64 +++-
 drivers/iommu/intel/nested.c                     | 117 +++++++
 drivers/iommu/intel/pasid.c                      | 221 +++++++++++++
 drivers/iommu/intel/pasid.h                      |   6 +
 drivers/iommu/iommufd/Makefile                   |   1 +
 drivers/iommu/iommufd/device.c                   | 174 +++++++----
 drivers/iommu/iommufd/hw_pagetable.c             | 304 ++++++++++++++----
 drivers/iommu/iommufd/io_pagetable.c             | 200 +++++++++++-
 drivers/iommu/iommufd/iommufd_private.h          |  84 ++++-
 drivers/iommu/iommufd/iommufd_test.h             |  39 +++
 drivers/{vfio => iommu/iommufd}/iova_bitmap.c    |   5 +-
 drivers/iommu/iommufd/main.c                     |  17 +-
 drivers/iommu/iommufd/pages.c                    |   2 +
 drivers/iommu/iommufd/selftest.c                 | 328 ++++++++++++++++++--
 drivers/iommu/iommufd/vfio_compat.c              |   6 +-
 drivers/vfio/Makefile                            |   3 +-
 drivers/vfio/pci/mlx5/Kconfig                    |   1 +
 drivers/vfio/pci/mlx5/main.c                     |   1 +
 drivers/vfio/pci/pds/Kconfig                     |   1 +
 drivers/vfio/pci/pds/pci_drv.c                   |   1 +
 drivers/vfio/vfio_main.c                         |   1 +
 include/linux/io-pgtable.h                       |   4 +
 include/linux/iommu.h                            | 146 ++++++++-
 include/linux/iova_bitmap.h                      |  26 ++
 include/uapi/linux/iommufd.h                     | 180 ++++++++++-
 tools/testing/selftests/iommu/iommufd.c          | 379 ++++++++++++++++++++++-
 tools/testing/selftests/iommu/iommufd_fail_nth.c |   7 +-
 tools/testing/selftests/iommu/iommufd_utils.h    | 233 +++++++++++++-
 36 files changed, 2723 insertions(+), 219 deletions(-)


--5Nphx7FMM3LpZnMs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZUD9pwAKCRCFwuHvBreF
YaW/AP9aScHWJufImCwdWpMB4vXCSyWmwR1jaL/NIOvbfGi7bAEAsn9WIIzQWg5b
jF4j2JpXwAg2W2Vg0aC0KuLYRDtDswA=
=P1Nt
-----END PGP SIGNATURE-----

--5Nphx7FMM3LpZnMs--

