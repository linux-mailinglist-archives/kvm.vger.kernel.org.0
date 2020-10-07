Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FB7285F34
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 14:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbgJGMbX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 08:31:23 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:41404 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbgJGMbX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 08:31:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1602073882; x=1633609882;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=pxoCsiGbEn7Ha7oZ9/pJ20Oktx+zmQqH6CAVsuUbNa8=;
  b=kXQDM0cxK6W9d3Mod2yhEAzbU80vIVDD9wc46b3Cng+INF/rmBfyiSnD
   mfwj7gprmpqPK37CvRmBkKKnJ/b3a3OsiUHuxbPd7wzNLvHbN9MXF6OkJ
   bug1TxfFLr+100Iw8b8/OuLyWj35K/WjS7LPDPSUkBnfTr7DgVuPe1PR+
   k=;
X-IronPort-AV: E=Sophos;i="5.77,346,1596499200"; 
   d="scan'208";a="58322282"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 07 Oct 2020 12:31:20 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 2B79F28989E;
        Wed,  7 Oct 2020 12:31:19 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 7 Oct 2020 12:31:18 +0000
Received: from Alexanders-MacBook-Air.local (10.43.161.23) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 7 Oct 2020 12:31:17 +0000
Subject: Re: [PATCH 1/4] selftests: kvm: Fix the segment descriptor layout to
 match the actual layout
To:     Aaron Lewis <aaronlewis@google.com>
CC:     <pshier@google.com>, <jmattson@google.com>, <kvm@vger.kernel.org>
References: <20201006210444.1342641-1-aaronlewis@google.com>
 <20201006210444.1342641-2-aaronlewis@google.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <7b3e509f-bccd-1dfd-42f2-6b152ae20a86@amazon.com>
Date:   Wed, 7 Oct 2020 14:31:15 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201006210444.1342641-2-aaronlewis@google.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.23]
X-ClientProxiedBy: EX13D25UWB002.ant.amazon.com (10.43.161.44) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAwNi4xMC4yMCAyMzowNCwgQWFyb24gTGV3aXMgd3JvdGU6Cj4gCj4gRml4IHRoZSBsYXlv
dXQgb2YgJ3N0cnVjdCBkZXNjNjQnIHRvIG1hdGNoIHRoZSBsYXlvdXQgZGVzY3JpYmVkIGluIHRo
ZQo+IFNETSBWb2wgMywgQ2hhcHRlciAzICJQcm90ZWN0ZWQtTW9kZSBNZW1vcnkgTWFuYWdlbWVu
dCIsIHNlY3Rpb24gMy40LjUKPiAiU2VnbWVudCBEZXNjcmlwdG9ycyIsIEZpZ3VyZSAzLTggIlNl
Z21lbnQgRGVzY3JpcHRvciIuICBUaGUgdGVzdCBhZGRlZAo+IGxhdGVyIGluIHRoaXMgc2VyaWVz
IHJlbGllcyBvbiB0aGlzIGFuZCBjcmFzaGVzIGlmIHRoaXMgbGF5b3V0IGlzIG5vdAo+IGNvcnJl
Y3QuCj4gCj4gU2lnbmVkLW9mZi1ieTogQWFyb24gTGV3aXMgPGFhcm9ubGV3aXNAZ29vZ2xlLmNv
bT4KClJldmlld2VkLWJ5OiBBbGV4YW5kZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPgoKCkFsZXgK
CgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgK
MTAxMTcgQmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9u
YXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50
ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

