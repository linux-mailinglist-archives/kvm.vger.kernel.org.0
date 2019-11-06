Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1994BF14A0
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 12:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbfKFLIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 06:08:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:37053 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfKFLIu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 06:08:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 03:08:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,274,1569308400"; 
   d="scan'208";a="232836361"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga002.fm.intel.com with ESMTP; 06 Nov 2019 03:08:50 -0800
Received: from fmsmsx153.amr.corp.intel.com (10.18.125.6) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 03:08:49 -0800
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 FMSMSX153.amr.corp.intel.com (10.18.125.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 03:08:49 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.149]) with mapi id 14.03.0439.000;
 Wed, 6 Nov 2019 19:08:47 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
Subject: RE: [RFC v2 05/22] vfio/common: add iommu_ctx_notifier in container
Thread-Topic: [RFC v2 05/22] vfio/common: add iommu_ctx_notifier in container
Thread-Index: AQHVimspAF8thUJhUUeOxjDX+6mnpqd17sgAgAghT/A=
Date:   Wed, 6 Nov 2019 11:08:46 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0EF188@SHSMSX104.ccr.corp.intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-6-git-send-email-yi.l.liu@intel.com>
 <20191101145848.GD8888@xz-x1.metropole.lan>
In-Reply-To: <20191101145848.GD8888@xz-x1.metropole.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYjVmNzI5M2QtZWQ3Zi00OGYxLTg5NDUtMWE3MjdlZGRiYmZiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiMU00UVVnemVqUmJpYjVnc2REXC9mR1Z5SlhXRTJmVUJNWFFUSTJQVitXcGhVTllwUzZcL3VTTWpWNlBMVmdYSEF6In0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdQ0KPiBTZW50OiBGcmlkYXksIE5vdmVtYmVyIDEsIDIwMTkgMTA6NTkg
UE0NCj4gVG86IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTog
W1JGQyB2MiAwNS8yMl0gdmZpby9jb21tb246IGFkZCBpb21tdV9jdHhfbm90aWZpZXIgaW4gY29u
dGFpbmVyDQo+IA0KPiBPbiBUaHUsIE9jdCAyNCwgMjAxOSBhdCAwODozNDoyNkFNIC0wNDAwLCBM
aXUgWWkgTCB3cm90ZToNCj4gDQo+IFsuLi5dDQo+IA0KPiA+ICt0eXBlZGVmIHN0cnVjdCBWRklP
SU9NTVVDb250ZXh0IHsNCj4gPiArICAgIFZGSU9Db250YWluZXIgKmNvbnRhaW5lcjsNCj4gPiAr
ICAgIElPTU1VQ29udGV4dCAqaW9tbXVfY3R4Ow0KPiA+ICsgICAgSU9NTVVDVFhOb3RpZmllciBu
Ow0KPiA+ICsgICAgUUxJU1RfRU5UUlkoVkZJT0lPTU1VQ29udGV4dCkgaW9tbXVfY3R4X25leHQ7
IH0gVkZJT0lPTU1VQ29udGV4dDsNCj4gPiArDQo+IA0KPiBObyBzdHJvbmcgb3BpbmlvbiBvbiB0
aGlzIC0gYnV0IGZvciBtZSBpdCB3b3VsZCBiZSBtb3JlIG1lYW5pbmdmdWwgdG8gc3F1YXNoIHRo
aXMNCj4gcGF0Y2ggaW50byB3aGVyZSB0aGlzIHN0cnVjdCBpcyBmaXJzdGx5IHVzZWQuDQoNCmdv
dCBpdC4gd2lsbCBtYWtlIGl0IGluIG5leHQgdmVyc2lvbi4NCg0KUmVnYXJkcywNCllpIExpdQ0K
