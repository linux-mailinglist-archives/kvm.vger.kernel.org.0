Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF4C7443DF
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 23:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjF3VZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 17:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjF3VY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 17:24:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B133B2680
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 14:24:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bfebb1beeccso2197810276.2
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 14:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688160298; x=1690752298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9OuqO+GprsYwzlZrAMxO302oe0WdyZWBaVRgt/0KOVc=;
        b=C98VfhGLNA5xfbBYxeu79VpxIy9gRA6nupPJlAfe0FuPEfw/4GPR1LutGEmbPkU+D6
         LCsyyk7D1OMMbPdZuqJ9pRQyj5bW6ckdCA5JJQ6l1LqK6+B3WHfFhFGW1zF4WhSDt95B
         76niGAHa2KUaUlGFoU46LfHpWIdnS1uFr74lXzrCCEehASUT/Zkr0bpM7jQ7BSmVFXYz
         a2YxzWzm0vujdecLtLgB25IIGiMTe9YiFVK4SJ/eBhMlwZW3PKId1fdZAWpVYfILXO43
         OkuMAJ9vMYtxDqrigZ3s9PiQR/RD0SJ2XoRA2Xh0FFvQ/TxS2T5r8RXuCsiv02v77dUv
         kuPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688160298; x=1690752298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9OuqO+GprsYwzlZrAMxO302oe0WdyZWBaVRgt/0KOVc=;
        b=NQlYbLO1qyAxLSw4As8ZEWTM5a4AY7RzFZZxDOPaaHXg1KTUp3HoeO3vy6W0gh5OI0
         di73SiFJbec3ReDy+nWLpBboR2gEsFDGUH3Pelek8Lh4RDdfUiTYSQa5FS32/fGC2h/s
         4NLi8rZJJPGig5vTc/1o5iSzD8Xql/A1851gsCw28bSh/PjyYB3qKkV8A9gsILc27NyB
         3AIQVw0JzIGAC9U0Ym4pWYy+6l3hRk3aC12SL06Orw5KMi8JCcxtTyqutcBp2DLPP/OE
         eANG31FJZHI+VOYstZ6YfftTQc90iNhpD+VWoGU9A3M2z/qQb3uWUXii8cOz6dz5yHAX
         Bz3w==
X-Gm-Message-State: ABy/qLYuEZ7kQfPxhnYwf4Gv4OqLh5HWwUh3CzBWGmVlzW7E0uBQQRgF
        cimyU3wpClgIjAXev6gGu/wNso3yKPM=
X-Google-Smtp-Source: APBJJlGImEzp5+7kOBgHaxvCjkxiHX5w7NN8ScEyxNJQ7wgzjAyS5wsh+UoGUOwuj07AgYjSnXiJcdrLhIY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4183:0:b0:c1e:f91c:2691 with SMTP id
 o125-20020a254183000000b00c1ef91c2691mr37547yba.10.1688160297945; Fri, 30 Jun
 2023 14:24:57 -0700 (PDT)
Date:   Fri, 30 Jun 2023 14:24:56 -0700
In-Reply-To: <20230630190514.GH3436214@ls.amr.corp.intel.com>
Mime-Version: 1.0
References: <cover.1687784645.git.kai.huang@intel.com> <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
 <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
 <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
 <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
 <20230630183020.GA4253@hirez.programming.kicks-ass.net> <20230630190514.GH3436214@ls.amr.corp.intel.com>
Message-ID: <ZJ9IKALhz1Q6ogu1@google.com>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on demand
From:   Sean Christopherson <seanjc@google.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Kai Huang <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, Sagi Shahar <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, Chao Gao <chao.gao@intel.com>,
        Len Brown <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Ying Huang <ying.huang@intel.com>,
        Dan J Williams <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023, Isaku Yamahata wrote:
> On Fri, Jun 30, 2023 at 08:30:20PM +0200,
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, Jun 30, 2023 at 09:55:32AM +0000, Huang, Kai wrote:
> > > On Fri, 2023-06-30 at 11:26 +0200, Peter Zijlstra wrote:
> > > > On Thu, Jun 29, 2023 at 12:10:00AM +0000, Huang, Kai wrote:
> > > > > On Wed, 2023-06-28 at 15:17 +0200, Peter Zijlstra wrote:
> > > > > > On Tue, Jun 27, 2023 at 02:12:37AM +1200, Kai Huang wrote:
> > > > > > > +EXPORT_SYMBOL_GPL(tdx_cpu_enable);
> > > > > > 
> > > > > > I can't find a single caller of this.. why is this exported?
> > > > > 
> > > > > It's for KVM TDX patch to use, which isn't in this series.
> > > > > 
> > > > > I'll remove the export.  KVM TDX series can export it.
> > > > 
> > > > Fair enough; where will the KVM TDX series call this? Earlier there was
> > > > talk about doing it at kvm module load time -- but I objected (and still
> > > > do object) to that.
> > > > 
> > > > What's the current plan?
> > > > 
> > > 
> > > The direction is still doing it during module load (not my series anyway).  But
> > > this can be a separate discussion with KVM maintainers involved.
> > 
> > They all on Cc afaict.
> > 
> > > I understand you have concern that you don't want to have the memory & cpu time
> > > wasted on enabling TDX by default.  For that we can have a kernel command line
> > > to disable TDX once for all (we can even make it default).
> > 
> > That's insane, I don't want to totally disable it. I want it done at
> > guard creation. Do the whole TDX setup the moment you actually create a
> > TDX guast.
> > 
> > Totally killing TDX is stupid, 

I dunno about that, *totally* killing TDX would make my life a lot simpler ;-)

> > just about as stupid as doing it on module load (which equates to always
> > doing it).
> > 
> > > Also, KVM will have a module parameter 'enable_tdx'.  I am hoping this could
> > > reduce your concern too.
> > 
> > I don't get this obsession with doing at module load time :/

Waiting until userspace attempts to create the first TDX guest adds complexity
and limits what KVM can do to harden itself.  Currently, all feature support in
KVM is effectively frozen at module load.  E.g. most of the setup code is
contained in __init functions, many module-scoped variables are effectively 
RO after init (though they can't be marked as such until we smush kvm-intel.ko
and kvm-amd.ko into kvm.ko, which is tentatively the long-term plan).  All of
those patterns would get tossed aside if KVM waits until userspace attempts to
create the first guest.

The userspace experience would also be poor, as KVM can't know whether or TDX is
actually supported until the TDX module is fully loaded and configured.  KVM waits
until VM creation to enable VMX, but that's pure enabling and more or less
guaranteed to succeed, e.g. will succeed barring hardware failures, software bugs,
or *severe* memory pressure.

There are also latency and noisy neighbor concerns, e.g. we *really* don't want
to end up in a situation where creating a TDX guest for a customer can observe
arbitrary latency *and* potentially be disruptive to VMs already running on the
host.

Userspace can workaround the second and third issues by spawning a dummy TDX guest
as early as possible, but that adds complexity to userspace, especially if there's
any desire for it to be race free, e.g. with respect to reporting system capabilities
to the control plan.

On the flip side, limited hardware availability (unless Intel has changed its
tune) and the amount of enabling that's required in BIOS and whatnot makes it
highly unlikely that random Linux users are going to unknowingly boot with TDX
enabled.

That said, if this is a sticking point, let's just make enable_tdx off by default,
i.e. force userspace to opt-in.  Deployments that *know* they may want to schedule
TDX VMs on the host can simply force the module param.  And for everyone else,
since KVM is typically configured as a module by distros, KVM can be unloaded and
reload if the user realizes they want TDX well after the system is up and running.

> The KVM maintainers prefer the initialization on kvm_intel.ko loading time. [1]

You can say "Sean", I'm not the bogeyman :-)

> I can change enable_tdx parameter for kvm_intel.ko instead of boolean.
> Something like
> 
> enable_tdx
>         ondemand: on-demand initialization when creating the first TDX guest
>         onload:   initialize TDX module when loading kvm_intel.ko

No, that's the most complex path and makes no one happy.

>         disable:  disable TDX support
