Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE2E7D19EE
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 02:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbjJUAeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 20:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbjJUAeP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 20:34:15 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82ADD70
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 17:34:13 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7d1816bccso18499497b3.1
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 17:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697848453; x=1698453253; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l/l3UkJzV9Lopd0hoSKNnokZZ/oLpoHJjp/TOvxlez8=;
        b=GpHZ9GwEiLb5m5Wyx4FNbJ/IJOjLyDWbK2ZanOPlVpR9AYlIxjJOXfVA9WYSlq6GCx
         8Lvk6msZtuarMWhJN7buzwbth/cVqFnMoJ4lOklEmkOle9JuzOX8aDbCd8VNEtU1uXra
         YkhaK/q1AQpg5AfvKgCGi9yEHHTh1WlYmkE3kWozqx7ZJ1VEfBFWITbrJxyu3aH7uO/R
         NbqdShdEw1FXrNYMi4OnQuZBzM17kyBBFwg6OPKO06FRhlZn2KMJ3kGF4nKmkVFfD5fv
         L1OTWDPAZEaO5fAPFhX+wXHeoDsZQHtSn96Ffd22GMX5WLkY5xPgMg0z9W2G8SOSRV8C
         iUYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697848453; x=1698453253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l/l3UkJzV9Lopd0hoSKNnokZZ/oLpoHJjp/TOvxlez8=;
        b=tPB5eSYbpA3xvYaSOYtssYZvsPlhudU4rWqFom/iQXcchRVExuncq016nmWKIQar16
         vHKy6H2GkXlzzaH5NL0cXb/ndZld09EyC56LIaJnJE8w5E7a+dBG7fGs4zc9hLd53unG
         zRJD0i7NdtZ68gtGcQlA4wsM3DH/CAsjxTM5uxv9MFmbV1gckUDPuG67jWj95wI3iHGL
         YHPXp0PKNC5q/enX6CtAboJE/55KqoILh7RVqO4KE947p+IsBZtMdnDghrM405cuo8qs
         Brs6IShjlTLrcx4dQhcb+svWEL7WGEHHsSi0pNycGvJLChDY9FqkHNqKLYl2WhzAE7Qx
         u58Q==
X-Gm-Message-State: AOJu0YzC5bBc+4+ug/2W7GHHWZOgALUXPyy3GHAx4eYjP2HHx/YLEs66
        10zukS1pisCBf+2dnvax2oSbBuIMQ2A=
X-Google-Smtp-Source: AGHT+IHGGC8nkB1wRJbFarlGVUIVZkTYT0GQ2L1f4TAHd8RVRBKy2a0lYnH91ghA1UQfOMrrTZHWfyHwIWY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:48cc:0:b0:5a7:b9ea:5c9d with SMTP id
 v195-20020a8148cc000000b005a7b9ea5c9dmr77561ywa.8.1697848453097; Fri, 20 Oct
 2023 17:34:13 -0700 (PDT)
Date:   Fri, 20 Oct 2023 17:34:11 -0700
In-Reply-To: <ZTMatKliYT5_I0bg@google.com>
Mime-Version: 1.0
References: <20230913124227.12574-1-binbin.wu@linux.intel.com> <ZTMatKliYT5_I0bg@google.com>
Message-ID: <ZTMcg__FPmRVqec9@google.com>
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

On Fri, Oct 20, 2023, Sean Christopherson wrote:
> On Wed, Sep 13, 2023, Binbin Wu wrote:
> > Binbin Wu (10):
> >   KVM: x86: Consolidate flags for __linearize()
> >   KVM: x86: Use a new flag for branch targets
> >   KVM: x86: Add an emulation flag for implicit system access
> >   KVM: x86: Add X86EMUL_F_INVLPG and pass it in em_invlpg()
> >   KVM: x86/mmu: Drop non-PA bits when getting GFN for guest's PGD
> >   KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to check CR3's legality
> >   KVM: x86: Remove kvm_vcpu_is_illegal_gpa()
> >   KVM: x86: Introduce get_untagged_addr() in kvm_x86_ops and call it in
> >     emulator
> >   KVM: x86: Untag address for vmexit handlers when LAM applicable
> >   KVM: x86: Use KVM-governed feature framework to track "LAM enabled"
> > 
> > Robert Hoo (3):
> >   KVM: x86: Virtualize LAM for supervisor pointer
> >   KVM: x86: Virtualize LAM for user pointer
> >   KVM: x86: Advertise and enable LAM (user and supervisor)
> > 
> > Zeng Guang (3):
> >   KVM: emulator: Add emulation of LASS violation checks on linear
> >     address
> >   KVM: VMX: Virtualize LASS
> >   KVM: x86: Advertise LASS CPUID to user space
> 
> This all looks good!  I have a few minor nits, but nothing I can't tweak when
> applying.  Assuming nothing explodes in testing, I'll get this applied for 6.8
> next week.

Gah, by "this" I meant the LAM parts.  LASS is going to have to wait until the
kernel support lands.
