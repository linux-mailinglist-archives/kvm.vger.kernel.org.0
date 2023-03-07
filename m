Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3AD6AE661
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 17:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbjCGQYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 11:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjCGQYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 11:24:20 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0565B84
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 08:22:56 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id u14-20020a170902e5ce00b0019e3ce940b7so7966330plf.12
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 08:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678206176;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dzwmgXbEnaJ8WTXtlWlG70ogHYxoTpSYg1RXe33jVAI=;
        b=qK+gWWi+Xqy+bGVhNI9pTgKz39hYB5+g2ZK1dCBkS3IAxEky7An9FabS7+yE7w5WI1
         uvRno99WwDIc7iTOdxZatPXZ0R4DLDw/iJIeAJ58NVtwhfKt2MlQvzgdOceCpcR9gDgH
         ppH3981TQ59V+aK4G1VUSTrhO5gPCnaFENvbF5n2yZgaCWI/NKuqmw4OR2pXE2n6Ah/N
         K0GywXP/Qf2NyxfRhUaY39llY1qC0gCKH19abwEzqudrhjsKep5fsi7G7ZlitAa5cr4K
         HaOxZMjqrmvBsG1o03pBwYPdXS1d6FY8/JZ9DJzJN+x4v/0spijluclabyZvBuS+Me4p
         An0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678206176;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dzwmgXbEnaJ8WTXtlWlG70ogHYxoTpSYg1RXe33jVAI=;
        b=pTh0O6/NjJqDCZX2sO8clxXbrlZ7tk6CG7pHeiYwHyTrPTn88BH44rS2a706qid2kM
         de/M2f7IBULczNOO4BDv9Jzrn4s1eQ2O6FTXoy+Nf6ggyh2P7yxQ38ejIGrRHMIFto3E
         rhGJ7gGanB3lmfhCNqmxshwPTHk5XOAiRhaRel0HoZu9bMcxw/rSKTTUKkC7rIosNggr
         a1juyTdSnpGR6fgY5eQPfcXY5F3edA2Q8zjD3eJweon9YhHIzmId4ZY3M7uiorOFgWRD
         X5+BKEB0tttnK6hOoOjdv/XLMzNd4jYkLU74W7kDIi5uZNkWWU02K6Kh0nCDywlc+AoU
         DGEA==
X-Gm-Message-State: AO0yUKVW9zs+JAQ2RFp/nEabctRT8+hxgMDJGk4lsityRItUIdesFCuU
        ldCW9TCZzJ930Afzwg09obtsRjIdEsw=
X-Google-Smtp-Source: AK7set8XZeEvrGzd+hynG7/OVGG4afGZ126KRN2WkaqKocUe0BagLRl+LDFnHZ6s20eiKfSqAliDNs4jvfA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4e04:b0:239:d0ab:a7c9 with SMTP id
 n4-20020a17090a4e0400b00239d0aba7c9mr5301262pjh.4.1678206176146; Tue, 07 Mar
 2023 08:22:56 -0800 (PST)
Date:   Tue, 7 Mar 2023 08:22:54 -0800
In-Reply-To: <87cz5uko6r.fsf@secure.mitica>
Mime-Version: 1.0
References: <87o7qof00m.fsf@secure.mitica> <Y/fi95ksLZSVc9/T@google.com> <87cz5uko6r.fsf@secure.mitica>
Message-ID: <ZAdk3v5P/c4qpmLv@google.com>
Subject: Re: Fortnightly KVM call for 2023-02-07
From:   Sean Christopherson <seanjc@google.com>
To:     Juan Quintela <quintela@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Markus Armbruster <armbru@redhat.com>,
        Paul Moore <pmoore@redhat.com>, peter.maydell@linaro.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023, Juan Quintela wrote:
> Sean Christopherson <seanjc@google.com> wrote:
> > On Tue, Jan 24, 2023, Juan Quintela wrote:
> >> Please, send any topic that you are interested in covering in the next
> >> call in 2 weeks.
> >> 
> >> We have already topics:
> >> - single qemu binary
> >>   People on previous call (today) asked if Markus, Paolo and Peter could
> >>   be there on next one to further discuss the topic.
> >> 
> >> - Huge Memory guests
> >> 
> >>   Will send a separate email with the questions that we want to discuss
> >>   later during the week.
> >> 
> >> After discussions on the QEMU Summit, we are going to have always open a
> >> KVM call where you can add topics.
> >
> > Hi Juan!
> >
> > I have a somewhat odd request: can I convince you to rename "KVM call" to something
> > like "QEMU+KVM call"?
> >
> > I would like to kickstart a recurring public meeting/forum that (almost) exclusively
> > targets internal KVM development, but I don't to cause confusion and definitely don't
> > want to usurp your meeting.  The goal/purpose of the KVM-specific meeting would be to
> > do design reviews, syncs, etc. on KVM internals and things like KVM selftests, while,
> > IIUC, the current "KVM call" is aimed at at the entire KVM+QEMU+VFIO ecosystem.
> 
> I can do that.
> I would have told you that you could use our slots, but right now we are
> quite low on slots.
> 
> If nobody objects, I will change that for the next call.

Thanks, much appreciated!
