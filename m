Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32EE550212D
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 06:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349349AbiDOELe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 00:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238722AbiDOELb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 00:11:31 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A84A8881
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 21:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649995744; x=1681531744;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=13vyS1D80l4QmtqeEaAsQlbMKjOIrQhSAt9k1FwFIHU=;
  b=TOUpXnlDIN5uUn07hieCk27TpUsJ8y8GKZLyu/Mgh6wg71my7LcSgO4G
   Jw2ti0XYsT0no89dPFxu0yVMNHr6cyhNYjALr9FH6Av5IqAkrTcBUA+vt
   RjhSkIpugRUqt9G6UPLYGJmCcPJMPx8YKQS2g8PMnE77BoEDqJvyuIpEO
   m69hg+d0WFKVDn1lfbcQTfV2856TnT0MRLzXQtAlHvXD/8CQ5jBx6xWN4
   +JSpxrfcACN1MxLD3i4mX5qnV0UzNhYnUIfuzQLFOcLchjPRXC+yUxulO
   46yQ3cS7selUiwp5P5hIXABMsDJdrLc4dSWv35Qy+0AyMkbfkEREHjOjB
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10317"; a="262842119"
X-IronPort-AV: E=Sophos;i="5.90,261,1643702400"; 
   d="scan'208";a="262842119"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 21:09:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,261,1643702400"; 
   d="scan'208";a="656249872"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga002.fm.intel.com with ESMTP; 14 Apr 2022 21:09:03 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Apr 2022 21:09:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 14 Apr 2022 21:09:02 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 14 Apr 2022 21:09:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2znrlNYOIOlvgsd/rfk3S106Xjmy4KEURTkW0w6cnjCiwMUmAqG0QH8BFtA7GjDzGo+RvlNIF8uk+jd65sJSr8UtNnGDGWum6akmdmsxk6Sb+QyhJeDmMXBj5IoACr5kTWzzJx0A7vXq1D4mdwWePTAyF4zo1GT8BlzyCwnVLLZoAqVIoN74+YUkqMQ9PIIYa5VbvockF8Xq5fooGQ/aRwNDNOhJueBzappi11br8NmRde3wf/YQRE7nF76adwMSpwkf4K6j7xw+eE3Y1P7X4Wi05+288HRDEs1SOkeBvGLSyPhAQ0e1FzqEa4M1zIA6/fb+XdK0DYhkUdvb97oKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=esgZGHl1PLZJEZkhGP/z/9hQRNwQ4RwTH3Lf7nK5mFg=;
 b=Lf62oRT8Mi/WiKitewDd7OEUTxj9gZb+ch64TujXmNivyVaqjhN1AXGOVrgMcBqmnUS81iR9/nTCrSSaT++eWi4ZOEZBNjnrkjTDA6f8SBSbbLveIZSLZPXBbIY31sSOcEXMd7iq4v33nPBj2Mt4LrPxtEmOHbPZohGTHtAHVjoZdDpcrN5oxOsuIm/1CVJGikHdkFiRAmMaKQlIEyRagFPuSCrab3QB8kuMpWlrcak6ePtLMIphZg0qYcBW+AXTvOcteszFpJjvj0rkiw7yHKjd6d8xdE28Esw/bvC3tM9LqA6sBFoinFOVLxr3e5GMqs11XRw1z9xM6Cyo2KU84Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW3PR11MB4761.namprd11.prod.outlook.com (2603:10b6:303:53::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Fri, 15 Apr
 2022 04:09:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%8]) with mapi id 15.20.5164.018; Fri, 15 Apr 2022
 04:09:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 08/10] vfio: Move vfio_group_set_kvm() into vfio_file_ops
Thread-Topic: [PATCH 08/10] vfio: Move vfio_group_set_kvm() into vfio_file_ops
Thread-Index: AQHYUDAP4wsyFZk+sEyoC/z6/O3tTazwXJ0Q
Date:   Fri, 15 Apr 2022 04:09:00 +0000
Message-ID: <BN9PR11MB527688E7DE70DC6C6E7AB68B8CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <8-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <8-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 527f98cd-6dbc-44f1-528c-08da1e95abfd
x-ms-traffictypediagnostic: MW3PR11MB4761:EE_
x-microsoft-antispam-prvs: <MW3PR11MB4761AACD05D6A8C8E14A45E38CEE9@MW3PR11MB4761.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z5f24jXRPCpvE4Mijc/f1pT7PXjJPRUD/enGHhfhbdXGD5bwHg0+9Q6E80s1klJu/0LqhMURM8K8KKs2wAfZJqfZJ3s+vUr+PE+nxw8R9rV6IuuRQP5rYidqxG4VLq1cNj55TBZDiVvWfIM/XUI3HCTp/VYwg+NeXUNZiLcCCFy/rG0GfOYQ/sjwLjfzfWWGjSp48wonkZbaoncZ54opKWAcWzZnMYRni3KAcSXazkuFceHSxRKn31+AY9+wYUrrnnyA9X4mE2fxmuHbCHzk8wZg219DWZ/RsDEueGQcWEq0wTtokB/QgyraL2N4Dbh9Y6eqWXFW48YMGP0LFr+aiHksU1CAm04cx1BR9GP+vAaRIm/O15JQEbymCvPpZtofzfXzUf4e6kM/lOir48zGN5cKFep070bU1a7lN8RnVU1KbAdX0gd9tqbs6eucLf+kqh+MaNHOpWcn+5zK19T4dDFwf516uTzF19u0w/HyVdDkWVEygyIt6yrcnYYFK9Rv7mDfXK6hepfo5ZbA4wLWyn02fSJU+TjaagJHgg4hEWHldtI3G17Z1UoGzIH+HvIm370Br4cdZO2hMCJ8s4ju4VinU4FHE6sa2zjKSNeTftf92uL1rjgQdIC7pdRX4k47tXRVFtDoYkQQadBvAyYwrAlMb3JAK6A9U2IX+Lse9BaISUR163s46LnBIU1gzdHomuvV9bTunBTXV5nyxXv7XA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(83380400001)(8936002)(33656002)(54906003)(66446008)(66476007)(66556008)(316002)(64756008)(110136005)(71200400001)(38070700005)(66946007)(76116006)(4326008)(8676002)(86362001)(508600001)(26005)(2906002)(186003)(107886003)(52536014)(55016003)(82960400001)(38100700002)(122000001)(9686003)(7696005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n9O1OTs+4VAcO9buwE0SolQV7AtDrWNjyuSmqCzzJmtyU3jni54ypmQLd2vK?=
 =?us-ascii?Q?ULOb5zK9S7y6bT12qZDPuRMQOL3MsYKqCkPbqKqPjAAnjNRdcB38/NiO4Fmw?=
 =?us-ascii?Q?MjNhtU26fV6UzkjcqpOrx1yx6t2srHZ2wZR1pCWk8yD2OY63NZ+wSwf4BGxd?=
 =?us-ascii?Q?5JKKTZkDMMf/gBszrY36EuDoUDg8NFJRF7gBSvjmBAPInWcmbEukCQ21q6m9?=
 =?us-ascii?Q?iDxMK8W7HEWdI1kmEmLKkfTZU1RKht12Xz4iINsvUyv8O+zt0BvQqryTZPTW?=
 =?us-ascii?Q?NkdsiO3JBMUjVoBYIB1WUieHZSYo52YfRA4GvJvPkdD/a5V5Ne3ThRrbDozd?=
 =?us-ascii?Q?1l5EaVRR5xbQsnLMHdetehKZwHZr9BUvdyolC12KmcpNlDwi58OErFW1YqNT?=
 =?us-ascii?Q?HaK5Z+e+nttpgs6Z19rqIM4BVHeMuajQsOhwEa7+hwrjjdPbWX6kawKSbgdO?=
 =?us-ascii?Q?caP3/lB3PCpk+76HSvkSsL9KMeyiSW/1son7GRHPZhwoHTLJIkSB6kn07CbD?=
 =?us-ascii?Q?3esVFdrfHJZ21tRvFfnrNHUy+THHC3hIKR4cIOtXSYuP3bN5PUsFcB+4lkih?=
 =?us-ascii?Q?0hd3W9L46jyXts/bkslinivPJzRwPLeBoZ+3srVdqmEkDpWT2+8IsBPOPUX+?=
 =?us-ascii?Q?LjYq04bLZWpbLCh6FI/MqdXGPK7vkWL3k4zrh0bYjcmDtCH08/9+sePlV2bf?=
 =?us-ascii?Q?DTm6y8fOIwFBWhdwG88uv+CdyIuC/71VgppRR8taaMO5pA5Af7iSQH63VnKS?=
 =?us-ascii?Q?W72VyYhDutugLyKzjBf11BYwu/Dr+BrAb4y4gmv6ezi4yXP/qrpzWVd2pxaz?=
 =?us-ascii?Q?A6+/UNSdK+Jx4qHextDKuuARQ2Oa1COFMpHpsLs54gZo96rqM3qi7XxqXiPz?=
 =?us-ascii?Q?FRNQGkg6aVKrSw0ek4uQJ+yxlS0CEKqOewJClR+lwTg+/GUX5At1DdkAmkRe?=
 =?us-ascii?Q?9Xb0zD3fxFjxXHnhRoPnvZQcmJQ5ycjBvAtYHdX/qd4A338mpVD3qr/s1Bof?=
 =?us-ascii?Q?h8sVI/B7G/Rz+b1wrNyCfWu2Tcgydu3Y+mk0qeje/tdru7AjkWe19XxW48g7?=
 =?us-ascii?Q?ovwTYr7rFbKlM+eDtD8f4WGZZX5UbQVBO1/HzqP3/GstpQDlDilPlW/7SYTt?=
 =?us-ascii?Q?xCj1NMaMKjQH6ytao+OOt428oMF4ddqNL0hVVhPhX8V4j0EdXSJ9ppf2nQeY?=
 =?us-ascii?Q?G441fDhovy9LLlXJswgJhFfkPjtOpEIW3n/hoJnaCt6dVjBHnI8OSdYYR1/i?=
 =?us-ascii?Q?mzSMyx0bS862BirH/XkWbpwGA4v9loHCFt1PyIU5/wkgfrrfeB91aJzGzVGe?=
 =?us-ascii?Q?sbTMG7vxawt+IgE32Z4mPcNAUygoGjeYTN0qWVO4MGf9e2DLGhwZf46n0Zb6?=
 =?us-ascii?Q?PWFpbXj23Jwz8V2+8sjuW3JXfbzUdFjDbiQLm6QDAoMK15MiJD5jqOUcC6iz?=
 =?us-ascii?Q?ge8529bdZB+NErkpm+2MbadX0FydxxiGgV1/8pjwGIQZJfoAPyz3Yq4WvKCX?=
 =?us-ascii?Q?/F0bbpjuDJuRWnOI/N9nRdij2Bk1fbKjtG81ZNjLUqMtL3IrbfbyClk331so?=
 =?us-ascii?Q?IZpsAIXqxm04EjUF/0ZCpyzeLsx32RUtwsAYf045QAyvoI/+77V37GizvjkE?=
 =?us-ascii?Q?smu3cJ/vNfDBwSOIR85GO/umt/+srqYKKS3xpt53eF8QJjRHtG9QqNCouQoF?=
 =?us-ascii?Q?iigemWqgk6qV4GNK0bpOd2e+c7e81+ytD5pDrDBAr8xbgQsxQ7q4H8t2uJtz?=
 =?us-ascii?Q?9jPS95kL7g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 527f98cd-6dbc-44f1-528c-08da1e95abfd
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 04:09:01.0031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GID/YiByXR4q9huoMly2Vw0R1d2vUBido+jt65txkGHfEfacWWt/7DXrNRdm1WfIiZPimlYBPYuhkTl9lbkyXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4761
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, April 15, 2022 2:46 AM
>=20
> Just move the exported function into the op and have it accept the struct
> file instead of vfio_group.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c  | 26 ++++++++++++++++++--------
>  include/linux/vfio.h |  5 +++--
>  virt/kvm/vfio.c      | 19 +++----------------
>  3 files changed, 24 insertions(+), 26 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index c08093fb6d28d5..2eb63d9dded8fb 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -2029,9 +2029,27 @@ static bool vfio_file_enforced_coherent(struct fil=
e
> *filep)
>  	return ret;
>  }
>=20
> +/**
> + * vfio_file_set_kvm - Link a kvm with VFIO drivers
> + * @filep: VFIO file
> + * @kvm: KVM to link
> + *
> + * The kvm pointer will be forwarded to all the vfio_device's attached t=
o the
> + * VFIO file via the VFIO_GROUP_NOTIFY_SET_KVM notifier.
> + */
> +static void vfio_file_set_kvm(struct file *filep, struct kvm *kvm)
> +{
> +	struct vfio_group *group =3D filep->private_data;
> +
> +	group->kvm =3D kvm;
> +	blocking_notifier_call_chain(&group->notifier,
> +				     VFIO_GROUP_NOTIFY_SET_KVM, kvm);
> +}
> +
>  static const struct vfio_file_ops vfio_file_group_ops =3D {
>  	.get_iommu_group =3D vfio_file_iommu_group,
>  	.is_enforced_coherent =3D vfio_file_enforced_coherent,
> +	.set_kvm =3D vfio_file_set_kvm,
>  };
>=20
>  /**
> @@ -2461,14 +2479,6 @@ static int vfio_unregister_iommu_notifier(struct
> vfio_group *group,
>  	return ret;
>  }
>=20
> -void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
> -{
> -	group->kvm =3D kvm;
> -	blocking_notifier_call_chain(&group->notifier,
> -				VFIO_GROUP_NOTIFY_SET_KVM, kvm);
> -}
> -EXPORT_SYMBOL_GPL(vfio_group_set_kvm);
> -
>  static int vfio_register_group_notifier(struct vfio_group *group,
>  					unsigned long *events,
>  					struct notifier_block *nb)
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index b1583eb80f12e6..bc6e47f3f26560 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -15,6 +15,8 @@
>  #include <linux/poll.h>
>  #include <uapi/linux/vfio.h>
>=20
> +struct kvm;
> +
>  /*
>   * VFIO devices can be placed in a set, this allows all devices to share=
 this
>   * structure and the VFIO core will provide a lock that is held around
> @@ -141,6 +143,7 @@ int vfio_mig_get_next_state(struct vfio_device
> *device,
>  struct vfio_file_ops {
>  	struct iommu_group *(*get_iommu_group)(struct file *filep);
>  	bool (*is_enforced_coherent)(struct file *filep);
> +	void (*set_kvm)(struct file *filep, struct kvm *kvm);
>  };
>  extern struct vfio_group *vfio_group_get_external_user(struct file *file=
p);
>  extern void vfio_group_put_external_user(struct vfio_group *group);
> @@ -186,8 +189,6 @@ extern int vfio_unregister_notifier(struct device *de=
v,
>  				    enum vfio_notify_type type,
>  				    struct notifier_block *nb);
>=20
> -struct kvm;
> -extern void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm=
);
>=20
>  /*
>   * Sub-module helpers
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index f5ef78192a97ab..9baf04c5b0cc3d 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -73,19 +73,6 @@ static void kvm_vfio_group_put_external_user(struct
> vfio_group *vfio_group)
>  	symbol_put(vfio_group_put_external_user);
>  }
>=20
> -static void kvm_vfio_group_set_kvm(struct vfio_group *group, struct kvm
> *kvm)
> -{
> -	void (*fn)(struct vfio_group *, struct kvm *);
> -
> -	fn =3D symbol_get(vfio_group_set_kvm);
> -	if (!fn)
> -		return;
> -
> -	fn(group, kvm);
> -
> -	symbol_put(vfio_group_set_kvm);
> -}
> -
>  static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
>  					     struct kvm_vfio_group *kvg)
>  {
> @@ -184,7 +171,7 @@ static int kvm_vfio_group_add(struct kvm_device
> *dev, unsigned int fd)
>=20
>  	mutex_unlock(&kv->lock);
>=20
> -	kvm_vfio_group_set_kvm(vfio_group, dev->kvm);
> +	kvg->ops->set_kvm(kvg->filp, dev->kvm);
>  	kvm_vfio_update_coherency(dev);
>=20
>  	return 0;
> @@ -218,7 +205,7 @@ static int kvm_vfio_group_del(struct kvm_device
> *dev, unsigned int fd)
>  		list_del(&kvg->node);
>  		kvm_arch_end_assignment(dev->kvm);
>  		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
> -		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
> +		kvg->ops->set_kvm(kvg->filp, NULL);
>  		kvm_vfio_group_put_external_user(kvg->vfio_group);
>  		fput(kvg->filp);
>  		kfree(kvg);
> @@ -334,7 +321,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
>=20
>  	list_for_each_entry_safe(kvg, tmp, &kv->group_list, node) {
>  		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
> -		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
> +		kvg->ops->set_kvm(kvg->filp, NULL);
>  		kvm_vfio_group_put_external_user(kvg->vfio_group);
>  		fput(kvg->filp);
>  		list_del(&kvg->node);
> --
> 2.35.1

