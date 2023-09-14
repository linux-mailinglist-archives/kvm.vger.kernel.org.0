Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778CE79FB7B
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 08:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbjINGCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 02:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbjINGCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 02:02:44 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CD5DF;
        Wed, 13 Sep 2023 23:02:39 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7BBAE2185C;
        Thu, 14 Sep 2023 06:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694671358; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=UN6sspPIx39466fl+yxO68tXlqE24fawTHIm37vhBn4=;
        b=mpJlx73uIZL2iN/jToOMnMFHb3itmckBlbd98AVqtO/PjC685eTRNtoGXki7SrCtuYG/wl
        KFgBeLmgoOsergPrfZfQXOmFXQ1z8bJydFm5YA5NCOWuZjxxK+6mXGcW9gHW0bak2+SbbE
        73hNUuUUYyvZGa29XszOIaFStQNmoXc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D58E213580;
        Thu, 14 Sep 2023 06:02:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NLO+Mv2hAmUEWwAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 14 Sep 2023 06:02:37 +0000
Message-ID: <48d312f4-50cd-468d-af70-51314796b0d8@suse.com>
Date:   Thu, 14 Sep 2023 08:02:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 03/38] x86/msr: Add the WRMSRNS instruction support
Content-Language: en-US
To:     Xin Li <xin3.li@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-4-xin3.li@intel.com>
From:   Juergen Gross <jgross@suse.com>
Autocrypt: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==
In-Reply-To: <20230914044805.301390-4-xin3.li@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------VvzgLc0ddY8y20w2PeqS1wNo"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------VvzgLc0ddY8y20w2PeqS1wNo
Content-Type: multipart/mixed; boundary="------------OCPddz9Em9L06c0hebIM6Gc4";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Xin Li <xin3.li@intel.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
 linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, peterz@infradead.org,
 ravi.v.shankar@intel.com, mhiramat@kernel.org, andrew.cooper3@citrix.com,
 jiangshanlai@gmail.com
Message-ID: <48d312f4-50cd-468d-af70-51314796b0d8@suse.com>
Subject: Re: [PATCH v10 03/38] x86/msr: Add the WRMSRNS instruction support
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-4-xin3.li@intel.com>
In-Reply-To: <20230914044805.301390-4-xin3.li@intel.com>

--------------OCPddz9Em9L06c0hebIM6Gc4
Content-Type: multipart/mixed; boundary="------------cb9RlJPV0piuYa8dnn0zZdi9"

--------------cb9RlJPV0piuYa8dnn0zZdi9
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTQuMDkuMjMgMDY6NDcsIFhpbiBMaSB3cm90ZToNCj4gQWRkIGFuIGFsd2F5cyBpbmxp
bmUgQVBJIF9fd3Jtc3JucygpIHRvIGVtYmVkIHRoZSBXUk1TUk5TIGluc3RydWN0aW9uDQo+
IGludG8gdGhlIGNvZGUuDQo+IA0KPiBUZXN0ZWQtYnk6IFNoYW4gS2FuZyA8c2hhbi5rYW5n
QGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWGluIExpIDx4aW4zLmxpQGludGVsLmNv
bT4NCg0KSW4gb3JkZXIgdG8gYXZvaWQgaGF2aW5nIHRvIGFkZCBwYXJhdmlydCBzdXBwb3J0
IGZvciBXUk1TUk5TIEkgdGhpbmsNCnhlbl9pbml0X2NhcGFiaWxpdGllcygpIHNob3VsZCBn
YWluOg0KDQorCXNldHVwX2NsZWFyX2NwdV9jYXAoWDg2X0ZFQVRVUkVfV1JNU1JOUyk7DQoN
Cg0KSnVlcmdlbg0KDQo+IC0tLQ0KPiAgIGFyY2gveDg2L2luY2x1ZGUvYXNtL21zci5oIHwg
MTggKysrKysrKysrKysrKysrKysrDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDE4IGluc2VydGlv
bnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9tc3IuaCBi
L2FyY2gveDg2L2luY2x1ZGUvYXNtL21zci5oDQo+IGluZGV4IDY1ZWMxOTY1Y2QyOC4uYzI4
NGZmOWViZTY3IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9tc3IuaA0K
PiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9tc3IuaA0KPiBAQCAtOTcsNiArOTcsMTkg
QEAgc3RhdGljIF9fYWx3YXlzX2lubGluZSB2b2lkIF9fd3Jtc3IodW5zaWduZWQgaW50IG1z
ciwgdTMyIGxvdywgdTMyIGhpZ2gpDQo+ICAgCQkgICAgIDogOiAiYyIgKG1zciksICJhIihs
b3cpLCAiZCIgKGhpZ2gpIDogIm1lbW9yeSIpOw0KPiAgIH0NCj4gICANCj4gKy8qDQo+ICsg
KiBXUk1TUk5TIGJlaGF2ZXMgZXhhY3RseSBsaWtlIFdSTVNSIHdpdGggdGhlIG9ubHkgZGlm
ZmVyZW5jZSBiZWluZw0KPiArICogdGhhdCBpdCBpcyBub3QgYSBzZXJpYWxpemluZyBpbnN0
cnVjdGlvbiBieSBkZWZhdWx0Lg0KPiArICovDQo+ICtzdGF0aWMgX19hbHdheXNfaW5saW5l
IHZvaWQgX193cm1zcm5zKHUzMiBtc3IsIHUzMiBsb3csIHUzMiBoaWdoKQ0KPiArew0KPiAr
CS8qIEluc3RydWN0aW9uIG9wY29kZSBmb3IgV1JNU1JOUzsgc3VwcG9ydGVkIGluIGJpbnV0
aWxzID49IDIuNDAuICovDQo+ICsJYXNtIHZvbGF0aWxlKCIxOiAuYnl0ZSAweDBmLDB4MDEs
MHhjNlxuIg0KPiArCQkgICAgICIyOlxuIg0KPiArCQkgICAgIF9BU01fRVhUQUJMRV9UWVBF
KDFiLCAyYiwgRVhfVFlQRV9XUk1TUikNCj4gKwkJICAgICA6IDogImMiIChtc3IpLCAiYSIo
bG93KSwgImQiIChoaWdoKSk7DQo+ICt9DQo+ICsNCj4gICAjZGVmaW5lIG5hdGl2ZV9yZG1z
cihtc3IsIHZhbDEsIHZhbDIpCQkJXA0KPiAgIGRvIHsJCQkJCQkJXA0KPiAgIAl1NjQgX192
YWwgPSBfX3JkbXNyKChtc3IpKTsJCQlcDQo+IEBAIC0yOTcsNiArMzEwLDExIEBAIGRvIHsJ
CQkJCQkJXA0KPiAgIA0KPiAgICNlbmRpZgkvKiAhQ09ORklHX1BBUkFWSVJUX1hYTCAqLw0K
PiAgIA0KPiArc3RhdGljIF9fYWx3YXlzX2lubGluZSB2b2lkIHdybXNybnModTMyIG1zciwg
dTY0IHZhbCkNCj4gK3sNCj4gKwlfX3dybXNybnMobXNyLCB2YWwsIHZhbCA+PiAzMik7DQo+
ICt9DQo+ICsNCj4gICAvKg0KPiAgICAqIDY0LWJpdCB2ZXJzaW9uIG9mIHdybXNyX3NhZmUo
KToNCj4gICAgKi8NCg0K
--------------cb9RlJPV0piuYa8dnn0zZdi9
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------cb9RlJPV0piuYa8dnn0zZdi9--

--------------OCPddz9Em9L06c0hebIM6Gc4--

--------------VvzgLc0ddY8y20w2PeqS1wNo
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmUCof0FAwAAAAAACgkQsN6d1ii/Ey/Z
Ygf/fFOAgiGHRKwhq+fiBtmitqjuCWlNXY8uP2C+It97gt1yyUr3t1R2km3a7rHjTKgRdMjP4uW3
JWbkKaWAjFGVfodq6EF3h1zPEmGuXuGdQTscEEXjUoebhPeUbggLr5//p5g0BLbQYOn84RFRpVkD
EF0pSEz3DTx8ZA4p+UupIFbUGC4IxJM53COI38mMoplsRcDAbwo+IrTsuK5BGSnmOa3/JKYflJBE
NL6WB9YcFm5atMMlgjkMPIH9lb0eWyrh8PLl1Q+rfx7EcFA7K+q1eoFRcsKJNoX8Ox6CP+sEFBgf
ZzsjTmX/1IFmS3F9Y5Q/hsPnTHQ0SZ4fBgRCKmxv3g==
=d8Tq
-----END PGP SIGNATURE-----

--------------VvzgLc0ddY8y20w2PeqS1wNo--
