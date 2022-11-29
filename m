Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7591563B784
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 02:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbiK2B6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 20:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbiK2B6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 20:58:31 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01593AC34;
        Mon, 28 Nov 2022 17:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669687110; x=1701223110;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7WnAs/ogQxcOHFr4zpg6PBLqxOBhypLc7I/0dnCDlE0=;
  b=DRDN8s9cM0GY0oA2N7FoDbLrDjoj9sTEHRS/nq8FEml/YxL/4DqMxI8c
   Ws2gRwsp+fG2IDA/7GFnKKvcVPjgfYk74aYxl0iaI1t3TgmM44fojtbPG
   JNbs87pJDc5izfsCG6c2khvZGCDZwl+jBoBrAXreHGnOXFEsuC4uUBMKp
   ekicJKzv5ivLHe5BLyJtjA7aKnhfBvPN/CWkc9NPQ21N/xlATyRf47v8H
   yFEyoGN8nP7HHxqz1U6sz5SCZhp5KNOBjx3NE5o+THWNZG1sc/qopZ0E8
   +vwhXHjBd6OrK2tEC3DageeY2h0Irrd54SZ5r/Ej0U5UpuDibmPQlqPby
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="302586115"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="302586115"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 17:58:30 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="818044375"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="818044375"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.254.211.213]) ([10.254.211.213])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 17:58:28 -0800
Message-ID: <96a53991-3bca-2c0f-84d8-54e2f64d29b3@intel.com>
Date:   Tue, 29 Nov 2022 09:58:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.0
Subject: Re: [PATCH v2 0/4] KVM: selftests: AMX test fix and cleanups
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221128225735.3291648-1-seanjc@google.com>
From:   "Wang, Lei" <lei4.wang@intel.com>
In-Reply-To: <20221128225735.3291648-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/29/2022 6:57 AM, Sean Christopherson wrote:
> Fix a bug in the AMX test introduced by moving to kvm_cpu_has() for
> X86_FEATURE_XFD, and clean up the related code.  The fix and cleanups
> all revolve around ARCH_REQ_XCOMP_GUEST_PERM impacting the output of
> KVM_GET_SUPPORTED_CPUID, and thus causing problems for selftest's
> caching of KVM's supported CPUID.
> 
> Lei Wang, I adjusted your Author and SOB tags to drop the comma, which I
> think? violates that "use your real name" rule, and use formatting from
> patches you've sent in the past[*].  Let me know if that's ok (or not).

That's OK, thanks!

> [*] https://lore.kernel.org/all/20220424101557.134102-9-lei4.wang@intel.com
> 
> Lei Wang (1):
>   KVM: selftests: Move XFD CPUID checking out of
>     __vm_xsave_require_permission()
> 
> Sean Christopherson (3):
>   KVM: selftests: Move __vm_xsave_require_permission() below CPUID
>     helpers
>   KVM: selftests: Disallow "get supported CPUID" before
>     REQ_XCOMP_GUEST_PERM
>   KVM: selftests: Do kvm_cpu_has() checks before creating VM+vCPU
> 
>  .../selftests/kvm/lib/x86_64/processor.c      | 84 ++++++++++---------
>  tools/testing/selftests/kvm/x86_64/amx_test.c | 11 ++-
>  2 files changed, 52 insertions(+), 43 deletions(-)
> 
> 
> base-commit: 519c2002cd92bdc37c8412ca22cb9c7e7bc48c48
