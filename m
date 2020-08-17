Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C758245BFC
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 07:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgHQFjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 01:39:10 -0400
Received: from mga17.intel.com ([192.55.52.151]:55408 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbgHQFjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 01:39:05 -0400
IronPort-SDR: qRhJp9GSJbdQo7p/c4IUktdbu8H3fkpC1APEY1r5GE0mB7gcVkImZ+UkFyp7d/uHHinxDL7pwT
 9rgAmhhBsmQw==
X-IronPort-AV: E=McAfee;i="6000,8403,9715"; a="134699687"
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="134699687"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2020 22:39:01 -0700
IronPort-SDR: qfiRvER/F4bb+I39rGvahTcS34Nq2Xuw/RnhGYLeZ2sFsHEc3isS3EZLt5DVq6sU0vy/kMurR7
 /C+aJe6qWDZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,322,1592895600"; 
   d="scan'208";a="370463670"
Received: from unknown (HELO fmsmsx606.amr.corp.intel.com) ([10.18.84.216])
  by orsmga001.jf.intel.com with ESMTP; 16 Aug 2020 22:39:00 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 16 Aug 2020 22:39:00 -0700
Received: from fmsmsx125.amr.corp.intel.com (10.18.125.40) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 16 Aug 2020 22:39:00 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 FMSMSX125.amr.corp.intel.com (10.18.125.40) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sun, 16 Aug 2020 22:39:00 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Sun, 16 Aug 2020 22:39:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TOMKDnq13uFekBQkH/ULQnRBoZ2cd785JPOU5M0BX2vzwLTavWVszeemyq7QGE/s39ccfsm+v9oD8nzhX46Yz4GuTPTkNxKmUpwUwpIOY8yOlv70ZpRSn3KuLnVGiw7mge6/O6pdf4TzA1N+ceplkBaekFA3CK25RglTQiNjUBKvXA9464JCVpEgwhKnEs1NGOj020v7WmRfE+PASX4ZBYIM6N9OJ1y7nRVN/qGtghEACEwJuhtKEY+PHx/Rmx9KuWdwgYdtdReAqfnm3lU4/P9a0oJnTFpPjB4/LwlgTbnTbn6cn87uW8XDPRQMQOuLbNemxP1xZYaYh1Gvl2l5Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJWFwhIB3w8jbWQHWlBqOjklBwORKfLlf0TsLp22n30=;
 b=J5Zqk0xxALsRAYnioRkGSGIfHDFpEEXMfA6haCzh9xGYjtsr51+S94I+w/xgUw9Y6MjKkPMkOIxSs79b//BP1r/0jasbZ3+3diE2lmD3YgTXbvke7o2FQmVClJ8BdI8RSK72meklzD9VDqwcB7KjpBw0zDltbR/KPvc7dttjmzUWfhfbOVu6Cy5tbFqxSnw+gWm8FJnaAFHhMO/cDF2Syxe/rNrodda1T1aO+yZgu7TQ1KU/x6RtKkwYfIMUfS6hF90HL+YIQ3MOkf5YjGIiWKidKSgpmFglytuy/SvYik5985ji0rxdHd4Yr2itWWtuHM2s42fT2+GhEqqOuiQQuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJWFwhIB3w8jbWQHWlBqOjklBwORKfLlf0TsLp22n30=;
 b=ZXtRVW1lMvT/5MV2Xc0HaME32fyAkAn56XK5Gtd9bTyYE7zym3BD6d7GjtB0z6ZvEXg4j3PnSIV5aaQur33/4darMNwRWbdhG0uCXnDpBxs8t8jQzRMeBGQFdTmqZOlD92inMNhPxkXP/cXxpI2MaNsyfQqv5SKHSPl0Lb40azc=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB1996.namprd11.prod.outlook.com (2603:10b6:3:13::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3283.16; Mon, 17 Aug 2020 05:38:58 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3283.027; Mon, 17 Aug
 2020 05:38:58 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Auger Eric <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 09/15] iommu/vt-d: Check ownership for PASIDs from
 user-space
Thread-Topic: [PATCH v6 09/15] iommu/vt-d: Check ownership for PASIDs from
 user-space
Thread-Index: AQHWZKdJno5Pta00J0+9WfqaijTt46k5eXWAgAJtvmA=
Date:   Mon, 17 Aug 2020 05:38:58 +0000
Message-ID: <DM5PR11MB14350F2817594E7895AD8A80C35F0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
 <1595917664-33276-10-git-send-email-yi.l.liu@intel.com>
 <0db97d4a-7c74-9fac-0763-0ed56dcc5eaa@redhat.com>
In-Reply-To: <0db97d4a-7c74-9fac-0763-0ed56dcc5eaa@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [117.169.230.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b47ea57e-4287-4030-0b39-08d8426fd6bf
x-ms-traffictypediagnostic: DM5PR11MB1996:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1996372362A76840D6A460A7C35F0@DM5PR11MB1996.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BDuhQNSQJkG5oiX4ChaR1OJNuslcrNhQc4Qig9t6TwJdv/1ZVEBpMBMPFiham3w5nCoaxJPSr7SSRgXu+fOC2psQxr826aWCaNDIxn7dHadzYcwz0PNWEgVjGa+UYNC/ctROp0GIJGuatCf0l+zdWcC7/j79QlpxSAGgZA9V2r9c/eW4DErSKzI43AHClwGObKPhGmwsVGwxUDuPbv6RFlI50cyrlb+KwN+PIpUa5Fwvn3tluo601KM//iwQ3mIwvpk+YuJ724vgETGcBEYKxaKjI3XitTJ4wNMXOLFtliH1k26WRwshAPCQi/gOqFG7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(376002)(39860400002)(136003)(26005)(66446008)(64756008)(71200400001)(66556008)(66476007)(7416002)(8676002)(9686003)(2906002)(66946007)(55016002)(76116006)(86362001)(5660300002)(186003)(8936002)(316002)(33656002)(478600001)(6506007)(52536014)(7696005)(53546011)(83380400001)(54906003)(110136005)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: PevVbgu3khApubuGMqtPlRWzO0CiUXlCGh3HBeJDsoyx1iAQL5Z0dklLmnTtKlXq/0Ze78S2lrGHx12vxEpBVNzcE1VMpUR45TcRw2WAxLpplzh+zwB9IBFePnjot6ZB9UlY3g3IRQk17xVyA1t/mB3ColWpxLrPaCX8T+RbpwPCCGH8Wt9pCOaeDHfqNnvMipUUhqN6VqCGV8sjKaIgqXMl0esJfciDy1uCabYFAzgplokf4SacpZKfM3JsJgOwOs+984/2g3vBRXTNwHyQl85IZjDd9mzbAhprF1zPIY4sOVTcBCCGtfFb4zlDql6X25BXIrR2jsRAReUUJQzWwNRH2BlDMVGrMdYy7dtma7xc+87JL1lgLnrLxkFDhkqSR41k2jG+nrLsu/tvqzh6jfW9RqMRK3NCSEDJxf7prPRKd6AB0APITgdMlCDV0jfvzivMf3hkWYxo4jMildDJJF99/2AV4GfSnEb9rJOzs14s+4hJb5mIpBM9J+63tWAszQAkC53MfmtBcMwYGgtmkXT3sbUlmAIjAmfM88+YApSLIYZSGcDYttGU7w5fouJ2LtZwYbyou/Gse4QNrJGExhFu9EeWRtj+Pez/O849t0+gx7ICgtOdoBtEzfebgYTA3KuhLo26ctlzAxequ1yi6g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b47ea57e-4287-4030-0b39-08d8426fd6bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2020 05:38:58.2423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xZH/cbenLmHV9yW197wchgSJKA8JdwG7gTg483bfoyN40wIghrulkdzVFYnOMogN8dAsLfvBurBrbWB7Cj+xVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1996
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFN1bmRheSwgQXVndXN0IDE2LCAyMDIwIDEyOjMwIEFNDQo+IA0KPiBIaSBZaSwNCj4g
DQo+IE9uIDcvMjgvMjAgODoyNyBBTSwgTGl1IFlpIEwgd3JvdGU6DQo+ID4gV2hlbiBhbiBJT01N
VSBkb21haW4gd2l0aCBuZXN0aW5nIGF0dHJpYnV0ZSBpcyB1c2VkIGZvciBndWVzdCBTVkEsIGEN
Cj4gPiBzeXN0ZW0td2lkZSBQQVNJRCBpcyBhbGxvY2F0ZWQgZm9yIGJpbmRpbmcgd2l0aCB0aGUg
ZGV2aWNlIGFuZCB0aGUgZG9tYWluLg0KPiA+IEZvciBzZWN1cml0eSByZWFzb24sIHdlIG5lZWQg
dG8gY2hlY2sgdGhlIFBBU0lEIHBhc3NlZCBmcm9tIHVzZXItc3BhY2UuDQo+ID4gZS5nLiBwYWdl
IHRhYmxlIGJpbmQvdW5iaW5kIGFuZCBQQVNJRCByZWxhdGVkIGNhY2hlIGludmFsaWRhdGlvbi4N
Cj4gPg0KPiA+IENjOiBLZXZpbiBUaWFuIDxrZXZpbi50aWFuQGludGVsLmNvbT4NCj4gPiBDQzog
SmFjb2IgUGFuIDxqYWNvYi5qdW4ucGFuQGxpbnV4LmludGVsLmNvbT4NCj4gPiBDYzogQWxleCBX
aWxsaWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4NCj4gPiBDYzogRXJpYyBBdWdl
ciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiA+IENjOiBKZWFuLVBoaWxpcHBlIEJydWNrZXIg
PGplYW4tcGhpbGlwcGVAbGluYXJvLm9yZz4NCj4gPiBDYzogSm9lcmcgUm9lZGVsIDxqb3JvQDhi
eXRlcy5vcmc+DQo+ID4gQ2M6IEx1IEJhb2x1IDxiYW9sdS5sdUBsaW51eC5pbnRlbC5jb20+DQo+
ID4gU2lnbmVkLW9mZi1ieTogTGl1IFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBKYWNvYiBQYW4gPGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29tPg0KPiA+
IC0tLQ0KPiA+ICBkcml2ZXJzL2lvbW11L2ludGVsL2lvbW11LmMgfCAxMCArKysrKysrKysrDQo+
ID4gIGRyaXZlcnMvaW9tbXUvaW50ZWwvc3ZtLmMgICB8ICA3ICsrKysrLS0NCj4gPiAgMiBmaWxl
cyBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvaW9tbXUvaW50ZWwvaW9tbXUuYyBiL2RyaXZlcnMvaW9tbXUvaW50
ZWwvaW9tbXUuYw0KPiA+IGluZGV4IGIyZmU1NGUuLjg4ZjQ2NDcgMTAwNjQ0DQo+ID4gLS0tIGEv
ZHJpdmVycy9pb21tdS9pbnRlbC9pb21tdS5jDQo+ID4gKysrIGIvZHJpdmVycy9pb21tdS9pbnRl
bC9pb21tdS5jDQo+ID4gQEAgLTU0MzYsNiArNTQzNiw3IEBAIGludGVsX2lvbW11X3N2YV9pbnZh
bGlkYXRlKHN0cnVjdCBpb21tdV9kb21haW4NCj4gKmRvbWFpbiwgc3RydWN0IGRldmljZSAqZGV2
LA0KPiA+ICAJCWludCBncmFudSA9IDA7DQo+ID4gIAkJdTY0IHBhc2lkID0gMDsNCj4gPiAgCQl1
NjQgYWRkciA9IDA7DQo+ID4gKwkJdm9pZCAqcGRhdGE7DQo+ID4NCj4gPiAgCQlncmFudSA9IHRv
X3Z0ZF9ncmFudWxhcml0eShjYWNoZV90eXBlLCBpbnZfaW5mby0+Z3JhbnVsYXJpdHkpOw0KPiA+
ICAJCWlmIChncmFudSA9PSAtRUlOVkFMKSB7DQo+ID4gQEAgLTU0NTYsNiArNTQ1NywxNSBAQCBp
bnRlbF9pb21tdV9zdmFfaW52YWxpZGF0ZShzdHJ1Y3QgaW9tbXVfZG9tYWluDQo+ICpkb21haW4s
IHN0cnVjdCBkZXZpY2UgKmRldiwNCj4gPiAgCQkJIChpbnZfaW5mby0+Z3JhbnUuYWRkcl9pbmZv
LmZsYWdzICYNCj4gSU9NTVVfSU5WX0FERFJfRkxBR1NfUEFTSUQpKQ0KPiA+ICAJCQlwYXNpZCA9
IGludl9pbmZvLT5ncmFudS5hZGRyX2luZm8ucGFzaWQ7DQo+ID4NCj4gPiArCQlwZGF0YSA9IGlv
YXNpZF9maW5kKGRtYXJfZG9tYWluLT5pb2FzaWRfc2lkLCBwYXNpZCwgTlVMTCk7DQo+ID4gKwkJ
aWYgKCFwZGF0YSkgew0KPiA+ICsJCQlyZXQgPSAtRUlOVkFMOw0KPiA+ICsJCQlnb3RvIG91dF91
bmxvY2s7DQo+ID4gKwkJfSBlbHNlIGlmIChJU19FUlIocGRhdGEpKSB7DQo+ID4gKwkJCXJldCA9
IFBUUl9FUlIocGRhdGEpOw0KPiA+ICsJCQlnb3RvIG91dF91bmxvY2s7DQo+ID4gKwkJfQ0KPiA+
ICsNCj4gPiAgCQlzd2l0Y2ggKEJJVChjYWNoZV90eXBlKSkgew0KPiA+ICAJCWNhc2UgSU9NTVVf
Q0FDSEVfSU5WX1RZUEVfSU9UTEI6DQo+ID4gIAkJCS8qIEhXIHdpbGwgaWdub3JlIExTQiBiaXRz
IGJhc2VkIG9uIGFkZHJlc3MgbWFzayAqLw0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lvbW11
L2ludGVsL3N2bS5jIGIvZHJpdmVycy9pb21tdS9pbnRlbC9zdm0uYw0KPiA+IGluZGV4IGM4NWI4
ZDUuLmI5YjI5YWQgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9pb21tdS9pbnRlbC9zdm0uYw0K
PiA+ICsrKyBiL2RyaXZlcnMvaW9tbXUvaW50ZWwvc3ZtLmMNCj4gPiBAQCAtMzIzLDcgKzMyMyw3
IEBAIGludCBpbnRlbF9zdm1fYmluZF9ncGFzaWQoc3RydWN0IGlvbW11X2RvbWFpbiAqZG9tYWlu
LA0KPiBzdHJ1Y3QgZGV2aWNlICpkZXYsDQo+ID4gIAlkbWFyX2RvbWFpbiA9IHRvX2RtYXJfZG9t
YWluKGRvbWFpbik7DQo+ID4NCj4gPiAgCW11dGV4X2xvY2soJnBhc2lkX211dGV4KTsNCj4gPiAt
CXN2bSA9IGlvYXNpZF9maW5kKElOVkFMSURfSU9BU0lEX1NFVCwgZGF0YS0+aHBhc2lkLCBOVUxM
KTsNCj4gPiArCXN2bSA9IGlvYXNpZF9maW5kKGRtYXJfZG9tYWluLT5pb2FzaWRfc2lkLCBkYXRh
LT5ocGFzaWQsIE5VTEwpOw0KPiBBIHF1ZXN0aW9uIGFib3V0IHRoZSBsb2NraW5nIHN0cmF0ZWd5
LiBXZSBkb24ndCB0YWtlIHRoZQ0KPiBkZXZpY2VfZG9tYWluX2xvY2sgaGVyZS4gQ291bGQgeW91
IGNsYXJpZnkgd2hldGhlciBpdCBpcyBzYWZlPw0KDQpJIGd1ZXNzIGl0IGlzIGJldHRlciB0byB0
YWtlIHRoZSBzYW1lIGxvY2sgYXMgd2hhdCBpb21tdV9kb21haW5fc2V0X2F0dHIoKQ0KdGFrZXMu
IHRoYW5rcyBmb3IgY2F0Y2hpbmcgaXQuIDotKQ0KDQo+IA0KPiA+ICAJaWYgKElTX0VSUihzdm0p
KSB7DQo+ID4gIAkJcmV0ID0gUFRSX0VSUihzdm0pOw0KPiA+ICAJCWdvdG8gb3V0Ow0KPiA+IEBA
IC00NDAsNiArNDQwLDcgQEAgaW50IGludGVsX3N2bV91bmJpbmRfZ3Bhc2lkKHN0cnVjdCBpb21t
dV9kb21haW4NCj4gKmRvbWFpbiwNCj4gPiAgCQkJICAgIHN0cnVjdCBkZXZpY2UgKmRldiwgdTMy
IHBhc2lkKQ0KPiA+ICB7DQo+ID4gIAlzdHJ1Y3QgaW50ZWxfaW9tbXUgKmlvbW11ID0gaW50ZWxf
c3ZtX2RldmljZV90b19pb21tdShkZXYpOw0KPiA+ICsJc3RydWN0IGRtYXJfZG9tYWluICpkbWFy
X2RvbWFpbjsNCj4gPiAgCXN0cnVjdCBpbnRlbF9zdm1fZGV2ICpzZGV2Ow0KPiA+ICAJc3RydWN0
IGludGVsX3N2bSAqc3ZtOw0KPiA+ICAJaW50IHJldCA9IC1FSU5WQUw7DQo+ID4gQEAgLTQ0Nyw4
ICs0NDgsMTAgQEAgaW50IGludGVsX3N2bV91bmJpbmRfZ3Bhc2lkKHN0cnVjdCBpb21tdV9kb21h
aW4NCj4gKmRvbWFpbiwNCj4gPiAgCWlmIChXQVJOX09OKCFpb21tdSkpDQo+ID4gIAkJcmV0dXJu
IC1FSU5WQUw7DQo+ID4NCj4gPiArCWRtYXJfZG9tYWluID0gdG9fZG1hcl9kb21haW4oZG9tYWlu
KTsNCj4gPiArDQo+ID4gIAltdXRleF9sb2NrKCZwYXNpZF9tdXRleCk7DQo+ID4gLQlzdm0gPSBp
b2FzaWRfZmluZChJTlZBTElEX0lPQVNJRF9TRVQsIHBhc2lkLCBOVUxMKTsNCj4gPiArCXN2bSA9
IGlvYXNpZF9maW5kKGRtYXJfZG9tYWluLT5pb2FzaWRfc2lkLCBwYXNpZCwgTlVMTCk7DQo+IHNh
bWUgaGVyZS4NCg0Kc2FtZS4NCg0KUmVnYXJkcywNCllpIExpdQ0KDQo+ID4gIAlpZiAoIXN2bSkg
ew0KPiA+ICAJCXJldCA9IC1FSU5WQUw7DQo+ID4gIAkJZ290byBvdXQ7DQo+ID4NCj4gVGhhbmtz
DQo+IA0KPiBFcmljDQoNCg==
