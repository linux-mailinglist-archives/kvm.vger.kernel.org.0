Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7D120BEF4
	for <lists+kvm@lfdr.de>; Sat, 27 Jun 2020 08:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgF0GPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jun 2020 02:15:01 -0400
Received: from mga06.intel.com ([134.134.136.31]:55302 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbgF0GPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jun 2020 02:15:00 -0400
IronPort-SDR: kW6PTwqyj3UKatD6EbkWt9fRanhlXv66tRrzuwq5Q53lm6DR1ZFu2mRs9uKdB3OQJ2tyfZ4OGp
 YdFRpcgTMR2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="207121411"
X-IronPort-AV: E=Sophos;i="5.75,286,1589266800"; 
   d="scan'208";a="207121411"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 23:14:58 -0700
IronPort-SDR: nziV5KgVlps8oS4XZ5Uc2B0gdnFKKzK+DNm1X2BliGqouK1XuiCtGeVkfO58FNoMqCJkj83HIG
 gciFJ2n2+sYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,286,1589266800"; 
   d="scan'208";a="276571553"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga003.jf.intel.com with ESMTP; 26 Jun 2020 23:14:56 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 26 Jun 2020 23:14:55 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 26 Jun 2020 23:14:55 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 26 Jun 2020 23:14:55 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 26 Jun 2020 23:14:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ix+vGXZ362HsncnPEFZXGuDuRzZNOL4BmZ9DCMJRDai2IYtEPiPlztY11kiVCypsoQcZMkR25ulOgcLKt+kycBGvKjAWUDtrUJL2oc4E/tFsOsoDbJVyRmJJavitxOxvVFXUfbf2yvCAqWKRaj/L3y68/1XWnX3Io1WmR9mTVcpbb/wpLPr3pbuvhlh5HoBsM364N2KA71ZD6/8zG9oAdg0jOBQxUMZ2tM7fqeyXa24OrKb5ze2bmlDDjWSrQA9fF2J+h6+fNGiWgPfztQImni1Tot4cb4gjWp2ebN4h8B5ovyMkT1Ao1YBECYF8dvnyLZ2+8wVhzYQNx05Ju8460w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1TScMjCm7htZTBLSFsxW+bfzPVFr4rFxs5gXSiFe47k=;
 b=FKqfM5Ggxk9yXjQ8p4PddlsXbT5MZ9VfsSL6G3APSEG4nbi4nTy1kCcQrxqYznGWvjCeBSKe5bRsMa0cxunBdZETM6GSeC3iR9HyXoOdFgZ10tTcyoDg57ZQmQnYjFCVwpKIpjvvXoRrZZJ3kbcV21xKdUVYdSbUFzvtCFo3KGWq3MJF3SeqI6x8e2mCp1OfCRl/E4CY9t+0WTthmpRi1ZKhtQm7sTg41q5wMOBcOL/xKWUPISrt958O6bwztESIwAtXsVeJri4eH/KDmqRuwgirWBKWOJvSrfGdaDzLJPwQLSaLxIrZLsBCarGulC5tpIkrG8sCp8v8aG8khpUuFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1TScMjCm7htZTBLSFsxW+bfzPVFr4rFxs5gXSiFe47k=;
 b=QeP6dF6E7Z9eIlLsrpv0E1DBkroDk+DLNuQrHjXM0k5Sf3GpKV8ME3X1MokIF1YR7pH1swFVVYyzuc5x6OaG6xqMtKy7JLU7rIcXhQrgAUo21p48Ra+USPkMDNidMlGHS+2jmlE01bTvG+q5fbOG0n1BaoCEUP9kdoHavZv3ta8=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB2009.namprd11.prod.outlook.com (2603:10b6:3:15::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.25; Sat, 27 Jun 2020 06:14:53 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::2c3d:98d9:4e81:c86c]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::2c3d:98d9:4e81:c86c%6]) with mapi id 15.20.3131.025; Sat, 27 Jun 2020
 06:14:53 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [PATCH v3 02/14] iommu: Report domain nesting info
Thread-Topic: [PATCH v3 02/14] iommu: Report domain nesting info
Thread-Index: AQHWSgRQVmc9Qp+Xi0mQEumzIJrE0qjqiBcAgAF4MYA=
Date:   Sat, 27 Jun 2020 06:14:52 +0000
Message-ID: <DM5PR11MB14355918CBF5DDDA1C1352C8C3900@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
 <1592988927-48009-3-git-send-email-yi.l.liu@intel.com>
 <20200626074738.GA2107508@myrica>
In-Reply-To: <20200626074738.GA2107508@myrica>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.221]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5b00e14-6f4c-44eb-7d41-08d81a6167f4
x-ms-traffictypediagnostic: DM5PR11MB2009:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB20094A98D4E7EAC9E8CC33B0C3900@DM5PR11MB2009.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0447DB1C71
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U6z+CSSDszwJevYlYrr0cZ3db7Tp39XZegYTY9dEjEpkq/pF4vtPq3f/7puAgtmTLllij1kTYDxUfNCtjOWG4IKicEZn5Fj3tITH7dLzpVV5TFvVaZkuy1HpHI3DYArqn4pW6f+fn7IHI8G5Sd3dbxL1+ZafnGBAyKlkAu2m4Ed4ee73pHx5pgXfvB//kxKr2SNMlU3yVksM24wl96MqZj9s3sbL1FeeKzQ5orOnvaGnTnXcppV5B1gjRZhw74Y8KcyatPg3ZpdVDyRyP4RiG9LDwnSBidlkQ4FrZcKKN3XsSyIJGUqu6OmrLUQNgZQybOjDNgBI7Soq0gAJPDNayg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(7696005)(52536014)(478600001)(186003)(2906002)(26005)(6506007)(66446008)(6916009)(66476007)(64756008)(8676002)(66556008)(66946007)(71200400001)(8936002)(4326008)(316002)(54906003)(86362001)(5660300002)(9686003)(83380400001)(33656002)(55016002)(7416002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 11u8uGvGmKoVQ93E7nUGbIWFG96m2kdu0xVwakFHiMBkwgvjBwoTtJ4V7otUKCki+eZIreYQziRbaBx3YE7jSzAoEl6iQf6fnkgx6TwNJDrHFkpPhvsutajvHNzfQp2VDtyj5uvf9G0rSW+X9EtFgVoPUdH6CgCsgnT4vNlZ8yW1FgfBixvk97vgf+NZpS0fLlKZ7rWjRIyGOTNlej56rKkQLlGeHUnTK0StnD3bWOSoOfMQWOM/0K978Plnt+/Xrhi2ErJ4nN1TAjYLiJa/Cy7fkv4Id4d/IDrEOsv4V2Yug7Mr+4fQIk8laPblZoosbj/CcbWLKPDfDbjyuOydQv9U+dpF9EDMpKcAXER/1H0CtiDFSpYVyNOcHJBhpqTTH4TZQH/965Erq4zLaZsmd/o9DpOYq3EiSJ28Vs2SD3U28Tor3JCSVN0dHHPYcagA/eHypMIMKtX1rdClCOmqCI2ziJ55GtSuObmeTF9JEti2+V3WnBlJdU7xOBL25Sku
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b00e14-6f4c-44eb-7d41-08d81a6167f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2020 06:14:52.8992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OXVrgK5dU0kPLK4EJkVtqJ8ySIgiyHSt1yuwbpme7MA3wO98FI84Z1C0JSsV+b9a3VDeAOqJO/p4YSPjV9VtxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB2009
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Sent: Friday, June 26, 2020 3:48 PM
>=20
> On Wed, Jun 24, 2020 at 01:55:15AM -0700, Liu Yi L wrote:
> > IOMMUs that support nesting translation needs report the capability
> > info to userspace, e.g. the format of first level/stage paging structur=
es.
> >
> > This patch reports nesting info by DOMAIN_ATTR_NESTING. Caller can get
> > nesting info after setting DOMAIN_ATTR_NESTING.
> >
> > v2 -> v3:
> > *) remvoe cap/ecap_mask in iommu_nesting_info.
> > *) reuse DOMAIN_ATTR_NESTING to get nesting info.
> > *) return an empty iommu_nesting_info for SMMU drivers per Jean'
> >    suggestion.
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
> >  drivers/iommu/arm-smmu-v3.c | 29 ++++++++++++++++++++--
> >  drivers/iommu/arm-smmu.c    | 29 ++++++++++++++++++++--
>=20
> Looks reasonable to me. Please move the SMMU changes to a separate patch
> and Cc the SMMU maintainers:
>=20
> Cc: Will Deacon <will@kernel.org>
> Cc: Robin Murphy <robin.murphy@arm.com>

got you. will do it.

Regards,
Yi Liu

> Thanks,
> Jean
>=20
> >  include/uapi/linux/iommu.h  | 59
> > +++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 113 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
> > index f578677..0c45d4d 100644
> > --- a/drivers/iommu/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm-smmu-v3.c
> > @@ -3019,6 +3019,32 @@ static struct iommu_group
> *arm_smmu_device_group(struct device *dev)
> >  	return group;
> >  }
> >
> > +static int arm_smmu_domain_nesting_info(struct arm_smmu_domain
> *smmu_domain,
> > +					void *data)
> > +{
> > +	struct iommu_nesting_info *info =3D (struct iommu_nesting_info *) dat=
a;
> > +	u32 size;
> > +
> > +	if (!info || smmu_domain->stage !=3D ARM_SMMU_DOMAIN_NESTED)
> > +		return -ENODEV;
> > +
> > +	size =3D sizeof(struct iommu_nesting_info);
> > +
> > +	/*
> > +	 * if provided buffer size is not equal to the size, should
> > +	 * return 0 and also the expected buffer size to caller.
> > +	 */
> > +	if (info->size !=3D size) {
> > +		info->size =3D size;
> > +		return 0;
> > +	}
> > +
> > +	/* report an empty iommu_nesting_info for now */
> > +	memset(info, 0x0, size);
> > +	info->size =3D size;
> > +	return 0;
> > +}
> > +
> >  static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
> >  				    enum iommu_attr attr, void *data)  { @@ -
> 3028,8 +3054,7 @@
> > static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
> >  	case IOMMU_DOMAIN_UNMANAGED:
> >  		switch (attr) {
> >  		case DOMAIN_ATTR_NESTING:
> > -			*(int *)data =3D (smmu_domain->stage =3D=3D
> ARM_SMMU_DOMAIN_NESTED);
> > -			return 0;
> > +			return arm_smmu_domain_nesting_info(smmu_domain,
> data);
> >  		default:
> >  			return -ENODEV;
> >  		}
> > diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c index
> > 243bc4c..908607d 100644
> > --- a/drivers/iommu/arm-smmu.c
> > +++ b/drivers/iommu/arm-smmu.c
> > @@ -1506,6 +1506,32 @@ static struct iommu_group
> *arm_smmu_device_group(struct device *dev)
> >  	return group;
> >  }
> >
> > +static int arm_smmu_domain_nesting_info(struct arm_smmu_domain
> *smmu_domain,
> > +					void *data)
> > +{
> > +	struct iommu_nesting_info *info =3D (struct iommu_nesting_info *) dat=
a;
> > +	u32 size;
> > +
> > +	if (!info || smmu_domain->stage !=3D ARM_SMMU_DOMAIN_NESTED)
> > +		return -ENODEV;
> > +
> > +	size =3D sizeof(struct iommu_nesting_info);
> > +
> > +	/*
> > +	 * if provided buffer size is not equal to the size, should
> > +	 * return 0 and also the expected buffer size to caller.
> > +	 */
> > +	if (info->size !=3D size) {
> > +		info->size =3D size;
> > +		return 0;
> > +	}
> > +
> > +	/* report an empty iommu_nesting_info for now */
> > +	memset(info, 0x0, size);
> > +	info->size =3D size;
> > +	return 0;
> > +}
> > +
> >  static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
> >  				    enum iommu_attr attr, void *data)  { @@ -
> 1515,8 +1541,7 @@
> > static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
> >  	case IOMMU_DOMAIN_UNMANAGED:
> >  		switch (attr) {
> >  		case DOMAIN_ATTR_NESTING:
> > -			*(int *)data =3D (smmu_domain->stage =3D=3D
> ARM_SMMU_DOMAIN_NESTED);
> > -			return 0;
> > +			return arm_smmu_domain_nesting_info(smmu_domain,
> data);
> >  		default:
> >  			return -ENODEV;
> >  		}
> > diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
> > index 1afc661..898c99a 100644
> > --- a/include/uapi/linux/iommu.h
> > +++ b/include/uapi/linux/iommu.h
> > @@ -332,4 +332,63 @@ struct iommu_gpasid_bind_data {
> >  	} vendor;
> >  };
> >
> > +/*
> > + * struct iommu_nesting_info - Information for nesting-capable IOMMU.
> > + *				user space should check it before using
> > + *				nesting capability.
> > + *
> > + * @size:	size of the whole structure
> > + * @format:	PASID table entry format, the same definition with
> > + *		@format of struct iommu_gpasid_bind_data.
> > + * @features:	supported nesting features.
> > + * @flags:	currently reserved for future extension.
> > + * @data:	vendor specific cap info.
> > + *
> > + * +---------------+--------------------------------------------------=
--+
> > + * | feature       |  Notes                                           =
  |
> > + *
> >
> ++=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D
> > ++
> > + * | SYSWIDE_PASID |  Kernel manages PASID in system wide, PASIDs used=
  |
> > + * |               |  in the system should be allocated by host kernel=
  |
> > + * +---------------+--------------------------------------------------=
--+
> > + * | BIND_PGTBL    |  bind page tables to host PASID, the PASID could =
  |
> > + * |               |  either be a host PASID passed in bind request or=
  |
> > + * |               |  default PASIDs (e.g. default PASID of aux-domain=
) |
> > + * +---------------+--------------------------------------------------=
--+
> > + * | CACHE_INVLD   |  mandatory feature for nesting capable IOMMU     =
  |
> > + *
> > ++---------------+----------------------------------------------------
> > ++
> > + *
> > + */
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
> > + * struct iommu_nesting_info_vtd - Intel VT-d specific nesting info
> > + *
> > + *
> > + * @flags:	VT-d specific flags. Currently reserved for future
> > + *		extension.
> > + * @addr_width:	The output addr width of first level/stage translation
> > + * @pasid_bits:	Maximum supported PASID bits, 0 represents no PASID
> > + *		support.
> > + * @cap_reg:	Describe basic capabilities as defined in VT-d capability
> > + *		register.
> > + * @ecap_reg:	Describe the extended capabilities as defined in VT-d
> > + *		extended capability register.
> > + */
> > +struct iommu_nesting_info_vtd {
> > +	__u32	flags;
> > +	__u16	addr_width;
> > +	__u16	pasid_bits;
> > +	__u64	cap_reg;
> > +	__u64	ecap_reg;
> > +};
> > +
> >  #endif /* _UAPI_IOMMU_H */
> > --
> > 2.7.4
> >
