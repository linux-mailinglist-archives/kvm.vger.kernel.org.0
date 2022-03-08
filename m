Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55ACB4D230B
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 22:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350303AbiCHVHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 16:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241424AbiCHVH3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 16:07:29 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2784738D;
        Tue,  8 Mar 2022 13:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646773592; x=1678309592;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=53HBdKKy+le9OULBY+tX1mgqaWu0Id7yvZra0Kq/3Vg=;
  b=SWUar2XxlXJw33LdausCNbdTrpBvJ0zSWtfveFGmAgxje2D04dG2Htr2
   SgNEELq443kIDVYsGrggY6w2YSL2h8Ftn8ES3PlAHirFQ6qUCYrk33voj
   IhuIm6x278BtQuXM2J3jRMNdrhKYSI51uvQXR4f2DLiyNH0CX8yVzW8FO
   m76TilukMlEQbaFuIgXEVux8zazCiHRFF9nAdriUjRyl3MGHUNpiMlHry
   uZWtF2EXtroZOnr5R4Gdq24P5yAMGMpRr9V6YlQeHY0k3yzPzoaMdMTK8
   6ZIrifMyJxHSTc42EJL4wot9Drp5DjEYSWHbgNLgvRqS1vUgnONh1Nm8X
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="315531944"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="315531944"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 13:06:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="513267302"
Received: from irsmsx605.ger.corp.intel.com ([163.33.146.138])
  by orsmga006.jf.intel.com with ESMTP; 08 Mar 2022 13:06:27 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 IRSMSX605.ger.corp.intel.com (163.33.146.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 21:06:26 +0000
Received: from orsmsx611.amr.corp.intel.com ([10.22.229.24]) by
 ORSMSX611.amr.corp.intel.com ([10.22.229.24]) with mapi id 15.01.2308.021;
 Tue, 8 Mar 2022 13:06:24 -0800
From:   "Hall, Christopher S" <christopher.s.hall@intel.com>
To:     "Hunter, Adrian" <adrian.hunter@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
CC:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        H Peter Anvin <hpa@zytor.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Leo Yan" <leo.yan@linaro.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "sdeep@vmware.com" <sdeep@vmware.com>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Andrew.Cooper3@citrix.com" <Andrew.Cooper3@citrix.com>
Subject: RE: [PATCH V2 03/11] perf/x86: Add support for TSC in nanoseconds as
 a perf event clock
Thread-Topic: [PATCH V2 03/11] perf/x86: Add support for TSC in nanoseconds as
 a perf event clock
Thread-Index: AQHYMjGQwHF+1jrIb0imwpV8b7O+FKy2EdUA///IiFA=
Date:   Tue, 8 Mar 2022 21:06:24 +0000
Message-ID: <6f07a7d4e1ad4440bf6c502c8cb6c2ed@intel.com>
References: <20220214110914.268126-1-adrian.hunter@intel.com>
 <20220214110914.268126-4-adrian.hunter@intel.com>
 <YiIXFmA4vpcTSk2L@hirez.programming.kicks-ass.net>
 <853ce127-25f0-d0fe-1d8f-0b0dd4f3ce71@intel.com>
 <YiXVgEk/1UClkygX@hirez.programming.kicks-ass.net>
 <30383f92-59cb-2875-1e1b-ff1a0eacd235@intel.com>
 <YiYZv+LOmjzi5wcm@hirez.programming.kicks-ass.net>
 <013b5425-2a60-e4d4-b846-444a576f2b28@intel.com>
In-Reply-To: <013b5425-2a60-e4d4-b846-444a576f2b28@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.401.20
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QWRyaWFuIEh1bnRlciB3cm90ZToNCj4gT24gNy4zLjIwMjIgMTYuNDIsIFBldGVyIFppamxzdHJh
IHdyb3RlOg0KPiA+IE9uIE1vbiwgTWFyIDA3LCAyMDIyIGF0IDAyOjM2OjAzUE0gKzAyMDAsIEFk
cmlhbiBIdW50ZXIgd3JvdGU6DQo+ID4NCj4gPj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJu
ZWwvcGFyYXZpcnQuYyBiL2FyY2gveDg2L2tlcm5lbC9wYXJhdmlydC5jDQo+ID4+PiBpbmRleCA0
NDIwNDk5ZjdiYjQuLmExZjE3OWVkMzliZiAxMDA2NDQNCj4gPj4+IC0tLSBhL2FyY2gveDg2L2tl
cm5lbC9wYXJhdmlydC5jDQo+ID4+PiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvcGFyYXZpcnQuYw0K
PiA+Pj4gQEAgLTE0NSw2ICsxNDUsMTUgQEAgREVGSU5FX1NUQVRJQ19DQUxMKHB2X3NjaGVkX2Ns
b2NrLCBuYXRpdmVfc2NoZWRfY2xvY2spOw0KPiA+Pj4NCj4gPj4+ICB2b2lkIHBhcmF2aXJ0X3Nl
dF9zY2hlZF9jbG9jayh1NjQgKCpmdW5jKSh2b2lkKSkNCj4gPj4+ICB7DQo+ID4+PiArCS8qDQo+
ID4+PiArCSAqIEFueXRoaW5nIHdpdGggQVJUIG9uIHByb21pc2VzIHRvIGhhdmUgc2FuZSBUU0Ms
IG90aGVyd2lzZSB0aGUgd2hvbGUNCj4gPj4+ICsJICogQVJUIHRoaW5nIGlzIHVzZWxlc3MuIElu
IG9yZGVyIHRvIG1ha2UgQVJUIHVzZWZ1bCBmb3IgZ3Vlc3RzLCB3ZQ0KPiA+Pj4gKwkgKiBzaG91
bGQgY29udGludWUgdG8gdXNlIHRoZSBUU0MuIEFzIHN1Y2gsIGlnbm9yZSBhbnkgcGFyYXZpcnQN
Cj4gPj4+ICsJICogbXVja2VyeS4NCj4gPj4+ICsJICovDQo+ID4+PiArCWlmIChjcHVfZmVhdHVy
ZV9lbmFibGVkKFg4Nl9GRUFUVVJFX0FSVCkpDQo+ID4+DQo+ID4+IERvZXMgbm90IHNlZW0gdG8g
d29yayBiZWNhdXNlIHRoZSBmZWF0dXJlIFg4Nl9GRUFUVVJFX0FSVCBkb2VzIG5vdCBzZWVtIHRv
IGdldCBzZXQuDQo+ID4+IFBvc3NpYmx5IGJlY2F1c2UgZGV0ZWN0X2FydCgpIGV4Y2x1ZGVzIGFu
eXRoaW5nIHJ1bm5pbmcgb24gYSBoeXBlcnZpc29yLg0KPiA+DQo+ID4gU2ltcGxlIGVub3VnaCB0
byBkZWxldGUgdGhhdCBjbGF1c2UgSSBzdXBwb3NlLiBDaHJpc3RvcGhlciwgd2hhdCBpcw0KPiA+
IG5lZWRlZCB0byBtYWtlIHRoYXQgZ28gYXdheT8gSSBzdXBwb3NlIHRoZSBndWVzdCBuZWVkcyB0
byBiZSBhd2FyZSBvZg0KPiA+IHRoZSBhY3RpdmUgVFNDIHNjYWxpbmcgcGFyYW1ldGVycyB0byBt
YWtlIGl0IHdvcmsgPw0KPiANCj4gVGhlcmUgaXMgYWxzbyBub3QgWDg2X0ZFQVRVUkVfTk9OU1RP
UF9UU0Mgbm9yIHZhbHVlcyBmb3IgYXJ0X3RvX3RzY19kZW5vbWluYXRvcg0KPiBvciBhcnRfdG9f
dHNjX251bWVyYXRvci4gIEFsc28sIGZyb20gdGhlIFZNJ3MgcG9pbnQgb2YgdmlldywgVFNDIHdp
bGwganVtcA0KPiBmb3J3YXJkcyBldmVyeSBWTS1FeGl0IC8gVk0tRW50cnkgdW5sZXNzIHRoZSBo
eXBlcnZpc29yIGNoYW5nZXMgdGhlIG9mZnNldA0KPiBldmVyeSBWTS1FbnRyeSwgd2hpY2ggS1ZN
IGRvZXMgbm90LCBzbyBpdCBzdGlsbCBjYW5ub3QgYmUgdXNlZCBhcyBhIHN0YWJsZQ0KPiBjbG9j
a3NvdXJjZS4NCg0KVHJhbnNsYXRpbmcgYmV0d2VlbiBBUlQgYW5kIHRoZSBndWVzdCBUU0MgY2Fu
IGJlIGEgZGlmZmljdWx0IHByb2JsZW0gYW5kIEFSVCBzb2Z0d2FyZQ0Kc3VwcG9ydCBpcyBkaXNh
YmxlZCBieSBkZWZhdWx0IGluIGEgVk0uDQoNClRoZXJlIGFyZSB0d28gbWFqb3IgaXNzdWVzIHRy
YW5zbGF0aW5nIEFSVCB0byBUU0MgaW4gYSBWTToNCg0KVGhlIHJhbmdlIG9mIHRoZSBUU0Mgc2Nh
bGluZyBmaWVsZCBpbiB0aGUgVk1DUyBpcyBtdWNoIGxhcmdlciB0aGFuIHRoZSByYW5nZSBvZiB2
YWx1ZXMNCnRoYXQgY2FuIGJlIHJlcHJlc2VudGVkIHVzaW5nIENQVUlEWzE1SF0sIGkuZS4sIGl0
IGlzIG5vdCBwb3NzaWJsZSB0byBjb21tdW5pY2F0ZSB0aGlzDQp0byB0aGUgVk0gdXNpbmcgdGhl
IGN1cnJlbnQgQ1BVSUQgaW50ZXJmYWNlLiBUaGUgcmFuZ2Ugb2Ygc2NhbGluZyB3b3VsZCBuZWVk
IHRvIGJlDQpyZXN0cmljdGVkIG9yIGFub3RoZXIgcGFyYS12aXJ0dWFsaXplZCBtZXRob2QgLSBw
cmVmZXJhYmx5IE9TL2h5cGVydmlzb3IgYWdub3N0aWMgLSB0bw0KY29tbXVuaWNhdGUgdGhlIHNj
YWxpbmcgZmFjdG9yIHRvIHRoZSBndWVzdCBuZWVkcyB0byBiZSBpbnZlbnRlZC4NCg0KVFNDIG9m
ZnNldHRpbmcgbWF5IGFsc28gYmUgYSBwcm9ibGVtLiBUaGUgVk1DUyBUU0Mgb2Zmc2V0IG11c3Qg
YmUgZGlzY292ZXJhYmxlIGJ5IHRoZQ0KZ3Vlc3QuIFRoaXMgY2FuIGJlIGRvbmUgdmlhIFRTQ19B
REpVU1QgTVNSLiBUaGUgb2Zmc2V0IGluIHRoZSBWTUNTIGFuZCB0aGUgZ3Vlc3QNClRTQ19BREpV
U1QgTVNSIG11c3QgYWx3YXlzIGJlIGVxdWl2YWxlbnQsIGkuZS4gYSB3cml0ZSB0byBUU0NfQURK
VVNUIGluIHRoZSBndWVzdA0KbXVzdCBiZSByZWZsZWN0ZWQgaW4gdGhlIFZNQ1MgYW5kIGFueSBj
aGFuZ2VzIHRvIHRoZSBvZmZzZXQgaW4gdGhlIFZNQ1MgbXVzdCBiZQ0KcmVmbGVjdGVkIGluIHRo
ZSBUU0NfQURKVVNUIE1TUi4gT3RoZXJ3aXNlIGEgcGFyYS12aXJ0dWFsaXplZCBtZXRob2QgbXVz
dA0KYmUgaW52ZW50ZWQgdG8gY29tbXVuaWNhdGUgYW4gYXJiaXRyYXJ5IFZNQ1MgVFNDIG9mZnNl
dCB0byB0aGUgZ3Vlc3QuDQoNCg==
