Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4CA7209BA
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 21:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237199AbjFBTWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 15:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237185AbjFBTWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 15:22:06 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0561A2
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 12:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685733719; x=1717269719;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0+2EmerWvVDRWhIJXXyWZdIJp7gQtDoC/JUh/FhHPM0=;
  b=d2cF4rsAWN4h/xbbDTFPStQoNxmebD+hKl3XULBoFBM33gnuaMYkEOMg
   RYmN3kMoatWs1N+QBe9YXNT+PAjYH84c9goDOY6/ubfxxO/wa947Fr5ap
   Vs1YdGTdUfqkCwNPbiXNe4WWNK+xV7t63H1gJzF3RL+4m3OzmT8lk59Pe
   E=;
X-IronPort-AV: E=Sophos;i="6.00,214,1681171200"; 
   d="scan'208";a="1135338111"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-a893d89c.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 19:21:58 +0000
Received: from EX19MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-a893d89c.us-west-2.amazon.com (Postfix) with ESMTPS id A21954141A;
        Fri,  2 Jun 2023 19:21:57 +0000 (UTC)
Received: from EX19D030UWB003.ant.amazon.com (10.13.139.142) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 2 Jun 2023 19:21:46 +0000
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX19D030UWB003.ant.amazon.com (10.13.139.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 2 Jun 2023 19:21:46 +0000
Received: from EX19D030UWB002.ant.amazon.com ([fe80::8cbd:fcae:56ad:4dfa]) by
 EX19D030UWB002.ant.amazon.com ([fe80::8cbd:fcae:56ad:4dfa%6]) with mapi id
 15.02.1118.026; Fri, 2 Jun 2023 19:21:46 +0000
From:   "Jitindar Singh, Suraj" <surajjs@amazon.com>
To:     "jingzhangos@google.com" <jingzhangos@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "oupton@google.com" <oupton@google.com>
CC:     "james.morse@arm.com" <james.morse@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "rananta@google.com" <rananta@google.com>,
        "tabba@google.com" <tabba@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alexandru.elisei@arm.com" <alexandru.elisei@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "reijiw@google.com" <reijiw@google.com>
Subject: Re: [PATCH v11 5/5] KVM: arm64: Refactor writings for
 PMUVer/CSV2/CSV3
Thread-Topic: [PATCH v11 5/5] KVM: arm64: Refactor writings for
 PMUVer/CSV2/CSV3
Thread-Index: AQHZlYd48E5FR1Z8uUiIgPHsWLb13w==
Date:   Fri, 2 Jun 2023 19:21:46 +0000
Message-ID: <f314beb1e53c1cbdc46909e857a246bab242b153.camel@amazon.com>
References: <20230602005118.2899664-1-jingzhangos@google.com>
         <20230602005118.2899664-6-jingzhangos@google.com>
In-Reply-To: <20230602005118.2899664-6-jingzhangos@google.com>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.187.170.26]
Content-Type: text/plain; charset="utf-8"
Content-ID: <EDCC44C611F8504E8D230D6D6CCFBD3D@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA2LTAyIGF0IDAwOjUxICswMDAwLCBKaW5nIFpoYW5nIHdyb3RlOgo+IFJl
ZmFjdG9yIHdyaXRpbmdzIGZvciBJRF9BQTY0UEZSMF9FTDEuW0NTVjJ8Q1NWM10sCj4gSURfQUE2
NERGUjBfRUwxLlBNVVZlciBhbmQgSURfREZSMF9FTEYuUGVyZk1vbiBiYXNlZCBvbiB1dGlsaXRp
ZXMKPiBzcGVjaWZpYyB0byBJRCByZWdpc3Rlci4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBKaW5nIFpo
YW5nIDxqaW5nemhhbmdvc0Bnb29nbGUuY29tPgo+IC0tLQo+IMKgYXJjaC9hcm02NC9pbmNsdWRl
L2FzbS9jcHVmZWF0dXJlLmggfMKgwqAgMSArCj4gwqBhcmNoL2FybTY0L2tlcm5lbC9jcHVmZWF0
dXJlLmPCoMKgwqDCoMKgIHzCoMKgIDIgKy0KPiDCoGFyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmPC
oMKgwqDCoMKgwqDCoMKgwqDCoCB8IDI5MSArKysrKysrKysrKysrKysrKysrLS0tLS0tLQo+IC0t
Cj4gwqAzIGZpbGVzIGNoYW5nZWQsIDIwMyBpbnNlcnRpb25zKCspLCA5MSBkZWxldGlvbnMoLSkK
PiAKPiAKPiArCj4gK3N0YXRpYyB1NjQgcmVhZF9zYW5pdGlzZWRfaWRfZGZyMF9lbDEoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1LAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY29uc3Qgc3RydWN0IHN5c19yZWdf
ZGVzYyAqcmQpCj4gK3sKPiArwqDCoMKgwqDCoMKgwqB1NjQgdmFsOwo+ICvCoMKgwqDCoMKgwqDC
oHUzMiBpZCA9IHJlZ190b19lbmNvZGluZyhyZCk7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoHZhbCA9
IHJlYWRfc2FuaXRpc2VkX2Z0cl9yZWcoaWQpOwo+ICvCoMKgwqDCoMKgwqDCoC8qCj4gK8KgwqDC
oMKgwqDCoMKgICogSW5pdGlhbGlzZSB0aGUgZGVmYXVsdCBQTVV2ZXIgYmVmb3JlIHRoZXJlIGlz
IGEgY2hhbmNlIHRvCj4gK8KgwqDCoMKgwqDCoMKgICogY3JlYXRlIGFuIGFjdHVhbCBQTVUuCj4g
K8KgwqDCoMKgwqDCoMKgICovCj4gK8KgwqDCoMKgwqDCoMKgdmFsICY9IH5BUk02NF9GRUFUVVJF
X01BU0soSURfREZSMF9FTDFfUGVyZk1vbik7Cj4gK8KgwqDCoMKgwqDCoMKgdmFsIHw9IEZJRUxE
X1BSRVAoQVJNNjRfRkVBVFVSRV9NQVNLKElEX0RGUjBfRUwxX1BlcmZNb24pLAo+IGt2bV9hcm1f
cG11X2dldF9wbXV2ZXJfbGltaXQoKSk7CgpNYXliZSBpdCdzIG5ldmVyIHBvc3NpYmxlLCBidXQg
ZG9lcyB0aGlzIG5lZWQgYToKcG11dmVyX3RvX3BlcmZtb24oa3ZtX2FybV9wbXVfZ2V0X3BtdXZl
cl9saW1pdCgpKSA/Cgo+ICsKPiArwqDCoMKgwqDCoMKgwqByZXR1cm4gdmFsOwo+IMKgfQo+IMKg
Cj4gwqAKVGhhbmtzCi0gU3VyYWoK
