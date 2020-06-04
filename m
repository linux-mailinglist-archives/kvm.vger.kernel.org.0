Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3681EEE3C
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 01:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgFDX3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 19:29:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:26049 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgFDX3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 19:29:52 -0400
IronPort-SDR: 0HL+cOFQUVS/bypYYVmcvxdP20NuEVuDZCnnl7pGfNZn0Tw7lNNmpLDXxzttflNDD+EID3HlwA
 I0fLfif3AzQw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 16:29:50 -0700
IronPort-SDR: fNjHWnVMpZrrH/1r1eWBawu9RKYDM5uFQhpgyPAmniQnoQsqiY0dwNeOCCV1Zj7Kurl2tl/HrY
 unLsEFelIdmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,474,1583222400"; 
   d="scan'208";a="471712099"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga005.fm.intel.com with ESMTP; 04 Jun 2020 16:29:50 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 4 Jun 2020 16:29:50 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 4 Jun 2020 16:29:49 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 4 Jun 2020 16:29:49 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.55) by
 edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 4 Jun 2020 16:29:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBhm0SWB/uyTIpjbrVDEEftsDGSgipXcoDXe41V3PuiumxK30G3j7DbZApcQjoISNItRsMNyNYX8tFJA2BVqls4AndB7RhB0XgycJcUqNZueoSYA7K4IKmpx2JbvRzZJY6CZhlpavTKiEpZWjr3ZTjT7H9CD7sVmTlcHxPvz96/eKzXdXTQ1ko5WggcBybWtOUgI8iyBXcKLIEU+UkUSXk6medJbhlTG3M/9kPZVNWCpfbyiUmv+95xVyHIG2debu0UJ8+Ca7fFw8GQo6y9dyB+Hqhdfzv5DYOG3KDF8WuqzIuC1/narBUXHosnT51IuivBE1X+GK3A4CvuoZth48w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zt0PxtOfHjbqfDW+Nd82d+1UPIiphCK8WNtWUQGXKDk=;
 b=WyJbmOn+QAXcTH07vPZ9v65wVTzNtYcWzMoKD9/gO6TpLC8HUCdAaMBRQER1IR3BPKa1P6vGEocsw1AVaOZkReWfBERNVwJueWoTTrM/AjSgkvI+hhZ/nqF7WH0WAssC0uVQAN9sNM9RWNcCSs2NqSRZzyOS1X4sY5GodHknwiuvoVdhdMEmS/HJieyGvppXSlc6tnUU88dcx9wcEbVjI64d8rwpIVJjJ4bMZQwnZcxgnQJR9sV2L76sYmVWVglRmI2upXaOQwJrHo7GpQBsEYsc31sVYCn862vw6Bn8jH+83bxyPq29vjl3XUXGZ4Z3yjcw7MXDTYJDhxaET4zMAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zt0PxtOfHjbqfDW+Nd82d+1UPIiphCK8WNtWUQGXKDk=;
 b=PVwYECqDKkgq6qk9GjnWEOyuSMKHjc5VnDNCNVP2e4jH1JTyLzCgNuy6IlOYJXLNdJZ2BH7MNeUAXiutS9vVhgi8Jt44C0hbFKjC1FGKKpMGTFir8Te5CE2/Y5BN1QGZ+Xd79c6T2hRXi7K95gIFtAew4GG7EKZMZw5wx0qYbeY=
Received: from BY5PR11MB3863.namprd11.prod.outlook.com (2603:10b6:a03:18a::28)
 by BY5PR11MB3861.namprd11.prod.outlook.com (2603:10b6:a03:18d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Thu, 4 Jun
 2020 23:29:46 +0000
Received: from BY5PR11MB3863.namprd11.prod.outlook.com
 ([fe80::ec4e:a2a2:f273:9074]) by BY5PR11MB3863.namprd11.prod.outlook.com
 ([fe80::ec4e:a2a2:f273:9074%6]) with mapi id 15.20.3066.018; Thu, 4 Jun 2020
 23:29:46 +0000
From:   "Nakajima, Jun" <jun.nakajima@intel.com>
To:     Jim Mattson <jmattson@google.com>
CC:     Will Deacon <will@kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "David Rientjes" <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kees Cook" <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: Re: [RFC 00/16] KVM protected memory extension
Thread-Topic: [RFC 00/16] KVM protected memory extension
Thread-Index: AQHWOoe1lM84g0zHPkupUbQ0L9bpcKjIp0WAgAAq94CAAB/RAIAAKPKA
Date:   Thu, 4 Jun 2020 23:29:45 +0000
Message-ID: <65785F35-60D6-4CAE-B307-C81BCA5A2AE4@intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200604161523.39962919@why> <20200604154835.GE30223@linux.intel.com>
 <20200604163532.GE3650@willie-the-truck>
 <6DBAB6A4-A1F9-40E9-B81B-74182DDCF939@intel.com>
 <CALMp9eRN-zkvmkYQ0a600SyLA_0ymznBG8jmriTsYMcXkK77Qg@mail.gmail.com>
In-Reply-To: <CALMp9eRN-zkvmkYQ0a600SyLA_0ymznBG8jmriTsYMcXkK77Qg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.223.163.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4ff87ca-b8a0-4129-08f9-08d808df2ac5
x-ms-traffictypediagnostic: BY5PR11MB3861:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB38618CC742966A25E8A0693A9A890@BY5PR11MB3861.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 04244E0DC5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WcuOnSfrknHqWRytSZ+Zlw7mVRDbVFE6U2tmqJV4gpbahVsTU3JDcnacPY2GYQGqbLnG6ORQLMpjPzQ4BS7BFB8fBQ3wTFN0X//vl9IgTM4mrCYOr5owRxo7ReOwzqvU756V4RIIK5oiY2+J6rxdvoL6h5XwBrI1yfyhTtoLP4QQj4iczP6pF/MJEjm3s1+BYJtnu4PuQETSz6awCPwsXJIbaW/Zmw9R9xYL/i++X0jmAy5/X8HZcC0fr8XsXagVH8SdzX0vxJKOJ1K7ECrm3x5vdqApKn8at+h5vaRI4g/4lMef3lDbOWQHUMu+vbSIrXgYZt3QvNF4hjB5k4m7fA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3863.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(366004)(39860400002)(346002)(136003)(6916009)(36756003)(8676002)(71200400001)(7416002)(478600001)(83380400001)(33656002)(5660300002)(76116006)(66476007)(316002)(66446008)(66556008)(64756008)(6486002)(2906002)(66946007)(8936002)(186003)(54906003)(6512007)(26005)(2616005)(6506007)(86362001)(53546011)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: kPJaluwlXZV0TSI6QQgOa1GSZzThx3IexC07JKfmZVcMmzNNUqyNT6uN5REtFYalKMGHmabyBUoSETnOjDXWVIXLHQIbhOfTlAaafZjf03LiVJJflS7/wVltODc115mItzyqV9ARortP2rGm70zaiFJpBjRbtyfOD9dWn95BuRCaO7YgqYSQ9M5pO37bS0F2Spxz9twRugAf7buGN78nfixUAd/SxkzCmT4l6aUYPOJZKgMdrIIxvrzVAdBG86AuE6MuCzzGztt0TM3+JDx813EZzbeikwvOyl5uQvPYKL3ljwhv1fVryjF9GpgsFo13/Gkcp0tMv6/GQ8LpjDA19eX/j2E+IcuAHjW3nKj8XiuI1YRRDwajwR8WBsST4WjgC/rRSwREsiHffBSiYVTiW9ngqWgSi280L5sGu6tnf+Nq0jF/DNM3HS+arW04RHCTEvSMa5MMk9IK3XyyfesW+bgLIPiuFpgODwGOSvF0pIctIuZK0QljMXFgXzbGmRtQ
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE02F21E38451E4F84266636B1678293@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d4ff87ca-b8a0-4129-08f9-08d808df2ac5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2020 23:29:45.9341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AVaHOG5LNHPSDdxbdIDG1p9h8/FU2NfURmvog5QuPlLiAWS3ItaOiAP+nrTz+F1J8sB72IRLkfSLpdzW01qAVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3861
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiANCj4gT24gSnVuIDQsIDIwMjAsIGF0IDI6MDMgUE0sIEppbSBNYXR0c29uIDxqbWF0dHNvbkBn
b29nbGUuY29tPiB3cm90ZToNCj4gDQo+IE9uIFRodSwgSnVuIDQsIDIwMjAgYXQgMTI6MDkgUE0g
TmFrYWppbWEsIEp1biA8anVuLm5ha2FqaW1hQGludGVsLmNvbT4gd3JvdGU6DQo+IA0KPj4gV2Ug
KEludGVsIHZpcnR1YWxpemF0aW9uIHRlYW0pIGFyZSBhbHNvIHdvcmtpbmcgb24gYSBzaW1pbGFy
IHRoaW5nLCBwcm90b3R5cGluZyB0byBtZWV0IHN1Y2ggcmVxdWlyZW1lbnRzLCBpLi5lICJzb21l
IGxldmVsIG9mIGNvbmZpZGVudGlhbGl0eSB0byBndWVzdHPigJ0uIExpbnV4L0tWTSBpcyB0aGUg
aG9zdCwgYW5kIHRoZSBLaXJpbGzigJlzIHBhdGNoZXMgYXJlIGhlbHBmdWwgd2hlbiByZW1vdmlu
ZyB0aGUgbWFwcGluZ3MgZnJvbSB0aGUgaG9zdCB0byBhY2hpZXZlIG1lbW9yeSBpc29sYXRpb24g
b2YgYSBndWVzdC4gQnV0LCBpdOKAmXMgbm90IGVhc3kgdG8gcHJvdmUgdGhlcmUgYXJlIG5vIG90
aGVyIG1hcHBpbmdzLg0KPj4gDQo+PiBUbyByYWlzZSB0aGUgbGV2ZWwgb2Ygc2VjdXJpdHksIG91
ciBpZGVhIGlzIHRvIGRlLXByaXZpbGVnZSB0aGUgaG9zdCBrZXJuZWwganVzdCB0byBlbmZvcmNl
IG1lbW9yeSBpc29sYXRpb24gdXNpbmcgRVBUIChFeHRlbmRlZCBQYWdlIFRhYmxlKSB0aGF0IHZp
cnR1YWxpemVzIGd1ZXN0ICh0aGUgaG9zdCBrZXJuZWwgaW4gdGhpcyBjYXNlKSBwaHlzaWNhbCBt
ZW1vcnk7IGFsbW9zdCBldmVyeXRoaW5nIGlzIHBhc3N0aHJvdWdoLiBBbmQgdGhlIEVQVCBmb3Ig
dGhlIGhvc3Qga2VybmVsIGV4Y2x1ZGVzIHRoZSBtZW1vcnkgZm9yIHRoZSBndWVzdChzKSB0aGF0
IGhhcyBjb25maWRlbnRpYWwgaW5mby4gU28sIHRoZSBob3N0IGtlcm5lbCBzaG91bGRu4oCZdCBj
YXVzZSBWTSBleGl0cyBhcyBsb25nIGFzIGl04oCZcyBiZWhhdmluZyB3ZWxsIChDUFVJRCBzdGls
bCBjYXVzZXMgYSBWTSBleGl0LCB0aG91Z2gpLg0KPiANCj4gWW91J3JlIEludGVsLiBDYW4ndCB5
b3UganVzdCBjaGFuZ2UgdGhlIENQVUlEIGludGVyY2VwdCBmcm9tIHJlcXVpcmVkDQo+IHRvIG9w
dGlvbmFsPyBJdCBzZWVtcyBsaWtlIHRoaXMgc2hvdWxkIGJlIGluIHRoZSByZWFsbSBvZiBhIHNt
YWxsDQo+IG1pY3JvY29kZSBwYXRjaC4NCg0KV2XigJlsbCB0YWtlIGEgbG9vay4gUHJvYmFibHkg
aXQgd291bGQgYmUgaGVscGZ1bCBldmVuIGZvciB0aGUgYmFyZS1tZXRhbCBrZXJuZWwgKGUuZy4g
ZGVidWdnaW5nKS4gDQpUaGFua3MgZm9yIHRoZSBzdWdnZXN0aW9uLg0KDQotLS0gDQpKdW4NCklu
dGVsIE9wZW4gU291cmNlIFRlY2hub2xvZ3kgQ2VudGVyDQoNCg0K
