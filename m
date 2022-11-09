Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F92622489
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 08:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiKIHV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 02:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiKIHV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 02:21:58 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A9F186C6;
        Tue,  8 Nov 2022 23:21:55 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 63B302242C;
        Wed,  9 Nov 2022 07:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1667978514; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mOiktVdrV4FzsqcU1nSNFLn0ByE//8QCCs526i9+tdw=;
        b=R1l/1TFh6sMmFMPwyCvCEKxkAHXsSyy0W7weV1U2T3tB++6a36ziIES4xMy264jy9R9rZr
        oxFmHHHeDLHHeFaDv4s+3xjl24MVotvkY9NplTfZ1WhxQMs1NA+RcBW889OSjeUgah0ufi
        v3FtB+BNTGpIXgIg8vUe75hTAXf9PWY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F09C21331F;
        Wed,  9 Nov 2022 07:21:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zv1vORFVa2PcLgAAMHmgww
        (envelope-from <jgross@suse.com>); Wed, 09 Nov 2022 07:21:53 +0000
Message-ID: <820ab144-5841-e3d9-88ec-52093f42be74@suse.com>
Date:   Wed, 9 Nov 2022 08:21:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] x86/paravirt: use common macro for creating simple asm
 paravirt functions
Content-Language: en-US
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Cc:     Alexey Makhalov <amakhalov@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20221020091950.6741-1-jgross@suse.com>
 <7f620a41-c68d-20ad-cdde-cd545c772014@csail.mit.edu>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <7f620a41-c68d-20ad-cdde-cd545c772014@csail.mit.edu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------shouL010u3Mr0e0Q9VFIBCgV"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------shouL010u3Mr0e0Q9VFIBCgV
Content-Type: multipart/mixed; boundary="------------X9YsFQnwdhkVRWzIiGnpsMmR";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>,
 linux-kernel@vger.kernel.org, x86@kernel.org,
 virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Cc: Alexey Makhalov <amakhalov@vmware.com>,
 VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Message-ID: <820ab144-5841-e3d9-88ec-52093f42be74@suse.com>
Subject: Re: [PATCH] x86/paravirt: use common macro for creating simple asm
 paravirt functions
References: <20221020091950.6741-1-jgross@suse.com>
 <7f620a41-c68d-20ad-cdde-cd545c772014@csail.mit.edu>
In-Reply-To: <7f620a41-c68d-20ad-cdde-cd545c772014@csail.mit.edu>

--------------X9YsFQnwdhkVRWzIiGnpsMmR
Content-Type: multipart/mixed; boundary="------------jfhg0fn1IeRuyYfJsUea8HcA"

--------------jfhg0fn1IeRuyYfJsUea8HcA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDkuMTEuMjIgMDY6MTYsIFNyaXZhdHNhIFMuIEJoYXQgd3JvdGU6DQo+IEhpIEp1ZXJn
ZW4sDQo+IA0KPiBTb3JyeSBmb3IgdGhlIGRlbGF5IGluIHJldmlld2luZyB0aGlzIHBhdGNo
IQ0KPiANCj4gT24gMTAvMjAvMjIgMjoxOSBBTSwgSnVlcmdlbiBHcm9zcyB3cm90ZToNCj4+
IFRoZXJlIGFyZSBzb21lIHBhcmF2aXJ0IGFzc2VtYmxlciBmdW5jdGlvbnMgd2hpY2ggYXJl
IHNoYXJpbmcgYSBjb21tb24NCj4+IHBhdHRlcm4uIEludHJvZHVjZSBhIG1hY3JvIERFRklO
RV9QQVJBVklSVF9BU00oKSBmb3IgY3JlYXRpbmcgdGhlbS4NCj4+DQo+PiBUaGUgZXhwbGlj
aXQgX3BhcmF2aXJ0X25vcCgpIHByb3RvdHlwZSBpbiBwYXJhdmlydC5jIGlzbid0IG5lZWRl
ZCwgYXMNCj4+IGl0IGlzIGluY2x1ZGVkIGluIHBhcmF2aXJ0X3R5cGVzLmggYWxyZWFkeS4N
Cj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+
DQo+IA0KPiBJIGp1c3Qgd2FudGVkIHRvIG1ha2UgYSBub3RlIHRoYXQgdGhlIHBhcnQgb2Yg
dGhpcyBwYXRjaCB0aGF0J3Mgbm90DQo+IHB1cmVseSBjbGVhbnVwIGlzIHRoZSBhZGRpdGlv
biBvZiB0aGUgYWxpZ25tZW50IChfX0FMSUdOX1NUUikgdG8NCj4gX19yYXdfY2FsbGVlX3Nh
dmVfX19rdm1fdmNwdV9pc19wcmVlbXB0ZWQoKSwgX3BhcmF2aXJ0X25vcCgpIGFuZA0KPiBw
YXJhdmlydF9yZXQwKCkuIE1heWJlIHRoYXQncyB3b3J0aCBjYWxsaW5nIG91dCBpbiB0aGUg
Y29tbWl0IG1lc3NhZ2U/DQoNCkkgY2FuIGRvIHRoYXQuDQoNCj4gDQo+IFJldmlld2VkLWJ5
OiBTcml2YXRzYSBTLiBCaGF0IChWTXdhcmUpIDxzcml2YXRzYUBjc2FpbC5taXQuZWR1Pg0K
DQpUaGFua3MsDQoNCg0KSnVlcmdlbg0KDQo=
--------------jfhg0fn1IeRuyYfJsUea8HcA
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------jfhg0fn1IeRuyYfJsUea8HcA--

--------------X9YsFQnwdhkVRWzIiGnpsMmR--

--------------shouL010u3Mr0e0Q9VFIBCgV
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmNrVREFAwAAAAAACgkQsN6d1ii/Ey9U
Rgf/Zq+VgQpFg5PaBWO2ax7z0+KDg190mK5cblc3e9kxb5St4UYyiqEpwDNLoxKDgf+GV1u1+2Ve
z8dfHbgpAOqF+/uElP5xGW9s4j+yJR6KlmQvU/6svODqTAKHx1GAokKvJ4sPJix57X6sBayhZc5d
5k/ilfPVEtUscAZgbHPwXfeRINkYS/ClnvMM3n/S/bIXK2hTGTUzpZnissnQY/QiZ1JXNACOk3RO
TDHYyNxzHM77v5MCe06J2tq5/d7h0gQbFokqnHb7u/CSe68kk53NWeuDM0bN9NjJEwg4tg0JZEla
ZQG8wbWFCWb1bHCOQQ0yss3bM46+TyHhu/VcB96aMA==
=hZOn
-----END PGP SIGNATURE-----

--------------shouL010u3Mr0e0Q9VFIBCgV--
