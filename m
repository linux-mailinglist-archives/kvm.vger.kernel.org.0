Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7C51E287B
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389149AbgEZRU5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:20:57 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:35254 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388061AbgEZRU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 13:20:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590513656; x=1622049656;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=SuRy4tavgBldQyqB1OdrVDKPEKHaP40bur786DRkLGI=;
  b=aZP0WA1NcqTI3gMKPb38MdYdfgLVYs8QMEz0y4/NqEDQQne/gB5As9EC
   F7Ok4GJVBxgXea+K97u9e1kfj6/qex/BUOxzanju11WxC06fNXsyYMn6N
   8rKb3wNiVGnDlWeVx/JzYUaagJYQEaFhHRpddTi3Nv8yoEwVDgnTFj0qJ
   8=;
IronPort-SDR: vJG6PgGh8Agtr/CuoHTmeJWRy+SNtfwxtlp638MAvHfGQ/s7GwBIZURSgc22qGTliFuyV9idUM
 UjbtLEQAhalw==
X-IronPort-AV: E=Sophos;i="5.73,437,1583193600"; 
   d="scan'208";a="46057669"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 26 May 2020 17:20:54 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id 12FEEA2291;
        Tue, 26 May 2020 17:20:54 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 26 May 2020 17:20:53 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 26 May 2020 17:20:43 +0000
Subject: Re: [PATCH v3 03/18] nitro_enclaves: Define enclave info for internal
 bookkeeping
To:     Greg KH <greg@kroah.com>
CC:     <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        "Alexander Graf" <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        "Uwe Dannowski" <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200525221334.62966-1-andraprs@amazon.com>
 <20200525221334.62966-4-andraprs@amazon.com>
 <20200526064601.GB2580530@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <b5cc525a-aeea-74ec-06fc-e9992077ba65@amazon.com>
Date:   Tue, 26 May 2020 20:20:38 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200526064601.GB2580530@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D41UWC001.ant.amazon.com (10.43.162.107) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNi8wNS8yMDIwIDA5OjQ2LCBHcmVnIEtIIHdyb3RlOgo+IE9uIFR1ZSwgTWF5IDI2LCAy
MDIwIGF0IDAxOjEzOjE5QU0gKzAzMDAsIEFuZHJhIFBhcmFzY2hpdiB3cm90ZToKPj4gKy8qIE5p
dHJvIEVuY2xhdmVzIChORSkgbWlzYyBkZXZpY2UgKi8KPj4gK2V4dGVybiBzdHJ1Y3QgbWlzY2Rl
dmljZSBuZV9taXNjZGV2aWNlOwo+IFdoeSBkb2VzIHlvdXIgbWlzYyBkZXZpY2UgbmVlZCB0byBi
ZSBpbiBhIC5oIGZpbGU/Cj4KPiBIYXZpbmcgdGhlIHBhdGNoIHNlcmllcyBsaWtlIHRoaXMgKGFk
ZCByYW5kb20gLmggZmlsZXMsIGFuZCB0aGVuIHN0YXJ0Cj4gdG8gdXNlIHRoZW0pLCBpcyBoYXJk
IHRvIHJldmlldy4gIFdvdWxkIHlvdSB3YW50IHRvIHRyeSB0byByZXZpZXcgYQo+IHNlcmllcyB3
cml0dGVuIGluIHRoaXMgd2F5PwoKVGhlIG1pc2MgZGV2aWNlIGlzIHJlZ2lzdGVyZWQgLyB1bnJl
Z2lzdGVyZWQgd2hpbGUgaGF2aW5nIHRoZSBORSBQQ0kgCmRldmljZSBwcm9iZSAvIHJlbW92ZSwg
YXMgYSBkZXBlbmRlbmN5IHRvIGFjdHVhbGx5IGhhdmluZyBhIFBDSSBkZXZpY2UgCndvcmtpbmcg
dG8gZXhwb3NlIGEgbWlzYyBkZXZpY2UuCgpUaGUgd2F5IHRoZSBjb2RlYmFzZSBpcyBzcGxpdCBp
biBmaWxlcyBpcyBtYWlubHkgdGhlIGlvY3RsIGxvZ2ljIC8gbWlzYyAKZGV2aWNlIGluIG9uZSBm
aWxlIGFuZCB0aGUgUENJIGRldmljZSBsb2dpYyBpbiBhbm90aGVyIGZpbGU7IHRodXMgbm90IApo
YXZlIGFsbCB0aGUgY29kZWJhc2UgaW4gYSBzaW5nbGUgYmlnIGZpbGUuIEdpdmVuIHRoZSBtaXNj
IGRldmljZSAKKHVuKXJlZ2lzdGVyIGxvZ2ljIGFib3ZlLCB0aGUgbWlzYyBkZXZpY2UgbmVlZHMg
dG8gYmUgYXZhaWxhYmxlIHRvIHRoZSAKUENJIGRldmljZSBzZXR1cCBsb2dpYy4KCkFuZHJhCgoK
CgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBv
ZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENv
dW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlv
biBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

