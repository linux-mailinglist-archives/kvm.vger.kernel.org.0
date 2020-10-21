Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EEB295268
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 20:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436568AbgJUSri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 14:47:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:23306 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394470AbgJUSrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 14:47:37 -0400
IronPort-SDR: 13VezyliEbB97Az+5AOlTntXxGY9klsOR1kGAnDfuanR6Ek1P988zNFe2RjFtRnyIk33lF+wKL
 iALvP+JXQ7TA==
X-IronPort-AV: E=McAfee;i="6000,8403,9781"; a="166640480"
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400"; 
   d="scan'208";a="166640480"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 11:47:36 -0700
IronPort-SDR: Pax6eoyiM+hI3mMMr0ObeICqgGAyK+rC71dMCZaRWmMPhdnIiyxm9X7im6A8B6GFoMXQIZlTPy
 UNkPqHrJpsXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,401,1596524400"; 
   d="scan'208";a="348427036"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga004.fm.intel.com with ESMTP; 21 Oct 2020 11:47:35 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 21 Oct 2020 11:47:35 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 21 Oct 2020 11:47:35 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 21 Oct 2020 11:47:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ocsJf5oqikQiu7izEsw2F2CQ5HIkD0iyNuFi1IVDq2KK54RO+Utezd5TnbP5ayZTahkNBj/kXhyUgri60BCVukWvsYg/1zu4YACWsbtDe6+W3Da6qybrj+vd9PzSRgOIBaNPgJvI7GM5rJqMkBQc3zwQQBN0cyX3prwl7xXhhS4J0U4w33JNOlt1RySEB/IO8Q3xCQGvmJTR65jEwx3wcsqyE0pGiPeoEbNtbWwOHwjbRYGfYiPpJWrRpJDOMKemC2kI6FKXrTBbKbzi4H/B1s3epKf5afbdqRV2C7UeCKlTIp6YY0BJ5vm6YB5T4rVFZGwiFHML+x3Zr5zxg6u1CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I2lYEVNiLemonzLFG2AweHmzeezx+MSdiTkJfHtTuTs=;
 b=m28ahuSmrBWT9JBIv2k3MrxLq/Dt7ULzsDqTso3uiviD6UBWZ6nhNzLZLL9+2auXygxs3Q1V0gsTuzpgqIeglsn+fO7v/6EBDSuLG9CCOVF1ZbMZx1bfgyQF8SiNGE18XP1S/jjN31EjcCuvaNnp98f37nw32BC+9o9SDpWRXu0A+WwPZwX8BZ+WbJtXKhFm2ryPZaNfMFWzX+mwwyw1kqbO0IB9OjTU+QED/BfYkWHmiq1U2kNAkKikFNIw0oURo81my4U9Kj06zYFbksFnTSnZ6foOBH2iA3ZpRYs09eDHQb+xSH0wQg+pjnj6XOHiOE+Az656eC5MVai8LlAJYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I2lYEVNiLemonzLFG2AweHmzeezx+MSdiTkJfHtTuTs=;
 b=di/FC93GqSggGeNsGFq2stbF/Pho/QWLcY6L+MHrQJqPm3eFMClCnFYY0ulp9Av4CdeMggWk/uPDljLgXve0CEs4EP0Dw+Dv4N8WwqgQTBRgFXW2VTHYWgCmWtdCBbC2hwIm/PL0cS8u5t33d0gqLh1OX/FFIxvfmQct3SrmQEo=
Received: from SN6PR11MB3184.namprd11.prod.outlook.com (2603:10b6:805:bd::17)
 by SN6PR11MB3071.namprd11.prod.outlook.com (2603:10b6:805:d6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Wed, 21 Oct
 2020 18:47:33 +0000
Received: from SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::b901:8e07:4340:6704]) by SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::b901:8e07:4340:6704%7]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 18:47:33 +0000
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
Subject: Re: [RFCv2 09/16] KVM: mm: Introduce VM_KVM_PROTECTED
Thread-Topic: [RFCv2 09/16] KVM: mm: Introduce VM_KVM_PROTECTED
Thread-Index: AQHWpqj/oWfxXDKzL0S/24+XdXoPxqmiZ/GA
Date:   Wed, 21 Oct 2020 18:47:32 +0000
Message-ID: <b13e29ea41e1961ea5cfea9e941320842c2d1695.camel@intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
         <20201020061859.18385-10-kirill.shutemov@linux.intel.com>
In-Reply-To: <20201020061859.18385-10-kirill.shutemov@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.137.79]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c768d322-cb1f-46aa-f5e1-08d875f1c54a
x-ms-traffictypediagnostic: SN6PR11MB3071:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB307166CBF3B5F1BC8FA49568C91C0@SN6PR11MB3071.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MZ3iPCH9NQMauqCUFP/SacZ6Lkk3XN3Xc/epBHlpXQpHRGt+ymLxoeK3uXBcg4NcBeBcW19tvFTIjU/e8p/pQlZtRVkdMy7ZvFVThk8tSlVfcmc+fFDOYdEzmMTGryUxNvKlEdfJxOSYsZJs5PlgUfOrOYvHfPBGS67pUBlohGlbb/NdfvHsTzRGGCMUykmNd5hVM1BZ7XHQHb2LUhy5tSTXyxxsUxxOLSZGiamcLZ6filoky9o54Ml6bsrEl7ixz30B5JohrfSRQdcOWcC9s/OVIvxFYkGE2kP3hAfBRhrIAxGjQqMU76zNCH3D5/7i1KlTndmyAdMtknZcpJVdPV3I2s4I0DRQC42AXlauILRkGV6Zm0igqLFSYwh+sKve
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(7416002)(4744005)(36756003)(83380400001)(6486002)(478600001)(186003)(71200400001)(26005)(8936002)(64756008)(6506007)(91956017)(86362001)(4326008)(2616005)(4001150100001)(66446008)(8676002)(5660300002)(66946007)(316002)(76116006)(54906003)(2906002)(6512007)(110136005)(66556008)(66476007)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: LDLTAAu0oG2x/OTOfxJoCxCR5pAmOinrXATYoQSFXNS21Zu1B4je57ZfZWq6PyMaimGgUhBhU06Ee9NStWHNyA2mdgeE+uOiPuqe/oMjiseVSc3LHUNZCADfgedJuqsH1zWkq7q4NnfM5pPg9pome8TzAJJMkdYctdt7PjVlOZRVvCizMHSZdkTVRoULC298S2Q6QyWEiHaETwXnLKzSV5DqwWmPDLjr9HTIWPgSdZgjcMK3c/WnJV37Kf00fG5oBt0P2VSNnGQxtIaQCqC1Ly7CrPQckARsJpX9tWJBMpLMlWe0bh5TZgHT8/INfPPb/csPxQQFD8pcpWoiXkgGZnoBLt12cd7S8sXANYetMNDPKyhbT5xjQpRaR4ZEoLRz6vGLjyhF4J+KOvKubJOe31ZO019PmWMX65EDhngaY8a4OHAsSz1UG8UrRP+OJFEohoPZ5HWcee4vdUQbHChIuF3CoBQegc5XP+6JBKc8d1AuOK+NWtANlyAMcvNVsaGq46+koO7Iae5F/18OOs6WxCHSwMupzLN0CqBUD36GQbU9Y3I8IUeG34V3c52pE0bcl8RDBDN5Wbl0jDLKqCC+gEzyHRGnaKs39hJ9Y2FgnDkNQY0Z02AoC8uHlpybAbAPWXzyXffox+H94IvJS4cGKg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <46610591579114479C9751EB37E4DE83@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c768d322-cb1f-46aa-f5e1-08d875f1c54a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2020 18:47:32.9568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rjk1qp/Flfb+AKc+dPJHRGYcn9VzaCfY+MTut+RFqp/dxRGgycSFh4w/EWAvYdUKFWeiV+nZScNNjWUBJJmoHv2Txj8JrJ6/Ad10ai3UVAM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3071
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIwLTEwLTIwIGF0IDA5OjE4ICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+ICBpbmNsdWRlL2xpbnV4L21tLmggIHwgIDggKysrKysrKysNCj4gIG1tL2d1cC5jICAg
ICAgICAgICAgfCAyMCArKysrKysrKysrKysrKysrLS0tLQ0KPiAgbW0vaHVnZV9tZW1vcnkuYyAg
ICB8IDIwICsrKysrKysrKysrKysrKystLS0tDQo+ICBtbS9tZW1vcnkuYyAgICAgICAgIHwgIDMg
KysrDQo+ICBtbS9tbWFwLmMgICAgICAgICAgIHwgIDMgKysrDQo+ICB2aXJ0L2t2bS9hc3luY19w
Zi5jIHwgIDIgKy0NCj4gIHZpcnQva3ZtL2t2bV9tYWluLmMgfCAgOSArKysrKy0tLS0NCj4gIDcg
ZmlsZXMgY2hhbmdlZCwgNTIgaW5zZXJ0aW9ucygrKSwgMTMgZGVsZXRpb25zKC0pDQoNClRoZXJl
IGlzIGFub3RoZXIgZ2V0X3VzZXJfcGFnZXMoKSBpbg0KcGFnaW5nX3RtcGwuaDpGTkFNRShjbXB4
Y2hnX2dwdGUpLiANCg0KQWxzbywgZGlkIHlvdSBsZWF2ZSBvZmYgRk9MTF9LVk0gaW4gZ2ZuX3Rv
X3BhZ2VfbWFueV9hdG9taWMoKSBvbg0KcHVycG9zZT8gSXQgbG9va3MgbGlrZSBpdHMgb25seSB1
c2VkIGZvciBwdGUgcHJlZmV0Y2ggd2hpY2ggSSBndWVzcyBpcw0Kbm90IHJlcXVpcmVkLg0K
