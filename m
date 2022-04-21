Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B155E50940C
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 02:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356670AbiDUAIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 20:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiDUAIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 20:08:12 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4AC13FB7
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 17:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650499524; x=1682035524;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cEDJhEIs9T3Tfm4XaAM/prBmizHgjWL7sFaIv4MhP30=;
  b=RB+HKf9F3MY0tuP9GIYI361SxtsOgsXpG4gyCSX0jYNkbTbJ65CfuS6/
   4/AAyFYX3B4FbK3d1l8ySXieVkaqShsZV4N3WyZleydWXYc6zK5iPHq4V
   3lrHteBQyJoEiInFQtbhU58l0WoNWmeEaJvYVafCBpf2n5KgT7SKadqzQ
   WB5JETjrRZdXEyt5lacaLyMRMSRZgrG8ZNBlLySU6QpaHHXw3PXqGO6dg
   FisDMsHf+evD8Zy3KqM+9fIANfE3A4/XnfITGQbbuZ0i/jcVJ2IJD0EqC
   81Hy+gOFgk896DtL4XID9sRG9xTmGXkI5EPa4c7aXfQHhN0rjjYmQqtLZ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="350633708"
X-IronPort-AV: E=Sophos;i="5.90,277,1643702400"; 
   d="scan'208";a="350633708"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 17:05:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,277,1643702400"; 
   d="scan'208";a="510787007"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 20 Apr 2022 17:05:22 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 20 Apr 2022 17:05:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 20 Apr 2022 17:05:21 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 20 Apr 2022 17:05:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VvZLJcj+DpZO3cwKBwWmTzhnHBF71u2yQlMHpxAv6RRC2m1uZOMLvOwgRZLM/ASJjQ0isbipXWlG/7W6I5bn5FmE7Egs84aNzxNN9Y/RWDJETV6v1GrOPP8GKvtJd4Va7MsQtxVtxAnuwXcazC2S2YRApUPI9HoZk5aAJAogIuHl5toZyMEeIPjMHXha4wZZ2i0cydiNz+Y48fnqZokGqcZ+GZxkZyeD7lPyskRZ5gUIkylmKDQ5GuB4WfZkF/neWw+Mw+wFYhR4NDxYJXHODeo/SxK1ZCgdu0eBv3rX29tZS2+eDt/I/H2ouNvvfNOexCJ/h5yHJ26qCmDiy9Cc9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XpWQJ6DRh9McnGYuDaq+7LlIy8enDd1GAWyzV+yE4I8=;
 b=NOkFAKruezevGIKFSWy5+iKCHx7CRbUCcPNdzucywQwPgZVL+y6oSASHVz26A3q2oiR699AHD//DZJxaqLczxui/QGYoUdoXnG52QsE3bGaOXXDYiuCH4VXSLLJsYfFitfONpab7uEBLjaEi2LQYwX3x15eAWk56k9JpfjBL3OxENu3w/Y3dlBFTlMgYTQdqGlyC4UF/eihm6wym4Qw8HrI8cDboKUhzYS5GSU64mzi/ogIkqXvq0HYVmMSWo5dFOZkFYiKLJMM7EIkqBX3r6Ub4S+2u9NEw108m0LK5LwdJU1u2u6oQidIiHvct/o4vx4c1wSqhATknN6u+Hevnxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by DM6PR11MB4249.namprd11.prod.outlook.com (2603:10b6:5:1d9::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 21 Apr
 2022 00:05:14 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::3114:d1ec:335e:d303]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::3114:d1ec:335e:d303%3]) with mapi id 15.20.5186.013; Thu, 21 Apr 2022
 00:05:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2 8/8] vfio/pci: Use the struct file as the handle not
 the vfio_group
Thread-Topic: [PATCH v2 8/8] vfio/pci: Use the struct file as the handle not
 the vfio_group
Thread-Index: AQHYVOwhwU/wF5ixX0OPDtmtA1HQyqz5fLtg
Date:   Thu, 21 Apr 2022 00:05:14 +0000
Message-ID: <BL1PR11MB5271D9B512518E5F0CA8E6008CF49@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
 <8-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <8-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b09f573-dac9-434f-e473-08da232a9c63
x-ms-traffictypediagnostic: DM6PR11MB4249:EE_
x-microsoft-antispam-prvs: <DM6PR11MB4249ACE8D7217A5835620CCF8CF49@DM6PR11MB4249.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z1yYioZAC0DuLbz0+xRBABcKnEhGJtvmnxlsuLIS6QKmEka95E/jA4y/zatP7sPPNFL5vjcy4Q5FZy4sXiAreLvN2NSpacf8n0BnDnBo7tkMwidrn2PhjHEZuRq/rmF4LKeh3Aa6z28aI9gOwCUctZ6WNox+t5aFwB7TC/EHTATvjH/GpE7BppzRuwsCG5+603l3ejzVsCeYaeq6AqPJIO5SGy5mPFV/KLr5QePJIs5ILx5om6XnJTuc9qfDCn30c6uYRuJymX32WHrlMqt463OM0+VrDk9ZRkdlHs81v4DPWt7LZrHUPbU1CHkvVhd3SELvAb4k32J165qo7cLdDfLjz/Hh7f9kIKqcTAScpDs9sIRuGiIYAKCd55KWCG3/YfuRV34y1Jsy4SjzQoQdp8x7URhrTjvMJpI2Rm6JS7lpwp0iKCN61nK3rW6Nuhjdi+DkduHiRXb171kOGFI0nzniqAbjPP5jeS0QCuVmNZP+7xT19A4oKaSMKRrW4D23TIruJTJuOgh9prBrP3Rz3sZA2vd+pq9pVmHn+uAy69DyKk6YUO3EVTbq9Dc+Dfy51vt6JAqh/Xflpfh6AG+3xaocpWGj/tNVKOfutUv+i8DmfWXDaVvS9MN2ZQHd/W0MdYm69vN6Zy+Jmlp1vrVryNfCYWsWSj953cV+7c8pNqSPVTmqdd0bVz3Q7wk2JE9O/wSj4pwkn6Nb0Xnf44/PdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66446008)(66556008)(64756008)(82960400001)(8936002)(76116006)(52536014)(508600001)(83380400001)(316002)(7696005)(5660300002)(54906003)(66946007)(8676002)(110136005)(9686003)(55016003)(26005)(2906002)(71200400001)(33656002)(107886003)(4326008)(122000001)(86362001)(186003)(6506007)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fR9EJZzkYSmFrGVs/KRiHYwivbwsfLSn4Y36nqHIUHCKFk/jso/hQv1nh6AP?=
 =?us-ascii?Q?sHoIT4Nt/cfasVm2ddKOb/Sy2YaVY1/C0OUFhOREU1kUFkH1QHYYttHQj5Sp?=
 =?us-ascii?Q?YBnoGzaqtj5Fhp5iGWgfowFlpDFmSvKq4lWYxgAzTWExxhIhpk1BBIJaivTG?=
 =?us-ascii?Q?OBIZdGJiNK/6WzVkrNWK6VgZewiN6gF/upcyw69GMymD++xio2m6w4+CNKuq?=
 =?us-ascii?Q?7P9bibOIOru9L5Sb8HTyilBNVAzooB2cDFLZdieI+qgzEBY0Zj/BJ9aYSn+A?=
 =?us-ascii?Q?hXv0U1/+321Flg0FPUb0Fs2SQgMwSBvFJrOBpjMfC5MLxnaXDjT+G84DQpxP?=
 =?us-ascii?Q?8aTgws2PCAHhax8MdeHnm4j6WTImKXCLOl6P9LHlwnrnYeLhcNuPUekNUMUJ?=
 =?us-ascii?Q?BR+onAmCNj/IgZWdizJvOPGAFGeQ1JkhWmJVVB7A3PnGrF58f6iWLmHbGblJ?=
 =?us-ascii?Q?7vH6tpTkfJR4t5uDDvrNiy0eVvAwAvKdOZMiqWPBeV7Hx3FVLbo02HTV8EEH?=
 =?us-ascii?Q?rhRGR9aJ8kY0EKxH02pj/DKobtTwNTXZUuKPhc1z0mzmI7nYtKzxV1yEub6c?=
 =?us-ascii?Q?3sIRHCdOg5kWPTYzEOAuvwAnvU90YnZv2T1cRMFelcSsU9uUDnxdaKNFLUN/?=
 =?us-ascii?Q?ml/00vWaUB6LEoUPfOe2yAtTjsGNJOoX8dSi3dJQ5iMF6rHFID5rilhybOAS?=
 =?us-ascii?Q?4YFrVJ9K1DqXR2XXwjjmWLiqAQmR7wtMODP+dCzas7yXQ7ggLXW2n176d6MN?=
 =?us-ascii?Q?mZ+TmFPVH+x+S8YNx7OHW7NjYbp0jYc4T9C2HZN92V2/vO3SeLj+H1exBInO?=
 =?us-ascii?Q?LiX+vD+PjIE2fnglfAQnUisb5Im6QPcJdK8xbnTSwxFNkOOS2BWZNu/f3k9j?=
 =?us-ascii?Q?5D9UdXwqjVRwEZ1Q/7B40eQDalddRvpA9ljJenOUVZ11+kKDRnshSjQw/K2V?=
 =?us-ascii?Q?3nQ3Jn0th8KNidow427dqBmRpOOFkNhvo0bcbkQTTYgE2iLAV+4SeIEEN5OW?=
 =?us-ascii?Q?rK1pfe2txX6dBzMDbR5v85ts0FFlzjm+T3a5bMLU0s3iG+bdvNyXFZ/VaTH0?=
 =?us-ascii?Q?zGjwjsKFbwKHiGA0VNeHm5lrMDlDJj/QhhVe7V0l9XPBRHz81inQ9xW8HkAB?=
 =?us-ascii?Q?7RAp4V9CJTDj6GzfvLqdwnkVw29tqGhfk9l3e3QP0IXEkMaeN1Sixtzu/zMw?=
 =?us-ascii?Q?2RsXGOuZ6ZwPNFU74AZd98PwMEd6kXaY/s+J0q/t6x/elU9UnbmWRVIKWgih?=
 =?us-ascii?Q?Cb3El4o6KGEMeZUg66bm0+64INbe7IZCQSJah7k0lZvizfrNZRXtPy0p8KBo?=
 =?us-ascii?Q?51/3sujztJt5DExXOKkacGGNjGRelJGXwVqBkslIVVfNpR4MpA2FgcuD/wir?=
 =?us-ascii?Q?lJuh9P6rbWfRv0YZo0EWpwSta+s9M9LmMVa8hWHUaSv56pfI6PPqI/4U1aPn?=
 =?us-ascii?Q?MZEr/JhFvs9rvxTdW+52cLzkCAXvEYTTqc/p45AoGnbutUcAjnmjhDsc35ON?=
 =?us-ascii?Q?3rxar16E6gM08rvqooGSICg60Kg69Ix3+pywztc44gOEicvvrjHf/YZVcJ3X?=
 =?us-ascii?Q?HZn/U2b/io0e7hJxgi2bl1WbVAGAKtf638y49vkrVhpjluxPW6HNTvmABQ7l?=
 =?us-ascii?Q?mbwV40AWCIs6p074UtfztnS4Melnn/FmSilJaWbR+qMnTtZkNelakoMvARCA?=
 =?us-ascii?Q?ZgxWjGkSY6bT4okPSL/y+R38la3HgxJF4POZuxW9whtAucJ9IGyKXFT4dNNU?=
 =?us-ascii?Q?0jzm+hn6WA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b09f573-dac9-434f-e473-08da232a9c63
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2022 00:05:14.5268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: emukhPiMEHUdI98FVryC/lbSmM4r0PEbw00elElo104EXrYWl9afsKlEeCWP763EhtdcwC+DTt5gJEBBNTa0Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4249
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, April 21, 2022 3:23 AM
>=20
> VFIO PCI does a security check as part of hot reset to prove that the use=
r
> has permission to manipulate all the devices that will be impacted by the
> reset.
>=20
> Use a new API vfio_file_has_dev() to perform this security check against
> the struct file directly and remove the vfio_group from VFIO PCI.
>=20
> Since VFIO PCI was the last user of vfio_group_get_external_user() remove
> it as well.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/pci/vfio_pci_core.c | 42 ++++++++++-----------
>  drivers/vfio/vfio.c              | 63 +++++++++-----------------------
>  include/linux/vfio.h             |  2 +-
>  3 files changed, 40 insertions(+), 67 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci=
_core.c
> index b7bb16f92ac628..465c42f53fd2fc 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -577,7 +577,7 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, v=
oid
> *data)
>=20
>  struct vfio_pci_group_info {
>  	int count;
> -	struct vfio_group **groups;
> +	struct file **files;
>  };
>=20
>  static bool vfio_pci_dev_below_slot(struct pci_dev *pdev, struct pci_slo=
t
> *slot)
> @@ -1039,10 +1039,10 @@ long vfio_pci_core_ioctl(struct vfio_device
> *core_vdev, unsigned int cmd,
>  	} else if (cmd =3D=3D VFIO_DEVICE_PCI_HOT_RESET) {
>  		struct vfio_pci_hot_reset hdr;
>  		int32_t *group_fds;
> -		struct vfio_group **groups;
> +		struct file **files;
>  		struct vfio_pci_group_info info;
>  		bool slot =3D false;
> -		int group_idx, count =3D 0, ret =3D 0;
> +		int file_idx, count =3D 0, ret =3D 0;
>=20
>  		minsz =3D offsetofend(struct vfio_pci_hot_reset, count);
>=20
> @@ -1075,17 +1075,17 @@ long vfio_pci_core_ioctl(struct vfio_device
> *core_vdev, unsigned int cmd,
>  			return -EINVAL;
>=20
>  		group_fds =3D kcalloc(hdr.count, sizeof(*group_fds),
> GFP_KERNEL);
> -		groups =3D kcalloc(hdr.count, sizeof(*groups), GFP_KERNEL);
> -		if (!group_fds || !groups) {
> +		files =3D kcalloc(hdr.count, sizeof(*files), GFP_KERNEL);
> +		if (!group_fds || !files) {
>  			kfree(group_fds);
> -			kfree(groups);
> +			kfree(files);
>  			return -ENOMEM;
>  		}
>=20
>  		if (copy_from_user(group_fds, (void __user *)(arg + minsz),
>  				   hdr.count * sizeof(*group_fds))) {
>  			kfree(group_fds);
> -			kfree(groups);
> +			kfree(files);
>  			return -EFAULT;
>  		}
>=20
> @@ -1094,22 +1094,22 @@ long vfio_pci_core_ioctl(struct vfio_device
> *core_vdev, unsigned int cmd,
>  		 * user interface and store the group and iommu ID.  This
>  		 * ensures the group is held across the reset.
>  		 */
> -		for (group_idx =3D 0; group_idx < hdr.count; group_idx++) {
> -			struct vfio_group *group;
> -			struct fd f =3D fdget(group_fds[group_idx]);
> -			if (!f.file) {
> +		for (file_idx =3D 0; file_idx < hdr.count; file_idx++) {
> +			struct file *file =3D fget(group_fds[file_idx]);
> +
> +			if (!file) {
>  				ret =3D -EBADF;
>  				break;
>  			}
>=20
> -			group =3D vfio_group_get_external_user(f.file);
> -			fdput(f);
> -			if (IS_ERR(group)) {
> -				ret =3D PTR_ERR(group);
> +			/* Ensure the FD is a vfio group FD.*/
> +			if (!vfio_file_iommu_group(file)) {
> +				fput(file);
> +				ret =3D -EINVAL;
>  				break;
>  			}
>=20
> -			groups[group_idx] =3D group;
> +			files[file_idx] =3D file;
>  		}
>=20
>  		kfree(group_fds);
> @@ -1119,15 +1119,15 @@ long vfio_pci_core_ioctl(struct vfio_device
> *core_vdev, unsigned int cmd,
>  			goto hot_reset_release;
>=20
>  		info.count =3D hdr.count;
> -		info.groups =3D groups;
> +		info.files =3D files;
>=20
>  		ret =3D vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
>=20
>  hot_reset_release:
> -		for (group_idx--; group_idx >=3D 0; group_idx--)
> -			vfio_group_put_external_user(groups[group_idx]);
> +		for (file_idx--; file_idx >=3D 0; file_idx--)
> +			fput(files[file_idx]);
>=20
> -		kfree(groups);
> +		kfree(files);
>  		return ret;
>  	} else if (cmd =3D=3D VFIO_DEVICE_IOEVENTFD) {
>  		struct vfio_device_ioeventfd ioeventfd;
> @@ -1964,7 +1964,7 @@ static bool vfio_dev_in_groups(struct
> vfio_pci_core_device *vdev,
>  	unsigned int i;
>=20
>  	for (i =3D 0; i < groups->count; i++)
> -		if (groups->groups[i] =3D=3D vdev->vdev.group)
> +		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
>  			return true;
>  	return false;
>  }
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 7d0fad02936f69..ff5f6e0f285faa 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1899,51 +1899,6 @@ static const struct file_operations
> vfio_device_fops =3D {
>  	.mmap		=3D vfio_device_fops_mmap,
>  };
>=20
> -/*
> - * External user API, exported by symbols to be linked dynamically.
> - *
> - * The protocol includes:
> - *  1. do normal VFIO init operation:
> - *	- opening a new container;
> - *	- attaching group(s) to it;
> - *	- setting an IOMMU driver for a container.
> - * When IOMMU is set for a container, all groups in it are
> - * considered ready to use by an external user.
> - *
> - * 2. User space passes a group fd to an external user.
> - * The external user calls vfio_group_get_external_user()
> - * to verify that:
> - *	- the group is initialized;
> - *	- IOMMU is set for it.
> - * If both checks passed, vfio_group_get_external_user()
> - * increments the container user counter to prevent
> - * the VFIO group from disposal before KVM exits.
> - *
> - * 3. When the external KVM finishes, it calls
> - * vfio_group_put_external_user() to release the VFIO group.
> - * This call decrements the container user counter.
> - */
> -struct vfio_group *vfio_group_get_external_user(struct file *filep)
> -{
> -	struct vfio_group *group =3D filep->private_data;
> -	int ret;
> -
> -	if (filep->f_op !=3D &vfio_group_fops)
> -		return ERR_PTR(-EINVAL);
> -
> -	ret =3D vfio_group_add_container_user(group);
> -	if (ret)
> -		return ERR_PTR(ret);
> -
> -	/*
> -	 * Since the caller holds the fget on the file group->users must be >=
=3D 1
> -	 */
> -	vfio_group_get(group);
> -
> -	return group;
> -}
> -EXPORT_SYMBOL_GPL(vfio_group_get_external_user);
> -
>  /*
>   * External user API, exported by symbols to be linked dynamically.
>   * The external user passes in a device pointer
> @@ -2056,6 +2011,24 @@ void vfio_file_set_kvm(struct file *file, struct k=
vm
> *kvm)
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
>=20
> +/**
> + * vfio_file_has_dev - True if the VFIO file is a handle for device
> + * @file: VFIO file to check
> + * @device: Device that must be part of the file
> + *
> + * Returns true if given file has permission to manipulate the given dev=
ice.
> + */
> +bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
> +{
> +	struct vfio_group *group =3D file->private_data;
> +
> +	if (file->f_op !=3D &vfio_group_fops)
> +		return false;
> +
> +	return group =3D=3D device->group;
> +}
> +EXPORT_SYMBOL_GPL(vfio_file_has_dev);
> +
>  /*
>   * Sub-module support
>   */
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index cbd9103b5c1223..e8be8ec40f2b50 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -140,13 +140,13 @@ int vfio_mig_get_next_state(struct vfio_device
> *device,
>  /*
>   * External user API
>   */
> -extern struct vfio_group *vfio_group_get_external_user(struct file *file=
p);
>  extern void vfio_group_put_external_user(struct vfio_group *group);
>  extern struct vfio_group *vfio_group_get_external_user_from_dev(struct
> device
>  								*dev);
>  extern struct iommu_group *vfio_file_iommu_group(struct file *file);
>  extern bool vfio_file_enforced_coherent(struct file *file);
>  extern void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
> +extern bool vfio_file_has_dev(struct file *file, struct vfio_device *dev=
ice);
>=20
>  #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned
> long))
>=20
> --
> 2.36.0

