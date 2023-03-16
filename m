Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422A56BD9AD
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 20:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjCPT6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 15:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbjCPT6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 15:58:13 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B01C2DB2
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 12:57:31 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 204-20020a2514d5000000b00a3637aea9e1so2944258ybu.17
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 12:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678996646;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6hZkF2wD5S148YOwsLKgyhW8hSKyz5z+vIxAoDqNEoU=;
        b=ppopHHPSmlauEReZkK5sf465mFh6p3Uf5alXDjm/6jJiPejFz3RHB7aixjA2ozrvOi
         LjIiAi2RABPxvySD7Ql+1dTFgTiDAABrEGBxcuHmTvN2QnJJqaMEmm//EYMn+z2kO/bY
         CmbWGysimF0nov7NS8ciC0fRQ5IaNXJlk2BHJr3BmSi1LabFKkFEwy90ULpt9//mAQem
         ttXH3ONv2j2YWZoLkIcJ2UTDoJ6pR2hXdifOR4fdTv/7X7W4WnprLdJyiCr/i3PL3YKK
         allvt39YWr14dR2/4YRKS+ACYy7NUzOxfL0NeLmQ6PYa/DALfNx3f2DPgXpkhnnpw7b+
         UwgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678996646;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6hZkF2wD5S148YOwsLKgyhW8hSKyz5z+vIxAoDqNEoU=;
        b=zGzWll8tQN06enUu6XAUbu44yBHALxxUyhahB9HE3wkvDUV7WZvPMPdTDNjrve4VDt
         Z3d+3aXyORxI2+LJdq+zzEVVH1tbKduymngopSfD84hrnorjnDmRyb1byW9vWtSDLk/k
         Y06ONEI+MKlX/3fg+6S/PSfstRlICz2qeZUbaiMAZBg/+elA1vjPC0q0xufuGGbemuP3
         Ja4cTxpRDopLIbKH4n9azhvtNWy5NJEmccZQ/IPjZuXA6W2Tf+GbFdJnSt8ehqnGfitZ
         6cRpjcSYyvpDBeprbdhbQAxYFKZn7v7awOi1QoZ0KfJ/jUY0j+Ka74AKzJhY4ELUhMhy
         sYLg==
X-Gm-Message-State: AO0yUKXcCNqr1qsqt1kayN2o1QYL3mHI0/r7Uvdl1yxQxYNrCsNJulDq
        I0NhEWm3PVS4/jc59F94UjRIXxEJv80=
X-Google-Smtp-Source: AK7set90USqlvs8yez6D/amNzNA42LXhWOo0jeJaT0oOsHZyg7uk4XQQlogtskg3otXzxSL5LVe+YTvWptQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:208:b0:a98:bd27:91de with SMTP id
 j8-20020a056902020800b00a98bd2791demr28961776ybs.7.1678996646536; Thu, 16 Mar
 2023 12:57:26 -0700 (PDT)
Date:   Thu, 16 Mar 2023 19:57:24 +0000
In-Reply-To: <6b9e8589281c4d2bae46eba36f77afe7@huawei.com>
Mime-Version: 1.0
References: <20230316154554.1237-1-shameerali.kolothum.thodi@huawei.com>
 <ZBNLnp7c1JvDsmHm@google.com> <6b9e8589281c4d2bae46eba36f77afe7@huawei.com>
Message-ID: <ZBN0pFN/nF8G3fWl@google.com>
Subject: Re: [PATCH] KVM: Add the missing stub function for kvm_dirty_ring_check_request()
From:   Sean Christopherson <seanjc@google.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "gshan@redhat.com" <gshan@redhat.com>,
        "maz@kernel.org" <maz@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023, Shameerali Kolothum Thodi wrote:
> > From: Sean Christopherson [mailto:seanjc@google.com]
> > On Thu, Mar 16, 2023, Shameer Kolothum wrote:
> > > The stub for !CONFIG_HAVE_KVM_DIRTY_RING case is missing.
> > 
> > No stub is needed.  kvm_dirty_ring_check_request() isn't called from
> > common code,
> > and should not (and isn't unless I'm missing something) be called from arch
> > code
> > unless CONFIG_HAVE_KVM_DIRTY_RING=y.
> > 
> > x86 and arm64 are the only users, and they both select
> > HAVE_KVM_DIRTY_RING
> > unconditionally when KVM is enabled.
> 
> Yes, it is at present not called from anywhere other than x86 and arm64.
> But I still think since it is a common helper, better to have a stub.

Why?  It buys us nothing other than dead code, and even worse it could let a bug
that would otherwise be caught during build time escape to run time.
