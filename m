Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F28279D5A
	for <lists+kvm@lfdr.de>; Sun, 27 Sep 2020 03:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbgI0Bv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Sep 2020 21:51:56 -0400
Received: from mga18.intel.com ([134.134.136.126]:27312 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbgI0Bv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Sep 2020 21:51:56 -0400
IronPort-SDR: 0C2n2EFCVCxZqMm30H0OLk6TfpvvlRAoU/SUpjRLUyTke6nVguh+V3XQn4jJ1eW1mXWxWtc6b5
 6VqDQef86i0w==
X-IronPort-AV: E=McAfee;i="6000,8403,9756"; a="149592950"
X-IronPort-AV: E=Sophos;i="5.77,308,1596524400"; 
   d="scan'208";a="149592950"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2020 18:51:53 -0700
IronPort-SDR: YQArnsI5uIEYD0aVQVNtL5ADuIQCUpS85EM6R5NEutSyParBCMZSDs/X4y7jyOrwq1OtN0upgt
 Ns4xgi1vjEyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,308,1596524400"; 
   d="scan'208";a="323868420"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga002.jf.intel.com with ESMTP; 26 Sep 2020 18:51:52 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 26 Sep 2020 18:51:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 26 Sep 2020 18:51:52 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sat, 26 Sep 2020 18:51:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X9KAsZOE8TaXgelAYOHWkw0GoW1AlRBiabROpU1gEAjMJGLWonczEFlBXomKsI22d9NVtsDgwaT7NiBjNyiM7HiU9TW4sgTYA4v8HbnrzxkCJ/TPykPRmpHRVfgUn90x3jGk9LktxVKyblAtVDBapfVBkW0QAE0WwmflAxPQe7QjdZyaiUAhzu47lDM3X66im+LtxWjMrLBUtAkgJGPbzwPievt220aEOgqmQ2sb9cXzciv+MBfjqHDAMaTtJuAuljGADEvC7oijbgUcAlHscowd7MzN+1QNFiFK7SVI2muvF5YrCnBFtRMTmVjAyKrc7ZIpEkczezx1XUdIV++5Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qjr0UU+XlrfDsdcWIeRFU5HVhypOrRCZbDTKEVt0ulo=;
 b=VX7o67K7uQnSAsnlG9LaNZpLU+K33UQ8ekoArjbAEn162IcNoUwI3+f/Mm+WtsNyiQxVr2abK3XZ3mIL8WhMbvt/FzwUNBlNWv0ZsKOFQuzyRLRsxTHb/tFuYS+R5AQ2/5RElTGyF695E0GCeCz5tVlnbi5BZqxMYdvLQ5lf0qvnqKzD+JBpMt30NknVGg9D0njzSXjVKhs+rF+mmEE/cW8a8M+dK1epP2xCJsBf184kvycD0GWVcUDFZtxolXN2v0GmqyR3H1K9qmVZmuGDLYo69rGVoz0rnzGRhpuqTTdphBGOL2eKQ9HPpp0GBPLa38Sxv5T6XtSjHN7Ru7u0rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qjr0UU+XlrfDsdcWIeRFU5HVhypOrRCZbDTKEVt0ulo=;
 b=obgorVYhDflpuRmI80C+pPlqyYhTzqOSy4h8CEIqSaLNLvKztOR9fcM8grAvOOghDzWUnDNLRzvOwEsEXnBd37uWy2NN2rW9GSyKndoQ28eQT2jKLXYn3FVjjNhBePiwSFdWEaT8tZSo15z9q23i9TAvgZF9AWQVVjmiQSrHEU4=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16)
 by MW3PR11MB4746.namprd11.prod.outlook.com (2603:10b6:303:5f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.28; Sun, 27 Sep
 2020 01:51:26 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::c507:6aa8:d408:932d]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::c507:6aa8:d408:932d%4]) with mapi id 15.20.3412.025; Sun, 27 Sep 2020
 01:51:26 +0000
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
Thread-Index: AQHWkKDXpbo0akWSWkKXeJbWVxPoT6l0XvaAgAEDrrCABlCM4A==
Date:   Sun, 27 Sep 2020 01:51:26 +0000
Message-ID: <MWHPR11MB1968CD560E8BB15613F3EA73E3340@MWHPR11MB1968.namprd11.prod.outlook.com>
References: <20200922052343.84388-1-yadong.qi@intel.com>
 <c0157014-d1bb-ef81-b92f-ebecb72396c9@redhat.com>
 <MWHPR11MB196858E9DC7AF08DC87E9261E3380@MWHPR11MB1968.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR11MB196858E9DC7AF08DC87E9261E3380@MWHPR11MB1968.namprd11.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.46.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e6ba7e46-4018-4484-c24e-08d86287d884
x-ms-traffictypediagnostic: MW3PR11MB4746:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB474653894A8300EBDD2B6F39E3340@MW3PR11MB4746.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3CDjT5kSDhjW2h/Be+Xlof1Ds30srHPopL5VGXA/UUd2e+in9DQx7p+Q0qC0YkyLGWityld/fGCZFclCjGvvv/pK4KWvB+Db8L26E53yRIbsNIJT5XewCveCG0NjHZWTYFCbSnX7p9ELt4ev/sXNoJcpKYCZ68m/PRbj1lxpkzsxjjRJXTIQMRr1QrqT/qaSIlQ1Phqudxfs1eTHbIl7Ezkrn+C+dEYtMTwVgiRrf+KVtOa6nho+Dt6rtv0AYXWS5aiOf0SUnbj9Uho5uxrLO56AYq+PIYdcET8T+omxJGKfA2VxzW92QKTmuqcPJ6h2kMI6BU+STiG85bGlj07EkuQD0rduqdhZIXuQjUBz2KZMI94f8GC/rMM8XPhQS1Ii94yZAsZ/CfcS+up9cnoJaanRxEOhGXnEAR50YLYzqTvTX2RqH2gz2DOXLscJTC82
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1968.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(54906003)(107886003)(66476007)(66446008)(64756008)(110136005)(8936002)(316002)(66556008)(4744005)(8676002)(66946007)(76116006)(7416002)(9686003)(6506007)(71200400001)(5660300002)(7696005)(52536014)(55016002)(966005)(478600001)(2906002)(33656002)(26005)(186003)(86362001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: d4ZhfXQ3DD0RzIT8KnYu0dFLvjvN6K+LHmdvBPd8AkihDGf+AIGqnoVfk/ANhL6yguLTLOoUK26B2UYFUThu6t7mtzNLRnSbS6JHxcfMwwplmskB+5mKly83ZH2Skdnv12NcNkLt0YTq6QCEo6r2WTjxbI2tb9sZ0lP2xOeLismKCVPo4Qdxi52cFuW5L+s1s77upDqNbauDdmkKxihs991WA9iTP/Cx9ae3Xc+nJy+my0K6Hu00l70gmuKPEyqKt4jjZT36/G5YGZcnTVFDVlwGH/u05vg1AIQhBS4cTCLIQtHMlWOo27cLM4Gy+TNFXSNgYyTEcWqBHc50Pfyj5DCq+wWj3G/Aj+Q2v0Pi1co1h/ZooiVaxPM/oTl/leBLEvJMQXyQf8W1k9MErVnu3sS8iHeeWpgajbuQ2W2teaDtYeYUfJ5E3v9436BFNFT2+kPjlqWUfEv2UJcm4/JWI3fmITzdm55klmi4PO18UXp+3qrm0HgWssb81TQZI4AXA5xNkGKD9CLEYSzwhQodzNgyhA3m9i59Fw/2u+nWOzFUEOiTrbxt+fEo0ZlZ0RX5WvoBDGMmz7XKvDXNX31iMv9QfWRDzF36tG9D3QV5f6fDxabKIYUOP2n0Hb3v1pnjf+sqLCfc3P2/4CEevGW1bw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1968.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6ba7e46-4018-4484-c24e-08d86287d884
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2020 01:51:26.2482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VIzXLbTyCFec6XGtQlvaA3gk8PTxoRzDxlKAc+96+z6XCKcmTNPSwcaC1GJgcdgfAAp1SEIb4hO2a0PYsfxFhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4746
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBTdWJqZWN0OiBSRTogW1BBVENIXSBLVk06IHg4NjogZW11bGF0ZSB3YWl0LWZvci1TSVBJIGFu
ZCBTSVBJLVZNRXhpdA0KPiANCj4gPiBBZ2FpbiwgdGhpcyBsb29rcyBnb29kIGJ1dCBpdCBuZWVk
cyB0ZXN0Y2FzZXMuDQo+IA0KPiBZZXMsIHRoZSB1bml0IHRlc3QgZGV2ZWxvcG1lbnQgaXMgV0lQ
Lg0KPiANCg0KSGksIFBhb2xvDQoNCkkgaGF2ZSBzZW50IG91dCB0aGUgdW5pdCB0ZXN0IHBhdGNo
Lg0KaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wYXRjaC8xMTc5OTMwNS8NCkNvdWxkIHlv
dSBoZWxwIHJldmlldyBpdD8gVGhhbmtzIGEgbG90Lg0KDQpCZXN0IFJlZ2FyZA0KWWFkb25nDQo=
