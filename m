Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3A152BE36
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 17:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239331AbiERPYo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 11:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239271AbiERPYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 11:24:42 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D10B19FB38
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 08:24:41 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id pq9-20020a17090b3d8900b001df622bf81dso2391229pjb.3
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 08:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=szkro6fdISr4qcgc9lEyo/uFlclALo3erp2QzJxCikU=;
        b=WEn/B+5uszz55r/PKscG7F+y/s63g6EhqVQOMb7gTzDGxqnsIsRkQUdRllj86Je5Qa
         R5FTIyo0p0XwKkd0yRVza3nOIGrmwQ9OAV3U+qCRkeEgV8TD9pzLv1vhkeKcGAV6mmRG
         Da1mDNow5BezEd5KGkDL8PQ8nSTKSKNuG67qgf/VALKpj65B1gLstbA9dXRqquvPXqFo
         aEmZtVjkOj+veHssXhLgcQCM4zzDcfwT3cwlCM/ljOEoe+TSXQTmZhfjmrPvBGu1yspX
         XA/t/Wy1QYxI8SY5QI/SmYf1/DPsdjBMiGUnR/zMxJblNghmG8yT0PbuV7x4VqKVWn26
         Ezmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=szkro6fdISr4qcgc9lEyo/uFlclALo3erp2QzJxCikU=;
        b=gL+iy702AHELAt5NoY86OndScH+CjvsN0YZ0H9FZLuAXPoDMVzeDolSxLEfUWTofDo
         +Y8LkWfoXjLqQn9cB1OXzNXcit69VXa/CgMnRaaDqR+8ukn5yYXQk4EPgdm2BTX6sOxP
         +giL/aQE1fGoTmocTzvdwkgLH2Pk9EsvGFkHBMG0j4+KVyO8b0sBXZeer4Ueb185g0bx
         hUWsHy0UsQDUx3xsA//BkeJP+akYSFZ8e/GFTOrN5AmNjl96usCcXY00OK1MXttRJKOp
         w09TAeCSbyzPf1Q6yFrJa9qIX5LipJy22oWa85iWqWLaz0FaCbU82BxqlxlRIYVcEzSa
         du5Q==
X-Gm-Message-State: AOAM531UZlgsfXVUNQ5bzy9zctWyN7R1HLvp7P4pTxxoYNeS2Nx760Ec
        LRrFbSC3N55UTv2CWUI2s80VDg==
X-Google-Smtp-Source: ABdhPJyy/X6OLFD75Kv+/AZvSZEz9mmRwSPAJr+OnVxPO+dnjQiE2gXn1ULCI8XWU0fEMi3sdAf7kA==
X-Received: by 2002:a17:903:244f:b0:15e:bb9a:3aa9 with SMTP id l15-20020a170903244f00b0015ebb9a3aa9mr237765pls.78.1652887480366;
        Wed, 18 May 2022 08:24:40 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x6-20020a17090a530600b001df54d74adbsm1732004pjh.25.2022.05.18.08.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 08:24:39 -0700 (PDT)
Date:   Wed, 18 May 2022 15:24:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 10/10] KVM: selftests: Add option to run
 dirty_log_perf_test vCPUs in L2
Message-ID: <YoUPtB0KtRuWl4p7@google.com>
References: <20220517190524.2202762-1-dmatlack@google.com>
 <20220517190524.2202762-11-dmatlack@google.com>
 <YoQDjx242f0AAUDS@xz-m1.local>
 <YoT5/TRyA/QKTsqL@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoT5/TRyA/QKTsqL@xz-m1.local>
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

On Wed, May 18, 2022, Peter Xu wrote:
> On Tue, May 17, 2022 at 04:20:31PM -0400, Peter Xu wrote:
> > On Tue, May 17, 2022 at 07:05:24PM +0000, David Matlack wrote:
> > > +uint64_t perf_test_nested_pages(int nr_vcpus)
> > > +{
> > > +	/*
> > > +	 * 513 page tables to identity-map the L2 with 1G pages, plus a few
> > > +	 * pages per-vCPU for data structures such as the VMCS.
> > > +	 */
> > > +	return 513 + 10 * nr_vcpus;
> > 
> > Shouldn't that 513 magic value be related to vm->max_gfn instead (rather
> > than assuming all hosts have 39 bits PA)?
> > 
> > If my math is correct, it'll require 1GB here just for the l2->l1 pgtables
> > on a 5-level host to run this test nested. So I had a feeling we'd better
> > still consider >4 level hosts some day very soon..  No strong opinion, as
> > long as this test is not run by default.
> 
> I had a feeling that when I said N level I actually meant N-1 level in all
> above, since 39 bits are for 3 level not 4 level?..
> 
> Then it's ~512GB pgtables on 5 level?  If so I do think we'd better have a
> nicer way to do this identity mapping..

Agreed, mapping all theoretically possible gfns into L2 is doomed to fail for
larger MAXPHYADDR systems.

Page table allocations are currently hardcoded to come from memslot0.  memslot0
is required to be in lower DRAM, and thus tops out at ~3gb for all intents and
purposes because we need to leave room for the xAPIC.

And I would strongly prefer not to plumb back the ability to specificy an alternative
memslot for page table allocations, because except for truly pathological tests that
functionality is unnecessary and pointless complexity.

> I don't think it's very hard - walk the mem regions in kvm_vm.regions
> should work for us?

Yeah.  Alternatively, The test can identity map all of memory <4gb and then also
map "guest_test_phys_mem - guest_num_pages".  I don't think there's any other memory
to deal with, is there?
