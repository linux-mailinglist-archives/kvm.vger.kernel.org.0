Return-Path: <kvm+bounces-4494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 60DAC813185
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 14:27:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 171AB1F221E7
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 13:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75ACC56B67;
	Thu, 14 Dec 2023 13:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aswqkEwH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F203137
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 05:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702560417;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IFAffqF6CJ5tF413gWMsZUdS3F+1RarOrkMLNThRh2g=;
	b=aswqkEwH2gbs93vOONgPekW71o0qacZVgMDNfzUIZT/NDOdUwqct9O7wsnyOQC0oEKN4tK
	fjnhrJ+PHSzw+lkemFtdluEgkiy5p5llDimFLp/Tg7WwCkB1qXdRZizKtckjnIVKf53QyH
	DbiaWhP66aDjm3g+NSwu2i2ciHnJiOk=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-lp5439zRNua0xxywikmdkw-1; Thu, 14 Dec 2023 08:26:56 -0500
X-MC-Unique: lp5439zRNua0xxywikmdkw-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3ba2072052cso3554770b6e.2
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 05:26:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702560415; x=1703165215;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IFAffqF6CJ5tF413gWMsZUdS3F+1RarOrkMLNThRh2g=;
        b=LEiHVP5rimnXXRKMPQBNisC4jtoqQf2yRGYOZGCpSxGhwCl4/KEM1rRNv2ei5u9GPd
         Vb0dJAwhh/o4Wn9DoSuw/JasUlS4j65bb7QEjSVwq/wbC3ToUztY+C90tPfBYKIOpKFZ
         GODoI9k/IrKlITM5zRL7FJnGDFnDCLfXnPqr68aTxIUmdBti32K2h4SuM7C0sza6LVsi
         aDVavohg/EMxXMfOXVCDNkWbh+PuzpwiFN9bKD6hIPoYXeFO00mo+4rHcdWKQ1DHC4Tb
         /Gc0WQ/1X4RlO7VCWFXWWfd2Wq+GjQaXHF38GDt3pSvf3SJ3sew8GeI+IV45w269+Crw
         XHlA==
X-Gm-Message-State: AOJu0YyXEzaKyzjv6vYCYSNprfZa71Xcqtbe1rYq3QabbAm+d3Qj+Kp8
	JhmzF/IVqK5osHb9j7adBB4BIQE0Vx9dlqguL1McSoIg5+hU6eGE8oLcYGFn7vFL2XSw1cQeZ5w
	vYgtsIXqQteWo
X-Received: by 2002:a05:6808:15a0:b0:3b8:8f56:1528 with SMTP id t32-20020a05680815a000b003b88f561528mr12655501oiw.59.1702560415792;
        Thu, 14 Dec 2023 05:26:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH6A0o6LtxHVOtyd6bLE1stOm98A3AEhVYosXAG/J+EBuGTbNiQGBFRYQUwTAT43kL/SCrf1A==
X-Received: by 2002:a05:6808:15a0:b0:3b8:8f56:1528 with SMTP id t32-20020a05680815a000b003b88f561528mr12655487oiw.59.1702560415543;
        Thu, 14 Dec 2023 05:26:55 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id m19-20020ae9e013000000b0076db5b792basm5271768qkk.75.2023.12.14.05.26.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Dec 2023 05:26:54 -0800 (PST)
Message-ID: <9e96236b-4346-434c-8e5e-3cc8fb60c32a@redhat.com>
Date: Thu, 14 Dec 2023 14:26:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 03/10] tests/avocado/intel_iommu.py: increase timeout
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, Radoslaw Biernacki
 <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Beraldo Leal <bleal@redhat.com>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 David Woodhouse <dwmw2@infradead.org>
References: <20231208190911.102879-1-crosa@redhat.com>
 <20231208190911.102879-4-crosa@redhat.com> <8734w8fzbc.fsf@draig.linaro.org>
 <87sf45vpad.fsf@p1.localdomain>
 <6140fc8a-4044-4891-854d-9bf555c5dd78@redhat.com>
 <878r5x9l4b.fsf@draig.linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <878r5x9l4b.fsf@draig.linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 12/14/23 10:41, Alex Bennée wrote:
> Eric Auger <eric.auger@redhat.com> writes:
>
>> Hi Cleber,
>>
>> On 12/13/23 21:08, Cleber Rosa wrote:
>>> Alex Bennée <alex.bennee@linaro.org> writes:
>>>
>>>> Cleber Rosa <crosa@redhat.com> writes:
>>>>
>>>>> Based on many runs, the average run time for these 4 tests is around
>>>>> 250 seconds, with 320 seconds being the ceiling.  In any way, the
>>>>> default 120 seconds timeout is inappropriate in my experience.
>>>> I would rather see these tests updated to fix:
>>>>
>>>>  - Don't use such an old Fedora 31 image
>>> I remember proposing a bump in Fedora version used by default in
>>> avocado_qemu.LinuxTest (which would propagate to tests such as
>>> boot_linux.py and others), but that was not well accepted.  I can
>>> definitely work on such a version bump again.
>>>
>>>>  - Avoid updating image packages (when will RH stop serving them?)
>>> IIUC the only reason for updating the packages is to test the network
>>> from the guest, and could/should be done another way.
>>>
>>> Eric, could you confirm this?
>> Sorry for the delay. Yes effectively I used the dnf install to stress
>> the viommu. In the past I was able to trigger viommu bugs that way
>> whereas getting an IP @ for the guest was just successful.
>>>>  - The "test" is a fairly basic check of dmesg/sysfs output
>>> Maybe the network is also an implicit check here.  Let's see what Eric
>>> has to say.
>> To be honest I do not remember how avocado does the check in itself; my
>> guess if that if the dnf install does not complete you get a timeout and
>> the test fails. But you may be more knowledged on this than me ;-)
> I guess the problem is relying on external infrastructure can lead to
> unpredictable results. However its a lot easier to configure user mode
> networking just to pull something off the internet than have a local
> netperf or some such setup to generate local traffic.
>
> I guess there is no loopback like setup which would sufficiently
> exercise the code?

I don't think so. This test is a reproducer for a bug I encountered and
fixed in the past.
Besudes, I am totally fine moving the test out of the gating CI and just
keep it as a tier2 test, as suggested by Phil.

Thanks

Eric
>
>> Thanks
>>
>> Eric
>>>> I think building a buildroot image with the tools pre-installed (with
>>>> perhaps more testing) would be a better use of our limited test time.
>>>>
>>>> FWIW the runtime on my machine is:
>>>>
>>>> ➜  env QEMU_TEST_FLAKY_TESTS=1 ./pyvenv/bin/avocado run ./tests/avocado/intel_iommu.py
>>>> JOB ID     : 5c582ccf274f3aee279c2208f969a7af8ceb9943
>>>> JOB LOG    : /home/alex/avocado/job-results/job-2023-12-11T16.53-5c582cc/job.log
>>>>  (1/4) ./tests/avocado/intel_iommu.py:IntelIOMMU.test_intel_iommu: PASS (44.21 s)
>>>>  (2/4) ./tests/avocado/intel_iommu.py:IntelIOMMU.test_intel_iommu_strict: PASS (78.60 s)
>>>>  (3/4) ./tests/avocado/intel_iommu.py:IntelIOMMU.test_intel_iommu_strict_cm: PASS (65.57 s)
>>>>  (4/4) ./tests/avocado/intel_iommu.py:IntelIOMMU.test_intel_iommu_pt: PASS (66.63 s)
>>>> RESULTS    : PASS 4 | ERROR 0 | FAIL 0 | SKIP 0 | WARN 0 | INTERRUPT 0 | CANCEL 0
>>>> JOB TIME   : 255.43 s
>>>>
>>> Yes, I've also seen similar runtimes in other environments... so it
>>> looks like it depends a lot on the "dnf -y install numactl-devel".  If
>>> that can be removed, the tests would have much more predictable runtimes.
>>>


