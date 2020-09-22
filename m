Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45541273D5A
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 10:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgIVIdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 04:33:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40763 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726756AbgIVIdy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 04:33:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600763632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=qvyUjkv8t4H1ij6w8DYR8/i335Zbxq6HBGLdSo8YFhw=;
        b=gU+mKxjG9wVGzPG+30pB5c3gluqP3T/cRoNBU5lU4CWr08njdfFQacDILyOLXqpTdk5rRp
        lQ48ZoDm6Oi7vxjrRZcizA4WqHrPDd0aADRPkYTiEWNptyfYXbfPZ/+2YxyeaMzUVnAXj+
        lLIE1GPCEMNCIVSQOtBDeMjdCONQlLY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-Pfv7ZJTPMtW4W4VZmcK25A-1; Tue, 22 Sep 2020 04:33:50 -0400
X-MC-Unique: Pfv7ZJTPMtW4W4VZmcK25A-1
Received: by mail-wr1-f70.google.com with SMTP id 33so7139089wre.0
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 01:33:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=qvyUjkv8t4H1ij6w8DYR8/i335Zbxq6HBGLdSo8YFhw=;
        b=OKcEmQ72CeFcoeo94VVcXN4sPzDU4K5eYEStOpPE5ctzpPDNNjN5S5LMkuJJd/OBOG
         wXC0U46BgEROumtLg0qJwuj7+KUOeKSYoMPLWRKcx6CGrX8/5aq/QQUoPHJ5Oa8FvhqZ
         A93XsJ3ofofoVo0wsI6u23K5eue0jWNLWAwoA/4t76NtP76mjck9evtoQMMDL51ns+w0
         QMoEHNXIUN0X5dCEr/aCS4D1AhniqD09vqNBzSZRqmw5Iv30+8GXcxENOWckteHxAJ5C
         qV3zklc/qz6BaV6EDOYNOMih+Hwy9lpLNaKI6/dE0jiK+7xZxkt0TOREv04PkoxpFcWn
         yn2g==
X-Gm-Message-State: AOAM531M3JiGRjaaN4nPmx8FnYWep7kykj0LNLbJK1a47QzhfyorJUGp
        JJhpss0zX9uzwQb/UNbTOsmwzDzayI1uSpOfKqVSre+nVLPVZTQyzZAqGUhNKtFhk0OW67jgTFe
        B/95h1btF5CdG
X-Received: by 2002:a1c:59c2:: with SMTP id n185mr3236256wmb.43.1600763629022;
        Tue, 22 Sep 2020 01:33:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6dFnNm36FEIqnuuXGz9nWZ1QUfl3u3gn03+FQFA+/1aED+MOKkBn5JsSaaGBStLCkBvBNiw==
X-Received: by 2002:a1c:59c2:: with SMTP id n185mr3236220wmb.43.1600763628785;
        Tue, 22 Sep 2020 01:33:48 -0700 (PDT)
Received: from [192.168.1.36] (65.red-83-57-170.dynamicip.rima-tde.net. [83.57.170.65])
        by smtp.gmail.com with ESMTPSA id l17sm3448412wme.11.2020.09.22.01.33.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 01:33:47 -0700 (PDT)
Subject: Re: [PATCH] qemu/atomic.h: prefix qemu_ to solve <stdatomic.h>
 collisions
To:     Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc:     fam@euphon.net, peter.maydell@linaro.org, sheepdog@lists.wpkg.org,
        kvm@vger.kernel.org, david@redhat.com, jasowang@redhat.com,
        yuval.shaia.ml@gmail.com, mdroth@linux.vnet.ibm.com,
        jcmvbkbc@gmail.com, Alistair.Francis@wdc.com, kraxel@redhat.com,
        chenhc@lemote.com, sstabellini@kernel.org, berto@igalia.com,
        sagark@eecs.berkeley.edu, ysato@users.sourceforge.jp,
        quintela@redhat.com, jslaby@suse.cz, mst@redhat.com,
        armbru@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        aleksandar.qemu.devel@gmail.com, thuth@redhat.com,
        marcandre.lureau@redhat.com, mjrosato@linux.ibm.com,
        aleksandar.rikalo@syrmia.com, ehabkost@redhat.com, sw@weilnetz.de,
        pl@kamp.de, dgilbert@redhat.com, paul@xen.org,
        anthony.perard@citrix.com, qemu-s390x@nongnu.org,
        qemu-arm@nongnu.org, namei.unix@gmail.com, qemu-riscv@nongnu.org,
        sunilmut@microsoft.com, jsnow@redhat.com,
        zhang.zhanghailiang@huawei.com, rth@twiddle.net, kwolf@redhat.com,
        berrange@redhat.com, qemu-block@nongnu.org,
        kbastian@mail.uni-paderborn.de, cohuck@redhat.com,
        laurent@vivier.eu, mreitz@redhat.com, palmer@dabbelt.com,
        pbonzini@redhat.com, xen-devel@lists.xenproject.org,
        aurelien@aurel32.net
References: <20200921162346.188997-1-stefanha@redhat.com>
 <160072176188.21069.7427016597134663502@66eaa9a8a123>
 <20200922081705.GB201611@stefanha-x1.localdomain>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Autocrypt: addr=philmd@redhat.com; keydata=
 mQINBDXML8YBEADXCtUkDBKQvNsQA7sDpw6YLE/1tKHwm24A1au9Hfy/OFmkpzo+MD+dYc+7
 bvnqWAeGweq2SDq8zbzFZ1gJBd6+e5v1a/UrTxvwBk51yEkadrpRbi+r2bDpTJwXc/uEtYAB
 GvsTZMtiQVA4kRID1KCdgLa3zztPLCj5H1VZhqZsiGvXa/nMIlhvacRXdbgllPPJ72cLUkXf
 z1Zu4AkEKpccZaJspmLWGSzGu6UTZ7UfVeR2Hcc2KI9oZB1qthmZ1+PZyGZ/Dy+z+zklC0xl
 XIpQPmnfy9+/1hj1LzJ+pe3HzEodtlVA+rdttSvA6nmHKIt8Ul6b/h1DFTmUT1lN1WbAGxmg
 CH1O26cz5nTrzdjoqC/b8PpZiT0kO5MKKgiu5S4PRIxW2+RA4H9nq7nztNZ1Y39bDpzwE5Sp
 bDHzd5owmLxMLZAINtCtQuRbSOcMjZlg4zohA9TQP9krGIk+qTR+H4CV22sWldSkVtsoTaA2
 qNeSJhfHQY0TyQvFbqRsSNIe2gTDzzEQ8itsmdHHE/yzhcCVvlUzXhAT6pIN0OT+cdsTTfif
 MIcDboys92auTuJ7U+4jWF1+WUaJ8gDL69ThAsu7mGDBbm80P3vvUZ4fQM14NkxOnuGRrJxO
 qjWNJ2ZUxgyHAh5TCxMLKWZoL5hpnvx3dF3Ti9HW2dsUUWICSQARAQABtDJQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoUGhpbCkgPHBoaWxtZEByZWRoYXQuY29tPokCVQQTAQgAPwIbDwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4AWIQSJweePYB7obIZ0lcuio/1u3q3A3gUCXsfWwAUJ
 KtymWgAKCRCio/1u3q3A3ircD/9Vjh3aFNJ3uF3hddeoFg1H038wZr/xi8/rX27M1Vj2j9VH
 0B8Olp4KUQw/hyO6kUxqkoojmzRpmzvlpZ0cUiZJo2bQIWnvScyHxFCv33kHe+YEIqoJlaQc
 JfKYlbCoubz+02E2A6bFD9+BvCY0LBbEj5POwyKGiDMjHKCGuzSuDRbCn0Mz4kCa7nFMF5Jv
 piC+JemRdiBd6102ThqgIsyGEBXuf1sy0QIVyXgaqr9O2b/0VoXpQId7yY7OJuYYxs7kQoXI
 6WzSMpmuXGkmfxOgbc/L6YbzB0JOriX0iRClxu4dEUg8Bs2pNnr6huY2Ft+qb41RzCJvvMyu
 gS32LfN0bTZ6Qm2A8ayMtUQgnwZDSO23OKgQWZVglGliY3ezHZ6lVwC24Vjkmq/2yBSLakZE
 6DZUjZzCW1nvtRK05ebyK6tofRsx8xB8pL/kcBb9nCuh70aLR+5cmE41X4O+MVJbwfP5s/RW
 9BFSL3qgXuXso/3XuWTQjJJGgKhB6xXjMmb1J4q/h5IuVV4juv1Fem9sfmyrh+Wi5V1IzKI7
 RPJ3KVb937eBgSENk53P0gUorwzUcO+ASEo3Z1cBKkJSPigDbeEjVfXQMzNt0oDRzpQqH2vp
 apo2jHnidWt8BsckuWZpxcZ9+/9obQ55DyVQHGiTN39hkETy3Emdnz1JVHTU0Q==
Message-ID: <f70c3ae8-330f-af43-0005-86b4d3fabb2e@redhat.com>
Date:   Tue, 22 Sep 2020 10:33:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200922081705.GB201611@stefanha-x1.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/22/20 10:17 AM, Stefan Hajnoczi wrote:
> On Mon, Sep 21, 2020 at 01:56:08PM -0700, no-reply@patchew.org wrote:
>> ERROR: Macros with multiple statements should be enclosed in a do - while loop
>> #2968: FILE: include/qemu/atomic.h:152:
>> +#define qemu_atomic_rcu_read__nocheck(ptr, valptr)      \
>>      __atomic_load(ptr, valptr, __ATOMIC_RELAXED);       \
>>      smp_read_barrier_depends();
>>
...
>> WARNING: Block comments use a leading /* on a separate line
>> #7456: FILE: util/rcu.c:154:
>> +        /* In either case, the qemu_atomic_mb_set below blocks stores that free
>>
>> total: 7 errors, 4 warnings, 6507 lines checked
> 
> These are pre-existing coding style issues. This is a big patch that
> tries to make as few actual changes as possible so I would rather not
> try to fix them.

What I do with automated patches triggering checkpatch errors:

- run automated conversion
- fix errors until checkpatch is happy
- run automated conversion inversed
- result is the checkpatch changes, commit them
- run automated conversion again, commit

