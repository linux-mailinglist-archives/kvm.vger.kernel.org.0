Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F9F3FC691
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 13:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241479AbhHaLaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 07:30:08 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:13108 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbhHaLaF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 07:30:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1630409351; x=1661945351;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=7PhzP4EO+l784/dZ4WFjFow7uqqkHrnBgkdLpG55N0k=;
  b=LOqryarpeOA2O67ovrnnrhYEOebACTrebaTylbLSZXB83k36aOEsIJGi
   vZR16RRG+yPyEqBNT6q6EW9BwP4RFgivTMFr5r49N+PPTmgThQWk28nL1
   QtZ0gIep9fAkQU/x0TdKePLmLKSTseuYr0X8ce57KPOJkz63xDJkEhelx
   8=;
X-IronPort-AV: E=Sophos;i="5.84,366,1620691200"; 
   d="scan'208";a="23145090"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 31 Aug 2021 11:29:03 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id 5521EA255B;
        Tue, 31 Aug 2021 11:29:01 +0000 (UTC)
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.164) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Tue, 31 Aug 2021 11:28:55 +0000
Subject: Re: [PATCH v3 2/7] nitro_enclaves: Update documentation for Arm64
 support
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
References: <20210827154930.40608-1-andraprs@amazon.com>
 <20210827154930.40608-3-andraprs@amazon.com>
 <20210831074341.e74quljmvp36gy5a@steredhat>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <2c167a8a-3d5c-4f42-410c-294d357d85bb@amazon.com>
Date:   Tue, 31 Aug 2021 14:28:44 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210831074341.e74quljmvp36gy5a@steredhat>
Content-Language: en-US
X-Originating-IP: [10.43.162.164]
X-ClientProxiedBy: EX13D03UWA001.ant.amazon.com (10.43.160.141) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAzMS8wOC8yMDIxIDEwOjQzLCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6Cj4gT24gRnJp
LCBBdWcgMjcsIDIwMjEgYXQgMDY6NDk6MjVQTSArMDMwMCwgQW5kcmEgUGFyYXNjaGl2IHdyb3Rl
Ogo+PiBBZGQgcmVmZXJlbmNlcyBmb3IgaHVnZXBhZ2VzIGFuZCBib290aW5nIHN0ZXBzIGZvciBB
cm02NC4KPj4KPj4gSW5jbHVkZSBpbmZvIGFib3V0IHRoZSBjdXJyZW50IHN1cHBvcnRlZCBhcmNo
aXRlY3R1cmVzIGZvciB0aGUKPj4gTkUga2VybmVsIGRyaXZlci4KPj4KPj4gU2lnbmVkLW9mZi1i
eTogQW5kcmEgUGFyYXNjaGl2IDxhbmRyYXByc0BhbWF6b24uY29tPgo+PiAtLS0KPj4gQ2hhbmdl
bG9nCj4+Cj4+IHYxIC0+IHYyCj4+Cj4+ICogQWRkIGluZm9ybWF0aW9uIGFib3V0IHN1cHBvcnRl
ZCBhcmNoaXRlY3R1cmVzIGZvciB0aGUgTkUga2VybmVsCj4+IGRyaXZlci4KPj4KPj4gdjIgLT4g
djMKPj4KPj4gKiBNb3ZlIGNoYW5nZWxvZyBhZnRlciB0aGUgIi0tLSIgbGluZS4KPj4gLS0tCj4+
IERvY3VtZW50YXRpb24vdmlydC9uZV9vdmVydmlldy5yc3QgfCAyMSArKysrKysrKysrKysrLS0t
LS0tLS0KPj4gMSBmaWxlIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0p
Cj4KPiBBY2tlZC1ieTogU3RlZmFubyBHYXJ6YXJlbGxhIDxzZ2FyemFyZUByZWRoYXQuY29tPgo+
CgpUaGFuayB5b3UsIFN0ZWZhbm8uCgpBbmRyYQoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVy
IChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6YXIgU3RyZWV0
LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21hbmlhLiBSZWdp
c3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEvMjAwNS4K

