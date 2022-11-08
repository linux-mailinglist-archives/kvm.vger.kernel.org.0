Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849BC621E11
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 21:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiKHUx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 15:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiKHUx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 15:53:57 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2C11FFB7;
        Tue,  8 Nov 2022 12:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1667940837; x=1699476837;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+7OxyCcck4tmZc0/abZvywRCDLIXnvqoX5QXWWzEvjI=;
  b=KwKNJGyA2Jlbt4+NHOtPJHBvWuPuL01qub2p7/XgE2jZeyJQBQxczatN
   wjrAEQWpUrd0ehcz5HpB+mGofQI8A6unKktgaPGMZeHRBXq7rt0lRvsRE
   Sef62sUISX7NAVube9Sx9j9ceCGeclGOXxFWBaEFQj6umgLeRwpVpGz1F
   w=;
X-IronPort-AV: E=Sophos;i="5.96,148,1665446400"; 
   d="scan'208";a="278179066"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 20:53:51 +0000
Received: from EX13D33EUA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-94edd59b.us-west-2.amazon.com (Postfix) with ESMTPS id CE2934191D;
        Tue,  8 Nov 2022 20:53:50 +0000 (UTC)
Received: from EX19D016EUA004.ant.amazon.com (10.252.50.4) by
 EX13D33EUA002.ant.amazon.com (10.43.165.38) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 8 Nov 2022 20:53:49 +0000
Received: from [192.168.25.119] (10.43.162.178) by
 EX19D016EUA004.ant.amazon.com (10.252.50.4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Tue, 8 Nov 2022 20:53:44 +0000
Message-ID: <a302bf1b-0263-ccff-b8c9-a3ce9db65f55@amazon.com>
Date:   Tue, 8 Nov 2022 22:53:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH v1] MAINTAINERS: Update entries from the Nitro Enclaves
 section
To:     Greg KH <gregkh@linuxfoundation.org>
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
Content-Language: en-US
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
In-Reply-To: <Y2qtFONe55pYI7oC@kroah.com>
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D17UWC001.ant.amazon.com (10.43.162.188) To
 EX19D016EUA004.ant.amazon.com (10.252.50.4)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-14.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwOC4xMS4yMDIyIDIxOjI1LCBHcmVnIEtIIHdyb3RlOgo+IAo+IE9uIFR1ZSwgTm92IDA4
LCAyMDIyIGF0IDA4OjU5OjEyUE0gKzAyMDAsIEFuZHJhIFBhcmFzY2hpdiB3cm90ZToKPj4gVXBk
YXRlIHRoZSBsaXN0IG9mIG1haW50YWluZXJzIGZvciB0aGUgTml0cm8gRW5jbGF2ZXMgcHJvamVj
dC4gQWxleAo+PiAobGV4bnZAKSBpcyBub3Qgd29ya2luZyBhdCBBbWF6b24gYW55bW9yZSBhbmQg
dGhlcmUgd2lsbCBiZSB0aGUgc2FtZQo+PiBjYXNlIGZvciBtZSBzdGFydGluZyB3aXRoIDIwMjMu
Cj4+Cj4+IEFkZCBhIHJlZmVyZW5jZSB0byB0aGUgbWFpbGluZyBsaXN0IG9mIHRoZSBOaXRybyBF
bmNsYXZlcyBkZXZlbG9wbWVudAo+PiB0ZWFtLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBBbmRyYSBQ
YXJhc2NoaXYgPGFuZHJhcHJzQGFtYXpvbi5jb20+Cj4+IC0tLQo+PiAgIE1BSU5UQUlORVJTIHwg
MyArLS0KPj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0p
Cj4+Cj4+IGRpZmYgLS1naXQgYS9NQUlOVEFJTkVSUyBiL01BSU5UQUlORVJTCj4+IGluZGV4IDA0
NmZmMDZmZjk3Zi4uYWYyYzE3OGJhMGRjIDEwMDY0NAo+PiAtLS0gYS9NQUlOVEFJTkVSUwo+PiAr
KysgYi9NQUlOVEFJTkVSUwo+PiBAQCAtMTQ1NjQsMTAgKzE0NTY0LDkgQEAgVDogICBnaXQgZ2l0
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2Rpbmd1eWVuL2xpbnV4
LmdpdAo+PiAgIEY6ICAgYXJjaC9uaW9zMi8KPj4KPj4gICBOSVRSTyBFTkNMQVZFUyAoTkUpCj4+
IC1NOiAgIEFuZHJhIFBhcmFzY2hpdiA8YW5kcmFwcnNAYW1hem9uLmNvbT4KPj4gLU06ICAgQWxl
eGFuZHJ1IFZhc2lsZSA8bGV4bnZAYW1hem9uLmNvbT4KPiAKPiBJIG5lZWQgYW4gYWNrIGZyb20g
QWxleGFuZHJ1IHRvby4KCkhlIGlzIG5vdCB3b3JraW5nIGF0IEFtYXpvbiBhbnltb3JlLCBidXQg
SSBzZW50IGEgbWVzc2FnZSB0byBoaW0gd2l0aCAKdGhlIHJlZmVyZW5jZSB0byB0aGlzIG1haWwg
dGhyZWFkLiBIb3BlIHRoYXQgaGUgY291bGQgc2VlIHRoZSBtZXNzYWdlIAphbmQgZ2V0IGJhY2sg
d2l0aCBhIHJlcGx5IG9uIHRoaXMgbWFpbCB0aHJlYWQuCgo+IAo+PiAgIE06ICAgQWxleGFuZHJ1
IENpb2JvdGFydSA8YWxjaW9hQGFtYXpvbi5jb20+Cj4+ICAgTDogICBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnCj4+ICtMOiAgIFRoZSBBV1MgTml0cm8gRW5jbGF2ZXMgVGVhbSA8YXdzLW5p
dHJvLWVuY2xhdmVzLWRldmVsQGFtYXpvbi5jb20+Cj4gCj4gSWNrLCByZWFsbHk/ICBXaHk/ICBU
aGF0IHRha2VzIGFsbCBwZXJzb25hbCByZXNwb25zaWJpbGl0eSBhd2F5IGZyb20gdGhlCj4gcmVh
bCBtYWludGFpbmVyLgoKVGhpcyBpcyBhIG1haWxpbmcgbGlzdCB0aGF0IHdhcyBjcmVhdGVkIGR1
cmluZyB0aGUgcGFzdCBtb250aHMsIGZvciB0aGUgCmRldmVsb3BtZW50IHRlYW0gYW5kIHdhcyBh
ZGRlZCBhcyByZWZlcmVuY2Ugb24gdGhlIEdpdEh1YiByZXBvc2l0b3JpZXMgCmZvciB0aGUgTml0
cm8gRW5jbGF2ZXMgcHJvamVjdC4KCkkgYWRkZWQgaXQgaGVyZSBhcyB3ZWxsLCBzbyB0aGF0IHRo
ZSBlbnRpcmUgdGVhbSBnZXRzIG1haWwgbm90aWZpY2F0aW9ucyAKYnkgZGVmYXVsdCwgd2l0aG91
dCB0aGUgbmVlZCB0byBtYW51YWxseSBhZGQgdGhlIG1haWxpbmcgbGlzdCB0byBhIG1haWwgCnRo
cmVhZC4gVGhhdCBpcyBpbiBhZGRpdGlvbiB0byB0aGUgZXhpc3RpbmcgbWFpbnRhaW5lcihzKSwg
dGhhdCByZW1haW4gCnRoZSBwcmltYXJ5IHBvaW50IG9mIGNvbnRhY3QuCgpUaGFuayB5b3UgZm9y
IHRoZSBmZWVkYmFjay4KCkFuZHJhCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFu
aWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUs
IGZsb29yIDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQg
aW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=

