Return-Path: <kvm+bounces-1685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 508437EB3F7
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 16:43:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0019B20AC3
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AF8B4176D;
	Tue, 14 Nov 2023 15:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kgKlFp4r"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925D841762
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 15:42:59 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E59BB
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 07:42:57 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-9e5dd91b0acso684600366b.1
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 07:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699976576; x=1700581376; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gCFoXhGCZFhwzHOt1ECCBxHdb8kGrjYPklFidAhJw58=;
        b=kgKlFp4riAdh8tsNMKXzUsxoJf4qBxGDU6RO4AwCfgRZEuBe/UdQWizqrG6tDok1cC
         kdxnErLhY4og7J/YzCGkwE6y7zdW/6efuWKJqVd7rODCr5imoc3eGi4QI7sR2EVQqyAA
         09o+dR/rVkrpGW5umE9NRlFm9YAW7TRrL6Zv+nCm8nBCrc3QF7YUOBdv1l4Ts5KuB+5n
         k2KgZ6zV4m5HCw+qBe6riofxH/REllIH3W8Xe1R4BJkTTM1ev6WUUPeiUM/1rEZsT89j
         NaltXaAoKy8hPMLdbBgCpbkTYzxKbERMkmfJoQ2WfYNIKiiKl0ZxAi1Qfu5/Knj2mJkq
         Eh1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699976576; x=1700581376;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gCFoXhGCZFhwzHOt1ECCBxHdb8kGrjYPklFidAhJw58=;
        b=nkpA8990zzMqfS/37xxNEKCfsEsNzzT2C47S+vO+MNTmJmLumqkizjQju4TUdXCHo6
         EcFOKqOHsqDfylCem+NpwM77W+1QU+DvlVBLopQOM4W+8VO6X/1pwOdzslxrTH4kwyqj
         dL/ctO/CF+4DMNYwDeoULn7zrfiBhDcfSpRSMvXQi+9TqM9XWjiRGLSW62O/SHt7Mcp7
         eRBPrAMm0G1UI9o++6VFLBvmzKMD+HPLEvv7c0NQgV4zsDmBB3ewKlas8czZwkQ8+oMT
         37B1gFp9nhOvsqPrgI/0dNYzeiU2wYQcdDXFO89zUGP4pFk71UtqZUc1qzJgdM2Hyyrs
         9tzw==
X-Gm-Message-State: AOJu0YyYVzeMjGVA9IEynD0bn70Gz9c2YAsBDZ3tBFhureplwfVeiQid
	qLLASuUahqGt7hUjHCUvejsoDg==
X-Google-Smtp-Source: AGHT+IHp79TSN3T1f0iR/8hTGuWsFNTOnvRmliGhAL1mNCFX7w4yOvOUPmAnOLIhILS3nzzmhv8aFA==
X-Received: by 2002:a17:906:1919:b0:9e4:121c:b9fd with SMTP id a25-20020a170906191900b009e4121cb9fdmr7690326eje.12.1699976576191;
        Tue, 14 Nov 2023 07:42:56 -0800 (PST)
Received: from [192.168.69.100] (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id dx5-20020a170906a84500b0099bd1a78ef5sm5691278ejb.74.2023.11.14.07.42.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Nov 2023 07:42:55 -0800 (PST)
Message-ID: <e298292d-fc40-44ca-9de2-1b159519836b@linaro.org>
Date: Tue, 14 Nov 2023 16:42:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 v2 01/19] tests/avocado: Add 'guest:xen' tag to
 tests running Xen guest
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, David Woodhouse
 <dwmw@amazon.co.uk>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paul Durrant <paul@xen.org>, qemu-arm@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 xen-devel@lists.xenproject.org, qemu-block@nongnu.org,
 Anthony Perard <anthony.perard@citrix.com>, kvm@vger.kernel.org,
 Thomas Huth <thuth@redhat.com>, Cleber Rosa <crosa@redhat.com>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Beraldo Leal <bleal@redhat.com>
References: <20231114143816.71079-1-philmd@linaro.org>
 <20231114143816.71079-2-philmd@linaro.org>
 <94D9484A-917D-4970-98DE-35B84BEDA1DC@infradead.org>
 <407f32ee-e489-4c05-9c3d-fa6c29bb1d99@linaro.org>
 <074BCACF-C8D0-440A-A805-CDB0DB21C416@infradead.org>
 <04917b57-d778-41a2-b320-c8c0afbe9ffb@linaro.org>
 <37D11113-662D-49FD-B1F1-757217EAFEEA@infradead.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <37D11113-662D-49FD-B1F1-757217EAFEEA@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14/11/23 16:19, David Woodhouse wrote:
> On 14 November 2023 10:13:14 GMT-05:00, "Philippe Mathieu-Daudé" <philmd@linaro.org> wrote:
>> On 14/11/23 16:08, David Woodhouse wrote:
>>> On 14 November 2023 10:00:09 GMT-05:00, "Philippe Mathieu-Daudé" <philmd@linaro.org> wrote:
>>>> On 14/11/23 15:50, David Woodhouse wrote:
>>>>> On 14 November 2023 09:37:57 GMT-05:00, "Philippe Mathieu-Daudé" <philmd@linaro.org> wrote:
>>>>>> Add a tag to run all Xen-specific tests using:
>>>>>>
>>>>>>     $ make check-avocado AVOCADO_TAGS='guest:xen'
>>>>>>
>>>>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>>>>> ---
>>>>>> tests/avocado/boot_xen.py      | 3 +++
>>>>>> tests/avocado/kvm_xen_guest.py | 1 +
>>>>>> 2 files changed, 4 insertions(+)
>>>>>
>>>>> Those two are very different. One runs on Xen, the other on KVM. Do we want to use the same tag for both?
>>>>
>>>> My understanding is,
>>>> - boot_xen.py runs Xen on TCG
>>>> - kvm_xen_guest.py runs Xen on KVM
>>>> so both runs Xen guests.
>>>
>>> Does boot_xen.py actually boot *Xen*? And presumably at least one Xen guest *within* Xen?
>>
>> I'll let Alex confirm, but yes, I expect Xen guest within Xen guest within TCG. So the tags "accel:tcg" (already present) and "guest:xen".
>>
>>> kvm_xen_guest.py boots a "Xen guest" under KVM directly without any real Xen being present. It's *emulating* Xen.
>>
>> Yes, so the tag "guest:xen" is correct.
>>
>>> They do both run Xen guests (or at least guests which use Xen hypercalls and *think* they're running under Xen). But is that the important classification for lumping them together?
>>
>> The idea of AVOCADO_TAGS is to restrict testing to what you want to cover. So here this allow running 'anything that can run Xen guest'
>> in a single command, for example it is handy on my macOS aarch64 host.
> 
> Ok, that makes sense then. Thanks for your patience.

No problem, I'll add a better description in v3.

> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>

Thanks!


