Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B5E5B1705
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 10:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiIHIar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 04:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiIHIal (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 04:30:41 -0400
Received: from littlepip.sumsal.cz (littlepip.sumsal.cz [IPv6:2a02:2b88:6:1f8a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5329C726A2
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 01:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sumsal.cz;
        s=20140915; h=Content-Type:In-Reply-To:Subject:From:References:Cc:To:
        MIME-Version:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nTHzHeLGtw6p3sZEvXhZNEmgC7kUA6Esm3A/E4nzxfg=; b=kr1G9Oj8qSVIS+xrb31yk/FSLc
        UPZOpFS5W5M+BZ99iBaToqP7+xrKmE4TTZmlraxOsSuQ5O5xjnraTjIenqr2UZCoDvOgz64vM5cAV
        FgltmKxk81JqI5zq/uwwF3RY2fxDYeAL6ftivq5lXgFsShWCVcmPdub0JhTSSIEonpFLjOkBvTtgM
        VAohIsO6I5c3shGaahbRI5+DOs2tc4SwIDcVi+uAQsPmuRSQfR3WOdA4dg7EDVqn8AasvMETWhS0P
        YFbYsYewnMdrOyYrdfIN876XN7bBdHijgwf0o3DmD7pJbleDbNbSWQjI8EqxPXK0eS6fOF70B4xIC
        kzTcyCCA==;
Received: from [176.74.150.102] (helo=[192.168.0.107])
        by littlepip.sumsal.cz with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <frantisek@sumsal.cz>)
        id 1oWCvW-00CbTS-Jb; Thu, 08 Sep 2022 10:30:23 +0200
Message-ID: <afbd5927-413b-f876-8146-c3f4deb763e1@sumsal.cz>
Date:   Thu, 8 Sep 2022 10:30:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <a861d348-b3fd-fd1d-2427-0a89ae139948@sumsal.cz>
 <Yxiz3giU/WEftPp6@google.com>
 <a8fc728c-073c-2ff5-2436-40c84c3c62e1@sumsal.cz>
 <Yxi3cj6xKBlJ3IJV@google.com>
From:   =?UTF-8?B?RnJhbnRpxaFlayDFoHVtxaFhbA==?= <frantisek@sumsal.cz>
Subject: Re: BUG: soft lockup - CPU#0 stuck for 26s! with nested KVM on 5.19.x
In-Reply-To: <Yxi3cj6xKBlJ3IJV@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0NlJFgN5zXAVVGZcFn2Frgi6"
X-Spam-Score: -107.1 (---------------------------------------------------) #
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0NlJFgN5zXAVVGZcFn2Frgi6
Content-Type: multipart/mixed; boundary="------------z94H1f8Ntqbo07vO7jZVSHzN";
 protected-headers="v1"
From: =?UTF-8?B?RnJhbnRpxaFlayDFoHVtxaFhbA==?= <frantisek@sumsal.cz>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Message-ID: <afbd5927-413b-f876-8146-c3f4deb763e1@sumsal.cz>
Subject: Re: BUG: soft lockup - CPU#0 stuck for 26s! with nested KVM on 5.19.x
References: <a861d348-b3fd-fd1d-2427-0a89ae139948@sumsal.cz>
 <Yxiz3giU/WEftPp6@google.com>
 <a8fc728c-073c-2ff5-2436-40c84c3c62e1@sumsal.cz>
 <Yxi3cj6xKBlJ3IJV@google.com>
In-Reply-To: <Yxi3cj6xKBlJ3IJV@google.com>

--------------z94H1f8Ntqbo07vO7jZVSHzN
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gOS83LzIyIDE3OjIzLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiBPbiBXZWQs
IFNlcCAwNywgMjAyMiwgRnJhbnRpxaFlayDFoHVtxaFhbCB3cm90ZToNCj4+IE9uIDkvNy8y
MiAxNzowOCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4+PiBPbiBXZWQsIFNlcCAw
NywgMjAyMiwgRnJhbnRpxaFlayDFoHVtxaFhbCB3cm90ZToNCj4+Pj4gSGVsbG8hDQo+Pj4+
DQo+Pj4+IEluIG91ciBBcmNoIExpbnV4IHBhcnQgb2YgdGhlIHVwc3RyZWFtIHN5c3RlbWQg
Q0kgSSByZWNlbnRseSBub3RpY2VkIGFuDQo+Pj4+IHVwdHJlbmQgaW4gQ1BVIHNvZnQgbG9j
a3VwcyB3aGVuIHJ1bm5pbmcgb25lIG9mIG91ciB0ZXN0cy4gVGhpcyB0ZXN0IHJ1bnMNCj4+
Pj4gc2V2ZXJhbCBzeXN0ZW1kLW5zcGF3biBjb250YWluZXJzIGluIHN1Y2Nlc3Npb24gYW5k
IHNvbWV0aW1lcyB0aGUgdW5kZXJseWluZw0KPj4+PiBWTSBsb2NrcyB1cCBkdWUgdG8gYSBD
UFUgc29mdCBsb2NrdXANCj4+Pg0KPj4+IEJ5ICJ1bmRlcmx5aW5nIFZNIiwgZG8geW91IG1l
YW4gTDEgb3IgTDI/ICBXaGVyZQ0KPj4+DQo+Pj4gICAgICAgTDAgPT0gQmFyZSBNZXRhbA0K
Pj4+ICAgICAgIEwxID09IEFyY2ggTGludXggKEtWTSwgNS4xOS41LWFyY2gxLTEvNS4xOS43
LWFyY2gxLTEpDQo+Pj4gICAgICAgTDIgPT0gQXJjaCBMaW51eCAobmVzdGVkIEtWTSBvciBR
RU1VIFRDRywgNS4xOS41LWFyY2gxLTEvNS4xOS43LWFyY2gxLTEpDQo+Pg0KPj4gSSBtZWFu
IEwyLg0KPiANCj4gSXMgdGhlcmUgYW55dGhpbmcgaW50ZXJlc3RpbmcgaW4gdGhlIEwxIG9y
IEwwIGxvZ3M/ICBBIGZhaWx1cmUgaW4gYSBsb3dlciBsZXZlbA0KPiBjYW4gbWFuaWZlc3Qg
YXMgYSBzb2Z0IGxvY2t1cCBhbmQvb3Igc3RhbGwgaW4gdGhlIFZNLCBlLmcuIGJlY2F1c2Ug
YSB2Q1BVIGlzbid0DQo+IHJ1biBieSB0aGUgaG9zdCBmb3Igd2hhdGV2ZXIgcmVhc29uLg0K
DQpUaGVyZSdzIG5vdGhpbmcgKHF1aXRlIGxpdGVyYWxseSkgaW4gdGhlIEwwIGxvZ3MsIHRo
ZSBob3N0IGlzIHNpbGVudCB3aGVuIHJ1bm5pbmcgdGhlIFZNL3Rlc3RzLg0KQXMgZm9yIEwx
LCB0aGVyZSBkb2Vzbid0IHNlZW0gdG8gYmUgYW55dGhpbmcgaW50ZXJlc3RpbmcgYXMgd2Vs
bC4gSGVyZSBhcmUgdGhlIEwxIGFuZCBMMiBsb2dzDQpmb3IgcmVmZXJlbmNlOiBodHRwczov
L21yYzBtbWFuZC5mZWRvcmFwZW9wbGUub3JnL2tlcm5lbC1rdm0tc29mdC1sb2NrdXAvMjAy
Mi0wOS0wNy1sb2dzLw0KDQo+IA0KPiBEb2VzIHRoZSBidWcgcmVwcm8gd2l0aCBhbiBvbGRl
ciB2ZXJzaW9uIG9mIFFFTVU/ICBJZiBpdCdzIGRpZmZpY3VsdCB0byByb2xsIGJhY2sNCj4g
dGhlIFFFTVUgdmVyc2lvbiwgdGhlbiB3ZSBjYW4gcHVudCBvbiB0aGlzIHF1ZXN0aW9uIGZv
ciBub3cuDQoNCj4gDQo+IElzIGl0IHBvc3NpYmxlIHRvIHJ1biB0aGUgbnNwYXduIHRlc3Rz
IGluIEwxPyAgSWYgdGhlIGJ1ZyByZXByb3MgdGhlcmUsIHRoYXQgd291bGQNCj4gZ3JlYXRs
eSBzaHJpbmsgdGhlIHNpemUgb2YgdGhlIGhheXN0YWNrLg0KDQpJJ3ZlIGZpZGRsZWQgYXJv
dW5kIHdpdGggdGhlIHRlc3QgYW5kIG1hbmFnZWQgdG8gdHJpbSBpdCBkb3duIGVub3VnaCBz
byBpdCdzIGVhc3kgdG8gcnVuIGluIGJvdGgNCkwxIGFuZCBMMiwgYW5kIGFmdGVyIGNvdXBs
ZSBvZiBob3VycyBJIG1hbmFnZWQgdG8gcmVwcm9kdWNlIGl0IGluIGJvdGggbGF5ZXJzLiBU
aGF0IGFsc28gc29tZXdoYXQNCmFuc3dlcnMgdGhlIFFFTVUgcXVlc3Rpb24sIHNpbmNlIEww
IHVzZXMgUUVNVSA2LjIuMCB0byBydW4gTDEsIGFuZCBMMSB1c2VzIFFFTVUgNy4wLjAgdG8g
cnVuIEwyLg0KSW4gYm90aCBjYXNlcyBJIHVzZWQgVENHIGVtdWxhdGlvbiwgc2luY2Ugd2l0
aCBpdCB0aGUgaXNzdWUgYXBwZWFycyB0byByZXByb2R1Y2Ugc2xpZ2h0bHkgbW9yZQ0Kb2Z0
ZW4gKG9yIG1heWJlIEkgd2FzIGp1c3QgdW5sdWNreSB3aXRoIEtWTSkuDQoNCmh0dHBzOi8v
bXJjMG1tYW5kLmZlZG9yYXBlb3BsZS5vcmcva2VybmVsLWt2bS1zb2Z0LWxvY2t1cC8yMDIy
LTA5LTA3LWxvZ3Mtbm8tTDIvTDFfY29uc29sZS5sb2cNCg0KQXMgaW4gdGhlIHByZXZpb3Vz
IGNhc2UsIHRoZXJlJ3Mgbm90aGluZyBvZiBpbnRlcmVzdCBpbiB0aGUgTDAgbG9ncy4NCg0K
VGhpcyBhbHNvIHJhaXNlcyBhIHF1ZXN0aW9uIC0gaXMgdGhpcyBpc3N1ZSBzdGlsbCBLVk0t
cmVsYXRlZCwgc2luY2UgaW4gdGhlIGxhc3QgY2FzZSB0aGVyZSdzDQpqdXN0IEwwIGJhcmVt
ZXRhbCBhbmQgTDEgUUVNVS9UQ0cgd2l0aG91dCBLVk0gaW52b2x2ZWQ/DQoNCi0tIA0KUEdQ
IEtleSBJRDogMHhGQjczOENFMjdCNjM0RTRCDQo=

--------------z94H1f8Ntqbo07vO7jZVSHzN--

--------------0NlJFgN5zXAVVGZcFn2Frgi6
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEp1toToNDDZVvO4js+3OM4ntjTksFAmMZqB4FAwAAAAAACgkQ+3OM4ntjTksU
wxAApxDbUoyL8T/LH4NKqkxstnRJQYd5/4ciDJ0Hvk3q0shbT7AXArgxKKRrgZjU1C/J7wMPE33F
eC3Yj1L1+yM3XJw7tB7bzwR13zYYl2rENtCMW804ZxKM4KCFJqTItJpZ9T18xyjaiMf8z7Xq2Hj7
0Ea/ZHAUGIVmea4i8ZrwhTacReDrfRHozMjX7OOSnUrsGmK6BEplQELHOQ8NyxbZdGSyLiOQuVcm
DGG+ULPeOrSsLq1gM9vXIiR/SQtof+kM0wMpQaJAUtQrqJgTg3ETmVjfICLA6+FUOxYzrVtlH6m5
6LTWmtJ6ihByuEFvshnV2qtLVK8l0ZWjc3ecZlp1ktdgIC4D02gjTEVReX5XqmTMzotWgzzjv+GU
mpOgaKZE8Zg31fSIzsvsWoi4n0F4YB6dSgj4FE1kGnaxBjzhY6E3VF3WWNtOwYdgfWTc9l2A2wtL
Qse/wfav1A9pc9rmXF8L1Uk4ggIuwZUolPDPoQz1Ic4iYO8xEG6d3A7Tir8fU9yfpX8t2boVu0ha
i6X2hdi6CPD/HhvI691rDxFueqBxMAin+tu8C95GpdBhJmKq4rgd2K7ednlGatZ6Yd6A90TNRv30
nT2ZoznzLhCsKNd/yDVTAUuSUWfScWaQDt+/APfYgbXz0Z3eBDLdfzyVrGtG7+EfN5JLu7Y1FngH
4Bk=
=T/9r
-----END PGP SIGNATURE-----

--------------0NlJFgN5zXAVVGZcFn2Frgi6--
