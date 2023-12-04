Return-Path: <kvm+bounces-3404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 642D6803E7C
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 20:35:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B8E81C20A96
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 19:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DB4031754;
	Mon,  4 Dec 2023 19:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S8ohafIA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B18E6;
	Mon,  4 Dec 2023 11:35:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktiSeEu+SVWuZDN4xa5+i7XGBcHqWwrJKH/KXusmZXZmkl4BqPGUF0pym1Ia/K0S0X5Gd4An+hzIZyX9iewh/sHdFo0cFyLxJuFaXEVX3tQtNNOtAuh5Lk6G7O8fyuXHc9WC1mFnOmlWGdUrQtjnJ/f0MeoJuxfaGVP+64ljBP+8u170YiA7EzYa9xixxCPbPxNeOrburM5sz5FxrGhxD7167q20P+vu6iHx6ZYdHaRFZtPPsD4Y5rbseERSIpJqnNYZeyD7b3NX6BxrLpWOkJWD0shYHEi/1WK0TBdwf+U0QekIukZeem/oB6/q6d1QpX8cq4/fFxGPw2ue8rZsOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=faSNB9Eimry/M1EVNLy6jhmEtmnsx4cmm2a9Ro7T1m8=;
 b=PBzkn3vgOXapv1XHHLFZTPYH8jFwQpuoRQJ8ztROtjaPmQIQfqOXHIqfKc67V42reWAQT0J/2Vp1MzWPcpuymPjdPHYPQU5OznAtPWJt03uQobHv12Y+sYdzjfdpWJCpV2bZQriGAHTxAeAtamYHUzatLB7ayqimF4YJrW8VmUdA4TIqabKa64bjV8DMqhQTgxUNS4ex8USCJF58WLDCXLKGuiqQhJB45OyCCdDQSAkqhc6cjJqSdG4UHMF9iivC29SXjqjzQh4fc5qmJzoNTt0Mzf3UEI4UULuCcUieI3uGUaKYNqtrGecLcbOq6UDWQB8V1BYySTLi9Ue8rDyxcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=faSNB9Eimry/M1EVNLy6jhmEtmnsx4cmm2a9Ro7T1m8=;
 b=S8ohafIAM40da5hJl3f/LlV8tzuH0A8ggP/ZkTfaAbep3+f/zsYHTPhekf7fgAsE4HvY1AJHObHbN379Ep3GOTMR8ZjaC/++Et+dEKUQDHbri5Sp/bM0ghJ+07itveDG8wlHbMB/zHSz8dTXWfmcb5VpESE7MzndTNH1rIHIVAqRBDNPtfPe4OyfeR1Qux71GN84wNIlVxAtP2RnEJz/ZXUq4f4S9ZCiE/no1yIhyglfNeaTJA+JdTNEBNJpYhEhxgNfa4EER7bWtiXpdCjCfj7F65y/xVAMcJbmLq/DSHA9RpSHbQtzEvUxmW3ochbuTtXp8wEPwnjtMXdTnti4nw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB9424.namprd12.prod.outlook.com (2603:10b6:8:1b4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Mon, 4 Dec
 2023 19:35:35 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 19:35:35 +0000
Date: Mon, 4 Dec 2023 15:35:34 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20231204193534.GA2755851@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vuknMnMpAQTya69l"
Content-Disposition: inline
X-ClientProxiedBy: BL1PR13CA0248.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB9424:EE_
X-MS-Office365-Filtering-Correlation-Id: 98903aa5-3260-4471-b2de-08dbf5002fc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	33AuZRBKi/eSONkkCB79NL0ygKwlDM5TBgupyNRHyPIRCEfpxKFg+Iin74W8dJwYgt2jTfmqMYmVjkHr8hOMKCLl4mhBUgZCMm/rgad6h5U4m10lSJ66G/G5JBFsGzE5nPs7bP1pD0YkQvBEoXDbR2QZbpOkvAptlECFJYf5hs9tKYbRhQaKgRFWzB0GNQy5nbPTN80Pf6prLwBAoRtHS6hbTdT5Ces6zZBfB60Ax34CflOHi3eCg0802iy8C70J3kZ7EJzTvS9Nr7x/yHbNQ5FZwUP6UBddvM3wz/oAigR1EayQDAdjmTq8e8DXC9hObJuplK+q4hLlgN1hs3TKGdk1TwDu/RVUnnPTROXZ5qtToU1Ub6a2o6b61RGFHyIiG6gb6mBUOT82lzHgYk5Gup48rUsEZIyp7rqbDW2SFYMaeFODNaOD4Au/N0qWglP4N5OC+ofZ/LbzYSF+L6M16vlEfa4kW9g9HBtysgxFRyufYXQB21028YnQxivhc7xRT5kZLFAwAidRyAuv75oNafQMYg9GyfeB3v/WymAVShdy2L3LRCNG+bVRrJ1UxYSE90MMl8OVIrc3GHa/X1K0J4NlxWftjGAb1uukWw0WcnA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(376002)(396003)(39860400002)(346002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(6916009)(66556008)(66476007)(66946007)(8676002)(8936002)(4326008)(316002)(6486002)(478600001)(5660300002)(36756003)(41300700001)(33656002)(2906002)(4001150100001)(86362001)(83380400001)(21480400003)(2616005)(26005)(1076003)(38100700002)(6506007)(44144004)(6512007)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E9Qda5GXjhxl04dRbjufEXMGRA5M57NCI5L1GSicNXrRWoUzLpk7bsWZ2Dhc?=
 =?us-ascii?Q?jgThzETOY8lsjdW4jVPISWxAG1I5UVmLEOoCQXV2RmEvUQC2zChb3PsLZEF4?=
 =?us-ascii?Q?9gt+Z0DKTlJLFCOwJwq3lILAVTiI2WOG1jFTpMJVhTM3s4u2MUlLJidHdusb?=
 =?us-ascii?Q?13v3wUE4sQpHDl3WN9wDv6A36C/TOT8e2nN7Ct8r/E2YQIWHMWtdLW2yV2M2?=
 =?us-ascii?Q?wilvcZso+8I7th17piN5ESzvpI9J5tlnPrSvhOiKCQn9S+jzrSKagsIQMmzj?=
 =?us-ascii?Q?uUAs1nmUIL98moaFosjAe2xGiyflRwPfXDVm9Ks/IaXT8FLFRdjFDxEsO4q2?=
 =?us-ascii?Q?JuqEW2meDcJbEcUZNEDQ+P7OKj2bSaomqomSG47JPSdTDsG5+uLS8BH6smGl?=
 =?us-ascii?Q?+Ze7R0L40+Y9IitzzmrkVKQMm+UmEj+A/3A/v/AkXELhimSFvicDSvkwqvea?=
 =?us-ascii?Q?SKbuvv/wQGnUsOJZ9RSthCbKXiE8e+ygazG+r5bWkMstCmAZuxJG8jVwJ3EU?=
 =?us-ascii?Q?dMsc8FSOXQFHkU6T84DjUCeTZbBBHhMV3K3qQb8qEI62uo7FqYdhJ9HEFjQw?=
 =?us-ascii?Q?rpIWeZl7/oFJlwR2rWCgMXACtISvl36A8gD9ArEnMNVoT9UrJv8wSzwWGOYd?=
 =?us-ascii?Q?vwNkCvdOYLGh9u3ER/YMUU4OPDOUK7Zw3pH2IBJ068fBw4pXZT9fBm9irdT6?=
 =?us-ascii?Q?yysEzKBOpfMRL9ShGAnveAEDdn+MZsybij7IDbRvxbzTu9gRLWNC85g/w0BB?=
 =?us-ascii?Q?1kPf78qCwX4zznRQIsLle6eVRmYBfn5/CuYOr9E0Vte0k8WXPGBUhb61r2VZ?=
 =?us-ascii?Q?mivfDEC2I0G1PpJKGhbWbEYcwD79k/g4EVIQlkwiT1zV/Zqk06oUxQ0XGZzL?=
 =?us-ascii?Q?Lzx0NccZEiTJ5tWdk6h0GAHezC61GnMVcWBZ7+2JQudQu1QecK1UetFJYvAI?=
 =?us-ascii?Q?tYgCAPGONopTnELvtVbM+zoY9WoG+0JLw2zLTR4kmq0UmtHpV153ZwAJAE3t?=
 =?us-ascii?Q?nnGXEUaegE2Tjnq7IrOgnSIxlJTKTqYC6fYzIdgRvHTPKuyHeaE8St2vxGgs?=
 =?us-ascii?Q?Wyczqpl4uB92h2ce0gBWLeRzukIJu6m5QindblNbhwNn73WSN0PGHHpcT6qU?=
 =?us-ascii?Q?1TTAoAvROLeogA4T6WlGdjgwi6G69OSIBYYHNx8pVobflfplDPUWX/N3qPUx?=
 =?us-ascii?Q?XTnU7vThIbvti8cOmG9m5ckV/AwgajxX5VWew/ceWlCuk6v+M83kME9WORBP?=
 =?us-ascii?Q?zCXz6w8ekqjQ1JxMQSG2a/qv++pKAONFhbnv1DJZqOOhUidsLSKwLHsNEWrI?=
 =?us-ascii?Q?Qma9cRm6D5QCZRpTrwWqmPGhU8v5gMovYNk5D0Tu/hvrRUpJl9vIt+crr/hZ?=
 =?us-ascii?Q?ORedy1vyF6N0l+2CqlDtK2wLcOVPvMgJd6qpDVfMpUN9DanFCFinltgw4/ro?=
 =?us-ascii?Q?Oe20jRLUUQDmYS3ch7h0V46ji7yhjPxy60AH1wj54cljUYXkRuZQmOhphHIt?=
 =?us-ascii?Q?IE8vgMsKTO0Ghcl1TDHydmSc6ruieNNMra6//d2rIklXKZaEARrnsn2Cz6ve?=
 =?us-ascii?Q?0QgxzV+Av7Q77ZWTphTLrjjNpdyoyd8sKZtLvlk5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98903aa5-3260-4471-b2de-08dbf5002fc1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 19:35:35.4433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y3oafJ3nhClVMGaGkFkRLty5sCItEPbRtis8bRWW44VrUEBPDpsTZV8G7P9bMtkO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9424

--vuknMnMpAQTya69l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Two bug fixes for the rc cycle.

Thanks,
Jason

The following changes since commit 98b1cc82c4affc16f5598d4fa14b1858671b2263:

  Linux 6.7-rc2 (2023-11-19 15:02:14 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to 6f9c4d8c468c189d6dc470324bd52955f8aa0a10:

  iommufd: Do not UAF during iommufd_put_object() (2023-11-29 20:30:03 -0400)

----------------------------------------------------------------
iommufd 6.7 first rc pull request

A small fix for the dirty tracking self test to fail correctly if the code
is buggy.

Fix a tricky syzkaller race UAF with object reference counting.

----------------------------------------------------------------
Jason Gunthorpe (2):
      iommufd: Add iommufd_ctx to iommufd_put_object()
      iommufd: Do not UAF during iommufd_put_object()

Robin Murphy (1):
      iommufd/selftest: Fix _test_mock_dirty_bitmaps()

 drivers/iommu/iommufd/device.c                |  14 +--
 drivers/iommu/iommufd/hw_pagetable.c          |   8 +-
 drivers/iommu/iommufd/ioas.c                  |  14 +--
 drivers/iommu/iommufd/iommufd_private.h       |  70 +++++++++---
 drivers/iommu/iommufd/main.c                  | 146 ++++++++++++++------------
 drivers/iommu/iommufd/selftest.c              |  14 +--
 drivers/iommu/iommufd/vfio_compat.c           |  18 ++--
 tools/testing/selftests/iommu/iommufd_utils.h |  13 ++-
 8 files changed, 177 insertions(+), 120 deletions(-)

--vuknMnMpAQTya69l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZW4qAwAKCRCFwuHvBreF
YYlSAP0dpavdQPVzswi60L1z82l6kwxCFijbfWgArmDGjkJL7QEAgFW4KoiRhcB3
PjPmnke+sVL+k7fzE9xzJrNkuTLDBgk=
=gJmS
-----END PGP SIGNATURE-----

--vuknMnMpAQTya69l--

