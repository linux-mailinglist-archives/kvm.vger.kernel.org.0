Return-Path: <kvm+bounces-4077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 92E6580D207
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 17:37:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 479D51F21572
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 16:37:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CEE26128;
	Mon, 11 Dec 2023 16:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o2gzs8hc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6493695
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 08:37:47 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-54dca2a3f16so8561123a12.0
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 08:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702312665; x=1702917465; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aZ9XXmId1yzNKbpMkkoAkMgLTFP9oyzkyWQqbnJsHh8=;
        b=o2gzs8hcrmIOWWCCnnNHs+5/KZUi2dQir76xtVHPQjdh5V6d9T4V4NE1iCwn8HM3iN
         PasqyilK5hiTyHrs+z0FBE9C75g6uYKoGKN2jkqZLi2eDolRfHlepRt4PjbHimJKcNR9
         i5PENlscPQIhKLzXnCU+v1Gk2qHIiQDlM+UBmSScvcjOkaoi81WzRhtqd0K6VR7BZs9G
         aNzBV1SybmBx9uHhQlmP1bWD9BCZ2lDZJltXeVoeXQDgX/BSsnC0868GDLPeSrw/32rH
         Zvzat9zVYu4AVcNavNjHkdVwEHhOI6fw3UC/aGzYKYyBmWa06fi+xQ8jNS2BAP+Y/HS3
         WceA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702312665; x=1702917465;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aZ9XXmId1yzNKbpMkkoAkMgLTFP9oyzkyWQqbnJsHh8=;
        b=jR8vFzckME76y3qohBIPNGCCyQkzue5RUOa6r1OwmJppGfMHjjWTCEVqDJoVnSS/9X
         AIfH/RrajDhP7ZAkl2+W0rydNnlbl9Bmi9jbUV7I4FD5bHX0CjnvtgEnlv3YJzEP3TDm
         4/nd4gRqBiHotGmhcqoyzxu2g+9ZxYgps8kB0RVibY9lnGezzkXU3YgVR5q7ifR1n8K9
         Dg3YbAYXXyMLMQu4aIKmd3ed1Xfcf8B5wLIwSARHosNzrw1OWle8tH7y8WTHEh/XlyGO
         oBWGpGN4lxiffnBh/FMI1V0qBLIttwy/c2N+DBJ+NRiymjyCMCzznVQkDgI5NdQh0Dxd
         Cflw==
X-Gm-Message-State: AOJu0YzNuCK5DQ4VCrg7CP3wow7kyWJj+g7TY3esYRODGTz2VOWH8oRD
	MzCjvOtT94LLD4qBfSLrWNVFlQ==
X-Google-Smtp-Source: AGHT+IGuPhejSEsdQBopcEBi2QQyqELHJP5rBS4xsF9O6h21RXEDalMYKXGwzBhKJWBGWOsAMrAilQ==
X-Received: by 2002:a17:907:60c7:b0:a1c:4c3e:99e2 with SMTP id hv7-20020a17090760c700b00a1c4c3e99e2mr5132099ejc.22.1702312665779;
        Mon, 11 Dec 2023 08:37:45 -0800 (PST)
Received: from [192.168.69.100] (cor91-h02-176-184-30-150.dsl.sta.abo.bbox.fr. [176.184.30.150])
        by smtp.gmail.com with ESMTPSA id rd12-20020a170907a28c00b00a097c5162b0sm4995159ejc.87.2023.12.11.08.37.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Dec 2023 08:37:45 -0800 (PST)
Message-ID: <fecb9b5d-caa3-438c-aa78-4775c2ef2002@linaro.org>
Date: Mon, 11 Dec 2023 17:37:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/10] tests/avocado/boot_xen.py: unify tags
Content-Language: en-US
To: Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Beraldo Leal <bleal@redhat.com>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 David Woodhouse <dwmw2@infradead.org>
References: <20231208190911.102879-1-crosa@redhat.com>
 <20231208190911.102879-10-crosa@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20231208190911.102879-10-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/12/23 20:09, Cleber Rosa wrote:
> Because all tests share the same tags, it's possible to have all of
> them at the class level.
> 
> Signed-off-by: Cleber Rosa <crosa@redhat.com>
> ---
>   tests/avocado/boot_xen.py | 26 +++++---------------------
>   1 file changed, 5 insertions(+), 21 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


