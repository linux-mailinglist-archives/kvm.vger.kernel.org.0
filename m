Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2082724C95F
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 02:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgHUAx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 20:53:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:55891 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726868AbgHUAxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 20:53:54 -0400
IronPort-SDR: JqNiwCB8i77U2vJ+XhyCbBOijxpt5/oiG9jny8Y5HfquJIB2FaQhcpcxXheU5Orch8KvzI0DW2
 kZUdeDGV2Ohg==
X-IronPort-AV: E=McAfee;i="6000,8403,9719"; a="155418443"
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="155418443"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2020 17:53:54 -0700
IronPort-SDR: DO7YEgSsi/zSZCdemwDt1pt8t8MHbaZJ+S5iPXFSjHbrDvKblRT70lA3ZUaaAJztLBCprMi98G
 Zvwi+5YPKlgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="497814420"
Received: from fmsmsx603-2.cps.intel.com (HELO fmsmsx603.amr.corp.intel.com) ([10.18.84.213])
  by fmsmga006.fm.intel.com with ESMTP; 20 Aug 2020 17:53:53 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 20 Aug 2020 17:53:53 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 20 Aug 2020 17:53:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 20 Aug 2020 17:53:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DzcfZvRvUQ8H1QPJltkecqcVxo0hhDF7ABhaKpxiUR1JwcI/6oXxn+P4qmJ5Fxns+Z6XVj7D18VgvRjJnaIGuad+otDHaJDjTdcsAXlvys8typgGHW5uQGY4y2TbhrOPR4iOh5bBP9yAwvrTTPGMjwvgDojmHSHfk3THiPydEnXrEvOQzLl0WeyLy1HoNNOPcMOlqSFz5zQK+PDRZc9lWYPbH4CdX8t40F/Ca/y7vFz/7eOZVvLWv9ReSTsgS0MfInKpxBaMhB0L/qTqmqgx8S5rYL2rOneZj8OYjhv2ZWDvAFGg59/F0aBmXCWPQzrrg31NRkqvZ92RyuECuWjj7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGtTwoTDKYOJzPRFMweWBbjkLv2DXlwkeCIl1ymRuyo=;
 b=NHLwfUuePsyrCILWCdRQMznGUfwOIBZ0OwRnzEPYGqa50N/0hmReSSucLILI8IqiNduJHhu8SFzmteh2EktZSr3LKJNInXpfgORce/AAeWifSGZX2JSDVxocF2lLc53udHxRPsLs8YcnfJ9J1NtBRz2PaAFgSHx1s/ehE7nB9aWJmt6TL3AjebmQsNMzJsf/X6mncUIHkIAssQSCVUJFai0y+YikSQHwuxFqX1pIu+lPJ0RqE5z2+dImEnbfx6PYKkovDKjxiiiqwbqpSaJwIj+dQBUasqK6YskjBETslIDBPP1hBvxQhTAvPEyisI9jymo/2zIxTfAA924ytMsiZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGtTwoTDKYOJzPRFMweWBbjkLv2DXlwkeCIl1ymRuyo=;
 b=oByEL4n2l1q6VyHfrmkZd1t4H50pKbuRuDeTLoSFMuLPgBrZQ1OV9DToM5uudEpvQWxIsR3Pr1GZKam3H66UrLEZN0/dVj3ryfmWAKRYQrLQwYVoA54v/RkmMJScP9rllqtNk/+6evEhmvCu8Ff7litp39xAalSg/CHkGIlUysM=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3196.namprd11.prod.outlook.com (2603:10b6:5:5b::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.24; Fri, 21 Aug 2020 00:53:49 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3305.024; Fri, 21 Aug
 2020 00:53:49 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 12/15] vfio/type1: Add vSVA support for IOMMU-backed
 mdevs
Thread-Topic: [PATCH v6 12/15] vfio/type1: Add vSVA support for IOMMU-backed
 mdevs
Thread-Index: AQHWZKdGYVW899YIZEKAgl5vKmGxWqlBrhWAgAAzauA=
Date:   Fri, 21 Aug 2020 00:53:49 +0000
Message-ID: <DM5PR11MB1435AF11115CE8FEF6977BCAC35B0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
        <1595917664-33276-13-git-send-email-yi.l.liu@intel.com>
 <20200820154853.21b660d2@x1.home>
In-Reply-To: <20200820154853.21b660d2@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [117.169.229.112]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92d43066-f0e8-482f-3908-08d8456caa8a
x-ms-traffictypediagnostic: DM6PR11MB3196:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3196C64F65A28F790CE96916C35B0@DM6PR11MB3196.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bK1buVi53xF5YLcH8IwzAeMtLqcTjfmHosnkLUDqJxskfJRgqD6y/cGgWKxeEldDUPHHhPgZiKOhKQkhgZpYSQgiIYf7kSYUKrmEq3sqMDWc6G4Kr+Kj4RrtHf+TBBp12ycJeAyHIYUj8qCevJURc7d0hkVa+auZ6x90ewRBinQS/Nn+RvYkPt66LJKFwdgFB0kIQDi7rQ+peQUSRDms/LvNhH5N7PAz8fnEp4eS0BhLvgKQ2Rgq4uS7qOnM/cAmRFT31F7VOooMc280n4+H4LKbdJjmyL5B5gLa0h9CNOWPu8rhxFYJkqwraj2az01HgUwTtGTVW7aY1G6L1AAWzj8S2OPkeX+/P1cHLLbywTaY/2bLONHfGS0i+1rmP3i2q3YwaXMizcdHGonkjNnQq8qmKvnKE2QcAj7oZTwSfp9gxx8d8e9eg3FHAZfWQVx7K0w2KuQ31XMLgox4JzN7umxJmxmlVHTuceG2M4y0IJgUQapUpy5gZQ4xy2lXx/5U
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(33656002)(83380400001)(71200400001)(478600001)(7416002)(66946007)(76116006)(966005)(2906002)(55016002)(8676002)(9686003)(4326008)(64756008)(26005)(54906003)(86362001)(66556008)(7696005)(8936002)(66476007)(316002)(5660300002)(66446008)(6506007)(186003)(6916009)(52536014)(43620500001)(15398625002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 72HhEyMeI6srLpGtHglph8bypkD2wY0hOUPBMzWq/qe1mLNgMDhlzWtpkqbIrXioMVLfXouNhTV8O0/l/wme93Z00nO6JiymkziNFP0w0T+bJ9iLLIvdUNhCz5LIEBxjdnMT3Oniw7nFTC4Oxt/2u6cx3Zibt37HOek/nQ6ASv+2UQoAkSbFiG+efebnjUksknYzDnU0BP1aXCwZ0y9P+BXmHoxQXKzy72Ym2LrnOdzlG04SBB7yRtJg6NzCxfZ8+cj2gILmnRZQmtCON8CZBFSwrPohrAErLqO1/+ZkEgSOMFq7B7qbbf1lNX2LRD5kyGbJ9iNJ2SHQO3ScqEG+enoxgRztm2eytnn8Gc27gil7RB9K77wUQE0onfhD9Psi67ywmjrxG0IHPBErfDWkV7NSNUiH/K8I/sRSqpIH0WAa7yMHCAisXEPAgQ98opIaWzrQ4UypdvsjwqdojVTgLUAAE03EhMYdFbcsT8YZ8xywYVl3R0v4yQV4fqwYoxrQ7JHHmdeEJWYAeabXbkuQVAE8HAK3F9mZUL16DJWpFv+rZbbSAWqQOKKmOhdWHTZGt04Bc/tsgkVF5S73IquYKAIczPSPjqw/oMC0k5SiXcd8n+IKtMMpXLXL+pNzoSWKtiZ8wXkPRT3MmFCEzs07Vg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d43066-f0e8-482f-3908-08d8456caa8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2020 00:53:49.1155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9A30hjau1HcTby0DZdmEUktVB8pLV+3YW9nmRoJsrkir8I+NH3Z45gjBgjn6wj+uVR+AZTPIesVhwp7Zzi/WYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3196
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, August 21, 2020 5:49 AM
>=20
> On Mon, 27 Jul 2020 23:27:41 -0700
> Liu Yi L <yi.l.liu@intel.com> wrote:
>=20
> > Recent years, mediated device pass-through framework (e.g. vfio-mdev)
> > is used to achieve flexible device sharing across domains (e.g. VMs).
> > Also there are hardware assisted mediated pass-through solutions from
> > platform vendors. e.g. Intel VT-d scalable mode which supports Intel
> > Scalable I/O Virtualization technology. Such mdevs are called IOMMU-
> > backed mdevs as there are IOMMU enforced DMA isolation for such mdevs.
> > In kernel, IOMMU-backed mdevs are exposed to IOMMU layer by aux-domain
>=20
> Or a physical IOMMU backing device.

got it. :-)

> > concept, which means mdevs are protected by an iommu domain which is
> > auxiliary to the domain that the kernel driver primarily uses for DMA
> > API. Details can be found in the KVM presentation as below:
> >
> > https://events19.linuxfoundation.org/wp-content/uploads/2017/12/\
> > Hardware-Assisted-Mediated-Pass-Through-with-VFIO-Kevin-Tian-Intel.pdf
>=20
> I think letting the line exceed 80 columns is preferable so that it's cli=
ckable.  Thanks,

yeah, it's clickable now. will do it. :-)

Thanks,
Yi Liu

> Alex
>=20
> > This patch extends NESTING_IOMMU ops to IOMMU-backed mdev devices. The
> > main requirement is to use the auxiliary domain associated with mdev.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > CC: Jun Tian <jun.j.tian@intel.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Reviewed-by: Eric Auger <eric.auger@redhat.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> > v5 -> v6:
> > *) add review-by from Eric Auger.
> >
> > v1 -> v2:
> > *) check the iommu_device to ensure the handling mdev is IOMMU-backed
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 40
> > ++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 36 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > b/drivers/vfio/vfio_iommu_type1.c index bf95a0f..9d8f252 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -2379,20 +2379,41 @@ static int vfio_iommu_resv_refresh(struct
> vfio_iommu *iommu,
> >  	return ret;
> >  }
> >
> > +static struct device *vfio_get_iommu_device(struct vfio_group *group,
> > +					    struct device *dev)
> > +{
> > +	if (group->mdev_group)
> > +		return vfio_mdev_get_iommu_device(dev);
> > +	else
> > +		return dev;
> > +}
> > +
> >  static int vfio_dev_bind_gpasid_fn(struct device *dev, void *data)  {
> >  	struct domain_capsule *dc =3D (struct domain_capsule *)data;
> >  	unsigned long arg =3D *(unsigned long *)dc->data;
> > +	struct device *iommu_device;
> > +
> > +	iommu_device =3D vfio_get_iommu_device(dc->group, dev);
> > +	if (!iommu_device)
> > +		return -EINVAL;
> >
> > -	return iommu_uapi_sva_bind_gpasid(dc->domain, dev, (void __user *)arg=
);
> > +	return iommu_uapi_sva_bind_gpasid(dc->domain, iommu_device,
> > +					  (void __user *)arg);
> >  }
> >
> >  static int vfio_dev_unbind_gpasid_fn(struct device *dev, void *data)
> > {
> >  	struct domain_capsule *dc =3D (struct domain_capsule *)data;
> >  	unsigned long arg =3D *(unsigned long *)dc->data;
> > +	struct device *iommu_device;
> >
> > -	iommu_uapi_sva_unbind_gpasid(dc->domain, dev, (void __user *)arg);
> > +	iommu_device =3D vfio_get_iommu_device(dc->group, dev);
> > +	if (!iommu_device)
> > +		return -EINVAL;
> > +
> > +	iommu_uapi_sva_unbind_gpasid(dc->domain, iommu_device,
> > +				     (void __user *)arg);
> >  	return 0;
> >  }
> >
> > @@ -2401,8 +2422,13 @@ static int __vfio_dev_unbind_gpasid_fn(struct de=
vice
> *dev, void *data)
> >  	struct domain_capsule *dc =3D (struct domain_capsule *)data;
> >  	struct iommu_gpasid_bind_data *unbind_data =3D
> >  				(struct iommu_gpasid_bind_data *)dc->data;
> > +	struct device *iommu_device;
> > +
> > +	iommu_device =3D vfio_get_iommu_device(dc->group, dev);
> > +	if (!iommu_device)
> > +		return -EINVAL;
> >
> > -	iommu_sva_unbind_gpasid(dc->domain, dev, unbind_data);
> > +	iommu_sva_unbind_gpasid(dc->domain, iommu_device, unbind_data);
> >  	return 0;
> >  }
> >
> > @@ -3060,8 +3086,14 @@ static int vfio_dev_cache_invalidate_fn(struct
> > device *dev, void *data)  {
> >  	struct domain_capsule *dc =3D (struct domain_capsule *)data;
> >  	unsigned long arg =3D *(unsigned long *)dc->data;
> > +	struct device *iommu_device;
> > +
> > +	iommu_device =3D vfio_get_iommu_device(dc->group, dev);
> > +	if (!iommu_device)
> > +		return -EINVAL;
> >
> > -	iommu_uapi_cache_invalidate(dc->domain, dev, (void __user *)arg);
> > +	iommu_uapi_cache_invalidate(dc->domain, iommu_device,
> > +				    (void __user *)arg);
> >  	return 0;
> >  }
> >

