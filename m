Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E442D0E22
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 11:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgLGKih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 05:38:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725794AbgLGKig (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 05:38:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607337429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+MUpNM1ZaTlO4T3gwbQyUi+bhaJnWEMg2E4uaX6U69A=;
        b=B2gQDU6LfuaVn9nNbE1kKM+ZnU0zVpYKfgoQuEuuwbpb6vzx57IA43fFTYMrrZSqsGUkdf
        8PVH06qRwYN8uEyxqgrVTLMpHkIrL9r5Z2c4Z3QdF2aoa9+xaB4mfeCbww8nKB4s1MnOKI
        e66wJ4bh0JRY4L949lmgJ23BVl8qyR8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-M68AQdmqMsaWNEWqm3w9zw-1; Mon, 07 Dec 2020 05:37:08 -0500
X-MC-Unique: M68AQdmqMsaWNEWqm3w9zw-1
Received: by mail-wr1-f71.google.com with SMTP id o4so1046009wrw.19
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 02:37:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+MUpNM1ZaTlO4T3gwbQyUi+bhaJnWEMg2E4uaX6U69A=;
        b=LIbbogyqVqCSBMWvmutnB+QJirt1axgdmfZe9VivEbH1HHaKvOmFDknpIxlr6bbYCR
         ST5IiMOKj9ty0nrpDhDA26AHpKM/pVZqBKjw+TQTpnDiCs7+FU00HkLIkHSPyk7vieb3
         zSArsFBrZVIiTMga74rhkB7koUAU5CFNLUIg36rYRnsrDVXzuN3LTqtudlnWC/tb4UwN
         0RmlZlu6I6lryvt7hg2ig0bUq96Rpi+2ThzSwhJhInmOqtfqk4Z2BPZ9jyj/Nlu05VLy
         owA+XoCZKvs7qDx9hqF82WJcrCo+C/neV5ui91d26+CWe6C+ICXQYsNmBw/y5HGI/zPH
         NNDw==
X-Gm-Message-State: AOAM530nr4vh8+x5Ek1RfEGIC7CQUTa7JjOU/a9pt8dQdrcciEOB5UKg
        A4QkIZq4kqCFcCoMx2kt+oTe2qa8ea18abzslVQPe8lmITDm5ZLSHIhf4mSifBe8Awww0kEWpJr
        E5Cj2pkNERyHo
X-Received: by 2002:a05:600c:2:: with SMTP id g2mr17382124wmc.156.1607337426666;
        Mon, 07 Dec 2020 02:37:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwwRtV73QFCV2ROpZ9fzFZtsHpDjPVdEFc+3zGnA5/nvOZAdgvHLzYUDyvlwzcMdbtuT+HBXg==
X-Received: by 2002:a05:600c:2:: with SMTP id g2mr17382089wmc.156.1607337426480;
        Mon, 07 Dec 2020 02:37:06 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id z140sm14292218wmc.30.2020.12.07.02.37.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 02:37:05 -0800 (PST)
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
 <2352c04c-829e-ea1d-0894-15fc1d06697a@redhat.com>
 <cd5d00b1-999a-fbb3-204e-a759a9e2c3ec@redhat.com>
 <0447129c-e6c9-71f6-1786-b4e8689b8214@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <b0ea4a2f-c79e-9d8f-86a5-eb6f53bf5067@redhat.com>
Date:   Mon, 7 Dec 2020 11:37:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <0447129c-e6c9-71f6-1786-b4e8689b8214@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 11:33 AM, Thomas Huth wrote:
> On 07/12/2020 11.26, Philippe Mathieu-Daudé wrote:
>> On 12/7/20 11:00 AM, Philippe Mathieu-Daudé wrote:
>>> On 12/7/20 6:46 AM, Thomas Huth wrote:
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
>>
>> What other accelerators are available on 390?
> 
> It's only TCG and KVM.

Easy, so no-tcg = kvm :)

