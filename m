Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6066BBD31
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 20:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbjCOTYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 15:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbjCOTXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 15:23:37 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F3B9AA19
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 12:23:21 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id pt5-20020a17090b3d0500b0023d3ffe542fso2138667pjb.0
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 12:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678908201;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CO8t+zxtFwLc3yJ6bJQPj8GStgQChto9AhidRXWbvKE=;
        b=AFfpyBBgddR4r+3JtnHbvcqmXuTkhpDMyp586u8nVhbO1w8OEZcY5uo/OF9V598ZLI
         4rHyH46ovKyA7lnhJHFG6xBBVxETLjL+X9IjtJQHUydXqo4ZUQ7Y5WwNClIPQ1Eh5lQZ
         zA5Knux19o9U5vhp9sOPU9amPjsWqVXPs766BYzKn+IlghB7VhRAkzLGqDz4B65bhhoA
         YNqCkknXtoi31iyHYeoVPj0mO+0gmInMgO4IEC2gwezvk4+y57uPy1bVDX0g88G2Wp9I
         7MVEgckhtqsD0i2BAz6dAWMWBZXBSPIf8Br/5Y4kjpfV2xKcxN6RAqv5yqcr4S5tRhFQ
         fCyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678908201;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CO8t+zxtFwLc3yJ6bJQPj8GStgQChto9AhidRXWbvKE=;
        b=ysjlR87AGJ8P+3pbQ0CME104UwS+dtDK7gN573NidRLPXynNMTlVgMpoMCMzohx6Iy
         sxpOqLoaOAj3eFk5YBnSKUTldYa1pA+9bL9ox3hcSV+cL5Vnnn1PsGW9HAkuF9ej0OdF
         TPtGCMmOPPNEE/jq5rvqRmCHIeSGIDrYJ6RXxzfRUY9Gt578ccVnCwBuX/xikK7qSMgz
         nCC8wdynuzM4N/2BdCCgeOhvpxDKNcGIDt97SQbNihnlqt5+t4XLuwOypLcC6J4m4eP4
         Ap6Ic9FojJQ0OLbFw9crDcqEBZEzEOvRwZ3TRTiQhEiuJ25IQoqOOAxmbqzQK7XfKJp6
         ky5w==
X-Gm-Message-State: AO0yUKXB3EOnQBeQbLtO9aajFr+EXlcSXaDMVREWr4qzQzgNOyM0JQAq
        sekuWvxLTHa6RCQAxsyJvRmlBFOj7Uc=
X-Google-Smtp-Source: AK7set/JY+rzlbShnVBele6OwSOSpHpEbwghpOgoGyd4CaLNRbbg6Pm7bxlVeohGsEhXPHXSQ02jqVfN9X8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f547:b0:19f:2164:9b3b with SMTP id
 h7-20020a170902f54700b0019f21649b3bmr261241plf.13.1678908201457; Wed, 15 Mar
 2023 12:23:21 -0700 (PDT)
Date:   Wed, 15 Mar 2023 12:23:20 -0700
In-Reply-To: <871f7c8b-0f54-7e9c-4253-b3878b010bbf@intel.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com> <20230311002258.852397-2-seanjc@google.com>
 <DS0PR11MB63733BCF5AEBBF5F38FD2C01DCB99@DS0PR11MB6373.namprd11.prod.outlook.com>
 <871f7c8b-0f54-7e9c-4253-b3878b010bbf@intel.com>
Message-ID: <ZBIQ1vxLs10UFi3R@google.com>
Subject: Re: [Intel-gfx] [PATCH v2 01/27] drm/i915/gvt: Verify pfn is "valid"
 before dereferencing "struct page"
From:   Sean Christopherson <seanjc@google.com>
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     Wei Wang <wei.w.wang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023, Andrzej Hajda wrote:
> On 13.03.2023 16:37, Wang, Wei W wrote:
> > On Saturday, March 11, 2023 8:23 AM, Sean Christopherson wrote:
> > > diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
> > > index 4ec85308379a..58b9b316ae46 100644
> > > --- a/drivers/gpu/drm/i915/gvt/gtt.c
> > > +++ b/drivers/gpu/drm/i915/gvt/gtt.c
> > > @@ -1183,6 +1183,10 @@ static int is_2MB_gtt_possible(struct intel_vgpu
> > > *vgpu,
> > >   	pfn = gfn_to_pfn(vgpu->vfio_device.kvm, ops->get_pfn(entry));
> > >   	if (is_error_noslot_pfn(pfn))
> > >   		return -EINVAL;
> > > +
> > > +	if (!pfn_valid(pfn))
> > > +		return -EINVAL;
> > > +
> > 
> > Merge the two errors in one "if" to have less LOC?
> > i.e.
> > if (is_error_noslot_pfn(pfn) || !pfn_valid(pfn))
> >      return -EINVAL;
> 
> you can just replace "if (is_error_noslot_pfn(pfn))" with "if
> (!pfn_valid(pfn))", it covers both cases.

Technically, yes, but the two checks are for very different things.  Practically
speaking, there can never be false negatives without KVM breaking horribly as
overlap between struct page pfns and KVM's error/noslot would prevent mapping
legal memory into a KVM guest.  But I'd rather not hide the "did KVM find a valid
mapping" in the "is this pfn backed by struct page" check, especially since this
code goes away entirely by the end of the series.
