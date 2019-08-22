Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C167E99143
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 12:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732376AbfHVKqf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 06:46:35 -0400
Received: from ozlabs.org ([203.11.71.1]:60267 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731416AbfHVKqe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 06:46:34 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 46Dh6J1Yyqz9sNy; Thu, 22 Aug 2019 20:46:31 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 8d4ba9c931bc384bcc6889a43915aaaf19d3e499
In-Reply-To: <20190813100100.GC9567@blackberry>
To:     Paul Mackerras <paulus@ozlabs.org>, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v2 2/3] KVM: PPC: Book3S HV: Don't push XIVE context when not using XIVE device
Message-Id: <46Dh6J1Yyqz9sNy@ozlabs.org>
Date:   Thu, 22 Aug 2019 20:46:31 +1000 (AEST)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-08-13 at 10:01:00 UTC, Paul Mackerras wrote:
> At present, when running a guest on POWER9 using HV KVM but not using
> an in-kernel interrupt controller (XICS or XIVE), for example if QEMU
> is run with the kernel_irqchip=off option, the guest entry code goes
> ahead and tries to load the guest context into the XIVE hardware, even
> though no context has been set up.
> 
> To fix this, we check that the "CAM word" is non-zero before pushing
> it to the hardware.  The CAM word is initialized to a non-zero value
> in kvmppc_xive_connect_vcpu() and kvmppc_xive_native_connect_vcpu(),
> and is now cleared in kvmppc_xive_{,native_}cleanup_vcpu.
> 
> Cc: stable@vger.kernel.org # v4.11+
> Reported-by: Cédric Le Goater <clg@kaod.org>
> Fixes: 5af50993850a ("KVM: PPC: Book3S HV: Native usage of the XIVE interrupt controller")
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
> Reviewed-by: Cédric Le Goater <clg@kaod.org>

Applied to powerpc topic/ppc-kvm, thanks.

https://git.kernel.org/powerpc/c/8d4ba9c931bc384bcc6889a43915aaaf19d3e499

cheers
