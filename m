Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24398B6F56
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 00:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731105AbfIRWYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 18:24:23 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55973 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727562AbfIRWYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 18:24:23 -0400
Received: by mail-wm1-f66.google.com with SMTP id a6so1892546wma.5
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2019 15:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H4MQ3yqWM9aLnpC+b6AQh55xJx9x+T81si1CR0+Cqfc=;
        b=H1OblpmNt3CrmpwPXnuMdUQy6V0xxviQE+H3Uy81W+v/ukgjwyBMNa4dadZNFC731d
         fnIEeLgV3/oRtZz6zxD1R/mnbzNqBew+W9KUPyVYucFgVjj15CTxzHnndmrjYhyFYKKM
         P95C62h2vvi1+OJNu1+6Y2cj8YlhJj49tlsBWGy4nmyBuBJiuaHDp7XR4yKPhpCFSZtB
         4rMGbEGr3fh1FZ9TPLGSBhlSJAajOSqPzyfgSlL1FVB6WU+SBiGzbbkqcBRrbDvRg8g/
         3ylKd+lJwWykqfCtQL4QJvzn7tWlYtmPtwO6vTXUvCg2oyS2mqaB3/DyuTWTwRepEiho
         Zn5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H4MQ3yqWM9aLnpC+b6AQh55xJx9x+T81si1CR0+Cqfc=;
        b=Adh3gsKM17zazgb5PiqGLeZO6qQx02KG0NOHf+SwO8Acox4SRUQwiVlyPqM8g6utb8
         q9Aek1+bBMcLoVu/yTZnPI3et4/GgVVI6+u46BW6HcejXphy0WQIl2eo3oNNUDrf5NEt
         XSs+ADrdPFCWGcde91TlYJsYFBbdnDEzb19ZmCyA4H2MIOOZrrAxYAuZPIAHOYb0cvm6
         REvLhJIRlAV4BJZYgOOiFvfCk5Ey0etwJG/5p/uAbrdFNGgT0IrBCh+aSJ8K8djTVHGf
         muJ4HcWOeu6xI23MF/wEsif/zP4L0Xbg4P0SusxHCFtrbH60BtG9fPOfhwuDapnJPf8Z
         1pnQ==
X-Gm-Message-State: APjAAAX05OOLf69Bd0DGLfc1HGqTxOR9ATldCC9iHmLa3sPP2tS0gXij
        XMXl8iMJgmhVcB+nYZvKPbf5wRsWu2goDqfc2fKYQA==
X-Google-Smtp-Source: APXvYqzZ2yMh3wi+EF+rgcsXBbRQFEHggnaMNzGNCEiusfFHRJOaIwTMmVf8K7ycf745mcZhuBWHoIl0KlLJoHaiMmk=
X-Received: by 2002:a7b:c40c:: with SMTP id k12mr117859wmi.151.1568845460986;
 Wed, 18 Sep 2019 15:24:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190917185753.256039-1-marcorr@google.com> <20190917185753.256039-2-marcorr@google.com>
 <87e25058-e726-9839-84b3-7270751be26e@oracle.com>
In-Reply-To: <87e25058-e726-9839-84b3-7270751be26e@oracle.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 18 Sep 2019 15:24:09 -0700
Message-ID: <CAA03e5GW1dXpUCO-5jfc3Vpr4oHMo1GijcuOz=rVWrQtj5DHug@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/2] x86: nvmx: test max atomic switch MSRs
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +     struct vmx_msr_entry *vm_enter_load;
> > +        struct vmx_msr_entry *vm_exit_load;
> > +        struct vmx_msr_entry *vm_exit_store;
>
> Is it possible to re-use the existing pointers in vmx_tests.c,
>
>      struct vmx_msr_entry *exit_msr_store, *entry_msr_load, *exit_msr_load;
>
>
>   instead of using local pointers ?

Done.

> > +     int max_allowed = max_msr_list_size();
> > +     int byte_capacity = 1ul << (msr_list_page_order + PAGE_SHIFT);
> > +     /* Exceeding the max MSR list size at exit trigers KVM to abort. */
> > +     int exit_count = count > max_allowed ? max_allowed : count;
> > +     int cleanup_count = count > max_allowed ? 2 : 1;
> > +     int i;
> > +
> > +     /*
> > +      * Check for the IA32_TSC MSR,
> > +      * available with the "TSC flag" and used to populate the MSR lists.
> > +      */
> > +     if (!(cpuid(1).d & (1 << 4))) {
> > +             report_skip(__func__);
> > +             return;
> > +     }
> > +
> > +     /* Set L2 guest. */
> > +     test_set_guest(atomic_switch_msr_limit_test_guest);
>
> Is it possible to directly pass the vmcall() function instead of
> creating a wrapper ?

Done.

> > +     if (count <= max_allowed) {
> > +             enter_guest();
> > +             assert_exit_reason(VMX_VMCALL);
>
> This is redundant because skip_exit_vmcall() calls this also.

Done.

> > +     free_pages_by_order(vm_enter_load, msr_list_page_order);
> > +     free_pages_by_order(vm_exit_load, msr_list_page_order);
> > +     free_pages_by_order(vm_exit_store, msr_list_page_order);
>
> Since the 2nd argument to the function is not changing, is there any
> particular reason for keeping it ?

The second argument has to match what was passed into the respective
alloc_pages() call, per my understanding.

> > +     /* Atomic MSR switch tests. */
> > +     TEST(atomic_switch_max_msrs_test),
> > +     TEST(atomic_switch_overflow_msrs_test),
>
> Actually, it should be a single executable.
> 'atomic_switch_max_msrs_test' is the positive version and
> 'atomic_switch_overflow_msrs_test' is the negative version of the
> MSR-lists, and so these should be enveloped in the same test.

They're separated because the negative version,
atomic_switch_overflow_msrs_test, may behave unexpectedly on real
hardware. This way, the negative version can easily be off by default
in the unittests.cfg file, and opted into as desired. Let me know if
there's a different, preferred, way to do this (e.g., via a flag) with
the two scenarios enveloped within a single test. However, this is
what Sean suggested in a prior code review and it seems like a good
solution to me.
