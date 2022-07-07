Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8E656A594
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 16:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbiGGOg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 10:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235801AbiGGOgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 10:36:19 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C937330F78;
        Thu,  7 Jul 2022 07:36:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 864521FF23;
        Thu,  7 Jul 2022 14:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657204577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cWjrqcATzVV6eVe/rdJaf9LDLbrld0qRdei0I3FGkZg=;
        b=STxmJggoMW+nOY3BkzmSLvaZ8q0hAfh27PR6qoZ7+qUhc/BvuhszQfvW0QCan1rD80ByWe
        v0dkC484V+/Ed4OrPQ1ZDylK3vc80WnujoEp400XDI73wMGQNRhXvuQaNMTJ8L9+aOEifK
        qOP0HqXX3WUZMUK2x0WxopRfATNE2VA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 187BD13461;
        Thu,  7 Jul 2022 14:36:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KlCLBGHvxmLbNAAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 07 Jul 2022 14:36:17 +0000
Message-ID: <d262b7dd-d7eb-0251-e3c7-0bb0a626749d@suse.com>
Date:   Thu, 7 Jul 2022 16:36:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v5 12/22] x86/virt/tdx: Convert all memory regions in
 memblock to TDX memory
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1655894131.git.kai.huang@intel.com>
 <8288396be7fedd10521a28531e138579594d757a.1655894131.git.kai.huang@intel.com>
 <20d63398-928f-0c6f-47ec-8e225c049ad8@intel.com>
 <76d7604ff21b26252733165478d5c54035d84d98.camel@intel.com>
 <880f3991-09e5-2f96-d5ba-213cff05c458@intel.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <880f3991-09e5-2f96-d5ba-213cff05c458@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------F3C1K8B7yXSI9xP782UHBXAx"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------F3C1K8B7yXSI9xP782UHBXAx
Content-Type: multipart/mixed; boundary="------------6vbT3KQ0DMdFpqJBtkiCsLIO";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Dave Hansen <dave.hansen@intel.com>, Kai Huang <kai.huang@intel.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
 tony.luck@intel.com, rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
 dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
 kirill.shutemov@linux.intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 isaku.yamahata@intel.com
Message-ID: <d262b7dd-d7eb-0251-e3c7-0bb0a626749d@suse.com>
Subject: Re: [PATCH v5 12/22] x86/virt/tdx: Convert all memory regions in
 memblock to TDX memory
References: <cover.1655894131.git.kai.huang@intel.com>
 <8288396be7fedd10521a28531e138579594d757a.1655894131.git.kai.huang@intel.com>
 <20d63398-928f-0c6f-47ec-8e225c049ad8@intel.com>
 <76d7604ff21b26252733165478d5c54035d84d98.camel@intel.com>
 <880f3991-09e5-2f96-d5ba-213cff05c458@intel.com>
In-Reply-To: <880f3991-09e5-2f96-d5ba-213cff05c458@intel.com>

--------------6vbT3KQ0DMdFpqJBtkiCsLIO
Content-Type: multipart/mixed; boundary="------------1HLgyr0hiDN7IbIizjL28Rim"

--------------1HLgyr0hiDN7IbIizjL28Rim
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDcuMDcuMjIgMTY6MjYsIERhdmUgSGFuc2VuIHdyb3RlOg0KPiBPbiA2LzI2LzIyIDIz
OjE2LCBLYWkgSHVhbmcgd3JvdGU6DQo+PiBPbiBGcmksIDIwMjItMDYtMjQgYXQgMTI6NDAg
LTA3MDAsIERhdmUgSGFuc2VuIHdyb3RlOg0KPj4+PiArLyoNCj4+Pj4gKyAqIFdhbGtzIG92
ZXIgYWxsIG1lbWJsb2NrIG1lbW9yeSByZWdpb25zIHRoYXQgYXJlIGludGVuZGVkIHRvIGJl
DQo+Pj4+ICsgKiBjb252ZXJ0ZWQgdG8gVERYIG1lbW9yeS4gIEVzc2VudGlhbGx5LCBpdCBp
cyBhbGwgbWVtYmxvY2sgbWVtb3J5DQo+Pj4+ICsgKiByZWdpb25zIGV4Y2x1ZGluZyB0aGUg
bG93IG1lbW9yeSBiZWxvdyAxTUIuDQo+Pj4+ICsgKg0KPj4+PiArICogVGhpcyBpcyBiZWNh
dXNlIG9uIHNvbWUgVERYIHBsYXRmb3JtcyB0aGUgbG93IG1lbW9yeSBiZWxvdyAxTUIgaXMN
Cj4+Pj4gKyAqIG5vdCBpbmNsdWRlZCBpbiBDTVJzLiAgRXhjbHVkaW5nIHRoZSBsb3cgMU1C
IGNhbiBzdGlsbCBndWFyYW50ZWUNCj4+Pj4gKyAqIHRoYXQgdGhlIHBhZ2VzIG1hbmFnZWQg
YnkgdGhlIHBhZ2UgYWxsb2NhdG9yIGFyZSBhbHdheXMgVERYIG1lbW9yeSwNCj4+Pj4gKyAq
IGFzIHRoZSBsb3cgMU1CIGlzIHJlc2VydmVkIGR1cmluZyBrZXJuZWwgYm9vdCBhbmQgd29u
J3QgZW5kIHVwIHRvDQo+Pj4+ICsgKiB0aGUgWk9ORV9ETUEgKHNlZSByZXNlcnZlX3JlYWxf
bW9kZSgpKS4NCj4+Pj4gKyAqLw0KPj4+PiArI2RlZmluZSBtZW1ibG9ja19mb3JfZWFjaF90
ZHhfbWVtX3Bmbl9yYW5nZShpLCBwX3N0YXJ0LCBwX2VuZCwgcF9uaWQpCVwNCj4+Pj4gKwlm
b3JfZWFjaF9tZW1fcGZuX3JhbmdlKGksIE1BWF9OVU1OT0RFUywgcF9zdGFydCwgcF9lbmQs
IHBfbmlkKQlcDQo+Pj4+ICsJCWlmICghcGZuX3JhbmdlX3NraXBfbG93bWVtKHBfc3RhcnQs
IHBfZW5kKSkNCj4+Pg0KPj4+IExldCdzIHN1bW1hcml6ZSB3aGVyZSB3ZSBhcmUgYXQgdGhp
cyBwb2ludDoNCj4+Pg0KPj4+IDEuIEFsbCBSQU0gaXMgZGVzY3JpYmVkIGluIG1lbWJsb2Nr
cw0KPj4+IDIuIFNvbWUgbWVtYmxvY2tzIGFyZSByZXNlcnZlZCBhbmQgc29tZSBhcmUgZnJl
ZQ0KPj4+IDMuIFRoZSBsb3dlciAxTUIgaXMgbWFya2VkIHJlc2VydmVkDQo+Pj4gNC4gZm9y
X2VhY2hfbWVtX3Bmbl9yYW5nZSgpIHdhbGtzIGFsbCByZXNlcnZlZCBhbmQgZnJlZSBtZW1i
bG9ja3MsIHNvIHdlDQo+Pj4gICAgIGhhdmUgdG8gZXhjbHVkZSB0aGUgbG93ZXIgMU1CIGFz
IGEgc3BlY2lhbCBjYXNlLg0KPj4+DQo+Pj4gVGhhdCBzZWVtcyBzdXBlcmZpY2lhbGx5IHJh
dGhlciByaWRpY3Vsb3VzLiAgU2hvdWxkbid0IHdlIGp1c3QgcGljayBhDQo+Pj4gbWVtYmxv
Y2sgaXRlcmF0b3IgdGhhdCBza2lwcyB0aGUgMU1CPyAgU3VyZWx5IHRoZXJlIGlzIHN1Y2gg
YSB0aGluZy4NCj4+DQo+PiBQZXJoYXBzIHlvdSBhcmUgc3VnZ2VzdGluZyB3ZSBzaG91bGQg
YWx3YXlzIGxvb3AgdGhlIF9mcmVlXyByYW5nZXMgc28gd2UgZG9uJ3QNCj4+IG5lZWQgdG8g
Y2FyZSBhYm91dCB0aGUgZmlyc3QgMU1CIHdoaWNoIGlzIHJlc2VydmVkPw0KPj4NCj4+IFRo
ZSBwcm9ibGVtIGlzIHNvbWUgcmVzZXJ2ZWQgbWVtb3J5IHJlZ2lvbnMgYXJlIGFjdHVhbGx5
IGxhdGVyIGZyZWVkIHRvIHRoZSBwYWdlDQo+PiBhbGxvY2F0b3IsIGZvciBleGFtcGxlLCBp
bml0cmQuICBTbyB0byBjb3ZlciBhbGwgdGhvc2UgJ2xhdGUtZnJlZWQtcmVzZXJ2ZWQtDQo+
PiByZWdpb25zJywgSSB1c2VkIGZvcl9lYWNoX21lbV9wZm5fcmFuZ2UoKSwgaW5zdGVhZCBv
ZiBmb3JfZWFjaF9mcmVlX21lbV9yYW5nZSgpLg0KPiANCj4gV2h5IG5vdCBqdXN0IGVudGly
ZWx5IHJlbW92ZSB0aGUgbG93ZXIgMU1CIGZyb20gdGhlIG1lbWJsb2NrIHN0cnVjdHVyZQ0K
PiBvbiBURFggc3lzdGVtcz8gIERvIHNvbWV0aGluZyBlcXVpdmFsZW50IHRvIGFkZGluZyB0
aGlzIG9uIHRoZSBrZXJuZWwNCj4gY29tbWFuZCBsaW5lOg0KPiANCj4gCW1lbW1hcD0xTSQw
eDANCj4gDQo+PiBCdHcsIEkgZG8gaGF2ZSBhIGNoZWNrcGF0Y2ggd2FybmluZyBhcm91bmQg
dGhpcyBjb2RlOg0KPj4NCj4+IEVSUk9SOiBNYWNyb3Mgd2l0aCBjb21wbGV4IHZhbHVlcyBz
aG91bGQgYmUgZW5jbG9zZWQgaW4gcGFyZW50aGVzZXMNCj4+ICMxMDk6IEZJTEU6IGFyY2gv
eDg2L3ZpcnQvdm14L3RkeC90ZHguYzozNzc6DQo+PiArI2RlZmluZSBtZW1ibG9ja19mb3Jf
ZWFjaF90ZHhfbWVtX3Bmbl9yYW5nZShpLCBwX3N0YXJ0LCBwX2VuZCwgcF9uaWQpCVwNCj4+
ICsJZm9yX2VhY2hfbWVtX3Bmbl9yYW5nZShpLCBNQVhfTlVNTk9ERVMsIHBfc3RhcnQsIHBf
ZW5kLCBwX25pZCkJXA0KPj4gKwkJaWYgKCFwZm5fcmFuZ2Vfc2tpcF9sb3dtZW0ocF9zdGFy
dCwgcF9lbmQpKQ0KPj4NCj4+IEJ1dCBpdCBsb29rcyBsaWtlIGEgZmFsc2UgcG9zaXRpdmUg
dG8gbWUuDQo+IA0KPiBJIHRoaW5rIGl0IGRvZXNuJ3QgbGlrZSB0aGUgaWYoKS4NCg0KSSB0
aGluayBpdCBpcyByaWdodC4NCg0KQ29uc2lkZXI6DQoNCmlmIChhKQ0KICAgICBtZW1ibG9j
a19mb3JfZWFjaF90ZHhfbWVtX3Bmbl9yYW5nZSguLi4pDQogICAgICAgICBmdW5jKCk7DQpl
bHNlDQogICAgIG90aGVyX2Z1bmMoKTsNCg0KDQpKdWVyZ2VuDQo=
--------------1HLgyr0hiDN7IbIizjL28Rim
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

--------------1HLgyr0hiDN7IbIizjL28Rim--

--------------6vbT3KQ0DMdFpqJBtkiCsLIO--

--------------F3C1K8B7yXSI9xP782UHBXAx
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmLG72AFAwAAAAAACgkQsN6d1ii/Ey+9
qwf6Am3O65pQZqby5HsdE4B92FYp0KPBJ4u31LgS1BwNR5momE7y5zjNXNde+Krqgij4n3tC2tso
BsnzvrnhJl1S08LM2+HBm+0eIqN/60DY+htnTOqmolJOhX1+N8zWgaLQvtPVn3rvb2FvJZib5hOg
9p7VlbqNSjO8qeU13C2E19mzvHn2XQdwpxChg2XyAuG9iH/Vgk3pJrJYrOS0A8QeieMFnvVLEW8G
u3W0+i6BmHmOyt0mrFAjVz2jG1zMaUvo5boxYyQa4m/oxpFKJioFwOWdsg+jQY/MFOv5d8vZr+OC
ysx83fTTi5EjKeUx8FSIKl8Iug1JrW+YP1rGLGbHFw==
=3RoI
-----END PGP SIGNATURE-----

--------------F3C1K8B7yXSI9xP782UHBXAx--
