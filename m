Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B486A1633
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 06:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjBXFWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 00:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBXFWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 00:22:19 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF2E4C6D4;
        Thu, 23 Feb 2023 21:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677216137; x=1708752137;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=w1a2CJHpNUT7xbEr2yFFOR9PTM/O2Y68+ZSpN5gwzy4=;
  b=NpEwd3xAKAX3V3r0NNN358N21GrSsCmlvG8T+q9T0AGBu+Ne30dg4BIC
   U3pbPkhC46PJSxK1TkkzOMsr/mEmsvtpYU3yYX/BZ3vA4KlqbDSf1qaKt
   o7o4FN06Rm3Mm2pE/PcLB8foWI3i83S8KxfoVCRBPsdgRKjudjX9y4cVK
   bp87Cvj1HTMEMs2e/oFdfgftGtOeKuZTEFujJAPBhx1b4VEqgWVed0esG
   /NqoPR6F9f3jHVBHxF6VCvQyZMqZC8rLj8DEtVA51OvY+QC683WPO3Ee8
   FEmd7r6wy1Yevi5UVcUbxuLgw8oyNAYjXJH9SwuVb49geJfhUZJQiUE+L
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="321598748"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="321598748"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 21:22:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="846831971"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="846831971"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 23 Feb 2023 21:22:17 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 21:22:16 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 23 Feb 2023 21:22:16 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 23 Feb 2023 21:22:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/Ml+jam/VSbKhGDbW/RIRH+VLOlRDTJ4q+iw8Ae89ioS/9WYPFVCc8SfF9a1tfLAq78nSyA4F5sfqJZDkVBCb+iiI6f9H0WUn2Glt9P34pXlhvPE3HkMNP/+9wUlb2g3mkn8/7/F+HMzYRakfeNlQknhpWzYk2CJdO3T2AThggeiOgeAnuis394TnGNLGWXzOe/Surp7CKoUZl5yY0EodMy++CYflivXfmy5iCzDVWGMICGJJeatqxSBaZmJJa9ngStTeQqriSs0ImoScrIg/fdhzzifXRMqhNY+3H6qZ0chVSa83tv6gH0NAzmKR8L1NTu5xH5sQ+FmnsdtRZijQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rkm6nSF8hfBPkRuzqClBYHp4b3ETigQP4WhMkalkHsY=;
 b=U9GvDFG0527hk0dot5yFLAIu9icmAg1xQNyofR/ZisO3O0b9ASB7rMkJTjsYAkWeoBbTtjW7LrqPEHJWcEhTwkjkAwuGVaQLnczl+M8fVTsNmlqzzqJyyOtpyZ7BjED/Sb07Hgo+TcJZQXk8T/wuBFxyg/yI7pfTUH3hSBtV8juJKDBOPe7/stL55pYtGjjcyDZAgfGpmwI3XOCSNugEBuzU0VFPOupnxcMB4OKw0eT2n2NdU6veca7wkThigzoVm5CHMEc3eu6wS+61Lbk2quO6vgEdiZTZnBWOxivYSSbrvt315YmePRh9VS4VLr7eXhMZcx7otsw2Zls4Q+sn/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB8230.namprd11.prod.outlook.com (2603:10b6:8:158::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.21; Fri, 24 Feb 2023 05:22:10 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef%8]) with mapi id 15.20.6134.021; Fri, 24 Feb 2023
 05:22:10 +0000
Date:   Fri, 24 Feb 2023 12:58:22 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v4 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <Y/hD7sRCLaD+/QlP@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-17-yi.l.liu@intel.com>
 <BL1PR11MB5271AB3735F7A783C2871DB88CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <DS0PR11MB7529D04D2EB9B5C69C306C16C3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/YRx7jLuyEoLxZg@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y/YRx7jLuyEoLxZg@nvidia.com>
X-ClientProxiedBy: SG2PR02CA0019.apcprd02.prod.outlook.com
 (2603:1096:3:17::31) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB8230:EE_
X-MS-Office365-Filtering-Correlation-Id: a1009b49-6f17-4bc8-036d-08db162713c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xqdGawCfsNiNvQOb6v7Ta/etJrgk4aEhNJbyiHNPm7Or9nRIlU9TIOXMMw9BtP1m8R4d5ULEZPjoGkEXXbwBwR3KD2IybZ+c9DTTQ/nCydMJWScaiYW+IRFxSF+NT6YPIHQk3S0cP8yAKelIvbzCb/lydXD6C3PY18sEYcocu+Y0YpCxORFiR8pRGcOfj6P58Z8t7nDhmM4xss1oSufCXeisRDIdgq8xkaIq2X/IKccNaeBJU4gyghpP1Our4HI2z002vZiiF/eyIgTMs58xH+wKksS2wq8D8dbLcJMx/fp8VR8X+WVpemD8mQF86YGI3OjayoPyBaDZ7sNGhXrE7rCJV4lHSH6Cyi1mzmDPnCVXHAq/jtcNqtJUPmKbVdeQiVmVfOwrdcsTQcC891gda48/050g4oavqCnMyL9RazNjzbnrWAIrz1QyKlyufBEvPWDN3FRSAM3HS7Rua2qjVJtMQQlUySgtNhp9jJK4werD2QVDsDDfSmu4YEHt2+kNnapmrVC4ihq+R9Xcs/rHac0WqxdX9qZ/8E/o4RP53ifYaUxrP97vWmvXat1NZR8LtHp+O5kd6reNazxKf6FwEVqjLQQka53wLnJ97NuP6I38ha8s6kg5Q7j1kCxEVbLDnq9b9meH6y0Yy7OK9zdFfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(3450700001)(38100700002)(83380400001)(54906003)(6486002)(2906002)(82960400001)(26005)(6666004)(186003)(6506007)(6512007)(478600001)(86362001)(4744005)(7416002)(8936002)(316002)(41300700001)(5660300002)(8676002)(66476007)(66556008)(6916009)(66946007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vEhtgQvq3TTCrj6hOCyYNwTmCq0r0We9jdMfhw0pxxZ4oJu6Ai8tgczCLntk?=
 =?us-ascii?Q?WZ52KgZHjkBX9vH+VbNlML3Wx9Yq/R2sf+ZSMnQvbX1ey+ObA7ItZq8aAt9a?=
 =?us-ascii?Q?cCGarYLcqJSjxthk4udhpNKSeYsE6Mxyvo1iJhcOLaRytJ48J+lpSGbmz8jR?=
 =?us-ascii?Q?xYuqTrfq0LwIqGAAMUVLVlqgwVnzqTXP9Lg8oRttjbHqPXDHi0mPSXFwK6/J?=
 =?us-ascii?Q?YenGBQWF4y6d7UBpmG/8ldz7E5GZJRY7rFpdGVb19KYHk+SFXeaz9GdlLODB?=
 =?us-ascii?Q?bQKn0mkneLhRHr+e3sTqEshJkxE/SEiZkIhvVLJJfSKooqtl2263TVzBL4ha?=
 =?us-ascii?Q?pf1MuFsosOpRwkubVq76kMDyV0OTBpEPu4YAK5All2JSJLXFBO6wR6xlBy1m?=
 =?us-ascii?Q?N0nG1zIIF6MX1PqTQk389FO5Jn52tnT5xxsC59RwPcjrGrFIEFloZE9F34jk?=
 =?us-ascii?Q?WLYl6rZt697nZarYIHm518ZnDvdWYJjt7aCebfupbD6R26ikdoQnisxlmBSb?=
 =?us-ascii?Q?jQBF0bYOdKF0vH5/1O86wJ8BhMjFjQeROy5+p6SjqIn8HoCyGRAxHe0L1biN?=
 =?us-ascii?Q?bZU0gdOjfiUfnAm6f25dxw3fQWnMoemimi78h37aVIrqas4kruCqi1IJyipP?=
 =?us-ascii?Q?KznJP5L1nn0JwYlsg6304RxBQHjzYpeQ6v/BAtS5WikU0JjsGgDb0x/zg9ju?=
 =?us-ascii?Q?hWe8k9csp1GvdKKPPbPxMMHhgnLNiOj+FhebIHkyGdd8K1dzbOLsybHHsrmJ?=
 =?us-ascii?Q?FNdzj7/8lOvKnvy2RF8yxCZ+nAdiubF6TzxNNHqYI6Up4RRZ4RlEn++ldKVq?=
 =?us-ascii?Q?1vFkfC6jTxVzyvByaKqj9A4sql6dZGtgYmpEEAiSiEnhjsoXbEJ4evx0Tsy+?=
 =?us-ascii?Q?xN9nbuficdmzT7mkfQ4/mPSiVnc0NJfTjMYIenkU6nOrkCauGDoOVNZrlKnN?=
 =?us-ascii?Q?xV9qcdusEVWlz/cIXLRWOa832XICetewuFNNAhqXUeSlembRq3UjwqjlDA7X?=
 =?us-ascii?Q?CFgC7WdBuBVQ2fWqQmKbuXdqOAXN520u40rkjJ73dTIS4m9KxJHXaIC1F/3A?=
 =?us-ascii?Q?R4K06YKY/KT40xkKUcj6SKfhHmlbmZINYQC37aajpgRZ9U5uCbLyk85qoRDH?=
 =?us-ascii?Q?kt0SFX4RXCiRnm0KmVvHq01awNKBqC08/PZfJTB3VHNtMRO32SL11nnswZRW?=
 =?us-ascii?Q?f5d5Dhx7ARKFjyX+Lpj5pxzEbSdYLZkBY/fY/ngw3E/TEjK0sZEsYyqFMaZ9?=
 =?us-ascii?Q?fWexO95ougIfehyH6mctcoI4iefEcQd3HV2dqt3nZkFAsw84yH/ky15hU6E5?=
 =?us-ascii?Q?rrUYir4iLZ4IoVtB6vnWq1gm9HxZiK8dW53T82iEkasgBDkQqNW9mhNRjsOO?=
 =?us-ascii?Q?CQzRiFVbucqguuKJFoFpJxIse/22HWeXlrNEdRbNeBeWuUsqfiruNrCg+pit?=
 =?us-ascii?Q?S+EJUHO5uABhzu7fwLwI+iTYTWAsbYOQbvzbCNEUUFFUo8EAPT5Gzu1e0mWK?=
 =?us-ascii?Q?K8y+prrzgGFDPhG8C4Ujoe5CnHydGdXgDAUyAVH1oh2L1ZSzYqtOUbG9Bjl0?=
 =?us-ascii?Q?+ln7SLprWrFGdmCMlXjNqEeaT5dchGDfj5Zu9hVCLJrJjbS1Nf+Wc4TEma0Y?=
 =?us-ascii?Q?2w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a1009b49-6f17-4bc8-036d-08db162713c4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 05:22:09.7486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5k1dhrEO+53Htp64bu+Kh2KJ8hBw+uIGG1iwT15pQY6fCti8RXpkKOkx9lrOLd5FShVj54sNM7yu5cd0sHZnng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8230
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 22, 2023 at 08:59:51AM -0400, Jason Gunthorpe wrote:
> On Wed, Feb 22, 2023 at 07:44:12AM +0000, Liu, Yi L wrote:
> > > From: Tian, Kevin <kevin.tian@intel.com>
> > > Sent: Wednesday, February 22, 2023 3:40 PM
> > > 
> > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > Sent: Tuesday, February 21, 2023 11:48 AM
> > > >
> > > > +
> > > > +void vfio_device_cdev_close(struct vfio_device_file *df)
> > > > +{
> > > > +	struct vfio_device *device = df->device;
> > > > +
> > > > +	mutex_lock(&device->dev_set->lock);
> > > > +	if (!smp_load_acquire(&df->access_granted)) {
> > > 
> > > there is no contention with another one changing this flag at this
> > > point so directly accessing it is fine.
> > 
> > make sense. 
> 
> Have to use READ_ONCE though
>
Just a curious question:
given df->access_granted is now written with device->dev_set->lock held and
also read with this lock held in vfio_device_cdev_close(), is READ_ONCE
still required? And what about df->iommufd ?

Thanks
Yan
