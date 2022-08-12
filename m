Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60A6591478
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 18:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239414AbiHLQ6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 12:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239335AbiHLQ6Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 12:58:24 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2074.outbound.protection.outlook.com [40.107.101.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89930B0B36;
        Fri, 12 Aug 2022 09:58:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8PvCzKIWGmDeIXD2e4xPjbOC1uE0X23ptLmJ+hMoF49EwX5vLt7S4nOw/w24drqMN5daqY9ELIZv8MnT7Wx3kXTNJ5EA/ohCJHP3jOJzkV5MyCj0/8p3kNVbDyas8wiqTzI3JMD7Y1R8MPkzeLyGQDa336KSBtUIO4AmObYu8Zb8Z/IjtYpgGAME5G4Gu+jjL0xRJh6YCr3fSZc2fO79ljIPtYpIlPzGcL3ke1r92ztLqefUKpJGVvBszDflDQ68H5mmTpyGLEOPHeeRYA/t8h72pstxr95lOxUFnXtXG7dcfyorqR0+Xu3c4oIjl8NetqBJY7z4C8PaML3x1L8zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yOoFt5InNsZY83g8n0/ykg9r2by5Nzqk2Wvouu+oRlQ=;
 b=UJVIITSk+TTHpmmQOBicL1xoYW38V0aIU/CDmGQ59pZWk9KVZuN5jSKi14VB8BKZ6EhazP5U29uYcgNz1cfDc9g3MhmTTMN6vcyA731pEzM58jtg7cHGJlxT1zVLQqHqxlfqtL/X9qiUmT/SslboAh3ynR8AnG62P8MkWbArRn+mocpzLG4651Bs+Ak7G14VywqRm5sI7Z1o+NgvFRXwh5r8CXxRgrnjZ1Gs7pSQwU475/CIg75iLVWGVhBTMrUmQq7g9n7Ngz0gCXHS6zI3v30TK2+hYDoasoBVoonu9Av/qDnNMV9rvaMA3SzkuQTz4wLowoaUTJ/SP2AUKXJJJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yOoFt5InNsZY83g8n0/ykg9r2by5Nzqk2Wvouu+oRlQ=;
 b=IUl/M36rutrjAhYtYE/y0u2Yrn8vJeOEza7EH88LAjjuEII2NY5VLZ87j7d17TFQszC9HBRDyRGH/VXtteDa/RHzljCNfydG8gjNZF2wLfbl0etNU3/FHmgUY0+Si9iuKApaWBxGfNx+F3vFtbyROcWeFr4v61NILCBisQbus+hR/C9oSr+c8JmUI6qjnMIf9N80VVazWlvOdt98Y8ug5Ot5ENDVejjuF56uUBn8zKM304IZvK0x8AnYSUpqGkeTidCExvbau3vpmjy5h9A7ltIbGg/3Y4vyXEAGD2OFJ2wchVCo/+nIW8RNeaL8Xu3XdV8UFaublrRgxmXI1DJXqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR12MB1237.namprd12.prod.outlook.com (2603:10b6:903:3e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Fri, 12 Aug
 2022 16:58:22 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.011; Fri, 12 Aug 2022
 16:58:22 +0000
Date:   Fri, 12 Aug 2022 13:58:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] VFIO updates for v6.0-rc1 (part 2)
Message-ID: <YvaGrD94Ttd8lGWi@nvidia.com>
References: <20220811153632.0ce73f72.alex.williamson@redhat.com>
 <CAHk-=wgfqqMMQG+woPEpAOyn8FkMQDqxq6k0OLKajZNGa7Jsfg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgfqqMMQG+woPEpAOyn8FkMQDqxq6k0OLKajZNGa7Jsfg@mail.gmail.com>
X-ClientProxiedBy: MN2PR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::11) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ade4afcc-2701-479d-7a4c-08da7c83dd21
X-MS-TrafficTypeDiagnostic: CY4PR12MB1237:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bN2itMY2wQWWVqqbxfUekHWaAb7LnOPdgFcExqp1rbU70dj3egpUkegRP8wEfJcpeyZzrqKashNSAiGTZ+dyygSSHZKQrBCoBy6AONjgjbY+3NwrbOcl4r41eb5O09bCLlpm0ya99pPB6k+/P3KG/BS/1KNee2q7oBZl4aGVH6FVi3RWWUmkqqFt81A/P5Gs8+uCEMCh3WRO0IutjBVEukapZrEARYmLwbkdW3rycwfZiRNeDG2lXLz+fGoxsed5RPeVE2coZiKyyYUwoyr+SmuRFlYi/Di3ST5cUnOTuKIwxJmcp3rYYKWuV/3Ox2oCuuC5/ilrZd1GRyb9YPVFLIumIlQR826Oyi5mbecGVW15MMqQmC4CloShzMThYbCCn3mMjyV2TCYlBhU7rjLGY5whNsDTWkYnN4LP0WJPHXeWit0pwicqFWroMd/CK+wvAppMtvQem8XpsbLaI7Tck5jiDpa9J2F/xfBgR+iKuUZ9l6pZDTde6X8aTda4rqTP17ZE9J4xlOplJKO8nWWZGDn2Zuz51NCCEsOQLrkQMykIXWBn3rbMYTp75cTj7QKxTXZll2eI+wey7xtTfkpOOdOmAPdHVfaJ1W70Zj44tWUmL5CZREKqoYLDqsk1ucfoohvQcMpS5TdTjEP4QzyTUhKH+dDJv7ZaOPQI5tZCHxhGO3ckABz64QaPgTlnQLHinpOEb78AjVUH4k4wPr1xh+mohbX9iJ1byvJt4jc7MLQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(26005)(6486002)(6512007)(53546011)(41300700001)(38100700002)(186003)(6506007)(86362001)(83380400001)(66476007)(4326008)(316002)(66946007)(8676002)(66556008)(2616005)(2906002)(8936002)(5660300002)(478600001)(54906003)(6916009)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9552DfrU2xFw4Lan0Ln7VUp9jgb29nTpXDLUQVzKLQ0bZvhrrjobpuDFhj8q?=
 =?us-ascii?Q?/vgiYajt8cZWX2/X7kJXQOWiPXqRXuFs3OeDxCjJVEosFBDZ2pzn73udenHl?=
 =?us-ascii?Q?nEi/L5cMJLaFnqinTnMgYHnVc9jv83E+p5bShK9TAHFcAm/w8a9RZBGKXEcB?=
 =?us-ascii?Q?hnS8YPL+6CpmR01OM1IJtSsMgLlTR7LRz/HIz0Q1NKDyXhSuG6LB7vE/Zkaz?=
 =?us-ascii?Q?KsNKBPhoY+XBofkuvWNq5k6j/OqgqmciLBeolCxzlNqoVQQaq20kOTIF4kqx?=
 =?us-ascii?Q?UgjrjlE7wDYMvlf/b36lFLdmKNpelBr0qOY/XhkyD8DvRnYU+K+dAbtZnHMB?=
 =?us-ascii?Q?EKzLwLi6nb5uIgvPDwN4SMvV5SZX9VP/g1SnPgtee01THct56qIbfU6P/nw2?=
 =?us-ascii?Q?UN2uv2D3hIKY1Wy6VU0llYm7QiLcZo0MIH0TTu+D+62JjLL3Ewq9sSze8nQW?=
 =?us-ascii?Q?CyWhDuQlinQY40VUuMWauhDqwJPjYbeTwwjCooRLRixy3nmZ4/+SwIFh5WOA?=
 =?us-ascii?Q?rP+jIuNojNlJv1dIGzBYq+WWUefnDzeYe9xAoP0OjzcQrAGdnft+POIGk8tT?=
 =?us-ascii?Q?IroBmORLI6UWuBec14WKzURyFTSuiKGdEADepRx+EB9sASsdeLpW6iwGmHqq?=
 =?us-ascii?Q?KUZ6319GcRLVbX0ADOVEVmDaVltC+CeyUX4tUHDcKBa9yRFRNpRP59Ey1C70?=
 =?us-ascii?Q?lPoctdfCHGEOdrYd1uNdFsnAnBqFapbkeMga6pZajH1G4PMFz2bTRPV3mThL?=
 =?us-ascii?Q?kYwHe8pjpiFrGNzMX1zlH89WgY9qUGzuIXwxZA13WbG+aiPvmczTUx+Fuj3/?=
 =?us-ascii?Q?fT+6s6HlaNQsE+9gVSuW/Ygw+EwyCo1IpdtB6U0vA+avECoWO7p0xO+JXfoM?=
 =?us-ascii?Q?5v9jlKtym/hgWO9eNMS13XZMRTbzQ2+J7FeV+yiMMSPbH1X4clHHIDSy4IMk?=
 =?us-ascii?Q?f9bC5TPyyS9FIpqrp4WrzFlV2nsOIrCOGLMAm4rEuknEiLTbiNKKzsmfaEg8?=
 =?us-ascii?Q?/xpPaMkYJJDliDLk0ZSxM+yOp6UhC5KAH10hZltsMTeqvuf1G4pNpG+3CSh4?=
 =?us-ascii?Q?seu69RpI9mA0y4GtFj1GM4PmQKRwBBk3Cnq1i2RX/qpdL1RbDq3K7LLNvkzv?=
 =?us-ascii?Q?oq4ldmZjNH8iepH54kM5+oIzCD6T0Fa6A1veZh6aVlgLVBtZL4sQzsSKUYly?=
 =?us-ascii?Q?3cRYvp+6nbk5uvYVCYDMthujAbnWO6BV5W2PTCpjTpue2krj1uqZ/z8a3pvt?=
 =?us-ascii?Q?irbAtbexqHdwBPFXI8c1M15D75JM/tSxeNrpIj8N7U9XNSfhWtkJxg7m0hoo?=
 =?us-ascii?Q?CS6yBBYU2V2SYEw4YLikPruc6FhkDzGqQGO9ypw0BP9gqkN8db2YXrreUvHm?=
 =?us-ascii?Q?Tyyo3hOvI7i6u5+SzGmtIcUKxGYnuv0uMqmMCHpa4sBtfqtcyVxj2SAaYwv/?=
 =?us-ascii?Q?DwA5fLSiBkcLq658kSbSYJNQuzC7M5cC90X0ylRMl1TKhQZaEKRircKIR78E?=
 =?us-ascii?Q?czeQx3XWd3PKyFgDZU1fu7vBhWpjecmoNMrLqf95R5wS5GvDzhzVOKTKHOkW?=
 =?us-ascii?Q?Chy2RXlBWmMJ8d8xyVBthTndFG3/I5wqrI7qrUYD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ade4afcc-2701-479d-7a4c-08da7c83dd21
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 16:58:22.0286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GhGtl0rNbR36PNY76dHhq6lZPNU3MkR555liMzr+lYok8KPKaAnjwMDeAF58wL/5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1237
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 12, 2022 at 09:35:34AM -0700, Linus Torvalds wrote:
> On Thu, Aug 11, 2022 at 2:36 PM Alex Williamson
> <alex.williamson@redhat.com> wrote:
> >
> >  - Rename vfio source file to more easily allow additional source
> >    files in the upcoming development cycles (Jason Gunthorpe)
> >
> > ----------------------------------------------------------------
> > Jason Gunthorpe (1):
> >       vfio: Move vfio.c to vfio_main.c
> >
> >  drivers/vfio/Makefile                | 2 ++
> >  drivers/vfio/{vfio.c => vfio_main.c} | 0
> 
> Guys, why do you do this ludicrously redundant file naming?
> 
> The directory is called "vfio".
> 
> Why is every file in it called "vfio_xyzzy.c"?

I think this is partly a historical artifact because each of the files
in the directory are compiling to actual kernel modules so the file
name has to have vfio_ in it to fit into the global module namespace.

Now, there is no reason I can see for all these files to be different
modules, but that is how it is, and because we have some module
parameters changing it is API breaking..

> So I've pulled this, since hey, "maintainer preference" and me not
> really having a lot of reason to *care*, but when I get this kind of
> pure rename pull request, I just have to pipe up about how silly and
> pointless the new name seems to be.

We can start to fix it up. I'm working on splitting that file up
further right now, so I will name the new ones container.c, group.c
and then we can resonably rename what is left as device.c - this would
logically match the object structure in the code at least.

Newer parts are already using non-prefix'd names:

$ ls drivers/vfio/pci/mlx5/
cmd.c  cmd.h  Kconfig  main.c  Makefile

> And if you don't use autocomplete, and actually type things out fully,
> doesn't that double redundant 'vtio' bother you even *more*?

Honestly, not really.. It is is just yet another tab in the bash
autocomplete, and vscode's filename searcher makes it irrelevant.

I'll watch out for it in future, eg I see I just merged
drivers/infiniband/hw/erdma/ and they used prefixes too.

Thanks,
Jason
