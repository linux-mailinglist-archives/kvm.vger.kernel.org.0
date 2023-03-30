Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6866CF87A
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 03:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjC3BKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 21:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjC3BKQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 21:10:16 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF814EF1;
        Wed, 29 Mar 2023 18:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680138615; x=1711674615;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fL5ddEXyKnr2OCANZAdI14G2NmaZfc+AZzn4MFXtYfQ=;
  b=XatHS4NHBsOl03nGK//4aPY0dTkXJ9GF96W0D1u4JruFU64ULBrMtbf0
   6BX6E6sej8JOrP8aygFrlhXPApAx95a3oU9qAmKtqRubIdckDJkiCCeJH
   wBjcyb4vqhh6EuUHEbfnk6n/qcsMPG8pfpsMACWUPCU8dIIaEY9P9A88D
   hr0eA0pz3aQx3tKwDXiZX4W1EL7gSwU4+7MKSFQfU+vCz+RPWIq7qOTeu
   wcd76/sMderqdFLs5/hioWQTrtejN3auN5CffCLLktORMHGisNuPXY8ei
   OUhTRWhsoGiO68a7b/aLWqK9MvCTOLti3fwfin23ZzfMAlMTpCwDsuAwA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="405994685"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="405994685"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 18:10:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="858713101"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="858713101"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 29 Mar 2023 18:10:13 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 18:10:13 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 29 Mar 2023 18:10:13 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 29 Mar 2023 18:10:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXARKTrpHGUKmn9I+OzfNBmBEU7Rva8vRAXO3TcVuiV2WfGR+GvPtAI6hhqVe9Ptr3+lhG4FdF0Gbrg6d+6QO9dKa1oDMJqq6mqPq11AmQO7TBdfmYrp5rpnsWAaAjo0ManX7ba1CIrz1fsEOoueNSNjNkQ4DUgakn08Y33NpnHAvXc1DluqJ2atL+xEC5/qDE+4D1zQELi2Gl3MGj6XHD4fBBI74roPnxfNiZszgUeQohydYE8GnsjJGOOBMh7pGQBF2k3gFHQYKkF+3z+QF78KLzE5R5LEYuOmHKVKthUQszVQIFkS1MKTlKK3kkmTkiyI534hRkmYVSwCX8dGvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fL5ddEXyKnr2OCANZAdI14G2NmaZfc+AZzn4MFXtYfQ=;
 b=TASJWXBYqSG6A67b3j7JxIZIVU70jiQFI1orpqqmOZlxuN61wevmEPSa/IY6arWAsabzfvp0j222obry4Ph0hCYj9aXjJgJbzQVOOQNg1lagey+Zke8xBw9GKHhWiNgJJahVmoFhRrZnyCgoqfBtTKbS5fg/uZ+J/jDTodp2gIhDj92pW7Vxd4T50sp3ZA9ZdUeo3R15lmOf4zOla47EyhC1b3hj+TiVZl/ZXif8xbArG16Pf0QhHPlt+3Qw2x5H8pxBZuQGt4geWPIfHlt1jhRQUEIas1sYoPVkX70Gvl4ivcn7vtask2FBhZ1GvYtYxyXOieeFD90+Omwg7hDQXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB5770.namprd11.prod.outlook.com (2603:10b6:a03:421::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 01:10:09 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%7]) with mapi id 15.20.6222.033; Thu, 30 Mar 2023
 01:10:09 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Topic: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Thread-Index: AQHZYI92YoejP8gsuUepwiqB47+8d68PAuSAgACHvgCAAC35QIAAiJkAgAADhQCAAAJBAIAABAgAgAAE14CAAAe3AIAABCSAgAC8HoCAAGkTAIAAak2AgACbrXA=
Date:   Thu, 30 Mar 2023 01:10:08 +0000
Message-ID: <BN9PR11MB527652CC7ABD6AE2908A9A1F8C8E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <BL1PR11MB52717FB9E6D5C10BF4B7DA0A8C889@BL1PR11MB5271.namprd11.prod.outlook.com>
 <20230328082536.5400da67.alex.williamson@redhat.com>
 <DS0PR11MB7529B6782565BE8489D922F9C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328084616.3361a293.alex.williamson@redhat.com>
 <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328091801.13de042a.alex.williamson@redhat.com>
 <DS0PR11MB752903CE3D5906FE21146364C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328100027.3b843b91.alex.williamson@redhat.com>
 <DS0PR11MB7529C12E086DAB619FF9AFF0C3899@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB52762E789B9C1D8021F54ECC8C899@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZCReOXsLsuS/J8TC@nvidia.com>
In-Reply-To: <ZCReOXsLsuS/J8TC@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB5770:EE_
x-ms-office365-filtering-correlation-id: 8838578e-9ae9-42e5-8a90-08db30bb8154
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RYAI3Rqjl9LtmmQTgT2bhSO3WniYg8dl3MsVkiZnQdA+fBqjySodIPZdA3WNXPao9HPZaf7iQQXqesjT/Ap0IbwmBOmo2aCLLWIn4Ng8oV5Xmt2ml3U1ESP82cJIeliSmhggUUkwU4lZYuQQXNIxKAdEKam9ggnE9k7SqXCHCgaUVFgy2NreiTdkwtKv2oshQWFrci1aC5cp1w3PdRd4fy6XdnYUaac2vjEW0EMut47wIqBaV0eKvjq2tVPYZiapCY1BFZh2E3Wt5KncyLKQbAQQwolAn8IGQ260G5Y5pIcwIsyrOFT8qOgFiYrs6F96aBaL38VWbDEg2cZ++IgpFiER2JqHqUpWnKViKCHl+/DJm1odfars9V8UtOmGDwP7Tmd2S1TCGQLmjNFyz+GwMAcuv1UaBbw+ueH5VEljJNj1mEZ8AqhCyliZ3EnALyo7oD69hdOPmuDUgLqc28wOWuEMDz8t5UWAn53pB1Ded3onlA+MQlwjjTmYAhf8lmuoJMyHdyf7E6ufuKH1/mi89ng1s/Uw301XKEbXcw8Qcjg/LKoq6sq5LJXu/iuJ5wGdN/ol65ArWO5N3oRdX6KLhir+N+phAv0ZoHqTq2PZ4ovvz6DbeMY2pYIsb7un6PP4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199021)(4744005)(2906002)(41300700001)(316002)(66556008)(71200400001)(7416002)(52536014)(8936002)(54906003)(4326008)(66446008)(64756008)(8676002)(66476007)(6916009)(55016003)(7696005)(66946007)(478600001)(76116006)(33656002)(122000001)(186003)(86362001)(82960400001)(9686003)(6506007)(26005)(5660300002)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?k5vcmQ3QAcGo7X3v8ZqR73tF2gZKlAXxPnQglfhQjgWwZNWSYsAClFZhUasA?=
 =?us-ascii?Q?QQtlplLWrVo3sVG1fQvZB+akWlatESHdWTaj9BVNIj42WC+nckDBgsohSWQ2?=
 =?us-ascii?Q?CwqtSL0OeVnRe1zfWJ8O7nQR89mqIFxKj+TRzUmHaiCfUOANIvaSc2GwEZXt?=
 =?us-ascii?Q?MQQZKASqBuoMvi5/OT+dUHr1BCiuk5467GkoUtsDMJU8KpkxM0R9KFPT3ahQ?=
 =?us-ascii?Q?aiqSuGgppRi72jTMdNXRuDeOWt3EiSSNPabvmew8JP2QTmGYyF6JUA+aK5QC?=
 =?us-ascii?Q?PoU85KdP7V6AtWCuhLY0BEouP2LHMZAbArS6v24xmg4aKtGxgq73b5WpS5LE?=
 =?us-ascii?Q?audksxj9vrkOwVNTZe6ZAC/GvhDvaFoancYzGSsY4cij7tOj4pH0HlPC2u1Q?=
 =?us-ascii?Q?ZEmr1LjjkQSSqjdj6KCQwuYOL+6qhZgX7Br9BZH2Zvgrc78tTQPct240STJx?=
 =?us-ascii?Q?GqEOuR7FLamo3oODTAbKyy8TJwLrJmX776QcgguocRHSlEV3NYad6CeHO3H3?=
 =?us-ascii?Q?pSdDEM3jZMGF3/zkl3FMss/2kqoFfErQQAUvHI8QaDDVQgAiDHNmG1ozoLd2?=
 =?us-ascii?Q?iW21hx/LruRep71EAEj63eciod8mw4BjdqEFPsbUYk3vQGBRKmflV9DQyu0d?=
 =?us-ascii?Q?Xfxd5sAKCzJfcBiSHJnPeyR98G5zg18VfB9p5ptreWRNU0HN64xxciuosc9b?=
 =?us-ascii?Q?BXMnGTkNMmG7ZXYSGj7m+2wlYejYDpc7g7jbIcS4HjrMG2LO8AOw0LOcEdaE?=
 =?us-ascii?Q?XZh30VzKTQnraFCzyIPuEpaGq7yW0ufIqtCZ0ZCd85t8/YsRIHiraGRWQGX3?=
 =?us-ascii?Q?BgNGn1yBYvnqF5/LLDRtRugETK0yu/pN5AV5MGATctAF1mKDU+yVzjOsF8Yo?=
 =?us-ascii?Q?3Q7CS9Yz7mVwrJ8QxupIs3ZQkaXNf5U3qiYneWRa8TXzU+3jkwFDo25/zgbk?=
 =?us-ascii?Q?9GX0ypf67OThXoZGuBR6zl3T4nim5olsW9SnCqck/mKBOtApC/4gMD0E71P/?=
 =?us-ascii?Q?KAbAnwBeDlfoiO6ICfScdUH3PAGZyaIBKz8rcClqVO0V7wDhWfWY8GQy/NO7?=
 =?us-ascii?Q?LjqiY5/Uau+jNw3zqxoDhjhDEEc+dQGgm+OljFEOitNAjLU1YyR4Crn6PYbC?=
 =?us-ascii?Q?VSrNeGCkmia5TkZHK3W+qeeZCtj6kOTjuIQRIdAwbKJ+Uz+8Q2b7uTP8BOes?=
 =?us-ascii?Q?kFKGBNJaU6XkECDeq2OxhCHBaU9hyCV4RfJTNeZcEeWbswMNlbXYxgLZlU9b?=
 =?us-ascii?Q?Y8PB3U14YBzOlGxPTlGD9USL+X4TtBuaWktgMMaRGBjK67W+LFmDoJVR81u0?=
 =?us-ascii?Q?zUYohk+WNYtTMvqOCSoF5cT8JXa14WPHORsOUiaa4gyk3ODtaGMhs0VSTlxK?=
 =?us-ascii?Q?w2lbPZZ3rpeGWWDKa2xhFdjItMhI9fcrQuFq57eOsHEJaxnqNLlw3mA6Ekw8?=
 =?us-ascii?Q?nFgdzcBC3483IBCIa4Ix1/VSri95mtIF//QQ3eViT7g/D7jrwc3bL45yeN4Z?=
 =?us-ascii?Q?BryYcM+dNfroQhLsV3/rnnllR1IHzKPPnc083zn5mn7odeNvznAldpgsKjQ6?=
 =?us-ascii?Q?pHIT8VQXl7/I2lA5+iU5FdMY2/Z2MieluSaBDfN5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8838578e-9ae9-42e5-8a90-08db30bb8154
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 01:10:08.9681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Od0bT8FE8R0UVDzaeL4z4acxu8aMM6sXi8NcIk76abyMNyoYKMuE85LmDhci8itC0xJlrsl6EYcYbhtNTyvYMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5770
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 29, 2023 11:50 PM
>=20
> On Wed, Mar 29, 2023 at 09:41:26AM +0000, Tian, Kevin wrote:
>=20
> > We could extend bind_iommufd to return the group id or introduce a
> > new ioctl to query it per dev_id.
>=20
> > Once that is in place looks we don't need a new _INFO ioctl?
>=20
> The iommu_group and the reset group are different things
>=20
> The issue is processing the BDF strings, not the group ID.
>=20
> Probably we should have some way for iommufd to report the group_id
> from the dev_id?
>=20

Yes, that is my thought. Though iommu_group and reset group are
different things we could still leverage existing _INFO ioctl once there
is a way to associated dev_id to group_id.
