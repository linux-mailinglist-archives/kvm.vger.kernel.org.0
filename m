Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3883CEC69
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 22:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377756AbhGSRcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 13:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378915AbhGSR0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 13:26:32 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A69C05BD3B
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 10:46:39 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ec55so25204996edb.1
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 11:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iwY647XqSBr0nhop6u+nJOZDJO2ojgmzAbMlPyzAP2A=;
        b=de4dSCIFeNoXczBGIJKhs+9cQ67ihAH384iDNj7/ghw8A521i45BAOlb9Wj5VrML2B
         ts5bNRNWddT+aI1DLJIMor+SL4/f3zNwEtrLVZsD2tjcjsRkzEr1TRxdDN0DwJUJ6pq2
         vSViocJn6F9z759rRSS8/3I8kikyFNECOd2Jum/ADid6KfFaxXYT7kzrn3v/uD/drMMG
         QmB7VB6/FnvNvlUQU1yQ7RgVec5cXCMQW4i7ue70iiKVBvUrwW3xqoF7vRTo45xa+TQV
         ER89LXFuY7yD0DDbzZMfbrV5Of00o5bIHTQbJFYMZNcVBnBX+yL0g9CKq1SafiocuodB
         XvpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iwY647XqSBr0nhop6u+nJOZDJO2ojgmzAbMlPyzAP2A=;
        b=a2itH0lTRTgVz3YJwJFILJh+g/P+VOw/jGt7DIOS1J8PnnaV0YZAXQ37USiFji5diA
         XANm1sMziIGHmzdAanEf13VK+n4+V5QDJwHF/RzaqLVAq4J7hr5QmmSvyIT+/H2wyGIK
         pM09Ooc3TM/WNGQLNCP359roTDqQbNxGlCZPA7qMO2jiJdfcKWbdOOmdxRu4OLGcdFbG
         +wMaKxmAQozCDrkb9aWyqb8G/uG66uWrpKZ+fiY1y2t3wih0KzTJWI1ThGf4rv/iKFyY
         /VcaLbTsOYHkFAnyQOV3hHjfKB9GWJqaJ9JpBDfXPvXY0hRf4lacG7WQ1X32Szab9pnJ
         GLHw==
X-Gm-Message-State: AOAM533THxmrxYppiszzh9uJMDjZIm65BK9U+kaqWxN14FFzNPdMqbza
        p5/UR/7SUsVmehRKGkHEyMIbUw==
X-Google-Smtp-Source: ABdhPJyQlO0WF1yuY/72pvxqzE/S/j0RUDWpsZG3FB/CGPHlXlZjXIrduqfJdRb/baD0ksNgkAUGWw==
X-Received: by 2002:a05:6402:1592:: with SMTP id c18mr35924631edv.243.1626717749925;
        Mon, 19 Jul 2021 11:02:29 -0700 (PDT)
Received: from myrica (adsl-84-226-111-173.adslplus.ch. [84.226.111.173])
        by smtp.gmail.com with ESMTPSA id n14sm8178314edo.23.2021.07.19.11.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 11:02:29 -0700 (PDT)
Date:   Mon, 19 Jul 2021 20:02:06 +0200
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, james.morse@arm.com,
        suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org,
        lorenzo.pieralisi@arm.com, salil.mehta@huawei.com,
        shameerali.kolothum.thodi@huawei.com, jonathan.cameron@huawei.com
Subject: Re: [RFC PATCH 0/5] KVM: arm64: Pass PSCI to userspace
Message-ID: <YPW+Hv3r586zKxpY@myrica>
References: <20210608154805.216869-1-jean-philippe@linaro.org>
 <c29ff5c8-9c94-6a6c-6142-3bed440676bf@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c29ff5c8-9c94-6a6c-6142-3bed440676bf@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

I'm not planning to resend this work at the moment, because it looks like
vcpu hot-add will go a different way so I don't have a user. But I'll
probably address the feedback so far and park it on some branch, in case
anyone else needs it.

On Mon, Jul 19, 2021 at 04:29:18PM +0100, Alexandru Elisei wrote:
> 1. Why forwarding PSCI calls to userspace depend on enabling forwarding for other
> HVC calls? As I understand from the patches, those handle distinct function IDs.

The HVC cap from patch 4 enables returning from the VCPU_RUN ioctl with
KVM_EXIT_HYPERCALL, for any HVC not handled by KVM. This one should
definitely be improved, either by letting userspace choose the ranges of
HVC it wants, or at least by reporting ranges reserved by KVM to
userspace.

The PSCI cap from patch 5 disables the in-kernel PSCI implementation. As a
result those HVCs are forwarded to userspace.

It was suggested that other users will want to handle HVC calls (SDEI for
example [1]), hence splitting into two capabilities rather than just the
PSCI cap. In v5.14 x86 added KVM_CAP_EXIT_HYPERCALL [2], which lets
userspace receive specific hypercalls. We could reuse that and have PSCI
be one bit of that capability's parameter.

[1] https://lore.kernel.org/linux-arm-kernel/20170808164616.25949-12-james.morse@arm.com/
[2] https://lore.kernel.org/kvm/90778988e1ee01926ff9cac447aacb745f954c8c.1623174621.git.ashish.kalra@amd.com/

> 2. HVC call forwarding to userspace also forwards PSCI functions which are defined
> in ARM DEN 0022D, but not (yet) implemented by KVM. What happens if KVM's PSCI
> implementation gets support for one of those functions? How does userspace know
> that now it also needs to enable PSCI call forwarding to be able to handle that
> function?

We forward the whole PSCI function range, so it's either KVM or userspace.
If KVM manages PSCI and the guest calls an unimplemented function, that
returns directly to the guest without going to userspace.

The concern is valid for any other range, though. If userspace enables the
HVC cap it receives function calls that at some point KVM might need to
handle itself. So we need some negotiation between user and KVM about the
specific HVC ranges that userspace can and will handle.

> It looks to me like the boundary between the functions that are forwarded when HVC
> call forwarding is enabled and the functions that are forwarded when PSCI call
> forwarding is enabled is based on what Linux v5.13 handles. Have you considered
> choosing this boundary based on something less arbitrary, like the function types
> specified in ARM DEN 0028C, table 2-1?

For PSCI I've used the range 0-0x1f as the boundary, which is reserved for
PSCI by SMCCC (table 6-4 in that document).

> 
> In my opinion, setting the MP state to HALTED looks like a sensible approach to
> implementing PSCI_SUSPEND. I'll take a closer look at the patches after I get a
> better understanding about what is going on.
> 
> On 6/8/21 4:48 PM, Jean-Philippe Brucker wrote:
> > Allow userspace to request handling PSCI calls from guests. Our goal is
> > to enable a vCPU hot-add solution for Arm where the VMM presents
> > possible resources to the guest at boot, and controls which vCPUs can be
> > brought up by allowing or denying PSCI CPU_ON calls. Passing HVC and
> > PSCI to userspace has been discussed on the list in the context of vCPU
> > hot-add [1,2] but it can also be useful for implementing other SMCCC and
> > vendor hypercalls [3,4,5].
> >
> > Patches 1-3 allow userspace to request WFI to be executed in KVM. That
> 
> I don't understand this. KVM, in kvm_vcpu_block(), does not execute an WFI.
> PSCI_SUSPEND is documented as being indistinguishable from an WFI from the guest's
> point of view, but it's implementation is not architecturally defined.

Yes that was an oversimplification on my part

Thanks,
Jean
