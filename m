Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B53232F9E
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 11:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbgG3JhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 05:37:14 -0400
Received: from mga04.intel.com ([192.55.52.120]:1937 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbgG3JhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 05:37:13 -0400
IronPort-SDR: 4XyujDS8WIXLghFD13rWg4jNzHVOeL/+q7YdhfyS/i/heJL08VBYU7n0xLguMOoEE7akc1fA4Y
 RjZLofyDmeuw==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="149027696"
X-IronPort-AV: E=Sophos;i="5.75,414,1589266800"; 
   d="scan'208";a="149027696"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 02:37:00 -0700
IronPort-SDR: gRv0EasT6GQ/0vzQt55khpS4jRRM7UiETxHjA5SMnZSBuQXanAPj8n2kinSCHn97xcIzrSWw0l
 i8XFZbNz2Abw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,414,1589266800"; 
   d="scan'208";a="272878097"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jul 2020 02:37:00 -0700
Received: from orsmsx161.amr.corp.intel.com (10.22.240.84) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 30 Jul 2020 02:37:00 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX161.amr.corp.intel.com (10.22.240.84) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 30 Jul 2020 02:37:00 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 30 Jul 2020 02:36:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DYSb2C6hkSBxzB5DQRRXYUTam1M984W8Dt55WZa76k9UITaDAxTZD3rRqxQuTn1cHrsTQArTmKAyySufaivi8dwKXqkLncZZdHIxh+VbhXIMq75RSIFVwAmoNrF0FWTp1ct3lg9DAFypatDE080TLqtTT86SSseiMU7h5YP8IxB7A0LVD5JkzPClz6rFmUrf3VL6XKOyOPFxkpI7QZN2E0qJoT4f3cAOdHiqxuMWCjZe7HxKfMrCHa4uU6cG4ICRfwRkv2pNDyyyFlkzel74hnL6bhr67o9AAFo5nHeYLQS1nH/0SdsN+Rj4rOzsNHOi+vCrFI/45T+AgtT6zOj8OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AlpTjAmVZcdPMDompfOzNbjxGNwsHD5jL5IKl6IvE0=;
 b=hHkcq06ETfxRynXoGoxXqvHGo8cE7SMgniyqxrc9zaOqP/iLTXRSNOoucnxlPKEKZ1ekhXRzUW6T5IuQICy+NwtA2euSGHl6ZBRZApeT7vvYZnpE736KD0gIUuRN0Q2hNdHQReQaSdCM23lHtvXnBi4HN2ST0wfRFX4iZS7uvr9O5nC2wW78MstIP7HTLJrZuJOivmFKCKubJOdCVZXCysLkDal0yFa8cGGKgMX8squU64pglPO9y4xQUo9IfoMyfIvAtLjelJZNOWuXyIf7CqpobnqKz8F9nKLuTitH9dW7xv5SeYjYbiWMl0n2g5/kMeRCzbgpqOV5WlDykVJB+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AlpTjAmVZcdPMDompfOzNbjxGNwsHD5jL5IKl6IvE0=;
 b=WIy2McQg6icVrcup+WwG+ADMXAR7MVYCBMi0ngn3MOnKzLWFMy2WLyreuuS0zpc2Qu2bTXDjgt/z5auU3WF27IFLXxDUzsZKHHjHsIo5BOSTG41AIZ8YIxIlNpjbyhh9vCPo/4i14pDNHvz5OtJZc+bEusaNW/9anu+H/pT5SBA=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3067.namprd11.prod.outlook.com (2603:10b6:5:6a::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.24; Thu, 30 Jul 2020 09:36:58 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3216.034; Thu, 30 Jul
 2020 09:36:58 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v3 4/4] vfio/type1: Use iommu_aux_at(de)tach_group() APIs
Thread-Topic: [PATCH v3 4/4] vfio/type1: Use iommu_aux_at(de)tach_group() APIs
Thread-Index: AQHWWaRWyngsNDGINUqk8kDgSaetUakf9XtA
Date:   Thu, 30 Jul 2020 09:36:58 +0000
Message-ID: <DM5PR11MB14351AE909E031B578EA3170C3710@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
 <20200714055703.5510-5-baolu.lu@linux.intel.com>
In-Reply-To: <20200714055703.5510-5-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.102.204.45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea45cc8d-dd0d-4af1-42c9-08d8346c1af6
x-ms-traffictypediagnostic: DM6PR11MB3067:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB30674CA71F58FB2F128FC05DC3710@DM6PR11MB3067.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:422;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IjZrxhNxemeFlx6A5PnPsjbpejbvOx37tsLAXdcvLZ5kPV+coiiHkJZU9fm4ycF6Lv29HpPQA8f4D5Bs9Q/3jtBcBKndbYkIXqd9dPIJE1lMZOxXjIWE3MtDCY6SHpyiZ5SstjjWcCMvvDuKUUn4KEmf51H0DgPTHAIyBmqwLrgmq4tbE80i4JLx07e6mcwQJcu2MIy9WG6t3OTvyGbSbxV+LWRar17OxHX8myKLzOC14BlXAMKJ4aQ9jaYL7nlCTi9MZFkFI0E0Gz/mNYWkm7ghV1sCkNjdWZKY4ubo/GtWz8sFl11/ZNlyxcrzh56D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(110136005)(54906003)(9686003)(316002)(71200400001)(66476007)(64756008)(6506007)(66446008)(86362001)(33656002)(7696005)(76116006)(83380400001)(66556008)(8676002)(66946007)(186003)(4326008)(52536014)(5660300002)(55016002)(8936002)(2906002)(26005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: JHy24Bo2O2hHsEPI2VKMwPcrGpuuIgTylFCp4y47h0i5g7D8OiP+9eg40fClSAM2bCiyy9I6Ek0lDcbRK6NVw7AbqexbHnbAuWit1WvHIFrdvFi/UN0Upq1gL39FC8QIUMJ5kLNoIstJIIi3JnypuFgOwztYkola1TSNdXcL9rJf3yZBHmEdaN49EE7rZXcIQHshDBAkLHtQcyz/geTWexhDV6pwfEmc72/e+Gtm/UjqitV0RUQLs2cuD1mViShA10WyqJqCUEYC8AS4k+EjVqkEm8mMe1RcFDckmf2WmllnAWSIMVGyoGFtZrQC9zjcUtiCtMTig8RaVNBBbJvj/ADl9HQDpg+rm9Whn0Ca6W9mx3Kq3xbqrZUXtke2/DSq85WRMl2MlsgRjKGmhgEsmTkRMLDNIb7dqh2TKyJOCh8EJS2Hy2hYFQwr/uR33y2ev0lyN/C87Fuub5TjQDecfWCZGNLt3pKuB71b/dn0H2HSfk0GSgPynp6YrEoN7Si2
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea45cc8d-dd0d-4af1-42c9-08d8346c1af6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 09:36:58.5494
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8bAJACR52pCPEb9DNyLepIcNTFdu0iYC1qr0x0taX6gqtoG1/GYdnHGN/Mu62CZ76W3nHMrAw1vv4T/fNwLA1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3067
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Tuesday, July 14, 2020 1:57 PM
>=20
> Replace iommu_aux_at(de)tach_device() with iommu_aux_at(de)tach_group().
> It also saves the IOMMU_DEV_FEAT_AUX-capable physcail device in the vfio_=
group
> data structure so that it could be reused in other places.
>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 44 ++++++---------------------------
>  1 file changed, 7 insertions(+), 37 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_ty=
pe1.c
> index 5e556ac9102a..f8812e68de77 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -100,6 +100,7 @@ struct vfio_dma {
>  struct vfio_group {
>  	struct iommu_group	*iommu_group;
>  	struct list_head	next;
> +	struct device		*iommu_device;

I know mdev group has only one device, so such a group has a single
iommu_device. But I guess may be helpful to add a comment here or in
commit message. Otherwise, it looks weird that a group structure
contains a single iommu_device field instead of a list of iommu_device.

Regards,
Yi Liu

>  	bool			mdev_group;	/* An mdev group */
>  	bool			pinned_page_dirty_scope;
>  };
> @@ -1627,45 +1628,13 @@ static struct device
> *vfio_mdev_get_iommu_device(struct device *dev)
>  	return NULL;
>  }
>=20
> -static int vfio_mdev_attach_domain(struct device *dev, void *data) -{
> -	struct iommu_domain *domain =3D data;
> -	struct device *iommu_device;
> -
> -	iommu_device =3D vfio_mdev_get_iommu_device(dev);
> -	if (iommu_device) {
> -		if (iommu_dev_feature_enabled(iommu_device,
> IOMMU_DEV_FEAT_AUX))
> -			return iommu_aux_attach_device(domain, iommu_device);
> -		else
> -			return iommu_attach_device(domain, iommu_device);
> -	}
> -
> -	return -EINVAL;
> -}
> -
> -static int vfio_mdev_detach_domain(struct device *dev, void *data) -{
> -	struct iommu_domain *domain =3D data;
> -	struct device *iommu_device;
> -
> -	iommu_device =3D vfio_mdev_get_iommu_device(dev);
> -	if (iommu_device) {
> -		if (iommu_dev_feature_enabled(iommu_device,
> IOMMU_DEV_FEAT_AUX))
> -			iommu_aux_detach_device(domain, iommu_device);
> -		else
> -			iommu_detach_device(domain, iommu_device);
> -	}
> -
> -	return 0;
> -}
> -
>  static int vfio_iommu_attach_group(struct vfio_domain *domain,
>  				   struct vfio_group *group)
>  {
>  	if (group->mdev_group)
> -		return iommu_group_for_each_dev(group->iommu_group,
> -						domain->domain,
> -						vfio_mdev_attach_domain);
> +		return iommu_aux_attach_group(domain->domain,
> +					      group->iommu_group,
> +					      group->iommu_device);
>  	else
>  		return iommu_attach_group(domain->domain, group-
> >iommu_group);  } @@ -1674,8 +1643,8 @@ static void
> vfio_iommu_detach_group(struct vfio_domain *domain,
>  				    struct vfio_group *group)
>  {
>  	if (group->mdev_group)
> -		iommu_group_for_each_dev(group->iommu_group, domain-
> >domain,
> -					 vfio_mdev_detach_domain);
> +		iommu_aux_detach_group(domain->domain, group->iommu_group,
> +				       group->iommu_device);
>  	else
>  		iommu_detach_group(domain->domain, group->iommu_group);  }
> @@ -2007,6 +1976,7 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
>  			return 0;
>  		}
>=20
> +		group->iommu_device =3D iommu_device;
>  		bus =3D iommu_device->bus;
>  	}
>=20
> --
> 2.17.1

