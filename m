Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B6F6BC0F2
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 00:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjCOXbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 19:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjCOXb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 19:31:29 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596B59015;
        Wed, 15 Mar 2023 16:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678923088; x=1710459088;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jAPoWJrg9onWifmf23Pn28gMQ5muOjzc8eNn/zI0Sq8=;
  b=Sekwk898pNFrufdXTE0y1l0JR+T93XLtN5kB71I2gwnf/UeMA8kAIl2h
   U5Fhf7HtrnoV85H/K5uEGiK0ajQKOERn41WUCwCIomTnLEPsCQIhRv7g9
   UlAqZ7N57K67FhOP43/U6M58e4gvZVlDuR34RGPP3jnEIDRlXMj32SQDd
   bBQbtIK3vwzZrHr29BvMPWwXuyGFUH5Un7pZahTAhjXZsZXhzUvFRk2Rj
   JZ3cSje027kUQyNRNXDd/DZ4oUVJ6HqojyNSiJXro8L+QUzc9nD/OnhA7
   C3DMyGvolccd65orJ8qsLpTzQ2zULcDYQL4qsQQLj07FuBn72WuwTGgyf
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="318238245"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="318238245"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 16:31:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="853788476"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="853788476"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 15 Mar 2023 16:31:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 16:31:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 16:31:26 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 16:31:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqY0eEV0C0bvdyjh4e5yCKbhwxlwSY+n7+Poyhz17rbGGQY/1BEyfQ6yUOSUaaoPFmPn1wBZ7zuHmHsd+SpkpmHhzZVWcSQkLsY544/sRQbolEq1zApSG0pIyNEfC+ZhF78k3NoNmDBgN8quvja6ww2TcercV4BP4QEP9GyIcUPGiM72qkAdzQQTXyZgxIWGyhsJWfV4fTOyUJKgSURZTG+VlZ4jt1TbE2kEmlG+2BD4xsBWGl77ULDIm92raclvcn2VH7ZMtbZe3CsGFgFk8cPUMxTqYt/h/8LOpdCTD/+zJwC6udzn4QuEMuDfcRLiro7fdo134yejSg6plXTNKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BjnCdd1Qrrk1oNNwJkuQOPtcwm7b9hO/uB2KDaOEURc=;
 b=bOVGqKN4pzYukOoKMdUgVsnqJtzlne2r3vxinnKboSY1GsqpTVyaNYrjXZ+g2OlqhKWWTzzy05nrM6xdV8TuVi7/RuM28weXcFabO1aMBY8YsYIgn9HIwiBRyG0pATdaFSmijf7Ffi4+PlFB+9I9jbjdZ5HMivlEzqNi7G2Zl6IlTcW8Y/07beswJ6Vit2usN3rCmFUK3HVcPF3JJorUJOTQkktzFtZ7M74OlUvl6yH4jxf8MEPi9KG8OrmFzfKqNEw943IFffUjLZ4y5aXgXOC9jls1vvITM4YdDa21fwlrOEMwAd5NNWC09RRFcayywTfArE6bdXregWDSBGJkKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5403.namprd11.prod.outlook.com (2603:10b6:408:11c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Wed, 15 Mar
 2023 23:31:24 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 23:31:24 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
Subject: RE: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZUcIISo3Z1SbL8EmJASujVt/DZK78flGAgAAE67A=
Date:   Wed, 15 Mar 2023 23:31:23 +0000
Message-ID: <BN9PR11MB5276300FCAAF8BF7B4E03BA48CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
        <20230308132903.465159-13-yi.l.liu@intel.com>
 <20230315165311.01f32bfe.alex.williamson@redhat.com>
In-Reply-To: <20230315165311.01f32bfe.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BN9PR11MB5403:EE_
x-ms-office365-filtering-correlation-id: 06418d4a-a7f5-4444-dc44-08db25ad63d3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L6UAJxPWcPGuoE4YwiSk2EnklfEeJItMgAIEtOahBV52cOLIGTJfJkhZ7mY4P7tmyt7EUA1uvcQVPjUw84olDkv+6IXPf7zBRVdzqmo7GZcrCR/cdSpQSLnwRtuIOvMiU6BLyabw7WJcoPJfZjpwqk9F2+dR0wJnCS5wtVExy453v6H0GiH+GCGJYAe511H2nrfhSIV+Y4UnfMVvlz7JnRnaGJ8bk0XsSJzAgehG2wqxxwl/CHPUtoIJKRS5iJkkXd0/4vSwT67FlpGjuYkUuYB1MZAh7m/O1lR11G7xGR7BFUC1I0L3fcFTvRKLMTSedPNWUpi3ConDL/kwpDy/2PIWSASM+M32yItfgV59QRkZf3yqwwiXlri5rk/FF/ffU1Lbh1up1wNjyOThJfPlUn2XP42B1Gvb4+VP4bU4Om3z2jXz54QFtOnuMPukD/E/uykAsO5XzN0mB8rx4lJL7UlK1n7XEov3WeFcRpkJuYfl4XdiqWeKhO2JK9QDKxaKdCqeP6BQXokYJ5wgOQzpCQ0jUUMFOsABURxpaIiSfpTnDVyqKAGNEZxz1AqDmnbzMN2pPfCYzN31uphelwDFnYRqYD+t/d7SBwPlsJmbQQjRrbR2oWNVkbapFQbRuXwGaQZzHjI6aOxxoeuwWx0TiK6nqdhza6j6PJbig0JQlYacbyQ9G/TXXt/ZaZ48YRUPzXAzwqReOpS4ac0ZD7QZlw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199018)(5660300002)(7416002)(2906002)(33656002)(66446008)(54906003)(186003)(6636002)(9686003)(478600001)(71200400001)(7696005)(26005)(6506007)(83380400001)(66476007)(76116006)(66556008)(66946007)(64756008)(86362001)(52536014)(38070700005)(8936002)(41300700001)(4326008)(8676002)(55016003)(316002)(110136005)(38100700002)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gjQXyAymNd+FJoAxjPr8vTiaXV3BK/S38Hvh0Wil1RZVfnX8EtCsFubFmSiZ?=
 =?us-ascii?Q?GWETXh74vDBanMexjk3crQq0zxaU5yRighFivIsdryYKK61GG06P89aZl4Vm?=
 =?us-ascii?Q?+eRy+zkjTKupIJmdt4o6kh0Vjov7oiNzcbfmA+mfAZOXPde69waj66t9lJmI?=
 =?us-ascii?Q?2p7m4L7CEsRBTRqo3CspXxXQu9bDur1/vHk5/9hyf1yfPs6Z/tqrJAT3mbWl?=
 =?us-ascii?Q?m5Lu+yp/tAIRoDHH27ZCyj15McoPjOHgNqDBuYKN7j+2vrB0KgqlQVT6ifix?=
 =?us-ascii?Q?LQGi97szIlm5opJdIAOfKpPTeTHKE7qrYs7b8CVIW6Gx55hDg9TH0pe8NQJW?=
 =?us-ascii?Q?oqVAaUehbvdIF8glAHXZimkOUW4F/X4+oS3W7MWMXSK869AzrYfcTIUdEdQW?=
 =?us-ascii?Q?ks9Rv2zHWDRlXJsGJ2fvdomxufEepeJVIyqNYKvab6nr3cZIrSQXUbmE+d9v?=
 =?us-ascii?Q?FnCf6imfNyahOJRO1o2JQ+5Evk1thtctMPIn235ewO7IhA1Xr3E0MwK4BDLs?=
 =?us-ascii?Q?8hoyaX6NrilJofGtyFkmRDlq4s14yGClZsBNQMMUKdmhIu4W+nh2tTNCw6c3?=
 =?us-ascii?Q?qrNlFK6goetLLCgE6ZGQAhuhXEdHJ+0JnVJxybJip+yJgk7otYw4Lx/Kbysm?=
 =?us-ascii?Q?h2HT6+ybc/FWXYY+0J4pOs0cQrz+fZk49qQrqf5uOSJ/kosRi8r/iIx7icn8?=
 =?us-ascii?Q?yGJjd+b48vvq7q4w9Osv5B0nFvmBC46Dph8mddKy5Rk7RmjK4of5Bowcj/L/?=
 =?us-ascii?Q?yBT2PB89RRnjQ9eQhNo3GIBbJccWYX/igfVr2sxtSYqYpMrK4GR/bqG16nNK?=
 =?us-ascii?Q?EO/jFzwWEuEi2jis2MNunry5rK4038ibZDEDlylyeQP0EOPClf5LHqrUIcXt?=
 =?us-ascii?Q?Aa6qbWWrJUHS90FP7/aYb9+7cuBwHxvADukekfpe0BsGy8Wv9PFZTpV2wjZU?=
 =?us-ascii?Q?0YZME9zwl+hfmq+k1dW8Lvp4ALLyIiBPA3BOvuhMf/e0YnJQ3HbevTAWWeSf?=
 =?us-ascii?Q?NsyFAQYBuWygG36xZ/DebxEjgrZwTfMVaApc+SxwMayrWSAHWmn4JKe1OUu+?=
 =?us-ascii?Q?9lOXWIYpg7UZ1qFV/5ZyhBLUplLoWrD2oN857VHt5GpWAtIUqd1HQwpRFXur?=
 =?us-ascii?Q?ZH7qgbqxESQBRN0U5cR5Q6PZNxMSu6KMeeA9IZmAiFsB31uif5eTr1vIAqb7?=
 =?us-ascii?Q?GAPXvEberlWjGFXUFX+REnFUuL8N1IS1gRSeXlUx/HTZKNCsvKKtM++LFMhb?=
 =?us-ascii?Q?Wor16SNYZ36PaR+CPSTpjh5WIsmGDKAliu8P5MKBYNh5czt+LMOQ3aQJC5n1?=
 =?us-ascii?Q?tsD18L+4xH3gnMfXX4KzcmUNvKaixQKHCqv0gn8nL70Gjy4anv6OmiyjXlNZ?=
 =?us-ascii?Q?KXK8sHP+uLSZNxHxP3VpWIr0PUK7igE8YJKMIkHwNFJOKIJE/rfI/18fivX2?=
 =?us-ascii?Q?hGg+CrxbtHvewxE3YHIRFFRw/q22JjAzfdM4qMifSQzNPol6YEoIqhk3MMcE?=
 =?us-ascii?Q?7Rq4Jxv7gBT5NdMHG0quI/YBgohyFSjzW/5YZlX9e7kiCrvR8Qoy9/KlGnbA?=
 =?us-ascii?Q?CvknkyY0XHvgIvCMNZItT44VJKQW8lr75a4pwoZp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06418d4a-a7f5-4444-dc44-08db25ad63d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 23:31:23.6831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rEjT4PxZvm5BXZEaPfyag/f80dSqz9gPQtukkQ27w/1IHh9czGdRX5NcWkyPqekNCQnQlszxHyX47oYypStVYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5403
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

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, March 16, 2023 6:53 AM
>=20
> On Wed,  8 Mar 2023 05:28:51 -0800
> Yi Liu <yi.l.liu@intel.com> wrote:
>=20
> > This is another method to issue PCI hot reset for the users that bounds
> > device to a positive iommufd value. In such case, iommufd is a proof of
> > device ownership. By passing a zero-length fd array, user indicates ker=
nel
> > to do ownership check with the bound iommufd. All the opened devices
> within
> > the affected dev_set should have been bound to the same iommufd. This i=
s
> > simpler and faster as user does not need to pass a set of fds and kerne=
l
> > no need to search the device within the given fds.
>=20
> Couldn't this same idea apply to containers?

User is allowed to create multiple containers. Looks we don't have a way
to check whether multiple containers belong to the same user today.

>=20
> I'm afraid this proposal reduces or eliminates the handshake we have
> with userspace between VFIO_DEVICE_GET_PCI_HOT_RESET_INFO and
> VFIO_DEVICE_PCI_HOT_RESET, which could promote userspace to ignore the
> _INFO ioctl altogether, resulting in drivers that don't understand the
> scope of the reset.  Is it worth it?  What do we really gain?

Jason raised the concern whether GET_PCI_HOT_RESET_INFO is actually
useful today.

It's an interface on opened device. So the tiny difference is whether the
user knows the device is resettable when calling GET_INFO or later when
actually calling PCI_HOT_RESET.

and with this series we also allow reset on affected devices which are not
opened. Such dynamic cannot be reflected in static GET_INFO. More
suitable a try-and-fail style.


>=20
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index d80141969cd1..382d95455f89 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -682,6 +682,11 @@ struct vfio_pci_hot_reset_info {
> >   * The ownership can be proved by:
> >   *   - An array of group fds
> >   *   - An array of device fds
> > + *   - A zero-length array
> > + *
> > + * In the last case all affected devices which are opened by this user
> > + * must have been bound to a same iommufd_ctx.  This approach is only
> > + * available for devices bound to positive iommufd.
> >   *
> >   * Return: 0 on success, -errno on failure.
> >   */
>=20
> There's no introspection that this feature is supported, is that why
> containers are not considered?  ie. if the host supports vfio cdevs, it
> necessarily must support vfio-pci hot reset w/ a zero-length array?
> Thanks,
>=20

yes. It's more for users who knows that iommufd is used.
