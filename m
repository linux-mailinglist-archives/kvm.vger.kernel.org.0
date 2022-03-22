Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8D74E468E
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 20:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiCVTUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 15:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbiCVTUG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 15:20:06 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9291167D26
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 12:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1647976718; x=1679512718;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=MjWWG7NFaQWR5DaeB1/Y/sWxhLmnHK4kpweIk3pw3tA=;
  b=pyTEsryi+NbxVfMfWmJlyzxiBluQMRN+XYh9tQUg053pCFLnDCJ54Hv5
   trW8pEIwOu78mBNWNK3iUbCJlxBZ/Pmqb/5k73rwrZZh9ptP7XKkZohNg
   DnebuDr/Toq97MsHEE00KI3+rdBDTB2Hdf1pZ/gy+bT8mTk9jP+xu0OHT
   E=;
X-IronPort-AV: E=Sophos;i="5.90,202,1643673600"; 
   d="scan'208";a="1001552544"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 22 Mar 2022 19:18:24 +0000
Received: from EX13MTAUEE001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-d9fba5dd.us-west-2.amazon.com (Postfix) with ESMTPS id 4C1E540C74;
        Tue, 22 Mar 2022 19:18:24 +0000 (UTC)
Received: from EX13D03UEE001.ant.amazon.com (10.43.62.140) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 22 Mar 2022 19:18:20 +0000
Received: from EX13D03UEE001.ant.amazon.com (10.43.62.140) by
 EX13D03UEE001.ant.amazon.com (10.43.62.140) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 22 Mar 2022 19:18:20 +0000
Received: from EX13D03UEE001.ant.amazon.com ([10.43.62.140]) by
 EX13D03UEE001.ant.amazon.com ([10.43.62.140]) with mapi id 15.00.1497.033;
 Tue, 22 Mar 2022 19:18:20 +0000
From:   "Franke, Daniel" <dff@amazon.com>
To:     Oliver Upton <oupton@google.com>,
        David Woodhouse <dwmw2@infradead.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
Thread-Topic: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
Thread-Index: AQHYPiGXkmdxBhn0T0ChBle2fi5XeQ==
Date:   Tue, 22 Mar 2022 19:18:20 +0000
Message-ID: <5BD1FCB2-3164-4785-B4D0-94E19E6D7537@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.61.251]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8713E527938226478AC63A67F87DC999@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-12.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMy8yMS8yMiwgNToyNCBQTSwgIk9saXZlciBVcHRvbiIgPG91cHRvbkBnb29nbGUuY29tPiB3
cm90ZToNCiA+ICBSaWdodCwgYnV0IEknZCBhcmd1ZSB0aGF0IGludGVyZmFjZSBoYXMgc29tZSBw
cm9ibGVtcyB0b28uIEl0DQogPiAgIGRlcGVuZHMgb24gdGhlIGd1ZXN0IHBvbGxpbmcgaW5zdGVh
ZCBvZiBhbiBpbnRlcnJ1cHQgZnJvbSB0aGUNCiA+ICAgaHlwZXJ2aXNvci4gSXQgYWxzbyBoYXMg
bm8gd2F5IG9mIGluZm9ybWluZyB0aGUga2VybmVsIGV4YWN0bHkgaG93IG11Y2gNCiA+ICAgdGlt
ZSBoYXMgZWxhcHNlZC4NCg0KID4gICBUaGUgd2hvbGUgcG9pbnQgb2YgYWxsIHRoZXNlIGhhY2tz
IHRoYXQgd2UndmUgZG9uZSBpbnRlcm5hbGx5IGlzIHRoYXQgd2UsDQogPiAgIHRoZSBoeXBlcnZp
c29yLCBrbm93IGZ1bGwgd2VsbCBob3cgbXVjaCByZWFsIHRpbWUgaGFzdiBhZHZhbmNlZCBkdXJp
bmcgdGhlDQogPiAgIFZNIGJsYWNrb3V0LiBJZiB3ZSBjYW4gYXQgbGVhc3QgbGV0IHRoZSBndWVz
dCBrbm93IGhvdyBtdWNoIHRvIGZ1ZGdlIHJlYWwNCiA+ICAgdGltZSwgaXQgY2FuIHRoZW4gcG9r
ZSBOVFAgZm9yIGJldHRlciByZWZpbmVtZW50LiBJIHdvcnJ5IGFib3V0IHVzaW5nIE5UUA0KID4g
ICBhcyB0aGUgc29sZSBzb3VyY2Ugb2YgdHJ1dGggZm9yIHN1Y2ggYSBtZWNoYW5pc20sIHNpbmNl
IHlvdSdsbCBuZWVkIHRvIGdvDQogPiAgIG91dCB0byB0aGUgbmV0d29yayBhbmQgYW55IHJlYWRz
IHVudGlsIHRoZSByZXNwb25zZSBjb21lcyBiYWNrIGFyZSBob3NlZC4NCg0KKEknbSBhIGtlcm5l
bCBuZXdiaWUsIHNvIHBsZWFzZSBleGN1c2UgYW55IGlnbm9yYW5jZSB3aXRoIHJlc3BlY3QgdG8g
a2VybmVsDQpJbnRlcm5hbHMgb3Iga2VybmVsL2h5cGVydmlzb3IgaW50ZXJmYWNlcy4pDQoNCldl
IGNhbiBoYXZlIGl0IGJvdGggd2F5cywgSSB0aGluay4gTGV0IHRoZSBoeXBlcnZpc29yIG1hbmlw
dWxhdGUgdGhlIGd1ZXN0IFRTQw0Kc28gYXMgdG8ga2VlcCB0aGUgZ3Vlc3Qga2VybmVsJ3MgaWRl
YSBvZiByZWFsIHRpbWUgYXMgYWNjdXJhdGUgYXMgcG9zc2libGUgDQp3aXRob3V0IGFueSBhd2Fy
ZW5lc3MgcmVxdWlyZWQgb24gdGhlIGd1ZXN0J3Mgc2lkZS4gKkFsc28qIGdpdmUgdGhlIGd1ZXN0
IGtlcm5lbA0KYSBub3RpZmljYXRpb24gaW4gdGhlIGZvcm0gb2YgYSBLVk1fUFZDTE9DS19TVE9Q
UEVEIGV2ZW50IG9yIHdoYXRldmVyIGVsc2UsDQphbmQgbGV0IHRoZSBrZXJuZWwgcHJvcGFnYXRl
IHRoaXMgbm90aWZpY2F0aW9uIHRvIHVzZXJzcGFjZSBzbyB0aGF0IHRoZSBOVFANCmRhZW1vbiBj
YW4gcmVjb21ib2J1bGF0ZSBpdHNlbGYgYXMgcXVpY2tseSBhcyBwb3NzaWJsZSwgdHJlYXRpbmcg
d2hhdGV2ZXIgVFNDDQphZGp1c3RtZW50IHdhcyByZWNlaXZlZCBhcyBiZXN0LWVmZm9ydCBvbmx5
Lg0KDQpUaGUgS1ZNX1BWQ0xPQ0tfU1RPUFBFRCBldmVudCBzaG91bGQgdHJpZ2dlciBhIGNoYW5n
ZSBpbiBzb21lIG9mIHRoZQ0KZ2xvYmFscyBrZXB0IGJ5IGtlcm5lbC90aW1lL250cC5jICh3aGlj
aCBhcmUgdmlzaWJsZSB0byB1c2Vyc3BhY2UgdGhyb3VnaA0KYWRqdGltZXgoMikpLiBJbiBwYXJ0
aWN1bGFyLCBgdGltZV9lc3RlcnJvcmAgYW5kIGB0aW1lX21heGVycm9yYCBzaG91bGQgZ2V0IHJl
c2V0DQp0byBgTlRQX1BIQVNFX0xJTUlUYCBhbmQgdGltZV9zdGF0dXMgc2hvdWxkIGdldCByZXNl
dCB0byBgU1RBX1VOU1lOQ2AuDQoNClRoZSBhZm9yZW1lbnRpb25lZCBmaWVsZHMgZ2V0IG92ZXJ3
cml0dGVuIGJ5IHRoZSBOVFAgZGFlbW9uIGV2ZXJ5IHBvbGxpbmcNCmludGVydmFsLCBhbmQgd2hh
dGV2ZXIgbm90aWZpY2F0aW9uIGdldHMgc2VudCB0byB1c2Vyc3BhY2UgaXMgZ29pbmcgdG8gYmUN
CmFzeW5jaHJvbm91cywgc28gd2UgbmVlZCB0byBhdm9pZCByYWNlIGNvbmRpdGlvbnMgd2hlcmVp
biB1c2Vyc3BhY2UgY2xvYmJlcnMNCnRoZW0gd2l0aCBpdHMgb3V0ZGF0ZWQgaWRlYSBvZiB0aGVp
ciBjb3JyZWN0IHZhbHVlIGJlZm9yZSB0aGUgbm90aWZpY2F0aW9uIGFycml2ZXMuDQpJIHByb3Bv
c2UgYWxsb2NhdGluZyBvbmUgb2YgdGhlIHVudXNlZCBmaWVsZHMgYXQgdGhlIGVuZCBvZiBgc3Ry
dWN0IHRpbWV4YCBhcyBhDQpgY2xvY2t2ZXJgIGZpZWxkLiBUaGlzIGZpZWxkIHdpbGwgYmUgMCBh
dCBib290IHRpbWUsIGFuZCBnZXQgaW5jcmVtZW50ZWQgYWZ0ZXINCmNsb2NrIGRpc2NvbnRpbnVp
dHkgc3VjaCBhcyBhIEtWTSBibGFja291dCwgYW4gQUNQSSBzdXNwZW5kLXRvLVJBTSBldmVudCwN
Cm9yIGEgbWFudWFsIHNldHRpbmcgb2YgdGhlIGNsb2NrIHRocm91Z2ggY2xvY2tfc2V0dGltZSgz
KSBvciBzaW1pbGFyLiBBdWdtZW50DQpgbW9kZXNgIHdpdGggYW4gYEFESl9DTE9DS1ZFUmAgYml0
LCB3aXRoIHRoZSBzZW1hbnRpY3MgIm1ha2UgdGhpcyBjYWxsIGZhaWwNCklmIHRoZSBgY2xvY2t2
ZXJgIEkgcGFzc2VkIGluIGlzIG5vdCBjdXJyZW50Ii4NCg0KQXMgZm9yIHRoZSBmb3JtIG9mIHRo
ZSBub3RpZmljYXRpb24gdG8gdXNlcnNwYWNlLi4uIGR1bm5vLCBJIHRoaW5rIGEgbmV0bGluaw0K
aW50ZXJmYWNlIG1ha2VzIHRoZSBtb3N0IHNlbnNlPyBJJ20gbm90IHRvbyBvcGluaW9uYXRlZCBo
ZXJlLiBXaGF0ZXZlciB3ZQ0KZGVjaWRlLCBJJ2xsIGJlIGhhcHB5IHRvIGNvbnRyaWJ1dGUgdGhl
IHBhdGNoZXMgdG8gY2hyb255IGFuZCBudHBkLiBUaGUgTlRQDQpkYWVtb24gc2hvdWxkIGhhbmRs
ZSB0aGlzIG5vdGlmaWNhdGlvbiBieSBlc3NlbnRpYWxseSByZXNldHRpbmcgaXRzIHN0YXRlIHRv
DQpob3cgaXQgd2FzIGF0IGZpcnN0IHN0YXJ0dXAsIGNvbnNpZGVyaW5nIGl0c2VsZiB1bnN5bmNo
cm9uaXplZCBhbmQgaW1tZWRpYXRlbHkNCmtpY2tpbmcgb2ZmIG5ldyBxdWVyaWVzIHRvIGFsbCBp
dHMgcGVlcnMuDQoNCk9uZSBvdGhlciB0aGluZyB0aGUgTlRQIGRhZW1vbiBtaWdodCB3YW50IHRv
IGRvIHdpdGggdGhpcyBub3RpZmljYXRpb24gaXMNCmNsb2JiZXIgaXRzIGRyaWZ0IGZpbGUsIGJ1
dCBvbmx5IGlmIGl0J3MgcnVubmluZyBvbiBkaWZmZXJlbnQgaGFyZHdhcmUgdGhhbiBiZWZvcmUu
DQpCdXQgdGhpcyByZXF1aXJlcyBnZXR0aW5nIHRoYXQgYml0IG9mIGluZm9ybWF0aW9uIGZyb20g
dGhlIGh5cGVydmlzb3IgdG8gdGhlDQprZXJuZWwgYW5kIEkgaGF2ZW4ndCB0aG91Z2h0IGFib3V0
IGhvdyB0aGlzIHNob3VsZCB3b3JrLg0KDQpUaGVyZSdzIGEgbWlub3IgcHJvYmxlbSByZW1haW5p
bmcgaGVyZSwgd2hpY2ggaW1wYWN0cyBOVFAgc2VydmVycyBidXQgbm90DQpjbGllbnRzLiBOVFAg
c2VydmVycyBkb24ndCB1c2UgYWRqdGltZXggdG8gZ2V0IHRoZSB0aW1lc3RhbXBzIHRoZSB1c2Ug
dG8NCnBvcHVsYXRlIE5UUCBwYWNrZXRzOyB0aGV5IGp1c3QgdXNlIGNsb2NrX2dldHRpbWUsIGJl
Y2F1c2UgdGhlIGxhdHRlciBpcyBhDQpWRFNPIGNhbGwgYW5kIHRoZSBmb3JtZXIgaXMgbm90LiBU
aGF0IG1lYW5zIHRoYXQgdGhleSBtYXkgbm90IGxlYXJuIG9mIHRoZQ0KYGNsb2NrdmVyYCBzdGVw
IGluIHRpbWUgdG8gYW5zd2VyIGFueSBxdWVyaWVzIHRoYXQgY29tZSBpbiBpbW1lZGlhdGVseQ0K
cG9zdC1ibGFja291dC4gU28sIHRoZSBzZXJ2ZXIgbWF5IGJyaWVmbHkgYmVjb21lIGEgZmFsc2V0
aWNrZXIgaWYgdGhlDQpoeXBlcnZpc29yIGRpZCB0b28gcG9vciBhIGpvYiB3aXRoIHRoZSBUU0Mg
c3RlcC4gSSBkb24ndCB0aGluayB0aGlzIGlzIGEgYmlnDQpkZWFsIG9yIHNvbWV0aGluZyB0aGF0
IG5lZWRzIHRvIGJlIGFkZHJlc3NlZCBpbiB0aGUgZmlyc3QgaXRlcmF0aW9uLiBUaGUNCmxvbmct
dGVybSBzb2x1dGlvbiBpcyB0byBtYWtlIGFkanRpbWV4IGFsc28gYmUgYSBWRFNPIHdoZW4gYG1v
ZGVzYCBpcw0KMCwgc28gdGhhdCBOVFAgZGFlbW9ucyBjYW4gdXNlIGl0IGZvciBldmVyeXRoaW5n
Lg0KDQo=
