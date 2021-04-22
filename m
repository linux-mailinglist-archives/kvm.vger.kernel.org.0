Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E9D367B27
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 09:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhDVHel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 03:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhDVHek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 03:34:40 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2369C06174A
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 00:34:05 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id z8so50675968ljm.12
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 00:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gEEBMhBSAcHjqpIEk9kFgoNJRNFl4oJ65WL8v6C0U/Q=;
        b=XaPSpzGVmkqEnmJDUT77EMq4WzCHQRYg1yM2aezvvn5ZehdvJNiAk5hyioPmv1LQNQ
         /belzPQmgfBGoGHDy+WpV45r8gF8SChbFyqVmHm06rX9ISBFFPLgIgCl1XPIU4yQ2Edm
         B+4mbb2rOKdfyqUIPfLPSRTgyQgmlXS9bMHlvWDXRKpkgAlzt3rFMOoLLPadU8FjrADy
         ER9moym8M466YphDdl5nwD7N+5/DngLMgnAUHtIIcnERRZmKmTD8hkwfLtvMQr9muDqG
         MrZ/p0J6bqUBBPbn9tA7l3Yv3G/bRY6oWhIJl+weuJzPQjNnm3nRwpaNyFKBwrNWub1h
         L7Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gEEBMhBSAcHjqpIEk9kFgoNJRNFl4oJ65WL8v6C0U/Q=;
        b=BgN4XQt/e5GajbXCDCtYDxN+BCqeWqeg6QqRf8Sxa8FEt/sRVBP/JL0ErzehUSjSc/
         c7TcHGmth6DDd+RoqwyXvJdWYqKvgaZW3lKWiqIPd/NN6JJ0hfk+f6liDNPxJX3C/Hco
         8vu/jzREjyWFxNdtQppP8hON14S4jDMiN1zTvXUxbtVQa9B/z2MQSEgVKohpc9zlqLrW
         Jq2QV+cEqn/SmgpNZgCa0SQkFWZaxMgmXEJxQy1TvdNbwNS1eKaODb6I1gJkAk8JJJP3
         nON6EpmuoYzLEAGjWw+MC2f21XE2NvqeixtmR10EOgZe+t9LFowWBmFG28GyKAPXIIsr
         gwVw==
X-Gm-Message-State: AOAM531Cde2+usnCy8PEmoTQFtiNBr9TAOXadsxKFTiOMghgnvyn417C
        2b2YY+UjtO19U8MQnysmcXtT5KlMtjGqvUoRqsjTjg==
X-Google-Smtp-Source: ABdhPJzM21a0QPKLw9KWd9aRpGtkmgDqKm5rlTq2WeW4y1O+2yPBHNvBaQv/qH7MZ1IFwlGCeydzjuiy6pXKTWze3p4=
X-Received: by 2002:a2e:91c3:: with SMTP id u3mr1614741ljg.106.1619076844002;
 Thu, 22 Apr 2021 00:34:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210422155355.471c7751@canb.auug.org.au> <124cf94f-e7f5-d6f3-7e7a-2685e1e7517f@redhat.com>
In-Reply-To: <124cf94f-e7f5-d6f3-7e7a-2685e1e7517f@redhat.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 22 Apr 2021 00:33:47 -0700
Message-ID: <CAHVum0eQX8+HCJ3F-G9nzSVMy4V8Cg58LtY=jGPRJ77E-MN1fQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the cgroup tree with the kvm tree
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
        KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021 at 11:34 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 22/04/21 07:53, Stephen Rothwell wrote:
> > Hi all,
> >
> > Today's linux-next merge of the cgroup tree got conflicts in:
> >
> >    arch/x86/kvm/svm/sev.c
> >
> > between commit:
> >
> >    9fa1521daafb ("KVM: SVM: Do not set sev->es_active until KVM_SEV_ES_INIT completes")
> >
> > from the kvm tree and commit:
> >
> >    7aef27f0b2a8 ("svm/sev: Register SEV and SEV-ES ASIDs to the misc controller")
> >
> > from the cgroup tree.
> >
> > I fixed it up (see below) and can carry the fix as necessary. This
> > is now fixed as far as linux-next is concerned, but any non trivial
> > conflicts should be mentioned to your upstream maintainer when your tree
> > is submitted for merging.  You may also want to consider cooperating
> > with the maintainer of the conflicting tree to minimise any particularly
> > complex conflicts.
> >
>
> Tejun, please don't commit patches to other tree without an Acked-by
> from the maintainer (which I wouldn't have provided, as the right way to
> go would have been a topic branch).
>
> Fortunately these patches are at the bottom of your tree.  If it's okay,
> I'll just pull from there "as if" you had provided a topic branch all
> the time.
>
> Thanks,
>
> Paolo
>

First of all, I am sorry that my patch series has caused this trouble to
all of you. I am not aware of the correct way to submit a patch series
which changes files in more than one maintainer's territory. Any
guidance for the future will be helpful.

Paolo, Stephen,
We need a little more fix in the sev_asid_free() function for Stephen's
changes to work correctly as es_active is used in that function also.

Is there a repo and branch where I can see the final state of merges
and then I can send my patch against that?

Thanks
Vipin
