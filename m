Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC97F7A1560
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 07:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbjIOF1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 01:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjIOF1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 01:27:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDE52703;
        Thu, 14 Sep 2023 22:27:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 983C01F38C;
        Fri, 15 Sep 2023 05:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694755648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=QU8myV3ur4X5421f1/iCCeH3dClVFgzG1eLkkZQpaSE=;
        b=NtKM/H7jhZhi6WVeOgIIjPD3lWAFrjAaJmVRY1uX3CKXpNBPqle4T/CnIYXShURolHHb6P
        p+oO7hLblgc9P9h0no2Cwk8ea9Gl4cXJ5YrfpyYrWVLekSpRAD+FCGr/2gVGFeCmjCv5aj
        hx/RjNMAZ6jQwJZp+d9t0XSaoGde3vA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 053D313479;
        Fri, 15 Sep 2023 05:27:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id m4dhOz/rA2VrYwAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 15 Sep 2023 05:27:27 +0000
Message-ID: <76fe3edb-cc84-46f1-80f6-00ea36fbad16@suse.com>
Date:   Fri, 15 Sep 2023 07:27:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 08/38] x86/cpufeatures: Add the cpu feature bit for
 FRED
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, andrew.cooper3@citrix.com,
        Jan Beulich <jbeulich@suse.com>
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, peterz@infradead.org,
        ravi.v.shankar@intel.com, mhiramat@kernel.org,
        jiangshanlai@gmail.com, Xin Li <xin3.li@intel.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-9-xin3.li@intel.com>
 <d98a362d-d806-4458-9473-be5bea254db7@suse.com>
 <77ca8680-02e2-cdaa-a919-61058e2d5245@suse.com>
 <7d907488-d626-0801-3d4b-af42d00a5537@citrix.com> <87o7i41bya.ffs@tglx>
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
In-Reply-To: <87o7i41bya.ffs@tglx>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0DJc54CgcwM0KkGine9Y86ek"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0DJc54CgcwM0KkGine9Y86ek
Content-Type: multipart/mixed; boundary="------------FxBkvOSsZsO036jILYJ06LWo";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Thomas Gleixner <tglx@linutronix.de>, andrew.cooper3@citrix.com,
 Jan Beulich <jbeulich@suse.com>
Cc: mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, luto@kernel.org, pbonzini@redhat.com,
 seanjc@google.com, peterz@infradead.org, ravi.v.shankar@intel.com,
 mhiramat@kernel.org, jiangshanlai@gmail.com, Xin Li <xin3.li@intel.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
 kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Message-ID: <76fe3edb-cc84-46f1-80f6-00ea36fbad16@suse.com>
Subject: Re: [PATCH v10 08/38] x86/cpufeatures: Add the cpu feature bit for
 FRED
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-9-xin3.li@intel.com>
 <d98a362d-d806-4458-9473-be5bea254db7@suse.com>
 <77ca8680-02e2-cdaa-a919-61058e2d5245@suse.com>
 <7d907488-d626-0801-3d4b-af42d00a5537@citrix.com> <87o7i41bya.ffs@tglx>
In-Reply-To: <87o7i41bya.ffs@tglx>

--------------FxBkvOSsZsO036jILYJ06LWo
Content-Type: multipart/mixed; boundary="------------FKBb0HfIKq5W00Hh1Q7xjNPA"

--------------FKBb0HfIKq5W00Hh1Q7xjNPA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTUuMDkuMjMgMDM6MDcsIFRob21hcyBHbGVpeG5lciB3cm90ZToNCj4gT24gVGh1LCBT
ZXAgMTQgMjAyMyBhdCAxNDoxNSwgYW5kcmV3IHdyb3RlOg0KPj4gUFYgZ3Vlc3RzIGFyZSBu
ZXZlciBnb2luZyB0byBzZWUgRlJFRCAob3IgTEtHUyBmb3IgdGhhdCBtYXR0ZXIpIGJlY2F1
c2UNCj4+IGl0IGFkdmVydGlzZXMgdG9vIG11Y2ggc3R1ZmYgd2hpY2ggc2ltcGx5IHRyYXBz
IGJlY2F1c2UgdGhlIGtlcm5lbCBpcyBpbg0KPj4gQ1BMMy4NCj4+DQo+PiBUaGF0IHNhaWQs
IHRoZSA2NGJpdCBQViBBQkkgaXMgYSB3aG9sZSBsb3QgY2xvc2VyIHRvIEZSRUQgdGhhbiBp
dCBpcyB0bw0KPj4gSURUIGRlbGl2ZXJ5LsKgIChBbG1vc3QgYXMgaWYgd2UgZGVjaWRlZCAx
NSB5ZWFycyBhZ28gdGhhdCBnaXZpbmcgdGhlIFBWDQo+PiBndWVzdCBrZXJuZWwgYSBnb29k
IHN0YWNrIGFuZCBHU2Jhc2Ugd2FzIHRoZSByaWdodCB0aGluZyB0byBkby4uLikNCj4gDQo+
IE5vIGFyZ3VtZW50IGFib3V0IHRoYXQuDQo+IA0KPj4gSW4gc29tZSBjb3Bpb3VzIGZyZWUg
dGltZSwgSSB0aGluayB3ZSBvdWdodCB0byBwcm92aWRlIGENCj4+IG1pbm9ybHktcGFyYXZp
cnQgRlJFRCB0byBQViBndWVzdHMgYmVjYXVzZSB0aGVyZSBhcmUgc3RpbGwgc29tZQ0KPj4g
aW1wcm92ZW1lbnRzIGF2YWlsYWJsZSBhcyBsb3cgaGFuZ2luZyBmcnVpdC4NCj4+DQo+PiBN
eSBwbGFuIHdhcyB0byBoYXZlIGEgUFYgaHlwZXJ2aXNvciBsZWFmIGFkdmVydGlzaW5nIHBh
cmF2aXJ0IHZlcnNpb25zDQo+PiBvZiBoYXJkd2FyZSBmZWF0dXJlcywgc28gYSBndWVzdCBj
b3VsZCBzZWUgIkkgZG9uJ3QgaGF2ZSBhcmNoaXRlY3R1cmFsDQo+PiBGUkVELCBidXQgSSBk
byBoYXZlIHBhcmF2aXJ0LUZSRUQgd2hpY2ggaXMgYXMgc2ltaWxhciBhcyB3ZSBjYW4NCj4+
IHJlYXNvbmFibHkgbWFrZSBpdCIuwqAgVGhlIHNhbWUgZ29lcyBmb3IgYSB3aG9sZSBidW5j
aCBvZiBvdGhlciBmZWF0dXJlcy4NCj4gDQo+ICpHUk9BTioNCj4gDQo+IEkgdG9sZCB5b3Ug
YmVmb3JlIHRoYXQgd2Ugd2FudCBsZXNzIHBhcmF2aXJ0IG5vbnNlbnNlIGFuZCBub3QgbW9y
ZS4NCg0KSSBhZ3JlZS4NCg0KV2Ugd2lsbCBzdGlsbCBoYXZlIHRvIHN1cHBvcnQgdGhlIFBW
IHN0dWZmIGZvciBub24tRlJFRCBoeXBlcnZpc29ycyBldmVuIHdpdGgNCnB2LUZSRUQgYmVp
bmcgYXZhaWxhYmxlIG9uIG5ldyBYZW4uIFNvIGFkZGluZyBwdi1GUkVEIHdvdWxkIGp1c3Qg
YWRkIG1vcmUgUFYNCmludGVyZmFjZXMgd2l0aG91dCB0aGUgYWJpbGl0eSB0byByZW1vdmUg
b2xkIHN0dWZmLg0KDQoNCkp1ZXJnZW4NCg0K
--------------FKBb0HfIKq5W00Hh1Q7xjNPA
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------FKBb0HfIKq5W00Hh1Q7xjNPA--

--------------FxBkvOSsZsO036jILYJ06LWo--

--------------0DJc54CgcwM0KkGine9Y86ek
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmUD6z8FAwAAAAAACgkQsN6d1ii/Ey9P
4gf/aBMi3KQPER3qnsza7bJcPa30yR8O4Wf7AA5RDD14BujhuYLFNBNKD79hG/g36bQXKFhJrB+M
Q4VMVlTDJUjk1kiCriaIUsP60e9f7a7jrnqjVyts6qJs4ykLfNbY9RALxJ29UTIS77HB/524y9U/
LLFQbDMI9/wMcx7x8IttNv8vTwHIaFdAqL8ThInV47Q6U2w1fJ+EBEQbGQkmKR7yE7R5HuXsLPgm
xNofJdtZFYteoGDwQ2wBdk1EwcrSVahKJ5AED175u96yZkl6+OclIFvUdT3CViu+8U9BzxwmcZbE
NUFYACRcGmot95W4xgjmdbd5HpZ8yqLhc4jLfVOm7A==
=E+ek
-----END PGP SIGNATURE-----

--------------0DJc54CgcwM0KkGine9Y86ek--
