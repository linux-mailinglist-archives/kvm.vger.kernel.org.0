Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9677CBD7C
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 10:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbjJQIbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 04:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234692AbjJQIbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 04:31:49 -0400
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CF2B6;
        Tue, 17 Oct 2023 01:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1697531507; x=1729067507;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=L1mLgvIUqi0W/g8ivejaUnyVfcp65Think3VRQ+B36s=;
  b=BZU4DxasSJifIhZoo2UsSPPC4KGh284C9+iS6x+2qZkNOpVGrUDxQMgl
   iIymnMrNKpGKOww3iGPRpeP6Gkgo6aJUVM3uDLWCliYaucOzgM223nrc8
   KgLaUn2xg0fIy9iDPSfJ3RRPi65V4i0OSFlsmI54ckoWic8DmiRBgDmbc
   8=;
X-IronPort-AV: E=Sophos;i="6.03,231,1694736000"; 
   d="scan'208";a="36233406"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 08:31:42 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan2.iad.amazon.com [10.32.235.34])
        by email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com (Postfix) with ESMTPS id BB244A339D;
        Tue, 17 Oct 2023 08:31:38 +0000 (UTC)
Received: from EX19MTAUWB002.ant.amazon.com [10.0.7.35:14896]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.12.209:2525] with esmtp (Farcaster)
 id 64d90951-01b1-4454-a91f-6637f13e7b1e; Tue, 17 Oct 2023 08:31:38 +0000 (UTC)
X-Farcaster-Flow-ID: 64d90951-01b1-4454-a91f-6637f13e7b1e
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Tue, 17 Oct 2023 08:31:33 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.37; Tue, 17 Oct
 2023 08:31:30 +0000
Message-ID: <8f9d81a8-1071-43ca-98cd-e9c1eab8e014@amazon.de>
Date:   Tue, 17 Oct 2023 10:31:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 00/10] mm/prmem: Implement the
 Persistent-Across-Kexec memory feature (prmem)
Content-Language: en-US
To:     <madvenka@linux.microsoft.com>, <gregkh@linuxfoundation.org>,
        <pbonzini@redhat.com>, <rppt@kernel.org>, <jgowans@amazon.com>,
        <arnd@arndb.de>, <keescook@chromium.org>,
        <stanislav.kinsburskii@gmail.com>, <anthony.yznaga@oracle.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <jamorris@linux.microsoft.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        kvm <kvm@vger.kernel.org>
References: <1b1bc25eb87355b91fcde1de7c2f93f38abb2bf9>
 <20231016233215.13090-1-madvenka@linux.microsoft.com>
From:   Alexander Graf <graf@amazon.de>
In-Reply-To: <20231016233215.13090-1-madvenka@linux.microsoft.com>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D045UWA003.ant.amazon.com (10.13.139.46) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGV5IE1hZGhhdmFuIQoKVGhpcyBwYXRjaCBzZXQgbG9va3Mgc3VwZXIgZXhjaXRpbmcgLSB0aGFu
a3MgYSBsb3QgZm9yIHB1dHRpbmcgaXQgCnRvZ2V0aGVyLiBXZSd2ZSBiZWVuIHBva2luZyBhdCBh
IHZlcnkgc2ltaWxhciBkaXJlY3Rpb24gZm9yIGEgd2hpbGUgYXMgCndlbGwgYW5kIHdpbGwgZGlz
Y3VzcyB0aGUgZnVuZGFtZW50YWwgcHJvYmxlbSBvZiBob3cgdG8gcGVyc2lzdCBrZXJuZWwgCm1l
dGFkYXRhIGFjcm9zcyBrZXhlYyBhdCBMUEM6CgogwqAgaHR0cHM6Ly9scGMuZXZlbnRzL2V2ZW50
LzE3L2NvbnRyaWJ1dGlvbnMvMTQ4NS8KCkl0IHdvdWxkIGJlIGdyZWF0IHRvIGhhdmUgeW91IGlu
IHRoZSByb29tIGFzIHdlbGwgdGhlbi4KClNvbWUgbW9yZSBjb21tZW50cyBpbmxpbmUuCgpPbiAx
Ny4xMC4yMyAwMTozMiwgbWFkdmVua2FAbGludXgubWljcm9zb2Z0LmNvbSB3cm90ZToKPiBGcm9t
OiAiTWFkaGF2YW4gVC4gVmVua2F0YXJhbWFuIiA8bWFkdmVua2FAbGludXgubWljcm9zb2Z0LmNv
bT4KPgo+IEludHJvZHVjdGlvbgo+ID09PT09PT09PT09PQo+Cj4gVGhpcyBmZWF0dXJlIGNhbiBi
ZSB1c2VkIHRvIHBlcnNpc3Qga2VybmVsIGFuZCB1c2VyIGRhdGEgYWNyb3NzIGtleGVjIHJlYm9v
dHMKPiBpbiBSQU0gZm9yIHZhcmlvdXMgdXNlcy4gRS5nLiwgcGVyc2lzdGluZzoKPgo+ICAgICAg
ICAgIC0gY2FjaGVkIGRhdGEuIEUuZy4sIGRhdGFiYXNlIGNhY2hlcy4KPiAgICAgICAgICAtIHN0
YXRlLiBFLmcuLCBLVk0gZ3Vlc3Qgc3RhdGVzLgo+ICAgICAgICAgIC0gaGlzdG9yaWNhbCBpbmZv
cm1hdGlvbiBzaW5jZSB0aGUgbGFzdCBjb2xkIGJvb3QuIEUuZy4sIGV2ZW50cywgbG9ncwo+ICAg
ICAgICAgICAgYW5kIGpvdXJuYWxzLgo+ICAgICAgICAgIC0gbWVhc3VyZW1lbnRzIGZvciBpbnRl
Z3JpdHkgY2hlY2tzIG9uIHRoZSBuZXh0IGJvb3QuCj4gICAgICAgICAgLSBkcml2ZXIgZGF0YS4K
PiAgICAgICAgICAtIElPTU1VIG1hcHBpbmdzLgo+ICAgICAgICAgIC0gTU1JTyBjb25maWcgaW5m
b3JtYXRpb24uCj4KPiBUaGlzIGlzIHVzZWZ1bCBvbiBzeXN0ZW1zIHdoZXJlIHRoZXJlIGlzIG5v
IG5vbi12b2xhdGlsZSBzdG9yYWdlIG9yCj4gbm9uLXZvbGF0aWxlIHN0b3JhZ2UgaXMgdG9vIHNt
YWxsIG9yIHRvbyBzbG93LgoKClRoaXMgaXMgdXNlZnVsIGluIG1vcmUgc2l0dWF0aW9ucy4gV2Ug
Zm9yIGV4YW1wbGUgbmVlZCBpdCB0byBkbyBhIGtleGVjIAp3aGlsZSBhIHZpcnR1YWwgbWFjaGlu
ZSBpcyBpbiBzdXNwZW5kZWQgc3RhdGUsIGJ1dCBoYXMgSU9NTVUgbWFwcGluZ3MgCmludGFjdCAo
TGl2ZSBVcGRhdGUpLiBGb3IgdGhhdCwgd2UgbmVlZCB0byBlbnN1cmUgRE1BIGNhbiBzdGlsbCBy
ZWFjaCAKdGhlIFZNIG1lbW9yeSBhbmQgdGhhdCBldmVyeXRoaW5nIGdldHMgcmVhc3NlbWJsZWQg
aWRlbnRpY2FsbHkgYW5kIAp3aXRob3V0IGludGVycnVwdGlvbnMgb24gdGhlIHJlY2VpdmluZyBl
bmQuCgoKPiBUaGUgZm9sbG93aW5nIHNlY3Rpb25zIGRlc2NyaWJlIHRoZSBpbXBsZW1lbnRhdGlv
bi4KPgo+IEkgaGF2ZSBlbmhhbmNlZCB0aGUgcmFtIGRpc2sgYmxvY2sgZGV2aWNlIGRyaXZlciB0
byBwcm92aWRlIHBlcnNpc3RlbnQgcmFtCj4gZGlza3Mgb24gd2hpY2ggYW55IGZpbGVzeXN0ZW0g
Y2FuIGJlIGNyZWF0ZWQuIFRoaXMgaXMgZm9yIHBlcnNpc3RpbmcgdXNlciBkYXRhLgo+IEkgaGF2
ZSBhbHNvIGltcGxlbWVudGVkIERBWCBzdXBwb3J0IGZvciB0aGUgcGVyc2lzdGVudCByYW0gZGlz
a3MuCgoKVGhpcyBpcyBwcm9iYWJseSB0aGUgbGVhc3QgaW50ZXJlc3Rpbmcgb2YgdGhlIGVuYWJs
ZW1lbnRzLCByaWdodD8gWW91IApjYW4gYWxyZWFkeSB0b2RheSByZXNlcnZlIFJBTSBvbiBib290
IGFzIERBWCBibG9jayBkZXZpY2UgYW5kIHVzZSBpdCBmb3IgCnRoYXQgcHVycG9zZS4KCgo+IEkg
YW0gYWxzbyB3b3JraW5nIG9uIG1ha2luZyBaUkFNIHBlcnNpc3RlbnQuCj4KPiBJIGhhdmUgYWxz
byBicmllZmx5IGRpc2N1c3NlZCB0aGUgZm9sbG93aW5nIHVzZSBjYXNlczoKPgo+ICAgICAgICAg
IC0gUGVyc2lzdGluZyBJT01NVSBtYXBwaW5ncwo+ICAgICAgICAgIC0gUmVtZW1iZXJpbmcgRE1B
IHBhZ2VzCj4gICAgICAgICAgLSBSZXNlcnZpbmcgcGFnZXMgdGhhdCBlbmNvdW50ZXIgbWVtb3J5
IGVycm9ycwo+ICAgICAgICAgIC0gUmVtZW1iZXJpbmcgSU1BIG1lYXN1cmVtZW50cyBmb3IgaW50
ZWdyaXR5IGNoZWNrcwo+ICAgICAgICAgIC0gUmVtZW1iZXJpbmcgTU1JTyBjb25maWcgaW5mbwo+
ICAgICAgICAgIC0gSW1wbGVtZW50aW5nIHBybWVtZnMgKHNwZWNpYWwgZmlsZXN5c3RlbSB0YWls
b3JlZCBmb3IgcGVyc2lzdGVuY2UpCj4KPiBBbGxvY2F0ZSBtZXRhZGF0YQo+ID09PT09PT09PT09
PT09PT09Cj4KPiBEZWZpbmUgYSBtZXRhZGF0YSBzdHJ1Y3R1cmUgdG8gc3RvcmUgYWxsIHBlcnNp
c3RlbnQgbWVtb3J5IHJlbGF0ZWQgaW5mb3JtYXRpb24uCj4gVGhlIG1ldGFkYXRhIGZpdHMgaW50
byBvbmUgcGFnZS4gT24gYSBjb2xkIGJvb3QsIGFsbG9jYXRlIGFuZCBpbml0aWFsaXplIHRoZQo+
IG1ldGFkYXRhIHBhZ2UuCj4KPiBBbGxvY2F0ZSBkYXRhCj4gPT09PT09PT09PT09PQo+Cj4gT24g
YSBjb2xkIGJvb3QsIGFsbG9jYXRlIHNvbWUgbWVtb3J5IGZvciBzdG9yaW5nIHBlcnNpc3RlbnQg
ZGF0YS4gQ2FsbCBpdAo+IHBlcnNpc3RlbnQgbWVtb3J5LiBTcGVjaWZ5IHRoZSBzaXplIGluIGEg
Y29tbWFuZCBsaW5lIHBhcmFtZXRlcjoKPgo+ICAgICAgICAgIHBybWVtPXNpemVbS01HXVssbWF4
X3NpemVbS01HXV0KPgo+ICAgICAgICAgIHNpemUgICAgICAgICAgICBJbml0aWFsIGFtb3VudCBv
ZiBtZW1vcnkgYWxsb2NhdGVkIHRvIHBybWVtIGR1cmluZyBib290Cj4gICAgICAgICAgbWF4X3Np
emUgICAgICAgIE1heGltdW0gYW1vdW50IG9mIG1lbW9yeSB0aGF0IGNhbiBiZSBhbGxvY2F0ZWQg
dG8gcHJtZW0KPgo+IFdoZW4gdGhlIGluaXRpYWwgbWVtb3J5IGlzIGV4aGF1c2VkIHZpYSBhbGxv
Y2F0aW9ucywgZXhwYW5kIHBybWVtIGR5bmFtaWNhbGx5Cj4gdXAgdG8gbWF4X3NpemUuIEV4cGFu
c2lvbiBpcyBkb25lIGJ5IGFsbG9jYXRpbmcgZnJvbSB0aGUgYnVkZHkgYWxsb2NhdG9yLgo+IFJl
Y29yZCBhbGwgYWxsb2NhdGlvbnMgaW4gdGhlIG1ldGFkYXRhLgoKCkkgZG9uJ3QgdW5kZXJzdGFu
ZCB3aHkgd2UgbmVlZCBhIHNlcGFyYXRlIGFsbG9jYXRvci4gV2h5IGNhbid0IHdlIGp1c3QgCnVz
ZSBub3JtYWwgTGludXggYWxsb2NhdGlvbnMgYW5kIHNlcmlhbGl6ZSB0aGVpciBsb2NhdGlvbiBm
b3IgaGFuZG92ZXI/IApXZSB3b3VsZCBvYnZpb3VzbHkgc3RpbGwgbmVlZCB0byBmaW5kIGEgbGFy
Z2UgY29udGlndW91cyBwaWVjZSBvZiBtZW1vcnkgCmZvciB0aGUgdGFyZ2V0IGtlcm5lbCB0byBi
b290c3RyYXAgaXRzZWxmIGludG8gdW50aWwgaXQgY2FuIHJlYWQgd2hpY2ggCnBhZ2VzIGl0IGNh
biBhbmQgY2FuIG5vdCB1c2UsIGJ1dCB3ZSBjYW4gZG8gdGhhdCBhbGxvY2F0aW9uIGluIHRoZSAK
c291cmNlIGVudmlyb25tZW50IHVzaW5nIENNQSwgbm8/CgpXaGF0IEknbSB0cnlpbmcgdG8gc2F5
IGlzOiBJIHRoaW5rIHdlJ3JlIGJldHRlciBvZmYgc2VwYXJhdGluZyB0aGUgCmhhbmRvdmVyIG1l
Y2hhbmlzbSBmcm9tIHRoZSBhbGxvY2F0aW9uIG1lY2hhbmlzbS4gSWYgd2UgY2FuIGltcGxlbWVu
dCAKaGFuZG92ZXIgd2l0aG91dCBhIG5ldyBhbGxvY2F0b3IsIHdlIGNhbiB1c2UgaXQgZm9yIHNp
bXBsZSB0aGluZ3Mgd2l0aCBhIApzbGlnaHQgcnVudGltZSBwZW5hbHR5LiBUbyBhY2NlbGVyYXRl
IHRoZSBoYW5kb3ZlciB0aGVuLCB3ZSBjYW4gbGF0ZXIgCmFkZCBhIGNvbXBhY3RpbmcgYWxsb2Nh
dG9yIHRoYXQgY2FuIHVzZSB0aGUgaGFuZG92ZXIgbWVjaGFuaXNtIHdlIAphbHJlYWR5IGJ1aWx0
IHRvIHBlcnNpc3QgaXRzZWxmLgoKCgpJIGhhdmUgYSBXSVAgYnJhbmNoIHdoZXJlIEknbSB0b3lp
bmcgd2l0aCBzdWNoIGEgaGFuZG92ZXIgbWVjaGFuaXNtIHRoYXQgCnVzZXMgZGV2aWNlIHRyZWUg
dG8gc2VyaWFsaXplL2Rlc2VyaWFsaXplIHN0YXRlLiBCeSBzdGFuZGFyZGl6aW5nIHRoZSAKcHJv
cGVydHkgbmFtaW5nLCB3ZSBjYW4gaW4gdGhlIHJlY2VpdmluZyBrZXJuZWwgbWFyayBhbGwgcGVy
c2lzdGVudCAKYWxsb2NhdGlvbnMgYXMgcmVzZXJ2ZWQgYW5kIHRoZW4gc2xvd2x5IGVpdGhlciBm
cmVlIHRoZW0gYWdhaW4gb3IgbWFyayAKdGhlbSBhcyBpbi11c2Ugb25lIGJ5IG9uZToKCmh0dHBz
Oi8vZ2l0aHViLmNvbS9hZ3JhZi9saW51eC9jb21taXQvZmQ1NzM2YTIxZDU0OWE5YTg2YzE3OGM5
MWFjYjI5ZWQ3ZjM2NGY0MgoKSSB1c2VkIGZ0cmFjZSBhcyBleGFtcGxlIHBheWxvYWQgdG8gcGVy
c2lzdDogV2l0aCB0aGUgaGFuZG92ZXIgbWVjaGFuaXNtIAppbiBwbGFjZSwgd2Ugc2VyaWFsaXpl
L2Rlc2VyaWFsaXplIGZ0cmFjZSByaW5nIGJ1ZmZlciBtZXRhZGF0YSBhbmQgYXJlIAp0aHVzIGFi
bGUgdG8gcmVhZCB0cmFjZXMgb2YgdGhlIHByZXZpb3VzIHN5c3RlbSBhZnRlciBrZXhlYy4gVGhp
cyB3YXksIAp5b3UgY2FuIGZvciBleGFtcGxlIHByb2ZpbGUgdGhlIGtleGVjIGV4aXQgcGF0aC4K
Ckl0J3Mgbm90IGV2ZW4gaW4gUkZDIHN0YXRlIHlldCwgdGhlcmUgYXJlIGEgZmV3IHRoaW5ncyB3
aGVyZSBJIHdvdWxkIApuZWVkIGEgY291cGxlIGRheXMgdG8gdGhpbmsgaGFyZCBhYm91dCBkYXRh
IHN0cnVjdHVyZXMsIGxheW91dHMgYW5kIApvdGhlciBwcm9ibGVtcyA6KS4gQnV0IEkgYmVsaWV2
ZSBmcm9tIHRoZSBwYXRjaCB5b3UgZ2V0IHRoZSBpZGVhLgoKT25lIHN1Y2ggdXNlciBvZiBraG8g
Y291bGQgYmUgYSBuZXcgYWxsb2NhdG9yIGxpa2UgcHJtZW0gYW5kIGVhY2ggCnN1YnN5c3RlbSdz
IHNlcmlhbGl6YXRpb24gY29kZSBjb3VsZCBjaG9vc2UgdG8gcmVseSBvbiB0aGUgcHJtZW0gCnN1
YnN5c3RlbSB0byBwZXJzaXN0IGRhdGEgaW5zdGVhZCBvZiBkb2luZyBpdCB0aGVtc2VsdmVzLiBU
aGF0IHdheSB5b3UgCmdldCBhIHZlcnkgbm9uLWludHJ1c2l2ZSBlbmFibGVtZW50IHBhdGggZm9y
IGtleGVjIGhhbmRvdmVyLCBlYXNpbHkgCmFtZW5kYWJsZSBkYXRhIHN0cnVjdHVyZXMgdGhhdCBj
YW4gY2hhbmdlIGNvbXBhdGlibHkgb3ZlciB0aW1lIGFzIHdlbGwgCmFzIHRoZSBhYmlsaXR5IHRv
IHJlY3JlYXRlIGVwaGVtZXJhbCBkYXRhIHN0cnVjdHVyZSBiYXNlZCBvbiBwZXJzaXN0ZW50IApp
bmZvcm1hdGlvbiAtIHdoaWNoIHdpbGwgYmUgbmVjZXNzYXJ5IHRvIHBlcnNpc3QgVkZJTyBjb250
YWluZXJzLgoKCkFsZXgKCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJI
CktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlh
biBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENo
YXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAy
ODkgMjM3IDg3OQoKCg==

