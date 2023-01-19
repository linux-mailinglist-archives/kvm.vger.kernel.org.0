Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29AE674682
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 23:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjASW7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 17:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjASW7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 17:59:08 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2E9A45E0;
        Thu, 19 Jan 2023 14:45:51 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id v6so1950705ilq.3;
        Thu, 19 Jan 2023 14:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jd8DvczjAgkaoJ2/VgnefBfGOX7aqFYYlHr6EdELZ2k=;
        b=QKeQBM9+VvaJ3ZgipoPQIFxNCvYPJmxpltzYP3ttSo6o2FkSzNYB7xzR1AO+qkQR32
         wuHgqWJK5NP5nTb0KNJbPwZP/6qrSRWPm7kj8EYYJhvvGVkBMwxGu74VmCwuTnFCHoXd
         bac0EXTAn4Azcc6ENzfNog5VU6tz7rqALCouT0uHCS2fGIa1QObS9Rt2owaZ8ZtZ0IEi
         PJA/1Ve20whxneSCuPvQkq2SSkIZYTX+Zm0yVScRbpUlZzcF6ucNrWGZHfLPXhBOT8/c
         V96LY6YaPiYCBwzab2TJYS5KZxNAHQoy4/WmZrm3AgrY6HlUqtIQGD2qUApBNWcX1C0+
         laHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jd8DvczjAgkaoJ2/VgnefBfGOX7aqFYYlHr6EdELZ2k=;
        b=bfIeISSvnGto2ba90aCydPi/hbjJJJ1aeW9XlJ4PA+pmhN2dvxcD+FXndDrvAYfgJM
         frv6jcLM0/kKlengd05ieUIvXwXnyMZ1Dk3XyAxTwGo2edt4AOWTh7wQnUaoOrQxmgAP
         +S74yOnxXFb0sncFocG1jb2ASZODac6++XHzkiuAFe5R3WtmxhkSri4B1D3dQHEZsdD+
         Vg9vt7cHCLslORlKlCnTqCKW+mB16L1O9Oz/FtAuLbOnlNYnrggRzwK1bLPTjer4ZiDk
         ab8Pu+WqlO7VdxbikHNPathC5Q7BtNIdG5ZK5EXt+li8zVIUKFu5MK62f8SUIqKlw3Pq
         LP/g==
X-Gm-Message-State: AFqh2ko1FtCW7w5rDQ3MZCZvqYckmQzGThHUuj5w5M2bXDj6L3NSGQKU
        06nMmnDIWxtMtCGQnK6pmZ0=
X-Google-Smtp-Source: AMrXdXvYTQSFLiwoxfPR4C8ddUgxEC/p229Ds5rfrm9CRJ9mBbGO4xv3Q8k47kZ5eG4scZWKpHgKVg==
X-Received: by 2002:a92:c5d1:0:b0:30d:9eea:e51 with SMTP id s17-20020a92c5d1000000b0030d9eea0e51mr1941414ilt.1.1674168350372;
        Thu, 19 Jan 2023 14:45:50 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id x14-20020a92d64e000000b003024928a9afsm11079999ilp.83.2023.01.19.14.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 14:45:50 -0800 (PST)
Date:   Fri, 20 Jan 2023 00:45:44 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Message-ID: <20230120004544.00003c50@gmail.com>
In-Reply-To: <Y8cLcY12zDWqO8nd@google.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
        <68fa413e61d7471657174bc7c83bde5c842e251f.1673539699.git.isaku.yamahata@intel.com>
        <20230113151258.00006a6d@gmail.com>
        <Y8F1uPsW56fVdhmC@google.com>
        <20230114111621.00001840@gmail.com>
        <Y8bFCb+rs25dKcMY@google.com>
        <20230117214414.00003229@gmail.com>
        <Y8cLcY12zDWqO8nd@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Jan 2023 20:56:17 +0000
Sean Christopherson <seanjc@google.com> wrote:

> On Tue, Jan 17, 2023, Zhi Wang wrote:
> > On Tue, 17 Jan 2023 15:55:53 +0000
> > Sean Christopherson <seanjc@google.com> wrote:
> > 
> > > On Sat, Jan 14, 2023, Zhi Wang wrote:
> > > > On Fri, 13 Jan 2023 15:16:08 +0000 > Sean Christopherson <seanjc@google.com> wrote:
> > > > 
> > > > > On Fri, Jan 13, 2023, Zhi Wang wrote:
> > > > > > Better add a FIXME: here as this has to be fixed later.
> > > > > 
> > > > > No, leaking the page is all KVM can reasonably do here.  An improved
> > > > > comment would be helpful, but no code change is required.
> > > > > tdx_reclaim_page() returns an error if and only if there's an
> > > > > unexpected, fatal error, e.g. a SEAMCALL with bad params, incorrect
> > > > > concurrency in KVM, a TDX Module bug, etc.  Retrying at a later point is
> > > > > highly unlikely to be successful.
> > > > 
> > > > Hi:
> > > > 
> > > > The word "leaking" sounds like a situation left unhandled temporarily.
> > > > 
> > > > I checked the source code of the TDX module[1] for the possible reason to
> > > > fail when reviewing this patch:
> > > > 
> > > > tdx-module-v1.0.01.01.zip\src\vmm_dispatcher\api_calls\tdh_phymem_page_reclaim.c
> > > > tdx-module-v1.0.01.01.zip\src\vmm_dispatcher\api_calls\tdh_phymem_page_wbinvd.c
> > > > 
> > > > a. Invalid parameters. For example, page is not aligned, PA HKID is not zero...
> > > > 
> > > > For invalid parameters, a WARN_ON_ONCE() + return value is good enough as
> > > > that is how kernel handles similar situations. The caller takes the
> > > > responsibility.
> > > >  
> > > > b. Locks has been taken in TDX module. TDR page has been locked due to another
> > > > SEAMCALL, another SEAMCALL is doing PAMT walk and holding PAMT lock... 
> > > > 
> > > > This needs to be improved later either by retry or taking tdx_lock to avoid
> > > > TDX module fails on this.
> > > 
> > > No, tdx_reclaim_page() already retries TDH.PHYMEM.PAGE.RECLAIM if the target page
> > > is contended (though I'd question the validity of even that), and TDH.PHYMEM.PAGE.WBINVD
> > > is performed only when reclaiming the TDR.  If there's contention when reclaiming
> > > the TDR, then KVM effectively has a use-after-free bug, i.e. leaking the page is
> > > the least of our worries.
> > > 
> > 
> > Hi:
> > 
> > Thanks for the reply. "Leaking" is the consquence of even failing in retry. I
> > agree with this. But I was questioning if "retry" is really a correct and only
> > solution when encountering lock contention in the TDX module as I saw that there
> > are quite some magic numbers are going to be introduced because of "retry" and
> > there were discussions about times of retry should be 3 or 1000 in TDX guest
> > on hyper-V patches. It doesn't sound right.
> 
> Ah, yeah, I'm speaking only with respect to leaking pages on failure in this
> specific scenario.
> 
> > Compare to an typical *kernel lock* case, an execution path can wait on a
> > waitqueue and later will be woken up. We usually do contention-wait-and-retry
> > and we rarely just do contention and retry X times. In TDX case, I understand
> > that it is hard for the TDX module to provide similar solutions as an execution
> > path can't stay long in the TDX module.
> 
> Let me preface the below comments by saying that this is the first time that I've
> seen the "Single-Step and Zero-Step Attacks Mitigation Mechanisms" behavior, i.e.
> the first time I've been made aware that the TDX Module can apparently decide
> to take S-EPT locks in the VM-Enter path.
> 
> > 
> > 1) We can always take tdx_lock (linux kernel lock) when calling a SEAMCALL
> > that touch the TDX internal locks. But the downside is we might lose some
> > concurrency.
> 
> This isn't really feasible in practice.  Even if tdx_lock were made a spinlock
> (it's currently a mutex) so that it could it could be taken inside kvm->mmu_lock,
> acquiring a per-VM lock, let alone a global lock, in KVM's page fault handling
> path is not an option.  KVM has a hard requirement these days of being able to
> handle multiple page faults in parallel.
> 
> > 2) As TDX module doesn't provide contention-and-wait, I guess the following
> > approach might have been discussed when designing this "retry".
> > 
> > KERNEL                          TDX MODULE
> > 
> > SEAMCALL A   ->                 PATH A: Taking locks
> > 
> > SEAMCALL B   ->                 PATH B: Contention on a lock
> > 
> >              <-                 Return "operand busy"
> > 
> > SEAMCALL B   -|
> >               |  <- Wait on a kernel waitqueue
> > SEAMCALL B  <-|
> > 
> > SEAMCALL A   <-                 PATH A: Return
> > 
> > SEAMCALL A   -|
> >               |  <- Wake up the waitqueue
> > SEMACALL A  <-| 
> > 
> > SEAMCALL B  ->                  PATH B: Taking the locks
> > ...
> > 
> > Why not this scheme wasn't chosen?
> 
> AFAIK, I don't think a waitqueue approach as ever been discussed publicly.  Intel
> may have considered the idea internally, but I don't recall anything being proposed
> publically (though it's entirely possible I just missed the discussion).
> 
> Anways, I don't think a waitqueue would be a good fit, at least not for S-EPT
> management, which AFAICT is the only scenario where KVM does the arbitrary "retry
> X times and hope things work".  If the contention occurs due to the TDX Module
> taking an S-EPT lock in VM-Enter, then KVM won't get a chance to do the "Wake up
> the waitqueue" action until the next VM-Exit, which IIUC is well after the TDX
> Module drops the S-EPT lock.  In other words, immediately retrying and then punting
> the problem further up the stack in KVM does seem to be the least awful "solution"
> if there's contention.
>

I should put both "waitqueue or spin" in the chart above to prevent misunderstanding.

I agree that S-EPT should be thought and treated differently than others as
any lock change on that path can affect the parallelization and performance. There are
many internal locks for protecting private data structures inside the security
firmware, like locks for TDR, TDCS, TDVPS. PAMT(mostly SEPT-related). Any contention
on these might result in a BUSY.

What I would like to clarify is: it would be better to have a mechanism to make sure a
SEAMCALL can succeed at a certain point (or at least trying to succeed) as the 
magic number would work like a lottery in reality. E.g. the CPU doing retry is running
at a higher freq than the CPU running the execution path which took the TDX inner
locks due to different P states. The retry loop might end much earlier than expectation.
Not even say when the same linux kernel binary with the same pre-determined number 
of retrying loop running on different CPU SKUs with different freqs.

We sometimes do retry in a driver to wait HW states ready is because the clock of a
device might be fixed or predictable. But I am in doubt if retrying loop works in the
case mentioned above.

It still likes a temporary workaround to me and I think we should be quite
careful of it.

> That said, I 100% agree that the arbitrary retry stuff is awful.  The zero-step
> interaction in particular isn't acceptable.
> 
> Intel folks, encountering "TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT" on VM-Enter
> needs to be treated as a KVM bug, even if it means teaching KVM to kill the VM
> if a vCPU is on the cusp of triggerring the "pre-determined number" of EPT faults
> mentioned in this snippet:
> 
>   After a pre-determined number of such EPT violations occur on the same instruction,
>   the TDX module starts tracking the GPAs that caused Secure EPT faults and fails
>   further host VMM attempts to enter the TD VCPU unless previously faulting private
>   GPAs are properly mapped in the Secure EPT.
> 
> If the "pre-determined number" is too low to avoid false positives, e.g. if it can
> be tripped by a vCPU spinning while a different vCPU finishes handling a fault,
> then either the behavior of the TDX Module needs to be revisited, or KVM needs to
> stall vCPUs that are approaching the threshold until all outstanding S-EPT faults
> have been serviced.
>

That sharply hits the point. Let's keep this in mind and start from here.

I also saw the AMD SEV-SNP host patches had retry times like (2 * cpu cores).
But I haven't seen any explanation in the code and comment yet, like how it
supposes to be able to work in reality. Would ask this question in the patch
review. I start to feel this seems a common problem that needs to be sorted.

> KVM shouldn't be spuriously zapping private S-EPT entries since the backing memory
> is pinned, which means the only way for a vCPU to truly get stuck faulting on a
> single instruction is if userspace is broken/malicious, in which case userspace
> gets to keep the pieces.

