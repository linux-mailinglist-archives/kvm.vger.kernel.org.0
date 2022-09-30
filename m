Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2A25F1687
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 01:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiI3XNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 19:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiI3XNG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 19:13:06 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B2E18CB04
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:13:06 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id w13so6203381oiw.8
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 16:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FTxLgcMyYAOQzucr8K2hPHGxdwrLL9BzC9KaXDtmRuQ=;
        b=GMUxqquBG5IIgt8I/OHRDgjDY73Ir6nyKBEL+5GFDby7C5osdXl0EXYTOpim3UUmFr
         /atNY2GeyOJ5/gc5eu1R+Ojqa/1OfiE5d9KalWHhAWvB6ojYpRnCN56uAlJnehPxY/c4
         OqC41k/5B+AU4Q7sBWhXB8wHyU5eAMcFJ5zUE3TW8hMTuUdAAsC50sneE2IlaREq3O19
         VH8mwZ1Wf9vmRxbCOVFn9di0gKpxWKj6Cx1lfA0jGoqc/4COpGyjRBYQptKzAlplJz/X
         0a3ZNyqh08ylO/nq1Aarh3yH0BuhI4dd1nZhkW9cboxD5p436pt7pTm9N1qb+Z9E4rfO
         sgYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FTxLgcMyYAOQzucr8K2hPHGxdwrLL9BzC9KaXDtmRuQ=;
        b=Lulr3iu+62OAhb8dZWiBJZaVo/mwpyADyOlgqhhJsLwbqbNxXBpQlOiAi26GUTLz43
         a2uRwU67fm57ZNhrCp28XVW5dEjZ1onoRYuCoQ8BYtBpOygUx2AC/5fQNUKVtbXbRnqR
         trQ73tLvb12SE/BCOS5fi5OzBEljXOQqN+JqBNhFAM9KsWuIBwJgskP5WEqCPzJ4NokF
         0K4J46WA2/bsTrlHsQ6lbB5SCLodKCDji+VMzr1+WzZVOWhOa7TBpaMGqRUcZaW9AHfu
         HNqEI0jTd7EIqzn6iGCLVRSPLDLxmhPBFFahTLrXiICq16vcAXPUeYDxp9/zCd4qN/ED
         Oyjw==
X-Gm-Message-State: ACrzQf2BVvqO7sK2WLQqgau6NTGwojXBmgYUqyhbLp+x60zXq+uj9eFY
        H2bWRDxjZR9eVsYP6eZehK+HGKtIqTQ9uZjHMF48qFNL23Y=
X-Google-Smtp-Source: AMsMyM7s6knt0IPs9xfhFexYsTIn1krb7/Ch/OWWNzQMrZmS98JosDwjw97+rOVyrMQIatmER1z6OkW8lZBBSbnG0kw=
X-Received: by 2002:a05:6808:f8e:b0:351:a39:e7ca with SMTP id
 o14-20020a0568080f8e00b003510a39e7camr190443oiw.269.1664579585160; Fri, 30
 Sep 2022 16:13:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220929225203.2234702-1-jmattson@google.com> <20220929225203.2234702-2-jmattson@google.com>
 <BL0PR11MB304234A34209F12E03F746198A569@BL0PR11MB3042.namprd11.prod.outlook.com>
In-Reply-To: <BL0PR11MB304234A34209F12E03F746198A569@BL0PR11MB3042.namprd11.prod.outlook.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 30 Sep 2022 16:12:53 -0700
Message-ID: <CALMp9eSMbLy8mETM6SRCbMVQFcKQRm=+qfcH_s1EhV=oF656eQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] KVM: x86: Mask off reserved bits in CPUID.80000006H
To:     "Dong, Eddie" <eddie.dong@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Sep 30, 2022 at 2:21 PM Dong, Eddie <eddie.dong@intel.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Jim Mattson <jmattson@google.com>
> > Sent: Thursday, September 29, 2022 3:52 PM
> > To: kvm@vger.kernel.org; pbonzini@redhat.com; Christopherson,, Sean
> > <seanjc@google.com>
> > Cc: Jim Mattson <jmattson@google.com>
> > Subject: [PATCH 2/6] KVM: x86: Mask off reserved bits in CPUID.80000006H
> >
> > KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
> > actually supports. CPUID.80000006H:EDX[17:16] are reserved bits and should
> > be masked off.
> >
> > Fixes: 43d05de2bee7 ("KVM: pass through CPUID(0x80000006)")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c index
> > ea4e213bcbfb..90f9c295825d 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -1125,6 +1125,7 @@ static inline int __do_cpuid_func(struct
> > kvm_cpuid_array *array, u32 function)
> >               break;
> >       case 0x80000006:
> >               /* L2 cache and TLB: pass through host info. */
> > +             entry->edx &= ~GENMASK(17, 16);
>
> SDM of Intel CPU says the edx is reserved=0.  I must miss something.

This is an AMD defined leaf. Therefore, the APM is authoritative.

> BTW, for those reserved bits, their meaning is not defined, and the VMM should not depend on them IMO.
> What is the problem if hypervisor returns none-zero value?

The problem arises if/when the bits become defined in the future, and
the functionality is not trivially virtualized.

> Thanks Eddie
>
> >               break;
> >       case 0x80000007: /* Advanced power management */
> >               /* invariant TSC is CPUID.80000007H:EDX[8] */
> > --
> > 2.38.0.rc1.362.ged0d419d3c-goog
>
