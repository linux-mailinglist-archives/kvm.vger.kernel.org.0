Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EEC64DCD8
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 15:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiLOOZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 09:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiLOOZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 09:25:15 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92D22A265
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 06:25:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BFXUCM3ZWBfNRS+dKJ7PyA+Xaw5b6DlvuVECpnRvxxKW/DTHxQEGKkhpdOFh7QwfqyrcxNj6wEAEP8cbUMaAgJMekQqHDsAxco7U9qwelWlhq0SVerztyX94gkQT5QnfBkQi5n29Zi92i8SDR97TLhBA5/bUE+YOCo69cZMZD2XVWbDk7VkAyw4tU5RaM4Mc+6i1xqhtCv7/1DXXSo91aTyHEEDZJzxPQYyysY6urJMFaj+Un9uxDAznDvJsgoNIgqmNjjuO+Mm6ZdTxOTuzfULAAoTrOmEmtoGfCTAxNivH4PtO9nFPU6ICJXTncxgMYI56/PI8HwZz7DoT86WL1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RI1F/KeSZ27fJWdV6BBRK1H9yQ83dKe3V0gkwQ6Leoo=;
 b=DdhOBg7rkC9cPQbTLNNnwy89Tpug2Xk8B8vPZLSiGBQvk4BcVDqOPlOOI3Nl6bmKHA9WbfMqFTVfjXrptwpp3OyNbJLXfvZkja4XkOqqAt1PNQyByQkKyi6xVm4uJ05efTKk6PTKhoJt8zZj7uBadyXlBSutgCNP4gTOp2DhBWp4kw0oYSWjc8n4YW0zuml5C23uvKMKAV03VW9DbFWA5IReXDtYjQb8a6q+ztKue4ecCSVy6dtAFTvUyO+IuvAOFd5OEQZcGyoURAgCQ5VeO2qPPx6D/ZkQDNiD88vpVQHYKpm1jKSi/R3c+VUMr9NC5gSimc6sWG1ou6fOvlX9kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RI1F/KeSZ27fJWdV6BBRK1H9yQ83dKe3V0gkwQ6Leoo=;
 b=IdH7w7KBNWKtnYpiDCEA7eXKB57NJZPcnzudrr7Zvm076BsY7TBZ/ZXWoxn65UdZWk0p0+T7BHr5IJgb9KORd/i6KDIt0//H4BLU3DxS1iR35DF3nGdbwk/QtMfXqnOVWVDNpFnsB2Y5rHJzWOdcU/M0VvTjVbHSojYpdyb44gF2nlPD0UJCFiNGj6lWHRPGh4YdanKvhmFjYYDzGLX/9bT7XNOoqZr7MtX1FOq+w54HYKIRL9XXHMHoHZF0uZ/IzNpSFD0ck0bbwEN6pC+O4c4jhbWMBTLLNvG14GQf5uFukimWvbftYHY6enCypMRdrLNS9UjzJiAoiFezjovgSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB7573.namprd12.prod.outlook.com (2603:10b6:8:10f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Thu, 15 Dec
 2022 14:25:13 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 14:25:13 +0000
Date:   Thu, 15 Dec 2022 10:25:11 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Steve Sistare <steven.sistare@oracle.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V4 0/5] fixes for virtual address update
Message-ID: <Y5suR/nBlxnfJY0n@nvidia.com>
References: <1671053097-138498-1-git-send-email-steven.sistare@oracle.com>
 <20221214144229.43c8348d.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214144229.43c8348d.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR14CA0023.namprd14.prod.outlook.com
 (2603:10b6:208:23e::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB7573:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d6a4cd7-1077-42ee-34fb-08dadea82dc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yehpxo/rlCYbj81J+eFTqMVAJcaBrk3t3HM8VcK/9M1auGnQGuyF3qfdHWGN3txkzWsW3t2qSVnLQeU7A/+qI3oHB9gHMyXvm5j7XpIssptuqMf5r5Jexh6MJZ8cBk3OMGZBkw6YT2zJmv17OaUi2m4BNvsTYB47J64w8fbR6vB2HwRHJZMBlbwxUlzaYYOymrPUJkvaj1zbjF1ko/wsinSpMr2fTzWh+DdQOQO5Z7MzEN6X67+zTc1DtZVOTUC/rZEDi01FbuU5xcJSrfxNPiQy6obFEN0L8w5EglaNWnuXamo8MhxEoBcgt0gtRZwvUfZO9mhjDArjmOeFufS992LFIfOi174HawPXtFVLyCql+8IY5/LnWFO5KWPL8d0LD0Murlb79LVDUp8p0gsPVhMdPJoZbdL4syHb2E7DJgE5INvmknry9CgZKEsHH2aCfQ6BfOeF857obRk+hJmllKubFJj8eEiPkbX7aKZACE3t+nYqSZ0DTLYM/BbPcrflmmAYVrRDOS03cX9OFAzAUadCDd6gdmVDg23MAmHyYTWW0nq7mx+1WVJSfM5GjArpbxMnZcNhB1agMBuQ6Vg15V9QKOFmdp0zZucfG38EvMfxtpeY5HT13/3HXVaptfPpaYQkbyHb8JN/VK6Rpxkpkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(451199015)(38100700002)(478600001)(41300700001)(8936002)(86362001)(6486002)(4326008)(66556008)(186003)(6916009)(6506007)(2906002)(15650500001)(54906003)(26005)(6512007)(66476007)(316002)(83380400001)(8676002)(2616005)(5660300002)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xHUqvSkAkau9HKlELRhFWjFKcICWyqoTRbfvoyoWwkhbRx8PbLr4xGddeGku?=
 =?us-ascii?Q?iYC/m7tL/fjC+8cHupPMi+GPmxElnfI+efe5q3qdua6I0oehIxcHegKDYtfl?=
 =?us-ascii?Q?vUEasLIo6df4y3wPYiY1FP52qu4RfPzn7WKbo9rw1IaqCrQGMiyrQTP+8sgB?=
 =?us-ascii?Q?yhRiopnASXYsl+5AIJLFW4XEh4jMWQz+WSuiDI2kht2FNcOF/ODIVvobSjZV?=
 =?us-ascii?Q?zzuRYLypL6duQHUXiS/3cnqeRbPpYnohPm189KCBOzkFWD+V+TNxrZMcQRDL?=
 =?us-ascii?Q?zjyl4rrtYVONt4nd2dnlLPfw9ODQ3k/KBjxVF2qEE7WpO4H0CS+fcMv/Q4Aq?=
 =?us-ascii?Q?vEoMasmaox38EB4EaGLuPM5u3KhUhO4+DPEtbOwO5a3U0tXQKUkbkD82C42b?=
 =?us-ascii?Q?8Go4+iwm8plINRQFaWgMb5mBWv5NpRBHwcGLsecn4Dsp07kf3T266UFEghJ+?=
 =?us-ascii?Q?BfAQjdktb4h2vAynUFjq7GG1eXvulyOsVrJjFDv45jMHm9asNw0i+QJT0/CQ?=
 =?us-ascii?Q?AQj/lldfnMZhTRkRtlsTh2rx67RmE3TPcfMpVRU/iqWgWfWxsLiCz5ZsyAmN?=
 =?us-ascii?Q?LqpMz8HY+UHVyvvK+bWQnD6mMOdF73co+3s2mn6BNz+657buDduTedMuPFcx?=
 =?us-ascii?Q?cMoODGwwx076+P6O2YlLiYfRixCrgRAMcaMeNYRwzVZoSANLI1qJRfLUWvYv?=
 =?us-ascii?Q?O9QCWze8RHlI+OoK4yEA2FHLeL6PrqNiyzuCHKGsIlVuScqWr7LhyQYIJ1v7?=
 =?us-ascii?Q?qZjKB3cq/DC1DXNWGd+swrKKIwwTIECYC0ssJqBWuH2oK9f4lQpkOD6VasBI?=
 =?us-ascii?Q?AdWXARYpUsID+BEdpKmhcJMtZ8oMetXjPEEFVo8yrzgF3A13WeEn4qgu18Oq?=
 =?us-ascii?Q?PZzN+zxROJyNdVW+wYraqDPV4Vd5QWHUNt17aUibTN9KjlPBjR/JfZvmJ09T?=
 =?us-ascii?Q?SWAZoRihZWCdof5tsGZMawKM8pEgHZM4b9yans725bLAlV/rJOnuZJWK3M6j?=
 =?us-ascii?Q?0AX+QLuAQTlOiqU3W9RhJFFj3nn233JXjcUHXueTVtvkws6sgG2A0J3jLEIC?=
 =?us-ascii?Q?xrZGpDSSpYXS4sSwWRP/b4SPGU659MuZUY5/P3WZIRuqVns49NS7oFPFljod?=
 =?us-ascii?Q?ceYZW2Q2a8/Qq092pNMskcA0chdvHXDq20d4vdk5qhaKL4TAt/v2oT6c2xaj?=
 =?us-ascii?Q?wAZWfZV/4Spsxfruo41QhR6kZLBfX58TC7/Cmgp/xE06E3B3tuX/Oy+zEDXK?=
 =?us-ascii?Q?+sGKNtybjh0OxYAvfrPJ8oRqNsfl66ziqUxWxBh6jAS4bnh3CST8Dea48JRM?=
 =?us-ascii?Q?Nbx3eeVEPrSZ/qcRq4PjVV0XzotsOCiWifAcMh+ReapT+CmkXFv49/M+kvf9?=
 =?us-ascii?Q?iy9ZJgrGFo/H0xBs6+KE/slDtxhsJCDpZa2oa+sdpOI95gLWouf3FKyXljW+?=
 =?us-ascii?Q?8uQfltNNf6PktAQdcm9au/R58ksW0QlAhtejC8SpBtwnabIlEAfR3nVODfpx?=
 =?us-ascii?Q?YikrOjRqsH1lhCAVW0KaTI9Ydo/DbWH8uJFMThFkWvCgOz2yIZCp2+nnxBAc?=
 =?us-ascii?Q?xqvzHjfSgreSESD5CBFvXkLEGC3Xfo2G0Bh7l0NW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d6a4cd7-1077-42ee-34fb-08dadea82dc8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 14:25:13.1251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y0dDp67wDYrmZZn3DK/qyJH1MAXMxB28pbo/bKlBHeZxrRp+0eOGj+Iami2pTyjK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7573
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 02:42:29PM -0700, Alex Williamson wrote:
> On Wed, 14 Dec 2022 13:24:52 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
> > Fix bugs in the interfaces that allow the underlying memory object of an
> > iova range to be mapped in a new address space.  They allow userland to
> > indefinitely block vfio mediated device kernel threads, and do not
> > propagate the locked_vm count to a new mm.
> > 
> > The fixes impose restrictions that eliminate waiting conditions, so
> > revert the dead code:
> >   commit 898b9eaeb3fe ("vfio/type1: block on invalid vaddr")
> >   commit 487ace134053 ("vfio/type1: implement notify callback")
> >   commit ec5e32940cc9 ("vfio: iommu driver notify callback")
> > 
> > Changes in V2 (thanks Alex):
> >   * do not allow group attach while vaddrs are invalid
> >   * add patches to delete dead code
> >   * add WARN_ON for never-should-happen conditions
> >   * check for changed mm in unmap.
> >   * check for vfio_lock_acct failure in remap
> > 
> > Changes in V3 (ditto!):
> >   * return errno at WARN_ON sites, and make it unique
> >   * correctly check for dma task mm change
> >   * change dma owner to current when vaddr is updated
> >   * add Fixes to commit messages
> >   * refactored new code in vfio_dma_do_map
> > 
> > Changes in V4:
> >   * misc cosmetic changes
> > 
> > Steve Sistare (5):
> >   vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
> >   vfio/type1: prevent locked_vm underflow
> >   vfio/type1: revert "block on invalid vaddr"
> >   vfio/type1: revert "implement notify callback"
> >   vfio: revert "iommu driver notify callback"
> > 
> >  drivers/vfio/container.c        |   5 -
> >  drivers/vfio/vfio.h             |   7 --
> >  drivers/vfio/vfio_iommu_type1.c | 199 +++++++++++++++++++---------------------
> >  include/uapi/linux/vfio.h       |  15 +--
> >  4 files changed, 103 insertions(+), 123 deletions(-)
> > 
> 
> Looks ok to me.  Jason, Kevin, I'd appreciate your reviews regarding
> whether this sufficiently addresses the outstanding issues to keep this
> interface around until we have a re-implementation in iommufd.  Thanks,

Well, patch 3 undeniably solves the deadlock problem.

I still don't like that we are keeping this, an interface that doesn't
support mdevs has no future and can't really be used in any general
purpose way.

Can we at least protect it with a kconfig && CONFIG_EXPERIMENTAL so it
is disabled in most builds?

Jason
