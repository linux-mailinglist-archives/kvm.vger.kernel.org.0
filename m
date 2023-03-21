Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600516C39E7
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 20:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjCUTJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 15:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjCUTJT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 15:09:19 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D63D1815C
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:09:17 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3-20020a250b03000000b00b5f1fab9897so16438978ybl.19
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679425756;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+pGykjt6F4E3l1/6M5oUp5XVFCEZApu+lPKmc7WsvFA=;
        b=q9TEkmeHlgXiwmVXN6P4+eU6rF4b6zggX5s0To1tcOOvjvUiJmW7S4ji9Fu9Vsg6OT
         C4ekWp5K4iJum5B70eb4m9l3unLlcBCiFmqYjfaPS/pCxQogQyScpIOIsEgZaH7B6jBA
         yph4ONmdjvZP2GmUcfitu+Wm0P/e3Qe+3WdjB2llWgEVAWob0LsZWaaKBleKveXimcsU
         2Jo/A8Mr8b/cO60wTBKf8JMdxNjCdyTEDN+AAprUPdhu5TBH61PUYQNWMMs6IEmaq1Ak
         /Jcl+N25k3H379Xwl8lh9Ur2GkTSKQ6TtNtPUWSshkshkvxAEJX/4vC/ckf2PiYWZZ/J
         i41w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679425756;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+pGykjt6F4E3l1/6M5oUp5XVFCEZApu+lPKmc7WsvFA=;
        b=fHH63MxcEl7EMS5eT/wgc2yVpN9Qha7QMZjiz0uWR83Yo2UkVrbkfc0Q1SZp9+tjKm
         RIB6aMqY+w3hUqm3pF13Vp3FagIKvz9Vk54kqCXvd/C1cNO1GiIc8L4+3Ur5jK2ppyW5
         QVjuPr0nXJrFIZMfC6xcz4B+W43Y2sOOd0MyOQdSwx69chPIjaIUfNwbSiKHIwwAzRrB
         NeraEw0+p3Y9OHegEA0N5LGDh6zQpmJ50tPL4I+GgT3cFBJwLb0NYj0T8wbdMcxiYauM
         q/ST6dVfIw2Cl25IWqMvK+jDpQ94nb1Y/ytiOqV9c3mchu2s+nsZmD5gPcVRAu6Tybgp
         NC6w==
X-Gm-Message-State: AAQBX9ev1xKyyIHSJpRQ082Aak811P7sfhWTaHmbmlhVlFTFDtEENWOU
        Drihsq/qL/ThnlCSZpaZXBsTwEhUkYNxxiuqEA==
X-Google-Smtp-Source: AKy350aNpXU3HBoHOW+Px8rtJHowHzsnDQjm0cMaD+flZhqunoFot/rMBHFPlmyZYUR0nXoLcL9S0uZ3jvBzn4Bhxg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:707:b0:b48:5eaa:a804 with
 SMTP id k7-20020a056902070700b00b485eaaa804mr2038934ybt.0.1679425756485; Tue,
 21 Mar 2023 12:09:16 -0700 (PDT)
Date:   Tue, 21 Mar 2023 19:09:15 +0000
In-Reply-To: <CAHVum0diwWqa38naQaybdJVszKHcxPiHj8a7T305h2TNER35Ew@mail.gmail.com>
 (message from Vipin Sharma on Fri, 17 Mar 2023 10:04:43 -0700)
Mime-Version: 1.0
Message-ID: <gsnth6uddiqs.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 1/2] KVM: selftests: Provide generic way to read system counter
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
Y29tPiAgDQo+IHdyb3RlOg0KDQo+PiBQcm92aWRlIGEgZ2VuZXJpYyBmdW5jdGlvbiB0byByZWFk
IHRoZSBzeXN0ZW0gY291bnRlciBmcm9tIHRoZSBndWVzdA0KPj4gZm9yIHRpbWluZyBwdXJwb3Nl
cy4gQSBjb21tb24gYW5kIGltcG9ydGFudCB3YXkgdG8gbWVhc3VyZSBndWVzdA0KPj4gcGVyZm9y
bWFuY2UgaXMgdG8gbWVhc3VyZSB0aGUgYW1vdW50IG9mIHRpbWUgZGlmZmVyZW50IGFjdGlvbnMg
dGFrZSBpbg0KPj4gdGhlIGd1ZXN0LiBQcm92aWRlIGFsc28gYSBtYXRoZW1hdGljYWwgY29udmVy
c2lvbiBmcm9tIGN5Y2xlcyB0bw0KPj4gbmFub3NlY29uZHMgYW5kIGEgbWFjcm8gZm9yIHRpbWlu
ZyBpbmRpdmlkdWFsIHN0YXRlbWVudHMuDQoNCj4+IFN1YnN0aXR1dGUgdGhlIHByZXZpb3VzIGN1
c3RvbSBpbXBsZW1lbnRhdGlvbiBvZiBhIHNpbWlsYXIgZnVuY3Rpb24gaW4NCg0KPiBNYXkgYmUg
c3BlY2lmeSBzcGVjaWZpYyBuYW1lOiAgZ3Vlc3RfcmVhZF9zeXN0ZW1fY291bnRlcigpDQoNCldp
bGwgZG8uDQoNCj4+ICsjZGVmaW5lIE1FQVNVUkVfQ1lDTEVTKHgpICAgICAgICAgICAgICAgICAg
ICAgIFwNCj4+ICsgICAgICAgKHsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IFwNCj4+ICsgICAgICAgICAgICAgICB1aW50NjRfdCBzdGFydDsgICAgICAgICAgICAgICAgIFwN
Cj4+ICsgICAgICAgICAgICAgICBzdGFydCA9IGN5Y2xlc19yZWFkKCk7ICAgICAgICAgIFwNCj4+
ICsgICAgICAgICAgICAgICB4OyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4+ICsg
ICAgICAgICAgICAgICBjeWNsZXNfcmVhZCgpIC0gc3RhcnQ7ICAgICAgICAgIFwNCj4+ICsgICAg
ICAgfSkNCj4+ICsNCg0KPiBNRUFTVVJFX0NZQ0xFUyBzaG91bGQgYmUgbW92ZWQgdG8gdGhlIG5l
eHQgcGF0Y2ggd2hlcmUgaXQgaXMgZ2V0dGluZw0KPiB1c2VkLiBEb2VzIGl0IGhhdmUgdG8gYmUg
bWFjcm8gb3IgY2FuIGl0IGJlIHJlcGxhY2VkIHdpdGggYSBmdW5jdGlvbj8NCg0KV2lsbCBtb3Zl
IHRvIHRoZSBuZXh0IHBhdGNoLiBJdCBjYW4ndCBiZSByZXBsYWNlZCBieSBhIGZ1bmN0aW9uIGJl
Y2F1c2UNCnRoZW4gJ3gnIHdvdWxkIGJlIGV4ZWN1dGVkIGJlZm9yZSB0aGUgZnVuY3Rpb24gYmVn
aW5zIGFuZCB0aGVyZSB3b3VsZCBiZQ0Kbm90aGluZyBsZWZ0IHRvIG1lYXN1cmUuDQo=
