Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A4F696A48
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 17:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbjBNQtX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 11:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbjBNQtM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 11:49:12 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D5D2D172;
        Tue, 14 Feb 2023 08:49:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+RMEdrPKMC0V88EHBpPvjSoYnJ0xXH5Odq+zZ6GN8IQPZuLiKJ5KhqUbQiW/JrEemE36OVHAzOsumvfFkNpySPcfnNAW1HLUr8A3+4G9A5eGZcVaQAZvtmQwgBj25OzFSeHo+JwoJ7xtwIJJIEyr5xCbZzQN4EXMKf2mxSJQMBZPJQOwDswIt/WJUjoIoj7dc/SITmcb9T4CRw7WcMoq0uUefBBRE4oWktEJNjNYKT1Y/vwkXcjbpH/EW1QE+jPFX8eQdtdbjNkmrxSRyoVTIKHZAfsJB/085uls2HH/HKppzk7D2Na82AdGnoYHchjlCsSWB1YKWO+FBiEE9HfOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FBMDIBIPNInMFlBf7ljHo9atygaL3iHN6PAJBtVGPKA=;
 b=YgV6d8rlfAjERXtIHpGezsfw6l+4S4epPhQc1W2HKMxCXH5Wpyq4dNPQL0/V+lHdbI2e9N6WAI9iBsgodwgBbf2vBujLBsRKhRo8D3Zn2DicLz3e2Z2LFGZjeJ6Euf/iPwxfvZwv4QHtlex1gYRoClB+CX/0UpfYpU4lucvbE7ZexeP65QB92vHYg9lPMP/XOKI1SqNc1cjjnOj8O7PmncOdqgAbxdbtcqWCULYtV8BsoMZmZr9wiELo4sseagvWCgvtGU1PvvEjCuUNYvKuMN4OPKyyjGd0kgPqXPjdO17w6mAyBGkX3MZuUEFf6Rr/+iNAi9BNcrxYjSE/aVn6Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FBMDIBIPNInMFlBf7ljHo9atygaL3iHN6PAJBtVGPKA=;
 b=GxhyggRtNlnm7krASrLQCLZOrWRISPCsuo5TO/8AFBQJwKYaaLEO/AyvHa5Ni1ygcyR+e+uXZRq8W1FnVUYiOMafJ0iT+Jd2jvwCchPwNH/97sUu+Bofi4JiQxU++sutLId4w4Os+6lmtqEP2i0WKz7RNHR6joWzq7D1Of9FAxAXkqilzKb77NLjzxD5smEW9a7Ds8ZoIoqVt8LEosJhF+cg2DIht54eT4gtdD00jeFN8oKeZ0gYbWHtCxjg+w0guMUn7EaHVHDG7AjFJXKAFuIoT0OHj3GWRum6jR4CnRMW2f4zUkxAHced4dum/3MdBXbx+LwS+VFJ0rOup6OL/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB7876.namprd12.prod.outlook.com (2603:10b6:8:148::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 16:48:58 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 16:48:58 +0000
Date:   Tue, 14 Feb 2023 12:48:56 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v3 00/15] Add vfio_device cdev for iommufd support
Message-ID: <Y+u7eJKzMp/NdV86@nvidia.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213124719.126eb828.alex.williamson@redhat.com>
 <Y+rGDeEMTB8FxjAH@nvidia.com>
 <DS0PR11MB7529F0B20A73690C5650778BC3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230214085419.4ac6d2c2.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214085419.4ac6d2c2.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P222CA0025.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB7876:EE_
X-MS-Office365-Filtering-Correlation-Id: 16076de5-0cc9-41b4-254b-08db0eab5e12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oEQLaekkTDF+I3jytlUktrnsGkWjMQXJ6s+A17sqE2WE57+bBtiQsyo2VumUOKRYSJBJBereDsHFf4caRCq9elf6+ory43kcdfUkifRL1LoJ8TTGAb1yfLZLBqOBuHpF27qKhSm+b8Dbb3sdJti5Vp73y3C61dDRycptDXEKB9Oz2c6MyytXN1W5lysPj75jPqejK04osejDtkoBchaAdANX5blpbB2hb8K7jIv3E7eHLOgxhsBI90lg59yLkmr2iR4/ipKfygjy/7rlUHM2OWeo5rpxqwVrHISv7KumTJys2uBNPpDKaCvZ6WqkHIsR6sCuQz/IAa2Qidoq0wnGhh32O40twwR7zjc2BaDnYkA7hhf3jn1ikofQyeOZiCs4B08CnCL7795liuINqFTVcggEBTgwYelnzRQocrePlqClE4VTbD8PXyaw87dpEyW2NfgN20TMUIE4R7j+wTHkYM9cOBhMwIo9IPAEgq65MtwwF7sIYDVU2r7YMmZyvt3llumIATVI1ScUAbrtAvhfAFPag5E4gebyOtwY+o9omHMT5FTIBbD6XgXJLp0vTem5FCwup413iXH641r/uzM7ZYpGwriyOVUo7Btttio/636yLhLXIlhSemS+khZ1Ovfd9LDhrlyZq9gMo9HY5mdW0Y8miaFe8/Ge7A0l7gaizOYyHgsCu3/pnCVP+xSx+xvY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199018)(54906003)(41300700001)(38100700002)(36756003)(7416002)(186003)(8936002)(6506007)(478600001)(2906002)(6486002)(26005)(5660300002)(966005)(66556008)(86362001)(6512007)(2616005)(66476007)(66946007)(6916009)(8676002)(4326008)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/LKj7Os3TlNxjQVHeHnCXck+QFs0JuPVyjoYjVmwwnutpZ/rRB+6zQ2NBYQE?=
 =?us-ascii?Q?gG7AEIijYeK2H2tx5oG6IrvYQe9lDhcbekPue3gr72Nf+4KF+w6xWC/a/35H?=
 =?us-ascii?Q?kcJpCfRR9VTep9SiaEXQstRAm+fitHO1740/+gm3fwDLAJId5xCIkS/XeJmc?=
 =?us-ascii?Q?b7+Mzw8FKlUyFWAksQl1VdHHBGhZG6XzCo8jTcavxSniikse5+rnmkfMAPls?=
 =?us-ascii?Q?tnUk8St9uNePKWg9ULBrtH1nms7dH9Gdkm0R/gNDxQYz+XBpILc+mqeyWW8R?=
 =?us-ascii?Q?MvMFqWFHIRzCfKPFyorqIjNbLs71q84NZXTbM+beeviTBmGduy2VFhOyfAEA?=
 =?us-ascii?Q?pKCXH5hDNJ4w8bPHNgjDePLYQW39bY9vESy+YkjOPTYQZKiyfg4XQJBKD6Lx?=
 =?us-ascii?Q?3DWx8Gv9PjUQuReUEZSLgnFzo6aDznr/qpBD8z5wMZk2lVRzLPeHc2oi8eYr?=
 =?us-ascii?Q?SqzPx8Na8pDqSv52tYVvRQ5Jy32dsNEjHe0i+oT0y7aJdEF2KJENexomqPbD?=
 =?us-ascii?Q?YtHTZXOylF7YwZ1PXWlY4B34aOQqSM7KtUZGbp2obF90/MEFr9AgRAZO873t?=
 =?us-ascii?Q?6u/AritrI9wMUBiA4/2kWivnX/cGlffhjfo2LPD3rZh0xeALK04FIZ+WeuGR?=
 =?us-ascii?Q?08ptE02/wwNpX9Uzwb9tOvcgel0vqDlrAMSoQj+yoodrHQOvmr3ADYj+fa4w?=
 =?us-ascii?Q?f/DV1LXm9iqgHdh1tCzxl2zCIHnFp/FesscCPbgfLF+xtsC2aRgfp3qp25dJ?=
 =?us-ascii?Q?LEhvra3tL6NZ8hMcqLE/vI1heRymrTS493AGH8IALgqyKJYDKVnX8J4KRZTK?=
 =?us-ascii?Q?6Cx3C5ouXxlYktS/Q9YJLRtLe1T5yxF3JZAlntWANTB/CoPuYUGQX9ajgUrN?=
 =?us-ascii?Q?qPtPmjDQWnN/IpShswF7kv7uEnX9U/tiSX1xmY5KcAt3kv+fF30stB0BgdTT?=
 =?us-ascii?Q?jRLLiNtt4HrLCSB3Q/QeSHdZ46L2sXZLuUe3Lw64vZuu6VqsD/E55E0O8tY6?=
 =?us-ascii?Q?3IH65GY2vWWDRhhK/6rD9ze2XsN0y7RtHqbE40QsjGL/u9dL3fCMbBfiVFHl?=
 =?us-ascii?Q?LkV7sX2gIEBfbW+G9ccoU93ZFg0wrfA+/mX1rtqhEy6W8kFPaXmYmCSdNdGn?=
 =?us-ascii?Q?rn3ytjFUudWDDmiZS3+cv/ciRFvtzqSSV9W5HT49LhDMeuBHpO16j6esxq4h?=
 =?us-ascii?Q?NMgWlixSR8nx+cRlqUdZG/Yty8/OhaKs2mZS+C/w8F+mADePAHsLSZk3b+ik?=
 =?us-ascii?Q?LEggpcob3T969+4dlx6RXH2h+/matjGApuLmC2IkZzvfcNxFDusIcE507Nnh?=
 =?us-ascii?Q?VIS01ar6FENGB9+KDt8w15cKe3JJn0rJc+JEGivz0ogJbxvXBgZrqi1Yt1AK?=
 =?us-ascii?Q?O7Sc2WzbYp30We7e9TmgalR3v6+5nN9eJCw1Cye5uus73QnYaoC/NETxaTco?=
 =?us-ascii?Q?Q595fcb5dIr9FBtLG2TfxwOHN0MHBaEKhY7wsXcagS7AgYjd6vuVqUfkMA8K?=
 =?us-ascii?Q?NSAoNkXbT1SNvvGMcZ3hPbIfFgH1ty8jF6RqaHIeTvtULMVP0XSTDN0i9or9?=
 =?us-ascii?Q?1cz5GqzNbn2dKd8vvKBxZoXUgbRAomEOelIg8Z+i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16076de5-0cc9-41b4-254b-08db0eab5e12
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:48:58.4907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ureIUVgQQ4Ere4UYZSam8gVghzDb308lq/3R95dMAErGT1uiitxXDRbl4hAbbKB9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7876
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023 at 08:54:19AM -0700, Alex Williamson wrote:
> On Tue, 14 Feb 2023 15:15:28 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, February 14, 2023 7:22 AM
> > > 
> > > On Mon, Feb 13, 2023 at 12:47:19PM -0700, Alex Williamson wrote:
> > >   
> > > > I think it's too late for v6.3 already, but given this needs at least
> > > > one more spin, let's set expectations of this being v6.4 material.  Thanks,  
> > > 
> > > Please let's continue to try to get this finished during the merge
> > > window, all the other series depend on it. We can manage it with a
> > > shared branch again..
> > >   
> > 
> > Sure. I've updated the below branch to address Kevin's latest remarks.
> > Fixed the compiling failure reported by Alex as well.
> > 
> > https://github.com/yiliu1765/iommufd/commits/vfio_device_cdev_v3
> 
> 
> Sorry, I think this is an abuse of the merge window.  We have a new uAPI
> proposal that's barely a week old and has no reviews or acks other than
> Yi's, we have build configuration issues which suggests a lack of
> testing, we're finding subtle implications to other existing uAPIs, and
> nobody seems to have finished an upstream review, including me.
> 
> Code for the merge window should already be in maintainer trees by now,
> the merge window should be for integration.  There are a lot of things
> in flight and many more review comments coming in than we should see
> for this to be a v6.3 candidate.  Thanks,

Sorry, I ment that we continue to review and try to get this ready for
rc1, not abuse the merge window.

Obviously this cycle is lost.

Jason
