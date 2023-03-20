Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A155A6C204D
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 19:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjCTStT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 14:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjCTSss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 14:48:48 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4946F3B21B
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 11:41:52 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id k17-20020a170902d59100b0019abcf45d75so7464384plh.8
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 11:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679337690;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AGeXag6D9kuvOFx10JcqNN4G7nzKqx8n4sK14frGlkY=;
        b=U9P4ktn0YkzcsNkjKO3O3Ey5KGceaGAI7p8ldXV5RZsiQx9D4pGgPcVlI5C5vcEaYi
         7ZFwggQRCDcnL66/e8kG6/yQPeRqQkJ7tSSaWU6/M4thn/MQl3cr4eFvjv3DTepgVjmP
         AfGzt3REUcyAZDjcMXz71BUJb0TOBK3sMUTx/VlSYrmtGgsDuO3EggSfIlYDOHw6+pBF
         BQNiej9HV/+MHQez+BeYly6UZuuNT4NgTYuIvFarBCrpOezD+q6wLcky0yinYb0u9QyT
         cr6jS7cjEoGgb1PSgJv0kqBU/GkCjFDI0qZz8inr6QOpPMZJnojb6MGHtuSCWIDBXJZK
         M9vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679337690;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AGeXag6D9kuvOFx10JcqNN4G7nzKqx8n4sK14frGlkY=;
        b=4dRaBBE8j6YFyzMwJdjM8msh3KvSnvx9eMSUTf5Ee9HQ/qbh1UYZMaw5PjlaNCradP
         5c6xSkk001svyV47nB0uetXTg0acdNqN2rJ0MLreiv4QXe9v3CLz0IEDdKmezWQW241W
         zIW2pO2tYODO0mrnNmrYE8+kDDcOb93eNHbBJMj/gSYcsoVijk1rm+cX5ZkLxZ88c+Wd
         AmF7GZeD40e4KXbdBPsTxB3mZwWc53/t5OSKI2CASRDd4xJjnroAeG979YdFoejbAEqE
         6E8YISuNEh3z46ufCNFdzQ2qdkdHNny4bEOdHtcI4KEhxQa2WEbhr7YPEmFRuhGyZQHE
         +xfQ==
X-Gm-Message-State: AO0yUKXqksJJn1mqkZRd6ymd+u+x+Mpbp8r7f7/A0lFEBwlQMfUPZ9jM
        Vu1PNyi5f7975FSko5dcHLBEoQkJi/E=
X-Google-Smtp-Source: AK7set/pLysGBEI7iu4qioNRYT41BiTPna9N6cshhvM7P4GCwyT22Eawv1P1/8/vvJ5fs130lwI3yr6ZPlY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:db09:b0:1a0:4be5:ccea with SMTP id
 m9-20020a170902db0900b001a04be5cceamr6937261plx.9.1679337690302; Mon, 20 Mar
 2023 11:41:30 -0700 (PDT)
Date:   Mon, 20 Mar 2023 11:41:28 -0700
In-Reply-To: <20230202182809.1929122-10-bgardon@google.com>
Mime-Version: 1.0
References: <20230202182809.1929122-1-bgardon@google.com> <20230202182809.1929122-10-bgardon@google.com>
Message-ID: <ZBio2Cs7UrkkilTc@google.com>
Subject: Re: [PATCH 09/21] KVM: x86/MMU: Move paging_tmpl.h includes to shadow_mmu.c
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>
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

First off, I apologize for not giving this feedback in the RFC.  I didn't think
too hard about the impliciations of moving paging_tmpl.h until I actually looked
at the code.

On Thu, Feb 02, 2023, Ben Gardon wrote:
> Move the integration point for paging_tmpl.h to shadow_mmu.c since
> paging_tmpl.h is ostensibly part of the Shadow MMU.

Ostensibly indeed.  While a simple majority of paging_tmpl.h is indeed unique to
the shadow MMU, all of the guest walker code needs to exist independent of the
shadow MMU.  And that code is signficant both in terms of lines of code, and
more importantly in terms of understanding its role in KVM at large.

This is essentially the same mess that eventually led the cpu_role vs. root_role
cleanup, and I think we should figure out a way to give paging_tmpl.h similar
treatment.  E.g. split paging_tmpl.h itself in some way.

Unfortunately, this is a sticking point for me.  If the code movement were minor
and/or cleaner in nature (definitely not your fault, simply the reality of the
code base), I might feel differently.  But as it stands, there is a lot of churn
to get to an endpoint that has significant flaws.

So while I love the idea of separating the MMU implementations from the common
MMU logic, because the guest walker stuff is a lynchpin of sorts, e.g. splitting
out the guest walker logic could go hand-in-hand with reworking guest_mmu, I don't
want to take this series as is.

Sadly, as much as I'm itching to dive in and do a bit of exploration, I am woefully
short on bandwidth right now, so all I can do is say no.  Sorry :-(
