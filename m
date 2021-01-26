Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DF7305C34
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 13:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313928AbhAZWuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:50:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51484 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727388AbhAZVki (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 16:40:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611697151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sxqv5yUwQFbVFgh+iPBiF0//0KbZRTwceB6ZVlVRKSA=;
        b=AW7JEShcWPu+ifBZ88niDa4QeIcjhJvctHfpzQ2L9LE8ibruF2DtTrGHr9fDnzGx3gw1h/
        PRz3olYh12G4uzBqlpWP/AiYSS8ZQaTiwvSLmtCrVs+kDrcJuOrMkfO55kDhZuim65Snum
        RPTQ2TMX6i2m/VzwdLf29SgtHV1zBaI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-sMtPW2MROReVkyT0Erv8lQ-1; Tue, 26 Jan 2021 16:39:08 -0500
X-MC-Unique: sMtPW2MROReVkyT0Erv8lQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E55CB8017FB;
        Tue, 26 Jan 2021 21:39:05 +0000 (UTC)
Received: from [10.10.112.247] (ovpn-112-247.rdu2.redhat.com [10.10.112.247])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E300863746;
        Tue, 26 Jan 2021 21:38:57 +0000 (UTC)
Subject: Re: [PATCH v2 8/9] tests/docker: Add dockerfile for Alpine Linux
To:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     Fam Zheng <fam@euphon.net>, Laurent Vivier <lvivier@redhat.com>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        qemu-block@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Alistair Francis <alistair@alistair23.me>,
        qemu-devel@nongnu.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Greg Kurz <groug@kaod.org>, Max Reitz <mreitz@redhat.com>,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
 <20210118063808.12471-9-jiaxun.yang@flygoat.com>
 <20210118103345.GE1789637@redhat.com>
 <929c3ec1-9419-908a-6b5e-ce3ae78f6011@redhat.com>
From:   John Snow <jsnow@redhat.com>
Message-ID: <551e153e-34da-28bd-c67f-d2a688ad987b@redhat.com>
Date:   Tue, 26 Jan 2021 16:38:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <929c3ec1-9419-908a-6b5e-ce3ae78f6011@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/19/21 8:41 AM, Thomas Huth wrote:
> On 18/01/2021 11.33, Daniel P. Berrangé wrote:
>> On Mon, Jan 18, 2021 at 02:38:07PM +0800, Jiaxun Yang wrote:
>>> Alpine Linux[1] is a security-oriented, lightweight Linux distribution
>>> based on musl libc and busybox.
>>>
>>> It it popular among Docker guests and embedded applications.
>>>
>>> Adding it to test against different libc.
>>>
>>> [1]: https://alpinelinux.org/
>>>
>>> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
>>> ---
>>>   tests/docker/dockerfiles/alpine.docker | 57 ++++++++++++++++++++++++++
>>>   1 file changed, 57 insertions(+)
>>>   create mode 100644 tests/docker/dockerfiles/alpine.docker
>>>
>>> diff --git a/tests/docker/dockerfiles/alpine.docker 
>>> b/tests/docker/dockerfiles/alpine.docker
>>> new file mode 100644
>>> index 0000000000..5be5198d00
>>> --- /dev/null
>>> +++ b/tests/docker/dockerfiles/alpine.docker
>>> @@ -0,0 +1,57 @@
>>> +
>>> +FROM alpine:edge
>>> +
>>> +RUN apk update
>>> +RUN apk upgrade
>>> +
>>> +# Please keep this list sorted alphabetically
>>> +ENV PACKAGES \
>>> +    alsa-lib-dev \
>>> +    bash \
>>> +    bison \
>>
>> This shouldn't be required.
> 
> bison and flex were required to avoid some warnings in the past while 
> compiling the dtc submodule ... but I thought we got rid of the problem 
> at one point in time, so this can be removed now, indeed.
> 
>>> +    build-base \
>>
>> This seems to be a meta packae that pulls in other
>> misc toolchain packages. Please list the pieces we
>> need explicitly instead.
> 
> Looking at the "Depends" list on 
> https://pkgs.alpinelinux.org/package/v3.3/main/x86/build-base there are 
> only 6 dependencies and we need most of those for QEMU anyway, so I 
> think it is ok to keep build-base here.
> 
>>> +    coreutils \
>>> +    curl-dev \
>>> +    flex \
>>
>> This shouldn't be needed.
>>
>>> +    git \
>>> +    glib-dev \
>>> +    glib-static \
>>> +    gnutls-dev \
>>> +    gtk+3.0-dev \
>>> +    libaio-dev \
>>> +    libcap-dev \
>>
>> Should not be required, as we use cap-ng.
> 
> Right.
> 
>>> +    libcap-ng-dev \
>>> +    libjpeg-turbo-dev \
>>> +    libnfs-dev \
>>> +    libpng-dev \
>>> +    libseccomp-dev \
>>> +    libssh-dev \
>>> +    libusb-dev \
>>> +    libxml2-dev \
>>> +    linux-headers \
>>
>> Is this really needed ? We don't install kernel-headers on other
>> distros AFAICT.
> 
> I tried a build without this package, and it works fine indeed.
> 
>>> +    lzo-dev \
>>> +    mesa-dev \
>>> +    mesa-egl \
>>> +    mesa-gbm \
>>> +    meson \
>>> +    ncurses-dev \
>>> +    ninja \
>>> +    paxmark \
>>
>> What is this needed for ?
> 
> Seems like it also can be dropped.
> 
>>> +    perl \
>>> +    pulseaudio-dev \
>>> +    python3 \
>>> +    py3-sphinx \
>>> +    shadow \
>>
>> Is this really needed ?
> 
> See:
> https://www.spinics.net/lists/kvm/msg231556.html
> 
> I can remove the superfluous packages when picking up the patch, no need 
> to respin just because of this.
> 
>   Thomas
> 
> 

You can refer to my post earlier this January for a "minimal" Alpine 
Linux build, if you wish.

My goal was to find the smallest set of packages possible without 
passing any explicit configure flags.

I wonder if it's worth having layered "core build" and "test build" 
images so that we can smoke test the minimalistic build from time to 
time -- I seem to recall Dan posting information about a dependency 
management tool for Dockerfiles, but I admit I didn't look too closely 
at what problem that solves, exactly.

--js

