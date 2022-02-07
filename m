Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1BA4ACAF1
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 22:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbiBGVLS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 16:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236956AbiBGVLR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 16:11:17 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77C1C06173B
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 13:11:16 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id m7so14136726pjk.0
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 13:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mY36jQoI3AeEpImpGbyA/M9MR4iWOBkhSAzAs5FaCso=;
        b=iiF4k2W8hbjV2+HFx+leUb5dsq67tw1p2mhsIwDG+qbZcFYL8rjLwIXsrbvieG/ECq
         xTKAG97Uif4lRusOAko4kS4g7LBifZ965F8YrIJi8Ooa/f9XdorJYkOQz5BolSvuUp8M
         BR83sXEafCFi5Y19OUCiFaYXCw8JSZt5BySgYVZRaIcxm8mPQ2nqA68WhlenoryJ3kJ0
         wnRVxX5tAkCy5TW+RqOVbc9Ts0ESP5URir4zEsL5W3PB0n/ilS7DYBYR8wU2SDd2s9af
         o2e1lw+GmwOJM51nvFMcVzX5dxyeoB8VRWwo7IphJcGqE9Tf+0PR8+yts3IoAq2Pz9qm
         a/lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mY36jQoI3AeEpImpGbyA/M9MR4iWOBkhSAzAs5FaCso=;
        b=U3H7HPuitcYSpKO0VHHlYF3oDR6mIvGM9LWvOA3c8vekCK9LPyZTMeijHFCEwM1z64
         c28xUuVRe/1CtwSmJqTLPxnn1WwP0MRSJB5GOihHa+tbOZPx5Qpu1dqmnSDzlYE3sYpP
         9y11DskUkogBJHJeY8NImhAqhtYOM1b8fiYNteJRNy2sPOvdA8XoMKdoztUjMNeBEf4+
         eXJh090MM0XyznzeyMIZkbDFji4qPixzRJ48gCkaO59Rfjit4AsZAgYokZHcE0yyM8Mm
         bi/wpzV4RQt+MIxu3vWJpC63MdFfxj/b7V+uDsQdluJu8GL6BkVzNlrS1VUQezt4iRl8
         M7tQ==
X-Gm-Message-State: AOAM533kAVFSzMaky23uJwfYZjTCEx/3/9UFfDGCkeNeIPBaVEoN0k2j
        s7NgCBCJy4YWfrES0TmEn8sCjA==
X-Google-Smtp-Source: ABdhPJwRj5B5xRCZreBuzLK3m15YKjOo7BejQBR37/7E/NdGI49loxL4hC7zaPcamnCi7vL7ZdbiQA==
X-Received: by 2002:a17:902:a508:: with SMTP id s8mr1471406plq.173.1644268276138;
        Mon, 07 Feb 2022 13:11:16 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l2sm250638pju.52.2022.02.07.13.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 13:11:15 -0800 (PST)
Date:   Mon, 7 Feb 2022 21:11:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Orr <marcorr@google.com>
Cc:     Joerg Roedel <jroedel@suse.de>,
        Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bp@suse.de
Subject: Re: [kvm-unit-tests 02/13] x86: AMD SEV-ES: Setup #VC exception
 handler for AMD SEV-ES
Message-ID: <YgGK8Fx3f2pIdtHg@google.com>
References: <20220120125122.4633-1-varad.gautam@suse.com>
 <20220120125122.4633-3-varad.gautam@suse.com>
 <CAA03e5FbSoRo9tXwJocBtZHEc7xisJ3gEFuOW0FPvchbL9X8PQ@mail.gmail.com>
 <Yf0GO8EydyQSdZvu@suse.de>
 <CAA03e5HnyqZqDOyK8cbJgq_-zMPYEcrAuKr_CF8+=3DeykfV5A@mail.gmail.com>
 <Yf1UqmkfirgX1Nl+@google.com>
 <CAA03e5G19K12UAt-1JLWXK2QEy2rSLDtzrj0LCv-DL1bYXOAsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA03e5G19K12UAt-1JLWXK2QEy2rSLDtzrj0LCv-DL1bYXOAsA@mail.gmail.com>
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

On Fri, Feb 04, 2022, Marc Orr wrote:
> On Fri, Feb 4, 2022 at 8:30 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Feb 04, 2022, Marc Orr wrote:
> > > On Fri, Feb 4, 2022 at 2:55 AM Joerg Roedel <jroedel@suse.de> wrote:
> > > >         3) The firmware #VC handler might use state which is not
> > > >            available anymore after ExitBootServices.
> > >
> > > Of all the issues listed, this one seems the most serious.
> > >
> > > >         4) If the firmware uses the kvm-unit-test GHCB after
> > > >            ExitBootServices, it has the get the GHCB address from the
> > > >            GHCB MSR, requiring an identity mapping.
> > > >            Moreover it requires to keep the address of the GHCB in the
> > > >            MSR at all times where a #VC could happen. This could be a
> > > >            problem when we start to add SEV-ES specific tests to the
> > > >            unit-tests, explcitily testing the MSR protocol.
> > >
> > > Ack. I'd think we could require tests to save/restore the GHCB MSR.
> > >
> > > > It is easy to violate this implicit protocol and breaking kvm-unit-tests
> > > > just by a new version of OVMF being used. I think that is not a very
> > > > robust approach and a separate #VC handler in the unit-test framework
> > > > makes sense even now.
> > >
> > > Thanks for the explanation! I hope we can keep the UEFI #VC handler
> > > working, because like I mentioned, I think this work can be used to
> > > test that code inside of UEFI. But I guess time will tell.
> > >
> > > Of all the points listed above, I think point #3 is the most
> > > concerning. The others seem like they can be managed.
> >
> >   5) Debug.  I don't want to have to reverse engineer assembly code to understand
> >      why a #VC handler isn't doing what I expect, or to a debug the exchanges
> >      between guest and host.
> 
> Ack. But this can also be viewed as a benefit. Because the bug is
> probably something that should be followed up and fixed inside of
> UEFI.

But how would we know it's a bug?  E.g. IMO, UEFI should be enlightened to _never_
take a #VC, at which point its #VC handle can be changed to panic and using such a
UEIF would cause KUT to fail.

> And that's my end goal. Can we reuse this work to test the #VC handler
> in the UEFI?
> 
> This shouldn't be onerous. Because the #VC should follow the APM and
> GHCB specs. And both UEFI and kvm-unit-tests #VC handlers should be
> coded to those specs. If they're not, then one of them has a bug.
> 
> > On Thu, Jan 20, 2022 at 4:52 AM Varad Gautam <varad.gautam@suse.com> wrote:
> > > If --amdsev-efi-vc is passed during ./configure, the tests will
> > > continue using the UEFI #VC handler.
> >
> > Why bother?  I would prefer we ditch the UEFI #VC handler entirely and not give
> > users the option to using anything but the built-in handler.  What do we gain
> > other than complexity?
> 
> See above. If we keep the ability to run off the UEFI #VC handler then
> we can get continuous testing running inside of Google to verify the
> UEFI used to launch every SEV VM on Google cloud.

I'm not super opposed to the idea, but I really do think that taking a #VC in
guest UEFI is a bug in and of itself.
