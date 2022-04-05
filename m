Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF06A4F2139
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 06:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiDECxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 22:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiDECt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 22:49:57 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C61629BF53
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 18:56:34 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id fu5so4734583pjb.1
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 18:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JSEiQNEgLzNehCj2N1qkt1yiYw63ndtI615+rA0Q68c=;
        b=doQ/goBnkxA1rXnSX2lWlFdMlYnisYl+4a64cEDjt4d8YzNnz8CAWfKyRO0k2UDWp3
         eimyFaHqy7RuD7uW+YKCg2D+tO9Urj2A1PqgtVbm+Nnd9lmCdJK2nHV3zC6g8wchg0po
         EaoEmtaomW1JjS8xcC5rJyu+4I136n2Px9Jom3i/eLDvWco4n6m5dAB5IAe22At3nmK1
         mt2rgfwkjjsgBGE1NmLrXLgwmlY28a6pBfzPkXCAMVa/Ox5RfM/bvd/fRmUBUzn9Rptt
         F5jB8iCuuCnuqn7Ks8MwKPmoJ4v0SfQSKO8NsSLDMrWn2qw3tn5CrrOlmB4WQ2BDH1Jy
         L+7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JSEiQNEgLzNehCj2N1qkt1yiYw63ndtI615+rA0Q68c=;
        b=A2Zn9ddAqnhSlWDx5x68l4y+KljYcQBbQcWOz6HZ0MwvUHv6ZIxq1dUBC5tmSQzcPn
         HKaZlzrUg7FyMhiOjcft1dOp0Gjd1SUOXsa7s6+a1I/bimgunTvASAneG7kBwsEh0vOm
         2b4qOwcSF+kadtllEnqS+o9ivQlYc/RQjbj2qfOjYEYsH5zs2njgYgF7Y8O6X6fXIyqA
         bvgScvcUl/+6eTHaaucyqzVfaW+rG6EpGdjQ1eZlDys9aTpJ1MuXvaSi0DngcOt7dZrl
         3yNMy1SLTevsxYrSlCgZl8PzySuxWeaiC7P8ysgIXm1ZDUT9AnvS4ey2Kmia83+/Crzx
         9Hgg==
X-Gm-Message-State: AOAM531SQt7+8VxwjE43nQqRSrGovwDzEdcxrHP12wRBzBM2cYWGjxoc
        TTY3WpxWIzbhobG2G6tk9iIu8g==
X-Google-Smtp-Source: ABdhPJyYa3VBrowXUAjAkU9zJ0ErXJB1Zdb8TUzr4UXplkvPF68iJEuVxlpzwhQwo7HJQlI/66koCQ==
X-Received: by 2002:a17:902:a9c7:b0:156:8951:651d with SMTP id b7-20020a170902a9c700b001568951651dmr1117931plr.79.1649123793565;
        Mon, 04 Apr 2022 18:56:33 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id f21-20020a056a00239500b004fb02a7a45bsm13475625pfc.214.2022.04.04.18.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 18:56:32 -0700 (PDT)
Date:   Mon, 4 Apr 2022 18:56:29 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, reijiw@google.com,
        rananta@google.com
Subject: Re: [PATCH v4 2/4] KVM: selftests: add is_cpu_eligible_to_run()
 utility function
Message-ID: <YkuhzRAiyt+M8RLi@google.com>
References: <20220404214642.3201659-1-ricarkol@google.com>
 <20220404214642.3201659-3-ricarkol@google.com>
 <YkuJrYL6wL5P5JY/@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkuJrYL6wL5P5JY/@google.com>
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

On Tue, Apr 05, 2022 at 12:13:33AM +0000, Oliver Upton wrote:
> Hi Ricardo,
> 
> On Mon, Apr 04, 2022 at 02:46:40PM -0700, Ricardo Koller wrote:
> > Add is_cpu_eligible_to_run() utility function, which checks whether the current
> > process, or one of its threads, is eligible to run on a particular CPU.
> > This information is obtained using sched_getaffinity.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  .../testing/selftests/kvm/include/test_util.h |  2 ++
> >  tools/testing/selftests/kvm/lib/test_util.c   | 20 ++++++++++++++++++-
> >  2 files changed, 21 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> > index 99e0dcdc923f..a7653f369b6c 100644
> > --- a/tools/testing/selftests/kvm/include/test_util.h
> > +++ b/tools/testing/selftests/kvm/include/test_util.h
> > @@ -143,4 +143,6 @@ static inline void *align_ptr_up(void *x, size_t size)
> >  	return (void *)align_up((unsigned long)x, size);
> >  }
> >  
> > +bool is_cpu_eligible_to_run(int pcpu);
> > +
> >  #endif /* SELFTEST_KVM_TEST_UTIL_H */
> > diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> > index 6d23878bbfe1..7813a68333c0 100644
> > --- a/tools/testing/selftests/kvm/lib/test_util.c
> > +++ b/tools/testing/selftests/kvm/lib/test_util.c
> > @@ -4,6 +4,7 @@
> >   *
> >   * Copyright (C) 2020, Google LLC.
> >   */
> > +#define _GNU_SOURCE
> >  
> >  #include <assert.h>
> >  #include <ctype.h>
> > @@ -13,7 +14,9 @@
> >  #include <sys/stat.h>
> >  #include <sys/syscall.h>
> >  #include <linux/mman.h>
> > -#include "linux/kernel.h"
> > +#include <linux/kernel.h>
> > +#include <sched.h>
> > +#include <sys/sysinfo.h>
> >  
> >  #include "test_util.h"
> >  
> > @@ -334,3 +337,18 @@ long get_run_delay(void)
> >  
> >  	return val[1];
> >  }
> > +
> > +bool is_cpu_eligible_to_run(int pcpu)
> > +{
> > +	cpu_set_t cpuset;
> > +	long i, nprocs;
> > +
> > +	nprocs = get_nprocs_conf();
> > +	sched_getaffinity(0, sizeof(cpu_set_t), &cpuset);
> > +	for (i = 0; i < nprocs; i++) {
> > +		if (i == pcpu)
> > +			return CPU_ISSET(i, &cpuset);
> > +	}
> 
> I don't think you need the loop and can just do CPU_ISSET(pcpu, &cpuset),
> right?

Oops, definitely not. Thanks for catching this.

> 
> --
> Thanks,
> Oliver
