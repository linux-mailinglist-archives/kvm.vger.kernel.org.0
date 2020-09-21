Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A690A2734E9
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 23:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgIUV3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 17:29:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27576 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726395AbgIUV3t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 17:29:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600723787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l3O8po8zGnkZ7Hhh9QEdY4yYb/EMIlkVak6tYnjxD78=;
        b=QfgQ0iibhZLxRuVw3U0MnakUWAkxTFZcwHl0H/6zvHaUC8Q/W6z+Fdj0hZaZPAabFEKAoX
        dQPG932MjGG866XsdktY3SAXVzNa8PscD5H+kUaN6U/46V+Fun2iUNAnVT8dpfGWXJG4n1
        opeb9D7As11XQSqCGkB4Bj7lYWaPU+4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-nRhULnN0M_uur3-4A9InjA-1; Mon, 21 Sep 2020 17:29:39 -0400
X-MC-Unique: nRhULnN0M_uur3-4A9InjA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1ACDE909CAC;
        Mon, 21 Sep 2020 21:29:34 +0000 (UTC)
Received: from [10.3.113.127] (ovpn-113-127.phx2.redhat.com [10.3.113.127])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 09B0F10013BD;
        Mon, 21 Sep 2020 21:29:10 +0000 (UTC)
Subject: Re: [PATCH] qemu/atomic.h: prefix qemu_ to solve <stdatomic.h>
 collisions
To:     Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc:     qemu-riscv@nongnu.org, Fam Zheng <fam@euphon.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Alberto Garcia <berto@igalia.com>, Jiri Slaby <jslaby@suse.cz>,
        Richard Henderson <rth@twiddle.net>, Peter Lieven <pl@kamp.de>,
        David Hildenbrand <david@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Max Reitz <mreitz@redhat.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Markus Armbruster <armbru@redhat.com>, kvm@vger.kernel.org,
        Yuval Shaia <yuval.shaia.ml@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, qemu-block@nongnu.org,
        Stefan Weil <sw@weilnetz.de>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        John Snow <jsnow@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Liu Yuan <namei.unix@gmail.com>, Paul Durrant <paul@xen.org>,
        Kevin Wolf <kwolf@redhat.com>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        Jason Wang <jasowang@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        xen-devel@lists.xenproject.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        sheepdog@lists.wpkg.org, qemu-s390x@nongnu.org,
        qemu-arm@nongnu.org, Juan Quintela <quintela@redhat.com>,
        Hailiang Zhang <zhang.zhanghailiang@huawei.com>
References: <20200921162346.188997-1-stefanha@redhat.com>
From:   Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
Message-ID: <1ce94412-7a01-9208-31b1-76b7562c3843@redhat.com>
Date:   Mon, 21 Sep 2020 16:29:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200921162346.188997-1-stefanha@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/21/20 11:23 AM, Stefan Hajnoczi wrote:
> clang's C11 atomic_fetch_*() functions only take a C11 atomic type
> pointer argument. QEMU uses direct types (int, etc) and this causes a
> compiler error when a QEMU code calls these functions in a source file
> that also included <stdatomic.h> via a system header file:
> 
>    $ CC=clang CXX=clang++ ./configure ... && make
>    ../util/async.c:79:17: error: address argument to atomic operation must be a pointer to _Atomic type ('unsigned int *' invalid)
> 
> Avoid using atomic_*() names in QEMU's atomic.h since that namespace is
> used by <stdatomic.h>. Prefix QEMU's APIs with qemu_ so that atomic.h
> and <stdatomic.h> can co-exist.
> 
> This patch was generated using:
> 
>    $ git diff | grep -o '\<atomic_[a-z0-9_]\+' | sort -u >/tmp/changed_identifiers

Missing a step in the recipe: namely, you probably modified 
include/qemu/atomic*.h prior to running 'git diff' (so that you actually 
had input to feed to grep -o).  But spelling it 'git diff HEAD^ 
include/qemu/atomic*.h | ...' does indeed give me a sane list of 
identifiers that looks like what you touched in the rest of the patch.

>    $ for identifier in $(</tmp/changed_identifiers64); do \

Also not quite the right recipe, based on the file name used in the line 
above.

>         sed -i "s%\<$identifier\>%qemu_$identifier%" $(git grep -l "\<$identifier\>") \
>      done
> 

Fortunately, running "git grep -c '\<atomic_[a-z0-9_]\+'" on the 
pre-patch state of the tree gives me a list that is somewhat close to 
yours, where the obvious difference in line counts is explained by:

> I manually fixed line-wrap issues and misaligned rST tables.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---

First, focusing on the change summary:

>   docs/devel/lockcnt.txt                        |  14 +-
>   docs/devel/rcu.txt                            |  40 +--
>   accel/tcg/atomic_template.h                   |  20 +-
>   include/block/aio-wait.h                      |   4 +-
>   include/block/aio.h                           |   8 +-
>   include/exec/cpu_ldst.h                       |   2 +-
>   include/exec/exec-all.h                       |   6 +-
>   include/exec/log.h                            |   6 +-
>   include/exec/memory.h                         |   2 +-
>   include/exec/ram_addr.h                       |  27 +-
>   include/exec/ramlist.h                        |   2 +-
>   include/exec/tb-lookup.h                      |   4 +-
>   include/hw/core/cpu.h                         |   2 +-
>   include/qemu/atomic.h                         | 258 +++++++-------
>   include/qemu/atomic128.h                      |   6 +-

These two are the most important for the sake of this patch; perhaps 
it's worth a temporary override of your git orderfile if you have to 
respin, to list them first?

>   include/qemu/bitops.h                         |   2 +-
>   include/qemu/coroutine.h                      |   2 +-
>   include/qemu/log.h                            |   6 +-
>   include/qemu/queue.h                          |   8 +-
>   include/qemu/rcu.h                            |  10 +-
>   include/qemu/rcu_queue.h                      | 103 +++---

Presumably, this and any other file with an odd number of changes was 
due to a difference in lines after reformatting long lines.

>   include/qemu/seqlock.h                        |   8 +-
...

>   util/stats64.c                                |  34 +-
>   docs/devel/atomics.rst                        | 326 +++++++++---------
>   .../opensbi-riscv32-generic-fw_dynamic.elf    | Bin 558668 -> 558698 bytes
>   .../opensbi-riscv64-generic-fw_dynamic.elf    | Bin 620424 -> 620454 bytes

Why are we regenerating .elf files in this patch?  Is your change even 
correct for those two files?

>   scripts/kernel-doc                            |   2 +-
>   tcg/aarch64/tcg-target.c.inc                  |   2 +-
>   tcg/mips/tcg-target.c.inc                     |   2 +-
>   tcg/ppc/tcg-target.c.inc                      |   6 +-
>   tcg/sparc/tcg-target.c.inc                    |   5 +-
>   135 files changed, 1195 insertions(+), 1130 deletions(-)

I don't spot accel/tcg/atomic_common.c.inc in the list (which declares 
functions such as atomic_trace_rmw_pre) - I guess that's intentional 
based on how you tried to edit only the identifiers you touched in 
include/qemu/atomic*.h.

For the rest of this patch, I only spot-checked in places, trusting the 
mechanical nature of this patch, and not spotting anything wrong in the 
places I checked.  But the two .elf files worry me enough to withhold 
R-b.  At the same time, because it's big, it will probably be a source 
of conflicts if we don't get it in soon, but can also be regenerated (if 
your recipe is corrected) without too much difficulty.  So I am in favor 
of the idea.

> diff --git a/pc-bios/opensbi-riscv32-generic-fw_dynamic.elf b/pc-bios/opensbi-riscv32-generic-fw_dynamic.elf
> index eb9ebf5674d3953ab25de6bf4db134abe904eb20..35b80512446dcf5c49424ae90caacf3c579be1b5 100644
> GIT binary patch
> delta 98
> zcmX@pqx7mrsiB3jg{g(Pg=Gt?!4uZP)ZEhe?LdZ@5QIJ5?Hg+mgxS918!HgAZQt>Y
> ceSHN~X?i|K5fhYsvykI97nHrFhGPaN0Hp#a^8f$<
> 
> delta 62
> zcmaFWqjaW6siB3jg{g(Pg=Gt?!ISN#Pguo-rU!guEowjhjTMO5wjck-zP@66bv{QC
> S)Amn=9Jjf)U#j7l!3h9Zj2qGb
> 
> diff --git a/pc-bios/opensbi-riscv64-generic-fw_dynamic.elf b/pc-bios/opensbi-riscv64-generic-fw_dynamic.elf
> index 642a64e240d09b2ddb9fc12c74718ae8d386b9d3..9cf2cf23b747cb5be1d3389a0611d8697609c6f8 100644
> GIT binary patch
> delta 102
> zcmeBpue$8LYC{WS3sVbo3(FSPMGsgDQ*%q>w*wh6LJ;=!eV<s1Ak21y&#XYq2E^>!
> e4L)<s&w(mGAJ19D1Z6uWaUSP_vN>`&8@K>*RVYvZ
> 
> delta 66
> zcmZ4XUbW-BYC{WS3sVbo3(FSPMGv+wf50juH2uUU)}nU%&#XYq2E^>!?LTwO&)NPs
> Up0kK)dsGtVajxxZxttAL0Np<vJ^%m!
> 
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index 030b5c8691..9ec38a1bf1 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -1625,7 +1625,7 @@ sub dump_function($$) {
>       # If you mess with these regexps, it's a good idea to check that
>       # the following functions' documentation still comes out right:
>       # - parport_register_device (function pointer parameters)
> -    # - atomic_set (macro)
> +    # - qemu_atomic_set (macro)
>       # - pci_match_device, __copy_to_user (long return type)

Does the result of sphinx still look good, as mentioned in this comment?

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3226
Virtualization:  qemu.org | libvirt.org

