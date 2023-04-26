Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D856EF902
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 19:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236414AbjDZRHS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 13:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236411AbjDZRHJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 13:07:09 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157F67EC1;
        Wed, 26 Apr 2023 10:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1682528818; x=1714064818;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/q/RayQgCyxolJD2+aA0KPoPbGMNuZ3edjcz0uAPYGg=;
  b=dLMWBP8dvSMd870q2qXV9LjEzdEJxqj66IPnTx7607kd2jM6q5+MBqwD
   S2wTJxzdD/TFpH0nH7gREhSDqna1q1WgmepffswvUpqP5LP6jufQS43mW
   D64CIuONcGGLqtsOYnKCOQnDDYGU0tLZrs5WVMp1f06mrdf3nC2mTGcRU
   g=;
X-IronPort-AV: E=Sophos;i="5.99,228,1677542400"; 
   d="scan'208";a="208529811"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 17:06:55 +0000
Received: from EX19D015EUA004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com (Postfix) with ESMTPS id 7F02640D51;
        Wed, 26 Apr 2023 17:06:53 +0000 (UTC)
Received: from EX19D024EUA002.ant.amazon.com (10.252.50.224) by
 EX19D015EUA004.ant.amazon.com (10.252.50.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 26 Apr 2023 17:06:52 +0000
Received: from [192.168.12.110] (10.1.213.23) by EX19D024EUA002.ant.amazon.com
 (10.252.50.224) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.26; Wed, 26 Apr
 2023 17:06:38 +0000
Message-ID: <f708da54-b99c-2ce8-f68f-6f3ba28ec2ff@amazon.com>
Date:   Wed, 26 Apr 2023 20:06:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH RFC v8 34/56] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START
 command
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
 <20230220183847.59159-35-michael.roth@amd.com>
Content-Language: en-US
From:   Sabin Rapan <sabrapan@amazon.com>
In-Reply-To: <20230220183847.59159-35-michael.roth@amd.com>
X-Originating-IP: [10.1.213.23]
X-ClientProxiedBy: EX19D035UWB003.ant.amazon.com (10.13.138.85) To
 EX19D024EUA002.ant.amazon.com (10.252.50.224)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMC4wMi4yMDIzIDIwOjM4LCBNaWNoYWVsIFJvdGggd3JvdGU6Cj4gRnJvbTogQnJpamVz
aCBTaW5naCA8YnJpamVzaC5zaW5naEBhbWQuY29tPgo+IAo+ICAKPiArc3RhdGljIGludCBzbnBf
ZGVjb21taXNzaW9uX2NvbnRleHQoc3RydWN0IGt2bSAqa3ZtKQo+ICt7Cj4gKwlzdHJ1Y3Qga3Zt
X3Nldl9pbmZvICpzZXYgPSAmdG9fa3ZtX3N2bShrdm0pLT5zZXZfaW5mbzsKPiArCXN0cnVjdCBz
ZXZfZGF0YV9zbnBfYWRkciBkYXRhID0ge307Cj4gKwlpbnQgcmV0Owo+ICsKPiArCS8qIElmIGNv
bnRleHQgaXMgbm90IGNyZWF0ZWQgdGhlbiBkbyBub3RoaW5nICovCj4gKwlpZiAoIXNldi0+c25w
X2NvbnRleHQpCj4gKwkJcmV0dXJuIDA7Cj4gKwo+ICsJZGF0YS5nY3R4X3BhZGRyID0gX19zbWVf
cGEoc2V2LT5zbnBfY29udGV4dCk7Cj4gKwlyZXQgPSBzZXZfZG9fY21kKFNFVl9DTURfU05QX0RF
Q09NTUlTU0lPTiwgJmRhdGEsIE5VTEwpOwo+ICsJaWYgKFdBUk5fT05DRShyZXQsICJmYWlsZWQg
dG8gcmVsZWFzZSBndWVzdCBjb250ZXh0IikpCj4gKwkJcmV0dXJuIHJldDsKPiArCj4gKwkvKiBm
cmVlIHRoZSBjb250ZXh0IHBhZ2Ugbm93ICovCj4gKwlzbnBfZnJlZV9maXJtd2FyZV9wYWdlKHNl
di0+c25wX2NvbnRleHQpOwo+ICsJc2V2LT5zbnBfY29udGV4dCA9IE5VTEw7Cj4gKwo+ICsJcmV0
dXJuIDA7Cj4gK30KPiArCgpFdmVuIHRob3VnaCBpdCdzIG5vdCBkb2N1bWVudGVkLCBTTlBfREVD
T01NSVNTSU9OIHNlZW1zIHRvIGNsZWFyIHRoZQpXQklOVkQgaW5kaWNhdG9yIGp1c3QgbGlrZSBE
RUFDVElWQVRFIGRvZXMgZm9yIFNFVi4KV29uJ3QgQVNJRCByZWN5Y2xpbmcgcmFjZSB3aXRoIFNO
UF9ERUNPTU1JU1NJT04gaWYgdGhlIGxhdHRlciBpc24ndApndWFyZGVkIHdpdGggc2V2X2RlYWN0
aXZhdGVfbG9jaz8KCgo+ICB2b2lkIHNldl92bV9kZXN0cm95KHN0cnVjdCBrdm0gKmt2bSkKPiAg
ewo+ICAJc3RydWN0IGt2bV9zZXZfaW5mbyAqc2V2ID0gJnRvX2t2bV9zdm0oa3ZtKS0+c2V2X2lu
Zm87Cj4gQEAgLTIzMzMsNyArMjQ0MCwxNSBAQCB2b2lkIHNldl92bV9kZXN0cm95KHN0cnVjdCBr
dm0gKmt2bSkKPiAgCQl9Cj4gIAl9Cj4gIAo+IC0Jc2V2X3VuYmluZF9hc2lkKGt2bSwgc2V2LT5o
YW5kbGUpOwo+ICsJaWYgKHNldl9zbnBfZ3Vlc3Qoa3ZtKSkgewo+ICsJCWlmIChzbnBfZGVjb21t
aXNzaW9uX2NvbnRleHQoa3ZtKSkgewo+ICsJCQlXQVJOX09OQ0UoMSwgIkZhaWxlZCB0byBmcmVl
IFNOUCBndWVzdCBjb250ZXh0LCBsZWFraW5nIGFzaWQhXG4iKTsKPiArCQkJcmV0dXJuOwo+ICsJ
CX0KPiArCX0gZWxzZSB7Cj4gKwkJc2V2X3VuYmluZF9hc2lkKGt2bSwgc2V2LT5oYW5kbGUpOwo+
ICsJfQo+ICsKPiAgCXNldl9hc2lkX2ZyZWUoc2V2KTsKPiAgfQo+ICAKCgoKQW1hem9uIERldmVs
b3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2Yu
IExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwg
Um9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8y
NjIxLzIwMDUuCg==

