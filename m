Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242D67D125F
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 17:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377754AbjJTPNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 11:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377751AbjJTPNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 11:13:37 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21E61713
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 08:13:20 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5788445ac04so660043a12.2
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 08:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697814800; x=1698419600; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3V/dl8/M0q65AbM9FO9EXQIgvMQ5r2H2FMc2x5re+aA=;
        b=AuDI16ejjjXCH9Q0I42nhr+QU1e0EMxRBz5wUEzYxa0pbips90nHEIqI3ijK3HZjzW
         hvEtqSzE0oG/4nwLK5YiyuhyG2LG8okR4UAw82y0mKQ131jL05V4W++aqqhRKR5R54ru
         BLxtwhwDXFnje1rMOBPrURpNIyCxcn7qHXMALSQJjOIkCr3mbTwLyUQd97WOtL14uHdT
         heRuj0jo9PTfE1bHnU0XA6aAYWhys76+AnzHYxoeUflnEUCO0f5Bb/SXO0B8kcWxygp0
         XUSsNUhN9tMjnEOjabUX3mWN8DPiY1lDbStb66WwCQUHskprmFGz3aptltKwNtBTwPpC
         Acag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697814800; x=1698419600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3V/dl8/M0q65AbM9FO9EXQIgvMQ5r2H2FMc2x5re+aA=;
        b=qknlgiPPuasqyr1l0yafJqRhwaqx2yQoNJWtWV7knXqROnl/EiTqu0VRHIyF50Xoo7
         /3pwtWjKCRjWtyl3HnFUBxHnTHsd5PCCE48ZHWE/TfhRqR0Bnr1I8YoEMpiUltHEQyTj
         ja4clLB06cVl25VVzk6dm11O8o3/UFvjP67jA7brk7fuCzR5MhSIRItBkF3+LSYksThE
         CiK0hv0wBxQNjQyqwk9JwSB64c0QcAcLyV2+nzLswnJ6obfhiINPuVZjfvwTGlq9INYy
         fi7xKDckrRL9axQmhFNdD1ct2+8UHQCxDvYNpG27FS1UsbK7dpQLsGAtopyRhPUaqK89
         KHeA==
X-Gm-Message-State: AOJu0YygQWt0CSO2yfWshGk2nLWIm0VfD86/Nz2VhyY6HQOsZyRZCLJl
        JE7bvmy7ExJAc0rAx1MIaZ9+rWr5DnA=
X-Google-Smtp-Source: AGHT+IHj2CnltiuYTZGUURvallHU7NdpsdbRO5EASAoqLjOVj8l+CRE78eMRyOyK3JHzlnarHigshf8H7dA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d346:b0:1c6:d25:8730 with SMTP id
 l6-20020a170902d34600b001c60d258730mr54330plk.0.1697814799716; Fri, 20 Oct
 2023 08:13:19 -0700 (PDT)
Date:   Fri, 20 Oct 2023 08:13:18 -0700
In-Reply-To: <eea3a2f0-8aae-435e-b839-3f21c4a8e2e6@amd.com>
Mime-Version: 1.0
References: <20231016132819.1002933-49-michael.roth@amd.com>
 <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
 <ZS614OSoritrE1d2@google.com> <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
 <ZS_iS4UOgBbssp7Z@google.com> <924b755a-977a-4476-9525-a7626d728e18@amd.com>
 <ZTFD8y5T9nPOpCyX@google.com> <2034624b-579f-482e-8a7a-0dfc91740d7e@amd.com>
 <ZTHGPlTXvLnEDbmd@google.com> <eea3a2f0-8aae-435e-b839-3f21c4a8e2e6@amd.com>
Message-ID: <ZTKY18SvZ6lxMsF3@google.com>
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     Dionna Amalie Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        pankaj.gupta@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023, Alexey Kardashevskiy wrote:
> 
> On 20/10/23 11:13, Sean Christopherson wrote:
> > On Fri, Oct 20, 2023, Alexey Kardashevskiy wrote:
> > > Plus, GHCB now has to go via the userspace before talking to the PSP which
> > > was not the case so far (though I cannot think of immediate implication
> > > right now).
> > 
> > Any argument along the lines of "because that's how we've always done it" is going
> > to fall on deaf ears.  If there's a real performance bottleneck with kicking out
> > to userspace, then I'll happily work to figure out a solution.  If.
> 
> No, not performance, I was trying to imagine what can go wrong if multiple
> vcpus are making this call, all exiting to QEMU, in a loop, racing,
> something like this.

I am not at all concerned about userspace being able to handle parallel requests
to get a certificate.  Per-vCPU exits that access global/shared resources might
not be super common, but they're certainly not rare.  E.g. a guest access to an
option ROM can trigger memslot updates in QEMU, which requires at least taking a
mutex to guard KVM_SET_USER_MEMORY_REGION, and IIRC QEMU also uses RCU to protect
QEMU accesses to address spaces.

Given that we know there will be scenarios where certificates are changed/updated,
I wouldn't be at all surprised if handling this in userspace is actually easier
as it will give userspace more control and options, and make it easier to reason
about the resulting behavior.  E.g. userspace could choose between a lockless
scheme and a r/w lock if there's a need to ensure per-VM and global certs are
updated atomically from the guest's perspective.
