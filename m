Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7209B5BD4BD
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 20:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiISS26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 14:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiISS2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 14:28:51 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0522442AD4
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 11:28:51 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q9so120172pgq.8
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 11:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=NP7EhhZKx6H5sIn1a9SU4sRt+0XSuyZNqZ/tN3b2mo0=;
        b=jXBI8o3TsWG0aeZB6YDRFBwVIn2+bkbanClZGXAK3gKwjce6PN/5CiAPzC8hppZb2E
         k5+4wDbeV2SXkZRrTsiqv39kAhwbYJcynVrLHkRjumETUAsiiU/2qZCyN7R2wvMgKm+z
         QmwSoRuWq8AATZZy+zdFmST/WRG8N6QfJmcsbDqmeeLUF05RfBCeEiIgiQ2lak13JBNG
         Qqax5rANikeuGVWAuQMkTVxVl7OiiEAEBW1HJuicnOfOGKMa18DrGIdENoi7zg1VKy31
         NU97yMvgIh2kSNPDELRCC8K0CKmO2LwNnTbdjHXCSh1eililGxSky2gJvX86lqNvDfvk
         RH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=NP7EhhZKx6H5sIn1a9SU4sRt+0XSuyZNqZ/tN3b2mo0=;
        b=Ssgi9Qodil6DAvTInqSm0l1SrWszFhBHwQtRNEa2oC6oW85uP2WMrJQIVnRWTQv8vJ
         /YXPVNxRa3LfLiofryLohhuYElQyYQsrxHasJeFN0aniP4GOjsKm43en4i/iULxhGx/w
         M4Gke66R9Okkx+8wGvEY6VPinURbc0h+XN7k5q59iwrZl7NMslLKauZrIQF1oxMI+sok
         cHdb9+z+FZXm3qJdKgapR+5j3MDWZEckI1m63ODdZq40M8RZygVnCv/JRkHwts3G38W9
         E8RPnPahBM8xFAaEs8k4/5on2MRqQ/1nWL2K4ivGtlfulJrn0YWo0WI35ZW2YVmNQuW3
         sy/g==
X-Gm-Message-State: ACrzQf1Q+eFKPmDkejSZImtNfUHx7/4JOqddU+N0D6/gMvAQI81B+3TH
        n+B/2Gqd7SvUhAkLVndNN3ixlA==
X-Google-Smtp-Source: AMsMyM4y6jxi9TY5TDIe4MF85ZLkZAr49dOv4HR1xbZ3wrfq+XU/0AsskfnyiUEg4RGco/eBsSsnGA==
X-Received: by 2002:a05:6a00:1ac6:b0:548:962b:4c50 with SMTP id f6-20020a056a001ac600b00548962b4c50mr19845246pfv.76.1663612130099;
        Mon, 19 Sep 2022 11:28:50 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id t3-20020a17090b018300b002030d596ff7sm6970253pjs.37.2022.09.19.11.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 11:28:49 -0700 (PDT)
Date:   Mon, 19 Sep 2022 11:28:46 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        pbonzini@redhat.com, rananta@google.com, dmatlack@google.com,
        bgardon@google.com, reijiw@google.com, axelrasmussen@google.com,
        oupton@google.com, alexandru.elisei@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH v6 00/13] KVM: selftests: Add aarch64/page_fault_test
Message-ID: <Yyi03sX5hx36M/Zr@google.com>
References: <20220906180930.230218-1-ricarkol@google.com>
 <166358370892.2832387.8903539023908338224.b4-ty@kernel.org>
 <Yyia9uqpaIm4JyH+@google.com>
 <87a66vl2tv.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a66vl2tv.wl-maz@kernel.org>
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

On Mon, Sep 19, 2022 at 05:57:16PM +0100, Marc Zyngier wrote:
> On Mon, 19 Sep 2022 17:38:14 +0100,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Mon, Sep 19, 2022, Marc Zyngier wrote:
> > > On Tue, 6 Sep 2022 18:09:17 +0000, Ricardo Koller wrote:
> > > > This series adds a new aarch64 selftest for testing stage 2 fault handling for
> > > > various combinations of guest accesses (e.g., write, S1PTW), backing sources
> > > > (e.g., anon), and types of faults (e.g., read on hugetlbfs with a hole, write
> > > > on a readonly memslot). Each test tries a different combination and then checks
> > > > that the access results in the right behavior (e.g., uffd faults with the right
> > > > address and write/read flag). Some interesting combinations are:
> > > > 
> > > > [...]
> > > 
> > > Given how long this has been around, I've picked this series up, applying
> > > Oliver's fixes in the process.
> > 
> > Any chance this can be undone?  A big reason why this is at v6 is
> > because of the common API changes, and due to KVM Forum I've
> > effectively had three working days since this was posted, and others
> > have probably had even less, i.e. lack of reviews on v6 isn't
> > because no one cares.
> 
> Hey, I'm still not back at work, and won't be for another week! But
> fair enough, if there is going to be a respin, I'd rather see that
> (and I'm less hung up on tests having been in -next for some time
> before sending out a PR that eventually reaches Linus).
> 
> > It's not the end of the world if we have to fix things up on top,
> > but we'd avoid a decent amount of churn if we can instead unwind and
> > do a v7.
> 
> No skin off my nose, as this leaves on its own topic branch. Now
> dropped.

Thank you both. Yes, this will make our lives easier (including getting
the changes internally).

Ricardo

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
