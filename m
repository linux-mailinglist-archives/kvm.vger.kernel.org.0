Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8FB68EF32
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 13:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjBHMlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 07:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjBHMlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 07:41:22 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1374A4673D
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 04:41:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CS+EwhJxQxOpV9sqr+GkXMtcGI6t9zqE2PjGJaeg5XwyddAIoi/csYgL6+/mmS5dIoa2bf0N0Fhx1+Kg1aa5eevoR88KqPy1l6pOEwrm4piBsbfBLMPrzjoRdpaj6BXmIxT+x+FydSsfKWX4ebZq4Bx0PmMJSV6mF/dIbSbanyr1TDE9wMhDbTvwij45W47FesEttn/xawtVwdw9CDoPwFhpqa2DwjPlknvv23iauxG73iYAtZgVrpy0RNqbchrIQAp4yaYodxlRPCSHPXkpRLeP094VRkQB3xPEEQkkJFwLm7OlVuNrpMVUh8YRWDyWKvLUtjAXwmh8Dl1Mu8IYhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oVwY4gLUy3MUjRGdgBHtlh3jk3Ijezc+47OyPJh4MTA=;
 b=IKssR/EY/syoI4dp/NV9D3NiTdRYqHnZVmwxY1jxSNp8ZBzRZjO1hYW1p/V0B7T3u/Y+po7iY9yWgs7yCy0OgN6oawOjmD316h3OqqiQvbOMHw0/DjxTX/5UiJ+YMDFn7OrpnfyufoUxp8MUjL7ZBWFgJUekarT8MaZTZJDQ3u3qQiAUU1duB2BTbgXPnyK5tblR4tHsnQTpHTyQSd+DZO9TAsTffbmiP6Z9hf9ZU9s0k85RrMTR+OdUdME5Prj5xjpyGSNwp06h99s46gHD5n4+81/43hUEhqF93flhUXRDuR4icpnpF4nRLEG8QBvfWuVB5TUxNfBalYmKPESz4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oVwY4gLUy3MUjRGdgBHtlh3jk3Ijezc+47OyPJh4MTA=;
 b=ZE5a5GzgGQFDEeh+U8B0R9RBJxz0J6iMBmwyqZFH8qGqjfl9QIhkij8kpoE6wfWdlePHW81g1owQk/PHM3m8fKR2BYo6fOlHWvJMT0QxOm7nVkNigDsnOicwAaILpeJDH2h2rRg/NadqbnRxk6VaB4WLvsooJqkV05SOfDKSqucc/RFvUmjECUWw1I7FoztHHjCWl3ikubU1b2W0iSgh4MhxCW2fkvwOK9jMA8WJTunLBo2Cfc07RH5ZmCcwGmZrcvuRDhK8LlOlamjE56sq4YWoW9nyqUQGQ2LlBoCtAycXGq6O7aAYoz+aV97Izqg+0yUwriPQtx8EZKu74YTwww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB7528.namprd12.prod.outlook.com (2603:10b6:8:110::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 12:41:20 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6064.031; Wed, 8 Feb 2023
 12:41:20 +0000
Date:   Wed, 8 Feb 2023 08:41:18 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Message-ID: <Y+OYbkYUmHq46hkX@nvidia.com>
References: <BN9PR11MB527617553145A90FD72A66958CDA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y+EYaTl4+BMZvJWn@nvidia.com>
 <DS0PR11MB75298BF1A29E894EBA1852D4C3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276FA68E8CAD6394A8887848CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y+JOPhSXuzukMlXR@nvidia.com>
 <DS0PR11MB752996D3E24EBE565B97AEE4C3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y+JQECl0mX4pjWgt@nvidia.com>
 <DS0PR11MB7529FA831FCFEDC92B0ECBF2C3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y+JRpqIIX8zi2NcH@nvidia.com>
 <BN9PR11MB5276F8E7172F12B19560AC1F8CD89@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276F8E7172F12B19560AC1F8CD89@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:208:32b::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB7528:EE_
X-MS-Office365-Filtering-Correlation-Id: 15847082-9473-4da5-a298-08db09d1c731
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w+eLdSsVLZDdLFbPitL00DEk6sg/BI6Kgr4yWykDl3FdBwJCAzcYuAJzJiLCN30McyWwIkk7XuektxG9iwMqkidHypPoUt3p828p/rakRnHHXZLizAYIXi+yOE+ayKAvQFlLTZW54Due4ZLcyZowg7MeYQuZx4SkI/RCZO4ZWJhS1ttv4JYzoAvxtRjQLzSLKWwTdlgGQ1sKh4Mdf5ZjRoLuOCFfG6JKU3pl5sSkjM8xYW35wcKwOn0kyK7n8XpctVR6a225RZHoEPmENhTldBb3FQg/z63r4TLtxvWImYpDdxXZw+ESXdsTcwN0OltHLK6cnytlcBQvHrq0U9WniXvXd+4WidLeg5kkTUUO+RdNjp5a3tB8WFKg6ttb6wxetpBjNF4so51Tk1ePKsHTYJPmOaQou77C2gx2byH1xBuSq82GEPL7hVAoBQ1L2DczNT7C+gVXSTcmj7eVmdiThHDq3UT4f+gniq0Bx7It/M/R13jqryA/K/9Gt7cmFYlTYuTq1YookOyLsu4ujXee+4s8V2ogf0K0b7fGENOCBXvVyC8WR1gtzn9kwTuiAtptEcXNO0TZtd8E8G4nr7PsYrMMhHBG8w9cJrGLBxa8/fXqreZC9rc0ZE8yx9XfxVQTZ/kTv6zkgmuTfVLNdHQJ2SJ2QAa3V6aWb6cE+obQoScvjrdTZNh9JWRuArfv8SLb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(451199018)(83380400001)(2616005)(54906003)(2906002)(316002)(478600001)(6486002)(38100700002)(36756003)(66946007)(66556008)(4326008)(6916009)(41300700001)(6506007)(8936002)(5660300002)(86362001)(7416002)(8676002)(6512007)(186003)(26005)(66476007)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kdIvUdx2+PCIJ0/TbJd/PxGGcVS7GaRBHpHrFvLDksEbv85bLm/ImC8smZ0C?=
 =?us-ascii?Q?lnewr24SDi2FdrmW4KXgExmUva3SACfEQq6qCqnJCkL+RH+gp+ftHTsbG0RS?=
 =?us-ascii?Q?HGx4Y1A4g1eXGrocrGe+STy0kDR2BCrNJwFwQwXAaFl6INtP3oHoAtIAQxY4?=
 =?us-ascii?Q?3SuqdBPGEpCKhnRz4GfBzSPAy8ePS/VSNm/RoIsHlv2jKtRrozhgTSsOQIcK?=
 =?us-ascii?Q?m1u89HQTjclByivuSbkCDV4Usu8WpPpprnr5dnv9YGRkx9dzV7PTiD92zBrm?=
 =?us-ascii?Q?0Q6jcj7vMrMfxbzVjU3JrT4oPhaY0y1tBcyPM7ANXZyndmyu6FvIYQMxTse4?=
 =?us-ascii?Q?jfEfp1XnQA5GW1nFqrFe0N03sNBPr/nxep+HiQEh6VM74tALwTdruzhFX6WL?=
 =?us-ascii?Q?gjZTx2byw+u3z/U4g1fP4JIvNm+5j7VHPLK8Gu8cqnzxE8nVVzeV3IIl5y0a?=
 =?us-ascii?Q?pXC2xbWgpfMy+bUsaN58s/dqvOdUwdB+jFuHYsUjqpz7tgkvjCEYsLWuqzqW?=
 =?us-ascii?Q?mC5V2sFP4xNSoLhcDfX8pmhzo+5fHByIQiBpIN7SINv/+fI09z8UAN5/vp1l?=
 =?us-ascii?Q?ikGCjddzMEjFEZ9fPHUGW01lFMUU0HcSozP4EHA+IKNOV9fw0rzRuRDMbbCT?=
 =?us-ascii?Q?o2s/FB6nClypcfVdsmV+WwdCLoUub9IPHVSsc9iwJgtf3WPaEsO2eDRhaooJ?=
 =?us-ascii?Q?hqZS/q2bdY23xpMGhSu852P41wO66e5sn9f8muj1w4t6pAMwrAMXZ3pj97qU?=
 =?us-ascii?Q?EckGdW6wHuiPunQcoE3WJIEQVI1soClltXKBO+Un3q26fxSCHp/djNtjpElv?=
 =?us-ascii?Q?PcS3TSrKTxdL1Oy4LI1nSeMvbpzaLg1l4TCLr/AGJTlZyDhYY8C9mn936Ky6?=
 =?us-ascii?Q?61izI9hxbPMkSdf0mfPBnywrW/8A1T4IIm4lTdvPdgaVCPyfWH0vTRv122JK?=
 =?us-ascii?Q?Mb3f7ymRZF0ngHtRo0LMprKlXrQ3vV7jqiUMHsc5otzeJ38EoMNPvczB9Y1/?=
 =?us-ascii?Q?tzEhALCPEv2UMyqsMhLPkvdjQtQ6cDe4fEIx+hMgk5YLvVTZH9KTnjcrTzPr?=
 =?us-ascii?Q?yyoepQJPFemtDJrIKNEDZUue/EsQvyIHHEDxzjkoqukqWVoo0jBqX64PWEcA?=
 =?us-ascii?Q?K13RRCDupXSERVKg46k9gCvoEv9uIuXJfvhoQWO3AHAglXxJo3FcL8iUM9lJ?=
 =?us-ascii?Q?UfnI7purU+G1Mfm9cYGglP5noXY+cP8mkpS3nMWt4CHU/2wWOqBfRO7AMN9q?=
 =?us-ascii?Q?Z4VfdTg8I72oxvB/pZtKwmc4kVaJ71TT/0KIK+pYwjmhnF34fmFR9qmdC73d?=
 =?us-ascii?Q?TqA8MySzERy9WWYjZ0DXqpn/YQo43I/Oc5GuYhjQcBnOBw/jbLAFPxYL1/ZJ?=
 =?us-ascii?Q?ck0AvFmmik62i3Kmg+KNeBxmNeD2JOaf9IcL5uZ75vqi9QTB3QVmxGvwQC+8?=
 =?us-ascii?Q?WhBQnFWhpFNYskqxdRiPTVg9FaydbXfRcDwBn4FIfsfqteSyWlZF3DoujT5n?=
 =?us-ascii?Q?rGUqStnKGGjuf/CRK9BtNOhlH51fM2We5c7r9Rw/woFz7d6FrpQY2MA4p7k4?=
 =?us-ascii?Q?K6gU9KCOdtsyezq/pqLTRCGxrCyWuJUW9nCtNXe6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15847082-9473-4da5-a298-08db09d1c731
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 12:41:19.9353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NNMLMqQDcDZyXgsLeTkOnoTHPwlGZG+JCj2QqYrEQQIeOzIyA+Wnyr7cTZzyZMtq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7528
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 08, 2023 at 04:23:16AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, February 7, 2023 9:27 PM
> > > >
> > > > No, I mean why can't vfio just call iommufd exactly once regardless of
> > > > what mode it is running in?
> > >
> > > This seems to be moving the DMA owner claim out of
> > iommufd_device_bind().
> > > Is it? Then either group and cdev can claim DMA owner with their own
> > DMA
> > > marker.
> > 
> > No, it has nothing to do with DMA ownership
> > 
> > Just keep a flag in vfio saying it is in group mode or device mode and
> > act accordingly.
> 
> It cannot be a simple flag. needs to be a refcnt since multiple devices 
> in the group might be opened via cdev so the device mode should be
> cleared only when the last device via cdev is closed.
> 
> Yi actually did implement such a flavor before, kind of introducing
> a vfio_group->cdev_opened_cnt field.
> 
> Then cdev bind_iommufd checks whether vfio_group->opened_file
> has been set in the group open path. If not then increment
> vfio_group->cdev_opened_cnt.
> 
> cdev close decrements vfio_group->cdev_opened_cnt.
> 
> group open checks whether vfio_group->cdev_opened_cnt has been
> set. If not go to set vfio_group->opened_file.
> 
> In this case only one path can claim DMA ownership.
> 
> Is above what you expect?

It seems appropriate

You could also sweep the device list to see how the indivudal devices are
open to decice what to do.

> > The iommufd DMA owner check is *only* to be used for protecting
> > against two unrelated drivers trying to claim the same device.
> > 
> 
> this is just one implementation choice. I don't see why it cannot be
> extended to allow one driver to protect against two internal paths.
> Just simply allow the driver to assign an owner instead of assuming
> iommufd_ctx.

It is really not what it is for, and the owner thing is so ugly I
don't like the pattern. 

Jason
