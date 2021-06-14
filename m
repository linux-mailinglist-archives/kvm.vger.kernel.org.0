Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501803A5DD5
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 09:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbhFNHne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 03:43:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35990 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232524AbhFNHnc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 03:43:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623656489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3vluf07n1e9CMotPaBeCeLpe5If4SME3MyJJJYYovH4=;
        b=Su5DrWN6fKgvGvkGWTQ6LhBB1hnkXLJ2T1ffBpO3uId9Anymk9nAwZLLLpL9tG7V8q12o3
        SFZIlK3/XCyf4SOpKzVxvViUDl/WWodwNm/7H927iAPkrM8jQtGwoWm3hGiHd+yy33yAfE
        25lvIUl1giBIbMA5UB56stVmsjct3zk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-600-V-k4ltloMKSnRDveIQ1Irg-1; Mon, 14 Jun 2021 03:40:48 -0400
X-MC-Unique: V-k4ltloMKSnRDveIQ1Irg-1
Received: by mail-ed1-f71.google.com with SMTP id s25-20020aa7c5590000b0290392e051b029so14780828edr.11
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 00:40:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3vluf07n1e9CMotPaBeCeLpe5If4SME3MyJJJYYovH4=;
        b=Rqc5X44dKsgl1qlapan7JcKZXKjmb+fdhRAaQjUwqmC/TcHQFNizYX3pc1tSXLUYGp
         2wSq/SrNjELZSdMufQmWh1/mA2vTHfVttn0HQF8K9qsAQxn+B6jUDLRDiZeLfHv2FtvT
         g1+eUb9JFd5ZKmF7rNPdcUsegkLF1SZWjTlBJxgVnGl19QPtXebf48QtKfVWY42YCRMm
         PtpcCrjq8kZDWGwKVOqR5vV7BqeSiIotrnMtWBQBwIfOrYR57GUWSg9RdsfT3Bm5n+zj
         KxAxu+E6ssHE/CPnzHXx5pb9CvjOkuJU55KAHsD6E1o7STUR9oCGhZ9wAVe7xikKgW+j
         Cg/w==
X-Gm-Message-State: AOAM531TveiOzHigidt0HmTpHYAcWtoqHIzwOtqRmL4/FXCp56PuDPxu
        tDL4q9/ilQovMPkI3J63P7ywliN4I2FGqeiHv4LiTUthPynQyP2Hyihf6bkBYR0iet5JTxSB2u2
        iVkoavD20KfCt
X-Received: by 2002:a05:6402:4395:: with SMTP id o21mr15611031edc.163.1623656447220;
        Mon, 14 Jun 2021 00:40:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXFlZ+swOY5PozQnD2lwcOa9P4NfPBGblip0aRW2ve2FhR7KJrAMeV3SRvrOwFQafoV2qa0A==
X-Received: by 2002:a05:6402:4395:: with SMTP id o21mr15611021edc.163.1623656447053;
        Mon, 14 Jun 2021 00:40:47 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id c19sm7910388edw.10.2021.06.14.00.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:40:46 -0700 (PDT)
Date:   Mon, 14 Jun 2021 09:40:44 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, yuzenghui@huawei.com, vkuznets@redhat.com
Subject: Re: [PATCH v4 0/6] KVM: selftests: arm64 exception handling and
 debug test
Message-ID: <20210614074044.vntupqsiuqmqobsy@gator>
References: <20210611011020.3420067-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611011020.3420067-1-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 10, 2021 at 06:10:14PM -0700, Ricardo Koller wrote:
> Hi,
> 
> These patches add a debug exception test in aarch64 KVM selftests while
> also adding basic exception handling support.
> 
> The structure of the exception handling is based on its x86 counterpart.
> Tests use the same calls to initialize exception handling and both
> architectures allow tests to override the handler for a particular
> vector, or (vector, ec) for synchronous exceptions in the arm64 case.
> 
> The debug test is similar to x86_64/debug_regs, except that the x86 one
> controls the debugging from outside the VM. This proposed arm64 test
> controls and handles debug exceptions from the inside.
> 
> Thanks,
> Ricardo
> 
> v3 -> v4:
> 
> V3 was dropped because it was breaking x86 selftests builds (reported by
> the kernel test robot).
> - rename vm_handle_exception to vm_install_sync_handler instead of
>   vm_install_vector_handlers. [Sean]
> - use a single level of routing for exception handling. [Sean]
> - fix issue in x86_64/sync_regs_test when switching to ucalls for unhandled
>   exceptions reporting.
> 
> v2 -> v3:
> 
> Addressed comments from Andrew and Marc (thanks again). Also, many thanks for
> the reviews and tests from Eric and Zenghui.
> - add missing ISBs after writing into debug registers.
> - not store/restore of sp_el0 on exceptions.
> - add default handlers for Error and FIQ.
> - change multiple TEST_ASSERT(false, ...) to TEST_FAIL.
> - use Andrew's suggestion regarding __GUEST_ASSERT modifications
>   in order to easier implement GUEST_ASSERT_EQ (Thanks Andrew).
> 
> v1 -> v2:
> 
> Addressed comments from Andrew and Marc (thank you very much):
> - rename vm_handle_exception in all tests.
> - introduce UCALL_UNHANDLED in x86 first.
> - move GUEST_ASSERT_EQ to common utils header.
> - handle sync and other exceptions separately: use two tables (like
>   kvm-unit-tests).
> - add two separate functions for installing sync versus other exceptions
> - changes in handlers.S: use the same layout as user_pt_regs, treat the
>   EL1t vectors as invalid, refactor the vector table creation to not use
>   manual numbering, add comments, remove LR from the stored registers.
> - changes in debug-exceptions.c: remove unused headers, use the common
>   GUEST_ASSERT_EQ, use vcpu_run instead of _vcpu_run.
> - changes in processor.h: write_sysreg with support for xzr, replace EL1
>   with current in macro names, define ESR_EC_MASK as ESR_EC_NUM-1.
> 
> Ricardo Koller (6):
>   KVM: selftests: Rename vm_handle_exception
>   KVM: selftests: Complete x86_64/sync_regs_test ucall
>   KVM: selftests: Introduce UCALL_UNHANDLED for unhandled vector
>     reporting
>   KVM: selftests: Move GUEST_ASSERT_EQ to utils header
>   KVM: selftests: Add exception handling support for aarch64
>   KVM: selftests: Add aarch64/debug-exceptions test
> 
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   3 +-
>  .../selftests/kvm/aarch64/debug-exceptions.c  | 250 ++++++++++++++++++
>  .../selftests/kvm/include/aarch64/processor.h |  83 +++++-
>  .../testing/selftests/kvm/include/kvm_util.h  |  23 +-
>  .../selftests/kvm/include/x86_64/processor.h  |   4 +-
>  .../selftests/kvm/lib/aarch64/handlers.S      | 126 +++++++++
>  .../selftests/kvm/lib/aarch64/processor.c     |  97 +++++++
>  .../selftests/kvm/lib/x86_64/processor.c      |  23 +-
>  .../testing/selftests/kvm/x86_64/evmcs_test.c |   4 +-
>  .../selftests/kvm/x86_64/kvm_pv_test.c        |   2 +-
>  .../selftests/kvm/x86_64/sync_regs_test.c     |   7 +-
>  .../selftests/kvm/x86_64/tsc_msrs_test.c      |   9 -
>  .../kvm/x86_64/userspace_msr_exit_test.c      |   8 +-
>  .../selftests/kvm/x86_64/xapic_ipi_test.c     |   2 +-
>  15 files changed, 592 insertions(+), 50 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/debug-exceptions.c
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S
> 
> -- 
> 2.32.0.272.g935e593368-goog
>

For the series

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

