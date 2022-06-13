Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E670549F9C
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 22:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbiFMUkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 16:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345007AbiFMUk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 16:40:29 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D7540A03
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 12:35:55 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id s20-20020a056830439400b0060c3e43b548so5056206otv.7
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 12:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HHeM+flxVNdPvHzfTQjqznJk16sWGVQxv7Ca8t6SBsE=;
        b=PwUb1TcOxrtFXEqynPal0Dxxtb/hVSDxNVg4mx9FbFVF5rReXGUJwcc/Pax9tA95H6
         TADpK0GOwfs+Lc7b2WXDmiyGRetPDAaUGwWX7n/bnq0ZHEaP1LZx0ZMtNo5l3N4u23Tb
         cn4zXIBv5CtVdDEnfadxC482jDX9tVqbO1CxlvXJLtFSTcGe0Mi/b5pESx5ZC5pJ28Hy
         yxH6D+eMfVRUepQPYm5JXHMvolauypojTH5i1HuLoXq1zt2RTr0Y4zhwkzepx2xgu4cc
         qdnxFIEIEhwyPY05rmblVrJOLj3NBWuMNeo1a5qXg8/7pJNfBLTAo6e55wnFnQBRMuQ/
         zDqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HHeM+flxVNdPvHzfTQjqznJk16sWGVQxv7Ca8t6SBsE=;
        b=HmaV3YB/HOofqa2d1gZiYDcaVssJ7hN1di8LBi2WsmV+3f/z3xKxp3lE248tfB4/fE
         MJvZf7uEJ+sieLKP89RHy4pg0Mh44vzzAHYlTG2GtpOPA1ZgNWB3aF8gtn8siAxM120R
         UDxrJRs6Wrb7ReOx5tb5lTZuzUQ4UD9ehTjN5/zUmMBVURiFROxHlIcuTwXqmhfdKbcs
         imTSIK+NrNrPQbrdM4p2xi5BRqN1o/pYASeNHOFvGH/X0b5vqrcEBvJO+RAlOlCvW26c
         q/jFIx436JwsSMhsCDxl6Cx4vxPRnCPs+0MHc3jCKLLjDrZBl3NRHhSedYz1vrAfC9AJ
         ljQQ==
X-Gm-Message-State: AOAM533F1Dr0hQ1PLB6Anz6FAh8y7xYvNwjPwliRQ7Q28iyLDb2nbn79
        qLMH3D+1lEGJs9tI/fMnw8+vyjEVxHkn1zXPLqDU7g==
X-Google-Smtp-Source: ABdhPJyjsaXGe67Xx3Ewbm6uDJybR+EoKHifbqcPUm5dy4plOXPn29b4R60AZwOELru2ZiGWTU1QMUT9lR/gncH8L8k=
X-Received: by 2002:a9d:665a:0:b0:60c:81b0:3a72 with SMTP id
 q26-20020a9d665a000000b0060c81b03a72mr186371otm.14.1655148954224; Mon, 13 Jun
 2022 12:35:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220613161942.1586791-1-seanjc@google.com> <20220613161942.1586791-2-seanjc@google.com>
 <CALMp9eRBNqPrBMi_XDMMK8HpdoYRUfoe_jSVZAW80wSxWbDJVA@mail.gmail.com> <YqeQx2fbdVVnRcxS@google.com>
In-Reply-To: <YqeQx2fbdVVnRcxS@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 13 Jun 2022 12:35:43 -0700
Message-ID: <CALMp9eRj9AWATJ=76Xio1cb7E_j=e2haH++nbccdv=MJ26N=GQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: selftests: Add a missing apostrophe in comment
 to show ownership
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Jun 13, 2022 at 12:32 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jun 13, 2022, Jim Mattson wrote:
> > On Mon, Jun 13, 2022 at 12:01 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > Add an apostrophe in a comment about it being the caller's, not callers,
> > > responsibility to free an object.
> > >
> > > Reported-by: Andrew Jones <drjones@redhat.com>
> > > Fixes: 768e9a61856b ("KVM: selftests: Purge vm+vcpu_id == vcpu silliness")
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  tools/testing/selftests/kvm/lib/kvm_util.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > > index 39f2f5f1338f..0c550fb0dab2 100644
> > > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > > @@ -1434,7 +1434,7 @@ void vcpu_run_complete_io(struct kvm_vcpu *vcpu)
> > >  /*
> > >   * Get the list of guest registers which are supported for
> > >   * KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls.  Returns a kvm_reg_list pointer,
> > > - * it is the callers responsibility to free the list.
> > > + * it is the caller's responsibility to free the list.
> > >   */
> > Shouldn't that be callers'? Or are you assuming there is only ever
> > going to be one caller?
>
> No?  Regardless of the number of users of the function, for any given invocation
> and allocation, there is exactly one caller.

Statically, there may be multiple callers, and each is responsible for
freeing the list, right?
