Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21750475463
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 09:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240888AbhLOIlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 03:41:07 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:60848 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240863AbhLOIlC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 03:41:02 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-23-f8sISgTNNZG0D9h8G8bq7w-1; Wed, 15 Dec 2021 08:40:15 +0000
X-MC-Unique: f8sISgTNNZG0D9h8G8bq7w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Wed, 15 Dec 2021 08:40:11 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Wed, 15 Dec 2021 08:40:11 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Yury Norov' <yury.norov@gmail.com>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexey Klimov <aklimov@redhat.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Andrew Lunn <andrew@lunn.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Andy Shevchenko" <andy@infradead.org>,
        Anup Patel <anup.patel@wdc.com>,
        "Ard Biesheuvel" <ardb@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        "Christoph Lameter" <cl@linux.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Dennis Zhou <dennis@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Geetha sowjanya <gakula@marvell.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        "Jens Axboe" <axboe@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski@canonical.com>,
        Lee Jones <lee.jones@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Mark Gross <markgross@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matti Vaittinen <mazziesaccount@gmail.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rasmus Villemoes" <linux@rasmusvillemoes.dk>,
        Roy Pledge <Roy.Pledge@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Solomon Peachy <pizza@shaftnet.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>, Tejun Heo <tj@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ulf Hansson" <ulf.hansson@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vineet Gupta <vgupta@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Will Deacon <will@kernel.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-csky@vger.kernel.org" <linux-csky@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH 2/9] lib/bitmap: implement bitmap_{empty,full} with
 bitmap_weight_eq()
Thread-Topic: [PATCH 2/9] lib/bitmap: implement bitmap_{empty,full} with
 bitmap_weight_eq()
Thread-Index: AQHX8SLbxx6fx2pSKEyBSY04FwbBf6wzO5+g
Date:   Wed, 15 Dec 2021 08:40:10 +0000
Message-ID: <0ccb827de1164b2989d652bfb6f1bbab@AcuMS.aculab.com>
References: <20211128035704.270739-1-yury.norov@gmail.com>
 <20211128035704.270739-3-yury.norov@gmail.com>
 <YaPGDOvBzhiRFcOP@qmqm.qmqm.pl>
 <CAAH8bW9-dbENFUrwPUQ-uJVVX_s=PWb2zpAJ8BqkV3vJE696mA@mail.gmail.com>
In-Reply-To: <CAAH8bW9-dbENFUrwPUQ-uJVVX_s=PWb2zpAJ8BqkV3vJE696mA@mail.gmail.com>
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

RnJvbTogWXVyeSBOb3Jvdg0KPiBTZW50OiAxNCBEZWNlbWJlciAyMDIxIDE5OjQzDQouLi4NCj4g
DQo+IEkgdGhpbmsgdGhhdCBmb3IgbG9uZyBiaXRtYXBzIHRoZSBtb3N0IHRpbWUgY29uc3VtaW5n
IG9wZXJhdGlvbiBpcyBtb3ZpbmcNCj4gZGF0YSB0byBMMSwgYW5kIGZvciBzaG9ydCBiaXRtYXBz
IHRoZSBkaWZmZXJlbmNlIGJldHdlZW4gYXBwcm9hY2hlcyBpcw0KPiBiYXJlbHkgbWVhc3VyYWJs
ZS4NCj4gDQo+IEJ1dCBod2VnaHRfbG9uZyBvbiBlYWNoIGl0ZXJhdGlvbiBjYW4ndCBiZSBtb3Jl
IGVmZmVjdGl2ZSB0aGFuIHRoZSBjdXJyZW50DQo+IHZlcnNpb24uIFNvLCBJJ2xsIGRyb3AgdGhp
cyBwYXRjaCBmb3IgdjIgYW5kIGtlZXAgdGhpbmdzIHVuY2hhbmdlZC4NCg0KQWN0dWFsbHkgZG8g
Yml0bWFwX2Z1bGwvZW1wdHkoKSBjYWxscyBtYWtlIGFueSBzZW5zZSBhdCBhbGw/DQpUaGUgcmVz
dWx0IGlzIHN0YWxlIHNpbmNlIGJpdG1hcHMgYXJlIGRlc2lnbmVkIHRvIGRvIGxvY2tlZCBvcGVy
YXRpb25zLg0KSWYgeW91IGhhdmUgYSBsb2NrIGNvdmVyaW5nIHRoZSBiaXRtYXAgdGhlbiB5b3Ug
c2hvdWxkIGJlIHVzaW5nDQpzb21ldGhpbmcgdGhhdCB1c2VzIG5vbi1sb2NrZWQgYWNjZXNzZXMu
DQpSaWdodGx5IG9yIHdyb25nbHkgdGhhdCBpc24ndCB0aGUgYml0bWFwIGFwaS4NCg0KCURhdmlk
DQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBG
YXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2
IChXYWxlcykNCg==

