Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46EEE513F4C
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 02:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353498AbiD2ACv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 20:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353494AbiD2ACt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 20:02:49 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADA1B3DFA
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 16:59:33 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id t13so5565098pfg.2
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 16:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=NkdAc4ROI0IN/ucEyriBKuBm/wRvD7rJzE7ZldBnAVc=;
        b=ieCdewl7trcwYiGuAViRjmy/2tPSl//ooh0sBkiUyaOLVGeYHI7HVNyw1r6oF2JGQO
         wfPhoK55na+q18w1IdYcarFh52JwEJunWLJfpUerDlCXy4BqlJkTthQFCWzT10C5/ZVU
         0+HWNKY67dGMsV+nXLrNvwTZKqqBzKZL16K6YZD7Cpc/U8hwdKDAgjrVS3IfWkpIGreI
         D430VmGlMTpTRYD+IQcZ/H/qobaUYmH1FL+2Vz1q7oNagkq4L4WL60pu/V5/mVYs1kKG
         KzC4J6Y5AjnwmiyJRQB6MqXVRBitr4Oj5gIOfXtkBoM61rdWVcm7rmBkrKtjNvTS0/j7
         22+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=NkdAc4ROI0IN/ucEyriBKuBm/wRvD7rJzE7ZldBnAVc=;
        b=1tnmR5hjE0FJVuFzJDsLsVTEb0Ucp/Criq4C019f8AIFv2+6u+3+yOPm8P6MV3tAVx
         2IhWS7nUxSbeLTkoYFAH46QuZ0LOE1gK/80wRZu60/nkQ8oCkkplShQqZTp89aRlgOiM
         /GaU4dcnCYtEq5UmU0gYJAHPAihxZrwKCNrCV/hYRjLcN1+U6LVqN7w/fjaZuPlxMVyZ
         JU26e0O96ywYqDCX/CjU6HWr8fRDS579RLCS7pG9V9AFSXlk9AoJxJnL4qVdXBELaaAu
         wrlWBN9w2HPoSjbPs0qk4Cl2GHPOYe7Av/YgFYB+3VtwS5UR+OHwS3iJqBhnFt58Ge1a
         pRDg==
X-Gm-Message-State: AOAM531DvtTQ4ebPn3jKJp53sckZ/tmEmI0n4HYS8skysnSur0BU/sW5
        6zW3Tz0CKXePbJ6CTXOhvbKfsQ==
X-Google-Smtp-Source: ABdhPJygQErW25U15esiDo2hH4DIrCtVSvl+BhW210cRVNRvdTJew+wcH3kEtOeLxjnuGlXwcmydZg==
X-Received: by 2002:a05:6a00:1307:b0:4b0:b1c:6fd9 with SMTP id j7-20020a056a00130700b004b00b1c6fd9mr37165986pfu.27.1651190373046;
        Thu, 28 Apr 2022 16:59:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i68-20020a628747000000b0050d25c48c3fsm936677pfe.90.2022.04.28.16.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 16:59:32 -0700 (PDT)
Date:   Thu, 28 Apr 2022 23:59:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v3 3/3] KVM: selftests: Add selftests for dirty quota
 throttling
Message-ID: <YmsqYZCMxR+Y/EP5@google.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-4-shivam.kumar1@nutanix.com>
 <3bd9825e-311f-1d33-08d4-04f3d22f9239@nutanix.com>
 <6c5ee7d1-63bb-a0a7-fb0c-78ffcfd97bc5@nutanix.com>
 <Yl2PEXqHswOc2j0L@google.com>
 <a8468330-5126-901a-7e49-2566ffcca591@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a8468330-5126-901a-7e49-2566ffcca591@nutanix.com>
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

On Thu, Apr 28, 2022, Shivam Kumar wrote:
> 
> On 18/04/22 9:47 pm, Sean Christopherson wrote:
> > On Mon, Apr 18, 2022, Shivam Kumar wrote:
> > > > > +void vcpu_handle_dirty_quota_exit(struct kvm_run *run,
> > > > > +            uint64_t test_dirty_quota_increment)
> > > > > +{
> > > > > +    uint64_t quota = run->dirty_quota_exit.quota;
> > > > > +    uint64_t count = run->dirty_quota_exit.count;
> > > > > +
> > > > > +    /*
> > > > > +     * Due to PML, number of pages dirtied by the vcpu can exceed its dirty
> > > > > +     * quota by PML buffer size.
> > > > > +     */
> > > > > +    TEST_ASSERT(count <= quota + PML_BUFFER_SIZE, "Invalid number of pages
> > > > > +        dirtied: count=%"PRIu64", quota=%"PRIu64"\n", count, quota);
> > > Sean, I don't think this would be valid anymore because as you mentioned, the
> > > vcpu can dirty multiple pages in one vmexit. I could use your help here.
> > TL;DR: Should be fine, but s390 likely needs an exception.
> > 
> > Practically speaking the 512 entry fuzziness is all but guaranteed to prevent
> > false failures.
> > 
> > But, unconditionally allowing for overflow of 512 entries also means the test is
> > unlikely to ever detect violations.  So to provide meaningful coverage, this needs
> > to allow overflow if and only if PML is enabled.
> > 
> > And that brings us back to false failures due to _legitimate_ scenarios where a vCPU
> > can dirty multiple pages.  Emphasis on legitimate, because except for an s390 edge
> > case, I don't think this test's guest code does anything that would dirty multiple
> > pages in a single instruction, e.g. there's no emulation, shouldn't be any descriptor
> > table side effects, etc...  So unless I'm missing something, KVM should be able to
> > precisely handle the core run loop.
> > 
> > s390 does appear to have a caveat:
> > 
> > 	/*
> > 	 * On s390x, all pages of a 1M segment are initially marked as dirty
> > 	 * when a page of the segment is written to for the very first time.
> > 	 * To compensate this specialty in this test, we need to touch all
> > 	 * pages during the first iteration.
> > 	 */
> > 	for (i = 0; i < guest_num_pages; i++) {
> > 		addr = guest_test_virt_mem + i * guest_page_size;
> > 		*(uint64_t *)addr = READ_ONCE(iteration);
> > 	}
> > 
> > IIUC, subsequent iterations will be ok, but the first iteration needs to allow
> > for overflow of 256 (AFAIK the test only uses 4kb pages on s390).
> Hi Sean, need an advice from your side before sending v4. In my opinion, I
> should organise my patchset in a way that the first n-1 patches have changes
> for x86 and the last patch has the changes for s390 and arm64. This can help
> me move forward for the x86 arch and get help and reviews from s390 and
> arm64 maintainers in parallel. Please let me know if this makes sense.

Works for me.  It probably makes sense to split s390 and arm64 too, that way you
don't need a v5 if one wants the feature and the other does not.
