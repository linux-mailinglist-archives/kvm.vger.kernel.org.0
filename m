Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19CE2F9AF2
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 09:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733291AbhARIEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 03:04:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50328 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733222AbhARIEJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 03:04:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610956960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jTgNdRDUMjp+NABm74DpOQpjeQcqsyUbCjmMQCacUck=;
        b=iz/P/dwOj2FJtQ426HcEkfSB9b9gYs1g/dzGvGL1h7Oq6NwAQEnYw1UZgmaYLJwz9JtcYX
        aqUNSSa/lpj4jpMX+eHd59Qr/I85xkYqSCbPKaGNnvMHl5W3CD+z+EVyxzpzghNmT1jgN+
        YG6v5IB3f6C81uVPVesMM6a3bHei0iA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-4I_9-2YMOoCxpesbMZiLUw-1; Mon, 18 Jan 2021 03:02:36 -0500
X-MC-Unique: 4I_9-2YMOoCxpesbMZiLUw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32FB7107ACFA;
        Mon, 18 Jan 2021 08:02:34 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-189.ams2.redhat.com [10.36.112.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDC3E6F986;
        Mon, 18 Jan 2021 08:02:25 +0000 (UTC)
Subject: Re: [PATCH v2 0/9] Alpine Linux build fix and CI pipeline
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-ppc@nongnu.org,
        Greg Kurz <groug@kaod.org>, Max Reitz <mreitz@redhat.com>,
        kvm@vger.kernel.org,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        Alistair Francis <alistair@alistair23.me>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-block@nongnu.org, Kevin Wolf <kwolf@redhat.com>
References: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <a34add77-2b12-3c83-4362-1241e2aef034@redhat.com>
Date:   Mon, 18 Jan 2021 09:02:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/01/2021 07.37, Jiaxun Yang wrote:
> Alpine Linux is a security-oriented, lightweight Linux distribution
> based on musl libc and busybox.
> 
> It it popular among Docker guests and embedded applications.
> 
> Adding it to test against different libc.
> 
> Patches pending review at v2 are: 7, 8, 9
> 
> Tree avilable at: https://gitlab.com/FlyGoat/qemu/-/commits/alpine_linux_v2
> CI All green: https://gitlab.com/FlyGoat/qemu/-/pipelines/242003288
> 
> It is known to have checkpatch complains about identation but they're
> all pre-existing issues as I'm only doing string replacement.
> 
> v2:
>   - Reoreder patches (Wainer)
>   - Add shadow to dockerfile (Wainer)
>   - Pickup proper signal.h fix (PMM)
>   - Correct clock_adjtime title (Thomas Huth)
>   - Collect review tags
> 
> Jiaxun Yang (8):
>    configure: Add sys/timex.h to probe clock_adjtime
>    libvhost-user: Include poll.h instead of sys/poll.h
>    hw/block/nand: Rename PAGE_SIZE to NAND_PAGE_SIZE
>    elf2dmp: Rename PAGE_SIZE to ELF2DMP_PAGE_SIZE
>    tests: Rename PAGE_SIZE definitions
>    accel/kvm: avoid using predefined PAGE_SIZE
>    tests/docker: Add dockerfile for Alpine Linux
>    gitlab-ci: Add alpine to pipeline
> 
> Michael Forney (1):
>    osdep.h: Remove <sys/signal.h> include
> 
>   configure                                 |  1 +
>   meson.build                               |  1 -
>   contrib/elf2dmp/addrspace.h               |  6 +-
>   include/qemu/osdep.h                      |  4 --
>   subprojects/libvhost-user/libvhost-user.h |  2 +-
>   accel/kvm/kvm-all.c                       |  3 +
>   contrib/elf2dmp/addrspace.c               |  4 +-
>   contrib/elf2dmp/main.c                    | 18 +++---
>   hw/block/nand.c                           | 40 ++++++-------
>   tests/migration/stress.c                  | 10 ++--
>   tests/qtest/libqos/malloc-pc.c            |  4 +-
>   tests/qtest/libqos/malloc-spapr.c         |  4 +-
>   tests/qtest/m25p80-test.c                 | 54 ++++++++---------
>   tests/tcg/multiarch/system/memory.c       |  6 +-
>   tests/test-xbzrle.c                       | 70 +++++++++++------------
>   .gitlab-ci.d/containers.yml               |  5 ++
>   .gitlab-ci.yml                            | 23 ++++++++
>   tests/docker/dockerfiles/alpine.docker    | 57 ++++++++++++++++++
>   18 files changed, 198 insertions(+), 114 deletions(-)
>   create mode 100644 tests/docker/dockerfiles/alpine.docker
> 

Thanks! I'll take this through my testing-next branch:

  https://gitlab.com/huth/qemu/-/commits/testing-next/

  Thomas

