Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A264EE128
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 20:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbiCaS42 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 14:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbiCaS4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 14:56:25 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840AB192364
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 11:54:37 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso299568pjb.5
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 11:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=vZbAPWGN9V0RlMVjzg1tOoChQNAemwuMQ5l01UmKfNY=;
        b=nrCzaq/cVh5LW7SCeP3Cjb4/kKTnqd5v24caBsRPxMS6pDdRzYLTWc7wZstT7k5tkR
         hoXzBlvzXmUMfm1gAiK5mn15iDwLRi7qhc2wXmg4iHmumzFcm+QMZNQ3JGw5KKPYHtzE
         csU9w1gh3tz+qrqtqYF90GVLTBgGz4WPFi6yeRjaF8kwv1Fb/RNC7ghkK2V3j3hfQMME
         TaEqicAoqOwoDrycWXNeHCo2wOKcUEkFi6aLyD6+inabJDd5mMPC4tWMjl651JWVwBFq
         yq/1cSiEk3EI3ZOVZ9mw1Ry/hq89lHfo1lBTrLK5kR5JbMppO3b0vHIcCNqHMlK4fW43
         KiPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=vZbAPWGN9V0RlMVjzg1tOoChQNAemwuMQ5l01UmKfNY=;
        b=HDjzuFpHPqP+7cIPM2dyAFTManL7WDlA1q1yzUpzszXFq84pnKO04iwRimF4vYM6vo
         KsuSKlJEL7BquxyHdrS6GbzWxj0uonVqXM8F8k0mcVVFO41HbcbdqLbdvRQ0QEvPkLbc
         HhVHxRJr44qxGYTwEYN74+YxMRgtRkFRoIdVapg/P9e4pMQ8ob5AG37TRFwCBlGCBIeb
         fyfp8WZ87tO2DkQpk7ZNOhGp6aOKwxFHgQ+zxaBqfnf8syrNJcDHUteuVxuVGyC8G8WK
         8BlSD2TYNDv0+cJdcH6W1TRi0poOT42zeAO+oE2YxgUep7RE4m8WdUdltt/HcW6Joc08
         V5Pg==
X-Gm-Message-State: AOAM531ECTGtvhNhZyOfBIahToObKTztWy+et5qeS0Bm3optPpT89Bw9
        a6ZcBckQLEdqZpiAbyAuQslGrOMxgm3GSg==
X-Google-Smtp-Source: ABdhPJx0SKJzkJgs/GAEFHijnxQnWTMT8ju+mKvGCYcMuzaFRUdi+yUHD65+d4N/NZfqYbexIJeyfQ==
X-Received: by 2002:a17:902:c3c1:b0:156:1109:2383 with SMTP id j1-20020a170902c3c100b0015611092383mr6821493plj.64.1648752876777;
        Thu, 31 Mar 2022 11:54:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b25-20020a637159000000b00381fda49d15sm101188pgn.39.2022.03.31.11.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 11:54:35 -0700 (PDT)
Date:   Thu, 31 Mar 2022 18:54:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     Marc Orr <marcorr@google.com>, kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3] KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
Message-ID: <YkX46P6mn+BYWsv2@google.com>
References: <20220330182821.2633150-1-pgonda@google.com>
 <YkXgq7hez9gGcmKt@google.com>
 <CAA03e5EcApE8ZnHEwZdZ3ecxYvh1G3nF-YDU5mhZa-15QZ0tew@mail.gmail.com>
 <CAA03e5Ghw6rJ82GhGKW+sCDgDRpZPLmhq29Wgmd0H40nvbX+Rg@mail.gmail.com>
 <CAMkAt6qr7zwy2uG1EaoZyvXnXMZ7Ho-CxQvRpcuUCx8wiA+6UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMkAt6qr7zwy2uG1EaoZyvXnXMZ7Ho-CxQvRpcuUCx8wiA+6UQ@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 31, 2022, Peter Gonda wrote:
> On Thu, Mar 31, 2022 at 11:48 AM Marc Orr <marcorr@google.com> wrote:
> >
> > On Thu, Mar 31, 2022 at 10:40 AM Marc Orr <marcorr@google.com> wrote:
> > >
> > > On Thu, Mar 31, 2022 at 10:11 AM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > +Paolo and Vitaly
> > > >
> > > > In the future, I highly recommend using scripts/get_maintainers.pl.
> > > >
> > > > On Wed, Mar 30, 2022, Peter Gonda wrote:
> > > > > SEV-ES guests can request termination using the GHCB's MSR protocol. See
> > > > > AMD's GHCB spec section '4.1.13 Termination Request'. Currently when a
> > > > > guest does this the userspace VMM sees an KVM_EXIT_UNKNOWN (-EVINAL)
> > > > > return code from KVM_RUN. By adding a KVM_EXIT_SHUTDOWN_ENTRY to kvm_run
> > > > > struct the userspace VMM can clearly see the guest has requested a SEV-ES
> > > > > termination including the termination reason code set and reason code.
> > > > >
> > > > > Signed-off-by: Peter Gonda <pgonda@google.com>
> > > > >
> > > > > ---
> > > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > > index 75fa6dd268f0..5f9d37dd3f6f 100644
> > > > > --- a/arch/x86/kvm/svm/sev.c
> > > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > > @@ -2735,8 +2735,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
> > > > >               pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
> > > > >                       reason_set, reason_code);
> > > >
> > > > This pr_info() should be removed.  A malicious usersepace could spam the kernel
> > > > by constantly running a vCPU that requests termination.
> >
> > Though... this patch makes this pr_info redundant! Since we'll now
> > report this in userspace. Actually, I'd be OK to remove it.
> 
> I'll make this 2 patches. This current patch and another to rate limit
> this pr_info() I think this patch is doing a lot already so would
> prefer to just add a second. Is that reasonable?

I strongly prefer removing the pr_info() entirely.  As Marc pointed out, the
info is redundant when KVM properly reports the issue.  And worse, the info is
useless unless there's exactly one VM running.  Even then, it doesn't capture
which vCPU failed.  This is exactly why Jim, myself, and others, have been pushing
to avoid using dmesg to report guest errors.  They're helpful for initial
development, but dead weight for production, and if they're helpful for development
then odds are good that having proper reporting in production would also be valuable.

> > > Quoting the spec:
> > > The reason code set is meant to provide hypervisors with their own
> > > termination SEV-ES Guest-Hypervisor Communication Block
> > > Standardization reason codes. This document defines and owns reason
> > > code set 0x0 and the following reason codes (GHCBData[23:16]):
> > > 0x00 – General termination request
> > > 0x01 – SEV-ES / GHCB Protocol range is not supported.
> > > 0x02 – SEV-SNP features not supported
> >
> > Reading this again, I now see that "reason_set" sounds like "The
> > reason code is set". I bet that's how Sean read it during his review.
> > So yeah, this needs comments :-)!
> 
> I'll add comments but I agree with Marc. These are part of the GHCB
> spec so for the very specific SEV-ES termination reason we should
> include all the data the spec allows. Sounds OK?

Ugh, so "set" means "set of reason codes"?  That's heinous naming.  I don't have a
strong objection to splitting, but at the same time, why not punt it to userspace?
Userspace is obviously going to have to understand what the hell "set" means
anyways...
