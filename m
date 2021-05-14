Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D9E380FC1
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 20:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhENScc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 14:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhENSca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 14:32:30 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DF2C061760
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 11:31:19 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 6so200347pgk.5
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 11:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9E0wuTet4JopXThnpnWVLzmH9GIGkngbwCTAn/avRcg=;
        b=goRBrZkKl2sbgciLAmD3ktsJwV7wNxZ1BcVR788hJtYJTxhgb8RdlnM/1V3wuvVXAE
         jhqJR10uPQLiGkT/WpT5P9HxbS8k9PdfZTd7dQoNCOtX1I/4fnVwPvwOc8mMYLpimbqm
         1ua3Pf20dPMTZAApXbRkY17Ny9Mr1dQTtX0NUY9/HvNWM16HaqJUUi65R0+6DEn+Fu7y
         TngnjP2wi99y49A900MYT55pnrGfD8d3t7kcig3puEWydknkswKr6OqUtgVPWbXeRBwS
         GrqF9Won5bad3AQb/00v75asUB6Le8JHJy60aqCDu2qo13f5rAbAntXHBtZj4xUOFiSz
         dTig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9E0wuTet4JopXThnpnWVLzmH9GIGkngbwCTAn/avRcg=;
        b=Lojerlxm9HIOVq8Y+PIyre81zyN9YiUaxBLRXiAafip4XwekCjn0OX6QQ+lofc/wF/
         ZkqpPLXtSrfhOHXR2CYya3+br+BSQJIv6yG7ixFwnc3tjnxNaERci9alYNIXB4r/XLvm
         5ogw9zpMh4v5UUmHWhDT504CQfigVH4XIm3gp+GCyP5CBijP/e2bwYdttqPj7mH/CaJy
         3V2ahxnSzTbpSY7ILzU30TSBRrBJ1nxWhsZbN7aQpJBYiOrr/R2TuM8Z8n54j1Ye1M+n
         fh4xbpnoQ0XaDepBIA9DPhfktZH+rSXOeErysiQCgdhNEv2T2oYnU1W9rQ4T6rF+GcyY
         MPaw==
X-Gm-Message-State: AOAM532PGTHMb9dDADHqQqP8B5c19i8Vt1yGZQ/NHcvDy2fWI9hJsHuN
        bH8GQ5jlZROFdbMluWoI99mDXOh4esj8hBRq
X-Google-Smtp-Source: ABdhPJzk7gYz4Qlli53km2eo6kviqemudDpAU62A2i0TNtr4F5m6ss+yMWkSWLn48joRzCEHlSSr2g==
X-Received: by 2002:aa7:9a81:0:b029:28e:b12c:9862 with SMTP id w1-20020aa79a810000b029028eb12c9862mr47973754pfi.51.1621017078283;
        Fri, 14 May 2021 11:31:18 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id e2sm5038138pjk.31.2021.05.14.11.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 11:31:17 -0700 (PDT)
Date:   Fri, 14 May 2021 11:31:13 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
Subject: Re: [PATCH v3 0/5] KVM: selftests: arm64 exception handling and
 debug test
Message-ID: <YJ7B8TCwvzxJLJH/@google.com>
References: <20210513002802.3671838-1-ricarkol@google.com>
 <aeeec52e-5a13-be39-3b9c-cf25a27b97b1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeeec52e-5a13-be39-3b9c-cf25a27b97b1@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 13, 2021 at 08:37:33AM +0200, Auger Eric wrote:
> Hi Ricardo,
> 
> On 5/13/21 2:27 AM, Ricardo Koller wrote:
> > Hi,
> > 
> > These patches add a debug exception test in aarch64 KVM selftests while
> > also adding basic exception handling support.
> > 
> > The structure of the exception handling is based on its x86 counterpart.
> > Tests use the same calls to initialize exception handling and both
> > architectures allow tests to override the handler for a particular
> > vector, or (vector, ec) for synchronous exceptions in the arm64 case.
> > 
> > The debug test is similar to x86_64/debug_regs, except that the x86 one
> > controls the debugging from outside the VM. This proposed arm64 test
> > controls and handles debug exceptions from the inside.
> > 
> > Thanks,
> > Ricardo
> > 
> > v2 -> v3:
> > 
> > Addressed comments from Andrew and Marc (thanks again). Also, many thanks for
> > the reviews and tests from Eric and Zenghui.
> You are welcome. This version does not fail anymore on Cavium Sabre so
> this looks to fix the previously reported issue.
> 
> Thanks

Great, thanks Eric. The issue was that writing to mdscr needed ISBs
afterward (discovered by Zenghui).

> 
> Eric
> > - add missing ISBs after writing into debug registers.
> > - not store/restore of sp_el0 on exceptions.
> > - add default handlers for Error and FIQ.
> > - change multiple TEST_ASSERT(false, ...) to TEST_FAIL.
> > - use Andrew's suggestion regarding __GUEST_ASSERT modifications
> >   in order to easier implement GUEST_ASSERT_EQ (Thanks Andrew).
> > 
> > v1 -> v2:
> > 
> > Addressed comments from Andrew and Marc (thank you very much):
> > - rename vm_handle_exception in all tests.
> > - introduce UCALL_UNHANDLED in x86 first.
> > - move GUEST_ASSERT_EQ to common utils header.
> > - handle sync and other exceptions separately: use two tables (like
> >   kvm-unit-tests).
> > - add two separate functions for installing sync versus other exceptions
> > - changes in handlers.S: use the same layout as user_pt_regs, treat the
> >   EL1t vectors as invalid, refactor the vector table creation to not use
> >   manual numbering, add comments, remove LR from the stored registers.
> > - changes in debug-exceptions.c: remove unused headers, use the common
> >   GUEST_ASSERT_EQ, use vcpu_run instead of _vcpu_run.
> > - changes in processor.h: write_sysreg with support for xzr, replace EL1
> >   with current in macro names, define ESR_EC_MASK as ESR_EC_NUM-1.
> > 
> > Ricardo Koller (5):
> >   KVM: selftests: Rename vm_handle_exception
> >   KVM: selftests: Introduce UCALL_UNHANDLED for unhandled vector
> >     reporting
> >   KVM: selftests: Move GUEST_ASSERT_EQ to utils header
> >   KVM: selftests: Add exception handling support for aarch64
> >   KVM: selftests: Add aarch64/debug-exceptions test
> > 
> >  tools/testing/selftests/kvm/.gitignore        |   1 +
> >  tools/testing/selftests/kvm/Makefile          |   3 +-
> >  .../selftests/kvm/aarch64/debug-exceptions.c  | 250 ++++++++++++++++++
> >  .../selftests/kvm/include/aarch64/processor.h |  83 +++++-
> >  .../testing/selftests/kvm/include/kvm_util.h  |  23 +-
> >  .../selftests/kvm/include/x86_64/processor.h  |   4 +-
> >  .../selftests/kvm/lib/aarch64/handlers.S      | 124 +++++++++
> >  .../selftests/kvm/lib/aarch64/processor.c     | 131 +++++++++
> >  .../selftests/kvm/lib/x86_64/processor.c      |  22 +-
> >  .../selftests/kvm/x86_64/kvm_pv_test.c        |   2 +-
> >  .../selftests/kvm/x86_64/tsc_msrs_test.c      |   9 -
> >  .../kvm/x86_64/userspace_msr_exit_test.c      |   8 +-
> >  .../selftests/kvm/x86_64/xapic_ipi_test.c     |   2 +-
> >  13 files changed, 615 insertions(+), 47 deletions(-)
> >  create mode 100644 tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> >  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S
> > 
> 
