Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799E359EFC2
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 01:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbiHWXiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 19:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHWXiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 19:38:00 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7087FE67
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 16:37:59 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y4so14189519plb.2
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 16:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=IaZ4H3tMkMrOvE5Cs902sGYZoIVCWhohAIktvLaNyXo=;
        b=iRiolzYbbyCama5Mgm7/cxmWWehq0CPsDYqHF+QXaUgJhsjIPZT7vp9PzHV1ivY/JC
         uP8VjwHsXwE+aYPYP91/h8/UwnVz28L3bWrC4F7PHQSlmkkQ5nlfsqkJhrGjPyNTLLkr
         V5Ir2PPSZ0jL6SBPHYAQyicQyKk05cuSoOvcrPNyvc8mM8xDwDLu9KFDj9r5sQ1h7pRI
         f0hXzf8qA0Jk4A+qrHl8LRKkBwWPce8Gge90xuTSY17965Xi31/m4pvCWy4Q0MY7zKZw
         BVLB4imHbmRcvB+AEP+QyIkqN0onjSPXiUzOR8gUWcAmj4DF5NvinzMwx1KADdyEYUkz
         H4MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=IaZ4H3tMkMrOvE5Cs902sGYZoIVCWhohAIktvLaNyXo=;
        b=p+BNiwNb32cvTapKhhrGWsfPb+Smmm2hfA3vyrxI5O5DciWYom1yFWt3x2zvqXVnb1
         WQJ+XTg72d9rQYV6Bn8exae2Mmg8mAoRfL89+8sj4o0bpWLC5OxO8mP9f/6ktSRrKn/5
         pPvjC7ZPBCKKqrpIK315nrZ90GvmKBEfxQKKBdFocBZM7xgrYFqorlqUK43EMHh1vuyS
         JyC/XeW5w0LiMX4v7Z/5a83LNacq/mFJrgOvAm2BnLWmp68yuzsc5t1+UuGXzu0PpotY
         eeQuFCx32jUAW19xFg/OUXlJIqwJ/dD1OXxPQSsGwx5hi+Z/GP1HW6OY0Q8IxV384hKo
         iCeQ==
X-Gm-Message-State: ACgBeo2AKr7aBGAYzbqaIRrxcl1poNlfDPxs4W+tQ5um2eCxF1hKIxmc
        zzrpbYrUjA7M9IPSUA1nxKu8cw==
X-Google-Smtp-Source: AA6agR5dtwFt87kPaOsLnvwsR27B8RnElI2bmBpqeYbCUDJ5aoQeIUf33cxZIJ+bDePMRUT00Yfmew==
X-Received: by 2002:a17:903:120d:b0:171:4fa0:7b4a with SMTP id l13-20020a170903120d00b001714fa07b4amr26013097plh.45.1661297878488;
        Tue, 23 Aug 2022 16:37:58 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id j7-20020a170903024700b00172ea8ff334sm5219402plh.7.2022.08.23.16.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 16:37:57 -0700 (PDT)
Date:   Tue, 23 Aug 2022 16:37:53 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com, maz@kernel.org,
        bgardon@google.com, dmatlack@google.com, pbonzini@redhat.com,
        axelrasmussen@google.com
Subject: Re: [PATCH v4 09/13] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YwVk0a/FTfYS1nNf@google.com>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-10-ricarkol@google.com>
 <Ytir/hbU9neBaYqb@google.com>
 <YtrcCeHqBcwy+Mf6@google.com>
 <YtrqVwSK42KbKckf@google.com>
 <20220723082201.ifme5dipygt5r2wx@kamzik>
 <YuAvQ0C8ZprtJ4US@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuAvQ0C8ZprtJ4US@google.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 26, 2022 at 06:15:31PM +0000, Sean Christopherson wrote:
> On Sat, Jul 23, 2022, Andrew Jones wrote:
> > On Fri, Jul 22, 2022 at 06:20:07PM +0000, Sean Christopherson wrote:
> > > On Fri, Jul 22, 2022, Ricardo Koller wrote:
> > > > What about dividing the changes in two.
> > > > 
> > > > 	1. Will add the struct to "__vm_create()" as part of this
> > > > 	series, and then use it in this commit. There's only one user
> > > > 
> > > > 		dirty_log_test.c:   vm = __vm_create(mode, 1, extra_mem_pages);
> > > > 
> > > > 	so that would avoid having to touch every test as part of this patchset.
> > > > 
> > > > 	2. I can then send another series to add support for all the other
> > > > 	vm_create() functions.
> > > > 
> > > > Alternatively, I can send a new series that does 1 and 2 afterwards.
> > > > WDYT?
> > > 
> > > Don't do #2, ever. :-)  The intent of having vm_create() versus is __vm_create()
> > > is so that tests that don't care about things like backing pages don't have to
> > > pass in extra params.  I very much want to keep that behavior, i.e. I don't want
> > > to extend vm_create() at all.  IMO, adding _anything_ is a slippery slope, e.g.
> > > why are the backing types special enough to get a param, but thing XYZ isn't?
> > > 
> > > Thinking more, the struct idea probably isn't going to work all that well.  It
> > > again puts the selftests into a state where it becomes difficult to control one
> > > setting and ignore the rest, e.g. the dirty_log_test and anything else with extra
> > > pages suddenly has to care about the backing type for page tables and code.
> > > 
> > > Rather than adding a struct, what about extending the @mode param?  We already
> > > have vm_mem_backing_src_type, we just need a way to splice things together.  There
> > > are a total of four things we can control: primary mode, and then code, data, and
> > > page tables backing types.
> > > 
> > > So, turn @mode into a uint32_t and carve out 8 bits for each of those four "modes".
> > > The defaults Just Work because VM_MEM_SRC_ANONYMOUS==0.
> > 
> > Hi Sean,
> > 
> > How about merging both proposals and turn @mode into a struct and pass
> > around a pointer to it? Then, when calling something that requires @mode,
> > if @mode is NULL, the called function would use vm_arch_default_mode()
> > to get a pointer to the arch-specific default mode struct.
> 
> One tweak: rather that use @NULL as a magic param, #define VM_MODE_DEFAULT to
> point at a global struct, similar to what is already done for __aarch64__.
> 
> E.g.
> 
> 	__vm_create(VM_MODE_DEFAULT, nr_runnable_vcpus, 0);
> 
> does a much better job of self-documenting its behavior than this:
> 
> 	__vm_create(NULL, nr_runnable_vcpus, 0);
> 
> > If a test needs to modify the parameters then it can construct a mode struct
> > from scratch or start with a copy of the default. As long as all members of
> > the struct representing parameters, such as backing type, have defaults
> > mapped to zero for the struct members, then we shouldn't be adding any burden
> > to users that don't care about other parameters (other than ensuring their
> > @mode struct was zero initialized).
> 
> I was hoping to avoid forcing tests to build a struct, but looking at all the
> existing users, they either use for_each_guest_mode() or just pass VM_MODE_DEFAULT,
> so in practice it's a complete non-issue.
> 
> The page fault usage will likely be similar, e.g. programatically generate the set
> of combinations to test.
> 
> So yeah, let's try the struct approach.

Thank you both for the suggestions.

About to send v5 with the suggested changes, with a slight modification.
V5 adds "struct kvm_vm_mem_params" which includes a "guest mode" field.
The suggestion was to overload "guest mode". What I have doesn't change
the meaning of "guest mode", and just keeps everything dealing with
"guest mode" the same (like guest_mode.c).

The main changes are:

1. adding a struct kvm_vm_mem_params that defines the memory layout:

	-struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages);
	+struct kvm_vm *____vm_create(struct kvm_vm_mem_params *mem_params);

2. adding memslot vm->memslot.[code|pt|data] and change all allocators
to use the right memslot, e.g.,: lib/elf should use the code memslot.

3. change the new page_fault_test.c setup_memslot() accordingly (much
nicer).

Let me know what you think.

Thanks!
Ricardo
