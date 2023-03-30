Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 669FE6CF8A3
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 03:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjC3BRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 21:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjC3BRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 21:17:10 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5473719A;
        Wed, 29 Mar 2023 18:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680139028; x=1711675028;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CSMsv6d+j359cZ42Uke0nyQllxMyVJHoVlSEr+EewLM=;
  b=BdikFIQt45XoAywZHJ7dPirEA41Yc4Zgiv6xdvvT+QghokTk37TCeRYh
   qv9eWCCz64fkRPIfgbCJYWNFx29m9fchnVTBi0PXmpgrnIPA0bn+YpS1F
   bCGrPANUhjgIZ22IUg0kqh3H6pXtffIb41lJA0gaWCB4UUQZeMYPXviEg
   yLgNFI9YNdg04tU9NoXIkJYff8OUvzRZ3Oa2KODJ84f9YjLLY7PLtMEIU
   WXsv2Z+kymJW3om1syKI5ZsBf/Duv5uxzlktggtpQ8XS3CwATYk/4aJ5L
   OjQeLEtpLdQSbESnw4F0ryJrXRf2xRIgwQ2FkkbbLtxmMmbmoK+EDseDQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="324961629"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="324961629"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 18:17:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="753803766"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="753803766"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 29 Mar 2023 18:17:06 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 18:17:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 29 Mar 2023 18:17:06 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 29 Mar 2023 18:17:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUfzENxA+s96ezFMmz3itvSuMorREBGJIV9iYLm4gphOIHgI87Z7j1h5R2Heb3mq1mXVMECDjlEAIYeOW/Fl/IixWPNy/z2VOTfmDJZ2ep0FRXgtt/JaUUbobOjnEdoFqvOIwxl+YoHj5Resw6ByRbsUZZmuhdR2N0i0vpxhWp8mrX2i+Zk7Gzw5HsidlAQFenuu72pyvJo3Wmn4QbqPFjM2KGrt7S8u2s6M9bCe+WGNkcN9fgxtSEKek++QLTNW9PWDvx+LeT22qt1RG5PfRh+x5Uer0sp9uMx5VLECCtuTvLrsXlIXkcCRG6QXSYVIpXGCQK2U5Nw1A6PQIu8M7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CSMsv6d+j359cZ42Uke0nyQllxMyVJHoVlSEr+EewLM=;
 b=GI/YfdCxqUE5RGhZbFdMULyVx0RKHeA9SWgPQf5U/Wsx7IYfwca4ImuDxFh83WYU1LCZsBAYKjNHC71cBbIDC+iJhpfhaea4bmVmA6dT7RbN6IV9aw+za9p/jMalrPqkwJcu93Va/gGdovKqLjqmuWCq/lO0B/JJP8t6Y/BFctvm4GUss4EqABUkeJD4BXt7RkEonDrJFa2gUgafpcA4QK7k05G1rq7UnloUsYRAeVTkqiSqGhs+4dRDX6LleZJoc/z32f7jlPF9q+QsmfLv1tUVG10HpSrrylqr8erN5eBkAbfIKPzH11cTBIzNzSDO9xHQRJ5Zmabwy4yw654OKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB7691.namprd11.prod.outlook.com (2603:10b6:8:e4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 01:17:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%7]) with mapi id 15.20.6222.033; Thu, 30 Mar 2023
 01:17:04 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
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
Thread-Index: AQHZYI92YoejP8gsuUepwiqB47+8d68PAuSAgACHvgCAAC35QIAAiJkAgAADhQCAAAJBAIAABAgAgAAE14CAAAe3AIAABCSAgAC8HoCAAGkTAIAAaiUAgAACPACAAJpaoA==
Date:   Thu, 30 Mar 2023 01:17:03 +0000
Message-ID: <BN9PR11MB52762D26CF9BC68F5738AA438C8E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230328082536.5400da67.alex.williamson@redhat.com>
 <DS0PR11MB7529B6782565BE8489D922F9C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328084616.3361a293.alex.williamson@redhat.com>
 <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328091801.13de042a.alex.williamson@redhat.com>
 <DS0PR11MB752903CE3D5906FE21146364C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328100027.3b843b91.alex.williamson@redhat.com>
 <DS0PR11MB7529C12E086DAB619FF9AFF0C3899@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB52762E789B9C1D8021F54ECC8C899@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230329094944.50abde4e.alex.williamson@redhat.com>
 <ZCRf+OdpBVnw5ntC@nvidia.com>
In-Reply-To: <ZCRf+OdpBVnw5ntC@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS7PR11MB7691:EE_
x-ms-office365-filtering-correlation-id: f902c124-8e98-45a8-22ad-08db30bc78a7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WpyAS1Sn47UH2O3G0mdxOxO0Q/ewQ6Uv2FDoY+bvI6ovOhX43498X2djJNZ+nifp/Qv2d4GEtNCOGRyPQIupgnuD0t3mCMqBoEnRipyaki9BX0x7QKmV1bteyV64sCk5LfIlPld5QTaRo6B94vuuUmbmNuIcC/KsqPtpHlj82jyGuxnyUg/JRH776D4KhKMj6e4KkpahwA/0DapN+6Cu0Vr5t0RthFr9NFg0zm1Xl4P5Idix4YeceS7mG3KZw/TKxmQ3ZsG+17+BMzCFn3QeuMvDMYv4pG+4SiBwFy4SpDRK0gntJkB8EgX9hOPUS55L/DNbcL2dh6rYfKqvzouMAqO6nDoal3GtHQ/6pQr0K/vdMls/t7iFTCD5eDLXkOKaMj+RQROA1BpfVN+8wCXzSMHwWdc12P+UyBKlWcleCJTiWY0cFjExSmpu6NIO4QCZJjaj1G3+h1ewAOquRMaWi35xGJjAnODsA8vH+DsdSY4f/Awm6DcoOzGUsboWgmaRFIl9Z2vbJe+7mLbZh4Xtz7rVPckLiSZvkF+XgnEgYeuqEy10ZqakhiRRVv2g1rMlOu5w5VhwXruYxywmsqxXKc+IzoYTJRGQfL0tHaHNiGxJD5N3dYp3Js8Hvf6Dq8l+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199021)(26005)(6506007)(9686003)(186003)(82960400001)(122000001)(38100700002)(38070700005)(86362001)(5660300002)(41300700001)(71200400001)(8936002)(66446008)(52536014)(7416002)(478600001)(54906003)(110136005)(7696005)(33656002)(66946007)(55016003)(76116006)(66556008)(66476007)(8676002)(64756008)(4326008)(316002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kC0UE0Ry3w1WB/Ht/n8YvaClu96ymkdvArqbO1BrgmMxBESxmvcUwRmK/dxl?=
 =?us-ascii?Q?zlEneKWd7Tx0HA8IogghDrj3WeS62wM692x86c0D6VuLLRrEYNnhSDYGn8Qn?=
 =?us-ascii?Q?lUcIeg82mLTthLlYVWmz6eTu1Fuxc45opzXgawpXujxZmS0bRT0mW50ZpHQh?=
 =?us-ascii?Q?K/aJhG6tia0FkEn6Bxgms4zMU4rnsZZP9tT+YI4t6D9xyRDFVWjYC6JO4w1T?=
 =?us-ascii?Q?UES4kn4lxnMXhMkc2AIdG9dzzoLhl4iuXIziGJSvu7ARhIIykRivmNzzr0tZ?=
 =?us-ascii?Q?776ivVLfZdo4z04HPRFRkGkdlt/a844PVZfpPjX8ZEfJSetzP97bnNj8OP8J?=
 =?us-ascii?Q?V6GwMgdrI7n1RBx+PUtiQvluA9kTimUJRHCgm+jzrVKHp3kIW5RXxjLUcZc9?=
 =?us-ascii?Q?08ZM7PArxchS/tellAmZzJgsnn7TiD4GAkRecWlmV6zxHUIY5I8+tD7n9RzL?=
 =?us-ascii?Q?JPbvojymAoEjcqAk79YvWRUSOntH6qTaBrUHu8eNzCkViJpm4q72ko9u6Fjf?=
 =?us-ascii?Q?QzfO27vPn2rcDWVw1RZRXA4neVfFjRAYBPSI8rNvhUYT1Wm/SnPxk6+UlJsO?=
 =?us-ascii?Q?mNX2Jov/FrZ89PjSxiqHzS0j191JFn8cG5vR4J8nd+aM+o097wq8K7Q0mo13?=
 =?us-ascii?Q?9+bTTIvg1ybhpmvmLeZVVo5eTxCRyIU0t02qJgUGzrkbq9nKgmBoSzB6TFWH?=
 =?us-ascii?Q?Yg1hwPIsUphRkCcRDam+Ffm2FxzXhVsZ4pzI49DJtJJauqNuuobnhECFCcv7?=
 =?us-ascii?Q?zmtbr5XzdyHjOmngP4pxqd9m8ZJHXMAr/3Gh+7gqpI4u2FzuI36iGg6ey7+s?=
 =?us-ascii?Q?we6fgp4lTBQsSmV45HwWqSR3Hy2TYtKBPrEZWNiI2Yt6ctLC6gfvXygse3s/?=
 =?us-ascii?Q?kgi8gRtuGfqRnidj3NMdvlDpf+QeD2Nkb3I//OzVRp7irghc2K3T5zRZJSX1?=
 =?us-ascii?Q?cSn1oOc4hHn0EKYdxTj7jY1nXdOtfBAJ6RAkYbBlV2q9HkUEtqqhC1Qahi/a?=
 =?us-ascii?Q?uwyoxDFMPbr8WViRpwzPs9BrC/LxKkFJzqlUmCuwOS+0sS0xnMvY2HeG/S1d?=
 =?us-ascii?Q?ciLFx7DK+dMAbI9XkbOWxGpO9JqOmiPsPpZaCzfpojmY+5QO2JvgJMJfhVlK?=
 =?us-ascii?Q?GaYYGlxoqDimdrVN5uKtAQkuSkt1PWrnLIRDGPBA/DAQ+E7jYbWTbubhP9HB?=
 =?us-ascii?Q?pQ53BzsPXKifP7Xb19WBmav0wyM/pMt+1hwL4Y2f+jftpBeXAkA8Dc2EaAXH?=
 =?us-ascii?Q?MOr9inta2eWZcMo0M+UnBhWayPqCkeUGX524bacQdQxl0Qco0zChsVvIRuvC?=
 =?us-ascii?Q?wRPzNsAV6STd/+7OxHnv8hZZz+4/IzMtrle8fFVAzwVTQpFlacLnW0ksqVXL?=
 =?us-ascii?Q?Le12XSKUgN+9to21IjfXFqcdoePn8SUG1WQk+XgiFoMQSYJ8e9Xdt2AGVbTc?=
 =?us-ascii?Q?KCy5MMORFn9N5dAE4uf01HiKZbnIQlsDnkAzd+VTJWfBJDyyQd1b7SuOexZz?=
 =?us-ascii?Q?4SvWHuim91J0stTRc9K8ZWPZLaZkqa3S13dh5wJvLoFi3i6nY0b6z9YrRs7o?=
 =?us-ascii?Q?N1A2lbSnSIy1/ihfTnkfNNypd6GX+ATNSgeJeygO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f902c124-8e98-45a8-22ad-08db30bc78a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 01:17:03.8927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5elbtxpCnVxx1CL24xD51pDIbhD9Ldax+PKT+kG6aiwwuP+s5JjhR928njJYkn03G7BG9sMbMq3HHFfx4CdxUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7691
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 29, 2023 11:58 PM
>=20
> On Wed, Mar 29, 2023 at 09:49:44AM -0600, Alex Williamson wrote:
>=20
> > > We could extend bind_iommufd to return the group id or introduce a
> > > new ioctl to query it per dev_id.
> >
> > That would be ironic to go to all this trouble to remove groups from
> > the API only to have them show up here.
>=20
> Groups always had to be part of the API for advanced cases like qemu -
> the point was to make them a small side bit of information not front
> and center in control of everything.

Agree.

>=20
> > For example, devices within a group cannot be bound to separate
> > iommufds due to lack of isolation, which is handled via DMA ownership,
> > but barring DMA aliasing issues, due to conventional PCI buses or
> > quirks, cdev could allow devices within the same group to be managed by
> > separate IOAS's.
>=20
> Maybe some future kernel could do this, the API allows it at least..
>=20
> > So the group information really isn't enough for
> > userspace to infer address space restrictions with cdev anyway.
> >
> > Therefore aren't we expecting this to be denied at attach_ioas() and
> > QEMU shouldn't be making these sorts of assumptions for cdev anyway?
>=20
> I guess we could make an API specifically to report same-iommu_domina
> information?
>=20
> I was assuming qemu would use the group for now as I don't see a
> likely future when we would relax that restriction.. So I was keeping
> a "add it when we need it" attitude here.
>=20

IIRC we discussed this subgroup concept in the thread of reviewing my
high level design proposal 2yrs ago. The consensus at the moment was
that subgroup is architecturally allowed w/o DMA aliasing issues but
we're yet to see a real demand of relaxing current group restriction to
support it. Also with time moving newer platforms should have less
multi-devices group so the need of subgroup is further decreased.

So I'm also inclined to laying the existing group restriction with cdev
for now.

Then can we make a decision how this group_id might be reported?

In nesting series we'll have a GET_INFO ioctl per dev_id. It could be
extended to report group_id too.

Or alternatively just return it in BIND_IOMMUFD together with dev_id.
