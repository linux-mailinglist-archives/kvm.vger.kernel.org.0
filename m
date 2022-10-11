Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BE65FB861
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 18:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiJKQkd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 12:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiJKQka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 12:40:30 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A218AA2235
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 09:40:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+m/1arGRXOBU47bYfBmF/KvciDQTve/l7TGA9xhaP9m2RD9rZmhtzOMDBCFZ9gOC5orRmNUG+Jt6a0ujtvkqIqh3uRpvbCwAsLD8BBBITf6T1dybIrxlu78Pf0XtfIVDQpbRBac71hvfztLp6x22zbTbezelArUjlNxYiDVpeasVxTcER6m5umBCfr9gZLY5jHceKOYp1Ty15/XxfvSD1VHw7z/GFEqvlYMxHKF6eUOJJtoNYuBB1Nb2ttijkr/euMCs8DdYxtTuIujt8sHcz/nh1A7diEw+maSF35NMi4Tv16I2+KUH1Qvv++COjdvVPGrEGmeE0VlQUArFJnqbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3H38aXrdJl4zKmRtGLJq3IM9JjnD6Oii30XzJol3fok=;
 b=f8mccKiB2j9pdUC/egarYm7Z3frvctiZ2E/xeI0WfJDc8GuBH8cxvTWW/AG0MT44gZBPZP4R8cX8sS+ppMiBzfy0nSgQ1/TmwlTZo1qjd6B894wyQPct1XW1OJXhForowuYBlf/LkYqmdn/inCdGCy/T6R74APrkQbSPayg0QVHFq5rjOT3UPJ+XjxBzCsOvWN4/jnp85WMozpg5oLSFou/oe2oTvgS51XZ6nv2BrdqIyBll/UBg+t6FNsZUchoBlIAqXuDL3pMzhYZLWGRZZm5KlBINIwBFfsoWuOBa9UDFb3XVCqvLuPUe9nXFwOMVHNWu6I401XsfNMa1LBJF7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3H38aXrdJl4zKmRtGLJq3IM9JjnD6Oii30XzJol3fok=;
 b=BlosdIZyGwZjOrJA/rtDg1RU81gWUT2RWDINJNp17ZHa9frTit113Kds38Gktf8Ho9DUcF8ApsRpVC+T2dh889GfYFLfJ9HWRzarW1UKXU/Vo0R4R6oS05xVPB9TcwiLxM3hqJySnoDroxkpvfRynQ7Jj/ysxNzFcldvzdd6hyS9s1o5ZVR4os3+hs9i+R8u0wJMSFOSkTaZmSqpK8xy7NMsaPjTgaQz7RYtLWWmB9mnm0vpAVQOUHg6Chs1Vmcf5ZPbVRNgIgZWIQ19JjJvZAE6QY5IjrD0Ji7g9MwQ+88Ctcj4gO5ZkeLh5IlRY/xKDgAhgSs0lKdQtNv0VgAWKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5104.namprd12.prod.outlook.com (2603:10b6:5:393::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Tue, 11 Oct
 2022 16:40:26 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Tue, 11 Oct 2022
 16:40:26 +0000
Date:   Tue, 11 Oct 2022 13:40:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/4] vfio: Fold vfio_virqfd.ko into vfio.ko
Message-ID: <Y0WceKm7xzJZprtP@nvidia.com>
References: <0-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
 <4-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
 <Y0PF/fcZ/6gzy1JL@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0PF/fcZ/6gzy1JL@infradead.org>
X-ClientProxiedBy: BLAPR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:208:32a::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5104:EE_
X-MS-Office365-Filtering-Correlation-Id: 867a82bc-1456-42b4-8dd2-08daaba74c95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /qGgfYIdvNBBxfasuFd4XjjrlUbNArjzSObb7nxWQv28NoJ6++dFvR2T5D5xjBMGvSsO4g2GRJbBzPqFw7wMHG/GMohwjtepZgEuXV00GpX+4cak2z4k3hhwyYrzTSgsNjjbYyaWqHEctYVXCFICVPpeHvAKNkDPzi4e91qM2x7IwaohbQyWXciKV6ph8TgMzFKHqlpswdkjDpBUZd2vxu9QQM+OKgeIMYPIsnR4lB3jUcYIJKtxQfgoJL/RcGXgnI/Y0rqbbm2a1Dw7pvpMtLCWVJJiAjOiEe7ifjZgnx4ulk3UaguZYq5xDYiULmf/5itzc3fLWYEhVCYqIjh9p2dhaCguJmjgnI+j9QihzMnhhUVOQgN4zNaO0vJYZOQAONf2a5pHPbz7/aPrwNteXOcJ3PYl5ieeUqdjTuI31z6juUXhMnwvYhBo2wFSCNbWYR3AQLZpfNzQv35piJBOSGxlCaYnIBJxhyx3HtjP/k1REGbiAwsb8WvIspRqfYfTa2sbRJ3odS39shyZLi7wFyRWdvGojbg/BnE2hSYY5aSTkgBd77GznbiLpcDhCuDWJbtKryIk7Slvfq2HMurcc6/l/FgU8RncZkeunJsWGCDjO+CrBqgHRV1mzyeqK9ytkxCK44AqM4nXu13/nHl4jGiJqaGJVgssqhiJXMcAFapSMuZZiF7FFLFrOgrGJoR4oKtRdo7F/ye1PFBdriEp4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(366004)(376002)(346002)(451199015)(6512007)(26005)(316002)(6916009)(38100700002)(6486002)(8676002)(54906003)(36756003)(86362001)(2616005)(186003)(6506007)(478600001)(5660300002)(4744005)(2906002)(8936002)(41300700001)(66946007)(4326008)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?comFL3URCmfKjrkm5dECem4DhA5PwI1AKKj1EAmcDWP5ZEgNHtMfxYX/UfdH?=
 =?us-ascii?Q?MZfp6Ywxr86IVLR1Tscv5UMCWZTjgEdHuaial7CH/Y7ia/I7SX1dNglDikqG?=
 =?us-ascii?Q?FB0WYDfuMtkRK+rScMtJz22K9ryzKqCvy/jQOBcW7muLNlQI0ddY6r5N168F?=
 =?us-ascii?Q?ToUT5X0/2ODtigI/Y3m6c/CqnWEtW7I03ef+2cuiwpN5zTUSEKcUFyJI7l4D?=
 =?us-ascii?Q?8ot3KvrJlbC/flf9o/SKTMtjRkZ1Nwyr+E22p96q1HOX4cGOygF0BPlVLrC1?=
 =?us-ascii?Q?b7UnzcF/D8mEjQOYIT/IqUXPwJN0TKA15rGaVd7L+E0NQbjqFi2A4Qo0758c?=
 =?us-ascii?Q?ZW3NMgSjWR7HqelMEbLOtknSEubbwL2zuHZ4Unw4alOkamKDNTZB+HHYyPtt?=
 =?us-ascii?Q?08cgfx6oQrBa/RfaRJAP8kWgab/XNqjDTHXktp4SR5Fy97bRQflwh+nMYpoG?=
 =?us-ascii?Q?Ot1LGwPGp0JpPDb/pFeWHQuBOof0A3rBl3t4Js7uT/x7hCJtr2S8HcF0Buj1?=
 =?us-ascii?Q?9VdUy4u0m0Qh7sE8wAZfhgoQKGBwk4WMOxSg5rrk0jy1br37mDwjsduyBami?=
 =?us-ascii?Q?XAS8phKqzoXSmGFLu3X9y2HEsPRRT96orueBrXXxuLR9a41t9KeBwOIUcIzB?=
 =?us-ascii?Q?IR6H8v44Nw3r+q75jW3VPFQXy6xN9n9zncUWdxTrGz/bg7l4IDNxHcMBZ0Ag?=
 =?us-ascii?Q?Fjsv9NBm8NwPm1w6m0F0cpw9BBMGGiOczEKGkMT12qWkQmiwh5WOoFyH+WBF?=
 =?us-ascii?Q?NDlT6oCM0U+pibZ0k9vDsDntRDjfQj6LDB4jSqk7XQWrVluX2EDA7/ptRxep?=
 =?us-ascii?Q?v/pwZE4THn7VIyh1+ZZPz/UGG1wsmqtDVgPuGJRhjlsDCVc2knAyA8zhTC6z?=
 =?us-ascii?Q?vLbK4xf0zMc43rq8PlL0/sELM89mQaYxwTQ+JdtcE5He06VcGmkbIWmdOkF6?=
 =?us-ascii?Q?il0NLjLUho7ZADs3+MHRO2D0ERYj5revK+Kdf7MdQqMumOXDcHRXClc7v6uO?=
 =?us-ascii?Q?HftxNBoFTHsmCMpSY00c1YKZotbfZauFYIlav7kUL4dxF6AO9cEC9BEnkYZ6?=
 =?us-ascii?Q?iQIdL+Ms9u8W/LktmI9Xmbmue3a42cijycMHBDiUzTeOmacROj9I8aNJmxYG?=
 =?us-ascii?Q?voc2ejqn780bynHSTHSf++oRnrJ2dMFqSHYCL8A1BsVylAJNjhEeABY3b4OD?=
 =?us-ascii?Q?LhLwJEr79Q64tkr5GCMiWOl1BDZjTm5QGAk3091OnH+QfXNf71sjsoHfwLvJ?=
 =?us-ascii?Q?LhBm3iejSOK08kHGMYESp+zkGXxqi6c/6TCDSbTcsFiNwga4gPcAY2ft2jTj?=
 =?us-ascii?Q?bM5o5SXB2WddGeJivd9HrfYycaeuyS82AQkX9cDP0RA1NtsPx8bSmRp+ynyd?=
 =?us-ascii?Q?P2/7aF/Cn658BF1rgZlmr9FWmyIkZQGwEl/hV/jf+NpJVjBUkHJ9v4XTHW5B?=
 =?us-ascii?Q?E+/V7+aXo639NZCzL3m5PHNsz/O563HZO2326MyhBcTfXmHmMvQ2DG0dPh8P?=
 =?us-ascii?Q?oOfUuOxsHxAprKzHogw1Nn4U9HUAx5yacrhWAdP+pEWqVnYhFBovDXd4mQkh?=
 =?us-ascii?Q?jXNWdK8yJJQNULB9xHc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 867a82bc-1456-42b4-8dd2-08daaba74c95
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2022 16:40:26.0510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i6OgY0F/6KPq4hKvHC+Y60D26B5bLuUWT9C0eleiW9IYaQ1W2mlFs/wQ0fjUqw2E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5104
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 10, 2022 at 12:13:01AM -0700, Christoph Hellwig wrote:
> On Mon, Oct 03, 2022 at 12:39:33PM -0300, Jason Gunthorpe wrote:
> > This is only 1.8k, putting it in its own module is going to waste more
> > space rounding up to a PAGE_SIZE than it is worth. Put it in the main
> > vfio.ko module now that kbuild can support multiple .c files.
> 
> Assuming you actually need it (only vfio_platform and vfio_pci actually
> need it) and you don't otherwise need EVENTFD support.  While I guess
> the configfs that do not fit the above aren't the most common they
> are real and are a real tradeoff.

Well, the config still exists, if someone is building a stripped down
kernel they can disable it and save the space. By the time you fully
load VFIO this is just noise. I don't have a specific preference here,
but I would like to reduce the number of modules just for sanity's
sake.

Jason
