Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175454DB198
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 14:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbiCPNhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 09:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbiCPNhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 09:37:36 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC0147074
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 06:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1647437782; x=1678973782;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LID3NASxxrjDJ/rpZG3bSzKJhX8jrfOreVS/2PCDuDM=;
  b=mtgevURXnjmGZCnK0+zfMtDqeEWde0+QidNce4IE2prckG1yQVBnkt1f
   WpK+gEnrgQzNSwLwuAZbt0btRqxC75SHBp6Q5ZDPsrGfygpWXJrhkOLIP
   xojEoo4Hg7/DgXFq25sSqnV9GT+4mRuxGNwq+udlFTtEagrVxziiNvWaU
   E=;
X-IronPort-AV: E=Sophos;i="5.90,186,1643673600"; 
   d="scan'208";a="186476741"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-a31e1d63.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 16 Mar 2022 13:36:10 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-a31e1d63.us-east-1.amazon.com (Postfix) with ESMTPS id 9295388936;
        Wed, 16 Mar 2022 13:36:05 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Wed, 16 Mar 2022 13:36:04 +0000
Received: from [0.0.0.0] (10.43.160.100) by EX13D20UWC001.ant.amazon.com
 (10.43.162.244) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 16 Mar
 2022 13:36:00 +0000
Message-ID: <da1dd6ee-6f3b-0470-cff3-9c2eb44d0ae6@amazon.com>
Date:   Wed, 16 Mar 2022 14:35:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     Stefan Hajnoczi <stefanha@gmail.com>
CC:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        "Rust-VMM Mailing List" <rust-vmm@lists.opendev.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Hannes Reinecke <hare@suse.de>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Alex Agache <aagch@amazon.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>, <ohering@suse.de>,
        "Eftime, Petre" <epetre@amazon.com>,
        Andra-Irina Paraschiv <andraprs@amazon.com>
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <244647ca-a247-cfc1-d0df-b8c74d434a77@amazon.com>
 <CAJSP0QVqvvN=sbm=XMT8mxHQNcSfNfTrnWJXXf-QgXwxAfzdcA@mail.gmail.com>
 <CAJSP0QUZS=vcruOixYwsC_Nwy2mvgeemuJimSqv98KsKr4BdSQ@mail.gmail.com>
From:   Alexander Graf <graf@amazon.com>
In-Reply-To: <CAJSP0QUZS=vcruOixYwsC_Nwy2mvgeemuJimSqv98KsKr4BdSQ@mail.gmail.com>
X-Originating-IP: [10.43.160.100]
X-ClientProxiedBy: EX13D41UWC001.ant.amazon.com (10.43.162.107) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGV5IFN0ZWZhbiEKCk9uIDE2LjAzLjIyIDE0OjE2LCBTdGVmYW4gSGFqbm9jemkgd3JvdGU6Cj4g
T24gTW9uLCAxNCBGZWIgMjAyMiBhdCAxMzo1OCwgU3RlZmFuIEhham5vY3ppIDxzdGVmYW5oYUBn
bWFpbC5jb20+IHdyb3RlOgo+PiBPbiBXZWQsIDkgRmViIDIwMjIgYXQgMTQ6NTAsIEFsZXhhbmRl
ciBHcmFmIDxncmFmQGFtYXpvbi5jb20+IHdyb3RlOgo+Pj4gT24gMjguMDEuMjIgMTY6NDcsIFN0
ZWZhbiBIYWpub2N6aSB3cm90ZToKPj4+PiBEZWFyIFFFTVUsIEtWTSwgYW5kIHJ1c3Qtdm1tIGNv
bW11bml0aWVzLAo+Pj4+IFFFTVUgd2lsbCBhcHBseSBmb3IgR29vZ2xlIFN1bW1lciBvZiBDb2Rl
IDIwMjIKPj4+PiAoaHR0cHM6Ly9zdW1tZXJvZmNvZGUud2l0aGdvb2dsZS5jb20vKSBhbmQgaGFz
IGJlZW4gYWNjZXB0ZWQgaW50bwo+Pj4+IE91dHJlYWNoeSBNYXktQXVndXN0IDIwMjIgKGh0dHBz
Oi8vd3d3Lm91dHJlYWNoeS5vcmcvKS4gWW91IGNhbiBub3cKPj4+PiBzdWJtaXQgaW50ZXJuc2hp
cCBwcm9qZWN0IGlkZWFzIGZvciBRRU1VLCBLVk0sIGFuZCBydXN0LXZtbSEKPj4+Pgo+Pj4+IElm
IHlvdSBoYXZlIGV4cGVyaWVuY2UgY29udHJpYnV0aW5nIHRvIFFFTVUsIEtWTSwgb3IgcnVzdC12
bW0geW91IGNhbgo+Pj4+IGJlIGEgbWVudG9yLiBJdCdzIGEgZ3JlYXQgd2F5IHRvIGdpdmUgYmFj
ayBhbmQgeW91IGdldCB0byB3b3JrIHdpdGgKPj4+PiBwZW9wbGUgd2hvIGFyZSBqdXN0IHN0YXJ0
aW5nIG91dCBpbiBvcGVuIHNvdXJjZS4KPj4+Pgo+Pj4+IFBsZWFzZSByZXBseSB0byB0aGlzIGVt
YWlsIGJ5IEZlYnJ1YXJ5IDIxc3Qgd2l0aCB5b3VyIHByb2plY3QgaWRlYXMuCj4+Pj4KPj4+PiBH
b29kIHByb2plY3QgaWRlYXMgYXJlIHN1aXRhYmxlIGZvciByZW1vdGUgd29yayBieSBhIGNvbXBl
dGVudAo+Pj4+IHByb2dyYW1tZXIgd2hvIGlzIG5vdCB5ZXQgZmFtaWxpYXIgd2l0aCB0aGUgY29k
ZWJhc2UuIEluCj4+Pj4gYWRkaXRpb24sIHRoZXkgYXJlOgo+Pj4+IC0gV2VsbC1kZWZpbmVkIC0g
dGhlIHNjb3BlIGlzIGNsZWFyCj4+Pj4gLSBTZWxmLWNvbnRhaW5lZCAtIHRoZXJlIGFyZSBmZXcg
ZGVwZW5kZW5jaWVzCj4+Pj4gLSBVbmNvbnRyb3ZlcnNpYWwgLSB0aGV5IGFyZSBhY2NlcHRhYmxl
IHRvIHRoZSBjb21tdW5pdHkKPj4+PiAtIEluY3JlbWVudGFsIC0gdGhleSBwcm9kdWNlIGRlbGl2
ZXJhYmxlcyBhbG9uZyB0aGUgd2F5Cj4+Pj4KPj4+PiBGZWVsIGZyZWUgdG8gcG9zdCBpZGVhcyBl
dmVuIGlmIHlvdSBhcmUgdW5hYmxlIHRvIG1lbnRvciB0aGUgcHJvamVjdC4KPj4+PiBJdCBkb2Vz
bid0IGh1cnQgdG8gc2hhcmUgdGhlIGlkZWEhCj4+Pgo+Pj4gSSBoYXZlIG9uZSB0aGF0IEknZCBh
YnNvbHV0ZWx5ICpsb3ZlKiB0byBzZWUgYnV0IG5vdCBnb3R0ZW4gYXJvdW5kCj4+PiBpbXBsZW1l
bnRpbmcgbXlzZWxmIHlldCA6KQo+Pj4KPj4+Cj4+PiBTdW1tYXJ5Ogo+Pj4KPj4+IEltcGxlbWVu
dCAtTSBuaXRyby1lbmNsYXZlIGluIFFFTVUKPj4+Cj4+PiBOaXRybyBFbmNsYXZlcyBhcmUgdGhl
IGZpcnN0IHdpZGVseSBhZG9wdGVkIGltcGxlbWVudGF0aW9uIG9mIGh5cGVydmlzb3IKPj4+IGFz
c2lzdGVkIGNvbXB1dGUgaXNvbGF0aW9uLiBTaW1pbGFyIHRvIHRlY2hub2xvZ2llcyBsaWtlIFNH
WCwgaXQgYWxsb3dzCj4+PiB0byBzcGF3biBhIHNlcGFyYXRlIGNvbnRleHQgdGhhdCBpcyBpbmFj
Y2Vzc2libGUgYnkgdGhlIHBhcmVudCBPcGVyYXRpbmcKPj4+IFN5c3RlbS4gVGhpcyBpcyBpbXBs
ZW1lbnRlZCBieSAiZ2l2aW5nIHVwIiByZXNvdXJjZXMgb2YgdGhlIHBhcmVudCBWTQo+Pj4gKENQ
VSBjb3JlcywgbWVtb3J5KSB0byB0aGUgaHlwZXJ2aXNvciB3aGljaCB0aGVuIHNwYXducyBhIHNl
Y29uZCB2bW0gdG8KPj4+IGV4ZWN1dGUgYSBjb21wbGV0ZWx5IHNlcGFyYXRlIHZpcnR1YWwgbWFj
aGluZS4gVGhhdCBuZXcgVk0gb25seSBoYXMgYQo+Pj4gdnNvY2sgY29tbXVuaWNhdGlvbiBjaGFu
bmVsIHRvIHRoZSBwYXJlbnQgYW5kIGhhcyBhIGJ1aWx0LWluIGxpZ2h0d2VpZ2h0Cj4+PiBUUE0u
Cj4+Pgo+Pj4gT25lIGJpZyBjaGFsbGVuZ2Ugd2l0aCBOaXRybyBFbmNsYXZlcyBpcyB0aGF0IGR1
ZSB0byBpdHMgcm9vdHMgaW4KPj4+IHNlY3VyaXR5LCB0aGVyZSBhcmUgdmVyeSBmZXcgZGVidWdn
aW5nIC8gaW50cm9zcGVjdGlvbiBjYXBhYmlsaXRpZXMuCj4+PiBUaGF0IG1ha2VzIE9TIGJyaW5n
dXAsIGRlYnVnZ2luZyBhbmQgYm9vdHN0cmFwcGluZyB2ZXJ5IGRpZmZpY3VsdC4KPj4+IEhhdmlu
ZyBhIGxvY2FsIGRldiZ0ZXN0IGVudmlyb25tZW50IHRoYXQgbG9va3MgbGlrZSBhbiBFbmNsYXZl
LCBidXQgaXMKPj4+IDEwMCUgY29udHJvbGxlZCBieSB0aGUgZGV2ZWxvcGVyIGFuZCBpbnRyb3Nw
ZWN0YWJsZSB3b3VsZCBtYWtlIGxpZmUgYQo+Pj4gbG90IGVhc2llciBmb3IgZXZlcnlvbmUgd29y
a2luZyBvbiB0aGVtLiBJdCBhbHNvIG1heSBwYXZlIHRoZSB3YXkgdG8gc2VlCj4+PiBOaXRybyBF
bmNsYXZlcyBhZG9wdGVkIGluIFZNIGVudmlyb25tZW50cyBvdXRzaWRlIG9mIEVDMi4KPj4+Cj4+
PiBUaGlzIHByb2plY3Qgd2lsbCBjb25zaXN0IG9mIGFkZGluZyBhIG5ldyBtYWNoaW5lIG1vZGVs
IHRvIFFFTVUgdGhhdAo+Pj4gbWltaWNzIGEgTml0cm8gRW5jbGF2ZSBlbnZpcm9ubWVudCwgaW5j
bHVkaW5nIHRoZSBsaWdodHdlaWdodCBUUE0sIHRoZQo+Pj4gdnNvY2sgY29tbXVuaWNhdGlvbiBj
aGFubmVsIGFuZCBidWlsZGluZyBmaXJtd2FyZSB3aGljaCBsb2FkcyB0aGUKPj4+IHNwZWNpYWwg
IkVJRiIgZmlsZSBmb3JtYXQgd2hpY2ggY29udGFpbnMga2VybmVsLCBpbml0cmFtZnMgYW5kIG1l
dGFkYXRhCj4+PiBmcm9tIGEgLWtlcm5lbCBpbWFnZS4KPj4+Cj4+PiBMaW5rczoKPj4+Cj4+PiBo
dHRwczovL2F3cy5hbWF6b24uY29tL2VjMi9uaXRyby9uaXRyby1lbmNsYXZlcy8KPj4+IGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAyMDA5MjExMjE3MzIuNDQyOTEtMTAtYW5kcmFwcnNA
YW1hem9uLmNvbS9ULwo+Pj4KPj4+IERldGFpbHM6Cj4+Pgo+Pj4gU2tpbGwgbGV2ZWw6IGludGVy
bWVkaWF0ZSAtIGFkdmFuY2VkIChzb21lIHVuZGVyc3RhbmRpbmcgb2YgUUVNVSBtYWNoaW5lCj4+
PiBtb2RlbGluZyB3b3VsZCBiZSBnb29kKQo+Pj4gTGFuZ3VhZ2U6IEMKPj4+IE1lbnRvcjogTWF5
YmUgbWUgKEFsZXhhbmRlciBHcmFmKSwgZGVwZW5kcyBvbiB0aW1lbGluZXMgYW5kIGhvbGlkYXkK
Pj4+IHNlYXNvbi4gTGV0J3MgZmluZCBhbiBpbnRlcm4gZmlyc3QgLSBJIHByb21pc2UgdG8gZmlu
ZCBhIG1lbnRvciB0aGVuIDopCj4+PiBTdWdnZXN0ZWQgYnk6IEFsZXhhbmRlciBHcmFmCj4+Pgo+
Pj4KPj4+IE5vdGU6IEkgZG9uJ3Qga25vdyBlbm91Z2ggYWJvdXQgcnVzdC12bW0ncyBkZWJ1Z2dp
bmcgY2FwYWJpbGl0aWVzLiBJZiBpdAo+Pj4gaGFzIGdkYnN0dWIgYW5kIGEgbG9jYWwgVUFSVCB0
aGF0J3MgZWFzaWx5IHVzYWJsZSwgdGhlIHByb2plY3QgbWlnaHQgYmUKPj4+IHBlcmZlY3RseSB2
aWFibGUgdW5kZXIgaXRzIHVtYnJlbGxhIGFzIHdlbGwgLSB3cml0dGVuIGluIFJ1c3QgdGhlbiBv
Zgo+Pj4gY291cnNlLgo+PiBJdCB3b3VsZCBiZSBncmVhdCB0byBoYXZlIGFuIG9wZW4gc291cmNl
IEVuY2xhdmUgZW52aXJvbm1lbnQgZm9yCj4+IGRldmVsb3BtZW50IGFuZCB0ZXN0aW5nIGluIFFF
TVUuCj4+Cj4+IENvdWxkIHlvdSBhZGQgYSBsaXR0bGUgbW9yZSBkZXRhaWwgYWJvdXQgdGhlIHRh
c2tzIGludm9sdmVkLiBTb21ldGhpbmcKPj4gYWxvbmcgdGhlIGxpbmVzIG9mOgoKCkkgbXVzdCd2
ZSBjb21wbGV0ZWx5IG1pc3NlZCB5b3VyIGVtYWlsLCBzb3JyeSA6KS4KCgo+PiAtIEltcGxlbWVu
dCBhIGRldmljZSBtb2RlbCBmb3IgdGhlIFRQTSBkZXZpY2UgKGxpbmsgdG8gc3BlYyBvciBkcml2
ZXIKPj4gY29kZSBiZWxvdykKPj4gLSBJbXBsZW1lbnQgdnNvY2sgZGV2aWNlIChvciBpcyB0aGlz
IHZpcnRpby1tbWlvIHZzb2NrPykKCgpZZWFoLCBpdCdzIGRlcml2ZWQgZnJvbSBGaXJlY3JhY2tl
ci4gU28gdmlydGlvLW1taW8gZm9yIHZzb2NrLgoKCj4+IC0gQWRkIGEgdGVzdCBmb3IgdGhlIFRQ
TSBkZXZpY2UKPj4gLSBBZGQgYW4gYWNjZXB0YW5jZSB0ZXN0IHRoYXQgYm9vdHMgYSBtaW5pbWFs
IEVJRiBwYXlsb2FkCj4+Cj4+IFRoaXMgd2lsbCBnaXZlIGNhbmRpZGF0ZXMgbW9yZSBrZXl3b3Jk
cyBhbmQgbGlua3MgdG8gcmVzZWFyY2ggdGhpcyBwcm9qZWN0Lgo+IEhpIEFsZXgsCj4gV291bGQg
eW91IGxpa2UgbWUgdG8gYWRkIHRoaXMgcHJvamVjdCBpZGVhIHRvIHRoZSBsaXN0PyBQbGVhc2Ug
c2VlCj4gd2hhdCBJIHdyb3RlIGFib3ZlIGFib3V0IGFkZGluZyBkZXRhaWxzIGFib3V0IHRoZSB0
YXNrcyBpbnZvbHZlZC4KCgpQZXRyZSBsaXRlcmFsbHkgcG9pbnRlZCBtZSB0byB0aGUgZmFjdCB0
aGF0IHRoZSBwcm9qZWN0IGRpZCBub3QgZW5kIHVwIApvbiB0aGUgd2lraSBwYWdlIGEgZmV3IGhv
dXJzIGFnby4gSSBhZGRlZCBpdCBhbmQgYXVnbWVudGVkIHRoZSBiaXRzIAphYm92ZS4gUGxlYXNl
IGxldCBtZSBrbm93IGlmIHlvdSBzZWUgYW55dGhpbmcgZWxzZSBtaXNzaW5nISA6KQoKCkFsZXgK
CgoKCgpBbWF6b24gRGV2ZWxvcG1lbnQgQ2VudGVyIEdlcm1hbnkgR21iSApLcmF1c2Vuc3RyLiAz
OAoxMDExNyBCZXJsaW4KR2VzY2hhZWZ0c2Z1ZWhydW5nOiBDaHJpc3RpYW4gU2NobGFlZ2VyLCBK
b25hdGhhbiBXZWlzcwpFaW5nZXRyYWdlbiBhbSBBbXRzZ2VyaWNodCBDaGFybG90dGVuYnVyZyB1
bnRlciBIUkIgMTQ5MTczIEIKU2l0ejogQmVybGluClVzdC1JRDogREUgMjg5IDIzNyA4NzkKCgo=

