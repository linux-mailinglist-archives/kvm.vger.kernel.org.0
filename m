Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546E32D0DFD
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 11:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgLGK2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 05:28:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34100 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726557AbgLGK2c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 05:28:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607336825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MYK9SCRGoM7soozgWZPnpW4pQBMVhd9wGe6LkNWKsP0=;
        b=WH8MF5wl7PRnR5TP5i0ZH7E80VkhtSO92HOZbFzbmE6aSbhjWpbGg14684BZsgNanZe6Sj
        TCZDmtqSbQP2v69GnMv4Azrl4k8FpR/gSS+Ouykno3nJnKtKFLsfJTYrMDQ+RPg/Vp8C3H
        5jPpCc4r/i4y5KsDjpx66EEx40KKtZY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-w728VtWyO8OMMfULiu4K1g-1; Mon, 07 Dec 2020 05:27:03 -0500
X-MC-Unique: w728VtWyO8OMMfULiu4K1g-1
Received: by mail-wm1-f70.google.com with SMTP id g198so3944310wme.7
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 02:27:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MYK9SCRGoM7soozgWZPnpW4pQBMVhd9wGe6LkNWKsP0=;
        b=a1lZ3S4zEHXFp2K5tLU9PRDbQ6Wx6QZZMW5ljeyQe3CH/SD2VSuM5QT4Zjw0bq28WY
         n+eClllWUyIGZW7iIlxAFyyROMty7DIuLSNNiPOH6o8NM+nrOq0+i1MufkaY1rk26rnS
         pdjifNxQMvHFoi8utDn/Iwi/OFEPIwL2mTwEdIsklzK6yMBFVffUWPEvmXENWZbXRmgn
         /16tKQl2GU5/oYKKAkb01mLEsVMw12vmAYtQmJpdyHmbES71lvPdZ96r1oKQmqM1Jh7/
         t9BreVZZe9NiLqBQ1zbYrrj3AdPY43gDdbytzG8WYIEqgXcg6wDEy97LPD2k3AUKwYnr
         gswg==
X-Gm-Message-State: AOAM530JPw2bb7k6eT02soKdN4Q9hlRfybhTUqu6T6NrK1Sx6KbbpesT
        XmpyvSBdqmGWckylGsm9op3tySdGF6vpMifW9X6BjkhylSa5/VMQ3e8so59jmWaCAqs0rN9z3L1
        tbVI1JLM7KDqC
X-Received: by 2002:a5d:5505:: with SMTP id b5mr18809754wrv.410.1607336821229;
        Mon, 07 Dec 2020 02:27:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwpxS69KnKku3sO4CNJaJdpGJkosGMLT7HJYybqboCJTmJrWpUYm5nXWA06aq36q3aIAua9Hw==
X-Received: by 2002:a5d:5505:: with SMTP id b5mr18809725wrv.410.1607336821045;
        Mon, 07 Dec 2020 02:27:01 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id o203sm14297391wmb.0.2020.12.07.02.26.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 02:27:00 -0800 (PST)
Subject: Re: [PATCH 5/8] gitlab-ci: Add KVM s390x cross-build jobs
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        kvm@vger.kernel.org, Paul Durrant <paul@xen.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        xen-devel@lists.xenproject.org,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Claudio Fontana <cfontana@suse.de>
References: <20201206185508.3545711-1-philmd@redhat.com>
 <20201206185508.3545711-6-philmd@redhat.com>
 <66d4d0ab-2bb5-1284-b08a-43c6c30f30dc@redhat.com>
 <20201207102450.GG3102898@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <9233fe7f-8d56-e1ad-b67e-40b3ce5fcabb@redhat.com>
Date:   Mon, 7 Dec 2020 11:26:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201207102450.GG3102898@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 11:25 AM, Daniel P. Berrangé wrote:
> On Mon, Dec 07, 2020 at 06:46:01AM +0100, Thomas Huth wrote:
>> On 06/12/2020 19.55, Philippe Mathieu-Daudé wrote:
>>> Cross-build s390x target with only KVM accelerator enabled.
>>>
>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>>> ---
>>>  .gitlab-ci.d/crossbuilds-kvm-s390x.yml | 6 ++++++
>>>  .gitlab-ci.yml                         | 1 +
>>>  MAINTAINERS                            | 1 +
>>>  3 files changed, 8 insertions(+)
>>>  create mode 100644 .gitlab-ci.d/crossbuilds-kvm-s390x.yml
>>>
>>> diff --git a/.gitlab-ci.d/crossbuilds-kvm-s390x.yml b/.gitlab-ci.d/crossbuilds-kvm-s390x.yml
>>> new file mode 100644
>>> index 00000000000..1731af62056
>>> --- /dev/null
>>> +++ b/.gitlab-ci.d/crossbuilds-kvm-s390x.yml
>>> @@ -0,0 +1,6 @@
>>> +cross-s390x-kvm:
>>> +  extends: .cross_accel_build_job
>>> +  variables:
>>> +    IMAGE: debian-s390x-cross
>>> +    TARGETS: s390x-softmmu
>>> +    ACCEL_CONFIGURE_OPTS: --disable-tcg
>>> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
>>> index 573afceb3c7..a69619d7319 100644
>>> --- a/.gitlab-ci.yml
>>> +++ b/.gitlab-ci.yml
>>> @@ -14,6 +14,7 @@ include:
>>>    - local: '/.gitlab-ci.d/crossbuilds.yml'
>>>    - local: '/.gitlab-ci.d/crossbuilds-kvm-x86.yml'
>>>    - local: '/.gitlab-ci.d/crossbuilds-kvm-arm.yml'
>>> +  - local: '/.gitlab-ci.d/crossbuilds-kvm-s390x.yml'
>>
>> KVM code is already covered by the "cross-s390x-system" job, but an
>> additional compilation test with --disable-tcg makes sense here. I'd then
>> rather name it "cross-s390x-no-tcg" or so instead of "cross-s390x-kvm".
>>
>> And while you're at it, I'd maybe rather name the new file just
>> crossbuilds-s390x.yml and also move the other s390x related jobs into it?
> 
> I don't think we really should split it up so much - just put these
> jobs in the existing crosbuilds.yml file.

Don't we want to leverage MAINTAINERS file?

