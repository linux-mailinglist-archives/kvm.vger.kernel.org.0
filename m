Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C04295F8DE
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 15:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfGDNJL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 09:09:11 -0400
Received: from mail-lf1-f43.google.com ([209.85.167.43]:33268 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbfGDNJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 09:09:11 -0400
Received: by mail-lf1-f43.google.com with SMTP id y17so4238107lfe.0
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2019 06:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Rl7ZE2p5oqBeq4Sb78kTphgrtz1wgjRVIAbyeObPYc=;
        b=iK3n1keE4uNcZxEU7Kn3/dyct5CnVCVuDW7zJKFbtRT2ND5ZRxmMaa8TcGdeD4f1SA
         zSZGxRv5zW+2wmooPbYrQBGuLpEWWAdj6eUXKemWZvUitFbJKv6hdxNggZo4fyTze8tn
         5g0HrNOua13SFM+0ccDQmcf0MT9BRF9Ljk+GgbsQ6AsJfiVCV490PTUCuU/TY9TRbYLf
         2X5m3cbacqnYT+2NWBMoaV4GsNfe3P7jqjQwc/7g0IP7q4G99A5Nha2TBNwz+rNXcRco
         TMa/ZebgOkHr4L7JVQ1UNwjfnk1KXQgyvobDrQbn2G7rer1KvzVlsBUnC2FixQXNSXVR
         Ly0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Rl7ZE2p5oqBeq4Sb78kTphgrtz1wgjRVIAbyeObPYc=;
        b=jKFzyamyr5HcA7tF9Z9DSf2O1/nRpAfn7mTIFj1PAQebWSB8jjle525+suNMTp7RVE
         bpa7Vn4hKSrSHPBO6DKLr5w5lk8qa59/Ce8t5j1dq9v/owaH/HWcZTp4imkTqGOV7/N4
         re4fUwmnT/ZuePyv/uPh30EyWkcyWJaqQ5l64sgJiSkJVAJtFX517vb2yHD28iADH+KS
         v0V+d37VRViyrQbS4N/dociw0X0IiIrX/rxPnXxA4PqeAMwtKVfoSkx+ACk8vr1RADz5
         mWdlfHPGh4LnCnSFfmCs23XFxx+arRx29SEbhGOGe/a2j33kcTzhBmU9anPpFMa3eVOO
         bBjg==
X-Gm-Message-State: APjAAAXB/YDryz407eZgAb6/TC/mTigZ0aDZIkvrmV00yijXnbb4Etsv
        9L4ig3Z2B/TftMwgzVboTcfxKWR+41IuCCxcbOwwNg==
X-Google-Smtp-Source: APXvYqx8o/c2n8pkABbYeKvByIRzXvFsOALTe0pBu65vHSLco8W0JmPx6iPFxRD+BithHcdmXcOUDUbbPJuPRPwBLlM=
X-Received: by 2002:ac2:482d:: with SMTP id 13mr1755610lft.132.1562245749209;
 Thu, 04 Jul 2019 06:09:09 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtVU2FoQ_cH71edFH-YfyFWZwi4s7tPxMW6aFG0pDEjPA@mail.gmail.com>
 <20190627081650.frxivyrykze5mqdv@kamzik.brq.redhat.com> <e10ac8cc-9bf6-b07d-00d9-83d9cc0f4b98@redhat.com>
In-Reply-To: <e10ac8cc-9bf6-b07d-00d9-83d9cc0f4b98@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 4 Jul 2019 18:38:57 +0530
Message-ID: <CA+G9fYuuOX7URAPdzR-xEAZBWLsdSLV9-UBrP0L5nAXOK94Baw@mail.gmail.com>
Subject: Re: Pre-required Kconfigs for kvm unit tests
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm list <kvm@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        karl.heubaum@oracle.com, andre.przywara@arm.com, cdall@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Thu, 27 Jun 2019 at 14:19, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
on x86_64,

> For x86 there's just CONFIG_KVM_INTEL and CONFIG_KVM_AMD.

As per your suggestions I have to enabled KVM configs.
Which auto enabled below list of configs.
With these config changes the number of test pass increased from 23 to 45.

PASS 45
FAIL  1
SKIP 10
Total 56

FAILED:
--------------
vmware_backdoors

SKIPPED:
--------------
pku
svm
taskswitch
taskswitch2
ept
vmx_eoi_bitmap_ioapic_scan
vmx_hlt_with_rvi_test
vmx_apicv_test
hyperv_connections
pmu

Extra configs enabled:
-------------------------------
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
CONFIG_KVM_AMD=y
CONFIG_KVM_MMU_AUDIT=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_IRQ_BYPASS_MANAGER=y

>
> Paolo

Thanks for great help.

Best regards
Naresh Kamboju
