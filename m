Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08720770BDF
	for <lists+kvm@lfdr.de>; Sat,  5 Aug 2023 00:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbjHDWVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 18:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbjHDWVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 18:21:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958EC10EA
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 15:21:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c8f360a07a2so2567672276.2
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 15:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691187663; x=1691792463;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/b75SsC9scGnF35935tzcOT5yZXu5YqOH3IvVYTIO2M=;
        b=6FIcWAdAD/y19QrMG96QEM8qoHmJvas1148syfBbX+sRjRgF3cTEEPXcRYJ18kwrhR
         wY1q1+67C0HpeIGox5P8r/KCkTFi3U9liXADQWiM+qrM2aKtTpLGMlaHBY/cwEmHqDag
         55NBesv7opvqVSXeMQ/XhCcEiQaob/XbWgJuO9P9NPREzbwde2YtLaKx/LIR1bU4bSGA
         vKED5hykI3YzHz6tuRxWQPNfi782TDdzjvwHcwH00mR7PMQQCUUaimJi9vrPA4nwsUPK
         fw33ZNAR45xNkwbyPFD1Jm5kDJJa0yX39n9UidMVMX27yXlJSZZi9LYWSjpFc1ENr2bv
         rW3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691187663; x=1691792463;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/b75SsC9scGnF35935tzcOT5yZXu5YqOH3IvVYTIO2M=;
        b=dST20Sm0cHp5c1Smz02+RPq8oyhxvC2uAeS8x3AAMPIdV0xK75vnPKR5PfPauT0cPC
         GRZlBmnZRX6ts7FFBUp4yEdvkpCjpDzlnj5ifSMxOti04UoGvn36ux+jlJETRWnRSiAl
         51z+6S5arlk5BiYtOt9UQZpOB7L4lV4pfH4gBZ78A3j9Ibf4g97gAWFa03JFr7Eg2vG+
         HArHNR46f00Ag82nqkqF4fIuftt9omciVCllrnfkq/y7oqdCUEP0f1SqKZylDEY3Y0g7
         /ecw30PI3G5O3/ywzJ66lAsBey/QhCXjTknqSZmYtwfok7LnYpWmiAdUpZoaVH5aVkmF
         Sb1w==
X-Gm-Message-State: AOJu0YwiaiieXWNzACO1aNVfz2CocGtO9ony70ml3tjHfOUbN9ii6Ite
        GUdeF6q+bBtgvFnrV9YKFov40359y+U=
X-Google-Smtp-Source: AGHT+IFxxYBFH5my/2+uZ9Q6VY5C7xgo4Zgh009je/H07I1uOf8Iit/Wc6LPC/VGWP9RteGn6/kCxzDIifc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:dbcf:0:b0:d01:60ec:d0e with SMTP id
 g198-20020a25dbcf000000b00d0160ec0d0emr17435ybf.9.1691187662858; Fri, 04 Aug
 2023 15:21:02 -0700 (PDT)
Date:   Fri, 4 Aug 2023 15:21:01 -0700
In-Reply-To: <c5bdcd8e-c6cd-d586-499c-4a2b7528cda9@redhat.com>
Mime-Version: 1.0
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-12-weijiang.yang@intel.com> <ZMyJIq4CgXxudJED@chao-email>
 <ZM1tNJ9ZdQb+VZVo@google.com> <c5bdcd8e-c6cd-d586-499c-4a2b7528cda9@redhat.com>
Message-ID: <ZM15zd998LCOUOrZ@google.com>
Subject: Re: [PATCH v5 11/19] KVM:VMX: Emulate read and write to CET MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Chao Gao <chao.gao@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com,
        binbin.wu@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 04, 2023, Paolo Bonzini wrote:
> On 8/4/23 23:27, Sean Christopherson wrote:
> > > > +
> > > > +	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> > > > +	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> > > > +		return false;
> > > > +
> > > > +	return msr->host_initiated ||
> > > > +		guest_cpuid_has(vcpu, X86_FEATURE_IBT) ||
> > > > +		guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> > 
> > Similar to my suggestsion for XSS, I think we drop the waiver for host_initiated
> > accesses, i.e. require the feature to be enabled and exposed to the guest, even
> > for the host.
> 
> No, please don't.  Allowing host-initiated accesses is what makes it
> possible to take the list of MSR indices and pass it blindly to KVM_GET_MSR
> and KVM_SET_MSR.

I don't see how that can work today.  Oooh, the MSRs that don't exempt host_initiated
are added to the list of MSRs to save/restore, i.e. KVM "silently" supports
MSR_AMD64_OSVW_ID_LENGTH and MSR_AMD64_OSVW_STATUS.

And guest_pv_has() returns true unless userspace has opted in to enforcement.

Sad panda.

That means we need to figure out a solution for KVM stuffing GUEST_SSP on RSM,
which is a "host" write but a guest controlled value.
