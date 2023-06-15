Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3AC731BE8
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 16:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241065AbjFOO4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 10:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345157AbjFOO4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 10:56:06 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1218F2943
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 07:56:05 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-babb76a9831so1908715276.2
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 07:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686840964; x=1689432964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8mCu3q2W53oKSoawXLYJ93orssYlrpvFJDcpWykXpws=;
        b=mUgvNvZY/tOdw3tuKIAsLd1mD1eoX6q/vF4f+UMtwXX/LnleIYYhB+2kJmlH3xFNQl
         xGosABWC5pM8S+9c7Go3WbBUGwk1nPMP6fpNkpPnPXU6E8EFFBwS0EjHDBLZLRMRR+jG
         Xu+6g3oCQUR1Tznlx75COV7MLaKxsxel0Mxv7gDsgjrFETQ+5DNTpPZiFrDmNgYglFf9
         iIjmYP4Qcx1Vs8l0Rx792q8Xk7qFeNyKsP2AS4ht1upRkwu9bdBuI8CDP8FabIojrKfY
         AjI7aeJdrglwJdFi3GYDaW61B3xtRtL95X59EpqsSIegViNBv7/Tc4GwYAGju2+kE01D
         BNWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686840964; x=1689432964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8mCu3q2W53oKSoawXLYJ93orssYlrpvFJDcpWykXpws=;
        b=GVaIy5lj99Gp/eQriVRe6xOzGNTzfYK5fzkey4FoIuG1BKOj7eiB0AUVFsUJVHfhoI
         licziiksU1PQojRFSgH3LmNvI0Ec7GYgSfbb077oltq/zQJinQFlgFnZr5Qz1gLvpu3c
         fmAoWxIlwj94KQeTufPuf9hJ6X4ZrSyfiIefvkjtcnhoyGrT15DrRhdUgQGvn8gJLlHX
         Kzs9jdLWDP6IMG0TqATx4lztpX1zxm2CYLNmHP07RbEr6FAA3evT3pUA2LUOHEWkZ+G2
         K9K0gkvdHb5G0BAR3MKz8F9YjinXgLPYhVxIQmOsXBVBFAHOdPPm5ZDu/Hq+0Xvcko6p
         EQCQ==
X-Gm-Message-State: AC+VfDybd/pZUE4H48bk9lmDbRq02BJ6Jn/RPc3FelhTA4XWzv2xQ9mH
        rOe8P042RBkfW0++NkbmIJtS/JGbeMs=
X-Google-Smtp-Source: ACHHUZ7ZYqdPI7E3BxkS+GlJff/2XmsdQrbZQToAtHCD3oKMWWqg9gW2lpZzYNNQvHEbuBhXAI4EIguFdRI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8209:0:b0:bd1:ae45:5447 with SMTP id
 q9-20020a258209000000b00bd1ae455447mr706408ybk.0.1686840964224; Thu, 15 Jun
 2023 07:56:04 -0700 (PDT)
Date:   Thu, 15 Jun 2023 07:56:02 -0700
In-Reply-To: <DS0PR11MB6373969DA5CCDD6EBBC9CB7ADC5BA@DS0PR11MB6373.namprd11.prod.outlook.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-10-amoorthy@google.com>
 <ZIovIBVLIM69E5Bo@google.com> <DS0PR11MB6373969DA5CCDD6EBBC9CB7ADC5BA@DS0PR11MB6373.namprd11.prod.outlook.com>
Message-ID: <ZIsmgnEneMBZ48hf@google.com>
Subject: Re: [PATCH v4 09/16] KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
From:   Sean Christopherson <seanjc@google.com>
To:     Wei W Wang <wei.w.wang@intel.com>
Cc:     Anish Moorthy <amoorthy@google.com>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "robert.hoo.linux@gmail.com" <robert.hoo.linux@gmail.com>,
        "jthoughton@google.com" <jthoughton@google.com>,
        "bgardon@google.com" <bgardon@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "ricarkol@google.com" <ricarkol@google.com>,
        "axelrasmussen@google.com" <axelrasmussen@google.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "nadav.amit@gmail.com" <nadav.amit@gmail.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 15, 2023, Wei W Wang wrote:
> On Thursday, June 15, 2023 5:21 AM, Sean Christopherson wrote:
> > Ah, crud.  The above highlights something I missed in v3.  The memslot NOWAIT
> > flag isn't tied to FOLL_NOWAIT, it's really truly a "fast-only" flag.  And even
> > more confusingly, KVM does set FOLL_NOWAIT, but for the async #PF case,
> > which will get even more confusing if/when KVM uses FOLL_NOWAIT internally.
> > 
> > Drat.  I really like the NOWAIT name, but unfortunately it doesn't do what as the
> > name says.
> > 
> > I still don't love "fast-only" as that bleeds kernel internals to userspace.
> > Anyone have ideas?  Maybe something about not installing new mappings?
> 
> Yes, "NOWAIT" sounds a bit confusing here. If this is a patch applied to userfaultfd
> to solve the "wait" issue on queuing/handling faults, then it would make sense.
> But this is a KVM specific solution, which is not directly related to userfaultfd, and
> it's not related to FOLL_NOWAIT. There seems nothing to wait in the KVM context
> here.
> 
> Why not just name the cap as what it does (i.e. something to indicate the cap of
> having the fault exited to userspace to handle), e.g. KVM_CAP_EXIT_ON_FAULT
> or KVM_CAP_USERSPACE_FAULT.

Because that's even further away from the truth when accounting for the fact that
the flag controls behavior when handling are *guest* faults.  The memslot flag
doesn't cause KVM to exit on every guest fault.  And USERSPACE_FAULT is far too
vague; KVM constantly faults in userspace mappings, the flag needs to communicate
that KVM *won't* do that for guest accesses.

Something like KVM_MEM_NO_USERFAULT_ON_GUEST_ACCESS?  Ridiculously verbose, but
I think it captures the KVM behavior, and "guest access" instead of "guest fault"
gives KVM some wiggle room, e.g. the name won't become stale if we figure out a
way to apply the behavior to KVM emulation of guest accesses in the future.
