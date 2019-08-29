Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1332A1558
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 12:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfH2KDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 06:03:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfH2KDW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 06:03:22 -0400
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D1B5359455
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 10:03:21 +0000 (UTC)
Received: by mail-pg1-f200.google.com with SMTP id q1so1707584pgt.2
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 03:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FLgzdYsri5EILgr23jEU4L5f0KDsqM0mkUgvzUt9vY8=;
        b=W2pNwt1kV4fVacxpIq8clIVk1q07f1r+l6oHMAWxYLTxWxB4x6oyVJ5QrthKk1mP3l
         jk5/pt0+50qPDZiWj4/qex0HUjF6hXlWMs6l8QGODz3DoTaiXAhU0L6lkpzU6m8XY2/h
         gA9sd/z01AFWHBCj2h1iMLRNsN5ngNu7GwpdOkqnUs4r+8h/y57Hm9RHmboAMSmRB1kq
         jtGuOwEev15iHZuZ5m1nIFECOAk8eZKL5T60SARReqvCt8l6LDcPX1EbMftMorEsAK8w
         +2p+r4XlyrtTH7G50XJYgxd72stvskJItjvJJ9+hjbxQvULFXhMFT/t8YI+r9ptfVQJ3
         9PlQ==
X-Gm-Message-State: APjAAAWJU6fVYqjpW1VeYk6kEZxra0EbDFdJvyGDqPETwKCYcMmC8Wam
        kNTWIMVUl1aIaDdKjTkTQIaGwmI1trbyp7fu28mQdHRhO3tCWOsPsMLzn1XtrXdaDB4e98zWii3
        VShFdEL4/DuZW
X-Received: by 2002:a17:90a:3b04:: with SMTP id d4mr8947822pjc.80.1567073001249;
        Thu, 29 Aug 2019 03:03:21 -0700 (PDT)
X-Google-Smtp-Source: APXvYqww1/tN21K3EaQdUoDdWqU2F/rzT4no3l16BDXrxXelEGYmmxGilarEYf4qyPPmbELZeai4XA==
X-Received: by 2002:a17:90a:3b04:: with SMTP id d4mr8947798pjc.80.1567073000931;
        Thu, 29 Aug 2019 03:03:20 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b126sm5809085pfa.177.2019.08.29.03.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 03:03:19 -0700 (PDT)
Date:   Thu, 29 Aug 2019 18:03:09 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v2 3/4] KVM: selftests: Introduce VM_MODE_PXXV48_4K
Message-ID: <20190829100309.GJ8729@xz-x1>
References: <20190829022117.10191-1-peterx@redhat.com>
 <20190829022117.10191-4-peterx@redhat.com>
 <20190829094516.fyfhgz7ma2nfazoq@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190829094516.fyfhgz7ma2nfazoq@kamzik.brq.redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 11:45:16AM +0200, Andrew Jones wrote:
> On Thu, Aug 29, 2019 at 10:21:16AM +0800, Peter Xu wrote:
> > The naming VM_MODE_P52V48_4K is explicit but unclear when used on
> > x86_64 machines, because x86_64 machines are having various physical
> > address width rather than some static values.  Here's some examples:
> > 
> >   - Intel Xeon E3-1220:  36 bits
> >   - Intel Core i7-8650:  39 bits
> >   - AMD   EPYC 7251:     48 bits
> > 
> > All of them are using 48 bits linear address width but with totally
> > different physical address width (and most of the old machines should
> > be less than 52 bits).
> > 
> > Let's create a new guest mode called VM_MODE_PXXV48_4K for current
> > x86_64 tests and make it as the default to replace the old naming of
> > VM_MODE_P52V48_4K because it shows more clearly that the PA width is
> > not really a constant.  Meanwhile we also stop assuming all the x86
> > machines are having 52 bits PA width but instead we fetch the real
> > vm->pa_bits from CPUID 0x80000008 during runtime.
> > 
> > We currently make this exclusively used by x86_64 but no other arch.
> > 
> > As a slight touch up, moving DEBUG macro from dirty_log_test.c to
> > kvm_util.h so lib can use it too.
> > 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  tools/testing/selftests/kvm/dirty_log_test.c  |  5 ++--
> >  .../testing/selftests/kvm/include/kvm_util.h  |  9 +++++-
> >  .../selftests/kvm/include/x86_64/processor.h  |  3 ++
> >  .../selftests/kvm/lib/aarch64/processor.c     |  3 ++
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 29 ++++++++++++++----
> >  .../selftests/kvm/lib/x86_64/processor.c      | 30 ++++++++++++++++---
> >  6 files changed, 65 insertions(+), 14 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> > index efb7746a7e99..c86f83cb33e5 100644
> > --- a/tools/testing/selftests/kvm/dirty_log_test.c
> > +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> > @@ -19,8 +19,6 @@
> >  #include "kvm_util.h"
> >  #include "processor.h"
> >  
> > -#define DEBUG printf
> > -
> >  #define VCPU_ID				1
> >  
> >  /* The memory slot index to track dirty pages */
> > @@ -256,6 +254,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
> >  
> >  	switch (mode) {
> >  	case VM_MODE_P52V48_4K:
> > +	case VM_MODE_PXXV48_4K:
> >  		guest_pa_bits = 52;
> >  		guest_page_shift = 12;
> >  		break;
> > @@ -446,7 +445,7 @@ int main(int argc, char *argv[])
> >  #endif
> >  
> >  #ifdef __x86_64__
> > -	vm_guest_mode_params_init(VM_MODE_P52V48_4K, true, true);
> > +	vm_guest_mode_params_init(VM_MODE_PXXV48_4K, true, true);
> >  #endif
> >  #ifdef __aarch64__
> >  	vm_guest_mode_params_init(VM_MODE_P40V48_4K, true, true);
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index c78faa2ff7f3..430edbacb9b2 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -24,6 +24,10 @@ struct kvm_vm;
> >  typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
> >  typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
> >  
> > +#ifndef DEBUG
> > +#define DEBUG printf
> > +#endif
> 
> There's no way to turn this off without modifying code. I suggested
> 
> #ifndef NDEBUG
> #define dprintf printf
> #endif
> 
> which allows the dprintf(...) statements to be removed by compiling with
> -DNDEBUG added to CFLAGS. And that would also disable all the asserts().
> That's probably not all that useful, but then again, defining printf() as
> DEBUG() isn't useful either if the intention is to always print.

Sorry I misread that...

Though, I'm afraid even if with above it won't compile with -DNDEBUG
because the compiler could start to complain about undefined
"dprintf", or even recognize the dprintf as the libc call, dprintf(3).

So instead, does below looks ok?

#ifdef NDEBUG
#define DEBUG(...)
#else
#define DEBUG(...) printf(__VA_ARGS__);
#endif

Thanks,

-- 
Peter Xu
