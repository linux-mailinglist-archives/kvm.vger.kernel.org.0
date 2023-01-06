Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCEB6602A6
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 15:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbjAFOzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 09:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235549AbjAFOzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 09:55:31 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B345B8113F
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 06:55:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNDZD8vHw/CCHCXsafqeBoX/nij9liHOTezsgnq8T3msclf6VXV67rl4+AVphy4blYmsDrNRo4Y+VQWuia7w63yFRSYCI3eVbfuZuN7mikP8LZ1OG+pj5io3pJJI4xHdwNUPNGBDTzXG0LxYWTa1XTHj6Cl8HLO673elp5FMGQGyGX/PYfR+YtGki9ihI2owf4lfnitTewb/cJOn+fo2Eb1i5vkeqANp1k/8u/tKIVHWUyvwr0HghxhkTNRQ2pqdszc5Zahu03qwfZ/utr3+LL0TvK7DHp7mKjsdnj4Qz+v/qFt2dbsitTgKoBVf0eqU9Ya/PcZ/+sFgnmfDqfKzyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0uxYLKnzh95UlDmhUNCGwFoyhAUrwo5FuBqwYyRjLI=;
 b=mSpyqDTIEarofcvsz2vmOrkxjRGvUkMMCfk5muTFcDd4pv62Aha4q14nbjiU1hSUe4Ohn0fO6eHjocCTuovYb3rV5ThW5ADmimsM2TGmQp2vDtB6Zbzmrv5rAkaIU4Sbp79Ab0fWT8rpvWKyL6Xw9oD2vTnkqvXRSX+WKvsoNbdY7vLC2YEh22f4VGSxkosZEzpGBD7m0vcR3oU1Vhgkh/2AHdzFgeUsSFsHNx+un3PpkM4XS/mnNEzfff6FM13gI3YyABzLN2BVGJKLUzPa/ycOgNUPaazQokm+E6XM6PMIBBZeXChbvPysu67ReoK9pB0lhQ3MuwX5Yl8+Ds5NpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0uxYLKnzh95UlDmhUNCGwFoyhAUrwo5FuBqwYyRjLI=;
 b=FeA2tjl1YPBLvq9y14Hx2XBB+G3OdU9gN4Cx8gyi3WnOaB0QPdf3bc8SKrPqOz5dSed680+8+SQuNGBzb4g/HZdOkK+dnCNDnd/szsPuu2sl3quKnPLcPLAQfZ0Nig8z67cQWyLukT8JI/du0f+7srDYctmM+p2FkPNtCmNPiT2lurmdp0jRVVqEc0/NQ96Gvl1EOzovtWn9uIlLEoWsEhxTQe3d9X4ORn+3UJ/QM/plpio7UpX969ezuDmYQbezbGsEF1THLSON8W0Aa/RgO05C2HCjZLhshQbQr7sJw/L8Hll6h1qHnE6xhkwNW1RYe8lXMnbNtoWZokViYhW5Bw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM8PR12MB5464.namprd12.prod.outlook.com (2603:10b6:8:3d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 14:55:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 14:55:29 +0000
Date:   Fri, 6 Jan 2023 10:55:22 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com
Subject: Re: [RFC 05/12] kvm/vfio: Accept vfio device file from userspace
Message-ID: <Y7g2WhrDFHpPPsaH@nvidia.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-6-yi.l.liu@intel.com>
 <Y7gxC/am09Cr885J@nvidia.com>
 <6af126f0-8344-f03a-6a45-9cdd877e4bcd@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6af126f0-8344-f03a-6a45-9cdd877e4bcd@intel.com>
X-ClientProxiedBy: BL1P223CA0028.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM8PR12MB5464:EE_
X-MS-Office365-Filtering-Correlation-Id: bc52ca81-0654-4600-2b26-08daeff60d4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 937V/eb/V4ZOGDdTG6nAxyzweVL5SrA2kbfSkguMxaEBkcvmlQCj8YV6mGXozaiN5FfgsrY+eDlXt2KlPvEz+6eAvFcIPGvc+VythBxiDTGxBKwBdM2lGLEOfbPkhQYLU8e9Gk8pMriri59VkZWROaeDiLStZ4q25pefJQey+kjDfyHJ1mf4OP6dSs8P1yG02aSCQ94kOCpzE2BT9NWqhKN9/AL0ii0zceM/a+x79okn7nt5rgI3tQ8JSkaNq3AelPRBOy6l/hWNow6g3PYp6YvKZtVEG4KuPewQNCUltmewhw8kK/I0gW1zF4M2eIaNiWwO0T4naYhkRvyvd/35vOp7IZt75WLFJdEnHyr9QAErmJ93v17Q2oKLGr8QWsNfBGXD7pPmxsS7dv6hPpmVPiIg860n4OZfb11GtHNyxF63ceR/u0F5PZMd4pmbttsaZyV+GpVjx5aUM2MKo58KwRbYq4wpqBWySPKXGJESNF3tIVYAB71jC7ZKRot+l715jPv7Gy6NiO52CiC4whkR9hMzZPy8phUJe5UHxsTKtSYMbqRjbHTPhf0k9B+Cm2x/DwB/W4CvKFN58T5y9Sv0nvcP3w/x7WZnf4WVXSwk7dMn+WZNQZT1B9lOjXYHXy5AHsAiF7ThpD1CwxfdYjkgJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199015)(2906002)(5660300002)(7416002)(6486002)(8936002)(6666004)(8676002)(41300700001)(66476007)(66556008)(66946007)(316002)(6916009)(478600001)(4326008)(2616005)(6512007)(26005)(186003)(83380400001)(6506007)(38100700002)(53546011)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Krb9Ag2Qc2pqsvZLxE49g53GVAHedtof+vGPTe/i3sPUogYlmSyz9bSbs0O3?=
 =?us-ascii?Q?IfQw0UMq1CqnAQOiZYtf7VYNgK8WCHa4Hh3UkPLeNm/lZbzRmIgeSJGhI+LY?=
 =?us-ascii?Q?TGta57RKtd3vEAEdjbzzH2A4oqM/Ru05C+1gInV4BipJMYrCRE9/EAIQ6vFs?=
 =?us-ascii?Q?hvpSllTfXhMJZfKzjTXqxuC6Di4kOnQ7Iu0mWpnoP8j2mCedZy3EzDAX7KdH?=
 =?us-ascii?Q?C/R3WRrnrXGHKWdtemhtABBxQFzUjcHNsi5nHtmNpYSmPkSmfrSAaDnTWEe4?=
 =?us-ascii?Q?Ry3lSmuft0KpG8ZKASIeHVGdPvKOb3RXKknczIPb+6e6f2JcUET0leL0UhQ+?=
 =?us-ascii?Q?1uW2W/95REX/+gHMrGPQ5mwxiYeqLwzbMSW7fd0CJWGbJwICPRgrWgjDyzMk?=
 =?us-ascii?Q?OpGkDrUUzDAuwK//W5SbDaVB/bzcbaWsfzSTGHA1uX9cqSyo0Xjz/d2rubV0?=
 =?us-ascii?Q?7EurETnkJMp0VpqMChupi5O3SFLY7O+xTcUSVM1I/hr/21t2dtrhzU0evzS7?=
 =?us-ascii?Q?x+i75NPgsptkj8VsYTFXJNtQGs9/P91BcSX1KpCwv/aLiXhTkrG3lOUnk8T2?=
 =?us-ascii?Q?qlXrrpsPazBKrr+z1TRdXI1H39ZbkSZh8+Y0pw2aST84Wv3WEti8kAzxAOtP?=
 =?us-ascii?Q?osqMAJ6xdHuWzBYpEYrPLL9Cri1BoplwAVjEmuZJyiUdMechpS4gGdb4b2oK?=
 =?us-ascii?Q?1Sw5Uq54/hnQMC1k8XaiDHn+DnjV4S2S5ng7zJHizffEwR1U6OlD2mE/WdHy?=
 =?us-ascii?Q?577BoBrsmaglrbpNqP8rmeSappf9UG7nGRl8Xk+PlU8WuVQebt57sKFUIp7z?=
 =?us-ascii?Q?q2iWD8JbRYNyUmajxdi3BcwogK9upHe2mmAFB6y7ZzCMoBMkJOJe+rTUHT0P?=
 =?us-ascii?Q?IbLqeFy+cZWV3DCLdJhYU7YWHyFl3X/7w/rJ1oZE9+nE/iyxTAPMDZcbmUcH?=
 =?us-ascii?Q?EtGPbKoXN2TKENB1aVR8fOpaMfcCI0cO89cOlsPaVNiDY0ye3/o0HisAVccE?=
 =?us-ascii?Q?86DlD5zXhfhiuSBX6pRXcVPwuzmKiRP7eUt9digIndizK506H1Z4OVX03u/T?=
 =?us-ascii?Q?00FVhjUBKQEa+3tg/R8o9+IpMXyM6ctjt0umpwR1GUGfcpSXitupeYr/IZz3?=
 =?us-ascii?Q?6/hNrzsJ5dO0BhjsC5XX4ubG+xvwqKNPB4YKK9BwNNTOI8pIV6ggEz7fPG4W?=
 =?us-ascii?Q?v4/eJVyWHHHIYQsT+Qq1V3wmKIGuVm6wMAWJGfC325gIgqgqU4HNzcOfJ3XA?=
 =?us-ascii?Q?SSy503nNDcziL+cLr6+t68k0RbfVkLpgL7ZgGChZgtKTRapdrNif3Kxp4aEN?=
 =?us-ascii?Q?COZFkg0HgJ/a9YyWnhM7uanHmO7y4mV6MA4DOodY7/ff4QXqEPRE6K79pbFV?=
 =?us-ascii?Q?fcdU4vnU8dnkTuXhTnED8BF/SICidXeiTdWV0In7YE0WJHzT9rRsEaj5OOrq?=
 =?us-ascii?Q?bjScSyomjfkmvLpLJg1B/7QoQiCNGaO2dYsd2R/2D5XsJjee28bEFG85Wcl8?=
 =?us-ascii?Q?+XhUYTCUycc3zsC11WdxxP0UTCuuzw15SzAjZlucX9g0JAuq0otMpT2o/h3A?=
 =?us-ascii?Q?NsytcFBFUgP/bY5GUtCgr2nIF+lLP4M8zzTgRqLL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc52ca81-0654-4600-2b26-08daeff60d4d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 14:55:29.1919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iGrd+6Wnap2dLYiuJlGRTWsBMb7DthT5IyCOU4PTvpPg4G7mAY9YajpCH8JFb27i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5464
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 06, 2023 at 10:46:56PM +0800, Yi Liu wrote:
> On 2023/1/6 22:32, Jason Gunthorpe wrote:
> > On Mon, Dec 19, 2022 at 12:47:11AM -0800, Yi Liu wrote:
> > > This defines KVM_DEV_VFIO_FILE* and make alias with KVM_DEV_VFIO_GROUP*.
> > > Old userspace uses KVM_DEV_VFIO_GROUP* works as well.
> > 
> > Do we have a circular refcount problem with this plan?
> > 
> > The kvm will hold a ref on the vfio device struct file
> > 
> > Once the vfio device struct file reaches open_device we will hold a
> > ref on the kvm
> > 
> > At this point if both kvm and vfio device FDs are closed will the
> > kernel clean it up or does it leak because they both ref each other?
> 
> looks to be a circular. In my past test, seems no apparent issue. But
> I'll do a test to confirm it. If this is a problem, it should be an
> existing issue. right? Should have same issue with group file.

The group is probably fine since the device struct file will not have
any reference it will close which will release the kvm and then the
group.

> > Please test to confirm..
> 
> will do.

Probably kvm needs to put back the VFIO file reference when its own
struct file closes, not when when the kvm->users_count reaches 0.

This will allow the VFIO device file to close and drop the users_count

Jason
