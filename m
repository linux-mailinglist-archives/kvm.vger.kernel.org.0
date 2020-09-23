Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B6F275823
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 14:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgIWMoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 08:44:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60271 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726548AbgIWMoE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 08:44:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600865042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=hw9WEGmGNUu+WgfdFN4EiriFZiOAvFF3KJ16jHLwMEw=;
        b=Cpvl6VmDQ4YTo/boVsMe10pMhrtv2bVv4MzvD1x6wPZ2/anwFwI33XVXaPzMWCJl9Ms4L0
        8TvLc9zwlWabXQAsHD8XI5IDjrOY2Yh9z8d2pvkS6xrVn1rkg3YcZSXjeXupeZyfBjS+GZ
        /UmyvPYVFzn80z99sJecVrI52JDVO3U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-v7nuG-GdNG2YuoVTAwyhTA-1; Wed, 23 Sep 2020 08:43:59 -0400
X-MC-Unique: v7nuG-GdNG2YuoVTAwyhTA-1
Received: by mail-wr1-f69.google.com with SMTP id o6so8755746wrp.1
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 05:43:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=hw9WEGmGNUu+WgfdFN4EiriFZiOAvFF3KJ16jHLwMEw=;
        b=NAu1NwEqNgi9aqJRq3a5XMq1KQCq9fZdjJH4VpYGVLmE7Jkp8sAlsUO/1isYoON342
         9KgYjHjRZSsc+AaqKQAnc9Tw/r7hIl3JnkEm/m2exdLJje3uCpsZXd89yV53ZnbuiRc2
         MkksVWWxLOUQY5TWayJ7t5eS1szw+mxCMeguuAjpSJJUB4bKX/snWAWUEyFDnX82gAqz
         QbRvne3Ceyo/XTKL3pRndljKUwuNr/cfKkt9SaPFDnQZTwSI0Nd+r7lT66hM3hbW7UPD
         R+WzF1vZX4Ml+Sp8wxayUQdDxAx0beQyesiph4d3DvXp9L3xNt+tFlaBZQYJ0SRlelC1
         fz8A==
X-Gm-Message-State: AOAM532zzJXHA3dBX9UNE4U3YSQGfgJzLXsMs6yLfpmem2soa100trbc
        g9noIkU2rnXReQvcz50bg37zI8waRb2GsoF1700TxrKdowGEVWUr04ceN0FNMgXeKdb8gbIYED9
        b/kk3jWpaSclW
X-Received: by 2002:a5d:494b:: with SMTP id r11mr624989wrs.227.1600865037794;
        Wed, 23 Sep 2020 05:43:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUhlvPeZCm3s3Zwa1yYE4gK+p3VCRndlrGF5QI1S9+YaLxw/1WRoCabWLmJZqZhI5emtTUAg==
X-Received: by 2002:a5d:494b:: with SMTP id r11mr624965wrs.227.1600865037566;
        Wed, 23 Sep 2020 05:43:57 -0700 (PDT)
Received: from [192.168.1.36] (65.red-83-57-170.dynamicip.rima-tde.net. [83.57.170.65])
        by smtp.gmail.com with ESMTPSA id a81sm8810100wmf.32.2020.09.23.05.43.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 05:43:56 -0700 (PDT)
Subject: Re: [PATCH v3] qemu/atomic.h: rename atomic_ to qatomic_
To:     Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc:     Fam Zheng <fam@euphon.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        sheepdog@lists.wpkg.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        Paul Durrant <paul@xen.org>, Jason Wang <jasowang@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Yuval Shaia <yuval.shaia.ml@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Eric Blake <eblake@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Alberto Garcia <berto@igalia.com>, kvm@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Juan Quintela <quintela@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        Liu Yuan <namei.unix@gmail.com>,
        Richard Henderson <rth@twiddle.net>,
        Thomas Huth <thuth@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Stefan Weil <sw@weilnetz.de>, Peter Lieven <pl@kamp.de>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-s390x@nongnu.org, qemu-arm@nongnu.org,
        xen-devel@lists.xenproject.org, qemu-riscv@nongnu.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        John Snow <jsnow@redhat.com>,
        Hailiang Zhang <zhang.zhanghailiang@huawei.com>,
        Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        qemu-block@nongnu.org,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Max Reitz <mreitz@redhat.com>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20200923105646.47864-1-stefanha@redhat.com>
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
Message-ID: <a405964c-0d33-35bd-5061-debfd9ff3194@redhat.com>
Date:   Wed, 23 Sep 2020 14:43:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923105646.47864-1-stefanha@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/23/20 12:56 PM, Stefan Hajnoczi wrote:
> clang's C11 atomic_fetch_*() functions only take a C11 atomic type
> pointer argument. QEMU uses direct types (int, etc) and this causes a
> compiler error when a QEMU code calls these functions in a source file
> that also included <stdatomic.h> via a system header file:
> 
>   $ CC=clang CXX=clang++ ./configure ... && make
>   ../util/async.c:79:17: error: address argument to atomic operation must be a pointer to _Atomic type ('unsigned int *' invalid)
> 
> Avoid using atomic_*() names in QEMU's atomic.h since that namespace is
> used by <stdatomic.h>. Prefix QEMU's APIs with 'q' so that atomic.h
> and <stdatomic.h> can co-exist. I checked /usr/include on my machine and
> searched GitHub for existing "qatomic_" users but there seem to be none.
> 
> This patch was generated using:
> 
>   $ git grep -h -o '\<atomic\(64\)\?_[a-z0-9_]\+' include/qemu/atomic.h | \
>     sort -u >/tmp/changed_identifiers
>   $ for identifier in $(</tmp/changed_identifiers); do
>         sed -i "s%\<$identifier\>%q$identifier%g" \
>             $(git grep -I -l "\<$identifier\>")
>     done
> 
> I manually fixed line-wrap issues and misaligned rST tables.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>

Reviewed using 'git-diff --color-words'.

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

> ---
> v3:
>  * Use qatomic_ instead of atomic_ [Paolo]
>  * The diff of my manual fixups is available here:
>    https://vmsplice.net/~stefan/atomic-namespace-pre-fixups-v3.diff
>    - Dropping #ifndef qatomic_fetch_add in atomic.h
>    - atomic_##X(haddr, val) glue macros not caught by grep
>    - Keep atomic_add-bench name
>    - C preprocessor backslash-newline ('\') column alignment
>    - Line wrapping
> v2:
>  * The diff of my manual fixups is available here:
>    https://vmsplice.net/~stefan/atomic-namespace-pre-fixups.diff
>    - Dropping #ifndef qemu_atomic_fetch_add in atomic.h
>    - atomic_##X(haddr, val) glue macros not caught by grep
>    - Keep atomic_add-bench name
>    - C preprocessor backslash-newline ('\') column alignment
>    - Line wrapping
>  * Use grep -I to avoid accidentally modifying binary files (RISC-V
>    OpenSBI ELFs) [Eric Blake]
>  * Tweak .gitorder to show atomic.h changes first [Eric Blake]
>  * Update grep commands in commit description so reviewers can reproduce
>    mechanical changes [Eric Blake]
> ---

