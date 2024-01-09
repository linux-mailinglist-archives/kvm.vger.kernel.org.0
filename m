Return-Path: <kvm+bounces-5889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3856E8287FA
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 15:24:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B76051F24EB7
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 14:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C2139ADB;
	Tue,  9 Jan 2024 14:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="foFAZslC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1E439ACF
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 14:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-40e4f71288bso7098005e9.1
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 06:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704810263; x=1705415063; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7TaTwDNJKCApijCrofUkZrcv+VK9ZM/YluE5dtA8j8M=;
        b=foFAZslCFL7g8ZVKr/+gXTbZyLV/wzQfauZcHWtj5TzqJ2/IP+gWgh53oHMZ2dderd
         aMmb3fYscyg4W/DS9si6qn1mZa5GpIIlGV8hiiUCNGcENa748RRKiZpAi25AQwCG1AWM
         CdbVp8IsN3bzarN2ZwafOAKRmwfPK/iIF4gjlfePEhwlUd0Wd+P1UhswB9P7AVUwiU/6
         FTgf3VAUCs/iyHmG3Y4lSVF6zcBZ0Aa8T/51X6lxVj92jgIU84SnQZWXb5Z2u8/xqlhX
         TMhrIC9I3kqmHaGdQwroXZ3cWfU2giOruCtih3dMbN3jAItOWzcyI/9Jp9HitWdxzdyU
         eq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704810263; x=1705415063;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7TaTwDNJKCApijCrofUkZrcv+VK9ZM/YluE5dtA8j8M=;
        b=Aptj+f+e4fX3iNqANYjIOcYr+lo8tHzvfI3nv/ykxkHNp+ay1hP6aJ5rdStr4D7Lfz
         ewA2zZYvw/APYf0cePStGUHq5I9WyjDXCwv3kgfAKNhrAtjcO2cgO/rCcLtPd5dLnrQH
         DOwpRpZi0WQhczBoHkW1ZBn4PjEHoYHclfudurKe+R+dusEL8+pZAdCgIR6NfZAuwLt0
         ghOCKMH+MFGXYT9Xc0wO295YddGzGSvJe9AjBorrSAMqYGxnyvnp+uqGLDJuU6qxXQ1R
         /E/87DZ2KB8jZSrzD23mH5yqjR1o1WOXCcJqp2bmvfb3U1k3Jh5X1IxLbPbYd59Jzwb2
         BGRQ==
X-Gm-Message-State: AOJu0Yz/Tbdo5gLKPEUvUuNIsNuXwWDcK4FxNyqer8K/py/vm456ICGG
	+KU/47n9OlZfdImvaWL2sys+DV1RMp8+SA==
X-Google-Smtp-Source: AGHT+IFBiWbbDS9xbrZz3ME3I+vcc+TfRmzAikG49gMGGqgDT673KWV87mP5tbIvB/CQl9/MctYIwQ==
X-Received: by 2002:a7b:c041:0:b0:40d:7247:b01f with SMTP id u1-20020a7bc041000000b0040d7247b01fmr1871048wmc.98.1704810263508;
        Tue, 09 Jan 2024 06:24:23 -0800 (PST)
Received: from [192.168.1.24] ([102.35.208.160])
        by smtp.gmail.com with ESMTPSA id ay26-20020a05600c1e1a00b0040e53f24ceasm7614wmb.16.2024.01.09.06.24.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jan 2024 06:24:22 -0800 (PST)
Message-ID: <a4554149-4dcf-449f-893d-e3ca70754f93@linaro.org>
Date: Tue, 9 Jan 2024 18:24:07 +0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 36/43] plugins: Use different helpers when reading
 registers
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
 Richard Henderson <richard.henderson@linaro.org>,
 Song Gao <gaosong@loongson.cn>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 David Hildenbrand <david@redhat.com>, Aurelien Jarno <aurelien@aurel32.net>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Yanan Wang <wangyanan55@huawei.com>, Bin Meng <bin.meng@windriver.com>,
 Laurent Vivier <lvivier@redhat.com>, Michael Rolnik <mrolnik@gmail.com>,
 Alexandre Iooss <erdnaxe@crans.org>, David Woodhouse <dwmw2@infradead.org>,
 Laurent Vivier <laurent@vivier.eu>, Paolo Bonzini <pbonzini@redhat.com>,
 Brian Cain <bcain@quicinc.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Beraldo Leal <bleal@redhat.com>, Paul Durrant <paul@xen.org>,
 Mahmoud Mandour <ma.mandourr@gmail.com>, Thomas Huth <thuth@redhat.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Cleber Rosa <crosa@redhat.com>,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org,
 Weiwei Li <liwei1518@gmail.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, John Snow <jsnow@redhat.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Nicholas Piggin <npiggin@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@kaod.org>, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>, qemu-riscv@nongnu.org,
 Alistair Francis <alistair.francis@wdc.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>
References: <20240103173349.398526-1-alex.bennee@linaro.org>
 <20240103173349.398526-37-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20240103173349.398526-37-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

UmV2aWV3ZWQtYnk6IFBpZXJyaWNrIEJvdXZpZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJv
Lm9yZz4NCg0KT24gMS8zLzI0IDIxOjMzLCBBbGV4IEJlbm7DqWUgd3JvdGU6DQo+IEZyb206
IEFraWhpa28gT2Rha2kgPGFraWhpa28ub2Rha2lAZGF5bml4LmNvbT4NCj4gDQo+IFRoaXMg
YXZvaWRzIG9wdGltaXphdGlvbnMgaW5jb21wYXRpYmxlIHdoZW4gcmVhZGluZyByZWdpc3Rl
cnMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBa2loaWtvIE9kYWtpIDxha2loaWtvLm9kYWtp
QGRheW5peC5jb20+DQo+IE1lc3NhZ2UtSWQ6IDwyMDIzMTIxMy1nZGItdjE3LTEyLTc3NzA0
NzM4MDU5MUBkYXluaXguY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbGV4IEJlbm7DqWUgPGFs
ZXguYmVubmVlQGxpbmFyby5vcmc+DQo+IC0tLQ0KPiAgIGFjY2VsL3RjZy9wbHVnaW4taGVs
cGVycy5oIHwgIDMgKystDQo+ICAgaW5jbHVkZS9xZW11L3BsdWdpbi5oICAgICAgfCAgMSAr
DQo+ICAgYWNjZWwvdGNnL3BsdWdpbi1nZW4uYyAgICAgfCA0MyArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrLS0tLQ0KPiAgIHBsdWdpbnMvYXBpLmMgICAgICAgICAgICAg
IHwgMTIgKysrKysrKysrLS0NCj4gICA0IGZpbGVzIGNoYW5nZWQsIDUyIGluc2VydGlvbnMo
KyksIDcgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYWNjZWwvdGNnL3BsdWdp
bi1oZWxwZXJzLmggYi9hY2NlbC90Y2cvcGx1Z2luLWhlbHBlcnMuaA0KPiBpbmRleCA4ZTY4
NWUwNjU0NS4uMTE3OTY0MzZmMzUgMTAwNjQ0DQo+IC0tLSBhL2FjY2VsL3RjZy9wbHVnaW4t
aGVscGVycy5oDQo+ICsrKyBiL2FjY2VsL3RjZy9wbHVnaW4taGVscGVycy5oDQo+IEBAIC0x
LDQgKzEsNSBAQA0KPiAgICNpZmRlZiBDT05GSUdfUExVR0lODQo+IC1ERUZfSEVMUEVSX0ZM
QUdTXzIocGx1Z2luX3ZjcHVfdWRhdGFfY2IsIFRDR19DQUxMX05PX1JXRyB8IFRDR19DQUxM
X1BMVUdJTiwgdm9pZCwgaTMyLCBwdHIpDQo+ICtERUZfSEVMUEVSX0ZMQUdTXzIocGx1Z2lu
X3ZjcHVfdWRhdGFfY2Jfbm9fd2csIFRDR19DQUxMX05PX1dHIHwgVENHX0NBTExfUExVR0lO
LCB2b2lkLCBpMzIsIHB0cikNCj4gK0RFRl9IRUxQRVJfRkxBR1NfMihwbHVnaW5fdmNwdV91
ZGF0YV9jYl9ub19yd2csIFRDR19DQUxMX05PX1JXRyB8IFRDR19DQUxMX1BMVUdJTiwgdm9p
ZCwgaTMyLCBwdHIpDQo+ICAgREVGX0hFTFBFUl9GTEFHU180KHBsdWdpbl92Y3B1X21lbV9j
YiwgVENHX0NBTExfTk9fUldHIHwgVENHX0NBTExfUExVR0lOLCB2b2lkLCBpMzIsIGkzMiwg
aTY0LCBwdHIpDQo+ICAgI2VuZGlmDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3FlbXUvcGx1
Z2luLmggYi9pbmNsdWRlL3FlbXUvcGx1Z2luLmgNCj4gaW5kZXggN2ZkYzNhNDg0OWYuLmIw
YzVhYzY4MjkzIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL3FlbXUvcGx1Z2luLmgNCj4gKysr
IGIvaW5jbHVkZS9xZW11L3BsdWdpbi5oDQo+IEBAIC03Myw2ICs3Myw3IEBAIGVudW0gcGx1
Z2luX2R5bl9jYl90eXBlIHsNCj4gICANCj4gICBlbnVtIHBsdWdpbl9keW5fY2Jfc3VidHlw
ZSB7DQo+ICAgICAgIFBMVUdJTl9DQl9SRUdVTEFSLA0KPiArICAgIFBMVUdJTl9DQl9SRUdV
TEFSX1IsDQo+ICAgICAgIFBMVUdJTl9DQl9JTkxJTkUsDQo+ICAgICAgIFBMVUdJTl9OX0NC
X1NVQlRZUEVTLA0KPiAgIH07DQo+IGRpZmYgLS1naXQgYS9hY2NlbC90Y2cvcGx1Z2luLWdl
bi5jIGIvYWNjZWwvdGNnL3BsdWdpbi1nZW4uYw0KPiBpbmRleCA3OGIzMzFiMjUxMC4uYjM3
Y2U3NjgzZTYgMTAwNjQ0DQo+IC0tLSBhL2FjY2VsL3RjZy9wbHVnaW4tZ2VuLmMNCj4gKysr
IGIvYWNjZWwvdGNnL3BsdWdpbi1nZW4uYw0KPiBAQCAtNzksNiArNzksNyBAQCBlbnVtIHBs
dWdpbl9nZW5fZnJvbSB7DQo+ICAgDQo+ICAgZW51bSBwbHVnaW5fZ2VuX2NiIHsNCj4gICAg
ICAgUExVR0lOX0dFTl9DQl9VREFUQSwNCj4gKyAgICBQTFVHSU5fR0VOX0NCX1VEQVRBX1Is
DQo+ICAgICAgIFBMVUdJTl9HRU5fQ0JfSU5MSU5FLA0KPiAgICAgICBQTFVHSU5fR0VOX0NC
X01FTSwNCj4gICAgICAgUExVR0lOX0dFTl9FTkFCTEVfTUVNX0hFTFBFUiwNCj4gQEAgLTkw
LDcgKzkxLDEwIEBAIGVudW0gcGx1Z2luX2dlbl9jYiB7DQo+ICAgICogVGhlc2UgaGVscGVy
cyBhcmUgc3R1YnMgdGhhdCBnZXQgZHluYW1pY2FsbHkgc3dpdGNoZWQgb3V0IGZvciBjYWxs
cw0KPiAgICAqIGRpcmVjdCB0byB0aGUgcGx1Z2luIGlmIHRoZXkgYXJlIHN1YnNjcmliZWQg
dG8uDQo+ICAgICovDQo+IC12b2lkIEhFTFBFUihwbHVnaW5fdmNwdV91ZGF0YV9jYikodWlu
dDMyX3QgY3B1X2luZGV4LCB2b2lkICp1ZGF0YSkNCj4gK3ZvaWQgSEVMUEVSKHBsdWdpbl92
Y3B1X3VkYXRhX2NiX25vX3dnKSh1aW50MzJfdCBjcHVfaW5kZXgsIHZvaWQgKnVkYXRhKQ0K
PiAreyB9DQo+ICsNCj4gK3ZvaWQgSEVMUEVSKHBsdWdpbl92Y3B1X3VkYXRhX2NiX25vX3J3
ZykodWludDMyX3QgY3B1X2luZGV4LCB2b2lkICp1ZGF0YSkNCj4gICB7IH0NCj4gICANCj4g
ICB2b2lkIEhFTFBFUihwbHVnaW5fdmNwdV9tZW1fY2IpKHVuc2lnbmVkIGludCB2Y3B1X2lu
ZGV4LA0KPiBAQCAtOTgsNyArMTAyLDcgQEAgdm9pZCBIRUxQRVIocGx1Z2luX3ZjcHVfbWVt
X2NiKSh1bnNpZ25lZCBpbnQgdmNwdV9pbmRleCwNCj4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHZvaWQgKnVzZXJkYXRhKQ0KPiAgIHsgfQ0KPiAgIA0KPiAtc3RhdGlj
IHZvaWQgZ2VuX2VtcHR5X3VkYXRhX2NiKHZvaWQpDQo+ICtzdGF0aWMgdm9pZCBnZW5fZW1w
dHlfdWRhdGFfY2Iodm9pZCAoKmdlbl9oZWxwZXIpKFRDR3ZfaTMyLCBUQ0d2X3B0cikpDQo+
ICAgew0KPiAgICAgICBUQ0d2X2kzMiBjcHVfaW5kZXggPSB0Y2dfdGVtcF9lYmJfbmV3X2kz
MigpOw0KPiAgICAgICBUQ0d2X3B0ciB1ZGF0YSA9IHRjZ190ZW1wX2ViYl9uZXdfcHRyKCk7
DQo+IEBAIC0xMDYsMTIgKzExMCwyMiBAQCBzdGF0aWMgdm9pZCBnZW5fZW1wdHlfdWRhdGFf
Y2Iodm9pZCkNCj4gICAgICAgdGNnX2dlbl9tb3ZpX3B0cih1ZGF0YSwgMCk7DQo+ICAgICAg
IHRjZ19nZW5fbGRfaTMyKGNwdV9pbmRleCwgdGNnX2VudiwNCj4gICAgICAgICAgICAgICAg
ICAgICAgLW9mZnNldG9mKEFyY2hDUFUsIGVudikgKyBvZmZzZXRvZihDUFVTdGF0ZSwgY3B1
X2luZGV4KSk7DQo+IC0gICAgZ2VuX2hlbHBlcl9wbHVnaW5fdmNwdV91ZGF0YV9jYihjcHVf
aW5kZXgsIHVkYXRhKTsNCj4gKyAgICBnZW5faGVscGVyKGNwdV9pbmRleCwgdWRhdGEpOw0K
PiAgIA0KPiAgICAgICB0Y2dfdGVtcF9mcmVlX3B0cih1ZGF0YSk7DQo+ICAgICAgIHRjZ190
ZW1wX2ZyZWVfaTMyKGNwdV9pbmRleCk7DQo+ICAgfQ0KPiAgIA0KPiArc3RhdGljIHZvaWQg
Z2VuX2VtcHR5X3VkYXRhX2NiX25vX3dnKHZvaWQpDQo+ICt7DQo+ICsgICAgZ2VuX2VtcHR5
X3VkYXRhX2NiKGdlbl9oZWxwZXJfcGx1Z2luX3ZjcHVfdWRhdGFfY2Jfbm9fd2cpOw0KPiAr
fQ0KPiArDQo+ICtzdGF0aWMgdm9pZCBnZW5fZW1wdHlfdWRhdGFfY2Jfbm9fcndnKHZvaWQp
DQo+ICt7DQo+ICsgICAgZ2VuX2VtcHR5X3VkYXRhX2NiKGdlbl9oZWxwZXJfcGx1Z2luX3Zj
cHVfdWRhdGFfY2Jfbm9fcndnKTsNCj4gK30NCj4gKw0KPiAgIC8qDQo+ICAgICogRm9yIG5v
dyB3ZSBvbmx5IHN1cHBvcnQgYWRkaV9pNjQuDQo+ICAgICogV2hlbiB3ZSBzdXBwb3J0IG1v
cmUgb3BzLCB3ZSBjYW4gZ2VuZXJhdGUgb25lIGVtcHR5IGlubGluZSBjYiBmb3IgZWFjaC4N
Cj4gQEAgLTE5Miw3ICsyMDYsOCBAQCBzdGF0aWMgdm9pZCBwbHVnaW5fZ2VuX2VtcHR5X2Nh
bGxiYWNrKGVudW0gcGx1Z2luX2dlbl9mcm9tIGZyb20pDQo+ICAgICAgICAgICAgICAgICAg
ICAgICBnZW5fZW1wdHlfbWVtX2hlbHBlcik7DQo+ICAgICAgICAgICAvKiBmYWxsIHRocm91
Z2ggKi8NCj4gICAgICAgY2FzZSBQTFVHSU5fR0VOX0ZST01fVEI6DQo+IC0gICAgICAgIGdl
bl93cmFwcGVkKGZyb20sIFBMVUdJTl9HRU5fQ0JfVURBVEEsIGdlbl9lbXB0eV91ZGF0YV9j
Yik7DQo+ICsgICAgICAgIGdlbl93cmFwcGVkKGZyb20sIFBMVUdJTl9HRU5fQ0JfVURBVEEs
IGdlbl9lbXB0eV91ZGF0YV9jYl9ub19yd2cpOw0KPiArICAgICAgICBnZW5fd3JhcHBlZChm
cm9tLCBQTFVHSU5fR0VOX0NCX1VEQVRBX1IsIGdlbl9lbXB0eV91ZGF0YV9jYl9ub193Zyk7
DQo+ICAgICAgICAgICBnZW5fd3JhcHBlZChmcm9tLCBQTFVHSU5fR0VOX0NCX0lOTElORSwg
Z2VuX2VtcHR5X2lubGluZV9jYik7DQo+ICAgICAgICAgICBicmVhazsNCj4gICAgICAgZGVm
YXVsdDoNCj4gQEAgLTU4OCw2ICs2MDMsMTIgQEAgc3RhdGljIHZvaWQgcGx1Z2luX2dlbl90
Yl91ZGF0YShjb25zdCBzdHJ1Y3QgcWVtdV9wbHVnaW5fdGIgKnB0YiwNCj4gICAgICAgaW5q
ZWN0X3VkYXRhX2NiKHB0Yi0+Y2JzW1BMVUdJTl9DQl9SRUdVTEFSXSwgYmVnaW5fb3ApOw0K
PiAgIH0NCj4gICANCj4gK3N0YXRpYyB2b2lkIHBsdWdpbl9nZW5fdGJfdWRhdGFfcihjb25z
dCBzdHJ1Y3QgcWVtdV9wbHVnaW5fdGIgKnB0YiwNCj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBUQ0dPcCAqYmVnaW5fb3ApDQo+ICt7DQo+ICsgICAgaW5qZWN0X3Vk
YXRhX2NiKHB0Yi0+Y2JzW1BMVUdJTl9DQl9SRUdVTEFSX1JdLCBiZWdpbl9vcCk7DQo+ICt9
DQo+ICsNCj4gICBzdGF0aWMgdm9pZCBwbHVnaW5fZ2VuX3RiX2lubGluZShjb25zdCBzdHJ1
Y3QgcWVtdV9wbHVnaW5fdGIgKnB0YiwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBUQ0dPcCAqYmVnaW5fb3ApDQo+ICAgew0KPiBAQCAtNjAyLDYgKzYyMywxNCBA
QCBzdGF0aWMgdm9pZCBwbHVnaW5fZ2VuX2luc25fdWRhdGEoY29uc3Qgc3RydWN0IHFlbXVf
cGx1Z2luX3RiICpwdGIsDQo+ICAgICAgIGluamVjdF91ZGF0YV9jYihpbnNuLT5jYnNbUExV
R0lOX0NCX0lOU05dW1BMVUdJTl9DQl9SRUdVTEFSXSwgYmVnaW5fb3ApOw0KPiAgIH0NCj4g
ICANCj4gK3N0YXRpYyB2b2lkIHBsdWdpbl9nZW5faW5zbl91ZGF0YV9yKGNvbnN0IHN0cnVj
dCBxZW11X3BsdWdpbl90YiAqcHRiLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgVENHT3AgKmJlZ2luX29wLCBpbnQgaW5zbl9pZHgpDQo+ICt7DQo+ICsgICAg
c3RydWN0IHFlbXVfcGx1Z2luX2luc24gKmluc24gPSBnX3B0cl9hcnJheV9pbmRleChwdGIt
Pmluc25zLCBpbnNuX2lkeCk7DQo+ICsNCj4gKyAgICBpbmplY3RfdWRhdGFfY2IoaW5zbi0+
Y2JzW1BMVUdJTl9DQl9JTlNOXVtQTFVHSU5fQ0JfUkVHVUxBUl9SXSwgYmVnaW5fb3ApOw0K
PiArfQ0KPiArDQo+ICAgc3RhdGljIHZvaWQgcGx1Z2luX2dlbl9pbnNuX2lubGluZShjb25z
dCBzdHJ1Y3QgcWVtdV9wbHVnaW5fdGIgKnB0YiwNCj4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIFRDR09wICpiZWdpbl9vcCwgaW50IGluc25faWR4KQ0KPiAgIHsN
Cj4gQEAgLTcyMSw2ICs3NTAsOSBAQCBzdGF0aWMgdm9pZCBwbHVnaW5fZ2VuX2luamVjdChz
dHJ1Y3QgcWVtdV9wbHVnaW5fdGIgKnBsdWdpbl90YikNCj4gICAgICAgICAgICAgICAgICAg
Y2FzZSBQTFVHSU5fR0VOX0NCX1VEQVRBOg0KPiAgICAgICAgICAgICAgICAgICAgICAgcGx1
Z2luX2dlbl90Yl91ZGF0YShwbHVnaW5fdGIsIG9wKTsNCj4gICAgICAgICAgICAgICAgICAg
ICAgIGJyZWFrOw0KPiArICAgICAgICAgICAgICAgIGNhc2UgUExVR0lOX0dFTl9DQl9VREFU
QV9SOg0KPiArICAgICAgICAgICAgICAgICAgICBwbHVnaW5fZ2VuX3RiX3VkYXRhX3IocGx1
Z2luX3RiLCBvcCk7DQo+ICsgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiAgICAgICAg
ICAgICAgICAgICBjYXNlIFBMVUdJTl9HRU5fQ0JfSU5MSU5FOg0KPiAgICAgICAgICAgICAg
ICAgICAgICAgcGx1Z2luX2dlbl90Yl9pbmxpbmUocGx1Z2luX3RiLCBvcCk7DQo+ICAgICAg
ICAgICAgICAgICAgICAgICBicmVhazsNCj4gQEAgLTczNyw2ICs3NjksOSBAQCBzdGF0aWMg
dm9pZCBwbHVnaW5fZ2VuX2luamVjdChzdHJ1Y3QgcWVtdV9wbHVnaW5fdGIgKnBsdWdpbl90
YikNCj4gICAgICAgICAgICAgICAgICAgY2FzZSBQTFVHSU5fR0VOX0NCX1VEQVRBOg0KPiAg
ICAgICAgICAgICAgICAgICAgICAgcGx1Z2luX2dlbl9pbnNuX3VkYXRhKHBsdWdpbl90Yiwg
b3AsIGluc25faWR4KTsNCj4gICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiArICAg
ICAgICAgICAgICAgIGNhc2UgUExVR0lOX0dFTl9DQl9VREFUQV9SOg0KPiArICAgICAgICAg
ICAgICAgICAgICBwbHVnaW5fZ2VuX2luc25fdWRhdGFfcihwbHVnaW5fdGIsIG9wLCBpbnNu
X2lkeCk7DQo+ICsgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiAgICAgICAgICAgICAg
ICAgICBjYXNlIFBMVUdJTl9HRU5fQ0JfSU5MSU5FOg0KPiAgICAgICAgICAgICAgICAgICAg
ICAgcGx1Z2luX2dlbl9pbnNuX2lubGluZShwbHVnaW5fdGIsIG9wLCBpbnNuX2lkeCk7DQo+
ICAgICAgICAgICAgICAgICAgICAgICBicmVhazsNCj4gZGlmZiAtLWdpdCBhL3BsdWdpbnMv
YXBpLmMgYi9wbHVnaW5zL2FwaS5jDQo+IGluZGV4IDU1MjFiMGFkMzZjLi5hYzM5Y2RlYTBi
MyAxMDA2NDQNCj4gLS0tIGEvcGx1Z2lucy9hcGkuYw0KPiArKysgYi9wbHVnaW5zL2FwaS5j
DQo+IEBAIC04OSw3ICs4OSwxMSBAQCB2b2lkIHFlbXVfcGx1Z2luX3JlZ2lzdGVyX3ZjcHVf
dGJfZXhlY19jYihzdHJ1Y3QgcWVtdV9wbHVnaW5fdGIgKnRiLA0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZvaWQgKnVkYXRhKQ0KPiAgIHsNCj4g
ICAgICAgaWYgKCF0Yi0+bWVtX29ubHkpIHsNCj4gLSAgICAgICAgcGx1Z2luX3JlZ2lzdGVy
X2R5bl9jYl9fdWRhdGEoJnRiLT5jYnNbUExVR0lOX0NCX1JFR1VMQVJdLA0KPiArICAgICAg
ICBpbnQgaW5kZXggPSBmbGFncyA9PSBRRU1VX1BMVUdJTl9DQl9SX1JFR1MgfHwNCj4gKyAg
ICAgICAgICAgICAgICAgICAgZmxhZ3MgPT0gUUVNVV9QTFVHSU5fQ0JfUldfUkVHUyA/DQo+
ICsgICAgICAgICAgICAgICAgICAgIFBMVUdJTl9DQl9SRUdVTEFSX1IgOiBQTFVHSU5fQ0Jf
UkVHVUxBUjsNCj4gKw0KPiArICAgICAgICBwbHVnaW5fcmVnaXN0ZXJfZHluX2NiX191ZGF0
YSgmdGItPmNic1tpbmRleF0sDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBjYiwgZmxhZ3MsIHVkYXRhKTsNCj4gICAgICAgfQ0KPiAgIH0NCj4gQEAgLTEw
OSw3ICsxMTMsMTEgQEAgdm9pZCBxZW11X3BsdWdpbl9yZWdpc3Rlcl92Y3B1X2luc25fZXhl
Y19jYihzdHJ1Y3QgcWVtdV9wbHVnaW5faW5zbiAqaW5zbiwNCj4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZvaWQgKnVkYXRhKQ0KPiAgIHsNCj4g
ICAgICAgaWYgKCFpbnNuLT5tZW1fb25seSkgew0KPiAtICAgICAgICBwbHVnaW5fcmVnaXN0
ZXJfZHluX2NiX191ZGF0YSgmaW5zbi0+Y2JzW1BMVUdJTl9DQl9JTlNOXVtQTFVHSU5fQ0Jf
UkVHVUxBUl0sDQo+ICsgICAgICAgIGludCBpbmRleCA9IGZsYWdzID09IFFFTVVfUExVR0lO
X0NCX1JfUkVHUyB8fA0KPiArICAgICAgICAgICAgICAgICAgICBmbGFncyA9PSBRRU1VX1BM
VUdJTl9DQl9SV19SRUdTID8NCj4gKyAgICAgICAgICAgICAgICAgICAgUExVR0lOX0NCX1JF
R1VMQVJfUiA6IFBMVUdJTl9DQl9SRUdVTEFSOw0KPiArDQo+ICsgICAgICAgIHBsdWdpbl9y
ZWdpc3Rlcl9keW5fY2JfX3VkYXRhKCZpbnNuLT5jYnNbUExVR0lOX0NCX0lOU05dW2luZGV4
XSwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNiLCBmbGFn
cywgdWRhdGEpOw0KPiAgICAgICB9DQo+ICAgfQ0K

