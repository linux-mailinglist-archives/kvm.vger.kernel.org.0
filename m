Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97577D19E7
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 02:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbjJUA0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 20:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233265AbjJUA0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 20:26:33 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331D3D6F
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 17:26:31 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59b5a586da6so11410857b3.1
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 17:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697847990; x=1698452790; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XLajY2EgsRMhFXb021iDhWt7wlyo3S6J5z4JRl54ma8=;
        b=jV7LjtGgc+DIkKYA4foz1XDlIy2bkQ41zgmC7ZJ64J1Z58prFOql7e2IQ80cwd3odN
         72tTDir6aIIaF1F4aA1cdn6FNUwhPT7Qjcoi2h4IADVRK8we0LsN+nZx7FpHPhZciVbU
         2UQy9F+4nu6nqAeccpOGhWjXLQeyXFl1x4jdfII/HRhAYBa2FRDVBkAhL4C/nRJYqzwg
         1WeHUkhrEfSnibL3+UoZZQkXpjYllgILjYjwOTl9QCqj1yZpmeOLeTcoEA+4REogmz46
         RxW92fTjw5UKua+hTiK19APS00VG4QvTZpgqaVEpSfu2wA+hynAyxn1tkC+xo9O345IL
         /uKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697847990; x=1698452790;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XLajY2EgsRMhFXb021iDhWt7wlyo3S6J5z4JRl54ma8=;
        b=oJuMJKKldk7bt36Go9TYLglbioK13DT4dP5xd47ro8Oi/1JjDJZ5ElT4mbUlxmomMu
         lya43qNUwn/mDdOm04HG8k/1hyLFk1Kj1TQWSNFzfegv2trlOudYupIEA/MeiLquOkPW
         VWBajyLA5xIgMYRtAW/mr01CxV37I+LgcPCZkplbG8CJob6qlxObfYPxvm9C8UxniWVR
         RrANPFAPmoJh+arB/qtVHZV2YC7+Z+q3HbLY9cqZlGAsccRfaii2oedaK9xu0CYmFL0u
         p/+BtqEHNEtbIi9UhEPzo9rcs+Oa9o8Yq3DC3c/hLMX4TWm4i1Tnbh25Nr2GHW8uFYal
         pohQ==
X-Gm-Message-State: AOJu0Ywi2gxYYdcPGKnNfz9wsI6kOGb/MptDE0kfiOFdhmf+Da+wHYqU
        tWn9ts00p5YZDiBUJs5MxjkrDcziE54=
X-Google-Smtp-Source: AGHT+IF+WDPHfnkC3I1jgqRaRfeZ2N1Z3bh9AxoCiE38ckeyHJs80J+tDdB/dq+uPs3d8CxxASGM6KbH0hI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:7815:0:b0:59b:b0b1:d75a with SMTP id
 t21-20020a817815000000b0059bb0b1d75amr203036ywc.4.1697847990379; Fri, 20 Oct
 2023 17:26:30 -0700 (PDT)
Date:   Fri, 20 Oct 2023 17:26:28 -0700
In-Reply-To: <20230913124227.12574-1-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
Message-ID: <ZTMatKliYT5_I0bg@google.com>
Subject: Re: [PATCH v11 00/16] LAM and LASS KVM Enabling
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com,
        guang.zeng@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 13, 2023, Binbin Wu wrote:
> Binbin Wu (10):
>   KVM: x86: Consolidate flags for __linearize()
>   KVM: x86: Use a new flag for branch targets
>   KVM: x86: Add an emulation flag for implicit system access
>   KVM: x86: Add X86EMUL_F_INVLPG and pass it in em_invlpg()
>   KVM: x86/mmu: Drop non-PA bits when getting GFN for guest's PGD
>   KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to check CR3's legality
>   KVM: x86: Remove kvm_vcpu_is_illegal_gpa()
>   KVM: x86: Introduce get_untagged_addr() in kvm_x86_ops and call it in
>     emulator
>   KVM: x86: Untag address for vmexit handlers when LAM applicable
>   KVM: x86: Use KVM-governed feature framework to track "LAM enabled"
> 
> Robert Hoo (3):
>   KVM: x86: Virtualize LAM for supervisor pointer
>   KVM: x86: Virtualize LAM for user pointer
>   KVM: x86: Advertise and enable LAM (user and supervisor)
> 
> Zeng Guang (3):
>   KVM: emulator: Add emulation of LASS violation checks on linear
>     address
>   KVM: VMX: Virtualize LASS
>   KVM: x86: Advertise LASS CPUID to user space

This all looks good!  I have a few minor nits, but nothing I can't tweak when
applying.  Assuming nothing explodes in testing, I'll get this applied for 6.8
next week.

My apologies for not getting to this sooner and missing 6.7 :-(
