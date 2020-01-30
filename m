Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF1A14DA9C
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 13:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbgA3Mbv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 30 Jan 2020 07:31:51 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:22476 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727110AbgA3Mbu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 07:31:50 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-78-nO0nl3ftMxusiiUxHSydGw-1; Thu, 30 Jan 2020 12:31:47 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 30 Jan 2020 12:31:44 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 30 Jan 2020 12:31:44 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xiaoyao Li' <xiaoyao.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 1/2] KVM: x86: Emulate split-lock access as a write
Thread-Topic: [PATCH 1/2] KVM: x86: Emulate split-lock access as a write
Thread-Index: AQHV12hLFMkYqgCTIEO98IqgYw6YoagDIpWg
Date:   Thu, 30 Jan 2020 12:31:44 +0000
Message-ID: <db3b854fd03745738f46cfce451d9c98@AcuMS.aculab.com>
References: <20200130121939.22383-1-xiaoyao.li@intel.com>
 <20200130121939.22383-2-xiaoyao.li@intel.com>
In-Reply-To: <20200130121939.22383-2-xiaoyao.li@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: nO0nl3ftMxusiiUxHSydGw-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li
> Sent: 30 January 2020 12:20
> If split lock detect is enabled (warn/fatal), #AC handler calls die()
> when split lock happens in kernel.
> 
> A sane guest should never tigger emulation on a split-lock access, but
> it cannot prevent malicous guest from doing this. So just emulating the
> access as a write if it's a split-lock access to avoid malicous guest
> polluting the kernel log.

That doesn't seem right if, for example, the locked access is addx.
ISTM it would be better to force an immediate fatal error of some
kind than just corrupt the guest memory.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

