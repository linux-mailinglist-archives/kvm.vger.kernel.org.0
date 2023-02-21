Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A783969DA2B
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 05:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbjBUEpC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 23:45:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbjBUEo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 23:44:59 -0500
X-Greylist: delayed 474 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 20 Feb 2023 20:44:58 PST
Received: from xry111.site (xry111.site [IPv6:2001:470:683e::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80D42195E;
        Mon, 20 Feb 2023 20:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
        s=default; t=1676954696;
        bh=U7tebzEXNfcMfa8vjS1Fs5D6M++aN+BR4LUTQIO77CI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=luInTmqsKc0D+KACJmDSyQurJ8PqPyFyZ9kX2ZEGn6iuG+sSGL5+CuV/XMnu11FSK
         V6tBdP76qrgyDpbvcESGb+WGG7/UvxAxRRp9/8tPB8ZAD/al1AR9rgVgULhPhP5+Q6
         f5WvTPqqjQNNw1rPGe4++fbUKUq7f+X7XUJ3CxuI=
Received: from localhost.localdomain (xry111.site [IPv6:2001:470:683e::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@xry111.site)
        by xry111.site (Postfix) with ESMTPSA id D659865C56;
        Mon, 20 Feb 2023 23:44:53 -0500 (EST)
Message-ID: <497693ca2cbc443c1d9f796c3aace6c9987bec72.camel@xry111.site>
Subject: Re: [PATCH v2 05/29] LoongArch: KVM: Add vcpu related header files
From:   Xi Ruoyao <xry111@xry111.site>
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
Date:   Tue, 21 Feb 2023 12:44:52 +0800
In-Reply-To: <20230220065735.1282809-6-zhaotianrui@loongson.cn>
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
         <20230220065735.1282809-6-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTAyLTIwIGF0IDE0OjU3ICswODAwLCBUaWFucnVpIFpoYW8gd3JvdGU6Cj4g
Ky8qIEdDU1IgKi8KPiArc3RhdGljIGlubGluZSB1NjQgZ2Nzcl9yZWFkKHUzMiByZWcpCj4gK3sK
PiArwqDCoMKgwqDCoMKgwqB1NjQgdmFsID0gMDsKPiArCj4gK8KgwqDCoMKgwqDCoMKgYXNtIHZv
bGF0aWxlICgKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgInBhcnNlX3IgX19yZWcs
ICVbdmFsXVxuXHQiCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCIud29yZCAweDUg
PDwgMjQgfCAlW3JlZ10gPDwgMTAgfCAwIDw8IDUgfCBfX3JlZ1xuXHQiCgpEb24ndCBkbyB0aGlz
LiAgWW91IHNob3VsZCBhZGQgdGhlIGluc3RydWN0aW9uIHRvIGJpbnV0aWxzIGZpcnN0LCB0aGVu
Cm1ha2UgQ09ORklHX0tWTSBkZXBlbmQgb24gdGhlIGFzc2VtYmxlciBzdXBwb3J0aW5nIHRoaXMg
aW5zdHJ1Y3Rpb24uIApUaGlzIGlzIGNvbXBsZXRlbHkgdW5yZWFkYWJsZSBhbmQgb25seSBmaW5l
IGZvciBhbiBpbnRlcm5hbCBQb0MuCgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqA6
IFt2YWxdICIrciIgKHZhbCkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgOiBbcmVn
XSAiaSIgKHJlZykKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgOiAibWVtb3J5Iik7
Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoHJldHVybiB2YWw7Cj4gK30KCi0tIApYaSBSdW95YW8gPHhy
eTExMUB4cnkxMTEuc2l0ZT4KU2Nob29sIG9mIEFlcm9zcGFjZSBTY2llbmNlIGFuZCBUZWNobm9s
b2d5LCBYaWRpYW4gVW5pdmVyc2l0eQo=

