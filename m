Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1706FF9BF
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 21:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238791AbjEKTF3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 15:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238860AbjEKTFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 15:05:18 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E9E558B
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 12:05:15 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-24deb9c5ffcso6193157a91.1
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 12:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683831915; x=1686423915;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1AHYztrTrdrP2LKi0Oh+rd9f71cGlR+Ef1fGy0XiIjw=;
        b=kbHT8nP05t6Xc3HWWOeEWRriN9YhfW5Fop8uOs7TVIP6Tjy6QnaiaOm4ZgBH4x/fXA
         4aC1hdGrEEiu23cr9B6fRgvhP8CMWO93PpqJSDFYNpp0byqOQb+xbAPAniytIbFEuuNI
         t1ScH3UciARY3DTL6B6vLnLh8Uz16Jpck7Y+MVbnHn0iTtaYn17OifJMbUaqTOl/sedy
         rPgcc4PQXqURK7kUF9dhTeGgZZFRfIzg0A88Urt7xKbNSHu+MsS5PAm/MenIxvovubWF
         8TYyDmIFL4USlyFWamC0x0BHukC3cYejaNIdvluQ7IxSX8IwAbhvHp9cDcevsx+jr9ix
         O1qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683831915; x=1686423915;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1AHYztrTrdrP2LKi0Oh+rd9f71cGlR+Ef1fGy0XiIjw=;
        b=df0DioEzqUse/7J6DtRnzyIfrO8A78bKGLC89i7FNqfVsRprHXbD+2dmEfvsGLdyuL
         pmRVBwc5oWfiJjcKqReSf/E3K5aBEdPbbykcHo3Kt69PIMViTPCycfbPpuG5fh9qcr8N
         EiU17NaJdy1JhAWgxGfFglPJ+8eTwft8kVTPO/A6gfm5bm7tcwlDioGtoE9MwQjqDGGf
         EpVcFyTNyAebKynHPE5tgVLnUu9UU9lGmetORrs4aPsTuRcGLBooT9SE9fZl7i5g6New
         mvzyFYkpOu7rNYgcs5EEVjfL31kmBUqgx/iUrJJe27zoEME7BfwXtMlSsf6IL8/Il2ae
         Ct1g==
X-Gm-Message-State: AC+VfDzYZCjP8FZgvtJhEDnzk+cmoob+WxCZLvG7svqvnWV0BEnigEBM
        hewSmLq3fusz/817D5P0v/Fz4Q==
X-Google-Smtp-Source: ACHHUZ6At4KXZSRJXuW0GhpJxg285yKYv6CR6j9CvsvQOtNpZzh9R0QoABlG7JoWUbhPF//QtvQtfw==
X-Received: by 2002:a17:90a:404b:b0:24e:3b85:a8a with SMTP id k11-20020a17090a404b00b0024e3b850a8amr22043515pjg.8.1683831914599;
        Thu, 11 May 2023 12:05:14 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id t3-20020a17090a024300b0024499d4b72esm16211158pje.51.2023.05.11.12.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 12:05:14 -0700 (PDT)
Date:   Thu, 11 May 2023 12:05:10 -0700
From:   David Matlack <dmatlack@google.com>
To:     Axel Rasmussen <axelrasmussen@google.com>
Cc:     Peter Xu <peterx@redhat.com>, Anish Moorthy <amoorthy@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
        bgardon@google.com, ricarkol@google.com, kvm <kvm@vger.kernel.org>,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZF08Zg90emoDJJIp@google.com>
References: <ZFLRpEV09lrpJqua@x1n>
 <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n>
 <ZFQC5TZ9tVSvxFWt@x1n>
 <CAF7b7mrTGL8rLVCmsmX4dZinZHRFFB7R7kX0Wv9FZR-B-4xhhw@mail.gmail.com>
 <ZFhO9dlaFQRwaPFa@x1n>
 <CAF7b7mqPdfbzj6cOWPsg+Owysc-SOTF+6UUymd9f0Mctag=8DQ@mail.gmail.com>
 <ZFwRuCuYYMtuUFFA@x1n>
 <CALzav=e29rRw4TTRGpTkazgJpU1zPML3zQGoyeHj9Zbkq+yAdQ@mail.gmail.com>
 <CAJHvVci4VuQ_vdpRKczg4ic6x7eZRXE4+ZUvzO-xU_9VJ1Vqvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHvVci4VuQ_vdpRKczg4ic6x7eZRXE4+ZUvzO-xU_9VJ1Vqvg@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023 at 10:33:24AM -0700, Axel Rasmussen wrote:
> On Thu, May 11, 2023 at 10:18 AM David Matlack <dmatlack@google.com> wrote:
> >
> > On Wed, May 10, 2023 at 2:50 PM Peter Xu <peterx@redhat.com> wrote:
> > > On Tue, May 09, 2023 at 01:52:05PM -0700, Anish Moorthy wrote:
> > > > On Sun, May 7, 2023 at 6:23 PM Peter Xu <peterx@redhat.com> wrote:
> > >
> > > What I wanted to do is to understand whether there's still chance to
> > > provide a generic solution.  I don't know why you have had a bunch of pmu
> > > stack showing in the graph, perhaps you forgot to disable some of the perf
> > > events when doing the test?  Let me know if you figure out why it happened
> > > like that (so far I didn't see), but I feel guilty to keep overloading you
> > > with such questions.
> > >
> > > The major problem I had with this series is it's definitely not a clean
> > > approach.  Say, even if you'll all rely on userapp you'll still need to
> > > rely on userfaultfd for kernel traps on corner cases or it just won't work.
> > > IIUC that's also the concern from Nadav.
> >
> > This is a long thread, so apologies if the following has already been discussed.
> >
> > Would per-tid userfaultfd support be a generic solution? i.e. Allow
> > userspace to create a userfaultfd that is tied to a specific task. Any
> > userfaults encountered by that task use that fd, rather than the
> > process-wide fd. I'm making the assumption here that each of these fds
> > would have independent signaling mechanisms/queues and so this would
> > solve the scaling problem.
> >
> > A VMM could use this to create 1 userfaultfd per vCPU and 1 thread per
> > vCPU for handling userfault requests. This seems like it'd have
> > roughly the same scalability characteristics as the KVM -EFAULT
> > approach.
> 
> I think this would work in principle, but it's significantly different
> from what exists today.
> 
> The splitting of userfaultfds Peter is describing is splitting up the
> HVA address space, not splitting per-thread.
> 
> I think for this design, we'd need to change UFFD registration so
> multiple UFFDs can register the same VMA, but can be filtered so they
> only receive fault events caused by some particular tid(s).
> 
> This might also incur some (small?) overhead, because in the fault
> path we now need to maintain some data structure so we can lookup
> which UFFD to notify based on a combination of the address and our
> tid. Today, since VMAs and UFFDs are 1:1 this lookup is trivial.

I was (perhaps naively) assuming the lookup would be as simple as:

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 44d1ee429eb0..e9856e2ba9ef 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -417,7 +417,10 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
         */
        mmap_assert_locked(mm);

-       ctx = vma->vm_userfaultfd_ctx.ctx;
+       if (current->userfaultfd_ctx)
+               ctx = current->userfaultfd_ctx;
+       else
+               ctx = vma->vm_userfaultfd_ctx.ctx;
        if (!ctx)
                goto out;

> 
> I think it's worth keeping in mind that a selling point of Anish's
> approach is that it's a very small change. It's plausible we can come
> up with some alternative way to scale, but it seems to me everything
> suggested so far is likely to require a lot more code, complexity, and
> effort vs. Anish's approach.

Agreed.

Mostly I think the per-thread UFFD approach would add complexity on the
userspace side of things. With Anish's approach userspace is able to
trivially re-use the vCPU thread (and it's associated pCPU if pinned) to
handle the request. That gets more complicated when juggling the extra
paired threads.

The per-thread approach would requires a new userfault UAPI change which
I think is a higher bar than the KVM UAPI change proposed here.

The per-thread approach would require KVM call into slow GUP and take
the mmap_lock before contacting userspace. I'm not 100% convinced that's
a bad thing long term (e.g. it avoids the false-positive -EFAULT exits
in Anish's proposal), but could have performance implications.

Lastly, inter-thread communication is likely slower than returning to
userspace from KVM_RUN. So the per-thread approach might increase the
end-to-end latency of demand fetches.
