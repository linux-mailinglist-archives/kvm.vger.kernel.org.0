Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE36C6F5CD5
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 19:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjECRQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 13:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjECRQY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 13:16:24 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E5010D1
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 10:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683134181; x=1714670181;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MUFszrLuw4U5G8S7pxWyyBMLqAt05m5HkDl/Z8RxWhs=;
  b=mxVnlAGub3ryDfvnYaWJAv+zV3mjRzZewxjW3lPcgvUsqayKTUjgqKPF
   G/RG3g/f5ClMmDw/Ae0PPuK8obiXw7w8OiqeXMVPq18TbrjUgYGe0Hwj1
   bqxWLiWAviMRmbXNQkknseXpnXs+90tGjDCk2AWMr8PbepLtkl4mjEMRY
   M=;
X-IronPort-AV: E=Sophos;i="5.99,247,1677542400"; 
   d="scan'208";a="282044698"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-3554bfcf.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 17:16:14 +0000
Received: from EX19MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-3554bfcf.us-east-1.amazon.com (Postfix) with ESMTPS id 44AB182471;
        Wed,  3 May 2023 17:16:09 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 3 May 2023 17:16:08 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.26; Wed, 3 May
 2023 17:16:06 +0000
Message-ID: <6890ae22-c3e2-cba3-3ce6-d3f65dacb31d@amazon.com>
Date:   Wed, 3 May 2023 19:16:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Content-Language: en-US
To:     Claudio Carvalho <cclaudio@linux.ibm.com>,
        =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
CC:     <amd-sev-snp@lists.suse.com>, <linux-coco@lists.linux.dev>,
        <kvm@vger.kernel.org>, Carlos Bilbao <carlos.bilbao@amd.com>,
        Klaus Kiwi <kkiwi@redhat.com>
References: <ZBl4592947wC7WKI@suse.de>
 <4420d7e5-d05f-8c31-a0f2-587ebb7eaa20@amd.com> <ZFJTDtMK0QqXK5+E@suse.de>
 <cc22183359d107dc0be58b4f9509c8d785313879.camel@linux.ibm.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <cc22183359d107dc0be58b4f9509c8d785313879.camel@linux.ibm.com>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDAzLjA1LjIzIDE4OjUxLCBDbGF1ZGlvIENhcnZhbGhvIHdyb3RlOgoKPgo+IEhpIEpvcmcs
Cj4KPiBPbiBXZWQsIDIwMjMtMDUtMDMgYXQgMTQ6MjYgKzAyMDAsIErDtnJnIFLDtmRlbCB3cm90
ZToKPj4+ICAgIC0gQXJlIHlvdSBvcGVuIHRvIGhhdmluZyBtYWludGFpbmVycyBvdXRzaWRlIG9m
IFNVU0U/IFRoZXJlIGlzIHNvbWUKPj4+ICAgICAgbGludXgtc3ZzbSBjb21tdW5pdHkgY29uY2Vy
biBhYm91dCBwcm9qZWN0IGdvdmVybmFuY2UgYW5kIHByb2plY3QKPj4+ICAgICAgcHJpb3JpdGll
cyBhbmQgcmVsZWFzZSBzY2hlZHVsZXMuIFRoaXMgd291bGRuJ3QgaGF2ZSB0byBiZSBBTUQgZXZl
biwKPj4+ICAgICAgYnV0IHdlJ2Qgdm9sdW50ZWVyIHRvIGhlbHAgaGVyZSBpZiBkZXNpcmVkLCBi
dXQgd2UnZCBsaWtlIHRvIGZvc3RlciBhCj4+PiAgICAgIHRydWUgY29tbXVuaXR5IG1vZGVsIGZv
ciBnb3Zlcm5hbmNlIHJlZ2FyZGxlc3MuIFdlJ2QgbG92ZSB0byBoZWFyCj4+PiAgICAgIHRob3Vn
aHRzIG9uIHRoaXMgZnJvbSBjb2NvbnV0LXN2c20gZm9sa3MuCj4+IFllcywgSSBhbSBkZWZpbml0
ZWx5IHdpbGxpbmcgdG8gbWFrZSB0aGUgcHJvamVjdCBtb3JlIG9wZW4gYW5kIG1vdmUgdG8gYQo+
PiBtYWludGFpbmVyLWdyb3VwIG1vZGVsLCBubyBpbnRlbnRpb24gZnJvbSBteSBzaWRlIHRvIGJl
Y29tZSBhIEJERkwgZm9yCj4+IHRoZSBwcm9qZWN0LiBJIGp1c3QgaGF2ZSBubyBjbGVhciBwaWN0
dXJlIHlldCBob3cgdGhlIG1vZGVsIHNob3VsZCBsb29rCj4+IGxpa2UgYW5kIGhvdyB0byBnZXQg
dGhlcmUuIEkgd2lsbCBzZW5kIGEgc2VwYXJhdGUgZW1haWwgdG8ga2ljay1zdGFydCBhCj4+IGRp
c2N1c3Npb24gYWJvdXQgdGhhdC4KPj4KPiBUaGFua3MuIEkgd291bGQgYmUgaGFwcHkgdG8gY29s
bGFib3JhdGUgaW4gdGhhdCBkaXNjdXNzaW9uLgo+Cj4+PiAgICAtIE9uIHRoZSBzdWJqZWN0IG9m
IHByaW9yaXRpZXMsIHRoZSBudW1iZXIgb25lIHByaW9yaXR5IGZvciB0aGUKPj4+ICAgICAgbGlu
dXgtc3ZzbSBwcm9qZWN0IGhhcyBiZWVuIHRvIHF1aWNrbHkgYWNoaWV2ZSBwcm9kdWN0aW9uIHF1
YWxpdHkgdlRQTQo+Pj4gICAgICBzdXBwb3J0LiBUaGUgc3VwcG9ydCBmb3IgdGhpcyBpcyBiZWlu
ZyBhY3RpdmVseSB3b3JrZWQgb24gYnkKPj4+ICAgICAgbGludXgtc3ZzbSBjb250cmlidXRvcnMg
YW5kIHdlJ2Qgd2FudCB0byBmaW5kIGZhc3Rlc3QgcGF0aCB0b3dhcmRzCj4+PiAgICAgIGdldHRp
bmcgdGhhdCByZWRpcmVjdGVkIGludG8gY29jb251dC1zdnNtIChwb3NzaWJseSBzdGFydGluZyB3
aXRoIENQTDAKPj4+ICAgICAgaW1wbGVtZW50YXRpb24gdW50aWwgQ1BMMyBzdXBwb3J0IGlzIGF2
YWlsYWJsZSkgYW5kIHRoZSBwcm9qZWN0Cj4+PiAgICAgIGhhcmRlbmVkIGZvciBhIHJlbGVhc2Uu
ICBJIGltYWdpbmUgdGhlcmUgd2lsbCBiZSBzb21lIGNvbXBldGluZwo+Pj4gICAgICBwcmlvcml0
aWVzIGZyb20gY29jb251dC1zdnNtIHByb2plY3QgY3VycmVudGx5LCBzbyB3YW50ZWQgdG8gZ2V0
IHRoaXMKPj4+ICAgICAgb3V0IG9uIHRoZSB0YWJsZSBmcm9tIHRoZSBiZWdpbm5pbmcuCj4+IFRo
YXQgaGFzIGJlZW4gdW5kZXIgZGlzY3Vzc2lvbiBmb3Igc29tZSB0aW1lLCBhbmQgaG9uZXN0bHkg
SSB0aGluawo+PiB0aGUgYXBwcm9hY2ggdGFrZW4gaXMgdGhlIG1haW4gZGlmZmVyZW5jZSBiZXR3
ZWVuIGxpbnV4LXN2c20gYW5kCj4+IENPQ09OVVQuIE15IHBvc2l0aW9uIGhlcmUgaXMsIGFuZCB0
aGF0IGNvbWVzIHdpdGggYSBiaWcgJ0JVVCcsIHRoYXQgSSBhbQo+PiBub3QgZnVuZGFtZW50YWxs
eSBvcHBvc2VkIHRvIGhhdmluZyBhIHRlbXBvcmFyeSBzb2x1dGlvbiBmb3IgdGhlIFRQTQo+PiB1
bnRpbCBDUEwtMyBzdXBwb3J0IGlzIGF0IGEgcG9pbnQgd2hlcmUgaXQgY2FuIHJ1biBhIFRQTSBt
b2R1bGUuCj4+Cj4+IEFuZCBoZXJlIGNvbWUgdGhlICdCVVQnOiBTaW5jZSB0aGUgZ29hbCBvZiBo
YXZpbmcgb25lIHByb2plY3QgaXMgdG8KPj4gYnVuZGxlIGNvbW11bml0eSBlZmZvcnRzLCBJIHRo
aW5rIHRoYXQgdGhlIGpvaW50IGVmZm9ydHMgYXJlIGJldHRlcgo+PiB0YXJnZXRlZCBhdCBnZXR0
aW5nIENQTC0zIHN1cHBvcnQgdG8gYSBwb2ludCB3aGVyZSBpdCBjYW4gcnVuIG1vZHVsZXMuCj4+
IE9uIHRoYXQgc2lkZSBzb21lIGlucHV0IGFuZCBoZWxwIGlzIG5lZWRlZCwgZXNwZWNpYWxseSB0
byBkZWZpbmUgdGhlCj4+IHN5c2NhbGwgaW50ZXJmYWNlIHNvIHRoYXQgaXQgc3VpdHMgdGhlIG5l
ZWRzIG9mIGEgVFBNIGltcGxlbWVudGF0aW9uLgo+Pgo+PiBJdCBpcyBhbHNvIG5vdCB0aGUgY2Fz
ZSB0aGF0IENQTC0zIHN1cHBvcnQgaXMgb3V0IG1vcmUgdGhhbiBhIHllYXIgb3IKPj4gc28uIFRo
ZSBSYW1GUyBpcyBhbG1vc3QgcmVhZHksIGFzIGlzIHRoZSBhcmNoaXZlIGZpbGUgaW5jbHVzaW9u
WzFdLiBXZQo+PiB3aWxsIG1vdmUgdG8gdGFzayBtYW5hZ2VtZW50IG5leHQsIHRoZSBnb2FsIGlz
IHN0aWxsIHRvIGhhdmUgYmFzaWMKPj4gc3VwcG9ydCByZWFkeSBpbiAySDIwMjMuCj4+Cj4+IFsx
XSBodHRwczovL2dpdGh1Yi5jb20vY29jb251dC1zdnNtL3N2c20vcHVsbC8yNwo+Pgo+PiBJZiB0
aGVyZSBpcyBzdGlsbCBhIHN0cm9uZyBkZXNpcmUgdG8gaGF2ZSBDT0NPTlVUIHdpdGggYSBUUE0g
KHJ1bm5pbmcgYXQKPj4gQ1BMLTApIGJlZm9yZSBDUEwtMyBzdXBwb3J0IGlzIHVzYWJsZSwgdGhl
biBJIGNhbiBsaXZlIHdpdGggaW5jbHVkaW5nCj4+IGNvZGUgZm9yIHRoYXQgYXMgYSB0ZW1wb3Jh
cnkgc29sdXRpb24uIEJ1dCBsaW5raW5nIGh1Z2UgYW1vdW50cyBvZiBDCj4+IGNvZGUgKGxpa2Ug
b3BlbnNzbCBvciBhIHRwbSBsaWIpIGludG8gdGhlIFNWU00gcnVzdCBiaW5hcnkga2luZCBvZgo+
PiBjb250cmFkaWN0cyB0aGUgZ29hbHMgd2hpY2ggbWFkZSB1cyB1c2luZyBSdXN0IGZvciBwcm9q
ZWN0IGluIHRoZSBmaXJzdAo+PiBwbGFjZS4gVGhhdCBpcyB3aHkgSSBvbmx5IHNlZSB0aGlzIGFz
IGEgdGVtcG9yYXJ5IHNvbHV0aW9uLgo+Pgo+Pgo+IEkgdGhpbmsgdGhlIGNyeXB0byBzdXBwb3J0
IHJlcXVpcmVzIG1vcmUgZGVzaWduIGRpc2N1c3Npb24gc2luY2UgaXQgaXMgcmVxdWlyZWQKPiBp
biBtdWx0aXBsZSBwbGFjZXMuCj4KPiBUaGUgZXhwZXJpZW5jZSBJJ3ZlIGhhZCBhZGRpbmcgU1ZT
TS12VFBNIHN1cHBvcnQgaXMgdGhhdCB0aGUgU1ZTTSBuZWVkcyBjcnlwdG8KPiBmb3IgcmVxdWVz
dGluZyBhbiBhdHRlc3RhdGlvbiByZXBvcnQgKFNOUF9HVUVTVF9SRVFVRVNUIG1lc3NhZ2VzIHNl
bnQgdG8gdGhlCj4gc2VjdXJpdHkgcHJvY2Vzc29yIFBTUCBoYXZlIHRvIGJlIGVuY3J5cHRlZCB3
aXRoIEFFU19HQ00pIGFuZCB0aGUgdlRQTSBhbHNvCj4gbmVlZHMgY3J5cHRvIGZvciB0aGUgVFBN
IGNyeXB0byBvcGVyYXRpb25zLiBXZSBjb3VsZCBqdXN0IGR1cGxpY2F0ZSB0aGUgY3J5cHRvCj4g
bGlicmFyeSwgb3IgZmluZCBhIHdheSB0byBzaGFyZSBpdCAoZS5nLiB2ZHNvIGFwcHJvYWNoKS4K
Pgo+IEZvciB0aGUgU1ZTTSwgaXQgd291bGQgYmUgcnVzdCBjb2RlIHRhbGtpbmcgdG8gdGhlIGNy
eXB0byBsaWJyYXJ5OyBmb3IgdGhlIHZUUE0KPiBpdCB3b3VsZCBiZSB0aGUgdlRQTSAobW9zdCBs
aWtlbHkgYW4gZXhpc3RpbmcgQyBpbXBsZW1lbnRhdGlvbikgdGFsa2luZyB0byB0aGUKPiBjcnlw
dG8gbGlicmFyeS4KCgpXaXRoIFNWU00sIHdlJ3JlIHJlaW50cm9kdWNpbmcgYSBuZXcgd2F5IG9m
IGRvaW5nIFNNTSBpbnNpZGUgdmlydHVhbCAKbWFjaGluZXM6IEEgaGlnaGVyIHByaXZpbGVnZSBt
b2RlIHRoYW4gY2FuIHRyYW5zcGFyZW50bHkgcnVuIGFyYml0cmFyeSAKY29kZSBhdCBhcmJpdHJh
cnkgdGltZXMsIGludmlzaWJsZSB0byB0aGUgT1MuCgpUaGF0IG1lYW5zIGFueSBidWcgaW4gdGhh
dCBjb2RlIGlzIGZhdGFsLiBUUE0gaW1wbGVtZW50YXRpb25zIG1heSAKcmVjZWl2ZSB1bnRydXN0
ZWQgaW5wdXRzIGZyb20gdXNlciBzcGFjZS4gVGhhdCBtZWFucyB3ZSBuZWVkIHRvIGNvbmZpbmUg
Cml0IGFzIHN0cm9uZ2x5IGFzIHBvc3NpYmxlOiBUaGUgc3lzY2FsbCBpbnRlcmZhY2UgbmVlZHMg
dG8gYmUgYXMgbWluaW1hbCAKYW5kIHN0YXRpYyAobm8gZHluYW1pYyBtZW1vcnkgYWxsb2NhdGlv
bnMsIG9iamVjdCBsaXZlY3ljbGVzLCBldGMpIGFzIApwb3NzaWJsZS4gVGhlIGxlc3MgbWVtb3J5
IHdlIHNoYXJlIGJldHdlZW4gdGhlIFRQTSBpbXBsZW1lbnRhdGlvbiBhbmQgCmFueXRoaW5nIG91
dHNpZGUsIHRoZSBiZXR0ZXIuIEFueSBtZW1vcnkgc2hhcmluZyBpcyBhIHBvdGVudGlhbCBzaWRl
IApjaGFubmVsIGF0dGFjayB0YXJnZXQgKGRhdGEpIG9yIHNpZGUgY2hhbm5lbCB0cmFpbmluZyB0
YXJnZXQgKGNvZGUpLgoKU28gdG8gZm9sZCB0aGlzIGludG8gdGhlIHBhcmFncmFwaCBhYm92ZTog
UGxlYXNlIGRvbid0IG92ZXJ0aGluayAvIApvdmVyZW5naW5lZXIgdGhpcy4gQXBwbGljYXRpb25z
IHNob3VsZCBiZSBhcyBzZWxmIGNvbnRhaW5lZCBhcyBwb3NzaWJsZS4gCk5vIFZEU08sIG5vIGRp
cmVjdCBsaW5raW5nLiBJZGVhbGx5IGV2ZW4gZnVsbHkgc3RhdGljIGF0IGJvb3QgbWVtb3J5IAph
bGxvY2F0aW9uLgoKCkFsZXgKCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBH
bWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlz
dGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0
IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBE
RSAyODkgMjM3IDg3OQoKCg==

