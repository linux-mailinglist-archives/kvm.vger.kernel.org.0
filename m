Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8133A36FFC4
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 19:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhD3Rkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 13:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbhD3Rke (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 13:40:34 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E3AC06174A
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 10:39:46 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id x54-20020a05683040b6b02902a527443e2fso14011207ott.1
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 10:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/QCg3tcFZuKNZPrHgr+MVsV/ZvagGHBU+E0/6yNtjTk=;
        b=S21mRyNFdIavYRi0+iNlOuM65+BLRfj0CCvvp5XAkGtoWtBnywaRXgrL/V7B6XsYSy
         eyhiFsgnVSOnf7IVPqeMr1+NjJFwlo4zuqrcTFDj25tvCJr9Yz7vY0iov0q/5FZy3nFN
         +ERnF6q1US2rvrVPHiTI4nON6kGwd0xGClFsemwNQBNV3CPqgS3+BmxxyWvLxafENMfI
         5dT+wO62rRLL+lm7vgJFMeZdzy16y3S9F+oDrgmhacX/BuZ1Vg1neO4GqKdNP7Qe1q9r
         jt50Hu4Xd+SjjzJwHOAj8F9uXQkhQZIWcJxfOd66WbEPR16X0aJeA/mO1yxbcgmWl1Al
         vIyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/QCg3tcFZuKNZPrHgr+MVsV/ZvagGHBU+E0/6yNtjTk=;
        b=Km5pc5YK4zgdBTMlUgmBB/6i0hrIL+deM+NrEvQhkauV4aweyZRe2XMCNy0HJJZCz6
         T6xcCiRUnCcRXQ7dQ6PCCqSjodmjWxUtowh9BWXx2rDd5dZvh/7KQgaRhFXCupnFpqpP
         k82xvUGL1k1EDCtj0S2xyFbCxiePHLhR7CC/aBOL3o2RKZxuGXeD+PtseX+xWEdfDzb7
         wsnLpEZEKt6UmMUoKu2gtIlsjm4o2Ej2uImj5mj24TVXG/PCE5JVeXT4SpwJop1CygZ2
         HPBZID2G5Nb1zMvfVsmr5Wt5C68J+Yo2U5CWA6ALUw0q2VAC2f+4ea8L6Ys8Ud4Ri9+2
         pP9Q==
X-Gm-Message-State: AOAM531/nizJtV2OgzQuc1mweOwD6WZmpDtUTEZhR3HmgRUjFyTx5q6p
        frSAPCjyg0OP8yPT3XenKiLUe9izbs7cGjtec7cCJA==
X-Google-Smtp-Source: ABdhPJxVui1hT2Hcy1eveUoAxuJ7AVz+2nWWBcVsk4luZe3GSZZp4iXbGXaOTr1cLOXa7xCKCO5NN50powcHKV3ijv4=
X-Received: by 2002:a9d:1b4d:: with SMTP id l71mr4576968otl.241.1619804384661;
 Fri, 30 Apr 2021 10:39:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210430143751.1693253-1-aaronlewis@google.com> <20210430143751.1693253-3-aaronlewis@google.com>
In-Reply-To: <20210430143751.1693253-3-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 30 Apr 2021 10:39:30 -0700
Message-ID: <CALMp9eQZEiZ1_nOmyMA2G1Q5vB_vhm09fmB1Bc9VK8tJUUB4kA@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] selftests: kvm: Allows userspace to handle
 emulation errors.
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     David Edmondson <david.edmondson@oracle.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 7:38 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> This test exercises the feature KVM_CAP_EXIT_ON_EMULATION_FAILURE.  When
> enabled, errors in the in-kernel instruction emulator are forwarded to
> userspace with the instruction bytes stored in the exit struct for
> KVM_EXIT_INTERNAL_ERROR.  So, when the guest attempts to emulate an
> 'flds' instruction, which isn't able to be emulated in KVM, instead
> of failing, KVM sends the instruction to userspace to handle.
>
> For this test to work properly the module parameter
> 'allow_smaller_maxphyaddr' has to be set.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Change-Id: I23af1c0d4a3a3484dc15ddd928f3693a48c33e47
> ---
...
> +                       TEST_ASSERT(is_flds(insn_bytes, insn_size),
> +                                   "Unexpected instruction.  Expected 'flds' (0xd9 /0)");

Aren't we looking for 0xd9 /5?

With that minor fix.

Reviewed-by: Jim Mattson <jmattson@google.com>
