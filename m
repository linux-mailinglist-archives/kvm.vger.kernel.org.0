Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9360A6AE08B
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 14:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjCGNaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 08:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjCGN35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 08:29:57 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F6CF744;
        Tue,  7 Mar 2023 05:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678195767; x=1709731767;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wODZnShEi40AejzzvzjNZ3VwIp3QR9n1Y69SYSffOCA=;
  b=KgdO7wsYqvJgO+prNaYJFB2v86Fe6gGuHWGe4HsdcUz3U1xFOJFgYKl7
   yewanxusoe9iONmA+79FMY8lhIj5qSop2BYY16muCUBVRRfrMnavQG9KX
   pYUcMLAWGZaC4UMAlCoxyjoMlHiMyp/qU3LI1QBkESDvr/h56XxXx3F+P
   VwQkjsFaVMhfGFkLcU4g7yG2heW05ijFQVQLONQLddCKM/F+Alq9zY+DJ
   Eqr4Saxl7gxE3orauuikvjzYP7VgAgfqD0hyjnzAsbWfhEb2kR4AsqonA
   7lnxHN4D0wyerknbrtwLNJZ+5vgO93g/uBHPn/3x+Ml4blLYkLeTi9IcQ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="338172995"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="338172995"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 05:28:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="653971287"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="653971287"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 07 Mar 2023 05:28:45 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 05:28:44 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 7 Mar 2023 05:28:44 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 7 Mar 2023 05:28:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0GJIIrPMp8nEZty+dlAnv4AvpXLjR+uK9evRleuy+KU8WwIV5hCzBxhxgNKaxKD9hndKNj8qoRg1qKdJC8c5vyDV7qJrYycWuTTsd3KQOaD0v19yXUunc09UuKA/VM/uWe12lsvRyRRXaGzv3ol2aOLGN4tZgswdkUb+Ss4VrbCo4hb76y1XaE7SYJ9WrfdRko3yn/Jar5CZD83PjIprYjBT2E79jLcHWOI0x2uLon3fPDZXsnjOZeja+j62FdZki1YnGEmf+ekMWwn6uhxpu8cMbhn5zA5NZ5ZIpRpJ5WMRwOZQlpxEBhEB7af289Kl7nQwALR8tijDYuKRf4PFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VSsVjOwoAqWQ5E/o30az+P+wwfkMn++qdGWM2oRg5bQ=;
 b=Y8AFP6OrDPxYagi/m9BG4VtTNy7jMQ20+o2NHR0sYyg8UQWD3Dc3FPb5AHwX7GQwCX3iyDfJNMXXeUMWGcDkLESJcZW54SYr7PuaTrbsv9jMYtaQHCeQW3Z9xmNff/+mEzHerlDwg6+dqEYndhnfFqJpi7dn5NxxElI3t47voJxIf8biCDOtjby7oT2oR5lY1BNwJwPTC1/p5G486ik2UMFyv6vKVMTnmpVD9LkzA+BACN7na0ugfBo2upBGt29LUiDDW1V3dhaJ0yqy8GqPn+JqgPdXzgg32mh+o4Ph8lKEAvuAKgkdCFhsa582mKC686rgFNJgjRj4DfTTljvwRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB5943.namprd11.prod.outlook.com (2603:10b6:510:13f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.22; Tue, 7 Mar
 2023 13:28:42 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 13:28:42 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
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
Subject: RE: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZSpxNz0d7VXviIEytrFhyB5GUvK7m/3jggABFoQCAACyCAIAAGw8ggAETHYCAAKz6AIAEeeOAgADd5oCAAKkfAIAACTyQ
Date:   Tue, 7 Mar 2023 13:28:42 +0000
Message-ID: <DS0PR11MB7529A864CB1C149CF8B19E78C3B79@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-10-yi.l.liu@intel.com>
 <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZACX+Np/IY7ygqL5@nvidia.com>
 <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230303095542.2bfce5c2.alex.williamson@redhat.com>
 <ZAXny4NDDq42NUxE@nvidia.com>
 <BN9PR11MB52760ABC93BCE7FB53A131038CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZAcvzvhkt9QhCmdi@nvidia.com>
In-Reply-To: <ZAcvzvhkt9QhCmdi@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH7PR11MB5943:EE_
x-ms-office365-filtering-correlation-id: 4e5a903a-e98c-4a51-3ed9-08db1f0fde8c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1r5i8fleg/lPTaF8n0IFjeXLrcaVh6lbROzbIO0GQ91OjdNbhBeFtWuVDe5hY1XV85S3NYzB4O4VqRa7rw0S41yCqiBliXKUg1bkcJjJhdyeqlPDfIm9ZrCRUXyWIcV0OTjYGKrs2nkyHChzD23qGccD4VYQz2Ckm3nmDkk7y8iIy7DDNPQezvIBSxkw/c9/skdwoW2FwJmqaImjCLPEy3dnBP3qB0x51lya1VO4Fcg3H0JG6pSkZHmTc1fVXUH1rTW0drUmkufgmTLdBh7s6u5bgDkcD731jzt0T4ja5/SiQ3fp7LepXUX28/N74bM4Y+Fm1UfT9SW0GRwVfQGOiCsCh3C7Jl2jDKdmQPL0gUqcYXyX/1MORJ6qihgj5TAOlCaq5kdQy1qcrI5PJSDEgHvbi4tAqx2/v9K9W+1ssmooRNBDbZkWpc22Aq65/MJxPQIMN6sBCqnS09KVnLcjgfYBy9+mfITjyxsl76yc+n/hbrj+ApxlP95Cx+mMuBZfEOFeyAZ/8/ul67lDtE4JHXPK8I0HJ+xZ7pSHqcnB0UenQZw8bm2IY/GEi7c/qqwU+NcOd6p47oIC6HxUMyMe9KrYVpMttCsqAPwoTY6PfQmdpe3jAB2TnxP9T6Df/nBkdB+WqDbI2WuvCi3QB9VDUj6r/OUPHLu0o8pnvLx1GE/9jazeUUqlqJDndTLXZUxXDmIjf+Ogz3ytmhjNgl+mcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199018)(82960400001)(122000001)(86362001)(38100700002)(2906002)(38070700005)(52536014)(33656002)(4326008)(76116006)(64756008)(5660300002)(7416002)(66476007)(66556008)(41300700001)(66946007)(66446008)(71200400001)(8676002)(8936002)(9686003)(186003)(83380400001)(6506007)(110136005)(6636002)(316002)(54906003)(7696005)(55016003)(478600001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3PQNduvuJnI3Wvnuz6JJcinCfbh0clQx7L4/MdOCQupZiz8yO6ALdlzhAXVe?=
 =?us-ascii?Q?OQMW10A38di3RBWGdcL45ESntOb++YSzCt9sdO6YNAX4nqA9RijNTXP+3ymk?=
 =?us-ascii?Q?eV9s/aelAFInRyK166508zQSHf9DcsT7v7FnUoZbxF11AROKap1fTRyuIKd8?=
 =?us-ascii?Q?bfTmQKKlPxXyRRuQElqbJorEAHx0uGb6TdsZxcJ8sqN9479xRVqkVmj/bVHt?=
 =?us-ascii?Q?pLJsRLCmiMM2giBpltZjIbSOSpjuADyn6NOqw6UJtxZeG0UjFWOp1M0tfKaC?=
 =?us-ascii?Q?fS3HGTFHILtV4US3leslZacutFpHhYimUk9y/cZp8ulPYGNFLTv/0kOtksr9?=
 =?us-ascii?Q?JJYN/YqOTTcJZyPPHRZ/ToS7LMDJSAJKMHuWPjynV2vvsNPeKMfq9C3XklWw?=
 =?us-ascii?Q?MdDr2cBZo8WJv8jYaKdUBc+Js2zDSZAgCJPebEJC2/OogrvU+ZKcwODXOkKr?=
 =?us-ascii?Q?sGfFH0zSkBPvxANRpQm6uvUfebDOtrO6OCb1u/QFOds0I4d95belDWD6u8Iz?=
 =?us-ascii?Q?Y6GyN//YUziwKRM9myoUUETfq5LLU6484eHkz0UjzmtfqfVuxgny3Ykk7oZn?=
 =?us-ascii?Q?4E0dDwib0GUGaDgbo2rt3hrcKiVhPmSQ5pjf3YiTkUDtVr+WvfO1JGlXqvZm?=
 =?us-ascii?Q?vouXqbKd6z3I/RuC6tBYuDVL9k2zLylBDZisgfeX5/pssJ9QaRfIB+3Wy8j4?=
 =?us-ascii?Q?4+JzB6gp76cHNqVGOQJZRETPhQSDcnNZtahvkpH6wZxN7XNaciLZSJFxYVfj?=
 =?us-ascii?Q?/VoToSCK0rHIJPsm8WkqAii7xABaHXLsnmADiH4WLnHhrsWToaT9AWHU+xlv?=
 =?us-ascii?Q?oEZF1ajH0fsT75DroFYhBqAaMbuu1ysf7DkZs2IWPak3DVkYwDFTsVnissCq?=
 =?us-ascii?Q?WMyj7H7lfC709LW4/km4HSkkrxKtsXkdRvOCSF5K04KS9/LMbz1X+a4PMAbo?=
 =?us-ascii?Q?eFxfYoww7b36JRsxbnPvS9AALmUeRt7Y92bw7Nk94L3s0NOC6ASNBAIJJlNb?=
 =?us-ascii?Q?bxdhWpPQcZ+GcOVvzpEFFEJmrZuZwNySlU1kJ+Rtf0WrJ0X7fPYNl1oNptJj?=
 =?us-ascii?Q?POiBH1zu71+O3Y814YAKOqn4+Edws3Ud+BYaXNsQDlx0hwafgbWtFsRZ76fK?=
 =?us-ascii?Q?a4LxsGv1A2QgM/ViAv6udNpBKUfDJ9yYF+fW71kLvYpY3yvC607DXJuLhhvO?=
 =?us-ascii?Q?cBwwyLgKUFDw8nZCiMrXvBCi4JPmW4tDmGLwvcDTF1T7u2m862bKj3f31KRf?=
 =?us-ascii?Q?VPgplV2RiCfUN2UAt+fUyXsifrlRO6bEI10mq/xeTTRbzN3bzzvJkASLmcuw?=
 =?us-ascii?Q?zUb4m0Ilz32BcUEV83fMpjmmkHaZNkY2HthX8GiNTrsWFUR8t7OZLrRpf/yu?=
 =?us-ascii?Q?QR0y60RVhFsUSDVSCjNQaNj/GuVQM4zj0koC+IPH89RmBN3H3Bv8a2JRHf+x?=
 =?us-ascii?Q?++fWLdFGU+wIZ8xmGsMMSRhKUGq2chPUOeUIhDqJEuMEoBmq3HkdVtN/FZNm?=
 =?us-ascii?Q?3uMhu5pkKYi0O3GugOlJRcH2ORCyCr5bqT40AWQnBAhVKQTMf/aUPQ/I6DsV?=
 =?us-ascii?Q?MLv4SoNqMZY+uVuv6A3RbocEydmih35W/JBLN+8R?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e5a903a-e98c-4a51-3ed9-08db1f0fde8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2023 13:28:42.1448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lU6L9gBBFkCoHnnVwCIRo7b38uxniEsbPcd5XvzCsMGap6YHx9hFnZg7KYgpkPDOvHcbHdb4YAKqnAGB1geUJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5943
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, March 7, 2023 8:37 PM
>=20
> On Tue, Mar 07, 2023 at 02:31:11AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Monday, March 6, 2023 9:17 PM
> > >
> > > On Fri, Mar 03, 2023 at 09:55:42AM -0700, Alex Williamson wrote:
> > >
> > > > I can't think of a reason DPDK couldn't use hot-reset.  If we want =
to
> > > > make it a policy, it should be enforced by code, but creating that
> > > > policy based on a difficulty in supporting that mode with iommufd i=
sn't
> > > > great.
> > >
> > > On the other hand adding code to allow device FDs in the hot reset
> > > path that is never used and never tested isn't great either..
> > >
> > > hot-reset does work for DPDK, it just doesn't work in the case where
> > > DPDK would have many VFIO devices open and they have overlapping
> > > device sets. Which, again, is something it doesn't do.
> > >
> > > IMHO we should leave it out of the kernel and wait for a no-iommu use=
r
> > > to come forward that wants hot-reset of many devices. Then we can
> add
> > > and test the device FD part. Most likely such a thing will never come
> > > at this point.
> > >
> >
> > I think we don't need to have this tradeoff if following Yi's last prop=
osal
> > which requires every opened device in the set to be covered by the
> > device fd array. with dev_set->lock held in the reset/open path this is
> > a safe measure and fully contained in vfio-pci w/o need of further
> > checking noiommu or iommufd.
>=20
> I really prefer the 'use the iommufd option' still exist, it is so
> much cleaner and easier for the actual users of this API. We've lost
> the point by worrying about no iommu.

Hmmm, so you are suggesting to have both the device fd approach
and the zero-length array approach, let user to select the best way
based on their wisdom. Is it? how about something like below in the
uapi header.

/**
 * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
 *                                  struct vfio_pci_hot_reset)
 *
 * Userspace requests hot reset for the devices it uses.  Due to the
 * underlying topology, multiple devices may be affected in the reset.
 * The affected devices may have been opened by the user or by other
 * users or not opened yet.  Only when all the affected devices are
 * either opened by the current user or not opened by any user, should
 * the reset request be allowed.  Otherwise, this request is expected
 * to return error. group_fds array can accept either group fds or
 * device fds.  Users using iommufd (valid fd), could also passing a
 * zero-length group_fds array to indicate using the bound iommufd_ctx
 * for ownership check to the affected devices that are opened.
 *
 * Return: 0 on success, -errno on failure.
 */
struct vfio_pci_hot_reset {
        __u32   argsz;
        __u32   flags;
        __u32   count;
        __s32   group_fds[];
};

Regards,
Yi Liu
