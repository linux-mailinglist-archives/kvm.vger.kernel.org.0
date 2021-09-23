Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A38415834
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 08:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239334AbhIWG2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 02:28:15 -0400
Received: from mga12.intel.com ([192.55.52.136]:29583 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239331AbhIWG2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 02:28:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10115"; a="203272261"
X-IronPort-AV: E=Sophos;i="5.85,316,1624345200"; 
   d="scan'208";a="203272261"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 23:26:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,316,1624345200"; 
   d="scan'208";a="518860062"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga001.jf.intel.com with ESMTP; 22 Sep 2021 23:26:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 23:26:42 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 23:26:41 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 22 Sep 2021 23:26:41 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 22 Sep 2021 23:26:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgzXEONzMD4CeXVoHyr9+gfwsP/TZRmW7eHOV+ztST6JWl/9BiC3mcGgG4KgNHBQk8PGmQkzPtsap9bpqFn1YcVS73BvIHE99hO87xy/d1SMKWWWvJWfePpsn3zwYzgBqjX1YNYNdFi5N0dVMd03BzC7apMZ+u7MVgY8l3wfp7NgAu9/0iQE4QIpfnjf7GA7VgGWXbIJvSDML3LlwGkhhRLV4mqJpOggbNgo9bpBwfdtae9YfdHfHD9DWPtfku8IV2ep+2SE4mVPYvWUKvmWKKGEeQEDoB5J5pyBiGGhyNu7qktPd+xWHMGLooX29aq7HQf/BRuex5rpPomb6qyclw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WR8ecBiavs48SoxlSjpqs+b9ujaTm+yIRwAD9qMvqNI=;
 b=R/OgPTNjbfyrkAddz1WDzX/5HuSJf/7+2pY5Z30pE0P/0KwdCp/dfezN/9Wl1DC5E1ZbhTdRej/qTCdx5wCVsAbdzyvZ4Mxp/eddO+cUjm/R0DDEYvJCW2Ix9h+HYGT3bhvRMCJjDyNd2twR5dzXTmOrQFQ4gYLaKUkio1/vWWV5y1QmpghfXNo0iVMqC+2s6gXJRlL0sEpMisSu6gLHL3/3OW5MwTupEZpyxu4L6IyreVj0Qv/Lm2bFofcwU4WVzoUuj09dLerHTJ0XyV5+D4i3fuyQGdBht33MmYT3mjZnqWWDahLauz6zHE5BTacrVj76pUPGbyqQkr8DxaMDNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WR8ecBiavs48SoxlSjpqs+b9ujaTm+yIRwAD9qMvqNI=;
 b=LYEa3/w2b7EhC2HQy6dK9Bs+OCbJT+JNIt5fh8ox25G4IkoZq6kWcJOBjkraUEt4DcaWk8SeuemeD1lsn75d9RVFTzXBMU+21UcuqjoX/hXXDLVftQmGwnPnQ4zJKbOxT7qR8U0jpKBdSiy0xmtxW5V/LCrfeVJJyIGXdvtwt0o=
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by PH0PR11MB5580.namprd11.prod.outlook.com (2603:10b6:510:e5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Thu, 23 Sep
 2021 06:26:39 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119%6]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 06:26:39 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Thread-Topic: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Thread-Index: AQHXrSGQLQh7Daiwk0GPvXz/w70Xfquuxm8AgAE+jLCAAA1HgIABGJEQ
Date:   Thu, 23 Sep 2021 06:26:39 +0000
Message-ID: <PH0PR11MB565877082436FE98CF4D978DC3A39@PH0PR11MB5658.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <SJ0PR11MB5662A74575125536D9BEF57AC3A29@SJ0PR11MB5662.namprd11.prod.outlook.com>
 <20210922133217.GR327412@nvidia.com>
In-Reply-To: <20210922133217.GR327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e96433a3-b313-4013-05b9-08d97e5b1a22
x-ms-traffictypediagnostic: PH0PR11MB5580:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB558057A04E4C243173E41919C3A39@PH0PR11MB5580.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sTKXwfDtkCd1wyil5IMw2QQKTSXVdv5MC0WqDsTtJ+vlFuhvQxUN1l5FWK0J5crffCcCA7aROE8kD2SW2sF3+dCNpYdrVqXS3oHEpY3u6NQvBHaxm5eNTYuCFZm2mnM+rBSq+AJM9X2jto0LmPJeXIppHpweSt7cBoGukB5qOs7Lz56902R7TaJ4WCGe5YXa4HEe57+ayVPmbteFyS/KkDzXYnZD4dH3predAbx4jYe2JHYT9NA/GQg8Ap6EFQrW7mvcrYRttR7ABGqDn18Wgib6KxHOIRRfcMOLIYoERyD5o4l3qmp0Il7c0qqInY7DA4laiX5nRj/Q79ZAG23AOdK6Uy3/vujugXFrLotao1E4aj43u3HomTH/ifgBg+/AE3XxFsY2OlEgKccWr1RdWoTZkN4lODi0hITtq1FCHv+5VhPMT2znBle4kdYela1HhjWuuFfY8XGdZVc2jUqbJrkhSfv6lt4O/kfI3D4qGzwYdJmHlLjAMKe9Q5hZOk7Zr+MWk3oorEFlZlrE9YJ8Rl2bxsgJ1A/W9Ny+PobSofEoFzJ/TNjtmef/fVZCARpwssVedBNohzIblNCDrpSiNwiBcEZ+ihNOZn+1/084fBGRPxeReFu1H5xR/5KPhO6TfDSJnMRcqB0/Ft6Abp1XICMHoQZlK8DgCEuw7FkirwR/059f7jRpc1RdIC5PJ5zmW2jyoWUKGA3TNb9tmjNMVqR7MQfWWGS0UOSHgSeh5Zo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(71200400001)(7416002)(86362001)(66446008)(83380400001)(186003)(38100700002)(26005)(66946007)(7696005)(508600001)(6506007)(6916009)(66476007)(76116006)(122000001)(2906002)(64756008)(66556008)(38070700005)(8936002)(5660300002)(55016002)(9686003)(33656002)(8676002)(316002)(52536014)(54906003)(84603001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hxNLe6x4f83daDw8O/kSiighfiQvPBRWbVOoUXqY4ktR60Y3BF/m1yMDh2Ef?=
 =?us-ascii?Q?N2uJGJPZkp9/wjV8hX1kfCd0MzTkh5SGUllCfxo5INaIeuW1OkAS4rx8axzt?=
 =?us-ascii?Q?NhjiatUtr3ZUzpY/3/e/CNT39Z+m0RdnsR86QG9QXAfJnUQqHwpRGySc9omJ?=
 =?us-ascii?Q?pYJAlmHH3moxq/e1Vo+VRIMuioi52wLqtWp7CYO9broVptguEx1fu4y155IK?=
 =?us-ascii?Q?MJ2GYK20ScRgHKSjTSk5ToXXthpJF0zH4Qt/suxp5mZfmqz/hzlmsc2tpCVe?=
 =?us-ascii?Q?2J43zLsq9THtU89iaOvjKBY6EVrWzyEa8j8PTtdqltCX/HhPyOaKxk1v3Kaq?=
 =?us-ascii?Q?T8m6/HekEINPP5JQMEckEM6KZ/gu5z8MKuxYZjk1aNf3n3kZfEFnKYbH1IEd?=
 =?us-ascii?Q?j6/YXIirIOSgnyqDqHYGII1lWM1hh+DdahBdK+Pe9NPyONWbSH7EJxAtu93D?=
 =?us-ascii?Q?Y18wZC7AARpnYrcVgxFx7wG/gyjJxJQ31l6d5kIZ+ZXsJlIDoxN7JOvNtUyK?=
 =?us-ascii?Q?L7B9nhNOa2uJjYQ42t/aXXWB9NlxOJFDuWdqZWb1/tYOg5vm3EzJUQNGPgF1?=
 =?us-ascii?Q?WZKXJv+CJC5+jyAfyFPudGRdNoDQsmeoqT24ooTE/t7XzKtm5P9d3bWATRdB?=
 =?us-ascii?Q?znGljahvb47b8gUtSRttnw+xUiHiA72Q/7BUoI0JIlvTaP8eGLVCp4gSrUap?=
 =?us-ascii?Q?1HFl0W15W/7waV5yEcBYU0VYdl+J5BCCPM9clnt8u1P8hdeKdkJ0mbk8o5y5?=
 =?us-ascii?Q?CKepEudEsJjzdGHVOpvMrlNNF4Jj6CzIgJ6/U7tiUlMheYfO3feoeSqk9Bzc?=
 =?us-ascii?Q?hbw4qFPZOc+lNSb/n02gekdiPSQ52wAKFZvCAE+LMjV3NpyL69Vfo1My1MvS?=
 =?us-ascii?Q?ZHTuXRpG61g75wiyQQ0Qg4ZTRlmVRcOi69Umnv/x3PPMCu7FuSIQBboCa3Y+?=
 =?us-ascii?Q?NNBbDs7GYvfZQHY8eQx/9rcTZoSW+94KBL6AXmwgkyWUV5qb4w9xgDxvyJp2?=
 =?us-ascii?Q?n/prG4VHPTZSa3q3UbHnB0TvaM1gLWLqjd0u4XF+7RZz4dN0+iEaTGcbYLyv?=
 =?us-ascii?Q?LIciHO+KCxvX0kd/N8oNRMen0wv6qQSzZ7FIzQi9GT/rEyGoVv3SZnPUPILs?=
 =?us-ascii?Q?HhtZ9+FbhPoSZN4PxlCeFHMR74nQC7tga3jj1jVu/MvDu/8oRu1G9LYk09Ja?=
 =?us-ascii?Q?PAGg5xAduc5+OzfxzRGDyS9OuwoNPfMiEogzyb0g2avZAY9W38Co28O4DRhg?=
 =?us-ascii?Q?umM0VLF0bo7PtcfaGrlWKW02XFergXcaPMPeOw+61a3hPSZwDsMR8Qk6h3Aj?=
 =?us-ascii?Q?cAYD4F5eIfmXr0jzH9xLnVec?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e96433a3-b313-4013-05b9-08d97e5b1a22
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 06:26:39.3444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m7WIENTtYDk9L+ueyPrGPvK+/uXQs3Uh8ZwNnHGBb/3+/1gM12HHxpeliWI0SNqwX1Vsqyu5VEG0C9EXaNlPVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5580
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 9:32 PM
>=20
> On Wed, Sep 22, 2021 at 12:51:38PM +0000, Liu, Yi L wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, September 22, 2021 1:45 AM
> > >
> > [...]
> > > > diff --git a/drivers/iommu/iommufd/iommufd.c
> > > b/drivers/iommu/iommufd/iommufd.c
> > > > index 641f199f2d41..4839f128b24a 100644
> > > > +++ b/drivers/iommu/iommufd/iommufd.c
> > > > @@ -24,6 +24,7 @@
> > > >  struct iommufd_ctx {
> > > >  	refcount_t refs;
> > > >  	struct mutex lock;
> > > > +	struct xarray ioasid_xa; /* xarray of ioasids */
> > > >  	struct xarray device_xa; /* xarray of bound devices */
> > > >  };
> > > >
> > > > @@ -42,6 +43,16 @@ struct iommufd_device {
> > > >  	u64 dev_cookie;
> > > >  };
> > > >
> > > > +/* Represent an I/O address space */
> > > > +struct iommufd_ioas {
> > > > +	int ioasid;
> > >
> > > xarray id's should consistently be u32s everywhere.
> >
> > sure. just one more check, this id is supposed to be returned to
> > userspace as the return value of ioctl(IOASID_ALLOC). That's why
> > I chose to use "int" as its prototype to make it aligned with the
> > return type of ioctl(). Based on this, do you think it's still better
> > to use "u32" here?
>=20
> I suggest not using the return code from ioctl to exchange data.. The
> rest of the uAPI uses an in/out struct, everything should do
> that consistently.

got it.

Thanks,
Yi Liu
