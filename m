Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3569CF12CB
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 10:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731754AbfKFJup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 04:50:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:30882 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731680AbfKFJuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 04:50:44 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 01:50:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,274,1569308400"; 
   d="scan'208";a="212731022"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga001.fm.intel.com with ESMTP; 06 Nov 2019 01:50:43 -0800
Received: from fmsmsx118.amr.corp.intel.com (10.18.116.18) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 01:50:43 -0800
Received: from shsmsx105.ccr.corp.intel.com (10.239.4.158) by
 fmsmsx118.amr.corp.intel.com (10.18.116.18) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 01:50:42 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX105.ccr.corp.intel.com ([169.254.11.225]) with mapi id 14.03.0439.000;
 Wed, 6 Nov 2019 17:50:39 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v2 03/22] intel_iommu: modify x-scalable-mode to be string
 option
Thread-Topic: [RFC v2 03/22] intel_iommu: modify x-scalable-mode to be
 string option
Thread-Index: AQHVimsn7SVAI/DYekGpKA287OuKO6d17oaAgAZs2aD//7jAAIAB5aQQ
Date:   Wed, 6 Nov 2019 09:50:38 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0EF0E9@SHSMSX104.ccr.corp.intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-4-git-send-email-yi.l.liu@intel.com>
 <20191101145753.GC8888@xz-x1.metropole.lan>
 <A2975661238FB949B60364EF0F2C25743A0EE30A@SHSMSX104.ccr.corp.intel.com>
 <20191105125000.GE12619@xz-x1>
In-Reply-To: <20191105125000.GE12619@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiM2RiMTg0YzMtZjU3Ni00NmFkLWI1NWItMmM5NGVmODIyMWM5IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiajZSc1ZOMHRxXC95ZWJrQURyMG04UCtjZGs3KzBsQmJwTGZhRGFOeEZrSFwvVVJTaWw3bXVrRVN4ZW8wbVI4aFQ1In0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSBbbWFpbHRvOnBldGVyeEByZWRoYXQuY29tXQ0KPiBTZW50OiBUdWVz
ZGF5LCBOb3ZlbWJlciA1LCAyMDE5IDg6NTAgUE0NCj4gVG86IExpdSwgWWkgTCA8eWkubC5saXVA
aW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1JGQyB2MiAwMy8yMl0gaW50ZWxfaW9tbXU6IG1v
ZGlmeSB4LXNjYWxhYmxlLW1vZGUgdG8gYmUgc3RyaW5nIG9wdGlvbg0KPiANCj4gT24gVHVlLCBO
b3YgMDUsIDIwMTkgYXQgMDk6MTQ6MDhBTSArMDAwMCwgTGl1LCBZaSBMIHdyb3RlOg0KPiA+ID4g
U29tZXRoaW5nIGxpa2U6DQo+ID4gPg0KPiA+ID4gICAtIHMtPnNjYWxhYmxlX21vZGVfc3RyIHRv
IGtlZXAgdGhlIHN0cmluZw0KPiA+ID4gICAtIHMtPnNjYWxhYmxlX21vZGUgc3RpbGwgYXMgYSBi
b29sIHRvIGNhY2hlIHRoZSBnbG9iYWwgZW5hYmxlbWVudA0KPiA+ID4gICAtIHMtPnNjYWxhYmxl
X21vZGVybiBhcyBhIGJvb2wgdG8ga2VlcCB0aGUgbW9kZQ0KPiA+ID4NCj4gPiA+ID8NCj4gPg0K
PiA+IFNvIHgtc2NhbGFibGUtbW9kZSBpcyBzdGlsbCBhIHN0cmluZyBvcHRpb24sIGp1c3QgdG8g
aGF2ZSBhIG5ldyBmaWVsZCB0byBzdG9yZSBpdD8NCj4gDQo+IFllcC4gIEknZCBzYXkgbWF5YmUg
d2Ugc2hvdWxkIHN0YXJ0IHRvIGFsbG93IHRvIGRlZmluZSBzb21lIHVuaW9uLWlzaCBwcm9wZXJ0
aWVzLCBidXQNCj4gZm9yIG5vdyBJIHRoaW5rIHN0cmluZyBpcyBvay4NCg0Kb2ssIGxldCBtZSBt
YWtlIGl0IGluIG5leHQgdmVyc2lvbi4NCg0KVGhhbmtzLA0KWWkgTGl1DQo=
