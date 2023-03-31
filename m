Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787B56D1DA3
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 12:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjCaKJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 06:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjCaKIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 06:08:49 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB1F1BF7D;
        Fri, 31 Mar 2023 03:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680256984; x=1711792984;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WyCOoJO7nr7+75jNKhZUYWeS+EfqKNFMNHxfqD2vuZE=;
  b=F0Y5SPVZTDXYlGUnKlwArrzuVHKvFI6voXZzJAyZ//ejAcETUCfOhPqV
   z5GZWIBRh1kAgkgkTg8Vro4iO0ftUhwkOfMHgETViB5hfVkCnIC4yQi6T
   Dtg0Ea8j7PiH0fODUsuEtLQWigJZ4kxb7ki4cxHzitnHW0EUh62yaEsgC
   isvFaY4iimQD6esCM7x9HkkrrkO1TNk5hnOo9fxs5MKlv+LkkTMw98mg9
   Gr3oSt5DB23sp+sgw+59zzgJY3vaMOeBLKn6q6yeTlJj0ifKXcVmOCM3Z
   UIu3QvUM1335htypWCQeaXh5iI7n4Pn7hJkdcR/l0dE9M54mf4gtDMSnm
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="329946982"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="329946982"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 03:02:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="859267676"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="859267676"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 31 Mar 2023 03:02:41 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 31 Mar 2023 03:02:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 31 Mar 2023 03:02:40 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 31 Mar 2023 03:02:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RIV5CVywuQMb9BXY1PEOFLcz7pEZDa6V8jtRO3deVh79566+pHID4jv1OlcYD43/ula2xQu20Edl3hL9ck/Q02iPiiMLGI2DjYSORWkxTepbsmRGGKyLP4d9cPWGUg4E0IRVesviwqYZh5e/FdW/JUDC09z6+yBvLvaSU2tcifueTJ27zbX66X3Y6WEeGtUOHYbNCcVXp6IZq1pHdcGN/ap0kF0mneTEYQng7kuzXxC6UJ489eQ7UwWelQx7K8hFV3pXroaCscN7D9IGrzetgjlM9Y8ltY/3m0cAZ/1pzg2ETbXOxoeClUlAskoAo85jCDVUhp6A54V/GfBzyTvs1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GtaP60UiTCXCv0ZbL0UekUfjGN67sHD1eP4GbXTUu/o=;
 b=GSjaSQUUxpjb4Y4FG0uF4ZWPgQ6IuQGYq6Fo9gzRhGPcNeQwo/qRqdrygyWEXjoTjOx27xFCma5r9kelFCQPFdQW6v9mapfFbRKtuN2U/XzPSSYW21iQSy7Eiim8ugcPVCBbBafAZk5FZnNxHFbw4gdWO8j2+emRmjh8By6hXWcYOzMkTlmVUgdQVUIquN5COzVQutK+u0fo5gGQSKlzTUXjejH/JMvCEUTO/E1ij4Uk0nDmWwp0+8TcIlXWjdwCvSYM95W5Qyh/uW3EOUYRTTBpCRvnUJ4MtGl8Naa/sbVbHjSzCzY2c/B1EWZy7t2JwzTLXtnA4RH8d6ySU83pjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1245.namprd11.prod.outlook.com (2603:10b6:300:28::11)
 by BL3PR11MB6313.namprd11.prod.outlook.com (2603:10b6:208:3b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Fri, 31 Mar
 2023 10:02:33 +0000
Received: from MWHPR11MB1245.namprd11.prod.outlook.com
 ([fe80::174:6bb9:46fa:f97e]) by MWHPR11MB1245.namprd11.prod.outlook.com
 ([fe80::174:6bb9:46fa:f97e%11]) with mapi id 15.20.6254.022; Fri, 31 Mar 2023
 10:02:33 +0000
From:   "Liu, Jing2" <jing2.liu@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
Thread-Topic: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
Thread-Index: AQHZYb/Rk3to+fQWNUmPjc7xA3v1Mq8UqOiQ
Date:   Fri, 31 Mar 2023 10:02:32 +0000
Message-ID: <MWHPR11MB12456636D269F997D1812FF8A98F9@MWHPR11MB1245.namprd11.prod.outlook.com>
References: <cover.1680038771.git.reinette.chatre@intel.com>
 <419f3ba2f732154d8ae079b3deb02d0fdbe3e258.1680038771.git.reinette.chatre@intel.com>
In-Reply-To: <419f3ba2f732154d8ae079b3deb02d0fdbe3e258.1680038771.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1245:EE_|BL3PR11MB6313:EE_
x-ms-office365-filtering-correlation-id: d4bfdc6e-b8e4-46de-9787-08db31cf0b9a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RIT7ddd0/vNjidyjI5W09+uk8f/qZEOBdoEl5W9+0T5iTnO+OrnLeoUFzIEqCMnvhY7zLLBgiCQ10XaHcfb5F22VK/cqzCTw1vTithr36Ou1p2oOmEBxyd0CJK0qSY5yTOMRprFkkQlMmN5G1g2uQiFJGWBwjsouenBxR6pyd8PJTkGnjM0gHYAwYz3hKN3algnDT7Biqe9FF+WLpqs8FXPE5kjbRMIM9zyElZFNDjGLgSBZ9fGVYmMZ+FRCcoee8APjyBCigoFsAc4IhR4BWqiIkb2PAc2HCqlRb/PgQ9DyrPE6BJMw2yzTS/Y9k+fyF/9FSaI0oWG9nkrTWytNfjiisIf8iWG0n9SJIynKs++aQ2v2kf+6e1lOLmfg+C2VZt2qR8fINoPn8PlIeJ9UY9SdgV85SWIJ3Jmx+EDCDx5MS2j925/gQZpMC8zHdsC2gKPIuf9g4kpWZPPZiwLv+fsoSpEEpFp89ndutXreVQQz2pTpjw1bol2euBkFWOh2bZZwRhlOpANX3iJLuiA2eQwCui1cctiFnpSdsOJ5M8/ZKVqdkfJQt1w1iLAHIDbeMo2Dpb3PKH1KuTfo4w+UVeVgoXmexqYD/+Z0jSegcrwGG3/Acw4sQMOA0LSYxBcs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1245.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(396003)(376002)(136003)(451199021)(33656002)(26005)(6506007)(83380400001)(186003)(9686003)(316002)(54906003)(55016003)(66446008)(110136005)(76116006)(8936002)(66556008)(38100700002)(5660300002)(66946007)(66476007)(4326008)(478600001)(7696005)(52536014)(8676002)(64756008)(122000001)(41300700001)(2906002)(38070700005)(71200400001)(86362001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cWNODCImc4BjME25eZvA0XE396Afw7+Tw14/Zq9BfbJT85znGEGKT0jNcWTy?=
 =?us-ascii?Q?SN5b4jr06QEpywIIuzKoEsJkja6TMLxBtu3AGSJwflb0g555nGsfLKqjshqS?=
 =?us-ascii?Q?TEamCtJhPVLDIOvbbX3jtKHKglNVPGe2HZH+KQyD1HxxZRn2qyPXRaYyBowI?=
 =?us-ascii?Q?IMWmNYHx/q9nMv+le/Kf7lJGeXq4TIpSLOip5mkblYDAivpWNpMQRDJC7ov5?=
 =?us-ascii?Q?bExWV5YjBBJ5uzEupeScgnrj6tSxE1FplwvgxVk1qD9TTeYCPjAw1qsKGj6Z?=
 =?us-ascii?Q?49DcRAW2pJH37PBbxOboYE8vHWErQSr96Gg1Az61b2syBZozVZVl/e9mEWx3?=
 =?us-ascii?Q?eoUs0a9o5eGsS6X6dOU/416D0G/XLQpoyGTj2K3sdbBioRPTIpUmqgAPbcbl?=
 =?us-ascii?Q?YNw/v4dw6ii4r5Y0CEQSESZLuL3HxFdmpgGW+FNGvYn0VgLd0WSUgHqAEt4E?=
 =?us-ascii?Q?0ddATyvyqddlRUM6q5Tg4BfVw9gLjHfYKeN0GPbxmXsL0rKv9BO42qbSQvNz?=
 =?us-ascii?Q?iqWCFPI8EGX91VnjwiDXGS1oKeWOIazlXJq0V2pdjV23TRMMo25TwJ4Iw6Q5?=
 =?us-ascii?Q?7TAAmLrEJpE1BiN/1iDsAqh68DgqaWzwXvwPsz7gEOwBmJ46G7WycJD2H9tF?=
 =?us-ascii?Q?lenYxztmbD7gkSdK5BodVlwmhuyEu8dXCAbp96eh/F5/Th3wchjnURU8ggKy?=
 =?us-ascii?Q?k97HR2JHCHQtpICRGdGVQkYieJGj33Xlqxr1f+jROOzDNKqbpFKRlNdgAuPf?=
 =?us-ascii?Q?yaUGPfudP1zMZ/vk15IsSDyitFRFJuls6I7c4yfZbvuXEU89BMEvJRPs8glp?=
 =?us-ascii?Q?HrJSlfxqj9ok6fHHNQpfDdb3yCkWprszoI+lgASshmZ7h6rbObpPUe3p/Dim?=
 =?us-ascii?Q?qcWSPWxB3ueS9nio2V7q7ksGyO01YJEQ9TU5N4ISUM5qMvXzwzCP/Vbteuzi?=
 =?us-ascii?Q?9JtpGxr/ljfmc27mh3VUUgHR59xBzvzEm+1bypj09+/w5vIif/nX/iVGF+FP?=
 =?us-ascii?Q?/YsrRHvBsYxWnAnsUz2UL4q1/2tZGc7uSTQ1Lf840HyunlzBr2Fq64HJ3qUk?=
 =?us-ascii?Q?AjmBOLDoXEVP5/fYiDHQaJPusNolUxNLSb/QbZ/O6pCu5FT1D9gJikmEmIq8?=
 =?us-ascii?Q?3Uvc5HBE99vcgbzbUCNFm1DQImQ/0bgC9ivSXO21XTeXifkeyjrjumlPQ86l?=
 =?us-ascii?Q?Kh+W6ygJRMaWNPYeism2tFdYI58OBEqEoSd99MqfnJBoRPrcS8RfVRPRCB86?=
 =?us-ascii?Q?DxuxoZJxVF6eMOj0R/TWuqSi1/DnIkWdxTDQetbe3U4pxQJCMNMvvzyfA9+S?=
 =?us-ascii?Q?sYu2eS2bsB8UF7LLIJfHxeFQ21Pgx23uxA+y35cegVIjlvk1tKZBBiG4cJuA?=
 =?us-ascii?Q?l57Elh7Tt4g3Gj0PH+e0p/5vxPU5Gxa2nNLgPxiSTWHYVsx6con1iN9taJJM?=
 =?us-ascii?Q?DBLw31Pr+y1aNLPhCRYhLpzsDph5/++4Q/PPnPV+B41mmqYJZhEGGlKGBxt4?=
 =?us-ascii?Q?tsGF42WIzdOs8oNQHzOujSBUqjDnnFF2/dy+Pg3Y4dEyst02H/rKFndR1VI6?=
 =?us-ascii?Q?ei8wJRTF72nwRv343ZBErjxGriOx0fq2IG+cpozH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1245.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4bfdc6e-b8e4-46de-9787-08db31cf0b9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 10:02:32.5545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: upWJazJjIA66LJ1Lzi5ilXNZud5bSMWWcNyQKMDOxbhIZCn7AeXjNA7agUaSN3uBdzaxcq2qPWpNOG2m5bv9CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6313
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reinette,

> @@ -409,33 +416,62 @@ static int vfio_msi_set_vector_signal(struct
> vfio_pci_core_device *vdev,  {
>  	struct pci_dev *pdev =3D vdev->pdev;
>  	struct vfio_pci_irq_ctx *ctx;
> +	struct msi_map msix_map =3D {};
> +	bool allow_dyn_alloc =3D false;
>  	struct eventfd_ctx *trigger;
> +	bool new_ctx =3D false;
>  	int irq, ret;
>  	u16 cmd;
>=20
> +	/* Only MSI-X allows dynamic allocation. */
> +	if (msix && pci_msix_can_alloc_dyn(vdev->pdev))
> +		allow_dyn_alloc =3D true;
> +
>  	ctx =3D vfio_irq_ctx_get(vdev, vector);
> -	if (!ctx)
> +	if (!ctx && !allow_dyn_alloc)
>  		return -EINVAL;
> +
>  	irq =3D pci_irq_vector(pdev, vector);
> +	/* Context and interrupt are always allocated together. */
> +	WARN_ON((ctx && irq =3D=3D -EINVAL) || (!ctx && irq !=3D -EINVAL));
>=20
> -	if (ctx->trigger) {
> +	if (ctx && ctx->trigger) {
>  		irq_bypass_unregister_producer(&ctx->producer);
>=20
>  		cmd =3D vfio_pci_memory_lock_and_enable(vdev);
>  		free_irq(irq, ctx->trigger);
> +		if (allow_dyn_alloc) {
> +			msix_map.index =3D vector;
> +			msix_map.virq =3D irq;
> +			pci_msix_free_irq(pdev, msix_map);
> +			irq =3D -EINVAL;
> +		}
>  		vfio_pci_memory_unlock_and_restore(vdev, cmd);
>  		kfree(ctx->name);
>  		eventfd_ctx_put(ctx->trigger);
>  		ctx->trigger =3D NULL;
> +		if (allow_dyn_alloc) {
> +			vfio_irq_ctx_free(vdev, ctx, vector);
> +			ctx =3D NULL;
> +		}
>  	}
>=20
>  	if (fd < 0)
>  		return 0;
>=20

While looking at this piece of code, one thought comes to me:=20
It might be possible that userspace comes twice with the same valid fd for =
a specific
vector, this vfio code will free the resource in if(ctx && ctx->trigger) fo=
r the second
time, and then re-alloc again for the same fd given by userspace.=20

Would that help if we firstly check e.g. ctx->trigger with the given valid =
fd, to see if=20
the trigger is really changed or not?

Thanks,
Jing


> +	if (!ctx) {
> +		ctx =3D vfio_irq_ctx_alloc_single(vdev, vector);
> +		if (!ctx)
> +			return -ENOMEM;
> +		new_ctx =3D true;
> +	}
> +
>  	ctx->name =3D kasprintf(GFP_KERNEL_ACCOUNT, "vfio-msi%s[%d](%s)",
>  			      msix ? "x" : "", vector, pci_name(pdev));
> -	if (!ctx->name)
> -		return -ENOMEM;
> +	if (!ctx->name) {
> +		ret =3D -ENOMEM;
> +		goto out_free_ctx;
> +	}
>=20
>  	trigger =3D eventfd_ctx_fdget(fd);
>  	if (IS_ERR(trigger)) {
> @@ -443,25 +479,38 @@ static int vfio_msi_set_vector_signal(struct
> vfio_pci_core_device *vdev,
>  		goto out_free_name;
>  	}
>=20
> -	/*
> -	 * The MSIx vector table resides in device memory which may be cleared
> -	 * via backdoor resets. We don't allow direct access to the vector
> -	 * table so even if a userspace driver attempts to save/restore around
> -	 * such a reset it would be unsuccessful. To avoid this, restore the
> -	 * cached value of the message prior to enabling.
> -	 */
>  	cmd =3D vfio_pci_memory_lock_and_enable(vdev);
>  	if (msix) {
> -		struct msi_msg msg;
> -
> -		get_cached_msi_msg(irq, &msg);
> -		pci_write_msi_msg(irq, &msg);
> +		if (irq =3D=3D -EINVAL) {
> +			msix_map =3D pci_msix_alloc_irq_at(pdev, vector, NULL);
> +			if (msix_map.index < 0) {
> +				vfio_pci_memory_unlock_and_restore(vdev,
> cmd);
> +				ret =3D msix_map.index;
> +				goto out_put_eventfd_ctx;
> +			}
> +			irq =3D msix_map.virq;
> +		} else {
> +			/*
> +			 * The MSIx vector table resides in device memory
> which
> +			 * may be cleared via backdoor resets. We don't allow
> +			 * direct access to the vector table so even if a
> +			 * userspace driver attempts to save/restore around
> +			 * such a reset it would be unsuccessful. To avoid
> +			 * this, restore the cached value of the message prior
> +			 * to enabling.
> +			 */
> +			struct msi_msg msg;
> +
> +			get_cached_msi_msg(irq, &msg);
> +			pci_write_msi_msg(irq, &msg);
> +		}
>  	}
>=20
>  	ret =3D request_irq(irq, vfio_msihandler, 0, ctx->name, trigger);
> -	vfio_pci_memory_unlock_and_restore(vdev, cmd);
>  	if (ret)
> -		goto out_put_eventfd_ctx;
> +		goto out_free_irq_locked;
> +
> +	vfio_pci_memory_unlock_and_restore(vdev, cmd);
>=20
>  	ctx->producer.token =3D trigger;
>  	ctx->producer.irq =3D irq;
> @@ -477,11 +526,21 @@ static int vfio_msi_set_vector_signal(struct
> vfio_pci_core_device *vdev,
>=20
>  	return 0;
>=20
> +out_free_irq_locked:
> +	if (allow_dyn_alloc && new_ctx) {
> +		msix_map.index =3D vector;
> +		msix_map.virq =3D irq;
> +		pci_msix_free_irq(pdev, msix_map);
> +	}
> +	vfio_pci_memory_unlock_and_restore(vdev, cmd);
>  out_put_eventfd_ctx:
>  	eventfd_ctx_put(trigger);
>  out_free_name:
>  	kfree(ctx->name);
>  	ctx->name =3D NULL;
> +out_free_ctx:
> +	if (allow_dyn_alloc && new_ctx)
> +		vfio_irq_ctx_free(vdev, ctx, vector);
>  	return ret;
>  }
>=20
> --
> 2.34.1

