Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A3D53952D
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 19:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346284AbiEaRC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 13:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243327AbiEaRC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 13:02:58 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09CB51E40
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 10:02:56 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id s6so6497637lfo.13
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 10:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6woIi5X4RXcZP28Bs94NCP/6sy5OrXp5YGW7ijpv1IY=;
        b=ad8U/fXPlywklSvneZLRHjyP2IogxtWeLm2xqT+/V9IeeWrhY+abelkmfvz+WqxMg3
         fbqhkIN3LsBqJxXgt4YJe5p8UKsaO0QmcL2KuKisd3H4V1uyA5yTYTI8/f3/ReNb7bBT
         0wsJv4qZ9+bdrr1Og93Ja+GDNlUPWNJ+rMTgmUjfTxEbzIEhm1E4DoYmOYiFyweoncZE
         uy0FCLy0ykX04QbKbwgAjQJtqNJqiT9u+Pvm3eDqomTdDyE7pB/+9QnHujdI2bf0w3My
         U0bi2ZWWJ9xlLK1w25BRZUXGY+Hv5b9GNTn5OIyQfwyog9QI+wJQPQ1TfdUuR+xHLs0B
         h1VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6woIi5X4RXcZP28Bs94NCP/6sy5OrXp5YGW7ijpv1IY=;
        b=mvLfNX68wD0JMEfD3YeJTkCrlef6he+bfdkGl7Ef5+as2xZzfIyggqRsJwQNKCiP6P
         pqT3VdXYv5q2bShLU0DLdT1+RR9OuY7DZst+vHg4vf6msBNlZZQ/9MmdBYltnxAbLOvV
         bAD5bk16td1mnExcg5Si/phelYKPvnv8bvx4f723hJp3jiUBZcDzg3m3ttrQlvYbAMv+
         UukHWUaFFWHT+MBLEibTqC+YAmAlNnjYLSKLsUT0E8wjwgq5eploTSyKgKeiVSBFf3iy
         3ZmeSLSXhRHKSL5NJDK6s5UbtkHITHVNiSoJJWDqTEMKUQ5Pyyw650UgzwwTVbJn6yCq
         7u1g==
X-Gm-Message-State: AOAM530sUiUxHXriiZxNIuby2fP3ziHFjsdzM3yhLFXE6UH6EzJUrFzF
        2pxh8YG/6v2+Xwl5wdRb97BlG3xKp7gV/Dsz8vvBMjaBRYE=
X-Google-Smtp-Source: ABdhPJzxfuW3aK35VfrvKMg9umUp08D2kZgx+31cWkWearry5aeczq+C/PJleIr5FJu1kE2MlK0qKrjpVhi8dsEJoXg=
X-Received: by 2002:a05:6512:1092:b0:478:689e:a8dc with SMTP id
 j18-20020a056512109200b00478689ea8dcmr33954811lfg.33.1654016575266; Tue, 31
 May 2022 10:02:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220526071156.yemqpnwey42nw7ue@gator> <20220526173949.4851-1-cross@oxidecomputer.com>
 <20220526173949.4851-3-cross@oxidecomputer.com> <Yo/v5tN8fKCb/ufB@google.com>
 <CAA9fzEFF=fdfV7qE-PU5fMD+XyrskQjvxPbgZ1yyS4fRTeBO2g@mail.gmail.com> <YpDjGdzsX+VHy1R8@google.com>
In-Reply-To: <YpDjGdzsX+VHy1R8@google.com>
From:   Dan Cross <cross@oxidecomputer.com>
Date:   Tue, 31 May 2022 13:02:44 -0400
Message-ID: <CAA9fzEEu5q3_WSMmvSht1=R5o3RQuHjJ8zWeSGU_nAtYOBEkxg@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm-unit-tests: configure changes for illumos.
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 27, 2022 at 10:41 AM Sean Christopherson <seanjc@google.com> wrote:
> On Thu, May 26, 2022, Dan Cross wrote:
> > On Thu, May 26, 2022 at 5:23 PM Sean Christopherson <seanjc@google.com> wrote:
> > > Why not simply move the check to run_tests.sh?  I can't imaging it's performance
> > > sensitive, and I doubt I'm the only one that builds tests on one system and runs
> > > them on a completely different system.
> >
> > `run_tests.sh` already has the test. Changing it to a warning here
> > was at the suggestion of Thomas and Drew.
>
> Ah, hence the earlier comment about removing the check entirely.  Either works
> for me, thanks!

Thanks for the helpful comments on the review!

        - Dan C.
