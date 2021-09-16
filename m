Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82B140EA9E
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 21:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347013AbhIPTHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 15:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbhIPTHk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 15:07:40 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FF2C05BD32
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 12:00:47 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id o8so4539904pll.1
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 12:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gDle1D5qDlY1io3U/w9WI6fFvLYZB9m9Ur/yNTQt+70=;
        b=TFNc7J9JfrTCpgW2/kVBoKubQATYoDQyXmnnonwqB0SL39hFsbmZWswQP7EKvMDlPX
         5iAgDjJnygqRUFZtz0fqAL6m8npECs+T23ZVcfcfmyi/Wn7n4E2qxw3gTTXUL/3Orp6o
         94F2sN6KGdNXJkU4VMBtt0PhALBOuVuX2sjWOF6lfijdwXciVka45bYf4WU/Gz9C8I02
         du7Z1IGIspXAx6pIsF55QHi4U3exAVgbp6CXq5MBmEvToDAhLqVh+HmR0AHR8gRld25o
         QdiloMIxTcdQKnbT9w3x9wpgXD484NeLHlI8mCa3SZcfU8VgtYrRfufYdimsS05TyE8Q
         Pieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gDle1D5qDlY1io3U/w9WI6fFvLYZB9m9Ur/yNTQt+70=;
        b=L8HOt9YUrbC9fNih3H5MDFGQiKuoIIQyTRfwocv41K1wtieZlkqlzXT9Fh0sLRlxzC
         s2IeHsgyPta7Rn7HxwnHYUMwLzvgiaLMCTH4FSg4j0pL/Gvk2w6H5/h4sk1WX0KO8uFW
         bpcjcYq8VZGiFc9plmrXu5qUtx8wdMhu5+s0j8pTISpOQZBawiQ2kMtGWuvyBnyCVJig
         eQX5uGrjEMKvrLfHRag2rsRRLoTKlIBDJTAvsFICcEF/D6P3QB5MA6QdS9vBFdWYpWm3
         dCEMBSokLlzFtUxQTUpP0S9KOFTyM/eB4rShr8TTIiP+iT+s/PAuNU2Vmy7ay0mZMzyR
         Mg2w==
X-Gm-Message-State: AOAM531DN7Ml3zN6JnZzXPWUlweGJlGwEUQJZ5Edyiek9EwoazR9ArIS
        GRc+Qm970TbZ3FANFUXkKHsyKVZO1mtenuzryJRm7w==
X-Google-Smtp-Source: ABdhPJz8WFd7q3yrrn0b7IjuukIdRWzTN5grfcCF/fTtPqjRPmRKQuLgjQPFWOeKIThctEUUyqq7563jAfuUsiswctA=
X-Received: by 2002:a17:90a:4894:: with SMTP id b20mr7617153pjh.13.1631818847166;
 Thu, 16 Sep 2021 12:00:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210914171551.3223715-1-pgonda@google.com> <YUDcvRB3/QOXSi8H@google.com>
 <CAMkAt6opZoFfW_DiyJUREBAtd8503C6j+ZbjS9YL3z+bhqHR8Q@mail.gmail.com>
 <YUDsy4W0/FeIEJDr@google.com> <CAMkAt6r9W=bTzLkojjAuc5VpwJnSzg7+JUp=rnK-jO88hSKmxw@mail.gmail.com>
 <YUDuv1aTauPz9aqo@google.com> <8d58d4cb-bc0b-30a9-6218-323c9ffd1037@redhat.com>
 <CAMkAt6oPijfkPjT4ARpVmXfdczChf2k3ACBwK0YZeuGOxMAE8Q@mail.gmail.com>
 <9feed4e4-937e-2f11-bb56-0da5959c7dbd@redhat.com> <CAKiEG5oirC30Ga=mrzKq24mkwSYvbzMw9AVfL6epVG4O0EZE7A@mail.gmail.com>
In-Reply-To: <CAKiEG5oirC30Ga=mrzKq24mkwSYvbzMw9AVfL6epVG4O0EZE7A@mail.gmail.com>
From:   Nathan Tempelman <natet@google.com>
Date:   Thu, 16 Sep 2021 12:00:36 -0700
Message-ID: <CAKiEG5qJZ0kk-dZLLp853K634+hTFUEGDtzpQiGxqgoYqP+QAw@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Disable KVM_CAP_VM_COPY_ENC_CONTEXT_FROM for SEV-ES
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org,
        Steve Rutherford <srutherford@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 16, 2021 at 11:08 AM Nathan Tempelman <natet@google.com> wrote:
>
> On Wed, Sep 15, 2021 at 3:33 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 15/09/21 18:10, Peter Gonda wrote:
> > > svm_vm_copy_asid_from() {
> > >
> > >     asid = to_kvm_svm(source_kvm)->sev_info.asid;
> > > + handle = to_kvm_svm(source_kvm)->sev_info.handle;
> > > + fd = to_kvm_svm(source_kvm)->sev_info.fd;
> > > + es_active = to_kvm_svm(source_kvm)->sev_info.es_active;
> > >
> > > ...
> > >
> > >      /* Set enc_context_owner and copy its encryption context over */
> > >      mirror_sev = &to_kvm_svm(kvm)->sev_info;
> > >      mirror_sev->enc_context_owner = source_kvm;
> > >      mirror_sev->asid = asid;
> > >      mirror_sev->active = true;
> > > +  mirror_sev->handle = handle;
> > > +  mirror_sev->fd = fd;
> > > + mirror_sev->es_active = es_active;
> > >
> > > Paolo would you prefer a patch to enable ES mirroring or continue with
> > > this patch to disable it for now?
> >
> > If it's possible to enable it, it would be better.  The above would be a
> > reasonable patch for 5.15-rc.
> >
> > Paolo
> >
>
> +1. We don't have any immediate plans for sev-es, but it would be nice
> to have while we're here. But if you want to make the trivial fix I
> can come along and do it later.

+Steve Rutherford
