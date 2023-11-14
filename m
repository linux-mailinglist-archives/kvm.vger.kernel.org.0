Return-Path: <kvm+bounces-1675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65AE27EB2F2
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 16:00:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DDBB6B207EA
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D2241237;
	Tue, 14 Nov 2023 15:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L0RT7JBu"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA88041215
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 15:00:15 +0000 (UTC)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E794129
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 07:00:14 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-544455a4b56so8796273a12.1
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 07:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699974013; x=1700578813; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hvwMnVTQaJD67434mMenkNkErgsf9DqTmkoP4qGMiTA=;
        b=L0RT7JBuLxIkQWiVzvXTNNcWjz5fJ4NndY8aYZQTY7TV4iK2Tr18Xnu6AR7//mCKWc
         krHoBM/DixKSQHE/0u93s1re65zNK/EzaAfoOJg7+ye8qr1q9EPJYIcYYtdQk42eXxiJ
         cfcJQieDyPwJ0XgRYVSYXQLLPXEE1gg2EEyArRVhU3rbccq6hNOBdXX4Fc/567I79+7L
         /KdWix1dNDd6QwYdFpg23Fr5W9RisNsRhKi+FwnSRufFuP/xh+AXH3VgsVLQ6LVy1V3/
         zUTQb/cLDJOI6rWI6KkDzH2+nhdWNvxhFpUdaEfJGqPDoqIr/Vf+icNV2uSfWDLYq8Pe
         hgjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699974013; x=1700578813;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hvwMnVTQaJD67434mMenkNkErgsf9DqTmkoP4qGMiTA=;
        b=Hg+BiC0x6OjgpQrjvyYTOX4G1lPoMdp4yJNFhyAK5HKup+4D+JrXOpp4wmV/q3In9C
         2p4Dr4w9WLEIl6a4JNZZi1KZ1+PMX7jl9fWiIHVpf17NmpBOzKnIHv1318Ys2WhUhNj7
         IQ0nH4cfrvp7NaMw8XzJT0JvXXH7h3BbijZYBmARSavCPlhncggosndMpszuuE7Gkdwr
         J3XFANWsOBBe9lKD+lfnWyneHVduxfymp4UBBqmy3WTWDYE92FF+Qtofkl1nELazHI+Y
         20qQgRHzpeIJE69qj6LxSAu8QsyVqY75/xQbbvnh2dU0mblW/8hdgc+C+e5E+9rIHn/k
         qeMQ==
X-Gm-Message-State: AOJu0YwaWS8B0BwfRijXJsnGI/KVg3y0jqDUu1twQdnKmH8XAV7aTKyu
	gppnf7adzf7P442sGDTApRXMoA==
X-Google-Smtp-Source: AGHT+IHf7MXlWtvkPtL4rKaxAjHGg7eiFZd1cU9GCPUEE1OMwcKoAJdSYUPudWARuJ4FPvDMOa6uyA==
X-Received: by 2002:a17:906:7e06:b0:9d3:5d4a:8b6a with SMTP id e6-20020a1709067e0600b009d35d4a8b6amr7254726ejr.42.1699974013091;
        Tue, 14 Nov 2023 07:00:13 -0800 (PST)
Received: from [192.168.69.100] (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id ay18-20020a170906d29200b009ce03057c48sm5685319ejb.214.2023.11.14.07.00.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Nov 2023 07:00:12 -0800 (PST)
Message-ID: <407f32ee-e489-4c05-9c3d-fa6c29bb1d99@linaro.org>
Date: Tue, 14 Nov 2023 16:00:09 +0100
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
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <94D9484A-917D-4970-98DE-35B84BEDA1DC@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14/11/23 15:50, David Woodhouse wrote:
> On 14 November 2023 09:37:57 GMT-05:00, "Philippe Mathieu-Daudé" <philmd@linaro.org> wrote:
>> Add a tag to run all Xen-specific tests using:
>>
>>   $ make check-avocado AVOCADO_TAGS='guest:xen'
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>> tests/avocado/boot_xen.py      | 3 +++
>> tests/avocado/kvm_xen_guest.py | 1 +
>> 2 files changed, 4 insertions(+)
> 
> Those two are very different. One runs on Xen, the other on KVM. Do we want to use the same tag for both?

My understanding is,
- boot_xen.py runs Xen on TCG
- kvm_xen_guest.py runs Xen on KVM
so both runs Xen guests.

Alex, is that incorrect?

