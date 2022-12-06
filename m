Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02F6643A83
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 02:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbiLFBGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 20:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiLFBGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 20:06:16 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B816EB7ED
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 17:06:14 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id s196so12026988pgs.3
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 17:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sjRGBzzky7GEdbHMIaj50mNITkjhMUtLATUmInnNUXI=;
        b=ZjTFVPb7C8TuejUqaxGN306ZgZFkObjgkZ2f3XHO14MbszUbIC221sxIgY4igZa8aC
         p/ZCzaYZm0psbuBUTTXyDXT+/0o4fthyEB+eQuW6FtPp36c0l9uECEFjETRnZAKQcaLT
         NoAFop2fOTbAb/ZggUIuqEpOim8ziWpPe65DeXJjyuVLkD8c71QATXqT0mliuCwNbsMO
         9lWjndM14dWrGvF6Tga7a3blBCYQA6qOrLGX+mRXnztk8ZYs9/VBdSFoj+/hZiJBQFdS
         awy4zY2OVMl17LQwFPLbGLvFgnTB+E81ISfekjaWuqFzlOsYY87ZNReEZNx8EDfDLRaG
         PemQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sjRGBzzky7GEdbHMIaj50mNITkjhMUtLATUmInnNUXI=;
        b=ikoXWyNdp+txrkKPG120NDlGBW9c5USMUMx6gGCmQHF/IEq2Z/srPVycG3VV0cwuWp
         psIjepOynGyG8MsFf1PEABd0qJ7Gj9sjp+HKYrK6uNup6jZVrGA5+/7eJydPwJzTh43N
         SJ4yLA+qiIJSBvU7shX46ps2bsi6npI5EkvqIYAq8AVfLzbDdlak04rdod7QvHndXEPd
         pFPycMQAGdBqwZX9MX26va5i6jUsguMR7JF5ayNRTmpSMJ85TKSOsMCJ+TPGvTXeZ4yh
         wW0PLIeBH/LgHT+TejHZooery70ZtP22pHLq+bnUAiWWhfIecvUH7XpINfCV2pPt1zb+
         B75Q==
X-Gm-Message-State: ANoB5pnfvU9rE4+KEnxYgB8OF/r1jp3FAAbnlHtNEw3EMjVeqM2EdjFD
        aaUBqhgWMeidngn0j8GMVsoW4g==
X-Google-Smtp-Source: AA0mqf6kk3lrzdJqgI08MzPjoWZfxCYTogxk+SRbtpdnkGhILnApvwYkdESzZOjTKi1rpcGHPU/K5g==
X-Received: by 2002:a62:687:0:b0:56e:924e:ee22 with SMTP id 129-20020a620687000000b0056e924eee22mr67478063pfg.34.1670288773908;
        Mon, 05 Dec 2022 17:06:13 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 24-20020a630d58000000b0045751ef6423sm8708405pgn.87.2022.12.05.17.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 17:06:12 -0800 (PST)
Date:   Tue, 6 Dec 2022 01:06:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     James Houghton <jthoughton@google.com>
Cc:     David Matlack <dmatlack@google.com>, Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Linux MM <linux-mm@kvack.org>, kvm <kvm@vger.kernel.org>,
        chao.p.peng@linux.intel.com
Subject: Re: [RFC] Improving userfaultfd scalability for live migration
Message-ID: <Y46VgQRU+do50iuv@google.com>
References: <CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com>
 <Y4qgampvx4lrHDXt@google.com>
 <Y44NylxprhPn6AoN@x1n>
 <CALzav=d=N7teRvjQZ1p0fs6i9hjmH7eVppJLMh_Go4TteQqqwg@mail.gmail.com>
 <Y442dPwu2L6g8zAo@google.com>
 <CADrL8HV_8=ssHSumpQX5bVm2h2J01swdB=+at8=xLr+KtW79MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADrL8HV_8=ssHSumpQX5bVm2h2J01swdB=+at8=xLr+KtW79MQ@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 05, 2022, James Houghton wrote:
> On Mon, Dec 5, 2022 at 1:20 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Dec 05, 2022, David Matlack wrote:
> > > On Mon, Dec 5, 2022 at 7:30 AM Peter Xu <peterx@redhat.com> wrote:
> > > > > > == Getting the faulting GPA to userspace ==
> > > > > > KVM_EXIT_MEMORY_FAULT was introduced recently [1] (not yet merged),
> > > > > > and it provides the main functionality we need. We can extend it
> > > > > > easily to support our use case here, and I think we have at least two
> > > > > > options:
> > > > > > - Introduce something like KVM_CAP_MEM_FAULT_REPORTING, which causes
> > > > > > KVM_RUN to exit with exit reason KVM_EXIT_MEMORY_FAULT when it would
> > > > > > otherwise just return -EFAULT (i.e., when kvm_handle_bad_page returns
> > > > > > -EFAULT).
> > > > > > - We're already introducing a new CAP, so just tie the above behavior
> > > > > > to whether or not one of the CAPs (below) is being used.
> > > > >
> > > > > We might even be able to get away with a third option: unconditionally return
> > > > > KVM_EXIT_MEMORY_FAULT instead of -EFAULT when the error occurs when accessing
> > > > > guest memory.
> 
> Wouldn't we need a new CAP for this?

Maybe?  I did say "might" :-)  -EFAULT is sooo useless for userspace in these
cases that there's a chance we can get away with an unconditional change.  Probably
not worth the risk of breaking userspace though as KVM will likely end up with a
helper to fill in the exit info.

> > > > > diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> > > > > index 07c81ab3fd4d..7f66b56dd6e7 100644
> > > > > --- a/fs/userfaultfd.c
> > > > > +++ b/fs/userfaultfd.c
> > > > > @@ -394,7 +394,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
> > > > >          * shmem_vm_ops->fault method is invoked even during
> > > > >          * coredumping without mmap_lock and it ends up here.
> > > > >          */
> > > > > -       if (current->flags & (PF_EXITING|PF_DUMPCORE))
> > > > > +       if (current->flags & (PF_EXITING|PF_DUMPCORE|PF_NO_UFFD_WAIT))
> > > > >                 goto out;
> > > >
> > > > I'll have a closer read on the nested part, but note that this path already
> > > > has the mmap lock then it invalidates the goal if we want to avoid taking
> > > > it from the first place, or maybe we don't care?
> 
> Not taking the mmap lock would be helpful, but we still have to take
> it in UFFDIO_CONTINUE, so it's ok if we have to still take it here.

IIUC, Peter is suggesting that the kernel not even get to the point where UFFD
is involved.  The "fault" would get propagated to userspace by KVM, userspace
fixes the fault (gets the page from the source, does MADV_POPULATE_WRITE), and
resumes the vCPU.

> The main goal is to avoid the locks in the userfaultfd wait_queues. If
> we could completely avoid taking the mmap lock for reading in the
> common post-copy case, we would avoid potential latency spikes if
> someone (e.g. khugepaged) came around and grabbed the mmap lock for
> writing.
> 
> It seems pretty difficult to make UFFDIO_CONTINUE *not* take the mmap
> lock for reading, but I suppose it could be done with something like
> the per-VMA lock work [2]. If we could avoid taking the lock in
> UFFDIO_CONTINUE, then it seems plausible that we could avoid taking it
> in slow GUP too. So really whether or not we are taking the mmap lock
> (for reading) in the mem fault path isn't a huge deal by itself.

...

> > > I don't know what userspace would do in those situations to make forward progress.
> >
> > Access the page from userspace?  E.g. a "LOCK AND -1" would resolve read and write
> > faults without modifying guest memory.
> >
> > That won't work for guests backed by "restricted mem", a.k.a. UPM guests, but
> > restricted mem really should be able to prevent those types of faults in the first
> > place.  SEV guests are the one case I can think of where that approach won't work,
> > since writes will corrupt the guest.  SEV guests can likely be special cased though.
> 
> As I mentioned in the original email, I think MADV_POPULATE_WRITE
> would work here (Peter suggested this to me last week, thanks Peter!).
> It would basically call slow GUP for us. So instead of hva_to_pfn_fast
> (fails) -> hva_to_pfn_slow -> slow GUP, we do hva_to_pfn_fast (fails)
> -> exit to userspace -> MADV_POPULATE_WRITE (-> slow GUP) -> KVM_RUN
> -> hva_to_pfn_fast (succeeds).a

Ah, nice.  Missed that (obviously).
