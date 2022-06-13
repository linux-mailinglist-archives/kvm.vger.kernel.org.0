Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6627354806C
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 09:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239263AbiFMH0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 03:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbiFMH0x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 03:26:53 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A481AD8B;
        Mon, 13 Jun 2022 00:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655105212; x=1686641212;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cvLueTdmhN3hJgNVAvOLkfvWJp0QJnKpGRgdoW7g6VE=;
  b=nfRSQvRQpDQv+Q6YJ1mC2M6tWlpno4GogSkgD2LFC2EPr11am+Zanjvv
   Ol0LQQRe3DAyQvVUn1qhyTU4/O1e6NFafDX9xJN+GMOJdkEV6gcBJqtiV
   IAxIY2BvR55bJ6U77VsmuK8TF+ydQnny8YGaFNUnRQj22bvwQUdio40Gg
   wmUH/feKABVAPrnWmaF/D1b+qMSUJsZd0BoE6cZxOQpr/TBH5xWInwfBd
   XklN/4kvpUWufsOHSYe1CzKRntGlpiSlbw3SWYAtquO+Uvu9aWOKyjoD+
   fsf0IuXsk9FzpL7BOBYvyv/uULNkANGXGttH8ee58lbxngDGWEZcUjMrs
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10376"; a="275728700"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="275728700"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 00:26:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="582101815"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 13 Jun 2022 00:26:52 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 13 Jun 2022 00:26:51 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 13 Jun 2022 00:26:51 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2308.027;
 Mon, 13 Jun 2022 00:26:51 -0700
From:   "Sang, Oliver" <oliver.sang@intel.com>
To:     "Qiang, Chenyi" <chenyi.qiang@intel.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Chen, Farrah" <farrah.chen@intel.com>,
        "Wei, Danmei" <danmei.wei@intel.com>,
        "lkp@lists.01.org" <lkp@lists.01.org>, lkp <lkp@intel.com>,
        "Hao, Xudong" <xudong.hao@intel.com>
Subject: RE: [KVM]  a5202946dc: kernel-selftests.kvm.make_fail
Thread-Topic: [KVM]  a5202946dc: kernel-selftests.kvm.make_fail
Thread-Index: AQHYfsSs2wejXgf5QkCfnMMhu7wPqK1NLIaA///Dp1A=
Date:   Mon, 13 Jun 2022 07:26:51 +0000
Message-ID: <d16188160405497a9ea9b206e4178730@intel.com>
References: <20220613012644.GA7252@xsang-OptiPlex-9020>
 <SA2PR11MB50525D04633E934148F8132781AB9@SA2PR11MB5052.namprd11.prod.outlook.com>
In-Reply-To: <SA2PR11MB50525D04633E934148F8132781AB9@SA2PR11MB5052.namprd11.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
x-originating-ip: [10.239.127.36]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgQ2hlbnlpLA0KDQo+IEZyb206IFFpYW5nLCBDaGVueWkgPGNoZW55aS5xaWFuZ0BpbnRlbC5j
b20+DQo+IFNlbnQ6IE1vbmRheSwgSnVuZSAxMywgMjAyMiAxMjowMiBQTQ0KPiANCj4gSGkgT2xp
dmVyDQo+IA0KPiBJIGZvdW5kIHRoaXMgaXNzdWUgaXMgYWxyZWFkeSBmaXhlZCBieSBTZWFuIGlu
IHF1ZXVlIGJyYW5jaC4gVGhhbmtzIGZvciB5b3VyDQo+IHRlc3RpbmcgYW5kIHJlcG9ydC4NCg0K
VGhhbmtzIGEgbG90IGZvciBpbmZvcm1hdGlvbiENCg0KPiANCj4gVGhhbmtzDQo+IENoZW55aQ0K
PiANCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FuZywgT2xpdmVyIDxv
bGl2ZXIuc2FuZ0BpbnRlbC5jb20+DQo+IFNlbnQ6IE1vbmRheSwgSnVuZSAxMywgMjAyMiA5OjI3
IEFNDQo+IFRvOiBRaWFuZywgQ2hlbnlpIDxjaGVueWkucWlhbmdAaW50ZWwuY29tPg0KPiBDYzog
UGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT47IENocmlzdG9waGVyc29uLCwgU2Vh
bg0KPiA8c2VhbmpjQGdvb2dsZS5jb20+OyBMS01MIDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnPjsNCj4ga3ZtQHZnZXIua2VybmVsLm9yZzsgSHUsIFJvYmVydCA8cm9iZXJ0Lmh1QGludGVs
LmNvbT47IENoZW4sIEZhcnJhaA0KPiA8ZmFycmFoLmNoZW5AaW50ZWwuY29tPjsgV2VpLCBEYW5t
ZWkgPGRhbm1laS53ZWlAaW50ZWwuY29tPjsNCj4gbGtwQGxpc3RzLjAxLm9yZzsgbGtwIDxsa3BA
aW50ZWwuY29tPjsgSGFvLCBYdWRvbmcgPHh1ZG9uZy5oYW9AaW50ZWwuY29tPg0KPiBTdWJqZWN0
OiBbS1ZNXSBhNTIwMjk0NmRjOiBrZXJuZWwtc2VsZnRlc3RzLmt2bS5tYWtlX2ZhaWwNCj4gDQo+
IA0KPiANCj4gR3JlZXRpbmcsDQo+IA0KPiBGWUksIHdlIG5vdGljZWQgdGhlIGZvbGxvd2luZyBj
b21taXQgKGJ1aWx0IHdpdGggZ2NjLTExKToNCj4gDQo+IGNvbW1pdDogYTUyMDI5NDZkYzdiMjBi
ZjJhYmUxYmQzNWFkZjJmNDZhYTE1NWFjMCAoIktWTTogc2VsZnRlc3RzOiBBZGQgYQ0KPiB0ZXN0
IHRvIGdldC9zZXQgdHJpcGxlIGZhdWx0IGV2ZW50IikgaHR0cHM6Ly9naXQua2VybmVsLm9yZy9j
Z2l0L3ZpcnQva3ZtL2t2bS5naXQNCj4gbGJyLWZvci13ZWlqaWFuZw0KPiANCj4gaW4gdGVzdGNh
c2U6IGtlcm5lbC1zZWxmdGVzdHMNCj4gdmVyc2lvbjoga2VybmVsLXNlbGZ0ZXN0cy14ODZfNjQt
ZDg4OWIxNTEtMV8yMDIyMDYwOA0KPiB3aXRoIGZvbGxvd2luZyBwYXJhbWV0ZXJzOg0KPiANCj4g
CWdyb3VwOiBrdm0NCj4gCXVjb2RlOiAweGVjDQo+IA0KPiB0ZXN0LWRlc2NyaXB0aW9uOiBUaGUg
a2VybmVsIGNvbnRhaW5zIGEgc2V0IG9mICJzZWxmIHRlc3RzIiB1bmRlciB0aGUNCj4gdG9vbHMv
dGVzdGluZy9zZWxmdGVzdHMvIGRpcmVjdG9yeS4gVGhlc2UgYXJlIGludGVuZGVkIHRvIGJlIHNt
YWxsIHVuaXQgdGVzdHMgdG8NCj4gZXhlcmNpc2UgaW5kaXZpZHVhbCBjb2RlIHBhdGhzIGluIHRo
ZSBrZXJuZWwuDQo+IHRlc3QtdXJsOiBodHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9Eb2N1bWVu
dGF0aW9uL2tzZWxmdGVzdC50eHQNCj4gDQo+IA0KPiBvbiB0ZXN0IG1hY2hpbmU6IDggdGhyZWFk
cyBJbnRlbChSKSBDb3JlKFRNKSBpNy02NzAwIENQVSBAIDMuNDBHSHogd2l0aCAyOEcNCj4gbWVt
b3J5DQo+IA0KPiBjYXVzZWQgYmVsb3cgY2hhbmdlcyAocGxlYXNlIHJlZmVyIHRvIGF0dGFjaGVk
IGRtZXNnL2ttc2cgZm9yIGVudGlyZQ0KPiBsb2cvYmFja3RyYWNlKToNCj4gDQo+IA0KPiANCj4g
DQo+IElmIHlvdSBmaXggdGhlIGlzc3VlLCBraW5kbHkgYWRkIGZvbGxvd2luZyB0YWcNCj4gUmVw
b3J0ZWQtYnk6IGtlcm5lbCB0ZXN0IHJvYm90IDxvbGl2ZXIuc2FuZ0BpbnRlbC5jb20+DQo+IA0K
PiANCj4gDQo+IGdjYyAtV2FsbCAtV3N0cmljdC1wcm90b3R5cGVzIC1XdW5pbml0aWFsaXplZCAt
TzIgLWcgLXN0ZD1nbnU5OSAtZm5vLXN0YWNrLQ0KPiBwcm90ZWN0b3IgLWZuby1QSUUgLUkuLi8u
Li8uLi8uLi90b29scy9pbmNsdWRlIC1JLi4vLi4vLi4vLi4vdG9vbHMvYXJjaC94ODYvaW5jbHVk
ZSAtDQo+IEkuLi8uLi8uLi8uLi91c3IvaW5jbHVkZS8gLUlpbmNsdWRlIC1JeDg2XzY0IC1JaW5j
bHVkZS94ODZfNjQgLUkuLiAgICAtcHRocmVhZCAgLW5vLXBpZQ0KPiB4ODZfNjQvdHJpcGxlX2Zh
dWx0X2V2ZW50X3Rlc3QuYyAvdXNyL3NyYy9wZXJmX3NlbGZ0ZXN0cy14ODZfNjQtcmhlbC04LjMt
DQo+IGtzZWxmdGVzdHMtDQo+IGE1MjAyOTQ2ZGM3YjIwYmYyYWJlMWJkMzVhZGYyZjQ2YWExNTVh
YzAvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2xpYmsNCj4gdm0uYSAgLW8gL3Vzci9zcmMv
cGVyZl9zZWxmdGVzdHMteDg2XzY0LXJoZWwtOC4zLWtzZWxmdGVzdHMtDQo+IGE1MjAyOTQ2ZGM3
YjIwYmYyYWJlMWJkMzVhZGYyZjQ2YWExNTVhYzAvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3Zt
L3g4Ng0KPiBfNjQvdHJpcGxlX2ZhdWx0X2V2ZW50X3Rlc3QNCj4geDg2XzY0L3RyaXBsZV9mYXVs
dF9ldmVudF90ZXN0LmM6IEluIGZ1bmN0aW9uIOKAmG1haW7igJk6DQo+IHg4Nl82NC90cmlwbGVf
ZmF1bHRfZXZlbnRfdGVzdC5jOjUwOjEwOiBlcnJvcjoNCj4g4oCYS1ZNX0NBUF9UUklQTEVfRkFV
TFRfRVZFTlTigJkgdW5kZWNsYXJlZCAoZmlyc3QgdXNlIGluIHRoaXMgZnVuY3Rpb24pOyBkaWQg
eW91DQo+IG1lYW4g4oCYS1ZNX0NBUF9YODZfVFJJUExFX0ZBVUxUX0VWRU5U4oCZPw0KPiAgICA1
MCB8ICAgLmNhcCA9IEtWTV9DQVBfVFJJUExFX0ZBVUxUX0VWRU5ULA0KPiAgICAgICB8ICAgICAg
ICAgIF5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+DQo+ICAgICAgIHwgICAgICAgICAgS1ZNX0NB
UF9YODZfVFJJUExFX0ZBVUxUX0VWRU5UDQo+IHg4Nl82NC90cmlwbGVfZmF1bHRfZXZlbnRfdGVz
dC5jOjUwOjEwOiBub3RlOiBlYWNoIHVuZGVjbGFyZWQgaWRlbnRpZmllciBpcw0KPiByZXBvcnRl
ZCBvbmx5IG9uY2UgZm9yIGVhY2ggZnVuY3Rpb24gaXQgYXBwZWFycyBpbg0KPiBtYWtlOiAqKiog
Wy4uL2xpYi5tazoxNTI6IC91c3Ivc3JjL3BlcmZfc2VsZnRlc3RzLXg4Nl82NC1yaGVsLTguMy1r
c2VsZnRlc3RzLQ0KPiBhNTIwMjk0NmRjN2IyMGJmMmFiZTFiZDM1YWRmMmY0NmFhMTU1YWMwL3Rv
b2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS94ODYNCj4gXzY0L3RyaXBsZV9mYXVsdF9ldmVudF90
ZXN0XSBFcnJvciAxDQo+IG1ha2U6IExlYXZpbmcgZGlyZWN0b3J5ICcvdXNyL3NyYy9wZXJmX3Nl
bGZ0ZXN0cy14ODZfNjQtcmhlbC04LjMta3NlbGZ0ZXN0cy0NCj4gYTUyMDI5NDZkYzdiMjBiZjJh
YmUxYmQzNWFkZjJmNDZhYTE1NWFjMC90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0nDQo+IA0K
PiANCj4gDQo+IFRvIHJlcHJvZHVjZToNCj4gDQo+ICAgICAgICAgZ2l0IGNsb25lIGh0dHBzOi8v
Z2l0aHViLmNvbS9pbnRlbC9sa3AtdGVzdHMuZ2l0DQo+ICAgICAgICAgY2QgbGtwLXRlc3RzDQo+
ICAgICAgICAgc3VkbyBiaW4vbGtwIGluc3RhbGwgam9iLnlhbWwgICAgICAgICAgICMgam9iIGZp
bGUgaXMgYXR0YWNoZWQgaW4gdGhpcyBlbWFpbA0KPiAgICAgICAgIGJpbi9sa3Agc3BsaXQtam9i
IC0tY29tcGF0aWJsZSBqb2IueWFtbCAjIGdlbmVyYXRlIHRoZSB5YW1sIGZpbGUgZm9yIGxrcCBy
dW4NCj4gICAgICAgICBzdWRvIGJpbi9sa3AgcnVuIGdlbmVyYXRlZC15YW1sLWZpbGUNCj4gDQo+
ICAgICAgICAgIyBpZiBjb21lIGFjcm9zcyBhbnkgZmFpbHVyZSB0aGF0IGJsb2NrcyB0aGUgdGVz
dCwNCj4gICAgICAgICAjIHBsZWFzZSByZW1vdmUgfi8ubGtwIGFuZCAvbGtwIGRpciB0byBydW4g
ZnJvbSBhIGNsZWFuIHN0YXRlLg0KPiANCj4gDQo+IA0KPiAtLQ0KPiAwLURBWSBDSSBLZXJuZWwg
VGVzdCBTZXJ2aWNlDQo+IGh0dHBzOi8vMDEub3JnL2xrcA0KPiANCj4gDQoNCg==
