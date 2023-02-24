Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33EC26A1B14
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 12:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbjBXLEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 06:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjBXLES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 06:04:18 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D1569AE1;
        Fri, 24 Feb 2023 03:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677236564; x=1708772564;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iP2Q1rCCDs5/6HCe0OSpJ2pmAxSDIeCTZ67VN6uLvus=;
  b=pPWphUBSiz1NdTtOTkC2fXgTtGF88KvTD65BGDV6xjn8grcLyrmKlMgF
   kG0Gy3op4gxetj7fQYqJacRfnVHeU32LJggmWGUuffAPgVqE5oNEMyIRm
   MKAi6ysIz9XauHSpY5OUM5xObxufv4cnO5ZxqURqayrbqToQ7OprL5f4q
   I=;
X-IronPort-AV: E=Sophos;i="5.97,324,1669075200"; 
   d="scan'208";a="185961388"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 11:02:02 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com (Postfix) with ESMTPS id 138A3E431E;
        Fri, 24 Feb 2023 11:01:50 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Fri, 24 Feb 2023 11:01:48 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.24; Fri, 24 Feb
 2023 11:01:40 +0000
Message-ID: <f79922de-c498-b471-01f3-54c35ee415ad@amazon.com>
Date:   Fri, 24 Feb 2023 12:01:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v8 45/56] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
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
        Brijesh Singh <brijesh.singh@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-46-michael.roth@amd.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <20230220183847.59159-46-michael.roth@amd.com>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D040UWA002.ant.amazon.com (10.13.139.113) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDIwLjAyLjIzIDE5OjM4LCBNaWNoYWVsIFJvdGggd3JvdGU6Cj4gRnJvbTogQnJpamVzaCBT
aW5naCA8YnJpamVzaC5zaW5naEBhbWQuY29tPgo+Cj4gVmVyc2lvbiAyIG9mIEdIQ0Igc3BlY2lm
aWNhdGlvbiBhZGRlZCB0aGUgc3VwcG9ydCBmb3IgdHdvIFNOUCBHdWVzdAo+IFJlcXVlc3QgTWVz
c2FnZSBOQUUgZXZlbnRzLiBUaGUgZXZlbnRzIGFsbG93cyBmb3IgYW4gU0VWLVNOUCBndWVzdCB0
bwo+IG1ha2UgcmVxdWVzdCB0byB0aGUgU0VWLVNOUCBmaXJtd2FyZSB0aHJvdWdoIGh5cGVydmlz
b3IgdXNpbmcgdGhlCj4gU05QX0dVRVNUX1JFUVVFU1QgQVBJIGRlZmluZSBpbiB0aGUgU0VWLVNO
UCBmaXJtd2FyZSBzcGVjaWZpY2F0aW9uLgo+Cj4gVGhlIFNOUF9FWFRfR1VFU1RfUkVRVUVTVCBp
cyBzaW1pbGFyIHRvIFNOUF9HVUVTVF9SRVFVRVNUIHdpdGggdGhlCj4gZGlmZmVyZW5jZSBvZiBh
biBhZGRpdGlvbmFsIGNlcnRpZmljYXRlIGJsb2IgdGhhdCBjYW4gYmUgcGFzc2VkIHRocm91Z2gK
PiB0aGUgU05QX1NFVF9DT05GSUcgaW9jdGwgZGVmaW5lZCBpbiB0aGUgQ0NQIGRyaXZlci4gVGhl
IENDUCBkcml2ZXIKPiBwcm92aWRlcyBzbnBfZ3Vlc3RfZXh0X2d1ZXN0X3JlcXVlc3QoKSB0aGF0
IGlzIHVzZWQgYnkgdGhlIEtWTSB0byBnZXQKPiBib3RoIHRoZSByZXBvcnQgYW5kIGNlcnRpZmlj
YXRlIGRhdGEgYXQgb25jZS4KPgo+IFNpZ25lZC1vZmYtYnk6IEJyaWplc2ggU2luZ2ggPGJyaWpl
c2guc2luZ2hAYW1kLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBBc2hpc2ggS2FscmEgPGFzaGlzaC5r
YWxyYUBhbWQuY29tPgo+IFNpZ25lZC1vZmYtYnk6IE1pY2hhZWwgUm90aCA8bWljaGFlbC5yb3Ro
QGFtZC5jb20+Cj4gLS0tCj4gICBhcmNoL3g4Ni9rdm0vc3ZtL3Nldi5jIHwgMTg1ICsrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tCj4gICBhcmNoL3g4Ni9rdm0vc3ZtL3N2
bS5oIHwgICAyICsKPiAgIDIgZmlsZXMgY2hhbmdlZCwgMTgxIGluc2VydGlvbnMoKyksIDYgZGVs
ZXRpb25zKC0pCj4KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3N2bS9zZXYuYyBiL2FyY2gv
eDg2L2t2bS9zdm0vc2V2LmMKPiBpbmRleCAxOTdiMWY5MDQ1NjcuLjkyMTc5NjE0MTAyZSAxMDA2
NDQKPiAtLS0gYS9hcmNoL3g4Ni9rdm0vc3ZtL3Nldi5jCj4gKysrIGIvYXJjaC94ODYva3ZtL3N2
bS9zZXYuYwo+IEBAIC0zMjcsNiArMzI3LDcgQEAgc3RhdGljIGludCBzZXZfZ3Vlc3RfaW5pdChz
dHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fc2V2X2NtZCAqYXJncCkKPiAgICAgICAgICAgICAg
ICAgIGlmIChyZXQpCj4gICAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gZV9mcmVlOwo+Cj4g
KyAgICAgICAgICAgICAgIG11dGV4X2luaXQoJnNldi0+Z3Vlc3RfcmVxX2xvY2spOwo+ICAgICAg
ICAgICAgICAgICAgcmV0ID0gc2V2X3NucF9pbml0KCZhcmdwLT5lcnJvciwgZmFsc2UpOwo+ICAg
ICAgICAgIH0gZWxzZSB7Cj4gICAgICAgICAgICAgICAgICByZXQgPSBzZXZfcGxhdGZvcm1faW5p
dCgmYXJncC0+ZXJyb3IpOwo+IEBAIC0yMDU5LDIzICsyMDYwLDM0IEBAIGludCBzZXZfdm1fbW92
ZV9lbmNfY29udGV4dF9mcm9tKHN0cnVjdCBrdm0gKmt2bSwgdW5zaWduZWQgaW50IHNvdXJjZV9m
ZCkKPiAgICAqLwo+ICAgc3RhdGljIHZvaWQgKnNucF9jb250ZXh0X2NyZWF0ZShzdHJ1Y3Qga3Zt
ICprdm0sIHN0cnVjdCBrdm1fc2V2X2NtZCAqYXJncCkKPiAgIHsKPiArICAgICAgIHN0cnVjdCBr
dm1fc2V2X2luZm8gKnNldiA9ICZ0b19rdm1fc3ZtKGt2bSktPnNldl9pbmZvOwo+ICAgICAgICAg
IHN0cnVjdCBzZXZfZGF0YV9zbnBfYWRkciBkYXRhID0ge307Cj4gLSAgICAgICB2b2lkICpjb250
ZXh0Owo+ICsgICAgICAgdm9pZCAqY29udGV4dCwgKmNlcnRzX2RhdGE7Cj4gICAgICAgICAgaW50
IHJjOwo+Cj4gKyAgICAgICAvKiBBbGxvY2F0ZSBtZW1vcnkgdXNlZCBmb3IgdGhlIGNlcnRzIGRh
dGEgaW4gU05QIGd1ZXN0IHJlcXVlc3QgKi8KPiArICAgICAgIGNlcnRzX2RhdGEgPSBremFsbG9j
KFNFVl9GV19CTE9CX01BWF9TSVpFLCBHRlBfS0VSTkVMX0FDQ09VTlQpOwo+ICsgICAgICAgaWYg
KCFjZXJ0c19kYXRhKQo+ICsgICAgICAgICAgICAgICByZXR1cm4gTlVMTDsKCgpJIGRvbid0IHVu
ZGVyc3RhbmQgd2h5IHRoaXMgaXMgcGFydCBvZiB0aGUgY29udGV4dCBjcmVhdGlvbiwgd2hpY2gg
YWdhaW4gCmlzIHBhcnQgb2YgdGhlIEtWTV9TRVZfU05QX0xBVU5DSF9TVEFSVCBvcC4gV291bGQg
eW91IG1pbmQgdG8gY3JlYXRlIGEgCnNlcGFyYXRlIG9wIGZvciB0aGlzIGFuZCB0aGVuIGNoZWNr
IGxhdGVyIG9uIHdoaWxlIHlvdSB1c2UgdGhlIGJ1ZmZlciAKd2hldGhlciBpdCB3YXMgZXZlciBh
bGxvY2F0ZWQ/CgoKQWxleAoKCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBH
bWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlz
dGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0
IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBE
RSAyODkgMjM3IDg3OQoKCg==

