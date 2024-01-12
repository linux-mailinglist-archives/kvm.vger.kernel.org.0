Return-Path: <kvm+bounces-6153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 928CC82C502
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 18:49:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A95821C2225C
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 17:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0D9C17C8C;
	Fri, 12 Jan 2024 17:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GuFsTHZY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2044.outbound.protection.outlook.com [40.107.212.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F401AAA6;
	Fri, 12 Jan 2024 17:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7E2GymxFq3uNY7RjqJdNLGAaxJLbDdeK8vwckkV8SC/FP2vbE5Bm1ULzpVWKlX6/Un7wkdFPSU/UufSGoSANx9it0RnOYXvT7aE7ZpFKvxmXldHtmoL74lpTBhlnQ5Hw3duXducxzjIBXOnfaP2L+W2PikBzgZPDJzTpggdyaq34NtL2TgnG5d7wcpFBjCSkK71XmmbFmLUdcx1yWChtP1I2KqrRNoyV5ZCeEKZunGQcPpvilHxlgU3VUsUOXh6VK9VE7D6RJzTKI4f70xUe2lIpRJza9xdaqkUES8Wnc0EZav5e3mcdFLRo9R58E0u1isXYogFtMit4Iiz4l+DIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=utpsbh3Ii3lnX3Ltoe0787VCsjROuxfkwNFy/HdsDMM=;
 b=kX2iSiC9gydkNABRQ607apNAyjqKR9IJLzh4luuz3YZWbC6AR2tczMu9CV096/XWqJfB5GLvUI2iruiTXzIcgtcZwfehOvuFZ+HgmVBPBAAHvz06YXRGUiNHPt3B8/1glbPj7uJPQH+DtZgIPVjFfJRKCnUg9JQiwiyUrm8AObpnfoGQFJ5z7M75QzCQkekCFPwm4FAOHIdZmVmYcCar74ufjEPMra6+lSjMvLMc4HMasHdMFs8yNhFJm3Z/fKOwfecX35k6xB4Vc/MAXamcT2z3AxiqxCtVZjXyIm29bfkzjiLGPMq1535t1kCvqSHRlEssSFUKP+Y+ntXQJrZmdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=utpsbh3Ii3lnX3Ltoe0787VCsjROuxfkwNFy/HdsDMM=;
 b=GuFsTHZY6/aF7BIif0Z5H309BR/Iqp6H9T8oDWQb4XW7a4iWLd05flYKRcST06ihvDubI0RnzuNu7d0v8c1II0ml3cDUCnog1Yf02GlHWsted4AkOIWhExoqibgevCrm2/ymga9xF+FxEcRLWVlpX1B7A7ybJSOcLIckdpl1nYLHiva1/NQH3d2h/ik9fWRb083RgmBC3aEwSFL6NAaSXpJ82l5YDDMJKlXYLZH81+jw1yqnR6ThINWQGMEaR/V3TUwA3ebuTTkxUt8FgxAus4pcr/dJh5EHUoTC/a3t5ioDF87UiI450NnPsMRghbjQEnCy0sLF/+rDXVOXz6pwsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV8PR12MB9264.namprd12.prod.outlook.com (2603:10b6:408:1e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.19; Fri, 12 Jan
 2024 17:49:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7181.020; Fri, 12 Jan 2024
 17:49:30 +0000
Date: Fri, 12 Jan 2024 13:49:28 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20240112174928.GA828978@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Z4b8nnA/cAQCd4Ug"
Content-Disposition: inline
X-ClientProxiedBy: SN6PR01CA0030.prod.exchangelabs.com (2603:10b6:805:b6::43)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV8PR12MB9264:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f4ade73-bd0a-413b-af6c-08dc1396d3d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JNjpK2yFsox3cWYCGhbRBCplinnif5W67x8pOTI6BmDQ7BaLGYx7nqpf1l2LGFES8g5jn209juwYKhb3quDk0IYhSkIPrIo4njn97U5hU/7C6Ol2MK/efMDIU+GCwltfeSh43I4C1JamDm4A0svcElCk4j3hpxZKmy1dtOfUSsL0NI6qBImaGmHKgaRTsEJnqEh2+MqUK7VTBYKQHanwebNvA1TWIovOojNXtm64nW0Qew8Fqs6j6H4YUmWmff1XljZFI3TyutHASyCRFd3aecJMqwtOsVDtOLaYkMrGmTOmUVLqN0lPALtOJaS7FSLsAw/2jpkWRtIj1IHA1X4gMeVnhyAG5wDV/r9uj88YDMqOpJc44kw7uqc29ulUNi1omh3qihmSCMpSLLB70Y5kGv/iOgEAh9E6HwaxnCqCSMwJfRYgftZoj1Zvipilo53kk9oFhRKpy8Dgi+lF1DIW1pSyKtfXgwLMzHkJjZNv9C3DUyvtUmpqk4ndFsemb2WgXWcQ6mQo28Vy+tUu/W3+gmNO6i5+lrGCMwIE7S4qyqj/uVXL4fyOeOMeKcYp+/PCxvcvIV7L/vQGlxRDe+cqBPfPlr/uZkUWoE2tWwcYgfBZZi5wzvY6nNFzAIaLJt8v6sxDzDR3Zo7fBrS+zFIk/ODTra88rnk5A0+yFQE1kYBHusEuGN15sdA8xXiDN64M4E2dWlp+du+jEdtz7g2tbLe9mH7xtCUGZjdVmjERhHQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(39860400002)(366004)(136003)(346002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(21480400003)(83380400001)(41300700001)(86362001)(36756003)(33656002)(38100700002)(6506007)(6512007)(66476007)(5660300002)(44144004)(316002)(6916009)(6486002)(478600001)(8676002)(8936002)(4326008)(966005)(26005)(1076003)(2616005)(2906002)(4001150100001)(66556008)(66946007)(27376004)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mj9UwKYFc+9HGF6wftsVjiBZVQsBZ38L7zf/W/SAKw0oxKoxIfE/LgjikAy+?=
 =?us-ascii?Q?5VGx9VPTp04H21X/pi232sgp9l/EP3pZdVsS4vAB8hsemBPvorl1br/dfRzL?=
 =?us-ascii?Q?WZNV5xQ5gGtaGZC3ZTNCdvpxDF8LCkGXWe2qBvx5rqeLVeSW/tFOOW1u1V9o?=
 =?us-ascii?Q?W8O8cXrlsELelv58V1qexlQvBlSVZQViKPhPdITft7/LRNeLfjef4u5lTl5o?=
 =?us-ascii?Q?w6oOf8rLDFfWz8HKD7Nk/P0EmFF+2suDi5ghiVL6GnSbLhA+nI2BUtO2a1E8?=
 =?us-ascii?Q?UPm44hqd8RRbK4CMIgsqd6MWcXCnHbQ9j6/TkOx4eMOIyPNafFoDq5gqPXE7?=
 =?us-ascii?Q?AeTgjs+6FPoIut2GnZVbLIyAJxRG/o/lay82iXE1ABHfSIAnw/oc9ilk94rK?=
 =?us-ascii?Q?ktgqyF5EoM3za+maND5tX3flYJ+kKsOFbWW52lwl66ksCVyRF1mZ/Uo7Kv8T?=
 =?us-ascii?Q?hw54P8FBx5V8sq95kKyVsQb9qNcGm2PGiLSyz9HYt5e8PRGamPujilUV+XrK?=
 =?us-ascii?Q?3QqO+IEH/DyNqqvUrl2Bv2LcliawtVhpAhtOyQNnZozWcTdD3sbHvTrBpbUv?=
 =?us-ascii?Q?EnQW0iz4Org+qZPNlbOJVYJCIHmz+wFLqsUa6sL4QDx4YW4+eVOZmWk0bQ3X?=
 =?us-ascii?Q?inkwofnOZ1eMYrlGLElBPHIlcVidTwJTlGbH8F8H2RN19fpbghflDCNKDKf7?=
 =?us-ascii?Q?+8p4ZwE8W4U0Gxr4fLDtnNpvQxQTyX/7I1di25OALhYSRh5MTEWq1TfC5jCo?=
 =?us-ascii?Q?gBhauTwIOu+hDqrn6Pv/swpAT20HMa/6gzbLUX/XItKv4kEnD1suk4OewBco?=
 =?us-ascii?Q?WRA+stQhiBorttwaNd58weCS4FqjN246ZaAonsfodZI+zrcEvTIYey4T/mVa?=
 =?us-ascii?Q?3rZgQq5iI0dMpMZ9JAgst8gTxvTFQBoxBmlgZdmBUOHoBRfoDEPWKbjSf+R/?=
 =?us-ascii?Q?nbzOIbKeY6VPuyIeK7yQwi50BKequRkX66lVLTeMEx8uqHjV8s0cI4zDX+Y+?=
 =?us-ascii?Q?UJ5w0tyrrdvHhBhlP1bL4WjiP8+79v8LwIPLFvyeWGYkvN7g5yr7ecWCCkqE?=
 =?us-ascii?Q?kPREu4mt8vMCl/16Lgk5RfLo/x54lDmFvp1EXeR8gBgeugI26ja8uSDYH4CV?=
 =?us-ascii?Q?Q1f22j/DydtFGfSG8oq4llTwlVZKSUGFKkZ+ATDwTF4Fj4kbj21YLwDLRo61?=
 =?us-ascii?Q?UFvn9P/vVBJ2oJvDz8eCdXsv1YjNLye+aSG4T8wuV/ohPNTXsaUu/gynAM02?=
 =?us-ascii?Q?EPJ8fo12L5LDsu5OhtphsO+p7QVi/EieB6tPOQxU8ufHyqhReJ0eArX9CCUd?=
 =?us-ascii?Q?vFPNXa29kgixCJjpDhcFqgiM6Z00xuA7JSY5lZDegbnS0WTjCSHlgWyCnuLF?=
 =?us-ascii?Q?MPjJeKoFdMFqNbY1LQt4lgFUIU1LxXylxTCvyZHYvDudmEjlF4LJ7XMg+an6?=
 =?us-ascii?Q?rqwT8QmO10BCt7R5JRuHvQA3p25uB/nG1NkC+x58itmD12TXx5SVqceZA5vx?=
 =?us-ascii?Q?56exWivrE0kqkhou9WzUT2k0WrJA8Q7cJ1MBT/Moh8ROzW78iufzfjTksPVI?=
 =?us-ascii?Q?Vv7JVbm/d8WK+YfKXMkZeOfy6hh5OBxYuyQGIa/n?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f4ade73-bd0a-413b-af6c-08dc1396d3d0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2024 17:49:30.1002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c/EUaGd+/96OE9jx/juFo3AGPrE4lS7SvleordZNA5yDGCenTwR10db8IqJrRFDm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9264

--Z4b8nnA/cAQCd4Ug
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

There was a last minute doubt from Intel on their error handling
plan. They decided to remove it since it has uAPI meaning this was
delayed while they made that edit. The prior verions has been in
linux-next for a while now but the update has only had a day.

This PR includes the second part of the nested translation items for
iommufd, details in the tag.

For those following, these series are still progressing:

- User page table invalidation (non-Intel) has a roadmap:
 https://lore.kernel.org/linux-iommu/20231209014726.GA2945299@nvidia.com/

 There will be at least two more invalidation IOCTLs - IOMMU_DEVICE_INVALIDATE
 and IOMMU_VIOMMU_INVALIDATE in future.

- ARM SMMUv3 nested translation:
 https://github.com/jgunthorpe/linux/commits/smmuv3_newapi

- Draft AMD IOMMU nested translation:
 https://lore.kernel.org/linux-iommu/20240112000646.98001-1-suravee.suthikulpanit@amd.com

- ARM SMMUv3 Dirty tracking:
 https://lore.kernel.org/linux-iommu/20231128094940.1344-1-shameerali.kolothum.thodi@huawei.com/

- x86 KVM and IOMMU page table sharing (IOMMU_DOMAIN_KVM):
 https://lore.kernel.org/all/20231202091211.13376-1-yan.y.zhao@intel.com/

There is also a lot of ongoing work to consistently and generically enable
PASID and SVA support in all the IOMMU drivers:
 SMMUv3:
   https://lore.kernel.org/r/0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com
   https://lore.kernel.org/r/0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com
 AMD:
   https://lore.kernel.org/linux-iommu/20231212085224.6985-1-vasant.hegde@amd.com/
   https://lore.kernel.org/linux-iommu/20231221111558.64652-1-vasant.hegde@amd.com/
 Intel:
   https://lore.kernel.org/r/20231017032045.114868-1-tina.zhang@intel.com

RFC patches for PASID support in iommufd & vfio:
 https://lore.kernel.org/all/20231127063428.127436-1-yi.l.liu@intel.com/
 https://lore.kernel.org/all/20231127063909.129153-1-yi.l.liu@intel.com/

IO page faults and events delivered to userspace through iommufd:
 https://lore.kernel.org/all/20231220012332.168188-1-baolu.lu@linux.intel.com/
 https://lore.kernel.org/all/20231026024930.382898-1-baolu.lu@linux.intel.com/

RFC patches exploring support for the first Intel Scalable IO Virtualization
(SIOV r1) device are posted:
 https://lore.kernel.org/all/20231009085123.463179-1-yi.l.liu@intel.com/

A lot of the iommufd support has now been merged to qemu, though I think we
are still needing dirty tracking and nesting stuff.
 https://lore.kernel.org/all/20231121084426.1286987-1-zhenzhong.duan@intel.com/
 https://lore.kernel.org/all/20230622214845.3980-1-joao.m.martins@oracle.com/

A video of the iommufd session at LPC has been posted:
 https://youtu.be/IE_A8wSWV7g

Thanks,
Jason

The following changes since commit 861deac3b092f37b2c5e6871732f3e11486f7082:

  Linux 6.7-rc7 (2023-12-23 16:25:56 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to 47f2bd2ff382e5fe766b1322e354558a8da4a470:

  iommufd/selftest: Check the bus type during probe (2024-01-11 15:53:28 -0400)

----------------------------------------------------------------
iommufd for 6.8

This brings the first of three planned user IO page table invalidation
operations:

 - IOMMU_HWPT_INVALIDATE allows invalidating the IOTLB integrated into the
   iommu itself. The Intel implementation will also generate an ATC
   invalidation to flush the device IOTLB as it unambiguously knows the
   device, but other HW will not.

It goes along with the prior PR to implement userspace IO page tables (aka
nested translation for VMs) to allow Intel to have full functionality for
simple cases. An Intel implementation of the operation is provided.

Fix a small bug in the selftest mock iommu driver probe.

----------------------------------------------------------------
Jason Gunthorpe (1):
      iommufd/selftest: Check the bus type during probe

Lu Baolu (2):
      iommu: Add cache_invalidate_user op
      iommu/vt-d: Add iotlb flush for nested domain

Nicolin Chen (4):
      iommu: Add iommu_copy_struct_from_user_array helper
      iommufd/selftest: Add mock_domain_cache_invalidate_user support
      iommufd/selftest: Add IOMMU_TEST_OP_MD_CHECK_IOTLB test op
      iommufd/selftest: Add coverage for IOMMU_HWPT_INVALIDATE ioctl

Yi Liu (2):
      iommufd: Add IOMMU_HWPT_INVALIDATE
      iommufd: Add data structure for Intel VT-d stage-1 cache invalidation

 drivers/iommu/intel/nested.c                  |  88 +++++++++++++++
 drivers/iommu/iommufd/hw_pagetable.c          |  41 +++++++
 drivers/iommu/iommufd/iommufd_private.h       |  10 ++
 drivers/iommu/iommufd/iommufd_test.h          |  23 ++++
 drivers/iommu/iommufd/main.c                  |   3 +
 drivers/iommu/iommufd/selftest.c              | 104 +++++++++++++++---
 include/linux/iommu.h                         |  77 +++++++++++++
 include/uapi/linux/iommufd.h                  |  79 +++++++++++++
 tools/testing/selftests/iommu/iommufd.c       | 152 ++++++++++++++++++++++++++
 tools/testing/selftests/iommu/iommufd_utils.h |  55 ++++++++++
 10 files changed, 619 insertions(+), 13 deletions(-)

--Z4b8nnA/cAQCd4Ug
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZaF7pwAKCRCFwuHvBreF
YX3yAP0bCfw55km2i2uu5mAhuZK2r0J5+VlSgb6BW3+POQfdlgEA/cecY2rTJjpw
u2hc5n+e2+p7OkqV37yWh4zVGm8OfAE=
=PF9p
-----END PGP SIGNATURE-----

--Z4b8nnA/cAQCd4Ug--

