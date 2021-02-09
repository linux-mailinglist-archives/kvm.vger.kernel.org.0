Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3633151F6
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 15:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhBIOrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 09:47:37 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:12501 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbhBIOrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 09:47:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1612882050; x=1644418050;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:mime-version:content-transfer-encoding:subject;
  bh=2Kb1dO0tX9Q/3hXhOyQc4Gtm6ISVV1Qd2tBwheSAix0=;
  b=M5bb7MJU+r04l9TmORgb2ypUSkcfhqHyyNOZ3TXDV2GtUzqELT9OdGEs
   +7EJDz/DpNZlf1xmbSBkJV1/XhEV/X5V0gWwk8QGdowRJG0h5k7Ips64M
   WZ7NftsBQCxZqDYVPBgPGzmxS+hzAD69kJxMzuaE0+NbvplLDn4Kst/1o
   c=;
X-IronPort-AV: E=Sophos;i="5.81,165,1610409600"; 
   d="scan'208";a="80855438"
Subject: Re: [PATCH v5 1/2] drivers/misc: sysgenid: add system generation id driver
Thread-Topic: [PATCH v5 1/2] drivers/misc: sysgenid: add system generation id driver
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 09 Feb 2021 14:46:38 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id 1363EA2196;
        Tue,  9 Feb 2021 14:46:35 +0000 (UTC)
Received: from EX13D20UWC004.ant.amazon.com (10.43.162.41) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 9 Feb 2021 14:46:34 +0000
Received: from EX13D08EUB004.ant.amazon.com (10.43.166.158) by
 EX13D20UWC004.ant.amazon.com (10.43.162.41) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 9 Feb 2021 14:46:33 +0000
Received: from EX13D08EUB004.ant.amazon.com ([10.43.166.158]) by
 EX13D08EUB004.ant.amazon.com ([10.43.166.158]) with mapi id 15.00.1497.010;
 Tue, 9 Feb 2021 14:46:32 +0000
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
Thread-Index: AQHW+L9CWTm14fGsAkOMfnzzQsViX6pExriAgAtOBYA=
Date:   Tue, 9 Feb 2021 14:46:32 +0000
Message-ID: <CA221922-DFEE-4771-9590-FADDB74F7399@amazon.com>
References: <1612200294-17561-1-git-send-email-acatan@amazon.com>
 <1612200294-17561-2-git-send-email-acatan@amazon.com>
 <YBlAueoh12esXR2A@kroah.com>
In-Reply-To: <YBlAueoh12esXR2A@kroah.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.130]
Content-Type: text/plain; charset="utf-8"
Content-ID: <078DDECD943E3742BC3EFEB9511AA280@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMDIvMDIvMjAyMSwgMTQ6MDksICJHcmVnIEtIIiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5v
cmc+IHdyb3RlOg0KDQogICAgT24gTW9uLCBGZWIgMDEsIDIwMjEgYXQgMDc6MjQ6NTNQTSArMDIw
MCwgQWRyaWFuIENhdGFuZ2l1IHdyb3RlOg0KICAgID4gK3N0YXRpYyBsb25nIHN5c2dlbmlkX2lv
Y3RsKHN0cnVjdCBmaWxlICpmaWxlLA0KICAgID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGludCBjbWQsIHVuc2lnbmVkIGxvbmcgYXJn
KQ0KDQogICAgVmVyeSBvZGQgaW5kZW50YXRpb24gc3R5bGUsIGNoZWNrcGF0Y2gucGwgZGlkbid0
IGNhdGNoIHRoaXM/DQoNCkNoZWNrcGF0Y2gucGwgaXMgaGFwcHkgd2l0aCB0aGlzLCB5ZXMuDQpX
aWxsIGNoYW5nZSBpdCB0byBhIHNpbmdsZSB0YWIgbm9uZXRoZWxlc3Mgc2luY2UgaXQgZG9lcyBs
b29rIHdlaXJkIDopDQoNCgoKCkFtYXpvbiBEZXZlbG9wbWVudCBDZW50ZXIgKFJvbWFuaWEpIFMu
Ui5MLiByZWdpc3RlcmVkIG9mZmljZTogMjdBIFNmLiBMYXphciBTdHJlZXQsIFVCQzUsIGZsb29y
IDIsIElhc2ksIElhc2kgQ291bnR5LCA3MDAwNDUsIFJvbWFuaWEuIFJlZ2lzdGVyZWQgaW4gUm9t
YW5pYS4gUmVnaXN0cmF0aW9uIG51bWJlciBKMjIvMjYyMS8yMDA1Lgo=

