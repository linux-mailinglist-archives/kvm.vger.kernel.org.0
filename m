Return-Path: <kvm+bounces-4459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EAD92812BDE
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 10:42:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F9581F21892
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 09:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AD4B30FBB;
	Thu, 14 Dec 2023 09:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bBpfNUW/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FBFB7
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 01:41:50 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2cb54ab7ffeso69051231fa.3
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 01:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702546908; x=1703151708; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zaSv1cEVN2/csDxZcQM7dUaN1yjFhAc0bctNu6GYJ2s=;
        b=bBpfNUW/6Z/HMKzj/ps4HG21CD/iXvWgAYjZLoJ0fGyG/kr0a9GQiW4vnljlsmrbDZ
         aJWw6M9EhfYR2h6q5wgxLHRwEd7DhUY4tXdac/LxlA+XK/2trCxCdlDMKgll4OzNeqKp
         u9FYE6Te9nq3oqjYcRBnT0gXxwbehZHDEZNdNlx0cEGMRZ5CbYemEHR4bCcYu50l47Ds
         IyH1XrOuxFMA4DFUVkFrLXU5QlFHYB1cvPC39BfyfVi4L5MsnnU1yG8upyrBj0eCwUR5
         1yOzG9/ss9ANDBwi5BZb+fLY5ggGh4LLkK5HfaFIXiFLGdzQtWrbRcz9IU7fKfgDnu7K
         DuWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702546908; x=1703151708;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zaSv1cEVN2/csDxZcQM7dUaN1yjFhAc0bctNu6GYJ2s=;
        b=Frl4UlNuhhP4+2cZB1vhjlDBL+bkw6BJCwHJNILeRlqywABynOVDEXfgq4i4CZfJMB
         JfcK+/Q+Kz7fXLG6MWeIMHj+c5nJRvyLvhh3b0Sp9NvtRaJ618J3sqwsBIyMud5B/qQW
         EgVS+G1CpXeBzwwK/kL/eVX08Y8+4dH+M8Kn9BVQmkvSqB28G2mH5ZcRHKk/JMTyfIPt
         CUZBJ5JjqgtjgZjn0OFYusEbLPkA+YcG3AlmqzQ7MzZIVbeZN2+hJ0A8G0O+Z8e2Kpzr
         twcJjvhk2sHCO15Wq7Ki9dzm3UpRNzhoGEfVInzhMcA5opymWGnOvoGE/ZGXsfq9ESb1
         HEfg==
X-Gm-Message-State: AOJu0Yy+bIMptt8z4eL8x0nJt0LrxL3Z0x3N3ukv+sOxp/EQvDuLHJ+y
	re9VXOk//qoBmzP5s4tYkAWyZQ==
X-Google-Smtp-Source: AGHT+IFUBdWXX+JjH2ebUgEKb8xFppKiJlOwr5a/u/5abODSqBse2b+tPHKVziGzfogMCqlZTYoGag==
X-Received: by 2002:a05:651c:2108:b0:2cb:2b10:ee96 with SMTP id a8-20020a05651c210800b002cb2b10ee96mr4475815ljq.3.1702546908237;
        Thu, 14 Dec 2023 01:41:48 -0800 (PST)
Received: from [192.168.199.175] ([93.23.249.68])
        by smtp.gmail.com with ESMTPSA id m29-20020a50999d000000b0054cc903baadsm6855403edb.30.2023.12.14.01.41.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Dec 2023 01:41:47 -0800 (PST)
Message-ID: <25c403f3-349a-4c4e-8470-2721881b442e@linaro.org>
Date: Thu, 14 Dec 2023 10:41:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] tests/avocado/intel_iommu.py: increase timeout
Content-Language: en-US
To: eric.auger@redhat.com, Cleber Rosa <crosa@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Beraldo Leal <bleal@redhat.com>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 David Woodhouse <dwmw2@infradead.org>
References: <20231208190911.102879-1-crosa@redhat.com>
 <20231208190911.102879-4-crosa@redhat.com> <8734w8fzbc.fsf@draig.linaro.org>
 <87sf45vpad.fsf@p1.localdomain>
 <6140fc8a-4044-4891-854d-9bf555c5dd78@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <6140fc8a-4044-4891-854d-9bf555c5dd78@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14/12/23 08:24, Eric Auger wrote:
> Hi Cleber,
> 
> On 12/13/23 21:08, Cleber Rosa wrote:
>> Alex Bennée <alex.bennee@linaro.org> writes:
>>
>>> Cleber Rosa <crosa@redhat.com> writes:
>>>
>>>> Based on many runs, the average run time for these 4 tests is around
>>>> 250 seconds, with 320 seconds being the ceiling.  In any way, the
>>>> default 120 seconds timeout is inappropriate in my experience.
>>> I would rather see these tests updated to fix:
>>>
>>>   - Don't use such an old Fedora 31 image
>> I remember proposing a bump in Fedora version used by default in
>> avocado_qemu.LinuxTest (which would propagate to tests such as
>> boot_linux.py and others), but that was not well accepted.  I can
>> definitely work on such a version bump again.
>>
>>>   - Avoid updating image packages (when will RH stop serving them?)
>> IIUC the only reason for updating the packages is to test the network
>> from the guest, and could/should be done another way.
>>
>> Eric, could you confirm this?
> Sorry for the delay. Yes effectively I used the dnf install to stress
> the viommu. In the past I was able to trigger viommu bugs that way
> whereas getting an IP @ for the guest was just successful.

Maybe this test is useful as what Daniel described as "Tier 2" [*],
that maintainers run locally but don't need to be gating CI? That
would save us some resources there.

[*] https://lore.kernel.org/qemu-devel/20200427152036.GI1244803@redhat.com/

>>
>>>   - The "test" is a fairly basic check of dmesg/sysfs output
>> Maybe the network is also an implicit check here.  Let's see what Eric
>> has to say.
> 
> To be honest I do not remember how avocado does the check in itself; my
> guess if that if the dnf install does not complete you get a timeout and
> the test fails. But you may be more knowledged on this than me ;-)
> 
> Thanks
> 
> Eric


