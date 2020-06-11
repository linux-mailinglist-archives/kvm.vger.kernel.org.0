Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604AD1F6D27
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 20:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgFKSFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 14:05:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33777 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726251AbgFKSFA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 14:05:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591898697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7cOqWTuYUa9FE9GP6fpBOyXkY5kMzNQixiqzTqJRGBI=;
        b=O4yqn6G3RJliVERbtU9BWcvLgTO3bZpdBDCfSNDtYokywIA6E8Z9biU1yDO4gHQK+Pe0xs
        AQEJzYopPWrhufqRQ2obZ8WJzOdNjQUxmHjW6PIlh4ZBwSYxhTk8YRvyS/pSGB69EEE72b
        OLqnlNenYzijpkiQO9NIRXGoWjSCJcA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-lEHwTRx3P2i12rmsHyro8g-1; Thu, 11 Jun 2020 14:04:56 -0400
X-MC-Unique: lEHwTRx3P2i12rmsHyro8g-1
Received: by mail-wm1-f72.google.com with SMTP id h6so1305448wmb.7
        for <kvm@vger.kernel.org>; Thu, 11 Jun 2020 11:04:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7cOqWTuYUa9FE9GP6fpBOyXkY5kMzNQixiqzTqJRGBI=;
        b=A9mjBC3tK97Bu59em1/rYWNN8jHhRlF33ScCHDimOEND3ZQNr4As0Rw2oiRd06de2g
         1yb2yczUeOF5DZrddSBJVPU22RWHgFu7EdML8uv2171xcR6JdYW5Z5CD4kzQmT3yAGaG
         j81vkZ/zTQvHbbjHsSC0n/TRgMoMBXphxKeHa0WUSymeTOC7eo2vLuATeb+wSz5GshT+
         05bnJz/Tpca0j4767rUDJqp8smwYjgovBEe0QngazGDM2+0BEMaoVssO2E7CMRm33PDD
         Gp3PF8eq9bc+ZPsWHipHCnNFtuTU90ZgN4CnouInCrfdxfY3/gWHXbYRiWvAS0nN+dX3
         Lc2w==
X-Gm-Message-State: AOAM531FVBtuxP+L088A9ecJ+yddqKYixGr0WatEntc8S4V6dtFrY2jo
        pY4rgGYGMBWBc+tLz2uw4dARzvsxcxzToMHUXb+s1XMXVtKrW7OWXpIKaK6SBJPtkk4VxUC6/3C
        5EUJUp5BbksKe
X-Received: by 2002:a1c:ed0e:: with SMTP id l14mr9180030wmh.8.1591898695048;
        Thu, 11 Jun 2020 11:04:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzR4smWGm/DBrvqHqnYi+0pYh8w7qlAz7vSbFH29HX9jSbIpMW1S4TmGZ3yFk17wCx3012mHw==
X-Received: by 2002:a1c:ed0e:: with SMTP id l14mr9180010wmh.8.1591898694794;
        Thu, 11 Jun 2020 11:04:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29ed:810e:962c:aa0d? ([2001:b07:6468:f312:29ed:810e:962c:aa0d])
        by smtp.gmail.com with ESMTPSA id v7sm6110537wro.76.2020.06.11.11.04.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2020 11:04:54 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.8, take #1
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20200611090956.1537104-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <be82c5cb-be6d-74f7-9b77-dbd1648a8933@redhat.com>
Date:   Thu, 11 Jun 2020 20:04:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200611090956.1537104-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/06/20 11:09, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's a bunch of fixes that cropped up during the merge window,
> mostly falling into two categories: 32bit system register accesses,
> and 64bit pointer authentication handling.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 8f7f4fe756bd5cfef73cf8234445081385bdbf7d:
> 
>   KVM: arm64: Drop obsolete comment about sys_reg ordering (2020-05-28 13:16:57 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.8-1
> 
> for you to fetch changes up to 15c99816ed9396c548eed2e84f30c14caccad1f4:
> 
>   Merge branch 'kvm-arm64/ptrauth-fixes' into kvmarm-master/next (2020-06-10 19:10:40 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for Linux 5.8, take #1
> 
> * 32bit VM fixes:
>   - Fix embarassing mapping issue between AArch32 CSSELR and AArch64
>     ACTLR
>   - Add ACTLR2 support for AArch32
>   - Get rid of the useless ACTLR_EL1 save/restore
>   - Fix CP14/15 accesses for AArch32 guests on BE hosts
>   - Ensure that we don't loose any state when injecting a 32bit
>     exception when running on a VHE host
> 
> * 64bit VM fixes:
>   - Fix PtrAuth host saving happening in preemptible contexts
>   - Optimize PtrAuth lazy enable
>   - Drop vcpu to cpu context pointer
>   - Fix sparse warnings for HYP per-CPU accesses
> 
> ----------------------------------------------------------------
> James Morse (3):
>       KVM: arm64: Stop writing aarch32's CSSELR into ACTLR
>       KVM: arm64: Add emulation for 32bit guests accessing ACTLR2
>       KVM: arm64: Stop save/restoring ACTLR_EL1
> 
> Marc Zyngier (9):
>       KVM: arm64: Flush the instruction cache if not unmapping the VM on reboot
>       KVM: arm64: Save the host's PtrAuth keys in non-preemptible context
>       KVM: arm64: Handle PtrAuth traps early
>       KVM: arm64: Stop sparse from moaning at __hyp_this_cpu_ptr
>       KVM: arm64: Remove host_cpu_context member from vcpu structure
>       KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts
>       KVM: arm64: Synchronize sysreg state on injecting an AArch32 exception
>       KVM: arm64: Move hyp_symbol_addr() to kvm_asm.h
>       Merge branch 'kvm-arm64/ptrauth-fixes' into kvmarm-master/next
> 
>  arch/arm64/include/asm/kvm_asm.h     | 33 ++++++++++++++++--
>  arch/arm64/include/asm/kvm_emulate.h |  6 ----
>  arch/arm64/include/asm/kvm_host.h    |  9 +++--
>  arch/arm64/include/asm/kvm_mmu.h     | 20 -----------
>  arch/arm64/kvm/aarch32.c             | 28 ++++++++++++++++
>  arch/arm64/kvm/arm.c                 | 20 ++++++-----
>  arch/arm64/kvm/handle_exit.c         | 32 ++----------------
>  arch/arm64/kvm/hyp/debug-sr.c        |  4 +--
>  arch/arm64/kvm/hyp/switch.c          | 65 ++++++++++++++++++++++++++++++++++--
>  arch/arm64/kvm/hyp/sysreg-sr.c       |  8 ++---
>  arch/arm64/kvm/pmu.c                 |  8 ++---
>  arch/arm64/kvm/sys_regs.c            | 25 +++++++-------
>  arch/arm64/kvm/sys_regs_generic_v8.c | 10 ++++++
>  13 files changed, 171 insertions(+), 97 deletions(-)
> 

Pulled, thanks.

Paolo

