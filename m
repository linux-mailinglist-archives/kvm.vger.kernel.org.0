Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C443C6098
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 18:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbhGLQcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 12:32:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50397 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233207AbhGLQcY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Jul 2021 12:32:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626107375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TJmtx5S78DeUeOiaROIWgqckn0w0Vqgpgk4lj+SYH84=;
        b=MJkm7F7YtEIMvzCuJfcCzs6dFf6A5CjxTMM5XpRteqfyqoONDBxW87fIt4RDfOBAF+7HRN
        dA/lhj/+sHse9aB5I7WPsF0/wbCE32YlDKFhyd0ZNVW88JvXcjx2Wx41pWWB4KJZVL4Rs3
        pZbBbtuF2T0e8QZh5rfNj8H/jqsCnhE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-T-YqQpyJMQ-6FdB85iVLjQ-1; Mon, 12 Jul 2021 12:29:34 -0400
X-MC-Unique: T-YqQpyJMQ-6FdB85iVLjQ-1
Received: by mail-io1-f72.google.com with SMTP id p7-20020a6b63070000b029050017e563a6so12225065iog.4
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 09:29:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TJmtx5S78DeUeOiaROIWgqckn0w0Vqgpgk4lj+SYH84=;
        b=rPILugXsmq7K7pXZhOQhY2NiQVljK+UbUAW7HZfBw0dwcJ18ofAM5KWqSNW9YVOY1z
         zHqd4/51UVIedrb+54IVuJdhZ5dPvkOFfTE96+O+zPJdF6m5Wt4ouz/jopsqN03brvDr
         YtVHdXuQle5Eul+OSSSIfpwhCbdyVu4bY2bAdZhRREa4kmQ+3K16NMSI6jQPm4zBfyEF
         QiInYZYnStT8y360TA58wUweNzZGZ4Vb6xHfvxJ+iKeKj7s7aw80i0V4LHsBIA6+qT9r
         DBE/8U4qvj5Wlu66Y8kZzQIxB+AkYxqWFbO/hDzgS1jNRRiBbY+rS6DpkkqEfxTNeGIA
         x8eQ==
X-Gm-Message-State: AOAM533vBMHpj02Dtm/WlugLDtPv69/nq40t+7vf/iNlNYQSsf/SOQ/4
        gNzwCkNVB3yyx0mFYhE2Evq2QkcTBQO818kBdH+WcaOnqEqzjKy8Gnq2wQ29uouWHToYNdLrbnL
        bCR1Zj8SZVcoZ
X-Received: by 2002:a5d:9396:: with SMTP id c22mr1954806iol.204.1626107373566;
        Mon, 12 Jul 2021 09:29:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwImilQcOnLt4sAj84ow/BK6iQ1ylqR4O4cCQi7qJ0WuQd4a7pAccIK5xQXdYHv+ORO5s/zdw==
X-Received: by 2002:a5d:9396:: with SMTP id c22mr1954792iol.204.1626107373284;
        Mon, 12 Jul 2021 09:29:33 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id x10sm751617ill.26.2021.07.12.09.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 09:29:32 -0700 (PDT)
Date:   Mon, 12 Jul 2021 18:29:30 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pbonzini@redhat.com, jroedel@suse.de, bp@suse.de,
        thomas.lendacky@amd.com, brijesh.singh@amd.com
Subject: Re: [kvm-unit-tests PATCH 0/6] Initial x86_64 UEFI support
Message-ID: <20210712162930.hhxv66geufxqe4vy@gator>
References: <20210702114820.16712-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702114820.16712-1-varad.gautam@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 02, 2021 at 01:48:14PM +0200, Varad Gautam wrote:
> This series brings EFI support to a reduced subset of kvm-unit-tests
> on x86_64. I'm sending it out for early review since it covers enough
> ground to allow adding KVM testcases for EFI-only environments.
> 
> EFI support works by changing the test entrypoint to a stub entry
> point for the EFI loader to jump to in long mode, where the test binary
> exits EFI boot services, performs the remaining CPU bootstrapping,
> and then calls the testcase main().
> 
> Since the EFI loader only understands PE objects, the first commit
> introduces a `configure --efi` mode which builds each test as a shared
> lib. This shared lib is repackaged into a PE via objdump.
> 
> Commit 2-4 take a trip from the asm entrypoint to C to exit EFI and
> relocate ELF .dynamic contents.
> 
> Commit 5 adds post-EFI long mode x86_64 setup and calls the testcase.
> 
> Commit 6 patches out some broken tests for EFI. Testcases that refuse
> to build as shared libs are also left disabled, these need some massaging.
> 
> git tree: https://github.com/varadgautam/kvm-unit-tests/commits/efi-stub

Hi Varad,

Thanks for this. I haven't reviewed it in detail yet (I just got back from
vacation), but this looks like the right approach. In fact, I had started
going down the efi stub approach for AArch64 a while back as well, but the
effort got preempted by other work [again]. I'll try to allocate time to
play with this for x86 and to build on it for AArch64 in the coming weeks.

drew

> 
> Varad Gautam (6):
>   x86: Build tests as PE objects for the EFI loader
>   x86: Call efi_main from _efi_pe_entry
>   x86: efi_main: Get EFI memory map and exit boot services
>   x86: efi_main: Self-relocate ELF .dynamic addresses
>   cstart64.S: x86_64 bootstrapping after exiting EFI
>   x86: Disable some breaking tests for EFI and modify vmexit test
> 
>  .gitignore          |   2 +
>  Makefile            |  16 ++-
>  configure           |  11 ++
>  lib/linux/uefi.h    | 337 ++++++++++++++++++++++++++++++++++++++++++++
>  x86/Makefile.common |  45 ++++--
>  x86/Makefile.x86_64 |  43 +++---
>  x86/cstart64.S      |  78 ++++++++++
>  x86/efi.lds         |  67 +++++++++
>  x86/efi_main.c      | 167 ++++++++++++++++++++++
>  x86/vmexit.c        |   7 +
>  10 files changed, 741 insertions(+), 32 deletions(-)
>  create mode 100644 lib/linux/uefi.h
>  create mode 100644 x86/efi.lds
>  create mode 100644 x86/efi_main.c
> 
> -- 
> 2.30.2
> 

