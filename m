Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1786190C47
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 12:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgCXLTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 07:19:04 -0400
Received: from mga03.intel.com ([134.134.136.65]:65367 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726911AbgCXLTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 07:19:04 -0400
IronPort-SDR: wBZMDvowo+SDu/vQTJKb81RvEye/nHar4ckwHFg4orNX7tSD7B7ME2I+pADewYj4lg1bLdeSVz
 SPRYr1GRK0lw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 04:19:03 -0700
IronPort-SDR: H+pji3yQ8v4Usbv7c8Q43RSLYLQWzfSoZ9yDokfdhYLywsvyUPwWr65OVvLnAVwmX7QNbvbfFo
 e/aMqcwipizA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,300,1580803200"; 
   d="scan'208";a="447845405"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga006.fm.intel.com with ESMTP; 24 Mar 2020 04:19:03 -0700
Received: from shsmsx105.ccr.corp.intel.com (10.239.4.158) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 24 Mar 2020 04:19:02 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 SHSMSX105.ccr.corp.intel.com ([169.254.11.144]) with mapi id 14.03.0439.000;
 Tue, 24 Mar 2020 19:18:59 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [PATCH v1 09/22] vfio/common: check PASID alloc/free
 availability
Thread-Topic: [PATCH v1 09/22] vfio/common: check PASID alloc/free
 availability
Thread-Index: AQHWAEW15Jx0RCLPSU2RY4n7wVdCtqhWOBCAgAFjAVA=
Date:   Tue, 24 Mar 2020 11:18:58 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A200444@SHSMSX104.ccr.corp.intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-10-git-send-email-yi.l.liu@intel.com>
 <20200323220653.GT127076@xz-x1>
In-Reply-To: <20200323220653.GT127076@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIE1h
cmNoIDI0LCAyMDIwIDY6MDcgQU0NCj4gVG86IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwuY29t
Pg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxIDA5LzIyXSB2ZmlvL2NvbW1vbjogY2hlY2sgUEFT
SUQgYWxsb2MvZnJlZSBhdmFpbGFiaWxpdHkNCj4gDQo+IE9uIFN1biwgTWFyIDIyLCAyMDIwIGF0
IDA1OjM2OjA2QU0gLTA3MDAsIExpdSBZaSBMIHdyb3RlOg0KPiANCj4gWy4uLl0NCj4gDQo+ID4g
QEAgLTEyNTYsMTEgKzEzMzQsMTkgQEAgc3RhdGljIGludCB2ZmlvX2luaXRfY29udGFpbmVyKFZG
SU9Db250YWluZXINCj4gKmNvbnRhaW5lciwgaW50IGdyb3VwX2ZkLA0KPiA+ICAgICAgfQ0KPiA+
DQo+ID4gICAgICBpZiAoaW9tbXVfdHlwZSA9PSBWRklPX1RZUEUxX05FU1RJTkdfSU9NTVUpIHsN
Cj4gPiAtICAgICAgICAvKg0KPiA+IC0gICAgICAgICAqIFRPRE86IGNvbmZpZyBmbGFncyBwZXIg
aG9zdCBJT01NVSBuZXN0aW5nIGNhcGFiaWxpdHkNCj4gPiAtICAgICAgICAgKiBlLmcuIGNoZWNr
IGlmIFZGSU9fVFlQRTFfTkVTVElOR19JT01NVSBzdXBwb3J0cyBQQVNJRA0KPiA+IC0gICAgICAg
ICAqIGFsbG9jL2ZyZWUNCj4gPiAtICAgICAgICAgKi8NCj4gPiArICAgICAgICBzdHJ1Y3QgdmZp
b19pb21tdV90eXBlMV9pbmZvX2NhcF9uZXN0aW5nIG5lc3RpbmcgPSB7DQo+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLm5lc3RpbmdfY2FwYWJpbGl0aWVzID0g
MHgwLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC5zdGFn
ZTFfZm9ybWF0cyA9IDAsIH07DQo+ID4gKw0KPiA+ICsgICAgICAgIHJldCA9IHZmaW9fZ2V0X25l
c3RpbmdfaW9tbXVfY2FwKGNvbnRhaW5lciwgJm5lc3RpbmcpOw0KPiA+ICsgICAgICAgIGlmIChy
ZXQpIHsNCj4gPiArICAgICAgICAgICAgZXJyb3Jfc2V0Z19lcnJubyhlcnJwLCAtcmV0LA0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJGYWlsZWQgdG8gZ2V0IG5lc3RpbmcgaW9t
bXUgY2FwIik7DQo+ID4gKyAgICAgICAgICAgIHJldHVybiByZXQ7DQo+ID4gKyAgICAgICAgfQ0K
PiA+ICsNCj4gPiArICAgICAgICBmbGFncyB8PSAobmVzdGluZy5uZXN0aW5nX2NhcGFiaWxpdGll
cyAmIFZGSU9fSU9NTVVfUEFTSURfUkVRUykgPw0KPiA+ICsgICAgICAgICAgICAgICAgIEhPU1Rf
SU9NTVVfUEFTSURfUkVRVUVTVCA6IDA7DQo+IA0KPiBJIHJlcGxpZWQgaW4gdGhlIHByZXZpb3Vz
IHBhdGNoIGJ1dCBJIGZvcmdvdCB0byB1c2UgcmVwbHktYWxsLi4uDQo+IA0KPiBBbnl3YXkgSSds
bCBjb21tZW50IGFnYWluIGhlcmUgLSBJIHRoaW5rIGl0J2xsIGJlIHNsaWdodGx5IGJldHRlciB3
ZQ0KPiB1c2UgdGhlIHByZXZpb3VzIHBhdGNoIHRvIG9ubHkgb2ZmZXIgdGhlIHZmaW8gc3BlY2lm
aWMgaG9va3MsIGFuZCB0aGlzDQo+IHBhdGNoIHRvIGRvIGFsbCB0aGUgcmVzdCBpbmNsdWRpbmcg
aG9zdF9pb21tdV9jdHhfaW5pdCgpIGJlbG93LCB3aGljaA0KPiB3aWxsIGF2b2lkIGNyZWF0aW5n
IHRoZSBob3N0X2lvbW11X2N0eF9pbml0KCkuDQoNCkdvdCBpdC4gTGV0IG1lIGRvIGl0IGluIG5l
eHQgdmVyc2lvbi4NCg0KUmVnYXJkcywNCllpIExpdQ0K
