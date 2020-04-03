Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55E8519D92B
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 16:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgDCOdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 10:33:03 -0400
Received: from mga05.intel.com ([192.55.52.43]:30210 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbgDCOdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 10:33:02 -0400
IronPort-SDR: BEfNXuKjwRM4v972A614CcAe9udUFJ8lqJujPRzGwEc3HZUJlD7k87kgyZrUs2mKGjn0TgstWV
 zKuKWw8mG/NA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 07:33:00 -0700
IronPort-SDR: nKqQBPM2pjbJRq2UmHiUnsjlo43jFfREYVzpnzZlEPDZR7j+o2gA7vPBClEZw1t1uh4TTPjkq8
 xT5uU5OHTXug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,340,1580803200"; 
   d="scan'208";a="329181331"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga001.jf.intel.com with ESMTP; 03 Apr 2020 07:32:59 -0700
Received: from fmsmsx115.amr.corp.intel.com (10.18.116.19) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 07:32:59 -0700
Received: from shsmsx105.ccr.corp.intel.com (10.239.4.158) by
 fmsmsx115.amr.corp.intel.com (10.18.116.19) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 07:32:59 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX105.ccr.corp.intel.com ([169.254.11.213]) with mapi id 14.03.0439.000;
 Fri, 3 Apr 2020 22:32:55 +0800
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
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>
Subject: RE: [PATCH v2 00/22] intel_iommu: expose Shared Virtual Addressing
 to VMs
Thread-Topic: [PATCH v2 00/22] intel_iommu: expose Shared Virtual Addressing
 to VMs
Thread-Index: AQHWBkpi4SFlYLfwBEaCXIDf+JnUMqhlofiAgAHaG1A=
Date:   Fri, 3 Apr 2020 14:32:55 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A220D6C@SHSMSX104.ccr.corp.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <20200402181255.GE103677@xz-x1>
In-Reply-To: <20200402181255.GE103677@xz-x1>
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

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgQXBy
aWwgMywgMjAyMCAyOjEzIEFNDQo+IFRvOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4N
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiAwMC8yMl0gaW50ZWxfaW9tbXU6IGV4cG9zZSBTaGFy
ZWQgVmlydHVhbCBBZGRyZXNzaW5nIHRvDQo+IFZNcw0KPiANCj4gT24gU3VuLCBNYXIgMjksIDIw
MjAgYXQgMDk6MjQ6MzlQTSAtMDcwMCwgTGl1IFlpIEwgd3JvdGU6DQo+ID4gVGVzdHM6IGJhc2Np
IHZTVkEgZnVuY3Rpb25hbGl0eSB0ZXN0LA0KPiANCj4gQ291bGQgeW91IGVsYWJvcmF0ZSB3aGF0
J3MgdGhlIGZ1bmN0aW9uYWxpdHkgdGVzdD8gIERvZXMgdGhhdCBjb250YWlucw0KPiBhdCBsZWFz
dCBzb21lIElPcyBnbyB0aHJvdWdoIHRoZSBTVkEtY2FwYWJsZSBkZXZpY2Ugc28gdGhlIG5lc3Rl
ZCBwYWdlDQo+IHRhYmxlIGlzIHVzZWQ/ICBJIHRob3VnaHQgaXQgd2FzIGEgeWVzLCBidXQgYWZ0
ZXIgSSBub3RpY2UgdGhhdCB0aGUNCj4gQklORCBtZXNzYWdlIGZsYWdzIHNlZW1zIHRvIGJlIHdy
b25nLCBJIHJlYWxseSB0aGluayBJIHNob3VsZCBhc2sgdGhpcw0KPiBsb3VkLi4NCg0KYXMganVz
dCByZXBsaWVkLCBpbiB0aGUgdmVyaWZpY2F0aW9uLCBvbmx5IHRoZSBTUkUgYml0IGlzIHVzZWQu
IFNvIGl0J3Mgbm90DQpzcG90dGVkLiBJbiBteSBmdW5jdGlvbmFsaXR5IHRlc3QsIEkndmUgcGFz
c3RocnUgYSBTVkEtY2FwYWJsZSBkZXZpY2UNCmFuZCBpc3N1ZSBTVkEgdHJhbnNhY3Rpb25zLg0K
DQo+ID4gVk0gcmVib290L3NodXRkb3duL2NyYXNoLA0KPiANCj4gV2hhdCdzIHRoZSBWTSBjcmFz
aCB0ZXN0Pw0KDQppdCdzIGN0cmwrYyB0byBraWxsIHRoZSBWTS4NCg0KPiA+IGtlcm5lbCBidWls
ZCBpbg0KPiA+IGd1ZXN0LCBib290IFZNIHdpdGggdlNWQSBkaXNhYmxlZCwgZnVsbCBjb21hcGls
YXRpb24gd2l0aCBhbGwgYXJjaHMuDQo+IA0KPiBJIGJlbGlldmUgSSd2ZSBzYWlkIHNpbWlsYXIg
dGhpbmdzLCBidXQuLi4gIEknZCBhcHByZWNpYXRlIGlmIHlvdSBjYW4NCj4gYWxzbyBzbW9rZSBv
biAybmQtbGV2ZWwgb25seSB3aXRoIHRoZSBzZXJpZXMgYXBwbGllZC4NCg0KeWVhaCwgeW91IG1l
YW4gdGhlIGxlZ2FjeSBjYXNlLCBJIGJvb3RlZCB3aXRoIHN1Y2ggY29uZmlnLg0KDQpSZWdhcmRz
LA0KWWkgTGl1DQo=
