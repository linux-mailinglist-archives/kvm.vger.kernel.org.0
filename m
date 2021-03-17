Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B69A33E30E
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 01:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbhCQAz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 20:55:26 -0400
Received: from mga12.intel.com ([192.55.52.136]:63257 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229467AbhCQAzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 20:55:11 -0400
IronPort-SDR: q0RxbB2+RHhkLX4UgbyVnrP9eo8rzkUU6mxfhmNJmWnwiYTAWTHO1WtAvOaIXd8H4IabQ36CLF
 Mbt0rKyEBq0A==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="168633067"
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="168633067"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 17:55:11 -0700
IronPort-SDR: afk7TOK44Qi2vRyP5BnsMlBZvnSLJW+7+GUvhKfvjoRj1cn4ClpW1CSJOGxgueD8eWXOLd1OK7
 JUL+Q6vz7rnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="372161850"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 16 Mar 2021 17:55:10 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 17:55:10 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 17:55:09 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 16 Mar 2021 17:55:09 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 16 Mar 2021 17:55:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCz2DiMaE6xGjIZdDP669+ZZuyfa4g7DaYM8ogPrOxcCpc3cq1LJpuT7TKaczDEfVa5TawFGELxg/DbnmR9iYCJGAg/7D0iRQKQh0/MF/yd9tzmTyqDR4cJg1onycb0vM5W18JUSsjkPzbOYA0k01VSxlSHqxlCDDJLsT4G7/F1XJHGLEa2ktpSI9hD3abramb+GEf8ZBBFlZfApgNHoQIFVFVFbly4dq4uFgKNhY095jQm6+mDFA45hrDppJV3Xiv94pGee+GG8RZvQsNu8qLdjxr4Qm9VWJ3xP6Zz7JYzUBnITeRhpY1axaIfvYep3kjQJQmYxYWA28IOMsoNy7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iCi0FcWpnPXvgrhIukuby5JHCRNLCN4wIpErKEA8iRo=;
 b=PM1ROaaXTE8b7nxECsl3ynKsXF0FpdCbPuowr0uChC7kMQuTgXkYQL/9hdCXDY7lG4SWtzJxZrxlvXJmdKg2+haKnvctavE8csKX0vAjaWkn0ggtSK3m2o3ohdXy0UxnAQEkTCGYFYKb35G9wMN3FXsCK2Sz6vhP7Y+GkU58DrrwmB/l9nvdF/gLFBvwF7h4bca1QoyRQSYKXuy1TLbLjXLZgO0zCO6RsNY/4OtE6vX4ggUjdFofAikE5WxEp4QSm9Yh/0S8JEMoy2y5+AI+qbNxMZGKvRmKTjDKb//ufjIO8jhpwl5jHClCweXC2yet9hrOn6ACIXDGVAdL2tXJvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iCi0FcWpnPXvgrhIukuby5JHCRNLCN4wIpErKEA8iRo=;
 b=heGPXc+geFoUx2ndewqgiXww8ng+EOVmmGZS7G0lVgpAUYM4Ds2Nd4PHSUnTs31b0eBUCR93z0ewPkdanV08Dq2cEQfOMYQ8mTbbZd7FJq8JxAO9h0VtZ544TAcwnUh3iaVmFJETA9kVjSHemY3+OVmJ54XVV1bXi/maidX9DZc=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MW3PR11MB4652.namprd11.prod.outlook.com (2603:10b6:303:5a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 00:55:07 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3933.033; Wed, 17 Mar 2021
 00:55:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Christoph Hellwig" <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2 03/14] vfio: Split creation of a vfio_device into init
 and register ops
Thread-Topic: [PATCH v2 03/14] vfio: Split creation of a vfio_device into init
 and register ops
Thread-Index: AQHXF6PxoJBvqnz7JkaCSbwgmarIu6qGQCyAgABisICAALyH0A==
Date:   Wed, 17 Mar 2021 00:55:06 +0000
Message-ID: <MWHPR11MB1886E2E09E16F4E9517677EC8C6A9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <3-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <MWHPR11MB188641760EE646AF47CABB6B8C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210316133421.GL2356281@nvidia.com>
In-Reply-To: <20210316133421.GL2356281@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.88.226.48]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61943f06-f0b8-4b77-7b2e-08d8e8df4ec6
x-ms-traffictypediagnostic: MW3PR11MB4652:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB465237E2EB3B14866DB54E578C6A9@MW3PR11MB4652.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ymlk6/FjIWX9QQwU19hyEi1N7T0hUI9LBjANi7zwzXOl8Fqk1rKXHHesuNPhYTQeJRt5In5lAsatNasUWkc5JphoaW7WZAiawDhIDIkiT/b3ZyT8S6DZnmcVzxfM1m1PuX7QhpncZ4CX914edHKEL66x6rXfQMm3wi2TTUznJFx8sRJcU/hL8Al+NKliEkghoL5KvZckF3062xFOAqUZ+ZECACsYDfFP7eGGFOPSGCJ3A2X7tgyEd5+LxilbHoBgCCFefzmmydpUsXqIACSbWf2rXuNJ5DZsncbQfHbOy9jckR5pASOqi7K1pmKLeZAereNmUaa72Vd5VobBWLCn3XT7aGFBNhwh6IWb7xYlStmRRTnH989TNjgw7jJLsH0DMpQSQHDwZ2kz0rtmVvwIvWmkAKMCzhLR0h3+6wkl5/hsAfHyZsSAFKKYJBFKAHTMPNLC27Fs1E1psrbZW774DlU2hcNf3Z7+/BIqMzvK8LilxT2H6GECUxNRaph+G7av9XenZYx1LgURKnNjgwlou3ORy+ltc7kVNnnvtTAoAe8Jm+OnLQHX3an5v8lhqD7M
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(136003)(396003)(346002)(66556008)(7416002)(76116006)(66446008)(7696005)(55016002)(83380400001)(26005)(66476007)(9686003)(33656002)(6916009)(71200400001)(64756008)(4326008)(6506007)(8676002)(316002)(5660300002)(478600001)(86362001)(2906002)(186003)(66946007)(8936002)(52536014)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?RqXj4+n+HDYP9jkMdOUXynfFsZOJCryp5SH6X803G9Yflm5031VmxsUfaO/i?=
 =?us-ascii?Q?wYt+/pV+0B0UByG+D/oriBmlaJC3NLTDeAHHTLRRO84/ePUGK3/XXGsMeoVR?=
 =?us-ascii?Q?ZciSzcN55WvBXjj22zwIL3gZnZFtFAO3647y/79czA4n13WzwXggeXHFUm0Q?=
 =?us-ascii?Q?oPlp8F7UwEGG777+hHFuWZce/GEKbEE90FnRNTQ/U8wlXQkTr8XOTAnzBc2T?=
 =?us-ascii?Q?padm1rF1arGbOAfEjq0Ulb/+dBNWDlVJ+iR+JE1bWk31AUqachYNBro2wDGG?=
 =?us-ascii?Q?jwPwX38hXR/NMvhgBp0oUx/WVbKCw/CCzlOS9op4ZZ1zChDz0n0tdYdPKFyu?=
 =?us-ascii?Q?XMFGxJ2OH8v9dNsz9UKyW9S+uemno3JdT3AJBEo1xFY/GOUO83BENLVnbrsD?=
 =?us-ascii?Q?0i5h89CO1Mun48WDW57HY1I80WKQmVAaSEwH+4TtN+xvkiXO7c7ksWPLhW0P?=
 =?us-ascii?Q?mM8h8N2RPgec+rEqg8K/yyimisvj2X6AHyfmbFPQXsfpe1q1HO+1Q6fS006k?=
 =?us-ascii?Q?J+q43NMc7FVY2JsKPtQ3I7Fb29lh/B30DE9EYXa0hXPO9WTt1IS7hqE1UGeQ?=
 =?us-ascii?Q?2fdSayoeHcih6sZhWRUyZZsHuvUNfQ7vJmUx0TSmsGStHt8alVjhdApZWCx9?=
 =?us-ascii?Q?tgrpBuDYxVo1U6q7ZKNt8F4qdsjqg/Mz+hGgOL8ZsZWDiMnQZdtf7YDeSCoe?=
 =?us-ascii?Q?GVO9tLfMbUU95G7jREi3gwkSNt7xeeOIsOfeSjgssuJ+8FeYeKB1Le3By3EX?=
 =?us-ascii?Q?9gltBKy/XNuTudeQnbzRrXfTDsxH36izG5Pe873ZEk8UIjertvfRP1k+YqrN?=
 =?us-ascii?Q?ZQ7Lbd9smpPIgDda0iiO75+M6nDMKM+cLRu2WGc1YJF6LEEHyiPktLvuZ/u1?=
 =?us-ascii?Q?cc/awLLalWrkp4tI6nr0fwsH/vNARPlAskUNTmWgkyVIJwXHaHDH4HK6DBKO?=
 =?us-ascii?Q?/tD8kw/yuBRqv8l7MZjqtol0gHKQ7UwUab/dPrYcikOLThAanJ2kq35ZQPwW?=
 =?us-ascii?Q?2eoV2rDnWtlQ4STkZjrQ1YxOhsdvjV34iDLoGrCjlJdcm8bEec6VWeOUpw0C?=
 =?us-ascii?Q?UvDT1bXaknIy3NbIlRttTVyPhfrmWNFmDWD0sshye00b0hCGWvRxiGev+UJw?=
 =?us-ascii?Q?e2vQRfan8qOHcji9wJ7UODCkh/70bCSYgP8U6zyNHQVdBICrjBjcJUjexjiS?=
 =?us-ascii?Q?CXoKZWKQUDQuZzBU9T8VxelmPjCiz7Q0+EalsnLynefW0F9fQ9viKLBEWfA6?=
 =?us-ascii?Q?xvlu3zfgJczjqMwNp8D9cnuUviqie3PPj+5qfLgigydeDDpd4yRuAGMQ4p/o?=
 =?us-ascii?Q?l0SRES7BUkFZtIgodH73n3Jn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61943f06-f0b8-4b77-7b2e-08d8e8df4ec6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 00:55:06.9137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sBkubfF2JIsuKJXisSopxCwsXUv8TH/Ren5Ljp3PENHqZyok0rMlRRiEWbaLKa+FbU89dA2wv5IEM5SzWrpAEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4652
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, March 16, 2021 9:34 PM
>=20
> On Tue, Mar 16, 2021 at 07:55:11AM +0000, Tian, Kevin wrote:
>=20
> > > +void *vfio_del_group_dev(struct device *dev)
> > > +{
> > > +	struct vfio_device *device =3D dev_get_drvdata(dev);
> > > +	void *device_data =3D device->device_data;
> > > +
> > > +	vfio_unregister_group_dev(device);
> > >  	dev_set_drvdata(dev, NULL);
> >
> > Move to vfio_unregister_group_dev? In the cover letter you mentioned
> > that drvdata is managed by the driver but removed from the core.
>=20
> "removed from the core" means the core code doesn't touch drvdata at
> all.
>=20
> > Looks it's also the rule obeyed by the following patches.
>=20
> The dev_set_drvdata(NULL) on remove is mostly cargo-cult nonsense. The
> driver core sets it to null immediately after the remove function
> returns, so to add another set needs a very strong reason.
>=20
> It is only left here temporarily, the last patch deletes it.
>=20

Ah, I didn't realize dev_set_drvdata(NULL) is nonsense here. Just saw
no place clears it after this series.=20

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

