Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC235EE3F3
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 20:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbiI1SKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 14:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbiI1SKb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 14:10:31 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336C96582F
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 11:10:29 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id cp18so3975051pjb.2
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 11:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=bs5D0g2ItumdYX+ue+ZykeItEbF4U1JZ3UggoNJ4PwY=;
        b=if4oJ2uaIlB5lHRl7AMaFhWanHUi2pKzVlq8kBHrN93nEhlmd2g5rntnMaoyfdrF5m
         f6rsyEcJ16qH5u/8AYc7teYzcjN45HL9qcdW/CGiSGL4fl+bTYDnOtOTzCEcf4RHIRPo
         frWDcrNldeknW5r1vi8+diUa5uRH9nCnkJBU/gmR/Ed9m/36ou218pq/u0CvE6DpX3/8
         XhmuE9/SdGRN+gnsBFg37PEANcDy2ZgUQMgIEIF7/YrY8obzVdXbiHJUn/e/L84wAi9P
         0dKxtL7ZZxbu4erRKmgkcJCWeeoKHEHlpJbwkiPnOfRPWkofycrlgDUuCQixwIICTYkK
         fIAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=bs5D0g2ItumdYX+ue+ZykeItEbF4U1JZ3UggoNJ4PwY=;
        b=uklf3iCUguZzSScedzy3F5wYeQkRJCkwXVM1oBVcCLDd3vsX9b9as5Q6NXoTgVoZl7
         ebGu28xpuuG6X3JB7ZTifM8n7y9ddzA1m+dD9WOZPHq+1UQRn+odjFkX9Z/gO5mul5pS
         6abzocJ5WaFfLJlfKmi08GGzXxObv/GrifpKXh7ZdwainNRJsynp/bv1qqRHV0LOMaTR
         GL9u5ZEGNCV4C/uYW8aESMDm2Qk7WLfJbJquDf6nId7+a4ud5el/M77OPQAtmBq5CXUp
         8TAxMQKPo4dMmRe1WOp1B/gc2lDwwsoFD3gi4RhMgsv+3iQjLZzMXf64s60hO4UbgDh1
         H/bw==
X-Gm-Message-State: ACrzQf2FtagwQeWzNm0TJ9rJY0bH1LEcm45IPoBahOvK7rNDnu73VT99
        e1ZYNX+IxMmadhpgrbMM2UglXg==
X-Google-Smtp-Source: AMsMyM6sgEQzXow3Ue2nk5mlmhCBBzZ7H3WqSCOpv+sMEOnIornuNw1RUHnOPUTWNYIExbARkbbRsw==
X-Received: by 2002:a17:902:bd8b:b0:179:d10e:97f with SMTP id q11-20020a170902bd8b00b00179d10e097fmr1041600pls.18.1664388629063;
        Wed, 28 Sep 2022 11:10:29 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id h3-20020a628303000000b0053e8f4a10c1sm4266103pfe.217.2022.09.28.11.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 11:10:28 -0700 (PDT)
Date:   Wed, 28 Sep 2022 11:10:25 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v8 10/14] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YzSOEYBp25DKYNVa@google.com>
References: <20220922031857.2588688-1-ricarkol@google.com>
 <20220922031857.2588688-11-ricarkol@google.com>
 <Yyy4WjEmuSH1tSZb@google.com>
 <YzHfwmZqMQ9xXaNa@google.com>
 <YzNz36gZqrse9GzT@google.com>
 <YzPMaEPBtaXguJaT@google.com>
 <YzR9TRjVFi+P7UOp@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzR9TRjVFi+P7UOp@google.com>
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

On Wed, Sep 28, 2022 at 04:58:53PM +0000, Sean Christopherson wrote:
> On Tue, Sep 27, 2022, Ricardo Koller wrote:
> > On Tue, Sep 27, 2022 at 10:06:23PM +0000, Sean Christopherson wrote:
> > > On Mon, Sep 26, 2022, Ricardo Koller wrote:
> > > > On Thu, Sep 22, 2022 at 07:32:42PM +0000, Sean Christopherson wrote:
> > > > > On Thu, Sep 22, 2022, Ricardo Koller wrote:
> > > > > > +	void *hva = (void *)region->region.userspace_addr;
> > > > > > +	uint64_t paging_size = region->region.memory_size;
> > > > > > +	int ret, fd = region->fd;
> > > > > > +
> > > > > > +	if (fd != -1) {
> > > > > > +		ret = fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> > > > > > +				0, paging_size);
> > > > > > +		TEST_ASSERT(ret == 0, "fallocate failed, errno: %d\n", errno);
> > > > > > +	} else {
> > > > > > +		if (is_backing_src_hugetlb(region->backing_src_type))
> > > > > > +			return false;
> > > > > 
> > > > > Why is hugetlb disallowed?  I thought anon hugetlb supports MADV_DONTNEED?
> > > > > 
> > > > 
> > > > It fails with EINVAL (only tried on arm) for both the PAGE_SIZE and the huge
> > > > page size. And note that the address is aligned as well.
> > > > 
> > > > madvise(0xffffb7c00000, 2097152, MADV_DONTNEED) = -1 EINVAL (Invalid argument)
> > > > 	^^^^^^^^^^^^^^	^^^^^^^
> > > > 	2M aligned	2M (hugepage size)
> > > > 			
> > > > madvise(0xffff9e800000, 4096, MADV_DONTNEED) = -1 EINVAL (Invalid argument)   
> > > > 			^^^^
> > > > 			PAGE_SIZE
> > > 
> > > I think this needs to be root caused before merging.  Unless I'm getting turned
> > > around, MADV_DONTEED should work, i.e. there is a test bug lurking somewhere.
> > 
> > Turns out that the failure is documented. Found this in the madvise manpage:
> > 
> >   MADV_DONTNEED cannot be applied to locked pages, Huge TLB pages, or VM_PFNMAP pages.
> 
> The manpages are stale:
> 
>    c4b6cb884011 ("selftests/vm: add hugetlb madvise MADV_DONTNEED MADV_REMOVE test")
>    90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
> 
> The tools/testing/selftests/vm/hugetlb-madvise.c selftest effectively tests what
> is being done here, so _something_ is broken.

Thanks for the pointers. I was using old kernels (~5.15) for these
latest tests. Testing on a 6.0-rc3 kernel fixed things: now able to
madvise(MADV_DONTNEED) on anon-hugetlb from the selftest (arm).

Will remove the check (for skppping the test) in v9.

Thanks!
Ricardo
