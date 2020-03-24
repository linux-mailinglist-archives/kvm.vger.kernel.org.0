Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 438A8190A1C
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 11:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgCXKCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 06:02:09 -0400
Received: from mga12.intel.com ([192.55.52.136]:51055 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgCXKCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 06:02:09 -0400
IronPort-SDR: id4SfLnlWoCLL9IqQ8nGRWgrCYA4hSpCRk0nvDxN6T856D6BSbX3LGleaiD5ZLlVruB1VBU5q5
 HuED6HczVoEw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 03:02:09 -0700
IronPort-SDR: 3hxktaP9YRptOTJ7L3AO8JGLWaBUQxVraDh4maKiTemZEp3c2qLAEiv1gD0jEDUsfUuDhJDL+Z
 Au9hFwCFRVkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,300,1580803200"; 
   d="scan'208";a="446165953"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga005.fm.intel.com with ESMTP; 24 Mar 2020 03:02:09 -0700
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 24 Mar 2020 03:02:09 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.96]) with mapi id 14.03.0439.000;
 Tue, 24 Mar 2020 18:02:05 +0800
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
Subject: RE: [PATCH v1 06/22] hw/pci: introduce
 pci_device_set/unset_iommu_context()
Thread-Topic: [PATCH v1 06/22] hw/pci: introduce
 pci_device_set/unset_iommu_context()
Thread-Index: AQHWAEW1Ny26yVgYEkqv+QbSE9Yz16hWKZuAgAFcIHA=
Date:   Tue, 24 Mar 2020 10:02:04 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A200286@SHSMSX104.ccr.corp.intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-7-git-send-email-yi.l.liu@intel.com>
 <20200323211509.GP127076@xz-x1>
In-Reply-To: <20200323211509.GP127076@xz-x1>
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
cmNoIDI0LCAyMDIwIDU6MTUgQU0NCj4gVG86IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwuY29t
Pg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxIDA2LzIyXSBody9wY2k6IGludHJvZHVjZQ0KPiBw
Y2lfZGV2aWNlX3NldC91bnNldF9pb21tdV9jb250ZXh0KCkNCj4gDQo+IE9uIFN1biwgTWFyIDIy
LCAyMDIwIGF0IDA1OjM2OjAzQU0gLTA3MDAsIExpdSBZaSBMIHdyb3RlOg0KPiANCj4gWy4uLl0N
Cj4gDQo+ID4gK0FkZHJlc3NTcGFjZSAqcGNpX2RldmljZV9pb21tdV9hZGRyZXNzX3NwYWNlKFBD
SURldmljZSAqZGV2KSB7DQo+ID4gKyAgICBQQ0lCdXMgKmJ1czsNCj4gPiArICAgIHVpbnQ4X3Qg
ZGV2Zm47DQo+ID4gKw0KPiA+ICsgICAgcGNpX2RldmljZV9nZXRfaW9tbXVfYnVzX2RldmZuKGRl
diwgJmJ1cywgJmRldmZuKTsNCj4gPiArICAgIGlmIChidXMgJiYgYnVzLT5pb21tdV9vcHMgJiYN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgYnVzLT5pb21tdV9vcHMtPmdldF9hZGRyZXNzX3Nw
YWNlKSB7DQo+IA0KPiBOaXQ6IFNpbmNlIHdlJ3JlIG1vdmluZyBpdCBhcm91bmQsIG1heWJlIHJl
LWFsaWduIGl0IHRvIGxlZnQgYnJhY2tldD8NCj4gU2FtZSB0byBiZWxvdyB0d28gcGxhY2VzLg0K
DQpnb3QgaXQuIHdpbGwgZG8gaXQuDQoNCj4gV2l0aCB0aGUgaW5kZW50IGZpeGVkOg0KPiANCj4g
UmV2aWV3ZWQtYnk6IFBldGVyIFh1IDxwZXRlcnhAcmVkaGF0LmNvbT4NCg0KVGhhbmtzIGZvciB0
aGUgY29tbWVudHMuDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg0K
