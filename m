Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E50D4C49D3
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242505AbiBYP6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbiBYP6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:58:38 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06FE1385B0;
        Fri, 25 Feb 2022 07:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1645804685; x=1677340685;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/4HhS3bKDhHBG81XwvT+lvk6Ix/QvcITcjjX0JZqCZA=;
  b=m3oABs3zZO2cWd4S+n3gOpT0Hyu69d7JZEzGS9cD8C7bAqfk/CijUZ86
   E0XBj0W3djrAuzSXmvchyxSEsa/+V/mX3wCKNT9xj7esy7o8QHEpR+B/Y
   TzdZu+K36G6u2LgFJtPr0ZzaquXI1zUyyF1MI97IIAXJ0TPsAVjItD0yJ
   s=;
X-IronPort-AV: E=Sophos;i="5.90,136,1643673600"; 
   d="scan'208";a="995010317"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-2dbf0206.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 25 Feb 2022 15:57:50 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-2dbf0206.us-west-2.amazon.com (Postfix) with ESMTPS id 06FB2A29C8;
        Fri, 25 Feb 2022 15:57:50 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Fri, 25 Feb 2022 15:57:49 +0000
Received: from [0.0.0.0] (10.43.160.203) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.28; Fri, 25 Feb
 2022 15:57:43 +0000
Message-ID: <5a196de5-d7cb-d462-2292-af05907d3544@amazon.com>
Date:   Fri, 25 Feb 2022 16:57:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v4] virt: vmgenid: introduce driver for reinitializing RNG
 on VM fork
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
CC:     Ard Biesheuvel <ardb@kernel.org>, KVM list <kvm@vger.kernel.org>,
        "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>,
        <linux-hyperv@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <adrian@parity.io>, <ben@skyportsystems.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        "Colm MacCarthaigh" <colmmacc@amazon.com>,
        Dexuan Cui <decui@microsoft.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        Eric Biggers <ebiggers@kernel.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Igor Mammedov" <imammedo@redhat.com>,
        Jann Horn <jannh@google.com>,
        KY Srinivasan <kys@microsoft.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "QEMU Developers" <qemu-devel@nongnu.org>,
        "Weiss, Radu" <raduweis@amazon.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Wei Liu <wei.liu@kernel.org>
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
 <20220225124848.909093-1-Jason@zx2c4.com>
 <05c9f2a9-accb-e0de-aac7-b212adac7eb2@amazon.com>
 <YhjjuMOeV7+T7thS@zx2c4.com>
 <88ebdc32-2e94-ef28-37ed-1c927c12af43@amazon.com>
 <YhjoyIUv2+18BwiR@zx2c4.com>
 <9ac68552-c1fc-22c8-13e6-4f344f85a4fb@amazon.com>
 <CAMj1kXEue6cDCSG0N7WGTVF=JYZx3jwE7EK4tCdhO-HzMtWwVw@mail.gmail.com>
 <c8066caf-8bbb-b148-57e6-98d8449a64c3@amazon.com>
 <Yhj5Dyd6+oC/R1H5@zx2c4.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <Yhj5Dyd6+oC/R1H5@zx2c4.com>
X-Originating-IP: [10.43.160.203]
X-ClientProxiedBy: EX13D43UWC004.ant.amazon.com (10.43.162.42) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ck9uIDI1LjAyLjIyIDE2OjQzLCBKYXNvbiBBLiBEb25lbmZlbGQgd3JvdGU6Cj4KPiBIaSBBbGV4
LAo+Cj4gT24gRnJpLCBGZWIgMjUsIDIwMjIgYXQgMDQ6MjI6NTRQTSArMDEwMCwgQWxleGFuZGVy
IEdyYWYgd3JvdGU6Cj4+IEkgZG9uJ3QgdW5kZXJzdGFuZCB0aGUgcnVzaCBoZXJlLiBUaGlzIGhh
ZCBiZWVuIHNpdHRpbmcgb24gdGhlIE1MIGZvciAxCj4+IHllYXIgLSBhbmQgbm93IHN1ZGRlbmx5
IHRhbGtpbmcgdGhlIG1hdGNoIHRocm91Z2ggcHJvcGVybHkgYW5kIGdldHRpbmcKPj4gVk1HZW5J
RCBzcGVjIGNvbXBhdGlibGUgbWF0Y2hpbmcgc3VwcG9ydCBpbnRvIHRoZSBBQ1BJIGNvcmUgaXMg
YQo+PiBwcm9ibGVtPyBXaGF0IGRpZCBJIG1pc3M/IDopCj4gSSBkb24ndCB0aGluayB0aGlzIGlz
IGEgcXVlc3Rpb24gYWJvdXQgc3BlZWQuIEFyZCBkb2Vzbid0IGxpa2UgdGhlIHNwZWMuCj4gWW91
IGxpa2UgdGhlIGZlYXR1cmUgbW9yZSB0aGFuIHlvdSBkaXNsaWtlIHRoZSBzcGVjLiBBcHBhcmVu
dGx5IHRoYXQKPiBtZWFucyB0aGVyZSdzIGEgZGlzYWdyZWVtZW50Lgo+Cj4gQXMgSSBtZW50aW9u
ZWQgZWFybGllciwgSSdkIGVuY291cmFnZSB5b3UgdG8gc2VuZCBhIHBhdGNoIHRvIHRoZSBBQ1BJ
Cj4gcGVvcGxlIGFuZCBsZXQgdGhlbSBkZWNpZGUuIElmIHRoYXQgZ2V0cyBpbiwgdGhlbiBJJ20g
ZmluZSB3aXRoCj4gbW9kaWZ5aW5nIHZtZ2VuaWQgdG8gbWVldCB0aGUgc3BlYyBhbmQgdGFrZSBh
ZHZhbnRhZ2Ugb2YgdGhlIGNoYW5nZQo+IHlvdSdsbCBiZSBtYWtpbmcgdG8gdGhlIEFDUEkgY29k
ZS4gSWYgaXQgaXMgcmVqZWN0ZWQgYnkgdGhlIEFDUEkgcGVvcGxlLAo+IGFuZCBjb25zZXF1ZW50
bHkgTGludXggaXNuJ3QgYWJsZSB0byBtYXRjaCBvbiBfQ0lELCB0aGVuIEkgZ3Vlc3Mgd2UnbGwK
PiBoYXZlIHRoZSBuZXh0IGJlc3QgdGhpbmcsIHdoaWNoIGlzICJ3ZWxsLCBpdCBzdGlsbCB3b3Jr
cyBvbiBRRU1VLiIKPiBIb3BlZnVsbHkgeW91J2xsIGNvbnZpbmNlIHRoZW0uIEZlZWwgZnJlZSB0
byBDQyBtZSBvbiB0aGF0IHBhdGNoLgoKCkkgYWdyZWUgd2l0aCB0aGF0IGFwcHJvYWNoIGFuZCBD
QydlZCB5b3Ugb24gdGhlIEFDUEkgcGF0Y2ggOikuIExldCdzIApleHBsb3JlIGFsbCBvcHRpb25z
IHRvIG1hdGNoIGFnYWluc3QgX0NJRCBiZWZvcmUgd2UgZ2l2ZSB1cC4KCgpBbGV4CgoKCgoKQW1h
em9uIERldmVsb3BtZW50IENlbnRlciBHZXJtYW55IEdtYkgKS3JhdXNlbnN0ci4gMzgKMTAxMTcg
QmVybGluCkdlc2NoYWVmdHNmdWVocnVuZzogQ2hyaXN0aWFuIFNjaGxhZWdlciwgSm9uYXRoYW4g
V2Vpc3MKRWluZ2V0cmFnZW4gYW0gQW10c2dlcmljaHQgQ2hhcmxvdHRlbmJ1cmcgdW50ZXIgSFJC
IDE0OTE3MyBCClNpdHo6IEJlcmxpbgpVc3QtSUQ6IERFIDI4OSAyMzcgODc5CgoK

