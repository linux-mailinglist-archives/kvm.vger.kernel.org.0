Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF0B6BF11A
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 19:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjCQSyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 14:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjCQSyS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 14:54:18 -0400
Received: from out-19.mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E5CDA
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 11:54:14 -0700 (PDT)
Date:   Fri, 17 Mar 2023 18:54:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679079252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xW3dFnai9Tv0aqGR5Okz6WZrsk5S4C1A//zEtUFkMXk=;
        b=VTeKLI5eioW6cfV7IbtruxLnMBTpXPiAgFZjy4Z2KjdjRkYnS03K4NhKo3N8iBIyoiMGDr
        bB6LK04+2G+rfoTNbtF8bgHp9J3SnFXILjL67p/vMSAKCBV4iaOcYpxUvqNq0sASE+uP6i
        25m12e6NGMtDGuc875OcCB+OMdIELEc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Anish Moorthy <amoorthy@google.com>, jthoughton@google.com,
        kvm@vger.kernel.org, maz@kernel.org
Subject: Re: [WIP Patch v2 00/14] Avoiding slow get-user-pages via memory
 fault exit
Message-ID: <ZBS3UbrWFZJzLzOq@linux.dev>
References: <20230315021738.1151386-1-amoorthy@google.com>
 <ZBSmz0JAgTrsF608@linux.dev>
 <ZBStyKk6H73/0z2r@google.com>
 <CALzav=dBJyr373jnBF_-uLJfZMwHOsKSVSR2u4xr83etjp6Daw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=dBJyr373jnBF_-uLJfZMwHOsKSVSR2u4xr83etjp6Daw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David,

On Fri, Mar 17, 2023 at 11:46:58AM -0700, David Matlack wrote:
> On Fri, Mar 17, 2023 at 11:13 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Mar 17, 2023, Oliver Upton wrote:
> > > On Wed, Mar 15, 2023 at 02:17:24AM +0000, Anish Moorthy wrote:
> > > > Hi Sean, here's what I'm planing to send up as v2 of the scalable
> > > > userfaultfd series.
> > >
> > > I don't see a ton of value in sending a targeted posting of a series to the
> > > list.
> 
> But isn't it already generating value as you were able to weigh in and
> provide feedback on technical aspects that you would not have been
> otherwise able to if Anish had just messaged Sean?

No, I only happened upon this series looking at lore. My problem is that
none of the affected maintainers or reviewers were cc'ed on the series.

> > > IOW, just CC all of the appropriate reviewers+maintainers. I promise,
> > > we won't bite.
> 
> I disagree. While I think it's fine to reach out to someone off-list
> to discuss a specific question, if you're going to message all
> reviewers and maintainers, you should also CC the mailing list. That
> allows more people to follow along and weigh in if necessary.

I think there may be a slight disconnect here :) I'm in no way encouraging
off-list discussion and instead asking that mail on the list arrives in
the right folks' inboxes.

Posting an RFC on the list was absolutely the right thing to do.

> >
> > +1.  And though I discourage off-list review, if something is really truly not
> > ready for public review, e.g. will do more harm than good by causing confusing,
> > then just send the patches off-list.  Half measures like this will just make folks
> > grumpy.
> 
> In this specific case, Anish very clearly laid out the reason for
> sending the patches and asked very specific directed questions in the
> cover letter and called it out as WIP. Yes "WIP" should have been
> "RFC" but other than that should anything have been different?

See above

-- 
Thanks,
Oliver
