Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D104249A4C
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 12:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgHSK0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 06:26:05 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:6220 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgHSK0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 06:26:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597832764; x=1629368764;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=KCodnIdrXI52KBO8fW6zf2JPgwR/SXg5pDPELvzDbk0=;
  b=V6TEAv8MiOjF6nB+UIhUUIIZkHLO6O0r4cxY4INDoVeOnULc5YG2yfN2
   RKg/GdbfBK2rctJN0MTU4zlryh0WYvOVOiqX8Au23chrRrNBGYOL4Wj8Z
   Ol1QoJDu/z+oQ2pSszATxfa9nLqj0Ww9z6ZMmelVBSI3p9pDhRpRWN4IV
   g=;
X-IronPort-AV: E=Sophos;i="5.76,331,1592870400"; 
   d="scan'208";a="48579822"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 19 Aug 2020 10:26:03 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id EB06AA1D67;
        Wed, 19 Aug 2020 10:26:00 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 10:26:00 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.85) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 10:25:58 +0000
Subject: Re: [PATCH v3 05/12] KVM: x86: Add support for exiting to userspace
 on rdmsr or wrmsr
To:     Aaron Lewis <aaronlewis@google.com>, <jmattson@google.com>
CC:     <pshier@google.com>, <oupton@google.com>, <kvm@vger.kernel.org>
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-6-aaronlewis@google.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <92dc58cc-2137-d063-1999-be3847485605@amazon.com>
Date:   Wed, 19 Aug 2020 12:25:56 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200818211533.849501-6-aaronlewis@google.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.85]
X-ClientProxiedBy: EX13D44UWB004.ant.amazon.com (10.43.161.205) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxOC4wOC4yMCAyMzoxNSwgQWFyb24gTGV3aXMgd3JvdGU6Cj4gCj4gQWRkIHN1cHBvcnQg
Zm9yIGV4aXRpbmcgdG8gdXNlcnNwYWNlIG9uIGEgcmRtc3Igb3Igd3Jtc3IgaW5zdHJ1Y3Rpb24g
aWYKPiB0aGUgTVNSIGJlaW5nIHJlYWQgZnJvbSBvciB3cml0dGVuIHRvIGlzIGluIHRoZSB1c2Vy
X2V4aXRfbXNycyBsaXN0Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IEFhcm9uIExld2lzIDxhYXJvbmxl
d2lzQGdvb2dsZS5jb20+CgpBZ2FpbiwgdGhpcyBwYXRjaCBzaG91bGQgYmUgcmVkdW5kYW50IHdp
dGggdGhlIGFsbG93IGxpc3Q/CgpBbGV4CgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2Vy
bWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6
IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNn
ZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0
LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

