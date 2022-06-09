Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E196544464
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 08:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239464AbiFIG7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 02:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237739AbiFIG7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 02:59:01 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2408711A22;
        Wed,  8 Jun 2022 23:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654757938; x=1686293938;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K0E5ZjatsmWNKMdDpvyxDz2859GXCaMubP3waWVqP+Q=;
  b=bNoOcODVM3EZtUqM4VmVAtnQkpBTSunBK1TdsS3joluCRqQ+hAILx9f0
   qX4C6cj+oM393EBo+UXMEpILjte3uCdysu1Q2RjJu8+DhIChyQBj+8Sz+
   ttzb/TWB1HwXH53y4FQoD4d9DdoPQ096ZK4kCf0hKY0yxPAj+9KMgdA3T
   SNS6GGGdafEX1gXF+k9yPKB6KLjd+xJ5BQevWmbgxjwUFCbKhuPXPi75E
   xhdV0nB1cQXJHJlVCeV0fP288yfALC+jCWu74p6I7y6IRIO4x5R9VX82O
   lCyBk1mfYVkmQtBThdchbHTuPpYwo6ZSnX0WM6eNFY23zhFzFwmolKMIa
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="302542069"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="302542069"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 23:58:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="759877827"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga005.jf.intel.com with ESMTP; 08 Jun 2022 23:58:56 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 8 Jun 2022 23:58:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 8 Jun 2022 23:58:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 8 Jun 2022 23:58:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/iWfbeMPyEfIqBgdT6q9wY8dzr6dKq0ONJBslfSKvNOkJBHePPcDSHmZNIny4HtWCdQU2JVtsjEQJ/9D3aN9w35ytAjx5GM5d6wEQ+YMc8F+sTaVTQ04oeK7SpXuCIBHCZ8zsVLYeoPqivcTkWxfLqxTcgLxY9Cobam64rtw5WYjPPL5y7DSelZee/meCbDM1CM9bg0MgTw0O6wu1JUeaxQPy7ezbzVMo6N0aPHw1gFTDxiFn1SJFgQLQ+9Mba8eVGhXMoAvy8NNOKUyPcJolkqpuObKWHEVCAGLEVqgV0lNK+6LIeopEZ/Pw7DxlNf08LVeMqJmSPIZbzUrTT8qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lJxMIRrc/6K/hdn6w4JhdhQixr9C351qa3NT6/StkXw=;
 b=GpkPsu6+V4vo70U99IO0YcMjZ//fye4CVTdG5dhyXeZsu+PIqSJm5ZjWfZGBV0GtPKeX5ESuAORrU7OfacS3xCVfAK1jr5tULJCHiQ0Afj0go/Qk+bk/yPjZMGmS35CguIqIk1jPRh6mjQktXKyUmVW2Zl/WgfRGxbjs4MfMt84/LiWyMpa/oJ9TFVE5hIrxvT6PCRZ8kjpiH7XIZd9wEp5beHyxxe1+EkMqvmUhBjwq+KSMJsTzEB1UPHx23OcSHiZoA74UFOvG7X/857E06h41XMQcRJ2bhnVJQHcXizjDRRXVdV91Za+RW3Oi77vqceukcNFRZrUie4+t6e8tig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MWHPR11MB0078.namprd11.prod.outlook.com (2603:10b6:301:67::38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 9 Jun
 2022 06:58:54 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8%4]) with mapi id 15.20.5332.013; Thu, 9 Jun 2022
 06:58:54 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 8/8] vfio/mdev: remove mtype_get_parent_dev
Thread-Topic: [PATCH 8/8] vfio/mdev: remove mtype_get_parent_dev
Thread-Index: AQHYdxP5WTfT14biTUurly4KfhpHDa1Grn9g
Date:   Thu, 9 Jun 2022 06:58:54 +0000
Message-ID: <BN9PR11MB5276E3898AF02C588BE2993A8CA79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220603063328.3715-1-hch@lst.de>
 <20220603063328.3715-9-hch@lst.de>
In-Reply-To: <20220603063328.3715-9-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4921752-1f0c-46b8-386a-08da49e58445
x-ms-traffictypediagnostic: MWHPR11MB0078:EE_
x-microsoft-antispam-prvs: <MWHPR11MB00785AB66B4396363D204C3C8CA79@MWHPR11MB0078.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mYbdUzhIIeNpb+uqvSNEKueXS3/YYmEUTEnOPVV1hMNWn2KrclyodbJcUU/sz//uLnLTG1x+eNSuuuDzWjurCWz/Q/Cj8UO6OUuBtHvz6CmBrOs5m//QjC8AMFK2YEeIhvqOh5QFBa9G4rGNLFRPvyS3+q6N4AWG0h+zG6PNsK6MhaMsmq62mg4TNXPqP28EY/afhlPDSuTsBwoZOcwiHvMLUTT9HY3e5z0f5rF1am2wWdc/2UvkC+kLuPW0DZUERIn8SCrk3BB7lwKaZksJvGftBv+AjRxrFAwjkgVKD+RfxHBRGfilcbPTFFLsyc8pYK0rFLmHGRDa6HnfnC8qr9kb5xMbO3p397IMar9VXm6S5Dak0VPzD59F6vxM4SQgWOkEj4O+7X45GnxaaQLlzopT0dKdNp5Yt/AWWVjpmAmVHL1fV+d/CKBrngLCw6fP4QLwC4I0JmQsvctDX18tVMpgRQ6+/4KmvK+xwk4HTfiwZN0AATqHHHXcLO5IPy0Dcq3cCcsxESP/D3ysN8pnArpCHkPwx/+7JBq7L4ZLGVzvNfks7UWuD0KHs1yLgbk2FiCFxxJvPPy4aQY+ex/3sI/zwFkcbCbz+bhBeqbNwdVdjVJ/uiB7kucfu10ONAX6dnJi9l9czCaXlTiVl0axbeXIPc9bry3+u0i4+RMU1c3eASAUzOh8/GVQoscq2mIzHDcPIhybcBdpLx84ko0xd0uySupIAy5Z+X19xrhJEM4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(9686003)(508600001)(71200400001)(26005)(6506007)(7696005)(122000001)(186003)(38070700005)(83380400001)(921005)(38100700002)(82960400001)(66556008)(8676002)(66446008)(66946007)(4326008)(64756008)(76116006)(8936002)(7416002)(2906002)(33656002)(52536014)(86362001)(5660300002)(55016003)(316002)(110136005)(54906003)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pFgQXK3xAKs89yL9FK2a9yxB27VAkAJUbVERF37NsJu+3m1Hwr4JWI8+RA1Q?=
 =?us-ascii?Q?3/YCMypGBmbdF/o29D1MsDcn2VMyJxw/D73phidobBvTBqoe7IIO3Bm/KGJs?=
 =?us-ascii?Q?2I5NIgAXi37Sr7pfOTDxFQX8dZfaTH7a6bOyJZfjfqBWS0UB+pXNsadfNh/Z?=
 =?us-ascii?Q?R9kMH0DxJ9rxWmmQpsqzaLt/LPNZaHJNvK+DJ3mQcUIsTlhy0kYhzgO7HbD1?=
 =?us-ascii?Q?hTApoCOnh+czMAH+LSzOHIihGxkWpV+qV8vI591rjUu2Mo6Wac8Z1sTKmWT4?=
 =?us-ascii?Q?8BKAtLViPH1hcIk0VP9DThpaK4/Q0tGc5PKg8gdCBmFWMgIvC15rCGGT2n4J?=
 =?us-ascii?Q?6MXR5L9EmqtXn0dswl5Y81jL5ak3Epa+sfI4GAytF4pEIxUbGFNncVAOYVyZ?=
 =?us-ascii?Q?2FhdOcM5ZdsSuMKxc7UY4kE2xD4DUGyvI7W+dADunDKSQQacgLTk/Lb9xBTF?=
 =?us-ascii?Q?P5x0HETpbI3uUwzPuMuripQj6k++bljGtIeXKBwohEzi+0BY/uRkw/kKLTLM?=
 =?us-ascii?Q?a8zdH1CAZfDVBd03WPmT53b2HZF2GlnZO1KeGN6hYrOuHRTQ44zMr2wCIHok?=
 =?us-ascii?Q?sPgPmTGXl5dTPCd8w/hWurSZ1UmnUbbdXPHR+/0nRG/e48/hqs4PLoKwc97I?=
 =?us-ascii?Q?a1a0sK9tMmsLKmPGpKkXKFQ+BtQLwl+X+qAesoQmKrJSucSFpO95ktqA+fLQ?=
 =?us-ascii?Q?1O1YYU/R7cfikjwGvt/JjTdTsA5DqsjcooKJaWSettX8LTJ08k0n1dZr+upW?=
 =?us-ascii?Q?2/Y+//Y8jSuiXOhJfQp88rO29jTBP4YJW0dcA4FvI6MxRUSvWaPwbtAHuOgB?=
 =?us-ascii?Q?7F/NRP+S8LoQwPOpvfDCNJ5ozV989rzvIQW68AsuweU4GaszZe8pMUn5mntU?=
 =?us-ascii?Q?NGs9WeLQJpJZ5mzwL//IqG1WQFZ//p9o0PhhC8QfYCEw+SLsY/eWYo6EMcEd?=
 =?us-ascii?Q?gRbpm8iz0+f2ztm88daLAwRNbH8Gk1ThqH58AAPVcHPtRYHt84CUtkhFh0ax?=
 =?us-ascii?Q?fCph6rz3oAy3Qp7j/j44jjGY4mXem2FOVTyK5OMg0swN34rATvdxCWPFeUAg?=
 =?us-ascii?Q?AGj+XYLjDxTAdLRZYOJz1x/MPXQkvZmAIccFeORaB5vKDmRScU/zlQETLgbz?=
 =?us-ascii?Q?VvWwc9bPONJQdiNGq+isI6WY3ttDBF/NitaKWVXLAiHQPuhjr5GS7kMLYtwy?=
 =?us-ascii?Q?0Sy7myLAz7kNKFiyvSrxMqqmAdiVz9IKaV+ApzcOjst44egv2kA1LcaJlTP8?=
 =?us-ascii?Q?6xcpAJPepr3oCg0z3WuZBvq2dAvW4XXvFgETudkl6r7hhGmMQNRbfcSNx3EI?=
 =?us-ascii?Q?lr4xLqBZ0LRmfyg3d4j7BzKsBVsU94D0l8C+W9BdbkKEKDooDvgGVoH8b/co?=
 =?us-ascii?Q?DKGd7+BBRuKJBG/BR1GRD0v3WfrNl4vzWKjbEsq3xSLJbeN7R8JEtIgENBsv?=
 =?us-ascii?Q?UYvDSsqk717SFmDw8YOBZixLShbYG0Eaf9KD0vH3w89n/GSg+zilXR53CJiK?=
 =?us-ascii?Q?+N6nbjTuwFRYIaspoo8QdYEnXb2OH0XG++e6AsbatHLDhVKeqVD9TGdM6zM8?=
 =?us-ascii?Q?tpcHwOlBJPHFME4UvNkAd9w4Sig5s5dXw3tJpiROhbUMyNe1pwXT3prp7ecC?=
 =?us-ascii?Q?TU2TqhXU3sISuCl/BGmwW2relBlCD/0DG8JoEIqg+vBCfH3XrA/6SshApyXY?=
 =?us-ascii?Q?3Mm0mBqHFVtcDn7sN6df1Qf4tlvYF2wz4nBTAg7gZU4De9W0DdDyPuJKoCDu?=
 =?us-ascii?Q?e3oLB7mcpg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4921752-1f0c-46b8-386a-08da49e58445
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2022 06:58:54.1500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q+glZXbPK571Z7bEacmWH2Bzf0GL+UJRCxB4tUU4KFxXJYaRWaLkRXALEdQtEb3a/9AQM+DsrH9yT4IByvY4iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0078
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig
> Sent: Friday, June 3, 2022 2:33 PM
>=20
> Just open code the dereferences in the only user.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/s390/cio/vfio_ccw_ops.c |  3 +--
>  drivers/vfio/mdev/mdev_core.c   | 10 ----------
>  include/linux/mdev.h            |  2 --
>  3 files changed, 1 insertion(+), 14 deletions(-)
>=20
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c
> b/drivers/s390/cio/vfio_ccw_ops.c
> index e219ea3c62fc6..4864271cffc1e 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -88,8 +88,7 @@ static ssize_t available_instances_show(struct
> mdev_type *mtype,
>  					struct mdev_type_attribute *attr,
>  					char *buf)
>  {
> -	struct vfio_ccw_private *private =3D
> -		dev_get_drvdata(mtype_get_parent_dev(mtype));
> +	struct vfio_ccw_private *private =3D dev_get_drvdata(mtype->parent-
> >dev);
>=20
>  	return sprintf(buf, "%d\n", atomic_read(&private->avail));
>  }
> diff --git a/drivers/vfio/mdev/mdev_core.c
> b/drivers/vfio/mdev/mdev_core.c
> index 3bdea77d506d9..3f51fbdf9393c 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -25,16 +25,6 @@ static struct class_compat *mdev_bus_compat_class;
>  static LIST_HEAD(mdev_list);
>  static DEFINE_MUTEX(mdev_list_lock);
>=20
> -/*
> - * Used in mdev_type_attribute sysfs functions to return the parent stru=
ct
> - * device
> - */
> -struct device *mtype_get_parent_dev(struct mdev_type *mtype)
> -{
> -	return mtype->parent->dev;
> -}
> -EXPORT_SYMBOL(mtype_get_parent_dev);
> -
>  /* Caller must hold parent unreg_sem read or write lock */
>  static void mdev_device_remove_common(struct mdev_device *mdev)
>  {
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 6d0a9b45a9eb6..dbf054d084886 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -48,8 +48,6 @@ int mdev_type_add(struct mdev_parent *parent, struct
> mdev_type *type,
>  void mdev_type_remove(struct mdev_type *type,
>  		const struct attribute * const *attrs);
>=20
> -struct device *mtype_get_parent_dev(struct mdev_type *mtype);
> -
>  /* interface for exporting mdev supported type attributes */
>  struct mdev_type_attribute {
>  	struct attribute attr;
> --
> 2.30.2

