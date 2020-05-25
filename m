Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31AE1E1584
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 23:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389661AbgEYVKZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 17:10:25 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:20360 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387794AbgEYVKY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 17:10:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590441024; x=1621977024;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=pVK6EFMn3Y2YVusHeeWOKQoF6/4jAwAm20RH8qsPtmc=;
  b=fEqDp470vqFqqwArMcW7d1vmTu1iAhYHFrecYy/ILENf4vrklpcTbVga
   vNB0pjkbFF8DM9Tki1nIZqc8JqUH3iW2YuG8ghSTz2WRDn3agqYMjLeHS
   ui1ifOUO8+T50yj/NzOv0SKpgUJu3kr4rRtdWcSlXGYW6oZkpOaz9aYeL
   A=;
IronPort-SDR: XHbaP4qQBTQgvcldhy0Q30HDmBJWwVZvPmBauoun0HAOmo056nEb87EMS0Lvtb7Wfh68vTPPw/
 VMpdpKBJwezg==
X-IronPort-AV: E=Sophos;i="5.73,434,1583193600"; 
   d="scan'208";a="32213533"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 25 May 2020 21:10:22 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id B5A79A1C56;
        Mon, 25 May 2020 21:10:21 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 21:10:21 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.175) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 25 May 2020 21:10:12 +0000
Subject: Re: [PATCH v2 16/18] nitro_enclaves: Add sample for ioctl interface
 usage
To:     Greg KH <gregkh@linuxfoundation.org>
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
References: <20200522062946.28973-1-andraprs@amazon.com>
 <20200522062946.28973-17-andraprs@amazon.com>
 <20200522071123.GI771317@kroah.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <af35ad60-6084-b28d-60ec-4e27adfae800@amazon.com>
Date:   Tue, 26 May 2020 00:10:06 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200522071123.GI771317@kroah.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.175]
X-ClientProxiedBy: EX13D38UWC003.ant.amazon.com (10.43.162.23) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMi8wNS8yMDIwIDEwOjExLCBHcmVnIEtIIHdyb3RlOgo+IE9uIEZyaSwgTWF5IDIyLCAy
MDIwIGF0IDA5OjI5OjQ0QU0gKzAzMDAsIEFuZHJhIFBhcmFzY2hpdiB3cm90ZToKPj4gU2lnbmVk
LW9mZi1ieTogQWxleGFuZHJ1IFZhc2lsZSA8bGV4bnZAYW1hem9uLmNvbT4KPj4gU2lnbmVkLW9m
Zi1ieTogQW5kcmEgUGFyYXNjaGl2IDxhbmRyYXByc0BhbWF6b24uY29tPgo+IE5vIGNoYW5nZWxv
Zz8KCkkgaW5jbHVkZWQgdGhlIGNoYW5nZWxvZyBpbiB2My4KCj4KPj4gLS0tCj4+ICAgc2FtcGxl
cy9uaXRyb19lbmNsYXZlcy8uZ2l0aWdub3JlICAgICAgICAgICAgIHwgICAyICsKPj4gICBzYW1w
bGVzL25pdHJvX2VuY2xhdmVzL01ha2VmaWxlICAgICAgICAgICAgICAgfCAgMjggKwo+PiAgIC4u
Li9pbmNsdWRlL2xpbnV4L25pdHJvX2VuY2xhdmVzLmggICAgICAgICAgICB8ICAyMyArCj4+ICAg
Li4uL2luY2x1ZGUvdWFwaS9saW51eC9uaXRyb19lbmNsYXZlcy5oICAgICAgIHwgIDc3ICsrKwo+
IFdoeSBhcmUgeW91IG5vdCB1c2luZyB0aGUgdWFwaSBmaWxlcyBmcm9tIHRoZSBrZXJuZWwgaXRz
ZWxmPyAgSG93IGFyZQo+IHlvdSBnb2luZyB0byBrZWVwIHRoZXNlIGluIHN5bmM/CgpZZWFoLCB0
aGUgdWFwaSBmaWxlcyBzaG91bGQgYmUgdXNlZCwgSSBqdXN0IHJlbW92ZWQgdGhlIGluY2x1ZGUg
Zm9sZGVyIApmcm9tIGhlcmUuCgpUaGFuayB5b3UuCgpBbmRyYQoKCgpBbWF6b24gRGV2ZWxvcG1l
bnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6
YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21h
bmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEv
MjAwNS4K

