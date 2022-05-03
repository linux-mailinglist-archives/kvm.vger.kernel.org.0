Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74EFE518661
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 16:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbiECOVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 10:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235673AbiECOVD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 10:21:03 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EDB27CCE
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 07:17:30 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id bv19so33732776ejb.6
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 07:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fbgMapne1rH6/kKlRXWbC6sN+d3viTII31UcYeBu5g4=;
        b=p5StzTBTAohsMwlL6jHQBWtTQobIcqESt3kLVZnkNHJSG2DdBFZF7Tgs5QaZmPnlCr
         F1l8QZ0lnzdHlhRVHnwsSRNzlNALEMzZuSnQCxowMh6uXeXOg3ZbmSEabk7olar1pdpp
         9pZRvS+REXlThgWE/quskEMYIGVZw1x55jioiJE011eju4WdbP9ZextM5/dSqGnzJ/OA
         Ip3n3G3Q5wiRXN3pJWPKqD+r0Wk199FnUkUPdXWP8Vhe6xFQIDSvsecKYYscAjJp/an6
         Yukn9oKICYgAyT+VGWoiAnlgJf7HCdoInuF1DHTluTYZYb7iUxSiRZ05KmZ0heDnRw16
         aUzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fbgMapne1rH6/kKlRXWbC6sN+d3viTII31UcYeBu5g4=;
        b=XlCd8E/hqmXipF8wHhg1MSb8wo5aHpko5kmwQaiCP/3FGc/ZTL2KKrSmTaHulQ3/zl
         cj789UkbsC4+9M1dNgLHdej345sFwxA3gpbYOr4H/w7uRU9XvIrjHk/NkIaYHH2Kcz+3
         UO29X6mJexLrTZ8HY5emDJCuAxTtk68Uc9j77fg40D6VpeECh93Lmf4gEHsFQCp9DmB3
         OJZ4wTeBdDl7PtCyxho9ZiaglChDz7FOvOeN5sQ2t5nFO134Rv05EzntnVQQPi+TUO3z
         fXS17XVh+BvsUfLYBu42cfjsRCrjLOKFMVwjOX4ejCrtiJDZXEEj9c6HZXLetrRPuuJw
         uF+g==
X-Gm-Message-State: AOAM532vi9V72DRFrV9qCOrHDU9NFID5JSKRsKcVDG257x0Tup6l4bFy
        G9GFwbuoHj4p9KefNl/E+8zVhw==
X-Google-Smtp-Source: ABdhPJzSpQ9MzxynGtzoIUDLeJ/DfizCDd1t2kS5FNmZLRZhA9C+R6Uh6yCEZ5JtfHxxtU8soK6nAQ==
X-Received: by 2002:a17:906:d555:b0:6da:ac8c:f66b with SMTP id cr21-20020a170906d55500b006daac8cf66bmr15765063ejc.107.1651587448896;
        Tue, 03 May 2022 07:17:28 -0700 (PDT)
Received: from google.com (30.171.91.34.bc.googleusercontent.com. [34.91.171.30])
        by smtp.gmail.com with ESMTPSA id hg13-20020a1709072ccd00b006f3ef214df3sm4657306ejc.89.2022.05.03.07.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 07:17:28 -0700 (PDT)
Date:   Tue, 3 May 2022 14:17:25 +0000
From:   Quentin Perret <qperret@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 09/17] KVM: arm64: Tear down unlinked page tables in
 parallel walk
Message-ID: <YnE5dfaC3HpXli26@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-10-oupton@google.com>
 <YmFactP0GnSp3vEv@google.com>
 <YmGJGIrNVmdqYJj8@google.com>
 <YmLRLf2GQSgA97Kr@google.com>
 <YmMTC2f0DiAU5OtZ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmMTC2f0DiAU5OtZ@google.com>
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

On Friday 22 Apr 2022 at 20:41:47 (+0000), Oliver Upton wrote:
> On Fri, Apr 22, 2022 at 04:00:45PM +0000, Quentin Perret wrote:
> > On Thursday 21 Apr 2022 at 16:40:56 (+0000), Oliver Upton wrote:
> > > The other option would be to not touch the subtree at all until the rcu
> > > callback, as at that point software will not tweak the tables any more.
> > > No need for atomics/spinning and can just do a boring traversal.
> > 
> > Right that is sort of what I had in mind. Note that I'm still trying to
> > make my mind about the overall approach -- I can see how RCU protection
> > provides a rather elegant solution to this problem, but this makes the
> > whole thing inaccessible to e.g. pKVM where RCU is a non-starter.
> 
> Heh, figuring out how to do this for pKVM seemed hard hence my lazy
> attempt :)
> 
> > A
> > possible alternative that comes to mind would be to have all walkers
> > take references on the pages as they walk down, and release them on
> > their way back, but I'm still not sure how to make this race-safe. I'll
> > have a think ...
> 
> Does pKVM ever collapse tables into blocks? That is the only reason any
> of this mess ever gets roped in. If not I think it is possible to get
> away with a rwlock with unmap on the write side and everything else on
> the read side, right?
> 
> As far as regular KVM goes we get in this business when disabling dirty
> logging on a memslot. Guest faults will lazily collapse the tables back
> into blocks. An equally valid implementation would be just to unmap the
> whole memslot and have the guest build out the tables again, which could
> work with the aforementioned rwlock.

Apologies for the delay on this one, I was away for a while.

Yup, that all makes sense. FWIW the pKVM use-case I have in mind is
slightly different. Specifically, in the pKVM world the hypervisor
maintains a stage-2 for the host, that is all identity mapped. So we use
nice big block mappings as much as we can. But when a protected guest
starts, the hypervisor needs to break down the host stage-2 blocks to
unmap the 4K guest pages from the host (which is where the protection
comes from in pKVM). And when the guest is torn down, the host can
reclaim its pages, hence putting us in a position to coallesce its
stage-2 into nice big blocks again. Note that none of this coallescing
is currently implemented even in our pKVM prototype, so it's a bit
unfair to ask you to deal with this stuff now, but clearly it'd be cool
if there was a way we could make these things coexist and even ideally
share some code...
