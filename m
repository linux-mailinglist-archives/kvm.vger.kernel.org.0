Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07FD116B86B
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 05:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgBYEMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 23:12:17 -0500
Received: from out0-145.mail.aliyun.com ([140.205.0.145]:38686 "EHLO
        out0-145.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgBYEMR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 23:12:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1582603933; h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type;
        bh=cEHttwHBwEcOvTilW/JmXjbUfPDOCl5orq/+mZTp7H0=;
        b=SXoLvWzP8Jar86IHICXJ9ZMsJZZpzfsxiF3yAA6iLalmvv3y5NYCJsl5u7ClnEF42FrnF+YBZLXNA0GNdoW5a6iN2tBDHY54P5ZcdsfMgSRbCf9l5RN2/QulztlI59/CWKaohUkRBaPFaQ34r7f2XQkdiiNrvteC20vLUTSLcp8=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01a16370;MF=bangcai.hrg@alibaba-inc.com;NM=1;PH=DW;RN=15;SR=0;TI=W4_5790132_DEFAULT_0A930F79_1582601665175_o7001c106b;
Received: from WS-web (bangcai.hrg@alibaba-inc.com[W4_5790132_DEFAULT_0A930F79_1582601665175_o7001c106b]) by e02c03300.eu6 at Tue, 25 Feb 2020 12:12:11 +0800
Date:   Tue, 25 Feb 2020 12:12:11 +0800
From:   "=?UTF-8?B?5L2V5a655YWJKOmCpumHhyk=?=" <bangcai.hrg@alibaba-inc.com>
To:     "namit" <namit@vmware.com>, "peterz" <peterz@infradead.org>,
        "kernellwp" <kernellwp@gmail.com>, "pbonzini" <pbonzini@redhat.com>
Cc:     "dave.hansen" <dave.hansen@intel.com>, "mingo" <mingo@redhat.com>,
        "tglx" <tglx@linutronix.de>, "x86" <x86@kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "dave.hansen" <dave.hansen@linux.intel.com>, "bp" <bp@alien8.de>,
        "luto" <luto@kernel.org>, "kvm" <kvm@vger.kernel.org>,
        "yongting.lyt" <yongting.lyt@alibaba-inc.com>,
        "=?UTF-8?B?5ZC05ZCv57++KOWQr+e/vik=?=" <qixuan.wqx@alibaba-inc.com>
Reply-To: "=?UTF-8?B?5L2V5a655YWJKOmCpumHhyk=?=" 
          <bangcai.hrg@alibaba-inc.com>
Message-ID: <07348bb2-c8a5-41d0-afca-26c1056570a5.bangcai.hrg@alibaba-inc.com>
Subject: =?UTF-8?B?W1JGQ10gUXVlc3Rpb24gYWJvdXQgYXN5bmMgVExCIGZsdXNoIGFuZCBLVk0gcHYgdGxiIGlt?=
  =?UTF-8?B?cHJvdmVtZW50cw==?=
X-Mailer: [Alimail-Mailagent revision 59873560][W4_5790132][DEFAULT][Chrome]
MIME-Version: 1.0
x-aliyun-mail-creator: W4_5790132_DEFAULT_M2ITW96aWxsYS81LjAgKFdpbmRvd3MgTlQgMTAuMDsgV2luNjQ7IHg2NCkgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzgwLjAuMzk4Ny4xMTYgU2FmYXJpLzUzNy4zNg==3L
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgdGhlcmUsCgpJIHNhdyB0aGlzIGFzeW5jIFRMQiBmbHVzaCBwYXRjaCBhdCBodHRwczovL2xv
cmUua2VybmVsLm9yZy9wYXRjaHdvcmsvcGF0Y2gvMTA4MjQ4MS8gLCBhbmQgSSBhbSB3b25kZXJp
bmcgYWZ0ZXIgb25lIHllYXIsIGRvIHlvdSB0aGluayBpZiB0aGlzIHBhdGNoIGlzIHByYWN0aWNh
bCBvciB0aGVyZSBhcmUgZnVuY3Rpb25hbCBmbGF3cz8KRnJvbSBteSBQT1YsIE5hZGF2J3MgcGF0
Y2ggc2VlbXMgaGFzIG5vIG9idmlvdXMgZmxhdy4gQnV0IEkgYW0gbm90IGZhbWlsaWFyIGFib3V0
IHRoZSByZWxhdGlvbnNoaXAgYmV0d2VlbiBDUFUncyBzcGVjdWxhdGlvbiBleGVjIGFuZCBzdGFs
ZSBUTEIsIHNpbmNlIGl0J3MgdXN1YWxseSB0cmFuc3BhcmVudCBmcm9tIHByb2dyYW1pbmcuIElu
IHdoaWNoIGNvbmRpdGlvbiB3b3VsZCBtYWNoaW5lIGNoZWNrIG9jY3Vycz8gSXMgdGhlcmUgc29t
ZSByZWZlcmVuY2UgSSBjYW4gbGVhcm4/CkJUVywgSSBhbSB0cnlpbmcgdG8gaW1wcm92ZSBrdm0g
cHYgdGxiIGZsdXNoIHRoYXQgaWYgYSB2Q1BVIGlzIHByZWVtcHRlZCwgYXMgaW5pdGlhdGluZyBD
UFUgaXMgbm90IHNlbmRpbmcgSVBJIHRvIGFuZCB3YWl0aW5nIGZvciB0aGUgcHJlZW1wdGVkIHZD
UFUsIHdoZW4gdGhlIHByZWVtcHRlZCB2Q1BVIGlzIHJlc3VtaW5nLCBJIHdhbnQgdGhlIFZNTSB0
byBpbmplY3QgYW4gaW50ZXJydXB0LCBwZXJoYXBzIE5NSSwgdG8gdGhlIHZDUFUgYW5kIGxldHRp
bmcgdkNQVSBmbHVzaCBUTEIgaW5zdGVhZCBvZiBmbHVzaCBUTEIgZm9yIHRoZSB2Q1BVLCBpbiBj
YXNlIHRoZSB2Q1BVIGlzIG5vdCBpbiBrZXJuZWwgbW9kZSBvciBkaXNhYmxlZCBpbnRlcnJ1cHQs
IG90aGVyd2lzZSBzdGljayB0byBWTU0gZmx1c2guIFNpbmNlIFZNTSBmbHVzaCB1c2luZyBJTlZW
UElEIHdvdWxkIGZsdXNoIGFsbCBUTEIgb2YgYWxsIFBDSUQgdGh1cyBoYXMgc29tZSBuZWdhdGl2
ZSBwZXJmb3JtYW5jZSBpbXBhY3Rpbmcgb24gdGhlIHByZWVtcHRlZCB2Q1BVLiBTbyBpcyB0aGVy
ZSBzYW1lIHByb2JsZW0gYXMgdGhlIGFzeW5jIFRMQiBmbHVzaCBwYXRjaD8KVGhhbmtzIGluIGFk
dmFuY2Uu
