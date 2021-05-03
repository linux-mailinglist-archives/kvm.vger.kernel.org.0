Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86587371F22
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 20:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhECSF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 14:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhECSFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 14:05:25 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02AEAC061761
        for <kvm@vger.kernel.org>; Mon,  3 May 2021 11:04:28 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id n32-20020a9d1ea30000b02902a53d6ad4bdso5895867otn.3
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 11:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KEiiSFDOHt+zbjvfB+bvuO8Cf11IqwdIW1ooa4clunA=;
        b=Pu9VMAzI47OgGACriVxuj/aYUadzmGabYhhfBazFjc8Z9Pc+1ijEf48ZWwJfIZv9mR
         go6kYwrF/niCdJ6ZLm+ay0k2Rq7PFqpWQ70Iu6bzAkOIxbM6W6sdOaxqbwC9/kmfZ8ip
         41IEjzyHSrk2ucSHaalJdIPo6OiRQr7P8giCxWMvDs56MqbmOZFg0C8sHA5lrvBtRXQu
         FvIZasVqlxlhkMqPVMffiSctbdvX8d2AEpDmL4w7whz5ykKZGjsSZ8WC7ma35r/JQ1na
         4y2iB01PiuNmF6+KrG8bxatnpz0KnTJQ82a7GceoW7i7gDv+HfkpwbyMZ56js5X/Yyee
         llmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KEiiSFDOHt+zbjvfB+bvuO8Cf11IqwdIW1ooa4clunA=;
        b=uUOT+cmG/cBDTvEzgGxIUMuUc+8DUpvUwtUzp0i0Dn6axMNz53OC9frFByoX5YkSv/
         KpvtUwP5UZB20rZyy2D1Uqtyb+/I2PI75gHejAYvgTELXBNq0eXWJx3ZfnEv3V1i9D4I
         z4rcm0c3qH3ZNOoe7j/rceiaTN/OmPCrdh0O0sAi7rvC++RXYMpsYgL49J/2Jj5dyAnT
         FlqWkIIAHGFE22Tvel9QMN4eWGwBPs3Ws8QUyB2eswBNV1Zq2o5r8Q99mPN3d4Sz5WB2
         DyyxzCoM0eIiSlDz4DWHe+JPC+c2vm/n6vgjN/aeOnohn8JsurmouEcPw/LrmArDFXZ5
         SYcA==
X-Gm-Message-State: AOAM532fD7ORRhRMrbRfD2g9DztpfXrC4oWtA22u7I3T+JEeAQcdQFC/
        USBFbqS5B/s/pYK80WNoV925tqew9P7hzl26164Y5w==
X-Google-Smtp-Source: ABdhPJylS3zT9Fdr9gZ0kmeduY8BWGG0OdN6WdwWRxg/9MPPOj9mrer4vRnzaC3tZc/HObdSagvMxBDCFIIysFTVAzI=
X-Received: by 2002:a9d:684e:: with SMTP id c14mr8088599oto.295.1620065067704;
 Mon, 03 May 2021 11:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210430143751.1693253-1-aaronlewis@google.com>
 <20210430143751.1693253-3-aaronlewis@google.com> <CALMp9eQZEiZ1_nOmyMA2G1Q5vB_vhm09fmB1Bc9VK8tJUUB4kA@mail.gmail.com>
In-Reply-To: <CALMp9eQZEiZ1_nOmyMA2G1Q5vB_vhm09fmB1Bc9VK8tJUUB4kA@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 3 May 2021 11:04:16 -0700
Message-ID: <CALMp9eQXGV=HV+r4UFp+O-BWs3YFUD-7jHjbBaDLWPq2CdLNAQ@mail.gmail.com>
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

On Fri, Apr 30, 2021 at 10:39 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Apr 30, 2021 at 7:38 AM Aaron Lewis <aaronlewis@google.com> wrote:
> >
> > This test exercises the feature KVM_CAP_EXIT_ON_EMULATION_FAILURE.  When
> > enabled, errors in the in-kernel instruction emulator are forwarded to
> > userspace with the instruction bytes stored in the exit struct for
> > KVM_EXIT_INTERNAL_ERROR.  So, when the guest attempts to emulate an
> > 'flds' instruction, which isn't able to be emulated in KVM, instead
> > of failing, KVM sends the instruction to userspace to handle.
> >
> > For this test to work properly the module parameter
> > 'allow_smaller_maxphyaddr' has to be set.
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > Change-Id: I23af1c0d4a3a3484dc15ddd928f3693a48c33e47
> > ---
> ...
> > +                       TEST_ASSERT(is_flds(insn_bytes, insn_size),
> > +                                   "Unexpected instruction.  Expected 'flds' (0xd9 /0)");
>
> Aren't we looking for 0xd9 /5?

My mistake. You are correct; we are looking for 0xd9 /0.

Reviewed-by: Jim Mattson <jmattson@google.com>
