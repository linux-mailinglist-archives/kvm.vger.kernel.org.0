Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5E35332EB
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 23:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241898AbiEXVUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 17:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241458AbiEXVUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 17:20:38 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B331F56FBD
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 14:20:35 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id p4so31517039lfg.4
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 14:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JmFE5hLJdXmT/AXy99kycqDIloRy0hvedEy/y8dFhro=;
        b=cEmpraQzwprn/oEmCBBWlqsPxWWPI3pykNE2jquLjaMMQqGEH6Caz5/oAmq+oJ29x/
         KFz2FMNtSkUy6vmElYWK7w1+D2CdM2/pP4KR2AzQagQtFOrSKPjU8CBOdSi3mCm8sEIW
         u5aDikL2pLNffhPBaPN8Lb+owu25hPWZaHjt5opr2pCug1SPODzgDWR4MsMNqbp4iK8Z
         W9vpSvD+zjq4A5wmX/Zw9ivu8tfjDaIp2YFe2jkpam1BnnNTDP1RhsCbjJ1En6MBbeaF
         l5bFFs6ycPyXFLTX7h0svzhFQj3kzKDZeqcQh8mWwm5dGEtqlwtAEdvn9Uitne9cUHrd
         iItw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JmFE5hLJdXmT/AXy99kycqDIloRy0hvedEy/y8dFhro=;
        b=Hudb9QH+Fj+PQwXWOk84l0SIkknZeIx8mKPP2ThJ+68NI7QdN+LcAv+zS/rW3Bp8Mt
         XNZZoE85bBeOULaJj4RNRr+h8CvpcxsFvaGG0qrWa0cFoqtqSIpSNyLlyoVk3VMdpqdx
         Wkaq2CzaYxnEVnOFQz59mxYMyGUzELWOSB/98l38zuxEsuXYRs7sazGswgWJs1sYuv4v
         +KgBeI35bfNzzaNj5ciBTaDnsWdZ7VilOCAHdug/Xsj3AGLAlAs8uFAlv6CChaCBXCZk
         gbPYajbh8OtJ0+WP3K7ZwG80LRUKMbityQ5abZjdMLow40Cy0YAP6ZykM9o48t3ni0HS
         9qtg==
X-Gm-Message-State: AOAM532Gm5iX9tL/u1YwQ5+4zfu4+71ZuG3zmxvIuGAQfrWT+n/VS7A7
        pBUBP4dCmrouXrvKnNP0SsBHcW42cW7xtk6GHkzCqg==
X-Google-Smtp-Source: ABdhPJwNN2BvZ/cdrO897IUZDHxKNEw9Tv7DVMb0WPyiO/Qm8n6jgirVbp2SYiTeV00OVgkEtm1mQoHSBUquXEBWwHg=
X-Received: by 2002:a05:6512:3f95:b0:472:c4d:30ac with SMTP id
 x21-20020a0565123f9500b004720c4d30acmr20970540lfa.51.1653427234077; Tue, 24
 May 2022 14:20:34 -0700 (PDT)
MIME-Version: 1.0
References: <Yn2ErGvi4XKJuQjI@google.com> <20220513010740.8544-1-cross@oxidecomputer.com>
 <20220513010740.8544-3-cross@oxidecomputer.com> <Yn5skgiL8SenOHWy@google.com> <5d48ad3f-a93a-0989-3872-cdff0bc6eb92@redhat.com>
In-Reply-To: <5d48ad3f-a93a-0989-3872-cdff0bc6eb92@redhat.com>
From:   Dan Cross <cross@oxidecomputer.com>
Date:   Tue, 24 May 2022 17:20:23 -0400
Message-ID: <CAA9fzEEYMGjPEUAZEzFHDkq3CRod7_eHeEBzD4JoTNL7TrUnjA@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm-unit-tests: configure changes for illumos.
To:     Thomas Huth <thuth@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
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

On Thu, May 19, 2022 at 5:53 AM Thomas Huth <thuth@redhat.com> wrote:
> On 13/05/2022 16.34, Sean Christopherson wrote:
> > [snip]
>
> According to https://illumos.org/man/1/getopt :
>
>   NOTES
>
>         getopt will not be supported in the next major release.
>         ...
>
> So even if we apply this fix now, this will likely break soon again. Is
> there another solution to this problem?

I wouldn't put too much stock into that; that note came from Solaris
and has been in the man page for 30 years or more [*]. I think there
are too many shell scripts in the wild using `getopt` for it to ever be
removed. Indeed, if anything this highlights something to clean up
on the illumos side by removing that from the man page.

        - Dan C.

[*] e.g. https://www.freebsd.org/cgi/man.cgi?query=getopt&apropos=0&sektion=0&manpath=SunOS+5.5.1&arch=default&format=html
from 1992!
