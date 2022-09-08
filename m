Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1865B2640
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 20:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbiIHSvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 14:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbiIHSvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 14:51:09 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E891AFE48F
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 11:51:06 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso3792830pjq.1
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 11:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=kjdi7HnZZPWqbvm0cQB8/Aa9qxYEE/QRoLyyVmHWAyQ=;
        b=A8kiiaozuZ7qVw1QY6EKyI1J8bTv8/KCV9QYwZGc61ZF6VsdYwvTEpCS/WC2q5e/yn
         UwzVldLcPszfTtIghKVwocgKepioJBZH6XvJULeNkZW1D4KTkmgcI/F5jx6sfkeEHsv2
         WLniYIDNMPf+GvtPSW3wU9GrUu9O/QynDjwYtZQiIq31Ryv+FMvhSgwtevT/2DhBF5hQ
         FpGbSgD3SmQpOtkr9jvHcgEWymWTWotl0kKW4lCDV6mWj4MwDkSiddATCGJ01Ujezs95
         4/U8y+aQQThNtP2wTIdrKxdyd1iGc89+06GP4wUrX4Dffw7YjAkxXLRLle38yexo2yTB
         UcEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=kjdi7HnZZPWqbvm0cQB8/Aa9qxYEE/QRoLyyVmHWAyQ=;
        b=TbsX2EvBaZiuVYJljlgakqrjUucTBPDdOXPLixUVMevFgwTXkqH/dxTCi8o6SgmEib
         n830lFlKstBtlGZSVRf4TfzfqFaPiXoq4HVdj96/NOXHNYQctAl8Llnjey4pwth3obvi
         87ByrgO/p9lH/GcbG7FFjve81gOZB6YWvRKuNq5yPk68BGH0lx2AOvDLRUU6OT0J4Nnj
         6Olo/B8pbP/8p1dQBKtIWLOcBTytHnSF9RAMxPw4gfx8N7V1gZQt3ilDCCf+MYr5O6RW
         5eq6/1T7kpo+AnvSP3uGgsbZvlEAWnQOSW8NCGp89nhAJSiOojJz9ri/uZciiwACZr66
         39CA==
X-Gm-Message-State: ACgBeo2hNSLsS+BLYCkld8QkdoUwvGCVQKnGM5gVosCIffrtNmXGw2F+
        GlSUupU8HEQo/3mMsmBA1oILCw==
X-Google-Smtp-Source: AA6agR55tKhJbqQEc2pDOfes7Vks3Ns3uAvewjr5iPc9gRGlcoBU/6c7csuBNIyoU1VJpV6yziv0OA==
X-Received: by 2002:a17:90b:3b47:b0:1fe:4b60:f4d8 with SMTP id ot7-20020a17090b3b4700b001fe4b60f4d8mr5575438pjb.229.1662663066234;
        Thu, 08 Sep 2022 11:51:06 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id w68-20020a623047000000b0053bf1f90188sm11332603pfw.176.2022.09.08.11.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 11:51:04 -0700 (PDT)
Date:   Thu, 8 Sep 2022 11:51:00 -0700
From:   David Matlack <dmatlack@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v2 2/3] KVM: selftests: Randomize which pages are written
 vs read.
Message-ID: <Yxo5lFuCRgbn+svL@google.com>
References: <YwlFcGn4w34uXPQd@google.com>
 <gsntilm9wo5p.fsf@coltonlewis-kvm.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gsntilm9wo5p.fsf@coltonlewis-kvm.c.googlers.com>
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

On Tue, Aug 30, 2022 at 07:02:10PM +0000, Colton Lewis wrote:
> David Matlack <dmatlack@google.com> writes:
> 
> > On Wed, Aug 17, 2022 at 09:41:45PM +0000, Colton Lewis wrote:
> > > Randomize which tables are written vs read using the random number
> > > arrays. Change the variable wr_fract and associated function calls to
> > > write_percent that now operates as a percentage from 0 to 100 where X
> > > means each page has an X% chance of being written. Change the -f
> > > argument to -w to reflect the new variable semantics. Keep the same
> > > default of 100 percent writes.
> 
> > Doesn't the new option cause like a 1000x slowdown in "Dirty memory
> > time"?  I don't think we should merge this until that is understood and
> > addressed (and it should be at least called out here so that reviewers
> > can be made aware).
> 
> 
> I'm guessing you got that from my internally posted tests. This option
> itself does not cause the slowdown. If this option is set to 0% or 100%
> (the default), there is no slowdown at all. The slowdown I measured was
> at 50%, probably because that makes branch prediction impossible because
> it has an equal chance of doing a read or a write each time. This is a
> good thing. It's much more realistic than predictably alternating read
> and write.

I found it hard to believe that branch prediction could affect
performance by 1000x (and why wouldn't random access order show the same
effect?) so I looked into it further.

The cause of the slowdown is actually MMU lock contention:

-   82.62%  [k] queued_spin_lock_slowpath
   - 82.09% queued_spin_lock_slowpath
      - 48.36% queued_write_lock_slowpath
         - _raw_write_lock
            - 22.18% kvm_mmu_notifier_invalidate_range_start
                 __mmu_notifier_invalidate_range_start
                 wp_page_copy
                 do_wp_page
                 __handle_mm_fault
                 handle_mm_fault
                 __get_user_pages
                 get_user_pages_unlocked
                 hva_to_pfn
                 __gfn_to_pfn_memslot
                 kvm_faultin_pfn
                 direct_page_fault
                 kvm_tdp_page_fault
                 kvm_mmu_page_fault
                 handle_ept_violation

I think the bug is due to the following:

 1. Randomized reads/writes were being applied to the Populate phase,
    which (when using anonymous memory) results in the guest memory being
    mapped to the Zero Page.
 2. The random access order changed across each iteration (Population
    phase included) which means that some pages were written to during each
    iteration for the first time. Those pages resulted in a copy-on-write
    in the host MM fault handler, which invokes the invalidate range
    notifier and acquires the MMU lock in write-mode.
 3. All vCPUs are doing this in parallel which results in a ton of lock
    contention.

Your internal test results also showed that performance got better
during each iteration. That's because more and more of the guest memory
has been faulted in during each iteration (less and less copy-on-write
faults that need to acquire the MMU lock in write-mode).

I see this issue in your v1 patchset but not v3 (I did not check v2).
But I think that's just because of the bug Ricardo pointed out
(write_percent is always 100 no matter what the user passes in on the
command line).

The proper fix for v4 would be to set write-percent to 100 during the
populate phase so all memory actually gets populated. Then only use the
provided write-percent for testing dirty logging.

Now you might wonder why the old version of the code didn't have this
problem despite also doing reads during the populate phase. That's
because the non-randomized version always read/wrote the same pages
during every pass. With your code every iteratoin reads/writes to a
random set of pages.
