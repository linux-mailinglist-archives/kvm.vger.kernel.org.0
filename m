Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08496613AF8
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 17:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbiJaQGA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 12:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiJaQF7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 12:05:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB63DD64
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 09:05:57 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l188-20020a2525c5000000b006cbcff0ab41so10717213ybl.4
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 09:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/12G0cGGAlAZZidbTOixqTDXBJ6XtzErz0m29GnuW2Q=;
        b=cBebUsSr+YP3CyBkCd7nmnQY2gskNdaMDphaqF2Qk6om62SHnD6PX5djlCzMvu9iFb
         iUh3zl0HANxVZLkGwIgxi+LUYgPx90cEAU+jPprDnsJWDYWWaVX3bNx4DbErg/qmH3R1
         SAw+MC3JUcPWEILO2z5Qh5VGFI3SKCvnxcK57J2HswL8it7+BtITFnIEf/8OhicrOqbi
         G15b9TbWYioj4V2FL7+uaTFlTnSkyyBNVCMfChGDRO+iZeOLQXd3Vdn6pYeoqHiChExX
         ZKlynK+tchc1ddQ43XuOG+tZNM1r1PKzTwPLHPtVnbZZtlyYSwTsLqPmdjXIKcKL3SC0
         wZ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/12G0cGGAlAZZidbTOixqTDXBJ6XtzErz0m29GnuW2Q=;
        b=m91HReyFeXFleTAZBksySiZ/J5DxSRqv96Ac+2Lb0ZYZZIFayGhnjVKRMhR1PdBoJ2
         sykhcQphH396xEj5loCNIONS3YC4kZSaD9Yoms6M2K16oShGXPUEFX3DOCrDSR8qbgzw
         VCR1DDV4oe8swXUP8C/MbJ7PxIgvumfUT0WmmaB7F3pcbI19b1SXrAtly4FbPEL/rHU8
         duThrnxLoODI9sYpHte7CEKwcNZu5NBiQAEtAclp6e6hVJ7twz80YFW7/3qDYmVf3KNa
         B4j3Q9RfURIQT4ZmapnCoGoFWsyQRKGNdIWLClC9C5cgAPq7XyYHAt5Ej4+Rrkpb2Zuk
         HsGA==
X-Gm-Message-State: ACrzQf1oy6gcLGG6xZ6a1QXctmTIAfrHB2jP8WbIyqRk3XCTf6Qpn+19
        LdbhFWUTcDC8FxaG4RlZQGYX1UHNQP7QX3lXcw==
X-Google-Smtp-Source: AMsMyM75dfSKv4Y9vaZAqjPFsr+/7ZCvzkGMeqcBdZyLJzK3F9F02jmsFDBPYiOxmePJPJZFTlAdvxn1pYVhiYI4uA==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:7d84:0:b0:6cc:9bc5:afe5 with SMTP
 id y126-20020a257d84000000b006cc9bc5afe5mr0ybc.346.1667232356410; Mon, 31 Oct
 2022 09:05:56 -0700 (PDT)
Date:   Mon, 31 Oct 2022 16:05:55 +0000
In-Reply-To: <Y1xAXtnQyTqbIMVE@google.com> (message from Sean Christopherson
 on Fri, 28 Oct 2022 20:49:34 +0000)
Mime-Version: 1.0
Message-ID: <gsntsfj40yho.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v8 2/4] KVM: selftests: create -r argument to specify
 random seed
From:   Colton Lewis <coltonlewis@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com
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

U2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+IHdyaXRlczoNCg0KPiBPbiBU
aHUsIE9jdCAyNywgMjAyMiwgQ29sdG9uIExld2lzIHdyb3RlOg0KPj4gZGlmZiAtLWdpdCBhL3Rv
b2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9saWIvcGVyZl90ZXN0X3V0aWwuYyAgDQo+PiBiL3Rv
b2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9saWIvcGVyZl90ZXN0X3V0aWwuYw0KPj4gaW5kZXgg
OTYxOGIzN2M2NmY3Li41ZjBlZWJiNjI2YjUgMTAwNjQ0DQo+PiAtLS0gYS90b29scy90ZXN0aW5n
L3NlbGZ0ZXN0cy9rdm0vbGliL3BlcmZfdGVzdF91dGlsLmMNCj4+ICsrKyBiL3Rvb2xzL3Rlc3Rp
bmcvc2VsZnRlc3RzL2t2bS9saWIvcGVyZl90ZXN0X3V0aWwuYw0KPj4gQEAgLTQ5LDYgKzQ5LDcg
QEAgdm9pZCBwZXJmX3Rlc3RfZ3Vlc3RfY29kZSh1aW50MzJfdCB2Y3B1X2lkeCkNCj4+ICAgCXVp
bnQ2NF90IGd2YTsNCj4+ICAgCXVpbnQ2NF90IHBhZ2VzOw0KPj4gICAJaW50IGk7DQo+PiArCXN0
cnVjdCBndWVzdF9yYW5kb21fc3RhdGUgcmFuZF9zdGF0ZSA9ICANCj4+IG5ld19ndWVzdF9yYW5k
b21fc3RhdGUocHRhLT5yYW5kb21fc2VlZCArIHZjcHVfaWR4KTsNCg0KPiBUaGlzIGJlbG9uZyBp
biB0aGUgZmlyc3QgcGF0Y2ggdGhhdCBjb25zdW1lcyByYW5kX3N0YXRlLCB3aGljaCBJIGJlbGll
dmUgIA0KPiBpcyBwYXRjaCAzLg0KDQo+IGxpYi9wZXJmX3Rlc3RfdXRpbC5jOiBJbiBmdW5jdGlv
biDigJhwZXJmX3Rlc3RfZ3Vlc3RfY29kZeKAmToNCj4gbGliL3BlcmZfdGVzdF91dGlsLmM6NTI6
MzU6IGVycm9yOiB1bnVzZWQgdmFyaWFibGUg4oCYcmFuZF9zdGF0ZeKAmSAgDQo+IFstV2Vycm9y
PXVudXNlZC12YXJpYWJsZV0NCj4gICAgIDUyIHwgICAgICAgICBzdHJ1Y3QgZ3Vlc3RfcmFuZG9t
X3N0YXRlIHJhbmRfc3RhdGUgPSAgDQo+IG5ld19ndWVzdF9yYW5kb21fc3RhdGUocHRhLT5yYW5k
b21fc2VlZCArIHZjcHVfaWR4KTsNCj4gICAgICAgIHwNCg0KV2lsbCBkby4gRm9yZ290IHRoaXMg
cGFydCB3aGVuIHNwbGl0dGluZyB0aGUgZmlyc3QgY29tbWl0LiBXaWxsIGFsc28NCmJyZWFrIGl0
IGludG8gdHdvIGxpbmVzIGZvciB0aGUgbGluZSBsZW5naHQgcmVhc29uIHlvdXIgb3RoZXIgZW1h
aWwuDQo=
