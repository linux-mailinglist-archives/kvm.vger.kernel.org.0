Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0579B61F1CA
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 12:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbiKGL1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 06:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiKGL1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 06:27:14 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962F619C3D;
        Mon,  7 Nov 2022 03:27:11 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3CEF11F88D;
        Mon,  7 Nov 2022 11:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1667820430; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fuy07r/Pl4zcOlkiTDUJwluu6evDL6z2DcxU1amHq48=;
        b=fvFO+ojTbywJ1hqi2rEbRh3do0UY+B9SLEzmY8XfgEGibDE2jOHOX000kSQOuSiA9tu6rY
        uHU6yfpHV4OlOE86qzADCDNm0iwDMdaJUGRt7eW1WyEPSuYVOZT+UQc+fv7JiDMz/GFiSn
        YX5X9E5leL+OR5ApwITyUtqYrhaE/pQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B327713494;
        Mon,  7 Nov 2022 11:27:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2ZETKo3raGMcEwAAMHmgww
        (envelope-from <jgross@suse.com>); Mon, 07 Nov 2022 11:27:09 +0000
Message-ID: <998fb4c9-dcac-3ee1-08f9-e74bfa5ab3d5@suse.com>
Date:   Mon, 7 Nov 2022 12:27:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] x86/paravirt: use common macro for creating simple asm
 paravirt functions
Content-Language: en-US
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Cc:     "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20221020091950.6741-1-jgross@suse.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <20221020091950.6741-1-jgross@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------C6qm0TaLOIxpKjeOyN6dfJd0"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------C6qm0TaLOIxpKjeOyN6dfJd0
Content-Type: multipart/mixed; boundary="------------20zTduStMkWLPE6nF0np5fEM";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
 virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Cc: "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>,
 Alexey Makhalov <amakhalov@vmware.com>,
 VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Message-ID: <998fb4c9-dcac-3ee1-08f9-e74bfa5ab3d5@suse.com>
Subject: Re: [PATCH] x86/paravirt: use common macro for creating simple asm
 paravirt functions
References: <20221020091950.6741-1-jgross@suse.com>
In-Reply-To: <20221020091950.6741-1-jgross@suse.com>

--------------20zTduStMkWLPE6nF0np5fEM
Content-Type: multipart/mixed; boundary="------------oQfxIuLrh0ERhpdpy2dQj4wz"

--------------oQfxIuLrh0ERhpdpy2dQj4wz
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

UGluZz8NCg0KT24gMjAuMTAuMjIgMTE6MTksIEp1ZXJnZW4gR3Jvc3Mgd3JvdGU6DQo+IFRo
ZXJlIGFyZSBzb21lIHBhcmF2aXJ0IGFzc2VtYmxlciBmdW5jdGlvbnMgd2hpY2ggYXJlIHNo
YXJpbmcgYSBjb21tb24NCj4gcGF0dGVybi4gSW50cm9kdWNlIGEgbWFjcm8gREVGSU5FX1BB
UkFWSVJUX0FTTSgpIGZvciBjcmVhdGluZyB0aGVtLg0KPiANCj4gVGhlIGV4cGxpY2l0IF9w
YXJhdmlydF9ub3AoKSBwcm90b3R5cGUgaW4gcGFyYXZpcnQuYyBpc24ndCBuZWVkZWQsIGFz
DQo+IGl0IGlzIGluY2x1ZGVkIGluIHBhcmF2aXJ0X3R5cGVzLmggYWxyZWFkeS4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCj4gLS0t
DQo+ICAgYXJjaC94ODYvaW5jbHVkZS9hc20vcGFyYXZpcnQuaCAgICAgICAgICAgfCAxMiAr
KysrKysNCj4gICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9xc3BpbmxvY2tfcGFyYXZpcnQuaCB8
IDQ2ICsrKysrKysrKystLS0tLS0tLS0tLS0tDQo+ICAgYXJjaC94ODYva2VybmVsL2t2bS5j
ICAgICAgICAgICAgICAgICAgICAgfCAxOSArKystLS0tLS0tDQo+ICAgYXJjaC94ODYva2Vy
bmVsL3BhcmF2aXJ0LmMgICAgICAgICAgICAgICAgfCAyMiArKy0tLS0tLS0tLQ0KPiAgIDQg
ZmlsZXMgY2hhbmdlZCwgNDAgaW5zZXJ0aW9ucygrKSwgNTkgZGVsZXRpb25zKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vcGFyYXZpcnQuaCBiL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0LmgNCj4gaW5kZXggMmEwYjhkZDRlYzMzLi40Nzli
ZjI2NGI4YWEgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0
LmgNCj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcGFyYXZpcnQuaA0KPiBAQCAtNzMw
LDYgKzczMCwxOCBAQCBzdGF0aWMgX19hbHdheXNfaW5saW5lIHVuc2lnbmVkIGxvbmcgYXJj
aF9sb2NhbF9pcnFfc2F2ZSh2b2lkKQ0KPiAgICN1bmRlZiBQVk9QX1ZDQUxMNA0KPiAgICN1
bmRlZiBQVk9QX0NBTEw0DQo+ICAgDQo+ICsjZGVmaW5lIERFRklORV9QQVJBVklSVF9BU00o
ZnVuYywgaW5zdHIsIHNlYykJCVwNCj4gKwlhc20gKCIucHVzaHNlY3Rpb24gIiAjc2VjICIs
IFwiYXhcIlxuIgkJXA0KPiArCSAgICAgIi5nbG9iYWwgIiAjZnVuYyAiXG5cdCIJCQlcDQo+
ICsJICAgICAiLnR5cGUgIiAjZnVuYyAiLCBAZnVuY3Rpb25cblx0IgkJXA0KPiArCSAgICAg
X19BTElHTl9TVFIgIlxuIgkJCQlcDQo+ICsJICAgICAjZnVuYyAiOlxuXHQiCQkJCVwNCj4g
KwkgICAgIEFTTV9FTkRCUgkJCQkJXA0KPiArCSAgICAgaW5zdHIJCQkJCVwNCj4gKwkgICAg
IEFTTV9SRVQJCQkJCVwNCj4gKwkgICAgICIuc2l6ZSAiICNmdW5jICIsIC4gLSAiICNmdW5j
ICJcblx0IglcDQo+ICsJICAgICAiLnBvcHNlY3Rpb24iKQ0KPiArDQo+ICAgZXh0ZXJuIHZv
aWQgZGVmYXVsdF9iYW5uZXIodm9pZCk7DQo+ICAgDQo+ICAgI2Vsc2UgIC8qIF9fQVNTRU1C
TFlfXyAqLw0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vcXNwaW5sb2Nr
X3BhcmF2aXJ0LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9xc3BpbmxvY2tfcGFyYXZpcnQu
aA0KPiBpbmRleCA2MGVjZTU5MmIyMjAuLmM0OTBmNWViOWYzZSAxMDA2NDQNCj4gLS0tIGEv
YXJjaC94ODYvaW5jbHVkZS9hc20vcXNwaW5sb2NrX3BhcmF2aXJ0LmgNCj4gKysrIGIvYXJj
aC94ODYvaW5jbHVkZS9hc20vcXNwaW5sb2NrX3BhcmF2aXJ0LmgNCj4gQEAgLTE0LDggKzE0
LDYgQEANCj4gICANCj4gICBfX1BWX0NBTExFRV9TQVZFX1JFR1NfVEhVTksoX19wdl9xdWV1
ZWRfc3Bpbl91bmxvY2tfc2xvd3BhdGgsICIuc3BpbmxvY2sudGV4dCIpOw0KPiAgICNkZWZp
bmUgX19wdl9xdWV1ZWRfc3Bpbl91bmxvY2sJX19wdl9xdWV1ZWRfc3Bpbl91bmxvY2sNCj4g
LSNkZWZpbmUgUFZfVU5MT0NLCQkiX19yYXdfY2FsbGVlX3NhdmVfX19wdl9xdWV1ZWRfc3Bp
bl91bmxvY2siDQo+IC0jZGVmaW5lIFBWX1VOTE9DS19TTE9XUEFUSAkiX19yYXdfY2FsbGVl
X3NhdmVfX19wdl9xdWV1ZWRfc3Bpbl91bmxvY2tfc2xvd3BhdGgiDQo+ICAgDQo+ICAgLyoN
Cj4gICAgKiBPcHRpbWl6ZWQgYXNzZW1ibHkgdmVyc2lvbiBvZiBfX3Jhd19jYWxsZWVfc2F2
ZV9fX3B2X3F1ZXVlZF9zcGluX3VubG9jaw0KPiBAQCAtMzcsMzIgKzM1LDI2IEBAIF9fUFZf
Q0FMTEVFX1NBVkVfUkVHU19USFVOSyhfX3B2X3F1ZXVlZF9zcGluX3VubG9ja19zbG93cGF0
aCwgIi5zcGlubG9jay50ZXh0Iik7DQo+ICAgICogICByc2kgPSBsb2NrdmFsICAgICAgICAg
ICAoc2Vjb25kIGFyZ3VtZW50KQ0KPiAgICAqICAgcmR4ID0gaW50ZXJuYWwgdmFyaWFibGUg
KHNldCB0byAwKQ0KPiAgICAqLw0KPiAtYXNtICAgICgiLnB1c2hzZWN0aW9uIC5zcGlubG9j
ay50ZXh0OyINCj4gLQkiLmdsb2JsICIgUFZfVU5MT0NLICI7Ig0KPiAtCSIudHlwZSAiIFBW
X1VOTE9DSyAiLCBAZnVuY3Rpb247Ig0KPiAtCSIuYWxpZ24gNCwweDkwOyINCj4gLQlQVl9V
TkxPQ0sgIjogIg0KPiAtCUFTTV9FTkRCUg0KPiAtCUZSQU1FX0JFR0lODQo+IC0JInB1c2gg
ICVyZHg7Ig0KPiAtCSJtb3YgICAkMHgxLCVlYXg7Ig0KPiAtCSJ4b3IgICAlZWR4LCVlZHg7
Ig0KPiAtCUxPQ0tfUFJFRklYICJjbXB4Y2hnICVkbCwoJXJkaSk7Ig0KPiAtCSJjbXAgICAk
MHgxLCVhbDsiDQo+IC0JImpuZSAgIC5zbG93cGF0aDsiDQo+IC0JInBvcCAgICVyZHg7Ig0K
PiArI2RlZmluZSBQVl9VTkxPQ0tfQVNNCQkJCQkJCVwNCj4gKwlGUkFNRV9CRUdJTgkJCQkJ
CQlcDQo+ICsJInB1c2ggICVyZHhcblx0IgkJCQkJCVwNCj4gKwkibW92ICAgJDB4MSwlZWF4
XG5cdCIJCQkJCQlcDQo+ICsJInhvciAgICVlZHgsJWVkeFxuXHQiCQkJCQkJXA0KPiArCUxP
Q0tfUFJFRklYICJjbXB4Y2hnICVkbCwoJXJkaSlcblx0IgkJCQlcDQo+ICsJImNtcCAgICQw
eDEsJWFsXG5cdCIJCQkJCQlcDQo+ICsJImpuZSAgIC5zbG93cGF0aFxuXHQiCQkJCQkJXA0K
PiArCSJwb3AgICAlcmR4XG5cdCIJCQkJCQlcDQo+ICsJRlJBTUVfRU5ECQkJCQkJCVwNCj4g
KwlBU01fUkVUCQkJCQkJCQlcDQo+ICsJIi5zbG93cGF0aDpcblx0IgkJCQkJCVwNCj4gKwki
cHVzaCAgICVyc2lcblx0IgkJCQkJCVwNCj4gKwkibW92emJsICVhbCwlZXNpXG5cdCIJCQkJ
CQlcDQo+ICsJImNhbGwgX19yYXdfY2FsbGVlX3NhdmVfX19wdl9xdWV1ZWRfc3Bpbl91bmxv
Y2tfc2xvd3BhdGhcblx0IglcDQo+ICsJInBvcCAgICAlcnNpXG5cdCIJCQkJCQlcDQo+ICsJ
InBvcCAgICAlcmR4XG5cdCIJCQkJCQlcDQo+ICAgCUZSQU1FX0VORA0KPiAtCUFTTV9SRVQN
Cj4gLQkiLnNsb3dwYXRoOiAiDQo+IC0JInB1c2ggICAlcnNpOyINCj4gLQkibW92emJsICVh
bCwlZXNpOyINCj4gLQkiY2FsbCAiIFBWX1VOTE9DS19TTE9XUEFUSCAiOyINCj4gLQkicG9w
ICAgICVyc2k7Ig0KPiAtCSJwb3AgICAgJXJkeDsiDQo+IC0JRlJBTUVfRU5EDQo+IC0JQVNN
X1JFVA0KPiAtCSIuc2l6ZSAiIFBWX1VOTE9DSyAiLCAuLSIgUFZfVU5MT0NLICI7Ig0KPiAt
CSIucG9wc2VjdGlvbiIpOw0KPiArREVGSU5FX1BBUkFWSVJUX0FTTShfX3Jhd19jYWxsZWVf
c2F2ZV9fX3B2X3F1ZXVlZF9zcGluX3VubG9jaywgUFZfVU5MT0NLX0FTTSwNCj4gKwkJICAg
IC5zcGlubG9jay50ZXh0KTsNCj4gICANCj4gICAjZWxzZSAvKiBDT05GSUdfNjRCSVQgKi8N
Cj4gICANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9rdm0uYyBiL2FyY2gveDg2
L2tlcm5lbC9rdm0uYw0KPiBpbmRleCBkNGU0OGI0YTQzOGIuLjg1NjcwOGNjNzhlNyAxMDA2
NDQNCj4gLS0tIGEvYXJjaC94ODYva2VybmVsL2t2bS5jDQo+ICsrKyBiL2FyY2gveDg2L2tl
cm5lbC9rdm0uYw0KPiBAQCAtNzk4LDE5ICs3OTgsMTIgQEAgZXh0ZXJuIGJvb2wgX19yYXdf
Y2FsbGVlX3NhdmVfX19rdm1fdmNwdV9pc19wcmVlbXB0ZWQobG9uZyk7DQo+ICAgICogSGFu
ZC1vcHRpbWl6ZSB2ZXJzaW9uIGZvciB4ODYtNjQgdG8gYXZvaWQgOCA2NC1iaXQgcmVnaXN0
ZXIgc2F2aW5nIGFuZA0KPiAgICAqIHJlc3RvcmluZyB0by9mcm9tIHRoZSBzdGFjay4NCj4g
ICAgKi8NCj4gLWFzbSgNCj4gLSIucHVzaHNlY3Rpb24gLnRleHQ7Ig0KPiAtIi5nbG9iYWwg
X19yYXdfY2FsbGVlX3NhdmVfX19rdm1fdmNwdV9pc19wcmVlbXB0ZWQ7Ig0KPiAtIi50eXBl
IF9fcmF3X2NhbGxlZV9zYXZlX19fa3ZtX3ZjcHVfaXNfcHJlZW1wdGVkLCBAZnVuY3Rpb247
Ig0KPiAtIl9fcmF3X2NhbGxlZV9zYXZlX19fa3ZtX3ZjcHVfaXNfcHJlZW1wdGVkOiINCj4g
LUFTTV9FTkRCUg0KPiAtIm1vdnEJX19wZXJfY3B1X29mZnNldCgsJXJkaSw4KSwgJXJheDsi
DQo+IC0iY21wYgkkMCwgIiBfX3N0cmluZ2lmeShLVk1fU1RFQUxfVElNRV9wcmVlbXB0ZWQp
ICIrc3RlYWxfdGltZSglcmF4KTsiDQo+IC0ic2V0bmUJJWFsOyINCj4gLUFTTV9SRVQNCj4g
LSIuc2l6ZSBfX3Jhd19jYWxsZWVfc2F2ZV9fX2t2bV92Y3B1X2lzX3ByZWVtcHRlZCwgLi1f
X3Jhd19jYWxsZWVfc2F2ZV9fX2t2bV92Y3B1X2lzX3ByZWVtcHRlZDsiDQo+IC0iLnBvcHNl
Y3Rpb24iKTsNCj4gLQ0KPiArI2RlZmluZSBQVl9WQ1BVX1BSRUVNUFRFRF9BU00JCQkJCQkg
ICAgIFwNCj4gKyAibW92cSAgIF9fcGVyX2NwdV9vZmZzZXQoLCVyZGksOCksICVyYXhcblx0
IgkJCQkgICAgIFwNCj4gKyAiY21wYiAgICQwLCAiIF9fc3RyaW5naWZ5KEtWTV9TVEVBTF9U
SU1FX3ByZWVtcHRlZCkgIitzdGVhbF90aW1lKCVyYXgpXG5cdCIgXA0KPiArICJzZXRuZSAg
JWFsXG5cdCINCj4gK0RFRklORV9QQVJBVklSVF9BU00oX19yYXdfY2FsbGVlX3NhdmVfX19r
dm1fdmNwdV9pc19wcmVlbXB0ZWQsDQo+ICsJCSAgICBQVl9WQ1BVX1BSRUVNUFRFRF9BU00s
IC50ZXh0KTsNCj4gICAjZW5kaWYNCj4gICANCj4gICBzdGF0aWMgdm9pZCBfX2luaXQga3Zt
X2d1ZXN0X2luaXQodm9pZCkNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9wYXJh
dmlydC5jIGIvYXJjaC94ODYva2VybmVsL3BhcmF2aXJ0LmMNCj4gaW5kZXggN2NhMmQ0NmMw
OGNjLi42ZjMwNmY4ODVjYWYgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2tlcm5lbC9wYXJh
dmlydC5jDQo+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9wYXJhdmlydC5jDQo+IEBAIC0zNywy
NyArMzcsMTEgQEANCj4gICAgKiBub3Agc3R1Yiwgd2hpY2ggbXVzdCBub3QgY2xvYmJlciBh
bnl0aGluZyAqaW5jbHVkaW5nIHRoZSBzdGFjayogdG8NCj4gICAgKiBhdm9pZCBjb25mdXNp
bmcgdGhlIGVudHJ5IHByb2xvZ3Vlcy4NCj4gICAgKi8NCj4gLWV4dGVybiB2b2lkIF9wYXJh
dmlydF9ub3Aodm9pZCk7DQo+IC1hc20gKCIucHVzaHNlY3Rpb24gLmVudHJ5LnRleHQsIFwi
YXhcIlxuIg0KPiAtICAgICAiLmdsb2JhbCBfcGFyYXZpcnRfbm9wXG4iDQo+IC0gICAgICJf
cGFyYXZpcnRfbm9wOlxuXHQiDQo+IC0gICAgIEFTTV9FTkRCUg0KPiAtICAgICBBU01fUkVU
DQo+IC0gICAgICIuc2l6ZSBfcGFyYXZpcnRfbm9wLCAuIC0gX3BhcmF2aXJ0X25vcFxuXHQi
DQo+IC0gICAgICIudHlwZSBfcGFyYXZpcnRfbm9wLCBAZnVuY3Rpb25cblx0Ig0KPiAtICAg
ICAiLnBvcHNlY3Rpb24iKTsNCj4gK0RFRklORV9QQVJBVklSVF9BU00oX3BhcmF2aXJ0X25v
cCwgIiIsIC5lbnRyeS50ZXh0KTsNCj4gICANCj4gICAvKiBzdHViIGFsd2F5cyByZXR1cm5p
bmcgMC4gKi8NCj4gLWFzbSAoIi5wdXNoc2VjdGlvbiAuZW50cnkudGV4dCwgXCJheFwiXG4i
DQo+IC0gICAgICIuZ2xvYmFsIHBhcmF2aXJ0X3JldDBcbiINCj4gLSAgICAgInBhcmF2aXJ0
X3JldDA6XG5cdCINCj4gLSAgICAgQVNNX0VOREJSDQo+IC0gICAgICJ4b3IgJSIgX0FTTV9B
WCAiLCAlIiBfQVNNX0FYICI7XG5cdCINCj4gLSAgICAgQVNNX1JFVA0KPiAtICAgICAiLnNp
emUgcGFyYXZpcnRfcmV0MCwgLiAtIHBhcmF2aXJ0X3JldDBcblx0Ig0KPiAtICAgICAiLnR5
cGUgcGFyYXZpcnRfcmV0MCwgQGZ1bmN0aW9uXG5cdCINCj4gLSAgICAgIi5wb3BzZWN0aW9u
Iik7DQo+IC0NCj4gKyNkZWZpbmUgUFZfUkVUMF9BU00JInhvciAlIiBfQVNNX0FYICIsICUi
IF9BU01fQVggIlxuXHQiDQo+ICtERUZJTkVfUEFSQVZJUlRfQVNNKHBhcmF2aXJ0X3JldDAs
IFBWX1JFVDBfQVNNLCAuZW50cnkudGV4dCk7DQo+ICAgDQo+ICAgdm9pZCBfX2luaXQgZGVm
YXVsdF9iYW5uZXIodm9pZCkNCj4gICB7DQoNCg==
--------------oQfxIuLrh0ERhpdpy2dQj4wz
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------oQfxIuLrh0ERhpdpy2dQj4wz--

--------------20zTduStMkWLPE6nF0np5fEM--

--------------C6qm0TaLOIxpKjeOyN6dfJd0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmNo640FAwAAAAAACgkQsN6d1ii/Ey9f
owgAg54U+u0HeI2B0LR69f8xneNQtP09epUpydzIV+4jsDD5WxUJtdxmqpcaplt8zU5V4Ateakv5
9mUD5Pa4Q0Tpt6zGv9vTetZ6SZuzRl1ufPM8ouIjAM/m0XhQrsDV2C19G7xK8DvVoOVz7nP537la
JjohaRhKzoeMNjC6SfUuny2q1knmW+daGi5kKmHeeZzFf6M+D8hWK9b2XMy74PD54AspJUwzgT3p
OKjVS7qiuPwlpjNEBXoyCSUdOSJ1t/pGs/qdSV3KhWzj7BdeKVXZ2vGAp4S9FvIZEFIIo+VFZVVa
OJJGOFad3W+oayDZ0kchEVW5f0naRYZ4uYIVYH2VXw==
=VyTK
-----END PGP SIGNATURE-----

--------------C6qm0TaLOIxpKjeOyN6dfJd0--
