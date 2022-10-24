Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6847C60B974
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 22:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbiJXUMe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 16:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbiJXUMN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 16:12:13 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21EAAC3B1
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 11:30:25 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id bu30so17533844wrb.8
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 11:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vslfN7+uZdJ5X5LoIB1UDDE0PItPz9PS/+QD4kaZ9Qc=;
        b=sQHI4JEZQZRcG1YAKpcLMOrgp3BGFePT69g1fQfuFp4lMzejFyljCox4KuGpsHebVg
         Syf5ly39Ji9gx/1aBQXhfBgssUi2AUiLeIjmf8hLUZeywkfQjTxTfwXCcvos+alAGptm
         Ov6UMSeOebKrid8lml5POLoPid4FwvedY1A8FislDw6H7lKBTGGYwJAx0NE0VQQKQ259
         6Bq9nTXjIc/qbq29nbGYAmpbK7R8a5NtJMJ1JlmeY9Kp67jZyNasRBSwJm7a1CAIMVJA
         6yH35ALuqLNhzOzwhbOvWthDWaoqnDCPm5C8UhG7RXftthbvYUGkfU3+HpHODSJglEkD
         I4rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vslfN7+uZdJ5X5LoIB1UDDE0PItPz9PS/+QD4kaZ9Qc=;
        b=rotD93SMwviF51/cL1yn66ScDoMsiYHS5TEmXT5y2yu9iJwNdS+FqHFmqCZYLN69oY
         Mv66v7qfdqewzNnwksvDi9c7CsuskQNCw+dJi3GA9strrwF40tmSz2wO8jtHj6Nc/LAl
         Z7veL2nod6bn1LLdAnJbHDl0PzpdajMhi7rs03a8wbki+vtyq2Md+TM8laNx8bdeKFHP
         Ix+dO0aUrfECObr6iCWiN96j9ljrOlPEs2ZyFl2sg/6Lp8C6qpU5bnUd9shB8Beb8wEG
         bmzQGeq8mKz++nFn9O1XoHgkaVnYItUbvaOM74y4+A+aIwQ5x4kx/YY+nVfkbO1Tq9RF
         LjzQ==
X-Gm-Message-State: ACrzQf1cji+ewEmlr+x2VS6di2SwNDJEUntTnT5lG5wH7NI7tEXJ0wPc
        j+X8gaq26O7QZu6kRLTrjaZaoWTGJw2MLgVVhUkfflYl5yBXLA==
X-Google-Smtp-Source: AMsMyM6SqKo1n8w/PerIEwv9gPQ7SmsgnzzgS5665pJKdC2WyaS51oC6+PxtlNaaxyHjuFp2Eb33GMhDlZ3ZRNZyky4=
X-Received: by 2002:adf:e94a:0:b0:236:6f5a:e89b with SMTP id
 m10-20020adfe94a000000b002366f5ae89bmr5032284wrn.451.1666636182803; Mon, 24
 Oct 2022 11:29:42 -0700 (PDT)
MIME-Version: 1.0
References: <20221021185916.1494314-1-vipinsh@google.com> <Y1L9Z8RgIs8yrU6o@google.com>
 <CAHVum0eoA5j7EPmmuuUb2y7XOU1jRpFwJO90tc+QBy0JNUtBsQ@mail.gmail.com>
 <Y1MXgjtPT9U6Cukk@google.com> <87k04pbfqd.fsf@ovpn-193-3.brq.redhat.com> <Y1atxgq2SDkHbP9I@google.com>
In-Reply-To: <Y1atxgq2SDkHbP9I@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Mon, 24 Oct 2022 11:29:06 -0700
Message-ID: <CAHVum0f=gRgrP=rTySn1zwPz65g6jm_3f-=qusmS7jOkKyUMSw@mail.gmail.com>
Subject: Re: [RFC PATCH] Add Hyperv extended hypercall support in KVM
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, pbonzini@redhat.com,
        dmatlack@google.com, kvm@vger.kernel.org, shujunxue@google.com,
        terrytaehyun@google.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 24, 2022 at 8:22 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Oct 24, 2022, Vitaly Kuznetsov wrote:
> > While some 'extended' hypercalls may indeed need to be handled in KVM,
> > there's no harm done in forwarding all unknown-to-KVM hypercalls to
> > userspace. The only issue I envision is how would userspace discover
> > which extended hypercalls are supported by KVM in case it (userspace) is
> > responsible for handling HvExtCallQueryCapabilities call which returns
> > the list of supported hypercalls. E.g. in case we decide to implement
> > HvExtCallMemoryHeatHint in KVM, how are we going to communicate this to
> > userspace?
> >
> > Normally, VMM discovers the availability of Hyper-V features through
> > KVM_GET_SUPPORTED_HV_CPUID but extended hypercalls are not listed in
> > CPUID. This can be always be solved by adding new KVM CAPs of
> > course. Alternatively, we can add a single
> > "KVM_CAP_HYPERV_EXT_CALL_QUERY" which will just return the list of
> > extended hypercalls supported by KVM (which Vipin's patch adds anyway to
> > *set* the list instead).
>
> AIUI, the TLFS uses a 64-bit mask to enumerate which extended hypercalls are
> supported, so a single CAP should be a perfect fit.  And KVM can use the capability
> to enumerate support for _and_ to allow userspace to enable in-kernel handling.  E.g.
>
> check():
>         case KVM_CAP_HYPERV_EXT_CALL:
>                 return KVM_SUPPORTED_HYPERV_EXT_CALL;
>
>
> enable():
>
>         case KVM_CAP_HYPERV_EXT_CALL:
>                 r = -EINVAL;
>                 if (mask & ~KVM_SUPPORTED_HYPERV_EXT_CALL)
>                         break;
>
>                 mutex_lock(&kvm->lock);
>                 if (!kvm->created_vcpus) {

Any reason for setting capability only after vcpus are created?
Also, in my patch I wrote the ioctl at kvm_vcpu_ioctl_enable_cap() as
all of the hyperv related code was there but since this capability is
a vm setting not a per vcpu setting, should this be at  kvm_vm_ioctl()
as a better choice?

>                         to_kvm_hv(kvm)->ext_call = cap->args[0];
>                         r = 0;
>                 }
>                 mutex_unlock(&kvm->lock);
>
> kvm_hv_hypercall()
>
>
>         case HV_EXT_CALL_QUERY_CAPABILITIES ... HV_EXT_CALL_MAX:
>                 if (unlikely(hc.fast)) {
>                         ret = HV_STATUS_INVALID_PARAMETER;
>                         break;
>                 }
>                 if (!(hc.code & to_kvm_hv(vcpu->kvm)->ext_call))

It won't be directly this. There will be a mapping of hc.code to the
corresponding bit and then "&" with ext_call.


>                         goto hypercall_userspace_exit;
>
>                 ret = kvm_hv_ext_hypercall(...)
>                 break;
>
>
> That maintains backwards compatibility with "exit on everything" as userspace
> still needs to opt-in to having KVM handle specific hypercalls in-kernel, and it
> provides the necessary knob for userspace to tell KVM which hypercalls should be
> allowed, i.e. ensures KVM doesn't violate HV_EXT_CALL_QUERY_CAPABILITIES.

So, should I send a version with KVM capability similar to above or
for now just send the version which by default exit to userspace and
later whenever the need arises KVM capability can be added then?
