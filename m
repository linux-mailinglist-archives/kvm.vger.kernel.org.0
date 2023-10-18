Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51BA7CDFBB
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 16:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345422AbjJRO2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 10:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345190AbjJRO2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 10:28:16 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18039106
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 07:28:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7af69a4baso105205167b3.0
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 07:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697639293; x=1698244093; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d0L3+cFU4QsO14uhjYGccfA39wf1vKEGho7WfRP4LWs=;
        b=vJ3le7qQhojZ3jig9CCsnVTkHz6sJkGyjuuD2EqBIjdd5kuDbLuVXl8Hg+HONy/hGg
         owdLDe14zUs4iVL675sNDSLP/NsCHX3UXA5N86Vp1Tug17rocbzX8rogY1BKPMQ3ueOe
         kPgmEL/F5sBGEX+Iy+1vbClB3nVhipQOUhZ658CVfJ/YJKSEJYkqSMrnyiB0jwpk6Qjn
         149yl95Zm0so3x9OT9/HZQIyPBCG/A6ZoJ+PiwPJgnuxhyZP9jKTstr8qfs42/V87yoU
         ifpl7FwdzuOqJkKn39IRmgETz8/5jMM2Fq9ioWwY2M1bnVvP7qHWUqkm9bgtxILfyVIl
         mdwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697639293; x=1698244093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d0L3+cFU4QsO14uhjYGccfA39wf1vKEGho7WfRP4LWs=;
        b=VoYn5oeagXoCQIDwytB3tq0KPASBUrvBdoeh4DsrrXd/BpCu7eqYDjC0gPkT2OR0pc
         EAlaADi7+ERZRadWauFrFIb/grrCgB2+Uouy5Kf9NzywjhvgmwapEIKgarTwYj3107et
         6fTt/8PTmnDDRiby0jJoLHuDUWOcxKmFCH1kYADvIaUASSeLdZtvWIzkXZ+uRZHKSGw3
         P8QdNE0tyZp3Dqtb1bCHYwIX0wBvFJJOVrPg0jBC646TkOSyZZgV45FUojEhvUstCi7f
         BaPYtG6lfssLAv6mWenKDJm/z0FP9/xc8SqF1+1gtxhpGYElFmAAxjRunZklFefpiZRK
         e5Wg==
X-Gm-Message-State: AOJu0YzeV5AwrTWL82n1Fc/0M07DWoja58LLXbuauXWyM0ZOC5arQm1b
        CCa/7SDvOxnXAhBcgbFf24aDt+vWp/o=
X-Google-Smtp-Source: AGHT+IEbAz2u3aldbg+cvolfM3tRH+twFqSywuG35bwDq+oVphNk0bL2TVN80pFp9xSd7r3/Ptj8nJfKLTo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:cb4d:0:b0:592:7a39:e4b4 with SMTP id
 n74-20020a0dcb4d000000b005927a39e4b4mr125401ywd.6.1697639293380; Wed, 18 Oct
 2023 07:28:13 -0700 (PDT)
Date:   Wed, 18 Oct 2023 07:28:11 -0700
In-Reply-To: <9483638a-e34b-4e01-baa4-445a5984301c@gmail.com>
Mime-Version: 1.0
References: <20231017093335.18216-1-likexu@tencent.com> <ZS79MFkVB6A1N9AA@google.com>
 <9483638a-e34b-4e01-baa4-445a5984301c@gmail.com>
Message-ID: <ZS_rezh9cFeobEEz@google.com>
Subject: Re: [PATCH] KVM: x86: Clean up included but non-essential header declarations
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023, Like Xu wrote:
> On 18/10/2023 5:31 am, Sean Christopherson wrote:
> > On Tue, Oct 17, 2023, Like Xu wrote:
> > > From: Like Xu <likexu@tencent.com>
> > > Removing these declarations as part of KVM code refactoring can also (when
> > > the compiler isn't so smart) reduce compile time, compile warnings, and the
> > 
> > Really, warnings?  On what W= level?  W=1 builds just fine with KVM_WERROR=y.
> > If any of the "supported" warn levels triggers a warn=>error, then we'll fix it.
> > 
> > > size of compiled artefacts, and more importantly can help developers better
> > > consider decoupling when adding/refactoring unmerged code, thus relieving
> > > some of the burden on the code review process.
> > 
> > Can you provide an example?  KVM certainly has its share of potential circular
> > dependency pitfalls, e.g. it's largely why we have the ugly and seemingly
> > arbitrary split between x86.h and asm/kvm_host.h.  But outside of legitimate
> > collisions like that, I can't think of a single instance where superfluous existing
> > includes caused problems.  On the other hand, I distinctly recall multiple
> > instances where a header didn't include what it used and broke the build when the
> > buggy header was included in a new file.
> 
> I've noticed that during patch iterations, developers add or forget to
> remove header declarations from previous versions (just so the compiler
> doesn't complain), and the status quo is that these header declarations
> are rapidly ballooning.

That's hyperbolic BS.  Here's the diff of includes in x86.c from v2.6.38 to now.

  @@ -1,20 +1,29 @@
  +#include "ioapic.h"
  +#include "kvm_emulate.h"
  +#include "mmu/page_track.h"
  +#include "cpuid.h"
  +#include "pmu.h"
  +#include "hyperv.h"
  +#include "lapic.h"
  +#include "xen.h"
  +#include "smm.h"
  
  New KVM functionality and/or the result of refactoring code to break up large files.
  
  -#include <linux/module.h>
  +#include <linux/export.h>
  +#include <linux/moduleparam.h>
  
  Likely a refactoring of other code.  Basically a wash.
  
  -#include <linux/intel-iommu.h>
  
  Removal of an unnecessary vendor-specific include.
  
  +#include <linux/pci.h>
  +#include <linux/timekeeper_internal.h>
  
  These two look dubious and probably can be removed.
  
  +#include <linux/pvclock_gtod.h>
  +#include <linux/kvm_irqfd.h>
  +#include <linux/irqbypass.h>
  +#include <linux/sched/stat.h>
  +#include <linux/sched/isolation.h>
  +#include <linux/mem_encrypt.h>
  +#include <linux/entry-kvm.h>
  +#include <linux/suspend.h>
  +#include <linux/smp.h>
  +#include <trace/events/ipi.h>
  
  New functionality and/or refactoring.
  
  -#include <asm/mtrr.h>
  -#include <asm/i387.h>
  -#include <asm/xcr.h>
  
  Removal from refactoring.
  
  +#include <asm/pkru.h>

  New functionality.

  +#include <linux/kernel_stat.h>
  
  This one looks dubious and probably can be removed.
  
  +#include <asm/fpu/api.h>
  +#include <asm/fpu/xcr.h>
  +#include <asm/fpu/xstate.h>
  +#include <asm/irq_remapping.h>
  +#include <asm/mshyperv.h>
  +#include <asm/hypervisor.h>
  
  New functionality and/or refactoring.
  
  +#include <asm/tlbflush.h>
  
  The tlbflush.h include _might_ be stale now that x86.c doesn't use cr4_read_shadow(),
  but it's also entirely possible there's a real need for it as tlbflush.h defines a
  lot more than just TLB flush stuff.
  
  +#include <asm/intel_pt.h>
  +#include <asm/emulate_prefix.h>
  +#include <asm/sgx.h>
  +#include <clocksource/hyperv_timer.h>
  
  New functionality and/or refactoring.

So over the last *13 years*, x86.c has gained 3 includes that are likely now
stale, and one that might be stale.  Yes, the total number of includes has roughly
doubled, but so has the size of x86.c!

arch/x86/include/asm/kvm_host.h is a similar story.  The number of includes has
roughly doubled, but the size of kvm_host.h has nearly *tripled*.  And at a glance,
every single new include is warranted.

  @@ -3,12 +3,26 @@
   #include <linux/mmu_notifier.h>
   #include <linux/tracepoint.h>
   #include <linux/cpumask.h>
  +#include <linux/irq_work.h>
  +#include <linux/irq.h>
  +#include <linux/workqueue.h>
   
   #include <linux/kvm.h>
   #include <linux/kvm_para.h>
   #include <linux/kvm_types.h>
  +#include <linux/perf_event.h>
  +#include <linux/pvclock_gtod.h>
  +#include <linux/clocksource.h>
  +#include <linux/irqbypass.h>
  +#include <linux/hyperv.h>
  +#include <linux/kfifo.h>
   
  +#include <asm/apic.h>
   #include <asm/pvclock-abi.h>
   #include <asm/desc.h>
   #include <asm/mtrr.h>
   #include <asm/msr-index.h>
  +#include <asm/asm.h>
  +#include <asm/kvm_page_track.h>
  +#include <asm/kvm_vcpu_regs.h>
  +#include <asm/hyperv-tlfs.h>

I would hardly desribe either of those as "rapidly ballooning".

> > >   43 files changed, 184 deletions(-)
> > 
> > NAK, I am not taking a wholesale purge of includes.  I have no objection to
> > removing truly unnecessary includes, e.g. there are definitely some includes that
> > are no longer necessary due to code being moved around.  But changes like the
> > removal of all includes from tdp_mmu.h and smm.h are completely bogus.  If anything,
> > smm.h clearly needs more includes, because it is certainly not including everything
> > it is using.
> 
> Thanks, this patch being nak is to be expected. As you've noticed in the
> smm.h story, sensible dependencies should appear in sensible header files,
> and are assembled correctly to promote better understanding (the compiler
> seems to be happy on weird dependency combinations and doesn't complain
> until something goes wrong).
> 
> In addition to "x86.h and asm/kvm_host.h", we could have gone further in
> the direction of "Make headers standalone", couldn't we ?

I honestly have no idea what point you're trying to make.  If you're asking
"could be split up x86.h and asm/kvm_host.h into smaller headers", then the answer
is "yes".  But that's not at all what your proposed patch does, and such cleanups
are usually non-trivial and come with a cost, e.g. complicates backporting fixes
to stable trees.

I'm obviously not opposed to cleaning up and reducing unnecessary includes, e.g.
see the recent work I put into arch/x86/include/asm/kvm_page_track.h.  But crap
like this just wastes my time and makes me grumpy.
