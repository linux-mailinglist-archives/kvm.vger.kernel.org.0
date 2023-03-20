Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A423B6C13E6
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 14:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjCTNrg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 09:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjCTNre (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 09:47:34 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126311984;
        Mon, 20 Mar 2023 06:47:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9C76521B09;
        Mon, 20 Mar 2023 13:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679320051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JG1NfNYZbsuoe2pkjIqzOzgyiXaTYVCYng1U86OwRyg=;
        b=r5hHLO1Itsa1NJ96zUobt9zQy0kJCfJkxmiPZSZ52fddtwYlB6cVpX9iPYkpG2+k8V+fn+
        KTulba8lbtziKBZOKCrtLR6GOJlL1Vc2cCBpoROVBH2vIyq1uvQ54nGctxnl0yvabKHWKd
        dfS+E9c+eqFThrrYPPkLqZt3xXubgJk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 47C6C13416;
        Mon, 20 Mar 2023 13:47:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VGKkD/NjGGSzCwAAMHmgww
        (envelope-from <jgross@suse.com>); Mon, 20 Mar 2023 13:47:31 +0000
Message-ID: <f9511025-f815-c8fa-f6e7-80501e8c839f@suse.com>
Date:   Mon, 20 Mar 2023 14:47:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Cc:     "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20230306163425.8324-1-jgross@suse.com>
 <20230306163425.8324-4-jgross@suse.com>
 <9c02041e7ce91752ede17b7a5232f38aadbb3a70.camel@intel.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v4 03/12] x86/mtrr: support setting MTRR state for
 software defined MTRRs
In-Reply-To: <9c02041e7ce91752ede17b7a5232f38aadbb3a70.camel@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------6ghO3BfwC7REkCj1ARA9WLsT"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------6ghO3BfwC7REkCj1ARA9WLsT
Content-Type: multipart/mixed; boundary="------------XdLW0iqN5FxuAMjX282ap0Q0";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: "Huang, Kai" <kai.huang@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "x86@kernel.org" <x86@kernel.org>
Cc: "Christopherson,, Sean" <seanjc@google.com>, "bp@alien8.de"
 <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
Message-ID: <f9511025-f815-c8fa-f6e7-80501e8c839f@suse.com>
Subject: Re: [PATCH v4 03/12] x86/mtrr: support setting MTRR state for
 software defined MTRRs
References: <20230306163425.8324-1-jgross@suse.com>
 <20230306163425.8324-4-jgross@suse.com>
 <9c02041e7ce91752ede17b7a5232f38aadbb3a70.camel@intel.com>
In-Reply-To: <9c02041e7ce91752ede17b7a5232f38aadbb3a70.camel@intel.com>

--------------XdLW0iqN5FxuAMjX282ap0Q0
Content-Type: multipart/mixed; boundary="------------EzSRQ9SXZS3miStFulFcoOrq"

--------------EzSRQ9SXZS3miStFulFcoOrq
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjAuMDMuMjMgMTM6NTksIEh1YW5nLCBLYWkgd3JvdGU6DQo+IE9uIE1vbiwgMjAyMy0w
My0wNiBhdCAxNzozNCArMDEwMCwgSnVlcmdlbiBHcm9zcyB3cm90ZToNCj4+IFdoZW4gcnVu
bmluZyB2aXJ0dWFsaXplZCwgTVRSUiBhY2Nlc3MgY2FuIGJlIHJlZHVjZWQgKGUuZy4gaW4g
WGVuIFBWDQo+PiBndWVzdHMgb3Igd2hlbiBydW5uaW5nIGFzIGEgU0VWLVNOUCBndWVzdCB1
bmRlciBIeXBlci1WKS4gVHlwaWNhbGx5DQo+PiB0aGUgaHlwZXJ2aXNvciB3aWxsIHJlc2V0
IHRoZSBNVFJSIGZlYXR1cmUgaW4gQ1BVSUQgZGF0YSwgcmVzdWx0aW5nDQo+PiBpbiBubyBN
VFJSIG1lbW9yeSB0eXBlIGluZm9ybWF0aW9uIGJlaW5nIGF2YWlsYWJsZSBmb3IgdGhlIGtl
cm5lbC4NCj4+DQo+PiBUaGlzIGhhcyB0dXJuZWQgb3V0IHRvIHJlc3VsdCBpbiBwcm9ibGVt
czoNCj4+DQo+PiAtIEh5cGVyLVYgU0VWLVNOUCBndWVzdHMgdXNpbmcgdW5jYWNoZWQgbWFw
cGluZ3Mgd2hlcmUgdGhleSBzaG91bGRuJ3QNCj4+IC0gWGVuIFBWIGRvbTAgbWFwcGluZyBt
ZW1vcnkgYXMgV0Igd2hpY2ggc2hvdWxkIGJlIFVDLSBpbnN0ZWFkDQo+Pg0KPj4gU29sdmUg
dGhvc2UgcHJvYmxlbXMgYnkgc3VwcG9ydGluZyB0byBzZXQgYSBzdGF0aWMgTVRSUiBzdGF0
ZSwNCj4+IG92ZXJ3cml0aW5nIHRoZSBlbXB0eSBzdGF0ZSB1c2VkIHRvZGF5LiBJbiBjYXNl
IHN1Y2ggYSBzdGF0ZSBoYXMgYmVlbg0KPj4gc2V0LCBkb24ndCBjYWxsIGdldF9tdHJyX3N0
YXRlKCkgaW4gbXRycl9icF9pbml0KCkuIFRoZSBzZXQgc3RhdGUNCj4+IHdpbGwgb25seSBi
ZSB1c2VkIGJ5IG10cnJfdHlwZV9sb29rdXAoKSwgYXMgaW4gYWxsIG90aGVyIGNhc2VzDQo+
PiBtdHJyX2VuYWJsZWQoKSBpcyBiZWluZyBjaGVja2VkLCB3aGljaCB3aWxsIHJldHVybiBm
YWxzZS4gQWNjZXB0IHRoZQ0KPj4gb3ZlcndyaXRlIGNhbGwgb25seSBmb3Igc2VsZWN0ZWQg
Y2FzZXMgd2hlbiBydW5uaW5nIGFzIGEgZ3Vlc3QuDQo+PiBEaXNhYmxlIFg4Nl9GRUFUVVJF
X01UUlIgaW4gb3JkZXIgdG8gYXZvaWQgYW55IE1UUlIgbW9kaWZpY2F0aW9ucyBieQ0KPj4g
anVzdCByZWZ1c2luZyB0aGVtLg0KPj4NCj4+DQo+IFsuLi5dDQo+IA0KPj4gZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvbXRyci9nZW5lcmljLmMgYi9hcmNoL3g4Ni9rZXJu
ZWwvY3B1L210cnIvZ2VuZXJpYy5jDQo+PiBpbmRleCBlZTA5ZDM1OWUwOGYuLjQ5YjRjYzky
MzMxMiAxMDA2NDQNCj4+IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvbXRyci9nZW5lcmlj
LmMNCj4+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvbXRyci9nZW5lcmljLmMNCj4+IEBA
IC04LDEwICs4LDEyIEBADQo+PiAgICNpbmNsdWRlIDxsaW51eC9pbml0Lmg+DQo+PiAgICNp
bmNsdWRlIDxsaW51eC9pby5oPg0KPj4gICAjaW5jbHVkZSA8bGludXgvbW0uaD4NCj4+IC0N
Cj4+ICsjaW5jbHVkZSA8bGludXgvY2NfcGxhdGZvcm0uaD4NCj4+ICAgI2luY2x1ZGUgPGFz
bS9wcm9jZXNzb3ItZmxhZ3MuaD4NCj4+ICAgI2luY2x1ZGUgPGFzbS9jYWNoZWluZm8uaD4N
Cj4+ICAgI2luY2x1ZGUgPGFzbS9jcHVmZWF0dXJlLmg+DQo+PiArI2luY2x1ZGUgPGFzbS9o
eXBlcnZpc29yLmg+DQo+PiArI2luY2x1ZGUgPGFzbS9tc2h5cGVydi5oPg0KPiANCj4gSXMg
PGFzbS9tc2h5cGVydi5oPiBuZWVkZWQgaGVyZT8NCg0KWWVzLCBmb3IgaHZfaXNfaXNvbGF0
aW9uX3N1cHBvcnRlZCgpLg0KDQo+IA0KPj4gICAjaW5jbHVkZSA8YXNtL3RsYmZsdXNoLmg+
DQo+PiAgICNpbmNsdWRlIDxhc20vbXRyci5oPg0KPj4gICAjaW5jbHVkZSA8YXNtL21zci5o
Pg0KPj4gQEAgLTI0MCw2ICsyNDIsNDggQEAgc3RhdGljIHU4IG10cnJfdHlwZV9sb29rdXBf
dmFyaWFibGUodTY0IHN0YXJ0LCB1NjQgZW5kLCB1NjQgKnBhcnRpYWxfZW5kLA0KPj4gICAJ
cmV0dXJuIG10cnJfc3RhdGUuZGVmX3R5cGU7DQo+PiAgIH0NCj4+ICAgDQo+PiArLyoqDQo+
PiArICogbXRycl9vdmVyd3JpdGVfc3RhdGUgLSBzZXQgc3RhdGljIE1UUlIgc3RhdGUNCj4+
ICsgKg0KPj4gKyAqIFVzZWQgdG8gc2V0IE1UUlIgc3RhdGUgdmlhIGRpZmZlcmVudCBtZWFu
cyAoZS5nLiB3aXRoIGRhdGEgb2J0YWluZWQgZnJvbQ0KPj4gKyAqIGEgaHlwZXJ2aXNvciku
DQo+IA0KPiArS1ZNIGxpc3QgYW5kIEtWTSBtYWludGFpbmVycywNCj4gDQo+IElJVUMgaW4g
dGhlIG5leHQgcGF0Y2gsIFNFVi1TTlAgZ3Vlc3Qgb25seSBzZXRzIGEgc3ludGhldGljIE1U
UlIgdy9vIHRlbGxpbmcgdGhlDQo+IGh5cGVydmlzb3IgKGh5cGVydikuICBJIHRoaW5rIHRo
aXMgd29ya3MgZm9yIFNFVi1TTlAgcnVubmluZyBvbiB0b3Agb2YgaHlwZXJ2DQo+IGJlY2F1
c2UgdGhleSBoYXZlIG11dHVhbCB1bmRlcnN0YW5kaW5nPw0KPiANCj4gV2hhdCBhYm91dCB0
aGUgU05QIGd1ZXN0IHJ1bm5pbmcgb24gb3RoZXIgaHlwZXJ2aXNvcnMgc3VjaCBhcyBLVk0/
DQo+IA0KPiBTaW5jZSB0aGlzIGNvZGUgY292ZXJzIFREWCBndWVzdCB0b28sIEkgdGhpbmsg
ZXZlbnR1YWxseSBpdCBtYWtlcyBzZW5zZSBmb3IgVERYDQo+IGd1ZXN0IHRvIHVzZSB0aGlz
IGZ1bmN0aW9uIHRvbyAodG8gYXZvaWQgI1ZFIElJVUMpLiAgSWYgd2FudCB0byBkbyB0aGF0
LCB0aGVuIEkNCj4gdGhpbmsgVERYIGd1ZXN0IHNob3VsZCBoYXZlIHRoZSBzYW1lIG11dHVh
bCB1bmRlcnN0YW5kaW5nIHdpdGggKkFMTCogaHlwZXJ2aXNvciwNCj4gYXMgSSBhbSBub3Qg
c3VyZSB3aGF0J3MgdGhlIHBvaW50IG9mIG1ha2luZyB0aGUgVERYIGd1ZXN0J3MgTVRSUiBi
ZWhhdmlvdXINCj4gZGVwZW5kaW5nIG9uIHNwZWNpZmljIGh5cGVydmlzb3IuDQoNClRoaXMg
c2VyaWVzIHRyaWVzIHRvIGZpeCB0aGUgY3VycmVudCBmYWxsb3V0Lg0KDQpCb3JpcyBQZXRr
b3YgYXNrZWQgZm9yIHRoZSBoeXBlcnZpc29yIHNwZWNpZmljIHRlc3RzIHRvIGJlIGFkZGVk
LCBzbyBJJ3ZlDQphZGRlZCB0aGVtIGFmdGVyIGRpc2N1c3NpbmcgdGhlIHRvcGljIHdpdGgg
aGltIChoZSBpcyB0aGUgbWFpbnRhaW5lciBvZg0KdGhpcyBjb2RlIGFmdGVyIGFsbCkuDQoN
Cj4gRm9yIG5vdyBJIGRvbid0IHNlZSB0aGVyZSdzIGFueSB1c2UgY2FzZSBmb3IgVERYIGd1
ZXN0IHRvIHVzZSBub24tV0IgbWVtb3J5IHR5cGUNCj4gKGluIGZhY3QsIEtWTSBhbHdheXMg
bWFwcyBndWVzdCBtZW1vcnkgYXMgV0IgaWYgdGhlcmUncyBubyBub24tY29oZXJlbnQgRE1B
IHRvDQo+IHRoZSBndWVzdCBtZW1vcnkpLCBzbyB0byBtZSBpdCBzZWVtcyBpdCdzIE9LIHRv
IG1ha2UgYSB1bml2ZXJzYWwgbXV0dWFsDQo+IHVuZGVyc3RhbmRpbmcgdGhhdCBURFggZ3Vl
c3Qgd2lsbCBhbHdheXMgaGF2ZSBXQiBtZW1vcnkgdHlwZSBmb3IgYWxsIG1lbW9yeS4NCg0K
SSBhZ3JlZS4NCg0KPiBCdXQsIEkgYW0gbm90IHN1cmUgd2hldGhlciBpdCdzIGJldHRlciB0
byBoYXZlIGEgc3RhbmRhcmQgaHlwZXJjYWxsIGJldHdlZW4NCj4gZ3Vlc3QgJiBoeXBlcnZp
c29yIGZvciB0aGlzIHB1cnBvc2Ugc28gdGhpbmdzIGNhbiBiZSBtb3JlIGZsZXhpYmxlPw0K
DQpNYXliZS4gQnV0IGZvciBub3cgd2UgbmVlZCB0byBoYW5kbGUgdGhlIGN1cnJlbnQgc2l0
dWF0aW9uLg0KDQoNCkp1ZXJnZW4NCg==
--------------EzSRQ9SXZS3miStFulFcoOrq
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------EzSRQ9SXZS3miStFulFcoOrq--

--------------XdLW0iqN5FxuAMjX282ap0Q0--

--------------6ghO3BfwC7REkCj1ARA9WLsT
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmQYY/IFAwAAAAAACgkQsN6d1ii/Ey9D
Wwf/f3RfTC6okgNEgmL1mVuSGTHncOSe6foNwWkpYew7Ok2S1s62Vdao6pAKUmij/V16ksjWLF79
scSVUNtLGJC0CO69CvVQRmi4ymGum15NezvIyCkLOxGk2NFqgKI4WzlB11KSpqumHNSsmCDvndNO
myGbzHuMLZ5i/rkHzhqdHce39oRKVa6RQXv1Lgl4UbfFHIovT1eVoUxHFKvnNzA2FZ75BefYv8b9
UWzInZKSgf4uIw2EPqPGwPjp0wXdKY8RDOvgglo1tIG/8UVuDNgr9Wbb+jSEZpao/H1JJOFIGWBp
2d6Z7l3TKfKuMd5bqx7x1WeSEM7emZMTcOZ0tIH4lQ==
=UeC8
-----END PGP SIGNATURE-----

--------------6ghO3BfwC7REkCj1ARA9WLsT--
