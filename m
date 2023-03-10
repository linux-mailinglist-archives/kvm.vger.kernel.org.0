Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4EC6B382E
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 09:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjCJIJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 03:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjCJII4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 03:08:56 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2891101F36;
        Fri, 10 Mar 2023 00:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678435712; x=1709971712;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Hj7uR7zRJvK4sg8QZBLiFPr8DAKT7FnOLQHBIRW/T1A=;
  b=VN57aBLnVuL2bsPqxIOTQmgTfmal82AJEjp5kZhr7KB+1qnhaO6b8PMv
   3RTIvaKIk8KpsULQZTo5Y3djzROu7rmcrtW0+9QMIACanLcJaRjSaNAnU
   fCUVJlcXs1S5BoPExFU4EGKsVhurHQ9qQ8UjoZgzPFpDRGHMY/P4wNUqF
   GNAUE0r0q80DI6nBwqsgfjJlOwkNKDW14b2BQ/722U31lVT2iHxkjyFt5
   bmjXeiBnc2NTTNgblpiWJVdFowBakNejclFnRfZcdyMsMIvHWUA+4oj8t
   QLWu2iVI+tEmXEvRHU/cnTZQR8pfzNi+HEIcQA0bEsnB4G8A6o326El9m
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="339038032"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="339038032"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 00:08:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="677717501"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="677717501"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 10 Mar 2023 00:08:17 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 00:08:17 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 10 Mar 2023 00:08:17 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 10 Mar 2023 00:08:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c0Mdx68kj70mcA1pCCR2zUh/AGPCoRTnKQrLPr4Nd8AXt0gzfXRqeMdn24WjyABpetV6bm6lN9x7qnq/QA68LmCWtw00xbA6xaMglkeC25eV0JGpnLHt61+RH19KF88n9LQ9FV6+8cAlzkeBPVkLNpCg3wlkaD+LrPh8FZuQ0PnN9lOd0E78ud/Lf+8RGdHcFZdKNbTLV3mA8wOx1eA80UYca2rWgzEQ4B33hmXmmwJ/aMB5c1ddIEBX2oqZmqpE1CxRT6g7S2WssTIj2Cj0En/zMtjZi7gZgGeACFHJpcaxa/FwtxBpLa015tguwAOIfZUb2ulmKu+G4wrMOGndxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4vmWQDNfmtqBEe0ByPgggVl/9vtjklRi2JtRrYfWWg8=;
 b=Ei6DzXJB/h3keSYGVzdFdHMhhUdQGxy0ZxjUlN6/o23ydnJITxNFEVjOQY6sGprCHtBkyK21yo81AZQM/xBUiv99K935vaIr6yMdL9Mnnfky9BWSinSe9Zhf4/LBIpKukFXBWo9JIBff9heUHOgebN/AALMa/TVE8ut/tZNWzWvHQrcrYQ07khcmvmh73XBVlowk7tov8nhy22QAxZpuwFeiXn8Tvh+Se3gZrHjma8Yzt66CIwudxixEF6bc/UmYOQFbhMQmo+asPaiLmzE5K7z7FQdLjQ9CZCLQVPIuLPv9vi8Hur2hdHm/CAlNjtWCYXAsfPqg8vOSGV7XQeY1mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB5779.namprd11.prod.outlook.com (2603:10b6:806:232::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Fri, 10 Mar
 2023 08:08:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 08:08:10 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
Subject: RE: [PATCH v6 13/24] vfio/iommufd: Split the compat_ioas attach out
 from vfio_iommufd_bind()
Thread-Topic: [PATCH v6 13/24] vfio/iommufd: Split the compat_ioas attach out
 from vfio_iommufd_bind()
Thread-Index: AQHZUcIKnlfid+m1xk2WV9/gWjjIRK7zp/Cg
Date:   Fri, 10 Mar 2023 08:08:10 +0000
Message-ID: <BN9PR11MB5276CF102D9EBB7B447C58FD8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-14-yi.l.liu@intel.com>
In-Reply-To: <20230308132903.465159-14-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB5779:EE_
x-ms-office365-filtering-correlation-id: 272ba177-c20c-4cd2-ce18-08db213e96d5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gUVOuBpTcozcFTHT4nRbVzADE69+PrYiZ/whkROtxMmVwAJF2ZzLYHMIMNct1fc1EkQw7rNP9ctORnm9ysy0B7vP9vx9+XOy+rwbGkgGQ/TKAWpfN3Wmwt60yvZp/KerYI+OrFN9b7RM1OAuLs6umQxzG0pnJbAVLN3cY7VzHDAPorCQ3gg7/d/y33V3dEuvo64ne+DXw5s8LiRhwQ0HviuEp5QhUWCc3+VCAGYbcchqmzXWVdqXeCzqG9vIfIxzhS8NIvFfnZKoPQztOrbcVVZHE4a5PxYoB6NNp+32chGveUUS3rRza0lkuhC6nr9wQz7Dn/8CsO5i6kEKuNaLpqDbzs4dJ9U9X3rkz6NdWnDomGB2aYERlND4kV2eFvNVmuLvN9+JEp+0Uj84HjgwUTvepj17sQcQOsvIaGWCkAwDVaxs/KTW82cXhgVSk+30+aTeGKB+KweIbg5bmRyCREqWJ3f6wSV0ChF2jKgk7BsLddrPSorZeCVtddg7dXPr+tayRfcqWHF6+Cg0U/Dif/m+Wh7rHHoah4wdwAYeWbdNaZvINHA5UAUpfe4wDwtjoscRdQjX43SnnL54JwCVgD+eEW/TFEUywxDTDnbQ17F9rSBl5W10TfSZiZ8KXHycdKHZM8ZF1JV/B4dxW7omhxUi88mLTSe8RFkHdb5k+ucxWgpBB6kSUdP9pQoUQANazRZbXrgbrlbnX8ccXMJkjQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199018)(82960400001)(83380400001)(33656002)(478600001)(122000001)(54906003)(55016003)(38100700002)(316002)(110136005)(7696005)(38070700005)(8936002)(186003)(64756008)(26005)(9686003)(7416002)(6506007)(41300700001)(5660300002)(2906002)(66476007)(52536014)(66556008)(8676002)(76116006)(66446008)(71200400001)(66946007)(86362001)(4326008)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fMTIMgP7P+CrQaZgWC/AwqBxpoDgUMhg/zvbFpSs9UdjO1QHd+TUnCP8DC6D?=
 =?us-ascii?Q?10OvOdIQ3htpN/VBNcBpgYe3f+xDp+aE+KKVECJLbj0jx0E9Bgu6o1mAfBKA?=
 =?us-ascii?Q?NLgNRTb8OTzN8QtNtE68pnHJBiKoLcysLJRGTBL5or5tzczK2w7c1H3aFwUj?=
 =?us-ascii?Q?wfOBH707ESN/8mYNqpstKbMASN4I67IGUZ3xepUh/FQ7bq/mJJF6gh/uv7Mm?=
 =?us-ascii?Q?2uj7z2E++cr2vp0xReiVAnheWuj+TIQLIM3Qk+O/CLfwttlci3ApMnEvKhcC?=
 =?us-ascii?Q?MbappGngQtRQDXLi1G2kJCoD1tMz4+fyyPX+KABFbHo80jAxg1TCfhW1UHcj?=
 =?us-ascii?Q?2aDc2AR4Bzx/cwPkR19RwvNMyw89LRPGvTLk7xaWqL4KoDwDaGjws+NjJiYu?=
 =?us-ascii?Q?wH5jhDaUiAwkwwe75aadY8LDALubyEY/+PCH9eHhuvkkkc5Zcm4pKtYth6BF?=
 =?us-ascii?Q?NIVcVu0QAkIFmO+/rAd2g/iPcZU5iHVbFLUAjdiXRotE8WFeKXTuCYI86Ske?=
 =?us-ascii?Q?f3ybf8NWdCeaRgY82VPGBZRZHroUuOsvUU7hmRBV99dNUR8+epOYIovf9EZe?=
 =?us-ascii?Q?qzwU0Fbg3ZJ6IC1Yc8sIsMmNjRTsHbQH2zjl396RJcCMgzj9PHXWBimlYVjA?=
 =?us-ascii?Q?tc2UdS/kfAAYZYYJ8h3m6tIp5mJtmldSt/a9NH7tYSkVIWhftn3WXOJ9kL8R?=
 =?us-ascii?Q?SsM43xRKVudBFQynfpSeuWPz4w34ush+cdiwTbaEOUsbUSvakoqlNWKw3Lrh?=
 =?us-ascii?Q?XdIqf5PQAimlCc6CG6WvQWQ77IgmzpAJInO+eWgEGuBqDLAAyjh64u4kyqsO?=
 =?us-ascii?Q?caRv2UWhMiwJy+6Ib2/73pt03iVfhdAmC2a4yEVF8B9oSk17L8gXaM1+WNJa?=
 =?us-ascii?Q?4uDBIDD+vwd9IniSFahnDxX5tOAw2XuXtuA7N3plLpNA7yGALIatAl78X7RY?=
 =?us-ascii?Q?3cOIrV8XcTT2vO6nsTUD7/nImnTyVaLQc/n7Fv9dOxScaltoKpK7NBKLow5j?=
 =?us-ascii?Q?teRLC9OLz8Q8kS6m2vC/T47kVckBcAhtSP/vKcQONNRvXxfOtkYX5jBoT/G3?=
 =?us-ascii?Q?cCxBwknCRZqGlFikdlMbQdzNxK1uUrvZsZD6XwYHyYYhfzBa/F7LKSFIb2us?=
 =?us-ascii?Q?tZC5bxcgHA1+5inJIejIsyNCSJiPh13h/Lid0jq2BZOk2mfo2ZAMUKmkb1xB?=
 =?us-ascii?Q?AyA+0OFv5JuTajh/WsVr8GEvxF3P/zfSVQu8YwjE5m4DDeXqDdxhS+VH7mM/?=
 =?us-ascii?Q?oEm8AygtOdUWSQ2SWlfUGsTNpV6vNzoUiTH0HsUh+sZhptJB7jlmdaHTV+Ki?=
 =?us-ascii?Q?iJ+k84uldSycXAxrJnsQTCt1INywuH7i+DlAFmf+SZD7LJEMrZB2ADH1fRn8?=
 =?us-ascii?Q?c0VUmlsqMtfPhoFKDXK4RiaCF0Ald6iXSxxkFCd3IcC8Uyfhqg8dN8MAQPy3?=
 =?us-ascii?Q?0iQXD7NjgPSTh/N1xDO3IRpsnEBja3SCwQ8CCkm0bGSMbnD9foL9MgqaBFdk?=
 =?us-ascii?Q?++Z90KWtacfDXPKCsfJlcq+725P7QikAkiTLsttf2WfpHoq3m3p6QhJ1Xwc4?=
 =?us-ascii?Q?ngnbnVV8TgKcJHhQm13tfOUDnF+K7lHY5ERNgCqx?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 272ba177-c20c-4cd2-ce18-08db213e96d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 08:08:10.4716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q2H2L7KgiDZeG35HEy9BkMWp+L8MD0aSRHYH8qawSmWMoQDVur8F0s40WY0wTmk7iShQ4jJTI1o9qMGa/PFnXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5779
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

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, March 8, 2023 9:29 PM
>=20
> @@ -177,7 +177,7 @@ static int vfio_device_group_open(struct
> vfio_device_file *df)
>  	mutex_lock(&device->group->group_lock);
>  	if (!vfio_group_has_iommu(device->group)) {
>  		ret =3D -EINVAL;
> -		goto out_unlock;
> +		goto err_unlock;
>  	}

My impression - out_xxx means go to do xxx while err_xxx means
go to do something for error xxx, though in many places the two
are mixed to both meaning 'do xxx'.

either way I don't see a need of changing it.

> -int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx=
)
> +static int vfio_iommufd_device_probe_comapt_noiommu(struct vfio_device
> *vdev,
> +						    struct iommufd_ctx *ictx)

s/comapt/compat/

btw it's clearer to move this check into vfio_device_group_open().

if noiommu then pass NULL to vfio_device_open(), same as the cdev path.

> +
> +int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx=
)
> +{
>  	u32 device_id;
>  	int ret;
>=20
>  	lockdep_assert_held(&vdev->dev_set->lock);
>=20
>  	if (vfio_device_is_noiommu(vdev)) {
> -		if (!capable(CAP_SYS_RAWIO))
> -			return -EPERM;
> -
> -		/*
> -		 * Require no compat ioas to be assigned to proceed. The
> basic
> -		 * statement is that the user cannot have done something
> that
> -		 * implies they expected translation to exist
> -		 */
> -		if (!iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id))
> -			return -EPERM;
> -		return 0;
> +		ret =3D vfio_iommufd_device_probe_comapt_noiommu(vdev,
> ictx);
> +		if (ret)
> +			return ret;
>  	}
>=20
>  	if (WARN_ON(!vdev->ops->bind_iommufd))
>  		return -ENODEV;
>=20
> -	ret =3D vdev->ops->bind_iommufd(vdev, ictx, &device_id);
> -	if (ret)
> -		return ret;
> +	/* The legacy path has no way to return the device id */
> +	return vdev->ops->bind_iommufd(vdev, ictx, &device_id);
> +}
>=20
> -	ret =3D iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id);
> -	if (ret)
> -		goto err_unbind;
> -	ret =3D vdev->ops->attach_ioas(vdev, &ioas_id);
> -	if (ret)
> -		goto err_unbind;

after noiommu check and attach_ioas are moved out then this
entire function can be removed now. Just call the ops in
vfio_device_first_open().

> +int vfio_iommufd_attach_compat_ioas(struct vfio_device *vdev,
> +				    struct iommufd_ctx *ictx)
> +{
> +	u32 ioas_id;
> +	int ret;
> +
> +	lockdep_assert_held(&vdev->dev_set->lock);
>=20
>  	/*
> -	 * The legacy path has no way to return the device id or the selected
> -	 * pt_id
> +	 * If the driver doesn't provide this op then it means the device does
> +	 * not do DMA at all. So nothing to do.
>  	 */
> -	return 0;
> +	if (WARN_ON(!vdev->ops->bind_iommufd))
> +		return -ENODEV;
>=20
> -err_unbind:
> -	if (vdev->ops->unbind_iommufd)
> -		vdev->ops->unbind_iommufd(vdev);
> -	return ret;
> +	if (vfio_device_is_noiommu(vdev)) {
> +		if
> (WARN_ON(vfio_iommufd_device_probe_comapt_noiommu(vdev, ictx)))
> +			return -EINVAL;
> +		return 0;
> +	}

no need. let's directly call following from vfio_device_group_open().
In that case no need to do noiommu check twice in one function.

> +
> +	ret =3D iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id);
> +	if (ret)
> +		return ret;
> +
> +	/* The legacy path has no way to return the selected pt_id */
> +	return vdev->ops->attach_ioas(vdev, &ioas_id);
>  }
>=20
