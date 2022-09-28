Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4F15ED3DD
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 06:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbiI1EYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 00:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiI1EYP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 00:24:15 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7B21F0CCC
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 21:24:14 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id cv6so1345370pjb.5
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 21:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=84y5cVFPqn7JdmKlB0INiH26jqZn3FwsuFj1nkhevE0=;
        b=leb1DMlrdBQlXituY1fllABDc1rX2Y/sfj5EjhSd00SHDHjY5TrDzEGj+vKXQmmONs
         /xdw+DFqbet7/tgeJWT7Wf81yXRJkVgXTFjIBPgI0ZWU+0t3w8H+c5ReVPeXVur5oWFM
         qjTMbUzJN0dl1dexQVQ/BS5ADe3iPO7v2sXw16iby8v0YuMsTQDBY51CVwTl2sTg/Ww6
         POyz1gvu3l4/31WwpFY/47fP3kmynWQYWaRB5QvAatYQ6kD8f7Eu0KVs1v8FPEEOCNFU
         tjXv0EGR4KHOUkPX86yeDOeFBXLQVtWeFdVMyeW9omz70tnYH9hLS3GQY4b5wlnpUFOZ
         hMBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=84y5cVFPqn7JdmKlB0INiH26jqZn3FwsuFj1nkhevE0=;
        b=eNUElgcpaZ2SfkgfPzGt2mZKvcRESpM1wjwrtl51n1tAxiLRxJqDQPt92L0OyXLBdL
         a6Y0LYUuGeTld6MRWcCFRTO46+lJrowYAN41h2wEjGK0f2SWBCKF3JqBcQ7D211hC9Dq
         LuxBJk9x2UTSBKAP3r/DMI67pfzuZAlgTSQ096MJxYLojDQrIJix06uJCQLF6PG1QM5m
         F6I19prTmJKAy9XxIoZbLmAGPXgjCRMMuNkyJQSZkVJT07CTrfxq05o1dX74xkbQ6FqC
         gRu3hIzM1KP6ckO5IRtvb3gWqj7y5iUSseT/0ryHVwlGcjKJ8sjnHTLQTLHRZY2TJCWd
         w3TA==
X-Gm-Message-State: ACrzQf3RfeQySFpN6ePW/IiagmNYvVYKOkjr+woH5nCsvLtkCJE3Sd6v
        mUS3I6RLfb+aTjzbiSPNSwH8lQ==
X-Google-Smtp-Source: AMsMyM6O7dOJoGrGACvEl/k7n7NYRr028Nsgp4sVYpO6c9B/6uiJJ83uMjNC1TjMMFAEKfz6blk6Rw==
X-Received: by 2002:a17:902:e807:b0:179:fc64:7288 with SMTP id u7-20020a170902e80700b00179fc647288mr3586121plg.137.1664339053509;
        Tue, 27 Sep 2022 21:24:13 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090a2b4f00b002005fcd2cb4sm412541pjc.2.2022.09.27.21.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 21:24:12 -0700 (PDT)
Date:   Tue, 27 Sep 2022 21:24:08 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v8 10/14] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YzPMaEPBtaXguJaT@google.com>
References: <20220922031857.2588688-1-ricarkol@google.com>
 <20220922031857.2588688-11-ricarkol@google.com>
 <Yyy4WjEmuSH1tSZb@google.com>
 <YzHfwmZqMQ9xXaNa@google.com>
 <YzNz36gZqrse9GzT@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzNz36gZqrse9GzT@google.com>
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

On Tue, Sep 27, 2022 at 10:06:23PM +0000, Sean Christopherson wrote:
> On Mon, Sep 26, 2022, Ricardo Koller wrote:
> > On Thu, Sep 22, 2022 at 07:32:42PM +0000, Sean Christopherson wrote:
> > > On Thu, Sep 22, 2022, Ricardo Koller wrote:
> > > > +	void *hva = (void *)region->region.userspace_addr;
> > > > +	uint64_t paging_size = region->region.memory_size;
> > > > +	int ret, fd = region->fd;
> > > > +
> > > > +	if (fd != -1) {
> > > > +		ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> > > > +				0, paging_size);
> > > > +		TEST_ASSERT(ret == 0, "fallocate failed, errno: %d\n", errno);
> > > > +	} else {
> > > > +		if (is_backing_src_hugetlb(region->backing_src_type))
> > > > +			return false;
> > > 
> > > Why is hugetlb disallowed?  I thought anon hugetlb supports MADV_DONTNEED?
> > > 
> > 
> > It fails with EINVAL (only tried on arm) for both the PAGE_SIZE and the huge
> > page size. And note that the address is aligned as well.
> > 
> > madvise(0xffffb7c00000, 2097152, MADV_DONTNEED) = -1 EINVAL (Invalid argument)
> > 	^^^^^^^^^^^^^^	^^^^^^^
> > 	2M aligned	2M (hugepage size)
> > 			
> > madvise(0xffff9e800000, 4096, MADV_DONTNEED) = -1 EINVAL (Invalid argument)   
> > 			^^^^
> > 			PAGE_SIZE
> 
> I think this needs to be root caused before merging.  Unless I'm getting turned
> around, MADV_DONTEED should work, i.e. there is a test bug lurking somewhere.

Turns out that the failure is documented. Found this in the madvise manpage:

  MADV_DONTNEED cannot be applied to locked pages, Huge TLB pages, or VM_PFNMAP pages.

Was also playing with the following non-selftest program (before checking the
manpage, and I now remember that I actually read the above sentence before).

This fails on both x86 and arm:

	#include <stdio.h>
	#include <stddef.h>
	#include <sys/mman.h>
	#include <linux/mman.h>
	#include <assert.h>

	#define SZ_2M (1 << 21)

	int main()
	{
		void *p = mmap(NULL, SZ_2M, PROT_READ | PROT_WRITE,
			       MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_HUGE_2MB,
			       -1, 0);
		assert(p != MAP_FAILED);
		assert(madvise(p, 4096, MADV_DONTNEED) == 0); // this fails
		assert(madvise(p, SZ_2M, MADV_DONTNEED) == 0); // this fails
	}

And for completeness, this passes on both:

	int main()
	{
		void *p = mmap(NULL, SZ_2M, PROT_READ | PROT_WRITE,
			       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
		assert(p != MAP_FAILED);
		assert(madvise(p, SZ_2M, MADV_DONTNEED) == 0);
	}
