Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876BF39F0EC
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 10:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhFHI36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 04:29:58 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:55274 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhFHI35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 04:29:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623140886; x=1654676886;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OAJ37p5pxyX+PAAkhW2VEqHI5xT3AyYK/3IuPScTwHU=;
  b=BZWxHlgqutyJXMOzsN6wuf8bPtoW6wIa7pT57/CTLMD9bBgU5F8cchtm
   8Ban+gpg9PhY4DjDp4IR56KIqFmRAoXWHIXD/QZV5w29ySsqNJ8dls/zk
   3gaNqWkdYam2z2cIlDRQRpj/zRV8g78gS6pYeetarYgq5wNhwgXroWeZn
   g=;
X-IronPort-AV: E=Sophos;i="5.83,257,1616457600"; 
   d="scan'208";a="129758249"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2c-cc689b93.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 08 Jun 2021 08:28:05 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-cc689b93.us-west-2.amazon.com (Postfix) with ESMTPS id 22A0C1201D6;
        Tue,  8 Jun 2021 08:28:05 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 08:28:04 +0000
Received: from [192.168.19.4] (10.43.160.137) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Jun
 2021 08:28:02 +0000
Message-ID: <8ca8309b-4a7a-e67a-4e20-ce3021077d8e@amazon.com>
Date:   Tue, 8 Jun 2021 10:28:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:90.0)
 Gecko/20100101 Thunderbird/90.0
Subject: Re: [PATCH 4/6] kvm/i386: Avoid multiple calls to
 check_extension(KVM_CAP_HYPERV)
Content-Language: en-US
To:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>
References: <cover.1621885749.git.sidcha@amazon.de>
 <ff4e06369b32aa715ac37fb51d151681cd66e401.1621885749.git.sidcha@amazon.de>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <ff4e06369b32aa715ac37fb51d151681cd66e401.1621885749.git.sidcha@amazon.de>
X-Originating-IP: [10.43.160.137]
X-ClientProxiedBy: EX13D48UWB004.ant.amazon.com (10.43.163.74) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNC4wNS4yMSAyMTo1NCwgU2lkZGhhcnRoIENoYW5kcmFzZWthcmFuIHdyb3RlOgo+IEtW
TV9DQVBfSFlQRVJWIGlzIGEgVk0gaW9jdGwgYW5kIGNhbiBiZSBjYWNoZWQgYXQga3ZtX2FyY2hf
aW5pdCgpCj4gaW5zdGVhZCBvZiBwZXJmb3JtaW5nIGFuIGlvY3RsIGVhY2ggdGltZSBpbiBoeXBl
cnZfZW5hYmxlZCgpIHdoaWNoIGlzCj4gY2FsbGVkIGZvcmVhY2ggdkNQVS4gQXBhcnQgZnJvbSB0
aGF0LCB0aGlzIHZhcmlhYmxlIHdpbGwgY29tZSBpbiBoYW5keQo+IGluIGEgc3Vic2VxdWVudCBw
YXRjaC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBTaWRkaGFydGggQ2hhbmRyYXNla2FyYW4gPHNpZGNo
YUBhbWF6b24uZGU+CgpSZXZpZXdlZC1ieTogQWxleGFuZGVyIEdyYWYgPGdyYWZAYW1hem9uLmNv
bT4KCgpBbGV4CgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVz
ZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hs
YWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0
ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3
IDg3OQoKCg==

