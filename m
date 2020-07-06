Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAAA215824
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 15:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgGFNRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 09:17:13 -0400
Received: from mga17.intel.com ([192.55.52.151]:60882 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729072AbgGFNRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 09:17:12 -0400
IronPort-SDR: HwUdchY5CnVzGqIOos2h0rsvK5M0mDu1naVOHDHxKBgk6SjbbbVbzhUhsgC/eRm4tbvqQ66JUE
 Y0LJK1Z0YL1Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9673"; a="127484934"
X-IronPort-AV: E=Sophos;i="5.75,320,1589266800"; 
   d="scan'208";a="127484934"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 06:17:09 -0700
IronPort-SDR: HSYZbkTYNzvbnHRMrkSbA1lrcoARCfPEw45YwWrwyXIL558POjBmtwxahtF9FAY7sC2Qrldy7R
 CFUWDoq6oPaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,320,1589266800"; 
   d="scan'208";a="283034653"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga006.jf.intel.com with ESMTP; 06 Jul 2020 06:17:08 -0700
Received: from orsmsx111.amr.corp.intel.com (10.22.240.12) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 6 Jul 2020 06:17:08 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX111.amr.corp.intel.com (10.22.240.12) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 6 Jul 2020 06:17:08 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 6 Jul 2020 06:17:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbKD/sC8HiVM0sj+gA1EP6N6iMTfUWaTLRn+kfAu+3WGHSgwsiFIBLI4+SVaTBK77z6BaePwYxmN+LG2XzBQ+VHCp3kDWM8fSpaTblsMFUa1i0VbYKAUfmpHJpnoAT69gBAoyCkzda/OYOBGWkiQc/7YaiNW15Nd+hyFpmpmYEP83qLyQHzGuwkZtsT8i4GyYtVW2WXgCCRok2JjHcCxvPTRgqJK8risd0BBt1wLPRrUoYNZXnJHOTnR/adm32jdLbZcljqlGXT3KpZ9QqiUWtQKMdLHueq/fXzHm5liZqqky5kTN4qN9kabAqL1VHsEX0eRe4pNKnL4Uw645a7c9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GyhqMkw+14CKz0MVrNIJyT7ZwzcY4nEQ6EfqL/E9Iok=;
 b=gketOvCEEuzgrmDUNd2FDlqUaM1eQMWV/yCYuWK+4w3QCB5jvFgrPeKqyExeHznnHVgocvOKMogUreScKvu/B0qvwKLKavpI+TcfMb1G3/tCBMI1vtfUP3uBRbLYgEvqrZOr5gukzwOPqgLljk8U6cQRZEW5LFfCBb1py3SgkViivBno6ts3cYG3qSkQmopgp7eFZOg7u11bez31TwkRzC3RoRLCQuF4gfmah8p5Fd3cWeYt59YYhN/6omksiRM1PYPHeMFjJRXCrgBSYFp6fqiLuR4viAk0YF4pK1uXv08CC2hvn0wyFv/B2wber7vstiLrFJZEy1mL7Dc6yp6H1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GyhqMkw+14CKz0MVrNIJyT7ZwzcY4nEQ6EfqL/E9Iok=;
 b=PgKUoXJqTWH3A5THSz/IkgByOyE1+oUt15LQXe5w/UAJltQ397TWR49U45+meo4yJF/dbtfIQrICObw+EDg4Ndc+gYP96urorWRdZ9Sbp754mvze0VV/EdkQJcP9nz2AGdqj88ZXV3YxR/306jWUFPItXViK+vehlhtuKF96Fk8=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB0027.namprd11.prod.outlook.com (2603:10b6:4:6b::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3153.20; Mon, 6 Jul 2020 13:17:05 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3153.029; Mon, 6 Jul 2020
 13:17:05 +0000
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
Subject: RE: [PATCH v4 02/15] iommu: Report domain nesting info
Thread-Topic: [PATCH v4 02/15] iommu: Report domain nesting info
Thread-Index: AQHWUfUZPmXy4q2mvk6wmPCF23Zkz6j6TVgAgAArcYCAAA43AIAAA19A
Date:   Mon, 6 Jul 2020 13:17:05 +0000
Message-ID: <DM5PR11MB1435362511CAADBDBF6CCF7FC3690@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1593861989-35920-1-git-send-email-yi.l.liu@intel.com>
 <1593861989-35920-3-git-send-email-yi.l.liu@intel.com>
 <b9479f61-7f9e-e0ae-5125-ab15f59b1ece@redhat.com>
 <DM5PR11MB14352CBCB1966C0B9E418C7CC3690@DM5PR11MB1435.namprd11.prod.outlook.com>
 <b1d361f3-b0ca-7fef-ba31-1bdcdadea96f@redhat.com>
In-Reply-To: <b1d361f3-b0ca-7fef-ba31-1bdcdadea96f@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.207]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: afbd4a37-59d3-4908-0eb6-08d821aee100
x-ms-traffictypediagnostic: DM5PR11MB0027:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB0027C8BC0262D614EBB59063C3690@DM5PR11MB0027.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 04569283F9
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XAyPENPZTixedPWaPi2orHBjJvPbpyqcx6OhHW/F4PP2URwjlCmWfvJ1rJ7eRKh576YcmWUIiEFMsBGfUDTEK+uqqQcwn30cruCGAC3qEhLvwp/4zR5C20G3Bn/Qx4cVAmNN4pm0KCRLTP4SpytlSEJkK4U8cE81R/ecSvUiY70jAsSVe7J/6d1VWGjGhg3fEAyPk528h56hhI4r4RxnvGYyYEHppBASh4o89wEHlg3HYnTKjmQob3I3xp5SxAcjMRWcbkLubCBmudF+yWJRMaQlewL0fRebPDGV1lMsj091aCh0jKk5SesVfPJqYjN5U3eIMnlIY/xFnyV40DVBQOZlFONnjBaGEDo/b/m7VY6gXfhrueCxy+QTAxa05N4W8xQU670huWmoXbHtF/t6Rw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(66946007)(9686003)(64756008)(66556008)(66476007)(66446008)(4326008)(26005)(186003)(71200400001)(7416002)(8676002)(55016002)(83380400001)(966005)(478600001)(45080400002)(52536014)(86362001)(110136005)(5660300002)(33656002)(53546011)(6506007)(54906003)(8936002)(316002)(2906002)(7696005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: fzhBaoqBZuJLoNQLItCJQkhEDbnCIrzJBxWUvaF9k2JHFHShMLcyEFKKjVP+VtowrggDMByV8ev5dkriGxARP7O+nflkcI5bRJNEg12QBIT2fR+soLtFjcSjTg/0Yz+EoOkdGxjq/y/7pdQPoAIr1cewvpXH/z2N9cKBGCRlguxZFnDHu5g6qYLnge/cciUykoV3jdMTU9Y0PaDNmIc+l0CaYAK4Iry60DzrE96Fl0zEBNc5qkDOa+XSJvihqCLectEm6sh66vfDFia+8I9Arj7w0HzJqa5BEBDzsL93iSsPj9snUOsPnOG68Skdl5elggLycegC4WmslJDJD7RyiIqDWsDKmiJEkg8gVH4yYhrp9qxRf2+wheJSIxcm7sGAI94nzcF8X5lwAwo2vnYDsvaBrX9z/Ntyng3UhmEB986id70Dz3xz/NPHyBna3JBrqgZHTCFBFHgOkbOU3gvftkrP0+QBTiVO3YXJtqJIwIl2S/7G3Yfes46SSLJNwzB/
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afbd4a37-59d3-4908-0eb6-08d821aee100
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2020 13:17:05.4549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S/uF95fIGxH/snh9VKiWJYJQVHWqVNeJNVm2M21kRPl8+3EGZ5nmXtHZy9m6vBrg+YnQoydJAG2cej4luF+BFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB0027
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBdWdlciBFcmljIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IE1vbmRh
eSwgSnVseSA2LCAyMDIwIDk6MDEgUE0NCj4NCj4gT24gNy82LzIwIDI6MjAgUE0sIExpdSwgWWkg
TCB3cm90ZToNCj4gPiBIaSBFcmljLA0KPiA+DQo+ID4+IEZyb206IEF1Z2VyIEVyaWMgPGVyaWMu
YXVnZXJAcmVkaGF0LmNvbT4NCj4gPj4gU2VudDogTW9uZGF5LCBKdWx5IDYsIDIwMjAgNTozNCBQ
TQ0KPiA+Pg0KPiA+PiBPbiA3LzQvMjAgMToyNiBQTSwgTGl1IFlpIEwgd3JvdGU6DQo+ID4+PiBJ
T01NVXMgdGhhdCBzdXBwb3J0IG5lc3RpbmcgdHJhbnNsYXRpb24gbmVlZHMgcmVwb3J0IHRoZSBj
YXBhYmlsaXR5DQo+ID4+PiBpbmZvDQo+ID4+IG5lZWQgdG8gcmVwb3J0DQo+ID4+PiB0byB1c2Vy
c3BhY2UsIGUuZy4gdGhlIGZvcm1hdCBvZiBmaXJzdCBsZXZlbC9zdGFnZSBwYWdpbmcgc3RydWN0
dXJlcy4NCj4gPj4+DQo+ID4+PiBUaGlzIHBhdGNoIHJlcG9ydHMgbmVzdGluZyBpbmZvIGJ5IERP
TUFJTl9BVFRSX05FU1RJTkcuIENhbGxlciBjYW4NCj4gPj4+IGdldCBuZXN0aW5nIGluZm8gYWZ0
ZXIgc2V0dGluZyBET01BSU5fQVRUUl9ORVNUSU5HLg0KPiA+Pj4NCj4gPj4+IENjOiBLZXZpbiBU
aWFuIDxrZXZpbi50aWFuQGludGVsLmNvbT4NCj4gPj4+IENDOiBKYWNvYiBQYW4gPGphY29iLmp1
bi5wYW5AbGludXguaW50ZWwuY29tPg0KPiA+Pj4gQ2M6IEFsZXggV2lsbGlhbXNvbiA8YWxleC53
aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4+PiBDYzogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckBy
ZWRoYXQuY29tPg0KPiA+Pj4gQ2M6IEplYW4tUGhpbGlwcGUgQnJ1Y2tlciA8amVhbi1waGlsaXBw
ZUBsaW5hcm8ub3JnPg0KPiA+Pj4gQ2M6IEpvZXJnIFJvZWRlbCA8am9yb0A4Ynl0ZXMub3JnPg0K
PiA+Pj4gQ2M6IEx1IEJhb2x1IDxiYW9sdS5sdUBsaW51eC5pbnRlbC5jb20+DQo+ID4+PiBTaWdu
ZWQtb2ZmLWJ5OiBMaXUgWWkgTCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiA+Pj4gU2lnbmVkLW9m
Zi1ieTogSmFjb2IgUGFuIDxqYWNvYi5qdW4ucGFuQGxpbnV4LmludGVsLmNvbT4NCj4gPj4+IC0t
LQ0KPiA+Pj4gdjMgLT4gdjQ6DQo+ID4+PiAqKSBzcGxpdCB0aGUgU01NVSBkcml2ZXIgY2hhbmdl
cyB0byBiZSBhIHNlcGFyYXRlIHBhdGNoDQo+ID4+PiAqKSBtb3ZlIHRoZSBAYWRkcl93aWR0aCBh
bmQgQHBhc2lkX2JpdHMgZnJvbSB2ZW5kb3Igc3BlY2lmaWMNCj4gPj4+ICAgIHBhcnQgdG8gZ2Vu
ZXJpYyBwYXJ0Lg0KPiA+Pj4gKikgdHdlYWsgdGhlIGRlc2NyaXB0aW9uIGZvciB0aGUgQGZlYXR1
cmVzIGZpZWxkIG9mIHN0cnVjdA0KPiA+Pj4gICAgaW9tbXVfbmVzdGluZ19pbmZvLg0KPiA+Pj4g
KikgYWRkIGRlc2NyaXB0aW9uIG9uIHRoZSBAZGF0YVtdIGZpZWxkIG9mIHN0cnVjdCBpb21tdV9u
ZXN0aW5nX2luZm8NCj4gPj4+DQo+ID4+PiB2MiAtPiB2MzoNCj4gPj4+ICopIHJlbXZvZSBjYXAv
ZWNhcF9tYXNrIGluIGlvbW11X25lc3RpbmdfaW5mby4NCj4gPj4+ICopIHJldXNlIERPTUFJTl9B
VFRSX05FU1RJTkcgdG8gZ2V0IG5lc3RpbmcgaW5mby4NCj4gPj4+ICopIHJldHVybiBhbiBlbXB0
eSBpb21tdV9uZXN0aW5nX2luZm8gZm9yIFNNTVUgZHJpdmVycyBwZXIgSmVhbicNCj4gPj4+ICAg
IHN1Z2dlc3Rpb24uDQo+ID4+PiAtLS0NCj4gPj4+ICBpbmNsdWRlL3VhcGkvbGludXgvaW9tbXUu
aCB8IDc4DQo+ID4+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysNCj4gPj4+ICAxIGZpbGUgY2hhbmdlZCwgNzggaW5zZXJ0aW9ucygrKQ0KPiA+Pj4NCj4gPj4+
IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvaW9tbXUuaCBiL2luY2x1ZGUvdWFwaS9s
aW51eC9pb21tdS5oDQo+ID4+PiBpbmRleCAxYWZjNjYxLi4xYmZjMDMyIDEwMDY0NA0KPiA+Pj4g
LS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2lvbW11LmgNCj4gPj4+ICsrKyBiL2luY2x1ZGUvdWFw
aS9saW51eC9pb21tdS5oDQo+ID4+PiBAQCAtMzMyLDQgKzMzMiw4MiBAQCBzdHJ1Y3QgaW9tbXVf
Z3Bhc2lkX2JpbmRfZGF0YSB7DQo+ID4+PiAgCX0gdmVuZG9yOw0KPiA+Pj4gIH07DQo+ID4+Pg0K
PiA+Pj4gKy8qDQo+ID4+PiArICogc3RydWN0IGlvbW11X25lc3RpbmdfaW5mbyAtIEluZm9ybWF0
aW9uIGZvciBuZXN0aW5nLWNhcGFibGUgSU9NTVUuDQo+ID4+PiArICoJCQkJdXNlciBzcGFjZSBz
aG91bGQgY2hlY2sgaXQgYmVmb3JlIHVzaW5nDQo+ID4+PiArICoJCQkJbmVzdGluZyBjYXBhYmls
aXR5Lg0KPiA+PiBhbGlnbm1lbnQ/DQo+ID4NCj4gPiBvaCwgeWVzLCB3aWxsIGRvIGl0Lg0KPiA+
DQo+ID4+PiArICoNCj4gPj4+ICsgKiBAc2l6ZToJc2l6ZSBvZiB0aGUgd2hvbGUgc3RydWN0dXJl
DQo+ID4+PiArICogQGZvcm1hdDoJUEFTSUQgdGFibGUgZW50cnkgZm9ybWF0LCB0aGUgc2FtZSBk
ZWZpbml0aW9uIHdpdGgNCj4gPj4+ICsgKgkJQGZvcm1hdCBvZiBzdHJ1Y3QgaW9tbXVfZ3Bhc2lk
X2JpbmRfZGF0YS4NCj4gPj4gdGhlIHNhbWUgZGVmaW5pdGlvbiBhcyBzdHJ1Y3QgaW9tbXVfZ3Bh
c2lkX2JpbmRfZGF0YSBAZm9ybWF0Pw0KPiA+DQo+ID4gcmlnaHQuIHlvdXJzIGlzIG11Y2ggYmV0
dGVyLg0KPiA+DQo+ID4+PiArICogQGZlYXR1cmVzOglzdXBwb3J0ZWQgbmVzdGluZyBmZWF0dXJl
cy4NCj4gPj4+ICsgKiBAZmxhZ3M6CWN1cnJlbnRseSByZXNlcnZlZCBmb3IgZnV0dXJlIGV4dGVu
c2lvbi4NCj4gPj4+ICsgKiBAYWRkcl93aWR0aDoJVGhlIG91dHB1dCBhZGRyIHdpZHRoIG9mIGZp
cnN0IGxldmVsL3N0YWdlIHRyYW5zbGF0aW9uDQo+ID4+PiArICogQHBhc2lkX2JpdHM6CU1heGlt
dW0gc3VwcG9ydGVkIFBBU0lEIGJpdHMsIDAgcmVwcmVzZW50cyBubyBQQVNJRA0KPiA+Pj4gKyAq
CQlzdXBwb3J0Lg0KPiA+Pj4gKyAqIEBkYXRhOgl2ZW5kb3Igc3BlY2lmaWMgY2FwIGluZm8uIGRh
dGFbXSBzdHJ1Y3R1cmUgdHlwZSBjYW4gYmUgZGVkdWNlZA0KPiA+Pj4gKyAqCQlmcm9tIEBmb3Jt
YXQgZmllbGQuDQo+ID4+PiArICoNCj4gPj4+ICsgKg0KPiA+Pg0KPiArPT09PT09PT09PT09PT09
Kz09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPiA+
PiA9PT0rDQo+ID4+PiArICogfCBmZWF0dXJlICAgICAgIHwgIE5vdGVzICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8DQo+ID4+PiArICoNCj4gPj4NCj4gKz09
PT09PT09PT09PT09PSs9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT0NCj4gPj4gPT09Kw0KPiA+Pj4gKyAqIHwgU1lTV0lERV9QQVNJRCB8ICBQQVNJRHMg
YXJlIG1hbmFnZWQgaW4gc3lzdGVtLXdpZGUsIGluc3RlYWQgb2YgcGVyICAgfA0KPiA+Pj4gKyAq
IHwgICAgICAgICAgICAgICB8ICBkZXZpY2UuIFdoZW4gYSBkZXZpY2UgaXMgYXNzaWduZWQgdG8g
dXNlcnNwYWNlIG9yICAgfA0KPiA+Pj4gKyAqIHwgICAgICAgICAgICAgICB8ICBWTSwgcHJvcGVy
IHVBUEkgKHVzZXJzcGFjZSBkcml2ZXIgZnJhbWV3b3JrIHVBUEksICAgfA0KPiA+Pj4gKyAqIHwg
ICAgICAgICAgICAgICB8ICBlLmcuIFZGSU8pIG11c3QgYmUgdXNlZCB0byBhbGxvY2F0ZS9mcmVl
IFBBU0lEcyBmb3IgfA0KPiA+Pj4gKyAqIHwgICAgICAgICAgICAgICB8ICB0aGUgYXNzaWduZWQg
ZGV2aWNlLiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfA0KPiA+Pj4gKyAqICstLS0t
LS0tLS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tKw0KPiA+Pj4gKyAqIHwgQklORF9QR1RCTCAgICB8ICBUaGUgb3duZXIgb2YgdGhl
IGZpcnN0IGxldmVsL3N0YWdlIHBhZ2UgdGFibGUgbXVzdCAgfA0KPiA+Pj4gKyAqIHwgICAgICAg
ICAgICAgICB8ICBleHBsaWNpdGx5IGJpbmQgdGhlIHBhZ2UgdGFibGUgdG8gYXNzb2NpYXRlZCBQ
QVNJRCAgfA0KPiA+Pj4gKyAqIHwgICAgICAgICAgICAgICB8ICAoZWl0aGVyIHRoZSBvbmUgc3Bl
Y2lmaWVkIGluIGJpbmQgcmVxdWVzdCBvciB0aGUgICAgfA0KPiA+Pj4gKyAqIHwgICAgICAgICAg
ICAgICB8ICBkZWZhdWx0IFBBU0lEIG9mIGlvbW11IGRvbWFpbiksIHRocm91Z2ggdXNlcnNwYWNl
ICAgfA0KPiA+Pj4gKyAqIHwgICAgICAgICAgICAgICB8ICBkcml2ZXIgZnJhbWV3b3JrIHVBUEkg
KGUuZy4gVkZJT19JT01NVV9ORVNUSU5HX09QKS4gfA0KPiA+Pj4gKyAqICstLS0tLS0tLS0tLS0t
LS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
Kw0KPiA+Pj4gKyAqIHwgQ0FDSEVfSU5WTEQgICB8ICBUaGUgb3duZXIgb2YgdGhlIGZpcnN0IGxl
dmVsL3N0YWdlIHBhZ2UgdGFibGUgbXVzdCAgfA0KPiA+Pj4gKyAqIHwgICAgICAgICAgICAgICB8
ICBleHBsaWNpdGx5IGludmFsaWRhdGUgdGhlIElPTU1VIGNhY2hlIHRocm91Z2ggdUFQSSAgfA0K
PiA+Pj4gKyAqIHwgICAgICAgICAgICAgICB8ICBwcm92aWRlZCBieSB1c2Vyc3BhY2UgZHJpdmVy
IGZyYW1ld29yayAoZS5nLiBWRklPKSAgfA0KPiA+Pj4gKyAqIHwgICAgICAgICAgICAgICB8ICBh
Y2NvcmRpbmcgdG8gdmVuZG9yLXNwZWNpZmljIHJlcXVpcmVtZW50IHdoZW4gICAgICAgfA0KPiA+
Pj4gKyAqIHwgICAgICAgICAgICAgICB8ICBjaGFuZ2luZyB0aGUgcGFnZSB0YWJsZS4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgfA0KPiA+Pj4gKyAqDQo+ID4+PiArICstLS0tLS0tLS0tLS0t
LS0rLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiA+
Pj4gKyAtLS0tLSsNCj4gPj4gRG8geW91IGZvcmVzZWUgY2FzZXMgd2hlcmUgQklORF9QR1RCTCBh
bmQgQ0FDSEVfSU5WTEQgc2hvdWxkbid0IGJlDQo+ID4+IGV4cG9zZWQgYXMgZmVhdHVyZXM/DQo+
ID4NCj4gPiBzb3JyeSwgSSBkaWRuJ3QgcXVpdGUgZ2V0IGl0LiBjb3VsZCB5b3UgZXhwbGFpbiBh
IGxpdHRsZSBiaXQgbW9yZS4gOi0pDQo+IEZvciBTWVNXSURFX1BBU0lEIEkgdW5kZXJzdGFuZCBT
TU1VIHdvbid0IGFkdmVydGlzZSBpdC4gQnV0IGRvIHlvdSBmb3Jlc2VlIGFueQ0KPiBuZXN0ZWQg
aW1wbGVtZW50YXRpb24gbm90IHJlcXVlc3RpbmcgdGhlIG93bmVyIG9mIHRoZSB0YWJsZXMgdG8g
YmluZCBhbmQgaW52YWxpZGF0ZQ0KPiBjYWNoZXMuIFNvIEkgdW5kZXJzdGFuZCB0aG9zZSAyIGZl
YXR1cmVzIHdvdWxkIGFsd2F5cyBiZSBzdXBwb3J0ZWQ/DQoNCkkgdGhpbmsgQklORF9QR1RCTCBp
cyBvcHRpb25hbCBhcyBBUk0gd2lsbCBiaW5kIGd1ZXN0IHBhc2lkIHRhYmxlIHRvIGhvc3QuIEFz
IGZvcg0KQ0FDSEVfSU5WTEQsIHBlciBjdXJyZW50IG5lc3RpbmcgaW1wbGVtZW50YXRpb25zLCBs
b29rcyBhbGwgc3RhZ2UtMS9sZXZlbC0xDQpvd25lciBzaG91bGQgaXNzdWUgY2FjaGUgaW52YWxp
ZGF0aW9uIHdoZW4gc3RhZ2UtMS9sZXZlbC0xIGNoYW5nZWQuIEJ1dCBzdGlsbA0KYWRkZWQgaXQg
aGVyZSBwZXIgdGhlIGNvbW1lbnRzIGZyb20gS2V2aW4uIDotKQ0KDQoiU28gZmFyIHRoaXMgYXNz
dW1wdGlvbiBpcyBjb3JyZWN0IGJ1dCBpdCBtYXkgbm90IGJlIHRydWUgd2hlbiB0aGlua2luZyBm
b3J3YXJkLg0KRm9yIGV4YW1wbGUsIGEgdmVuZG9yIG1pZ2h0IGZpbmQgYSB3YXkgdG8gYWxsb3cg
dGhlIG93bmVyIG9mIDFzdC1sZXZlbCBwYWdlDQp0YWJsZSB0byBkaXJlY3RseSBpbnZhbGlkYXRl
IGNhY2hlIHcvbyBnb2luZyB0aHJvdWdoIGhvc3QgSU9NTVUgZHJpdmVyLiBGcm9tDQp0aGlzIGFu
Z2xlIEkgZmVlbCBleHBsaWNpdGx5IHJlcG9ydGluZyB0aGlzIGNhcGFiaWxpdHkgaXMgbW9yZSBy
b2J1c3QuIg0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1pb21tdS9NV0hQUjExTUIx
NjQ1QjA5RUJEQzc2NTE0QURDODk3QTY4QzZGMEBNV0hQUjExTUIxNjQ1Lm5hbXByZDExLnByb2Qu
b3V0bG9vay5jb20vDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg0KPiA+DQo+ID4+PiArICoNCj4gPj4+
ICsgKiBAZGF0YVtdIHR5cGVzIGRlZmluZWQgZm9yIEBmb3JtYXQ6DQo+ID4+PiArICoNCj4gPj4N
Cj4gKz09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Kz09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT0NCj4gPj4gPT09Kw0KPiA+Pj4gKyAqIHwgQGZvcm1hdCAgICAgICAgICAg
ICAgICAgICAgICAgIHwgQGRhdGFbXSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfA0KPiA+
Pj4gKyAqDQo+ID4+DQo+ICs9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PSs9PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+ID4+ID09PSsNCj4gPj4+ICsgKiB8IElPTU1V
X1BBU0lEX0ZPUk1BVF9JTlRFTF9WVEQgICB8IHN0cnVjdCBpb21tdV9uZXN0aW5nX2luZm9fdnRk
DQo+IHwNCj4gPj4+ICsgKg0KPiA+Pj4gKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LSstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPj4+ICstLS0tKw0KPiA+Pj4g
KyAqDQo+ID4+PiArICovDQo+ID4+PiArc3RydWN0IGlvbW11X25lc3RpbmdfaW5mbyB7DQo+ID4+
PiArCV9fdTMyCXNpemU7DQo+ID4+PiArCV9fdTMyCWZvcm1hdDsNCj4gPj4+ICsJX191MzIJZmVh
dHVyZXM7DQo+ID4+PiArI2RlZmluZSBJT01NVV9ORVNUSU5HX0ZFQVRfU1lTV0lERV9QQVNJRAko
MSA8PCAwKQ0KPiA+Pj4gKyNkZWZpbmUgSU9NTVVfTkVTVElOR19GRUFUX0JJTkRfUEdUQkwJCSgx
IDw8IDEpDQo+ID4+PiArI2RlZmluZSBJT01NVV9ORVNUSU5HX0ZFQVRfQ0FDSEVfSU5WTEQJCSgx
IDw8IDIpDQo+ID4+IEluIG90aGVyIHN0cnVjdHMgdGhlIHZhbHVlcyBzZWVtIHRvIGJlIGRlZmlu
ZWQgYmVmb3JlIHRoZSBmaWVsZA0KPiA+DQo+ID4gbm90IHN1cmUuIDotKSBJIG1pbWljcyB0aGUg
YmVsb3cgc3RydWN0IGZyb20gdWFwaS92ZmlvLmgNCj4gWWVwIEkgbm90aWNlZCB0aGF0IGFmdGVy
d2FyZHMuIEluIElPTU1VIHVhcGkgaXQgbG9va3MgdGhlIG9wcG9zaXRlIHRob3VnaC4gU28gSQ0K
PiB3b3VsZCBhbGlnbnRvIHRoZSBzdHlsZSBpbiB0aGUgc2FtZSBmaWxlIGJ1dCB0aGF0J3Mgbm90
IGEgYmlnIGRlYWwuDQoNCkkgc2VlLCBtYXkgYWxpZ24gd2l0aCBvdGhlciBpb21tdSB1YXBpLiA6
LSkNCg0KUmVnYXJkcywNCllpIExpdQ0KDQo+ID4NCj4gPiBzdHJ1Y3QgdmZpb19pb21tdV90eXBl
MV9kbWFfbWFwIHsNCj4gPiAgICAgICAgIF9fdTMyICAgYXJnc3o7DQo+ID4gICAgICAgICBfX3Uz
MiAgIGZsYWdzOw0KPiA+ICNkZWZpbmUgVkZJT19ETUFfTUFQX0ZMQUdfUkVBRCAoMSA8PCAwKSAg
ICAgICAgIC8qIHJlYWRhYmxlIGZyb20gZGV2aWNlICovDQo+ID4gI2RlZmluZSBWRklPX0RNQV9N
QVBfRkxBR19XUklURSAoMSA8PCAxKSAgICAgICAgLyogd3JpdGFibGUgZnJvbSBkZXZpY2UgKi8N
Cj4gPiAgICAgICAgIF9fdTY0ICAgdmFkZHI7ICAgICAgICAgICAgICAgICAgICAgICAgICAvKiBQ
cm9jZXNzIHZpcnR1YWwgYWRkcmVzcyAqLw0KPiA+ICAgICAgICAgX191NjQgICBpb3ZhOyAgICAg
ICAgICAgICAgICAgICAgICAgICAgIC8qIElPIHZpcnR1YWwgYWRkcmVzcyAqLw0KPiA+ICAgICAg
ICAgX191NjQgICBzaXplOyAgICAgICAgICAgICAgICAgICAgICAgICAgIC8qIFNpemUgb2YgbWFw
cGluZyAoYnl0ZXMpICovDQo+ID4gfTsNCj4gPg0KPiA+Pj4gKwlfX3UzMglmbGFnczsNCj4gPj4+
ICsJX191MTYJYWRkcl93aWR0aDsNCj4gPj4+ICsJX191MTYJcGFzaWRfYml0czsNCj4gPj4+ICsJ
X191MzIJcGFkZGluZzsNCj4gPj4+ICsJX191OAlkYXRhW107DQo+ID4+PiArfTsNCj4gPj4+ICsN
Cj4gPj4+ICsvKg0KPiA+Pj4gKyAqIHN0cnVjdCBpb21tdV9uZXN0aW5nX2luZm9fdnRkIC0gSW50
ZWwgVlQtZCBzcGVjaWZpYyBuZXN0aW5nIGluZm8NCj4gPj4+ICsgKg0KPiA+PiBzcHVyaW91cyBs
aW5lDQo+ID4NCj4gPiB5ZXMsIHdpbGwgcmVtb3ZlIHRoaXMgbGluZS4NCj4gPg0KPiA+IFJlZ2Fy
ZHMsDQo+ID4gWWkgTGl1DQo+ID4NCj4gPj4+ICsgKg0KPiA+Pj4gKyAqIEBmbGFnczoJVlQtZCBz
cGVjaWZpYyBmbGFncy4gQ3VycmVudGx5IHJlc2VydmVkIGZvciBmdXR1cmUNCj4gPj4+ICsgKgkJ
ZXh0ZW5zaW9uLg0KPiA+Pj4gKyAqIEBjYXBfcmVnOglEZXNjcmliZSBiYXNpYyBjYXBhYmlsaXRp
ZXMgYXMgZGVmaW5lZCBpbiBWVC1kIGNhcGFiaWxpdHkNCj4gPj4+ICsgKgkJcmVnaXN0ZXIuDQo+
ID4+PiArICogQGVjYXBfcmVnOglEZXNjcmliZSB0aGUgZXh0ZW5kZWQgY2FwYWJpbGl0aWVzIGFz
IGRlZmluZWQgaW4gVlQtZA0KPiA+Pj4gKyAqCQlleHRlbmRlZCBjYXBhYmlsaXR5IHJlZ2lzdGVy
Lg0KPiA+Pj4gKyAqLw0KPiA+Pj4gK3N0cnVjdCBpb21tdV9uZXN0aW5nX2luZm9fdnRkIHsNCj4g
Pj4+ICsJX191MzIJZmxhZ3M7DQo+ID4+PiArCV9fdTMyCXBhZGRpbmc7DQo+ID4+PiArCV9fdTY0
CWNhcF9yZWc7DQo+ID4+PiArCV9fdTY0CWVjYXBfcmVnOw0KPiA+Pj4gK307DQo+ID4+PiArDQo+
ID4+PiAgI2VuZGlmIC8qIF9VQVBJX0lPTU1VX0ggKi8NCj4gPj4+DQo+ID4+IFRoYW5rcw0KPiA+
Pg0KPiA+PiBFcmljDQo+ID4NCj4gDQo+IFRoYW5rcw0KPiANCj4gRXJpYw0KDQo=
