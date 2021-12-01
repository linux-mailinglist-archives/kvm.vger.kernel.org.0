Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492AA46522B
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 16:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351215AbhLAP6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 10:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351160AbhLAP6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 10:58:44 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B35C061748
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 07:55:23 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id n12so64159442lfe.1
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 07:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xL/SpxsRDGwnkxLz+6BUFTtHIU21cRhV7c5wnSAq5Yw=;
        b=I9ghR7dt4Gsu2/sYeRlTJJVcMRtr/3zIlV90L93Rm2vWQQlekO0Gh/KlB+6MCE9mh/
         juwc6AzqEs6nuuZfCfIT0KtgAq4d8EPA+f1TyawHpHBGFqlagkI1HRMoaokxQe1oLeTI
         3+nwmHhW9uCJTy1yQjGwikexKvJy8O/+WwGbH4ni0za9FZKFfu/j2DiwCLI9vlWjz0Ck
         loIEZyFSE05BB2FEUebNqKkCSIs5xrOKRHLL+3SE/O2PRgpeOQY10NypbaUy18r5XAyx
         HpWpUZ2O9GxMYTvzRyByPETbnLA1n4a4CCXhzNR/9pJEWugmO5XVUH1hXskJbIQj+hge
         RnJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xL/SpxsRDGwnkxLz+6BUFTtHIU21cRhV7c5wnSAq5Yw=;
        b=N6AmeOJULKNBtiyDGDsRqI233QEgya8Wt3T/zBkjO/CRHsbpaioYw5cjzAiHOrxyDv
         6EKIlLn62kHFxqEoJFE86VSROiLGLRpckJr2TvR5ZjowwT4cJ91LyAmj9l/sI93A9ZJ2
         1S9j+gr3aGbfRYLUnB+DfFXfKLNixLfkjCE7LnADs0Y/Iaou7chIz/wfdtCB/2+d4RLD
         WMPXEd/S58KVnWIAFARINRbCnvyz4CnekjxxDiV7qE2IcwGGc1lqBMzc8aOXJLkW9b8a
         D/tQjU9fte/IzseFmAJe1rVT70BdgGkS0t7k0Ql3ME3qzER4r6bS3SSyI8nZWYo0OLSm
         S6kA==
X-Gm-Message-State: AOAM5300m1/6uQDcpYkagqgyh1Jmg3j39IjysxdCZkHYkCGzT+GpQBKs
        xg7Wjv+aVX9yJmMNeHQEjy9PiVBnesOL9jGnzXYPYg==
X-Google-Smtp-Source: ABdhPJy/+/3rg39jeP45zH9ymgRTv59GH1CjAnXh2e39aAzfNKAr8HYBD2a8dwlALIOyVHSFKkWKQev3T2wRxUjX9aw=
X-Received: by 2002:a05:6512:1148:: with SMTP id m8mr6362883lfg.456.1638374121401;
 Wed, 01 Dec 2021 07:55:21 -0800 (PST)
MIME-Version: 1.0
References: <20211123005036.2954379-1-pbonzini@redhat.com> <20211123005036.2954379-4-pbonzini@redhat.com>
 <YaVUBv9ILIkElc/2@google.com>
In-Reply-To: <YaVUBv9ILIkElc/2@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 1 Dec 2021 08:55:10 -0700
Message-ID: <CAMkAt6obMZp9hBS02-AxNLEeYfCs2vLu0dxpJUaP9mOfUGAxdA@mail.gmail.com>
Subject: Re: [PATCH 03/12] KVM: SEV: expose KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM capability
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 3:28 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Nov 22, 2021, Paolo Bonzini wrote:
> > The capability, albeit present, was never exposed via KVM_CHECK_EXTENSION.
> >
> > Fixes: b56639318bb2 ("KVM: SEV: Add support for SEV intra host migration")
> > Cc: Peter Gonda <pgonda@google.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Peter Gonda <pgonda@google.com>
