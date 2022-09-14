Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8BC5B8F2E
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 21:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiINTMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 15:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiINTM2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 15:12:28 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA7D82765
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 12:12:27 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so20038777pjm.1
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 12:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=jQp1+Ka6WRFxpjSfTMZnhetzciGUJa6yU4O7NscoajA=;
        b=IeN0Cl+mtGiGg7nrtyNfnplaI4CYtE6C8gQqNLIiK2oJypSmlW93xSxiISSQU4d2MF
         MZ0F9ce+eGGyfWONcZEQ85D7ZRb0Hj9ZUPAvnhzyXj7Kmj/cNJlRXAtLp3Nbh1/OAfE3
         5/VC7tFS32WVWK8E/wGcLAxti3h9HmfRl0a3NLgJOyNVq75XSy9pL8U95YHS5CaPdaNz
         Hlc71gyQT2zomO/d6mQQ3km5/Ce2Z/C0JDwE2L6ty1vw97w+T9yu3Ukw79ErOq4VCNJz
         y7HaRofdUWUDnZwe3qz80Tr7xF2O2c05miWK1B7EkB9TbkD+aeFZt8S2cJOos2EEni8y
         xkIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=jQp1+Ka6WRFxpjSfTMZnhetzciGUJa6yU4O7NscoajA=;
        b=J5LUdA/j2+Jjq8aSJXaIWIllInUsHZWMBezXWavJs7u0iyZcB9I7JS2vHamJtW0UwE
         pVOU+zRNzI4+MQ/u3v8aoMmh4LgQBCFeihANTOSTEsdpjyQdtpT3ty+cT+7KuslF7JHT
         1peF5An9G/pmaFD+XNKDuCgnLJAPqfINcyEdFKzoSa1NMXfA9ksoIp26nF6kwP8eHDsO
         XPHqX9ibvNaPNVEdiFze/o3bQBf31uGrMt3TDHq4TkmCqmcx7KOAS/IbEfI1Tudh0tDX
         f0EH7cC1eAJsJc8CY0UOEAuH6lZMG7ogEeqA8G9UHU6b5qfGBpY3gVJU8zoLHs2cwoGz
         p0iQ==
X-Gm-Message-State: ACrzQf2ll+pnxX6D9TzIxgkDZpTdd6mItq5cso+kRyQeKOX/jawAf8M2
        26EjdTOnt+kicYtGMS+8JW4pWuYlFnMU8IUSQM+Apg==
X-Google-Smtp-Source: AMsMyM6Yh8x46EoMi+PJvPwLgN4UgEvtPjKTPDk5ffiYP9Avu9XXVxjLuzXfnDqVS2xslQdgz+nJGkA5jHEZQRvn2J8=
X-Received: by 2002:a17:902:e74f:b0:178:3af4:fb13 with SMTP id
 p15-20020a170902e74f00b001783af4fb13mr449762plf.19.1663182747200; Wed, 14 Sep
 2022 12:12:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220903012849.938069-1-vannapurve@google.com>
 <20220903012849.938069-4-vannapurve@google.com> <YxpysbHZb2G56K+f@google.com>
In-Reply-To: <YxpysbHZb2G56K+f@google.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Wed, 14 Sep 2022 12:12:16 -0700
Message-ID: <CAGtprH9C9qTSBC8zB+q0K7ZgT=gs6hHy=i=1AQ80cD0U1vg7nA@mail.gmail.com>
Subject: Re: [V1 PATCH 3/5] selftests: kvm: x86: Execute vmcall/vmmcall
 according to CPU type
To:     David Matlack <dmatlack@google.com>
Cc:     x86 <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, shuah <shuah@kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>, drjones@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 8, 2022 at 3:54 PM David Matlack <dmatlack@google.com> wrote:
>
> Please use "KVM: selftest: ..." for the shortlog.
>

Ack.

> On Sat, Sep 03, 2022 at 01:28:47AM +0000, Vishal Annapurve wrote:
> > Modify following APIs for x86 implementation:
> > 1) kvm_arch_main : Query the cpu vendor and cache the value in advance.
> > 2) kvm_arch_post_vm_load: Populate cpu type in the guest memory so that
> >       guest doesn't need to execute cpuid instruction again.
>
> This commit message only describes a subset of the changes in this
> commit, and does not provide any context on why the changes are being
> made (other than a clue about avoiding CPUID).
>
> I also think this could be split up into 2 separate commits.
>

Ack, will add more details to the commit log. Though since
is_amd_cpu/is_intel_cpu is used by both selftest VMM and selftest
guest logic, I would prefer to not split this change into two. For
now, I will upload the series with this change being a single patch.
We can discuss again if this split is really needed.

Regards,
Vishal

> I would suggest first patch changes is_{intel,amd}_cpu() to return a cached
> result. e.g.
>
>   KVM: selftests: Precompute the result for is_{intel,amd}_cpu()
>
>   Cache the vendor CPU type in a global variable so that multiple calls
>   to is_intel_cpu() do not need to re-execute CPUID. This will be useful
>   in a follow-up commit to check if running on AMD or Intel from within
>   a selftest guest where executing CPUID requires a VM-exit.
>
> Then add support for AMD to kvm_hypercall():
>
>   KVM: selftests: Add AMD support to kvm_hypercall()
>
>   Add support for AMD hypercalls to kvm_hypercall() so that it can be
>   used in selftests running on Intel or AMD hosts. This will be used in
>   a follow up commit to ...
>
>   As part of this change, sync the global variable is_cpu_amd into the
>   guest so the guest can determine which hypercall instruction to use
>   without needing to re-execute CPUID for every hypercall.
>
