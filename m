Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A726372AF
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 08:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiKXHKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 02:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKXHKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 02:10:44 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C812B38AA
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 23:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669274456; x=1700810456;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rcF61HP/4bt4JR+wtBoo8fwV5cpWKxY4KWm6RO4EikY=;
  b=M7z4CMy2/sFa2N9ySbYOV+UsJ1KZycO5UsOBLeD8bN+jQUvbueGmaefC
   6yVJ7VqntOBUDJ7VQ68LZS2XCICY0plOj+eOu4XVzsfX1dXpDk1aPJ8/h
   6z56fuz1ms5dIIWVt8FmSOdukRy0Nhn0VKddC9m9s7RKWwTj0kmwk/qZO
   rANo4Fpvnq5vcyIyD7aqAS7AYpSZNLLEjzELNWwGqgCM0ezQw1RC+eT4u
   czEkqYqtwaJ/A60n4c7tZQEUASEeCm6vLlypSdFRvLUUnbA4jhvWWd1oa
   FssxAvnW9wAm5Lzor2d/8fZqvvPaKiiYGCNsGTwS83StdsxTetYA/ndyx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="301794599"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="301794599"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 23:08:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="705644634"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="705644634"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 23 Nov 2022 23:08:08 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 23 Nov 2022 23:08:08 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 23:08:08 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 23:08:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jD6Ag8GIhDSGesw7RTzpXL39fTJiXbes1tcr2wcaPXg7/GGCQiIRR8eb+XZxZgd/zrIBWASzSrBoe1jncmTZObcjyaA+3GwkX9yrEQRao1RSMAyYS0gqvQw7A9SIt72K06ZkT5QdhoD6oH3SOP9zpUCjlfJjQElCqModKC6mQZpNL8HBLzOu8Re1dIjjD32VHdXl6159rpnKWa0ZViuiS//NFxZRnfUQljlZ3NJvqakntwE30aE0b0og3xh19Yo2Iy2AJYwaIjNNysCa65VP0rU0LCIcTvW0TJ6XDPKQnEXvAHDKfYW3pIBNCDUEMwMsKuC658+8m0x93PD0O6cP8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5vXEgPkFr53oEPUXjWAXJNMMRwmnL8LFa5a0f5BtX6I=;
 b=j7XWSACcID92ciSf3x3Mvm9g/qUvJp5I/sxlew7T+ITx7lGybrCQY3jPuk+DgpCbOvIAGJNdtpYjfwPL2lk2nc0U9H2HvbNxELXQZsP2m7tNeTf6cCTN3oLOLg6+No3hXgW6C3L3u8wzOQRuFaYnbsbIFOxqb0uo9rUT1vrBkeEi7UjHmvT6YhY6VAR2o5RFOnw4uxlbqJtej10yRECX6h4+RqO0ZsE+0Vkm1W/TYnEQvrK6PCeB/rpEA6wMH6orrWXR5XvlKPGWSCF2m16fqhCAWNMdqIk/cCZC6z8VLnsQOpZXzzJvJun+0uKkizLnnGLoUkJ6I5DpU+R9/I31SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB6351.namprd11.prod.outlook.com (2603:10b6:8:cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 07:08:06 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde%8]) with mapi id 15.20.5857.018; Thu, 24 Nov 2022
 07:08:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Tony Krowiak" <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "Jason Herne" <jjherne@linux.ibm.com>
Subject: RE: [iommufd 2/2] vfio/ap: validate iova during dma_unmap and trigger
 irq disable
Thread-Topic: [iommufd 2/2] vfio/ap: validate iova during dma_unmap and
 trigger irq disable
Thread-Index: AQHY/0JNDOImPJXOIkCz+4x7weUmDq5NqDwA
Date:   Thu, 24 Nov 2022 07:08:06 +0000
Message-ID: <BN9PR11MB5276E07F9CB1A006FAC9E4098C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
 <20221123134832.429589-3-yi.l.liu@intel.com>
In-Reply-To: <20221123134832.429589-3-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB6351:EE_
x-ms-office365-filtering-correlation-id: 4a9fb9ed-f3f0-4a05-a718-08dacdeaa2b5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tboMF2uNiQdjKfAlzl1918kOiFgStDLy8lv+YWwg3oHYBDetpJBHXqWjVC9jC3WJt1oILITd5erlyoEc4YIA2Dygzec0KPnWX5moTZtgXRpxetHo5wtFR41n318mK6Pjf3vyGznL6Zn6w2cxL6TadGl/9oOuFysq5WBspafIw4wVr5VyLDFlZGhNhcAYG4kPUky+F+Ks9LBDqnF0xyoUGjfVfMLJxYWtrMErZ2V3YjhflIVztqfSVEgdY1uudBZ5MwNGDENBOm/9aIi/gY8ijIbRbS1YEXSyjzRYi+KjAlVY7IJ5RjNk51aFiNBcZk8Hgr8xfLgeMh8hU51yo6v893Y2VSUMq9Mm2t6zjRsw6a31xt1gUb7pHhxRKevVn8m9yCzL4kDZtBXvTwJUUzmWpeCMrdfDbE6k8uXAPfHlwMnwN6yUL8RvGvSb/FjPShCC+/nP7G5V+mtQZY1F06YfrwsvEV26w8hVzZ/qbBFj8UvveJHP+y+HuU1Ko54+hL5w2dyNcFL9FWXckySz1T5ZoWFBeMBZ2jMu3kpI29yDISmb4PJ/qMV/eJd5Z8isg+Mlwg8orGSykmBgfd44kUZ09RJE8unFgY3m96TYdta5rLlJxYJCufEq8LiyM7lFxOdhXx6E1HQFEbIA+BKlYpzoncN149m8sSdvilAQfCys7CbmXTe+P0if6S7W0L43ALI9tZfKBRpLeRmfX9Z41ScVtA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199015)(122000001)(38100700002)(15650500001)(7696005)(316002)(9686003)(6506007)(26005)(2906002)(5660300002)(41300700001)(52536014)(8936002)(82960400001)(86362001)(38070700005)(66556008)(66446008)(66476007)(66946007)(76116006)(8676002)(4326008)(64756008)(478600001)(71200400001)(186003)(55016003)(33656002)(83380400001)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UQGIqWQSIW94V8prVD6FhGxr2OM1y0R93ZCwUd4ZCblJxqQZn3jVKcuIP9Dl?=
 =?us-ascii?Q?xAto6I36sNIG9DO8PdDFF1OqIxuohVwXRonsAvcyrlSx+rJqM8txf1uBXXoU?=
 =?us-ascii?Q?KAjZNqe8NymLkk+WKuKerLOhIWa+WLCpG0iuIIiSdApkf1+jK45wLXKMP8Gt?=
 =?us-ascii?Q?mTxKtQyYl6omyfYM3oMWPQfjPPyPB/e25rYfj8FNyGXEOIlqBHvrrxAmQY7o?=
 =?us-ascii?Q?c+/JyynyfwAZd1VSCV/OM5lSNa+SUW2j4IpuUR1xXf4lf4M6zlhWwegaYiGS?=
 =?us-ascii?Q?/9AAlzSPiaheVz/ZhVhB8ik0S/zc5n5foLMnhdZnuoIMbD0ufkAhGLIBpN+h?=
 =?us-ascii?Q?EBQShG1mY5ifTXhfj/39JRTDGradbw9wvSx+B0cAJcid5egeZp5gFYe4sJdH?=
 =?us-ascii?Q?1RtAh6v2Sbt/9BUG82aqK5SL/nlYn9sB8sPtZ4jgb0Do8gW1BV75RWfPLaCj?=
 =?us-ascii?Q?0KUxCGpjmRWvME9W55jd0cE8nnF+SWvzK1qNM07NINJbkJYNKCJHAg92jBoL?=
 =?us-ascii?Q?W9bRQch/x1zU7DzX0Dz9vDC6svYCGUQT6m9N8uNMYvwMe9Ky0e1yD7jtZNOO?=
 =?us-ascii?Q?iMGEYUUYizNUm0av2emXi3C6Xdyj/2j736t2V126dwn8Y6nzeZZ27VKXWISM?=
 =?us-ascii?Q?ia4dOJWNQ3LMHnt017Qwi6K+z7+eL+MIEpFv0o4PbYUZGacclXzFgPXbjBQ/?=
 =?us-ascii?Q?cvOmsT38OHqraJuSLDK+iNPh3++BTwmbudUQstKoPRGpNbQw0Q1mpCaYFWSm?=
 =?us-ascii?Q?V9JmbeqQUbqPDK6l9aCdSU9Ld86Po1IRooPC4y6PCo4hhxmb4bhi4uGsuPvG?=
 =?us-ascii?Q?p1gJZ8nQVwo3uNo6A0dRIqpbQhwO9QdYMyu82UlIwPXht/ge7iJWCxstcNzA?=
 =?us-ascii?Q?toKgdOk8+fvvsZyhhXE774aiJ25bZxQTW9Q0uNG7i3OXBju5zYKY8UcFXrMC?=
 =?us-ascii?Q?sHncSsvNEMpPRyCe5wHqWRzZ6wh/GN8Ayt8uWGkiJA0BcVZ/vWLCBEPqLt2t?=
 =?us-ascii?Q?qfpQgLuOijZrsNF3vG+ghhrO2n/uKRgkbiq2Nub+59G+aw62A0jf2HFcL4Ek?=
 =?us-ascii?Q?cViDk6D8x/L1l8SxuQG2WyDtLaSizui5oeguUrBPzWhWtlAtegJAnPhsgJWA?=
 =?us-ascii?Q?h27TuyRfV6KPXZlrvjJorKzWytvNKCujiFZW5/i4Duk+xdopHdLVg7yY150p?=
 =?us-ascii?Q?HwkPSqNnXwh55c9dyWy98CZEnID2+KnMN3MiZqHSmXBja32/OsSA3bGIR9wT?=
 =?us-ascii?Q?I9Oh5ZvmcTSxKqyaruwOUFKogeEwxv03lUNMtvLmLZdoZNZRxH7vUY/VPLF8?=
 =?us-ascii?Q?xognk9PCXvg5vW4hgv2rde2nGJQ4QNqbAiq468eafyXS6BW6Asd8VamK6/+q?=
 =?us-ascii?Q?ASOWyXwqwpR/E4XoO9eyqyXNOpuBX/n9Y8egVDz7lj5b8Rw93HhIt/xVi0Xz?=
 =?us-ascii?Q?yZ59mw+spF0KctKkFj9fB84apZuK1D0EqCaeqBCOJkUa220dh5tez6WkPcc7?=
 =?us-ascii?Q?wiTIoz4/6MX307BJfUi2BF3qjh0aksE7Sbw3oYNvhWh4yZayEHmq6CPkXAmZ?=
 =?us-ascii?Q?Ptt2SC9T/Z+SMxvibO3EnjYDMPkTte5qyw9xKmPm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a9fb9ed-f3f0-4a05-a718-08dacdeaa2b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 07:08:06.1732
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 02ez8RCbUWvpjGImnHeor4O3hyhDmFmSBemsC/Chx40HzfOhW6D5HMT5HNtQWnu6AVb83jGLwXtIhgraFRbWFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6351
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, November 23, 2022 9:49 PM
>=20
> From: Matthew Rosato <mjrosato@linux.ibm.com>
>=20
> vfio_iommufd_bind() creates an access which has an unmap callback, which
> can be called immediately. So dma_unmap() callback should tolerate the
> unmaps that come before the emulated device is opened.
>=20
> To achieve above, vfio_ap_mdev_dma_unmap() needs to validate that
> unmap
> request matches with one or more of these stashed values before
> attempting unpins.
>=20
> Currently, each mapped iova is stashed in its associated vfio_ap_queue;
> Each stashed iova represents IRQ that was enabled for a queue. Therefore,
> if a match is found, trigger IRQ disable for this queue to ensure that
> underlying firmware will no longer try to use the associated pfn after
> the page is unpinned. IRQ disable will also handle the associated unpin.
>=20
> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Jason Herne <jjherne@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
> b/drivers/s390/crypto/vfio_ap_ops.c
> index bb7776d20792..62bfca2bbe6d 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1535,13 +1535,35 @@ static int vfio_ap_mdev_set_kvm(struct
> ap_matrix_mdev *matrix_mdev,
>  	return 0;
>  }
>=20
> +static void unmap_iova(struct ap_matrix_mdev *matrix_mdev, u64 iova,
> u64 length)
> +{
> +	struct ap_queue_table *qtable =3D &matrix_mdev->qtable;
> +	u64 iova_pfn_end =3D (iova + length - 1) >> PAGE_SHIFT;
> +	u64 iova_pfn_start =3D iova >> PAGE_SHIFT;
> +	struct vfio_ap_queue *q;
> +	int loop_cursor;
> +	u64 pfn;
> +
> +	hash_for_each(qtable->queues, loop_cursor, q, mdev_qnode) {
> +		pfn =3D q->saved_iova >> PAGE_SHIFT;
> +		if (pfn >=3D iova_pfn_start && pfn <=3D iova_pfn_end) {
> +			vfio_ap_irq_disable(q);
> +			break;

does this need a WARN_ON if the length is more than one page?

> +		}
> +	}
> +}
> +
>  static void vfio_ap_mdev_dma_unmap(struct vfio_device *vdev, u64 iova,
>  				   u64 length)
>  {
>  	struct ap_matrix_mdev *matrix_mdev =3D
>  		container_of(vdev, struct ap_matrix_mdev, vdev);
>=20
> -	vfio_unpin_pages(&matrix_mdev->vdev, iova, 1);
> +	mutex_lock(&matrix_dev->mdevs_lock);
> +
> +	unmap_iova(matrix_mdev, iova, length);
> +
> +	mutex_unlock(&matrix_dev->mdevs_lock);
>  }
>=20
>  /**
> --
> 2.34.1

