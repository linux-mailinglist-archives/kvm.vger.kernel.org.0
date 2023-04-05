Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20FA6D817D
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238927AbjDEPSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238780AbjDEPSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:18:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132756A79;
        Wed,  5 Apr 2023 08:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680707835; x=1712243835;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RHW40wOiES9/80a7HPFu1sPSnYYm08sDTV9soq9wHIM=;
  b=gD50MGGh/FaZH4HmBva6/Xq49ubPFIulxcHR5Zr+HVFhqWRyGS5lZqNy
   Y5TxSZRJ/5xe10zFQXoe86Ar0Frs56LYVtqgrcSpo4aJLpekXtwvza+rN
   3ChatjsJrPN0Arat5o6e3g2lsDXCjNGJiZ9Ppjr8KHrKS/Xeh8JfEv5zs
   7Viu/sSY5+N8qm9AxKCUGyxYM+DeDZ+wF4bT5H6UyCWtRlI3HCfE/Qhwf
   ZjenJmE55vSkXy6ZjOZ8BlBrvSetDTZgLWTln6WAWAOSICFkBsnbDPJul
   PIOMFLaFW7rYJWZT0ThDEp5l6VD9F3m4fj8qGitWtNHJxldt9kI7xO8YT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="405257734"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="405257734"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 08:17:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="797947860"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="797947860"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 05 Apr 2023 08:17:11 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 08:17:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 08:17:11 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 08:17:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gla4Bm9wFY8anlnzIHyqR3Y5yyjDgcSHfiHLyNPPNdr5836lmwD1shTEIsxRzR4stRXRpLjqtQE7EJJ4gPf5B1q0E05nKb9dcJXIMRC1CYfz4KVmt4caRXT+fLKQ1m8heH7hyqm8p7LJC/vdpDj0REIYnqJAA8e4iNnIMp9QfLjY7QFWy7G6b+Iloh64d0PmjWnKKnGJiFpbuQ5l4MCvVZxFGE7RFEm4V7nbcbWVe23lqJfW5F1BanUEBYmUZNf0IR03gcRMmsDMRwg96hHFWlFQGnPxOvJaCLLCAf3Wgptyl0ZKt8P8n2XDGCm2TrThE+10mkdfTNkmc52/0HNdIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+blkBje7vMyDRxEva38J1KWiPpvKq36eCBDXlf3YG9w=;
 b=jrDie1KS+W3dArb6BIvmoMZ+DUQZp8Y93smlfQYBoLqTHcvUR/bnk4LbN5vGGt7y45FxmoKvNkSeDRoPBIAfnWhJxyg67qf7tFKdN9cKCeo4z30zbaIWcQhNHsmMKGE7P47BjeEalb99DX2Ln/50FQAXhwCGtm6iP5gnIiISyGuOUJr7Jn8K/dE/lsUjWd1yvx5cx2B74pouJFkn5fuzFITCjDOYhE8ajUrxIDW2D9R88nZWKnqDy1F7xnahQW1opEc10mQZcs/hCjpCEUaCW2QyIKrK3I47MLezYlGHG3gy6m/KoNhMaux6451RZURl2zf0gV6vgaV3iTGk/Z0odg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MN0PR11MB6085.namprd11.prod.outlook.com (2603:10b6:208:3cf::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Wed, 5 Apr
 2023 15:17:04 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 15:17:03 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: RE: [PATCH v3 11/12] iommufd: Define IOMMUFD_INVALID_ID in uapi
Thread-Topic: [PATCH v3 11/12] iommufd: Define IOMMUFD_INVALID_ID in uapi
Thread-Index: AQHZZKiCScQNamljh0Wf7fmaPGy2SK8bp64AgADRndCAAF+qAIAAAPHw
Date:   Wed, 5 Apr 2023 15:17:03 +0000
Message-ID: <DS0PR11MB75292976FB48DDC6D2F7F834C3909@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-12-yi.l.liu@intel.com>
        <20230404150034.312fbcac.alex.williamson@redhat.com>
        <DS0PR11MB752985764A642C7B12436C53C3909@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230405091312.6e9dbae0.alex.williamson@redhat.com>
In-Reply-To: <20230405091312.6e9dbae0.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MN0PR11MB6085:EE_
x-ms-office365-filtering-correlation-id: ad45f646-e8fb-4a64-17f7-08db35e8cf69
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wDj2dsykY8vSxs/B2uwVk9Q/nIDkIRfmo7tgePgnvQjs6eNOzmbfEx+hBmenVN9CeoxOIV6/n1snb8fkfO9earEYbMBzQT3UaWshf1eGpOkKFDeCTtrSjwfTqxVU/EjlZhfT2ro2Bvmq7x75nXMA8h6yCBAM7BdckQnR8aBLHZB6rz61g31l4bxc1QrAAWSWd24DwTDOUPKi6Ry0MOkJ19MO7+yWp+q1iozaMRi9F3hNebENr0bBDEM4090P8qwJcT4ADvzVdQPpgws7AVYwytTNSBcRK89BLhH0Wu0oJkngGntcO+rjR0RHbIlq4zIIEYPCOK91GkjUSNlqKv5k4WpYXlqUaY+s+HRVmfRJwHJt5BMO3UpvbYmf9CglWZlxNgehwbzpKMhB5OmtvfErcTHLtYpWl9pEKTHrwB0tAxgsu4qGQ3IKHKdNicwicyzqjrBJdpzmIv8oSFRJly4LD9HswzKLTN1k0624kQRriXzgcSiVU86qzZI1+BsU6PG3IGQeNAdWADsMwBsmmfmPocIpmuWu9KckZ+FohvKT5AgYSxiGBOMDQHYk3aGReVLqGWu8mx9HXb5wmbDxV2MkKQgxKIE/Fp7qhmWGMF7k9bJbJeKqSVr9dLIptUhK62PTK6FkPbtnLn4w+ZpzeYwcZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(346002)(396003)(376002)(39860400002)(451199021)(55016003)(478600001)(4326008)(6916009)(66476007)(8676002)(66446008)(64756008)(316002)(76116006)(66556008)(66946007)(41300700001)(54906003)(8936002)(52536014)(7416002)(122000001)(38100700002)(82960400001)(5660300002)(186003)(9686003)(6506007)(26005)(71200400001)(86362001)(2906002)(33656002)(38070700005)(7696005)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?M7jQZAX6FRKkdeyX3rodzw9T2AE/QJA5C489iZ8Bs6a4Xskld0fLr5UTc2Sf?=
 =?us-ascii?Q?kK4CI9/RATWJgNXl07IJCxHgLMsIN0z1eHQXKT0au1QNpG71avv8HgY7hJWY?=
 =?us-ascii?Q?8EjrsKZxhmJheojZzr8zo0IFZNm/Z4Lw9N4QGJlSOrtAykZKlX1FWOrT+lg8?=
 =?us-ascii?Q?Fq9nV+08asdMHFbawMgs9S4RnPfAl3VxsX6aBZTP+vO68TCjIT+vMaCAhnIg?=
 =?us-ascii?Q?JUuqPzJ/vDyQqx1r9Sr1ZunoXQIBlyrkbEhVtqsyQVeAYuP8HJ8ch7wa0n7Y?=
 =?us-ascii?Q?1ywsOq7QsRiNAtI2gxgIP7ZG+MGCdk1DbnF7210DxraamTHzfYGNhNr7bJ9d?=
 =?us-ascii?Q?a8aLnZzM4bpys9tzynpefqUoqCJ75KvX0PATT4fxFfsd2TaT64KZv5sECW0a?=
 =?us-ascii?Q?5wiL9vRARwm77Efc2u+qrThC3VUxLhW/9r0uulzwz1kiBNKTCUDQhC0/Leup?=
 =?us-ascii?Q?hY3Oy9bmvAKCeCm2rpvd2RNJFFhRBG1Z8QNd65EfZjHwjSOUDzFSo0oIznGL?=
 =?us-ascii?Q?E0/RzbcQ2PaeyNasnlyc+/ZlEJIaLFqiTGHyfYyjp1ssJIjktEWJERsQ9n/a?=
 =?us-ascii?Q?UT+TCjEjnDdfHSiE0YIQD180YVsthnAKGwuSs1i7EFCFOKMeL7FEW7EbINc0?=
 =?us-ascii?Q?umZOpNU7jJ4K6CUFv1Zp1kJBIqyIXkuAybKME7xsa2s67O1FxGA1nKMKTPEB?=
 =?us-ascii?Q?VNw2P8rPYtvB7oVpWnjmgk7aDt3gbFzgkAE4YD1ZkAuF0TdmJegJ0UbbAtnL?=
 =?us-ascii?Q?/YGLKweJfoh3LzGNAHOzTWJ1K9omtPmnHjRvs1X5UKv98O68CsS/i2T0mnrW?=
 =?us-ascii?Q?1xHMvpZfFzRW2X6iqlj6FvzdfrbOJDcFIhcH7ehS9n9r/UyvGM1yP0Nj/3tr?=
 =?us-ascii?Q?eiH9Adpl2UobCGcUqjYiS9W0rHy/Xg3z8b76cFXUTvnVZTeXz8piDNIOx4NT?=
 =?us-ascii?Q?X1KNxx+eIPQhDrrBiFYJ7W2HxMsjvjCgXlxRckh1Mry5LhpkdQ27R9KcE6LS?=
 =?us-ascii?Q?jZkSOHcx3OD2/bx5QZHK5wxaV1ndD40mADocWWP2BMWNIhu7BmHn53KArR4B?=
 =?us-ascii?Q?ZFdrO1CagEQYoWE84xu3im9NBV7F/Bf/d/tkF9uXXi9QaSh5Cad0lVjSxPDH?=
 =?us-ascii?Q?YSt9TvqS5dIxeafuCtdQtXG+V8k0SNhXeJ7QVktgluS4JbJjUfyGoOWe6p61?=
 =?us-ascii?Q?ZfkS/46Udf/FbWvL/BTBMWL0OF7+Sesm+CCF4Kk1YnJ3OKykhHC5YmYVInI/?=
 =?us-ascii?Q?mlZYY4e964x24cZHR9J10eCKEulS2gs/jeccc3+0Zg/5qgcIEgKStJCOJt5G?=
 =?us-ascii?Q?Lge6geOBYM3UO9e6Xm8VruO+dlFXX6q3ug+665HKX16fE0mxLE7o0BwPJWxg?=
 =?us-ascii?Q?d/7ABCwRF3TZbOqguJXESJs/veGV4tjxLTF3i6a7NlCWWZD+u/2YyTZfBRHg?=
 =?us-ascii?Q?/vreqYGYz0yV5JMzKeXgmhX4B250PKtn/a2vn+R+FvKQMQyWakcyC3l2bOpT?=
 =?us-ascii?Q?b4ht+RiBhbj/AXHq5vzMZm+6jOOmMWH4KJ0hpWIU4epIG/24B2dIVTra23I2?=
 =?us-ascii?Q?LvnpztGLCnu04BB4Kbi2hpo1nZF2Aqh+Ag/ISlyX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad45f646-e8fb-4a64-17f7-08db35e8cf69
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 15:17:03.0843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Au3ex0uppA6YAZAHsLN36kfYFUfYkJYMq789Vt0ciw2ccHRLseWQCnJKQjQbkUxCxGytKlCJ4KbrUHgJw30/PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6085
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, April 5, 2023 11:13 PM
>=20
> On Wed, 5 Apr 2023 09:31:39 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Wednesday, April 5, 2023 5:01 AM
> > >
> > > On Sat,  1 Apr 2023 07:44:28 -0700
> > > Yi Liu <yi.l.liu@intel.com> wrote:
> > >
> > > > as there are IOMMUFD users that want to know check if an ID generat=
ed
> > > > by IOMMUFD is valid or not. e.g. vfio-pci optionaly returns invalid
> > > > dev_id to user in the VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl. Use=
r
> > > > needs to check if the ID is valid or not.
> > > >
> > > > IOMMUFD_INVALID_ID is defined as 0 since the IDs generated by IOMMU=
FD
> > > > starts from 0.
> > > >
> > > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > > ---
> > > >  include/uapi/linux/iommufd.h | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iomm=
ufd.h
> > > > index 98ebba80cfa1..aeae73a93833 100644
> > > > --- a/include/uapi/linux/iommufd.h
> > > > +++ b/include/uapi/linux/iommufd.h
> > > > @@ -9,6 +9,9 @@
> > > >
> > > >  #define IOMMUFD_TYPE (';')
> > > >
> > > > +/* IDs allocated by IOMMUFD starts from 0 */
> > > > +#define IOMMUFD_INVALID_ID 0
> > > > +
> > > >  /**
> > > >   * DOC: General ioctl format
> > > >   *
> > >
> > > If allocation "starts from 0" then 0 is a valid id, no?  Does allocat=
ion
> > > start from 1, ie. skip 0?  Thanks,
> >
> > yes, it starts from 1, that's why we can use 0 as invalid id.
>=20
> So the comment is wrong, correct?

yes.

Regards
Yi Liu

