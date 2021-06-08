Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576B939F0E9
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 10:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhFHI3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 04:29:47 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:54973 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbhFHI3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 04:29:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623140874; x=1654676874;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dt72r89oBKjQrVVXnFkGO45pvt4R0/uSn+tuKL7DfJA=;
  b=UXfDMykGrQkpPYe5fr3qewFgj+4jgzBQV8cL1RwSyA5+GSm7a7RB8JN9
   2guMM5LxG9B2qgkTlszXDcI9o/QuyZlhgFiKVH1Ug21C+IvRtpnOJ10PN
   NwRUOEFyV4IhmWINznBPRwv5kzy7YpZR3uLYnvlhXQ490aPiyYrSgYBko
   s=;
X-IronPort-AV: E=Sophos;i="5.83,257,1616457600"; 
   d="scan'208";a="129758191"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 08 Jun 2021 08:27:48 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id 59225A1E0E;
        Tue,  8 Jun 2021 08:27:47 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 08:27:46 +0000
Received: from [192.168.19.4] (10.43.160.137) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Jun
 2021 08:27:44 +0000
Message-ID: <b76c6cac-2fcc-bbf0-7201-66b442e640bc@amazon.com>
Date:   Tue, 8 Jun 2021 10:27:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:90.0)
 Gecko/20100101 Thunderbird/90.0
Subject: Re: [PATCH 2/6] hyper-v: Use -1 as invalid overlay address
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
 <13aa6b6a4434198ad3d43e48501bce1796266850.1621885749.git.sidcha@amazon.de>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <13aa6b6a4434198ad3d43e48501bce1796266850.1621885749.git.sidcha@amazon.de>
X-Originating-IP: [10.43.160.137]
X-ClientProxiedBy: EX13D49UWB004.ant.amazon.com (10.43.163.111) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNC4wNS4yMSAyMTo1NCwgU2lkZGhhcnRoIENoYW5kcmFzZWthcmFuIHdyb3RlOgo+IFdo
ZW4gbWFuYWdpbmcgb3ZlcmxheSBwYWdlcywgd2UgdXNlZCBod2FkZHIgMCB0byBzaWduYWwgYW4g
aW52YWxpZAo+IGFkZHJlc3MgKHRvIGRpc2FibGUgYSBwYWdlKS4gQWx0aG91Z2ggdW5saWtlbHks
IDAgX2NvdWxkXyBiZSBhIHZhbGlkCj4gb3ZlcmxheSBvZmZzZXQgYXMgSHlwZXItViBUTEZTIGRv
ZXMgbm90IHNwZWNpZnkgYW55dGhpbmcgYWJvdXQgaXQuCj4gCj4gVXNlIC0xIGFzIHRoZSBpbnZh
bGlkIGFkZHJlc3MgaW5kaWNhdG9yIGFzIGl0IGNhbiBuZXZlciBiZSBhIHZhbGlkCj4gYWRkcmVz
cy4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBTaWRkaGFydGggQ2hhbmRyYXNla2FyYW4gPHNpZGNoYUBh
bWF6b24uZGU+CgpSZXZpZXdlZC1ieTogQWxleGFuZGVyIEdyYWYgPGdyYWZAYW1hem9uLmNvbT4K
CgpBbGV4CgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5z
dHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVn
ZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5i
dXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3
OQoKCg==

