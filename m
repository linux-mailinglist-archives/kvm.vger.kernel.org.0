Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E91A31E9EF
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 13:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhBRMfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 07:35:16 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:19729 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhBRLvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 06:51:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1613649067; x=1645185067;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:subject;
  bh=QeaA4BgLoScFVJehbQG/YZYaIZGYxNdw7wjzWkqg9f0=;
  b=FvtmpCXaoTzd8PIfxQ3eSEn/+KoOFVzrOB6g+zShh6yQ8xr3CNrxULC8
   VRaUKDXALgJBqSIn/ajsQzU0rZBSnHBIz/ukr0Lnl+YUkpu7yn2tFpaFN
   WQ5sdCNJLVK4jiLvzmwQvAnQM7Y7BWs3Yt9TLljsEKFAnniB3nzpCO8Mj
   s=;
X-Amazon-filename: 0x9B51563C1FA36782.asc
X-IronPort-AV: E=Sophos;i="5.81,187,1610409600"; 
   d="asc'?scan'208";a="84953348"
Subject: Re: [Rust-VMM] Call for Google Summer of Code 2021 project ideas
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 18 Feb 2021 11:50:12 +0000
Received: from EX13D10EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 6FFFCA209B;
        Thu, 18 Feb 2021 11:50:10 +0000 (UTC)
Received: from u0b01dd3105595b.ant.amazon.com (10.43.162.104) by
 EX13D10EUB003.ant.amazon.com (10.43.166.160) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 18 Feb 2021 11:50:02 +0000
To:     Stefan Hajnoczi <stefanha@gmail.com>
CC:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        "rust-vmm@lists.opendev.org" <rust-vmm@lists.opendev.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Alexander Graf <agraf@csgraf.de>,
        Alberto Garcia <berto@igalia.com>,
        David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        Aleksandar Markovic <Aleksandar.Markovic@rt-rk.com>,
        Sergio Lopez <slp@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
References: <CAJSP0QWWg__21otbMXAXWGD1FaHYLzZP7axZ47Unq6jtMvdfsA@mail.gmail.com>
 <1613136163375.99584@amazon.com>
 <CAJSP0QXEvw6o7XFk9FXudr9PmorFHiOuNRg16DjJhBgj_qC-FQ@mail.gmail.com>
From:   Andreea Florescu <fandree@amazon.com>
Autocrypt: addr=fandree@amazon.com; keydata=
 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
 TcmdMcglXIIwIrlvsrZQtO/DNJqe
Message-ID: <f0493c86-e92b-8bb6-a4a9-33646bf05fab@amazon.com>
Date:   Thu, 18 Feb 2021 13:49:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAJSP0QXEvw6o7XFk9FXudr9PmorFHiOuNRg16DjJhBgj_qC-FQ@mail.gmail.com>
Content-Type: multipart/mixed;
        boundary="------------AD190BD4942BACC0DA29D03D"
Content-Language: en-US
X-Originating-IP: [10.43.162.104]
X-ClientProxiedBy: EX13P01UWB004.ant.amazon.com (10.43.161.213) To
 EX13D10EUB003.ant.amazon.com (10.43.166.160)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--------------AD190BD4942BACC0DA29D03D
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64

CgpPbiAyLzE3LzIxIDE6MjAgUE0sIFN0ZWZhbiBIYWpub2N6aSB3cm90ZToKPiBDQVVUSU9OOiBU
aGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERv
IG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNvbmZp
cm0gdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLgo+Cj4KPgo+IFRoYW5r
cywgSSBoYXZlIHB1Ymxpc2hlZCB0aGUgcnVzdC12bW0gcHJvamVjdCBpZGVhcyBvbiB0aGUgd2lr
aToKPiBodHRwczovL3dpa2kucWVtdS5vcmcvR29vZ2xlX1N1bW1lcl9vZl9Db2RlXzIwMjEKVGhh
bmtzLCBTdGVmYW4hCj4KPiBQbGVhc2Ugc2VlIFNlcmdpbydzIHJlcGx5IGFib3V0IHZpcnRpby1j
b25zb2lsZSBpcyBsaWJrcnVuLiBNYXliZSBpdAo+IGFmZmVjdHMgdGhlIHByb2plY3QgaWRlYT8K
SSBzeW5jZWQgb2ZmbGluZSB3aXRoIFNlcmdpby4gSXQgc2VlbXMgSSd2ZSBtaXNyZWFkIGhpcyBj
b21tZW50LgpUaGUgY29kZSBpcyBhbHJlYWR5IGF2YWlsYWJsZSBpbiBsaWJrcnVuLCBhbmQgdG8g
cG9ydCBpdCB0byBydXN0LXZtbQp3aWxsIGxpa2VseSB0YWtlIGp1c3QgYSBjb3VwbGUgb2YgZGF5
cy4gV2UgZXhwbG9yZWQgdGhlIG9wdGlvbiBvZiBhbHNvCnJlcXVlc3RpbmcgdG8gaW1wbGVtZW50
IFZJUlRJT19DT05TT0xFX0ZfTVVMVElQT1JUIHRvIG1ha2UgaXQgYW4KYXBwcm9wcmlhdGUgR1Nv
QyBwcm9qZWN0LCBidXQgd2UgZGVjaWRlZCB0aGlzIGlzIG5vdCBhIGdvb2QgaWRlYSBzaW5jZQpp
dCBkb2Vzbid0IGxvb2sgbGlrZSB0aGF0IGZlYXR1cmUgaXMgdXNlZnVsIGZvciB0aGUgcHJvamVj
dHMgY29uc3VtaW5nCnJ1c3Qtdm1tLiBJdCBhbHNvIGFkZHMgY29tcGxleGl0eSwgYW5kIHdlIHdv
dWxkIG5lZWQgdG8gbWFpbnRhaW4gdGhhdCBhcwp3ZWxsLgoKU2luY2UgaXQgd291bGQgc3RpbGwg
YmUgbmljZSB0byBoYXZlIHZpcnRpby1jb25zb2xlIGluIHJ1c3Qtdm1tLCBJJ2xsCmp1c3Qgb3Bl
biBhbiBpc3N1ZSBpbiB2bS12aXJ0aW8gYW5kIGxhYmVsIGl0IHdpdGggImhlbHAgd2FudGVkIiBz
bwpwZW9wbGUgY2FuIHBpY2sgaXQgdXAuCkNhbiB3ZSByZW1vdmUgdGhlIHZpcnRpby1jb25zb2xl
IHByb2plY3QgZnJvbSB0aGUgbGlzdCBvZiBHU29DIGlkZWFzPwoKQWxzbywgaXVsQGFtYXpvbi5j
b20gd2lsbCBsaWtlIHRvIGhlbHAgd2l0aCBtZW50b3JpbmcgdGhlIEdTb0MgcHJvamVjdHMuCkNh
biBoZSBiZSBhZGRlZCBhcyBhIGNvLW1lbnRvciBvZjogIk1vY2tpbmcgZnJhbWV3b3JrIGZvciBW
aXJ0aW8gUXVldWVzIj8KClNvcnJ5IGZvciB0aGUgcGluZy1wb25nLCBhbmQgdGhhbmtzIGFnYWlu
IGZvciBldmVyeXRoaW5nIQoKQW5kcmVlYQoKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciAo
Um9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwg
VUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0
ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==

--------------AD190BD4942BACC0DA29D03D
Content-Type: application/pgp-keys; name="0x9B51563C1FA36782.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="0x9B51563C1FA36782.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
WEH16b1D1ddNyZ0xyCVcgjAiuW+ytlC078M0mp4=3D
=3DO+XH
-----END PGP PUBLIC KEY BLOCK-----

--------------AD190BD4942BACC0DA29D03D--

