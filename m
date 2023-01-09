Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C40B661F6A
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 08:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbjAIHrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 02:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbjAIHrJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 02:47:09 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D1C13D0C
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 23:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673250428; x=1704786428;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Zs7xrFUElb/mMRmu4vq/7Q5qf8saUxACFlsehUWmQHQ=;
  b=gqTLik2kVs1NroQsDHRS8FYp7jcl5wg1qdfVyfR0k0d6CmE2sNZt2XvN
   WhG/xp+9T+lv0BeeZDXGeqFzsEtPo0Uzn2GvIhBY6maxyfxHuf1+UqE6G
   sUKqG+B5MQJ+Iwux4Dkfz1Wy7RD5lFvQJ0891wckNNel/wUQHgq+7z912
   DKLkxyDl1nClQBhn8GdaqOq/vFpPzxhwI0MHmQRvFaygnZwUSPHm34msa
   60pBGsdoKZ9ag5QimJmt2Wjo2r706LJHtf6DeJtnzzBUb8o6ivvYsBvFo
   3XmNvwGlmI/sZWNe7ZPo3w0YAYC67sal5uIGRIJcf/bfdEGGs6PPmdnJz
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="306336458"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="306336458"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 23:47:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="830513846"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="830513846"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 08 Jan 2023 23:47:06 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 8 Jan 2023 23:47:05 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 8 Jan 2023 23:47:05 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 8 Jan 2023 23:47:05 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 8 Jan 2023 23:47:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=De2xWVNSZ7yGY5TWBiWng6tOhlt+Y0HLfIHbSnpQG/Yfnz2GkY4nQGhrXtzhgPTtYKqMPtvgygh+YLOVNWHJyAYcOBSdgv1P1JsCa+cjnRLZQ7xP6dZDFtUbhLShhQ2wloOUcn4U6vOVoNHKi7fnE/QH3z+c2VXQAWyPhzNCRQ4PlCZOLyfWHN57/f9Bhcb4pMiiatfnp74fPbeQOvqibIdFbJMfsnq8x2uVoabMVyFaINIfBlcNl23/DuyTqBCKtwxG9Ph5SoeNORJ6tZiA/MqlGYdsN1r9Pqn8K7iJKiFlISkLt/e0GejYPgo+TEnVm6V5PIrCNNZIxlUUj9Q5Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=by3Z+c8y5XqzlcWSawVQtYTfU3P3ojd5LLlwyUcGsos=;
 b=OrUrFVwFi5HgELZLYoJSEEpUhDPopLPtU8F3sgoG8YogYxBTgi8SjNPHrl9Yt1Mmw6IqTx0J/VuLS8w4Ouhy9BRQ//ebSUxl+yJaE8pRo88F2aaR1H6K8IMRFnMzK+zWbc4UOwYR//CDtS7NTWYFi/eJtspiTJFptMlULKGWPA1vN8zfg26UXrZfGApzZgTS0woFhPJTnqj1JBmCSD8CplbcTC8zTHicYzHYYKS+evUmmApvgOaxB3PEZp0x17flL0yM67xC/OhDt5aR2Ti6UF3Zc2ySwhTJr9aZomPhY7i10yG/fSLk6FCO49DyCLM1xjblvNIPG8IDiow6y5dH9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB8069.namprd11.prod.outlook.com (2603:10b6:8:12c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 07:47:03 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%7]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 07:47:03 +0000
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
Subject: RE: [RFC 11/12] vfio: Add ioctls for device cdev iommufd
Thread-Topic: [RFC 11/12] vfio: Add ioctls for device cdev iommufd
Thread-Index: AQHZE4aW3uMKS3SxukmckGIex8c1c66VzEJw
Date:   Mon, 9 Jan 2023 07:47:03 +0000
Message-ID: <BN9PR11MB5276E47BF63C4553DD4C0F4C8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-12-yi.l.liu@intel.com>
In-Reply-To: <20221219084718.9342-12-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB8069:EE_
x-ms-office365-filtering-correlation-id: 6074dc33-fbaf-42db-a6ac-08daf215b2f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cL82iYXi4QVuXId5aISw4RLzkXqpOzEejJ9JvN3gV1U9u60+bwoAAa+VBRftAPHGNlagNir62GE4OO2T5YzWY7kXYy2Iod0/plZkgzaxmV7ukb6ZGf/5+KdpUOIqnY4zarxHoQ3yN3LgZNdvGMXKk5JlgLdU3gAsO4+jKs/Nhg5XH3MDA+rx4EiO6hvzVMR1ptzelmaXBrJRUJAS4G4vQbJLIkgW6ZabsluW16/DUsJjcI50qFM4pWr2WJKABoFJqQC+pv7+3WPEkqEYo2JhM4+mbceqvMZqLebNaZ0PV/u+btvNZZCSq66M+sHDZCNLxqX2OPI/wD7iCfC2migpiJhxyUT/8nvpD3WLhysSU1jRRo4thQE3lJSaCAZXI4C4nzAXoz+JSjJosaKVo4VH/rqT7NzcNfTaQKAwCmmTabd33BV8RQJ9A1qnzVo+fe/Uq1OoUhXyE/SXOYbf0YuohXLrM3BbnEEcdbiX3q+0nhkB9NNUGq7kRkJVwzVPJEudDDIpTcTaxNoyPYUSLccbLCpdDyrGT1MeP3GR9ZKph9GzBvcgms6f3gV5gJpmsqo+uc9a22L/1kP8yJXnGjb0BQaHRogHectSsN2KsOsD16G0/KFWEbEKlO2MNG2dwH14mT6dnlBhbyu0KS7NAUSVMx8DtAcyWrFMnCNlSvSRHcbKoL6RmiaqPPi68gks68OpikViIRqdyivh7D2EYMeQww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(346002)(376002)(136003)(451199015)(8676002)(76116006)(66476007)(4326008)(64756008)(316002)(66946007)(71200400001)(66446008)(7696005)(66556008)(110136005)(54906003)(38070700005)(2906002)(5660300002)(8936002)(41300700001)(7416002)(52536014)(86362001)(83380400001)(6506007)(82960400001)(478600001)(33656002)(55016003)(122000001)(38100700002)(9686003)(186003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Mtjj+EXGbFfgEDeXl4Loxjj4AGarM1NwB668OagakBJTepTxS3c/kcRc40Yz?=
 =?us-ascii?Q?Ilh0lW8+aIx0LQUAYYt2Py4qF3GcsuJJMptnFvpFU2M5w1HNec8YCA0aN0MB?=
 =?us-ascii?Q?db5Q6ntbZYQubONlQ08hrJnA9VrIapFGvcVpj4RCBQeq5yJCRBw5xMJK+VJY?=
 =?us-ascii?Q?pmFbvLg+CSQs4YmAFVcFxHiC8Ft+r3/LOCYV/kVUUipqFENFBBifVTQadXTk?=
 =?us-ascii?Q?1wMJl4/A6xGQutBuLfhvfbvkee2tiFoAEsSNuzVshmWvqYRyHp6v9/8K7Yen?=
 =?us-ascii?Q?jI4xKAdU+cLg85aRViZTFz4gIR6gAPPKiX3LrLMx1OZyNhee+1RR68CG+M9Z?=
 =?us-ascii?Q?FMXkJ/uUrVVoz74KTf1QaXb6NwR5CvFx9h4rOU5UpmopJUy+gafRV/hbkoWB?=
 =?us-ascii?Q?PfUgryBu6CdgjivGUKjuC1APs2lFdmXcLADROPdxpteybmc0T1gW94ib3cva?=
 =?us-ascii?Q?23cm9bhhskCtPogl5AiRl7vkRD4Z7C5T1fIYx2RLzx1EL6fcKogJHWcEYPwl?=
 =?us-ascii?Q?iYYmmh9w7IjpZLrDF+NYJoL0kW7UOsdGWq7sEGUZrEjRmFnc1JCBVZzSMlhG?=
 =?us-ascii?Q?CSvF3nSlGhjJvUJBVD4Q6oZXFuRG0ACykksSycC+OtpPkxfkSydY44WYF04U?=
 =?us-ascii?Q?5SokLTUzGTIM+Yv5/eEr2bZ0IetUISx1flAtiSKFWvc4ou9x4G1SdJRV0hyO?=
 =?us-ascii?Q?3kk7XksN7MLLDjuD53Weie3UlEDUKhnpn4ljDa10EWKhoFPX5r3BihMD4Gtu?=
 =?us-ascii?Q?dPUcI3asTV8r7E4w6Vy5OvpcxqkzZmvKli0PgQv3yUEnsc8R63UfzAyH7Zsk?=
 =?us-ascii?Q?HHF2/h+75nIsF5tIfSHSauN4X+obLt8auldSuN/vdq8ztyR2OCUAWv8Ogg+M?=
 =?us-ascii?Q?ygW9ufwerBDuGYQmVCpfiLdSSazraeqStnwOHt+NtURWSe+kmjenpxgFg0Jx?=
 =?us-ascii?Q?YppJcJ9hqV3zr/h7kyyrzEc26cD3NTR4yVSYPUbTXjqYo9rdWxqkpN6NDXvW?=
 =?us-ascii?Q?oB/f5nNIAbXDHpeOr5d6Yz13nf6r+nw+n/7ji9PL/1okyqyGhZ7u7wmgGFTT?=
 =?us-ascii?Q?ed+8DTqPruJR279YSuFGBoTppNyD3GocnVTXjJc5FselrWQMZpvAGVmHWvVi?=
 =?us-ascii?Q?7Ui8u2sQecxEZWekgK9IlxmOzb+EakDwxMMPFki1b37r3O9gED4Rh9VMflwM?=
 =?us-ascii?Q?cZJ/UgP0lru+kQ/Mu4vqooNZv58/Z2SL0A86V0LhAMJ0Ao8bopFg+6sm6O2T?=
 =?us-ascii?Q?JSubHE0fTjBw8YsxjMD8LmB7kg25H5RmCzfmHa8tkIGZLLXicNOVcyDTi6nu?=
 =?us-ascii?Q?4I5VKi+u/IeSNLSOgmlwFeSw2B47dn0I7Qa0SzOTFicK0oTA+gNApjK1ATiz?=
 =?us-ascii?Q?ZX9FIQsPVm/TgoDhcqAdLRYmTQh2RR2tX1vSv4b5C1+HQdwAPOGp9DeUvkE4?=
 =?us-ascii?Q?T2LHsfJiZr2beveZYDcjBJqdKdw/aezWXu8ELZyUtxEZ+FYSLtrAuRzmCdhB?=
 =?us-ascii?Q?ge2/kTl7Bl1+GhXNgfc8KUbj2we1JHU8B0EF3O+oneoWLB78s0KPhpRKQmNT?=
 =?us-ascii?Q?0casMQC7rxviT0uAUHjQQoJsTM2vRdTLzrt9wAa+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6074dc33-fbaf-42db-a6ac-08daf215b2f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 07:47:03.6294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lth5liJX5vasyyn2Ew8DP9d/gu9Wdyd8iMd8RHKG/Y4SLbGsoht2abv9/9GizVurlzlsKN+SJPqQ5XlQ/KpA2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8069
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, December 19, 2022 4:47 PM
>=20
> @@ -415,7 +416,7 @@ static int vfio_device_first_open(struct
> vfio_device_file *df,
>  	if (!try_module_get(device->dev->driver->owner))
>  		return -ENODEV;
>=20
> -	if (iommufd)
> +	if (iommufd && !IS_ERR(iommufd))
>  		ret =3D vfio_iommufd_bind(device, iommufd, dev_id, pt_id);
>  	else
>  		ret =3D vfio_device_group_use_iommu(device);

can you elaborate how noiommu actually works in the cdev path?

I'm a bit lost here.

> @@ -592,6 +600,8 @@ static int vfio_device_fops_release(struct inode
> *inode, struct file *filep)
>  	 */
>  	if (!df->single_open)
>  		vfio_device_group_close(df);
> +	else
> +		vfio_device_close(df);
>  	kfree(df);
>  	vfio_device_put_registration(device);

belong to last patch?

> +	mutex_lock(&device->dev_set->lock);
> +	/* Paired with smp_store_release() in vfio_device_open/close() */
> +	access =3D smp_load_acquire(&df->access_granted);
> +	if (access) {
> +		ret =3D -EINVAL;
> +		goto out_unlock;
> +	}

Not sure it's required. The lock is already held then just checking
df->iommufd should be sufficient.

> +	mutex_lock(&device->dev_set->lock);
> +	pt_id =3D attach.pt_id;
> +	ret =3D vfio_iommufd_attach(device,
> +				  pt_id !=3D IOMMUFD_INVALID_ID ? &pt_id :
> NULL);
> +	if (ret)
> +		goto out_unlock;
> +
> +	if (pt_id !=3D IOMMUFD_INVALID_ID) {

it's clearer to use an 'attach' local variable

> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index 98ebba80cfa1..87680274c01b 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -9,6 +9,8 @@
>=20
>  #define IOMMUFD_TYPE (';')
>=20
> +#define IOMMUFD_INVALID_ID 0  /* valid ID starts from 1 */

Can you point out where valid IDs are guaranteed to start
from 1?

According to _iommufd_object_alloc() it uses xa_limit_32b as
limit which includes '0' as the lowest ID

> +/*
> + * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 19,
> + *				   struct vfio_device_bind_iommufd)
> + *
> + * Bind a vfio_device to the specified iommufd and an ioas or a hardware
> + * page table.

this is stale. BIND now is only about bind. No ioas.

> + * VFIO_DEVICE_ATTACH_IOMMUFD_PT - _IOW(VFIO_TYPE, VFIO_BASE +
> 20,
> + *					struct
> vfio_device_attach_iommufd_pt)
> + *
> + * Attach a vfio device to an iommufd address space specified by IOAS
> + * id or hardware page table id.
> + *
> + * Available only after a device has been bound to iommufd via
> + * VFIO_DEVICE_BIND_IOMMUFD
> + *
> + * Undo by passing pt_id =3D=3D IOMMUFD_INVALID_ID
> + *
> + * @argsz:	user filled size of this data.
> + * @flags:	must be 0.
> + * @pt_id:	Input the target id, can be an ioas or a hwpt allocated
> + *		via iommufd subsystem, and output the attached pt_id. It
> + *		be the ioas, hwpt itself or an hwpt created by kernel
> + *		during the attachment.

Input the target id which can represent an ioas or a hwpt allocated
via iommufd subsystem. Output the attached hwpt id which could
be the specified hwpt itself or a hwpt automatically created for the
specified ioas by kernel during the attachment.
