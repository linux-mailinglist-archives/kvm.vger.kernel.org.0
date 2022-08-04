Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914E958A3F8
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 01:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240174AbiHDXl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 19:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbiHDXlz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 19:41:55 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7144F71719
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 16:41:52 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id f30so473254pfq.4
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 16:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=l+P9fpFDdOqA9j3jQqz9XotSfAmk7LMH9y8Xwuzkeq8=;
        b=hq+EXzFn/rYo+1nAn1GgoV6Fyt2EBEbLnTUDltWIJJ5Nwxy2yLZLT3zrNwEMbFSktq
         p2K538X2GPgEy58sWKbf7hsYZB95Sgg0V+20j68h2cl3yJCmVlWLalxELlz6nUoxSxGo
         DNCNxuldCYWZMF4htmpiMuTROXbgRvzLr5aP7kisco49PLjwsR1DGhityfxR6WI4n8AS
         utfQJQQ+0g4WK2ZXLYxn5OxYWkzgKCL4B2dloJ5LobCh5lGo0Dv4JIIV9CwlcC6YWtIN
         6OcR+4eYqYQHTplusmDzotDK4N/DBiQMLWkSWytDJop5FqCxfZtbHy0ScPkew/M6NyLj
         0BpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=l+P9fpFDdOqA9j3jQqz9XotSfAmk7LMH9y8Xwuzkeq8=;
        b=WjXUvTsRmExsy8XRrVUcJs/kh12ZAKzKrUfxWi5DyEDkMSSkf98ul36a/qwt3JZ+YG
         pCi9qAi4lEFthhgR6J2ju5uTaeoTUkBRZ8yHUl+RyPmszkwQDiiWdbWeTrvH5Um7rKFb
         Uj/f8/Jx01O17Uut+GSWRo6a5qIsLJfkVKysJzPmmVCUNp9hqEW3bwjwRvU5EM6aVdKS
         ecQEWuCY0PVTE7bq9QMM39vKFqcB53P8x4CrxaUN7C4mIvrjnQSgS96yPbhVhwlKHDgM
         QVMPwZy6GT5Z4KeWl2zte2s1Zrp13PLJJUzKslTiSz9itkN3Gt9rLJkbKmHpdAZ9kpiF
         /5WQ==
X-Gm-Message-State: ACgBeo0BruFx9Nvc0K0Lz6AHzNeaEWQGvJqIHirK6YUjxhLGFLKD+sGU
        trrGeWXGHKpF0xNNO9ARHEQ/Tg==
X-Google-Smtp-Source: AA6agR5uznOPI7pHa/194rH5r0Bp7QUO3TzgtsGa28w+jPwqwWzLVlv3sbXOdTF6CLvMwYMj2EuoLQ==
X-Received: by 2002:a63:698a:0:b0:41c:8dfb:29cb with SMTP id e132-20020a63698a000000b0041c8dfb29cbmr3448196pgc.170.1659656511847;
        Thu, 04 Aug 2022 16:41:51 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 13-20020a62190d000000b0052d4ffac466sm1487969pfz.188.2022.08.04.16.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 16:41:51 -0700 (PDT)
Date:   Thu, 4 Aug 2022 23:41:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     Jinrong Liang <ljr.kernel@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: kvm: Fix a compile error in
 selftests/kvm/rseq_test.c
Message-ID: <YuxZO/ktPT8ug8zT@google.com>
References: <20220802071240.84626-1-cloudliang@tencent.com>
 <20220802150830.rgzeg47enbpsucbr@kamzik>
 <CAFg_LQWB5hV9CLnavsCmsLbQCMdj1wqe-gVP7vp_mRGt+Eh+nQ@mail.gmail.com>
 <20220803142637.3y5fj2cwyvbrwect@kamzik>
 <YuqeDetNukKp9lyF@google.com>
 <20220803172627.kccwzda6eshx3vol@kamzik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803172627.kccwzda6eshx3vol@kamzik>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 03, 2022, Andrew Jones wrote:
> On Wed, Aug 03, 2022 at 04:10:53PM +0000, Sean Christopherson wrote:
> > On Wed, Aug 03, 2022, Andrew Jones wrote:
> > > On Wed, Aug 03, 2022 at 09:58:51PM +0800, Jinrong Liang wrote:
> > > > My ldd version is (GNU libc) 2.28, and I get a compilation error in this case.
> > > > But I use another ldd (Ubuntu GLIBC 2.31-0ubuntu9.2) 2.31 is compiling fine.
> > > > This shows that compilation errors may occur in different GNU libc environments.
> > > > Would it be more appropriate to use syscall for better compatibility?
> > > 
> > > OK, it's a pity, but no big deal to use syscall().
> > 
> > Ya, https://man7.org/linux/man-pages/man2/gettid.2.html says:
> > 
> >   The gettid() system call first appeared on Linux in kernel 2.4.11.  Library
> >   support was added in glibc 2.30.
> > 
> > But there are already two other instances of syscall(SYS_gettid) in KVM selftests,
> > tools/testing/selftests/kvm/lib/assert.c even adds a _gettid() wrapper.
> 
> Ha! And I found four more in selftests...
> 
> testing/selftests/powerpc/include/utils.h
> testing/selftests/proc/proc.h
> testing/selftests/rseq/param_test.c
> testing/selftests/sched/cs_prctl_test.c
> 
> and even more in tools...

Ha, and tools/testing/selftests/sched/cs_prctl_test.c even has the GLIBC crud.

#if __GLIBC_PREREQ(2, 30) == 0
#include <sys/syscall.h>
static pid_t gettid(void)
{
	return syscall(SYS_gettid);
}
#endif

> > So rather than having to remember (or discover) to use syscall(SYS_gettid), I wonder
> > if it's possible to conditionally define gettid()?  E.g. check for GLIBC version?
> > Or do
> > 
> >   #define gettid() syscall(SYS_gettid)
> > 
> > so that it's always available and simply overrides the library's gettid() if it's
> > provided?
> 
> Sounds good to me. Now the question is where to put it? kvm_util.h,
> test_util.h, or maybe we should create a new header just for stuff
> like this?

tools/include/uapi/linux/syscall.h?

Kind of dirty, but not thaaaat dirty.
