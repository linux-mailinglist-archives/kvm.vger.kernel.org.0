Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F731FA66D
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 04:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgFPCY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 22:24:56 -0400
Received: from mga06.intel.com ([134.134.136.31]:12578 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgFPCYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 22:24:55 -0400
IronPort-SDR: 7BnkgbXTWFlDSsnvmJ04DlwbiiFI+occoTSRCcMH+8TuUzgu6zTLE/3JKq7HTFT8jAcCsr6+rQ
 wBdAE/ZNiVHg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2020 19:24:54 -0700
IronPort-SDR: R7aMeLfchfV34/hfpkLurSZuW6GC4dOwh8V3oPfRxVy+cFsniHX99wxkVwGMX9AaKFSyQqbWuL
 VAB0O4Bqo5zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,517,1583222400"; 
   d="scan'208";a="298731748"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga004.fm.intel.com with ESMTP; 15 Jun 2020 19:24:54 -0700
Received: from fmsmsx162.amr.corp.intel.com (10.18.125.71) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 15 Jun 2020 19:24:54 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx162.amr.corp.intel.com (10.18.125.71) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 15 Jun 2020 19:24:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 15 Jun 2020 19:24:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZuuqxGG4lcWrtl5zkdp/voUvvxTOPfZPX+gMvZUcEbH0GX8AJ27rtisRGuXY2JbrgFguGXyOa7QmOmsSR9bhIUPzrOUf5fA2uyHkvXc+9hbmSezvCiTIypKr3sl7QntPFQciSpEP61cmYmE4aP1Lpjdt1jskwn4ox1gKVrtF1QSAu6CJbgOvxt4nhgE+lGpL5keY2JiZY/yuKYLa/EwRGPYDCZh3vxZp4MLO7WnS4m6QwVPXIOO8OwnKMrS++FwXHBsEcHDVBdfGJodE9kijAlaOcDbllu5Y0SERyqecyg1Ura2mly/Ap3omVefKwEeKxKDistnfriwYsw0TAPXMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEqp4grqrMMCENyRiWXaRhGVnQkvx7go0XL6cYMMAFI=;
 b=ZySU2ftQgu0nGk2Dy7y1K0CqcmQhdElQe1A2e71izFda761wUQnpdgK1cSncr/5XHVUqI+tHZD8kwyKmWmdqF/YtSlm8ppIFQi7FroLiSVHC8MEPiUEhLMPhW8x3YyLQNrtPDcmtnHsbSGcDRiVfsolj20a6zSWKmg1LeJ8Xpqd5i+F9RxfYHP0n/oVHtO/NoKt1+SGikUdBk0Yv6o9f67FHEnBZkcTy54j6iV+MKLqQV3FgbtnQoQoZ9E8HMnD1+HUaGWuHUylKR/LczfNNlHBbu1euWOcy79esckfNzaeHs26IHxdI64OPgwryvtrz7i+7lnThL+xGNQKDUgnIuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEqp4grqrMMCENyRiWXaRhGVnQkvx7go0XL6cYMMAFI=;
 b=A+6MtaU5tAzs4+DCXbRA6srX7TiMJ4POqzrOx//+EzUj78mbGb5z44nbkAEqAc43/Pq/qe1ztFCVBsTQ4grGGgyJTORNz1LzXCp4pMLriF7rWz8BswKKM1ruKlESalXAP+Of9eIve34TWz0i1wvgAO3fhYPrEv6O82WCPnkQ5yo=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB4596.namprd11.prod.outlook.com (2603:10b6:5:2a6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3088.20; Tue, 16 Jun 2020 02:24:51 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::2c3d:98d9:4e81:c86c]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::2c3d:98d9:4e81:c86c%6]) with mapi id 15.20.3088.029; Tue, 16 Jun 2020
 02:24:51 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
Thread-Index: AQHWP+lAvgybSaO2NECN4P16s7e2zKjTzaSAgADgFXCABDlcgIAARuNggAFU34CAAAJCQA==
Date:   Tue, 16 Jun 2020 02:24:51 +0000
Message-ID: <DM5PR11MB1435C08C428B34EA4546BB49C39D0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
        <1591877734-66527-3-git-send-email-yi.l.liu@intel.com>
 <20200611133015.1418097f@x1.home>
 <DM5PR11MB143571773B05359FA2F46FB6C3810@DM5PR11MB1435.namprd11.prod.outlook.com>
 <MWHPR11MB1645A7EBC706AC8A075EA83D8C9C0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <DM5PR11MB1435EB4D10A6EF16BF95C811C39C0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <MWHPR11MB16456A9F54BA70D5381F2D758C9D0@MWHPR11MB1645.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR11MB16456A9F54BA70D5381F2D758C9D0@MWHPR11MB1645.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85283556-209d-4f83-4db7-08d8119c7331
x-ms-traffictypediagnostic: DM6PR11MB4596:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB459634EBD0F82363E4196451C39D0@DM6PR11MB4596.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 04362AC73B
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TnueoURQC8qLtdk58AElIzYsfvvtXdGfBHxG3H9vY1LnOJLIBnn6QoE+1jX3m6X3HLZQL2aeHwF/oppuTwD+pIaiWXWA9kXiQ/R24NzTmcowf4wxi2d3itxIneDjCbtG8fTovmtomhgAYfSHte5IFyLL1FOxYY/bl/0swb8KjhfVI4NNNKr/DaXdaORCR3Fqq41oB+buzGRJ4sVrnS7QndPrr+QA+qs8jU1CdHwgeC9NbAX/iOKYp+bEqf9+7fGt116wRhbLeSTuez8O6JQ4TSsAH+StjEdTeQKGgoOjjXHExM9kSWZSmPP0L4ooLZaZzMHFVw/NYXJ30ainGYYLL8IoKXAgRjK4GZSr2K3iIRYCpHL626X8mbQvYG3VlNchlwNxnPPU6mqcU9wfuL4jQA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(136003)(39860400002)(396003)(346002)(5660300002)(52536014)(71200400001)(7696005)(26005)(186003)(33656002)(54906003)(110136005)(6506007)(316002)(7416002)(966005)(86362001)(478600001)(76116006)(66446008)(64756008)(66556008)(66476007)(66946007)(2906002)(8936002)(8676002)(9686003)(83380400001)(55016002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: tDK8C56ehLyTow8rPGJgemAkPlh+hyoLyAQJerVojva2TA1VCMBfmv02QQGNzEVmYt+vyNBGaay2QNNl942QbRLtMEQzjujSIro/isNyiUa/NeNvOlmD8HPAYSP9xkE2JTc9EAHmWvqhxoGXbJxWzdcCjMiD5Q6DwFW2qgypfgrP6kQVmClGr9+wlPdrGhpqq64JOEBNx6C2NR8iLYsR1qhDkKj0dVk/KZVL7rpIKtJt3IUp2tc6CUMK6LJWCOB5OZ1NYb69noOOHkJhVO0bDicdorlk6UvDRi8fB775vTPHpB1MdbxNK2gX+mbQykH4B+1NcOcWSG6jpVjTssTl+oUSgXUWMEru/aCUfTQr0VE/ip+gpwH7uSKZq5aCKg72wxo4/C1mzXxWu2dSFfyrQ23yJJt7SpIrtIHE+DuLneEu0KXpNsnVGZ5Kg/vEFhbiGhKZS+kMkqpo7YzBonC2fiHicGM/7U8kWi//HbBPD6zC1Ihw3/iSKk/FthGjt2I5
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 85283556-209d-4f83-4db7-08d8119c7331
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2020 02:24:51.6957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uOyxfJbBitYz9unSAfv8NoyvXsa6aH0D98Ks+3xypStmBdDX57+Fs34B6tO4+Ix6tdR8uURiiHb1CDVSI2CRSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4596
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Tuesday, June 16, 2020 9:56 AM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Monday, June 15, 2020 2:05 PM
> >
> > Hi Kevin,
> >
> > > From: Tian, Kevin <kevin.tian@intel.com>
> > > Sent: Monday, June 15, 2020 9:23 AM
> > >
> > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > Sent: Friday, June 12, 2020 5:05 PM
> > > >
> > > > Hi Alex,
> > > >
> > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > Sent: Friday, June 12, 2020 3:30 AM
> > > > >
> > > > > On Thu, 11 Jun 2020 05:15:21 -0700
> > > > > Liu Yi L <yi.l.liu@intel.com> wrote:
> > > > >
> > > > > > IOMMUs that support nesting translation needs report the
> > > > > > capability info to userspace, e.g. the format of first level/st=
age paging
> > > structures.
> > > > > >
> > > > > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > > > > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > > > > Cc: Alex Williamson <alex.williamson@redhat.com>
> > > > > > Cc: Eric Auger <eric.auger@redhat.com>
> > > > > > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > > > > > Cc: Joerg Roedel <joro@8bytes.org>
> > > > > > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > > > > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > > > > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > > > > ---
> > > > > > @Jean, Eric: as nesting was introduced for ARM, but looks like =
no
> > > > > > actual user of it. right? So I'm wondering if we can reuse
> > > > > > DOMAIN_ATTR_NESTING to retrieve nesting info? how about your
> > > > opinions?
> > > > > >
> > > > > >  include/linux/iommu.h      |  1 +
> > > > > >  include/uapi/linux/iommu.h | 34
> > > > ++++++++++++++++++++++++++++++++++
> > > > > >  2 files changed, 35 insertions(+)
> > > > > >
> > > > > > diff --git a/include/linux/iommu.h b/include/linux/iommu.h inde=
x
> > > > > > 78a26ae..f6e4b49 100644
> > > > > > --- a/include/linux/iommu.h
> > > > > > +++ b/include/linux/iommu.h
> > > > > > @@ -126,6 +126,7 @@ enum iommu_attr {
> > > > > >  	DOMAIN_ATTR_FSL_PAMUV1,
> > > > > >  	DOMAIN_ATTR_NESTING,	/* two stages of translation */
> > > > > >  	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
> > > > > > +	DOMAIN_ATTR_NESTING_INFO,
> > > > > >  	DOMAIN_ATTR_MAX,
> > > > > >  };
> > > > > >
> > > > > > diff --git a/include/uapi/linux/iommu.h
> > > > > > b/include/uapi/linux/iommu.h index 303f148..02eac73 100644
> > > > > > --- a/include/uapi/linux/iommu.h
> > > > > > +++ b/include/uapi/linux/iommu.h
> > > > > > @@ -332,4 +332,38 @@ struct iommu_gpasid_bind_data {
> > > > > >  	};
> > > > > >  };
> > > > > >
> > > > > > +struct iommu_nesting_info {
> > > > > > +	__u32	size;
> > > > > > +	__u32	format;
> > > > > > +	__u32	features;
> > > > > > +#define IOMMU_NESTING_FEAT_SYSWIDE_PASID	(1 << 0)
> > > > > > +#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 1)
> > > > > > +#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 <<
> > 2)
> > > > > > +	__u32	flags;
> > > > > > +	__u8	data[];
> > > > > > +};
> > > > > > +
> > > > > > +/*
> > > > > > + * @flags:	VT-d specific flags. Currently reserved for future
> > > > > > + *		extension.
> > > > > > + * @addr_width:	The output addr width of first level/stage
> > > translation
> > > > > > + * @pasid_bits:	Maximum supported PASID bits, 0 represents
> > no
> > > > PASID
> > > > > > + *		support.
> > > > > > + * @cap_reg:	Describe basic capabilities as defined in VT-d
> > > > capability
> > > > > > + *		register.
> > > > > > + * @cap_mask:	Mark valid capability bits in @cap_reg.
> > > > > > + * @ecap_reg:	Describe the extended capabilities as defined in
> VT-d
> > > > > > + *		extended capability register.
> > > > > > + * @ecap_mask:	Mark the valid capability bits in @ecap_reg.
> > > > >
> > > > > Please explain this a little further, why do we need to tell
> > > > > userspace about cap/ecap register bits that aren't valid through =
this
> > interface?
> > > > > Thanks,
> > > >
> > > > we only want to tell userspace about the bits marked in the
> > cap/ecap_mask.
> > > > cap/ecap_mask is kind of white-list of the cap/ecap register.
> > > > userspace should only care about the bits in the white-list, for ot=
her
> > > > bits, it should ignore.
> > > >
> > > > Regards,
> > > > Yi Liu
> > >
> > > For invalid bits if kernel just clears them then do we still need add=
itional
> > mask bits
> > > to explicitly mark them out? I guess this might be the point that Ale=
x asked...
> >
> > For invalid bits, kernel will clear them. But I think the mask bits is
> > still necessary. The mask bits tells user space the bits related to
> > nesting. Without it, user space may have no idea about it.
>=20
> userspace should know which bit is related to nesting and then should
> check that bit explicitly...

ok, so userspace could get such info by the understanding of spec, right?
if user space could get it, then I think it's uncessary to have cap/ecap ma=
sk
bits.

> >
> > Maybe talk about QEMU usage of the cap/ecap bits would help. QEMU
> > vIOMMU
> > decides cap/ecap bits according to QEMU cmdline. But not all of them ar=
e
> > compatible with hardware support. Especially, vIOMMU built on nesting.
> > So needs to sync the cap/ecap bits with host side. Based on the mask
> > bits, QEMU can compare the cap/ecap bits configured by QEMU cmdline wit=
h
> > the cap/ecap bits reported by this interface. This comparation is limit=
ed
> > to the nesting related bits in cap/ecap, the other bits are not include=
d
> > and can use the configuration by QEMU cmdline.
>=20
> I didn't get this explanation. Based on patch [15/15], nesting capabiliti=
es
> are defined as:
> +/* Nesting Support Capability Alignment */
> +#define VTD_CAP_FL1GP		(1ULL << 56)
> +#define VTD_CAP_FL5LP		(1ULL << 60)
> +#define VTD_ECAP_PRS		(1ULL << 29)
> +#define VTD_ECAP_ERS		(1ULL << 30)
> +#define VTD_ECAP_SRS		(1ULL << 31)
> +#define VTD_ECAP_EAFS		(1ULL << 34)
> +#define VTD_ECAP_PASID		(1ULL << 40)
>=20
> When Qemu gets an cmdline option it knows which bit out of above
> list should be checked against hardware capability. Then just do the
> check bit-by-bit. Why do we need mask bit in uapi to tell which bits
> are valid?

as above reply, if userspace has the check list for the cap/ecap bits,
then it's not necessary to use mask bit.

> Unless 0/1 doesn't represent validity of some bit. Do we
> have such example?

yes, like the pasid bits. it's 20 bits. but we already got pasid_bits
in the iommu_nesting_info_vtd structure. so it's not covered in the
ecap_bits.

Regards,
Yi Liu

> >
> > The link below show the current Intel vIOMMU usage on the cap/ecap bits=
.
> > For each assigned device, vIOMMU will compare the nesting related bits =
in
> > cap/ecap and mask out the bits which hardware doesn't support. After th=
e
> > machine is intilized, the vIOMMU cap/ecap bits are determined. If user
> > hot-plug devices to VM, vIOMMU will fail it if the hardware cap/ecap bi=
ts
> > behind hot-plug device are not compatible with determined vIOMMU
> > cap/ecap
> > bits.
> >
> > https://www.spinics.net/lists/kvm/msg218294.html
> >
> > Regards,
> > Yi Liu
> >
> > > >
> > > > > Alex
> > > > >
> > > > >
> > > > > > + */
> > > > > > +struct iommu_nesting_info_vtd {
> > > > > > +	__u32	flags;
> > > > > > +	__u16	addr_width;
> > > > > > +	__u16	pasid_bits;
> > > > > > +	__u64	cap_reg;
> > > > > > +	__u64	cap_mask;
> > > > > > +	__u64	ecap_reg;
> > > > > > +	__u64	ecap_mask;
> > > > > > +};
> > > > > > +
> > > > > >  #endif /* _UAPI_IOMMU_H */

