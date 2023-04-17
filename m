Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9ED06E4BF9
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 16:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbjDQOzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 10:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbjDQOzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 10:55:00 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D83EA5D4;
        Mon, 17 Apr 2023 07:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681743290; x=1713279290;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wjpu85HNbSCwnQIASo3Tl3v15mlV3vziDGcYsxXxgjo=;
  b=XSGhUcKh3xD1+918+F/wyQRC8NNA/mBw4TCSDwt2x3FVikocU7cEs8oh
   6gqoEa1QyTCx9KeLTD/EniR4RVNo+EnKQx+MK92fwj8F4tpxE1cZeyRFv
   mHjCsz7mSEj9WGPZ88VxyMGV9v28pI0ZSVkqJxxeXjZ4z/pwI2ovlP7vC
   0=;
X-IronPort-AV: E=Sophos;i="5.99,204,1677542400"; 
   d="scan'208";a="319201660"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 14:54:45 +0000
Received: from EX19D004EUA003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com (Postfix) with ESMTPS id 4D430A049A;
        Mon, 17 Apr 2023 14:54:35 +0000 (UTC)
Received: from EX19D024EUA002.ant.amazon.com (10.252.50.224) by
 EX19D004EUA003.ant.amazon.com (10.252.50.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 17 Apr 2023 14:54:34 +0000
Received: from [192.168.12.145] (10.1.213.26) by EX19D024EUA002.ant.amazon.com
 (10.252.50.224) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.26; Mon, 17 Apr
 2023 14:54:21 +0000
Message-ID: <7bc2d96b-6a32-6eaa-2e51-203b78abec2e@amazon.com>
Date:   Mon, 17 Apr 2023 17:54:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH RFC v8 20/56] crypto:ccp: Define the SEV-SNP commands
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
 <20230220183847.59159-21-michael.roth@amd.com>
Content-Language: en-US
From:   Sabin Rapan <sabrapan@amazon.com>
In-Reply-To: <20230220183847.59159-21-michael.roth@amd.com>
X-Originating-IP: [10.1.213.26]
X-ClientProxiedBy: EX19D039UWB001.ant.amazon.com (10.13.138.119) To
 EX19D024EUA002.ant.amazon.com (10.252.50.224)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMC4wMi4yMDIzIDIwOjM4LCBNaWNoYWVsIFJvdGggd3JvdGU6Cj4gRnJvbTogQnJpamVz
aCBTaW5naCA8YnJpamVzaC5zaW5naEBhbWQuY29tPgo+IAo+IEFNRCBpbnRyb2R1Y2VkIHRoZSBu
ZXh0IGdlbmVyYXRpb24gb2YgU0VWIGNhbGxlZCBTRVYtU05QIChTZWN1cmUgTmVzdGVkCj4gUGFn
aW5nKS4gU0VWLVNOUCBidWlsZHMgdXBvbiBleGlzdGluZyBTRVYgYW5kIFNFVi1FUyBmdW5jdGlv
bmFsaXR5Cj4gd2hpbGUgYWRkaW5nIG5ldyBoYXJkd2FyZSBzZWN1cml0eSBwcm90ZWN0aW9uLgo+
IAo+IERlZmluZSB0aGUgY29tbWFuZHMgYW5kIHN0cnVjdHVyZXMgdXNlZCB0byBjb21tdW5pY2F0
ZSB3aXRoIHRoZSBBTUQtU1AKPiB3aGVuIGNyZWF0aW5nIGFuZCBtYW5hZ2luZyB0aGUgU0VWLVNO
UCBndWVzdHMuIFRoZSBTRVYtU05QIGZpcm13YXJlIHNwZWMKPiBpcyBhdmFpbGFibGUgYXQgZGV2
ZWxvcGVyLmFtZC5jb20vc2V2Lgo+IAo+IENvLWRldmVsb3BlZC1ieTogQXNoaXNoIEthbHJhIDxh
c2hpc2gua2FscmFAYW1kLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBBc2hpc2ggS2FscmEgPGFzaGlz
aC5rYWxyYUBhbWQuY29tPgo+IFNpZ25lZC1vZmYtYnk6IEJyaWplc2ggU2luZ2ggPGJyaWplc2gu
c2luZ2hAYW1kLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWVsIFJvdGggPG1pY2hhZWwucm90
aEBhbWQuY29tPgo+IC0tLQo+ICBkcml2ZXJzL2NyeXB0by9jY3Avc2V2LWRldi5jIHwgIDE2ICsr
Kwo+ICBpbmNsdWRlL2xpbnV4L3BzcC1zZXYuaCAgICAgIHwgMjQ3ICsrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrCj4gIGluY2x1ZGUvdWFwaS9saW51eC9wc3Atc2V2LmggfCAgNDQg
KysrKysrKwo+ICAzIGZpbGVzIGNoYW5nZWQsIDMwNyBpbnNlcnRpb25zKCspCj4gCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvY3J5cHRvL2NjcC9zZXYtZGV2LmMgYi9kcml2ZXJzL2NyeXB0by9jY3Av
c2V2LWRldi5jCj4gaW5kZXggMDZmYzcxNTZjMDRmLi45ZDg0NzIwYTQxZDcgMTAwNjQ0Cj4gLS0t
IGEvZHJpdmVycy9jcnlwdG8vY2NwL3Nldi1kZXYuYwo+ICsrKyBiL2RyaXZlcnMvY3J5cHRvL2Nj
cC9zZXYtZGV2LmMKPiBAQCAtMTI2LDYgKzEyNiw4IEBAIHN0YXRpYyBpbnQgc2V2X2NtZF9idWZm
ZXJfbGVuKGludCBjbWQpCj4gIAlzd2l0Y2ggKGNtZCkgewo+ICAJY2FzZSBTRVZfQ01EX0lOSVQ6
CQkJcmV0dXJuIHNpemVvZihzdHJ1Y3Qgc2V2X2RhdGFfaW5pdCk7Cj4gIAljYXNlIFNFVl9DTURf
SU5JVF9FWDogICAgICAgICAgICAgICAgICAgcmV0dXJuIHNpemVvZihzdHJ1Y3Qgc2V2X2RhdGFf
aW5pdF9leCk7Cj4gKwljYXNlIFNFVl9DTURfU05QX1NIVVRET1dOX0VYOgkJcmV0dXJuIHNpemVv
ZihzdHJ1Y3Qgc2V2X2RhdGFfc25wX3NodXRkb3duX2V4KTsKPiArCWNhc2UgU0VWX0NNRF9TTlBf
SU5JVF9FWDoJCXJldHVybiBzaXplb2Yoc3RydWN0IHNldl9kYXRhX3NucF9pbml0X2V4KTsKPiAg
CWNhc2UgU0VWX0NNRF9QTEFURk9STV9TVEFUVVM6CQlyZXR1cm4gc2l6ZW9mKHN0cnVjdCBzZXZf
dXNlcl9kYXRhX3N0YXR1cyk7Cj4gIAljYXNlIFNFVl9DTURfUEVLX0NTUjoJCQlyZXR1cm4gc2l6
ZW9mKHN0cnVjdCBzZXZfZGF0YV9wZWtfY3NyKTsKPiAgCWNhc2UgU0VWX0NNRF9QRUtfQ0VSVF9J
TVBPUlQ6CQlyZXR1cm4gc2l6ZW9mKHN0cnVjdCBzZXZfZGF0YV9wZWtfY2VydF9pbXBvcnQpOwo+
IEBAIC0xNTQsNiArMTU2LDIwIEBAIHN0YXRpYyBpbnQgc2V2X2NtZF9idWZmZXJfbGVuKGludCBj
bWQpCj4gIAljYXNlIFNFVl9DTURfR0VUX0lEOgkJCXJldHVybiBzaXplb2Yoc3RydWN0IHNldl9k
YXRhX2dldF9pZCk7Cj4gIAljYXNlIFNFVl9DTURfQVRURVNUQVRJT05fUkVQT1JUOglyZXR1cm4g
c2l6ZW9mKHN0cnVjdCBzZXZfZGF0YV9hdHRlc3RhdGlvbl9yZXBvcnQpOwo+ICAJY2FzZSBTRVZf
Q01EX1NFTkRfQ0FOQ0VMOgkJcmV0dXJuIHNpemVvZihzdHJ1Y3Qgc2V2X2RhdGFfc2VuZF9jYW5j
ZWwpOwo+ICsJY2FzZSBTRVZfQ01EX1NOUF9HQ1RYX0NSRUFURToJCXJldHVybiBzaXplb2Yoc3Ry
dWN0IHNldl9kYXRhX3NucF9hZGRyKTsKPiArCWNhc2UgU0VWX0NNRF9TTlBfTEFVTkNIX1NUQVJU
OgkJcmV0dXJuIHNpemVvZihzdHJ1Y3Qgc2V2X2RhdGFfc25wX2xhdW5jaF9zdGFydCk7Cj4gKwlj
YXNlIFNFVl9DTURfU05QX0xBVU5DSF9VUERBVEU6CQlyZXR1cm4gc2l6ZW9mKHN0cnVjdCBzZXZf
ZGF0YV9zbnBfbGF1bmNoX3VwZGF0ZSk7Cj4gKwljYXNlIFNFVl9DTURfU05QX0FDVElWQVRFOgkJ
cmV0dXJuIHNpemVvZihzdHJ1Y3Qgc2V2X2RhdGFfc25wX2FjdGl2YXRlKTsKPiArCWNhc2UgU0VW
X0NNRF9TTlBfREVDT01NSVNTSU9OOgkJcmV0dXJuIHNpemVvZihzdHJ1Y3Qgc2V2X2RhdGFfc25w
X2FkZHIpOwo+ICsJY2FzZSBTRVZfQ01EX1NOUF9QQUdFX1JFQ0xBSU06CQlyZXR1cm4gc2l6ZW9m
KHN0cnVjdCBzZXZfZGF0YV9zbnBfcGFnZV9yZWNsYWltKTsKPiArCWNhc2UgU0VWX0NNRF9TTlBf
R1VFU1RfU1RBVFVTOgkJcmV0dXJuIHNpemVvZihzdHJ1Y3Qgc2V2X2RhdGFfc25wX2d1ZXN0X3N0
YXR1cyk7Cj4gKwljYXNlIFNFVl9DTURfU05QX0xBVU5DSF9GSU5JU0g6CQlyZXR1cm4gc2l6ZW9m
KHN0cnVjdCBzZXZfZGF0YV9zbnBfbGF1bmNoX2ZpbmlzaCk7Cj4gKwljYXNlIFNFVl9DTURfU05Q
X0RCR19ERUNSWVBUOgkJcmV0dXJuIHNpemVvZihzdHJ1Y3Qgc2V2X2RhdGFfc25wX2RiZyk7Cj4g
KwljYXNlIFNFVl9DTURfU05QX0RCR19FTkNSWVBUOgkJcmV0dXJuIHNpemVvZihzdHJ1Y3Qgc2V2
X2RhdGFfc25wX2RiZyk7Cj4gKwljYXNlIFNFVl9DTURfU05QX1BBR0VfVU5TTUFTSDoJCXJldHVy
biBzaXplb2Yoc3RydWN0IHNldl9kYXRhX3NucF9wYWdlX3Vuc21hc2gpOwo+ICsJY2FzZSBTRVZf
Q01EX1NOUF9QTEFURk9STV9TVEFUVVM6CXJldHVybiBzaXplb2Yoc3RydWN0IHNldl9kYXRhX3Nu
cF9hZGRyKTsKPiArCWNhc2UgU0VWX0NNRF9TTlBfR1VFU1RfUkVRVUVTVDoJCXJldHVybiBzaXpl
b2Yoc3RydWN0IHNldl9kYXRhX3NucF9ndWVzdF9yZXF1ZXN0KTsKPiArCWNhc2UgU0VWX0NNRF9T
TlBfQ09ORklHOgkJcmV0dXJuIHNpemVvZihzdHJ1Y3Qgc2V2X3VzZXJfZGF0YV9zbnBfY29uZmln
KTsKClRoaXMgbmVlZHMgU0VWX0NNRF9TTlBfRE9XTkxPQURfRklSTVdBUkVfRVgsIFNFVl9DTURf
U05QX0NPTU1JVCBhbmQKU0VWX0NNRF9TTlBfVkxFS19MT0FEIGZyb20gMS41NCBBQkkgcmVsZWFz
ZS4KCj4gIAlkZWZhdWx0OgkJCQlyZXR1cm4gMDsKPiAgCX0KPiAgCj4gKy8qKgo+ICsgKiBzdHJ1
Y3Qgc2V2X3VzZXJfZGF0YV9zbnBfc3RhdHVzIC0gU05QIHN0YXR1cwo+ICsgKgo+ICsgKiBAbWFq
b3I6IEFQSSBtYWpvciB2ZXJzaW9uCj4gKyAqIEBtaW5vcjogQVBJIG1pbm9yIHZlcnNpb24KPiAr
ICogQHN0YXRlOiBjdXJyZW50IHBsYXRmb3JtIHN0YXRlCj4gKyAqIEBidWlsZDogZmlybXdhcmUg
YnVpbGQgaWQgZm9yIHRoZSBBUEkgdmVyc2lvbgo+ICsgKiBAZ3Vlc3RfY291bnQ6IHRoZSBudW1i
ZXIgb2YgZ3Vlc3QgY3VycmVudGx5IG1hbmFnZWQgYnkgdGhlIGZpcm13YXJlCj4gKyAqIEB0Y2Jf
dmVyc2lvbjogY3VycmVudCBUQ0IgdmVyc2lvbgo+ICsgKi8KPiArc3RydWN0IHNldl91c2VyX2Rh
dGFfc25wX3N0YXR1cyB7Cj4gKwlfX3U4IGFwaV9tYWpvcjsJCS8qIE91dCAqLwo+ICsJX191OCBh
cGlfbWlub3I7CQkvKiBPdXQgKi8KPiArCV9fdTggc3RhdGU7CQkvKiBPdXQgKi8KPiArCV9fdTgg
cnN2ZDsKPiArCV9fdTMyIGJ1aWxkX2lkOwkJLyogT3V0ICovCj4gKwlfX3UzMiByc3ZkMTsKPiAr
CV9fdTMyIGd1ZXN0X2NvdW50OwkvKiBPdXQgKi8KPiArCV9fdTY0IHRjYl92ZXJzaW9uOwkvKiBP
dXQgKi8KPiArCV9fdTY0IHJzdmQyOwo+ICt9IF9fcGFja2VkOwoKQ291bGQgeW91IHBsZWFzZSB1
cGRhdGUgdGhpcyB0byAxLjU0IEFCSSB2ZXJzaW9uPwpTaG91bGQgaW5jbHVkZSBzb21ldGhpbmcg
YWxvbmcgdGhlc2UgbGluZXM6CgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L3BzcC1z
ZXYuaCBiL2luY2x1ZGUvdWFwaS9saW51eC9wc3Atc2V2LmgKaW5kZXggNjBlN2E4ZDFhMThlLi5l
OWViZDI0ZWYwODUgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9wc3Atc2V2LmgKKysr
IGIvaW5jbHVkZS91YXBpL2xpbnV4L3BzcC1zZXYuaApAQCAtMTYzLDIwICsxNjMsMjkgQEAgc3Ry
dWN0IHNldl91c2VyX2RhdGFfZ2V0X2lkMiB7CiAgKiBAbWFqb3I6IEFQSSBtYWpvciB2ZXJzaW9u
CiAgKiBAbWlub3I6IEFQSSBtaW5vciB2ZXJzaW9uCiAgKiBAc3RhdGU6IGN1cnJlbnQgcGxhdGZv
cm0gc3RhdGUKKyAqIEBpc19ybXBfaW5pdGlhbGl6ZWQ6IHdoZXRoZXIgUk1QIGlzIGluaXRpYWxp
emVkIG9yIG5vdAogICogQGJ1aWxkOiBmaXJtd2FyZSBidWlsZCBpZCBmb3IgdGhlIEFQSSB2ZXJz
aW9uCisgKiBAbWFza19jaGlwX2lkOiB3aGV0aGVyIGNoaXAgaWQgaXMgcHJlc2VudCBpbiBhdHRl
c3RhdGlvbiByZXBvcnRzIG9yIG5vdAorICogQG1hc2tfY2hpcF9rZXk6IHdoZXRoZXIgYXR0ZXN0
YXRpb24gcmVwb3J0cyBhcmUgc2lnbmVkIG9yIG5vdAorICogQHZsZWtfZW46IFZMRUsgaGFzaHN0
aWNrIGlzIGxvYWRlZAogICogQGd1ZXN0X2NvdW50OiB0aGUgbnVtYmVyIG9mIGd1ZXN0IGN1cnJl
bnRseSBtYW5hZ2VkIGJ5IHRoZSBmaXJtd2FyZQotICogQHRjYl92ZXJzaW9uOiBjdXJyZW50IFRD
QiB2ZXJzaW9uCisgKiBAY3VycmVudF90Y2JfdmVyc2lvbjogY3VycmVudCBUQ0IgdmVyc2lvbgor
ICogQHJlcG9ydGVkX3RjYl92ZXJzaW9uOiByZXBvcnRlZCBUQ0IgdmVyc2lvbgogICovCiBzdHJ1
Y3Qgc2V2X3VzZXJfZGF0YV9zbnBfc3RhdHVzIHsKLSAgICAgICBfX3U4IGFwaV9tYWpvcjsgICAg
ICAgICAvKiBPdXQgKi8KLSAgICAgICBfX3U4IGFwaV9taW5vcjsgICAgICAgICAvKiBPdXQgKi8K
LSAgICAgICBfX3U4IHN0YXRlOyAgICAgICAgICAgICAvKiBPdXQgKi8KLSAgICAgICBfX3U4IHJz
dmQ7Ci0gICAgICAgX191MzIgYnVpbGRfaWQ7ICAgICAgICAgLyogT3V0ICovCi0gICAgICAgX191
MzIgcnN2ZDE7Ci0gICAgICAgX191MzIgZ3Vlc3RfY291bnQ7ICAgICAgLyogT3V0ICovCi0gICAg
ICAgX191NjQgdGNiX3ZlcnNpb247ICAgICAgLyogT3V0ICovCi0gICAgICAgX191NjQgcnN2ZDI7
CisgICAgICAgX191OCBhcGlfbWFqb3I7ICAgICAgICAgICAgIC8qIE91dCAqLworICAgICAgIF9f
dTggYXBpX21pbm9yOyAgICAgICAgICAgICAvKiBPdXQgKi8KKyAgICAgICBfX3U4IHN0YXRlOyAg
ICAgICAgICAgICAgICAgLyogT3V0ICovCisgICAgICAgX191OCBpc19ybXBfaW5pdGlhbGl6ZWQ6
MTsgIC8qIE91dCAqLworICAgICAgIF9fdTggcnN2ZDo3OworICAgICAgIF9fdTMyIGJ1aWxkX2lk
OyAgICAgICAgICAgICAvKiBPdXQgKi8KKyAgICAgICBfX3UzMiBtYXNrX2NoaXBfaWQ6MTsgICAg
ICAgLyogT3V0ICovCisgICAgICAgX191MzIgbWFza19jaGlwX2tleToxOyAgICAgIC8qIE91dCAq
LworICAgICAgIF9fdTMyIHZsZWtfZW46MTsgICAgICAgICAgICAvKiBPdXQgKi8KKyAgICAgICBf
X3UzMiByc3ZkMToyOTsKKyAgICAgICBfX3UzMiBndWVzdF9jb3VudDsgICAgICAgICAgLyogT3V0
ICovCisgICAgICAgX191NjQgY3VycmVudF90Y2JfdmVyc2lvbjsgIC8qIE91dCAqLworICAgICAg
IF9fdTY0IHJlcG9ydGVkX3RjYl92ZXJzaW9uOyAvKiBPdXQgKi8KIH0gX19wYWNrZWQ7CgogLyoK
CgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQg
b2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBD
b3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRp
b24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==

