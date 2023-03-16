Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D316BC408
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 03:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjCPCyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 22:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCPCyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 22:54:06 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943A43B670;
        Wed, 15 Mar 2023 19:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678935244; x=1710471244;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UrUcVXSBx8LnQ9lCxRkG7mglMpjh78OuyKmCryCbFls=;
  b=FpIP0T9PVv1IKzFguS79LsiYJalYCDYwt2kXTxcGSs7uygIFr55Xsxp+
   tjQyrIb3XKVcLmITD1YfiOd+MDE+1t74cVMmtlZAoWzarePw6CABgeJFq
   3vLL/SMW/syBn5E3DLSxQVD+OTU7hlAl3ErOLQ28+e5nGZ2DtYqunWET2
   yvc5nsjpHYIpspuPZvrcCUXgFZFootaWtVCawc851Mm7Ti6gUuiyfNe2t
   252NU3aRcxjyB09+NBr0g+YaFsZ11zUSurKPS/JipOOv6yQuvJwH0kUxS
   PdUWda3owLDX2Rfe+p2wBnSEjFKVg47jG/qctsPJdd07xZRw9bhH5PLSD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="317524686"
X-IronPort-AV: E=Sophos;i="5.98,264,1673942400"; 
   d="scan'208";a="317524686"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 19:53:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="748684587"
X-IronPort-AV: E=Sophos;i="5.98,264,1673942400"; 
   d="scan'208";a="748684587"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 15 Mar 2023 19:53:53 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 19:53:53 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 19:53:53 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 19:53:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drgmNkZkrrjjrI1w249sWJTngENNtD6afq0H3gY30hgWM6R4iWfh5V7SntmNLNqE/Zk4By2iSAz1+13x/CXuE1G+KoVziowxbwjZjDeSr5+KXDo0tG0hCa2pKa1vA0ctfUvRZuy1iwMXxGVsqJ0/RKyFj6EsCYF5IsGtQcKCDHsfYDuCru6O+p0Ouhz91IGMdTEKxAU2kD+jvOXKdLJEv2uJxTwz0ZIaHM/x38rmrPGQ3uM90Yx7okPlZKor2tbylAAR1j9mGrCq+6sZ9/Kq4Oc8Q+TUW+iiWDkw37NG6p4XYbudFeNsvOsVd5nnokWCahXx23GMuBofa/pD68zDOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LRSub9mcaYDo3waaso70EzKmHFyReHS4h1FhAgBDxhk=;
 b=IaLkqjI8RH1oQudMw8fs9TyQeKIYDrBLjYDMQqiK2uvwzfu5HC0fUiWkuDQQzxAFQBrPVwe8UMYaNKftcziFRFW2pIwITaYEqyPRZ3t58hcQcKSBckJvFPhg0eAERUhF2xEScqFpZ4ddpNIar4xqpC/Xb/ENKpbyt8NzvNOn+hO7IyvcsuhU5JKxNDAY9x0Wf+CeavMlRwI+19U3goSsV/fjHZlQTibx0sKOTzPpSRaH/sFr+6CJrgjQSCTYIYw72g0Q+WJz+Pyl0OMbtpwwi0FxeXyJsgnx+cwgqlSDAKW1Mx/wt/5U+c2KD2Ayj4nl4Ppsm2QzgR45Dh0W6X9/sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by SN7PR11MB6923.namprd11.prod.outlook.com (2603:10b6:806:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 02:53:50 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f%7]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 02:53:50 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Topic: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Index: AQHZUb/VKrDPi02EE0KOkFVtC1WCVq70SikAgAWuFwCAAReSgIAAVgYwgAAGiICAAAEI4IAAKQWAgAEmOLA=
Date:   Thu, 16 Mar 2023 02:53:50 +0000
Message-ID: <BL1PR11MB52710B5DCB08214EF4542D098CBC9@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com> <ZAtqlnCk7uccR5E7@nvidia.com>
 <ZBAuXo166M+z8b3z@Asurada-Nvidia> <ZBEY49XtiFUImfe4@Asurada-Nvidia>
 <BN9PR11MB5276738DC59AC1B4A66AB3C38CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBFmh2iAqGGb8CjK@Asurada-Nvidia>
 <BN9PR11MB52765D7977F987960072482E8CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZBGJzefTm4p/ReIu@Asurada-Nvidia>
In-Reply-To: <ZBGJzefTm4p/ReIu@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|SN7PR11MB6923:EE_
x-ms-office365-filtering-correlation-id: 96c9f3fe-dce1-45ec-c71d-08db25c9abf8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lKPtld7yJvzOheLrlWLptai48AIHehfM/1hgseK1dMK9m9BawjruSBKV6SdzBQYmK5D7gFwMj+VlSdQ1Eagcuke9Ps9W55t6aHy5N0jskLynzApQuv79WeGqhY8D9cv5Iy7u561bqMLnp7Wee12MO9jlsqpHBKN3bfPPYLgGidba5kZB95yQo6cFK7R/Xd0cL9u6yAQon63ASfIW0fjQA3+MDl7gRJmi4ak/EMmEp6zw/dt089xNcrmoxApiDbep5eQTyuMVrxTczjLJzbFxKNXAoQJIUDEiCX80ht4cnHeHWIfgIA5fHaxvccxraihzqYgG8IkaiKrblwvb/KQKoqjhTzMGQYu7QkbItGlYaXIKkPjA7HpsTDPDounzdYC1cm9O+3BZUBiye4R+CNUl0JaPzj5mUxl2n+2dv+RcHSmmIVnHHmhulONFbaR+EMwIzvSwqJKNwEnoQshsDDrBQFYHWayR6xTzUW1hm2eDm6WofRNBq1BHCVOJ/iGwikEW4O+ieOsQF9BslaWRdSJ2LbG8Bru9YgV4HEQOEsraQSQa3+48tnz/UyHF0e+oFwmo0YlcDoXVTheuDeYp/S9oqbJ/Wnm5v+spe7j8fg8jZ6EWp391y00QXTgecQwjLznKEHrTm8f5mEJdfoRGNPVB9Kjh96AqT4OJQR4InTSn1Cf/5qEewiJGkndPVr5UiRYjK/JOJhi5/PqdKQ7VInDSOpYq31lYugKluoRMF/PGZzI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199018)(52536014)(7416002)(8936002)(5660300002)(41300700001)(2906002)(7696005)(38100700002)(38070700005)(86362001)(33656002)(82960400001)(122000001)(71200400001)(478600001)(66556008)(76116006)(66476007)(66446008)(64756008)(8676002)(66946007)(966005)(55016003)(4326008)(110136005)(316002)(54906003)(186003)(9686003)(6506007)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mBrrKZ6rSBOEGf3jYIHsn++D/dde502l2ebqy2JN9eizBYawC12hhMj9ng/2?=
 =?us-ascii?Q?rrVL027gggm4jtfZpXTxEh6wMbtmQLB1xEU+hOyHQmBQHvAl0ANR3+7wCnzM?=
 =?us-ascii?Q?mbdGL7BrcPWJGFfj3gL6WwWQ/we8QevIIxPNWEmb+2km2nq3c2ylmy9qLYGG?=
 =?us-ascii?Q?bp4Ll4AZHJx/ALEXQnhCjf0R1oGzHXErFy4rLI8VPdgE3OFdF31sqAazigPZ?=
 =?us-ascii?Q?hm+9DQBU1KM3HYqY3UD5FzxqOydT4ZUl3fnolmMtXcS8WlNgLBtKs1fC9tjQ?=
 =?us-ascii?Q?uXc2JfuLJGTNFdrFYrdAn4bMi87T+NI3akh4ed7rhHUgvdpoFZgp8VssIi3X?=
 =?us-ascii?Q?mQODljfDnJFV2WgEMFKoaa0IU2O1FjM/Iq6bxNwuvN2qWau41u7QSB5vi3CR?=
 =?us-ascii?Q?NCaPWd/xHotNOp5JSYuvAAqUq7/jdtuRSG2O4emqiHIUkO0tTjApVXp6qqGC?=
 =?us-ascii?Q?RqJbKAeOtP21ZFKwEjiomhaEhT6J70pwS1+hnT5Sf5mauy618/iUGdVmwIuJ?=
 =?us-ascii?Q?qxNrJIfee7zLUSs2iAOt6vfMv55XEJZzZgOKPUwWkLKnEpqzzT6R9Ewcq4li?=
 =?us-ascii?Q?jd9XJfKLvakHr0j/g0947MXnId0PiVRxXrPcSTnhAXfe0o4+DMAEoVyUYT9z?=
 =?us-ascii?Q?zj6gTZ3hpmx27OvhV8ie5AHCOZFjqUpQH8oHDqXeMEruvvlmn9ePVsYv/KI2?=
 =?us-ascii?Q?TBwmllXp6jxkN8Gia86YOdI7u4IKQmR7EhJh3cPfWsKCPBnGl0kq/Uxomle8?=
 =?us-ascii?Q?ME15UCKA2mw8Ovi+gnHiyJMBqTD2xobgg/ypbG/ZP4f49lpUDPRF8eDu3hwp?=
 =?us-ascii?Q?jzxpzGFyt0jMyscP9lKqkG6YJ8K5Fg8UvpMqokfWKxqzqzcB8bk2fz5yBk+F?=
 =?us-ascii?Q?sHkDdevyT3YExRVCMDu1pJzVMcjdw1Ci31RrQj8h0W+rPdVojvBpMjkVD16s?=
 =?us-ascii?Q?P3xI8WI/9SYiz7HwWdaEmUtz071cYZ9E/JgJ3qfc5h+99HRkSPjoYnNDjimp?=
 =?us-ascii?Q?lzuI4R9sbypgyhEQrSt/4oI6gfBnhXwvtah5GDdOUhdRJXevLuDiO05CeHGL?=
 =?us-ascii?Q?tWCC1m5UChm6Xh2ZKhBqe6mSt8U8NvXIB7Wzz1aJo5uqjj0mcVI90fFOzT1w?=
 =?us-ascii?Q?mawLuXhtDBF26gb+NyOUkvikyPp1U0x1fQytzZjEDVRNFCzbFDSnHW3TqaHR?=
 =?us-ascii?Q?nfR+JSyN4erUZ+vGlLH0PC8OUTxaP4QBqQkKCqBS87zQHfIXKVdBfjjys/Z6?=
 =?us-ascii?Q?vB5Ds1rvZiVe0GoP6kEs8pevzBYqQyibaemzGrhn5gO1hwCVvIsk232qBE2B?=
 =?us-ascii?Q?Jl6Ix4w12B5NumDTPQZMelqoL09vo6lVV6bDyWCq948IZelk5klchofviof1?=
 =?us-ascii?Q?RqiUVRY+D5CGBC8E3W0z07IEh3tCh++4LLwHVaG/nhtxH/0VvI4Ces1BurcC?=
 =?us-ascii?Q?mGiE162PjxlmgOzpTuqnClq+zmpmCMxxQns9nSCQlbN5hgxPGBSVS4KPKGGL?=
 =?us-ascii?Q?w8qVLnco7qaMx7ZFXpIpl10N2uTkPEs9HAgf3FJOk1MEbKtPMQuik0Ztlm00?=
 =?us-ascii?Q?bmd9S9OGE60u+/l2I1aYH/Be2nqWImbgOXvI/9YK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96c9f3fe-dce1-45ec-c71d-08db25c9abf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 02:53:50.6315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tMBoaBVhiOhj3iYvmQAv4h+9iXrPKepiQLWvATBObYUvPhQyj9SLFVtJyIcjenWIZnkuxJj7WI7TE3cO7c/N7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6923
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Wednesday, March 15, 2023 5:03 PM
>=20
> Hi,
>=20
> On Wed, Mar 15, 2023 at 06:50:53AM +0000, Tian, Kevin wrote:
>=20
> > > So, this preparatory series will add a pair of simple attach()
> > > and detach() APIs. Then the cdev series will add the locking
> > > and the ioas_unpin stuff as a rework of the detach() API.
>=20
> > > I think they can be something mingled... the sample code that
> > > I sent previously could take care of those conditions. But, I
> > > am also thinking a bit that maybe attach() does not need the
> > > locking? I can do a separate replace() function in this case.
> > >
> >
> > w/o locking then you need smp_store_release() and its pair.
> >
> > anyway it's not in perf critical path. Keeping lock for attach
> > is simpler and safe.
>=20
> OK. Basically I followed what Jason suggested by having three
> APIs and combined Kevin's inputs about the difference between
> the attach/replace(). I also updated the replace changes, and
> rebased all nesting (infrastructure, VT-d and SMMU):
> https://github.com/nicolinc/iommufd/commits/wip/iommufd_nesting-
> 03142023
>=20
> The major three changes for those APIs:
> [1] This adds iommufd_access_attach() in this series:
>     "iommufd: Create access in vfio_iommufd_emulated_bind()"
>=20
> https://github.com/nicolinc/iommufd/commit/34fba7509429380f828fb23dcc
> a5ceaeb40e22b5

WARN_ON(!vdev->iommufd_access) in vfio_iommufd_emulated_attach_ioas()

> [2] This adds iommufd_access_detach() in the cdev series:
>     "iommufd/device: Add iommufd_access_detach() API"
>=20
> https://github.com/nicolinc/iommufd/commit/4110522146ca1fc0d5321c04a
> 097e2c9d9e26af4

also add a check if old_ioas exists it must equal to the new_ioas in attach=
.

> [3] This adds iommufd_access_replace() in the replace series:
>     "iommufd: Add iommufd_access_replace() API"
>=20
> https://github.com/nicolinc/iommufd/commit/36507fa9f0f42cf1a5bebe7c9b
> c2bf319b7654a8

lockdep_assert_held(&access->ioas_lock) in iommufd_access_change_pt()

cur_ioas is uninitialized in iommufd_access_change_pt(). Actually we don't
need an extra variable given only one reference to access->ioas.

similarly directly refer to access->ioas in iommufd_access_replace().

>=20
> Please check if they look okay, so that Yi can integrate them
> accordingly to the emulated/cdev series.

this split looks reasonable to me. Go ahead.
