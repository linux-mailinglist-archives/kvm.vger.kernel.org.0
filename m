Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625BC2D082A
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbgLFXqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:46:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52945 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbgLFXqO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 6 Dec 2020 18:46:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607298287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EVBInixgmn136ovV1rZRYaD9AJ24IiI0pMFI4QniZVU=;
        b=ZPnoksmjWyUA3DZT73/aj4xJZqJZTpQXTVbtouEC2ek8xONhxzEnp4rLRCXW5qfh0L0JpU
        Z5Y17C5+3GagyFqFzKSBk4q1kR8jGlmzlsDNCOKPDtoiiNP2H8Ns6UEe3M3WjX6gvFZcX/
        nq7tkmt966EupI2DkIK9oXo8fZiwo9A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-Bo_ArtGrOtOMdBbCNsVy3A-1; Sun, 06 Dec 2020 18:44:43 -0500
X-MC-Unique: Bo_ArtGrOtOMdBbCNsVy3A-1
Received: by mail-wr1-f70.google.com with SMTP id m2so4411104wro.1
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:44:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EVBInixgmn136ovV1rZRYaD9AJ24IiI0pMFI4QniZVU=;
        b=l2M5b4DzKmCFnXAwFSOavx4bCX/GbWHH3g7we110uz4q62xQCF0XjlXXZP0tEmGBAN
         bddxmkGqKDKyqYkQNI8FMHknEYrk/sHH0BLziTh11IDhv4cVH6NVYtrHcH4FzSoN6vse
         hBjO1WgvmVFR6g8hVHwV89fgNgDuh8NyY0dlg9RJ/lmLoUwOl8SznxWdAN5NXD5Oem4S
         ufVCclKSORurYe8IDoiDe5EKdj0Q4MQTjFWu1M2hbrtpl7NBpXxbChyAS52oLY+SvTkD
         lnmfoHv0BWeGxCdeSgY7asnDOFHot2vM375mpZuB0gcMnSAb3omLx9jid87uRBNbp8xE
         2ZOQ==
X-Gm-Message-State: AOAM530RYM2xQazkmxIsgxuZqsOrwyp5fYv0VEk+oI5WMb21DQ6RpoCl
        0NVq1Fyc/8VCSizMOQhYu2dXPPRq+LoR3TsW8P3o3enAxxZA+pA1YULeNmvnZFC2HryySGPPLhI
        DRsfNGxYYSn5Y
X-Received: by 2002:a7b:c303:: with SMTP id k3mr15698504wmj.21.1607298282181;
        Sun, 06 Dec 2020 15:44:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz9Ly/Z3VYUD9ldB9eMDBoFXsydwmOnqU35i1cTdXNWpuYJCJR1JajcbqGx6vrhzpycS4B9gw==
X-Received: by 2002:a7b:c303:: with SMTP id k3mr15698481wmj.21.1607298282031;
        Sun, 06 Dec 2020 15:44:42 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id c9sm12697020wrp.73.2020.12.06.15.44.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Dec 2020 15:44:41 -0800 (PST)
Subject: Re: [PATCH 2/8] gitlab-ci: Introduce 'cross_accel_build_job' template
To:     Claudio Fontana <cfontana@suse.de>
Cc:     qemu-devel@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Paul Durrant <paul@xen.org>, Huacai Chen <chenhc@lemote.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-s390x@nongnu.org,
        Aurelien Jarno <aurelien@aurel32.net>, qemu-arm@nongnu.org
References: <20201206185508.3545711-1-philmd@redhat.com>
 <20201206185508.3545711-3-philmd@redhat.com>
 <1691b11e-dd40-8a15-6a34-d5e817f95027@suse.de>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <c3b42add-6586-8723-ab81-4fdd660277fc@redhat.com>
Date:   Mon, 7 Dec 2020 00:44:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1691b11e-dd40-8a15-6a34-d5e817f95027@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 8:23 PM, Claudio Fontana wrote:
> On 12/6/20 7:55 PM, Philippe Mathieu-Daudé wrote:
>> Introduce a job template to cross-build accelerator specific
>> jobs (enable a specific accelerator, disabling the others).
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>  .gitlab-ci.d/crossbuilds.yml | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/.gitlab-ci.d/crossbuilds.yml b/.gitlab-ci.d/crossbuilds.yml
>> index 099949aaef3..be63b209c5b 100644
>> --- a/.gitlab-ci.d/crossbuilds.yml
>> +++ b/.gitlab-ci.d/crossbuilds.yml
>> @@ -13,6 +13,18 @@
>>            xtensa-softmmu"
>>      - make -j$(expr $(nproc) + 1) all check-build
>>  
>> +.cross_accel_build_job:
>> +  stage: build
>> +  image: $CI_REGISTRY_IMAGE/qemu/$IMAGE:latest
>> +  timeout: 30m
>> +  script:
>> +    - mkdir build
>> +    - cd build
>> +    - PKG_CONFIG_PATH=$PKG_CONFIG_PATH
>> +      ../configure --enable-werror $QEMU_CONFIGURE_OPTS --disable-tools
>> +        --enable-${ACCEL:-kvm} --target-list="$TARGETS" $ACCEL_CONFIGURE_OPTS
>> +    - make -j$(expr $(nproc) + 1) all check-build
>> +
>>  .cross_user_build_job:
>>    stage: build
>>    image: $CI_REGISTRY_IMAGE/qemu/$IMAGE:latest
>>
> 
> Hi Philippe,
> 
> probably I just don't understand how this works, but
> where is the "disabling the others" part?

Sorry I forgot to document $ACCEL_CONFIGURE_OPTS, which
can be used to amend options. See x86 and s390x jobs
(the only one buildable without TCG afaik) use:

    ACCEL_CONFIGURE_OPTS: --disable-tcg

> 
> I see the --enable-${ACCEL:-kvm}, but I would expect some --disable-XXX ?
> 
> I am probably just missing something..

The goal of this series is not to test --disable-tcg, but
to test --enable-kvm when you don't have access to a host
arch. I see testing --disable-tcg as a bonus :)

> 
> Thanks,
> 
> Ciao,
> 
> Claudio
> 

