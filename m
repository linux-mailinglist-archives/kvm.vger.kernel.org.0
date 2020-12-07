Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CC52D0F00
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 12:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgLGL1j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 06:27:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23153 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726322AbgLGL1i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 06:27:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607340371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E8SnAm7lBjFJY33tSzEd+s5+QBCNZ6+uVzsTHaYTIOw=;
        b=jQlZ8crDBhMSMDBbAv5MahTWqG042nlTOgzgRQJLkDO2BuWQFHUhBIoBbItKF38lYQLksR
        z0yQHljwMHwsrjbOQmcs1+6BRdw5oCK1HcqdmhEDwC85u91r39+UZCICQgI51qQU/RqbwW
        JBn4z9SC2cgOCvKOKhXglXIWpSrEJaM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-XBhMQkgHPLSA52I_I_7l8A-1; Mon, 07 Dec 2020 06:26:10 -0500
X-MC-Unique: XBhMQkgHPLSA52I_I_7l8A-1
Received: by mail-wm1-f71.google.com with SMTP id k128so5203833wme.7
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 03:26:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E8SnAm7lBjFJY33tSzEd+s5+QBCNZ6+uVzsTHaYTIOw=;
        b=JktNW3APRBotljWI1usTycDuJD4oZ5fmTmg2piUD3B16TSI5I9Tae3E2iQ22yYDHbM
         mbGwmC768k0iudrrGVJd9wOJ/jmGHOfadtJFkGg9z3J97fnpIuLAhtZjF8ts1OgZDpGQ
         imEWykyNoO13mREC5zwQT8xlWaBMuYepdKUppiANNdvG19YCq2wykZzmUrPrWq3F/pc4
         8Bm5rChaoVUWhey2/QbJabBJQjn4Iu65iXF/pKfCYLDkBjrL3l9PDru1pKBGOgFPfdb4
         EqJjhttProWNAtHrrs1xstWNaOAorEgYL91LDbzqTcsBZnkshlDkQeCcV66qsyKyS7sj
         U1eQ==
X-Gm-Message-State: AOAM531N0HXkC9lbLhP8cr/yxtDKVRa6Dx1k6vh0tj7IxXx0q9oBTgJF
        tzDIwmuccbjTeKkjTZuy8uyfsEtofvHehvsfIdiPTWe+Qszy30Kumk7bogN7MJRKGE1rzgVBNyn
        SdSEe77onKmcR
X-Received: by 2002:a5d:4c4e:: with SMTP id n14mr9412283wrt.209.1607340368502;
        Mon, 07 Dec 2020 03:26:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwcLG0ly5fRNXTnumnXcvmnqbciuOeraAOT2K0u9vBpVFo7cpgUmtymDQM92D6CgbpOtloTWw==
X-Received: by 2002:a5d:4c4e:: with SMTP id n14mr9412242wrt.209.1607340368301;
        Mon, 07 Dec 2020 03:26:08 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id s4sm14921932wra.91.2020.12.07.03.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 03:26:07 -0800 (PST)
Subject: Re: [PATCH 5/8] gitlab-ci: Add KVM s390x cross-build jobs
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paul Durrant <paul@xen.org>, Cornelia Huck <cohuck@redhat.com>,
        qemu-devel@nongnu.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, Claudio Fontana <cfontana@suse.de>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Gibson <david@gibson.dropbear.id.au>
References: <20201206185508.3545711-1-philmd@redhat.com>
 <20201206185508.3545711-6-philmd@redhat.com>
 <66d4d0ab-2bb5-1284-b08a-43c6c30f30dc@redhat.com>
 <20201207102450.GG3102898@redhat.com>
 <9233fe7f-8d56-e1ad-b67e-40b3ce5fcabb@redhat.com>
 <20201207103430.GI3102898@redhat.com>
 <3bb741d3-aaf7-8d73-1990-efc01e3e8977@redhat.com>
Message-ID: <6c7ef8e8-f2ab-9388-0058-4740bdcfd69a@redhat.com>
Date:   Mon, 7 Dec 2020 12:26:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <3bb741d3-aaf7-8d73-1990-efc01e3e8977@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 12:14 PM, Philippe Mathieu-Daudé wrote:
> On 12/7/20 11:34 AM, Daniel P. Berrangé wrote:
>> On Mon, Dec 07, 2020 at 11:26:58AM +0100, Philippe Mathieu-Daudé wrote:
>>> On 12/7/20 11:25 AM, Daniel P. Berrangé wrote:
>>>> On Mon, Dec 07, 2020 at 06:46:01AM +0100, Thomas Huth wrote:
>>>>> On 06/12/2020 19.55, Philippe Mathieu-Daudé wrote:
>>>>>> Cross-build s390x target with only KVM accelerator enabled.
>>>>>>
>>>>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>>>>>> ---
>>>>>>  .gitlab-ci.d/crossbuilds-kvm-s390x.yml | 6 ++++++
>>>>>>  .gitlab-ci.yml                         | 1 +
>>>>>>  MAINTAINERS                            | 1 +
>>>>>>  3 files changed, 8 insertions(+)
>>>>>>  create mode 100644 .gitlab-ci.d/crossbuilds-kvm-s390x.yml
>>>>>>
>>>>>> diff --git a/.gitlab-ci.d/crossbuilds-kvm-s390x.yml b/.gitlab-ci.d/crossbuilds-kvm-s390x.yml
>>>>>> new file mode 100644
>>>>>> index 00000000000..1731af62056
>>>>>> --- /dev/null
>>>>>> +++ b/.gitlab-ci.d/crossbuilds-kvm-s390x.yml
>>>>>> @@ -0,0 +1,6 @@
>>>>>> +cross-s390x-kvm:
>>>>>> +  extends: .cross_accel_build_job
>>>>>> +  variables:
>>>>>> +    IMAGE: debian-s390x-cross
>>>>>> +    TARGETS: s390x-softmmu
>>>>>> +    ACCEL_CONFIGURE_OPTS: --disable-tcg
>>>>>> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
>>>>>> index 573afceb3c7..a69619d7319 100644
>>>>>> --- a/.gitlab-ci.yml
>>>>>> +++ b/.gitlab-ci.yml
>>>>>> @@ -14,6 +14,7 @@ include:
>>>>>>    - local: '/.gitlab-ci.d/crossbuilds.yml'
>>>>>>    - local: '/.gitlab-ci.d/crossbuilds-kvm-x86.yml'
>>>>>>    - local: '/.gitlab-ci.d/crossbuilds-kvm-arm.yml'
>>>>>> +  - local: '/.gitlab-ci.d/crossbuilds-kvm-s390x.yml'
>>>>>
>>>>> KVM code is already covered by the "cross-s390x-system" job, but an
>>>>> additional compilation test with --disable-tcg makes sense here. I'd then
>>>>> rather name it "cross-s390x-no-tcg" or so instead of "cross-s390x-kvm".
>>>>>
>>>>> And while you're at it, I'd maybe rather name the new file just
>>>>> crossbuilds-s390x.yml and also move the other s390x related jobs into it?
>>>>
>>>> I don't think we really should split it up so much - just put these
>>>> jobs in the existing crosbuilds.yml file.
>>>
>>> Don't we want to leverage MAINTAINERS file?
>>
>> As mentioned in the cover letter, I think this is mis-using the MAINTAINERS
>> file to try to represent something different.
>>
>> The MAINTAINERS file says who is responsible for the contents of the .yml
>> file, which is the CI maintainers, because we want a consistent gitlab
>> configuration as a whole, not everyone doing their own thing.
>>
>> MAINTAINERS doesn't say who is responsible for making sure the actual
>> jobs that run are passing, which is potentially a completely different
>> person. If we want to track that, it is not the MAINTAINERS file.
> 
> Thanks, I was expecting subsystem maintainers would worry about the
> CI jobs, but you made it clear this should be different persons who
> look after CI. I understand it is better to have no maintainer than
> to have incorrect maintainer.

MAINTAINERS and scripts/get_maintainer.pl doesn't scale well with
YAML / JSON... While this files are maintained by the Gitlab
subsystem maintainers, how can we had job-specific reviewers?

