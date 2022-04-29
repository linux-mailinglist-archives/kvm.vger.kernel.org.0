Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01E65149FB
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 14:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359577AbiD2M6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 08:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237137AbiD2M6D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 08:58:03 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E752BCAB8F
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 05:54:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVoBcrF5oPYc2tnVcc89iyyAGJBgFkCJrn44fx42GBEUCD1joDVBNrrrr5LvT4oX8/PuKqHUvmn/+h1IHMZyiMxh5a1UIgl/arMVsJVXLwGhsAgmusp7+X/HlO2lgaEVrvvovk96T+HK4+P1HoSsASdd0aLpHDDGXrVlNmEVyC9N8awImNwJncP9d2zmbWUY0CCuiMdCNvgFUtIq/nZrXOCfVaNTpC493a7zfzny0HkJJwkaZ3TFY30Dh7qn2+g5txuJDz/KX0yJOpxtRyn3bZpPw5MF+BGoGxKfDUUJLltDDzgfYR115iTiJFNVO+WxL8GlNFNbuN+dxt9gZpTN6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nn+vULH5hOYi3Wky4yP+9cOcmwE2zH/NP4CuktZvNdU=;
 b=PFuRKGqiReeAjZOFZcEYAoEfXKmu9oXbi2OzcliJOwxIAhw26HYjbaLHbaqRt85xd6v+hV58FJMSHD24IufpBmRe/aG+1oycVRs4YPRXKAtpg21PizapoEpGEjmem1oHddfW5lhzCHqpvv9nhsxz9DtVvIOEgNy7AtxEXY9yujVBRtU3oAhEnuW6j7eEWN2OUzJf0qTmusItNZQWGpGMhm6xd/2SkphJF5PLhOgMz2EPpSpdq1WEW059c3QEsttGUNFjBSuYZfJW2QOubcdoXnrSMEvYQixNpJfO/qlKzhgzyaxZKJfOkrPe/OYqetViDntKLasZ76Z3g1tZB1OT/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nn+vULH5hOYi3Wky4yP+9cOcmwE2zH/NP4CuktZvNdU=;
 b=h/ETIICaCwYT0/dSr6vgSfKN2QPQRmuuAgmEZk3KD9vI+IKdpioD1t4RjdMFsIrp6Fu9wZ9G2Yu2nJWxURI/uXhQ1qXJMCgqhDwR8viOxXYWK2WOukV3ZFA2TxA6suDinipUGEgoiA2208LqMRATknG92QKzeXaMA7p1aX6dLRCeiN5xhG3+59cEYKyIadonNzne/82svFY9btGYW/A5INwUiZdTzmkjHAIOEQCNIecT2s+nsyb4nWBZG+k5coGXxWSiY5W+gAx3/RP5o7V9WvczHX0jdgjCubnBcjwo0mWlWLDUuzDYN9DbitnoD6Qxlo+0a0YJKMJaIUUuaOTfSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN8PR12MB4769.namprd12.prod.outlook.com (2603:10b6:408:a7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 29 Apr
 2022 12:54:44 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 12:54:44 +0000
Date:   Fri, 29 Apr 2022 09:54:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Message-ID: <20220429125442.GY8364@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <YkUvzfHM00FEAemt@yekko>
 <20220331125841.GG2120790@nvidia.com>
 <YmotBkM103HqanoZ@yekko>
 <20220428142258.GH8364@nvidia.com>
 <Ymt+7gOSlXyy4v5e@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ymt+7gOSlXyy4v5e@yekko>
X-ClientProxiedBy: BL1PR13CA0298.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::33) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8d2cfc4-14ec-49aa-2d09-08da29df6ec9
X-MS-TrafficTypeDiagnostic: BN8PR12MB4769:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB4769A3DD58F4B545E8B4C816C2FC9@BN8PR12MB4769.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n7A0RHTQoodjSi5Oi3e0fznYqPOFHTsQvbO0xSfuj43/1NbnGtRcBQecx3MBpY5SjAFwuKJNz350tJhCv6DAjiXacACHqW0rhzpEke9HKoPEfEUxH5ZF6vSTGTjJCzG6ppNhJu/OzepCXHXbaC1UGRxjMq0ctMO/i+xFLf2LDMM8usP5NsIpEI8RElTMUK33BQ2S6ed5JlxhEByHa9m4butWLTN1ugcuMhZOuelCcLediqO9790rgcjXb/2+a0FMsgrgVtrUPZ4AGXgUkezfGXDrLuMuV7n3o04SA+w6gbfWb6W7KS+HYBkPYss62MFh9i5PUoVtnhEPJvXCYhhqu9u7//XRCXZVMO1/Td6jtZJUI0KBAX0NgXkmZS9IOydQkpUTrvm07+add9B9FHiVFtZxp4Oni+jQ+9kCKYoBLkVQ8R+A3Pjeh9AFifDBjJOlF/ounWMLE5A1vB1vxFNm6Ppv6K2hotM8aVLloRvulY58ev6tTWDEwmRSPaef9w5+5I3D53m4AEkKg4ur3KaqwAE1itW2j1rJWMv9Jd4AnT4XeDy5SQJGDpqFzMWPWvu9O1DHk3odJdCCIg6j65Fldc8vI7D2gR4scnKX5kbDfA6KlyQF1wShmb5DH4E4oEQsXHY47B0m9uCe4BIiP4iswg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(54906003)(6512007)(38100700002)(316002)(86362001)(36756003)(2616005)(6486002)(186003)(5660300002)(1076003)(7416002)(2906002)(26005)(508600001)(6506007)(8676002)(33656002)(83380400001)(8936002)(66946007)(4326008)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jcx6rURlIVUbtdLnZ7vDv417bn1vyPesU1NiSthzRyS0HjqE82lDJVxrIxcY?=
 =?us-ascii?Q?un5cB74UyuDUyPJr0NcC0egJk4y/r7/x50NP4aqT5aIsymB3IkWivEQb/4JV?=
 =?us-ascii?Q?oWaJR81KWYKF0uIGbOme5DtLaO8H0wagE6bhzLnrrZLLdOSaOA6TQmIWIn22?=
 =?us-ascii?Q?+x7+KRKnXMhmIku4LEWppwgASysXiazTVrEC62cTMG0lg9lX8jXhlYFniqcf?=
 =?us-ascii?Q?xYG1GDYNrKSFiRzUwL1gS0SPujvBm+J1IdQM0lv9mXtkWkbjBjeYKFZLMMst?=
 =?us-ascii?Q?umtvjJe69iS/e85DZMAhvJ2MmUYs5ikhRW7vMjWo7aAFk2qhP592saXCDn0j?=
 =?us-ascii?Q?o7ULQ9za8RYHLIIziKJ2FH25fyPV6e3iKl/D3VqBryRBT0p73RdUso4G1g73?=
 =?us-ascii?Q?SMeRV2kdWdYYg72e7FDZTXBPh1O7uR8fK0akEhBZ701i2WGw28cODWJG0+XD?=
 =?us-ascii?Q?URyo6eh82tTu/iyqiquyU+oqS5qqVj64NMro91aonYLfRavckSWK7WQgK5SC?=
 =?us-ascii?Q?CamkARM+hZqThF7JJ+3KDdPN1GF4z7J9+jUwznkQ3bNj/FVMAaK5qZnFz17o?=
 =?us-ascii?Q?aI6fAlGiCqHzKmSDXhnouVCvJ7t3AEROXLHOG1bb54BU4obxUM91m7nsp9xX?=
 =?us-ascii?Q?fIaacyImUfNCVYmuI3Li08PjSAnRcuUwdDC4da/GMDh5IqPnZCHY6ko6FTiA?=
 =?us-ascii?Q?2ywY8bV6yVmtpL/jSo7RNFfxOCyPLEwg94diA6oAzOI0zrDMvNjvHOJPLLAy?=
 =?us-ascii?Q?jmuAEvHH6zjRJbmNQ64Pm++Zww2Itj/lpFwG/vM2gq3MA/o6mLMRhe+7sZoj?=
 =?us-ascii?Q?iIyAT0jUV6Y6Dgdfad7lsEHfQLbf0k615ZBvUF4s00nvr/om2HoYxn7ODzDO?=
 =?us-ascii?Q?d0VBNZ1hz87Wy24thslgO8OOsGAvXWsqQ9bPsA0wUuHJAa/IurOhHYUWJSV7?=
 =?us-ascii?Q?SMYakH9l+BaAdOPxpktzfYPwMh11CxDyV8ie1fVdWO7FKtOmx6zdqW4z0w+R?=
 =?us-ascii?Q?inKjtI6UQGlxXId0kWqaJ/KqFlL7d6TYCUk3eGnlzfM+blvfjmmNbpQA6c0W?=
 =?us-ascii?Q?aQ1pe/oO1942A1jBTFeDxjKKsjHplkb/P3SPdiT34+CaFuFQYOoZNIR97qXq?=
 =?us-ascii?Q?0IrJa+soywBPaAe6GL8an+vLJ5treFBfbgBWg7yY+dBhaxrKOcOu3qtV4AR1?=
 =?us-ascii?Q?JV7Gmy0cpxHDr68QuRXbfj62rgVTQ0UuYNCNwVP9y9TS/ntVV93tKUme240C?=
 =?us-ascii?Q?sZ1gxvAAmkM1TVcTwwcWuraKdMbo+2cSLIGJ7/epmrnTHatqnkRq5xv9xVg9?=
 =?us-ascii?Q?TSIpOK9aNYx62FFxV0a4UK+uEp7WEH2aG7JXzcT3pYfrpCcE5B6Pndq/hX5h?=
 =?us-ascii?Q?JvVTKi3sO8c97HS7cvAfnom7dmX/rqadMRbQP6Khr+AbXNm0XFiNHpm5jWVK?=
 =?us-ascii?Q?w21WRIkVJqypoHZN9EWVeIRi1TonPJGqob9MFUzjUN5V3NJwwl6OYIq5iLxz?=
 =?us-ascii?Q?7wKkFQblYxibnnXnsYdqnA6PDxoJ28apO7M9iKj5xHMl9F6xEeKkk5aFDGlg?=
 =?us-ascii?Q?kRGXFBr05iMJXEZfeV9w8yTqwl4jiEnDznu4wl2BUSgicZcpP8XWJITRc+1v?=
 =?us-ascii?Q?HiqmJ4bn92vFydWm2YyRLxNVDO4lvzj5VzF3RDVIt2Qjw2coYuto3GmwDvVn?=
 =?us-ascii?Q?HNkDIoc+J5YDB8mWCikDwbb8rJUsN7Yha40qpqyEq64C72K/6VyfOuStTmgE?=
 =?us-ascii?Q?df9J4l+jSA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8d2cfc4-14ec-49aa-2d09-08da29df6ec9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 12:54:44.1501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FcqlhBlByKxR8zqvp7Lh7dqsx/YdiQtD+trr/Lu3xnXsOf0suatDWoyRbheVB1SJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB4769
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 04:00:14PM +1000, David Gibson wrote:
> > But I don't have a use case in mind? The simplified things I know
> > about want to attach their devices then allocate valid IOVA, they
> > don't really have a notion about what IOVA regions they are willing to
> > accept, or necessarily do hotplug.
> 
> The obvious use case is qemu (or whatever) emulating a vIOMMU.  The
> emulation code knows the IOVA windows that are expected of the vIOMMU
> (because that's a property of the emulated platform), and requests
> them of the host IOMMU.  If the host can supply that, you're good
> (this doesn't necessarily mean the host windows match exactly, just
> that the requested windows fit within the host windows).  If not,
> you report an error.  This can be done at any point when the host
> windows might change - so try to attach a device that can't support
> the requested windows, and it will fail.  Attaching a device which
> shrinks the windows, but still fits the requested windows within, and
> you're still good to go.

We were just talking about this in another area - Alex said that qemu
doesn't know the IOVA ranges? Is there some vIOMMU cases where it does?

Even if yes, qemu is able to manage this on its own - it doesn't use
the kernel IOVA allocator, so there is not a strong reason to tell the
kernel what the narrowed ranges are.

> > That is one possibility, yes. qemu seems to be using this to establish
> > a clone ioas of an existing operational one which is another usage
> > model.
> 
> Right, for qemu (or other hypervisors) the obvious choice would be to
> create a "staging" IOAS where IOVA == GPA, then COPY that into the various
> emulated bus IOASes.  For a userspace driver situation, I'm guessing
> you'd map your relevant memory pool into an IOAS, then COPY to the
> IOAS you need for whatever specific devices you're using.

qemu seems simpler, it juggled multiple containers so it literally
just copies when it instantiates a new container and does a map in
multi-container.

Jason
