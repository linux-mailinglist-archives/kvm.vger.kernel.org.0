Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3549A29F17F
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 17:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgJ2Qbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 12:31:46 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:37063 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727090AbgJ2Qa0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Oct 2020 12:30:26 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-97-MKHylt3TN2qOdBALyCARbQ-1; Thu, 29 Oct 2020 16:30:20 +0000
X-MC-Unique: MKHylt3TN2qOdBALyCARbQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 29 Oct 2020 16:30:19 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 29 Oct 2020 16:30:19 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arnd Bergmann' <arnd@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "Platform Driver" <platform-driver-x86@vger.kernel.org>,
        xen-devel <xen-devel@lists.xenproject.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH] [v2] x86: apic: avoid -Wshadow warning in header
Thread-Topic: [PATCH] [v2] x86: apic: avoid -Wshadow warning in header
Thread-Index: AQHWrdqfIpyThHXm90WmqPrnIVTaQ6muxUWQ
Date:   Thu, 29 Oct 2020 16:30:19 +0000
Message-ID: <2a85eaf7d2e54a278493588bae41b06a@AcuMS.aculab.com>
References: <20201028212417.3715575-1-arnd@kernel.org>
 <ea34f1d3-ed54-a2de-79d9-5cc8decc0ab3@redhat.com>
 <CAK8P3a0e0YAkh_9S1ZG5FW3QozZnp1CwXUfWx9VHWkY=h+FVxw@mail.gmail.com>
In-Reply-To: <CAK8P3a0e0YAkh_9S1ZG5FW3QozZnp1CwXUfWx9VHWkY=h+FVxw@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogQXJuZCBCZXJnbWFubg0KPiBTZW50OiAyOSBPY3RvYmVyIDIwMjAgMDk6NTENCi4uLg0K
PiBJIHRoaW5rIGlkZWFsbHkgdGhlcmUgd291bGQgYmUgbm8gZ2xvYmFsIHZhcmlhYmxlLCB3aXRo
YWxsIGFjY2Vzc2VzDQo+IGVuY2Fwc3VsYXRlZCBpbiBmdW5jdGlvbiBjYWxscywgcG9zc2libHkg
dXNpbmcgc3RhdGljX2NhbGwoKSBvcHRpbWl6YXRpb25zDQo+IGlmIGFueSBvZiB0aGVtIGFyZSBw
ZXJmb3JtYW5jZSBjcml0aWNhbC4NCg0KVGhlcmUgaXNuJ3QgcmVhbGx5IGEgbWFzc2l2ZSBkaWZm
ZXJlbmNlIGJldHdlZW4gZ2xvYmFsIHZhcmlhYmxlcw0KYW5kIGdsb2JhbCBhY2Nlc3MgZnVuY3Rp
b25zLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5
IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRp
b24gTm86IDEzOTczODYgKFdhbGVzKQ0K

