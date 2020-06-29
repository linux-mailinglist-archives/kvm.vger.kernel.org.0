Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EE720D6E2
	for <lists+kvm@lfdr.de>; Mon, 29 Jun 2020 22:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731827AbgF2TYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 15:24:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:22494 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732229AbgF2TYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 15:24:13 -0400
IronPort-SDR: QUFCqV4WzEX0DpclvzL0kBs6jwzVpcJXCgAbZajmy8zRTXEWlwaqFxl/9S1L8AgCnvJbldA9m2
 HiGjVBczcpGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="144144724"
X-IronPort-AV: E=Sophos;i="5.75,294,1589266800"; 
   d="scan'208";a="144144724"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 05:23:11 -0700
IronPort-SDR: opdDwj+HB672U4xcrIPAvY6zveLUtMxy1iElSVFTqJnW264T+00B4NbPRsL5kliXRdqCrSGlvc
 NHQTBcEv2rOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,294,1589266800"; 
   d="scan'208";a="280847371"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga006.jf.intel.com with ESMTP; 29 Jun 2020 05:23:11 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 05:23:11 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 29 Jun 2020 05:23:10 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 29 Jun 2020 05:23:10 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.55) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 29 Jun 2020 05:23:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnjE60hSEZAKsbXGaGUAkjzfO9Ak0ghaayHUURKPIWMcI3pZyQeP6WxldnyFh8uSPLF0q8xMNwRbpy4+wmCeztE2qt0FpBWpJ9OT/rbyg9fOxJ+4h7CsJcjI8aIb6kROdBejYx8bIMzndy4Hv6bkpwXsbDQsGfXeIRo+pBExZMrYiypBPOvbsD8Y1VMP+ocxYterhIHVzGtGdOUrUeSpAjXPify4ZHYTDK3DGL7RnrVI/vE3d22CkTposhexStjgN5KeigRtv0KogNGe/66FFuyfNdv+FbaqHz+N0CYrYnh+gCjMGNEZ1s2zLpah0W5RXBHPY9IWEw15GAHskwcGnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+13YzAJD7w6vO8YVDFkU3bnj5WWsLn2FcJvtsl34nog=;
 b=djuyuHv91mc7zHBYZ9s/GyMQl7wZMtERlpgaoXWmtAtJ2Hx/bvAW6JSyI/1XwBr0gkhhuJLijsAHxdAftXOLsYvyCg6KKJMyHeg/0MMSAByV/KCqqsQzoyiXag8qyypesz3NAyeW30GVhLkSod45ypjERSDTzqG7rMk2BYTGeuyiwnCfPBmJtbgTEWTYRgAe9ZVB4VMYH1Jwov3sVk2Gx1135wu2KfhbRPksJNXyGIa+LkUgwjdukHW0E22BftOUZtgxOiFbSFZuFCAaXl3vlVSBNNwmQwvOwZuBP+ftuZeuhu3trZR1hPPlhrsJR7byNzLqBgIEH1j2NGS7YxGCWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+13YzAJD7w6vO8YVDFkU3bnj5WWsLn2FcJvtsl34nog=;
 b=qyMxtctPMF3EICizAH45nFMO1V/X374vdeASqJkt5I1pInJ344MI4bJacVXBTyJTAxsk7UWxDFDM5IX/4dKXDBBJx4in2Il0ThSHnPDRJKZaHAg4fK9BEC0ae+AykaZS3fw+CRGLW3gNyt5KPIl4zM0oz0kzyQjwlprTfOrPwEs=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3708.namprd11.prod.outlook.com (2603:10b6:5:146::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.20; Mon, 29 Jun 2020 12:23:08 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::2c3d:98d9:4e81:c86c]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::2c3d:98d9:4e81:c86c%6]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 12:23:08 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
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
Subject: RE: [PATCH v3 02/14] iommu: Report domain nesting info
Thread-Topic: [PATCH v3 02/14] iommu: Report domain nesting info
Thread-Index: AQHWSgRQVmc9Qp+Xi0mQEumzIJrE0qjvWjsAgAAviUA=
Date:   Mon, 29 Jun 2020 12:23:08 +0000
Message-ID: <DM5PR11MB1435FC14F2E8AC075DE41205C36E0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
 <1592988927-48009-3-git-send-email-yi.l.liu@intel.com>
 <20200629092448.GB31392@stefanha-x1.localdomain>
In-Reply-To: <20200629092448.GB31392@stefanha-x1.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7594ca87-cb8d-44c5-121d-08d81c272e85
x-ms-traffictypediagnostic: DM6PR11MB3708:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3708DF26A6EF34F93AD67AB8C36E0@DM6PR11MB3708.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EQH8LY1QihLjXelKVZq2O/b/4efcuOEmZtC8BcJ4RjdFaWWmwW5j9bkso1ZvYudT7jq+cKVjyseZRV8gqE1fFlJh2CiUYYvoIqd1V/PRN0lvMBVZG5oSUL+hnSsFFmxnk8jHFhmfqkFiwM8o7OyDM4rxjXHpiqho9EtWhBVYgF8fNYBMQdnzHBud+mWiF7CySu+O8gjPqS7E9q4Fn/brxp2lVu4tugVJ9PQLDJdd9GLlSqCdZabJU6/lapaOhXUM0jKGIs/O0KFEuojliRmAztgdFy6MyhN8B0jYhoJP+YIetswJ+ssoV1yK18xA/q+8Dhj4ER3tgDYSYWrR5ZFYyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(478600001)(7696005)(316002)(2906002)(8676002)(8936002)(7416002)(66946007)(54906003)(76116006)(6916009)(6506007)(52536014)(33656002)(66476007)(64756008)(66446008)(5660300002)(66556008)(4326008)(186003)(86362001)(83380400001)(55016002)(9686003)(26005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 4KlcjyTcElFwnXfazHOWtQu0g+uML7Q6H7w+nmdHAw1nS2NoQecUvYqe9Jno4HUduebghDfNRvU2zvTTnK4q8JGr4GJmsXoYXpOilrWWJW9XlGgcY0huqq91mvcPAJ+4bS2wjtmn0plz3WWldwZdv+DmDjCr4JRJLYkIAg6gkgqFi+P9SdqW/ggNGXQg26sCoefvwEdFo+yIv3AB15buhlUXu6Wu8NPfoiZmRjWj92V1TN3Lh5bx8G5rh7dsIw0Weop20t6GBH4j94wVKTrBGOLZSpn42EyQ79vrBnECSDCa2yHJPrzcTl55vA1LWdKhe4bHdAl4j5yqRwkFTEUDwUMTHDMRByvWIzcAsBsWksMJjDVOseXCBKKvCFgb3I3TPfLYMqIbGu6louX+1OBOuDXN+vXw3h5jdcy9TEsiYWTYj56KOia+ImxCZiwk7yV/alwjb1j70cT39WzQpFzd2g4wm7xb6KZkxMWhuZ2qdrFQ73wp37tyPy2UiJC/e3Al
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7594ca87-cb8d-44c5-121d-08d81c272e85
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 12:23:08.1141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rflPj9pyL03NnbKUQ8IK+h22QoRqwRqWwQ9I6kU8fvuLDsHk2nx0YtoAqoABRjezXpXygSB+PI3RiCPlCT4kjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3708
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Stefan,

> From: Stefan Hajnoczi <stefanha@gmail.com>
> Sent: Monday, June 29, 2020 5:25 PM
>=20
> On Wed, Jun 24, 2020 at 01:55:15AM -0700, Liu Yi L wrote:
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
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D+
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
> > + * +---------------+--------------------------------------------------=
--+
>=20
> This feature description is vague about what CACHE_INVLD does and how to
> use it. If I understand correctly, the presence of this feature means
> that VFIO_IOMMU_NESTING_OP_CACHE_INVLD must be used?
>
> The same kind of clarification could be done for SYSWIDE_PASID and
> BIND_PGTBL too.

For SYSWIDE_PASID and BIND_PGTBL, yes, presence of the feature bit
means must use. So the two are requirements to user space if it wants
to setup nesting. While for CACHE_INVLD, it's kind of availability
here. How about removing CACHE_INVLD as presence of BIND_PGTBL should
indicates support of CACHE_INVLD?

Regards,
Yi Liu

> Stefan
