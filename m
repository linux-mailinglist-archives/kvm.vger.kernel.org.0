Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966C267D815
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 23:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbjAZWAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 17:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbjAZV7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 16:59:55 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE62073748
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 13:59:54 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 143so2026512pgg.6
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 13:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YJnku2tU3/6C2F8suak76N7QwbI25qrwIMn4ZDl4TFI=;
        b=QYG1rYc8La4B3E/MkSHWT5RxKkar6r4pvkx3HyZiVu1tVarzy6kcr/VFFiVgtoi1Ra
         ZSGyz+F2QvIjob6gceJZgvtq5UdaIdQdLmz76BB7S6Oku1fG9U9Egjj5rOD7U/wtXrHj
         ajPPi91z5UUBPDJRxkK4s3OjwYYe/C9A3LB0+gDD8vLCFukSu4j7/E2PU+BzCCFQbYTc
         tF/xpGQBFYmFJARe2QE3SCqL4g6VLeW87RnW+IlnEm7OWti6WOaP+LFX8e7XrExX2aPi
         Av234avFZ8wqm7JOzqcgCvMQwyZJpQXCXFj3gSHq443MvbJzDGhPjWqMAoeu8cidWAUl
         gtgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YJnku2tU3/6C2F8suak76N7QwbI25qrwIMn4ZDl4TFI=;
        b=E6AtKqIrB5vki1BJAVr7KL7LT9FBSalyZFdOykoiC1gSMcCDKs3Ug4iLVC2B34tzLV
         NnXU+WsBztJn8mH7TKDY/0OrRxiFT+Qq6vI6dIb22AVYYejvSCbZGVZM6sI3z+vFLP0m
         N+izEUm+SYuXUpHclPctveFyvYVK+0MCcZ0GT/X6O28yJevsbw4UTUaY3uzgiSRLhp42
         H7hlQxY1HFt6KKfNJ+IppCLhLNSuoeN1hEsmh+pjnTJ3ENTv3CQ54Ldy4TEAX4PJ3tMc
         5Bm9+clChimZjJIEsV9cvuKXelmh/2oeOeFGzpx6hWvdgtNMclCNWaKCSE0rMFOyO8WT
         h+Jg==
X-Gm-Message-State: AO0yUKW5TkdheBAhxYxl+3qWvxfd4Ivr8ZwBHkE7MoH1IEkpXc6kY/kN
        GKJR5AZEpzKiLlK52dAMjaD91g==
X-Google-Smtp-Source: AK7set+5EZ/qT4Z/ggWinkndf4ffSHynNy8XELCqMlevIgpOgNFZ8JsBSKxAPw5A8iCBg+mkSPUL3Q==
X-Received: by 2002:a05:6a00:23cb:b0:581:bfac:7a52 with SMTP id g11-20020a056a0023cb00b00581bfac7a52mr1507578pfc.1.1674770394220;
        Thu, 26 Jan 2023 13:59:54 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c64-20020a624e43000000b00586fbbdf6e4sm1316693pfb.34.2023.01.26.13.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 13:59:53 -0800 (PST)
Date:   Thu, 26 Jan 2023 21:59:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Message-ID: <Y9L31cqsKvr4boGU@google.com>
References: <Y8m34OEVBfL7Q4Ns@google.com>
 <1c71eda35e03372f29162c6a5286f5b4d1e1d7e1.camel@intel.com>
 <Y8ndcGHUHQjHfbF9@google.com>
 <CALzav=d4vwHTnXP8wetA_Hqd3Tzc_NLp=3M-akwNSN1-ToL+Eg@mail.gmail.com>
 <Y8st2PjGDQ+Q0LlW@google.com>
 <3951e178bc38191074f5cccadc442212ff15c737.camel@intel.com>
 <Y87GzHrx8vxZLBEJ@google.com>
 <e5912f7d04ce7a27a68ce4328fc50ce594295c6c.camel@intel.com>
 <Y9K4Mnx/Je4j+RsD@google.com>
 <144de0bf7cc86dd7807f1b559c3269bccbb56317.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <144de0bf7cc86dd7807f1b559c3269bccbb56317.camel@intel.com>
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

On Thu, Jan 26, 2023, Huang, Kai wrote:
> On Thu, 2023-01-26 at 17:28 +0000, Sean Christopherson wrote:
> > In other words, once the PTE is zapped/blocked (branch is pruned), it's completely
> > removed from the paging tree and no other tasks can access the branch (page table
> > and its children).  I.e. the only remaining reference to the branch is the pointer
> > handed to the RCU callback.  That means the RCU callback has exclusive access to the
> > branch, i.e. can operate as if it were holding mmu_lock for write.  Furthermore, the
> > RCU callback also doesn't need to flush TLBs because that was again done when
> > pruning the branch.
> > 
> > It's the same idea that KVM already uses for root SPs, the only difference is how
> > KVM determines that there is exactly one entity that holds a reference to the SP.
> 
> Right.  This works fine for normal non-TDX case.  However for TDX unfortunately
> the access to the removed branch (or the removed sub-page-table) isn't that
> "exclusive" as the SEAMCALL to truly zap that branch still needs to hold the
> write lock of the entire Secure EPT tree, so it can still conflict with other
> threads handling new faults.

I thought TDX was smart enough to read-lock only the part of the tree that it's
actually consuming, and write-lock only the part of the tree that it's actually
modifying?

Hrm, but even if TDX takes a read-lock, there's still the problem of it needing
to walk the upper levels, i.e. KVM needs to keep mid-level page tables reachable
until they're fully removed.  Blech.  That should be a non-issue at this time
though, as I don't think KVM will ever REMOVE a page table of a live guest.  I
need to look at the PROMOTE/DEMOTE flows...
