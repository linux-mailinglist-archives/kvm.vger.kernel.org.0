Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B316C801A
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 15:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbjCXOla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 10:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjCXOl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 10:41:29 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC5D5FD6;
        Fri, 24 Mar 2023 07:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679668876; x=1711204876;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=djdDyOQEhRpjTdDX9E9eh9RPf/+S/Hlq/oRhX87DyXg=;
  b=HhuS9rrAWm+0UXI54GPkWb9CF9kVVnLlMLKmOXdNP7cAPu/hffCcGJay
   jXZsluMDJyUNZVOSKCTK0Hu6iKhcNJLM2r2yOjfdZD/PhwVBOn2TXTY8w
   NFABLiYkMIspZ7zmaidJ7WrYJ5gEmB11XZVRhc+vnK7ll8I7gxSmWRy0F
   4=;
X-IronPort-AV: E=Sophos;i="5.98,288,1673913600"; 
   d="scan'208";a="310968051"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 14:41:13 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com (Postfix) with ESMTPS id 740A884CE6;
        Fri, 24 Mar 2023 14:41:01 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 24 Mar 2023 14:40:58 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.26; Fri, 24 Mar
 2023 14:40:47 +0000
Message-ID: <6b841d82-ad94-561a-3175-469b5e45eb47@amazon.com>
Date:   Fri, 24 Mar 2023 15:40:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH RFC v8 36/56] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH
 command
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Harald Hoyer" <harald@profian.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-37-michael.roth@amd.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <20230220183847.59159-37-michael.roth@amd.com>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D036UWC004.ant.amazon.com (10.13.139.205) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMjAuMDIuMjMgMTk6MzgsIE1pY2hhZWwgUm90aCB3cm90ZToKPiBGcm9tOiBCcmlqZXNoIFNp
bmdoIDxicmlqZXNoLnNpbmdoQGFtZC5jb20+Cj4KPiBUaGUgS1ZNX1NFVl9TTlBfTEFVTkNIX0ZJ
TklTSCBmaW5hbGl6ZSB0aGUgY3J5cHRvZ3JhcGhpYyBkaWdlc3QgYW5kIHN0b3Jlcwo+IGl0IGFz
IHRoZSBtZWFzdXJlbWVudCBvZiB0aGUgZ3Vlc3QgYXQgbGF1bmNoLgo+Cj4gV2hpbGUgZmluYWxp
emluZyB0aGUgbGF1bmNoIGZsb3csIGl0IGFsc28gaXNzdWVzIHRoZSBMQVVOQ0hfVVBEQVRFIGNv
bW1hbmQKPiB0byBlbmNyeXB0IHRoZSBWTVNBIHBhZ2VzLgo+Cj4gSWYgaXRzIGFuIFNOUCBndWVz
dCwgdGhlbiBWTVNBIHdhcyBhZGRlZCBpbiB0aGUgUk1QIGVudHJ5IGFzCj4gYSBndWVzdCBvd25l
ZCBwYWdlIGFuZCBhbHNvIHJlbW92ZWQgZnJvbSB0aGUga2VybmVsIGRpcmVjdCBtYXAKPiBzbyBm
bHVzaCBpdCBsYXRlciBhZnRlciBpdCBpcyB0cmFuc2l0aW9uZWQgYmFjayB0byBoeXBlcnZpc29y
Cj4gc3RhdGUgYW5kIHJlc3RvcmVkIGluIHRoZSBkaXJlY3QgbWFwLgo+Cj4gU2lnbmVkLW9mZi1i
eTogQnJpamVzaCBTaW5naCA8YnJpamVzaC5zaW5naEBhbWQuY29tPgo+IFNpZ25lZC1vZmYtYnk6
IEhhcmFsZCBIb3llciA8aGFyYWxkQHByb2ZpYW4uY29tPgo+IFNpZ25lZC1vZmYtYnk6IEFzaGlz
aCBLYWxyYSA8YXNoaXNoLmthbHJhQGFtZC5jb20+Cj4gU2lnbmVkLW9mZi1ieTogTWljaGFlbCBS
b3RoIDxtaWNoYWVsLnJvdGhAYW1kLmNvbT4KPiAtLS0KPiAgIC4uLi92aXJ0L2t2bS94ODYvYW1k
LW1lbW9yeS1lbmNyeXB0aW9uLnJzdCAgICB8ICAyMyArKysrCj4gICBhcmNoL3g4Ni9rdm0vc3Zt
L3Nldi5jICAgICAgICAgICAgICAgICAgICAgICAgfCAxMjIgKysrKysrKysrKysrKysrKysrCj4g
ICBpbmNsdWRlL3VhcGkvbGludXgva3ZtLmggICAgICAgICAgICAgICAgICAgICAgfCAgMTQgKysK
PiAgIDMgZmlsZXMgY2hhbmdlZCwgMTU5IGluc2VydGlvbnMoKykKPgpbLi4uXQoKCj4gZGlmZiAt
LWdpdCBhL2FyY2gveDg2L2t2bS9zdm0vc2V2LmMgYi9hcmNoL3g4Ni9rdm0vc3ZtL3Nldi5jCj4g
aW5kZXggMDNkZDIyN2Y2MDkwLi41MTVlMjJkMGRjMzAgMTAwNjQ0Cj4gLS0tIGEvYXJjaC94ODYv
a3ZtL3N2bS9zZXYuYwo+ICsrKyBiL2FyY2gveDg2L2t2bS9zdm0vc2V2LmMKPiBAQCAtMjI4MCw2
ICsyMjgwLDEwOSBAQCBzdGF0aWMgaW50IHNucF9sYXVuY2hfdXBkYXRlKHN0cnVjdCBrdm0gKmt2
bSwgc3RydWN0IGt2bV9zZXZfY21kICphcmdwKQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHNucF9sYXVuY2hfdXBkYXRlX2dmbl9oYW5kbGVyLCBhcmdwKTsKPiAgIH0K
Pgo+ICtzdGF0aWMgaW50IHNucF9sYXVuY2hfdXBkYXRlX3Ztc2Eoc3RydWN0IGt2bSAqa3ZtLCBz
dHJ1Y3Qga3ZtX3Nldl9jbWQgKmFyZ3ApCj4gK3sKPiArICAgICAgIHN0cnVjdCBrdm1fc2V2X2lu
Zm8gKnNldiA9ICZ0b19rdm1fc3ZtKGt2bSktPnNldl9pbmZvOwo+ICsgICAgICAgc3RydWN0IHNl
dl9kYXRhX3NucF9sYXVuY2hfdXBkYXRlIGRhdGEgPSB7fTsKPiArICAgICAgIHN0cnVjdCBrdm1f
dmNwdSAqdmNwdTsKPiArICAgICAgIHVuc2lnbmVkIGxvbmcgaTsKPiArICAgICAgIGludCByZXQ7
Cj4gKwo+ICsgICAgICAgZGF0YS5nY3R4X3BhZGRyID0gX19wc3BfcGEoc2V2LT5zbnBfY29udGV4
dCk7Cj4gKyAgICAgICBkYXRhLnBhZ2VfdHlwZSA9IFNOUF9QQUdFX1RZUEVfVk1TQTsKPiArCj4g
KyAgICAgICBrdm1fZm9yX2VhY2hfdmNwdShpLCB2Y3B1LCBrdm0pIHsKPiArICAgICAgICAgICAg
ICAgc3RydWN0IHZjcHVfc3ZtICpzdm0gPSB0b19zdm0odmNwdSk7Cj4gKyAgICAgICAgICAgICAg
IHU2NCBwZm4gPSBfX3BhKHN2bS0+c2V2X2VzLnZtc2EpID4+IFBBR0VfU0hJRlQ7Cj4gKwo+ICsg
ICAgICAgICAgICAgICAvKiBQZXJmb3JtIHNvbWUgcHJlLWVuY3J5cHRpb24gY2hlY2tzIGFnYWlu
c3QgdGhlIFZNU0EgKi8KPiArICAgICAgICAgICAgICAgcmV0ID0gc2V2X2VzX3N5bmNfdm1zYShz
dm0pOwo+ICsgICAgICAgICAgICAgICBpZiAocmV0KQo+ICsgICAgICAgICAgICAgICAgICAgICAg
IHJldHVybiByZXQ7Cj4gKwo+ICsgICAgICAgICAgICAgICAvKiBUcmFuc2l0aW9uIHRoZSBWTVNB
IHBhZ2UgdG8gYSBmaXJtd2FyZSBzdGF0ZS4gKi8KPiArICAgICAgICAgICAgICAgcmV0ID0gcm1w
X21ha2VfcHJpdmF0ZShwZm4sIC0xLCBQR19MRVZFTF80Sywgc2V2LT5hc2lkLCB0cnVlKTsKPiAr
ICAgICAgICAgICAgICAgaWYgKHJldCkKPiArICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4g
cmV0Owo+ICsKPiArICAgICAgICAgICAgICAgLyogSXNzdWUgdGhlIFNOUCBjb21tYW5kIHRvIGVu
Y3J5cHQgdGhlIFZNU0EgKi8KPiArICAgICAgICAgICAgICAgZGF0YS5hZGRyZXNzID0gX19zbWVf
cGEoc3ZtLT5zZXZfZXMudm1zYSk7Cj4gKyAgICAgICAgICAgICAgIHJldCA9IF9fc2V2X2lzc3Vl
X2NtZChhcmdwLT5zZXZfZmQsIFNFVl9DTURfU05QX0xBVU5DSF9VUERBVEUsCj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAmZGF0YSwgJmFyZ3AtPmVycm9yKTsKCgpUaGVy
ZSBpcyBubyBjb250cmFjdCBpbiBLVk0gdGhhdCBkaWN0YXRlcyB0aGF0IHRoZSBmaXJzdCBlbnRy
eSBpbiB0aGUgCnZjcHUgbGlzdCBuZWVkcyB0byBiZSB2Y3B1X2lkPT0wIChCU1ApLiBUaGF0IG1l
YW5zIGlmIHlvdSB1c2UgYSB1c2VyIApzcGFjZSB0aGF0IHNwYXducyB2Q1BVcyBpbiBwYXJhbGxl
bCBvbiBpbml0LCB5b3Ugd2lsbCBlbmQgdXAgd2l0aCB0aGUgCkJTUCBiZWhpbmQgQVBzIGluIHRo
ZSBMQVVOQ0hfVVBEQVRFIG9yZGVyLgoKVGhpcyBpcyBhIHByb2JsZW0gYmVjYXVzZSBmb3IgTEFV
TkNIX1VQREFURSwgdGhlIG9yZGVyIG1hdHRlcnMuIEJTUCBhbmQgCkFQIHZDUFVzIGhhdmUgZGlm
ZmVyZW50IGluaXRpYWwgc3RhdGUgYW5kIHNvIGlmIHlvdSB3YW50IHRvIHJlY29uc3RydWN0IAp0
aGUgbGF1bmNoIGRpZ2VzdCwgeW91IG5lZWQgdG8gZW5zdXJlIHRoYXQgdGhlIGd1ZXN0IGtub3dz
IHRoZSBvcmRlci4KClRoZSBlYXNpZXN0IHdheSBJIGNhbiB0aGluayBvZiB0byBmaXggdGhpcyBp
cyB0byBjYWxsIApzbnBfbGF1bmNoX3VwZGF0ZV92bXNhIHR3aWNlOiBPbmNlIGZpbHRlcmluZyBm
b3IgdmNwdV9pZCA9PSAwIGFuZCBvbmNlIApmb3IgdmNwdV9pZCAhPSAwLgoKClRoYW5rcywKCkFs
ZXgKCgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3Ry
LiAzOAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2Vy
LCBKb25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVy
ZyB1bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkK
Cgo=

