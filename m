Return-Path: <kvm+bounces-5891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2836E828812
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 15:28:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F44E1C24448
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 14:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31A539AF5;
	Tue,  9 Jan 2024 14:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vSLjam9F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BC439ACC
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 14:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3376ead25e1so1525947f8f.3
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 06:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704810510; x=1705415310; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pn5mJSy6+IPUiDDo8gfQUfaMovq3bcwda2oYtY3vgIw=;
        b=vSLjam9Fa4g8909DFTgMiuiahiNG19t4xhl2Woy1CJ0DCAbPLD0fWd2dVYffJf5giu
         uVP8gKgRD1pHk8WhLA2YYB3qCGU8rSZXIe6LtqLwV1y29SBkn2GqweegKS2Bz70i3dSN
         e0dXY1MtAqXuWQYAIrWSaIokrFkdoyKCKLzHvAGHcfR7CrPdUHdw5HBqAzytoDQGz+md
         sdBkQTyqIv9I23NurKsGeJb5VirEMLk3TfJd+Qc473SSGglH2vyiQ+Cdo9fUxAM1Lk1b
         r5its8IU1X63RnYJAysmAC092AiaGcgo2I/e71YwrwJ3GyEEJFDB39TtUdG134etLdF+
         KPoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704810510; x=1705415310;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pn5mJSy6+IPUiDDo8gfQUfaMovq3bcwda2oYtY3vgIw=;
        b=tdB6PuhAH6XqfvujXt3h5FESgFe/kUfwM5lzQ8KmDHzsffF1g3VVw6bb4EjOdKxKcv
         BAMsB3a+ex+orObyigc/hVxoVuxw8NzT/6OXzPXVxgxpfPvSH+apSC+9gj34o+m6feRW
         XUGkLft4cl4pTlPpk9VelT6+waUFOxnhhihnm769O9L5BVqyOXeDDeyjv70VLOHhQd4+
         Q1Kk00W65PcmMZnz87n5DMKztcrLMfCgtNyt1JK1boB8r62rdYJJUZ5HB7Ou8DUZZFzL
         huIhlBq8ZwwSsDN+6Wl1+vD5cDFL3Hw6/AVGWpJWdkvgubr2rlwvzfiIPQG0PcBAYPix
         8bqQ==
X-Gm-Message-State: AOJu0YznNttZ5Wb2wPwU2jHpjKMh4Tk+X36wpVvLkdt9G6plT15Do5bV
	tVUcC01ZMBGIsMC8U7Y8dxRCKqTI+pLtzQ==
X-Google-Smtp-Source: AGHT+IEMfFwF5fvLeUZ0AaWVyWVBLuAVIpiU1k8nqhqE7npOWTXGjdkDfY+e8W66evzYBoSR2N9pbQ==
X-Received: by 2002:a5d:51c3:0:b0:336:b52d:30cf with SMTP id n3-20020a5d51c3000000b00336b52d30cfmr548248wrv.61.1704810510205;
        Tue, 09 Jan 2024 06:28:30 -0800 (PST)
Received: from [192.168.1.24] ([102.35.208.160])
        by smtp.gmail.com with ESMTPSA id j15-20020adfb30f000000b003375c8f796bsm2627787wrd.0.2024.01.09.06.28.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jan 2024 06:28:29 -0800 (PST)
Message-ID: <8ce7c705-8f11-4ed0-ba7c-7965a1dd1fff@linaro.org>
Date: Tue, 9 Jan 2024 18:28:17 +0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 43/43] docs/devel: document some plugin assumptions
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
 Alistair Francis <alistair.francis@wdc.com>
References: <20240103173349.398526-1-alex.bennee@linaro.org>
 <20240103173349.398526-44-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20240103173349.398526-44-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

UmV2aWV3ZWQtYnk6IFBpZXJyaWNrIEJvdXZpZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJv
Lm9yZz4NCg0KT24gMS8zLzI0IDIxOjMzLCBBbGV4IEJlbm7DqWUgd3JvdGU6DQo+IFdoaWxl
IHdlIGF0dGVtcHQgdG8gaGlkZSBpbXBsZW1lbnRhdGlvbiBkZXRhaWxzIGZyb20gdGhlIHBs
dWdpbiB3ZQ0KPiBzaG91bGRuJ3QgYmUgdG90YWxseSBvYnR1c2UuIExldCB0aGUgdXNlciBr
bm93IHdoYXQgdGhleSBjYW4gYW5kIGNhbid0DQo+IGV4cGVjdCB3aXRoIHRoZSB2YXJpb3Vz
IGluc3RydW1lbnRhdGlvbiBvcHRpb25zLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQWxleCBC
ZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPg0KPiAtLS0NCj4gICBkb2NzL2RldmVs
L3RjZy1wbHVnaW5zLnJzdCB8IDQ5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDQ5IGluc2VydGlvbnMoKykNCj4gDQo+IGRp
ZmYgLS1naXQgYS9kb2NzL2RldmVsL3RjZy1wbHVnaW5zLnJzdCBiL2RvY3MvZGV2ZWwvdGNn
LXBsdWdpbnMucnN0DQo+IGluZGV4IDUzNWE3NDY4NGM1Li45Y2MwOWQ4YzNkYSAxMDA2NDQN
Cj4gLS0tIGEvZG9jcy9kZXZlbC90Y2ctcGx1Z2lucy5yc3QNCj4gKysrIGIvZG9jcy9kZXZl
bC90Y2ctcGx1Z2lucy5yc3QNCj4gQEAgLTExMiw2ICsxMTIsNTUgQEAgZGV0YWlscyBhcmUg
b3BhcXVlIHRvIHBsdWdpbnMuIFRoZSBwbHVnaW4gaXMgYWJsZSB0byBxdWVyeSBzZWxlY3QN
Cj4gICBkZXRhaWxzIG9mIGluc3RydWN0aW9ucyBhbmQgc3lzdGVtIGNvbmZpZ3VyYXRpb24g
b25seSB0aHJvdWdoIHRoZQ0KPiAgIGV4cG9ydGVkICpxZW11X3BsdWdpbiogZnVuY3Rpb25z
Lg0KPiAgIA0KPiArSG93ZXZlciB0aGUgZm9sbG93aW5nIGFzc3VtcHRpb25zIGNhbiBiZSBt
YWRlOg0KPiArDQo+ICtUcmFuc2xhdGlvbiBCbG9ja3MNCj4gKysrKysrKysrKysrKysrKysr
Kw0KPiArDQo+ICtBbGwgY29kZSB3aWxsIGdvIHRocm91Z2ggYSB0cmFuc2xhdGlvbiBwaGFz
ZSBhbHRob3VnaCBub3QgYWxsDQo+ICt0cmFuc2xhdGlvbnMgd2lsbCBiZSBuZWNlc3Nhcmls
eSBiZSBleGVjdXRlZC4gWW91IG5lZWQgdG8gaW5zdHJ1bWVudA0KPiArYWN0dWFsIGV4ZWN1
dGlvbnMgdG8gdHJhY2sgd2hhdCBpcyBoYXBwZW5pbmcuDQo+ICsNCj4gK0l0IGlzIHF1aXRl
IG5vcm1hbCB0byBzZWUgdGhlIHNhbWUgYWRkcmVzcyB0cmFuc2xhdGVkIG11bHRpcGxlIHRp
bWVzLg0KPiArSWYgeW91IHdhbnQgdG8gdHJhY2sgdGhlIGNvZGUgaW4gc3lzdGVtIGVtdWxh
dGlvbiB5b3Ugc2hvdWxkIGV4YW1pbmUNCj4gK3RoZSB1bmRlcmx5aW5nIHBoeXNpY2FsIGFk
ZHJlc3MgKGBgcWVtdV9wbHVnaW5faW5zbl9oYWRkcmBgKSB0byB0YWtlDQo+ICtpbnRvIGFj
Y291bnQgdGhlIGVmZmVjdHMgb2YgdmlydHVhbCBtZW1vcnkgYWx0aG91Z2ggaWYgdGhlIHN5
c3RlbSBkb2VzDQo+ICtwYWdpbmcgdGhpcyB3aWxsIGNoYW5nZSB0b28uDQo+ICsNCj4gK05v
dCBhbGwgaW5zdHJ1Y3Rpb25zIGluIGEgYmxvY2sgd2lsbCBhbHdheXMgZXhlY3V0ZSBzbyBp
ZiBpdHMNCj4gK2ltcG9ydGFudCB0byB0cmFjayBpbmRpdmlkdWFsIGluc3RydWN0aW9uIGV4
ZWN1dGlvbiB5b3UgbmVlZCB0bw0KPiAraW5zdHJ1bWVudCB0aGVtIGRpcmVjdGx5LiBIb3dl
dmVyIGFzeW5jaHJvbm91cyBpbnRlcnJ1cHRzIHdpbGwgbm90DQo+ICtjaGFuZ2UgY29udHJv
bCBmbG93IG1pZC1ibG9jay4NCj4gKw0KPiArSW5zdHJ1Y3Rpb25zDQo+ICsrKysrKysrKysr
KysNCj4gKw0KPiArSW5zdHJ1Y3Rpb24gaW5zdHJ1bWVudGF0aW9uIHJ1bnMgYmVmb3JlIHRo
ZSBpbnN0cnVjdGlvbiBleGVjdXRlcy4gWW91DQo+ICtjYW4gYmUgY2FuIGJlIHN1cmUgdGhl
IGluc3RydWN0aW9uIHdpbGwgYmUgZGlzcGF0Y2hlZCwgYnV0IHlvdSBjYW4ndA0KPiArYmUg
c3VyZSBpdCB3aWxsIGNvbXBsZXRlLiBHZW5lcmFsbHkgdGhpcyB3aWxsIGJlIGJlY2F1c2Ug
b2YgYQ0KPiArc3luY2hyb25vdXMgZXhjZXB0aW9uIChlLmcuIFNJR0lMTCkgdHJpZ2dlcmVk
IGJ5IHRoZSBpbnN0cnVjdGlvbg0KPiArYXR0ZW1wdGluZyB0byBleGVjdXRlLiBJZiB5b3Ug
d2FudCB0byBiZSBzdXJlIHlvdSB3aWxsIG5lZWQgdG8NCj4gK2luc3RydW1lbnQgdGhlIG5l
eHQgaW5zdHJ1Y3Rpb24gYXMgd2VsbC4gU2VlIHRoZSBgYGV4ZWNsb2cuY2BgIHBsdWdpbg0K
PiArZm9yIGV4YW1wbGVzIG9mIGhvdyB0byB0cmFjayB0aGlzIGFuZCBmaW5hbGlzZSBkZXRh
aWxzIGFmdGVyIGV4ZWN1dGlvbi4NCj4gKw0KPiArTWVtb3J5IEFjY2Vzc2VzDQo+ICsrKysr
KysrKysrKysrKysNCj4gKw0KPiArTWVtb3J5IGNhbGxiYWNrcyBhcmUgY2FsbGVkIGFmdGVy
IGEgc3VjY2Vzc2Z1bCBsb2FkIG9yIHN0b3JlLg0KPiArVW5zdWNjZXNzZnVsIG9wZXJhdGlv
bnMgKGkuZS4gZmF1bHRzKSB3aWxsIG5vdCBiZSB2aXNpYmxlIHRvIG1lbW9yeQ0KPiAraW5z
dHJ1bWVudGF0aW9uIGFsdGhvdWdoIHRoZSBleGVjdXRpb24gc2lkZSBlZmZlY3RzIGNhbiBi
ZSBvYnNlcnZlZA0KPiArKGUuZy4gZW50ZXJpbmcgYSBleGNlcHRpb24gaGFuZGxlcikuDQo+
ICsNCj4gK1N5c3RlbSBJZGxlIGFuZCBSZXN1bWUgU3RhdGVzDQo+ICsrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKw0KPiArDQo+ICtUaGUgYGBxZW11X3BsdWdpbl9yZWdpc3Rlcl92
Y3B1X2lkbGVfY2JgYCBhbmQNCj4gK2BgcWVtdV9wbHVnaW5fcmVnaXN0ZXJfdmNwdV9yZXN1
bWVfY2JgYCBmdW5jdGlvbnMgY2FuIGJlIHVzZWQgdG8gdHJhY2sNCj4gK3doZW4gQ1BVcyBn
byBpbnRvIGFuZCByZXR1cm4gZnJvbSBzbGVlcCBzdGF0ZXMgd2hlbiB3YWl0aW5nIGZvcg0K
PiArZXh0ZXJuYWwgSS9PLiBCZSBhd2FyZSB0aG91Z2ggdGhhdCB0aGVzZSBtYXkgb2NjdXIg
bGVzcyBmcmVxdWVudGx5DQo+ICt0aGFuIGluIHJlYWwgSFcgZHVlIHRvIHRoZSBpbmVmZmlj
aWVuY2llcyBvZiBlbXVsYXRpb24gZ2l2aW5nIGxlc3MNCj4gK2NoYW5jZSBmb3IgdGhlIENQ
VSB0byBpZGxlLg0KPiArDQo+ICAgSW50ZXJuYWxzDQo+ICAgLS0tLS0tLS0tDQo+ICAgDQo=


