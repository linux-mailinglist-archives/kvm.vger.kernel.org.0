Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566B068A88E
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 07:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbjBDGWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 01:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBDGV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 01:21:59 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6061C761C5;
        Fri,  3 Feb 2023 22:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675491717; x=1707027717;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/TXdPlObJnSAXjuwJPxTkaGgy+ENUT9sUFX7gA7puY0=;
  b=B+vIC0cX2kFAA/Hjd4Zm8taLjSGZTJeNl7eR3UPaZ+49fLysDQOJyH+8
   fP70Ixcssp68mVT60JCXYOT7XXPfR10IxLQHSEPbAtzmC3TOb5dCx/qw+
   J8kTCzVyJNPoHJFvW3Kyvn9hO+HwcYocfZQT2Q2TsCfLIQ2kTKEaELOz8
   MJ87bYP5igeflwGrenxoZRB0bF4PYWNsUw6fu/NplIbUMki1Z2TPv+5kk
   JA5CreBj7H8bKkbw+HXcHjv6I0lgsG0Ni6H886zu2ymnabycZ6vCUUXws
   F0jBKIfFvZIKqIDSL8BDKNjLbQuTfaBrrIwermCiEE5/hx6qJYhI2T+8P
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="330213513"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="330213513"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 22:21:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="729485763"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="729485763"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 03 Feb 2023 22:21:55 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 22:21:55 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 3 Feb 2023 22:21:55 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 3 Feb 2023 22:21:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HCFsc69+TljutCoXF46xzHWVUpBThA81AOwvRHpwZbfK3pl8bCaElPgFKVCEkkIMCnVSfIaoi0rdsnRO+Tx0pZBEWy6QZ2r6koQyZJs5I8uySDTyr3Tx43zsDeI2ShqtCNAF5BvUqcjvIw8aE6vx/206CiI8nLLy7w0x0Yv5q82BbjVpYGLXR9zVk0fiJIkXzhSHbhszNuHpYWBGbl7QSwoarVZnrPozvN9G4S/BOIz7HDW05MTyy0E9uI+XyonzgELvHblbjuon4U3nnrRNnrXxlAvXSfftvaqmZIiZBPwUORcVXzJc/7qoa3P2z/FR9qYZjj5IwbhgWLg0+e8lPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJ57Wvb4urtpj1kVRwfDYkcD6FX9hWMOpSmzc2+8phQ=;
 b=MF+ndMVf8aznNOAxhFlpb/YQ9aAZSuuPhIhVaX9t/hTQkaifg3fyiwYWIF2jyfvqgB+ua0AeDaBJIiGGBWSAmWFNJJvjBnbdBkgxJ3ldCRDVLhS9bRAVCWB1MtaSgosLfsqLwUN9ECzsF0bwgJVeKfKKcbnjkzsWTBw8pxCe394hG6UVLcaNPjglkdN0HJF0d87pt1FsRvygrElvSqInAZ+DOyOicNJtZ8ZfRELemi13XVZLr9KyMZs6TyI6W5FxpPs2idnl73PBImiORXW06T2lgSS0LsGpGNt58MwuYTq2XxWl2DfZw+BLLcnbJLdXOcf5H6VU4RmfDKLQ9Darzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL3PR11MB6315.namprd11.prod.outlook.com (2603:10b6:208:3b2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Sat, 4 Feb
 2023 06:21:49 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6064.024; Sat, 4 Feb 2023
 06:21:49 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 1/2] vfio: fix deadlock between group lock and kvm lock
Thread-Topic: [PATCH v4 1/2] vfio: fix deadlock between group lock and kvm
 lock
Thread-Index: AQHZOBmQk2FRcSB0UUmlHVuhyLs3Ya6+SbvA
Date:   Sat, 4 Feb 2023 06:21:48 +0000
Message-ID: <DS0PR11MB7529CE3027A713D6F2EE7F68C3D49@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230203215027.151988-1-mjrosato@linux.ibm.com>
 <20230203215027.151988-2-mjrosato@linux.ibm.com>
In-Reply-To: <20230203215027.151988-2-mjrosato@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BL3PR11MB6315:EE_
x-ms-office365-filtering-correlation-id: 7c76f25b-ff7d-4d9d-7060-08db0678191a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TTRAcRxyTmTnVr1SnbLOXHDKf78J5d1eSe2VoxfbPLnfcP/Hg8WorCQI1HH0I2zg8NlODU62KSbuloDs4AijhvJm7mVxLLJf3CWvalxoBdIOflbxt0P8iAYKf2GQdpvaD5ebPVuNrUnpNwKxygUw9ZXBucHKPbBTo97gg3fUKBkW+HJDPg3ohaPvYygI5RJKi1XNDr06fXjD8539VPTQPFtZ2Aq4i7btr55aIi/mQP02Y1E1+DVl3WJZh14rrbP/TcDIUFlYQO3zAQNxzNmgy0pAd/rTBo1qPAcAYiYwu66gSTRrtQ5aB5xwdaYBqGqhQBTpVYyGQjfQLi77Ftz2rmSKOJImbr+WOCpcnRE8EDDwwsbO6Smy3SJY7xb3qxdBWZDdXcayPIJ4nIaPFZUFW9iy2yPgEJmsLi+tPcuK/lf4Q2R12HT8rXPy24W1KhiWN4abOHUD7qEAA7Kpq3Z8GbGvRTfIAb8zzjzrlAetNj+b40W+eK+b7kHtNVHGIipTUSBbR8y6JGqlsXrHAMg5p5GbxEgUOh0qx92kHwqHE+xgotQnP5MSzsYkSW73ER1IdMb88LVG+tu/PzLaHQfYUyks0+G+MGfrsWmUqEb8pFhAT0+PdVc8jCSRE2lPGnX3MJ9e0UfBmX9OnXp6SPwk4mh+BzItoufWLDbs9OXsPFP94uMpVx1YymrfA5c/peMO35eM2bsLtE7mcAzI/2otYT6EefeMcUOJRJA6YVjT2KM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(376002)(396003)(39860400002)(366004)(451199018)(41300700001)(478600001)(33656002)(82960400001)(66556008)(38100700002)(122000001)(4326008)(66476007)(8676002)(83380400001)(54906003)(64756008)(316002)(66446008)(110136005)(5660300002)(186003)(71200400001)(26005)(53546011)(7416002)(76116006)(9686003)(6506007)(86362001)(38070700005)(52536014)(7696005)(55016003)(8936002)(66946007)(2906002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZkPA/L74Ek2MPEp0+rwxq7zB2iXhzp+MecBQ9+f+vD8EAfSmCPbcg8DP0Uvt?=
 =?us-ascii?Q?D67UX8EzXx/AE+bnOmfeWI0EjBVvgeofa66r063YfBs3fmOwTtGyLyCn+Mht?=
 =?us-ascii?Q?D6bZhIgwEwMPXXRkDCHJzs7d/HvqEU5d1eLAZ5MJeb3DxkMPp2ettIjJy0S8?=
 =?us-ascii?Q?0xxA1N6Qu2WyiXPsd0eeIn5f51UlD3VoDRBNSegH0m+sdgZGCngK92QZI4I7?=
 =?us-ascii?Q?HxYhsaZDZ5m6GcrGLbmLRuUGCxLWTyPYyCOgjSYSShOMEe1h2bUr7TgzfsmV?=
 =?us-ascii?Q?BXFb9OCSSIzM3Hbh8zIHU7ClBcFdS8gRekC5tX1UDwW7CVGn91VKufgT9E7n?=
 =?us-ascii?Q?53QQ9cCWqvhOItGJMYppi/ojtIapBGMNTwEyjvBwYjci9+yu+oasJwEFr4VW?=
 =?us-ascii?Q?lrdqVSw5SZsrEy34Ip0kshc37fgk5Hnl0NhopGUMpKWfaSBKhAJA9/8WqSIf?=
 =?us-ascii?Q?iUG65u+VBtLNHXyCaFOzjh+Xtwh5W/m8lnSb092I1GBu7dGZJ102UNVE3pi4?=
 =?us-ascii?Q?xVPakSNwMr0dCEAW3twHnInzLMHQcR/l30peZtb3Js6bR7BKcQMlnjY0bgiR?=
 =?us-ascii?Q?eCXaRkSS8PTR0MTsDaA842+oCO/ooiFUdVVTfdOpx027L4dECVDUWCHqmM0l?=
 =?us-ascii?Q?dFuuY+eh0HTUIb19XGBxwjTH3SDQqmrNeZ6umYs2JkHUkGja+dT7UGvpekDs?=
 =?us-ascii?Q?EsP0b/cEQ8EiofMM0qZU/GbF1VtyTUJB2/WqmBwioL7agfdOornx4hiT+46d?=
 =?us-ascii?Q?M4Gx99UwVYPAZXjl1ru91CXSTiD5h6oBu9sHuju+8Wa8cZrvoiNCfRJYnapC?=
 =?us-ascii?Q?GbJHAVyWAciKmSUl4iEoMwJavGIQxR/IXmwPLzoRB53sr6BlH7qh1AWE6qph?=
 =?us-ascii?Q?qeJsc9e3xcqE8Icn05FgHeiB9YYvQoaD2AuNbDeKOYfynU5SrcN71bCc4W8z?=
 =?us-ascii?Q?wcyqIa6WqB1IA9ly1Ukodhv0bkFdHwrBfG6zHxgjDFYPAdcxmD0xFejipNsM?=
 =?us-ascii?Q?O+mOjaPoj7Tk3oEsldKrUdK07W1JOJKyDb0KYQOQhCsjU2IOM0y1Kw8PxbOX?=
 =?us-ascii?Q?zOWGcHt22JDkoPTcy4w8a0LkEVpAc01Wv0W47L+BCDxQU3sT8KFJQVY3xYoz?=
 =?us-ascii?Q?YEGvDnq5N6eNMazK9cvD/4H8z2+NvXcBLxaRMk5GV1R9o4MePX+X3lN9Twat?=
 =?us-ascii?Q?8eNjppWNceyQrjPEyXLZ10X6MbzOojMydI8xR2c7v6g4DQQBFN5UuAXVAibA?=
 =?us-ascii?Q?D1fYHOuf7IA+hLM+5AQd4zBiIHzgOWGzmoUEPRiqtlIIvUd6lp2q70ugACRb?=
 =?us-ascii?Q?RDqVJF7dgcALYrcQxN/NMpo89GazS+RBg6eXTnNdLbFgns8l0mcqPypVMc4Y?=
 =?us-ascii?Q?ZU2MLYJ8fecnis7A0Tnkib0KB2998DWQlduclS1l49qqsYbs3ctinDD3ErPm?=
 =?us-ascii?Q?xyneqRGCGuKFa53mhk4OqeYB+ves8RfEZJ5wz2T5NRnTRAlROKpzLuysVQvu?=
 =?us-ascii?Q?Yc5UxUIdpT5MG3H78vnFoxcJTgOp4z+BtZ4ALKUOCRFdRWbJUWyB2b3FQaCf?=
 =?us-ascii?Q?z3mgGTfvFkqSGEy7KkS/im4gB9GCcldZFU6dGioA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c76f25b-ff7d-4d9d-7060-08db0678191a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2023 06:21:48.9905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S7A32F132T7IuLe4iziXmP6YUk3Q17H9W8lLbZ5y12Yc7s9b58n8w6Gk/paP8oCU6fDqfVULIYrFt9cDZJF23g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6315
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

> From: Matthew Rosato <mjrosato@linux.ibm.com>
> Sent: Saturday, February 4, 2023 5:50 AM
> To: alex.williamson@redhat.com; pbonzini@redhat.com; Liu, Yi L
>=20
> After 51cdc8bc120e, we have another deadlock scenario between the
> kvm->lock and the vfio group_lock with two different codepaths acquiring
> the locks in different order.  Specifically in vfio_open_device, vfio
> holds the vfio group_lock when issuing device->ops->open_device but
> some
> drivers (like vfio-ap) need to acquire kvm->lock during their open_device
> routine;  Meanwhile, kvm_vfio_release will acquire the kvm->lock first
> before calling vfio_file_set_kvm which will acquire the vfio group_lock.
>=20
> To resolve this, let's remove the need for the vfio group_lock from the
> kvm_vfio_release codepath.  This is done by introducing a new spinlock to
> protect modifications to the vfio group kvm pointer, and acquiring a kvm
> ref from within vfio while holding this spinlock, with the reference held
> until the last close for the device in question.
>=20
> Fixes: 51cdc8bc120e ("kvm/vfio: Fix potential deadlock on vfio group_lock=
")
> Reported-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/vfio/group.c     | 44 +++++++++++++++++++++++-----
>  drivers/vfio/vfio.h      | 15 ++++++++++
>  drivers/vfio/vfio_main.c | 63
> +++++++++++++++++++++++++++++++++++-----
>  include/linux/vfio.h     |  2 +-
>  4 files changed, 109 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index bb24b2f0271e..98621ac082f0 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -154,6 +154,18 @@ static int vfio_group_ioctl_set_container(struct
> vfio_group *group,
>  	return ret;
>  }
>=20
> +static void vfio_device_group_get_kvm_safe(struct vfio_device *device)
> +{
> +	spin_lock(&device->group->kvm_ref_lock);
> +	if (!device->group->kvm)
> +		goto unlock;
> +
> +	_vfio_device_get_kvm_safe(device, device->group->kvm);
> +
> +unlock:
> +	spin_unlock(&device->group->kvm_ref_lock);
> +}
> +
>  static int vfio_device_group_open(struct vfio_device *device)
>  {
>  	int ret;
> @@ -164,13 +176,23 @@ static int vfio_device_group_open(struct
> vfio_device *device)
>  		goto out_unlock;
>  	}
>=20
> +	mutex_lock(&device->dev_set->lock);
> +
>  	/*
> -	 * Here we pass the KVM pointer with the group under the lock.  If
> the
> -	 * device driver will use it, it must obtain a reference and release it
> -	 * during close_device.
> +	 * Before the first device open, get the KVM pointer currently
> +	 * associated with the group (if there is one) and obtain a reference
> +	 * now that will be held until the open_count reaches 0 again.  Save

Nit: a redundant space before "Save". Other part looks good to me.

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

Regards,
Yi Liu

> +	 * the pointer in the device for use by drivers.
>  	 */
> -	ret =3D vfio_device_open(device, device->group->iommufd,
> -			       device->group->kvm);
> +	if (device->open_count =3D=3D 0)
> +		vfio_device_group_get_kvm_safe(device);
> +
> +	ret =3D vfio_device_open(device, device->group->iommufd, device->kvm);
> +
> +	if (device->open_count =3D=3D 0)
> +		vfio_device_put_kvm(device);
> +
> +	mutex_unlock(&device->dev_set->lock);
>=20
>  out_unlock:
>  	mutex_unlock(&device->group->group_lock);
> @@ -180,7 +202,14 @@ static int vfio_device_group_open(struct
> vfio_device *device)
>  void vfio_device_group_close(struct vfio_device *device)
>  {
>  	mutex_lock(&device->group->group_lock);
> +	mutex_lock(&device->dev_set->lock);
> +
>  	vfio_device_close(device, device->group->iommufd);
> +
> +	if (device->open_count =3D=3D 0)
> +		vfio_device_put_kvm(device);
> +
> +	mutex_unlock(&device->dev_set->lock);
>  	mutex_unlock(&device->group->group_lock);
>  }
>=20
> @@ -450,6 +479,7 @@ static struct vfio_group *vfio_group_alloc(struct
> iommu_group *iommu_group,
>=20
>  	refcount_set(&group->drivers, 1);
>  	mutex_init(&group->group_lock);
> +	spin_lock_init(&group->kvm_ref_lock);
>  	INIT_LIST_HEAD(&group->device_list);
>  	mutex_init(&group->device_lock);
>  	group->iommu_group =3D iommu_group;
> @@ -803,9 +833,9 @@ void vfio_file_set_kvm(struct file *file, struct kvm
> *kvm)
>  	if (!vfio_file_is_group(file))
>  		return;
>=20
> -	mutex_lock(&group->group_lock);
> +	spin_lock(&group->kvm_ref_lock);
>  	group->kvm =3D kvm;
> -	mutex_unlock(&group->group_lock);
> +	spin_unlock(&group->kvm_ref_lock);
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
>=20
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index f8219a438bfb..24d6cd285945 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -74,6 +74,7 @@ struct vfio_group {
>  	struct file			*opened_file;
>  	struct blocking_notifier_head	notifier;
>  	struct iommufd_ctx		*iommufd;
> +	spinlock_t			kvm_ref_lock;
>  };
>=20
>  int vfio_device_set_group(struct vfio_device *device,
> @@ -251,4 +252,18 @@ extern bool vfio_noiommu __read_mostly;
>  enum { vfio_noiommu =3D false };
>  #endif
>=20
> +#ifdef CONFIG_HAVE_KVM
> +void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm
> *kvm);
> +void vfio_device_put_kvm(struct vfio_device *device);
> +#else
> +static inline void _vfio_device_get_kvm_safe(struct vfio_device *device,
> +					     struct kvm *kvm)
> +{
> +}
> +
> +static inline void vfio_device_put_kvm(struct vfio_device *device)
> +{
> +}
> +#endif
> +
>  #endif
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 5177bb061b17..28c47cd6a6b5 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -16,6 +16,9 @@
>  #include <linux/fs.h>
>  #include <linux/idr.h>
>  #include <linux/iommu.h>
> +#ifdef CONFIG_HAVE_KVM
> +#include <linux/kvm_host.h>
> +#endif
>  #include <linux/list.h>
>  #include <linux/miscdevice.h>
>  #include <linux/module.h>
> @@ -338,6 +341,55 @@ void vfio_unregister_group_dev(struct vfio_device
> *device)
>  }
>  EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
>=20
> +#ifdef CONFIG_HAVE_KVM
> +void _vfio_device_get_kvm_safe(struct vfio_device *device, struct kvm
> *kvm)
> +{
> +	void (*pfn)(struct kvm *kvm);
> +	bool (*fn)(struct kvm *kvm);
> +	bool ret;
> +
> +	lockdep_assert_held(&device->dev_set->lock);
> +
> +	pfn =3D symbol_get(kvm_put_kvm);
> +	if (WARN_ON(!pfn))
> +		return;
> +
> +	fn =3D symbol_get(kvm_get_kvm_safe);
> +	if (WARN_ON(!fn)) {
> +		symbol_put(kvm_put_kvm);
> +		return;
> +	}
> +
> +	ret =3D fn(kvm);
> +	symbol_put(kvm_get_kvm_safe);
> +	if (!ret) {
> +		symbol_put(kvm_put_kvm);
> +		return;
> +	}
> +
> +	device->put_kvm =3D pfn;
> +	device->kvm =3D kvm;
> +}
> +
> +void vfio_device_put_kvm(struct vfio_device *device)
> +{
> +	lockdep_assert_held(&device->dev_set->lock);
> +
> +	if (!device->kvm)
> +		return;
> +
> +	if (WARN_ON(!device->put_kvm))
> +		goto clear;
> +
> +	device->put_kvm(device->kvm);
> +	device->put_kvm =3D NULL;
> +	symbol_put(kvm_put_kvm);
> +
> +clear:
> +	device->kvm =3D NULL;
> +}
> +#endif
> +
>  /* true if the vfio_device has open_device() called but not close_device=
()
> */
>  static bool vfio_assert_device_open(struct vfio_device *device)
>  {
> @@ -361,7 +413,6 @@ static int vfio_device_first_open(struct vfio_device
> *device,
>  	if (ret)
>  		goto err_module_put;
>=20
> -	device->kvm =3D kvm;
>  	if (device->ops->open_device) {
>  		ret =3D device->ops->open_device(device);
>  		if (ret)
> @@ -370,7 +421,6 @@ static int vfio_device_first_open(struct vfio_device
> *device,
>  	return 0;
>=20
>  err_unuse_iommu:
> -	device->kvm =3D NULL;
>  	if (iommufd)
>  		vfio_iommufd_unbind(device);
>  	else
> @@ -387,7 +437,6 @@ static void vfio_device_last_close(struct vfio_device
> *device,
>=20
>  	if (device->ops->close_device)
>  		device->ops->close_device(device);
> -	device->kvm =3D NULL;
>  	if (iommufd)
>  		vfio_iommufd_unbind(device);
>  	else
> @@ -400,14 +449,14 @@ int vfio_device_open(struct vfio_device *device,
>  {
>  	int ret =3D 0;
>=20
> -	mutex_lock(&device->dev_set->lock);
> +	lockdep_assert_held(&device->dev_set->lock);
> +
>  	device->open_count++;
>  	if (device->open_count =3D=3D 1) {
>  		ret =3D vfio_device_first_open(device, iommufd, kvm);
>  		if (ret)
>  			device->open_count--;
>  	}
> -	mutex_unlock(&device->dev_set->lock);
>=20
>  	return ret;
>  }
> @@ -415,12 +464,12 @@ int vfio_device_open(struct vfio_device *device,
>  void vfio_device_close(struct vfio_device *device,
>  		       struct iommufd_ctx *iommufd)
>  {
> -	mutex_lock(&device->dev_set->lock);
> +	lockdep_assert_held(&device->dev_set->lock);
> +
>  	vfio_assert_device_open(device);
>  	if (device->open_count =3D=3D 1)
>  		vfio_device_last_close(device, iommufd);
>  	device->open_count--;
> -	mutex_unlock(&device->dev_set->lock);
>  }
>=20
>  /*
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 35be78e9ae57..87ff862ff555 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -46,7 +46,6 @@ struct vfio_device {
>  	struct vfio_device_set *dev_set;
>  	struct list_head dev_set_list;
>  	unsigned int migration_flags;
> -	/* Driver must reference the kvm during open_device or never
> touch it */
>  	struct kvm *kvm;
>=20
>  	/* Members below here are private, not for driver use */
> @@ -58,6 +57,7 @@ struct vfio_device {
>  	struct list_head group_next;
>  	struct list_head iommu_entry;
>  	struct iommufd_access *iommufd_access;
> +	void (*put_kvm)(struct kvm *kvm);
>  #if IS_ENABLED(CONFIG_IOMMUFD)
>  	struct iommufd_device *iommufd_device;
>  	struct iommufd_ctx *iommufd_ictx;
> --
> 2.39.1

