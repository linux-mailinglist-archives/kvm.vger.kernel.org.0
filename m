Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162C82D0DAF
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 11:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgLGKBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 05:01:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31097 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726641AbgLGKBj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 05:01:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607335212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jkvd7LrgfbA/3UaWz+BLuo3xobAs3RImgpzqIL+38Gs=;
        b=QfJL7SrLO/7J5nZCqRP99ADVzZgu9TrDtsm2xGg0/N/fDS4ZCMTZO3bcceBzx9R9tY32lE
        uMRSeGXM4ToCfnx8EMiLG0iMBqE94IRNy2X+oLzvhAPGfrjfcjreZY7+PuUr16R6yI3EB/
        7wonqoTO6kYgQdCW5DvBE7BeULRYVn8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-NRKNzkAENyKi6g-OJXuiuQ-1; Mon, 07 Dec 2020 05:00:10 -0500
X-MC-Unique: NRKNzkAENyKi6g-OJXuiuQ-1
Received: by mail-wr1-f69.google.com with SMTP id x10so4699035wrs.2
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 02:00:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jkvd7LrgfbA/3UaWz+BLuo3xobAs3RImgpzqIL+38Gs=;
        b=FexS6Ko6TugO5gqtvALBE8iooNXb9ASUX9oBsDf+7RRDXnGMdSb3WEcNi+zbDF/Rf1
         CWCrtYuEvZZcukQnhEK/p8wf06WV7DQcEOe7BZHKQ1OhgGprzdB8etGJAxT48+hc1nYK
         hCI4ChTOIpxjTuyBG/Jio7WCHO+WJN+wLzLExpz1XWhOCSlwG27my0mJhZudnaEyYyKq
         7dXi+jSRY8vr/jjRj23rdE1G/5UfKPN5REdYSM7RXRtgAjEPNVVPQ6cSrheGinFq/sfX
         0z4lOCRgFFTUukJN2HULYGqClQnuL8iag9Si97uIfZc8DRxlRlFbQ289QlGp0kib7GmB
         Cb0g==
X-Gm-Message-State: AOAM531RQzQ68dqPtkZrdd+naPdqpihIsvh2D+E75a/six66XmQLYZwM
        l6iM5pmj0qxJ6KeCAhnn2uydrGNNVvV2WhH4ff6o7Q8JV7TXVzZnTy/JncxIjlBKAWU8N1a9sxt
        OaX8q80dRPZhc
X-Received: by 2002:a1c:6208:: with SMTP id w8mr17496909wmb.96.1607335207834;
        Mon, 07 Dec 2020 02:00:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw3EYRHSI+t9NVpsM0Mrbn468kurkRbJwfsRKh9URZe4lUy/zhC9c0UawCuc4XOtBW1JeEjjA==
X-Received: by 2002:a1c:6208:: with SMTP id w8mr17496881wmb.96.1607335207639;
        Mon, 07 Dec 2020 02:00:07 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id c1sm13112995wml.8.2020.12.07.02.00.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 02:00:06 -0800 (PST)
Subject: Re: [PATCH 5/8] gitlab-ci: Add KVM s390x cross-build jobs
To:     Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Paul Durrant <paul@xen.org>, Huacai Chen <chenhc@lemote.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Claudio Fontana <cfontana@suse.de>,
        Halil Pasic <pasic@linux.ibm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-s390x@nongnu.org,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201206185508.3545711-1-philmd@redhat.com>
 <20201206185508.3545711-6-philmd@redhat.com>
 <66d4d0ab-2bb5-1284-b08a-43c6c30f30dc@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <2352c04c-829e-ea1d-0894-15fc1d06697a@redhat.com>
Date:   Mon, 7 Dec 2020 11:00:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <66d4d0ab-2bb5-1284-b08a-43c6c30f30dc@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 6:46 AM, Thomas Huth wrote:
> On 06/12/2020 19.55, Philippe Mathieu-Daudé wrote:
>> Cross-build s390x target with only KVM accelerator enabled.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>  .gitlab-ci.d/crossbuilds-kvm-s390x.yml | 6 ++++++
>>  .gitlab-ci.yml                         | 1 +
>>  MAINTAINERS                            | 1 +
>>  3 files changed, 8 insertions(+)
>>  create mode 100644 .gitlab-ci.d/crossbuilds-kvm-s390x.yml
>>
>> diff --git a/.gitlab-ci.d/crossbuilds-kvm-s390x.yml b/.gitlab-ci.d/crossbuilds-kvm-s390x.yml
>> new file mode 100644
>> index 00000000000..1731af62056
>> --- /dev/null
>> +++ b/.gitlab-ci.d/crossbuilds-kvm-s390x.yml
>> @@ -0,0 +1,6 @@
>> +cross-s390x-kvm:
>> +  extends: .cross_accel_build_job
>> +  variables:
>> +    IMAGE: debian-s390x-cross
>> +    TARGETS: s390x-softmmu
>> +    ACCEL_CONFIGURE_OPTS: --disable-tcg
>> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
>> index 573afceb3c7..a69619d7319 100644
>> --- a/.gitlab-ci.yml
>> +++ b/.gitlab-ci.yml
>> @@ -14,6 +14,7 @@ include:
>>    - local: '/.gitlab-ci.d/crossbuilds.yml'
>>    - local: '/.gitlab-ci.d/crossbuilds-kvm-x86.yml'
>>    - local: '/.gitlab-ci.d/crossbuilds-kvm-arm.yml'
>> +  - local: '/.gitlab-ci.d/crossbuilds-kvm-s390x.yml'
> 
> KVM code is already covered by the "cross-s390x-system" job, but an
> additional compilation test with --disable-tcg makes sense here. I'd then
> rather name it "cross-s390x-no-tcg" or so instead of "cross-s390x-kvm".

As you wish. What I want is to let Gitlab users be able to build the
equivalent "[s390x] Clang (disable-tcg)" from Travis.

I keep using GCC toolchain because managing job coverage duplication
is an unresolved problem.

> 
> And while you're at it, I'd maybe rather name the new file just
> crossbuilds-s390x.yml and also move the other s390x related jobs into it?

OK will do.

Thanks,

Phil.

