Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0843685F9
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 19:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238635AbhDVRbc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 13:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbhDVRb2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 13:31:28 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D04C061756
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 10:30:52 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id j18so73436506lfg.5
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 10:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BW8SV/DH+Hd+lRiZNd1pf62iBo2iQ9Y0qPuGyJQ35mA=;
        b=rdk2wopYDE0eWgLYwt73ZshFCETVmNf7SBznWmE2R94jyJkSHk6QOuYrWJiUgmHjdF
         jmdltOdVm3e+vt6Jj9ee+dVaRR8EF4NmeE+nMhiKl+0fbMMzfESshj2iJP6o3wdQcGUJ
         UnKlLXSHfQevKKqIpkJG/A02IDnmvltmxT7x+cCWcxKimi9OFIQGe6rxbAfsMQ2aiDN3
         K0bl63QpBRSb69zGx0nqIaJ4bChFQC+qoyh+ERxRu51tVQu1+bWH+jeHLvGpWEtwdsNS
         HEYb5aOVHOUWujUvxjg9nCl3R4kH0YWrfHGWSC5YG+zKpDVujEy/F6BH0cTb6tCdzxJj
         aIRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BW8SV/DH+Hd+lRiZNd1pf62iBo2iQ9Y0qPuGyJQ35mA=;
        b=bTjxXPI0jKxsncPRXrPxrZMuGCGuSe2iSFpyZh4Ki5vVdaUi5D8Y6FdPs/20V6Twig
         8/2d9uLxGUWMwkesWdc71ORblm9nQBkm7wFQ7Rn1v0lez+pemzVHpUpaIvxPrJZ96c6a
         7fhRaI6eGGcDRI4KhVChMY2FOCtAeoA6ZlANvO/MzI4CUF21Lyj1qgUdqnJapBP42Wjs
         rNt+UF2BgulYBswxh+lvEYJfC+W7/y2RrCpzEXO3efi/W+Uqnb2N3DHuGrw2kxOsXCrz
         7qF7oWyCLA5J/TzM6OXm2r8CB/087vp3lFaLNbEeOd4o4QDVWZavi6Y9tlRfcnckjdYG
         DqLg==
X-Gm-Message-State: AOAM532POnzcrJKt2NVXm+AE7XI6aZWSaeon3wlqajBVMkdh9xLGsymr
        GdcxdhRsE4fJ6Uvus6M5ujjC6mB5ThodsbOQW02Xhg==
X-Google-Smtp-Source: ABdhPJwVyT0CMNqbjZ5KC/EMc7MwR0KTKJxElOY3HK9AYnjWGn8QctOWGhEOI8p49uRRjxNG6O30lQHfUugj1ddAQrc=
X-Received: by 2002:ac2:4908:: with SMTP id n8mr3203044lfi.576.1619112650646;
 Thu, 22 Apr 2021 10:30:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210422155355.471c7751@canb.auug.org.au> <124cf94f-e7f5-d6f3-7e7a-2685e1e7517f@redhat.com>
 <CAHVum0eQX8+HCJ3F-G9nzSVMy4V8Cg58LtY=jGPRJ77E-MN1fQ@mail.gmail.com>
 <e6256bd5-ca11-13c1-c950-c4761edbcf4d@redhat.com> <CAHVum0cVMd-SxmjKAJyJXO7SR68GKXQ7WTqyqWVfq1MMVd+oLQ@mail.gmail.com>
 <13e21724-bbe5-0fb0-82b6-35f87fe4c639@redhat.com>
In-Reply-To: <13e21724-bbe5-0fb0-82b6-35f87fe4c639@redhat.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 22 Apr 2021 10:30:12 -0700
Message-ID: <CAHVum0e25jKjUPiQR5+QR4x9_4CzBWNzv3=95=PyZ75Y=JMYHw@mail.gmail.com>
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

On Thu, Apr 22, 2021 at 10:19 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 22/04/21 19:09, Vipin Sharma wrote:
> > On Thu, Apr 22, 2021 at 12:47 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >> You can check the current state of the merge in the queue branch of the
> >> KVM tree.  This is what I plan to merge if Tejun agrees.  That would be
> >> helpful indeed!
> >
> > Merge looks fine from my patch perspective. However, one thing is missing:
> >
> > In sev_guest_init() after sev_asid_free() call we should also write
> > set sev->es_false = false.
> >
> > Without this the main intent of Sean's patch will be missing in the merge.
>
> So this:
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 3539201278bd..2632852be856 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -224,7 +224,7 @@ static int sev_guest_init(struct kvm *kvm, struct
> kvm_sev_cmd *argp)
>         sev->es_active = es_active;
>         asid = sev_asid_new(sev);
>         if (asid < 0)
> -               return ret;
> +               goto e_no_asid;
>         sev->asid = asid;
>
>         ret = sev_platform_init(&argp->error);
> @@ -240,6 +240,8 @@ static int sev_guest_init(struct kvm *kvm, struct
> kvm_sev_cmd *argp)
>   e_free:
>         sev_asid_free(sev);
>         sev->asid = 0;
> +e_no_asid:
> +       sev->es_active = false;
>         return ret;
>   }
>
>
> Sounds good, I'll squash it and push to kvm.git.
>
> Paolo

Thanks. This looks good.
