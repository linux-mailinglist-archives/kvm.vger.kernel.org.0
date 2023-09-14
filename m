Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F7079FB84
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 08:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbjINGDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 02:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjINGDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 02:03:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF98E3;
        Wed, 13 Sep 2023 23:03:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 324B81F459;
        Thu, 14 Sep 2023 06:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694671411; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=AbPXKEnFzRuQTCi8FnYdSafbWrbCEp1kerREXOMqMZ4=;
        b=pVF5ViAMWMI/oM+FwU4CtVVRvr2OTOWwH9nCt9rmCUBwxeEjn0+FYgB/PBrYdXtDaVuqfb
        tRItoAldZlnJEZx5qRmIrXr5cAOn2fTp7cLqT7cGxW0y6LgyopQ6tsKDHvWmzXvU69N2qY
        7Shgd7++YNkbFF6+qPqogFNO4TEOeF8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 95A9A13580;
        Thu, 14 Sep 2023 06:03:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mMkrIjKiAmUEWwAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 14 Sep 2023 06:03:30 +0000
Message-ID: <d98a362d-d806-4458-9473-be5bea254db7@suse.com>
Date:   Thu, 14 Sep 2023 08:03:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 08/38] x86/cpufeatures: Add the cpu feature bit for
 FRED
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
 <20230914044805.301390-9-xin3.li@intel.com>
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
In-Reply-To: <20230914044805.301390-9-xin3.li@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------H14CmzcS2010IVl64ThBu1rA"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------H14CmzcS2010IVl64ThBu1rA
Content-Type: multipart/mixed; boundary="------------33sQNft0m0M1LVqEqR9iUEtK";
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
Message-ID: <d98a362d-d806-4458-9473-be5bea254db7@suse.com>
Subject: Re: [PATCH v10 08/38] x86/cpufeatures: Add the cpu feature bit for
 FRED
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-9-xin3.li@intel.com>
In-Reply-To: <20230914044805.301390-9-xin3.li@intel.com>

--------------33sQNft0m0M1LVqEqR9iUEtK
Content-Type: multipart/mixed; boundary="------------NS2vFGS00A331mW7cQGgqgWq"

--------------NS2vFGS00A331mW7cQGgqgWq
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTQuMDkuMjMgMDY6NDcsIFhpbiBMaSB3cm90ZToNCj4gRnJvbTogIkguIFBldGVyIEFu
dmluIChJbnRlbCkiIDxocGFAenl0b3IuY29tPg0KPiANCj4gQW55IEZSRUQgQ1BVIHdpbGwg
YWx3YXlzIGhhdmUgdGhlIGZvbGxvd2luZyBmZWF0dXJlcyBhcyBpdHMgYmFzZWxpbmU6DQo+
ICAgIDEpIExLR1MsIGxvYWQgYXR0cmlidXRlcyBvZiB0aGUgR1Mgc2VnbWVudCBidXQgdGhl
IGJhc2UgYWRkcmVzcyBpbnRvDQo+ICAgICAgIHRoZSBJQTMyX0tFUk5FTF9HU19CQVNFIE1T
UiBpbnN0ZWFkIG9mIHRoZSBHUyBzZWdtZW504oCZcyBkZXNjcmlwdG9yDQo+ICAgICAgIGNh
Y2hlLg0KPiAgICAyKSBXUk1TUk5TLCBub24tc2VyaWFsaXppbmcgV1JNU1IgZm9yIGZhc3Rl
ciBNU1Igd3JpdGVzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSC4gUGV0ZXIgQW52aW4gKElu
dGVsKSA8aHBhQHp5dG9yLmNvbT4NCj4gVGVzdGVkLWJ5OiBTaGFuIEthbmcgPHNoYW4ua2Fu
Z0BpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFhpbiBMaSA8eGluMy5saUBpbnRlbC5j
b20+DQoNCkluIG9yZGVyIHRvIGF2b2lkIGhhdmluZyB0byBhZGQgcGFyYXZpcnQgc3VwcG9y
dCBmb3IgRlJFRCBJIHRoaW5rDQp4ZW5faW5pdF9jYXBhYmlsaXRpZXMoKSBzaG91bGQgZ2Fp
bjoNCg0KKyAgICBzZXR1cF9jbGVhcl9jcHVfY2FwKFg4Nl9GRUFUVVJFX0ZSRUQpOw0KDQoN
Ckp1ZXJnZW4NCg0KPiAtLS0NCj4gICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9jcHVmZWF0dXJl
cy5oICAgICAgIHwgMSArDQo+ICAgYXJjaC94ODYva2VybmVsL2NwdS9jcHVpZC1kZXBzLmMg
ICAgICAgICB8IDIgKysNCj4gICB0b29scy9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9jcHVmZWF0
dXJlcy5oIHwgMSArDQo+ICAgMyBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykNCj4g
DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9jcHVmZWF0dXJlcy5oIGIv
YXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZXMuaA0KPiBpbmRleCAzMzA4NzZkMzRi
NjguLjU3YWU5M2RjMWU1MiAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20v
Y3B1ZmVhdHVyZXMuaA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9jcHVmZWF0dXJl
cy5oDQo+IEBAIC0zMjEsNiArMzIxLDcgQEANCj4gICAjZGVmaW5lIFg4Nl9GRUFUVVJFX0Za
Uk0JCSgxMiozMisxMCkgLyogIiIgRmFzdCB6ZXJvLWxlbmd0aCBSRVAgTU9WU0IgKi8NCj4g
ICAjZGVmaW5lIFg4Nl9GRUFUVVJFX0ZTUlMJCSgxMiozMisxMSkgLyogIiIgRmFzdCBzaG9y
dCBSRVAgU1RPU0IgKi8NCj4gICAjZGVmaW5lIFg4Nl9GRUFUVVJFX0ZTUkMJCSgxMiozMisx
MikgLyogIiIgRmFzdCBzaG9ydCBSRVAge0NNUFNCLFNDQVNCfSAqLw0KPiArI2RlZmluZSBY
ODZfRkVBVFVSRV9GUkVECQkoMTIqMzIrMTcpIC8qIEZsZXhpYmxlIFJldHVybiBhbmQgRXZl
bnQgRGVsaXZlcnkgKi8NCj4gICAjZGVmaW5lIFg4Nl9GRUFUVVJFX0xLR1MJCSgxMiozMisx
OCkgLyogIiIgTG9hZCAia2VybmVsIiAodXNlcnNwYWNlKSBHUyAqLw0KPiAgICNkZWZpbmUg
WDg2X0ZFQVRVUkVfV1JNU1JOUwkJKDEyKjMyKzE5KSAvKiAiIiBOb24tU2VyaWFsaXppbmcg
V3JpdGUgdG8gTW9kZWwgU3BlY2lmaWMgUmVnaXN0ZXIgaW5zdHJ1Y3Rpb24gKi8NCj4gICAj
ZGVmaW5lIFg4Nl9GRUFUVVJFX0FNWF9GUDE2CQkoMTIqMzIrMjEpIC8qICIiIEFNWCBmcDE2
IFN1cHBvcnQgKi8NCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvY3B1aWQt
ZGVwcy5jIGIvYXJjaC94ODYva2VybmVsL2NwdS9jcHVpZC1kZXBzLmMNCj4gaW5kZXggZTQ2
MmMxZDM4MDBhLi5iNzE3NDIwOWQ4NTUgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2tlcm5l
bC9jcHUvY3B1aWQtZGVwcy5jDQo+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvY3B1aWQt
ZGVwcy5jDQo+IEBAIC04Miw2ICs4Miw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgY3B1aWRf
ZGVwIGNwdWlkX2RlcHNbXSA9IHsNCj4gICAJeyBYODZfRkVBVFVSRV9YRkQsCQkJWDg2X0ZF
QVRVUkVfWEdFVEJWMSAgIH0sDQo+ICAgCXsgWDg2X0ZFQVRVUkVfQU1YX1RJTEUsCQkJWDg2
X0ZFQVRVUkVfWEZEICAgICAgIH0sDQo+ICAgCXsgWDg2X0ZFQVRVUkVfU0hTVEssCQkJWDg2
X0ZFQVRVUkVfWFNBVkVTICAgIH0sDQo+ICsJeyBYODZfRkVBVFVSRV9GUkVELAkJCVg4Nl9G
RUFUVVJFX0xLR1MgICAgICB9LA0KPiArCXsgWDg2X0ZFQVRVUkVfRlJFRCwJCQlYODZfRkVB
VFVSRV9XUk1TUk5TICAgfSwNCj4gICAJe30NCj4gICB9Ow0KPiAgIA0KPiBkaWZmIC0tZ2l0
IGEvdG9vbHMvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZXMuaCBiL3Rvb2xzL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmVzLmgNCj4gaW5kZXggMWI5ZDg2YmE1YmMy
Li4xOGJhYjc5ODdkN2YgMTAwNjQ0DQo+IC0tLSBhL3Rvb2xzL2FyY2gveDg2L2luY2x1ZGUv
YXNtL2NwdWZlYXR1cmVzLmgNCj4gKysrIGIvdG9vbHMvYXJjaC94ODYvaW5jbHVkZS9hc20v
Y3B1ZmVhdHVyZXMuaA0KPiBAQCAtMzE3LDYgKzMxNyw3IEBADQo+ICAgI2RlZmluZSBYODZf
RkVBVFVSRV9GWlJNCQkoMTIqMzIrMTApIC8qICIiIEZhc3QgemVyby1sZW5ndGggUkVQIE1P
VlNCICovDQo+ICAgI2RlZmluZSBYODZfRkVBVFVSRV9GU1JTCQkoMTIqMzIrMTEpIC8qICIi
IEZhc3Qgc2hvcnQgUkVQIFNUT1NCICovDQo+ICAgI2RlZmluZSBYODZfRkVBVFVSRV9GU1JD
CQkoMTIqMzIrMTIpIC8qICIiIEZhc3Qgc2hvcnQgUkVQIHtDTVBTQixTQ0FTQn0gKi8NCj4g
KyNkZWZpbmUgWDg2X0ZFQVRVUkVfRlJFRAkJKDEyKjMyKzE3KSAvKiBGbGV4aWJsZSBSZXR1
cm4gYW5kIEV2ZW50IERlbGl2ZXJ5ICovDQo+ICAgI2RlZmluZSBYODZfRkVBVFVSRV9MS0dT
CQkoMTIqMzIrMTgpIC8qICIiIExvYWQgImtlcm5lbCIgKHVzZXJzcGFjZSkgR1MgKi8NCj4g
ICAjZGVmaW5lIFg4Nl9GRUFUVVJFX1dSTVNSTlMJCSgxMiozMisxOSkgLyogIiIgTm9uLVNl
cmlhbGl6aW5nIFdyaXRlIHRvIE1vZGVsIFNwZWNpZmljIFJlZ2lzdGVyIGluc3RydWN0aW9u
ICovDQo+ICAgI2RlZmluZSBYODZfRkVBVFVSRV9BTVhfRlAxNgkJKDEyKjMyKzIxKSAvKiAi
IiBBTVggZnAxNiBTdXBwb3J0ICovDQoNCg==
--------------NS2vFGS00A331mW7cQGgqgWq
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjri
oyspZKOBycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2
kaV2KL9650I1SJvedYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i
1TXkH09XSSI8mEQ/ouNcMvIJNwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/B
BLUVbDa4+gmzDC9ezlZkTZG2t14zWPvxXP3FAp2pkW0xqG7/377qptDmrk42GlSK
N4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEBAAHNHEp1ZXJnZW4gR3Jvc3Mg
PGpnQHBmdXBmLm5ldD7CwHkEEwECACMFAlOMcBYCGwMHCwkIBwMCAQYVCAIJCgsE
FgIDAQIeAQIXgAAKCRCw3p3WKL8TL0KdB/93FcIZ3GCNwFU0u3EjNbNjmXBKDY4F
UGNQH2lvWAUy+dnyThpwdtF/jQ6j9RwE8VP0+NXcYpGJDWlNb9/JmYqLiX2Q3Tye
vpB0CA3dbBQp0OW0fgCetToGIQrg0MbD1C/sEOv8Mr4NAfbauXjZlvTj30H2jO0u
+6WGM6nHwbh2l5O8ZiHkH32iaSTfN7Eu5RnNVUJbvoPHZ8SlM4KWm8rG+lIkGurq
qu5gu8q8ZMKdsdGC4bBxdQKDKHEFExLJK/nRPFmAuGlId1E3fe10v5QL+qHI3EIP
tyfE7i9Hz6rVwi7lWKgh7pe0ZvatAudZ+JNIlBKptb64FaiIOAWDCx1SzR9KdWVy
Z2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+wsB5BBMBAgAjBQJTjHCvAhsDBwsJ
CAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey/HmQf/RtI7kv5A2PS4
RF7HoZhPVPogNVbC4YA6lW7DrWf0teC0RR3MzXfy6pJ+7KLgkqMlrAbN/8Dvjoz7
8X+5vhH/rDLa9BuZQlhFmvcGtCF8eR0T1v0nC/nuAFVGy+67q2DH8As3KPu0344T
BDpAvr2uYM4tSqxK4DURx5INz4ZZ0WNFHcqsfvlGJALDeE0LhITTd9jLzdDad1pQ
SToCnLl6SBJZjDOX9QQcyUigZFtCXFst4dlsvddrxyqT1f17+2cFSdu7+ynLmXBK
7abQ3rwJY8SbRO2iRulogc5vr/RLMMlscDAiDkaFQWLoqHHOdfO9rURssHNN8WkM
nQfvUewRz80hSnVlcmdlbiBHcm9zcyA8amdyb3NzQG5vdmVsbC5jb20+wsB5BBMB
AgAjBQJTjHDXAhsDBwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/
Ey8PUQf/ehmgCI9jB9hlgexLvgOtf7PJnFOXgMLdBQgBlVPO3/D9R8LtF9DBAFPN
hlrsfIG/SqICoRCqUcJ96Pn3P7UUinFG/I0ECGF4EvTE1jnDkfJZr6jrbjgyoZHi
w/4BNwSTL9rWASyLgqlA8u1mf+c2yUwcGhgkRAd1gOwungxcwzwqgljf0N51N5Jf
VRHRtyfwq/ge+YEkDGcTU6Y0sPOuj4Dyfm8fJzdfHNQsWq3PnczLVELStJNdapwP
OoE+lotufe3AM2vAEYJ9rTz3Cki4JFUsgLkHFqGZarrPGi1eyQcXeluldO3m91NK
/1xMI3/+8jbO0tsn1tqSEUGIJi7ox80eSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1
c2UuZGU+wsB5BBMBAgAjBQJTjHDrAhsDBwsJCAcDAgEGFQgCCQoLBBYCAwECHgEC
F4AACgkQsN6d1ii/Ey+LhQf9GL45eU5vOowA2u5N3g3OZUEBmDHVVbqMtzwlmNC4
k9Kx39r5s2vcFl4tXqW7g9/ViXYuiDXb0RfUpZiIUW89siKrkzmQ5dM7wRqzgJpJ
wK8Bn2MIxAKArekWpiCKvBOB/Cc+3EXE78XdlxLyOi/NrmSGRIov0karw2RzMNOu
5D+jLRZQd1Sv27AR+IP3I8U4aqnhLpwhK7MEy9oCILlgZ1QZe49kpcumcZKORmzB
TNh30FVKK1EvmV2xAKDoaEOgQB4iFQLhJCdP1I5aSgM5IVFdn7v5YgEYuJYx37Io
N1EblHI//x/e2AaIHpzK5h88NEawQsaNRpNSrcfbFmAg987ATQRTjHAWAQgAyzH6
AOODMBjgfWE9VeCgsrwH3exNAU32gLq2xvjpWnHIs98ndPUDpnoxWQugJ6MpMncr
0xSwFmHEgnSEjK/PAjppgmyc57BwKII3sV4on+gDVFJR6Y8ZRwgnBC5mVM6JjQ5x
Dk8WRXljExRfUX9pNhdE5eBOZJrDRoLUmmjDtKzWaDhIg/+1Hzz93X4fCQkNVbVF
LELU9bMaLPBG/x5q4iYZ2k2ex6d47YE1ZFdMm6YBYMOljGkZKwYde5ldM9mo45mm
we0icXKLkpEdIXKTZeKDO+Hdv1aqFuAcccTg9RXDQjmwhC3yEmrmcfl0+rPghO0I
v3OOImwTEe4co3c1mwARAQABwsBfBBgBAgAJBQJTjHAWAhsMAAoJELDendYovxMv
Q/gH/1ha96vm4P/L+bQpJwrZ/dneZcmEwTbe8YFsw2V/Buv6Z4Mysln3nQK5ZadD
534CF7TDVft7fC4tU4PONxF5D+/tvgkPfDAfF77zy2AH1vJzQ1fOU8lYFpZXTXIH
b+559UqvIB8AdgR3SAJGHHt4RKA0F7f5ipYBBrC6cyXJyyoprT10EMvU8VGiwXvT
yJz3fjoYsdFzpWPlJEBRMedCot60g5dmbdrZ5DWClAr0yau47zpWj3enf1tLWaqc
suylWsviuGjKGw7KHQd3bxALOknAp4dN3QwBYCKuZ7AddY9yjynVaD5X7nF9nO5B
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------NS2vFGS00A331mW7cQGgqgWq--

--------------33sQNft0m0M1LVqEqR9iUEtK--

--------------H14CmzcS2010IVl64ThBu1rA
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmUCojIFAwAAAAAACgkQsN6d1ii/Ey+S
oggAjMQEUPqPvWOSM6qiYOAn9aPD2feF/Z/LlVmWkWj0b+fSbgGmFI7EMZlbjfs9XGBRnj7v8xXF
qx7h7xpi7sQ5cvY9/2VpQ6n3pxV8LHFa4TX+g+trEV/TSmye+hBTkh5UawIABFkhI5dkroDY8FmJ
Iq4IC78CksA/Sn+ZLjETJGLCeJ1S2/I34gF3N7Z5MBec2vGdD+4wE5Chi6EJqjBNlZNU+C/vHJSl
ON0q7GZDZO/JYpRC1SnutiunNWsxCpMGF5I5ntl9NgaZXrjjgAUZdbZk/g+GIliIuWgtW8uY2U02
0FVohdSohTonJ2CgyHavYvK9J7MF2B/dvFRDxNMfvg==
=9Ssk
-----END PGP SIGNATURE-----

--------------H14CmzcS2010IVl64ThBu1rA--
