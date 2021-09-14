Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB38840B713
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 20:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhINSmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 14:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbhINSmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 14:42:38 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1479EC061762
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 11:41:21 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id k23so309722pji.0
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 11:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CZGAmbkitZy1k/EbPG4VZaALR8mUJkwDAJ+dhwnEfWA=;
        b=g0XsY+ZsxAS62v5OORPhKedEFaUPok0532gCaf35nYaW3Xo3uVIUpkYTkh/m8MKQX2
         JHSZRACscofgKlXYLwjExoXqvFEnzJNwUIWqwcOpMXquEUg8MTGk/vSM+81+7UgkGEu0
         Uky5wXvnhZFp+7zM0zZavFzxVBblL0+3EYUF1DYEd4bYo4BChp9xJj1Nn6fd2LP7AX+g
         2xFSKik3Fudqeki7Latt8irjFQXjYitD10ov4ymGe/ZENZ+Q/ffw/fu/rgq2DFSj72rx
         EVfrofp0tBcb6+a+Ok77h9Cf3ebzU3GILYloXI5gAZLvT6cidT4VOOOyKHZArylBqZWV
         LiaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CZGAmbkitZy1k/EbPG4VZaALR8mUJkwDAJ+dhwnEfWA=;
        b=AhISlXRv44BeqUaMnFgDT+GkfreO/4/bGvXUWElWv888ehr+iT08z8v63q/1COx/SN
         WX7MbDhfeqcJS0UdJZCqzbUQyWG/SqpQv3t76aC2h1v6eSPKnPq/YaxKRoJ1rSRC6kxI
         xnDeVAkq8PVCkTqDjcU0LKG7UMJrzZ2HfY8PgF9+WoT2lFUv+ow4ZReI4IssFOFYOGn/
         veoWq6/0H4YI48LdJKY+obLrwqtHnD7uibDzuUrwrFHiZESb1JxTcEl4Ic+Blt9yhU/S
         O/moPu604eJGy4HZeHgMldCa4MS0W3rXXn0c0n7CHWpP3UXvxsk0M2vJ1HdXl8Zzv36B
         fLAQ==
X-Gm-Message-State: AOAM533XrpogKsZhKOK6inWD3vDlwTKrOOF7CR6ykQ+bdaCHVeBzTDKl
        Y0dP0Y/16dF8+RZkvdkgmBxabuR3yLhaaQ==
X-Google-Smtp-Source: ABdhPJxutQ1GMW+J5gbp3HNJ6JRYL68/SsneQ7S3VEv4paQ8J4o2b7kmJu3ktKmvsaWglWEAw6Kbkg==
X-Received: by 2002:a17:902:c948:b0:13a:345c:917c with SMTP id i8-20020a170902c94800b0013a345c917cmr16428275pla.61.1631644880303;
        Tue, 14 Sep 2021 11:41:20 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 23sm12220414pgk.89.2021.09.14.11.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 11:41:19 -0700 (PDT)
Date:   Tue, 14 Sep 2021 18:41:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SEV: Disable KVM_CAP_VM_COPY_ENC_CONTEXT_FROM for
 SEV-ES
Message-ID: <YUDsy4W0/FeIEJDr@google.com>
References: <20210914171551.3223715-1-pgonda@google.com>
 <YUDcvRB3/QOXSi8H@google.com>
 <CAMkAt6opZoFfW_DiyJUREBAtd8503C6j+ZbjS9YL3z+bhqHR8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6opZoFfW_DiyJUREBAtd8503C6j+ZbjS9YL3z+bhqHR8Q@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-stable, for giggles

On Tue, Sep 14, 2021, Peter Gonda wrote:
> On Tue, Sep 14, 2021 at 11:32 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Sep 14, 2021, Peter Gonda wrote:
> > > Copying an ASID into new vCPUs will not work for SEV-ES since the vCPUs
> > > VMSAs need to be setup and measured before SEV_LAUNCH_FINISH. Return an
> > > error if a users tries to KVM_CAP_VM_COPY_ENC_CONTEXT_FROM from an
> > > SEV-ES guest.
> >
> > What happens if userspace does KVM_CAP_VM_COPY_ENC_CONTEXT_FROM before the source
> > has created vCPUs, i.e. before it has done SEV_LAUNCH_FINISH?
> 
> That's not enough. If you wanted to be able to mirror SEV-ES you'd
> also need to call LAUNCH_UPDATE_VMSA on the mirror's vCPUs before
> SEV_LAUNCH_FINISH. That is do-able but I was writing a small change to
> fix this bug. If mirroring of SEV-ES is wanted it's a much bigger
> change.

Is it doable without KVM updates?  If so, then outright rejection may not be the
correct behavior.

> > Might be worth noting that the destination cannot be an SEV guest, and therefore
> > can't be an SEV-ES guest either.
> 
> sev_guest() implies sev_es_guest() so I think this case is covered.

Yes, I was suggesting calling that out in the changelog so that readers/reviewers
don't worry about that case.

> > Cc: stable@vger.kernel.org

> Oops. I'll update in the V2 if needed. Added to this thread for now.

FWIW, you don't actually need to Cc stable, just including it in the changelog is
sufficient as the script automagic will pick it up when it hits Linus' tree.
