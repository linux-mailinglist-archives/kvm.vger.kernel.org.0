Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3563A4273
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 14:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhFKM5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 08:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230233AbhFKM5C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 08:57:02 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19DD7613B8;
        Fri, 11 Jun 2021 12:55:05 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lrggh-006yjL-4o; Fri, 11 Jun 2021 13:55:03 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 11 Jun 2021 13:55:03 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com,
        eric.auger@redhat.com, yuzenghui@huawei.com, vkuznets@redhat.com
Subject: Re: [PATCH v4 0/6] KVM: selftests: arm64 exception handling and debug
 test
In-Reply-To: <20210611011020.3420067-1-ricarkol@google.com>
References: <20210611011020.3420067-1-ricarkol@google.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <e6fc0b42b6d82b1803339842470da97a@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ricarkol@google.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com, eric.auger@redhat.com, yuzenghui@huawei.com, vkuznets@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-06-11 02:10, Ricardo Koller wrote:
> Hi,
> 
> These patches add a debug exception test in aarch64 KVM selftests while
> also adding basic exception handling support.
> 
> The structure of the exception handling is based on its x86 
> counterpart.
> Tests use the same calls to initialize exception handling and both
> architectures allow tests to override the handler for a particular
> vector, or (vector, ec) for synchronous exceptions in the arm64 case.
> 
> The debug test is similar to x86_64/debug_regs, except that the x86 one
> controls the debugging from outside the VM. This proposed arm64 test
> controls and handles debug exceptions from the inside.
> 
> Thanks,
> Ricardo
> 
> v3 -> v4:
> 
> V3 was dropped because it was breaking x86 selftests builds (reported 
> by
> the kernel test robot).
> - rename vm_handle_exception to vm_install_sync_handler instead of
>   vm_install_vector_handlers. [Sean]
> - use a single level of routing for exception handling. [Sean]
> - fix issue in x86_64/sync_regs_test when switching to ucalls for 
> unhandled
>   exceptions reporting.

This looks good to me. If I can get an Ack from any of the x86 
maintainers,
I'll queue the series.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
