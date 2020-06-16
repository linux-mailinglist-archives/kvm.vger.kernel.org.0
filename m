Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F79A1FA5CB
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 03:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgFPB40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 21:56:26 -0400
Received: from mga12.intel.com ([192.55.52.136]:17168 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726392AbgFPB4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 21:56:25 -0400
IronPort-SDR: 33Sygi/3xgxIyNajL/EEA6k/+jvhzqZ3cWAry6cuojxVxOQIQZk1nIvb36+vaWu3LqDFU3oJCe
 CIHUjGxZLkbQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2020 18:56:24 -0700
IronPort-SDR: VtVJ8Dtp6VwKiWrnGv3/Jz33wD6AikeU4OYcu+CdkWiJEV+HnsXNnhMNDvx6j/Itz/UJSbdMEh
 dnjPmJQlru4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,517,1583222400"; 
   d="scan'208";a="261272132"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga007.fm.intel.com with ESMTP; 15 Jun 2020 18:56:24 -0700
Received: from fmsmsx153.amr.corp.intel.com (10.18.125.6) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 15 Jun 2020 18:56:23 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 FMSMSX153.amr.corp.intel.com (10.18.125.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 15 Jun 2020 18:56:23 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.54) by
 edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 15 Jun 2020 18:56:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCtZyteBQ997RfiHAxAZ3MuCSOKdF+rqJ9Fflxf4jJEoG/lRR8IR6AeWcWthCP7yBylwlX3EbaXYvvNfHWiRLBn+w1WJeEr6Ne19gNsldmRGTig4P40fWZ0msPAbaPcKux3ua7riICRRPgv2ip3Ig46Qnmt7vNYmHfIWEQMSTmeCejihhG6bT6Dh7w+FSoqOrVmeqisjVV7vWh0WjAg8C5BOUNorS6szJ0k59taUpTBgEygUEBvewNoTK3o8Vlm+UFvuD2VVukLgrTntTT6CU4q3jTQB7G8x9JI3+3HpaAC1Nci1/I0DbVNlqek1xIszYaelCZmI10pL+vtD97Ud9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiiidVsKIp15744MlA/MTaUwlwnheHUjTFY5Tih6qMs=;
 b=e8F8HKT/Hx+QACkFI2q3yqCNIcfVqtAJE0hvu9B3Ru5A+IwkemqfpvZk1WIeZpdr5QTRi9SpafNguojp9leqbG86jyGjkHEpECQWTORLSUnhDR3gq3B8N+yBOQopHJj41eEAhItTrPF8PBGaOtrg96DcewhiXyM2XS/hhZfKNnpMnr6cnI+A4lnaBrDQAXMGtAlFRyZYPWIwDQOtxVC80Pnx4nkLSTZe2j6mmFSNv3MHfQWRiZqjZt+A64MBAPJBUIdeFNI7GU3HUnQfwQjNR3QTF+xph87iyLgr/LjozOkiWu7wd6ZSrM3VIsHa4UD3GJh34GFXuWcakXNyp2UFwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiiidVsKIp15744MlA/MTaUwlwnheHUjTFY5Tih6qMs=;
 b=Tc05JbGlfvDh2XuKa2FHa5VTBXBozPDsZb8c2f1F5d3EfPsAdjmrkwwodrz4YHeDcgrZJF16fBXMuWNLmuGJ0Dx1pyY0DDQTrCxhhTbxLpK/B6b53qoV0Pc3CTT9Dv9ZgHvhzPSSq4lVUsmdPe9UN5G+wq2FlT4j7F0KBtDz694=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1341.namprd11.prod.outlook.com (2603:10b6:300:2b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.26; Tue, 16 Jun
 2020 01:56:21 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb%5]) with mapi id 15.20.3088.029; Tue, 16 Jun 2020
 01:56:21 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
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
Thread-Index: AQHWP+lAh6LCFwZsRk6rW47Mu2S6h6jTzaSAgADjv4CABDOwQIAAUMcAgAFJ28A=
Date:   Tue, 16 Jun 2020 01:56:21 +0000
Message-ID: <MWHPR11MB16456A9F54BA70D5381F2D758C9D0@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <1591877734-66527-1-git-send-email-yi.l.liu@intel.com>
        <1591877734-66527-3-git-send-email-yi.l.liu@intel.com>
 <20200611133015.1418097f@x1.home>
 <DM5PR11MB143571773B05359FA2F46FB6C3810@DM5PR11MB1435.namprd11.prod.outlook.com>
 <MWHPR11MB1645A7EBC706AC8A075EA83D8C9C0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <DM5PR11MB1435EB4D10A6EF16BF95C811C39C0@DM5PR11MB1435.namprd11.prod.outlook.com>
In-Reply-To: <DM5PR11MB1435EB4D10A6EF16BF95C811C39C0@DM5PR11MB1435.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.207]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27e6a7cf-e075-4c75-abd4-08d8119877e2
x-ms-traffictypediagnostic: MWHPR11MB1341:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1341760E14E85CA47A5EA9D38C9D0@MWHPR11MB1341.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 04362AC73B
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OTjHuGag7Sk6zd/5mB9+i2ftuqwFgjFSEtveIRRz63jJe5fC4jRG5AMCZQUJMWxi9ste5myxlFFibYPGZTRO63K2Vxt0MRe+jHUCAEP2NubrQ8cOPYmmt5EFKalnuMzjKzmLGR5G6jkjVvB/kexN6uW5go0/9O82B9o5i2TRVsIS5TzmbocKS3Ve2z8xo23psSUzVKdeM1ju5PVYMehSUUDqPoawF1tBwhp5rux7P+d6ioNM8hsViFj9DT6ynMIvBm/XsVEkysHk/JLEcfkzUT9BGA9BJG+WLSYoXe3tQz9mhaIwQw0Z/3x8pF7CUOJfrwSfGMH0Ba8i2PudXv7xMssmEJVjJbzyT+iwubCFUYlXHNv7WdWCiO5fjg1IK6F6RE/6NCCIxnFtZLRsKe9UMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(396003)(376002)(39860400002)(136003)(2906002)(6506007)(966005)(71200400001)(316002)(54906003)(8936002)(110136005)(478600001)(86362001)(55016002)(33656002)(76116006)(83380400001)(64756008)(66446008)(186003)(66946007)(66476007)(9686003)(5660300002)(52536014)(8676002)(4326008)(7696005)(66556008)(26005)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 5kH19gkhVkeD3JMhcfCUQ0SF9kewV3oSl+V9K3KFlsEqih6twijCxBmLrtpAwZ9HpauiDAg2lDYnM5jUtcqi/reAVN8afJdpiTqjrlvL4zdAj+YlEuUDQX471I41Ol88+FJe0AAf6t4kMv/fZKlVieLwCYuZLp7Iu/VtV+dPGYZYwKl512TT1zYVpy9dOy5Lox91mcqJxXCCKLhFjMyHx9D0f3vYSRMDEilSygFSYbzu5LpkI1K6rfsC+68ywgBH2rx1/64786F1B5nOsdEfKecPoU3kjzxfAyFtF1Sfc7JD9eYb2KxLeval0wDZXVNhpVgqBgfqIzNvaO5sj3nsKdmhK6cDZEJ5xpFtbRqW4aqoDm4ytMNQH/nX3xtprdXsp9oGuHW2fAszYZsGeRP15Zcnv24a7+aqwX/5Dhw3cLugXrVnbwOOImkQoaJxk9AftQqDCdsOifH9UoFHTtG4YeTCAwQ2IyxW4EL7iGr1dLI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e6a7cf-e075-4c75-abd4-08d8119877e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2020 01:56:21.5570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pDDLYf2JqnblHbEm74yQujKI1Ymijdr45+zMGoYP8ao+B3BSKqQ9gH52Xuq673Cx/c7n4LfKus5iPew4S4NUzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1341
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, June 15, 2020 2:05 PM
>=20
> Hi Kevin,
>=20
> > From: Tian, Kevin <kevin.tian@intel.com>
> > Sent: Monday, June 15, 2020 9:23 AM
> >
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Friday, June 12, 2020 5:05 PM
> > >
> > > Hi Alex,
> > >
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Friday, June 12, 2020 3:30 AM
> > > >
> > > > On Thu, 11 Jun 2020 05:15:21 -0700
> > > > Liu Yi L <yi.l.liu@intel.com> wrote:
> > > >
> > > > > IOMMUs that support nesting translation needs report the
> > > > > capability info to userspace, e.g. the format of first level/stag=
e paging
> > structures.
> > > > >
> > > > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > > > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > > > Cc: Alex Williamson <alex.williamson@redhat.com>
> > > > > Cc: Eric Auger <eric.auger@redhat.com>
> > > > > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > > > > Cc: Joerg Roedel <joro@8bytes.org>
> > > > > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > > > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > > > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > > > ---
> > > > > @Jean, Eric: as nesting was introduced for ARM, but looks like no
> > > > > actual user of it. right? So I'm wondering if we can reuse
> > > > > DOMAIN_ATTR_NESTING to retrieve nesting info? how about your
> > > opinions?
> > > > >
> > > > >  include/linux/iommu.h      |  1 +
> > > > >  include/uapi/linux/iommu.h | 34
> > > ++++++++++++++++++++++++++++++++++
> > > > >  2 files changed, 35 insertions(+)
> > > > >
> > > > > diff --git a/include/linux/iommu.h b/include/linux/iommu.h index
> > > > > 78a26ae..f6e4b49 100644
> > > > > --- a/include/linux/iommu.h
> > > > > +++ b/include/linux/iommu.h
> > > > > @@ -126,6 +126,7 @@ enum iommu_attr {
> > > > >  	DOMAIN_ATTR_FSL_PAMUV1,
> > > > >  	DOMAIN_ATTR_NESTING,	/* two stages of translation */
> > > > >  	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
> > > > > +	DOMAIN_ATTR_NESTING_INFO,
> > > > >  	DOMAIN_ATTR_MAX,
> > > > >  };
> > > > >
> > > > > diff --git a/include/uapi/linux/iommu.h
> > > > > b/include/uapi/linux/iommu.h index 303f148..02eac73 100644
> > > > > --- a/include/uapi/linux/iommu.h
> > > > > +++ b/include/uapi/linux/iommu.h
> > > > > @@ -332,4 +332,38 @@ struct iommu_gpasid_bind_data {
> > > > >  	};
> > > > >  };
> > > > >
> > > > > +struct iommu_nesting_info {
> > > > > +	__u32	size;
> > > > > +	__u32	format;
> > > > > +	__u32	features;
> > > > > +#define IOMMU_NESTING_FEAT_SYSWIDE_PASID	(1 << 0)
> > > > > +#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 1)
> > > > > +#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 <<
> 2)
> > > > > +	__u32	flags;
> > > > > +	__u8	data[];
> > > > > +};
> > > > > +
> > > > > +/*
> > > > > + * @flags:	VT-d specific flags. Currently reserved for future
> > > > > + *		extension.
> > > > > + * @addr_width:	The output addr width of first level/stage
> > translation
> > > > > + * @pasid_bits:	Maximum supported PASID bits, 0 represents
> no
> > > PASID
> > > > > + *		support.
> > > > > + * @cap_reg:	Describe basic capabilities as defined in VT-d
> > > capability
> > > > > + *		register.
> > > > > + * @cap_mask:	Mark valid capability bits in @cap_reg.
> > > > > + * @ecap_reg:	Describe the extended capabilities as defined in V=
T-d
> > > > > + *		extended capability register.
> > > > > + * @ecap_mask:	Mark the valid capability bits in @ecap_reg.
> > > >
> > > > Please explain this a little further, why do we need to tell
> > > > userspace about cap/ecap register bits that aren't valid through th=
is
> interface?
> > > > Thanks,
> > >
> > > we only want to tell userspace about the bits marked in the
> cap/ecap_mask.
> > > cap/ecap_mask is kind of white-list of the cap/ecap register.
> > > userspace should only care about the bits in the white-list, for othe=
r
> > > bits, it should ignore.
> > >
> > > Regards,
> > > Yi Liu
> >
> > For invalid bits if kernel just clears them then do we still need addit=
ional
> mask bits
> > to explicitly mark them out? I guess this might be the point that Alex =
asked...
>=20
> For invalid bits, kernel will clear them. But I think the mask bits is
> still necessary. The mask bits tells user space the bits related to
> nesting. Without it, user space may have no idea about it.

userspace should know which bit is related to nesting and then should
check that bit explicitly...

>=20
> Maybe talk about QEMU usage of the cap/ecap bits would help. QEMU
> vIOMMU
> decides cap/ecap bits according to QEMU cmdline. But not all of them are
> compatible with hardware support. Especially, vIOMMU built on nesting.
> So needs to sync the cap/ecap bits with host side. Based on the mask
> bits, QEMU can compare the cap/ecap bits configured by QEMU cmdline with
> the cap/ecap bits reported by this interface. This comparation is limited
> to the nesting related bits in cap/ecap, the other bits are not included
> and can use the configuration by QEMU cmdline.

I didn't get this explanation. Based on patch [15/15], nesting capabilities
are defined as:
+/* Nesting Support Capability Alignment */
+#define VTD_CAP_FL1GP		(1ULL << 56)
+#define VTD_CAP_FL5LP		(1ULL << 60)
+#define VTD_ECAP_PRS		(1ULL << 29)
+#define VTD_ECAP_ERS		(1ULL << 30)
+#define VTD_ECAP_SRS		(1ULL << 31)
+#define VTD_ECAP_EAFS		(1ULL << 34)
+#define VTD_ECAP_PASID		(1ULL << 40)

When Qemu gets an cmdline option it knows which bit out of above
list should be checked against hardware capability. Then just do the
check bit-by-bit. Why do we need mask bit in uapi to tell which bits
are valid? Unless 0/1 doesn't represent validity of some bit. Do we
have such example?

>=20
> The link below show the current Intel vIOMMU usage on the cap/ecap bits.
> For each assigned device, vIOMMU will compare the nesting related bits in
> cap/ecap and mask out the bits which hardware doesn't support. After the
> machine is intilized, the vIOMMU cap/ecap bits are determined. If user
> hot-plug devices to VM, vIOMMU will fail it if the hardware cap/ecap bits
> behind hot-plug device are not compatible with determined vIOMMU
> cap/ecap
> bits.
>=20
> https://www.spinics.net/lists/kvm/msg218294.html
>=20
> Regards,
> Yi Liu
>=20
> > >
> > > > Alex
> > > >
> > > >
> > > > > + */
> > > > > +struct iommu_nesting_info_vtd {
> > > > > +	__u32	flags;
> > > > > +	__u16	addr_width;
> > > > > +	__u16	pasid_bits;
> > > > > +	__u64	cap_reg;
> > > > > +	__u64	cap_mask;
> > > > > +	__u64	ecap_reg;
> > > > > +	__u64	ecap_mask;
> > > > > +};
> > > > > +
> > > > >  #endif /* _UAPI_IOMMU_H */

