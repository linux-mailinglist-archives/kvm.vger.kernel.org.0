Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B004E6C46BD
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 10:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjCVJnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 05:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjCVJnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 05:43:50 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D66124C99
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 02:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679478230; x=1711014230;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zpiJWehkqEkZcpemsbCud6oWM+E4FzFrqNpu+JYUDEo=;
  b=bE4KMZrPl/rpZtCIs9R2A7ue/SNzhAt7ywQeVL5g3NHPjiiION22V/9f
   NaYAZaf8+fpXXks0suPNdQMD9MfSQFDpfYxUCRGvF2iXQ0tUpruI1ZPo5
   /tRI+hz5+CrX39HDTtwius4YHTZtgU0MlO8bIsaKPm9BMDvbc2u55oYoW
   g=;
X-IronPort-AV: E=Sophos;i="5.98,281,1673913600"; 
   d="scan'208";a="196163049"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-a893d89c.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 09:43:44 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-a893d89c.us-west-2.amazon.com (Postfix) with ESMTPS id 9B60340D50;
        Wed, 22 Mar 2023 09:43:43 +0000 (UTC)
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.22; Wed, 22 Mar 2023 09:43:42 +0000
Received: from [0.0.0.0] (10.253.83.51) by EX19D020UWC004.ant.amazon.com
 (10.13.138.149) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.24; Wed, 22 Mar
 2023 09:43:40 +0000
Message-ID: <444b0d8d-3a8c-8e6d-1df3-35f57046e58e@amazon.com>
Date:   Wed, 22 Mar 2023 10:43:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Content-Language: en-US
To:     =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <jroedel@suse.de>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
CC:     <amd-sev-snp@lists.suse.com>, <linux-coco@lists.linux.dev>,
        <kvm@vger.kernel.org>
References: <ZBl4592947wC7WKI@suse.de> <ZBnH600JIw1saZZ7@work-vm>
 <ZBnMZsWMJMkxOelX@suse.de> <ZBnhtEsMhuvwfY75@work-vm>
 <ZBn/ZbFwT9emf5zw@suse.de> <ZBoLVktt77F9paNV@work-vm>
 <ZBrIFnlPeCsP0x2g@suse.de>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <ZBrIFnlPeCsP0x2g@suse.de>
X-Originating-IP: [10.253.83.51]
X-ClientProxiedBy: EX19D039UWB002.ant.amazon.com (10.13.138.79) To
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

SGkgSsO2cmcsCgpPbiAyMi4wMy4yMyAxMDoxOSwgSsO2cmcgUsO2ZGVsIHdyb3RlOgoKPiBPbiBU
dWUsIE1hciAyMSwgMjAyMyBhdCAwNzo1Mzo1OFBNICswMDAwLCBEci4gRGF2aWQgQWxhbiBHaWxi
ZXJ0IHdyb3RlOgo+PiBPSzsgdGhlIG90aGVyIHRoaW5nIHRoYXQgbmVlZHMgdG8gZ2V0IG5haWxl
ZCBkb3duIGZvciB0aGUgdlRQTSdzIGlzIHRoZQo+PiByZWxhdGlvbnNoaXAgYmV0d2VlbiB0aGUg
dlRQTSBhdHRlc3RhdGlvbiBhbmQgdGhlIFNFViBhdHRlc3RhdGlvbi4KPj4gaS5lLiBob3cgdG8g
cHJvdmUgdGhhdCB0aGUgdlRQTSB5b3UncmUgZGVhbGluZyB3aXRoIGlzIGZyb20gYW4gU05QIGhv
c3QuCj4+IChBenVyZSBoYXZlIGEgaGFjayBvZiBwdXR0aW5nIGFuIFNOUCBhdHRlc3RhdGlvbiBy
ZXBvcnQgaW50byB0aGUgdlRQTQo+PiBOVlJBTTsgc2VlCj4+IGh0dHBzOi8vZ2l0aHViLmNvbS9B
enVyZS9jb25maWRlbnRpYWwtY29tcHV0aW5nLWN2bS1ndWVzdC1hdHRlc3RhdGlvbi9ibG9iL21h
aW4vY3ZtLWd1ZXN0LWF0dGVzdGF0aW9uLm1kCj4+ICkKPiBXaGVuIHVzaW5nIHRoZSBTVlNNIFRQ
TSBwcm90b2NvbCBpdCBzaG91bGQgYmUgcHJvdmVuIGFscmVhZHkgdGhhdCB0aGUKPiB2VFBNIGlz
IHBhcnQgb2YgdGhlIFNOUCB0cnVzdGVkIGJhc2UsIG5vPyBUaGUgVFBNIGNvbW11bmljYXRpb24g
aXMKPiBpbXBsaWNpdGx5IGVuY3J5cHRlZCBieSB0aGUgVk1zIG1lbW9yeSBrZXkgYW5kIHRoZSBT
RVYgYXR0ZXN0YXRpb24KPiByZXBvcnQgcHJvdmVzIHRoYXQgdGhlIGNvcnJlY3QgdlRQTSBpcyBl
eGVjdXRpbmcuCgoKV2hhdCB5b3Ugd2FudCB0byBhY2hpZXZlIGV2ZW50dWFsbHkgaXMgdG8gdGFr
ZSBhIHJlcG9ydCBmcm9tIHRoZSB2VFBNIAphbmQgc3VibWl0IG9ubHkgdGhhdCB0byBhbiBleHRl
cm5hbCBhdXRob3JpemF0aW9uIGVudGl0eSB0aGF0IGxvb2tzIGF0IAppdCBhbmQgc2F5cyAiWXVw
LCB5b3UgcmFuIGluIFNFVi1TTlAsIEkgdHJ1c3QgeW91ciBUQ0IsIEkgdHJ1c3QgeW91ciBUUE0g
CmltcGxlbWVudGF0aW9uLCBJIGFsc28gdHJ1c3QgeW91ciBQQ1IgdmFsdWVzIiBhbmQgYmFzZWQg
b24gdGhhdCBwcm92aWRlcyAKYWNjZXNzIHRvIHdoYXRldmVyIHJlc291cmNlIHlvdSB3YW50IHRv
IGFjY2Vzcy4KClRvIGRvIHRoYXQsIHlvdSBuZWVkIHRvIGxpbmsgU0VWLVNOUCBhbmQgVFBNIG1l
YXN1cmVtZW50cy9yZXBvcnRzIAp0b2dldGhlci4gQW5kIHRoZSBlYXNpZXN0IHdheSB0byBkbyB0
aGF0IGlzIGJ5IHByb3ZpZGluZyB0aGUgU0VWLVNOUCAKcmVwb3J0IGFzIHBhcnQgb2YgdGhlIFRQ
TTogWW91IGNhbiB0aGVuIHVzZSB0aGUgaGFzaCBvZiB0aGUgU0VWLVNOUCAKcmVwb3J0IGFzIHNp
Z25pbmcga2V5IGZvciBleGFtcGxlLgoKSSB0aGluayB0aGUga2V5IGhlcmUgaXMgdGhhdCB5b3Ug
bmVlZCB0byBwcm9wYWdhdGUgdGhhdCBsaW5rIHRvIGFuIApleHRlcm5hbCBwYXJ0eSwgbm90IChv
bmx5KSB0byB0aGUgVk0uCgoKQWxleAoKCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2Vy
bWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6
IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNn
ZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0
LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

