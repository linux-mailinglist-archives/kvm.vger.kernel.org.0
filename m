Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C91E70A348
	for <lists+kvm@lfdr.de>; Sat, 20 May 2023 01:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjESXZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 19:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjESXZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 19:25:26 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CC4E6A
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 16:25:20 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-25372604818so1362957a91.2
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 16:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684538720; x=1687130720;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YWydhYAUUM0h6IOB1teV/5zjmeQJcljpW/F65iNBE98=;
        b=fFOksPQ4eh0j1TWMakEwwKd+G5zWm/T/kQVPOeK2AHKyfOqoolmhmysoo9LCDMX7vU
         urzp3H4qVWXzFwPoH033IdBSAWbzGQv7jm4pBqLTO+Ztw1QVv4a26hpDXl98eyTKmeNr
         jCR2IviRj5u9uYEq32xdPqem036cjUaBVt9tITDjjeFHDGMHS1tffF2IgYWESwv7XxH3
         9HKZX4OQx6rUtqaq4l7g18eP/ldNjEeQGxLT5R8ceuI1vSAkUuatyiyj+iQVo6gboxNW
         36dJZ5LLgFAsJwOuqLmh/jdmFueV9xq7QbEFPnrJOJtuj12R0bqXT8qLeaZMK6YPTZ0Z
         nfNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684538720; x=1687130720;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YWydhYAUUM0h6IOB1teV/5zjmeQJcljpW/F65iNBE98=;
        b=FLk3kjeLmwAq7TuVKdYmbJB3UWMcMkyJ9Z5DzA+SvY0DsjxKY+SbGSf3VK/+Om07Nf
         uZauq0yY4cphQ6ZXFyJkqyt9L02C8uaYIIT/2M87451RFiz2a2JPUb/vcMhizIfjhdWl
         NHXhDokH6M71ktVM7iewN7gDpCqDW0m//qsp+XcDyI93XE+nl5/sY33tqyRgu+FhUfbu
         EXHulBY7qChGN4nHYNzIQ8u8W7/l3dTJS9i7pOGPw8wX2PKq8HQCM5KLvGyBTqphYyZm
         gzprpNSQkvZDUJ+V0nkbAu3dbi+/HTK8lD9xOatxStw/yEeUTuCZ5aOb0C13kVv2mMUh
         bYXA==
X-Gm-Message-State: AC+VfDzQk+pLCutOPcuKHF8+nyelSF7o9wjtrc9s6pR7HzDuw4kt7fKa
        lzD7XYYcRge28wK+kVJIcq4=
X-Google-Smtp-Source: ACHHUZ76MI8MZrrm/JMipNVoojpooSQ2ZgXhICgmyrh8kpPilZnv69oGJOsGhKgjrOqTNUyqTFABYQ==
X-Received: by 2002:a17:90b:1a8e:b0:250:a4f5:fb34 with SMTP id ng14-20020a17090b1a8e00b00250a4f5fb34mr3627174pjb.2.1684538719967;
        Fri, 19 May 2023 16:25:19 -0700 (PDT)
Received: from edge-m3-r3-209.e-iad51.amazon.com ([205.251.233.182])
        by smtp.googlemail.com with ESMTPSA id s5-20020a17090a2f0500b0025393752cd5sm2323437pjd.1.2023.05.19.16.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 16:25:19 -0700 (PDT)
Message-ID: <d6ae3e6b5a3d86aa1a6c862bc5751effc65212cd.camel@gmail.com>
Subject: Re: [PATCH v8 6/6] KVM: arm64: Refactor writings for
 PMUVer/CSV2/CSV3
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Date:   Fri, 19 May 2023 16:25:18 -0700
In-Reply-To: <20230503171618.2020461-7-jingzhangos@google.com>
References: <20230503171618.2020461-1-jingzhangos@google.com>
         <20230503171618.2020461-7-jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTA1LTAzIGF0IDE3OjE2ICswMDAwLCBKaW5nIFpoYW5nIHdyb3RlOgo+IFJl
ZmFjdG9yIHdyaXRpbmdzIGZvciBJRF9BQTY0UEZSMF9FTDEuW0NTVjJ8Q1NWM10sCj4gSURfQUE2
NERGUjBfRUwxLlBNVVZlciBhbmQgSURfREZSMF9FTEYuUGVyZk1vbiBiYXNlZCBvbiB1dGlsaXRp
ZXMKPiBpbnRyb2R1Y2VkIGJ5IElEIHJlZ2lzdGVyIGRlc2NyaXB0b3IgYXJyYXkuCj4gCj4gU2ln
bmVkLW9mZi1ieTogSmluZyBaaGFuZyA8amluZ3poYW5nb3NAZ29vZ2xlLmNvbT4KCkhpLAoKPiAt
LS0KPiDCoGFyY2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZS5oIHzCoMKgIDEgKwo+IMKg
YXJjaC9hcm02NC9rZXJuZWwvY3B1ZmVhdHVyZS5jwqDCoMKgwqDCoCB8wqDCoCAyICstCj4gwqBh
cmNoL2FybTY0L2t2bS9pZF9yZWdzLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMzYxICsrKysr
KysrKysrKysrKysrKy0tLS0tLS0tCj4gLS0KPiDCoDMgZmlsZXMgY2hhbmdlZCwgMjQyIGluc2Vy
dGlvbnMoKyksIDEyMiBkZWxldGlvbnMoLSkKPiAKPiAKClsgc25pcCBdCgo+IGRpZmYgLS1naXQg
YS9hcmNoL2FybTY0L2t2bS9pZF9yZWdzLmMgYi9hcmNoL2FybTY0L2t2bS9pZF9yZWdzLmMKPiBp
bmRleCA2NGQ0MGFhMzk1YmUuLjZjZDU2YzllNjQyOCAxMDA2NDQKPiAtLS0gYS9hcmNoL2FybTY0
L2t2bS9pZF9yZWdzLmMKPiArKysgYi9hcmNoL2FybTY0L2t2bS9pZF9yZWdzLmMKPiBAQCAtMTgs
NiArMTgsODYgQEAKPiDCoAo+IMKgI2luY2x1ZGUgInN5c19yZWdzLmgiCj4gwqAKPiBbIHNuaXAg
XQo+IMKgCj4gK3N0YXRpYyB1NjQgcmVhZF9zYW5pdGlzZWRfaWRfYWE2NHBmcjBfZWwxKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY29uc3Qgc3RydWN0
IHN5c19yZWdfZGVzYwo+ICpyZCkKPiArewo+ICvCoMKgwqDCoMKgwqDCoHU2NCB2YWw7Cj4gK8Kg
wqDCoMKgwqDCoMKgdTMyIGlkID0gcmVnX3RvX2VuY29kaW5nKHJkKTsKPiArCj4gK8KgwqDCoMKg
wqDCoMKgdmFsID0gcmVhZF9zYW5pdGlzZWRfZnRyX3JlZyhpZCk7Cj4gK8KgwqDCoMKgwqDCoMKg
LyoKPiArwqDCoMKgwqDCoMKgwqAgKiBUaGUgZGVmYXVsdCBpcyB0byBleHBvc2UgQ1NWMiA9PSAx
IGlmIHRoZSBIVyBpc24ndAo+IGFmZmVjdGVkLgo+ICvCoMKgwqDCoMKgwqDCoCAqIEFsdGhvdWdo
IHRoaXMgaXMgYSBwZXItQ1BVIGZlYXR1cmUsIHdlIG1ha2UgaXQgZ2xvYmFsCj4gYmVjYXVzZQo+
ICvCoMKgwqDCoMKgwqDCoCAqIGFzeW1tZXRyaWMgc3lzdGVtcyBhcmUganVzdCBhIG51aXNhbmNl
Lgo+ICvCoMKgwqDCoMKgwqDCoCAqCj4gK8KgwqDCoMKgwqDCoMKgICogVXNlcnNwYWNlIGNhbiBv
dmVycmlkZSB0aGlzIGFzIGxvbmcgYXMgaXQgZG9lc24ndCBwcm9taXNlCj4gK8KgwqDCoMKgwqDC
oMKgICogdGhlIGltcG9zc2libGUuCj4gK8KgwqDCoMKgwqDCoMKgICovCj4gK8KgwqDCoMKgwqDC
oMKgaWYgKGFybTY0X2dldF9zcGVjdHJlX3YyX3N0YXRlKCkgPT0gU1BFQ1RSRV9VTkFGRkVDVEVE
KSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHZhbCAmPSB+QVJNNjRfRkVBVFVS
RV9NQVNLKElEX0FBNjRQRlIwX0VMMV9DU1YyKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgdmFsIHw9Cj4gRklFTERfUFJFUChBUk02NF9GRUFUVVJFX01BU0soSURfQUE2NFBGUjBf
RUwxX0NTVjIpLCAxKTsKPiArwqDCoMKgwqDCoMKgwqB9Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKGFy
bTY0X2dldF9tZWx0ZG93bl9zdGF0ZSgpID09IFNQRUNUUkVfVU5BRkZFQ1RFRCkgewo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB2YWwgJj0gfkFSTTY0X0ZFQVRVUkVfTUFTSyhJRF9B
QTY0UEZSMF9FTDFfQ1NWMyk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHZhbCB8
PQo+IEZJRUxEX1BSRVAoQVJNNjRfRkVBVFVSRV9NQVNLKElEX0FBNjRQRlIwX0VMMV9DU1YzKSwg
MSk7Cj4gK8KgwqDCoMKgwqDCoMKgfQo+ICsKCkkgdGhpbmsgdGhlIHZpcnR1YWwgR0lDIGNoZWNr
IGFsc28gbmVlZHMgdG8gYmUgbW92ZWQgaGVyZSBmcm9tCmt2bV9hcm1fcmVhZF9pZF9yZWcoKQoK
ICAgICAgICBpZiAoa3ZtX3ZnaWNfZ2xvYmFsX3N0YXRlLnR5cGUgPT0gVkdJQ19WMykgewogICAg
ICAgICAgICAgICAgdmFsICY9IH5BUk02NF9GRUFUVVJFX01BU0soSURfQUE2NFBGUjBfRUwxX0dJ
Qyk7CiAgICAgICAgICAgICAgICB2YWwgfD0KRklFTERfUFJFUChBUk02NF9GRUFUVVJFX01BU0so
SURfQUE2NFBGUjBfRUwxX0dJQyksIDEpOwogICAgICAgIH0KIApTaW5jZSB0aGUgaG9zdCBzdXBw
b3J0cyBHSUN2NC4xIElEX0FBNjRQRlIwX0VMMV9HSUMgPT0gMyB3aGVuIHFlbXUKdHJpZXMgdG8g
cmVhZCB0aGlzIHJlZ2lzdGVyIHRoZW4gb3ZlcndyaXRlIGl0IHdpdGggdGhlIHNhbWUgdmFsdWUg
aXQKcmVhZCBwcmV2aW91c2x5IGFuIGVycm9yIG9jY3Vycy4gSURfQUE2NFBGUjBfRUwxX0dJQyA9
PSAzIGlzIHRoZQoibGltaXQiIHZhbHVlIGhvd2V2ZXIgdGhpcyBmaWVsZCB3aWxsIHJlYWQgYXMg
SURfQUE2NFBGUjBfRUwxX0dJQyA9PSAxCndoZW4gYSB2aXJ0dWFsIEdJQ3YzIGlzIGluIHVzZS4g
VGh1cyB3aGVuIHFlbXUgdHJpZXMgdG8gc2V0CklEX0FBNjRQRlIwX0VMMV9HSUMgPT0gMSwgYXJt
NjRfY2hlY2tfZmVhdHVyZXMoKSBmYWlscyBhcyB0aG9zZSBiaXRzCmFyZW4ndCBzZXQgaW4gaWRf
cmVnLnZhbCBtZWFuaW5nIHRoYXQgbW9kaWZpY2F0aW9ucyBhcmVuJ3QgYWxsb3dlZC4KCkFkZGl0
aW9uYWxseSB0aGlzIG1lYW5zIGl0J3MgcG9zc2libGUgdG8gc2V0IElEX0FBNjRQRlIwX0VMMV9H
SUMgPT0gMwpmcm9tIHVzZXJzcGFjZSBob3dldmVyIGFueSByZWFkcyB3aWxsIHNlZSB0aGlzIGZp
ZWxkIGFzCklEX0FBNjRQRlIwX0VMMV9HSUMgPT0gMS4KClRoaXMgYWxsIG1lYW5zIHRoZSBzbXAg
a3ZtX3VuaXRfdGVzdHMgZmFpbGVkLiBXaXRoIHRoZSBhYm92ZSBjaGFuZ2UKdGhleSBwYXNzLgoK
VGhhbmtzLApTdXJhagoKPiArwqDCoMKgwqDCoMKgwqB2YWwgJj0gfkFSTTY0X0ZFQVRVUkVfTUFT
SyhJRF9BQTY0UEZSMF9FTDFfQU1VKTsKPiArCj4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIHZhbDsK
PiArfQo+ICsKPiDCoHN0YXRpYyBpbnQgc2V0X2lkX2FhNjRwZnIwX2VsMShzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGNvbnN0IHN0cnVjdCBzeXNfcmVnX2Rlc2MgKnJkLAo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1NjQg
dmFsKQpbIHNuaXAgXQo=

