Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2050E4DA584
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 23:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352314AbiCOWmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 18:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352305AbiCOWmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 18:42:39 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5915D5C8
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 15:41:26 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id z16so1257888pfh.3
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 15:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LDxK/xi7kYY9tmPdyRz28nRjjbfnzSTylZ2lhhKTPXk=;
        b=sUf+nm8vjmNbUAtPL2AR6ZApsYGsLRgv5MM0cr7Ja39tfGmJ4yMWWrhgJeyHZqgggS
         UYjfKVPbb99KayMwn/imKckbSVm/hGUUQN9c/rhVAz+/mYlqAiQzq6EDqOJMrt04mX0Q
         PoPGju0IZtwgGA3RISA2z01k43sMYR2tNGPWfBXQKB0RyyeKRTLE/Iwya2EJ7ioupL2l
         4vQXuI7mXL8x2E+Uz/h8/nLWetwur9Ve5jJ7Z73sPyHSsnNpp2RtFuqYnucYs5eoN159
         yxAwRMSF8EUxXafYPgpS7S0xL0JGNKLe94xL0rEBAGGK6OigDJaQgQArk1PM4qfum2Cx
         fs8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LDxK/xi7kYY9tmPdyRz28nRjjbfnzSTylZ2lhhKTPXk=;
        b=kUVoiwLjZKtzDoRzblL53i7OtglRwSj1T0CYtRId4p0wu2PgW0Qhx7hPnCzxQw506V
         oPvTFKm0w8gA/JOLcAMbIWhEHL8COwT0agqIZCZhZ4W+b6N3X/oVvBjhFbIR6jJavKcu
         EB5h0JU8bS8GjdjGzxIWnnqc5xWliIEZ3JfVjIJaj3e//SXf7S64xDGAyMU/WSF9ukJe
         YH3nLvC5K7JrvRsvWdT4sFlgha96jP57gm1vb67DE8jWoYsVGhmL7lHzf+leKlPGu2aO
         lNuOYfw8xWQjuagmJo/tvonQBhWdQtmHLoiBqMed4nQ0wmetf/a9tmFJaEQD85ugXNDj
         2hYw==
X-Gm-Message-State: AOAM531G1m50IWXUqCYoi1WaZylNntzK4zAYmy+74W7NlPPGf8HYnqsE
        PfnjagOm7D2Su7vYsjjgTBjjnQ==
X-Google-Smtp-Source: ABdhPJz/dgdutvWHvVq0ljcWISsh0FoaUzN895aVcdgT/4ZucZW+zp+WPouMKfev/ndQL7N2cX98qg==
X-Received: by 2002:aa7:8432:0:b0:4f6:6dcd:4f19 with SMTP id q18-20020aa78432000000b004f66dcd4f19mr31222248pfn.53.1647384085703;
        Tue, 15 Mar 2022 15:41:25 -0700 (PDT)
Received: from ?IPV6:2600:1700:38d4:55df:2366:8a7e:9fa2:44e6? ([2600:1700:38d4:55df:2366:8a7e:9fa2:44e6])
        by smtp.gmail.com with ESMTPSA id d6-20020a17090a6f0600b001c64b1bcd50sm229582pjk.39.2022.03.15.15.41.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 15:41:25 -0700 (PDT)
Message-ID: <87db9dbe-c7f1-deec-9c24-7d4bda406f2c@google.com>
Date:   Tue, 15 Mar 2022 15:41:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [RFC PATCH 04/47] mm: asi: ASI support in interrupts/exceptions
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, luto@kernel.org, linux-mm@kvack.org
References: <20220223052223.1202152-1-junaids@google.com>
 <20220223052223.1202152-5-junaids@google.com> <87pmmofs83.ffs@tglx>
 <9f2f1226-f398-f132-06f4-c21a2a2d1033@google.com> <877d8v74tw.ffs@tglx>
From:   Junaid Shahid <junaids@google.com>
In-Reply-To: <877d8v74tw.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgVGhvbWFzLA0KDQpPbiAzLzE1LzIyIDA1OjU1LCBUaG9tYXMgR2xlaXhuZXIgd3JvdGU6
DQo+Pj4NCj4+PiBUaGlzIGlzIHdyb25nLiBZb3UgY2Fubm90IGludm9rZSBhcmJpdHJhcnkg
Y29kZSB3aXRoaW4gYSBub2luc3RyDQo+Pj4gc2VjdGlvbi4NCj4+Pg0KPj4+IFBsZWFzZSBl
bmFibGUgQ09ORklHX1ZNTElOVVhfVkFMSURBVElPTiBhbmQgd2F0Y2ggdGhlIGJ1aWxkIHJl
c3VsdCB3aXRoDQo+Pj4gYW5kIHdpdGhvdXQgeW91ciBwYXRjaGVzLg0KPj4+DQo+PiBUaGFu
ayB5b3UgZm9yIHRoZSBwb2ludGVyLiBJdCBzZWVtcyB0aGF0IG1hcmtpbmcgYXNpX2ludHJf
ZW50ZXIvZXhpdA0KPj4gYW5kIGFzaV9lbnRlci9leGl0LCBhbmQgdGhlIGZldyBmdW5jdGlv
bnMgdGhhdCB0aGV5IGluIHR1cm4gY2FsbCwgYXMNCj4+IG5vaW5zdHIgd291bGQgZml4IHRo
aXMsIGNvcnJlY3Q/IChBbG9uZyB3aXRoIHJlbW92aW5nIHRoZSBWTV9CVUdfT05zDQo+PiBm
cm9tIHRob3NlIGZ1bmN0aW9ucyBhbmQgdXNpbmcgbm90cmFjZS9ub2RlYnVnIHZhcmlhbnRz
IG9mIGEgY291cGxlIG9mDQo+PiBmdW5jdGlvbnMpLg0KPiANCj4geW91IGNhbiBrZWVwIHRo
ZSBCVUdfT04oKXMuIElmIHN1Y2ggYSBidWcgaGFwcGVucyB0aGUgbm9pbnN0cg0KPiBjb3Jy
ZWN0bmVzcyBpcyB0aGUgbGVhc3Qgb2YgeW91ciB3b3JyaWVzLCBidXQgaXQncyBpbXBvcnRh
bnQgdG8gZ2V0IHRoZQ0KPiBpbmZvcm1hdGlvbiBvdXQsIHJpZ2h0Pw0KDQpZZXMsIHRoYXQg
bWFrZXMgc2Vuc2UgOikNCg0KPiANCj4gVnMuIGFkZGluZyBub2luc3RyLiBZZXMsIG1ha2lu
ZyB0aGUgZnVsbCBjYWxsY2hhaW4gbm9pbnN0ciBpcyBnb2luZyB0bw0KPiBjdXJlIGl0LCBi
dXQgeW91IHJlYWxseSB3YW50IHRvIHRoaW5rIGhhcmQgd2hldGhlciB0aGVzZSBjYWxscyBu
ZWVkIHRvDQo+IGJlIGluIHRoaXMgc2VjdGlvbiBvZiB0aGUgZXhjZXB0aW9uIGhhbmRsZXJz
Lg0KPiANCj4gVGhlc2UgY29kZSBzZWN0aW9ucyBoYXZlIG90aGVyIGNvbnN0cmFpbnRzIGFz
aWRlIG9mIGJlaW5nIGV4Y2x1ZGVkIGZyb20NCj4gaW5zdHJ1bWVudGF0aW9uLCB0aGUgbWFp
biBvbmUgYmVpbmcgdGhhdCB5b3UgY2Fubm90IHVzZSBSQ1UgdGhlcmUuDQoNCk5laXRoZXIg
b2YgdGhlc2UgZnVuY3Rpb25zIG5lZWQgdG8gdXNlIFJDVSwgc28gdGhhdCBzaG91bGQgYmUg
b2suIEFyZSB0aGVyZSBhbnkgb3RoZXIgY29uc3RyYWludHMgdGhhdCBjb3VsZCBtYXR0ZXIg
aGVyZT8NCg0KPiANCj4gSSdtIG5vdCB5ZXQgY29udmluY2VkIHRoYXQgYXNpX2ludHJfZW50
ZXIoKS9leGl0KCkgbmVlZCB0byBiZSBpbnZva2VkIGluDQo+IGV4YWN0bHkgdGhlIHBsYWNl
cyB5b3UgcHV0IGl0LiBUaGUgY2hhbmdlbG9nIGRvZXMgbm90IGdpdmUgYW55IGNsdWUNCj4g
YWJvdXQgdGhlIHdoeS4uLg0KDQpJIGhhZCB0byBwbGFjZSB0aGVzZSBjYWxscyBlYXJseSBp
biB0aGUgZXhjZXB0aW9uL2ludGVycnVwdCBoYW5kbGVycyBhbmQgc3BlY2lmaWNhbGx5IGJl
Zm9yZSB0aGUgcG9pbnQgd2hlcmUgdGhpbmdzIGxpa2UgdHJhY2luZyBhbmQgbG9ja2RlcCBl
dGMuIGNhbiBiZSB1c2VkIChhbmQgYWZ0ZXIgdGhlIHBvaW50IHdoZXJlIHRoZXkgY2FuIG5v
IGxvbmdlciBiZSB1c2VkLCBmb3IgdGhlIGFzaV9pbnRyX2V4aXQoKSBjYWxscykuIE90aGVy
d2lzZSwgd2Ugd291bGQgbmVlZCB0byBtYXAgYWxsIGRhdGEgc3RydWN0dXJlcyB0b3VjaGVk
IGJ5IHRoZSB0cmFjaW5nL2xvY2tkZXAgaW5mcmFzdHJ1Y3R1cmUgaW50byB0aGUgQVNJIHJl
c3RyaWN0ZWQgYWRkcmVzcyBzcGFjZXMuDQoNCkJhc2ljYWxseSwgaW4gZ2VuZXJhbCwgaWYg
d2hpbGUgcnVubmluZyBpbiBhIHJlc3RyaWN0ZWQgYWRkcmVzcyBzcGFjZSwgc29tZSBrZXJu
ZWwgY29kZSB0b3VjaGVzIHNvbWUgbWVtb3J5IHdoaWNoIGlzIG5vdCBtYXBwZWQgaW4gdGhl
IHJlc3RyaWN0ZWQgYWRkcmVzcyBzcGFjZSwgaXQgd2lsbCB0YWtlIGFuIGltcGxpY2l0IEFT
SSBFeGl0IHZpYSB0aGUgcGFnZSBmYXVsdCBoYW5kbGVyIGFuZCBjb250aW51ZSBydW5uaW5n
LCBzbyBpdCB3b3VsZCBqdXN0IGJlIGEgc21hbGwgcGVyZm9ybWFuY2UgaGl0LCBidXQgbm90
IGEgZmF0YWwgaXNzdWUuIEJ1dCB0aGVyZSBhcmUgMyBjcml0aWNhbCBjb2RlIHJlZ2lvbnMg
d2hlcmUgdGhpcyBpbXBsaWNpdCBBU0kgRXhpdCBtZWNoYW5pc20gZG9lc24ndCBhcHBseS4g
VGhlIGZpcnN0IGlzIHRoZSByZWdpb24gYmV0d2VlbiBhbiBhc2lfZW50ZXIoKSBjYWxsIGFu
ZCB0aGUgYXNpX3NldF90YXJnZXRfdW5yZXN0cmljdGVkKCkgY2FsbC4gVGhlIHNlY29uZCBp
cyB0aGUgcmVnaW9uIGJldHdlZW4gdGhlIHN0YXJ0IG9mIGFuIGludGVycnVwdC9leGNlcHRp
b24gaGFuZGxlciBhbmQgdGhlIGFzaV9pbnRyX2VudGVyKCkgY2FsbCwgYW5kIHRoZSB0aGly
ZCBpcyB0aGUgcmVnaW9uIGJldHdlZW4gdGhlIGFzaV9pbnRyX2V4aXQoKSBjYWxsIGFuZCB0
aGUgSVJFVC4gU28gYW55IG1lbW9yeSB0aGF0IGlzIGFjY2Vzc2VkIGJ5IHRoZSBjb2RlIGlu
IHRoZXNlIHJlZ2lvbnMgaGFzIHRvIGJlIG1hcHBlZCBpbiB0aGUgcmVzdHJpY3RlZCBhZGRy
ZXNzIHNwYWNlLCB3aGljaCBpcyB3aHkgSSB0cmllZCB0byBwbGFjZSB0aGUgYXNpX2ludHJf
ZW50ZXIvZXhpdCBjYWxscyBmYWlybHkgZWFybHkvbGF0ZSBpbiB0aGUgaGFuZGxlcnMuIEl0
IGlzIHBvc3NpYmxlIHRvIG1vdmUgdGhlbSBmdXJ0aGVyIGluLCBidXQgaWYgd2UgYWNjaWRl
bnRhbGx5IG1pc3MgYW5ub3RhdGluZyBzb21lIGRhdGEgbmVlZGVkIGluIHRoYXQgcmVnaW9u
LCB0aGVuIGl0IGNvdWxkIHBvdGVudGlhbGx5IGJlIGZhdGFsIGluIHNvbWUgc2l0dWF0aW9u
cy4NCg0KVGhhbmtzLA0KSnVuYWlkDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+ICAgICAgICAg
IHRnbHgNCj4gDQo+IA0KPiANCg0K
