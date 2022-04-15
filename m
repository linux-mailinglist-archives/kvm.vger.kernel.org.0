Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70AB502A31
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 14:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243446AbiDOMid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 08:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353387AbiDOMiO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 08:38:14 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2058.outbound.protection.outlook.com [40.107.100.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9EA53B75
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 05:35:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LaHR9vdRzLYf7MOipmRqG+Q+b9fLp3gCTG8w1i5zfHvLOvzfh5wYQQY25rYvSXETzl+9NHhSEdBylW8CZKX3fNQInIJD75+3SfN9pJF3GNgcSgVd5EGyLtahrbbgAioRRThxFJOOj4ZyG5aNQx0ZHSm6Df4mB3WgY7TGXQneOm5PAXaHmzp+T4e+wwzc2Lt9E2UpjUMRzyauV0ZcERjix85is0WHqqXKTUY7HUibWPLwtKcReaVk2SOntyJfZ4NqF9bBdGHCcGZEZASnvmZnFIqRdotjPLxwnoMTg/dsTc2C8qKQauCxRU/5wCkcDbPvEWhDphG+xxnOaqNbI5nl4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tDCuD2sk7tFcw4JARaqfU+DFkuxZQTgng150ZgoeZe0=;
 b=jCMXXpL0IZ+XXw+VSSniysJU8dbiCIsA+C8Lg2EFhOwck8nUe+JOXGNliWGGr3Wu3g57c+LfsrvYoQ3jW/JxSQmbLu0AiFwAm2+CSiBTgoDQtI/CcbQga+W577PgQ4pNktizl9X/Y2aX20GPmjgaVAcs6aV9g/J2XeIp3U8LJwLuR3P+TbVmm4EEgq+99byy2+ZnhPX9rPPOjLK7v1XLpEYQwuUQEzXM+x+lkokPrOXA1jFbWKLJqGPWLx9fXwusf2de4CbHZskXaazEHawNoXdOvDgZEBwzojWVYetrEhqUuwn/fsD88QGt6JgLQR0LqE/WgbJcOQB8HBIX+HD9rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDCuD2sk7tFcw4JARaqfU+DFkuxZQTgng150ZgoeZe0=;
 b=tkp/JS7OH74K9yCWlzWgw6ipQH/B1s2Q7fC+oe91hGKF6QML4+wVfCVCRveBsNuvpTw8avvDv4QEq+OmHBojCbsRKUYnYX4ZHbCIxNXdqq5n+MFw+qIrx4x7PVVqD7eiwEmTxtkYHCawHxVkkPMrtuzPMwu8lxjLdMDm0fOKzFa6JQMu5lpVbY/OxNcmtZvESE3eiaVKhr7lz668eHlU5wg9Y4cKxmMLE3rzrdJD7prQX5UcPwVJYiNqLdQjc+MiWyHUnGjZY+RTjSy1bDYM9bw51L9aG14k23IPawLrdDJAY0J9yZsob3brKX2Vae+st7s9DTaOqP+5yhv6l5EkZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3148.namprd12.prod.outlook.com (2603:10b6:5:11c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 12:35:05 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 12:35:05 +0000
Date:   Fri, 15 Apr 2022 09:35:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 02/10] kvm/vfio: Reduce the scope of PPC #ifdefs
Message-ID: <20220415123504.GK2120790@nvidia.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <2-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <20220415044731.GB22209@lst.de>
 <20220415121343.GI2120790@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415121343.GI2120790@nvidia.com>
X-ClientProxiedBy: MN2PR06CA0007.namprd06.prod.outlook.com
 (2603:10b6:208:23d::12) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33f7c3cd-865f-4b16-72f5-08da1edc5e57
X-MS-TrafficTypeDiagnostic: DM6PR12MB3148:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3148D2C695A6743C1F97C6D2C2EE9@DM6PR12MB3148.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2FrmNcODJMfEtYOo0QavR++KbsRD0wvJY3v7l+VVMNOssTpd/tsZo7GJsH9bZPl1KvDjQl0tgNFRu4D6OEMENQBisMl3qEuCTwXXD4bCZOObikLNY7kUiB11yrb5kF9AtkJmZEhXlww90D6n2A+EjH9HOpA/4Z6tlUQkDcOBIvATDMSMoQBAdyZOAwRXFaLyH4ebQAaSB4iqJWywPK+SLQTAvjAw8JVt/rsl64zn9jDoS69iiM+wVShyciP0sF1j59kXNIzUin+gSGTJcv/I0OT2EIx4ZUnepGrkGjCj4sLzJgZVHFWX4l9ChdmFVduvIg+wexaUgUzxis7KbCPkyhwjSPFB7LnJrHBhTEq6oOHPkSEiIKSbxqMupN7i5drN/wvDCR7mjEpVdegXw/SuIxSSidBtAu07T0B6SH0aBDbeVeIwo3nwwjMS42dGluoV/P3maQQ0CBGEuR+zq25kU7hL9LI3zFYwgeZy6J3PnvK2giApqBSYu4aKT2uwW2wExGw/fIZnI8CbZ+0bNLTbuKWqpSW7Wnx32bV+TtmvJ2AEq+sHSfTbIV8MqA5JJ6ShsYoYHBLWNL+gtfSLMYoE4fun9bdb8Lw8TUHX+Ze8fO9TEqY2BnhwLgisRVAcri1En3sosIT3DuMJ2BqchUBadQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(36756003)(6486002)(86362001)(26005)(316002)(508600001)(54906003)(33656002)(6916009)(6506007)(2906002)(38100700002)(2616005)(1076003)(6512007)(5660300002)(66476007)(8676002)(66556008)(66946007)(186003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7YJPgSDb4LhxV4fKkTdRu/gFjNQKbsDYGR389eT5fTlN86c1PxOLi9RNe9Ov?=
 =?us-ascii?Q?kpDYYdb1o084td0Bn1OZBGwj+9QanHpFV51jrLZQ8kskUdkWHQvf1C2ck3gy?=
 =?us-ascii?Q?xdQXixNGLpjnJ+LQIcvLDaCeVYHWyj6ljFflJsCXrWhKCgcoy5+3fm5Nacth?=
 =?us-ascii?Q?Q/gE5z6zc6GzHBDJPepHpwCcNL2beI/Xngt5BxWyOGVfr6/L1E6RKQdKJGMm?=
 =?us-ascii?Q?2MQcOj2I9Yl1mfHqzO9ClpP2kQX61Y8lA30o4iU3A89OVFJNouXQbRrnMb3z?=
 =?us-ascii?Q?S/HrIcImJVDvB+ENy2E3aO1pSZQtbB1z8Bn0PeSN0vgio2eWgTNZPTvD9gk2?=
 =?us-ascii?Q?F63GYD0Njv+0jU2Ux4MsRiuuswQVCmIHKOXXOFAIKaJUr2OpRP6Yvggpqf7p?=
 =?us-ascii?Q?9WeC3ZJLkA9uwNGdDR9OPmIUp+nZiw7ZnmB2TMLz3ueZmrXDvWCdpES2eEsw?=
 =?us-ascii?Q?byGnmscigSvUwfVYAz8LDiajsE4XZVzIX0w9WQdBWMcxUS0MoAZBJQp+8ZF2?=
 =?us-ascii?Q?zfnPu8hdgWhg9sQUHnGa9vXZJaqWRdSs0KyPy+xI1pqGpFO18LSSoDTN4uTo?=
 =?us-ascii?Q?iKEpTptt+VcpxOzhOv2kfNjHsoun82kYimu9GjdItO9WEE6g3kp+ayjMC1Ao?=
 =?us-ascii?Q?z1MoNY7WFOdlSzqXILvaIApIKYnblWQtfNBvGTf5Var1AYAFu2150ZeqrYZz?=
 =?us-ascii?Q?OnvqVaEqP/zOMgULdkC1bk1qMisp4LVP4ix7wkyRDm67Y7GXVXoo3xzPLmQQ?=
 =?us-ascii?Q?SiCDzeedYFCIM62w6e3410wCAI1+V+nhHAERl1A8301xQHx6L85oUd+Kcadt?=
 =?us-ascii?Q?TxD14KvPQdac+j48ztWvBo+xJBt39w+IYWhbDdZB6xrs2WHZ5joqzRsDNQI6?=
 =?us-ascii?Q?PT9aAaXKcfQkIohI+6GzwF9DB9pzyVzf3ey+czHuUvEaeAXjkWq8f8KeF1xU?=
 =?us-ascii?Q?UHiHmetcTN8aegbQadFDQYI2andGwF9gXLkIzGAt46Nz/rgZz2KHJjB+uM74?=
 =?us-ascii?Q?vKQVqh+zbzFGrKraKKajntXxDZBdA949WrLfe8UAuo9toImzLnnPtQCZKy9A?=
 =?us-ascii?Q?HIycuGLE2kfSJ/O6xQa8k47LxEZCqct4JvcteSapYWPSg8GW4TLzGYrVgJUU?=
 =?us-ascii?Q?yd8VqOgksNVr9ae8MeAPnaMz7CxXtOjL6TVpn0mrMzxHPx2sBe8vpxe+g5gI?=
 =?us-ascii?Q?MIOnzk+3dUBKy9pYG6TPnr44OSbZGbspgNDjQQudkZFO5zO6brHKctHlonQd?=
 =?us-ascii?Q?Gk2U1OBbKGH+2WU0gAaDii/bWCCprXCyoz5py0EjEbv9yNmSv/AyWmrfhbMa?=
 =?us-ascii?Q?ayAu8AwFUJ9AHFYcVjZnusEMMQsSKzmoKUBzNtZ5+Xj7tgI6bEINnoHKSUPW?=
 =?us-ascii?Q?iY2rI1fDVA4CxwVd2+rNCm7lPvy3H+Fl3haDqvJQg6Cv2ynfdTYmhjwt7gcn?=
 =?us-ascii?Q?SzmQ/N+zaP+tgsefCodciKT+dTOibiy9vXDHku9CAqZ4wtp6V4Us6q5poNrV?=
 =?us-ascii?Q?5DljD2PnUJqNAB4txRHsB41rfDmB40W44HIsEF2OBDvNpIBFVtSYso/uwjIC?=
 =?us-ascii?Q?Y/kMKO0/WpEBhuK9Jf3Twbrv+5ydDkHITlTKAYiwOYW4E5UKXhmSFIOS+12q?=
 =?us-ascii?Q?CwY2MMbzqQByfFOnrlkOZHfS1+9mzVeDilpdvCX+1cT1lYw6vyzyLDpbRFQk?=
 =?us-ascii?Q?11FbXQuOY0c6ypFutfilklaDFjzDZ6skcE7PSQqcWReSwAHlocBftz/zmgZX?=
 =?us-ascii?Q?wk3USoTB/w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f7c3cd-865f-4b16-72f5-08da1edc5e57
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 12:35:05.1867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YURmOTb+Wur2gF3RfSyTloXhQISAKK5hcL7ALnfF0UfLX9INVzUdLn7s+FuG42bQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3148
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 09:13:43AM -0300, Jason Gunthorpe wrote:
> On Fri, Apr 15, 2022 at 06:47:31AM +0200, Christoph Hellwig wrote:
> > On Thu, Apr 14, 2022 at 03:46:01PM -0300, Jason Gunthorpe wrote:
> > > Use IS_ENABLED and static inlines instead of just ifdef'ing away all the
> > > PPC code. This allows it to be compile tested on all platforms and makes
> > > it easier to maintain.
> > 
> > That's even uglier than what we had.  I'd rather have a new vfio_ppc.c
> > to implement it, then you can stubs for it in the header (or IS_ENABLED
> > if you really want) but we don't need stubs for ppc-specific arch
> > functionality in a consumer of it.
> 
> That seems like a good approach, I will try it

Actually, it defeats the whole point of this patch. I wrote it so I
could compile test all this stuff on x86 - if I shift it into a
vfio_ppc.c and make some kconfig stuff then it still won't compile
test on x86.

At that point I'd rather leave the ifdefs as-is and drop this patch.

Yes, the #ifdef is ugly, but this whole PPC thing is ugly :\

Jason
