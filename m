Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21B72D0DFB
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 11:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgLGK1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 05:27:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44929 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725802AbgLGK1h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 05:27:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607336770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J/MxqDMH4iax6gZAnLZgFNJcpANG56pQVPbXFBf8CsE=;
        b=NU6mvteMJw+bK8pnh+4Cdk/dLukYNzRI8kcUcW+VfdmZopyECIqiG2UUUuEDwC+FerGtMZ
        AEzbjXoxI0B6rLKIKFGZu4i+S3znekBniHKjb0Wy6N93vOMPsDof/nRs/9cjGWc87YZdYq
        Li02V/laYJiZNcZ/ZADbroNmTbXQ9dQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-RNpfO6cMPXaBmRs9V91tVQ-1; Mon, 07 Dec 2020 05:26:08 -0500
X-MC-Unique: RNpfO6cMPXaBmRs9V91tVQ-1
Received: by mail-wr1-f70.google.com with SMTP id n13so4698177wrs.10
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 02:26:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J/MxqDMH4iax6gZAnLZgFNJcpANG56pQVPbXFBf8CsE=;
        b=dJWh1s5+ng461cbtNnqItzLVshEvKROchtHwoCyi0tR2+VhQ2IzqIEn7fbjUlFOL2z
         ekJiMKuApp+n9n5vuXSAv8WRRzstI363+f9WHx4wVjnl9ggHRgUGXGfstTvXMRF74gHF
         7J/AMvXR3DZrRFB6Va6wg3ojV2Oggsi/fq4iR9RjWmA/dK1St0TfgwgEgnFB7jk5erHT
         zrFJ3MFyevBsVq5h5710U5Sm33MTqNW7Eb/JFJasaPqukRl7o48jOhYiy7LiYFEiZF47
         0uBqO5eVMMgF/KXIyvf0S961VIyRGgA+Ca7Hpe/dJiZ3iVxUzThUlTWd0T5WB04lhNG9
         /6Ug==
X-Gm-Message-State: AOAM532spGQjAYaK+NDw2zZJ5Xalg4tyT34e0hpgUkKP6gh7YWICVvyz
        L1354wGFfEa5tjKUTHifToQYsFwpOR8GTNiBNetShzsZLsuWN9xGlBp2dmmZyHdRlkB7lJ+qcD5
        wBmCtOD0TscH8
X-Received: by 2002:adf:f7c7:: with SMTP id a7mr18479903wrq.347.1607336767410;
        Mon, 07 Dec 2020 02:26:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwhcAghl9OpXDUnMnlNasl3UZRYONq9ISpQW3iUKTZZ4vH7cH2+LswiXSeNsBKrig5E8lZLoA==
X-Received: by 2002:adf:f7c7:: with SMTP id a7mr18479882wrq.347.1607336767232;
        Mon, 07 Dec 2020 02:26:07 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id n189sm13572019wmf.20.2020.12.07.02.26.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 02:26:06 -0800 (PST)
Subject: Re: [PATCH 5/8] gitlab-ci: Add KVM s390x cross-build jobs
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
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
 <2352c04c-829e-ea1d-0894-15fc1d06697a@redhat.com>
Message-ID: <cd5d00b1-999a-fbb3-204e-a759a9e2c3ec@redhat.com>
Date:   Mon, 7 Dec 2020 11:26:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <2352c04c-829e-ea1d-0894-15fc1d06697a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 11:00 AM, Philippe Mathieu-Daudé wrote:
> On 12/7/20 6:46 AM, Thomas Huth wrote:
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

What other accelerators are available on 390?

> 
> As you wish. What I want is to let Gitlab users be able to build the
> equivalent "[s390x] Clang (disable-tcg)" from Travis.
> 
> I keep using GCC toolchain because managing job coverage duplication
> is an unresolved problem.
> 
>>
>> And while you're at it, I'd maybe rather name the new file just
>> crossbuilds-s390x.yml and also move the other s390x related jobs into it?
> 
> OK will do.
> 
> Thanks,
> 
> Phil.
> 

