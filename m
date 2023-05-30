Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B2E716C9B
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 20:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbjE3SgL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 14:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbjE3SgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 14:36:09 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1943FF9
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 11:36:04 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-64d429d817aso45503b3a.1
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 11:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685471763; x=1688063763;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6XQ/gIktcEeVAmZ0Yy2kcFyrfKA1jUU7OE4AsJDhQb0=;
        b=XNUMSWMExPxRFnlGDzZ4h2mpJexufL+vobGeCPeLQ42dHox54FlyEw8Fdl1IRQLmYr
         bLZehzMwiKd1iCEd3ccuztcJDNEs97afx7RNGJ7SwW/AgwTlMoSLxqPF0/gmkbil2ne1
         uTff4ISF12aVHlRrrp30Hs+X+vfWmPpzvqlWuPq7Z5D3dQV3XDXQRBn7TZahWOzScSOA
         302Os+a8X3HObDLpz4AEljbLNqfaeVtB1RvBV7DGnYwoc5KlS9+6KGWsTA2+TDf1hg3W
         h9knJmRwwoLO8OAXQuTCs+BchBgqdjH0Iyw7ZjvY0JepE3NWUTrFvpOY9s1Jc9zQbezn
         /Kdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685471763; x=1688063763;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6XQ/gIktcEeVAmZ0Yy2kcFyrfKA1jUU7OE4AsJDhQb0=;
        b=d1gBsEZzkFGsAm2I8rz0PiiLp4leyqikBg8yishk0xgHteKEUcFj9EpBnLthgloze7
         YIArTYudkH9ecAmAKiZgkW5U14dtzUIRUwHw+eJrisEh89weFL4fcs9Sag3pcBLZNkbt
         oSOEEXeXQ5Z7RU86i0HdWuBwideX9Yz3xVaew/gwK0UPIkvo1t98J+NFTF4mmWHE3xNk
         gDrC8tENZthcii+upvoJ95TPzmj7s4g55NCcIbg3vIH9f3qD1StfNYZlsZEVxmUBqCed
         cNp11Qly54OA9C7ed4C7/tqR2BmKmQs6BD1UdcddDHD2AtMO8m5+v5yCuUm6UHVgdVZ4
         5ToA==
X-Gm-Message-State: AC+VfDwiAiDN5ti5hTsDn9zLvNbhr3t1ZTcpuFfvvkTqjUsCa1Hd912X
        UAF19nZ/DkPx3GNHW+p7IStztUA4JiI=
X-Google-Smtp-Source: ACHHUZ5Lqt4Q5VecpSbF9YmBhbpRwU7rVjRTOgLSt92Y929Amo7LhcvUkLrb5yM+ccVmhwVn57QvNH3Wfk0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:ad5:b0:64f:b286:af7a with SMTP id
 c21-20020a056a000ad500b0064fb286af7amr1292227pfl.1.1685471763586; Tue, 30 May
 2023 11:36:03 -0700 (PDT)
Date:   Tue, 30 May 2023 11:36:01 -0700
In-Reply-To: <9fa11f06-bd55-b061-d16a-081351f04a13@gameservers.com>
Mime-Version: 1.0
References: <f023d927-52aa-7e08-2ee5-59a2fbc65953@gameservers.com>
 <ZGzoUZLpPopkgvM0@google.com> <44ba516b-afe0-505d-1a87-90d489f9e03f@gameservers.com>
 <bce4b387-638d-7f3c-ca9b-12ff6e020bad@vultr.com> <ZHEefxsu5E3BsPni@google.com>
 <9fa11f06-bd55-b061-d16a-081351f04a13@gameservers.com>
Message-ID: <ZHZCEUzr9Ak7rkjG@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     brak@gameservers.com
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023, Brian Rak wrote:
>=20
> On 5/26/2023 5:02 PM, Sean Christopherson wrote:
> > On Fri, May 26, 2023, Brian Rak wrote:
> > > On 5/24/2023 9:39 AM, Brian Rak wrote:
> > > > On 5/23/2023 12:22 PM, Sean Christopherson wrote:
> > > > > The other thing that would be helpful would be getting kernel sta=
ck
> > > > > traces of the
> > > > > relevant tasks/threads.=EF=BF=BD The vCPU stack traces won't be i=
nteresting,
> > > > > but it'll
> > > > > likely help to see what the fallocate() tasks are doing.
> > > > I'll see what I can come up with here, I was running into some
> > > > difficulty getting useful stack traces out of the VM
> > > I didn't have any luck gathering guest-level stack traces - kaslr mak=
es it
> > > pretty difficult even if I have the guest kernel symbols.
> > Sorry, I was hoping to get host stack traces, not guest stack traces.  =
I am hoping
> > to see what the fallocate() in the *host* is doing.
>=20
> Ah - here's a different instance of it with a full backtrace from the hos=
t:

Gah, I wasn't specific enough again.  Though there's no longer an fallocate=
() for
any of the threads', so that's probably a moot point.  What I wanted to see=
 is what
exactly the host kernel was doing, e.g. if something in the host memory man=
agement
was indirectly preventing vCPUs from making forward progress.  But that doe=
sn't
seem to be the case here, and I would expect other problems if fallocate() =
was
stuck.  So ignore that request for now.

> > Another datapoint that might provide insight would be seeing if/how KVM=
's page
> > faults stats change, e.g. look at /sys/kernel/debug/kvm/pf_* multiple t=
imes when
> > the guest is stuck.
>=20
> It looks like pf_taken is the only real one incrementing:

Drat.  That's what I expected, but it doesn't narrow down the search much.

> > Are you able to run modified host kernels?  If so, the easiest next ste=
p, assuming
> > stack traces don't provide a smoking gun, would be to add printks into =
the page
> > fault path to see why KVM is retrying instead of installing a SPTE.
> We can, but it can take quite some time from when we do the update to
> actually seeing results.=EF=BF=BD This problem is inconsistent at best, a=
nd even
> though we're seeing it a ton of times a day, it's can show up anywhere.=
=EF=BF=BD
> Even if we rolled it out today, we'd still be looking at weeks/months bef=
ore
> we had any significant number of machines on it.

Would you be able to run a bpftrace program on a host with a stuck guest?  =
If so,
I believe I could craft a program for the kvm_exit tracepoint that would ru=
le out
or confirm two of the three likely culprits.

Can you also dump the kvm.ko module params?  E.g. `tail /sys/module/kvm/par=
ameters/*`
