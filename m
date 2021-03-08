Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDA43310F5
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhCHOge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:36:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52660 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230480AbhCHOgU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:36:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615214179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z6aTjsstS//XU46FW5n04GbzvkHS0se7lPTHSWa5HW4=;
        b=aymgr8P5IllcroovjzVQVW5ncR2bJ54Uq1k1AlUGbekqlr4r7zBQK1CQLrjoh4uJbybbKa
        7uJC91+pUl/qMTRQTLsrNpr7AtrRcePvdOrAwXJNGvw/AGl7L/1hugEnxzxlWDBbGC5A7g
        50NZWZy53kLnXmGyfTFqD4Av2okqJPE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-hmrgkLsdN6aKJIuxr1VxKQ-1; Mon, 08 Mar 2021 09:36:16 -0500
X-MC-Unique: hmrgkLsdN6aKJIuxr1VxKQ-1
Received: by mail-ej1-f70.google.com with SMTP id m4so4138723ejc.14
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 06:36:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z6aTjsstS//XU46FW5n04GbzvkHS0se7lPTHSWa5HW4=;
        b=LqNEB7BQ94wgJeKB9NpU6cauowZj0GeIrybH7YajXX1uINYQcawDkR8bfPWPcCuIfO
         pM0UXKQ9Y8na5rGopvWMxV0OheroFbtNgFd0+Nl3gXtAnG3NH9DVUveQLa7SPDVtRGs9
         rrsxqJF+ErfCzd1NrasSH4l7H+tnivMKHGXjXDC/4I+Af3Aq2OvtNrB+9mS6H0QfWGQS
         3C6EXcLdee9wVWJuQe4OCuDwIu6BUAXhxMEBEThvqrA0o6b1J/KSnoIPasaI7RvcUbPd
         wCSwOxQ9X7s8cbS4dp5I7GHSzGgUolmVSrYG8t346BQ1lIWj7Q5bq5ED/I4/qzRn9ORL
         M0gQ==
X-Gm-Message-State: AOAM532HhyVJXh7FCB5J9K1sJS9InUjZJIlTU2wX+9v8Pqws5DKtz6Is
        rLlQ2pFdZ+7JlRBqzTFTqMZHxdc87WFs0J1mpBNkUsNAbo/WtfbpTiAhWseWf3EP/L7MNvQpQMT
        iTSnP4vID7WPj
X-Received: by 2002:a17:906:7c44:: with SMTP id g4mr15038609ejp.269.1615214175040;
        Mon, 08 Mar 2021 06:36:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwXAR5BlVE65pzfj2tGCA9YAyD71OkhlsSV9Ii80iP6dafAeCBsMyLBkRK/oC2uHVJpQscBCg==
X-Received: by 2002:a17:906:7c44:: with SMTP id g4mr15038580ejp.269.1615214174812;
        Mon, 08 Mar 2021 06:36:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f11sm6683683eje.107.2021.03.08.06.36.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 06:36:14 -0800 (PST)
Subject: Re: [kvm-unit-tests GIT PULL 00/16] s390x update
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com
References: <20210308143147.64755-1-frankja@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a47a30be-1edc-6351-747d-d14db3e6f932@redhat.com>
Date:   Mon, 8 Mar 2021 15:36:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210308143147.64755-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/03/21 15:31, Janosch Frank wrote:
> Dear Paolo,
> 
> please merge or pull the following changes:
>   * IO tests PV compatibility (Pierre)
>   * Backtrace support (Janosch)
>   * mvpg test (Claudio)
>   * Fixups (Thomas)
> 
> 
> MERGE:
> https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/5
> 
> 
> PULL:
> The following changes since commit 739f7de6b3c8deaf22d2fa5e6016ad2c7bd22ddc:
> 
>    x86: clean up EFER definitions (2021-02-18 13:31:22 -0500)
> 
> are available in the Git repository at:
> 
>    https://gitlab.com/frankja/kvm-unit-tests.git s390x-pull-2021-08-03
> 
> for you to fetch changes up to b7f0f9a2e1fdb9d4235164f0a8d8ea880e1cefd4:
> 
>    s390x: mvpg: skip some tests when using TCG (2021-03-08 12:03:47 +0100)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> Claudio Imbrenda (3):
>    s390x: introduce leave_pstate to leave userspace
>    s390x: mvpg: simple test
>    s390x: mvpg: skip some tests when using TCG
> 
> Janosch Frank (8):
>    s390x: Remove sthyi partition number check
>    s390x: Fix fpc store address in RESTORE_REGS_STACK
>    s390x: Fully commit to stack save area for exceptions
>    s390x: Introduce and use CALL_INT_HANDLER macro
>    s390x: Provide preliminary backtrace support
>    s390x: Print more information on program exceptions
>    s390x: Move diag308_load_reset to stack saving
>    s390x: Remove SAVE/RESTORE_STACK and lowcore fpc and fprs save areas
> 
> Pierre Morel (3):
>    s390x: pv: implement routine to share/unshare memory
>    s390x: define UV compatible I/O allocation
>    s390x: css: pv: css test adaptation for PV
> 
> Thomas Huth (2):
>    lib/s390x/sclp: Clarify that the CPUEntry array could be at a
>      different spot
>    Fix the length in the stsi check for the VM name
> 
>   lib/s390x/asm-offsets.c   |  17 ++-
>   lib/s390x/asm/arch_def.h  |  42 ++++--
>   lib/s390x/asm/interrupt.h |   4 +-
>   lib/s390x/asm/uv.h        |  39 ++++++
>   lib/s390x/css.h           |   3 +-
>   lib/s390x/css_lib.c       |  28 ++--
>   lib/s390x/interrupt.c     |  61 +++++++--
>   lib/s390x/malloc_io.c     |  71 ++++++++++
>   lib/s390x/malloc_io.h     |  45 +++++++
>   lib/s390x/sclp.h          |   9 +-
>   lib/s390x/stack.c         |  20 ++-
>   s390x/Makefile            |   3 +
>   s390x/cpu.S               |   6 +-
>   s390x/css.c               |  43 ++++--
>   s390x/cstart64.S          |  25 +---
>   s390x/macros.S            |  96 ++++++-------
>   s390x/mvpg.c              | 277 ++++++++++++++++++++++++++++++++++++++
>   s390x/sthyi.c             |   1 -
>   s390x/stsi.c              |   2 +-
>   s390x/unittests.cfg       |   4 +
>   20 files changed, 657 insertions(+), 139 deletions(-)
>   create mode 100644 lib/s390x/malloc_io.c
>   create mode 100644 lib/s390x/malloc_io.h
>   create mode 100644 s390x/mvpg.c
> 

