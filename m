Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE7E29526A
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 20:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440795AbgJUSty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 14:49:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:36473 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394632AbgJUSty (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 14:49:54 -0400
IronPort-SDR: E4CJKJVdZEf9NELIkb+9G3TQRSzSLpK0KtLOPMGi0lgt1DD2+MI2HVkDD08Pu5UTz6VwZyhU96
 rwuADhazKPSg==
X-IronPort-AV: E=McAfee;i="6000,8403,9781"; a="154371989"
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400"; 
   d="scan'208";a="154371989"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 11:49:53 -0700
IronPort-SDR: DwwFrwfyPOv4xs1EKHQP+3G1+PH3UdGrifvhbyrvV7oUO0okopCQeOfRYJyqoB4K3wy8FwSjg1
 vcHSUqZiTUCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400"; 
   d="scan'208";a="302165606"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 21 Oct 2020 11:49:52 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 21 Oct 2020 11:49:52 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 21 Oct 2020 11:49:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 21 Oct 2020 11:49:52 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.58) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 21 Oct 2020 11:49:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MA1m9Gwyy40TBIjTd1WHCknGHuZPqXdElF/a/WK7fL6AcR6gGRlvU+m15PHIN2l7ZQAfNDlc6tBio4pcO75m38Cj3KU2jo4x8Nxz1UwVXZLSg09ZEI7/V8AwSRe4Srd78KV2kQQpriMCJXYJiEssNQd2I7U/EQTkK33zhWgxPJdED2Li1e3Bwds1BOoyocBwlW0whG6fr59L1qwmBXbNLiKAzX+kkc9/1XBFXS3sNp0DcyVpZCqICoJrjePbvzrcI90E93cjVyPw3pHhwua8kE7S+FDWyOnIQlO7WpEB18ROxWfT7A00fujvMzv/r3xI9gVnSLLzDPnAuel5GCl3LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iH6noq2MRuWvo8Fsgzafzn/Qsd4zAP0hQiWHU6kzHcg=;
 b=Ek5SDvxweu8tCCJ3TngO3vQ0E9mQ0QpiM0UsWZKImbWlaHDp9RFoPawRVABxScZgVUJuXfgj/uwDYipM7vwApCeCpS4S+5Z9HW2DojroLIELqKnchXkjvSmroWruVN+7P/9q2IqoNQkQGkDDAJEqOae65AluogvVQhCwgXcAHHZDZxSO3kcsKYx9SKhSPZ5jFxZb5we6k4REeG1wZgvnKIBpxdXCVUfE7X00gQ2/E/6hZI4p+fe0aJ+7EeTXXUaeOPs9hcfDRR2qsobEHUGB5RtbExRLM1dFsCoGrEy/c/ThIK/M/Kh7xN8FLDUKhP9PFhtPCKeLgE6e4HA3gjuS7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iH6noq2MRuWvo8Fsgzafzn/Qsd4zAP0hQiWHU6kzHcg=;
 b=kCFft+vZvJA1h9uj+bsDylXwq4J43JmSs73E0tCZoZeieKITQRVbntGbQZJ8yJOGvzgCkWpXurxoNJnKm/WSr/CeD6zgmJuaXVPNlNYZ2+GDAzd2NxktBUIFl3oyM/KtEmX9WXCrRhTkgHBgSv1rgGm3NuaF5cO4yZOYfss51xo=
Received: from SN6PR11MB3184.namprd11.prod.outlook.com (2603:10b6:805:bd::17)
 by SA0PR11MB4752.namprd11.prod.outlook.com (2603:10b6:806:99::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Wed, 21 Oct
 2020 18:49:47 +0000
Received: from SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::b901:8e07:4340:6704]) by SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::b901:8e07:4340:6704%7]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 18:49:47 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "wad@chromium.org" <wad@chromium.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
Subject: Re: [RFCv2 15/16] KVM: Unmap protected pages from direct mapping
Thread-Topic: [RFCv2 15/16] KVM: Unmap protected pages from direct mapping
Thread-Index: AQHWpqkA1YU9N1KX5UmrdwJUGbXroKmiaJIA
Date:   Wed, 21 Oct 2020 18:49:47 +0000
Message-ID: <f36511d73d69cefc1944290ee29acbd71fd90e6f.camel@intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
         <20201020061859.18385-16-kirill.shutemov@linux.intel.com>
In-Reply-To: <20201020061859.18385-16-kirill.shutemov@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.137.79]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c98922a-1621-4448-ba34-08d875f215ae
x-ms-traffictypediagnostic: SA0PR11MB4752:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB4752B7EFCB82308777AC5DF6C91C0@SA0PR11MB4752.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: czfaWLZuHz2KAP4wL4v+WejWq8jE5MuMbuBqYGdnms2xtmVOQksd3Wu9+CtIR94l8wr8xNYpnGj9QF/aTkLIHPJch38B/RrPIILzP9OzTGQoUYBmCz+WpmNcpToT1ELxaM8zUQYxES0aGN/+ws1BUnHGppTU7dC7KClHgTy+obB8VyC3Lpcqx9/DpvjvRXQK8cuYw79bznoh1nfOv4n0Zmlava1IQYxO0NnyFOBydyb6uaoOo2DRiUL7aBmJOcOnwLvTh04QhWSNdQoBRsUYxOWER6d0sVEPvsRX8RM4SG9DpKI+9lIJ6PAdubKXxrS1qlYrm7fJSj/kAZ1r3o6rmHbcOMZ7+ccNy8ibpXfNDmEXFhDkTcWTjINOwST59piJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(2616005)(6512007)(66446008)(316002)(66946007)(2906002)(6486002)(5660300002)(8676002)(64756008)(66476007)(8936002)(110136005)(66556008)(54906003)(26005)(7416002)(478600001)(71200400001)(4001150100001)(186003)(4326008)(83380400001)(91956017)(76116006)(86362001)(6506007)(36756003)(4744005)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: wNuJrJt9OC6dVmdocjqTEPnqXBnnNKqkZ77Eg2As4ziJ4ppkvorJjgQlBLyR6RYKt/ZYOMintMZYnmMaRvuBbjqt/6wouU/2lloFNBGOaMeBY8hyq55bi0dr9RUQfGd3NO3rvAjubIMxz6HBek2rkK3jBFVTJSeuwcliTDdzbheD7sI9RzLJPryVolwscvyaMJRh4JVpqTHarQXK9dWA7dvkw69bDZcYbCFO8xFW1Sns3+edH+OvmMdV97nC8x1G58WkwqyrAFpaC9tPpuQmkpDfrTyjEEX7lJYvENOmFBU5srM+1ckOBew/vV6qts/trO2ZkKGklKF/bBvaakRX2O1T6CzNAKQmkdPJ88jiw+rpWq2ANOX6aOEDVsPMB0WQzaRoS3AwhekKvEsAvD1gKSK8g/VxOHLAzgm91oR/kVDyzgC3CYvkHi5eodEbmbpX6ttQ+aoK8sYWi7YnWoCldXnBfeukWV+WTmJmHo9iS2P4NmFc8Qeg3NPPLSMsAuXC0N/xB6QBB32ZECzyoamfBL/pskd1JRrBkpeKQrJIaVAPPjb3mkhpmrO+Vzod+WMuyKCB20Ck2B+sY1uSvRYq73j06X/zzrZnExZyH8aCQ0VFrTEKD5oqsYRaUt0/EnfFc76APk8SYK5SUIUpFP6FtA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <3FE35A55D4F87A4DB790CBFAAD2F4EEE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c98922a-1621-4448-ba34-08d875f215ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2020 18:49:47.7733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a1Rvc/4voLFNgcQgA27NeWfoaWwg5SXWmCLkF38OCMOsXDoKXQoFpsIs1Y+xyIRf7V3ixwVwn8whnC2pukUEj2rs2ficMdK8tw1mb8yQmzk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4752
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIwLTEwLTIwIGF0IDA5OjE4ICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IElmIHRoZSBwcm90ZWN0ZWQgbWVtb3J5IGZlYXR1cmUgZW5hYmxlZCwgdW5tYXAgZ3Vl
c3QgbWVtb3J5IGZyb20NCj4ga2VybmVsJ3MgZGlyZWN0IG1hcHBpbmdzLg0KPiANCj4gTWlncmF0
aW9uIGFuZCBLU00gaXMgZGlzYWJsZWQgZm9yIHByb3RlY3RlZCBtZW1vcnkgYXMgaXQgd291bGQN
Cj4gcmVxdWlyZSBhDQo+IHNwZWNpYWwgdHJlYXRtZW50Lg0KPiANClNvIGRvIHdlIGNhcmUgYWJv
dXQgdGhpcyBzY2VuYXJpbyB3aGVyZSBhIG1hbGljaW91cyB1c2Vyc3BhY2UgY2F1c2VzIGENCmtl
cm5lbCBvb3BzPyBJJ20gbm90IHN1cmUgaWYgaXQncyBwcmV2ZW50ZWQgc29tZWhvdy4NCg0KQ1BV
MCAoZXhlcmNpc2luZyBvdGhlciBrZXJuZWwgZnVuY3Rpb25hbGl0eSkJQ1BVMQ0KCQkJCQkJbWFy
ayBwYWdlIHNoYXJlZA0KcGFnZSA9IGdldF91c2VyX3BhZ2VzKCFGT0xMX0tWTSkNCgkJCQkJCW1h
cmsgcGFnZSBwcml2YXRlDQprbWFwKHBhZ2UpDQphY2Nlc3MgdW5tYXBwZWQgcGFnZSBhbmQgb29w
cw0KDQo=
