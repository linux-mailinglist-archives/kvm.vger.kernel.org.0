Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 318724D147
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 17:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfFTPDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 11:03:16 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33276 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfFTPDQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 11:03:16 -0400
Received: by mail-lj1-f194.google.com with SMTP id h10so3059513ljg.0
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 08:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qryYQIYqaMfgDNI3Y3pI3bEMZbqg5pRsTzyVnBW4EqU=;
        b=hQMjcL9ckVxrJdvB0CYXcoLXWH9j1HQg6pzkGu6LeZrhpipQT2rt49fQIot/k7JhTL
         9ZOSXBM8eJnpjECyUlOX4O15Ea1+EfA6uIMuJWEDzQzHpsXy9e21rTZl3i95lKHM+rmj
         f15MIoikl82NOlRVTbfzUYoW9i/l4OQlvgyvtcPcfOJduLPPh0YycxMlht4yqzCq4bY1
         tD9om5caof4GhwO6+16lY0t7g448iP6a1yJIeG79L/IDl9ajXj2U26hA6p6RSp6fk1nn
         f1FbZWzeXyS7dgfz4ZkvGuo89vasKvB7sr0t1GSvWfwJCbMJ1Nt/yZNgwipuSWVV8KC/
         oNJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qryYQIYqaMfgDNI3Y3pI3bEMZbqg5pRsTzyVnBW4EqU=;
        b=VWolu/McScLE22cRtmz6PE55qEuUE/rgTM5A+MQ8EgNWnvccmz4zpcYL6o/VYKpOrm
         3UEYzSqViJKbTblzmMoq5Gz2uS97tFiQoAG90XgVBYkiIuomgxtI0eqmwUpbRFi8YaH6
         c2NR//503pixzucuZaCV76zZb7ckbqaHUBJvLqcSO9wAu3Y8pJYCRJV+PfthnfExrodU
         LM1SHH3JsCgue47vCqeWXonyx9WQ0/Z4XZLQsY8GPSB+fOTdsDCJBjhsT/2u0tD709GI
         Z262nD9Zq33GUe9TBoZ8uAkcLh/aOVI3XB+TAffJyhMSSpk8VRpCRWiFmH72lCEk0d2l
         e1MQ==
X-Gm-Message-State: APjAAAUJLoeczoUmY+zcQoN31Pb06OzBwfKpTi3Xh4otB6Y/Iy3IzTPM
        uIagSu3O7VsjE6sLw2zgaYAqv7ILcVU6OwbnVcwZTw==
X-Google-Smtp-Source: APXvYqwl5JIwBn/FSQ+ub94PXOTWAYkrFFxIEBKya32ZhaEpDaNrLtS3w4wS+0aqV9RxsktQrstnDfVv4LjUSUlqk3s=
X-Received: by 2002:a2e:8681:: with SMTP id l1mr12696891lji.166.1561042994060;
 Thu, 20 Jun 2019 08:03:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190521171358.158429-1-aaronlewis@google.com>
 <CAAAPnDH1eiZf-HkT2T8aDBBU_TKV7Md=EBQymq9FDMZ7e4__6g@mail.gmail.com>
 <CAAAPnDHg6Qmwwuh3wGNdTXQ3C4hpSJo9D5bvZG4yX9s48DeSLQ@mail.gmail.com> <63c62aa7-2dd1-f133-d8bc-c7a3528b7598@oracle.com>
In-Reply-To: <63c62aa7-2dd1-f133-d8bc-c7a3528b7598@oracle.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 20 Jun 2019 08:03:02 -0700
Message-ID: <CAAAPnDFSRbYMwNrbTe-n7efwwD5KZJd2GebYwjWKKhh9QhtmXQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: tests: Sort tests in the Makefile alphabetically
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Marc Orr <marcorr@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 18, 2019 at 12:47 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
>
> On 06/18/2019 07:14 AM, Aaron Lewis wrote:
> > On Fri, May 31, 2019 at 9:37 AM Aaron Lewis <aaronlewis@google.com> wrote:
> >> On Tue, May 21, 2019 at 10:14 AM Aaron Lewis <aaronlewis@google.com> wrote:
> >>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> >>> Reviewed-by: Peter Shier <pshier@google.com>
> >>> ---
> >>>   tools/testing/selftests/kvm/Makefile | 20 ++++++++++----------
> >>>   1 file changed, 10 insertions(+), 10 deletions(-)
> >>>
> >>> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> >>> index 79c524395ebe..234f679fa5ad 100644
> >>> --- a/tools/testing/selftests/kvm/Makefile
> >>> +++ b/tools/testing/selftests/kvm/Makefile
> >>> @@ -10,23 +10,23 @@ LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/ucall.c lib/sparsebi
> >>>   LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c
> >>>   LIBKVM_aarch64 = lib/aarch64/processor.c
> >>>
> >>> -TEST_GEN_PROGS_x86_64 = x86_64/platform_info_test
> >>> -TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
> >>> -TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
> >>> -TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
> >>> -TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
> >>> -TEST_GEN_PROGS_x86_64 += x86_64/state_test
> >>> +TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
> >>>   TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
> >>>   TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
> >>> -TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
> >>> -TEST_GEN_PROGS_x86_64 += x86_64/smm_test
> >>>   TEST_GEN_PROGS_x86_64 += x86_64/kvm_create_max_vcpus
> >>> +TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
> >>> +TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
> >>> +TEST_GEN_PROGS_x86_64 += x86_64/smm_test
> >>> +TEST_GEN_PROGS_x86_64 += x86_64/state_test
> >>> +TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
> >>> +TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
> >>>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
> >>> -TEST_GEN_PROGS_x86_64 += dirty_log_test
> >>> +TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
> >>>   TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
> >>> +TEST_GEN_PROGS_x86_64 += dirty_log_test
>
> May be, place the last two at the beginning if you are arranging them
> alphabetically ?

The original scheme had everything in x86_64 first then everything in
the root folder second.  I wanted to maintain this scheme, so that's
why it is sorted this way.

>
> >>>
> >>> -TEST_GEN_PROGS_aarch64 += dirty_log_test
> >>>   TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
> >>> +TEST_GEN_PROGS_aarch64 += dirty_log_test
>
> May be, put the aarch64 ones above the x86_64 ones to arrange them
> alphabetically ?

I want to make a minimal change, so sorting the tags isn't a priority,
just the files.  The goal is to have a more predictable place to add
new tests, and I think this helps.

>
> >>>
> >>>   TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
> >>>   LIBKVM += $(LIBKVM_$(UNAME_M))
> >>> --
> >>> 2.21.0.1020.gf2820cf01a-goog
> >>>
> >> Does this look okay?  It's just a simple reordering of the list.  It
> >> helps when adding new tests.
> > ping
>
