Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54FF5B0822
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 17:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiIGPMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 11:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiIGPMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 11:12:00 -0400
Received: from littlepip.sumsal.cz (littlepip.sumsal.cz [IPv6:2a02:2b88:6:1f8a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1D34DF2F
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 08:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sumsal.cz;
        s=20140915; h=Content-Type:In-Reply-To:Subject:From:References:Cc:To:
        MIME-Version:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lwvPNekQHUTxrNisTtEU9cGSeBrujY7Uew4Kk1ixWXE=; b=KOM7aCFL+GoAG4irHf8WsiLLb2
        nxZviGDWlwR0XvmHb9dy7ZcudVyfuQ8nnnLUU/GNThZz8l+ClmjndztZCi2a6w5oDE7mra6hUxY4Y
        VXt/zTRoaVWi82x7mUMbaTQUplybmLvlq6/Jl4B3KlONK2wANWCBZod+QV1FiHBmCNxeKJtjRasRr
        Tn8HQqHa0Herz6fpA5by66xmY65tuOg+bThVU7cKQ4SqBY4DWOG1XNJAIdDQac23zI0nDUhHNyeuA
        YsDgDrYZ/6+gTUHZLD5dI/a+BYe8ALRhQi/OIk2m1x9mnwoMypcGwzOioFiHTCj8DBHIPAz6rXgqY
        IRpFKrlA==;
Received: from [176.74.150.102] (helo=[192.168.0.107])
        by littlepip.sumsal.cz with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <frantisek@sumsal.cz>)
        id 1oVwiZ-00CZm2-Tk; Wed, 07 Sep 2022 17:11:56 +0200
Message-ID: <a8fc728c-073c-2ff5-2436-40c84c3c62e1@sumsal.cz>
Date:   Wed, 7 Sep 2022 17:11:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <a861d348-b3fd-fd1d-2427-0a89ae139948@sumsal.cz>
 <Yxiz3giU/WEftPp6@google.com>
From:   =?UTF-8?B?RnJhbnRpxaFlayDFoHVtxaFhbA==?= <frantisek@sumsal.cz>
Subject: Re: BUG: soft lockup - CPU#0 stuck for 26s! with nested KVM on 5.19.x
In-Reply-To: <Yxiz3giU/WEftPp6@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------4QYIU5mY0l0YdJTh45k6Ka2P"
X-Spam-Score: -104.7 (---------------------------------------------------) #
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------4QYIU5mY0l0YdJTh45k6Ka2P
Content-Type: multipart/mixed; boundary="------------ZgivT5N8vq45pBZkpXb0yQGW";
 protected-headers="v1"
From: =?UTF-8?B?RnJhbnRpxaFlayDFoHVtxaFhbA==?= <frantisek@sumsal.cz>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Message-ID: <a8fc728c-073c-2ff5-2436-40c84c3c62e1@sumsal.cz>
Subject: Re: BUG: soft lockup - CPU#0 stuck for 26s! with nested KVM on 5.19.x
References: <a861d348-b3fd-fd1d-2427-0a89ae139948@sumsal.cz>
 <Yxiz3giU/WEftPp6@google.com>
In-Reply-To: <Yxiz3giU/WEftPp6@google.com>

--------------ZgivT5N8vq45pBZkpXb0yQGW
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOS83LzIyIDE3OjA4LCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiBPbiBXZWQs
IFNlcCAwNywgMjAyMiwgRnJhbnRpxaFlayDFoHVtxaFhbCB3cm90ZToNCj4+IEhlbGxvIQ0K
Pj4NCj4+IEluIG91ciBBcmNoIExpbnV4IHBhcnQgb2YgdGhlIHVwc3RyZWFtIHN5c3RlbWQg
Q0kgSSByZWNlbnRseSBub3RpY2VkIGFuDQo+PiB1cHRyZW5kIGluIENQVSBzb2Z0IGxvY2t1
cHMgd2hlbiBydW5uaW5nIG9uZSBvZiBvdXIgdGVzdHMuIFRoaXMgdGVzdCBydW5zDQo+PiBz
ZXZlcmFsIHN5c3RlbWQtbnNwYXduIGNvbnRhaW5lcnMgaW4gc3VjY2Vzc2lvbiBhbmQgc29t
ZXRpbWVzIHRoZSB1bmRlcmx5aW5nDQo+PiBWTSBsb2NrcyB1cCBkdWUgdG8gYSBDUFUgc29m
dCBsb2NrdXANCj4gDQo+IEJ5ICJ1bmRlcmx5aW5nIFZNIiwgZG8geW91IG1lYW4gTDEgb3Ig
TDI/ICBXaGVyZQ0KPiANCj4gICAgICBMMCA9PSBCYXJlIE1ldGFsDQo+ICAgICAgTDEgPT0g
QXJjaCBMaW51eCAoS1ZNLCA1LjE5LjUtYXJjaDEtMS81LjE5LjctYXJjaDEtMSkNCj4gICAg
ICBMMiA9PSBBcmNoIExpbnV4IChuZXN0ZWQgS1ZNIG9yIFFFTVUgVENHLCA1LjE5LjUtYXJj
aDEtMS81LjE5LjctYXJjaDEtMSkNCg0KSSBtZWFuIEwyLg0KDQo+IA0KPj4gKGp1c3QgdG8g
Y2xhcmlmeSwgdGhlIHRvcG9sb2d5IGlzOiBDZW50T1MgU3RyZWFtIDggKGJhcmVtZXRhbCwN
Cj4+IDQuMTguMC0zMDUuMy4xLmVsOCkgLT4gQXJjaCBMaW51eCAoS1ZNLCA1LjE5LjUtYXJj
aDEtMS81LjE5LjctYXJjaDEtMSkgLT4NCj4+IEFyY2ggTGludXggKG5lc3RlZCBLVk0gb3Ig
UUVNVSBUQ0csIGhhcHBlbnMgd2l0aCBib3RoLA0KPj4gNS4xOS41LWFyY2gxLTEvNS4xOS43
LWFyY2gxLTEpIC0+IG5zcGF3biBjb250YWluZXJzKS4NCj4gDQo+IFNpbmNlIHRoaXMgcmVw
cm9zIHdpdGggVENHLCB0aGF0IHJ1bGVzIG91dCBuZXN0ZWQgS1ZNIGFzIHRoZSBjdXBscml0
LlwNCg0KQWgsIHRoYXQncyBhIGdvb2QgcG9pbnQsIHRoYW5rcy4NCg0KPiANCj4+IEkgZGlk
IHNvbWUgZnVydGhlciB0ZXN0aW5nLCBhbmQgaXQgcmVwcm9kdWNlcyBldmVuIHdoZW4gdGhl
IGJhcmVtZXRhbCBpcyBteQ0KPj4gbG9jYWwgRmVkb3JhIDM2IG1hY2hpbmUgKDUuMTcuMTIt
MzAwLmZjMzYueDg2XzY0KS4NCj4+DQo+PiBVbmZvcnR1bmF0ZWx5LCBJIGNhbid0IHByb3Zp
ZGUgYSBzaW1wbGUgYW5kIHJlbGlhYmxlIHJlcHJvZHVjZXIsIGFzIEkgY2FuDQo+PiByZXBy
b2R1Y2UgaXQgb25seSB3aXRoIHRoYXQgcGFydGljdWxhciB0ZXN0IGFuZCBub3QgcmVsaWFi
bHkgKHNvbWV0aW1lcyBpdCdzDQo+PiB0aGUgZmlyc3QgaXRlcmF0aW9uLCBzb21ldGltZXMg
aXQgdGFrZXMgYW4gaG91ciBvciBtb3JlIHRvIHJlcHJvZHVjZSkuDQo+PiBIb3dldmVyLCBJ
J2QgYmUgbW9yZSB0aGFuIGdsYWQgdG8gY29sbGVjdCBtb3JlIGluZm9ybWF0aW9uIGZyb20g
b25lIHN1Y2gNCj4+IG1hY2hpbmUsIGlmIHBvc3NpYmxlLg0KPiANCj4gLi4uDQo+IA0KPj4g
QWxzbywgaW4gb25lIGluc3RhbmNlLCB0aGUgbWFjaGluZSBkaWVkIHdpdGg6DQo+IA0KPiBQ
cm9iYWJseSB1bnJlbGF0ZWQsIGJ1dCBzYW1lIHF1ZXN0aW9uIGFzIGFib3ZlOiB3aGljaCBs
YXllciBkb2VzICJ0aGUgbWFjaGluZSINCj4gcmVmZXIgdG8/DQoNCg0KU2FtZSBhcyBpbiB0
aGUgcHJldmlvdXMgY2FzZSAtIGl0J3MgdGhlIEwyLg0KDQoNCi0tIA0KUEdQIEtleSBJRDog
MHhGQjczOENFMjdCNjM0RTRCDQo=

--------------ZgivT5N8vq45pBZkpXb0yQGW--

--------------4QYIU5mY0l0YdJTh45k6Ka2P
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEp1toToNDDZVvO4js+3OM4ntjTksFAmMYtLsFAwAAAAAACgkQ+3OM4ntjTktd
Rw//Qq8jz/0TBSLBuKC36X58CPzdm1TRV4aoNaehxR3aTN61J2DfjTas+KPa6pYQRSWA0N0Tb3Vd
2LrZFP2Rh/jg3VyST48+81yOJeJZeDo1lSiSYm3wOFlhKFmoqC1DKPLDwj3vXk5kmFOiet9/EtfT
MqCyHoigap1z31XUhIR0IfigW8Qv6TDn/zI7kC51wWgTAiQ47sGbDrzXwnHVKZgw2PY/AWr5RIc+
jsam2YPvvChRVHUZForooiPCNKXI66zJVNl/kov9fqLAsXvb7QzCeGTQ7+EMP45hMan7iSOrDpT2
zaMaX3OaO3HrYUU8tMF1GnS0lTa3NYOKWr67o3jPEZpdJMBF854c1rf3eRSX9Hblrl5lkFxnlXKJ
3TN240gHk0/n1go4/GPVvJ9Bc2Y4u0i4Zpt9+2NfgzyvTrHEdegVHPkecuxUdNI3axksxVcN9dn7
GPiWa3zHtFwZRWQSxPybERAU7yx5Iru3XHxDHubtvHt0uuvkjvy1hdu2SBvthkT2j1CMSzRo4gEg
UJjM2rcI6zNKOGHJb+EygTWfpEd80HQ7Y/rKtxwdwZebYO8yCH5iEGXy/Piot0tzyDRYO/YWhuxz
13UvwNtz61pOr8p6ZrzF0EN9D7gZDWlYIdJwV8gTYbKYrC/wtuH4RlCZQfhnzA+6D2nHR3bsNDMy
hvY=
=KdUz
-----END PGP SIGNATURE-----

--------------4QYIU5mY0l0YdJTh45k6Ka2P--
