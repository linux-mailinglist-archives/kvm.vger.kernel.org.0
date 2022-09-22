Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2756A5E57B0
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 03:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiIVBAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 21:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiIVBAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 21:00:34 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEF753D05
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 18:00:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVizuOG3w3iFdLDpuiSyytS8Zq732REbCoPGmayp8C1mSAVhyh+VQ8TvcMHOTvI5CmwTBSrwjIXU2EmYwJeJn4pa48HMY/pLp68iEZGi2wTHhYs98IcSA0er8Ov2NVGZ0N/gYFk1SNdjdUHZ9b4Wnxvmeaf5lzOEHvK5QUHJZ3mzVs+y0JtvUNKhYRNRIMNXlsNReEEBbV1HaqaECp9G2zZueiURtH/3dkvdP6JtYL/6bI91XacTaCX+LHuvX6rjX3OWVBJRCNA7zGB/+j/juNnw5ilqIcEsEogm3+YuUHJBteGVHiuv6rAK/zO9Co2P4niM172JzHTdpo3QVqhTPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oKb7G6eGDclgLSGzJWL3UgQNazkLemgUKk7Bl04NmhA=;
 b=VoQ/mYITDzfrn3gVSB6rZolNAm8KFl7410cdUenaOMM3QzytmAc5zUW2FBvWQLQkgaySflLbREnVD/Icl5DVW7Sspvm3PI+0s7K6dx1+8BPvnt1Kj2d10C8LAtSePmAefwoGpMaNTixN2KGFxJKx6tSA1XgRGXo4njRtPlHf0u/FvyOQ64I7/yVbgBA2v3h9Xw7nC2o40KBtFmEThZGDQQdnbuS91Qylud/8o0OsnX1lUvj8c3JR5hzCJkxKi8xg8SI6K1XrEPz/wHzPVYMWltruO8daAkSNq3t4kT1S4mO/GzShL7b+EiZ5XeEUfbu6QkJZrRaJVW+DWdtXYmTlHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKb7G6eGDclgLSGzJWL3UgQNazkLemgUKk7Bl04NmhA=;
 b=uW6CqqsUI82kKmVJY3YtlSmfvk4HevWwMWOnxzVjZo9sgFl+l2m88/S91N1FiVKBRZnmCqozCaAfIp82Jp0tnyY2V163x8CdkMN3GbkuR38A1d4oKfhedFwJNrcVy3YhQ7VIQ0jSNGIquoRyVx+S9uOX+v79oeKXexZlGKr4p9AtUMu7LzasQcLGNXCq6Iklcd0lnndZ3XXt4sF5EQIQ+/XLhKatE1cNCf2RuRRiz3EXAgijLOZYhlT221NFIDNGMBTAyXJEBKLde64iQB2rCDD4tDSkRv4CdRvznW5eeJdJ5Ghftt6g9w54uQnEkSQLnbX5wcmMlYNJHaup7IUZ+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DS7PR12MB5790.namprd12.prod.outlook.com (2603:10b6:8:75::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.17; Thu, 22 Sep
 2022 01:00:32 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.018; Thu, 22 Sep 2022
 01:00:31 +0000
Date:   Wed, 21 Sep 2022 22:00:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] vfio: Split the container code into a clean layer
 and dedicated file
Message-ID: <Yyuzrqe8PocywMld@nvidia.com>
References: <0-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
 <BN9PR11MB527613A28174EBE5450B4A218C4F9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527613A28174EBE5450B4A218C4F9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR19CA0057.namprd19.prod.outlook.com
 (2603:10b6:208:19b::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|DS7PR12MB5790:EE_
X-MS-Office365-Filtering-Correlation-Id: 29c2a666-9c0b-4edf-bbea-08da9c35d930
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hU3XZHx8QugeBGYdtzVdESa4/r6ZjzJ2pwTmRdhcIzN/oj9RWZvwZJfx1oJ9/z7H74zzqeWmVTLVJK/wTqk/M7t2JDRBdw9KA9VprHobMyG6eB/4qrDbXs4VWoAE9n6Y9UZBgY50u4lDSPDtMigZvdJvD+Mr/d0kwqvbiYGtEKOrl05p+XpqZrECl2fusRBHEUgE0PscsJkjtFzCVUr8+pTc1clCPBABVK5rGMihR9bwBdnnY+aA0XJz2QhVlKHVTl80lY9rOzo7R7p5w5o5Or+R+XfxUCdpt+gDrk1UWB26UAlAnh4Fmr85vy6ms+8SyvJlpCjwwQO6++pQy5SQbiZ42sLyfdQ+hZ/RPYKv759MYQsGpRQaw8WpaKu+isMJ3ai6mbZrldP6kVItGR4ltt9fMJ6LnSha9J6OL1PS2vlvvrr/xvxTyzRx0JWL8U4pqOmUAFZcQEskuL4P6fZqXMfWcd+cKp0nwzj99kM5xuAqY3pXSMWw7GzbPvVjV5TKyG6kYDi0GC9RFcMkduZo6yWRl/WX6irqjI7MCgMvDQ9DRLjHviks1K01DtDr91ntJDTwN0653e/tb6B3LpxgZFXhM+98ff4dlbgcuH+XiL3q0DUzPALhDITtkfM9zhxv1IoE+7llUoKDKa9V7y7+UM0hz520g/yRzbS2Fb+A8TwbwPF60Qu5ZnhpQ416DwZCy+44i3Ez2IQIN5XqsBaIjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(366004)(136003)(396003)(346002)(451199015)(86362001)(36756003)(38100700002)(41300700001)(26005)(6506007)(2906002)(83380400001)(6512007)(6916009)(186003)(8676002)(66476007)(316002)(5660300002)(6486002)(54906003)(8936002)(66946007)(66556008)(478600001)(4326008)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9BnMIkAy+hYtSD989YVv2W2Psan6nlsTuJsUgeqHHD6h3T1HoyYywEwvunAC?=
 =?us-ascii?Q?Jz+QEx3JXias0D5vSPbpUluRVtIPE72kUY9fMr+xXTdRxbsaohfSgCbem2DH?=
 =?us-ascii?Q?QidXgGFFHWg9PGbOvX4E3W8r6MMPVkDwrQwP9gL+Q0j5I62ORkKEd1D9sshV?=
 =?us-ascii?Q?ykQ7ShyRyTGLCIcAacki8Wg/Mtx94tg4RdZeGxQBWZEn6xHMydIDCRaTpuGf?=
 =?us-ascii?Q?80MJUPTzCvqR5RpRgbEUc0g7BqPftsXjDXtL2bYJaBTO12vH4m/xx6bIZOCs?=
 =?us-ascii?Q?nmTNjbRVC5wg7y3rVbx7GaXelAZTcxozTTU2YRc71vCBhP5CgREP40TWrN1w?=
 =?us-ascii?Q?VkBraTDgn9MFUiNO1Shu1GPR5zdnQQLlYlgj43UkJR3/idg9a7cxjwhXBYog?=
 =?us-ascii?Q?atM2FVXkO/rUY6Hb8c3Neaei3eg53Ck82VJyLfX6yzuY4YVR9UOq+fLS0ypt?=
 =?us-ascii?Q?W+SdVKpKOGi8Lg/KcyNmlyv2bBLuyRNuIZBtc05l+Gbumiiq/E7vJQ12xr38?=
 =?us-ascii?Q?Bg+u8JSwPu9deZEoiwqNetqEl527Yrpk9xNYfhPWDFXa8YsnYWjIqgl0ZtOB?=
 =?us-ascii?Q?tsw0XsJyyn6VrtquoFl8Q6W2IBsPxUlvEq0IQNW1fnoMhxDTfJVGmt2y/HkM?=
 =?us-ascii?Q?hJo8JMTyh4rh6s/gFLJ1gdI87nIiyN0JPf4uBGE+57pUMX/iYsT5b7a3XXvN?=
 =?us-ascii?Q?77BnngO6LiDi+M4o8tn7tQ3AZkBpt0nx3afGzjWWk+6VW/lD146cnSquVebj?=
 =?us-ascii?Q?u8+duSm+gUKqezEv2YHJTBrpCA/Zwm+eUK3jaBXL3t7QBuWRyhNmMg4hgV2V?=
 =?us-ascii?Q?y/2sE5/IVTZ7VLscKSg18FvUVsMqHUmF0C67aiYiqcOWOG4WdfzSJ66ASNKT?=
 =?us-ascii?Q?MZKQBlMrkims+p0Kc04/ITGUXFnPokIc1PQWqATN9m2eZBnDmdFrpN5fFGU6?=
 =?us-ascii?Q?iHic8YQkEq0srnfDo6t8CoQXUBulip1RNyswpgdn0tgopm4LQbKs75WigvVR?=
 =?us-ascii?Q?kXa73Hzz7+Tgj7VnsQWbGuUkXJ2jgxH78MZs7IzYreRy6c3jQ6silj8rOY9C?=
 =?us-ascii?Q?WMp+kzxPONtDCyoAZ/fkqrwvce0EcAUnWlZasFusbFjxG4wpuiMayfegmKOb?=
 =?us-ascii?Q?30O4HMCzBXrth9klyZBuS2CnIJY6Gtu4LXbJ31sTWTY+qTsNRdudp7a7qy9I?=
 =?us-ascii?Q?vFTy6+vFC6JexbkcFhu/HsWQc+8fVyksZkFVYOjCOABX+JVutHYIAwNFXquk?=
 =?us-ascii?Q?liCEJbnG5p12pJEs2IT6zhqHVnx8G59InU4j1Ilen7qvc8XzHysF1Y/8CjLa?=
 =?us-ascii?Q?oW4KdPtegIeI1R00iyslbDIVmOicpI2UZmm+fhiRWKrx9EC52yxCKJHJyfyr?=
 =?us-ascii?Q?6uLiODCEDLS39gwsIHRNh+8D5oZC59BJ/tldpi/TQynAj1iWg6iVUaxMWQ5h?=
 =?us-ascii?Q?F6+NQJbDct+rEMWiLLYn5SmyT+AjxlYwKISqIlypApmUHWzSwJ7n1du7mo+D?=
 =?us-ascii?Q?yrXRza+jVezzAIMDFz+KxVdTfpLwEMGybIe+3DDft4e5r5VlHqyTA0+Y5aL9?=
 =?us-ascii?Q?15XmUucdxoP6LtjAcoTmJINA+AsjY7Nlj6tNB9En?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29c2a666-9c0b-4edf-bbea-08da9c35d930
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 01:00:31.8958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vY+Ag1GPdnLA+s9nKBzYsf540rGB/8aFcJASgtbEL/f4duBgn34OhOlqcQl/iqBf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5790
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 08:07:42AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, September 21, 2022 8:42 AM
> >  drivers/vfio/Makefile    |   1 +
> >  drivers/vfio/container.c | 680 +++++++++++++++++++++++++++++++++++++
> >  drivers/vfio/vfio.h      |  56 ++++
> >  drivers/vfio/vfio_main.c | 708 ++-------------------------------------
> >  4 files changed, 765 insertions(+), 680 deletions(-)
> >  create mode 100644 drivers/vfio/container.c
> > 
> > 
> > base-commit: 245898eb9275ce31942cff95d0bdc7412ad3d589
> 
> it's not the latest vfio/next:

Ah, I did the rebase before I left for lpc..

There is a minor merge conflict with the stuff from the last week:

diff --cc drivers/vfio/Makefile
index d67c604d0407ef,d5ae6921eb4ece..00000000000000
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@@ -1,11 -1,10 +1,12 @@@
  # SPDX-License-Identifier: GPL-2.0
  vfio_virqfd-y := virqfd.o
  
 -vfio-y += container.o
 -vfio-y += vfio_main.o
 -
  obj-$(CONFIG_VFIO) += vfio.o
 +
 +vfio-y += vfio_main.o \
 +        iova_bitmap.o \
++        container.o
 +
  obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o

Alex, let me know if you want me to respin it

Thanks,
Jason
