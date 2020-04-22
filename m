Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957021B4919
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 17:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgDVPuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 11:50:13 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:14973 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgDVPuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 11:50:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587570613; x=1619106613;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=hDChm5isPAPEd65CcrlezjVWCRg1aImUyTNZ8pXg5oA=;
  b=hSq7erkh0UcHcaWasn2zMC6yyQRuTpHHbyuxcqL9cGrGLe/Fc20y86+9
   uktV3neDmNmk3h+aEo1Oxxj0Zad1E2LJL2KJ0tnZI8Bi17Y5eTwhFH8T3
   LoEi3UviUNEQ3Rjw3buyO0Cb7po1dkG4BBajYAzZF/TQQnUAHVY78O26D
   0=;
IronPort-SDR: qyRT4HQqGjKUlgTHtQ18PQBLmHMmiKq/AyUKZT2Yv9wkvYewTT0iTRrkV/ZQFPAQHr8RByOCIX
 koMWQMVsQ0/w==
X-IronPort-AV: E=Sophos;i="5.73,414,1583193600"; 
   d="scan'208";a="30459560"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 22 Apr 2020 15:50:11 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 43B991416AE;
        Wed, 22 Apr 2020 15:50:08 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 15:50:08 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.52) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 15:50:00 +0000
Subject: Re: [PATCH v1 01/15] nitro_enclaves: Add ioctl interface definition
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>, Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200421184150.68011-1-andraprs@amazon.com>
 <20200421184150.68011-2-andraprs@amazon.com>
 <7e0cb729-60ca-3b2e-909b-8883b24908a8@infradead.org>
 <716e0cfb-fa4a-5fc5-f198-6574fa8dc046@redhat.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <c70e18f1-bd3d-1d6d-7675-cac3566fb0ab@amazon.com>
Date:   Wed, 22 Apr 2020 18:49:54 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <716e0cfb-fa4a-5fc5-f198-6574fa8dc046@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.52]
X-ClientProxiedBy: EX13d09UWA002.ant.amazon.com (10.43.160.186) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgpPbiAyMi8wNC8yMDIwIDAwOjQ1LCBQYW9sbyBCb256aW5pIHdyb3RlOgo+IE9uIDIxLzA0LzIw
IDIwOjQ3LCBSYW5keSBEdW5sYXAgd3JvdGU6Cj4+PiArCj4+PiArLyoqCj4+PiArICogVGhlIGNv
bW1hbmQgaXMgdXNlZCB0byB0cmlnZ2VyIGVuY2xhdmUgc3RhcnQgYWZ0ZXIgdGhlIGVuY2xhdmUg
cmVzb3VyY2VzLAo+Pj4gKyAqIHN1Y2ggYXMgbWVtb3J5IGFuZCBDUFUsIGhhdmUgYmVlbiBzZXQu
Cj4+PiArICoKPj4+ICsgKiBUaGUgZW5jbGF2ZSBzdGFydCBtZXRhZGF0YSBpcyBhbiBpbiAvIG91
dCBkYXRhIHN0cnVjdHVyZS4gSXQgaW5jbHVkZXMKPj4+ICsgKiBwcm92aWRlZCBpbmZvIGJ5IHRo
ZSBjYWxsZXIgLSBlbmNsYXZlIGNpZCBhbmQgZmxhZ3MgLSBhbmQgcmV0dXJucyB0aGUKPj4+ICsg
KiBzbG90IHVpZCBhbmQgdGhlIGNpZCAoaWYgaW5wdXQgY2lkIGlzIDApLgo+Pj4gKyAqLwo+Pj4g
KyNkZWZpbmUgTkVfRU5DTEFWRV9TVEFSVCBfSU9XUignQicsIDB4MSwgc3RydWN0IGVuY2xhdmVf
c3RhcnRfbWV0YWRhdGEpCj4+IFBsZWFzZSBkb2N1bWVudCBpb2N0bCBtYWpvciAoJ0InIGluIHRo
aXMgY2FzZSkgYW5kIHJhbmdlIHVzZWQgaW4KPj4gRG9jdW1lbnRhdGlvbi91c2Vyc3BhY2UtYXBp
L2lvY3RsL2lvY3RsLW51bWJlci5yc3QuCj4+Cj4gU2luY2UgaXQncyByZWFsbHkganVzdCBhIGNv
dXBsZSBpb2N0bHMsIEkgY2FuICJkb25hdGUiIHBhcnQgb2YgdGhlIEtWTQo+IHNwYWNlLCBmb3Ig
ZXhhbXBsZSBtYWpvciAweEFFIG1pbm9yIDB4MjAtMHgzZi4KClJhbmR5LCB0aGFua3MgZm9yIHRo
ZSBpb2N0bCBkb2MgcmVmcy4KCkkgY2FuIHVwZGF0ZSB0aGUgaW9jdGwtbnVtYmVyIGRvYyB0byBh
ZGQgYW4gZW50cnkgZm9yIHRoZSB0aGUgTml0cm8gCkVuY2xhdmVzIHVhcGkgd2l0aCAweEFFIGFu
ZCAweDIwLTB4M2YgcmFuZ2UgKyB1cGRhdGUgdGhlIEtWTSBlbnRyeSB0byAKaGF2ZSAweEFFIDB4
MDAtMHgxZiBhbmQgMHg0MC0weGZmLgoKV2lsbCB0aGVuIHVzZSAweEFFIGFuZCAweDIwIGZvciBO
RV9FTkNMQVZFX1NUQVJULgoKUGFvbG8sIGxldCBtZSBrbm93IGlmIHdlIHNob3VsZCBkbyB0aGlz
IGlvY3RsIG51bWJlciB1cGRhdGUgb3RoZXIgd2F5LiAKQW5kIHRoYW5rcyBmb3IgdGhlIHByb3Bv
c2FsLiA6KQoKVGhhbmtzLApBbmRyYQoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciAoUm9t
YW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJD
NSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJl
ZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==

