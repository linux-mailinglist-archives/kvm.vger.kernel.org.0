Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D92C40EA57
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240651AbhIPS4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243404AbhIPS4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:56:50 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CFFC0470DC
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:08:32 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id h3so6938917pgb.7
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fch+BCg3HR41ekUQjpG3GOdcfqruvNbMqhruqZCG9TM=;
        b=VU0JKe77kfS2lcfPh1Xksu/gXWYm5U2CRSHOjk5wD2KeQu276EK+jc2VnrC+wYEeAQ
         7vVV2DIqLaw6SSw7xvewUzVEXCYwUkOr7AW92q8SIXbhxYIvWTTDNohDSOt9JOjn49WO
         gm8tB1EP1n/uKUy6loqkqzZdzigOSa9I7wtKuRkve1V23pZ+1QYW4lJt8qrGllATObLl
         X4R1niqoSsq4NJujBzn2M19ZdG9tp2ls2rnqXmPpALn+mxXDCqxVbDwdjofWjJ/w7nQD
         owDwXSkc+7m/21ui1P/aysnEZptJ+ZTBKjaoTEhFnIkPt59+QZKwjjwsW7cvL0fpu8Fd
         ZvBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fch+BCg3HR41ekUQjpG3GOdcfqruvNbMqhruqZCG9TM=;
        b=aHAZncksf8REA9SghAzaVsXaIH0VgLZIww2j0leGlSl+Bw8OHv+6a8Ku/zafr7hs3O
         kksdUeWhJZQi8jzfExVz7nXpBY/Z9g3pEEVXZ/p+NPBfCwMSC7CeWaEk0MzS+7XEm8x0
         5lP5BYK2P+ToL2fEVNyRE3HtTRgXM8BsArIR1QdbuxoOgLGNAjqPAuqBZSs2HerJdzSw
         cG5ooWHuuo6jSE+ZSi7wzLnNPkw5XICAkDJP+KOc993YMmGjdT60Xa9Bve5UrLWyIzlX
         pHtPIyhFJUJTvH9lZCaEO3ZYj2cqitLf7Ftvf9J0vg9iYlp8tX5a9+Eg1z4J9Gs1p0ks
         0z8w==
X-Gm-Message-State: AOAM531r0Tgtc7a1hk9tb6snIPDCs7PNGebX1UxxY0qgGBrZ82bK5koh
        FnmiRvG4s5YDXL0hehx2ItNfuN2GNo8BWcNa/9cWggK/cZkWCg==
X-Google-Smtp-Source: ABdhPJyPKSbJBJFs3Yy9jFyd4gTJG/sE+FH3APZQjVELwURMUUYv1ahDn7xBjbzC+yIyaxKSPecp94leOoKZ9E1vipo=
X-Received: by 2002:a63:af4a:: with SMTP id s10mr6024367pgo.469.1631815712207;
 Thu, 16 Sep 2021 11:08:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210914171551.3223715-1-pgonda@google.com> <YUDcvRB3/QOXSi8H@google.com>
 <CAMkAt6opZoFfW_DiyJUREBAtd8503C6j+ZbjS9YL3z+bhqHR8Q@mail.gmail.com>
 <YUDsy4W0/FeIEJDr@google.com> <CAMkAt6r9W=bTzLkojjAuc5VpwJnSzg7+JUp=rnK-jO88hSKmxw@mail.gmail.com>
 <YUDuv1aTauPz9aqo@google.com> <8d58d4cb-bc0b-30a9-6218-323c9ffd1037@redhat.com>
 <CAMkAt6oPijfkPjT4ARpVmXfdczChf2k3ACBwK0YZeuGOxMAE8Q@mail.gmail.com> <9feed4e4-937e-2f11-bb56-0da5959c7dbd@redhat.com>
In-Reply-To: <9feed4e4-937e-2f11-bb56-0da5959c7dbd@redhat.com>
From:   Nathan Tempelman <natet@google.com>
Date:   Thu, 16 Sep 2021 11:08:21 -0700
Message-ID: <CAKiEG5oirC30Ga=mrzKq24mkwSYvbzMw9AVfL6epVG4O0EZE7A@mail.gmail.com>
Subject: Re: [PATCH] KVM: SEV: Disable KVM_CAP_VM_COPY_ENC_CONTEXT_FROM for SEV-ES
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021 at 3:33 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 15/09/21 18:10, Peter Gonda wrote:
> > svm_vm_copy_asid_from() {
> >
> >     asid = to_kvm_svm(source_kvm)->sev_info.asid;
> > + handle = to_kvm_svm(source_kvm)->sev_info.handle;
> > + fd = to_kvm_svm(source_kvm)->sev_info.fd;
> > + es_active = to_kvm_svm(source_kvm)->sev_info.es_active;
> >
> > ...
> >
> >      /* Set enc_context_owner and copy its encryption context over */
> >      mirror_sev = &to_kvm_svm(kvm)->sev_info;
> >      mirror_sev->enc_context_owner = source_kvm;
> >      mirror_sev->asid = asid;
> >      mirror_sev->active = true;
> > +  mirror_sev->handle = handle;
> > +  mirror_sev->fd = fd;
> > + mirror_sev->es_active = es_active;
> >
> > Paolo would you prefer a patch to enable ES mirroring or continue with
> > this patch to disable it for now?
>
> If it's possible to enable it, it would be better.  The above would be a
> reasonable patch for 5.15-rc.
>
> Paolo
>

+1. We don't have any immediate plans for sev-es, but it would be nice
to have while we're here. But if you want to make the trivial fix I
can come along and do it later.
