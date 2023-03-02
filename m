Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C8B6A8252
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 13:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCBMfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 07:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjCBMfQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 07:35:16 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6CC305C3;
        Thu,  2 Mar 2023 04:35:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCldKgMX+UBd2ocAbprUIANKNYWhy7w2+iTZpX9/DXQi2xsrtL6pMyG+UB40FoZnXprRz21ehCUhRAAmRh+121wTVkBVBChVUYQLlCxLrZhYM7QFfzI6FGcu8GMxhiCWiJ9dtjpR67Bu3hwod6cbvU1DFnEaxve67LX9jayxb4dusp9T8wCcrDumDKyUxDspDeWWpPVNaoNXq5+AN8WyxCPtoUeiOOH2SDpIgTd31u4OnrQCxHiVC5JL04xLHM4eywZihDt8FBXqCuXPLnmySa44Y4CrpAWLULnYvW6IeY8rbZjDZATEf6Iaq3kvnt4XDdUzlLS/NODKTHIe3cQCXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uacm4W8u/4YeXCgctKXpsodqmaDZpDlMkSzzJjJLHNI=;
 b=By+bmDNJx2iVYLkqGH3zFUsq0SIie3YQ+2k0J2ZIfz4GiAi1n82Q5EXPSsUcV8jdFiYn6ZZ7uq6/MJ0/gymgcBYdfRLIzShE9KFM9TCNsh+bge/B93P9/aBAFCLXtjFNEtv8lSSgpV7z3ajf6DdYlZaJUV6zViwPzo9vo+uNZhqv6xDGEtpaqFumvr3CK5b8fwIxKxz8cU/T8s9CXJEUVGFtmz3dqg7xfkb4k4JV8TWrfGE3i30WOcoI+OfPnChBsQw4ThvoU7iHusC/F0h1UTxSQEbqP/cDzDCtxXzNYOr2AZjLwz7BE8xsEoKOx3bHMJvh2H20nBY7F7ygF5NNSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uacm4W8u/4YeXCgctKXpsodqmaDZpDlMkSzzJjJLHNI=;
 b=AyhGPH9c/nuUaU+xtC7xq1nSXOrXOakLin6c4FO3nMXxCqvOhGt3qh63/oYCrC2fW+M7vmVAl4ZvRQdKZ0l7vudLf8Bd7AQ0rjB3yOfXXFZnF3MXVSh3js50jyDgVLYmM3qyNREX4cXg3h70wrT/yy4U1wDTLOWXStJyIM67aKLMXAU1hCkT0+EtamHcpyID9RLTrEGRsdIPvY8quMgpIxjW6gM5FEYGQJzwLGAl7zpKopjXUplj7mPme5FJOwiNtP9782oHQV4iO/2FhOkRLCaMbL5eVMNmssSRyAEe1hFfAOvFFPq6aNGjzaVKIoceMq3My4luz8y6K4TgpIVqbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB5959.namprd12.prod.outlook.com (2603:10b6:8:7e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Thu, 2 Mar
 2023 12:35:08 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%5]) with mapi id 15.20.6156.019; Thu, 2 Mar 2023
 12:35:08 +0000
Date:   Thu, 2 Mar 2023 08:35:04 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZACX+Np/IY7ygqL5@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-10-yi.l.liu@intel.com>
 <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BYAPR06CA0003.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB5959:EE_
X-MS-Office365-Filtering-Correlation-Id: 91bbaac5-44ed-46ab-b01b-08db1b1a8e45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vjoIiHR5pgMwhc7+DQ3q3LlnOF9rPWfb6M8kcONSBOLWSUoBYq/HQDQ0kS8qz16ec6/WhVdENAdYoJRv17nJxmDN0+o48ebmJFJfCOL5yTq/0u7lsRnkNKNQbDSUH6JME0ea0bLTr/jzUyrjgfYjZWxx/OLVp9o8vs9Ekd/MQmrgs7rV9YirU+fDENGnjJTGvqCFBPWl7BTh4+/eppkB1xYhDGNPlN0epfqjz61hQAKwk0AWS9V7F3daGhVd5p/bEceC36wGelmfrXo//HjHxMwhyKUD4xr13rNFOhSRRzPqRmc7sbCv/afj0J7a+IEXW+XdDPdcUlnfKq4GdbnTaW+VfJUU22rlkbqRxmTp2sqwjlEfJM4oG4guSvFz9mIj7wHHqBuaDN3fWehGfLR4Z8Kyf/KznbB0qSGeHuFWJXqVzoheDX442Jgzy2DWiTBjof/sidTNQmH/4AmP9rxamX/8Wx/RTfWZboEu5q/ccAa/fcjK8ZqlXbBteUn7s5Fz7r1/MYTR9v2BG9YEsN09WB+S30yWiRb0kVZVYt59sHMxbdV0bNANDCkdsFt3L5zsiwu4z7fACKPQfT54OeeslIYuh+ONSBls3QSkzYQl3iWUcmbfmUNem/DLIWrRUCJztEo7ibYUNsik3fuzRx8ybw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(366004)(396003)(376002)(136003)(451199018)(7416002)(5660300002)(66899018)(4326008)(66476007)(8936002)(36756003)(83380400001)(41300700001)(2616005)(2906002)(66946007)(66556008)(8676002)(316002)(6486002)(38100700002)(6916009)(6506007)(26005)(6512007)(186003)(6666004)(54906003)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NpWwBE2rccrT5OuMPNvHWp/8SdJqYj0CFjaPoXLzz+9sPfprNt4+hBZI+IOH?=
 =?us-ascii?Q?BfiDBSAjLrl2czxx3gu9EnfuUt/0BU/K7PxZNRpytGDSQmLNBNoQdtlpMRjj?=
 =?us-ascii?Q?4nWlmGoEW6b4rNpGF4m3XGQJN9L93NiF1XB+xm1wvTzTAt/gP3fPyzITSi52?=
 =?us-ascii?Q?pn/08LL2r6L1JHlK956R326N8feZycwvcJ1i5cJQiA1Zvmpfr0CTMd9XJTAB?=
 =?us-ascii?Q?IpjuN7rlXDVAOSSv4qzN3MHCdtWFTGoosSX4ORKsYd+UzzIAC6YV90ltRGxW?=
 =?us-ascii?Q?XBWkwJyzyF26tEliG7DhERRCgECzEEjmbKDISz2xTbRTzCFW5GK56UUARbHb?=
 =?us-ascii?Q?VN1aDoFAkbJcwnwZ9S6iYVbFEnxcr9W76rFZdGF8vlvPn8Phs3kmyK+4RoQG?=
 =?us-ascii?Q?j1vTJ3JDAFMUVNCjTNXI4DOPwYBo+kxJfwFuzMDluSIpU5rceIlLWHJl+tOC?=
 =?us-ascii?Q?JNWLbwiFf8YcNLTDpjUTRKYmR7fnQT8epYoLjkI8jLRa286hNKApsRvya1ja?=
 =?us-ascii?Q?mI0xfnKFjdYhRQulDEbyrjiPb6KeEvU6KmkWZAME1+9vNnPw1q4m7wN35w48?=
 =?us-ascii?Q?8fBjkMhMIL9X9NS9qarK8ryme+oRmfM94l3tFH/Fb30tHupM2vBvOzsvsZQi?=
 =?us-ascii?Q?T7SN/DRxdC3xtPoeTPr/oxTnNnuQr4TLN3iBthpdlhrATS5f12jpimaMpSZ9?=
 =?us-ascii?Q?alpNDNdSQW4tTnH3SxA4MeWA2nfRsr3LIfhs3/8cGTL4rNL6SQlwNehQ5Evf?=
 =?us-ascii?Q?cJPTn4oiHq9aN0+Qepek9xHP7J+KA9Rv9PTsvMDJZuhhEjiADifYvXIU9ypp?=
 =?us-ascii?Q?7F3UMTz7eK4JaN6SlemSdMkY8A0WZsfDaESNgbeL9Q6j0/y7YTtrSxyj0563?=
 =?us-ascii?Q?AhjIFV/PPiOv06GMlS10B4emhwWWGq6LBjOZJRN3MDr093ap3k4kNGycz7Qy?=
 =?us-ascii?Q?LGBfc45b3xbU5eBarCkHoOgTnGwbReDXhPH8QGDkBqQeoQOaSvyfS27c8BVz?=
 =?us-ascii?Q?piempvXEGLvT2WerOz/g/lA7x6I6x1JQNIEg1+4ZdhgQ4z+U/3+AwoqpcOeI?=
 =?us-ascii?Q?SJJH6e8wFurY83QN+oE+Ox8dNejI3vOuBCNYNtjt4Wc6p/RWUGqoJHWdmtPu?=
 =?us-ascii?Q?q0bMaczGs794DhPIjrgG67RUeTEWK1aliSgFtlBt6CXoNI5eGhgsEYAWHahF?=
 =?us-ascii?Q?VeaaCaOEXn/PkDCToFOtM9jw6+ddNnsQJRouEtrl9el2aC36eHQO+jtXOSmu?=
 =?us-ascii?Q?YfVsw0+Jb/fUCh9AfxpkPsD/3mDU2IMCfB+RgWShl/0UIljqXqMnhqMnaKhy?=
 =?us-ascii?Q?XgQUBSTCWdh46eRUVFyWpkK+dclRYbMdZn/rrx+YFmXavB/7xno/xPHhcal4?=
 =?us-ascii?Q?nyKZFRwzHKrTyMHOBAq+sqR5iSa+1qH4wYdopSbodErZdbM2zR6Q9PhlUUCX?=
 =?us-ascii?Q?80uq2BQ7tmvtYKwgUjDcVjk6CzELKUr20HpaEs2LSQJkmhFQofGLVRp1dEvX?=
 =?us-ascii?Q?ZO3q25sAs/qALsgVlP3s6T6bAC5llA/ewKQYO5wrgLhCNP1PkHjKF0yzEiBh?=
 =?us-ascii?Q?lmeesnUgyH3jowXx03ecNB/ZJb3MP2OCzUOM8gkf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91bbaac5-44ed-46ab-b01b-08db1b1a8e45
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 12:35:07.6837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lX1z5mkpRKpsTktjkqTZ6e+ymmoChPu2jpD5rM1AaT9pf19CaQESiMB+753OaBdb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5959
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 02, 2023 at 09:55:46AM +0000, Tian, Kevin wrote:
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Thursday, March 2, 2023 2:07 PM
> > 
> > > -		if (!vfio_dev_in_groups(cur_vma, groups)) {
> > > +		if (cur_vma->vdev.open_count &&
> > > +		    !vfio_dev_in_groups(cur_vma, groups) &&
> > > +		    !vfio_dev_in_iommufd_ctx(cur_vma, iommufd_ctx)) {
> > 
> > Hi Alex, Jason,
> > 
> > There is one concern on this approach which is related to the
> > cdev noiommu mode. As patch 16 of this series, cdev path
> > supports noiommu mode by passing a negative iommufd to
> > kernel. In such case, the vfio_device is not bound to a valid
> > iommufd. Then the check in vfio_dev_in_iommufd_ctx() is
> > to be broken.
> > 
> > An idea is to add a cdev_noiommu flag in vfio_device, when
> > checking the iommufd_ictx, also check this flag. If all the opened
> > devices in the dev_set have vfio_device->cdev_noiommu==true,
> > then the reset is considered to be doable. But there is a special
> > case. If devices in this dev_set are opened by two applications
> > that operates in cdev noiommu mode, then this logic is not able
> > to differentiate them. In that case, should we allow the reset?
> > It seems to ok to allow reset since noiommu mode itself means
> > no security between the applications that use it. thoughts?
> > 
> 
> Probably we need still pass in a valid iommufd (instead of using
> a negative value) in noiommu case to mark the ownership so the
> check in the reset path can correctly catch whether an opened
> device belongs to this user.

There should be no iommufd at all in no-iommu mode

Adding one just to deal with noiommu reset seems pretty sad :\

no-iommu is only really used by dpdk, and it doesn't invoke
VFIO_DEVICE_PCI_HOT_RESET at all.

I'd say as long as VFIO_DEVICE_PCI_HOT_RESET works if only one vfio
device is open using a empty list (eg we should ensure that the
invoking cdev itself is allowed) then I think it is OK.

Jason
