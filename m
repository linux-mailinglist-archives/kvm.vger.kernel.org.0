Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B115636E015
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 22:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240921AbhD1UIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 16:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbhD1UHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 16:07:47 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C068C061573
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 13:06:45 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d124so1727761pfa.13
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 13:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CAez7Qyq734BJY4fOHAHF9NJa5VleU6E2eJWVTM5cMY=;
        b=dNmj2jyG74w6+mYtabfMSjs7cBIPdUxTxmyj4CKo83J4WFnMPA+vAqYBOj3Xgtt6Vf
         RpoC4mfT2F0H1DdoBTKwS2P4EMiiDNEcHeo+PYiXLTKe/hU4nSTNbCALUq/+yC/Y8N5F
         T3/jL1RzGWLDE1Ba2vzaetcDUdgp7tVT9PTd6qt+vRBlSr6lqckrHsIdhgWHMRKesRWR
         sKGk01KaR6sUdjmDiJZVUAJ8hRY4p9OhtbPRGNQxLaKpZ9C3z5wzp6l3uQ07l/a2zGZ4
         RcjSGObbebNx5pknTQKC/2MuATCYEfrwBjUh46A+HbL/DvqeeIFhYwoJOxoKfvHaZ9eB
         mWoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CAez7Qyq734BJY4fOHAHF9NJa5VleU6E2eJWVTM5cMY=;
        b=QMWeJwcdkL7A8p/m0LVEVUp1MQie8pajce7dmH9x6EcWgmtBYtskSxcsLefJ/KBwUN
         oDyPBJ1JknWLaCtprR/3Dg2er9pyPXnonP81lf5C/Awe0IuN5nCcLUlc3UT7wdO/VNlV
         n8uCjqoFVmH0+4e0Gp1y5QFjnkSOXwZXB5M4WkFFP9PxmV/dZYFY7ohrWP6cE8+DxKvP
         hJYQygt+5afZEppfWsLm5AC5/i9gDBVRcuUSXZqKHhrrwhAbVWB3t3RzjLc/kzc6PPWn
         k/i/Vv2km/FyoQ3Hx2sj7zTJaQml536hlSOsU0nV/MPB6WPxhyMwz9jdV3Pwx6Cl5Ahi
         aPTw==
X-Gm-Message-State: AOAM532nTyUYXWgpWTZR9oJmavy/X+FSs5ywRTpoFz/eNN0CR//hs1d0
        pLCxQ/bh5Mcn/JOY9kih2bVEDg==
X-Google-Smtp-Source: ABdhPJx6CsUROTTzjBOZDTARdsQ0hVWsBEZk8B/IPbqUlZijhoakdsN71COq1doo9BY0qDhDa12OJw==
X-Received: by 2002:a63:40c1:: with SMTP id n184mr28334914pga.219.1619640404428;
        Wed, 28 Apr 2021 13:06:44 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id w7sm431182pff.208.2021.04.28.13.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 13:06:43 -0700 (PDT)
Date:   Wed, 28 Apr 2021 20:06:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Venu Busireddy <venu.busireddy@oracle.com>
Subject: Re: [PATCH v2 2/2] KVM: x86: add MSR_KVM_MIGRATION_CONTROL
Message-ID: <YInAT6MYU2N0tKSW@google.com>
References: <20210421173716.1577745-1-pbonzini@redhat.com>
 <20210421173716.1577745-3-pbonzini@redhat.com>
 <YIiMrWS60NuesU63@google.com>
 <CABayD+dKLTx5kQTaKASQkcam4OiHJueuL1Vf32soiLq=torg+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+dKLTx5kQTaKASQkcam4OiHJueuL1Vf32soiLq=torg+w@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021, Steve Rutherford wrote:
> On Tue, Apr 27, 2021 at 3:14 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Apr 21, 2021, Paolo Bonzini wrote:
> > > Add a new MSR that can be used to communicate whether the page
> > > encryption status bitmap is up to date and therefore whether live
> > > migration of an encrypted guest is possible.
> > >
> > > The MSR should be processed by userspace if it is going to live
> > > migrate the guest; the default implementation does nothing.
> > >
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > ---
> >
> > ...
> >
> > > @@ -91,6 +93,8 @@ struct kvm_clock_pairing {
> > >  /* MSR_KVM_ASYNC_PF_INT */
> > >  #define KVM_ASYNC_PF_VEC_MASK                        GENMASK(7, 0)
> > >
> > > +/* MSR_KVM_MIGRATION_CONTROL */
> > > +#define KVM_PAGE_ENC_STATUS_UPTODATE         (1 << 0)
> >
> > Why explicitly tie this to encryption status?  AFAICT, doing so serves no real
> > purpose and can only hurt us in the long run.  E.g. if a new use case for
> > "disabling" migration comes along and it has nothing to do with encryption, then
> > it has the choice of either using a different bit or bastardizing the existing
> > control.
> >
> > I've no idea if such a use case is remotely likely to pop up, but allowing for
> > such a possibility costs us nothing.
>
> Using a different bit sounds fine to me. It would allow us to avoid
> stuffing multiple meanings into a single bit, which would still happen
> even if we had a better name.

But there's only multiple meanings if we define the bit to be specific to
page encryption.  E.g. if the bit is KVM_READY_FOR_MIGRATION, then its meaning
(when cleared) is simply "please don't migrate me, I will die".  KVM doesn't
care _why_ the guest is telling userspace that it's not ready for migration, nor
does KVM care if userspace honors the indicator.
