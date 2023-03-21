Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026F06C3A02
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 20:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCUTKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 15:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjCUTK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 15:10:28 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FCD241D2
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:10:13 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id q17-20020a056e020c3100b003245df8be9fso6929435ilg.14
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679425811;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hax70T3mtFxpx8y4YJVjD3ICBC5UMpIcKWg/IHMOGnU=;
        b=Mpnsylw4B8JQisU15/+hVZDibQAv1Qt9lkKAj8SWJI9Ccx9vgCgh+1bEeOKk2LoWVn
         F54JfzP729+VD8Q83ELlprLsxCOewoRkpxwQV73evl3y1w/2IaNT+KoxWgcek32CerfE
         GQV4+bCFB8FrR3iH/VdugScsWV4l6E9EbGqdsia1jQXBaak7H2rreveqxkj9ad8jnkE/
         ZFW8J/dvAJvGdsgSsVanhq64Q6LwEdBhnSQuPLkWp2VxUMUjeFg5C8znI52B9IN4kmvA
         /9l1RymJZ5CZIu4giBl1NSC+v321ZKHNEY4b4fq7jlgejJFscTe1G5ViBKZQyl8y7TvG
         shBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679425811;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Hax70T3mtFxpx8y4YJVjD3ICBC5UMpIcKWg/IHMOGnU=;
        b=WpNynVGFnfQ1HDn6Ph5a8Q3LmFeLMVzERZ/vE1XZfgNUJ/AcSJzUNSIUZFnsLwd3Xo
         9Lhj2Z6d2FiLrRLhZM8eQflBtM3xr+4yLrlgi+W/+607jCR5z+RnknKtHjjCxEqbAvjA
         rYpz78ieO82Lagt1Q6pU5hCYbP1POVeEqbt5tAQjny2CJzdiYQwvHiuw9PYEdSgsoGmL
         8FFEudOrChJy1SJGSBTpeRNUu9Xty62Y+/Lm8C75l6v5Ft+uljoqKfOGlcspSgt+m82k
         pZOwHuKTOd0bYMCak1TIeODVYgpkOIontXrPtto8rGerdkldIzLYnUQeDm/khbyDRmmh
         FY8g==
X-Gm-Message-State: AO0yUKVX2VAUh0nxyf7ApBDcRyRF8mSc02YFLg+qrtbTHZwGQnw33LQW
        58GE96kByz+LZ0gpPwHrp8oIdfcPyjfyhqkrsA==
X-Google-Smtp-Source: AK7set/hTbOWDdTK/APHNJPqPsvOmp88q/bORq2Y8aIWO+XbwQNT9cbSXsOLM7XQ/vdliedic3a0uMjxFwrmUdqlfA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6602:2982:b0:744:d7fc:7a4f with
 SMTP id o2-20020a056602298200b00744d7fc7a4fmr1611389ior.1.1679425811041; Tue,
 21 Mar 2023 12:10:11 -0700 (PDT)
Date:   Tue, 21 Mar 2023 19:10:10 +0000
In-Reply-To: <CAHVum0edWWs0cw6pTMFA_qnU++4qP=J88gyL6eSSYaLL-W9kxw@mail.gmail.com>
 (message from Vipin Sharma on Fri, 17 Mar 2023 11:16:11 -0700)
Mime-Version: 1.0
Message-ID: <gsntedphdip9.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 2/2] KVM: selftests: Print summary stats of memory
 latency distribution
From:   Colton Lewis <coltonlewis@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, shuah@kernel.org, seanjc@google.com,
        dmatlack@google.com, andrew.jones@linux.dev, maz@kernel.org,
        bgardon@google.com, ricarkol@google.com, oliver.upton@linux.dev,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VmlwaW4gU2hhcm1hIDx2aXBpbnNoQGdvb2dsZS5jb20+IHdyaXRlczoNCg0KPiBPbiBUaHUsIE1h
ciAxNiwgMjAyMyBhdCAzOjI54oCvUE0gQ29sdG9uIExld2lzIDxjb2x0b25sZXdpc0Bnb29nbGUu
Y29tPiAgDQo+IHdyb3RlOg0KDQo+PiBQcmludCBzdW1tYXJ5IHN0YXRzIG9mIHRoZSBtZW1vcnkg
bGF0ZW5jeSBkaXN0cmlidXRpb24gaW4gbmFub3NlY29uZHMNCj4+IGZvciBkaXJ0eV9sb2dfcGVy
Zl90ZXN0LiBGb3IgZXZlcnkgaXRlcmF0aW9uLCB0aGlzIHByaW50cyB0aGUgbWluaW11bSwNCj4+
IHRoZSBtYXhpbXVtLCBhbmQgdGhlIDUwdGgsIDkwdGgsIGFuZCA5OXRoIHBlcmNlbnRpbGVzLg0K
DQoNCj4gQ2FuIHlvdSBhbHNvIHdyaXRlIGhvdyB0aGlzIGlzIHVzZWZ1bCBhbmQgd2h5IHRoZXNl
IDUgc3BlY2lmaWMNCj4gcGVyY2VudGlsZXMgYXJlIHZhbHVhYmxlIGZvciB0ZXN0ZXJzPyBHZW5l
cmFsbHksIDUgbnVtYmVyIHN1bW1hcmllcw0KPiBhcmUgMCwgMjUsIDUwLCA3NSwgMTAwICVpbGUu
DQo+IEl0IG1pZ2h0IGFsc28gYmUgdG9vIG11Y2ggZGF0YSB0byBkaXNwbGF5IHdpdGggZWFjaCBp
dGVyYXRpb24uDQoNCkdlbmVyYWxseSwgd2hlbiBtZWFzdXJpbmcgbGF0ZW5jeSB5b3UgY2FyZSBt
b3JlIGFib3V0IHRoZSByaWdodCBoYWxmIG9mDQp0aGUgZGlzdHJpYnV0aW9uLiBUaGUgbGVmdCBo
YWxmIG9mIHRoZSBkaXN0cmlidXRpb24gaXMgYXNzdW1lZCB0byBiZQ0KYnVuY2hlZCBjbG9zZSB0
b2dldGhlciBhdCBzb21lIGxvdyB2YWx1ZSwgYW5kIEkgZG8gc2VlIGluIG15DQptZWFzdXJlbWVu
dHMgdGhlcmUgaXMgbm90IG11Y2ggZGlmZmVyZW5jZSBiZXR3ZWVuIHRoZSBtaW5pbXVtIGFuZCB0
aGUNCjUwdGggcGVyY2VudGlsZS4gVGhlIHJpZ2h0IGhhbGYgb2YgdGhlIGRpc3RyaWJ1dGlvbiBp
cyB3aGVyZSB0aGluZ3MNCm1pZ2h0IGJlIGdvaW5nIHdyb25nLiA1MHRoLCA5MHRoLCBvciA5OXRo
IGFyZSBjb21tb24gbWVhc3VyZXMgdG8gdGFrZSBpbg0Kb3RoZXIgY29udGV4dHMsIHNwZWNpZmlj
YWxseSBuZXR3b3JraW5nLg0KDQpPbmUgZXhhbXBsZToNCmh0dHBzOi8vY2xvdWQuZ29vZ2xlLmNv
bS9zcGFubmVyL2RvY3MvbGF0ZW5jeS1tZXRyaWNzI292ZXJ2aWV3DQoNCj4gTml0OiBtaW5pbXVt
LCA1MHRoLCA5MHRoLCA5OXRoIGFuZCBtYXhpbXVtIHNpbmNlIHRoaXMgaXMgdGhlIG9yZGVyIHlv
dQ0KPiBhcmUgcHJpbnRpbmcuDQoNCk9rLg0KDQo+PiBAQCAtNDI4LDYgKzQzMiw3IEBAIGludCBt
YWluKGludCBhcmdjLCBjaGFyICphcmd2W10pDQo+PiAgICAgICAgICAgICAgICAgIC5zbG90cyA9
IDEsDQo+PiAgICAgICAgICAgICAgICAgIC5yYW5kb21fc2VlZCA9IDEsDQo+PiAgICAgICAgICAg
ICAgICAgIC53cml0ZV9wZXJjZW50ID0gMTAwLA0KPj4gKyAgICAgICAgICAgICAgIC5zYW1wbGVz
X3Blcl92Y3B1ID0gMTAwMCwNCg0KPiBXaHkgaXMgMTAwMCB0aGUgcmlnaHQgZGVmYXVsdCBjaG9p
Y2U/IE1heWJlIHRoZSBkZWZhdWx0IHNob3VsZCBiZSAwDQo+IGFuZCBpZiBhbnlvbmUgd2FudHMg
dG8gdXNlIGl0IHRoZW4gdGhleSBjYW4gdXNlIHRoZSBjb21tYW5kIGxpbmUNCj4gb3B0aW9uIHRv
IHNldCBpdD8NCg0KR29vZCBwb2ludC4NCg0KPj4gQEAgLTQzOCw3ICs0NDMsNyBAQCBpbnQgbWFp
bihpbnQgYXJnYywgY2hhciAqYXJndltdKQ0KDQo+PiAgICAgICAgICBndWVzdF9tb2Rlc19hcHBl
bmRfZGVmYXVsdCgpOw0KDQo+PiAtICAgICAgIHdoaWxlICgob3B0ID0gZ2V0b3B0KGFyZ2MsICAN
Cj4+IGFyZ3YsICJhYjpjOmVnaGk6bTpub3A6cjpzOnY6eDp3OiIpKSAhPSAtMSkgew0KPj4gKyAg
ICAgICB3aGlsZSAoKG9wdCA9IGdldG9wdChhcmdjLCAgDQo+PiBhcmd2LCAiYWI6YzplZ2hpOm06
bm9wOnI6czpTOnY6eDp3OiIpKSAhPSAtMSkgew0KDQo+IDEuIFBsZWFzZSBhZGQgdGhlIGhlbHAg
c2VjdGlvbiB0byB0ZWxsIGFib3V0IHRoZSBuZXcgY29tbWFuZCBsaW5lIG9wdGlvbi4NCg0KVGhh
bmtzIGZvciB0aGUgcmVtaW5kZXIuDQoNCj4gMi4gSW5zdGVhZCBvZiBoYXZpbmcgcyBhbmQgUywg
aXQgbWF5IGJlIGJldHRlciB0byB1c2UgYSBkaWZmZXJlbnQNCj4gbG93ZXIgY2FzZSBsZXR0ZXIs
IGxpa2UgImwiIGZvciBsYXRlbmN5LiBHaXZpbmcgdGhpcyBvcHRpb24gd2lsbCBwcmludA0KPiBt
ZW1vcnkgbGF0ZW5jeSBhbmQgdXNlcnMgbmVlZCB0byBwcm92aWRlIHRoZSBudW1iZXIgb2Ygc2Ft
cGxlcyB0aGV5DQo+IHByZWZlciBwZXIgdkNQVS4NCg0KUHJvYmFibHkgYSBnb29kIGlkZWEuDQoN
Cj4+IEBAIC00ODAsNiArNDg1LDkgQEAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKmFyZ3ZbXSkN
Cj4+ICAgICAgICAgICAgICAgICAgY2FzZSAncyc6DQo+PiAgICAgICAgICAgICAgICAgICAgICAg
ICAgcC5iYWNraW5nX3NyYyA9IHBhcnNlX2JhY2tpbmdfc3JjX3R5cGUob3B0YXJnKTsNCj4+ICAg
ICAgICAgICAgICAgICAgICAgICAgICBicmVhazsNCj4+ICsgICAgICAgICAgICAgICBjYXNlICdT
JzoNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHAuc2FtcGxlc19wZXJfdmNwdSA9IGF0b2lf
cG9zaXRpdmUoIk51bWJlciBvZiAgDQo+PiBzYW1wbGVzL3ZjcHUiLCBvcHRhcmcpOw0KPj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQoNCj4gVGhpcyB3aWxsIGZvcmNlIHVzZXJzIHRv
IGFsd2F5cyBzZWUgbGF0ZW5jeSBzdGF0IHdoZW4gdGhleSBkbyBub3Qgd2FudA0KPiB0byBzZWUg
aXQuIEkgdGhpbmsgdGhpcyBwYXRjaCBzaG91bGQgYmUgbW9kaWZpZWQgaW4gYSB3YXkgdG8gZWFz
aWx5DQo+IGRpc2FibGUgdGhpcyBmZWF0dXJlLg0KPiBJIG1pZ2h0IGJlIHdyb25nIGhlcmUgYW5k
IGl0IGlzIGFjdHVhbGx5IGEgdXNlZnVsIG1ldHJpYyB0byBzZWUgd2l0aA0KPiBlYWNoIHJ1bi4g
SWYgdGhpcyBpcyB0cnVlIHRoZW4gbWF5YmUgdGhlIGNvbW1pdCBzaG91bGQgbWVudGlvbiB3aHkg
aXQNCj4gaXMgZ29vZCBmb3IgZWFjaCBydW4uDQoNCkl0IGdpdmVzIGFuIGV4dHJhIGxpbmUgb2Yg
aW5mb3JtYXRpb24gcGVyIHJ1bi4gVGhpcyB3b3VsZCBoZWxwIHBlb3BsZQ0KZGlzdGluZ3Vpc2gg
YmV0d2VlbiBjYXNlcyB3aGVyZSB0aGUgYXZlcmFnZSBpcyBoaWdoIGJlY2F1c2UgbW9zdA0KYWNj
ZXNzZXMgYXJlIGhpZ2ggb3IgYmVjYXVzZSBhIGEgc21hbGwgcGVyY2VudGFnZSBvZiBhY2Nlc3Nl
cyBhcmUNCipyZWFsbHkqIGhpZ2guDQoNCkJ1dCBpbiBnZW5lcmFsIEkgYWdyZWUgaXQgc2hvdWxk
IGJlIHNpbGVudCB1bmxlc3MgcmVxdWVzdGVkLg0KDQo+PiArdm9pZCBtZW1zdHJlc3NfcHJpbnRf
cGVyY2VudGlsZXMoc3RydWN0IGt2bV92bSAqdm0sIGludCBucl92Y3B1cykNCj4+ICt7DQo+PiAr
ICAgICAgIHVpbnQ2NF90IG5fc2FtcGxlcyA9IG5yX3ZjcHVzICogbWVtc3RyZXNzX2FyZ3Muc2Ft
cGxlc19wZXJfdmNwdTsNCj4+ICsgICAgICAgdWludDY0X3QgKmhvc3RfbGF0ZW5jeV9zYW1wbGVz
ID0gYWRkcl9ndmEyaHZhKHZtLCAgDQo+PiBtZW1zdHJlc3NfYXJncy5sYXRlbmN5X3NhbXBsZXMp
Ow0KPj4gKw0KPj4gKyAgICAgICBxc29ydChob3N0X2xhdGVuY3lfc2FtcGxlcywgbl9zYW1wbGVz
LCBzaXplb2YodWludDY0X3QpLCAgDQo+PiAmbWVtc3RyZXNzX3FjbXApOw0KPj4gKw0KPj4gKyAg
ICAgICBwcl9pbmZvKCJMYXRlbmN5IGRpc3RyaWJ1dGlvbiAobnMpID0gbWluOiU2LjBsZiwgNTB0
aDolNi4wbGYsICANCj4+IDkwdGg6JTYuMGxmLCA5OXRoOiU2LjBsZiwgbWF4OiU2LjBsZlxuIiwN
Cj4+ICsgICAgICAgICAgICAgICBjeWNsZXNfdG9fbnModmNwdXNbMF0sIChkb3VibGUpaG9zdF9s
YXRlbmN5X3NhbXBsZXNbMF0pLA0KDQo+IEkgYW0gbm90IG11Y2ggYXdhcmUgb2YgaG93IHRzYyBp
cyBzZXQgdXAgYW5kIHVzZWQuIFdpbGwgYWxsIHZDUFVzIGhhdmUNCj4gdGhlIHNhbWUgdHNjIHZh
bHVlPyBDYW4gdGhpcyBjaGFuZ2UgaWYgdkNQVSBnZXRzIHNjaGVkdWxlZCB0bw0KPiBkaWZmZXJl
bnQgcENQVSBvbiB0aGUgaG9zdD8NCg0KQWxsIHZDUFVzICppbiBvbmUgVk0qIHNob3VsZCBoYXZl
IHRoZSBzYW1lIGZyZXF1ZW5jeS4gVGhlIGFsdGVybmF0aXZlIGlzDQpwcm9iYWJseSBwb3NzaWJs
ZSBidXQgc28gd2VpcmQgSSBjYW4ndCBpbWFnaW5lIGEgcmVhc29uIGZvciBkb2luZyBpdC4NCg0K
Pj4gKyAgICAgICAgICAgICAgIGN5Y2xlc190b19ucyh2Y3B1c1swXSwgIA0KPj4gKGRvdWJsZSlo
b3N0X2xhdGVuY3lfc2FtcGxlc1tuX3NhbXBsZXMgLyAyXSksDQo+PiArICAgICAgICAgICAgICAg
Y3ljbGVzX3RvX25zKHZjcHVzWzBdLCAgDQo+PiAoZG91YmxlKWhvc3RfbGF0ZW5jeV9zYW1wbGVz
W25fc2FtcGxlcyAqIDkgLyAxMF0pLA0KPj4gKyAgICAgICAgICAgICAgIGN5Y2xlc190b19ucyh2
Y3B1c1swXSwgIA0KPj4gKGRvdWJsZSlob3N0X2xhdGVuY3lfc2FtcGxlc1tuX3NhbXBsZXMgKiA5
OSAvIDEwMF0pLA0KPj4gKyAgICAgICAgICAgICAgIGN5Y2xlc190b19ucyh2Y3B1c1swXSwgIA0K
Pj4gKGRvdWJsZSlob3N0X2xhdGVuY3lfc2FtcGxlc1tuX3NhbXBsZXMgLSAxXSkpOw0KPj4gK30N
Cg0KPiBBbGwgb2YgdGhlIGRpcnR5X2xvZ19wZXJmX3Rlc3RzIHByaW50IGRhdGEgaW4gc2Vjb25k
cyBmb2xsb3dlZCBieQ0KPiBuYW5vc2Vjb25kcy4gSSB3aWxsIHJlY29tbWVuZCBrZWVwaW5nIGl0
IHRoZSBzYW1lLg0KPiBBbHNvLCA5IGRpZ2l0cyBmb3IgbmFub3NlY29uZHMgaW5zdGVhZCBvZiA2
IGFzIGluIG90aGVyIGZvcm1hdHMuDQoNCkNvbnNpc3RlbmN5IGhlcmUgaXMgYSBnb29kIHRoaW5n
LiBUaGFua3MgZm9yIHBvaW50aW5nIG91dC4NCg==
