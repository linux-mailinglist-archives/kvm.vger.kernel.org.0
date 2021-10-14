Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C1442D65A
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 11:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhJNJsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 05:48:01 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:52772 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhJNJsA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 05:48:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1634204757; x=1665740757;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=rIdv63TLR2at0MciWz9Xu0SIXfMqrbe2EBqkrri9S/k=;
  b=aPGD/x5UdwEyOEg5Zya2CyD6MRfWAJqN3XOy9gAxwvQnWUMKwglM47zg
   bGk8F/bUz+psN/CRmahkmUryN8Zs+QapN6l9z5HR7ucZqXCMAFg4gwim3
   ujxqyXp37FejW5wxAWC2QplCmhj6rNCQPZl5cYlQLS7KaXiXMWSx8k89I
   E=;
X-IronPort-AV: E=Sophos;i="5.85,372,1624320000"; 
   d="scan'208";a="153487891"
Subject: Re: [PATCH kvm-unit-tests 2/2] lib: Introduce strtoll/strtoull
Thread-Topic: [PATCH kvm-unit-tests 2/2] lib: Introduce strtoll/strtoull
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-6435a935.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 14 Oct 2021 09:45:48 +0000
Received: from EX13D24EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-6435a935.us-west-2.amazon.com (Postfix) with ESMTPS id 5EE28420DC;
        Thu, 14 Oct 2021 09:45:47 +0000 (UTC)
Received: from EX13D24EUA001.ant.amazon.com (10.43.165.233) by
 EX13D24EUA001.ant.amazon.com (10.43.165.233) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 14 Oct 2021 09:45:46 +0000
Received: from EX13D24EUA001.ant.amazon.com ([10.43.165.233]) by
 EX13D24EUA001.ant.amazon.com ([10.43.165.233]) with mapi id 15.00.1497.023;
 Thu, 14 Oct 2021 09:45:46 +0000
From:   "Ahmed, Daniele" <ahmeddan@amazon.de>
To:     Andrew Jones <drjones@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "thuth@redhat.com" <thuth@redhat.com>
Thread-Index: AQHXwFGZF7D9MspgNk6J6Qy76CiuHKvSYWiA
Date:   Thu, 14 Oct 2021 09:45:46 +0000
Message-ID: <C2234EFB-E423-4DB4-AB74-F1F20889DE79@amazon.com>
References: <20211013164259.88281-1-drjones@redhat.com>
 <20211013164259.88281-3-drjones@redhat.com>
In-Reply-To: <20211013164259.88281-3-drjones@redhat.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.96]
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE800814EBD091478A60B3B3764E67E1@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNClJldmlld2VkLWJ5OiBEYW5pZWxlIEFobWVkIDxhaG1lZGRhbkBhbWF6b24uY29tPg0KDQoK
CgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAzOAox
MDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBKb25h
dGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1bnRl
ciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=

