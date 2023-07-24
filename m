Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78DC8760155
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 23:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjGXVkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 17:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjGXVkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 17:40:10 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA8C126
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 14:40:06 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-563396c1299so4296254a12.2
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 14:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690234805; x=1690839605;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8BXNvlgPl86R5u1hRBm87aT1u2p7UCsAkEmDEcFG3FM=;
        b=WQVwrhACND8PT5c7alEIYasKcI4Gp7ux8sDxSBc+Z2bJbXkeTQ5jBOUHXIeOX7mlDT
         IA9pzFYjQzEITJml3F0PjSrEsUo05ZsNqrb8ZwrdQPd0nMVfILzegzYolD0BGNic81Gz
         s/fdxjhr9ssohjwdFcYBZFpTEIY+Cqf0ZgzvRQr8pLNrIFSvHblY82xsimwQ5Hoxpxag
         ZEchK0cmfSc5EC0KjP2jeYQcYdm/+0G52yT8+C/fGHF0OSFhlgDympjozQGmHyuKGxkf
         fMrqX+sFQNcqhs5SEIEVfG4p8fZpQ9QGuGj6l2J8Jvr1lkwN+TT1rHadFW5PB+D/1gaQ
         ICdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690234805; x=1690839605;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8BXNvlgPl86R5u1hRBm87aT1u2p7UCsAkEmDEcFG3FM=;
        b=Ophv0piF6z8lJ3wzoq+ZJrqcuJW8IPTpBnJ8v1LbsH8oUm/N3Eq5GdSRfpD0TCn5AE
         Pl03vGkPDEzNNZ2oDqKoUcsjm90U4yno/LPCsjIhZn/ixh0rjVUpDCzTO5FNKu38z+Kj
         gMZJMTL6vZxosa0QTLiQwACvLjbzEN18KE0EsQo12g6X/IQVHds083X74jp8brVFu7Gb
         lIozTmz+5YXW4lKRdR9UhEz4BVuEj1Qb91wk+poeFT2qTH4OKWtJmIKfVtOv8YCcS4/i
         YVH1ksvNctqlcxjgPp5N+b7wSgDXLL0WoU9PJvqZUs5wPjkxPKbAiMXA8qv7kwBM48jb
         deLA==
X-Gm-Message-State: ABy/qLaOYvb7ThIPXsOQa86zkU2yQYsgn5a8CwIKbJgaNHdfjVHwAqPC
        3Qar7QK1kyV7oXNNmd2B4nVPjRORrE4=
X-Google-Smtp-Source: APBJJlGr3Xi9CBngHaiIYWxM1PJJW9h3BT6/cv5dUH1y6ZztFyeHVEzhLcBu5fYxBfWr79u2kv7wLBA+Mcw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:32c3:b0:1b9:e338:a90d with SMTP id
 i3-20020a17090332c300b001b9e338a90dmr44909plr.3.1690234805271; Mon, 24 Jul
 2023 14:40:05 -0700 (PDT)
Date:   Mon, 24 Jul 2023 14:40:03 -0700
In-Reply-To: <20230724212150.GH3745454@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com> <20230721201859.2307736-15-seanjc@google.com>
 <20230724212150.GH3745454@hirez.programming.kicks-ass.net>
Message-ID: <ZL7vs9zMatFRl6IH@google.com>
Subject: Re: [PATCH v4 14/19] KVM: SVM: Check that the current CPU supports
 SVM in kvm_is_svm_supported()
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 24, 2023, Peter Zijlstra wrote:
> On Fri, Jul 21, 2023 at 01:18:54PM -0700, Sean Christopherson wrote:
> > Check "this" CPU instead of the boot CPU when querying SVM support so that
> > the per-CPU checks done during hardware enabling actually function as
> > intended, i.e. will detect issues where SVM isn't support on all CPUs.
> 
> Is that a realistic concern?

It's not a concern in the sense that it should never happen, but I know of at
least one example where VMX on Intel completely disappeared[1].  The "compatibility"
checks are really more about the entire VMX/SVM feature set, the base VMX/SVM
support check is just an easy and obvious precursor to the full compatibility
checks.

Of course, SVM doesn't currently have compatibility checks on the full SVM feature
set, but that's more due to lack of a forcing function than a desire to _not_ have
them.  Intel CPUs have a pesky habit of bugs, ucode updates, and/or in-field errors
resulting in VMX features randomly appearing or disappearing.  E.g. there's an
ongoing buzilla (sorry) issue[2] where a user is only able to load KVM *after* a
suspend+resume cycle, because TSC scaling only shows up on one socket immediately
after boot, which is then somehow resolved by suspend+resume.

[1] 009bce1df0bb ("x86/split_lock: Don't write MSR_TEST_CTRL on CPUs that aren't whitelisted")
[2] https://bugzilla.kernel.org/show_bug.cgi?id=217574
