Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADCEC5EB476
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 00:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiIZWT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 18:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiIZWTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 18:19:08 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F74E6E88C
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 15:18:49 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id e187so10125455ybh.10
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 15:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=5c7O7OE6y7iEqCyFkwUzzrySNFGgzG3FlSfpwI61xTY=;
        b=ZidBRley+2+0BcNGYx4Fnuhk6Y9qWAsIjqKTMmJrT+swFarQLDCHS3ixYDeFBoAVJE
         H4wC1tnB9PDPVV9t/ZagcrFwsKrTKQ7VbnIneEsXg9oO7kyP4qSgPori/1xDzPDIVswk
         xkR7cpv+eQ7Q1Vr1bCf4ztC3egkl3nlfAPFxJbTT/jqWU95/NvEEFnKYTMvsq7aBHfFd
         uOmLQj+tAHpMdsIK6MxuF9/7SgDSHcgvWpuSlqZp343kOVrTidSw11optu6MLBCWh76Z
         cc9hX6WYgz0ITAdkLJSueB0rgNPjSqFsEQYZT5bc2RZlEBXbrzJd79L27mSqNohuBNGo
         cAnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=5c7O7OE6y7iEqCyFkwUzzrySNFGgzG3FlSfpwI61xTY=;
        b=GAzUQXRQt+e8rzlAdkqoADV2Ik2mcr5UaNPCwHV3mkMxTx06xOK3ADaj0bPYGqnJ5B
         QmORz8zwz6f3DWo6sO97L7YJ+9/QF4/aNMomxcJKNCSqrJbX0T1hemU+ZDyLofg7Whx+
         F9diNDtNRm4mgdHgg8xClnjUJvzHNC65pXm6Pc+55ombgvhkDlHHN1jTSpsBxx2P8jc9
         bTH/4aXvROco8UvZ47ecEbTL8R9v4JP55uBihZDnpWJcJZgZTkGyf+9PNPObZ4TxHS95
         8CSF8eCX9nCp/R1EcxIMXdr4ZBQ5GP3lF0nts+ac3H6HAYUy9TEY7HRMvlT2AbEuES5q
         s5tQ==
X-Gm-Message-State: ACrzQf0T5WyJ7PWzvhHTasqrRWDm4CLib2jH94ngT1JgH3CpImw4fB9G
        yIFw92qTZyN3qlbGa5yoqMfcu1IcJWKyLljt3e4SjQ==
X-Google-Smtp-Source: AMsMyM6rM9f44ys1MMp7kmQeMVaG1OXOWNNkfQ4aWCWOfGxpG7obV3Dk5qplJmFzsNvL8rXPheWTtgpArSwghxJj+1M=
X-Received: by 2002:a25:4fc2:0:b0:680:f309:48e5 with SMTP id
 d185-20020a254fc2000000b00680f30948e5mr23902716ybb.0.1664230728659; Mon, 26
 Sep 2022 15:18:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220926171457.532542-1-dmatlack@google.com> <YzIdfkovobW3w/zk@google.com>
In-Reply-To: <YzIdfkovobW3w/zk@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 26 Sep 2022 15:18:22 -0700
Message-ID: <CALzav=d-4a8yPxPUuHNh1884Z4Pe_0ewMwnunGK_jAAvr9L-vw@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Skip tests that require EPT when it is
 not available
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        kvm list <kvm@vger.kernel.org>
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

On Mon, Sep 26, 2022 at 2:45 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Sep 26, 2022, David Matlack wrote:
> > +bool kvm_vm_has_ept(struct kvm_vm *vm)
> > +{
> > +     struct kvm_vcpu *vcpu;
> > +     uint64_t ctrl;
> > +
> > +     vcpu = list_first_entry(&vm->vcpus, struct kvm_vcpu, list);
> > +     TEST_ASSERT(vcpu, "Cannot determine EPT support without vCPUs.\n");
>
> KVM_GET_MSRS is supported on /dev/kvm for feature MSRs, and is available for
> selftests via kvm_get_feature_msr().

Ack.

>
> > +
> > +     ctrl = vcpu_get_msr(vcpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS) >> 32;
> > +     if (!(ctrl & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
> > +             return false;
> > +
> > +     ctrl = vcpu_get_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS2) >> 32;
> > +     return ctrl & SECONDARY_EXEC_ENABLE_EPT;
> > +}
> > +
> >  void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
> >                 uint32_t eptp_memslot)
> >  {
> > +     TEST_REQUIRE(kvm_vm_has_ept(vm));
>
> I would much rather this be an assert, i.e. force the test to do TEST_REQUIRE(),
> even if that means duplicate code.  One of the roles of TEST_REQUIRE() is to
> document test requirements.

This gets difficult when you consider dirty_log_perf_test. Users can
use dirty_log_perf_test in nested mode by passing "-n". But
dirty_log_perf_test is an architecture-neutral test, so adding
TEST_REQUIRE() there would require an ifdef, and then gets even more
complicated if we add support for AMD or nested on non-x86
architectures.

One option is to put the TEST_REQUIRE() in the x86-specific
perf_test_setup_ept(), but that is only one level above
prepare_eptp(), so not exactly any better at documenting the
requirement.

Another option is to do nothing and let the test fail if running on
hosts without EPT. I don't like this solution though, because that
means developers and automation would need custom logic to skip
running dirty_log_perf_test with -n depending on the state of the
host. (For context: I typically run all selftests and kvm-unit-tests
against kvm with ept=Y and ept=N.)

At least for vmx_dirty_log_test, the TEST_REQUIRE() could be put in main().
