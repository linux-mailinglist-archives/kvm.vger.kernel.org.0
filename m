Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EA331F3AC
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 02:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbhBSBnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 20:43:13 -0500
Received: from mga03.intel.com ([134.134.136.65]:48052 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229471AbhBSBnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 20:43:12 -0500
IronPort-SDR: rQU92St886akbCYbC4XlGNwpM9h15EIqRKlasB33YKKOhQrwJygrGRRebLnKMB21hvaHgAZFtV
 n8uLS38LgsBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9899"; a="183768966"
X-IronPort-AV: E=Sophos;i="5.81,187,1610438400"; 
   d="scan'208";a="183768966"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 17:42:29 -0800
IronPort-SDR: Wv0DZAy2BrReKb6Rf0xFM4tquxPjicOyP5MuerqfDBw8TX759J5MEpM0V+72UI+NE5RIXABSFP
 x29gxEEGoYKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,187,1610438400"; 
   d="scan'208";a="428514274"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 18 Feb 2021 17:42:29 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 18 Feb 2021 17:42:28 -0800
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 18 Feb 2021 17:42:28 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 18 Feb 2021 17:42:28 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 18 Feb 2021 17:42:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Th98+88UM24pq+W/kXpU3y2a8VbL76OPcT8mcDuNP7iTllxycx6cjNMwKZkdLHTAzZmb5Tffnbam2Naj1ZOhv19SzLjhOU1TKEI7wZBC+92vZz4ZMKOoUYvKyEsIJz5D56jZSvZB9UTCYVFpW+Ijzvjr2VucjEOHgPaYcHWz1Ek2NDne2JSyYFUvSp6LbPDgSB7T+yteY3WSuNRxC94QAMvit5/3NuT+KJRXfm7Veoz5hJZKLtk7kGED8z2b1xK60RoN5hTPTpk2ydQY6A8TmdaaNVb/M98xYLEzlg0voA5oDIsFrPZmG/lCCTCn52p8rIYhCHdIYve0WfWNTiAL0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6tzJJRzGG5qp7qQ/vTnHyKHoD0hD04ZUjWXEVtCNLA=;
 b=YUzn5Gn6nvLBAPu2qRVGjjvbFZ6FZkCiOOVpwwSzZeGwHpFZAGMhP2UuRW8Zc+p7XSWxN/bPjmOZ8rWtY5VW93yujdqtPar3mBSiGa7kV8bgN+1b8Js1MAh2mNvttIeSzwhK7LgaPwUq87y4RMZP1Hy9wYtTMM+v0nf2qvx2et+mRSMrepsx1vYfdnCnH0KVsfj0zO65tTtdfLuo6b1StmHRYpPXXYVHJxwtyrlYKVX9ySdO66N6qIvGCBbP12Wd5D5pWuwh9sQYTErAAMV8LnxdaX3SR5QiReruOd8TQ6mSfglUovo5E0HYN70NCr9Ja1p8YTz7wUh9oHDPYpjudw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6tzJJRzGG5qp7qQ/vTnHyKHoD0hD04ZUjWXEVtCNLA=;
 b=Phf643UFfgflB/BiXZntfvzGXaLIkPAuOYzbeVv3Than0r/IYpSV0CMknIzdcKgvOOyXZN3Vp7keh7hkq2JN3fLNmwo/yuv4DsesdCLL9opCr1SVvecuXnFKlOoyqm4FpHTWHhH6jsj30+GtG6ObFI04VuBlw1DCAKVAjpjVs2g=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MW3PR11MB4697.namprd11.prod.outlook.com (2603:10b6:303:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Fri, 19 Feb
 2021 01:42:26 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::f1b4:bace:1e44:4a46]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::f1b4:bace:1e44:4a46%6]) with mapi id 15.20.3846.042; Fri, 19 Feb 2021
 01:42:26 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Jiang, Dave" <dave.jiang@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>
Subject: RE: [PATCH v5 05/14] vfio/mdev: idxd: add basic mdev registration and
 helper functions
Thread-Topic: [PATCH v5 05/14] vfio/mdev: idxd: add basic mdev registration
 and helper functions
Thread-Index: AQHW/AD4vwz31CjC0UGMFUWiPK3cUqpSGYEAgAkbtoCAAClrAIADaRzg
Date:   Fri, 19 Feb 2021 01:42:26 +0000
Message-ID: <MWHPR11MB1886B77D53A77DF32FF938B48C849@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <161255810396.339900.7646244556839438765.stgit@djiang5-desk3.ch.intel.com>
 <161255840486.339900.5478922203128287192.stgit@djiang5-desk3.ch.intel.com>
 <20210210235924.GJ4247@nvidia.com>
 <8ff16d76-6b36-0da6-03ee-aebec2d1a731@intel.com>
 <20210216213310.GJ4247@nvidia.com>
In-Reply-To: <20210216213310.GJ4247@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cdef6cfb-66c4-430a-bfe5-08d8d4779c85
x-ms-traffictypediagnostic: MW3PR11MB4697:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4697FB2D5F98C5E9F9C9721A8C849@MW3PR11MB4697.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:561;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eVY7b7lPQ0ZtzP7y/FjbpWpbzty6K7bG2p9naHRUZqXMtThHLv6mb2+dvHlqm//MHzgv8Y+C/9ieCFusBwoYmOzYH9SnOYXP4xns8tRC9LeHS7rBblQEM4i4/P3eNKmT610haQlGtVG0+ki1aUpe9W5UIdw1KSCzRqutrpcsXf5VZbY1AEwIdx3uhTdHcvUIqn23pBiqDAoFZw4mRVWa1NqEqBBbeAsWAg9lSEVWL/6SwrxmjhvlQOkefq/vFB1T4FhuH4TqvRZYH8kYP3eAOVW2qhWHfppEdcoeIB3D0Mwin7XxtvbuUjdf2xXGz62mqboT77rwB6iEeI7VDKe7r7YuLDAT5wj7WNPtpH5PLEIIdRNLGGpnJybMFmQ879cOd9lUIChlPYm43RF5QPzlYtwNaSNYN9Bbfnig5kpWNZ7/HDjfLRzqsGvU1/rd6uCYvPS9SRFZQXeN35h1+ui2tispJPF1awvVeENwr3gyEhDTu0JrXtSYAb6GxTIK6pILKJUyxvcPASRzR9/YckKgPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(6506007)(7416002)(71200400001)(5660300002)(76116006)(66476007)(8676002)(8936002)(6636002)(83380400001)(110136005)(26005)(4326008)(64756008)(66556008)(52536014)(2906002)(186003)(55016002)(7696005)(66446008)(316002)(478600001)(86362001)(54906003)(9686003)(66946007)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?QvUFQjIGwSTdYHm5VT7mWitdlRhaF8SYjkq26qI8Yfkrzxk3gJ4emEoMEhob?=
 =?us-ascii?Q?462owimMoSwD4P0CqK8ZoPoOxxb46YxezJ6vFhG092tvrlk0iFm4bxgxJaLl?=
 =?us-ascii?Q?mXiggGtLVQqtVEy5ZQoV59GJxTakK13dEghtsJvp7g52tt2G+zehvswgKUyb?=
 =?us-ascii?Q?w8WBX/SnFYvnhKQQ73LkFwMbTaE6w5+F4KT95Mtle7vpdS7C+8Im/4gBnDR/?=
 =?us-ascii?Q?0GF1i3UpJNsM5eOtM4kJ/nlc7c6xBPouYnMMNmGAg+q+fiYJMB/fpu1atOEf?=
 =?us-ascii?Q?+xVWtOeRKPjfQI9wR19Uul6oRNMRAgGDSG1gzlUn0bLstk3CRY5baciBWCmX?=
 =?us-ascii?Q?AfYxD4LNmPWw/LI9qsmrAOSZjRKnDPmghlIwiSzdiSXQ1jKyMdLS1M0kWfJe?=
 =?us-ascii?Q?gaeQ/Ev9I9LEWf/YBKLLxy7nkOH+GVOqF1r2Mn+dylTsFEhUKTZSO+Tk4AW6?=
 =?us-ascii?Q?h9h4D+yYpnKhnoJ7pgqYMKabtPFnIraSgGHG7MASnnM4SjZwU2QmkHPtJAbn?=
 =?us-ascii?Q?nhiQLoDrbnQNeyWxV4+emwhZcIuzXW9Bd+0dIEuPNdM7oIw4FYR2iQ3IlB2M?=
 =?us-ascii?Q?AEi3aMgoMzhB2ahDrh+AVD8oimLb6t23VYST/3eHBLVV/TsUoVTyLLQShzLB?=
 =?us-ascii?Q?eW8WpZsZP+HTOTVjW1vmIJLYLDhBhRfabWlAnlhxZBCKLGQZqs3w8T3dd9CH?=
 =?us-ascii?Q?rlXcnnF1py8jCgTCFMjbaRfSqkJzeUr2jG272JwzMIoTLELVlSz9+J6E5OC+?=
 =?us-ascii?Q?RQkFngbDzc+IpYpTYiM+STPy5z6KaZJlzDgvOUj+pgNF6VeLu6pYcPtBN9/Y?=
 =?us-ascii?Q?W6vjcuAUtJDY7qu9oWoPXUWOLVfCQz9hWG6LCrUyIo2MC+/u5SLfHoT/v4kT?=
 =?us-ascii?Q?dbPaeFXMr9xZYGxqLmP2DHUz6T9CZR54Id1E+ScNSwXeV8HGIF9OcKuN12Rf?=
 =?us-ascii?Q?u2aFz7KIdTKZtpHrgUHsaGjQXT1zufnRow//N6HGQSH8HcNQJnn5sD5wKCPX?=
 =?us-ascii?Q?DpQrZbnhT38BpWQIXBR+V6lGlK8PVL1NdQl/IUXbuJTUg6+v1+bEyb/N6bj5?=
 =?us-ascii?Q?GuhWm5F6X43VemRQm+tQUjbvJkUvAsOSlEMy3JhzFFOhPctuZ/d1VSM03ogn?=
 =?us-ascii?Q?5YO05f69psav1YESD0EQDMvpz8u8D52XN9Vh0GXLgPr0AFb1S3PVZW5Xc3/1?=
 =?us-ascii?Q?+NHRmtk4Pq7uoCMWBFO3VcSyWz2qYTEIihoQ6FfknJDGjpeLjS8vLBU2QV6o?=
 =?us-ascii?Q?w7uPcxV2C2EwYwQI0k4yIP1znPTzjo7N28p7tyssVs50/fxv0tQcKY5rcHJS?=
 =?us-ascii?Q?zZKx6kBElCOoILr72Nrm0YAK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdef6cfb-66c4-430a-bfe5-08d8d4779c85
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2021 01:42:26.3163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SSEuA0E7WNkLSYgbRArChdePCEjvYsbfxs6kTdADspTDLKSqeC7kJ15RPyP2y4C+T9384UPe+AI92/CkBrOvbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4697
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, February 17, 2021 5:33 AM
>=20
> On Tue, Feb 16, 2021 at 12:04:55PM -0700, Dave Jiang wrote:
>=20
> > > > +	return remap_pfn_range(vma, vma->vm_start, pgoff, req_size,
> pg_prot);
> > > Nothing validated req_size - did you copy this from the Intel RDMA
> > > driver? It had a huge security bug just like this.
>=20
> > Thanks. Will add. Some of the code came from the Intel i915 mdev
> > driver.
>=20
> Please make sure it is fixed as well, the security bug is huge.
>=20

It's already been fixed 2yrs ago:

commit 51b00d8509dc69c98740da2ad07308b630d3eb7d
Author: Zhenyu Wang <zhenyuw@linux.intel.com>
Date:   Fri Jan 11 13:58:53 2019 +0800

    drm/i915/gvt: Fix mmap range check

    This is to fix missed mmap range check on vGPU bar2 region
    and only allow to map vGPU allocated GMADDR range, which means
    user space should support sparse mmap to get proper offset for
    mmap vGPU aperture. And this takes care of actual pgoff in mmap
    request as original code always does from beginning of vGPU
    aperture.

    Fixes: 659643f7d814 ("drm/i915/gvt/kvmgt: add vfio/mdev support to KVMG=
T")
    Cc: "Monroy, Rodrigo Axel" <rodrigo.axel.monroy@intel.com>
    Cc: "Orrala Contreras, Alfredo" <alfredo.orrala.contreras@intel.com>
    Cc: stable@vger.kernel.org # v4.10+
    Reviewed-by: Hang Yuan <hang.yuan@intel.com>
    Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>

Thanks
Kevin

