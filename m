Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AEF28C982
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 09:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390362AbgJMHm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 03:42:56 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:41834 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390040AbgJMHm4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 03:42:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1602574976; x=1634110976;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Wk7qI7wtWTVXBeudR+HXiSfnVbwRyMkBVgDzfjgKi10=;
  b=PAEW8aZaFW0rh0q8P3QRgEtddUyXpe7qj6gI3aLwkGR6OFdBw3RSpa0W
   TwedXpmnffNX1aJD+/5NjrrPosoSvrOhIiBssO5vxoj4pMjtHx4fr2S+1
   CtcpNvrZZ0RvbQ7oaXHkZp46lV1YShHMAX1sOhZy2a89Rkdg3EfQAxbIK
   I=;
X-IronPort-AV: E=Sophos;i="5.77,369,1596499200"; 
   d="scan'208";a="59441679"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 13 Oct 2020 07:42:49 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 2BC09A1826;
        Tue, 13 Oct 2020 07:42:48 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 13 Oct 2020 07:42:47 +0000
Received: from freeip.amazon.com (10.43.160.27) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 13 Oct 2020 07:42:46 +0000
Subject: Re: [PATCH v3 3/4] selftests: kvm: Add exception handling to
 selftests
To:     Aaron Lewis <aaronlewis@google.com>
CC:     <pshier@google.com>, <jmattson@google.com>, <kvm@vger.kernel.org>
References: <20201012194716.3950330-1-aaronlewis@google.com>
 <20201012194716.3950330-4-aaronlewis@google.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <9f9a8b3d-8c3b-a773-b1b6-f883ba59ad23@amazon.com>
Date:   Tue, 13 Oct 2020 09:42:43 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201012194716.3950330-4-aaronlewis@google.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.27]
X-ClientProxiedBy: EX13D45UWA003.ant.amazon.com (10.43.160.92) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAxMi4xMC4yMCAyMTo0NywgQWFyb24gTGV3aXMgd3JvdGU6Cj4gCj4gQWRkIHRoZSBpbmZy
YXN0cnVjdHVyZSBuZWVkZWQgdG8gZW5hYmxlIGV4Y2VwdGlvbiBoYW5kbGluZyBpbiBzZWxmdGVz
dHMuCj4gVGhpcyBhbGxvd3MgYW55IG9mIHRoZSBleGNlcHRpb24gYW5kIGludGVycnVwdCB2ZWN0
b3JzIHRvIGJlIG92ZXJyaWRkZW4KPiBpbiB0aGUgZ3Vlc3QuCj4gCj4gU2lnbmVkLW9mZi1ieTog
QWFyb24gTGV3aXMgPGFhcm9ubGV3aXNAZ29vZ2xlLmNvbT4KClJldmlld2VkLWJ5OiBBbGV4YW5k
ZXIgR3JhZiA8Z3JhZkBhbWF6b24uY29tPgoKCkFsZXgKCgoKQW1hem9uIERldmVsb3BtZW50IENl
bnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcgQmVybGluCkdlc2NoYWVmdHNm
dWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4gV2Vpc3MKRWluZ2V0cmFnZW4g
YW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJCIDE0OTE3MyBCClNpdHo6IEJl
cmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

