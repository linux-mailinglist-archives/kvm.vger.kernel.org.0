Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9391C42D691
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 11:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhJNJ6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 05:58:19 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:13179 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhJNJ6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 05:58:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1634205375; x=1665741375;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=jGmCXTHuOsw/NHSSCpZiNiTeddtQHn4Cy25sokT1ceg=;
  b=X5jrEinzmv0330xg2+iqdmHclI4ryP2D04nDucpC8Bz9Wtf6F6qKX0/Y
   1Ge/ccaHNdxaWwpmBUy9xsSOn1AfuB3nQsmdIi9aj2MvRrKm1kvJjthOD
   3cIVZeWYsfMLD5V4vlNgseBXVPdXRsdoQjejSBskzGiu8lEBz6Nz317qH
   w=;
X-IronPort-AV: E=Sophos;i="5.85,372,1624320000"; 
   d="scan'208";a="149132923"
Subject: Re: [PATCH kvm-unit-tests 1/2] compiler.h: Fix typos in mul and sub overflow
 checks
Thread-Topic: [PATCH kvm-unit-tests 1/2] compiler.h: Fix typos in mul and sub overflow
 checks
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-0bfdb89e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 14 Oct 2021 09:56:06 +0000
Received: from EX13D24EUA003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-0bfdb89e.us-east-1.amazon.com (Postfix) with ESMTPS id D3936E0239;
        Thu, 14 Oct 2021 09:56:04 +0000 (UTC)
Received: from EX13D24EUA001.ant.amazon.com (10.43.165.233) by
 EX13D24EUA003.ant.amazon.com (10.43.165.211) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 14 Oct 2021 09:56:04 +0000
Received: from EX13D24EUA001.ant.amazon.com ([10.43.165.233]) by
 EX13D24EUA001.ant.amazon.com ([10.43.165.233]) with mapi id 15.00.1497.023;
 Thu, 14 Oct 2021 09:56:04 +0000
From:   "Ahmed, Daniele" <ahmeddan@amazon.de>
To:     Andrew Jones <drjones@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "thuth@redhat.com" <thuth@redhat.com>
Thread-Index: AQHXwFGNhPbfZVYhGEapHgQlWKjhD6vSZEmA
Date:   Thu, 14 Oct 2021 09:56:04 +0000
Message-ID: <82FB120B-824C-4F35-98CB-65964F6C4C5C@amazon.com>
References: <20211013164259.88281-1-drjones@redhat.com>
 <20211013164259.88281-2-drjones@redhat.com>
In-Reply-To: <20211013164259.88281-2-drjones@redhat.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.96]
Content-Type: text/plain; charset="utf-8"
Content-ID: <11869295A996C84797812C5A435E8FBA@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UmV2aWV3ZWQtYnk6IERhbmllbGUgQWhtZWQgPGFobWVkZGFuQGFtYXpvbi5jb20+DQoNCgoKCkFt
YXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3
IEJlcmxpbgpHZXNjaGFlZnRzZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFu
IFdlaXNzCkVpbmdldHJhZ2VuIGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhS
QiAxNDkxNzMgQgpTaXR6OiBCZXJsaW4KVXN0LUlEOiBERSAyODkgMjM3IDg3OQoKCg==

