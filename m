Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C986C41AB
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 05:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjCVEmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 00:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCVEmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 00:42:21 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0551716A;
        Tue, 21 Mar 2023 21:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679460140; x=1710996140;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0xuJIgYjybjOFdE+F54Z2GaIap3Zm2p5am9++NPRybo=;
  b=m9zHVRCGCY64lm3QoWTzZWHO8tssE967sdh8eS21XJIL/m+927TVORnR
   FguGIlhECqBFkgq+x7PgQVJmzsuOt1e1r3M+fnXXEIw4jQe9Wn9q57hQk
   E3ilBT92+8y+N5ogtH1s23Ky44m09lfDuEdqrWwK9LlQAtg79uP7/1+Be
   OZEC5jDRYE88ib1oyctR9ZQkmLIzCoXc5ZzS4tF5X4HlCLWCoS9I2bVd5
   e0YHogWnpvo1GMRDT/HwABtsdiciP+LCl0LKtmc2E789zdKawRO6MpDB0
   Ouv/DbI9FZsYp5a1B5rZ4wJECZSm5+Oq2K5e5rz85+oJLftXgtvvKHsUa
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="336632586"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="336632586"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 21:42:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="631854789"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="631854789"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 21 Mar 2023 21:42:19 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 21:42:19 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 21:42:19 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 21:42:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AvykJ8p96fdiiLgT11Gm/MtL2qhoOf9mXk39+T0eYprqTFEI54AY53b+dmYCIEDmj/gmycrjPy+VQHigq5y8fK9+WGTviMpstz8usmjd7rwm5fnRAaJEivKKiSWvIzjUGB02UxFYtUdQQkf3lymj1jdQFsikCGgR0y7z6yDY0APRBNoSFgMr5j1lsFC0m/eUFvWpgwHb4WYdhcA4rNhFOqeqH0MTQlvrND5E//qtmbaM0z1bb7WUN1oDKaw9KxiS9UmMpqJGZncWfiuuYXbWaxkzEZsEnbCQ75F22/q+xDSFCxAjiBlASDyhc5Hq7TU5aR8FHjL0e6+0r3gmMqsjSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vV0FmQqMG3B4zaCHT3AwuHdQuoROSiPgGvtKJ3qi2ZQ=;
 b=WfGRBn8e0WnODTT9gLcs69Me9qLv5NlhpCG/C2jd8Q7F3vwzTvX9D/TA+Lz7YOhcxR4R1aeRcQuIgSuFK1OXTqeivthz1YqjMlcu8SDfYQwJUQ62CJ3CQ2bPpl5soTvyg3o2FhTJDpY5U5kn2J21mxm6BCdDLDs5URPEvZuCTkJfkngNai7HJqLIJR7Cb0DPBAUCrX1UG1Y9QpIMUvChCvHap+9SH+BHRbdL0Olt08A+LEwHV7HNJ8g21vCbMW+CPAyDIPMCDIAIHJKOH7YDUSUKC3VjwJ8SfuYnoiw1zXLF1iZCdQFlG1bmvJDIM8ayYv4pZmitQkoggGMv0f2I+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB7061.namprd11.prod.outlook.com (2603:10b6:806:2ba::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 04:42:16 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 04:42:16 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZW095081R6kW/70aeRy5pC5KSt68ERp6AgAANFoCAAV3gAIAABT4AgAADFwCAABYxgIAAB4uAgABetDA=
Date:   Wed, 22 Mar 2023 04:42:16 +0000
Message-ID: <DS0PR11MB752996D3DCB2F0CE6728F4B8C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <BN9PR11MB5276F7879E428080D2B214D98CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230316182256.6659bbbd.alex.williamson@redhat.com>
        <BN9PR11MB5276D5A71E43EA4CDD1C960A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230317091557.196638a6.alex.williamson@redhat.com>
        <ZBiUiEC8Xj9sOphr@nvidia.com>
        <20230320165217.5b1019a4.alex.williamson@redhat.com>
        <ZBjum1wQ1L2AIfhB@nvidia.com>
        <20230321143122.632f7e63.alex.williamson@redhat.com>
        <ZBoYgNq60eDpV9Un@nvidia.com>
        <20230321150112.1c482380.alex.williamson@redhat.com>
        <ZBottXxBlOsXmnmX@nvidia.com>
 <20230321164737.62b45132.alex.williamson@redhat.com>
In-Reply-To: <20230321164737.62b45132.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA1PR11MB7061:EE_
x-ms-office365-filtering-correlation-id: 914f9816-1987-4881-17e0-08db2a8fd010
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: foUIDevkEOurag1eWb6zllIwEucT+vwjSsyz++veBEhlmNBi14jZbnRjvBUTrkiMjIyg+4j4o+ZdFoPBif5xYJlAwis00Pbhkr/gUZohELGq026jtTvIzLPEldpnJSYI0C5C0VVVWC6x48Fq7wgxF4SoJuLj/TH3KmJjD7QwdTdCwy5nS8qkl8tp2AP6GgsfFzsvDa+TCeuVPDdTUBNqWzO7w960eObtcAVlJwuMyVSWjrRRvQaYNTGXHglEaYf87jJ7KTwLBRcpH7HEnUoouie7zGVVvQR0dEGFxzXaxX4yhsdQ47FixaHQ0V8aefg8dLcRqYWfHTRvDYMA1HjAsVav+2nqUIJRfhaKCXIhjxjzZ8j782Zagv9CbuE1HIMfYv8OvGjNALS//fJtRULZ7GOgUNjxm15eB+1jp9LM/lvqvEQs8yy57xG+Kf5KTKQ1bZGAoYbFbD/mt7TWKy7NFk7JeCmlUw2cVyui/JUa0Cmwo9g+6JdLOArrZNX+gxtPmm/j+IyqjqkFHwD1oHdz0O/IvQUQF2ijgiya/CdgQsmf+rOCqJKxprbAWEJsWCqAHvFgzrqjgJnOvAIkBE15QeNT7MEPLETOuBcXvfHnaczDdKWPSzHqHPo1/JAI6Mim/H9xuRpyAvGcPUcDHqXGSQAYPx17TARm+xngJcmHXW6Pv8Gg46Ze52zHdB0lPCHBX8YbCELQ/sBMAWeyMjTx1gbGAHUm+CZHRBOGkbQ2SO4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(396003)(136003)(39860400002)(376002)(451199018)(83380400001)(110136005)(54906003)(55016003)(7696005)(71200400001)(478600001)(2906002)(7416002)(26005)(41300700001)(316002)(9686003)(5660300002)(6506007)(86362001)(66946007)(4326008)(8676002)(66476007)(76116006)(66446008)(66556008)(64756008)(38100700002)(33656002)(38070700005)(186003)(122000001)(52536014)(82960400001)(8936002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8zxk8P8oBQhO8jSW8bLluS42k4xAiNZhxeEib4s+W3gsNCIsmTDj1VLD/2N5?=
 =?us-ascii?Q?jccHcDsSoDn35Pa15dJhu8cQkHqppzDIgVVNQV1xhmgEpD5JR4Z+/nrXY3Pg?=
 =?us-ascii?Q?Axs/ctT0V0GGeGfW1lmuqRj7NGDkHAA7YToC9inUk4mb6PX8pWv3MC8Qpy2M?=
 =?us-ascii?Q?uRbCiI0WQlLp3pwsux6hizkgED4HBy72MXYEV4SLpPnG5gNvSLtFMdiGxjwB?=
 =?us-ascii?Q?2qLn4KNGVaY+dDCaOg56w2ls2HivieqJBgkreNNDEnc9j4mqmVaus4mJbkf2?=
 =?us-ascii?Q?B0UyKH+gjDhhXL0AbIXaVTHgD0anmD3X8+qjMmnYjB8KsEb9NkEmgWPER4TR?=
 =?us-ascii?Q?kKapNazjdogqqEg4nacvY7WvvEJZxMLDiq+y3u1UCFRyuYcevFVMghwat0aw?=
 =?us-ascii?Q?/HetT/17dOfUrPW4u1QYgMvLzzvQzXWG/zfr8NgclacGVZqjDVbUUqxyoYcq?=
 =?us-ascii?Q?obGve88hPzhKjWs+Y8Mgs2EsuGug/u0qNGaR8YIziQCB8EtdSuWTwd2L8mw1?=
 =?us-ascii?Q?yepZL+gOKXXldn76EeBg+zJr3ZQKxCY6tWqlW5HVs61qR1jxoHVqlkhvKB5A?=
 =?us-ascii?Q?Zrw3D3/3PSr7qv5Hu4HeOtx8Fpfr9RQiEzzXT06mq+K5aHk02m2nl2GXJuA+?=
 =?us-ascii?Q?s4ewqqqew8SGAWZmW1xbapPVr0Qbl4otVNSYVlE/cggTZ8WnxkPaiNpf6gsP?=
 =?us-ascii?Q?/hoI+iq7A6N6HYzBORoeimz5xbww+vSsZ5C8hBGMV+A/6CtwnXBAe7QhVpj8?=
 =?us-ascii?Q?jolbTJrFeXMqtPds/EZdZoxWO76OU7/ycr4Lhc29BWxwlzz1BayPbNu3zwy9?=
 =?us-ascii?Q?9DUAC8F/IM+VgTguWRdPtq2RNRkDOdOg8Kk4SyEITgdm02+LLCpBhekKJUmU?=
 =?us-ascii?Q?b7AiV3JrVAILnTbcBRaWH4TFkPqlC92+dNOFfbaSbbcRErL4rgy4LiF2Y9xj?=
 =?us-ascii?Q?CTwloTOOyHevDY0pmy28Hui0GBBjxICQyq7rSnv4LLZLHiOuu3i6McA37Bo2?=
 =?us-ascii?Q?TbvKiGYj5fs9YHAr08EXVil3BQkfKmUC/qzFyZGj3VKGWatI9ADoicqLM1Ir?=
 =?us-ascii?Q?u1i9Cxu4Z0VBe4a0oeW1x4gNYAhMI5BRPEeJtsn5qKODYOzFauksf6gXzVMw?=
 =?us-ascii?Q?jfLo6NZqwRsvllGURQKtETIXqABD61kvOt0FxkX5+jpOnHjzfS66O1akkCCE?=
 =?us-ascii?Q?ua+F1w+cr9wsgLU0JSd7Jg6MCY5/ei3WzoIg+E9VZNq+rgcpBHUzH9e/R7H/?=
 =?us-ascii?Q?HuIkpeYAjf60mK8cMBMdBI6cZCWxQLMCfQf3XHTVnX0xxBWowmP58QlWK4sX?=
 =?us-ascii?Q?D9KHxExhfc0zPhfN9Q9DYXGiEA4GU0hXSubvR/m7s9xp6yUlTbYFduX3zX0D?=
 =?us-ascii?Q?fS788hnzRFVkmqXAu2w6Dip01wcS6UtgfOBhfJtf2xvn+YPX+0Pi6pHm6U77?=
 =?us-ascii?Q?27B+LmJMtKoxKM+hZqpe2+dGE9j+Y+iT+62NXhX/zUdrYTX6IAa0Fbyqa4Ni?=
 =?us-ascii?Q?5Ikxbh+77BVP+IlkaKhlK38ua0w01BxElI5UYb56416VgP63dpZbIPgItoEw?=
 =?us-ascii?Q?sRt1Cftm1OpQkmZp/8L8FUJPDt6uaY1sxLDUyM0n?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 914f9816-1987-4881-17e0-08db2a8fd010
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 04:42:16.2139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wPS8zAz6Y+rhRj76Ef8Dd62mD3J4Z1qGqhb5Tm0s/JOijV/+14ZB/Kh5ERL+EflzJLNSTKs5JUt63hKDsLI+sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7061
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, March 22, 2023 6:48 AM
>=20
> On Tue, 21 Mar 2023 19:20:37 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Tue, Mar 21, 2023 at 03:01:12PM -0600, Alex Williamson wrote:
> >
> > > > Though it would be nice if qemu didn't need two implementations so =
Yi
> > > > I'd rather see a new info in this series as well and qemu can just
> > > > consistently use dev_id and never bdf in iommufd mode.
> > >
> > > We also need to consider how libvirt determines if QEMU has the kerne=
l
> > > support it needs to pass file descriptors.  It'd be a lot cleaner if
> > > this aligned with the introduction of vfio cdevs.
> >
> > Yes, that would be much better if it was one package.
> >
> > But this is starting to grow and we have so many threads that need to
> > progress blocked on this cdev enablement :(
> >
> > Could we go forward with the cdev main patches and kconfig it to
> > experimental or something while the rest of the parts are completed
> > and tested through qemu? ie move the vfio-pci reset enablment to after
> > the cdev patches?
>=20
> We need to be able to guarantee that there cannot be any significant
> builds of the kernel with vfio cdev support if our intention is to stage
> it for libvirt.  We don't have a global EXPERIMENTAL config option any
> more.  Adding new code under BROKEN seems wrong.  Fedora ships with
> STAGING enabled.  A sternly worded Kconfig entry is toothless.  What is
> the proposed mechanism to make this not look like a big uncompiled code
> dump?  Thanks,

Just out of curious, is the BDF mapping gap only for cdev or it also
exists in the traditional group path? IMHO, if it is only a gap for cdev, m=
aybe
we can use CONFIG_VFIO_DEVICE_CDEV to stage it. This kconfig is N by
default. I think it won't change until one day the whole ecosystem is
updated.

Anyhow, I'll also see the complexity of adding a new _INFO ioctl. It should
return a set of dev_id to user rather than the bdf info in the existing _IN=
FO
ioctl. Is it?

Regards,
Yi Liu
