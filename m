Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB6C3F9236
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 04:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243918AbhH0CJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 22:09:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:61899 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241128AbhH0CJb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 22:09:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="217883264"
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="217883264"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 19:08:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="537880349"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga002.fm.intel.com with ESMTP; 26 Aug 2021 19:08:43 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 26 Aug 2021 19:08:42 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 26 Aug 2021 19:08:42 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 26 Aug 2021 19:08:42 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 26 Aug 2021 19:08:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AvPn4/rqS8toje8gd5sI72UwGjXZ7VFJUu0J1apeulfDwKswYjBU+42BBC+qBoO2hDIfJQhXPaaBxrEaVY9IiP3OIIkUycQPzNeN2LiQ8MHz7UwqQqIQFTuQF0nWsRJZMwPe/V0VFlhrG+mKA/1cg0k6sH9mkny1T/2nOEUsI22e0LvFzELdrNcTuevQeXpsyNEXtSUT+edVWBm0YGUDpqWqloAA6vVP9MrYlP/5y7mCCDepXVsAnSmJ3gPfXxueKykO39iU5t433KOBj7rM5IzWC9UqEwHsOqTZ7rSmnnvu57rAZrBoLpYo3phD02YZpt/ZjzvkJe84w8FbpkIdug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qc2YDk1hMzUZfERJXljkNuLBXDFvHpQ2ddMYu6XwofI=;
 b=hCsV+t9t00PcsxsPgUNg+Yolfynl9YGOV1trSYTOl/K4a4wxqAVuXYfnlfqZP6ndoi6IMQWhCjdw8m2DWBbwAeZ/YM2QNWNnzubbD+vJv+S31CY7ToJ+z0vjsxh3lVeu0m/g6etIrDJYfjLdkoP+NnFEhiJp5NOyuk75114NB823Hh0B2W0vXjTum8ldCJjeQmn/XgcnjK+FNYpSJbUoAEAekgdlzJuAh4sWHaqlty6F4diV51YygseQAQ7PZAUbOS8C+IVYLASo7r/HkR0OgeAAWd4VHJMJbJd1ETL+3f0qOZooZZndiMsuA4prVuhSfplFznkYV8GwDgBR2k+lpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qc2YDk1hMzUZfERJXljkNuLBXDFvHpQ2ddMYu6XwofI=;
 b=T9O/u0amZj2uX9tz6584II8qbY1qoTQWwRFEquQyzxTq/kr2ayByBWcY8V3G/KiLCB/39Uz3AxoS1RxtuQl8N4ClFBwW4s2lq7ov+YNb5grA79aVE0LSggf5yNgd803IxPtV4XWLSx/FY9Nyad+VJxLuuPd919Tx/E+q3MKbVQQ=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN0PR11MB5709.namprd11.prod.outlook.com (2603:10b6:408:148::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Fri, 27 Aug
 2021 02:08:27 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%7]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 02:08:27 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>
CC:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH 05/14] vfio: refactor noiommu group creation
Thread-Topic: [PATCH 05/14] vfio: refactor noiommu group creation
Thread-Index: AQHXmoAlghYj1vuUxEaTXPc9Iba5HKuGY64AgAA4DLA=
Date:   Fri, 27 Aug 2021 02:08:27 +0000
Message-ID: <BN9PR11MB5433077FE13B405A7DA86FBA8CC89@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210826133424.3362-1-hch@lst.de>
        <20210826133424.3362-6-hch@lst.de>
 <20210826164726.5bb6a027.alex.williamson@redhat.com>
In-Reply-To: <20210826164726.5bb6a027.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b45e79a6-9658-4af0-e17d-08d968ff8eff
x-ms-traffictypediagnostic: BN0PR11MB5709:
x-microsoft-antispam-prvs: <BN0PR11MB5709596F4DDA19BACE678AF48CC89@BN0PR11MB5709.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0IkxU3w+f+klm/zzRYu/UtFxGBmbVfdYn8JKk0cE+Hemp6te8Gcyz7z+XhM8JCUnKkHxlgY2YheAQqBl4sOiwPOBMwMrlDi1WyvQAk7gLa0sAWsHtOvnk8p0VTIDVDNfvDFWtSdbrt6YSeOHwikTReQm+sjEnLExUdb6FYvIw8r71oAx8g/5C4lSQEnD41qPAN/BO0316GLH5pEk4E1qPZy7r5Ggqzn7PXkLFsbxQ9VLlXVXgLdIvKTYYwvxxF32jB1ZCcTvmxGKhAgKfmtc3NZWgWf/kDdKqDWnpRQaoXAci0kg+w3+Xq7ngameCfiy4/ikoS4p4kyqcPNmZLdDsgdJXsQxYK4htqh/0d2Ct5b19p/jzHKMqMGYnZHL7LKJC9YS8Rks4qikxnwoP3u9i4T63Sd6nPk5S6+7j0rruXM3JtzjTznPK55fIVv/mKlh8GULvFf5oAMc8o1QiFNeuECLRdRcuWNbvXDCfWrSnNvmY7OPFJ8Nsou4nG+TlA6bYYtQRVPRp8t0WodM3efZXWbOE0dUWiJafM9++dPXdjgBJq9RuG6YO9WHkmsspo2j2XNpVtba1xOw4VYX2ciwxea/L8I/h8wprSXVSGdyL4FvkejYT6JhmjZzYAzsWDseBqlEpAekwlLmM9vUdlxSjKimyuTslWFXyE/6ARq46mgMur+xvGUJrwITyeixOJ+mQccrhm8DDK+YkDBaARkj8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(38100700002)(4326008)(122000001)(2906002)(64756008)(52536014)(55016002)(9686003)(5660300002)(71200400001)(38070700005)(66446008)(478600001)(66476007)(186003)(54906003)(66946007)(66556008)(8676002)(76116006)(26005)(83380400001)(6506007)(33656002)(110136005)(316002)(7696005)(86362001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XlLkGwgNvlZlAvYcoB/J9kyf8WshTJlpAHz84G9pBHarxyr51ywIk/p5SxYE?=
 =?us-ascii?Q?CTC0vP9CLoAiKN8bkzYXqlIOZj/lBGggM6yKMNer9VCdr1nuQFhdWL6NZvk9?=
 =?us-ascii?Q?WmHblfsqPjPjh2DH3xG7B7S64f9fVlTG9bL19/8w8An2acsdA1cUHSfbIokb?=
 =?us-ascii?Q?UC0FeB2GWK226SJxbSdPiIaQgJobNMRUITXCcRi1ANvcFD3Hzz5tB8IpecaH?=
 =?us-ascii?Q?1/3TlLd8E9ebUTZOYhAzRGRIQh3/I9HJoc421zilIU+flIQ6mHpGDRu+CFdV?=
 =?us-ascii?Q?xZ6QJ7gQVl2FZ2pp3lVt7ynBT/HU+2jC98kVhdDWnPcUKdFBgq1au/xEzGJb?=
 =?us-ascii?Q?H9i3ee8CrPNsXQog+8u4s5XsG6GZRXGF8LdX2g7hH4E8fqg91b1ExMYS7JY7?=
 =?us-ascii?Q?g9he5r0NkkbDGyMSNvic8+QPrMflSo9YpqR8i5Jqz8hYDjKTjiO2OmRdSD2t?=
 =?us-ascii?Q?wbi6z7e/i6o4yWmpOWRT30lBT7x+KYZNvbI3m/JuUKwrv50Jl4FWdkplvZ7o?=
 =?us-ascii?Q?B2Yb12nj595N01s1deE3BgwT9IWyBbsu2bE12G85GGIsrJPf7GN5JlMNuWgR?=
 =?us-ascii?Q?9EqhLR+VtZ0IpRKdj34NncLs8JFK1UB3JT6My0DWyHCnB/NMjx5zVPfxPad1?=
 =?us-ascii?Q?fZoQVrP7AIH5U8LoeM+T3J+mnLgpwR2mKVH00XuIhh8Py1Vy2aM1+Dq0Wl1n?=
 =?us-ascii?Q?N5P1iuHB6DxyLJpfYO5ntHzRt+N0lO36AMTYo+clX+tqVAjPQyqRiddJT9IJ?=
 =?us-ascii?Q?f17OtU9iNVsSn/c8sBsrG/80RRLAxc6Bh5nm47mNHv3AIszjdb5kArlnZIc/?=
 =?us-ascii?Q?IF3R4NmaGkYBIiYsqUSxwvtPHncesiiht1msvVjuMpIhb75frQFNJshZRwpQ?=
 =?us-ascii?Q?lhQGlgXx5S7EVIY8E1CjIBqipmuXTMwIWVF1nAH1vHU6EhL1AuhpjizFfLds?=
 =?us-ascii?Q?nQKUA10HG1h2d9sx/NakmNcwUT5XJ0G+AAo93kQ5nBLr9tLNGN2se918rGCF?=
 =?us-ascii?Q?i0bIEnxnyZJog7OVj6+GJxyhVHeTO9UyHmJZUKKGMVSpp7ZC//NvFIEzBo2n?=
 =?us-ascii?Q?2yxwnkD44/2ACDjy3mIF2zt0OXRAh9boKlVl4QIr7goJLzDiRnLUt4mKLWug?=
 =?us-ascii?Q?cuD77L06PviUl7wwYM1EbHGGaYCf/tyCCiAWjW9D4DGcdSC4Akf5B19JRglM?=
 =?us-ascii?Q?2nUde0gIgxFm67ptXHP9qN5JwjKFmWdwuHL0eU3jei7elT1Sq3hJs/5Dd/VA?=
 =?us-ascii?Q?+Asdx6qpaCBdFQ46ZmPvzhzBBBgv/rB5JEdH7r97QOhTUphjQXdtvErf6BEQ?=
 =?us-ascii?Q?yemJjWDddnIdnMyIVQ/WsJcq?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b45e79a6-9658-4af0-e17d-08d968ff8eff
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2021 02:08:27.3096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EdC1SuObNRU575piIbjLTfDsuw5SJlp4pSa7kG5eOavMGw33rUdb49veILLTMkx7V1BT/A6+rS0BOkSYjcbqjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5709
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, August 27, 2021 6:47 AM
>=20
> On Thu, 26 Aug 2021 15:34:15 +0200
> Christoph Hellwig <hch@lst.de> wrote:
> > +#ifdef CONFIG_VFIO_NOIOMMU
> > +static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev)
> >  {
> >  	struct iommu_group *iommu_group;
> >  	struct vfio_group *group;
> > +	int ret;
> > +
> > +	iommu_group =3D iommu_group_alloc();
> > +	if (IS_ERR(iommu_group))
> > +		return ERR_CAST(iommu_group);
> >
> > -	iommu_group =3D vfio_iommu_group_get(dev);
> > +	iommu_group_set_name(iommu_group, "vfio-noiommu");
> > +	iommu_group_set_iommudata(iommu_group, &noiommu, NULL);
> > +	ret =3D iommu_group_add_device(iommu_group, dev);
> > +	if (ret)
> > +		goto out_put_group;
> > +
> > +	group =3D vfio_create_group(iommu_group);
> > +	if (IS_ERR(group)) {
> > +		ret =3D PTR_ERR(group);
> > +		goto out_remove_device;
> > +	}
> > +
> > +	return group;
> > +
> > +out_remove_device:
> > +	iommu_group_remove_device(dev);
> > +out_put_group:
> > +	iommu_group_put(iommu_group);
> > +	return ERR_PTR(ret);
> > +}
> > +#endif
> > +
> > +static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
> > +{
> > +	struct iommu_group *iommu_group;
> > +	struct vfio_group *group;
> > +
> > +	iommu_group =3D iommu_group_get(dev);
> > +#ifdef CONFIG_VFIO_NOIOMMU
> > +	if (!iommu_group && noiommu && !iommu_present(dev->bus)) {
> > +		/*
> > +		 * With noiommu enabled, create an IOMMU group for
> devices that
> > +		 * don't already have one and don't have an iommu_ops on
> their
> > +		 * bus.  Taint the kernel because we're about to give a DMA
> > +		 * capable device to a user without IOMMU protection.
> > +		 */
> > +		group =3D vfio_noiommu_group_alloc(dev);
> > +		if (group) {
> > +			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> > +			dev_warn(dev, "Adding kernel taint for vfio-
> noiommu group on device\n");
> > +		}
>=20
> Perhaps what Kevin was pointing out here in the previous version,
> vfio_noiommu_group_alloc() returns a pointer, so this should test
> !IS_ERR(group).  Thanks,
>=20

yes, that is what I meant.
