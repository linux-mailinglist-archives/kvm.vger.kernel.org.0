Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AA81EE890
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 18:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgFDQ2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 12:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729115AbgFDQ17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 12:27:59 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FEAC08C5C0
        for <kvm@vger.kernel.org>; Thu,  4 Jun 2020 09:27:58 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id d1so6651475ila.8
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 09:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8SV0FtrMHcEVC0TjG1lIBMyklx/s99kl7ywIO23ZhMk=;
        b=lsX7SRkn/58kMRS+GxvZjQ1F2T1zTLqcNYPLPjzqxYcEq3/rdEQ1PDHoI8s25jhaKF
         i6R2yAAOM4ruXYCc74CjQSulrfgjKrectwnu2jZntPzkfezzeKYUXNmzBYFlNoYPJKwj
         gANWWpzAxKwCkGb1wv4cfPVDP6Dg7hdTuWP/3IrvKe2jBG0seplny638FN3YJS/bmPCC
         qwnqfF76UvF1EOL5CB+Wn0DdaINU1//sA2M56c0PBNB4tw/YvnxLZkMr49qB4vmDWcDg
         R6PC7XpwseUn/XvM2PVM/RaMI0o561hsiNr1xDau9y5opoF0pHprCUUfhJ5diEZM5M/5
         yABA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8SV0FtrMHcEVC0TjG1lIBMyklx/s99kl7ywIO23ZhMk=;
        b=AkBwbxsfI3tnLmghnqnb/RIu6Hkguzhnq3ZEtqfhQ7/tUV8PLZzEVqnp3LhyyNsqVL
         kPhJ6/nFpFOfGe9ItQj4TdL66t6/ixly0jdOvF6rDmyVXEGfocbV+tj3R5k61xyuf5d9
         yeVe4RRSvkzXvQWE/fcoIecG2GoF08xEJchhVrJuqFLnO9FoMHPJW9i6DoTbAllwPiwm
         KVBGV5NrfTI6YAwGdxiVkK9S2Nfa+x1JxP3Xf+4E0Sf0omYsLQBKRJ1trl1dUJDMxdL8
         a9Gl5a5Y/fvNxoFOv9NsiMfCg6j1qnpCvbC+eu3UsMuHRNHk3zhPFrlkLm9i76ylpL6D
         KFYA==
X-Gm-Message-State: AOAM530vO7puulB4cyqDnqmHgl9qCcinY6qsj9/FTzFdMVM2L+o0sfO+
        AA3qFb29PiskeJBeStUi75bUJgkmhlM6Y9sCYMJRcIT1
X-Google-Smtp-Source: ABdhPJxRbVJTskYAsmdKpu2pg4TINE2MruufkpwnEijmewcp0JnBYFK2jNyYBde6mk7i4x2dEuDjCSNqEH6iENKh6dA=
X-Received: by 2002:a92:5f13:: with SMTP id t19mr4759363ilb.296.1591288077708;
 Thu, 04 Jun 2020 09:27:57 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eS2UtMazBew2yndKVXC0QnnBW2bvbU_d+27Hp7Fw2NXFg@mail.gmail.com>
 <48454efb-455f-5505-f92c-7f78836d5b91@redhat.com>
In-Reply-To: <48454efb-455f-5505-f92c-7f78836d5b91@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 4 Jun 2020 09:27:46 -0700
Message-ID: <CALMp9eQ9Xit1oZ0gFmUwd4HwQ6mEMDMvF_ZRg60Ohtt9_nPQqw@mail.gmail.com>
Subject: Re: PAE mode save/restore broken
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 4, 2020 at 7:51 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 02/06/20 02:11, Jim Mattson wrote:
> > I can only assume that no one cares that KVM_GET_SREGS/KVM_SET_SREGS
> > is broken for PAE mode guests (i.e. KVM_GET_SREGS doesn't capture the
> > PDPTRs and KVM_SET_SREGS re-reads them from memory).
> >
> > Presumably, since AMD's nested paging is broken for PAE mode guests,
> > the kvm community has made the decision not to get things right for
> > Intel either. Can anyone confirm? This was all before my time.
>
> Yes, pretty much.  The PDPTRs are not part of the saved state, we just
> treat them as a small third level in the radix tree.  Of course, for
> nested VMX they are properly synced to the VMCS12 and serialized by
> KVM_SET_NESTED_STATE.
>
> Out of curiosity are there OSes that rely on the PDPTRs remaining cached
> until the next CR3 load?

None that I know of.

It's interesting that Intel has taken great pains to virtualize the
architected behavior, but AMD just shrugged it off.
