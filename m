Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1845B2206
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 17:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiIHPYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 11:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiIHPYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 11:24:33 -0400
Received: from littlepip.sumsal.cz (littlepip.sumsal.cz [IPv6:2a02:2b88:6:1f8a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3148101E7
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 08:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sumsal.cz;
        s=20140915; h=Content-Type:In-Reply-To:Subject:From:References:Cc:To:
        MIME-Version:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=V6NpwGxP7BWCdzQUQpC1R7ydwUe3NW3y3rHOtzbouYQ=; b=cOg5ewt3I2MjPe/gn3iJfE2pUF
        hPAeDhimcT6nc+2XF0GTtUGOrgM1eyv+zeQpKgEi1HCfXJcZ9ooRB9cRwL6Vo9yJodoh2Q92jBArk
        AVa/FmEYo7E27lJHidrqDAclE8c8/fG3s9+5cRhfo+ar0d7EmWp6atJAMsDInnRsZr5DNMA4c3JXE
        ML5LAjNdq9k+ALfoqDe0rZ3NsYTIaTzxNrds6HCF4AOFwdt3v26oPawA+HndeU4bfqoWdShv6THNK
        tuSkPLxfd6ZPuOY8Y08mhIK+vnXQD7p1Pipzkz7SpLLGCDstkd1/FJnRkp8s/tl+fygcVVWqJ+ks5
        LbEuUJmg==;
Received: from [176.74.150.102] (helo=[192.168.0.107])
        by littlepip.sumsal.cz with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <frantisek@sumsal.cz>)
        id 1oWJOF-00CcFB-1G; Thu, 08 Sep 2022 17:24:28 +0200
Message-ID: <5453c441-ae4e-00ce-a6c8-de591a4871bb@sumsal.cz>
Date:   Thu, 8 Sep 2022 17:24:26 +0200
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
 <afbd5927-413b-f876-8146-c3f4deb763e1@sumsal.cz>
 <YxoFf1LZfru5cmDO@google.com>
From:   =?UTF-8?B?RnJhbnRpxaFlayDFoHVtxaFhbA==?= <frantisek@sumsal.cz>
Subject: Re: BUG: soft lockup - CPU#0 stuck for 26s! with nested KVM on 5.19.x
In-Reply-To: <YxoFf1LZfru5cmDO@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------yxjYklHOdoRUb6wAqUrsWkzj"
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
--------------yxjYklHOdoRUb6wAqUrsWkzj
Content-Type: multipart/mixed; boundary="------------Zgf69yQzBvj4kZR7oekBtZyp";
 protected-headers="v1"
From: =?UTF-8?B?RnJhbnRpxaFlayDFoHVtxaFhbA==?= <frantisek@sumsal.cz>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Message-ID: <5453c441-ae4e-00ce-a6c8-de591a4871bb@sumsal.cz>
Subject: Re: BUG: soft lockup - CPU#0 stuck for 26s! with nested KVM on 5.19.x
References: <a861d348-b3fd-fd1d-2427-0a89ae139948@sumsal.cz>
 <Yxiz3giU/WEftPp6@google.com>
 <a8fc728c-073c-2ff5-2436-40c84c3c62e1@sumsal.cz>
 <Yxi3cj6xKBlJ3IJV@google.com>
 <afbd5927-413b-f876-8146-c3f4deb763e1@sumsal.cz>
 <YxoFf1LZfru5cmDO@google.com>
In-Reply-To: <YxoFf1LZfru5cmDO@google.com>

--------------Zgf69yQzBvj4kZR7oekBtZyp
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

DQoNCk9uIDkvOC8yMiAxNzowOCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gT24g
VGh1LCBTZXAgMDgsIDIwMjIsIEZyYW50acWhZWsgxaB1bcWhYWwgd3JvdGU6DQo+PiBPbiA5
LzcvMjIgMTc6MjMsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+Pj4gT24gV2VkLCBT
ZXAgMDcsIDIwMjIsIEZyYW50acWhZWsgxaB1bcWhYWwgd3JvdGU6DQo+Pj4+IE9uIDkvNy8y
MiAxNzowOCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4+Pj4+IE9uIFdlZCwgU2Vw
IDA3LCAyMDIyLCBGcmFudGnFoWVrIMWgdW3FoWFsIHdyb3RlOg0KPj4+Pj4+IEhlbGxvIQ0K
Pj4+Pj4+DQo+Pj4+Pj4gSW4gb3VyIEFyY2ggTGludXggcGFydCBvZiB0aGUgdXBzdHJlYW0g
c3lzdGVtZCBDSSBJIHJlY2VudGx5IG5vdGljZWQgYW4NCj4+Pj4+PiB1cHRyZW5kIGluIENQ
VSBzb2Z0IGxvY2t1cHMgd2hlbiBydW5uaW5nIG9uZSBvZiBvdXIgdGVzdHMuIFRoaXMgdGVz
dCBydW5zDQo+Pj4+Pj4gc2V2ZXJhbCBzeXN0ZW1kLW5zcGF3biBjb250YWluZXJzIGluIHN1
Y2Nlc3Npb24gYW5kIHNvbWV0aW1lcyB0aGUgdW5kZXJseWluZw0KPj4+Pj4+IFZNIGxvY2tz
IHVwIGR1ZSB0byBhIENQVSBzb2Z0IGxvY2t1cA0KPj4+Pj4NCj4+Pj4+IEJ5ICJ1bmRlcmx5
aW5nIFZNIiwgZG8geW91IG1lYW4gTDEgb3IgTDI/ICBXaGVyZQ0KPj4+Pj4NCj4+Pj4+ICAg
ICAgICBMMCA9PSBCYXJlIE1ldGFsDQo+Pj4+PiAgICAgICAgTDEgPT0gQXJjaCBMaW51eCAo
S1ZNLCA1LjE5LjUtYXJjaDEtMS81LjE5LjctYXJjaDEtMSkNCj4+Pj4+ICAgICAgICBMMiA9
PSBBcmNoIExpbnV4IChuZXN0ZWQgS1ZNIG9yIFFFTVUgVENHLCA1LjE5LjUtYXJjaDEtMS81
LjE5LjctYXJjaDEtMSkNCj4+Pj4NCj4+Pj4gSSBtZWFuIEwyLg0KPj4+DQo+Pj4gSXMgdGhl
cmUgYW55dGhpbmcgaW50ZXJlc3RpbmcgaW4gdGhlIEwxIG9yIEwwIGxvZ3M/ICBBIGZhaWx1
cmUgaW4gYSBsb3dlciBsZXZlbA0KPj4+IGNhbiBtYW5pZmVzdCBhcyBhIHNvZnQgbG9ja3Vw
IGFuZC9vciBzdGFsbCBpbiB0aGUgVk0sIGUuZy4gYmVjYXVzZSBhIHZDUFUgaXNuJ3QNCj4+
PiBydW4gYnkgdGhlIGhvc3QgZm9yIHdoYXRldmVyIHJlYXNvbi4NCj4+DQo+PiBUaGVyZSdz
IG5vdGhpbmcgKHF1aXRlIGxpdGVyYWxseSkgaW4gdGhlIEwwIGxvZ3MsIHRoZSBob3N0IGlz
IHNpbGVudCB3aGVuIHJ1bm5pbmcgdGhlIFZNL3Rlc3RzLg0KPj4gQXMgZm9yIEwxLCB0aGVy
ZSBkb2Vzbid0IHNlZW0gdG8gYmUgYW55dGhpbmcgaW50ZXJlc3RpbmcgYXMgd2VsbC4gSGVy
ZSBhcmUgdGhlIEwxIGFuZCBMMiBsb2dzDQo+PiBmb3IgcmVmZXJlbmNlOiBodHRwczovL21y
YzBtbWFuZC5mZWRvcmFwZW9wbGUub3JnL2tlcm5lbC1rdm0tc29mdC1sb2NrdXAvMjAyMi0w
OS0wNy1sb2dzLw0KPj4NCj4+Pg0KPj4+IERvZXMgdGhlIGJ1ZyByZXBybyB3aXRoIGFuIG9s
ZGVyIHZlcnNpb24gb2YgUUVNVT8gIElmIGl0J3MgZGlmZmljdWx0IHRvIHJvbGwgYmFjaw0K
Pj4+IHRoZSBRRU1VIHZlcnNpb24sIHRoZW4gd2UgY2FuIHB1bnQgb24gdGhpcyBxdWVzdGlv
biBmb3Igbm93Lg0KPj4NCj4+Pg0KPj4+IElzIGl0IHBvc3NpYmxlIHRvIHJ1biB0aGUgbnNw
YXduIHRlc3RzIGluIEwxPyAgSWYgdGhlIGJ1ZyByZXByb3MgdGhlcmUsIHRoYXQgd291bGQN
Cj4+PiBncmVhdGx5IHNocmluayB0aGUgc2l6ZSBvZiB0aGUgaGF5c3RhY2suDQo+Pg0KPj4g
SSd2ZSBmaWRkbGVkIGFyb3VuZCB3aXRoIHRoZSB0ZXN0IGFuZCBtYW5hZ2VkIHRvIHRyaW0g
aXQgZG93biBlbm91Z2ggc28gaXQncyBlYXN5IHRvIHJ1biBpbiBib3RoDQo+PiBMMSBhbmQg
TDIsIGFuZCBhZnRlciBjb3VwbGUgb2YgaG91cnMgSSBtYW5hZ2VkIHRvIHJlcHJvZHVjZSBp
dCBpbiBib3RoIGxheWVycy4gVGhhdCBhbHNvIHNvbWV3aGF0DQo+PiBhbnN3ZXJzIHRoZSBR
RU1VIHF1ZXN0aW9uLCBzaW5jZSBMMCB1c2VzIFFFTVUgNi4yLjAgdG8gcnVuIEwxLCBhbmQg
TDEgdXNlcyBRRU1VIDcuMC4wIHRvIHJ1biBMMi4NCj4+IEluIGJvdGggY2FzZXMgSSB1c2Vk
IFRDRyBlbXVsYXRpb24sIHNpbmNlIHdpdGggaXQgdGhlIGlzc3VlIGFwcGVhcnMgdG8gcmVw
cm9kdWNlIHNsaWdodGx5IG1vcmUNCj4+IG9mdGVuIChvciBtYXliZSBJIHdhcyBqdXN0IHVu
bHVja3kgd2l0aCBLVk0pLg0KPj4NCj4+IGh0dHBzOi8vbXJjMG1tYW5kLmZlZG9yYXBlb3Bs
ZS5vcmcva2VybmVsLWt2bS1zb2Z0LWxvY2t1cC8yMDIyLTA5LTA3LWxvZ3Mtbm8tTDIvTDFf
Y29uc29sZS5sb2cNCj4+DQo+PiBBcyBpbiB0aGUgcHJldmlvdXMgY2FzZSwgdGhlcmUncyBu
b3RoaW5nIG9mIGludGVyZXN0IGluIHRoZSBMMCBsb2dzLg0KPj4NCj4+IFRoaXMgYWxzbyBy
YWlzZXMgYSBxdWVzdGlvbiAtIGlzIHRoaXMgaXNzdWUgc3RpbGwgS1ZNLXJlbGF0ZWQsIHNp
bmNlIGluIHRoZSBsYXN0IGNhc2UgdGhlcmUncw0KPj4ganVzdCBMMCBiYXJlbWV0YWwgYW5k
IEwxIFFFTVUvVENHIHdpdGhvdXQgS1ZNIGludm9sdmVkPw0KPiANCj4gWWEsIHVubGVzcyB0
aGVyZSdzIGEgbGF0ZW50IGJ1ZyBpbiBLVk0gdGhhdCdzIHByZXNlbnQgaW4geW91ciBMMCBr
ZXJuZWwsIHdoaWNoIGlzDQo+IGV4dHJlbWVseSB1bmxpa2VseSBnaXZlbiB0aGF0IHRoZSBi
dWcgcmVwcm9zIHdpdGggNC4xOCBhbmQgNS4xNyBhcyB0aGUgYmFyZSBtZXRhbA0KPiBrZXJu
ZWwsIHRoaXMgaXNuJ3QgYSBLVk0gcHJvYmxlbS4NCj4gDQo+IFRoZSBtbSwgZXh0NCwgYW5k
IHNjaGVkdWxlciBzdWJzeXN0ZW1zIGFyZSBhbGwgbGlrZWx5IGNhbmRpZGF0ZXMuICBJJ20g
bm90IGZhbWlsaWFyDQo+IGVub3VnaCB3aXRoIHRoZWlyIGdvcnkgZGV0YWlscyB0byBwb2lu
dCBmaW5nZXJzIHRob3VnaC4NCj4gDQo+IERvIHlvdSB0aGluayBpdCdzIHBvc3NpYmxlIHRv
IGJpc2VjdCB0aGUgTDEga2VybmVsIHVzaW5nIHRoZSBRRU1VL1RDRyBjb25maWd1cmF0aW9u
Pw0KPiBUaGF0J2QgcHJvYmFibHkgYmUgdGhlIGxlYXN0IGF3ZnVsIHdheSB0byBnZXQgYSBy
b290IGNhdXNlLg0KDQpZZWFoLCBJIGNhbiB0cnksIGJ1dCBpdCBtaWdodCB0YWtlIHNvbWUg
dGltZS4gTmV2ZXJ0aGVsZXNzLCBpdCBzb3VuZHMgbGlrZSB0aGUgbGVhc3QgYXdmdWwgd2F5
DQpob3cgdG8gZGVidWcgdGhpcyBmdXJ0aGVyLCBhcyB5b3Ugc2FpZC4gSSdsbCByZXBvcnQg
YmFjayBpZi93aGVuIEkgZmluZCBzb21ldGhpbmcgaW50ZXJlc3RpbmcuDQoNClRoYW5rcyBm
b3IgdGhlIHRpcHMhDQoNCi0tIA0KUEdQIEtleSBJRDogMHhGQjczOENFMjdCNjM0RTRCDQo=


--------------Zgf69yQzBvj4kZR7oekBtZyp--

--------------yxjYklHOdoRUb6wAqUrsWkzj
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEp1toToNDDZVvO4js+3OM4ntjTksFAmMaCSoFAwAAAAAACgkQ+3OM4ntjTkt9
Bw/9GSCFhfHx05LxScI6MIxP1du1f4XeTmffeX+G5PfvH1CrGvZPKf/8IV8hJAHwoTE4iF3db2/B
eplNSZcPEm/P8p/7GPCDOqZa4amTPQ598XVMAbTpXwNevUp9Cq2JbRBC8kjXoKpXkya2V2N8sMaT
6fnGNnDMLGa4y+rtN7ejKiUFzUh1G0Hr3PfTfj7rKhnepFuddsD2wC5eZRAl2izJG9S8qbi7Zgh/
XcixoKhu0eGGgGxpaegmB9UIEGpabFlFxzqdaZ/Fruk2eInImytwLVc5206A15GqjbSRA35GcGVP
faGX4OjB3+kfDCSJCIYMU8xEpjh2HalQFcKqjlf8DvQ5wO3MkED/LlVzRkETgH2/EazwgsVRhpGW
YHeYNFXDCIak9ZTiZT6N6cJmfza8cX7eji2VnZS+ErAVt0ffv01wjTyyRX8rkqRcGIzwjxnR3VbT
eTG6Nh6F9bVUn7AGua8i+RSpnQiaBLH47/bm38782TmQqf9FVg1ojWz32Z0bneMuYsKr+2siI5bg
HnSmwDh8msyA3BGBoAq0Cz3Qzh8t3AqT3RluctwA3LhAdYoSLeLhQZW2QBxtLXNZ4XCecb8Lwvc1
vPg4dm8Y8112ZjCmN1Vux2c2slw6JGct+9ABavDHpTkphYhI9YRjO/OuxmouzzAH2wpoquuc+LLS
fX8=
=8DUk
-----END PGP SIGNATURE-----

--------------yxjYklHOdoRUb6wAqUrsWkzj--
