Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BDA413F15
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 03:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbhIVBwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 21:52:39 -0400
Received: from mga17.intel.com ([192.55.52.151]:28726 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230433AbhIVBwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 21:52:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="203653946"
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="203653946"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 18:51:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="585221094"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga004.jf.intel.com with ESMTP; 21 Sep 2021 18:51:08 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 18:51:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 18:51:07 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 18:51:07 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 18:51:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZftJc2/fy+S0J/IqwpdH2OfAue53+GnmmuMw2XmRWvaRbaQEgBNzIV1IfAyJCyC7T7n/9eBBfAXgm1qqL/eoCNFPaY1ke226M8/KAYU+wKfcejglVRi/edJRIdyAZKYSJv/fPfcEUuKZfUMkqjhUH/Y6ATmAGASSo1vcaUcOQvKIAYwtJDjDneQtR4doRhWOuTeJnPWJACFTdHBh2AYug+EktxwrVofhx38TxX57Ia3cglAupkrq3mI5PnoxjWLRs0A54N+MBXKLIEw+g5ik07BXOllgMaM3yuS7Xq/8cOaHaaV4DTAC48zmbFuyhv6Sh2r4xJKjp+YlcgSnOjhZZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=6d7YhbS1ShO4VxtfGKedQDJCJqZXIESEtaqyYFUDViY=;
 b=Rclz//vkXe4bU93mOgLheZjcGH0O6kdDbyKsiijnqnzeHpu6txytQXTOB0yepcT1R0Qjw85vDtlLuBcfyHWs2QrSxyyYEbc3406MbNFjtGe0Is2tOsw1wsxukl6IlxopE54J+cw0TGkD6OHg4Wbij1JMXaCbkFaOEO8s7RRVi/qf1Kr9JuDMQeTM4R+sj7cP2rE4iFI9+jErSQlN8SgThSA1aBDJifzMsBy5Gt2FA7i0hAeWuO2Pl3WQfoeIQjtTHCgFc/fklItiDy7fN2NuXLje+DU0mGNecvKUNaJFbN0yRvpnOSywxDbda1W5cnqWpPeDsF2C6r9u4twpPQPreA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6d7YhbS1ShO4VxtfGKedQDJCJqZXIESEtaqyYFUDViY=;
 b=xA87GZTl5o0w4qD23x9R2WyKJnsf/a04ZrMMuvjMQTdfjSYY624u9BiXMCGUwr3kXQZv9J5iytmjQ4O4L+PTLwqqH59WZBPcyP9bEOAUw449AqJO4JNeaS3/4pwRJlN0blu5RZoegjjENhOkXnmOgZlFELm2hXufcPU6bCdzD2w=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN9PR11MB5500.namprd11.prod.outlook.com (2603:10b6:408:105::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 01:51:03 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 01:51:03 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
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
Subject: RE: [RFC 01/20] iommu/iommufd: Add /dev/iommu core
Thread-Topic: [RFC 01/20] iommu/iommufd: Add /dev/iommu core
Thread-Index: AQHXrSFnPBIvaGfS70e23Uj7Zne3L6uupBEAgACprmA=
Date:   Wed, 22 Sep 2021 01:51:03 +0000
Message-ID: <BN9PR11MB543344B31D1AC7C8BC054E268CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-2-yi.l.liu@intel.com>
 <20210921154138.GM327412@nvidia.com>
In-Reply-To: <20210921154138.GM327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5094581-5d4e-4aa1-d438-08d97d6b6fc0
x-ms-traffictypediagnostic: BN9PR11MB5500:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN9PR11MB55001AF9A9020B67E7AC8B8B8CA29@BN9PR11MB5500.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hfv39K7zOCv6m8RXHbEO+Zro3iF0zsqTaHkpt7+RzqGFAGM5r1jLD+sLqTxOtStYHIGI/yvlrM22DO+tLwZhyTP5DBuJV/R78EfIoW7OyoPKzyv/vOcaq3i45VmobUa3Vgtk3JgWvE35uuGCMCEnaXkOz+4azh5R1JDQgOICn1g0g033iz3zJXijiW22S9GnSIPKT5isgNYBgme7MFvvLReMmLyDFolrJvvs+vkjFazS1bC6HTCqr8sS7bZy5SnoVyYN245bs7OjatFB+EAbNir7sv1OWtke6nZ9qevZ0ij/JAX2aacb51CoFYSzYtgfEDoyuQlpeAd2axsa3clHiNYA3Mki/UFWOX9iEhr8j2njFpNAFE3zkxoQLDj4o0En169hg5Dp1eON9D5at60BHvoJMfFHCZkkc3/2MK80csEtzdMEuo3b23JKkB7RiXJgBMRjOQ40TYOL+wm/atzpEgGr43UdAjm/66k8t8ebf3UJIQAkm2D91FOLCq+091WG7ENYWuYnNa6VUUg5RjVJgqfTKTU5rz/qILBSMdzEkWOc9mlNN/9WUB9mfDkeXSE+sQWzujyhHg5yVIS7XPPLTZ6tCkRHHok4W+DwaDiGrr5vTRCEz7hDVw8F1vxivznxtuJz+N2AJF/CtJ72PY1bN6ZvgilWQjJS6s9dIkQmFD8pVr+q0Eu/EIxuUPH5TV7f0AgW/HAKY//ie4bPnBvu0Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(122000001)(6506007)(8936002)(86362001)(8676002)(38100700002)(2906002)(83380400001)(55016002)(9686003)(38070700005)(52536014)(7416002)(6636002)(54906003)(33656002)(316002)(110136005)(508600001)(26005)(4744005)(7696005)(64756008)(4326008)(66556008)(66476007)(66946007)(5660300002)(66446008)(76116006)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?K3a/kwSITHtc+0vR86MFSdf8dKt9kAx7Q5YRaDW+NRFqX2K1COGC85c55Ib0?=
 =?us-ascii?Q?Cp25oXqULJDjty4U0POmkkdHbnk1d50AdLLpDl1/BChn6973/DWQEQXEHb0N?=
 =?us-ascii?Q?Uh7VDh1795EI8E+vS/JBreu/JnKelgO6/fwCtAPUi9+AHA+sU0xMtUSzcKo4?=
 =?us-ascii?Q?BFCR/w39fjeN8Ky/U7UW7C7F9eDjCfhUPRx6XtkWomnAHkU/M4MrPpjGagQ2?=
 =?us-ascii?Q?lwW2ahDomxvXOsT99ofFS8E/x0+S9Kwg3BkHatRXXJex9g2RFpfzKcm/q25O?=
 =?us-ascii?Q?uo8HaarKTMJoV5mugXlTqwHmYSgJng4FePR1dS949O5aKzDfXVnTOkyKFgdp?=
 =?us-ascii?Q?zeFjaUAa8GVYeUiBGLekw9N7sGPXw18J2A42hKJxspqiYBK8VFf/SMHJnQ/c?=
 =?us-ascii?Q?JB/LUH+PS1N7LgBEfbd6xb9e3Z9Q+HVL71woYrsdHyh5Li41nb67z8nXCd7l?=
 =?us-ascii?Q?TzIkstNlOO6jN3TEj2ml9pNfnFQjOhPrvANzDaIFKUQdH4duhncnLErPuPir?=
 =?us-ascii?Q?ZUmhpb2TLMTrk1Fw349RLfhpCvDkbd/UyL6aWXAc5D/uePSdah3NRTAlrw6S?=
 =?us-ascii?Q?3V4U0GsrYwwAJc6TEV3LEzg1Znw39il3ENQPg2tqd1AELgymLS+JAN4a/UWr?=
 =?us-ascii?Q?GmJjoWoJsDzJeHhFPa7GGlEZZYL5NMfAS7Ei1uM9DU7YfnzGyKol6zzmubeu?=
 =?us-ascii?Q?yR05FbzTwNyzwa7JX5bpUPAe8Hi/VRsXXyq6IdE1atup7C01hWizUqVfY7WU?=
 =?us-ascii?Q?zlP8KD6gZnAaKOCyKQU/b/+Nyfdr9KEi7xhEqgFshZz8RdJdPRZvPmoxv5Jf?=
 =?us-ascii?Q?05wzef58ie9uZ5OpnoIYHuJUHZAsWNrHmvBRdU4Y0Y794EQopM8UdHsowzbW?=
 =?us-ascii?Q?IMsHnLIqijTOQvZaZmap9JGMsvlioZYNjnma6GCCs3Ol6NlMeENp2bCobBa9?=
 =?us-ascii?Q?LPNBztzmlqzAOIbIbKD9MZi0NxLSwnUGtBT5ZdrbFDRvivw/CTWZl6fUb08+?=
 =?us-ascii?Q?wehUfW/3bcirQQP4MuoUNjD9HRptKIpj2pDl5aO1/fawd4H6AM+uZb/Dagwb?=
 =?us-ascii?Q?ADGO3djLX73qbXNfAhHn+7rWJxoDzlKa52PXfu0VemM29RrO++5x/2ocPEVF?=
 =?us-ascii?Q?HwnxEtp/yHan4kBzqeVsfuZxxiE8IML6RcXCi4s88f1Csr2I83aqbFSCB++3?=
 =?us-ascii?Q?O2tSivjL5EdBZIzPptwOtFwt8p6oDAGV8RkgBghzhxKOI7MZKVyGQe+tK574?=
 =?us-ascii?Q?ZCTfnmknnP9Rldk9zgdnVN9BOa2tceq/OqHRiSInIy/qbv8a608fr/rtPe6i?=
 =?us-ascii?Q?27fue077CgsYUWMyiVk8HhRt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5094581-5d4e-4aa1-d438-08d97d6b6fc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 01:51:03.7510
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EnGVvkGh3G61hGXw7/4AW+nt991q5JD7V+Lkk/hJ4xTjpqTCHLwtrBesh1GN8glSuCYKyhmyVfHg1uVONRn28A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5500
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, September 21, 2021 11:42 PM
>=20
>  - Delete the iommufd_ctx->lock. Use RCU to protect load, erase/alloc doe=
s
>    not need locking (order it properly too, it is in the wrong order), an=
d
>    don't check for duplicate devices or dev_cookie duplication, that
>    is user error and is harmless to the kernel.
>=20

I'm confused here. yes it's user error, but we check so many user errors
and then return -EINVAL, -EBUSY, etc. Why is this one special?
