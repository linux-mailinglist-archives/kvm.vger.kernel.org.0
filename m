Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C2D2D0EC5
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 12:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgLGLQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 06:16:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47800 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726198AbgLGLQH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 06:16:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607339679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d3due4jAC9MTV0mBnYKTJ7whzzjRsNAmshkXoWCe6CY=;
        b=hEzfI8QhHpBU3XWwe/cBDzu488W5eUA8mkOmg3DSsG/3Ih33s+szJVvyZeScslOZowqa4q
        oVeVemqRpj/lMeGShTONxTB2gXgM525n0q8n8xVjOpCjdnRyJW2Ptz5mGc+Ah7pUIe2/SI
        jT6Ox2h352vSrfnmX0uIimHJ0pcQCyc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-u8KOGwl_O8aLmXoFNoU0yQ-1; Mon, 07 Dec 2020 06:14:38 -0500
X-MC-Unique: u8KOGwl_O8aLmXoFNoU0yQ-1
Received: by mail-wr1-f69.google.com with SMTP id i4so1360456wrm.21
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 03:14:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d3due4jAC9MTV0mBnYKTJ7whzzjRsNAmshkXoWCe6CY=;
        b=p6ztGdAeiRBI1MAovwhVmVjkDFxSzfku6tVcRVbjblWMAF5bp/MlvoCkWjWZOtcth6
         ROjgPOE9M1Lq1U5tjA16m2aADo1MQAwX4FYgyjrPLfhJCHsNhtKE3euuIyrcy8+3x3f1
         ijSP5n7wOMqyuDiLZ5TS7JZ+CRbD6GIhsp4kCldi9CDrHO1NfXMLSiItudYAttt4pAf7
         DRN9Q7P9xvJP/MnVrtOyhNblOge2X5x9pOF182A5fe4X9wTD97M4/R8ewuqExYRSBKVy
         7ktKWWUbNg5hi2SGHpw/q49wr1PbzXMZnss/ANmpV1aDtz/s8PYGwObdUvsaDlOYLWp3
         m3Xw==
X-Gm-Message-State: AOAM531pftCMw4BX2jX07eKMXl3LlgB1XjxsqqALpstS3NZqMjI3f1H3
        cnppS7X9ajJj6j75swrK47Y75D/LXAhxgqvJj3MenPlmv0ozRIkjBLvzAdemOEHP/10YayWrGqv
        HfEAOiCe0UUMt
X-Received: by 2002:a1c:e0d4:: with SMTP id x203mr18329761wmg.68.1607339676035;
        Mon, 07 Dec 2020 03:14:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx39v2hZ0fbf4DvQybV80l5NVeeedH84TOXnjX8rQjHffosdw7+EPGiVnjKS5k8UtdPHq9RPg==
X-Received: by 2002:a1c:e0d4:: with SMTP id x203mr18329736wmg.68.1607339675852;
        Mon, 07 Dec 2020 03:14:35 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id 101sm8204198wrc.11.2020.12.07.03.14.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 03:14:35 -0800 (PST)
Subject: Re: [PATCH 5/8] gitlab-ci: Add KVM s390x cross-build jobs
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
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <3bb741d3-aaf7-8d73-1990-efc01e3e8977@redhat.com>
Date:   Mon, 7 Dec 2020 12:14:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201207103430.GI3102898@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 11:34 AM, Daniel P. Berrangé wrote:
> On Mon, Dec 07, 2020 at 11:26:58AM +0100, Philippe Mathieu-Daudé wrote:
>> On 12/7/20 11:25 AM, Daniel P. Berrangé wrote:
>>> On Mon, Dec 07, 2020 at 06:46:01AM +0100, Thomas Huth wrote:
>>>> On 06/12/2020 19.55, Philippe Mathieu-Daudé wrote:
>>>>> Cross-build s390x target with only KVM accelerator enabled.
>>>>>
>>>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>>>>> ---
>>>>>  .gitlab-ci.d/crossbuilds-kvm-s390x.yml | 6 ++++++
>>>>>  .gitlab-ci.yml                         | 1 +
>>>>>  MAINTAINERS                            | 1 +
>>>>>  3 files changed, 8 insertions(+)
>>>>>  create mode 100644 .gitlab-ci.d/crossbuilds-kvm-s390x.yml
>>>>>
>>>>> diff --git a/.gitlab-ci.d/crossbuilds-kvm-s390x.yml b/.gitlab-ci.d/crossbuilds-kvm-s390x.yml
>>>>> new file mode 100644
>>>>> index 00000000000..1731af62056
>>>>> --- /dev/null
>>>>> +++ b/.gitlab-ci.d/crossbuilds-kvm-s390x.yml
>>>>> @@ -0,0 +1,6 @@
>>>>> +cross-s390x-kvm:
>>>>> +  extends: .cross_accel_build_job
>>>>> +  variables:
>>>>> +    IMAGE: debian-s390x-cross
>>>>> +    TARGETS: s390x-softmmu
>>>>> +    ACCEL_CONFIGURE_OPTS: --disable-tcg
>>>>> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
>>>>> index 573afceb3c7..a69619d7319 100644
>>>>> --- a/.gitlab-ci.yml
>>>>> +++ b/.gitlab-ci.yml
>>>>> @@ -14,6 +14,7 @@ include:
>>>>>    - local: '/.gitlab-ci.d/crossbuilds.yml'
>>>>>    - local: '/.gitlab-ci.d/crossbuilds-kvm-x86.yml'
>>>>>    - local: '/.gitlab-ci.d/crossbuilds-kvm-arm.yml'
>>>>> +  - local: '/.gitlab-ci.d/crossbuilds-kvm-s390x.yml'
>>>>
>>>> KVM code is already covered by the "cross-s390x-system" job, but an
>>>> additional compilation test with --disable-tcg makes sense here. I'd then
>>>> rather name it "cross-s390x-no-tcg" or so instead of "cross-s390x-kvm".
>>>>
>>>> And while you're at it, I'd maybe rather name the new file just
>>>> crossbuilds-s390x.yml and also move the other s390x related jobs into it?
>>>
>>> I don't think we really should split it up so much - just put these
>>> jobs in the existing crosbuilds.yml file.
>>
>> Don't we want to leverage MAINTAINERS file?
> 
> As mentioned in the cover letter, I think this is mis-using the MAINTAINERS
> file to try to represent something different.
> 
> The MAINTAINERS file says who is responsible for the contents of the .yml
> file, which is the CI maintainers, because we want a consistent gitlab
> configuration as a whole, not everyone doing their own thing.
> 
> MAINTAINERS doesn't say who is responsible for making sure the actual
> jobs that run are passing, which is potentially a completely different
> person. If we want to track that, it is not the MAINTAINERS file.

Thanks, I was expecting subsystem maintainers would worry about the
CI jobs, but you made it clear this should be different persons who
look after CI. I understand it is better to have no maintainer than
to have incorrect maintainer.

