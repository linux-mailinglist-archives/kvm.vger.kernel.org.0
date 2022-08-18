Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5692598DFA
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 22:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345996AbiHRU1V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 16:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbiHRU1R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 16:27:17 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4312DEE
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 13:27:16 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id z25so3585766lfr.2
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 13:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=YFGXFQYXoVmCKVOEKwu97UXFn2U3AKJvDm+SfaJoYO4=;
        b=Kg/+UwF/PjZcgJojrLe8crYywuCgJF7fjAMH2vaga51BWn+eB6q5UyWDZ2vLdYlygw
         qwAxfaqxP53PQsYqxKHaDfOE4fH2r4F/YowOx0s6zlpcdliIE86AjWo3KtTM0eLty4zN
         0pE3IvZDVjOKNHoMWtDUt7ukVUPX35N11KgzJXwajQuP3z7vazO96b7FVKgs6QqkmyqR
         S4SdIywqI/Ayi22lUmsuFJQds2UWcT7CI1kjxYM1N2ooPGmdYea5rjqzOv8BI+gn+buN
         wOWn3yuNVo06C1BNb1Kbt34iKicwruuYFIaN0ZVmHZ1xljDUu6xVP0AwZsPXL3V8qHiU
         BNqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=YFGXFQYXoVmCKVOEKwu97UXFn2U3AKJvDm+SfaJoYO4=;
        b=GdqBPtWiRLV1hijU533qSabUp25IAiU9oUesDUr2q2sGbYmgTAyZ6wt1j819kbaVrH
         R1jvYG8RmsW4WJCSrKCuDYIdBqlM7kidMyXpdk/S1af51C2oMOo6ir7uApA+Nwmz0qUp
         /JWP3qlM7oXvKIzLcejrWSnE1aQ2/JGjFaGSJ4Hn+W8bYjTh8SxLQbgSMnEXV0Muyocf
         kw3CyPb79fTlg/SwDkdEbWJNqHapPPkhTE2ygsQ29tyREr26LIJDiRTEaxzXrNPfd8zm
         LuGz+MVEHH9evkMoNcsOZI4dqWYZfoSkRLZjzpmbXuailE4L4pBhckySsIKmB2QGBnni
         CtCg==
X-Gm-Message-State: ACgBeo3+KkBl/h+p9YIVQ+htuqjmdG6rTDOFqf8TrZyjAvN3Z9QiJToc
        40drDxJwo8HzW1pA+wgGd9RQ9g==
X-Google-Smtp-Source: AA6agR435eQ7zhcL0O1VLmN9oVGRJLUlszDqf0RCJ5hJP92A+zPLJKKglvEexuf6VCP8p99DlW5YGg==
X-Received: by 2002:ac2:4c41:0:b0:48b:3b16:1bd7 with SMTP id o1-20020ac24c41000000b0048b3b161bd7mr1333516lfk.562.1660854434812;
        Thu, 18 Aug 2022 13:27:14 -0700 (PDT)
Received: from dmaluka.office.semihalf.net ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id b5-20020a056512070500b0048b0c59ed9asm341400lfs.227.2022.08.18.13.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 13:27:14 -0700 (PDT)
From:   Dmytro Maluka <dmy@semihalf.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>, upstream@semihalf.com,
        Dmitry Torokhov <dtor@google.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        Dmytro Maluka <dmy@semihalf.com>
Subject: [PATCH v3 0/2] KVM: x86/ioapic: Fix oneshot interrupts forwarding
Date:   Thu, 18 Aug 2022 22:26:59 +0200
Message-Id: <20220818202701.3314045-1-dmy@semihalf.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM irqfd based emulation of level-triggered interrupts doesn't work
quite correctly in some cases, particularly in the case of interrupts
that are handled in a Linux guest as oneshot interrupts (IRQF_ONESHOT).
Such an interrupt is acked to the device in its threaded irq handler,
i.e. later than it is acked to the interrupt controller (EOI at the end
of hardirq), not earlier.

Linux keeps such interrupt masked until its threaded handler finishes,
to prevent the EOI from re-asserting an unacknowledged interrupt.
However, with KVM + vfio (or whatever is listening on the resamplefd)
we always notify resamplefd at the EOI, so vfio prematurely unmasks the
host physical IRQ, thus a new physical interrupt is fired in the host.
This extra interrupt in the host is not a problem per se. The problem is
that it is unconditionally queued for injection into the guest, so the
guest sees an extra bogus interrupt. [*]

There are observed at least 2 user-visible issues caused by those
extra erroneous interrupts for a oneshot irq in the guest:

1. System suspend aborted due to a pending wakeup interrupt from
   ChromeOS EC (drivers/platform/chrome/cros_ec.c).
2. Annoying "invalid report id data" errors from ELAN0000 touchpad
   (drivers/input/mouse/elan_i2c_core.c), flooding the guest dmesg
   every time the touchpad is touched.

The core issue here is that by the time when the guest unmasks the IRQ,
the physical IRQ line is no longer asserted (since the guest has
acked the interrupt to the device in the meantime), yet we
unconditionally inject the interrupt queued into the guest by the
previous resampling. So to fix the issue, we need a way to detect that
the IRQ is no longer pending, and cancel the queued interrupt in this
case.

With IOAPIC we are not able to probe the physical IRQ line state
directly (at least not if the underlying physical interrupt controller
is an IOAPIC too), so in this patch series we use irqfd resampler for
that. Namely, instead of injecting the queued interrupt, we just notify
the resampler that this interrupt is done. If the IRQ line is actually
already deasserted, we are done. If it is still asserted, a new
interrupt will be shortly triggered through irqfd and injected into the
guest.

In the case if there is no irqfd resampler registered for this IRQ, we
cannot fix the issue, so we keep the existing behavior: immediately
unconditionally inject the queued interrupt.

This patch series fixes the issue for x86 IOAPIC only. In the long run,
we can fix it for other irqchips and other architectures too, possibly
taking advantage of reading the physical state of the IRQ line, which is
possible with some other irqchips (e.g. with arm64 GIC, maybe even with
the legacy x86 PIC).

[*] In this description we assume that the interrupt is a physical host
    interrupt forwarded to the guest e.g. by vfio. Potentially the same
    issue may occur also with a purely virtual interrupt from an
    emulated device, e.g. if the guest handles this interrupt, again, as
    a oneshot interrupt.


v3:
  - Completely reworked: instead of postponing resamplefd notify until
    unmask (to avoid extra interrupts in the host), resample the pending
    status at unmask to avoid erroneous propagation of those extra
    interrupts to the guest.
    Thanks to Marc Zyngier for helping to identify the core issue, which
    resulted in a simpler and probably more sensible implementation
    (even though Marc's concern about presenting inaccurate pending
    status to the guest is a non-issue in the case of IOAPIC, since
    IOAPIC doesn't present this information anyway).

v2:
  - Fixed compilation failure on non-x86: mask_notifier_list moved from
    x86 "struct kvm_arch" to generic "struct kvm".
  - kvm_fire_mask_notifiers() also moved from x86 to generic code, even
    though it is not called on other architectures for now.
  - Instead of kvm_irq_is_masked() implemented
    kvm_register_and_fire_irq_mask_notifier() to fix potential race
    when reading the initial IRQ mask state.
  - Renamed for clarity:
      - irqfd_resampler_mask() -> irqfd_resampler_mask_notify()
      - kvm_irq_has_notifier() -> kvm_irq_has_ack_notifier()
      - resampler->notifier -> resampler->ack_notifier
  - Reorganized code in irqfd_resampler_ack() and
    irqfd_resampler_mask_notify() to make it easier to follow.
  - Don't follow unwanted "return type on separate line" style for
    irqfd_resampler_mask_notify().

Dmytro Maluka (2):
  KVM: irqfd: Make resampler_list an RCU list
  KVM: x86/ioapic: Resample the pending state of an IRQ when unmasking

 arch/x86/kvm/ioapic.c     | 36 ++++++++++++++++++++++++++++--
 include/linux/kvm_host.h  |  9 ++++++++
 include/linux/kvm_irqfd.h |  2 +-
 virt/kvm/eventfd.c        | 47 ++++++++++++++++++++++++++++++++-------
 4 files changed, 83 insertions(+), 11 deletions(-)

-- 
2.37.1.595.g718a3a8f04-goog

