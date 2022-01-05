Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397D6484BE6
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 02:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbiAEBA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 20:00:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48246 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233102AbiAEBA6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Jan 2022 20:00:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641344457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jqwuA6aKidckTkOxwxDl+GZO7PwsYFsIh6FOl+nF1Wc=;
        b=IlGBf7UpCe+HW9ncmFx9MiskfiroLaAXn+4Kww3Vwf4ROMA7bcnwU1sNril2WRtIhd6Amb
        k/C/tyku2W+6B3976Tbsq+ttigUc7VOpP8OwoOKJdPdokCsLI3WaeHpa7aYWZAf9j9DE2f
        4eTtGAm5EDdCy7jQi8EwArQj9k/powo=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-ODthPCquPg2mbHvrSIdg2w-1; Tue, 04 Jan 2022 20:00:56 -0500
X-MC-Unique: ODthPCquPg2mbHvrSIdg2w-1
Received: by mail-pf1-f197.google.com with SMTP id z1-20020a62d101000000b004ba56d990daso19425982pfg.13
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 17:00:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jqwuA6aKidckTkOxwxDl+GZO7PwsYFsIh6FOl+nF1Wc=;
        b=xDm0hXS60OkTyjZ5IMZp7hosKaAaYnuntrcRWPc7zLJJTeg8grHcTPu8Ov0sd1C4Q0
         L5HnJeEef1Mg6elpiherHzEP2PO2MAqHKURgNKLRzuu+aAy5masr7mtr1cnpgMwxZhIV
         fn+szQ8xIIg8wQt7idxKKSY5z6sMe11LdzoVSsMFjw2Vj3PW0zdSPPUkfvTfhrYSMGFT
         SoEt90Ej6TmE+wMDlkEAmUH+fTmtYE3KW2I0vUeMV1P1q+vm7nfvFTcOsjNrQ8drWOZ0
         z99S1nUhn0ZENoRtw5laO+p1mQTclA+Hh7w0aru93lxikfFzxnETfQeVtp/b7ki9diAI
         siVg==
X-Gm-Message-State: AOAM533AtsrfmkC/W3HRA41u1TrqFQhCT/kCTS+GmPwKFeI3gwGh9m2V
        xsMu0JxnPzDIKiLiE+fsj6Q0qWfXt7h2IH4w74NYubaNL3B9l5jMc/5cUYMEzmoG+hFSGPjiWcg
        aEz42CrHTbAJS
X-Received: by 2002:a63:8141:: with SMTP id t62mr47318897pgd.548.1641344455144;
        Tue, 04 Jan 2022 17:00:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyrt2bb9/jaE7DzzfFgTRzM202qn6COfmDa7IPVXNfcgqorfu3nH87ERSnZ6ppm0x0vggxJvg==
X-Received: by 2002:a63:8141:: with SMTP id t62mr47318875pgd.548.1641344454843;
        Tue, 04 Jan 2022 17:00:54 -0800 (PST)
Received: from xz-m1.local ([191.101.132.50])
        by smtp.gmail.com with ESMTPSA id q17sm475185pjp.2.2022.01.04.17.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 17:00:54 -0800 (PST)
Date:   Wed, 5 Jan 2022 09:00:46 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 04/13] KVM: x86/mmu: Factor out logic to atomically
 install a new page table
Message-ID: <YdTtviind8XTrRfv@xz-m1.local>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-5-dmatlack@google.com>
 <YdQiK2fbOfkQ77ku@xz-m1.local>
 <CALzav=dSHkEfA+G8EZO4tEdY7TXYB3DhxGb7Y=9ay_jC-S9Xpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALzav=dSHkEfA+G8EZO4tEdY7TXYB3DhxGb7Y=9ay_jC-S9Xpw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 04, 2022 at 10:26:15AM -0800, David Matlack wrote:
> On Tue, Jan 4, 2022 at 2:32 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Mon, Dec 13, 2021 at 10:59:09PM +0000, David Matlack wrote:
> > > +/*
> > > + * tdp_mmu_install_sp_atomic - Atomically replace the given spte with an
> > > + * spte pointing to the provided page table.
> > > + *
> > > + * @kvm: kvm instance
> > > + * @iter: a tdp_iter instance currently on the SPTE that should be set
> > > + * @sp: The new TDP page table to install.
> > > + * @account_nx: True if this page table is being installed to split a
> > > + *              non-executable huge page.
> > > + *
> > > + * Returns: True if the new page table was installed. False if spte being
> > > + *          replaced changed, causing the atomic compare-exchange to fail.
> > > + *          If this function returns false the sp will be freed before
> >
> > s/will/will not/?
> 
> Good catch. This comment is leftover from the RFC patch where it did
> free the sp.

With that fixed, feel free to add:

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu

