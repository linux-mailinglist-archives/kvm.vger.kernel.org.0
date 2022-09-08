Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6205B2714
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 21:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiIHTrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 15:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiIHTqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 15:46:46 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D841F2968
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 12:46:45 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-32a115757b6so153479847b3.13
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 12:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date;
        bh=BwMaAHPQSq+Wa0RYapafyYYY5QCLaYZSELDbulLZdJM=;
        b=r0TmBIPME0tjb8WFKLcPHZJxmBLTq/TdlIWsA+xcj61Y3moaZ7zjsTG73K5nDDG0PX
         0VUgefhx9PVoqGsdJcC5Y1ud63W/XjYJ+12PdX/6Ec+OU2xLoVcxZYMBIIVPRBxhOxD+
         FuyOVyZ8zpRp02uBNK6FZeZoOGhC22L7GfWNFxggqtXFOp8M47vplnCSAO5m1QnYOdgY
         F/rfD30Eyp3+8weeCy1EaWyMaEnzSxsJa/9iDzKXSb7Q1y9ev0eHm8JkBdH9PhlV6DUn
         Dv8iJMgL04rUZNa2k01HhHFaxlocE97xQb3I0Sk5qgX/Cawoym3mC50pF5uHrCIwW6ui
         c18A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=BwMaAHPQSq+Wa0RYapafyYYY5QCLaYZSELDbulLZdJM=;
        b=Bu+MnnWUzKjiTMP7KGkxhaYZ7oCa5fuBWoeuG2Es+1dXylGfgzTPI74ZXw9sfSlSsc
         KuYCudTN1msajAnnULv9U+RLEIU7XgT5JIBafDvtYFpP4I+WIIljZ9hHwZ8fe4g7Op15
         ZI0cnMPOuE14ngE0aObjwNZv7sZXy2pyWNWZDewGPiHMECtX+kbnUObzDvlxoQp+EYN4
         Lvr/znyH8fzCzAbB6s321Y1qnMA+8VLLTr2UeNLVcH+PYhkrPaIhhWdQJofvMdpJ/jWg
         YSHpzQzW5Ob3jNHY5/CFoaIdOcEA5BaguGwgdkFExpQ7rGomt7tBeD1aWLz52z9wWdke
         jkxQ==
X-Gm-Message-State: ACgBeo1UYBFWR47Gv8O29R3OTWDJrHaPJEsN0veKXT+1tqcdL2IyClRu
        fVVsbkwjRskmSvFk4x9UAcn/s9ml6vKEwBdm6g==
X-Google-Smtp-Source: AA6agR7HDhZRaErxg3Sv90RNlp2UCRnJMnsm+MgYyUzZRdgja4iGjR3KBfGxMGIUpbf1NxmcoQBgEczqf/h9egBw4g==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:9d8d:0:b0:676:a71d:edad with SMTP
 id v13-20020a259d8d000000b00676a71dedadmr8374263ybp.94.1662666404785; Thu, 08
 Sep 2022 12:46:44 -0700 (PDT)
Date:   Thu, 08 Sep 2022 19:46:44 +0000
In-Reply-To: <Yxo5lFuCRgbn+svL@google.com> (message from David Matlack on Thu,
 8 Sep 2022 11:51:00 -0700)
Mime-Version: 1.0
Message-ID: <gsntmtb9ps2j.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 2/3] KVM: selftests: Randomize which pages are written
 vs read.
From:   Colton Lewis <coltonlewis@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Matlack <dmatlack@google.com> writes:

> On Tue, Aug 30, 2022 at 07:02:10PM +0000, Colton Lewis wrote:
>> David Matlack <dmatlack@google.com> writes:

>> > On Wed, Aug 17, 2022 at 09:41:45PM +0000, Colton Lewis wrote:
>> > > Randomize which tables are written vs read using the random number
>> > > arrays. Change the variable wr_fract and associated function calls to
>> > > write_percent that now operates as a percentage from 0 to 100 where X
>> > > means each page has an X% chance of being written. Change the -f
>> > > argument to -w to reflect the new variable semantics. Keep the same
>> > > default of 100 percent writes.

>> > Doesn't the new option cause like a 1000x slowdown in "Dirty memory
>> > time"?  I don't think we should merge this until that is understood and
>> > addressed (and it should be at least called out here so that reviewers
>> > can be made aware).


>> I'm guessing you got that from my internally posted tests. This option
>> itself does not cause the slowdown. If this option is set to 0% or 100%
>> (the default), there is no slowdown at all. The slowdown I measured was
>> at 50%, probably because that makes branch prediction impossible because
>> it has an equal chance of doing a read or a write each time. This is a
>> good thing. It's much more realistic than predictably alternating read
>> and write.

> I found it hard to believe that branch prediction could affect
> performance by 1000x (and why wouldn't random access order show the same
> effect?) so I looked into it further.

> The cause of the slowdown is actually MMU lock contention:

> -   82.62%  [k] queued_spin_lock_slowpath
>     - 82.09% queued_spin_lock_slowpath
>        - 48.36% queued_write_lock_slowpath
>           - _raw_write_lock
>              - 22.18% kvm_mmu_notifier_invalidate_range_start
>                   __mmu_notifier_invalidate_range_start
>                   wp_page_copy
>                   do_wp_page
>                   __handle_mm_fault
>                   handle_mm_fault
>                   __get_user_pages
>                   get_user_pages_unlocked
>                   hva_to_pfn
>                   __gfn_to_pfn_memslot
>                   kvm_faultin_pfn
>                   direct_page_fault
>                   kvm_tdp_page_fault
>                   kvm_mmu_page_fault
>                   handle_ept_violation

> I think the bug is due to the following:

>   1. Randomized reads/writes were being applied to the Populate phase,
>      which (when using anonymous memory) results in the guest memory being
>      mapped to the Zero Page.
>   2. The random access order changed across each iteration (Population
>      phase included) which means that some pages were written to during  
> each
>      iteration for the first time. Those pages resulted in a copy-on-write
>      in the host MM fault handler, which invokes the invalidate range
>      notifier and acquires the MMU lock in write-mode.
>   3. All vCPUs are doing this in parallel which results in a ton of lock
>      contention.

> Your internal test results also showed that performance got better
> during each iteration. That's because more and more of the guest memory
> has been faulted in during each iteration (less and less copy-on-write
> faults that need to acquire the MMU lock in write-mode).


Thanks for the analysis David. I had wondered about the effects of
randomized reads/writes during the populate phase.

> The proper fix for v4 would be to set write-percent to 100 during the
> populate phase so all memory actually gets populated. Then only use the
> provided write-percent for testing dirty logging.


Will do that.
