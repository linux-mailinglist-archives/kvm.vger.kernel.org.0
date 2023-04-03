Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E8A6D4E65
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbjDCQvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbjDCQvv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:51:51 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D62210A
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 09:51:50 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id s4-20020a170902ea0400b001a1f4137086so17867013plg.14
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 09:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680540709;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j0+AsVm/ICAEcAP4rxU82nAAsSy6vNn+W+CVde+YYzE=;
        b=nnY+pELvU43otmpN0FYH574JDxJHD/YemNmoCWDwKRhowjTqAFseS6/AhsnyP/1Dlx
         a+QEvEtVOUszU9dy5VPF6tm+vahgU5NxgfKrZ0ua4uwXen3y8WbNo262wAfK7TEyAXYQ
         hLL0buw22y4bMJZBT50pFvYiOosvyBtodbpmiJrLpWe5YNKFpeL3Bweq6MmhRvZn5vCd
         7mmIweQoAn/16C+vrQpVP3MphK/g/d/XvntkoW6U+AM6U4AZek2xPD/lglyeGp0ab2qO
         xpVzuBrMBHOmA+EOhuSDrdE4HQgdbAeoRCu7GPpNYhqYxDOBP1qgi44HC3sDyZte6Wab
         d63A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680540709;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j0+AsVm/ICAEcAP4rxU82nAAsSy6vNn+W+CVde+YYzE=;
        b=EivIH3UdWRtTOPapbksUA4JqnJOcvdKj1BxTolV7FsuTIXovNYDfl8BEXDKsP62bM3
         LAh8PIihU5PQNN0Lj75A/E6yU1EgnQ2TIdFZHLF0dFapmezCC1I0YeigTcwxrN43iPAe
         i+eeRStINedat2rPzb2iQUrT4ErCuCuUKbJ8Wz57BXLu94YDD5eqzVCNmznPZM4BSMEj
         gBUjgspW+WWi2xp0CirGW2NDqvfkQLP7vIKW4CQwa4yjXONsNtf9iZ5tvj1Y9CTkEgfP
         yXh5VEi6LgbPx/bM1xvOiA/tAZsluUdIAMLwxKkaWo/OTHXOodo22SJjuGPNJeFaihfa
         9xtw==
X-Gm-Message-State: AAQBX9cv65zl6gyhm58v4UZmAa0fq7gUDdhsmrqtZquXmAmTray4BCRc
        b4lVmj4EdTTXl7yj7vbtsTO4hDU4zjE=
X-Google-Smtp-Source: AKy350ZhY2dj1zF7nuU24v6IRoc4e1JXI6QyCj5OHk4qZbU6IqQ6ObciFfvpw3KS+ToEJ5g/PTAMWnoBlJs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fb57:b0:23d:30c2:c5b7 with SMTP id
 iq23-20020a17090afb5700b0023d30c2c5b7mr5988293pjb.3.1680540709693; Mon, 03
 Apr 2023 09:51:49 -0700 (PDT)
Date:   Mon, 3 Apr 2023 09:51:48 -0700
In-Reply-To: <3b8e64f5-6099-9e80-d0d8-4a5ea4e6c6f3@redhat.com>
Mime-Version: 1.0
References: <20230403112625.63833-1-thuth@redhat.com> <ZCrvwEhb45cqGhmP@google.com>
 <3b8e64f5-6099-9e80-d0d8-4a5ea4e6c6f3@redhat.com>
Message-ID: <ZCsEJPjWA/IOk9ca@google.com>
Subject: Re: [kvm-unit-tests PATCH] ci/cirrus-ci-fedora.yml: Disable the
 "memory" test in the KVM job
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
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

On Mon, Apr 03, 2023, Paolo Bonzini wrote:
> On 4/3/23 17:24, Sean Christopherson wrote:
> > An alternative would be to force emulation when using KVM, but KVM doesn't currently
> > emulating pcommit (deprecated by Intel), clwb, or any of the fence instructions
> > (at least, not afaict; I'm somewhat surprised *fence isn't "required").
> > 
> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > index f324e32d..5afb5dad 100644
> > --- a/x86/unittests.cfg
> > +++ b/x86/unittests.cfg
> > @@ -185,6 +185,7 @@ arch = x86_64
> >   [memory]
> >   file = memory.flat
> > +accel = tcg
> >   extra_params = -cpu max
> >   arch = x86_64
> > 
> 
> I think we should just drop the "CPUID bit non-present" case.

Oh, yeah, that's even better.
