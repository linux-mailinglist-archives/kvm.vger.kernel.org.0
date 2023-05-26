Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD16712963
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 17:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243668AbjEZP0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 11:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjEZP0N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 11:26:13 -0400
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B93A3;
        Fri, 26 May 2023 08:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685114734; x=1716650734;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tmfQEVJS4QLMOmMk5N2seJXYVgOGi5nIiXqiC0ehALM=;
  b=l93uQOzJSq4FdsZ0o4Q3tg4WNvGx/SD5RhWhAq1SpHKwJhzeQpmkz3jj
   KZZcxsqctg0qvWw5WZh2kdYlfHgOFWybbzSFXQNyO3s90qUmDT2jkcfm3
   FcJFrPN/PMZzZZMqyeYvaR0Kqa+fiZMwKKZJzXXCmWdKnFMUY1ArBrS6b
   k=;
X-IronPort-AV: E=Sophos;i="6.00,194,1681171200"; 
   d="scan'208";a="6093742"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-b538c141.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 15:24:19 +0000
Received: from EX19D004EUC004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-b538c141.us-east-1.amazon.com (Postfix) with ESMTPS id 03C66A389E;
        Fri, 26 May 2023 15:24:18 +0000 (UTC)
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19D004EUC004.ant.amazon.com (10.252.51.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 26 May 2023 15:24:17 +0000
Received: from EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41]) by
 EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41%3]) with mapi id
 15.02.1118.026; Fri, 26 May 2023 15:24:17 +0000
From:   "Gowans, James" <jgowans@amazon.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "maz@kernel.org" <maz@kernel.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "seanjc@google.com" <seanjc@google.com>,
        "Saenz Julienne, Nicolas" <nsaenz@amazon.es>
Subject: Re: [ANNOUNCE] KVM Microconference at LPC 2023
Thread-Topic: [ANNOUNCE] KVM Microconference at LPC 2023
Thread-Index: AQHZj9zgz1ZgVJ9qBk6Gn3iwvw5JSq9srIUA
Date:   Fri, 26 May 2023 15:24:17 +0000
Message-ID: <88db2d9cb42e471692ff1feb0b9ca855906a9d95.camel@amazon.com>
References: <2f19f26e-20e5-8198-294e-27ea665b706f@redhat.com>
In-Reply-To: <2f19f26e-20e5-8198-294e-27ea665b706f@redhat.com>
Accept-Language: en-ZA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.146.13.223]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9D5A654711AEA46AF996B9D829BA446@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA1LTA5IGF0IDExOjU1ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBIaSBhbGwhDQo+IA0KPiBXZSBhcmUgcGxhbm5pbmcgb24gc3VibWl0dGluZyBhIENGUCB0byBo
b3N0IGEgS1ZNIE1pY3JvY29uZmVyZW5jZSBhdA0KPiBMaW51eCBQbHVtYmVycyBDb25mZXJlbmNl
IDIwMjMuIFRvIGhlbHAganVzdGlmeSB0aGUgcHJvcG9zYWwsIHdlIHdvdWxkDQo+IGxpa2UgdG8g
Z2F0aGVyIGEgbGlzdCBvZiBmb2xrcyB0aGF0IHdvdWxkIGxpa2VseSBhdHRlbmQsIGFuZCBjcm93
ZHNvdXJjZQ0KPiBhIGxpc3Qgb2YgdG9waWNzIHRvIGluY2x1ZGUgaW4gdGhlIHByb3Bvc2FsLg0K
DQpIaSBQYW9sbywNCg0KVGhpcyBNQyBzb3VuZHMgZ3JlYXQhIFRoZXJlIGFyZSB0d28gdG9waWNz
IEknZCBiZSBrZWVuIHRvIGRpc2N1c3MsIGJvdGggaW4NCnRoZSBLVk0gKyBtZW1vcnktbWFuYWdl
bWVudCByZWFsbToNCg0KMS4gR3Vlc3QgYW5kIGtlcm5lbCBtZW1vcnkgcGVyc2lzdGVuY2UgYWNy
b3NzIGtleGVjIGZvciBsaXZlIHVwZGF0ZS4NClNwZWNpZmljYWxseSBmb2N1c3Npbmcgb24gdGhl
IGhvc3QgSU9NTVUgcGd0YWJsZSBwZXJzaXN0ZW5jZSBmb3IgRE1BLQ0KcGFzc3Rocm91Z2ggZGV2
aWNlcyB0byBzdXBwb3J0IGtleGVjIHdoaWxlIGd1ZXN0LWRyaXZlbiBETUEgaXMgc3RpbGwNCnJ1
bm5pbmcuIFRoZXJlIGlzIHNvbWUgZGlzY3Vzc2lvbiBoYXBwZW5pbmcgbm93IGFib3V0IHRoaXMg
WzFdIGFuZA0KaG9wZWZ1bGx5IHRoZSBkaXNjdXNzaW9uIGFuZCBwcm90b3R5cGluZyB3aWxsIGNv
bnRpbnVlIGluIHRoZSBydW4gdXAgdG8NCkxQQy4NCg0KMi4gU3VwcG9ydGluZyBtb3JlIGZpbmUt
Z3JhaW4gbWVtb3J5IG1hbmFnZW1lbnQgYW5kIGFjY2VzcyBjb250cm9sIEFQSXMNCmZvciB0aGUg
dmlydHVhbGlzYXRpb24gY2FzZSBzcGVjaWZpY2FsbHksIGZvciB1c2UtY2FzZXMgYXJvdW5kIGxp
dmUNCm1pZ3JhdGlvbiwgbWVtb3J5IG92ZXJzdWJzY3JpcHRpb24sIGFuZCAic2lkZS1jYXIiIHZp
cnR1YWwgbWFjaGluZXMuIFRoZXNlDQp1c2UgY2FzZXMgd291bGQgYmVuZWZpdCBmcm9tIGtlcm5l
bCBzdXBwb3J0IGZvciB0aGluZ3MgbGlrZSBkeW5hbWljYWxseQ0KdXBkYXRpbmcgSU9NTVUgYW5k
IE1NVSBwZXJtaXNzaW9ucyBpbmRlcGVuZGVudGx5IGF0IGZpbmUgZ3JhbnVsYXJpdHksIGFsbA0K
d2l0aG91dCBhY3R1YWxseSBtb2RpZnlpbmcgdGhlIFZNQXMsIHRvIHN1cHBvcnQgZmluZS1ncmFp
biBoYW5kbGluZy4gQW5kDQpsaW5raW5nIHRoaXMgdG9waWMgdG8gdGhlIG9uZSBhYm92ZTogYmVp
bmcgYWJsZSB0byBkbyB0aGVzZSB0aGluZ3Mgd2hlbg0Kbm90IGJhY2tlZCBieSBzdHJ1Y3QgcGFn
ZXMuIChUaGVyZSBtYXkgYmUgc29tZSBvdmVybGFwIHdpdGggIktWTSBndWVzdA0KcHJpdmF0ZSBt
ZW1vcnkiIFsyXSBoZXJlLi4uKQ0KDQpXb3VsZCBkZWZpbml0ZWx5IGJlIGtlZW4gb24gdGhpcyBN
QyENCg0KSkcNCg0KWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW1tL2E0ZjYyYThl
MWIwZjQzZGIwMDVjYzExMTdjMDZjMDBlNmMwYzg1ZmYuY2FtZWxAYW1hem9uLmNvbS9ULyNtMjBj
NmRmM2Q3NTVjYjc5YjZjNDI2ZjdkOWEwMmNlYzM3ZDIxZTczZQ0KWzJdIGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2xrbWwvMjAyMjEyMDIwNjEzNDcuMTA3MDI0Ni0xLWNoYW8ucC5wZW5nQGxpbnV4
LmludGVsLmNvbS9ULw0K
