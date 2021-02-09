Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F643151EB
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 15:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhBIOqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 09:46:03 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:2068 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbhBIOp4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 09:45:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1612881956; x=1644417956;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=NxMwBdmyc4sNOrz14IYPg0zdZ8oD1VtXNjDeDxomoG8=;
  b=pBP07ojO0rxzTEMHjDNFPktHeYrlBcgGqKUc9ZjRJ0Sqa2HCWe0Qd3Vg
   8lSbcRmFkd3hdSouYrU81W0anFf87DxYsnA3ke39t3+rPp6F2RrAiKNVT
   Q9oxn77cmnsk1GxS5nyksThyMYpoW4M93ittXUoDY4nc/WvacXX57unay
   M=;
X-IronPort-AV: E=Sophos;i="5.81,165,1610409600"; 
   d="scan'208";a="85049893"
Subject: Re: [PATCH v5 1/2] drivers/misc: sysgenid: add system generation id driver
Thread-Topic: [PATCH v5 1/2] drivers/misc: sysgenid: add system generation id driver
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 09 Feb 2021 14:45:04 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com (Postfix) with ESMTPS id 4F2E12E4314;
        Tue,  9 Feb 2021 14:45:01 +0000 (UTC)
Received: from EX13D20UWA002.ant.amazon.com (10.43.160.176) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 9 Feb 2021 14:45:00 +0000
Received: from EX13D08EUB004.ant.amazon.com (10.43.166.158) by
 EX13D20UWA002.ant.amazon.com (10.43.160.176) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 9 Feb 2021 14:44:59 +0000
Received: from EX13D08EUB004.ant.amazon.com ([10.43.166.158]) by
 EX13D08EUB004.ant.amazon.com ([10.43.166.158]) with mapi id 15.00.1497.010;
 Tue, 9 Feb 2021 14:44:58 +0000
From:   "Catangiu, Adrian Costin" <acatan@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "0x7f454c46@gmail.com" <0x7f454c46@gmail.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>,
        "jannh@google.com" <jannh@google.com>, "w@1wt.eu" <w@1wt.eu>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "mst@redhat.com" <mst@redhat.com>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "areber@redhat.com" <areber@redhat.com>,
        "ovzxemul@gmail.com" <ovzxemul@gmail.com>,
        "avagin@gmail.com" <avagin@gmail.com>,
        "ptikhomirov@virtuozzo.com" <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>,
        "oridgar@gmail.com" <oridgar@gmail.com>,
        "ghammer@redhat.com" <ghammer@redhat.com>
Thread-Index: AQHW+L9CWTm14fGsAkOMfnzzQsViX6pExcWAgAtOiQA=
Date:   Tue, 9 Feb 2021 14:44:58 +0000
Message-ID: <6D86B655-C57C-4E58-87D2-507D62E3B820@amazon.com>
References: <1612200294-17561-1-git-send-email-acatan@amazon.com>
 <1612200294-17561-2-git-send-email-acatan@amazon.com>
 <YBk/7YzxqPJM3Bm8@kroah.com>
In-Reply-To: <YBk/7YzxqPJM3Bm8@kroah.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.130]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D4110FB330449B40B4E7F8905E6D7C0E@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMDIvMDIvMjAyMSwgMTQ6MDUsICJHcmVnIEtIIiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5v
cmc+IHdyb3RlOg0KDQogICAgT24gTW9uLCBGZWIgMDEsIDIwMjEgYXQgMDc6MjQ6NTNQTSArMDIw
MCwgQWRyaWFuIENhdGFuZ2l1IHdyb3RlOg0KICAgID4gK0VYUE9SVF9TWU1CT0woc3lzZ2VuaWRf
YnVtcF9nZW5lcmF0aW9uKTsNCg0KICAgIEVYUE9SVF9TWU1CT0xfR1BMKCk/ICBJIGhhdmUgdG8g
YXNrLi4uDQoNCkdvb2QgY2F0Y2ghIFdpbGwgdXBkYXRlLg0KDQoKCgpBbWF6b24gRGV2ZWxvcG1l
bnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3QSBTZi4gTGF6
YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAwMDQ1LCBSb21h
bmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIgSjIyLzI2MjEv
MjAwNS4K

