Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FDD2498F1
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 11:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgHSJAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 05:00:51 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:47219 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgHSJAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 05:00:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597827651; x=1629363651;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=nMgr+aAMjbsFA8bh0bESOonHrS/wFUmcTPAqtT2+bGQ=;
  b=T+Nci1VokK+jFY8yk8JsCRqmknvUuS0E103bscYhmNuJr55DOrTjJdfI
   ci6di2wt6ykYpiR31SBnsuo+Kpl2RsDfoEQZFwBhIKL8s1LVmhQqRDbYv
   OlVQnbJ0aaeHzDFhcAuudhgyi0spufy6T0Ej09EisN4Sl7cR2AX+bRZce
   Q=;
X-IronPort-AV: E=Sophos;i="5.76,330,1592870400"; 
   d="scan'208";a="60934963"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 19 Aug 2020 09:00:43 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 090C6A2453;
        Wed, 19 Aug 2020 09:00:40 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 09:00:37 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.40) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 19 Aug 2020 09:00:36 +0000
Subject: Re: [PATCH v3 04/12] KVM: x86: Add ioctl for accepting a userspace
 provided MSR list
To:     Aaron Lewis <aaronlewis@google.com>, <jmattson@google.com>
CC:     <pshier@google.com>, <oupton@google.com>, <kvm@vger.kernel.org>
References: <20200818211533.849501-1-aaronlewis@google.com>
 <20200818211533.849501-5-aaronlewis@google.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <b8bbbd5d-9411-407d-7757-f31e1ee54ae2@amazon.com>
Date:   Wed, 19 Aug 2020 11:00:32 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200818211533.849501-5-aaronlewis@google.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.40]
X-ClientProxiedBy: EX13D42UWB003.ant.amazon.com (10.43.161.45) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxOC4wOC4yMCAyMzoxNSwgQWFyb24gTGV3aXMgd3JvdGU6Cj4gCj4gQWRkIEtWTV9TRVRf
RVhJVF9NU1JTIGlvY3RsIHRvIGFsbG93IHVzZXJzcGFjZSB0byBwYXNzIGluIGEgbGlzdCBvZiBN
U1JzCj4gdGhhdCBmb3JjZSBhbiBleGl0IHRvIHVzZXJzcGFjZSB3aGVuIHJkbXNyIG9yIHdybXNy
IGFyZSB1c2VkIGJ5IHRoZQo+IGd1ZXN0Lgo+IAo+IEtWTV9TRVRfRVhJVF9NU1JTIHdpbGwgbmVl
ZCB0byBiZSBjYWxsZWQgYmVmb3JlIGFueSB2Q1BVcyBhcmUKPiBjcmVhdGVkIHRvIHByb3RlY3Qg
dGhlICd1c2VyX2V4aXRfbXNycycgbGlzdCBmcm9tIGJlaW5nIG11dGF0ZWQgd2hpbGUKPiB2Q1BV
cyBhcmUgcnVubmluZy4KPiAKPiBBZGQgS1ZNX0NBUF9TRVRfTVNSX0VYSVRTIHRvIGlkZW50aWZ5
IHRoZSBmZWF0dXJlIGV4aXN0cy4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBBYXJvbiBMZXdpcyA8YWFy
b25sZXdpc0Bnb29nbGUuY29tPgo+IFJldmlld2VkLWJ5OiBPbGl2ZXIgVXB0b24gPG91cHRvbkBn
b29nbGUuY29tPgoKV2h5IHdvdWxkIHdlIHN0aWxsIG5lZWQgdGhpcyB3aXRoIHRoZSBhbGxvdyBs
aXN0IGFuZCB1c2VyIHNwYWNlICNHUCAKZGVmbGVjdGlvbiBsb2dpYyBpbiBwbGFjZT8KCgpBbGV4
CgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4
CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpv
bmF0aGFuIFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVu
dGVyIEhSQiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

