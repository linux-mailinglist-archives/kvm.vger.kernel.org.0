Return-Path: <kvm+bounces-5890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0153B828804
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 15:26:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8827DB2259B
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 14:26:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25BAA39AC4;
	Tue,  9 Jan 2024 14:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AwVqr+Nj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C836B39876
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 14:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-40e461c1f5cso24767315e9.3
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 06:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704810355; x=1705415155; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u1AEBceW3yFlpwPWlgM2E0KSqURLnKs6XEX+Lp2G+N4=;
        b=AwVqr+NjwpvRvQsP/kemlqSfZEWcef3HXgsglXeCg8hsDZI1Nh13Eaa+Zo2oz/Ocuj
         7OzBVlbP5mghYiGiaMWeh9RZU4NlKPbJRCP6r14aerv4Rm1WlDW2Vekkk9skHKcaX+vB
         lE5NbfmjdMhE3WFK5mdwHn4eqdK4aznHtQq0gOmbc/K8Hih8U9PDbGfVljsBINYVsQET
         y0wtJVudCLkhCFYdPxd5cImbjAvrtWbISiq8pKsR9JsjWX51M3ZVCbLKLnMQhBt5nI97
         8xwLBG4ciuOdW4/2ACTf8xmUOVBflFftWtLcgub9fRutrxbrsiu6rzHVtgYTTO39S/Qu
         ZBGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704810355; x=1705415155;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u1AEBceW3yFlpwPWlgM2E0KSqURLnKs6XEX+Lp2G+N4=;
        b=oBBF6saYnvKpYcGZrVfyZxulQbVu7U4GXfEPo1Op6K4DTXf+UuwwzsmtNL8C1RkS9Z
         139cLxkHvUjJh7w2I6tN1j5NcwdIHH/5TYFvhWAYoTqZh1CW1dpCg7AZfxI83MxjC8ZL
         c20qyTliel1pBaPR9VwoSQATeMpGTNfgQCENfmptCItuFXRVFqKOGg/R2pn41COTr4aG
         0otlcxrvibrA8hGkQWMFGPA2X0d50bke0mFIqLiruMUNm4riyfWiWvigdQWX6ig2OenP
         iQw6W2pFQPSfpNFKBOM5096QuumWuJ9YAuwzl1DvV/SlKPnr+H8PmzzcKYBaf9f0G7Iw
         cOcA==
X-Gm-Message-State: AOJu0YwGisUst5B5d7vMtsv1TVUsYocica3KRAooHDjMifJFGQ9vQBvg
	AEKMD1Nl4LGxqpdietr7YRnPf3TL3RprXw==
X-Google-Smtp-Source: AGHT+IHY3kSZpB9bUQ9rZCp+7ar1YHv+53ISVHQsGVm43Q5eEUUT+WQeFBsEeK9v7TycA/Mni84MDQ==
X-Received: by 2002:a05:600c:1c16:b0:40e:470a:d867 with SMTP id j22-20020a05600c1c1600b0040e470ad867mr1263182wms.222.1704810355230;
        Tue, 09 Jan 2024 06:25:55 -0800 (PST)
Received: from [192.168.1.24] ([102.35.208.160])
        by smtp.gmail.com with ESMTPSA id ay26-20020a05600c1e1a00b0040e53f24ceasm7614wmb.16.2024.01.09.06.25.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jan 2024 06:25:54 -0800 (PST)
Message-ID: <e7896134-bf88-4742-bd89-9a80f701206a@linaro.org>
Date: Tue, 9 Jan 2024 18:25:44 +0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 42/43] docs/devel: lift example and plugin API sections
 up
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
 <20240103173349.398526-43-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20240103173349.398526-43-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

UmV2aWV3ZWQtYnk6IFBpZXJyaWNrIEJvdXZpZXIgPHBpZXJyaWNrLmJvdXZpZXJAbGluYXJv
Lm9yZz4NCg0KT24gMS8zLzI0IDIxOjMzLCBBbGV4IEJlbm7DqWUgd3JvdGU6DQo+IFRoaXMg
bWFrZXMgdGhlbSBhIGJpdCBtb3JlIHZpc2libGUgaW4gdGhlIFRDRyBlbXVsYXRpb24gbWVu
dSByYXRoZXINCj4gdGhhbiBoaWRpbmcgdGhlbSBhd2F5IGJlbGxvdyB0aGUgVG9DIGxpbWl0
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5h
cm8ub3JnPg0KPiAtLS0NCj4gICBkb2NzL2RldmVsL3RjZy1wbHVnaW5zLnJzdCB8IDYgKysr
LS0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMo
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kb2NzL2RldmVsL3RjZy1wbHVnaW5zLnJzdCBiL2Rv
Y3MvZGV2ZWwvdGNnLXBsdWdpbnMucnN0DQo+IGluZGV4IGZhNzQyMTI3OWY1Li41MzVhNzQ2
ODRjNSAxMDA2NDQNCj4gLS0tIGEvZG9jcy9kZXZlbC90Y2ctcGx1Z2lucy5yc3QNCj4gKysr
IGIvZG9jcy9kZXZlbC90Y2ctcGx1Z2lucy5yc3QNCj4gQEAgLTE0Myw3ICsxNDMsNyBAQCBy
ZXF1ZXN0ZWQuIFRoZSBwbHVnaW4gaXNuJ3QgY29tcGxldGVseSB1bmluc3RhbGxlZCB1bnRp
bCB0aGUgc2FmZSB3b3JrDQo+ICAgaGFzIGV4ZWN1dGVkIHdoaWxlIGFsbCB2Q1BVcyBhcmUg
cXVpZXNjZW50Lg0KPiAgIA0KPiAgIEV4YW1wbGUgUGx1Z2lucw0KPiAtLS0tLS0tLS0tLS0t
LS0tDQo+ICs9PT09PT09PT09PT09PT0NCj4gICANCj4gICBUaGVyZSBhcmUgYSBudW1iZXIg
b2YgcGx1Z2lucyBpbmNsdWRlZCB3aXRoIFFFTVUgYW5kIHlvdSBhcmUNCj4gICBlbmNvdXJh
Z2VkIHRvIGNvbnRyaWJ1dGUgeW91ciBvd24gcGx1Z2lucyBwbHVnaW5zIHVwc3RyZWFtLiBU
aGVyZSBpcyBhDQo+IEBAIC01OTEsOCArNTkxLDggQEAgVGhlIHBsdWdpbiBoYXMgYSBudW1i
ZXIgb2YgYXJndW1lbnRzLCBhbGwgb2YgdGhlbSBhcmUgb3B0aW9uYWw6DQo+ICAgICBjb25m
aWd1cmF0aW9uIGFyZ3VtZW50cyBpbXBsaWVzIGBgbDI9b25gYC4NCj4gICAgIChkZWZhdWx0
OiBOID0gMjA5NzE1MiAoMk1CKSwgQiA9IDY0LCBBID0gMTYpDQo+ICAgDQo+IC1BUEkNCj4g
LS0tLQ0KPiArUGx1Z2luIEFQSQ0KPiArPT09PT09PT09PQ0KPiAgIA0KPiAgIFRoZSBmb2xs
b3dpbmcgQVBJIGlzIGdlbmVyYXRlZCBmcm9tIHRoZSBpbmxpbmUgZG9jdW1lbnRhdGlvbiBp
bg0KPiAgIGBgaW5jbHVkZS9xZW11L3FlbXUtcGx1Z2luLmhgYC4gUGxlYXNlIGVuc3VyZSBh
bnkgdXBkYXRlcyB0byB0aGUgQVBJDQo=

