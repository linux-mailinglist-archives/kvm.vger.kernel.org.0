Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C1B3BA41D
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 20:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhGBS7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 14:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhGBS7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 14:59:30 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655E3C061762
        for <kvm@vger.kernel.org>; Fri,  2 Jul 2021 11:56:57 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id z4so6115118plg.8
        for <kvm@vger.kernel.org>; Fri, 02 Jul 2021 11:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ycum9evCUFiduU+FXmIYFePuE2chcx7yYwOjeyhRcmY=;
        b=ho0D7I7qB20VRN3J6CXnbaLEYxEHCdEhVu40EI6ZPzzLcPs3bffu8rWBtcdZsoJgFO
         xNIJCsBkGe7H+XUlLF4eh+fpD6EV9y5Yp0q+a4755qD0CHKsbqCGc1mvHWjTJDRhs8zR
         zp+14ILcLWZcM0fpMylNDU8qtbK/+pGTH36f0kFuHjI5MZ4jV7T+885DDSZGWp/bnRdA
         1IycNnZ3X0DlSGIOJjyQ14oO42YRoImsBPMsHH0NPtHij010Tp0AY49LWyd8p9oWZgfX
         d4PqzWbZi/INO+FwT7gT9fcUeWlwdYvfihQZ7HB1jBOnaBBKyu3X7HNO2rq0oY4nmo0Y
         nEYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ycum9evCUFiduU+FXmIYFePuE2chcx7yYwOjeyhRcmY=;
        b=TfQKe7BBulb4OSatet9nQ4GdVcqmaGnTQUj9r7AxeYovwy6f9L+U8tbtKIeG6R/YQx
         1R99bwB7WMTiyP2KNjKy5RCNYeI6c392467RJx2OY+9p8iywgmy2bmNEuyaZ6OF8D2sQ
         Djv4DFYMISP2T7bxavcAL7SGJJq2MeN31j2KX4HdeOg7AADgZcCS+Gu8HA4ebt2wNZxa
         lPwgND3N+cmCHE3Jzw2rjvKLFviVqMCxUBDfFxLWA8CfZhsaxLX0Spl02DA/K5M66a+S
         241n34YXz+UtYcF9s4PsDNMGYmBcMN8oCQ8DduQxz7G29T3vXU5ujv2Uu16z8px7tAsr
         VMMA==
X-Gm-Message-State: AOAM530GrUowv1g8+3PagxVWw6eMqoBboAqsOQZsGFc164Rpw86mhj2D
        nGIC82ybFY37GMrWBWjJjBwuQQ==
X-Google-Smtp-Source: ABdhPJyLCScqgNzWVyO70OvO0qg6l9xuCtTQ0UMuGxyyNVkREi8sRKK50KY7HcDr5U0yDyK3iDOnLw==
X-Received: by 2002:a17:90a:558c:: with SMTP id c12mr1094718pji.166.1625252216557;
        Fri, 02 Jul 2021 11:56:56 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id w14sm5030003pgo.75.2021.07.02.11.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 11:56:56 -0700 (PDT)
Date:   Fri, 2 Jul 2021 11:56:52 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        vkuznets@redhat.com, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v4 5/6] KVM: selftests: Add exception handling support
 for aarch64
Message-ID: <YN9hdFROSeMSTA2S@google.com>
References: <20210611011020.3420067-1-ricarkol@google.com>
 <20210611011020.3420067-6-ricarkol@google.com>
 <b1f581ec-56f4-24a2-7850-182128cdc4ac@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1f581ec-56f4-24a2-7850-182128cdc4ac@huawei.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 02, 2021 at 02:46:57PM +0800, Zenghui Yu wrote:
> [+Sean]
> 
> On 2021/6/11 9:10, Ricardo Koller wrote:
> > Add the infrastructure needed to enable exception handling in aarch64
> > selftests. The exception handling defaults to an unhandled-exception
> > handler which aborts the test, just like x86. These handlers can be
> > overridden by calling vm_install_exception_handler(vector) or
> > vm_install_sync_handler(vector, ec). The unhandled exception reporting
> > from the guest is done using the ucall type introduced in a previous
> > commit, UCALL_UNHANDLED.
> > 
> > The exception handling code is inspired on kvm-unit-tests.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   2 +-
> >  .../selftests/kvm/include/aarch64/processor.h |  63 +++++++++
> >  .../selftests/kvm/lib/aarch64/handlers.S      | 126 ++++++++++++++++++
> >  .../selftests/kvm/lib/aarch64/processor.c     |  97 ++++++++++++++
> >  4 files changed, 287 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S
> 
> [...]
> 
> > +void vm_init_descriptor_tables(struct kvm_vm *vm)
> > +{
> > +	vm->handlers = vm_vaddr_alloc(vm, sizeof(struct handlers),
> > +			vm->page_size, 0, 0);
> 
> This raced with commit a75a895e6457 ("KVM: selftests: Unconditionally
> use memslot 0 for vaddr allocations") which dropped memslot parameters
> from vm_vaddr_alloc().

Will send a fix to use vm_vaddr_alloc() without the memslot parameters.

> 
> We can remove the related comments on top of vm_vaddr_alloc() as well.

Can do this as well, will send a separate patch removing this. Unless
somebody was about to.

> 
> Zenghui

Thanks,
Ricardo
