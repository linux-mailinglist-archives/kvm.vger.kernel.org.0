Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87834587DDF
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 16:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237172AbiHBOFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 10:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236936AbiHBOE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 10:04:58 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B9225E8E;
        Tue,  2 Aug 2022 07:04:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEm4fpcctZiQBfV4HkeiuXN3ZxqiXb2JdIpLhpB2DCRoDjX+we/9yHnemN/mX5Tlp2fTZU9ZT9ireL3sLwHZ/lIDvDWu+9nXSPdkff4ISn/sDAEoRt8DehAiZJ19YhVU2KzsHAnAnVInFFBKDalYEgNAJVfviEYM9jnWoFEFX/S5F4d/Fu5BzqWjvLQN3ayrQ+pqrHURaoxZZTmuLmGlipvU2jbY2QIifp0dbmEmc1ck7dOuS4CBxiqUZZM3GhwpjYVPZrjDxzBIC5Rvl3heyxIYBWisWczA/Lls+zVXJkg5bN0MOBjIwoz3cT83cb7EJ4zTkcgCFKo7BceUhOnXbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HK1ea1sqVmLzxJD3LilnFaXaIT+Z6vHVe1v7zGvohSk=;
 b=PJBkjZSwhZ0ekU5JZLK2NLXjAsBH/4KmpguVxiYyXfBxp+o5hx2SpO7fGX8eFv7IPLRuEq+MzmHx0g7Oo0pDEBVs3+9dF/loy1O7f6QWB2WwV4SR9Vehr+g2TSOj3Yiptxj3NzZzCN9inUQbchxiAiiy8cqB5DrCO4gNRHlZuYQdUIj5MCxoXiWLjXQPcgCUdGQE7QGVPb/cAkDHo71fjie+p+v3gAWiPfH5aK1r6IXWPakP4YqCBgiuG2LbohaxFWyhzR/b95jnXF6+W7QvJidxoAsJXhX88Ntf1Ln1F98eGZCLeRU9VeJ358QdPZMZ7UML51GAWpPzdZ/zXAgvsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HK1ea1sqVmLzxJD3LilnFaXaIT+Z6vHVe1v7zGvohSk=;
 b=bx4iUhoE6QFamVDcwpxoCf9l2dQT2BXncz0sFFzEsJ2GjftIgKCXbGU0D6iL5pQHUac/f/3ZIw7o+yGDrSipkFvpa2wT0sR0XcQ2j3fFmHhhur3gqkInKTDFOLbqfpGpz95OVDMCIvj3IeG67+TuYjUfJ9frJIAc34CmyzW61YCpFVqRih4z89DxRGS50dlmg124J0C0gp2V010iOIIMTLdnsslUXiuoFWUIkJoH7iZA1q/fENu0UaBlI+tDb4CgMaqXVIBHy90zl+5yIFn5UAZV4MG1MqJl+W2Qupj1qEdQSSp22xPrwhPB188Uc6GWsmljmub5cLsJg/INnOCfOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN9PR12MB5241.namprd12.prod.outlook.com (2603:10b6:408:11e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Tue, 2 Aug
 2022 14:04:54 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58%8]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 14:04:54 +0000
Date:   Tue, 2 Aug 2022 11:04:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v5 1/5] vfio: Add the device features for the low power
 entry and exit
Message-ID: <YukvBBClrbCbIitm@nvidia.com>
References: <20220719121523.21396-1-abhsahu@nvidia.com>
 <20220719121523.21396-2-abhsahu@nvidia.com>
 <20220721163445.49d15daf.alex.williamson@redhat.com>
 <aaef2e78-1ed2-fe8b-d167-8ea2dcbe45b6@nvidia.com>
 <20220725160928.43a17560.alex.williamson@redhat.com>
 <bd7bca18-ae07-c04a-23d3-bf71245da0cc@nvidia.com>
 <20220726172356.GH4438@nvidia.com>
 <f903e2b9-f85b-a4c8-4706-f463919723a3@nvidia.com>
 <20220801124253.11c24d91.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801124253.11c24d91.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR03CA0135.namprd03.prod.outlook.com
 (2603:10b6:208:32e::20) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6e2ef5a-5660-437b-e75e-08da748ff986
X-MS-TrafficTypeDiagnostic: BN9PR12MB5241:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XbkyERU3LXWvQLxtadEqKmKbaOvUqAUe9broBLbOcpk/bUP+T+ZGhi5tleGC3+RSe3YokZ78GAJO90fIk2TVoVpPAFHw1LrpVkxE+z4Auh2rE6czBOwc/10efSpcr96k4pW2tWFjzk4U1t0ipCUwB1j9A0X5KsGk7lyepkdhKSi1TmgvXavn0c8psEWmyQ5rhYcjGvpZHEg2HnMPyxyWj+DB51IFVHhDZkT+9IspbKwtaRnzEvk1aTtVpe89bNMKOqKn7/HmF7KVq5Z/zo5LaCut0Rcht/qrFoHqzEkrVKRM18xHFhLG7R/qUc28HPKR5tkDDe8pUv11bkJJNEPrxvRPE9auPb+MUIzqFAl80uuig8bPd6y4jSEa/MPwQKq4MiNzlld5bDLbrUVT/iapphE4L6nBFsi0BLBwB9AGoxU8ZUSRZv2pF9tbOQJR52rzjmW/AOBNl0Z92MSEtp/38DCi8vry65FwxuReC2Vx1DJlH/pyIkHbJmqmEfYI7oI5U/9PE7FIIVE+7Chu4v0xryvjHhc/HYNZuP0gCqE4J5Nn8a+EfWmiJFMFHONQW0rH5RkM64HYWejxlE0whafirl8WHrDZoLZScf6vPvvS/Wj5oDO6yaZGtxwGCwFMH2JXjhhuJtHvsn+Dl5D4ADlB44CD1HI02uDjL2EzA4/3FWHbIJEWZPCSf0/aC63LZdZMf8YZCm8Bsqc7XmqhHA6FklhcmPN7rYGI+ENo2hfl9+/2PIDHl5ZAuFOH8PcxMCGF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(26005)(186003)(86362001)(6512007)(478600001)(38100700002)(6486002)(2616005)(8936002)(6506007)(53546011)(2906002)(41300700001)(83380400001)(7416002)(5660300002)(6916009)(36756003)(316002)(8676002)(66946007)(66556008)(54906003)(66476007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jTEMBaYpDGIyLrWBLyFYGLAqpM1gTAkIenUvW7yP+iIzMxHB3zuzxBqqbBV1?=
 =?us-ascii?Q?Ic71Ny+WRreJa+bteGMvz85COzUkBAjJRjTw7ssyo78tgMUjIqRmVn8FJixK?=
 =?us-ascii?Q?EQfqboCMa2P0i4hDX3InSrjNyhea0jhanwC4/W5Dg/3k9QjLWb/sJQQWfbUi?=
 =?us-ascii?Q?bFCpaNCf9FsUgUGl+320H/R+sIcgq/4wxSVsYlbX+IZnbfOfIXPVdzEdASW7?=
 =?us-ascii?Q?YPv97JqTpXj9JaTkhxgbW+/nJt80WqTLHRxoE6orcFbXhup9KIjF7cEINEZW?=
 =?us-ascii?Q?eH/5D3DUSrl9aCBGbBb5s0pkOQwqTBwSCF+5s78/NG3mxI5s3Bql/guayaNb?=
 =?us-ascii?Q?/2t6bvwoCQR54GUXpvft77OW6xPhz9OZUKc4oEJVFAdbeDT4pNKfIVp+E+7N?=
 =?us-ascii?Q?jUs8v9TZMGMu7DnuZzsLee+7EkZjFACrAedqcpxm0n3TvBymGXztf/vPysWP?=
 =?us-ascii?Q?9wIOb6Wvtv3qm1atlKGiLLgoyDRw1QnaEQ457FV7GKvQ0YyYNp4JWYRFjIzn?=
 =?us-ascii?Q?ZCU6KBzMswQqEEOo/zl9dMKxLMlivInn64MbVFdqqDVZhJxvIqmp9EjNUKwf?=
 =?us-ascii?Q?TMX8gATE7yOcB5GScMPe6fO7ZMCT3nXp28v9Hk0/OsMELeNHXUnUUwewdy88?=
 =?us-ascii?Q?c3BsDXRK8+rnGWrcWftxq+puim9ECTZe882QeyB6RNYkcsL4vTaa9LiCB12a?=
 =?us-ascii?Q?H8bDhqXG0Ew5a8iJ4SdmdeG2DxTrwG6FnQmmGoYXdW2ALalQhADISFKG352q?=
 =?us-ascii?Q?0vRdJ2A/zujKjgt90x0pKf7qlHMrmj1kMiWgv7Zya496M9mKXVIJepTHuUZo?=
 =?us-ascii?Q?rognCfArbAN2sYRRszRCuKt1w3zL9M9EihM5kM1upm+5RXtLwK9hgWhWv5lB?=
 =?us-ascii?Q?5oJh4kqkyu5lOO3C/ytgwZJOt3/upPFFZ+ef+xyMwOuFTj0pZ+FSOlnROodB?=
 =?us-ascii?Q?4+Pf9K31XIzE9bGfGrbw5hrNVqtRlKIlsZUnsfUigeNs+EzEFXuEXIvn4ApQ?=
 =?us-ascii?Q?9Ho74Qe4HgmtTeOTclpthj0C7wt0L8canb3JKJKIjuRM1GHNCsGa+saESVfY?=
 =?us-ascii?Q?smBX/amQcnbYJl3rMaKSIFPGTvXw6R49eXtB04y4FaukhKrsP1H0c/pmgx6E?=
 =?us-ascii?Q?2h3RKEYJnUDTpB+9zrV5TxQpH3i8Uy/GRk5FYmerath6AwZp/iC0F0jSnHSY?=
 =?us-ascii?Q?DhZj6Wws7M+Z4b7aa8x9VqbX6lj3XPzxyUe4IgkZivQLXkUBsy8dL3X9OULY?=
 =?us-ascii?Q?qBF/6b457E/bCA7M8Gw+GGHYgwXjI9NrwhGrc24o9AMmWByxiZpNw5+NeWpC?=
 =?us-ascii?Q?pJuIbCAzgKaADC+ehvhANnn2N9n9ngti/5BTZ/OvzcrSHZ7uM3n7/aikZdQ/?=
 =?us-ascii?Q?6FyDuFw5dTEQNaed5kEE4F5SDrsTWsBTJqxzDRybHM2eixLDn4pXo2dTcdLg?=
 =?us-ascii?Q?yNrvmGAwWvsaweLEmyxpWJKFfOaFjrkObuwqQN0MtrKJHmQN2O/wjfy+VZvI?=
 =?us-ascii?Q?O4JTNbhbEkDrAXKdqHYU7KujKjzCABThtJtcrwPEwdzFhzPdPFCM0o/X4X7a?=
 =?us-ascii?Q?1QxKnfP3no7Og1Lon5hLR6P5f69++I0malRxFFDn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6e2ef5a-5660-437b-e75e-08da748ff986
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 14:04:54.4047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HPSszQCQq6vugtetvNzwvqNO5NdN4mG2Ns7q23CJhZ+IunSGRBGI0QYK129OaAb9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5241
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 01, 2022 at 12:42:53PM -0600, Alex Williamson wrote:
> On Wed, 27 Jul 2022 11:37:02 +0530
> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> 
> > On 7/26/2022 10:53 PM, Jason Gunthorpe wrote:
> > > On Tue, Jul 26, 2022 at 06:17:18PM +0530, Abhishek Sahu wrote:  
> > >>  Thanks Alex for your thorough review of uAPI.
> > >>  I have incorporated all the suggestions.
> > >>  Following is the updated uAPI.
> > >>  
> > >>  /*
> > >>   * Upon VFIO_DEVICE_FEATURE_SET, allow the device to be moved into a low power
> > >>   * state with the platform-based power management.  Device use of lower power
> > >>   * states depends on factors managed by the runtime power management core,
> > >>   * including system level support and coordinating support among dependent
> > >>   * devices.  Enabling device low power entry does not guarantee lower power
> > >>   * usage by the device, nor is a mechanism provided through this feature to
> > >>   * know the current power state of the device.  If any device access happens
> > >>   * (either from the host or through the vfio uAPI) when the device is in the
> > >>   * low power state, then the host will move the device out of the low power
> > >>   * state as necessary prior to the access.  Once the access is completed, the
> > >>   * device may re-enter the low power state.  For single shot low power support
> > >>   * with wake-up notification, see
> > >>   * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP below.  Access to mmap'd
> > >>   * device regions is disabled on LOW_POWER_ENTRY and may only be resumed after
> > >>   * calling LOW_POWER_EXIT.
> > >>   */
> > >>  #define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3
> > >>  
> > >>  /*
> > >>   * This device feature has the same behavior as
> > >>   * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY with the exception that the user
> > >>   * provides an eventfd for wake-up notification.  
> > > 
> > > It feels like this should be one entry point instead of two.
> > > 
> > > A flag "automatic re-sleep" and an optional eventfd (-1 means not
> > > provided) seems to capture both of these behaviors in a bit clearer
> > > and extendable way.
> 
> I think the mutual exclusion between re-entrant mode and one-shot is
> quite a bit more subtle in the version below, so I don't particularly
> find this cleaner.  Potentially we could have variant drivers support
> one w/o the other in the previously proposed model as well.  It's
> interesting to see this suggestion since since we seem to have a theme
> of making features single purpose elsewhere.  Thanks,

It is still quite single purpose, just
VFIO_DEVICE_LOW_POWER_REENTERY_DISABLE is some minor customization of
that single purpose.

Either the flag is set or not, it isn't subtle..

Jason
