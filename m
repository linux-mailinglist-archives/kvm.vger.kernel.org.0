Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7CD7626A7F
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 17:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbiKLQRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 11:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiKLQRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 11:17:44 -0500
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CAEB7EE;
        Sat, 12 Nov 2022 08:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668269863; x=1699805863;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=8X27/t7MKLINdgAeS7GKxZkdIxTcT8sPt/m+8jRxhow=;
  b=SDDLz7qYgL7IK2/YfjXfXJWahksYwmMGvxvgKpzR39tlDgEXzh7tuK2d
   K7OjaK+UQ8wwEIQXmx0raxtQeqyGHdcv1sIbEOykxYL3gP+je76mpk2k6
   d1IIOBeiHLwJseNl9AUtzvyyqyPU9P780h6wphT5qsEXfy9/IfOmbAC4g
   4=;
X-IronPort-AV: E=Sophos;i="5.96,160,1665446400"; 
   d="scan'208";a="240417630"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d8e96288.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2022 16:17:38 +0000
Received: from EX13D34EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-d8e96288.us-east-1.amazon.com (Postfix) with ESMTPS id 1CF56856FB;
        Sat, 12 Nov 2022 16:17:34 +0000 (UTC)
Received: from EX19D016EUA004.ant.amazon.com (10.252.50.4) by
 EX13D34EUA001.ant.amazon.com (10.43.165.5) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sat, 12 Nov 2022 16:17:33 +0000
Received: from [192.168.9.198] (10.43.162.178) by
 EX19D016EUA004.ant.amazon.com (10.252.50.4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.20; Sat, 12 Nov 2022 16:17:28 +0000
Message-ID: <c477e6cc-fb29-4fd9-70bd-83284f69b8f9@amazon.com>
Date:   Sat, 12 Nov 2022 18:17:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH v1] MAINTAINERS: Update entries from the Nitro Enclaves
 section
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Alexandru Vasile <acvasile96@gmail.com>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        "The AWS Nitro Enclaves Team" <aws-nitro-enclaves-devel@amazon.com>
References: <20221108185912.15792-1-andraprs@amazon.com>
 <Y2qtFONe55pYI7oC@kroah.com>
 <a302bf1b-0263-ccff-b8c9-a3ce9db65f55@amazon.com>
 <Y2tYUeVXgIo7ONfA@kroah.com>
 <62a9ab52-af59-fa60-c52b-34f7bc7741a2@amazon.com>
Content-Language: en-US
In-Reply-To: <62a9ab52-af59-fa60-c52b-34f7bc7741a2@amazon.com>
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D36UWA001.ant.amazon.com (10.43.160.71) To
 EX19D016EUA004.ant.amazon.com (10.252.50.4)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwOS4xMS4yMDIyIDExOjI3LCBQYXJhc2NoaXYsIEFuZHJhLUlyaW5hIHdyb3RlOgo+IAo+
IAo+IE9uIDA5LjExLjIwMjIgMDk6MzUsIEdyZWcgS0ggd3JvdGU6Cj4+Cj4+IE9uIFR1ZSwgTm92
IDA4LCAyMDIyIGF0IDEwOjUzOjM0UE0gKzAyMDAsIFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEgd3Jv
dGU6Cj4+Pgo+Pj4KPj4+IE9uIDA4LjExLjIwMjIgMjE6MjUsIEdyZWcgS0ggd3JvdGU6Cj4+Pj4K
Pj4+PiBPbiBUdWUsIE5vdiAwOCwgMjAyMiBhdCAwODo1OToxMlBNICswMjAwLCBBbmRyYSBQYXJh
c2NoaXYgd3JvdGU6Cj4+Pj4+IFVwZGF0ZSB0aGUgbGlzdCBvZiBtYWludGFpbmVycyBmb3IgdGhl
IE5pdHJvIEVuY2xhdmVzIHByb2plY3QuIEFsZXgKPj4+Pj4gKGxleG52QCkgaXMgbm90IHdvcmtp
bmcgYXQgQW1hem9uIGFueW1vcmUgYW5kIHRoZXJlIHdpbGwgYmUgdGhlIHNhbWUKPj4+Pj4gY2Fz
ZSBmb3IgbWUgc3RhcnRpbmcgd2l0aCAyMDIzLgo+Pj4+Pgo+Pj4+PiBBZGQgYSByZWZlcmVuY2Ug
dG8gdGhlIG1haWxpbmcgbGlzdCBvZiB0aGUgTml0cm8gRW5jbGF2ZXMgZGV2ZWxvcG1lbnQKPj4+
Pj4gdGVhbS4KPj4+Pj4KPj4+Pj4gU2lnbmVkLW9mZi1ieTogQW5kcmEgUGFyYXNjaGl2IDxhbmRy
YXByc0BhbWF6b24uY29tPgo+Pj4+PiAtLS0KPj4+Pj4gwqDCoCBNQUlOVEFJTkVSUyB8IDMgKy0t
Cj4+Pj4+IMKgwqAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAyIGRlbGV0aW9ucygt
KQo+Pj4+Pgo+Pj4+PiBkaWZmIC0tZ2l0IGEvTUFJTlRBSU5FUlMgYi9NQUlOVEFJTkVSUwo+Pj4+
PiBpbmRleCAwNDZmZjA2ZmY5N2YuLmFmMmMxNzhiYTBkYyAxMDA2NDQKPj4+Pj4gLS0tIGEvTUFJ
TlRBSU5FUlMKPj4+Pj4gKysrIGIvTUFJTlRBSU5FUlMKPj4+Pj4gQEAgLTE0NTY0LDEwICsxNDU2
NCw5IEBAIFQ6wqDCoCBnaXQgCj4+Pj4+IGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC9kaW5ndXllbi9saW51eC5naXQKPj4+Pj4gwqDCoCBGOsKgwqAgYXJjaC9u
aW9zMi8KPj4+Pj4KPj4+Pj4gwqDCoCBOSVRSTyBFTkNMQVZFUyAoTkUpCj4+Pj4+IC1NOsKgwqAg
QW5kcmEgUGFyYXNjaGl2IDxhbmRyYXByc0BhbWF6b24uY29tPgo+Pj4+PiAtTTrCoMKgIEFsZXhh
bmRydSBWYXNpbGUgPGxleG52QGFtYXpvbi5jb20+Cj4+Pj4KPj4+PiBJIG5lZWQgYW4gYWNrIGZy
b20gQWxleGFuZHJ1IHRvby4KPj4+Cj4+PiBIZSBpcyBub3Qgd29ya2luZyBhdCBBbWF6b24gYW55
bW9yZSwgYnV0IEkgc2VudCBhIG1lc3NhZ2UgdG8gaGltIHdpdGggCj4+PiB0aGUKPj4+IHJlZmVy
ZW5jZSB0byB0aGlzIG1haWwgdGhyZWFkLiBIb3BlIHRoYXQgaGUgY291bGQgc2VlIHRoZSBtZXNz
YWdlIGFuZCAKPj4+IGdldAo+Pj4gYmFjayB3aXRoIGEgcmVwbHkgb24gdGhpcyBtYWlsIHRocmVh
ZC4KPj4KPj4gT2ssIGlmIHRoYXQgZG9lc24ndCBoYXBwZW4sIGp1c3Qgc2VuZCBhIHZlcnNpb24g
b2YgdGhhdCBwYXRjaCByZW1vdmluZwo+PiB5b3UuCj4gCj4gQWNrLiBBbGV4IG1lbnRpb25lZCB0
aGF0IHdpbGwgY29tZSBiYWNrIHRoaXMgd2VlayB3aXRoIGEgcmVwbHkuCj4gCj4gSWYgbm90IGhh
cHBlbmluZywgSSdsbCBjcmVhdGUgYSBuZXcgdmVyc2lvbiBvZiB0aGUgcGF0Y2guCj4gCj4gVGhh
bmsgeW91LgoKQWRkaW5nIHRoZSByZXBseSBmcm9tIEFsZXggdG8gdGhpcyBtYWlsIHRocmVhZCBh
cyB3ZWxsLiBUaGFuayB5b3UuCgoiCgpBY2tlZC1ieTogQWxleGFuZHJ1IFZhc2lsZSA8YWN2YXNp
bGU5NkBnbWFpbC5jb20+CgpUaGUgcGF0Y2ggbG9va3MgZ29vZCB0byBtZQpUaGFua3MKQWxleAoK
IgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJl
ZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNp
IENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJh
dGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

