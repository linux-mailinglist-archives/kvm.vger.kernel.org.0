Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6281F75AC
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 11:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgFLJFa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jun 2020 05:05:30 -0400
Received: from mga06.intel.com ([134.134.136.31]:25769 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgFLJF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jun 2020 05:05:27 -0400
IronPort-SDR: KOcgJP9GPsZ1xQVFPtkfIyjGu34RkxggutI42pIxAjWggV9AjaW1xff1Dx/eftgSmvdqhQfrI7
 u8DwbVNTMdWQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2020 02:05:26 -0700
IronPort-SDR: ZcautvsGOR1wn07eNlPC90coy3DHAMJdobA5HQ2U3+a7rfii17sUj5ry6sz+T9ILtca5yN3FB6
 wU94ERPJKAEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,502,1583222400"; 
   d="scan'208";a="419405201"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga004.jf.intel.com with ESMTP; 12 Jun 2020 02:05:26 -0700
Received: from fmsmsx102.amr.corp.intel.com (10.18.124.200) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 12 Jun 2020 02:05:25 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 FMSMSX102.amr.corp.intel.com (10.18.124.200) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 12 Jun 2020 02:05:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Fri, 12 Jun 2020 02:05:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OrCl9yR0yYd++zTaHDeuKw64hRaDvrC4pUsFgrgOddXxOguDwAAPiMpfvj//HBz0GUoSrtoJo3zhWe7rMQBpT+SB0QfX1khiz0P8jdv0ZdxCgUdkHLYxC34nRfYDy0O4Hp4ZHFhtaHmLTX7SKb4j2SbNPRAMUAeWu8+rtpR4DNNh0m4cUYnHG49FByyAOjw9o29yyxvf4Lw1XdN9M1KJCgn7anCLQqfct6lE0QJleMqhHDdko4iM2JedEjndjSKY7xYSgtB5NG3icrswpuVfgmUcM3/dBH/+DJIB42I2ZDosFYHS3n2DRNhpgJbg0eINIxa2l3iwEGo58/eVnMrWtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1H8MOHGfQlAgGRzzViYguFMa400367o2qaxs9cov1Y=;
 b=JyHl7dGFN73MVvzBBFzbf74fWKrBz8XZxCnqm5Kyml8YorYl28NwXp0qeFGPGxg/D2bmcEoqTSGsyCCMqxDuRhj0YmAoOsAV6F5/VpEpqKe9WfxxmrtSk+xgrycZHh2jo8UFie08zVxPx6PygOKFaUiChZ7+/Lyk2bOCn9xAPIEj5RpfDRQhGm8/PFsDLCBYch/4F0Ru+qjsDSAAr0Hg+Tj/cYLwbkDdt8x9A7vdhkSvCOuhOI0gDEZiKmZKa8WTokrP9D3miN+eYWctmfZWh1rT75UvCDAdDtV1JxuaxpzSjj+Xjq/hVnQsFursnaJ4sRQr2tSXhPmgeD563+7UzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1H8MOHGfQlAgGRzzViYguFMa400367o2qaxs9cov1Y=;
 b=daM1uAybifHsnlNrfdpAaFDYvniyespcSPOWqHqZ/Yhc5evutJjVMhP34NBcErZ9fOYJj1byXQKyLX9IMVCO+pEBScUilKKEretgJfkQwyK910VxsES+wWPL2i375VfR4zv28uL8hpwCrDzN+o6K9VVTdYsMkZkHZbsBQZrDFV4=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB1673.namprd11.prod.outlook.com (2603:10b6:4:c::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3088.24; Fri, 12 Jun 2020 09:05:23 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::2c3d:98d9:4e81:c86c]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::2c3d:98d9:4e81:c86c%6]) with mapi id 15.20.3066.023; Fri, 12 Jun 2020
 09:05:23 +0000
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
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 02/15] iommu: Report domain nesting info
Thread-Topic: [PATCH v2 02/15] iommu: Report domain nesting info
Thread-Index: AQHWP+lAvgybSaO2NECN4P16s7e2zKjTzaSAgADgFXA=
Date:   Fri, 12 Jun 2020 09:05:23 +0000
Message-ID: <DM5PR11MB143571773B05359FA2F46FB6C3810@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
        <1591877734-66527-3-git-send-email-yi.l.liu@intel.com>
 <20200611133015.1418097f@x1.home>
In-Reply-To: <20200611133015.1418097f@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.46.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8e6e931-8d7a-4ef0-caca-08d80eafbd8c
x-ms-traffictypediagnostic: DM5PR11MB1673:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1673F3EA03F7E0238EB96612C3810@DM5PR11MB1673.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0432A04947
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QHaqHWi3pwmjFZe9QXC59U92yxj1OWdBDz48EzKwLPlUWKe59oMpNwHBgsnhSlkRILJyIctObDjiKhU8nLv4AYp1/ttLoG3D0GGJhnzwyEyMsCPyj/hjVOkfqU3u0T7mB3CdDr6QPZ2Id8s/yBW+NHD1Vu5E/6lzZbnLd5ADMMEWf+duZFDxCQdtltTyNYPE+RkLTBFm5F8oMzX4D3qVHDg42Do+HfYOVECPdb7jicnpwJwyKHjuf4WauFpnRXuCyIc5ampMSUNrfgcRNDArb4YgNt8WvCqvIWeeid282TZlr8SfVc5U3xGZM31QK5w8treQbpHxTcJk+TMylDCUWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(136003)(39860400002)(366004)(346002)(376002)(33656002)(4326008)(71200400001)(55016002)(8936002)(2906002)(6916009)(54906003)(7416002)(86362001)(316002)(6506007)(478600001)(5660300002)(7696005)(26005)(8676002)(186003)(66476007)(52536014)(66556008)(66446008)(64756008)(76116006)(66946007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 05XlbDYxOlxGZNLc6qaSIyiVcuTCHiAbJRVO25hAcMuGtYXOS6lOCezHVkeiI+wmrpBxDmTOD4tETsLsF0dxzb3PJCIeiq0S7vfPi2VwNrpmje/gAHgMkkLJ0/KZgfMLLklo4B5mr14+VO+iDa5y4MbU1IUb/3O2v4a5Uca5BgMrm4vRMt3AkAmDAtyGj2z5RlAMknDTy3WGv01upfqzl9sO7/WX7rk0B/+ifwSmN04rjA5cjTutSR68DdNAV8I6ME2p5fO7EAO3pBGQFFFgvg2TVxC/9M4tsax/NIFgpvUTh2JC+jfSsUDbdKQmMHNuI+bDSTidbUG78ujT3xaJa6j4IPEh65vn7xPvM7g7uzw9MbVmAOzYEchdCqPhbk7/2QTwxo6DcT25k3yxEX/sKLG6t0frp1g6V521ZTZsldA4NLcAaGvhk3KbbBYJvVzdEyv6iLpXefMOZUUi3G9+bD6JZo+QAUTc5noLut7e4Qs=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e8e6e931-8d7a-4ef0-caca-08d80eafbd8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2020 09:05:23.3472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OLeFCRmTj27LrYaPawCtWnnBDbAdgd1IYsagibLqdq4n2yee6G5I6NWm2XwFJLTAEVURIEADIbWcDwBd7y+NPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1673
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, June 12, 2020 3:30 AM
>=20
> On Thu, 11 Jun 2020 05:15:21 -0700
> Liu Yi L <yi.l.liu@intel.com> wrote:
>=20
> > IOMMUs that support nesting translation needs report the capability
> > info to userspace, e.g. the format of first level/stage paging structur=
es.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> > @Jean, Eric: as nesting was introduced for ARM, but looks like no
> > actual user of it. right? So I'm wondering if we can reuse
> > DOMAIN_ATTR_NESTING to retrieve nesting info? how about your opinions?
> >
> >  include/linux/iommu.h      |  1 +
> >  include/uapi/linux/iommu.h | 34 ++++++++++++++++++++++++++++++++++
> >  2 files changed, 35 insertions(+)
> >
> > diff --git a/include/linux/iommu.h b/include/linux/iommu.h index
> > 78a26ae..f6e4b49 100644
> > --- a/include/linux/iommu.h
> > +++ b/include/linux/iommu.h
> > @@ -126,6 +126,7 @@ enum iommu_attr {
> >  	DOMAIN_ATTR_FSL_PAMUV1,
> >  	DOMAIN_ATTR_NESTING,	/* two stages of translation */
> >  	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
> > +	DOMAIN_ATTR_NESTING_INFO,
> >  	DOMAIN_ATTR_MAX,
> >  };
> >
> > diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
> > index 303f148..02eac73 100644
> > --- a/include/uapi/linux/iommu.h
> > +++ b/include/uapi/linux/iommu.h
> > @@ -332,4 +332,38 @@ struct iommu_gpasid_bind_data {
> >  	};
> >  };
> >
> > +struct iommu_nesting_info {
> > +	__u32	size;
> > +	__u32	format;
> > +	__u32	features;
> > +#define IOMMU_NESTING_FEAT_SYSWIDE_PASID	(1 << 0)
> > +#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 1)
> > +#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 << 2)
> > +	__u32	flags;
> > +	__u8	data[];
> > +};
> > +
> > +/*
> > + * @flags:	VT-d specific flags. Currently reserved for future
> > + *		extension.
> > + * @addr_width:	The output addr width of first level/stage translation
> > + * @pasid_bits:	Maximum supported PASID bits, 0 represents no PASID
> > + *		support.
> > + * @cap_reg:	Describe basic capabilities as defined in VT-d capability
> > + *		register.
> > + * @cap_mask:	Mark valid capability bits in @cap_reg.
> > + * @ecap_reg:	Describe the extended capabilities as defined in VT-d
> > + *		extended capability register.
> > + * @ecap_mask:	Mark the valid capability bits in @ecap_reg.
>=20
> Please explain this a little further, why do we need to tell userspace ab=
out
> cap/ecap register bits that aren't valid through this interface?
> Thanks,

we only want to tell userspace about the bits marked in the cap/ecap_mask.
cap/ecap_mask is kind of white-list of the cap/ecap register. userspace sho=
uld
only care about the bits in the white-list, for other bits, it should ignor=
e.

Regards,
Yi Liu

> Alex
>=20
>=20
> > + */
> > +struct iommu_nesting_info_vtd {
> > +	__u32	flags;
> > +	__u16	addr_width;
> > +	__u16	pasid_bits;
> > +	__u64	cap_reg;
> > +	__u64	cap_mask;
> > +	__u64	ecap_reg;
> > +	__u64	ecap_mask;
> > +};
> > +
> >  #endif /* _UAPI_IOMMU_H */

