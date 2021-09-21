Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A7B4138D3
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 19:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhIURoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 13:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhIURoY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 13:44:24 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2688C061574
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 10:42:55 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id p29so552201lfa.11
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 10:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x1n9q3vbepQtsoN7gIbjiMfEKFVaYsnFrh4UdZ590q4=;
        b=gQ4YOC5JIZpP+oRfrOy7fTkK+PIvcU0eOLvMtinsTsNE/Q0NMHbRsMTWdE7u/x2v3l
         ApckSD+kd0l+BB+KI3plO0FTdGIQW3FSf4YUg4ZLgu/T7Y+ISYawC2G5xICi/4tGCYv9
         m2UYrhVrKhGSdoRbjmlzWEEBpn5L5Ko5S77BhDW3AdZF3keWwXzmxCGXMcwqSqiyT95r
         K1jO9t9Ji6jVFntgKSH5XAgfXxpB8RW2mo+PlvHLCXhqYUM+EVx0baT7mvD08pZ5tX6O
         8HBjqB7O0BsXvq8b5DG85Ol43wGigt6TuFkn/cDV5JQ82+GBPC74Gup85mrUBilZbztx
         1nYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x1n9q3vbepQtsoN7gIbjiMfEKFVaYsnFrh4UdZ590q4=;
        b=k+o71nqOMn6AHQLzl3Wto2RF0vTc75mx02JAK/ThY8c4Qq/k2mbN22V5BglyfoY7c1
         uzMbWfZE3jVB8C2rxHxIF0uhKUv1FWIp+rEI3z6rmPfpddUfa9C0l1FtoJxJ0OxCDI8i
         /GD4PRWDnl+gGCM9UYuplkUb0cleusFuF/mfU6AVu/0igcOFs82KWF2j98Y7XuX64C+L
         jt3/UJf/W5BI1rLV8P1mhtZBOW4oRGD1zWuYi395zxc5wgfvBcx8qQ83BQdKpAKk4gs6
         qkpBUkWUA+57YF+U2RIeCpSB4CmgvE16Cbm3OU80O9VGHe/aMVqhvhXtdKQ7aUZ8VYod
         3fbQ==
X-Gm-Message-State: AOAM532pXKgSgK5E0h1FoWNFlIWwET9lloLRaC8CMy5uC1CQjOBKd5CV
        jFLKjf/sxGYa5jbduiNCIRE6wb/EhGmfk8k1Xroshg==
X-Google-Smtp-Source: ABdhPJzta0UHM2xo/JOt/RXafPSRUTqAzaLV6K6nYr9EJEx3X7wLpaDYUsi/AFu1dosOcGYxchuIVMoNQyUEuGJRMiI=
X-Received: by 2002:ac2:4a6e:: with SMTP id q14mr24881198lfp.685.1632246173682;
 Tue, 21 Sep 2021 10:42:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210921010120.1256762-1-oupton@google.com> <20210921010120.1256762-2-oupton@google.com>
 <1fcd4084-c1fe-0689-da46-5d81191eeae7@redhat.com>
In-Reply-To: <1fcd4084-c1fe-0689-da46-5d81191eeae7@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 21 Sep 2021 10:42:42 -0700
Message-ID: <CAOQ_QshcN-wcQy9Dv8V6OEKk5OTm5165A3k4tA56KeqfgC2iug@mail.gmail.com>
Subject: Re: [PATCH 1/2] selftests: KVM: Fix compiler warning in demand_paging_test
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Tue, Sep 21, 2021 at 10:38 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 21/09/21 03:01, Oliver Upton wrote:
> > Building demand_paging_test.c with clang throws the following warning:
> >
> >>> demand_paging_test.c:182:7: error: logical not is only applied to the left hand side of this bitwise operator [-Werror,-Wlogical-not-parentheses]
> >                    if (!pollfd[0].revents & POLLIN)
> >
> > Silence the warning by placing the bitwise operation within parentheses.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >   tools/testing/selftests/kvm/demand_paging_test.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> > index e79c1b64977f..10edae425ab3 100644
> > --- a/tools/testing/selftests/kvm/demand_paging_test.c
> > +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> > @@ -179,7 +179,7 @@ static void *uffd_handler_thread_fn(void *arg)
> >                       return NULL;
> >               }
> >
> > -             if (!pollfd[0].revents & POLLIN)
> > +             if (!(pollfd[0].revents & POLLIN))
> >                       continue;
> >
> >               r = read(uffd, &msg, sizeof(msg));
> >
>
> Queued (with small adjustments to the commit message and Cc: stable),
> thanks.

I sent out a v2 of this series that addressed Drew's comments here and
picked up his suggested fix for 2/2. Would you like to queue that
version instead?

http://lore.kernel.org/kvm/20210921171121.2148982-1-oupton@google.com

--
Thanks,
Oliver
