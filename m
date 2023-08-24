Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B72786AFE
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 11:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235844AbjHXJCc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 05:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234292AbjHXJCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 05:02:01 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48C71739;
        Thu, 24 Aug 2023 02:01:58 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5ABA122C9B;
        Thu, 24 Aug 2023 09:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1692867717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=egg0anXRwEikjuBX1Cu3G3bFWp0ncIQVfRy2OweTBCs=;
        b=NeCkGtO57wesDc0moN2yZJNuuPZDrqoNsnWfRwdpdLwQzYEpHKcD7Rkw/2pzFR7RIOYLTc
        FWOdx1JDmOBJ+Me7pCeMRzyaJWmEGzJRC2RgmjS476wziijZREMIKTWs+huWfnjD2puzyL
        1tjGTzTHeA7QNvuNF/rl14H38Nn9puQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DF3EE138FB;
        Thu, 24 Aug 2023 09:01:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kMPzNIQc52QWUwAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 24 Aug 2023 09:01:56 +0000
Message-ID: <a32e211f-4add-4fb2-9e5a-480ae9b9bbf2@suse.com>
Date:   Thu, 24 Aug 2023 11:01:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/3] x86/paravirt: Get rid of paravirt patching
Content-Language: en-US
From:   Juergen Gross <jgross@suse.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org
References: <20230608140333.4083-1-jgross@suse.com>
 <acda7276-234b-9036-c178-ca2b441f3998@suse.com>
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
In-Reply-To: <acda7276-234b-9036-c178-ca2b441f3998@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------xA8JPSq6dXP1gpZd6i7AROJ0"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------xA8JPSq6dXP1gpZd6i7AROJ0
Content-Type: multipart/mixed; boundary="------------IlAJHtNd5EUXbqjj5ruYobon";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
 virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>,
 Alexey Makhalov <amakhalov@vmware.com>,
 VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, xen-devel@lists.xenproject.org
Message-ID: <a32e211f-4add-4fb2-9e5a-480ae9b9bbf2@suse.com>
Subject: Re: [RFC PATCH 0/3] x86/paravirt: Get rid of paravirt patching
References: <20230608140333.4083-1-jgross@suse.com>
 <acda7276-234b-9036-c178-ca2b441f3998@suse.com>
In-Reply-To: <acda7276-234b-9036-c178-ca2b441f3998@suse.com>

--------------IlAJHtNd5EUXbqjj5ruYobon
Content-Type: multipart/mixed; boundary="------------qW0bpoPA5AINx3Iryt6lqFLS"

--------------qW0bpoPA5AINx3Iryt6lqFLS
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

UElORyENCg0KT24gMTAuMDcuMjMgMTQ6MjksIEp1ZXJnZW4gR3Jvc3Mgd3JvdGU6DQo+IEFu
eSBjb21tZW50cz8NCj4gDQo+IE9uIDA4LjA2LjIzIDE2OjAzLCBKdWVyZ2VuIEdyb3NzIHdy
b3RlOg0KPj4gVGhpcyBpcyBhIHNtYWxsIHNlcmllcyBnZXR0aW5nIHJpZCBvZiBwYXJhdmly
dCBwYXRjaGluZyBieSBzd2l0Y2hpbmcNCj4+IGNvbXBsZXRlbHkgdG8gYWx0ZXJuYXRpdmUg
cGF0Y2hpbmcgZm9yIHRoZSBzYW1lIGZ1bmN0aW9uYWxpdHkuDQo+Pg0KPj4gVGhlIGJhc2lj
IGlkZWEgaXMgdG8gYWRkIHRoZSBjYXBhYmlsaXR5IHRvIHN3aXRjaCBmcm9tIGluZGlyZWN0
IHRvDQo+PiBkaXJlY3QgY2FsbHMgdmlhIGEgc3BlY2lhbCBhbHRlcm5hdGl2ZSBwYXRjaGlu
ZyBvcHRpb24uDQo+Pg0KPj4gVGhpcyByZW1vdmVzIF9zb21lXyBvZiB0aGUgcGFyYXZpcnQg
bWFjcm8gbWF6ZSwgYnV0IG1vc3Qgb2YgaXQgbmVlZHMNCj4+IHRvIHN0YXkgZHVlIHRvIHRo
ZSBuZWVkIG9mIGhpZGluZyB0aGUgY2FsbCBpbnN0cnVjdGlvbnMgZnJvbSB0aGUNCj4+IGNv
bXBpbGVyIGluIG9yZGVyIHRvIGF2b2lkIG5lZWRsZXNzIHJlZ2lzdGVyIHNhdmUvcmVzdG9y
ZS4NCj4+DQo+PiBXaGF0IGlzIGdvaW5nIGF3YXkgaXMgdGhlIG5hc3R5IHN0YWNraW5nIG9m
IGFsdGVybmF0aXZlIGFuZCBwYXJhdmlydA0KPj4gcGF0Y2hpbmcgYW5kIChvZiBjb3Vyc2Up
IHRoZSBzcGVjaWFsIC5wYXJhaW5zdHJ1Y3Rpb25zIGxpbmtlciBzZWN0aW9uLg0KPj4NCj4+
IEkgaGF2ZSB0ZXN0ZWQgdGhlIHNlcmllcyBvbiBiYXJlIG1ldGFsIGFuZCBhcyBYZW4gUFYg
ZG9tYWluIHRvIHN0aWxsDQo+PiB3b3JrLg0KPj4NCj4+IFJGQyBiZWNhdXNlIEknbSBxdWl0
ZSBzdXJlIHRoZXJlIHdpbGwgYmUgc29tZSBvYmp0b29sIHdvcmsgbmVlZGVkDQo+PiAoYXQg
bGVhc3QgcmVtb3ZpbmcgdGhlIHNwZWNpZmljIHBhcmF2aXJ0IGhhbmRsaW5nKS4NCj4+DQo+
PiBKdWVyZ2VuIEdyb3NzICgzKToNCj4+IMKgwqAgeDg2L3BhcmF2aXJ0OiBtb3ZlIHNvbWUg
ZnVuY3Rpb25zIGFuZCBkZWZpbmVzIHRvIGFsdGVybmF0aXZlDQo+PiDCoMKgIHg4Ni9hbHRl
cm5hdGl2ZTogYWRkIGluZGlyZWN0IGNhbGwgcGF0Y2hpbmcNCj4+IMKgwqAgeDg2L3BhcmF2
aXJ0OiBzd2l0Y2ggbWl4ZWQgcGFyYXZpcnQvYWx0ZXJuYXRpdmUgY2FsbHMgdG8gYWx0ZXJu
YXRpdmVfMg0KPj4NCj4+IMKgIGFyY2gveDg2L2luY2x1ZGUvYXNtL2FsdGVybmF0aXZlLmjC
oMKgwqDCoMKgwqDCoCB8IDI2ICsrKysrLQ0KPj4gwqAgYXJjaC94ODYvaW5jbHVkZS9hc20v
cGFyYXZpcnQuaMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMzkgKystLS0tLS0tDQo+PiDCoCBh
cmNoL3g4Ni9pbmNsdWRlL2FzbS9wYXJhdmlydF90eXBlcy5owqDCoMKgwqAgfCA2OCArKyst
LS0tLS0tLS0tLS0tDQo+PiDCoCBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9xc3BpbmxvY2tfcGFy
YXZpcnQuaCB8wqAgNCArLQ0KPj4gwqAgYXJjaC94ODYvaW5jbHVkZS9hc20vdGV4dC1wYXRj
aGluZy5owqDCoMKgwqDCoCB8IDEyIC0tLQ0KPj4gwqAgYXJjaC94ODYva2VybmVsL2FsdGVy
bmF0aXZlLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCA5OSArKysrKysrKysrKy0tLS0t
LS0tLS0tLQ0KPj4gwqAgYXJjaC94ODYva2VybmVsL2NhbGx0aHVua3MuY8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHwgMTcgKystLQ0KPj4gwqAgYXJjaC94ODYva2VybmVsL2t2bS5j
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgNCArLQ0KPj4g
wqAgYXJjaC94ODYva2VybmVsL21vZHVsZS5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB8IDIwICsrLS0tDQo+PiDCoCBhcmNoL3g4Ni9rZXJuZWwvcGFyYXZpcnQuY8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDU0ICsrLS0tLS0tLS0tLS0NCj4+IMKg
IGFyY2gveDg2L2tlcm5lbC92bWxpbnV4Lmxkcy5TwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHwgMTMgLS0tDQo+PiDCoCBhcmNoL3g4Ni90b29scy9yZWxvY3MuY8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMiArLQ0KPj4gwqAgYXJjaC94ODYveGVuL2ly
cS5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAg
MiArLQ0KPj4gwqAgMTMgZmlsZXMgY2hhbmdlZCwgMTExIGluc2VydGlvbnMoKyksIDI0OSBk
ZWxldGlvbnMoLSkNCj4+DQo+IA0KDQo=
--------------qW0bpoPA5AINx3Iryt6lqFLS
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------qW0bpoPA5AINx3Iryt6lqFLS--

--------------IlAJHtNd5EUXbqjj5ruYobon--

--------------xA8JPSq6dXP1gpZd6i7AROJ0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmTnHIQFAwAAAAAACgkQsN6d1ii/Ey8n
vwf+LLwfy/ZCu3h4Yznh9ADz+Z6QLx25dcChZ3PW9TpFv0/It2mewnB2dbbA9FXkMcKppkbIkOyT
qvFngSvS1JNDOb7hHe7HS7JWPiiaSzbRv2swl/k+KRj54o/7blTP9jAykQ0UtEoZTszQOwX6gMTX
h1xnTUSFtC5eS4Ijy4fjxqg9id2taSSWbMxohEJdSQ/XwzwtlCT4uk6aThzh1pxc2h/5Wf7yGnJg
yRydtilThbqiQ1HTGbgh40URW1ptUXj53gPc+lVOPV1obYQMWgqOrgpsL9dzBMSGvCNI0MNzdNCz
CJZ+YKQ6QSE17kPFUmamvzuoN2/zHGYPz5WsUuHasg==
=ELGp
-----END PGP SIGNATURE-----

--------------xA8JPSq6dXP1gpZd6i7AROJ0--
