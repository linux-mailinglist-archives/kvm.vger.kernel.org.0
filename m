Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84D839B50F
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 10:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhFDIpC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 04:45:02 -0400
Received: from mga07.intel.com ([134.134.136.100]:9772 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229958AbhFDIpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 04:45:01 -0400
IronPort-SDR: acgQPSqWxHcm1BJ3gwUvdxf6AWleANv//JfZNbRUtskcr46z9nHigMgmG2qAhBz3La3kwrViUg
 PpjDWvSb5CqQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="268116361"
X-IronPort-AV: E=Sophos;i="5.83,247,1616482800"; 
   d="scan'208";a="268116361"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 01:43:15 -0700
IronPort-SDR: 7M9s7BnKZqkTaAMiR8xVTzHpnRf1Z7uLKwuc0P0su82FlwkqhGrIWWX1MdUTVg4twZVaMwq9S2
 c745mbE7Sq9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,247,1616482800"; 
   d="scan'208";a="475394190"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Jun 2021 01:43:14 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 4 Jun 2021 01:43:14 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 4 Jun 2021 01:43:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 4 Jun 2021 01:43:13 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 4 Jun 2021 01:43:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evbcYqSQothLTuouRrWStfuc36SOUOeLJ0zMxQ2mpAa77ns9sGN31X6I95hCz98rXaHmlVI/JFivi7+aJq9e11SU0Wfln9C6v+hDlnkfF+OJu8R4G36KtEGIDr/y2fHR3o6FNjIIADod5WPwojYzg94zZimNjyYOmhiIzk/PK+RBvT6s+KafBGWP+64iS2I9MzDyL2GScXzCuRETXjaXdbGfFAbfKgYXH0Fuw5+OEtkFQtyOn1Rzx5eqW2k5yKMiiI4B2mHZsSlHGa1TaYOeZ/WGFTtDDojKQJbVpKCzWWe+U7AXUIgdrndIaKuc3y7Dc+7oXtN3lZ76Tk57tySytw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hF5Rrtu29A8gNlPvo9gJ4Gcar9iDVAI9ECtztXx32NU=;
 b=ZCAtHFw8FzJSUm0IJZMe3kMJL26ObQo2i5t0Nomt4G/jbRowy6mFaApT7RAv1rJU4Av35hJv4TvJ+CNW2wJMVhCbMlVeOGI7eU1YA9NgtcaH/M7tBKFmQdWqLCdIDnm8gCEgMeYrsee7pPXhhOfh5A+yp42HIbCW7e+bBRqTkkqLxMBeSbGFsnQjOybMG20Ong3zbEAgOL9g+sVZjfhDu+9Sxf9QNOj8PYxRL/IT0D5B5j5D9WDylT2BYegMG7NMsT2tywRjLp4smur3B08OJib0C2bG8sJRIApjg3UwAeDQXFUI5GdvneM8dUuKtBf8fd25fK3DPpSKX6b7j1XDTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hF5Rrtu29A8gNlPvo9gJ4Gcar9iDVAI9ECtztXx32NU=;
 b=URHEBG95LUyujiLso5CcdwG+qG/pSAAean/3Z43Xh1ClDtHObN/iEMGHB+5TyYTbCL0nPzeW5FQagEOUvH2h7LmEeXjd/bQI+gNao/dIrpa+Nn+NOsootnHB8r6S1BEN0JbZSqZISPERnBTHXmBir1rNUmNxO3qm8ZAPP7bXkBo=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1469.namprd11.prod.outlook.com (2603:10b6:301:c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Fri, 4 Jun
 2021 08:43:10 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4195.023; Fri, 4 Jun 2021
 08:43:10 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwBL2ymAAKTbxpAAJTGVAAAJnz8QAHO4UgAAANRBMA==
Date:   Fri, 4 Jun 2021 08:43:10 +0000
Message-ID: <MWHPR11MB1886480B0E0A26C7110F929B8C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528200311.GP1002214@nvidia.com>
 <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601202834.GR1002214@nvidia.com>
 <MWHPR11MB1886172080807517E92A8EF68C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YLnhmgLVPJR7LJmk@myrica>
In-Reply-To: <YLnhmgLVPJR7LJmk@myrica>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 057dabc2-d4b8-417c-bf72-08d92734c858
x-ms-traffictypediagnostic: MWHPR11MB1469:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1469EDC0265CEC4472FA93078C3B9@MWHPR11MB1469.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yElIY1dW5Lo2dp3zOGd3bj87yh8qNStp4CQu9SO6NLRxSHRxl16DizOGbdZSY6io800a6e1Uc23xg6CIZpnAJWLeFUsLMEu2MoAsdUwixqABQvoufnvFEdWsa1+AhUfWYNi0uvjhvVRtr3HJotURfXmJnwuUcXq6kaSaPzXTxT8SYOa/7nlo1hKOCYyscaSXy7G64M5I2fj3Ig5/JF461cHw74KjgekKMVYqt9Od45dERrel5xNkrs87QznckzSf/dI5TGqn7lnVEA84ECeDYqTZolaXDOy5vGGERouQLCkfTIysqibcKrUp/INE3vAk/bFDJnOBO/I8wwCgk3vzvSemPI23oQaxLOn3//7iZOzEKz3gJKEdLx69v2NKzhdWBmqcCHzhOXJ9et8yqres5m9F4rx1frt3JO4QcK7tZRkRrtZDmgBGP0xaykxV2YfahuC4W3D1QvOrJMVumooAqc3nYsf6szAvKAmMYUVH6Y8nuCi7mvSXby8KPCn8lmoFGdMHlilj7v4bhKBtc1DI+RR3SEi74ikjhLOTCQPftjli0VTBcDrXoVoaY0nkxrgY63fJcIwcpkv8EORRVpn7n/lkGfY6MZbAer0sBZYjTBc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(346002)(376002)(396003)(86362001)(66946007)(6506007)(76116006)(6916009)(66476007)(66446008)(64756008)(66556008)(8676002)(33656002)(316002)(8936002)(2906002)(54906003)(7696005)(7416002)(4326008)(9686003)(55016002)(38100700002)(478600001)(26005)(122000001)(5660300002)(71200400001)(186003)(52536014)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Uk5DYnZOL3R6L3oxVGpJNThXc0F1Vy9ZTUFuVTdyQmJiais4cFRCdlRaRzJ6?=
 =?utf-8?B?MHdKeHBhZXl3R284Q0tJMTEzZWNjUDNnVzNkcGlxQ2dvbElRVTRpOHRlbUl6?=
 =?utf-8?B?NkhVcnRPWlZjVjg0ZWcrZ1ZaSDFUQkx3T1d3R2lIV1p5VktQWFdkWFJkV0FO?=
 =?utf-8?B?U2IzQUpSMFAwQjhMRVVDQjZUOERBNUNQN3pSSi9CR3hIelhOajNWa0pRS2V5?=
 =?utf-8?B?TktoUGJiSnpaVTF4Y0tkM3ZlbzRucmtUMW5xeVBQSW9GTFh1cGppR1o3NlpV?=
 =?utf-8?B?bWZlTStyelpndjA3ckJNZ0lrY1VYM0JOVVkwRXhCSVd1amhGYTFLMjlkR3FT?=
 =?utf-8?B?M29MdE9BaVhlWEJiWjV3RUtvdkd4VTVYdGxWa3lsWFR2WStkRlFoeTdyK3U2?=
 =?utf-8?B?VHFacUphb2VpZmFHQ21LTDh6dU95TlVXNDBLWDNTeWpHcVlNenNSblRaY2di?=
 =?utf-8?B?aWNkcEVjQ2NsSVhDVGN1eklxMXFpQlhnVW9SRkJnTlVOL2pnZW83MXQ2RWZa?=
 =?utf-8?B?UGpDYThTcGFqMzIzbDdTRDhzcG90ZXJ5UTFKT09PbTBHa203QU4rbzZnNUNM?=
 =?utf-8?B?NGRNVWIrekExRnlNL1Exck1ESGxMbjNmeElpTXJZc0VVZis1N1lJRXJNaXht?=
 =?utf-8?B?Rm1XN2MxUTRVYTZTUllxNDFIUDZPU3IyUTdYSVNnT3k4N2dPbnRyRVBybXJ6?=
 =?utf-8?B?eUs5MmdQaDd0NkY5SlU5bjRqeHFZZ01UVXVCUXdUU083OVlidThSdWtPem9j?=
 =?utf-8?B?cmFmNDc0VnlNN0tnTTNwTW9YdmgwSFZJZUtPTytlc1BCL1Q4ZjNyOEFCOHlz?=
 =?utf-8?B?V3BGRXc1dGttZFdTd0RaVVMwOXZhaVloRmFLaGw1RzZDRjRFbmxTZUNMRzBL?=
 =?utf-8?B?cGp2N1BXWnRObGV2OHdpNnBlcEp0Vm9mTkdJRWFYVTA1OXQ4Qjc0UzFtOEtK?=
 =?utf-8?B?K21TT1BCQXhhM1pNZjY0K1pkUFJ5K0ZVMGpQMDJVbDlPamhLdUtEaytuY2lm?=
 =?utf-8?B?RXAzVTA4NXN0LzRTMHpPWWZmUUZiVW14WFZDT0x4TmpPR29wTXVjb2gya0xo?=
 =?utf-8?B?M1p0SlorZ0NvaUxoTVF4elpqNlo3bGsrOW1MV1BsSVdsVnhpa0QrRk8yWnpP?=
 =?utf-8?B?SWF2R1NNZXJXT0cyUmdlYnQ3RE5iZHhySWwzQzFacmdyU0c3YlhXejdiaTVi?=
 =?utf-8?B?NTVONmQ4WTVWak1LU2ljeDFiMVh1ekoydit3WXNCTjRBSVFvTm9VMmx0Yktx?=
 =?utf-8?B?VUNsY3pQSHNXMHFDbXlZMEEray80Ny9pUVNldmo5cWhoRHRraStiTTFFZ0RG?=
 =?utf-8?B?d3VLK0lLazZQU0t0WStNWWxCSC9FK0s4OEI3bUNZL1ZZRDQvUklWMHpKRmJQ?=
 =?utf-8?B?RjZoSjIvVzlkNzNXR3RBejNFRGV6UUNWeHZYaXl5d3lHN0lRNVBOTUZUdEtP?=
 =?utf-8?B?dm5hdVU0T3RQWDJSYkkzZDdmSVJwNEQxSzNYWnJGZHNSU0t4aEJzOVZrbTVO?=
 =?utf-8?B?cGl3VC8veVRpSS8rd2F1WUsxKzlodCtnOVVlTmdmU1lnanJNc3BLZUNTbTZN?=
 =?utf-8?B?b3pQakJDaHEzaDJIcEFRdUl6NjlGY3UxeDFtTy9NMDBoRnJGTm5EaUF1aHZr?=
 =?utf-8?B?U3RHNjZFclpWNnZhU2pXMmorQWRmTE84OWtuUXZwZEpXR1BuQjlaS2t6eTQv?=
 =?utf-8?B?SUpDMThrWUhaTGg2bnUvT0RpQkxlRUxyVVJSbGxlT1BidnRCYVJUajBQaHJq?=
 =?utf-8?Q?EN6Xonoe10EGGZ+C5KyIYki0UDMAwELEL/OrtAd?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 057dabc2-d4b8-417c-bf72-08d92734c858
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 08:43:10.1308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J/+i9FN4TqpWm5mlCX29qlbetMplSX5UB3iHVwZ5Ucw3Kiv+6bpnEBSGf/TmZaNRnc1z2kcbWMHatzUDAd9sZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1469
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBKZWFuLVBoaWxpcHBlIEJydWNrZXIgPGplYW4tcGhpbGlwcGVAbGluYXJvLm9yZz4N
Cj4gU2VudDogRnJpZGF5LCBKdW5lIDQsIDIwMjEgNDoxOCBQTQ0KPiANCj4gT24gV2VkLCBKdW4g
MDIsIDIwMjEgYXQgMDE6MjU6MDBBTSArMDAwMCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4gPiA+
IFRoaXMgaW1wbGllcyB0aGF0IFZGSU9fQk9VTkRfSU9BU0lEIHdpbGwgYmUgZXh0ZW5kZWQgdG8g
YWxsb3cgdXNlcg0KPiA+ID4gPiBzcGVjaWZ5IGEgZGV2aWNlIGxhYmVsLiBUaGlzIGxhYmVsIHdp
bGwgYmUgcmVjb3JkZWQgaW4gL2Rldi9pb21tdSB0bw0KPiA+ID4gPiBzZXJ2ZSBwZXItZGV2aWNl
IGludmFsaWRhdGlvbiByZXF1ZXN0IGZyb20gYW5kIHJlcG9ydCBwZXItZGV2aWNlDQo+ID4gPiA+
IGZhdWx0IGRhdGEgdG8gdGhlIHVzZXIuDQo+ID4gPg0KPiA+ID4gSSB3b25kZXIgd2hpY2ggb2Yg
dGhlIHVzZXIgcHJvdmlkaW5nIGEgNjQgYml0IGNvb2tpZSBvciB0aGUga2VybmVsDQo+ID4gPiBy
ZXR1cm5pbmcgYSBzbWFsbCBJREEgaXMgdGhlIGJlc3QgY2hvaWNlIGhlcmU/IEJvdGggaGF2ZSBt
ZXJpdHMNCj4gPiA+IGRlcGVuZGluZyBvbiB3aGF0IHFlbXUgbmVlZHMuLg0KPiA+DQo+ID4gWWVz
LCBlaXRoZXIgd2F5IGNhbiB3b3JrLiBJIGRvbid0IGhhdmUgYSBzdHJvbmcgcHJlZmVyZW5jZS4g
SmVhbj8NCj4gDQo+IEkgZG9uJ3Qgc2VlIGFuIGlzc3VlIHdpdGggZWl0aGVyIHNvbHV0aW9uLCBt
YXliZSBpdCB3aWxsIHNob3cgdXAgd2hpbGUNCj4gcHJvdG90eXBpbmcuIEZpcnN0IG9uZSB1c2Vz
IElEcyB0aGF0IGRvIG1lYW4gc29tZXRoaW5nIGZvciBzb21lb25lLCBhbmQNCj4gdXNlcnNwYWNl
IG1heSBpbmplY3QgZmF1bHRzIHNsaWdodGx5IGZhc3RlciBzaW5jZSBpdCBkb2Vzbid0IG5lZWQg
YW4NCj4gSUQtPnZSSUQgbG9va3VwLCBzbyB0aGF0J3MgbXkgcHJlZmVyZW5jZS4NCg0Kb2ssIHdp
bGwgZ28gZm9yIHRoZSBmaXJzdCBvcHRpb24gaW4gdjIuDQoNCj4gDQo+ID4gPiA+IEluIGFkZGl0
aW9uLCB2UEFTSUQgKGlmIHByb3ZpZGVkIGJ5IHVzZXIpIHdpbGwNCj4gPiA+ID4gYmUgYWxzbyBy
ZWNvcmRlZCBpbiAvZGV2L2lvbW11IHNvIHZQQVNJRDwtPnBQQVNJRCBjb252ZXJzaW9uDQo+ID4g
PiA+IGlzIGNvbmR1Y3RlZCBwcm9wZXJseS4gZS5nLiBpbnZhbGlkYXRpb24gcmVxdWVzdCBmcm9t
IHVzZXIgY2Fycmllcw0KPiA+ID4gPiBhIHZQQVNJRCB3aGljaCBtdXN0IGJlIGNvbnZlcnRlZCBp
bnRvIHBQQVNJRCBiZWZvcmUgY2FsbGluZyBpb21tdQ0KPiA+ID4gPiBkcml2ZXIuIFZpY2UgdmVy
c2EgZm9yIHJhdyBmYXVsdCBkYXRhIHdoaWNoIGNhcnJpZXMgcFBBU0lEIHdoaWxlIHRoZQ0KPiA+
ID4gPiB1c2VyIGV4cGVjdHMgYSB2UEFTSUQuDQo+ID4gPg0KPiA+ID4gSSBkb24ndCB0aGluayB0
aGUgUEFTSUQgc2hvdWxkIGJlIHJldHVybmVkIGF0IGFsbC4gSXQgc2hvdWxkIHJldHVybg0KPiA+
ID4gdGhlIElPQVNJRCBudW1iZXIgaW4gdGhlIEZEIGFuZC9vciBhIHU2NCBjb29raWUgYXNzb2Np
YXRlZCB3aXRoIHRoYXQNCj4gPiA+IElPQVNJRC4gVXNlcnNwYWNlIHNob3VsZCBmaWd1cmUgb3V0
IHdoYXQgdGhlIElPQVNJRCAmIGRldmljZQ0KPiA+ID4gY29tYmluYXRpb24gbWVhbnMuDQo+ID4N
Cj4gPiBUaGlzIGlzIHRydWUgZm9yIEludGVsLiBCdXQgd2hhdCBhYm91dCBBUk0gd2hpY2ggaGFz
IG9ubHkgb25lIElPQVNJRA0KPiA+IChwYXNpZCB0YWJsZSkgcGVyIGRldmljZSB0byByZXByZXNl
bnQgYWxsIGd1ZXN0IEkvTyBwYWdlIHRhYmxlcz8NCj4gDQo+IEluIHRoYXQgY2FzZSB2UEFTSUQg
PSBwUEFTSUQgdGhvdWdoLiBUaGUgdlBBU0lEIGFsbG9jYXRlZCBieSB0aGUgZ3Vlc3QgaXMNCj4g
dGhlIHNhbWUgZnJvbSB0aGUgdklPTU1VIGludmFsIHRvIHRoZSBwSU9NTVUgaW52YWwuIEkgZG9u
J3QgdGhpbmsgaG9zdA0KPiBrZXJuZWwgb3IgdXNlcnNwYWNlIG5lZWQgdG8gYWx0ZXIgaXQuDQo+
IA0KDQp5ZXMuIFNvIHJlc3BvbmRpbmcgdG8gSmFzb24ncyBlYXJsaWVyIGNvbW1lbnQgd2UgZG8g
bmVlZCByZXR1cm4NClBBU0lEIChhbHRob3VnaCBubyBjb252ZXJzaW9uIGlzIHJlcXVpcmVkKSB0
byB1c2Vyc3BhY2UgaW4gdGhpcw0KY2FzZS4g8J+Yig0KDQpUaGFua3MNCktldmluDQo=
