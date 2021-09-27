Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E86A419808
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 17:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbhI0Pjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 11:39:55 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:7500 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235213AbhI0Pjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 11:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1632757098; x=1664293098;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=WSV22WLEm7ykK0bcc9gSnBMzGc6S9tGofXlxCyc5KYo=;
  b=nwIvJyfKT6F3c9sMR3FMGQN8HcK7bQLWPuz+EbNVixV0Lrhf54N2Byg0
   rwpAOwyh7lPHBTxbM681gbvoe/hPZ2oR9SknTl/RTDH2tnk4hrttJcA6F
   tXZTD+8aT2bAPow4wtipFzO38hhIofAcj245BKqbqlKmPw4H9cxWYpIzS
   I=;
X-IronPort-AV: E=Sophos;i="5.85,326,1624320000"; 
   d="scan'208";a="143427244"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 27 Sep 2021 15:38:09 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com (Postfix) with ESMTPS id 11941201996;
        Mon, 27 Sep 2021 15:38:07 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 27 Sep 2021 15:38:07 +0000
Received: from [0.0.0.0] (10.43.160.146) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.23; Mon, 27 Sep
 2021 15:38:05 +0000
Message-ID: <dfa613a1-9e7e-e03b-32e5-c995df9126f2@amazon.com>
Date:   Mon, 27 Sep 2021 17:38:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:93.0)
 Gecko/20100101 Thunderbird/93.0
Subject: Re: [kvm-unit-tests PATCH v2 2/3] [kvm-unit-tests PATCH] x86/msr.c
 refactor out generic test logic
Content-Language: en-US
To:     <ahmeddan@amazon.com>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <nikos.nikoleris@arm.com>,
        <drjones@redhat.com>
References: <08d356da-17ce-d380-1fc9-18ba7ec67020@amazon.com>
 <20210927153028.27680-1-ahmeddan@amazon.com>
 <20210927153028.27680-2-ahmeddan@amazon.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <20210927153028.27680-2-ahmeddan@amazon.com>
X-Originating-IP: [10.43.160.146]
X-ClientProxiedBy: EX13D11UWB004.ant.amazon.com (10.43.161.90) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyNy4wOS4yMSAxNzozMCwgYWhtZWRkYW5AYW1hem9uLmNvbSB3cm90ZToKPiBGcm9tOiBE
YW5pZWxlIEFobWVkIDxhaG1lZGRhbkBhbWF6b24uY29tPgo+IAo+IE1vdmUgdGhlIGdlbmVyaWMg
TVNSIHRlc3QgbG9naWMgdG8gaXRzIG93biBmdW5jdGlvbi4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBE
YW5pZWxlIEFobWVkIDxhaG1lZGRhbkBhbWF6b24uY29tPgoKUmV2aWV3ZWQtYnk6IEFsZXhhbmRl
ciBHcmFmIDxncmFmQGFtYXpvbi5jb20+CgpBbGV4CgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50
ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVl
aHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFt
IEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJs
aW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

