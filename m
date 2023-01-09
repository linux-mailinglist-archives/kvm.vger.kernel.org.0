Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC18066335F
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 22:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237726AbjAIVoB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 16:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238287AbjAIVn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 16:43:56 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FF025B
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 13:43:56 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id b24-20020a056602219800b006e2bf9902cbso5675183iob.4
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 13:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iab9jCZdR8ehewZ+m9QCW2S2L8M2fM8heELQ3h/B5KQ=;
        b=ZFx4WM8PfyHyyf1FErKejLn57ate4H1yL24rMw238JkXC17jozmX0IrC9KuqCgRjE8
         IPwnYVLT5nNNFUeZNsH5i/Y3o91aaospX7JgSvreIuM4h9P7Q1Mxkmb/89vRrAKlNXfF
         //0jug8SdLeVu/X8ZLQ6q/AgYxNgFiGKk6xy2S9TD85c8aozbAU6SUev1gEWoTrQWhGE
         lEEMcCt6x0vHnAmAYRQRw1GedDT769IDARDEqxhP/4s+pUbROmUG6csHY8fpNKafFaYz
         xaNq5inql7F9mXyex3sm1SMG7jWX8suQ2hrrIS4WfdFIdDnEfFAHMTaCM/+bY3WTMy6o
         Boqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iab9jCZdR8ehewZ+m9QCW2S2L8M2fM8heELQ3h/B5KQ=;
        b=IBRGzTzlEm8hucYvkvgb76bM4UE//Z8TwFaafmJC8HGVio1pEmppJLbCtAuwhSJ36G
         byxpH4RbD8qBh5Bc1rkD5mjJzpERQd43XfuNRNbslrK3SwDAP2KOeXfZjLS4oiGIK4BG
         /W3wLEPcAG/psfSqC8rhMzLhodGHNUNBATlykigNTDdamj6p6JY/iI1WHuZh2tGQ26NW
         GX61PJdR+YZdhkGCvp8TEPW3F8VZ5dLKcImL8fwVW9TZxIX+zOL272EQYYrwt6Kl02YQ
         1qKfLNkwO/egxImrEEWsEEfZCCOQ67bVa246G0BiYNt3Eorjs9E7+2JyDszoK35vMHNF
         JDRw==
X-Gm-Message-State: AFqh2krVaZrXApoXJaylVik9nx9RYLukUrJVH49zzQ424c7NilBq2uzb
        /6NkU4+H9r10MGVsRkgFWCVUw2K3exMsGm6gXQ==
X-Google-Smtp-Source: AMrXdXuX7qopHgej1X4oLk8fQABRD2N2FrKz6oxdc3fs/RoDjvBomz7KYLKTKq7xDQGQ7MYJiZJZJffzTFLERVF1Rg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a6b:e90c:0:b0:6e0:1f4a:f8d with SMTP
 id u12-20020a6be90c000000b006e01f4a0f8dmr5666359iof.85.1673300635440; Mon, 09
 Jan 2023 13:43:55 -0800 (PST)
Date:   Mon, 09 Jan 2023 21:43:54 +0000
In-Reply-To: <20230109085907.nklhxqz2vrfpengj@orel> (message from Andrew Jones
 on Mon, 9 Jan 2023 09:59:07 +0100)
Mime-Version: 1.0
Message-ID: <gsntr0w3qt7p.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [kvm-unit-tests PATCH] arm: Remove MAX_SMP probe loop
From:   Colton Lewis <coltonlewis@google.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     alexandru.elisei@arm.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        eric.auger@redhat.com, oliver.upton@linux.dev, reijiw@google.com,
        ricarkol@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andrew Jones <andrew.jones@linux.dev> writes:

> On Fri, Jan 06, 2023 at 05:37:16PM +0000, Colton Lewis wrote:
>> Andrew Jones <andrew.jones@linux.dev> writes:

>> > > We could cap at 8 for ACCEL=tcg. Even if no one cares, I'm tempted  
>> to do
>> > > it so no one hits the same little landmine as me in the future.

>> > TCG supports up to 255 CPUs. The only reason it'd have a max of 8 is if
>> > you were configuring a GICv2 instead of a GICv3.

>> That makes sense as it was the GICv2 tests failing that led me to this
>> rabbit hole. In that case, it should be completely safe to delete the
>> loop because all the GICv2 tests have ternary condition to cap at 8
>> already.

> How did your gicv2 tests hit the problem?

Mysteriously. QEMU/TCG failed those tests when given -smp 4 but not -smp
8. There's the unresoved question of why they fail then (could be a QEMU
bug). And the second question of why the test was using -smp 4 on some
machines and not others, which is due to the loop I am trying to remove.


>> If we can't delete, the loop logic is still a suboptimal way to do
>> things as qemu reports the max cpus it can take. We could read MAX_SMP
>> from qemu error output.

> Patches welcome, but you'll want to ensure older QEMU also reports the
> number of max CPUs. Basically, either we completely drop the loop,
> which assumes we're no longer concerned with testing kernels older than
> v4.3 and testing shows we always get a working number of CPUs, or we
> change the loop to parsing QEMU's output, but that requires testing
> all versions of QEMU we care about report the error the same way, or
> we leave the loop as is. Alex says the speedup obtained by dropping
> the extra QEMU invocations is noticeable, so that's a vote for doing
> something, but whatever is chosen will need a commit message identifying
> which versions of kernel and/or QEMU are now the oldest ones supported.

Theoretically, I guess we could always have a machine with more CPUs
than QEMU supports. Checking multiple QEMU versions for a specific
message format sounds tedious and flakey. What we really need is a
better way to query QEMU for max cpus and then take min(cpus on machine,
cpus QEMU supports). Any ideas? I sent an email asking the QEMU mailing
list.
