Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE5E39F0EA
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 10:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhFHI3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 04:29:49 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:54973 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbhFHI3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 04:29:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623140877; x=1654676877;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rNfCQrNV6O04dXWuzWdC60uvlaZ7im8TRShYIfHAAHI=;
  b=hHSxZ2d49zTGfQHyhSVbkXIqTCgEbUbE5e6reNih7pL45mc/bgAtNK00
   iB+gaAI+bkDqtdQ8qGSjTu44ElYplvYd5L7zg+rhEWanSGuDOCLbf/61r
   esBiYOw6mxi69r/P3fEMPKZ/lans4z4+h71zdBrLSlZrP8dpCwiGP00MZ
   A=;
X-IronPort-AV: E=Sophos;i="5.83,257,1616457600"; 
   d="scan'208";a="129758228"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 08 Jun 2021 08:27:57 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id 7DF48A04B6;
        Tue,  8 Jun 2021 08:27:56 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 08:27:56 +0000
Received: from [192.168.19.4] (10.43.160.137) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Jun
 2021 08:27:54 +0000
Message-ID: <270a73f1-43bc-46e7-d0fb-cfd65889f1e6@amazon.com>
Date:   Tue, 8 Jun 2021 10:27:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:90.0)
 Gecko/20100101 Thunderbird/90.0
Subject: Re: [PATCH 3/6] kvm/i386: Stop using cpu->kvm_msr_buf in
 kvm_put_one_msr()
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
 <04c81a02c19a47e799e06b9c9ccb97e9a77f5927.1621885749.git.sidcha@amazon.de>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <04c81a02c19a47e799e06b9c9ccb97e9a77f5927.1621885749.git.sidcha@amazon.de>
X-Originating-IP: [10.43.160.137]
X-ClientProxiedBy: EX13D41UWB003.ant.amazon.com (10.43.161.243) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNC4wNS4yMSAyMTo1NCwgU2lkZGhhcnRoIENoYW5kcmFzZWthcmFuIHdyb3RlOgo+IGt2
bV9wdXRfb25lX21zcigpIHplcm9zIGNwdS0+a3ZtX21zcl9idWYgYW5kIHVzZXMgaXQgdG8gc2V0
IG9uZSBNU1IgdG8KPiBLVk0uIEl0IGlzIHByZXR0eSB3YXN0ZWZ1bCBhcyBjcHUtPmt2bV9tc3Jf
YnVmIGlzIDQwOTYgYnl0ZXMgbG9uZzsKPiBpbnN0ZWFkIHVzZSBhIGxvY2FsIGJ1ZmZlciB0byBh
dm9pZCBtZW1zZXQuCj4gCj4gQWxzbywgZXhwb3NlIHRoaXMgbWV0aG9kIGZyb20ga3ZtX2kzODYu
aCBhcyBoeXBlcnYuYyBuZWVkcyB0byBzZXQgTVNScwo+IGluIGEgc3Vic2VxdWVudCBwYXRjaC4K
PiAKPiBTaWduZWQtb2ZmLWJ5OiBTaWRkaGFydGggQ2hhbmRyYXNla2FyYW4gPHNpZGNoYUBhbWF6
b24uZGU+CgpSZXZpZXdlZC1ieTogQWxleGFuZGVyIEdyYWYgPGdyYWZAYW1hem9uLmNvbT4KCgpB
bGV4CgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIu
IDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIs
IEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJn
IHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoK
Cg==

