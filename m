Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85102740FC
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 13:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgIVLf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 07:35:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55061 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726701AbgIVLfr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 07:35:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600774545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iVuM9z2yUr8zyxXYDwbwyPVDW6UrW4ow9wkAb6hmN1A=;
        b=IdCasDbB5I3yINNoIe57gd423VtZ1c8ErAIk9ObVFnwFUE9Ysd+hoy3Vzzh84Q/JdJXHZ5
        nGmIeMbWTjPoQMKc/N+yHrEiIndvwuRFWVN7qyqwHjFqVReVs6RIEuJK1hHcf5lHOH1+yc
        IbC6IfRrEyB3mD0Hh/0K7PUddt8D11E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-Q1nJ2DRCNVi9MLlSRT3twg-1; Tue, 22 Sep 2020 07:35:42 -0400
X-MC-Unique: Q1nJ2DRCNVi9MLlSRT3twg-1
Received: by mail-wm1-f69.google.com with SMTP id m125so790883wmm.7
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 04:35:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iVuM9z2yUr8zyxXYDwbwyPVDW6UrW4ow9wkAb6hmN1A=;
        b=dLicr5MgO3M8LQbNrr5aAzle/DSJTUx4BLKCcSxg32zslRj1oLlKPco6YDhK1HdD30
         T/OeKza+TqyaWl8C6NZIZQDRnZ6XJBerPn4f62EOwG3ba3f5V8Q1GcAoJsKwZE6ipZQo
         /t6CyjvmpHQwm62wwQ1z9FqvyiRxteR4HdlpYhX92jc/4+la/v9KwOm44lFr/cVoHhLS
         tWziGtKBeDbfn0hr2l+Ktpd3iMW6bggMdwNVDIlbHCD8/aPZOew03C6rQU3y82mMLh1z
         +A30rs+fmyaZ6QlyE+Q3C7lWlaZvUzQleerPPHHLN+a3j8vizfryp6QudzcrxpSSKhZZ
         M9SQ==
X-Gm-Message-State: AOAM533QPHXmG5muLUTGIM3HpeHxDFGKlCvwnol4GVMftaqOOu2AfUsY
        P7HSKWv2lv/ILrw/lhQylIufmDcQVaG367/OklAoFN4PGbP2m4e+gbBSHD6J5zbqV0H3bGD9RXT
        UZOCFQcmieuRq
X-Received: by 2002:a1c:2c0a:: with SMTP id s10mr522270wms.103.1600774540926;
        Tue, 22 Sep 2020 04:35:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRA5AQEUn4rCczYkkzXjxs49KTP7PwCp4IUjQhU4ZWgDSvFRTPtzciduuPsGxbrjwX11t5eA==
X-Received: by 2002:a1c:2c0a:: with SMTP id s10mr522238wms.103.1600774540651;
        Tue, 22 Sep 2020 04:35:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id m18sm25626053wrx.58.2020.09.22.04.35.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 04:35:39 -0700 (PDT)
Subject: Re: [PATCH v2] qemu/atomic.h: prefix qemu_ to solve <stdatomic.h>
 collisions
To:     Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>, Eric Blake <eblake@redhat.com>,
        Peter Lieven <pl@kamp.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        Alberto Garcia <berto@igalia.com>, qemu-s390x@nongnu.org,
        kvm@vger.kernel.org, Liu Yuan <namei.unix@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, Fam Zheng <fam@euphon.net>,
        Paul Durrant <paul@xen.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Max Reitz <mreitz@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>, John Snow <jsnow@redhat.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-arm@nongnu.org, Yuval Shaia <yuval.shaia.ml@gmail.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        sheepdog@lists.wpkg.org,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Juan Quintela <quintela@redhat.com>, qemu-riscv@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Weil <sw@weilnetz.de>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Markus Armbruster <armbru@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, qemu-block@nongnu.org,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        xen-devel@lists.xenproject.org, Laurent Vivier <laurent@vivier.eu>,
        Hailiang Zhang <zhang.zhanghailiang@huawei.com>,
        Richard Henderson <rth@twiddle.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Huacai Chen <chenhc@lemote.com>
References: <20200922085838.230505-1-stefanha@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <33631340-e3e3-b10f-4f9a-0e1b295d79ef@redhat.com>
Date:   Tue, 22 Sep 2020 13:35:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200922085838.230505-1-stefanha@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/20 10:58, Stefan Hajnoczi wrote:
> clang's C11 atomic_fetch_*() functions only take a C11 atomic type
> pointer argument. QEMU uses direct types (int, etc) and this causes a
> compiler error when a QEMU code calls these functions in a source file
> that also included <stdatomic.h> via a system header file:
> 
>   $ CC=clang CXX=clang++ ./configure ... && make
>   ../util/async.c:79:17: error: address argument to atomic operation must be a pointer to _Atomic type ('unsigned int *' invalid)
> 
> Avoid using atomic_*() names in QEMU's atomic.h since that namespace is
> used by <stdatomic.h>. Prefix QEMU's APIs with qemu_ so that atomic.h
> and <stdatomic.h> can co-exist.
> 
> This patch was generated using:
> 
>   $ git grep -h -o '\<atomic\(64\)\?_[a-z0-9_]\+' include/qemu/atomic.h | \
>     sort -u >/tmp/changed_identifiers
>   $ for identifier in $(</tmp/changed_identifiers); do
>        sed -i "s%\<$identifier\>%qemu_$identifier%g" \
>            $(git grep -I -l "\<$identifier\>")
>     done
> 
> I manually fixed line-wrap issues and misaligned rST tables.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
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

I think the reviews crossed, are you going to respin using a qatomic_
prefix?

Paolo

