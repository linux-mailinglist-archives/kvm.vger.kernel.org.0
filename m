Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFAD2416675
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 22:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243084AbhIWUR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 16:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243068AbhIWUR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 16:17:26 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3975C061574
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 13:15:54 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id p80so9679161iod.10
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 13:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JPc+ABXarfxXepFwMKo48Oe1UzLRxS69NAKG8VNocoQ=;
        b=hQo5uYSne1TJBBf9RdJB3DxVuqBUJEMvu5S5/N+VRcG+sGRgyWo3lTlot2bt65MKPz
         ZB9F6zjWxYufa1YhqQi0HkSZpNps2aS045YmU4YDym/aeyJR6cQcCSXwEakLkFW5ko1d
         +YOrIBC0xtT82QN26TJdPw6+tgRxIZeoH05Gnq0r95vol+EZtPAAs8fW8NY5mektdoY+
         lJ5Pq27FDD7jEzg5PhtALk22ol6kAwOlzo0DBbwHD1ayU5YDCFkIgPkltxRdsm31mDg+
         cl1aBM+97pceIikRKcL8klD84d7SD+FMwJP2E9JNeEVCRIjgA9tvi+UJ7r+Vhof3fX2T
         LHGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JPc+ABXarfxXepFwMKo48Oe1UzLRxS69NAKG8VNocoQ=;
        b=Au2U6MEY/hL4pwDGD0kx25s9VR6sqgm2dLJC4KY93yAkehePYVRu7O4Y8GaChiIQlH
         Km+PqDBlwt55fVk1r5QRVBwI5mzXMH+NbuKeZVxeeG402VxZgzAC5DfNvej5bYqJoV3V
         3daqcov8ebP5Q4YAN19+7xI3xFwut7PjuMC9B4hOSF8J5eO6irv2cI2HzoB+eiTOPE93
         YNlcwYsg70O6D+Au3elIQfsBoQujco0i1oi7k9bi5PXhnfwwENFcpj82xf9xmTvC66Y8
         kpH02MeuvsNiazzMqD+ob27DqEaK8WzOpW5Fai4TYMuGDhMCn7joCQ00X1bLwoZFpiOG
         rsYw==
X-Gm-Message-State: AOAM5333Wy0YFelM0KjNElkHXqeBReJFYCx3tCVKDkfH58Yfia7uBKkn
        r47LU1e1xB1vjW82/vVdfdFD/PBoS+sNeg==
X-Google-Smtp-Source: ABdhPJxM4cssV+WmLQLIXzuWCCZybqJxIjRtk5nsOr/aQ+/ddiyBdJqkF8qXyRfSkGma2tFbyuWJSw==
X-Received: by 2002:a02:b704:: with SMTP id g4mr5700224jam.7.1632428153752;
        Thu, 23 Sep 2021 13:15:53 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id c11sm3031576ilu.74.2021.09.23.13.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 13:15:53 -0700 (PDT)
Date:   Thu, 23 Sep 2021 20:15:49 +0000
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 00/11] KVM: arm64: Implement PSCI SYSTEM_SUSPEND
 support
Message-ID: <YUzgdbYk8BeCnHyW@google.com>
References: <20210923191610.3814698-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 07:15:59PM +0000, Oliver Upton wrote:
> Certain VMMs/operators may wish to give their guests the ability to
> initiate a system suspend that could result in the VM being saved to
> persistent storage to be resumed at a later time. The PSCI v1.0
> specification describes an SMC, SYSTEM_SUSPEND, that allows a kernel to
> request a system suspend. This call is optional for v1.0, and KVM
> elected to not support the call in its v1.0 implementation.
> 
> This series adds support for the SYSTEM_SUSPEND PSCI call to KVM/arm64.
> Since this is a system-scoped event, KVM cannot quiesce the VM on its
> own. We add a new system exit type in this series to clue in userspace
> that a suspend was requested. Per the KVM_EXIT_SYSTEM_EVENT ABI, a VMM
> that doesn't care about this event can simply resume the guest without
> issue (we set up the calling vCPU to come out of reset correctly on next
> KVM_RUN). If a VMM would like to have KVM emulate the suspend, it can do
> so by setting the vCPU's MP state to KVM_MP_STATE_HALTED. Support for
> this state has been added in this series.
> 
> Patch 1 is an unrelated cleanup, dropping an unused parameter
> 
> Patch 2 simplifies how KVM filters SMC64 functions for AArch32 guests.
> 
> Patch 3 wraps up the vCPU reset logic used by the PSCI CPU_ON
> implementation in KVM for subsequent use, as we must queue up a reset
> for the vCPU that requested a system suspend.
> 
> Patch 4 is another unrelated cleanup, fixing the naming for the
> KVM_REQ_SLEEP handler to avoid confusion and remain consistent with the
> handler introduced in this series.
> 
> Patch 5 changes how WFI-like events are handled in KVM (WFI instruction,
> PSCI CPU_SUSPEND). Instead of directly blocking the vCPU in the
> respective handlers, set a request bit and block before resuming the
> guest. WFI and PSCI CPU_SUSPEND do not require deferral of
> kvm_vcpu_block(), but SYSTEM_SUSPEND does. Rather than adding a deferral
> mechanism just for SYSTEM_SUSPEND, it is a bit cleaner to have all
> blocking events just request the event.
> 
> Patch 6 actually adds PSCI SYSTEM_SUSPEND support to KVM, and adds the
> necessary UAPI to pair with the call.
> 
> Patch 7 renames the PSCI selftest to something more generic, as we will
> test more than just CPU_ON.
> 
> Patch 8 creates a common helper for making SMC64 calls in KVM selftests,
> rather than having tests open-code their own approach.
> 
> Patch 9 makes the PSCI test use KVM_SET_MP_STATE for powering off a vCPU
> rather than the vCPU init flag. This change is necessary to separate
> generic VM setup from the setup for a particular PSCI test.
> 
> Patch 10 reworks psci_test into a bunch of helpers, making it easier to
> build additional test cases with the common parts.
> 
> Finally, patch 11 adds 2 test cases for the SYSTEM_SUSPEND PSCI call.
> Verify that the call succeeds if all other vCPUs have been powered off
> and that it fails if more than the calling vCPU is powered on.
> 
> This series applies cleanly to v5.15-rc2. Testing was performed on an
> Ampere Mt. Jade system.

Gah, forgot to summarize updates:

v1 -> v2:
 - Rebase to 5.15-rc2
 - Allow userspace to request in-kernel suspend emulation (Marc)
 - Add another test case for SYSTEM_SUSPEND, cleaning up the PSCI
   selftest
 - Create a common SMCCC function for KVM selftests

v1: http://lore.kernel.org/r/20210819223640.3564975-1-oupton@google.com

> Oliver Upton (11):
>   KVM: arm64: Drop unused vcpu param to kvm_psci_valid_affinity()
>   KVM: arm64: Clean up SMC64 PSCI filtering for AArch32 guests
>   KVM: arm64: Encapsulate reset request logic in a helper function
>   KVM: arm64: Rename the KVM_REQ_SLEEP handler
>   KVM: arm64: Defer WFI emulation as a requested event
>   KVM: arm64: Add support for SYSTEM_SUSPEND PSCI call
>   selftests: KVM: Rename psci_cpu_on_test to psci_test
>   selftests: KVM: Create helper for making SMCCC calls
>   selftests: KVM: Use KVM_SET_MP_STATE to power off vCPU in psci_test
>   selftests: KVM: Refactor psci_test to make it amenable to new tests
>   selftests: KVM: Test SYSTEM_SUSPEND PSCI call
> 
>  Documentation/virt/kvm/api.rst                |   6 +
>  arch/arm64/include/asm/kvm_host.h             |   4 +
>  arch/arm64/kvm/arm.c                          |  21 +-
>  arch/arm64/kvm/handle_exit.c                  |   3 +-
>  arch/arm64/kvm/psci.c                         | 138 ++++++++---
>  include/uapi/linux/kvm.h                      |   2 +
>  tools/testing/selftests/kvm/.gitignore        |   2 +-
>  tools/testing/selftests/kvm/Makefile          |   2 +-
>  .../selftests/kvm/aarch64/psci_cpu_on_test.c  | 121 ----------
>  .../testing/selftests/kvm/aarch64/psci_test.c | 218 ++++++++++++++++++
>  .../selftests/kvm/include/aarch64/processor.h |  22 ++
>  .../selftests/kvm/lib/aarch64/processor.c     |  25 ++
>  tools/testing/selftests/kvm/steal_time.c      |  13 +-
>  13 files changed, 403 insertions(+), 174 deletions(-)
>  delete mode 100644 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
>  create mode 100644 tools/testing/selftests/kvm/aarch64/psci_test.c
> 
> -- 
> 2.33.0.685.g46640cef36-goog
> 
