Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E905F72EC4E
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 21:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbjFMTu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 15:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234699AbjFMTuz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 15:50:55 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF9A170E
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 12:50:54 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-53f6f7d1881so4360728a12.3
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 12:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686685854; x=1689277854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dOeQUQ5xDOdf0WiPYYuWIym0XAZVbGcn3BzJ8T+eYDg=;
        b=gJxO2s7ieUvXstIebtJVn3qRibb82MwKXwUNF1ZuwrdK4qI/yw01wDyHxgbHHZq/9c
         eRs10d49hORhCmPtAwsMQOnsxTKrgYvpmpwCOrLr5Iybo6L/D1sVYEih/QYXWlwT5YQV
         hAZ8oeF/X2ntEMVFUykQkAjIC0Dl/TM3UhvGar++lOVVacKu12qkAJvI9nPXzhaJQjJF
         um8aobCd9AEhCOOskUJv3tGpZbGtK5DZP6GWlOSoyCxQTurwOGNiGqhDNZVlYJDHfQo+
         t3TtUtOcWeVWPPuWFLem0eLai3I5MpASoxOtVKTAYSIO/Dnl/zPD/cPymOZTRVa+H7W4
         n3OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686685854; x=1689277854;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dOeQUQ5xDOdf0WiPYYuWIym0XAZVbGcn3BzJ8T+eYDg=;
        b=iZoYfqXFMGvrBFfeP1oLyTLwcgft+yaZ6CWlS513xgFpcKbTn/4VfxBiXBkqvKSVg8
         /8a55KWeUZchNA/WK4QRcxrwk2KIbledcg0V3IC3eCO9vSLPTLBokmQhn63BaJHvg/b7
         zrOkkBGv57RiUeznHlEVQbgXVK+8MgUQDIHhUnysEdq+eBgw8FHBDNi8aJV+Vo0JkvbH
         Co4yJf/sgvWfNA9rzpz5ltkLHYCe6zINBDFK5J8PF2D19yDHNOroj2BpcI7cP90dMY3R
         rsEh+5JI/fvdHoLPXCs47olhFY/d1QQvP5woJWXRteCSudgAIzJQV7VWZCo46z2jyKH5
         Pq6A==
X-Gm-Message-State: AC+VfDwGcGGM/4buJ0Cgyh7eRVcilWqg+dbcoiPlhaeU+fKPMPrq7WMU
        CbhDxNUXQodF4cA44qN22NEyxD7zCpE=
X-Google-Smtp-Source: ACHHUZ4CZirMRJsKMgU4ooBbk2la8w9RKp5ACl6zFgNU+lJ3fTE7kXUzBsXbNFIpl4yrgqbAEvT10K/94L8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:f314:0:b0:53f:5067:64ec with SMTP id
 l20-20020a63f314000000b0053f506764ecmr1893548pgh.0.1686685853739; Tue, 13 Jun
 2023 12:50:53 -0700 (PDT)
Date:   Tue, 13 Jun 2023 12:50:52 -0700
In-Reply-To: <309da807-2fdb-69ea-3b1b-ff36fc1d67ec@semihalf.com>
Mime-Version: 1.0
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
 <ZA9WM3xA6Qu5Q43K@google.com> <ZBCg6Ql1/hdclfDd@jiechen-ubuntu-dev>
 <75a6b0b3-156b-9648-582b-27a9aaf92ef1@semihalf.com> <SA1PR11MB59230DB019B11C89C334F8F2BF51A@SA1PR11MB5923.namprd11.prod.outlook.com>
 <309da807-2fdb-69ea-3b1b-ff36fc1d67ec@semihalf.com>
Message-ID: <ZIjInENnK5/L/Jsd@google.com>
Subject: Re: [RFC PATCH part-5 00/22] VMX emulation
From:   Sean Christopherson <seanjc@google.com>
To:     Dmytro Maluka <dmy@semihalf.com>
Cc:     Jason CJ Chen <jason.cj.chen@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "android-kvm@google.com" <android-kvm@google.com>,
        Dmitry Torokhov <dtor@chromium.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 09, 2023, Dmytro Maluka wrote:
> On 6/9/23 04:07, Chen, Jason CJ wrote:
> > I think with PV design, we can benefit from skip shadowing. For example, a TLB flush
> > could be done in hypervisor directly, while shadowing EPT need emulate it by destroy
> > shadow EPT page table entries then do next shadowing upon ept violation.

This is a bit misleading.  KVM has an effective TLB for nested TDP only for 4KiB
pages; larger shadow pages are never allowed to go out-of-sync, i.e. KVM doesn't
wait until L1 does a TLB flush to update SPTEs.  KVM does "unload" roots, e.g. to
emulate INVEPT, but that usually just ends up being an extra slow TLB flush in L0,
because nested TDP SPTEs rarely go unsync in practice.  The patterns for hypervisors
managing VM memory don't typically trigger the types of PTE modifications that
result in unsync SPTEs.

I actually have a (very tiny) patch sitting around somwhere to disable unsync support
when TDP is enabled.  There is a very, very thoeretical bug where KVM might fail
to honor when a guest TDP PTE change is architecturally supposed to be visible,
and the simplest fix (by far) is to disable unsync support.  Disabling TDP+unsync
is a viable fix because unsync support is almost never used for nested TDP.  Legacy
shadow paging on the other hand *significantly* benefits from unsync support, e.g.
when the guest is managing CoW mappings. I haven't gotten around to posting the
patch to disable unsync on TDP purely because the flaw is almost comically theoretical.

Anyways, the point is that the TLB flushing side of nested TDP isn't all that
interesting.

> Yeah indeed, good point.
> 
> Is my understanding correct: TLB flush is still gonna be requested by
> the host VM via a hypercall, but the benefit is that the hypervisor
> merely needs to do INVEPT?

Maybe?  A paravirt paging scheme could do whatever it wanted.  The APIs could be
designed in such a way that L1 never needs to explicitly request a TLB flush,
e.g. if the contract is that changes must always become immediately visible to L2.

And TLB flushing is but one small aspect of page table shadowing.  With PV paging,
L1 wouldn't need to manage hardware-defined page tables, i.e. could use any arbitrary
data type.  E.g. KVM as L1 could use an XArray to track L2 mappings.  And L0 in
turn wouldn't need to have vendor specific code, i.e. pKVM on x86 (potentially
*all* architectures) could have a single nested paging scheme for both Intel and
AMD, as opposed to needing code to deal with the differences between EPT and NPT.

A few months back, I mentally worked through the flows[*] (I forget why I was
thinking about PV paging), and I'm pretty sure that adapting x86's TDP MMU to
support PV paging would be easy-ish, e.g. kvm_tdp_mmu_map() would become an
XArray insertion (to track the L2 mapping) + hypercall (to inform L1 of the new
mapping).

[*] I even though of a catchy name, KVM Paravirt Only Paging, a.k.a. KPOP ;-)
