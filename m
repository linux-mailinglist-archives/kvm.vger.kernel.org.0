Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0376B6BF54E
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 23:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCQWot (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 18:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCQWos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 18:44:48 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C913BDD06
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 15:44:47 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id m5so4328503uae.11
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 15:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679093086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wMoW7IaGrOuG3tLDTSz1LptM3iWWmGYJ7XjQZj/iTVI=;
        b=SBSCADU+yStdMahSN2OyhFXyd8MfjEo9+xwwAHORSLPJYVNKDURAS586/wLWkjlte+
         mlJnpBpF8PoDC0O8BvHihxw30uBG9LjPq7acJNZMIvaBepIwIail3YqQmhr4ppxZO2RL
         F1aK7tLTP8lKa/ODjxISle1g3e7/trn0HLOwOn+f0gvpG60cSDxj9Y4Pl4NK1zLGC+6y
         h3RL9UqODe91icjSY5QYsjouKpGiMZl0yrEWYRZRVGCiYXqG7sH9ejY1Z607tzzzDvNX
         lPuotiUhUkB3sqKK6CBgdm1h+SmUe/0GDkIchRDr8VWkXBuF6enX/ryjSgyjwXNFGavS
         OfYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679093086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wMoW7IaGrOuG3tLDTSz1LptM3iWWmGYJ7XjQZj/iTVI=;
        b=h4uqpTvN2glqKsqS/TfG3Sy10Fa+hu3vtJhVIv46fpqg+WnqQmRbqnfffUzcTAV8KG
         hz2khC4ZKiAf2ZVhunxJinOmlJfGdGubTYz5BmtttjmCsyP2y23cxoW7XXnYQ1Z+yzGk
         azrKx988sq9QL7ORAr+hpXn2aB/7foyzPev0G6WBV4rSH0vKY//VY+b0x7PUtwz9Sgg0
         NF5gvyBaIM0Pi+2gHdRpm6bKmH3DW3K3sfYc0Oa825kYBpIaaMhdvnBLQbtOR0vb7d3f
         AwUbum1LE3Pwk8lZvvrmdxxxZzR/uT27888G79o5Fch+i8rJYQ2k5ypp3Gr8oc7CXlo8
         3rKw==
X-Gm-Message-State: AO0yUKW/Pdfw65ruGfMbl33H85aWh5q7/Uua+Yt6CrCcl8nk3OSI33kr
        Bz7W6DpT8Lz5rQeSNJdPxL2n97ahkNcJ7vGmXU8h6qmVqQV/j3e+LgJWbw==
X-Google-Smtp-Source: AK7set9zmhRAV9CcOsfYEpXonLWW/9Hhp5NEtB52djg9ZxbmjzOdTQdQqKA5Gqc0mwVshJKlrw1DzGIj3khd6xYE3LM=
X-Received: by 2002:a05:6122:789:b0:432:595b:1cea with SMTP id
 k9-20020a056122078900b00432595b1ceamr178685vkr.7.1679093086022; Fri, 17 Mar
 2023 15:44:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com> <20230315021738.1151386-5-amoorthy@google.com>
 <20230317000226.GA408922@ls.amr.corp.intel.com> <CAF7b7mrTa735kDaEsJQSHTt7gpWy_QZEtsgsnKoe6c21s0jDVw@mail.gmail.com>
 <ZBTgnjXJvR8jtc4i@google.com>
In-Reply-To: <ZBTgnjXJvR8jtc4i@google.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Fri, 17 Mar 2023 15:44:09 -0700
Message-ID: <CAF7b7mqnvLe8tw_6-cW1b2Bk8YB9qP=7BsOOJK3q-tAyDkarww@mail.gmail.com>
Subject: Re: [WIP Patch v2 04/14] KVM: x86: Add KVM_CAP_X86_MEMORY_FAULT_EXIT
 and associated kvm_run field
To:     Sean Christopherson <seanjc@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, jthoughton@google.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 2:50=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> I wonder if we can get away with returning -EFAULT, but still filling vcp=
u->run
> with KVM_EXIT_MEMORY_FAULT and all the other metadata.  That would likely=
 simplify
> the implementation greatly, and would let KVM fill vcpu->run unconditonal=
ly.  KVM
> would still need a capability to advertise support to userspace, but user=
space
> wouldn't need to opt in.  I think this may have been my very original tho=
ugh, and
> I just never actually wrote it down...

Oh, good to know that's actually an option. I thought of that too, but
assumed that returning a negative error code was a no-go for a proper
vCPU exit. But if that's not true then I think it's the obvious
solution because it precludes any uncaught behavior-change bugs.

A couple of notes
1. Since we'll likely miss some -EFAULT returns, we'll need to make
sure that the user can check for / doesn't see a stale
kvm_run::memory_fault field when a missed -EFAULT makes it to
userspace. It's a small and easy-to-fix detail, but I thought I'd
point it out.
2. I don't think this would simplify the series that much, since we
still need to find the call sites returning -EFAULT to userspace and
populate memory_fault only in those spots to avoid populating it for
-EFAULTs which don't make it to userspace. We *could* relax that
condition and just document that memory_fault should be ignored when
KVM_RUN does not return -EFAULT... but I don't think that's a good
solution from a coder/maintainer perspective.
