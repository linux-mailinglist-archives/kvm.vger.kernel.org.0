Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C392D1120
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 13:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgLGMzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 07:55:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57782 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbgLGMzU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 07:55:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607345633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8jQXhZcYJDxQ+pyrZJ9955D0Y/b7j+Ci1hyg9wiMJqU=;
        b=B5mNN6ssD+k8xdQceVG3A/oXt1xDCPvwExE0Jo6i1pil8ftFR8M/oq/lmJWRyRInCsV7L7
        ICPVXXqSqRbPvi8nbyB5seKrq0wXUGWiU+8xSsm+DMHdHK/IQcv9zI7wHqivS1wnK00oKX
        lyacLPihPVns0fG0bueqa6bE5hqWXow=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-U4KudxG_Mm2YXq2Gy0GzoA-1; Mon, 07 Dec 2020 07:53:52 -0500
X-MC-Unique: U4KudxG_Mm2YXq2Gy0GzoA-1
Received: by mail-wr1-f69.google.com with SMTP id o4so1146436wrw.19
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 04:53:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8jQXhZcYJDxQ+pyrZJ9955D0Y/b7j+Ci1hyg9wiMJqU=;
        b=ccjUDyon/noxKwucCC8EV9j1zg2GC2ZWPqKIbQJFnINsDUwrxp9MxtWbSJ/5tms9Wt
         Kk6ZmoIhMO/1OFb+tP58nOczAvjRZFG7JDREQBCZ+85Vx3YIKRjieFfgf4mBmwV8RHq6
         5Vqq3jyGgY8xnvxVGhwJM9T/k7jsD7IVOSquOZYYD4JvLzNzqZRasDZiMc+UBMbWzqjS
         MIUdWbxYb4dBwiME5Oj/xzSOVn0KzrN5wPkU0ms5TdUrEkvU8vsDu9bNY+tgeu0y8kkz
         4o1dDzBSJ/L4F7vCtsOOv7jE8uy6LuR1vYhgPM5SfO02KU/4HkNSR3Uxxy3S3T0t/WaV
         cKXQ==
X-Gm-Message-State: AOAM532LddTWjBv8ZzfPuGZZvjetEb5VCCHWVC7+e9+NmSORPU7WtlNc
        Vbah4pK87jruEDYmN8H0PgouK0JoqOg2SGQi4EiTBdoUpzgquBLP77aPSbHVj3GzKWIo3cisf+M
        Z6ChOoBo4qO1u
X-Received: by 2002:adf:e547:: with SMTP id z7mr16664435wrm.283.1607345630921;
        Mon, 07 Dec 2020 04:53:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwL3U84FFw+0qFmC+nPsQaUjHyjhjpgeVy6OSntbXqxnSM9myKiFBtd0teG8BcdiMc8S14tKw==
X-Received: by 2002:adf:e547:: with SMTP id z7mr16664424wrm.283.1607345630765;
        Mon, 07 Dec 2020 04:53:50 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id h15sm15059392wrw.15.2020.12.07.04.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 04:53:50 -0800 (PST)
Subject: Re: [PATCH v2 3/5] gitlab-ci: Introduce 'cross_accel_build_job'
 template
To:     Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Fontana <cfontana@suse.de>,
        Willian Rampazzo <wrampazz@redhat.com>, qemu-s390x@nongnu.org,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        xen-devel@lists.xenproject.org, Paul Durrant <paul@xen.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Stefano Stabellini <sstabellini@kernel.org>
References: <20201207112353.3814480-1-philmd@redhat.com>
 <20201207112353.3814480-4-philmd@redhat.com>
 <93d186c0-feea-8e47-2a03-5276fb898bff@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <39d13e9c-1fb4-2fa9-6cf4-01086ad920aa@redhat.com>
Date:   Mon, 7 Dec 2020 13:53:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <93d186c0-feea-8e47-2a03-5276fb898bff@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 12:37 PM, Thomas Huth wrote:
> On 07/12/2020 12.23, Philippe Mathieu-Daudé wrote:
>> Introduce a job template to cross-build accelerator specific
>> jobs (enable a specific accelerator, disabling the others).
>>
>> The specific accelerator is selected by the $ACCEL environment
>> variable (default to KVM).
>>
>> Extra options such disabling other accelerators are passed
>> via the $ACCEL_CONFIGURE_OPTS environment variable.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>> ---
>>  .gitlab-ci.d/crossbuilds.yml | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/.gitlab-ci.d/crossbuilds.yml b/.gitlab-ci.d/crossbuilds.yml
>> index 099949aaef3..d8685ade376 100644
>> --- a/.gitlab-ci.d/crossbuilds.yml
>> +++ b/.gitlab-ci.d/crossbuilds.yml
>> @@ -13,6 +13,23 @@
>>            xtensa-softmmu"
>>      - make -j$(expr $(nproc) + 1) all check-build
>>  
>> +# Job to cross-build specific accelerators.
>> +#
>> +# Set the $ACCEL variable to select the specific accelerator (default to
>> +# KVM), and set extra options (such disabling other accelerators) via the
>> +# $ACCEL_CONFIGURE_OPTS variable.
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
> 
> I wonder whether we could also simply use the .cross_user_build_job - e.g.
> by adding a $EXTRA_CONFIGURE_OPTS variable in the "../configure ..." line so
> that the accel-jobs could use that for their --enable... and --disable...
> settings?

Well cross_user_build_job build tools (I'm not sure that desired).

> Anyway, I've got no strong opinion on that one, and I'm also fine if we add
> this new template, so:
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Thanks, we can improve on top.

