Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58617171FF
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 01:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbjE3Xva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 19:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjE3Xv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 19:51:29 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0590B2
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 16:51:27 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-53f460cd829so2574744a12.1
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 16:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685490687; x=1688082687;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f3m0pzAsvXlgYHnj6/riFASoiQUxSwf8zHCe8kONnPE=;
        b=i+t8wS8Zzdk/DDGndM0RV6oXvH0DUsW3BQBz0afAbvrvBCZRTnw0QExXM0xewsE4Sc
         Ub7UYGm7yx5RGzcdxOz36sYqrc1R89xtuNCxJJ9FUHyQOurRENSZ6cnga14WQ7Py6VS+
         q5asCqVGEg2CYHANzOFLiOqmNZXP10Wk973Cj0P3XMBDGQq+VIWXKD2qFUtbFHa0E7hJ
         E8xWEHT3UFNEzms/L+4xnlIUixZTFEwsIvf9lJcYNDWnUhIlC/YjnKHTA5DwO8DGzenk
         xZQyA1yKnYAd6bvfA0h8qYxq8iIJ9DzA7pAl/zWAjJovHHO/VfnOiOT0/uuqpvJNMFPh
         yZtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685490687; x=1688082687;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f3m0pzAsvXlgYHnj6/riFASoiQUxSwf8zHCe8kONnPE=;
        b=N+PB1QVewWdme+n919mOkT+qKQ2s9cNb88H/4ducz/ejVcmL8gwFR0Vd04IDmYnWmG
         4y9wQhAd6nFqWusvbxpoHdhby38IdozM7FTL7pxRPLBP6kZrHgmgORSp1hR46fY4wPE4
         UstA6o2cdRv4zASxrNYCpaFi4yVIupPGi++JPFWjDAoPvEY2lqeFzFffC6czgtBW75rX
         F2ZdWOXQztVYNJUU8cHF6mPm1aQEyncJOnDs3xwQJu4yIMQgxXu0CI0uofKPkNDEBlUI
         sLPQULAKJRtLhaDORV0AOcZmvfvcnbUd3OKlBOBqMXvP4RJ/Ds7pWUB88WcZQtQ+OWV8
         UDAQ==
X-Gm-Message-State: AC+VfDx8Vr1eM+ZZkoShgd3l6Acl2CpooYa1QdV4eFu7BCUS4KEnqotx
        usiUPlV2sl5tgUJcpInlNBHvLp5ktoc=
X-Google-Smtp-Source: ACHHUZ7xijeo/wqnhPQqi9KgehH2vePJBm6Ksfl+fq79Bxn7xeyKXRn2NH7jTpSS4/+cIogX4Wd1YLt6zWQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5f16:0:b0:52c:8878:65dd with SMTP id
 t22-20020a635f16000000b0052c887865ddmr739097pgb.0.1685490687289; Tue, 30 May
 2023 16:51:27 -0700 (PDT)
Date:   Tue, 30 May 2023 16:51:25 -0700
In-Reply-To: <ZHXGWsw3ARk2OOjX@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230509134825.1523-1-yan.y.zhao@intel.com> <20230509135006.1604-1-yan.y.zhao@intel.com>
 <ZFsr9TynkA/CyPgg@chao-email> <ZFtQeLNuXP6tDMne@yzhao56-desk.sh.intel.com>
 <ZG1DhSdhpTkxrfCq@google.com> <ZG10zi6YtqGeik7u@yzhao56-desk.sh.intel.com>
 <ZG4kMKXKnQuQOTa7@google.com> <ZG807ECX4TeBcE61@yzhao56-desk.sh.intel.com>
 <ZG+Epwp75nJ7tpXM@google.com> <ZHXGWsw3ARk2OOjX@yzhao56-desk.sh.intel.com>
Message-ID: <ZHaL/d0XhoCmoo3q@google.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: add a new mmu zap helper to indicate
 memtype changes
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
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

On Tue, May 30, 2023, Yan Zhao wrote:
> On Thu, May 25, 2023 at 08:54:15AM -0700, Sean Christopherson wrote:
> And I combined the __kvm_mmu_honors_guest_mtrrs() into
> kvm_mmu_honors_guest_mtrrs(). Not sure if you like it :)

I would prefer to provide a separater inner helper, mainly so that the common
case callers don't need to pass %false.  I don't love passing bools, but it's
tolerable for a one-off use of an inner helper.

> +/*
> + * Returns if KVM honors guest MTRRs
> + * @override_vm_has_noncoherent_dma: Allow caller to override non-coherent DMA
> + *                                   status returned from
> + *                                   kvm_arch_has_noncoherent_dma()
> + */
> +bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm,
> +                               bool override_vm_has_noncoherent_dma)
> +{
> +       bool noncoherent_dma = override_vm_has_noncoherent_dma ? true :
> +                              kvm_arch_has_noncoherent_dma(kvm);

The "override" name is confusing, e.g. it won't be clear when it's safe/correct
for a new caller to override kvm_arch_has_noncoherent_dma().  If we go with a
single helper, I could live with:

bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool stopping_noncoherent_dma)
{
	bool noncoherent_dma = stopping_noncoherent_dma ||
			       kvm_arch_has_noncoherent_dma(kvm);

	...
}

but that makes it awkward to use common code for start+stop assignment, and as
above there are three "normal" callers that would have to pass magic %false
values regardless of the name.
