Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6701EEC7B
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 22:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbgFDUyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 16:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730102AbgFDUyW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 16:54:22 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25606C08C5C0
        for <kvm@vger.kernel.org>; Thu,  4 Jun 2020 13:54:21 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id b5so7473430iln.5
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 13:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZKBf+/aAnIUAhu9efRbyqkKtVoY00YPeZOHPjPmkDUg=;
        b=EXUGIsMpLq8D6GPhFSNjGxyNjmzEW+X5h5BClBRA+wde+3vdGOKrPiiKhLKpALSbKY
         BIpW5abVqFGiWmqRwPI+r/0GYTqrHTmyFwVw+/iG6gsVyFaytrCfJv1H0ckslBp/ql6X
         8c57Xb7v1+x66Ro0pbj62wq4vYxdBSUfTomxTStXzuloJQT9gjKcVyGewlXf0HybjFwe
         Pws+ydXXqUzExwLwhQ+Qnto6duzAOijG6+9Z+QrQJTe0kS1h1lGU0brhwsKvkbBO7vve
         ruMpP+cxyHHd0JRUTGEN3rEGTN4JkLCXTQTQFEu2weyZST4kk++gohlfpsr+0WMJZYo+
         A5Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZKBf+/aAnIUAhu9efRbyqkKtVoY00YPeZOHPjPmkDUg=;
        b=HCwpdK3LOKM21ycoUUOq4xBVlXGHPe+U2msHLNT477LxhMhnLoCsRGqNyYUUJAfExd
         zHktllGs6BhWMCA1tJVaUHqeQNtjGqGYcz5JX35CiCrdpr8lPCOCkZB2LfgHE+Dte578
         4u8mqLe2v30KMB6hei/RitodUWCBykNiCZve+UV1AS9ykNRV58mG/EZZVhwJooT1Okol
         6PZMyQSL2aYrzKC7mcVN5mmlQ50b/hwRhpnsRhaEIRARH4SSwtddzdsTxObE2FqQvfXS
         WW4o/+uNUAuEX3WK8IRc1bLCh+WMLKjeEetbLzjghuQn2JBsOP8vqa6vbYBQeXqwUSFl
         kj+w==
X-Gm-Message-State: AOAM5320Gbujhed5BVU2O16suRUoaG4v+zVfbigGNNaFNv2C23+r2411
        RrDtG0Ykp3Vdt/dfDzefNVh2p8bJ7KoEMGDU4gZcuA==
X-Google-Smtp-Source: ABdhPJxAll0OJ1/wMBDM6dQwfd3L2h7ZvXs8GHFGKi1xbeeodP385HcTEOp5gg/32CUyhzprg8JKpbn1NqX/MPasBRo=
X-Received: by 2002:a92:bacb:: with SMTP id t72mr5906929ill.26.1591304060394;
 Thu, 04 Jun 2020 13:54:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200601222416.71303-1-jmattson@google.com> <20200601222416.71303-4-jmattson@google.com>
 <20200602012139.GF21661@linux.intel.com> <CALMp9eS3XEVdZ-_pRsevOiKRBSbCr96saicxC+stPfUqsM1u1A@mail.gmail.com>
 <20200603022414.GA24364@linux.intel.com> <CALMp9eSth924epmxS8-mMXopGMFfR_JK7Hm8tQXyeqGF3ebxcg@mail.gmail.com>
 <20200604184656.GD30456@linux.intel.com> <CALMp9eR3c3wQ4YrP7O0UwP=B95XR_-rEpbjet1AgKVMYNEWskA@mail.gmail.com>
 <20200604192622.GE30456@linux.intel.com>
In-Reply-To: <20200604192622.GE30456@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 4 Jun 2020 13:54:08 -0700
Message-ID: <CALMp9eTwExWy9f14D-P0jCfoXynk1BBL705wk4-UiBNcufAJSg@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] kvm: vmx: Add last_cpu to struct vcpu_vmx
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 4, 2020 at 12:26 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Jun 04, 2020 at 12:00:33PM -0700, Jim Mattson wrote:
> > On Thu, Jun 4, 2020 at 11:47 AM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Wed, Jun 03, 2020 at 01:18:31PM -0700, Jim Mattson wrote:
> > > > On Tue, Jun 2, 2020 at 7:24 PM Sean Christopherson
> > > > <sean.j.christopherson@intel.com> wrote:
> > > > > As an alternative to storing the last run/attempted CPU, what about moving
> > > > > the "bad VM-Exit" detection into handle_exit_irqoff, or maybe a new hook
> > > > > that is called after IRQs are enabled but before preemption is enabled, e.g.
> > > > > detect_bad_exit or something?  All of the paths in patch 4/4 can easily be
> > > > > moved out of handle_exit.  VMX would require a little bit of refacotring for
> > > > > it's "no handler" check, but that should be minor.
> > > >
> > > > Given the alternatives, I'm willing to compromise my principles wrt
> > > > emulation_required. :-) I'll send out v4 soon.
> > >
> > > What do you dislike about the alternative approach?
> >
> > Mainly, I wanted to stash this in a common location so that I could
> > print it out in our local version of dump_vmcs(). Ideally, we'd like
> > to be able to identify the bad part(s) just from the kernel logs.
>
> But this would also move dump_vmcs() to before preemption is enabled, i.e.
> your version could read the CPU directly.

If it backports easily. The bigger the change, the less likely that is.

> And actually, if we're talking about ferreting out hardware issues, you
> really do want this happening before preemption is enabled so that the VMCS
> dump comes from the failing CPU.  If the vCPU is migrated, the VMCS will be
> dumped after a VMCLEAR->VMPTRLD, i.e. will be written to memory and pulled
> back into the VMCS cache on a different CPU, and will also have been written
> to by the new CPU to update host state.  Odds are that wouldn't affect the
> dump in a meaningful way, but never say never.

True.

> Tangentially related, what about adding an option to do VMCLEAR at the end
> of dump_vmcs(), followed by a dump of raw memory?  It'd be useless for
> debugging software issues, but might be potentially useful/interesting for
> triaging hardware problems.

Our dump_vmcs() dumps all vmreadable fields, which should be pretty
close to what we can get from a raw memory dump. We do have additional
instrumentation to aid in determining the layout of the VMCS in
memory, but it is too stupid to figure out how access rights are
stored. Maybe it could be beefed up a little, and we could at least
verify that VMCLEAR dumps the same thing to physical memory that we
get from the individual VMREADs.

> > That, and I wouldn't have been as comfortable with the refactoring
> > without a lot more testing.
