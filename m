Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205406226E9
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 10:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiKIJ2s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 04:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiKIJ2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 04:28:41 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60BD2127C;
        Wed,  9 Nov 2022 01:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1667986117; x=1699522117;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1lyMS97aOhK9HdVaYOKoc1UrcZ3a7mFZFdUnkHkf4V0=;
  b=Ttk+/I4TJeM+YVBAjzgVjG9oIL7ICawEgHYKBBoyWdkf+jqG7SRsvNpi
   OB/tzPrrZfXe90gZ5BkQAORm/tDGMODBOVbIKZrCzJwlzyxbgDAL7x7Vd
   PQay7Gx7fLHh+rS38e+IRCdmSBViXafwwM92XB0gq44ysgsTzYVhU80tq
   8=;
X-IronPort-AV: E=Sophos;i="5.96,150,1665446400"; 
   d="scan'208";a="149137753"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 09:28:13 +0000
Received: from EX13D10EUA003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com (Postfix) with ESMTPS id BA57661477;
        Wed,  9 Nov 2022 09:28:11 +0000 (UTC)
Received: from EX19D016EUA004.ant.amazon.com (10.252.50.4) by
 EX13D10EUA003.ant.amazon.com (10.43.165.52) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 9 Nov 2022 09:28:09 +0000
Received: from [192.168.16.138] (10.43.160.223) by
 EX19D016EUA004.ant.amazon.com (10.252.50.4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Wed, 9 Nov 2022 09:28:05 +0000
Message-ID: <62a9ab52-af59-fa60-c52b-34f7bc7741a2@amazon.com>
Date:   Wed, 9 Nov 2022 11:27:39 +0200
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
 <a302bf1b-0263-ccff-b8c9-a3ce9db65f55@amazon.com>
 <Y2tYUeVXgIo7ONfA@kroah.com>
Content-Language: en-US
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
In-Reply-To: <Y2tYUeVXgIo7ONfA@kroah.com>
X-Originating-IP: [10.43.160.223]
X-ClientProxiedBy: EX13D20UWC004.ant.amazon.com (10.43.162.41) To
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

CgpPbiAwOS4xMS4yMDIyIDA5OjM1LCBHcmVnIEtIIHdyb3RlOgo+IAo+IE9uIFR1ZSwgTm92IDA4
LCAyMDIyIGF0IDEwOjUzOjM0UE0gKzAyMDAsIFBhcmFzY2hpdiwgQW5kcmEtSXJpbmEgd3JvdGU6
Cj4+Cj4+Cj4+IE9uIDA4LjExLjIwMjIgMjE6MjUsIEdyZWcgS0ggd3JvdGU6Cj4+Pgo+Pj4gT24g
VHVlLCBOb3YgMDgsIDIwMjIgYXQgMDg6NTk6MTJQTSArMDIwMCwgQW5kcmEgUGFyYXNjaGl2IHdy
b3RlOgo+Pj4+IFVwZGF0ZSB0aGUgbGlzdCBvZiBtYWludGFpbmVycyBmb3IgdGhlIE5pdHJvIEVu
Y2xhdmVzIHByb2plY3QuIEFsZXgKPj4+PiAobGV4bnZAKSBpcyBub3Qgd29ya2luZyBhdCBBbWF6
b24gYW55bW9yZSBhbmQgdGhlcmUgd2lsbCBiZSB0aGUgc2FtZQo+Pj4+IGNhc2UgZm9yIG1lIHN0
YXJ0aW5nIHdpdGggMjAyMy4KPj4+Pgo+Pj4+IEFkZCBhIHJlZmVyZW5jZSB0byB0aGUgbWFpbGlu
ZyBsaXN0IG9mIHRoZSBOaXRybyBFbmNsYXZlcyBkZXZlbG9wbWVudAo+Pj4+IHRlYW0uCj4+Pj4K
Pj4+PiBTaWduZWQtb2ZmLWJ5OiBBbmRyYSBQYXJhc2NoaXYgPGFuZHJhcHJzQGFtYXpvbi5jb20+
Cj4+Pj4gLS0tCj4+Pj4gICAgTUFJTlRBSU5FUlMgfCAzICstLQo+Pj4+ICAgIDEgZmlsZSBjaGFu
Z2VkLCAxIGluc2VydGlvbigrKSwgMiBkZWxldGlvbnMoLSkKPj4+Pgo+Pj4+IGRpZmYgLS1naXQg
YS9NQUlOVEFJTkVSUyBiL01BSU5UQUlORVJTCj4+Pj4gaW5kZXggMDQ2ZmYwNmZmOTdmLi5hZjJj
MTc4YmEwZGMgMTAwNjQ0Cj4+Pj4gLS0tIGEvTUFJTlRBSU5FUlMKPj4+PiArKysgYi9NQUlOVEFJ
TkVSUwo+Pj4+IEBAIC0xNDU2NCwxMCArMTQ1NjQsOSBAQCBUOiAgIGdpdCBnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZGluZ3V5ZW4vbGludXguZ2l0Cj4+Pj4g
ICAgRjogICBhcmNoL25pb3MyLwo+Pj4+Cj4+Pj4gICAgTklUUk8gRU5DTEFWRVMgKE5FKQo+Pj4+
IC1NOiAgIEFuZHJhIFBhcmFzY2hpdiA8YW5kcmFwcnNAYW1hem9uLmNvbT4KPj4+PiAtTTogICBB
bGV4YW5kcnUgVmFzaWxlIDxsZXhudkBhbWF6b24uY29tPgo+Pj4KPj4+IEkgbmVlZCBhbiBhY2sg
ZnJvbSBBbGV4YW5kcnUgdG9vLgo+Pgo+PiBIZSBpcyBub3Qgd29ya2luZyBhdCBBbWF6b24gYW55
bW9yZSwgYnV0IEkgc2VudCBhIG1lc3NhZ2UgdG8gaGltIHdpdGggdGhlCj4+IHJlZmVyZW5jZSB0
byB0aGlzIG1haWwgdGhyZWFkLiBIb3BlIHRoYXQgaGUgY291bGQgc2VlIHRoZSBtZXNzYWdlIGFu
ZCBnZXQKPj4gYmFjayB3aXRoIGEgcmVwbHkgb24gdGhpcyBtYWlsIHRocmVhZC4KPiAKPiBPaywg
aWYgdGhhdCBkb2Vzbid0IGhhcHBlbiwganVzdCBzZW5kIGEgdmVyc2lvbiBvZiB0aGF0IHBhdGNo
IHJlbW92aW5nCj4geW91LgoKQWNrLiBBbGV4IG1lbnRpb25lZCB0aGF0IHdpbGwgY29tZSBiYWNr
IHRoaXMgd2VlayB3aXRoIGEgcmVwbHkuCgpJZiBub3QgaGFwcGVuaW5nLCBJJ2xsIGNyZWF0ZSBh
IG5ldyB2ZXJzaW9uIG9mIHRoZSBwYXRjaC4KClRoYW5rIHlvdS4KCkFuZHJhCgoKCkFtYXpvbiBE
ZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMuUi5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdB
IFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29yIDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAw
NDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9tYW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBK
MjIvMjYyMS8yMDA1Lgo=

