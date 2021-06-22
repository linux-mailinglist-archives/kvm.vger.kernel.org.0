Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624573AFD92
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 09:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhFVHJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 03:09:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229890AbhFVHJy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 03:09:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624345658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BpxLvUdEN4UOwGk1JTOpTM4c5SQrD6XCtpiY9c/D+sc=;
        b=Bh/0elMG5ApqAHS87Fgqow3DOrM/sCSoIC5mn7FQZXit90KVw/0kGJZkWnUDLEq0KHyLtQ
        Fri7+0VaUePT5LoYD7VWIg3YwZ2wQNM++qJQrV/IbrbzIhNycovAKCOwY4Lk4YLke8tvSs
        APFufwWVMwzxCYi3VhFQOTRSd1GQmes=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-azcIy1qoOOuzmQZCidK_uw-1; Tue, 22 Jun 2021 03:07:36 -0400
X-MC-Unique: azcIy1qoOOuzmQZCidK_uw-1
Received: by mail-ej1-f71.google.com with SMTP id g6-20020a1709064e46b02903f57f85ac45so2858142ejw.15
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 00:07:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BpxLvUdEN4UOwGk1JTOpTM4c5SQrD6XCtpiY9c/D+sc=;
        b=MnlCrbp70SMiilMr8bA/k9uouIjkP6wBWFtU7DTVLQ6zzwog3KQmzz2duo5bFlBF4E
         aUN7eQbl2ADN6t9adlL2S64czaayhMqmRIjWvesTb7ku8bQ5GpXkyQ7aRO9e9WgVlhJB
         wODc9eqoRF136V+ujYoFKBvOeGbPDRaoH9NOk1WyP7YO9GfQiZuvwmqO2rEUPWVkelcf
         27Rf4+I9gO6Wzvczxsd3MqUmDnmEeU7oamjMqTfg9NSJ13eCWnScMHBGYyrCk/CvEF0/
         cEITq6dCpvf+Ant8ht+LLIv7RNxI1Rqe453rCBs4W7TwhuWF0s6CkWII/OGXQeGDzX88
         QtdQ==
X-Gm-Message-State: AOAM533/B1+BkxXJggObq5euf20reVrInB2lRC5GJCdCIdC4Vs8PNvja
        qSQwp+tc/80RtaEPz4YB/RghR4MkQ6c9EnvhatabnYx9T1zjFzSezTcDstVZyrf0Xd7E1noDADv
        6+aMoNYaiS5k6+kuLkNMbETlEQbT7k2gskSV/HW2YeZUmnlMzdqJNJHrXlgNAST8=
X-Received: by 2002:a17:906:670c:: with SMTP id a12mr2323240ejp.249.1624345655056;
        Tue, 22 Jun 2021 00:07:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIRL7kFdSnYi6ayAi9cWByQS1oJPIkRm7y2jVnBDl937Rh9GVFkpzhNuSsQPogXJRPDSPj+A==
X-Received: by 2002:a17:906:670c:: with SMTP id a12mr2323214ejp.249.1624345654861;
        Tue, 22 Jun 2021 00:07:34 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id h20sm5416875ejl.7.2021.06.22.00.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 00:07:34 -0700 (PDT)
Date:   Tue, 22 Jun 2021 09:07:32 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, ricarkol@google.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: Re: [PATCH v3 0/5] KVM: arm64: selftests: Fix get-reg-list
Message-ID: <20210622070732.zod7gaqhqo344vg6@gator>
References: <20210531103344.29325-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531103344.29325-1-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 31, 2021 at 12:33:39PM +0200, Andrew Jones wrote:
> v3:
>  - Took Ricardo's suggestions in order to avoid needing to update
>    prepare_vcpu_init, finalize_vcpu, and check_supported when adding
>    new register sublists by better associating the sublists with their
>    vcpu feature bits and caps [Ricardo]
>  - We now dynamically generate the vcpu config name by creating them
>    from its sublist names [drew]
> 
> v2:
>  - Removed some cruft left over from a previous more complex design of the
>    config command line parser
>  - Dropped the list printing factor out patch as it's not necessary
>  - Added a 'PASS' output for passing tests to allow testers to feel good
>  - Changed the "up to date with kernel" comment to reference 5.13.0-rc2
> 
> 
> Since KVM commit 11663111cd49 ("KVM: arm64: Hide PMU registers from
> userspace when not available") the get-reg-list* tests have been
> failing with
> 
>   ...
>   ... There are 74 missing registers.
>   The following lines are missing registers:
>   ...
> 
> where the 74 missing registers are all PMU registers. This isn't a
> bug in KVM that the selftest found, even though it's true that a
> KVM userspace that wasn't setting the KVM_ARM_VCPU_PMU_V3 VCPU
> flag, but still expecting the PMU registers to be in the reg-list,
> would suddenly no longer have their expectations met. In that case,
> the expectations were wrong, though, so that KVM userspace needs to
> be fixed, and so does this selftest.
> 
> We could fix the test with a one-liner since we just need a
> 
>   init->features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
> 
> in prepare_vcpu_init(), but that's too easy, so here's a 5 patch patch
> series instead :-)  The reason for all the patches and the heavy diffstat
> is to prepare for other vcpu configuration testing, e.g. ptrauth and mte.
> With the refactoring done in this series, we should now be able to easily
> add register sublists and vcpu configs to the get-reg-list test, as the
> last patch demonstrates with the pmu fix.
> 
> Thanks,
> drew
> 
> 
> Andrew Jones (5):
>   KVM: arm64: selftests: get-reg-list: Introduce vcpu configs
>   KVM: arm64: selftests: get-reg-list: Prepare to run multiple configs
>     at once
>   KVM: arm64: selftests: get-reg-list: Provide config selection option
>   KVM: arm64: selftests: get-reg-list: Remove get-reg-list-sve
>   KVM: arm64: selftests: get-reg-list: Split base and pmu registers
> 
>  tools/testing/selftests/kvm/.gitignore        |   1 -
>  tools/testing/selftests/kvm/Makefile          |   1 -
>  .../selftests/kvm/aarch64/get-reg-list-sve.c  |   3 -
>  .../selftests/kvm/aarch64/get-reg-list.c      | 439 +++++++++++++-----
>  4 files changed, 321 insertions(+), 123 deletions(-)
>  delete mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
> 
> -- 
> 2.31.1
>

Gentle ping.

I'm not sure if I'm pinging Marc or Paolo though. MAINTAINERS shows Paolo
as all kvm selftests, but I think Marc has started picking up the AArch64
specific kvm selftests.

Marc, if you've decided to maintain AArch64 kvm selftests, would you be
opposed to adding

  F: tools/testing/selftests/kvm/*/aarch64/
  F: tools/testing/selftests/kvm/aarch64/

to "KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)"?

Thanks,
drew

