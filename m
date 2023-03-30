Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4136D0EF7
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 21:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjC3Tht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 15:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbjC3Thr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 15:37:47 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A326195
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 12:37:46 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id w14-20020a170902e88e00b001a238a5946cso9167220plg.11
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 12:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680205066;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NkWLHZW0sQsmSN+6OnRpZy+vDJdcHjDc+c5diHQwuNM=;
        b=lg7Mqv7PwZJpz9bkaWubUTBK7nwFxEOmGodCBS0Zeqt/RCcb5TIrDGbOmw6HCP28/6
         Nh71oVjqUHYfAsK4hhOv7c67UOOUlUeyKXsm07+Fy8v9i+57dhO0aRdonrNnXUvirFVT
         mBVv7W+MBb3xW5no5hus0WEihXvkKlSiAgxS6RcGPk5LHBZwMV7zZAE3Cd+iQR82X9iw
         9KlwRZJhNwKASj1oeEbaWec1dudvFaYiMuaTyk4aeFv7J1k8LreuYMBzRBWXbphEM9LG
         5SvjeI2pi7qu+BdtKcdLk61mZJXWq6PuPZ/2tw6dupcbnLAtF5rmBCHzgzrdEj6guyIL
         9ahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680205066;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NkWLHZW0sQsmSN+6OnRpZy+vDJdcHjDc+c5diHQwuNM=;
        b=pKZw1aCgyHD4Y7+SuoydPvvhrp77XLdtuFMSUWVP26ZKaOY1Rk6GQfBTjIMQ0sbAiW
         XT0cdLqI/bA8PKYwrXamiNEcr8E0DAnquPj/7cjxeNW+JS8NSknQZzdonfEU8kCrtrZE
         UE6nfvFIspUJSr61zOOYUaWtIpvK4uH27f/FJz+61cIu4sj/eStDlzV/ur6A7jKv7JdU
         wGjvTz6ncadVPZYx7zB20sepVN3KEMZzIAQeWPvZxje9M0UB8ncxBDmTXKCjhBoYoW99
         X7X1E4p8u2xGIvPN8erNMuZ2rO4YWz4zhw+cQgzBqnAK5SFHcSQIFM7ah7T90fO0CvBg
         qorA==
X-Gm-Message-State: AAQBX9eOXu7Rg4HAimZNXkHTrByFxcokAFiFmPwlAKT8jmQkdH+kPFEw
        5qeTDgkLete2gZ/43c7U75s6u4hLQcs=
X-Google-Smtp-Source: AKy350ZhugBdBge6dVmLkF2+aGDettukZd1/SI5qNwtiDRyudPkp0xTio5VDPHnFN9mdpYJhiTfW8ocRaZI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:e104:0:b0:507:3e33:4390 with SMTP id
 z4-20020a63e104000000b005073e334390mr2160704pgh.6.1680205066070; Thu, 30 Mar
 2023 12:37:46 -0700 (PDT)
Date:   Thu, 30 Mar 2023 12:37:44 -0700
In-Reply-To: <754c052c-b575-4abc-605a-fff7d09c4a65@redhat.com>
Mime-Version: 1.0
References: <0dcae003-d784-d4e6-93a2-d8cc9a1e3bc1@redhat.com>
 <ZCSNasVg+HBK0vI1@google.com> <754c052c-b575-4abc-605a-fff7d09c4a65@redhat.com>
Message-ID: <ZCXlCHx0ti9LtXKx@google.com>
Subject: Re: The "memory" test is failing in the kvm-unit-tests CI
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Cole Robinson <crobinso@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023, Thomas Huth wrote:
> On 29/03/2023 21.11, Sean Christopherson wrote:
> > On Wed, Mar 29, 2023, Thomas Huth wrote:
> > > 
> > >   Hi,
> > > 
> > > I noticed that in recent builds, the "memory" test started failing in the
> > > kvm-unit-test CI. After doing some experiments, I think it might rather be
> > > related to the environment than to a recent change in the k-u-t sources.
> > > 
> > > It used to work fine with commit 2480430a here in January:
> > > 
> > >   https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/jobs/3613156199#L2873
> > > 
> > > Now I've re-run the CI with the same commit 2480430a here and it is failing now:
> > > 
> > >   https://gitlab.com/thuth/kvm-unit-tests/-/jobs/4022074711#L2733
> > 
> > Can you provide the logs from the failing test, and/or the build artifacts?  I
> > tried, and failed, to find them on Gitlab.
> 
> Yes, that's still missing in the CI scripts ... I'll try to come up with a
> patch that provides the logs as artifacts.
> 
> Meanwhile, here's a run with a manual "cat logs/memory.log":
> 
> https://gitlab.com/thuth/kvm-unit-tests/-/jobs/4029213352#L2726
> 
> Seems like these are the failing memory tests:
> 
> FAIL: clflushopt (ABSENT)
> FAIL: clwb (ABSENT)

More than likely what is happening is that the platform supports CLFLUSHOPT and
CLWB (possibly even via a ucode patch update), but the CPUID bits are not being
enumerated to the guest.  Neither VMX nor SVM has intercept controls for the
instructions, so KVM has no way to enforce the the guest's CPUID model.  E.g.
the failures can be reproduce by manually hiding the features:

  rkt ./x86/run x86/memory.flat -smp 1 -cpu max,-clflushopt,-clwb

This isn't a KVM bug because of the virtualization hole.  And really, the test
itself is bogus when running on KVM precisely because of said hole (similar holes
exist for all the other instructions in the test).

The test appears to have been added for QEMU's TCG, which makes sense as there
shouldn't be any virtualization holes in a pure emulation environment.

That said, it is interesting that the test is suddenly failing, as it means
something is buggy.  If you can run commands on the host, check for host support
via /proc/cpuinfo.  If those come back negative (no support), then it would appear
that hardware or the host kernel is in a bad/unexpected state.

  grep -q clflushopt /proc/cpuinfo 
  grep -q clwb /proc/cpuinfo 

