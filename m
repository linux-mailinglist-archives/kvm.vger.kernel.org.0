Return-Path: <kvm+bounces-1677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE83B7EB331
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 16:13:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 622851F25119
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B65AA4123B;
	Tue, 14 Nov 2023 15:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oIQs8xGv"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4105141227
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 15:13:21 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805A9E3
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 07:13:19 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-9e623356e59so633283266b.0
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 07:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699974798; x=1700579598; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HIHi0yKkQuExrrqaReTTaHyYp9veWL43i8XQ+amSwZ4=;
        b=oIQs8xGvnZ5PGqGOQd8QsOQQYUXwQcMDxoo5Nxnfer8x4zvA5kBJZUN7pY6DeSLZnL
         HjCml3zbh1yDt7XSKpQFQXrHPSwUAC8iHfoFYO3zT8/iNNDdQzJCeNQ6bEz/5tN7V5/G
         ZBa6zZv1GUgZsQm3vzXh4gGZ5gh9WWGS1KzwKsQO5TdxrZaIPQ7kf6nY35oMCazGJeQM
         oP0hlgDEk8QLki/397dTEWKaALJPbSFaVVeqcw1KZblDzf6ohI7iln5o+RunRjIopdyi
         CeGfo3tZOqW6/2MKBOGDEdaYevurh772+kS3O8ldJh4dozFwzbkzN3gSaOxaqvyKUO4/
         Zp5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699974798; x=1700579598;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HIHi0yKkQuExrrqaReTTaHyYp9veWL43i8XQ+amSwZ4=;
        b=sBs2Cxv5g7uKNvmDbmVJQ1uy0Tt+kMVr3JRKAnGzbYjo1fyCPalq1UnwHxdxDRdNbV
         DZy+vV/D8im41YaJYHv9u1TEilrTOnnri20xBaYmlrW/76EqGBd+Y7bfAusXtB9LR+0N
         Hb7EE/PJW7+ECReN0XRtbKKDG93cG0lww3LEDCd+Zc/OCC+B2eMUxybfSLhV+T9Ifyqd
         IscaeMgJtXGnlUCzNxwiF/RUie15EmdxYRJIZJvl31nvnG8l1CbicYeu6zzQmLLI/Bc2
         lGHLKhlaGtIdz4EpVXChPhvjiIZIA2hOaZoWyrzBXZVrSQjoTfW+MA4VTybciIF91XZo
         6i2Q==
X-Gm-Message-State: AOJu0Ywcbk5YGHKDFLZirI3C26WY/c8mng4nRdekc/t31/l2MR4irxEF
	0PLzc7zI5FTQe/35mtQJeHnZtg==
X-Google-Smtp-Source: AGHT+IHGFXgwRm95QaGDvzmEn8xmzfuJoAXM9MDWtXppVWdC9PPQJI2AOwqlfdbCPZx6yH7hHs/ywQ==
X-Received: by 2002:a17:906:c01:b0:9e5:d618:d6c1 with SMTP id s1-20020a1709060c0100b009e5d618d6c1mr8703674ejf.19.1699974797997;
        Tue, 14 Nov 2023 07:13:17 -0800 (PST)
Received: from [192.168.69.100] (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id fi6-20020a170906da0600b009e6a990a55esm5644531ejb.158.2023.11.14.07.13.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Nov 2023 07:13:17 -0800 (PST)
Message-ID: <04917b57-d778-41a2-b320-c8c0afbe9ffb@linaro.org>
Date: Tue, 14 Nov 2023 16:13:14 +0100
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
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <074BCACF-C8D0-440A-A805-CDB0DB21C416@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14/11/23 16:08, David Woodhouse wrote:
> On 14 November 2023 10:00:09 GMT-05:00, "Philippe Mathieu-Daudé" <philmd@linaro.org> wrote:
>> On 14/11/23 15:50, David Woodhouse wrote:
>>> On 14 November 2023 09:37:57 GMT-05:00, "Philippe Mathieu-Daudé" <philmd@linaro.org> wrote:
>>>> Add a tag to run all Xen-specific tests using:
>>>>
>>>>    $ make check-avocado AVOCADO_TAGS='guest:xen'
>>>>
>>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>>> ---
>>>> tests/avocado/boot_xen.py      | 3 +++
>>>> tests/avocado/kvm_xen_guest.py | 1 +
>>>> 2 files changed, 4 insertions(+)
>>>
>>> Those two are very different. One runs on Xen, the other on KVM. Do we want to use the same tag for both?
>>
>> My understanding is,
>> - boot_xen.py runs Xen on TCG
>> - kvm_xen_guest.py runs Xen on KVM
>> so both runs Xen guests.
> 
> Does boot_xen.py actually boot *Xen*? And presumably at least one Xen guest *within* Xen?

I'll let Alex confirm, but yes, I expect Xen guest within Xen guest 
within TCG. So the tags "accel:tcg" (already present) and "guest:xen".

> kvm_xen_guest.py boots a "Xen guest" under KVM directly without any real Xen being present. It's *emulating* Xen.

Yes, so the tag "guest:xen" is correct.

> They do both run Xen guests (or at least guests which use Xen hypercalls and *think* they're running under Xen). But is that the important classification for lumping them together?

The idea of AVOCADO_TAGS is to restrict testing to what you want to 
cover. So here this allow running 'anything that can run Xen guest'
in a single command, for example it is handy on my macOS aarch64 host.

