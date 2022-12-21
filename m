Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDCA652C12
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 05:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiLUEK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 23:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234323AbiLUEKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 23:10:49 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4EF25F6
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 20:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671595848; x=1703131848;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2eRpQ703vcU7S9L3ledFJsBWPV6VD6WQms5uMfDEoTw=;
  b=kyXAk5ftwHQKrW0MHC082/F/lMgDeZj7DWuLlDOAVyx1709dpK8q+Xr2
   bbJR5qi/bxT58Co9qfC0klhqSjInJjwRvyyoxzIvKFiaJCC6vvJfVaPNQ
   ForSzpRnYdRDhoEV0N8o+ln1ThwBm9dBIVhyjC28lr6efkF6wli1InH0I
   NjAJB0+lJ4RuMwcdM1nMsZXhIG89XPkOc7IkWtVAvvkLerXZZ0tpj1zMB
   8CT6xf9HFZ5eg9DIVzR1IJGHmCLfK2Ve0rHW5GCwEFid88VWH4pKj65FK
   VnQ7wLkpWCVZuolYhFOa0JXWNTkg4KzhSsS30MDQWT9UI5h/wRTBL8D0a
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="299456079"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="299456079"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 20:10:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="740025640"
X-IronPort-AV: E=Sophos;i="5.96,261,1665471600"; 
   d="scan'208";a="740025640"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Dec 2022 20:10:47 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 20:10:47 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 20:10:47 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 20 Dec 2022 20:10:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oi9DofiIBWDyuAql5KsEkx2jBVaDg57bM0k8HHOUxF/fPhy5Lz6GiYSFTmUluY7J+iVmRZ7pU5w94V2bI0uJX9GWuUyVf7DJ1CeAECnogdgJ0JM7tSnR3PYeGntzqqYlW8cbfSrEvKb+c1h2NBb9nC18XRl4/dguW+NDrpet7mjHLSxuT7HM5H4btssSAf6zrw2RM9oh7zxWruyuj1Nhvin8qQqF00TvUGQo0T7UlAhsX0K7mXPB1N6secsN/xXBOj2LNkn0HG1o4YCchhFaucc/YuoKY6UkoSltmiHU3LPu4jokm/h8G/wqV9/z1rXzmaJoGGaETDx+BtlfwLDonA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ecyuOMxNrmY2kNoIN2dFNImAxSGiYpxL6NA4FRB4MA=;
 b=fmE+xWlYvFRUM7msURErLDJ53nhweVHLlL6jRtbdjPt3xTwpoCCNBV5NmkWu1f7WVNlsN4mipG/LZOghYvE3Fa9a6asyKWKQwQa0DU+643Jd2MILRMLZ6zSqFaA7R4vuBtK808H6L2LiipkHz+fAj5mVzsT4ZILjjOs0cwK/f506BDjqopHEYG9BBdXZOpvqgK/rnUbCxkGei9aoM5Gr13nszhXApwzMrIuwRFAXEUufRFS9fpd513DpDZqt2IXFSEJx+ph2H9f7CYJUZbPnva06r+JgFtjt49dNjJfD91KFbj3jv3nCw/IxGCLEL/WKF8Y+8AiPw3j191YIat8FRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4880.namprd11.prod.outlook.com (2603:10b6:a03:2af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 04:10:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809%4]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 04:10:45 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [RFC 06/12] vfio: Pass struct vfio_device_file * to
 vfio_device_open/close()
Thread-Topic: [RFC 06/12] vfio: Pass struct vfio_device_file * to
 vfio_device_open/close()
Thread-Index: AQHZE4aUwixFLcLSEUqcLpH76fiqhK53siGg
Date:   Wed, 21 Dec 2022 04:10:45 +0000
Message-ID: <BN9PR11MB5276DF71950E708BA18619C08CEB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-7-yi.l.liu@intel.com>
In-Reply-To: <20221219084718.9342-7-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB4880:EE_
x-ms-office365-filtering-correlation-id: 2286adc6-c917-45aa-c112-08dae309556c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y4IbrxnL/rvb973D1fHDeFBYghyo/RyBXjCBupsPFNKUrbxXRh7qLnCpCJUmn1MWUgwAFuabBdNuq5VTrgG8GdtjgJjmElEtcm50WoONL7Y3/I2LygEQRkEBjYAJqFU10wTjYAAvJPU1MJ7aTHWuMapqJsAnSp9M2C2teiRRI8T/P7IRT4F64lj5YfuPYr5nqxW1XoZD4XDGIFe/50mBBrVyn2WLqAqdSn6TUoGJWtg3f9Glh5qh8loZEd0Xw1zO82piYwdh09xwjsu5thUbRRLAVcKN8N3TF646l1OR3gyPxNuBJIRrej2fv5SbpvX3oC/r4NUmN09hdIDsMmlE9hKapoC95VhMFiV3VWzzPUGaJvfU5wxyl3qtjgehIoJ2V3Ez0yjqYcCeGuGS+4r0koyUjuIhJzaVIT67F26ZnRil87CFkzLzFaTgQTaxtqv81Nqh7wvUbFXim4O3x5d+0aRMd/APdjb9t9sXM1T9hTZ+n1I3sr+ZnJsw+rjxXOpUiCZXHy8FIPI6LHzeDGgG/y1ZiPtzNmE2vtc/Fa/zqrb8UHJAZ5YXMfgrpTWtoETcgRYQIr+pKCE5S9xKcA7uly7FAXrVDYdOYdJBQk8OZKtHQHudKIBnov3kAIKZmHM9Ebl2tim6i9yJbG41+VHJQkzXW6aprXTSgxKvPS73Oz9v25Sodm95s6yecrlYDi/iErGHOUjbXEgYU8wTaO9Esw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(39860400002)(346002)(396003)(451199015)(86362001)(41300700001)(478600001)(76116006)(9686003)(6506007)(7696005)(26005)(186003)(316002)(54906003)(110136005)(55016003)(8676002)(38100700002)(122000001)(66476007)(64756008)(66946007)(66556008)(8936002)(66446008)(52536014)(71200400001)(33656002)(4326008)(5660300002)(7416002)(83380400001)(38070700005)(2906002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?igwq7YYtYEiP175S3rufSZWSsNKZI/0rlKsWOhZGbeDACbFnv3vI68RbG1n8?=
 =?us-ascii?Q?NZBujl5em9Od6nVgf58sp0pi8ZokA92ZvamOAQbF1L6r2n6Bq+6LMZPSUxvl?=
 =?us-ascii?Q?I1GOwqbewFpzUtEYMXx8B29DX2HvonvyMPiikRrvcTLyEjMrLzqzYXP3zn4O?=
 =?us-ascii?Q?7UMg3vUYX2kvd5a6kyxovVIzf6iUkIz36PSDvlTJtjQiXUwyRBhDNw5f7T2R?=
 =?us-ascii?Q?W9nDoJ6RlRAVJWfgRV9P1udnaOY6xfqLo8YJZd2laD6rJz+sLTnzigDv7+n7?=
 =?us-ascii?Q?CRsuiFwOA82nEYa8BcUULgebh7hYDi7i6bemu1iZe9lbX1dIhEFK63Po3BqU?=
 =?us-ascii?Q?qgDInigBh7XgL9E34+C/gdrjSze2WpoID08pW1/7hBLFxZ+XKuw+vlEdb3Gp?=
 =?us-ascii?Q?BsDr8IjbjESsmO0RN1E2nDNak29t5kaqE1TiLJXDyi83gcgc5gjENoa5vy9H?=
 =?us-ascii?Q?Y8O2/Mqo/fTS+AIYgUlzF+kiclyQ2dgzS/KuEKbKkqoPZevCnMmrF117TVaK?=
 =?us-ascii?Q?AK4FoD+D+eBl1dPwfqzg1++SKCQzE2Ra7Lm5bM7pO4osyrguoebDTLD6OBj+?=
 =?us-ascii?Q?q34W8miEVtO755nZjB8bhM+J7LvhOz4aZbP8LjzR6nPircS3/YveaPwB4f+0?=
 =?us-ascii?Q?B4BNN2FY6LfI64sDdT0Tx3kXDMBri8zFDJoKpEawzZ3na1iieJP2TjnGUryo?=
 =?us-ascii?Q?F5bGy9LKUTel+ZEIsmGP2lICSffgLj7kHJYQithaSVMU5Vgj5KFiq/w2lPS8?=
 =?us-ascii?Q?ekoPDHdBeCZu64Bh9K6xyZEWvujNlpiA81viWXk7a7BqgqzG3bpdDmAqNgXB?=
 =?us-ascii?Q?1i3E5SO4gn79c562ih+s+ycEPB8Czah87lr0Es+WIU+Ws6TIYoi9ecT6mBJJ?=
 =?us-ascii?Q?rEn1tzgMQ/XVAfVOe7GKePM4paPrVxO7UG3GcRwWc15/r0xl/MoOkaAdxDUx?=
 =?us-ascii?Q?I20f6cxbUpdv9dtwPOa6pyhw60SOGq7K4zusnBE+tHMS21xOeT0qEDsDY9tT?=
 =?us-ascii?Q?GSIp+v5bbLIvkHtPgdBKbiMvwHBsfuiLPN3N+NdzndjpfhGzfZsh6y0RJXbY?=
 =?us-ascii?Q?49vysQ8PaG28Wv67YwVTsO5OmsRsgdJrE/Zo4OD3oEutts3rS8Ht3/8vx6HG?=
 =?us-ascii?Q?PxQQwoSv5ofxroqFkazgUOrKdNm0t0RJ6I8AQXeUyNix3TXZ/vlug5nLBFBr?=
 =?us-ascii?Q?7H8VWmwFA+ndve/murFQ8SBGfej5ct5TbocO8zl+b2ndHziyc9r0K6M+KgZp?=
 =?us-ascii?Q?UcglPS57aEa5uwE94rdVeUZ7nxk1UpzNGeTAI5EX9VGOvjxUaMXENqzSig9C?=
 =?us-ascii?Q?CS2aFz1IELjaF2LGvuQz12QrJBwHYxHM6/2zt8NxrUOXlQ99Y1n4so9QvJ7i?=
 =?us-ascii?Q?k1IN30ZP7zgw/YW1TOSjCfTROZ51Kpl0WtZctcoIPUR5MGmjeOnagDxyRvei?=
 =?us-ascii?Q?b6FncuENm+5/b8+aAFEHFJ53x+m7FnvDEfsKgIURz0zb40oz/Ylf2eqO771C?=
 =?us-ascii?Q?0oKMEkX+/fPp3Pb0cqJxF8hlA4Ql2V2vnk/iVCMuE1Xe1lYMla1hWm0gziEo?=
 =?us-ascii?Q?Wud/5W0w3vOcnmIZcj0gEUrg5bg4nyGBqpSAMqLN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2286adc6-c917-45aa-c112-08dae309556c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2022 04:10:45.3435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SkJFCnp3LMeeAp1mAJKZO1qLsy+oatMxrOEi0l/1EjwcBCq+wZzqcANrVP6FNa74lkaYNan4Xg5TF2GjrWcBwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4880
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, December 19, 2022 4:47 PM
>=20
> This avoids passing struct kvm * and struct iommufd_ctx * in multiple
> functions. vfio_device_open() becomes to be a locked helper, while
> vfio_device_open() still holds device->dev_set->lock itself.

Not sure what the words after 'while' intend to explain.

> -int vfio_device_open(struct vfio_device *device,
> -		     struct iommufd_ctx *iommufd, struct kvm *kvm)
> +int vfio_device_open(struct vfio_device_file *df)
>  {
> -	int ret =3D 0;
> +	struct vfio_device *device =3D df->device;
> +
> +	lockdep_assert_held(&device->dev_set->lock);
>=20
> -	mutex_lock(&device->dev_set->lock);
>  	device->open_count++;
>  	if (device->open_count =3D=3D 1) {
> -		ret =3D vfio_device_first_open(device, iommufd, kvm);
> -		if (ret)
> +		int ret;
> +
> +		ret =3D vfio_device_first_open(df);
> +		if (ret) {
>  			device->open_count--;
> +			return ret;
> +		}
>  	}
> -	mutex_unlock(&device->dev_set->lock);
>=20
> -	return ret;
> +	return 0;
>  }

I don't see the point of moving 'ret' into the inner block.
