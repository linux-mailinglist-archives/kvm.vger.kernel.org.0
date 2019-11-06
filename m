Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACFE7F10D6
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 09:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730065AbfKFIOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 03:14:23 -0500
Received: from mga03.intel.com ([134.134.136.65]:11329 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729881AbfKFIOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 03:14:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 00:14:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,274,1569308400"; 
   d="scan'208";a="205252047"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga003.jf.intel.com with ESMTP; 06 Nov 2019 00:14:21 -0800
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 00:14:21 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.213]) with mapi id 14.03.0439.000;
 Wed, 6 Nov 2019 16:14:19 +0800
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
Subject: RE: [RFC v2 12/22] intel_iommu: add present bit check for pasid
 table entries
Thread-Topic: [RFC v2 12/22] intel_iommu: add present bit check for pasid
 table entries
Thread-Index: AQHVims04dTSFqLNz0S2LC9QARGUe6d3mAmAgAZHUHA=
Date:   Wed, 6 Nov 2019 08:14:19 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0EEF68@SHSMSX104.ccr.corp.intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-13-git-send-email-yi.l.liu@intel.com>
 <20191102162051.GB26023@xz-x1.metropole.lan>
In-Reply-To: <20191102162051.GB26023@xz-x1.metropole.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZDc2MDg5Y2YtNzU4NS00ODBhLTg1YTQtZWI4YWNjYmYyOWJjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTTJHSTJRMlNZWmczaEdRbml4NEpMNUdqS0c4ZHUwZjdxWUpwcXZBaE1lUWtTVE9LQzhSWHhIeW1sY1NGTzBCQSJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSBbbWFpbHRvOnBldGVyeEByZWRoYXQuY29tXQ0KPiBTZW50OiBTdW5k
YXksIE5vdmVtYmVyIDMsIDIwMTkgMTI6MjEgQU0NCj4gVG86IExpdSwgWWkgTCA8eWkubC5saXVA
aW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1JGQyB2MiAxMi8yMl0gaW50ZWxfaW9tbXU6IGFk
ZCBwcmVzZW50IGJpdCBjaGVjayBmb3IgcGFzaWQgdGFibGUNCj4gZW50cmllcw0KPiANCj4gT24g
VGh1LCBPY3QgMjQsIDIwMTkgYXQgMDg6MzQ6MzNBTSAtMDQwMCwgTGl1IFlpIEwgd3JvdGU6DQo+
ID4gVGhlIHByZXNlbnQgYml0IGNoZWNrIGZvciBwYXNpZCBlbnRyeSAocGUpIGFuZCBwYXNpZCBk
aXJlY3RvcnkgZW50cnkNCj4gPiAocGRpcmUpIHdlcmUgbWlzc2VkIGluIHByZXZpb3VzIGNvbW1p
dHMgYXMgZnBkIGJpdCBjaGVjayBkb2Vzbid0DQo+ID4gcmVxdWlyZSBwcmVzZW50IGJpdCBhcyAi
U2V0Ii4gVGhpcyBwYXRjaCBhZGRzIHRoZSBwcmVzZW50IGJpdCBjaGVjaw0KPiA+IGZvciBjYWxs
ZXJzIHdoaWNoIHdhbnRzIHRvIGdldCBhIHZhbGlkIHBlL3BkaXJlLg0KPiA+DQo+ID4gQ2M6IEtl
dmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KPiA+IENjOiBKYWNvYiBQYW4gPGphY29i
Lmp1bi5wYW5AbGludXguaW50ZWwuY29tPg0KPiA+IENjOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhh
dC5jb20+DQo+ID4gQ2M6IFlpIFN1biA8eWkueS5zdW5AbGludXguaW50ZWwuY29tPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IExpdSBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+IA0KPiBSZXZpZXdl
ZC1ieTogUGV0ZXIgWHUgPHBldGVyeEByZWRoYXQuY29tPg0KDQpUaGFua3MgZm9yIHRoZSByZXZp
ZXcuDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg==
