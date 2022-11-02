Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7BF616BD5
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 19:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiKBSRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 14:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbiKBSRk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 14:17:40 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DED9240AD
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 11:17:39 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-370547b8ca0so94336687b3.0
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 11:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=c+z7qmImi7+COI679LrKI0YycnRNIrWvZFXZegly2PM=;
        b=UiKRHcJa55+84WNfWhM5EZqWES7cjX4MU9lzpv6lIJgVS8kpb4Xv5ta8L74nF+voDq
         r1NcdcVLPRK7kKgkVVkLn+F0v75o5uuYKBLXNvChLKMb9tG+V9lbCRfASIR1+mueCRHO
         /aPAhOQhXxhVojo/8zcIlYvIdX2yfItmEKC37pGhLQ5iDAwozVcElI054QOo5mx+CIco
         ywOdcdmrop8NKqNGRXLZTE1BzVelXf/s6JlivGFIXRHvRYf3BDro7YodmJch/ptILn8A
         /l0OJcfh2j2jHreZDUhY6//GCBDQjaiVfuBNuZ6nzGYMa5DS3mnzY5dJfktRAdYTszi2
         CuEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c+z7qmImi7+COI679LrKI0YycnRNIrWvZFXZegly2PM=;
        b=I+NefdZt7C/WZDCSGOCFEXRgj7ka74wbGu8wfUv4EzF+jteCQeUhHk95wGzeVJlNPo
         H1eYFBbR+WS9MNXtel4TVWB3pH3dG59g5LbCoHgB42zwdmCLHq/P+8VpQqXyPTGDvDaC
         ISpbpJLkTUhrwVwIsBINjM2/mxTrccswjc5rwEdkyGR40DnQ+cGp740NK2MOhld7uJ2m
         +wMavGE4Q+lMb2dzyNkgQMWeIsc/IxMbzdIVMVqlAq0/Y9XF/9huzA3UDzpcFtZhCkFA
         LqR0TAfMKYUSt/tos/6gu+e+lClgvIpfRxeO42OV9VDwl3oi+46nWMmVfo+zHpZN9eLX
         2e/Q==
X-Gm-Message-State: ACrzQf2vyMpi3opy3ienWT2WTfdiy2ci9BuxJlytVzRSvhg+P2xIBB+p
        z55zqPl6pXc1oYbxT46bxltVnFFwHMsUSD7pT0O7Bw==
X-Google-Smtp-Source: AMsMyM5BPbQHQqb2/0u69psO9zIrxJapgw+lQHSZgjz8r+BIgHPZR93DZKD/f6ZtOBqLIlMwIKHFx+4PBQ4TvsV+Ens=
X-Received: by 2002:a81:555:0:b0:36b:2d71:5861 with SMTP id
 82-20020a810555000000b0036b2d715861mr24766327ywf.340.1667413058559; Wed, 02
 Nov 2022 11:17:38 -0700 (PDT)
MIME-Version: 1.0
References: <20221031180045.3581757-1-dmatlack@google.com> <20221031180045.3581757-5-dmatlack@google.com>
 <Y2ATsTO8tqs4gtz/@google.com>
In-Reply-To: <Y2ATsTO8tqs4gtz/@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 2 Nov 2022 11:17:12 -0700
Message-ID: <CALzav=eqiCbYaNUgSEsZrRGEA2pv3x5j=oUvbm=_Gho4t50H1g@mail.gmail.com>
Subject: Re: [PATCH v3 04/10] KVM: selftests: Move flds instruction emulation
 failure handling to header
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
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

On Mon, Oct 31, 2022 at 11:28 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Oct 31, 2022, David Matlack wrote:
> > +
> > +static inline void assert_exit_for_flds_emulation_failure(struct kvm_vcpu *vcpu)
>
> I think it makes sense to keeping the bundling of the assert+skip.  As written,
> the last test doesn't need to skip, but that may not always hold true, e.g. if
> the test adds more stages to verify KVM handles page splits correctly, and even
> when a skip is required, it does no harm.  I can't think of a scenario where a
> test would want an FLDS emulation error but wouldn't want to skip the instruction,
> e.g. injecting a fault from userspace is largely an orthogonal test.
>
> Maybe this as a helper name?  I don't think it's necessary to include "assert"
> anywhere in the name, the idea being that "emulated" provides a hint that it's a
> non-trivial helper.
>
>   static inline void skip_emulated_flds(struct kvm_vcpu *vcpu)
>
> or skip_emulated_flds_instruction() if we're concerned that it might not be obvious
> "flds" is an instruction mnemonic.

I kept them separate for readability, but otherwise I have no argument
against bundling. I find skip_emulated*() somewhat misleading since
flds is not actually emulated (successfully). I'm trending toward
something like handle_flds_emulation_failure_exit() for v4.
