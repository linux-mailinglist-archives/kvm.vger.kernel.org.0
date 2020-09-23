Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119C5274DF0
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 02:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgIWAm0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 20:42:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:30653 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbgIWAmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Sep 2020 20:42:25 -0400
IronPort-SDR: fBvUd6DkQroTS5UXemMRK1+xBfSV95a+L3ZGWQy9tERAO34XKqpk+/Wm8ZXSOQAosiqTA9o9KO
 vyDu87WSnxKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9752"; a="148500441"
X-IronPort-AV: E=Sophos;i="5.77,292,1596524400"; 
   d="scan'208";a="148500441"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2020 17:42:24 -0700
IronPort-SDR: m9JSWIzVB8856v5O4LF6S3dn/ZJV8s81t1VICbn1FQpocsFD3rNVuBhtpiax59nJFtGhSgmNUO
 LMWv4ZHCnroQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,292,1596524400"; 
   d="scan'208";a="412828679"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 22 Sep 2020 17:42:24 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 22 Sep 2020 17:42:23 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 22 Sep 2020 17:42:23 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 22 Sep 2020 17:42:23 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 22 Sep 2020 17:42:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZFog7WUDt1cgZORJdaY/mgk2FOTXT0VPz0nxz0AiSuOngfFlNCNQ/S8yYF+z9hejrV7d/lvAB854MroQD5gnW+Xm81D44OLLxYrPceL3qx0bBpPEQEHpXpIw5siyGdRBOwjclB42SYCwOs24BDBJZFhipxu6g47t2BG+zdkXPXSdJFJQxiZuV9BFQvlHM7O1nsMr+l9GvsvqHLTRvHTbaO6lkLHu73OP1viLsgkC96xLVjPQGkl9N9xcA+XAqe5fvrSkdUrcBcIztw+BHV1bvqfXfKGzPtCVR4EiRKCJJ7goY3dpNcUZEmXD6wHewlLHZdSLmJhooZfdHzkdIGxVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/2RGz7MwW0mmvO/pieWlLi67QRWs0npRkaUisR7eCk=;
 b=nhR6HW2uH4FtRLsly2QeqJTMe4FBLtVjCxEW39rAHYNT1wMSyGB2Uh3n78X1YCdVoRNIMCEU/wf4tn0nQ7Z14JcKGKID0hUg/H8YuCqNX3ItPL8pxW0Q5AZcfWbXwi2s54bllNwBzB3JH/mtKdmGi061Gj7ylQozO6XLZfWmdgmpzUrsOzJQpsQPRdHCtLCRp9A8N7ciJIJZtmewPnKVis4DHiFWmanzBgWHeDQuA7y66SVi+0CwCMe08lit7AoTpgmlKmXvW+AjCFJHa5QTB21y7oV+fLaLdN6fP6WMdbfQC/7Qqsp8LdpmA+aRtaAxlVzNO2L8OLpnuTNKo/Ms3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/2RGz7MwW0mmvO/pieWlLi67QRWs0npRkaUisR7eCk=;
 b=Qt5iVTfUdvlX3y+onHsXtaEk1mQAkZGIE0KCvxf2+ognf7Zqc0U5btp3SCKvkeLO2tYQSctb3xiDvX0CLWgh23T+tGqpL6TBp5EQLmY3ujVHQIdkb4FaSdXfyx9kHGg/O173kUvFTKecFjrmYk9tzAWko16fCwXVOxy/BpGlkMU=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16)
 by MW3PR11MB4569.namprd11.prod.outlook.com (2603:10b6:303:54::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Wed, 23 Sep
 2020 00:42:13 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::fcf5:948c:28d7:7ee3]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::fcf5:948c:28d7:7ee3%8]) with mapi id 15.20.3391.027; Wed, 23 Sep 2020
 00:42:12 +0000
From:   "Qi, Yadong" <yadong.qi@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "nikita.leshchenko@oracle.com" <nikita.leshchenko@oracle.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Chen, Luhai" <luhai.chen@intel.com>,
        "Zhu, Bing" <bing.zhu@intel.com>,
        "Wang, Kai Z" <kai.z.wang@intel.com>
Subject: RE: [PATCH] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
Thread-Topic: [PATCH] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
Thread-Index: AQHWkKDXpbo0akWSWkKXeJbWVxPoT6l0XvaAgAEDrrA=
Date:   Wed, 23 Sep 2020 00:42:12 +0000
Message-ID: <MWHPR11MB196858E9DC7AF08DC87E9261E3380@MWHPR11MB1968.namprd11.prod.outlook.com>
References: <20200922052343.84388-1-yadong.qi@intel.com>
 <c0157014-d1bb-ef81-b92f-ebecb72396c9@redhat.com>
In-Reply-To: <c0157014-d1bb-ef81-b92f-ebecb72396c9@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.102.204.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58c8f500-3f90-43bf-b2b7-08d85f598326
x-ms-traffictypediagnostic: MW3PR11MB4569:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4569101B9363E72681C031CFE3380@MW3PR11MB4569.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dVYHQmupyVrvKakUC3+8RXdlP7y39Q6U0o7phC9m797HfLzz9rogs5q90Irfe9w7SmlN1WLaVGo+Imnw8qVMCHbonZe2u8YEp9sxqlhQUZuID6JkpawuXgJkNHIGP2CeWweHfE9QnLC4EaO50iuyrWX8D/CwNKSPv14CFwq4U11VVSKgKLnYrAjnhQ3TfBIzLI8cq2vNAK+IcCarbpytT2Nx6AxrZfQujR9wDnpofJhl1oDV04heWQV/nbtEAUfW1MGDUvkfk0u4d8PbkfRQYBJwR5HL2OsTQG7l0WwI09L24UGtLs4OPDAcbV6zf5UcNMW9MPBr6qNNJakJkQLB8+/PiIilcVga/XY0r+yurfv8qs9e4TsTQLHVyXujp+Qo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1968.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(55016002)(71200400001)(52536014)(316002)(558084003)(8936002)(6506007)(8676002)(9686003)(5660300002)(7696005)(76116006)(107886003)(66946007)(66476007)(186003)(33656002)(66556008)(7416002)(4326008)(66446008)(64756008)(110136005)(86362001)(26005)(478600001)(2906002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: aRYSEMP+VBQy6L7tBDB8FJHNNtQ2SbDpr14pH3FzwkHk/FJ4OLqmMgU7QKXYDalTU4DRHOLoM/BCmmQgffEjt182atp7P/bzIx+L0P89sxSwszm0LdhuPrCRNVBc75OQXIR7zUKiJSdQKhfoM6fw6IjCQEkBymnwEArOIFYPmxdcwdnqnC49HPxX9CK/sFEp36ux83XnL/Vn4WZL4L6EBcs8XTRJ23JuruGrL57vj7pKSboUctSqw5jNjHsXcqx+q283AyfsXNjP0DrG0eUtWsVwz/qWK+OIGDKC0iLJzoKIALK+KeIszPbRBNyTl3YNwtkeJ1Se5Z35NBVx+US1b7pYuMvj9a1B/H6lDtAj/wv2K5XpaeJxjV9FaJjTQE2EtVDtLybHyoGn/TDDjx/JUfI1AUQfPuUtpIu/a3ooL5SbJq25BzJKf5/n4BoQSEEG/o3Y3EBceqtm0ZoBnCQL1PcZnAX9t1s0eXk4/uRW74WNu/ttJuhhDZSul8tlFaAERYsnzo8GpQ10fZkM3CT4kcXGX4I5bPGMVesM/In0ZQGQBSVyjAMw4AZK4C/paSKehHBewej6uBnvMO6aGDRgMfzOVsZHPgWcAS3Sqqu7Ke08JCK3YhdPBz50I94kBMrUCQZAGZGyBKo64keAhz++3A==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1968.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58c8f500-3f90-43bf-b2b7-08d85f598326
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 00:42:12.6866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wXSTPYndJqHD1B+8BrYYLVpxJ4eDzHS2jqis2Rc9Q3HBaLn6/mlN9gLdLiUaAMQgFrBZqeSX662fPO0NxAKpNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4569
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBBZ2FpbiwgdGhpcyBsb29rcyBnb29kIGJ1dCBpdCBuZWVkcyB0ZXN0Y2FzZXMuDQoNClllcywg
dGhlIHVuaXQgdGVzdCBkZXZlbG9wbWVudCBpcyBXSVAuDQoNCkJlc3QgUmVnYXJkDQpZYWRvbmcN
Cg0K
