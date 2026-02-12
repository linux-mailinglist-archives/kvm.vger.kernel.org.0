Return-Path: <kvm+bounces-71001-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QINUC5YSjmll/AAAu9opvQ
	(envelope-from <kvm+bounces-71001-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 18:49:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AF4F130127
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 18:49:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4591D30A0439
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 17:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8724961668;
	Thu, 12 Feb 2026 17:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SfcxCpys"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFED32770A
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 17:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770918533; cv=none; b=SuDsdAWdK3DEUpYUJVUQ99Q7Gt1mu64bJlWWiNtIEshVLurr/6Zu4ogqYAD4yFKEjWKHe9Q2TLzYixAgZsrcA5sDHmvUSloRsHbrJFYNtp7mrnOmMv33f3ajdc+9X3zioJfK5ECeSIfTP0dYyY3P+Ao1MGRDVBZQOBUoLWnFVJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770918533; c=relaxed/simple;
	bh=Y9YqPnc8BmjwKubmvFSXt3QWfkXvZK4RllFw60PzH/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aY8XJsGvASMGPDIO/4mbCJag9neFQPl4UYwbAV/w4GlDvKTvVW23OLc81h9YtSgrf4jvT+Z5pjs7XEp3nmK0V3AHjP2mok7yXXhbOfuRAdQqPhciV/L34o9UPmJoIAck8F3Nu3vwuJ8f5jhN76nw0FEUz6g5I3aXFxcwhWGWKtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SfcxCpys; arc=none smtp.client-ip=209.85.210.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-8230c839409so101018b3a.3
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 09:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770918531; x=1771523331; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wkYX9/8AMpNKTzDUSgXfqQoLj53MIkWsoktK8rnuztU=;
        b=SfcxCpysIslfaeRb0koLoQJIzCPa4PzVqhpQYLJLlQEEktnR8ldYrI8r0eg5Nic1so
         bmVt3dW7/S/+2TzIV+uym8efWN7BJRE5cBmr7dr5VpVQuxKaT3GvcccEn12cIRwyivTq
         W5spevx+CVXEB60hyFCYpX3MJM1cPteJFA4TWsBU67O0z00OglzlE7XZ8Y+1wRkg/Nze
         pXM6qpTMgs5nD8ib0dp6wViNMw4bPsLuvf8ybDF95tdTS42YzoQ6gX0EbS8gJ9Jb1pzm
         XBOdZQOjXbiljZeEqTeezrVWIYSv9xmwyESdOmcu73FrXG3OERuU1jKCJP+ba/Az/66l
         y+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770918531; x=1771523331;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wkYX9/8AMpNKTzDUSgXfqQoLj53MIkWsoktK8rnuztU=;
        b=l9fXW3Zoc/ki9oAWhq+gJqyn/ZlBwQals/TwFUHWdEhFmkiny3a9q6dgQ6dxuG+rn0
         rBNEx56P7U5HGUDGxkA2ewfwxokXjTZP7hBoQRFN8WgaIhNpf0U6dOB4/9LTr+GSBVEj
         0OX8nlFk82qBXdYBhjpTZ0JmPL5XEvJHpLz71dqy3p+Y4QOYBUrnRt2HGBzYD1sYk0vR
         7e6W4aeKvz3HMuH6cxw22GZn1++b4ahTAe7OpRAYSbWoO5OzLpNUYonbMse6OiIva8Zx
         WbJ2s/D7bU2dhM+o/kfYosw0bJ/AUZPJ/Nmo+lDNwakbKBsP+ICWqqzXFuGXd6HTQ4et
         SW+A==
X-Gm-Message-State: AOJu0YxB/PmTPDhcap7MjM8anNzmXcXDIFwcNw+8RMh8PANmySZ9uTOx
	UEVGk9icgunRwpYfFQrSNScPyAgeleVBW2G4FwJD9VllhQ3pqlzHw9+2hNSBJgcF+XQ=
X-Gm-Gg: AZuq6aI5ECTCbJeeSbJxWLf+iMc+pplo8yZLrDOug65zHUQtJCKyxTuRXNeFlvJzTIf
	v55SIFHqtTIwnJQ5857oxUrYD9XnYMvJG6YnNYb1+luotw2pLXD7ZNID9dMgIdVf/8znjcmEYJp
	ul/ysTiDtSyN/2WvsiWVBaeU8C23H8vNFdEBlhRGN7Cog6pxs5ys6VeQEOu2SDobpEsyc5lJCSF
	4UBm3pk7TmLXMQv0JI6oBTZjwgGQfV096NEm/msKm/MaAl57XcDVvIo3PL2HF4ZrxhP3Ofo/Sv5
	tdd+DN20/DwD31ZcrQOC862d/BIanti1PvF6QmvAneIoBBrd/usgJBxieLCI04tc+Vb2qs/2Co2
	WfJ5XZ6Ler1vl2SsWKQjripoY8VcJhaL39dvb+yNcZqlnmhFocFq2RizJr5cr5We/RmfvQL4zVY
	aXC4t6WVdDGJa7/nhJjkL/i6cbdlc=
X-Received: by 2002:a05:6a00:17a1:b0:824:a304:e5b7 with SMTP id d2e1a72fcca58-824b302d476mr3194178b3a.51.1770918530788;
        Thu, 12 Feb 2026 09:48:50 -0800 (PST)
Received: from p14s ([2604:3d09:148c:c800:b17f:2662:e1ea:5d37])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e3bd3b2sm6231651b3a.22.2026.02.12.09.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 09:48:50 -0800 (PST)
Date: Thu, 12 Feb 2026 10:48:47 -0700
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH v12 00/46] arm64: Support for Arm CCA in KVM
Message-ID: <aY4Sf4lMlWd9LyTo@p14s>
References: <20251217101125.91098-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217101125.91098-1-steven.price@arm.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71001-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	DKIM_TRACE(0.00)[linaro.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mathieu.poirier@linaro.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:url,linaro.org:dkim]
X-Rspamd-Queue-Id: 8AF4F130127
X-Rspamd-Action: no action

Hi Steven,

On Wed, Dec 17, 2025 at 10:10:37AM +0000, Steven Price wrote:
> This series adds support for running protected VMs using KVM under the
> Arm Confidential Compute Architecture (CCA). I've changed the uAPI
> following feedback from Marc.
> 
> The main change is that rather than providing a multiplex CAP and
> expecting the VMM to drive the different stages of realm construction,
> there's now just a minimal interface and KVM performs the necessary
> operations when needed.
> 
> This series is lightly tested and is meant as a demonstration of the new
> uAPI. There are a number of (known) rough corners in the implementation
> that I haven't dealt with properly.
> 
> In particular please note that this series is still targetting RMM v1.0.
> There is an alpha quality version of RMM v2.0 available[1]. Feedback was
> that there are a number of blockers for merging with RMM v1.0 and so I
> expect to rework this series to support RMM v2.0 before it is merged.
> That will necessarily involve reworking the implementation.
> 
> Specifically I'm expecting improvements in:
> 
>  * GIC handling - passing state in registers, and allowing the host to
>    fully emulate the GIC by allowing trap bits to be set.
> 
>  * PMU handling - again providing flexibility to the host's emulation.
> 
>  * Page size/granule size mismatch. RMM v1.0 defines the granule as 4k,
>    RMM v2.0 provide the option for the host to change the granule size.
>    The intention is that Linux would simply set the granule size equal
>    to its page size which will significantly simplify the management of
>    granules.
> 
>  * Some performance improvement from the use of range-based map/unmap
>    RMI calls.
> 
> This series is based on v6.19-rc1. It is also available as a git
> repository:
> 
> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v12
> 
> Work in progress changes for kvmtool are available from the git
> repository below:
> 
> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v10

The first thing to note is that branch cca/v10 does not compile due to function
realm_configure_parameters() not being called anywhere.  Marking the function as
[[maybe_unused]] solved the problem on my side.

Using the FVP emulator, booting a Realm that includes EDK2 in its boot stack
worked.  If EDK2 is not part of the boot stack and a kernel is booted directly
from lkvm, mounting the initrd fails.  Looking into this issue further, I see
that from a Realm kernel's perspective, the content of the initrd is either
encrypted or has been trampled on.  

I'd be happy to provide more details on the above, just let me know.

Thanks,
Mathieu

> 
> [1] https://developer.arm.com/documentation/den0137/latest/
> 
> Jean-Philippe Brucker (7):
>   arm64: RMI: Propagate number of breakpoints and watchpoints to
>     userspace
>   arm64: RMI: Set breakpoint parameters through SET_ONE_REG
>   arm64: RMI: Initialize PMCR.N with number counter supported by RMM
>   arm64: RMI: Propagate max SVE vector length from RMM
>   arm64: RMI: Configure max SVE vector length for a Realm
>   arm64: RMI: Provide register list for unfinalized RMI RECs
>   arm64: RMI: Provide accurate register list
> 
> Joey Gouly (2):
>   arm64: RMI: allow userspace to inject aborts
>   arm64: RMI: support RSI_HOST_CALL
> 
> Steven Price (34):
>   arm64: RME: Handle Granule Protection Faults (GPFs)
>   arm64: RMI: Add SMC definitions for calling the RMM
>   arm64: RMI: Add wrappers for RMI calls
>   arm64: RMI: Check for RMI support at KVM init
>   arm64: RMI: Define the user ABI
>   arm64: RMI: Basic infrastructure for creating a realm.
>   KVM: arm64: Allow passing machine type in KVM creation
>   arm64: RMI: RTT tear down
>   arm64: RMI: Activate realm on first VCPU run
>   arm64: RMI: Allocate/free RECs to match vCPUs
>   KVM: arm64: vgic: Provide helper for number of list registers
>   arm64: RMI: Support for the VGIC in realms
>   KVM: arm64: Support timers in realm RECs
>   arm64: RMI: Handle realm enter/exit
>   arm64: RMI: Handle RMI_EXIT_RIPAS_CHANGE
>   KVM: arm64: Handle realm MMIO emulation
>   KVM: arm64: Expose support for private memory
>   arm64: RMI: Allow populating initial contents
>   arm64: RMI: Set RIPAS of initial memslots
>   arm64: RMI: Create the realm descriptor
>   arm64: RMI: Add a VMID allocator for realms
>   arm64: RMI: Runtime faulting of memory
>   KVM: arm64: Handle realm VCPU load
>   KVM: arm64: Validate register access for a Realm VM
>   KVM: arm64: Handle Realm PSCI requests
>   KVM: arm64: WARN on injected undef exceptions
>   arm64: Don't expose stolen time for realm guests
>   arm64: RMI: Always use 4k pages for realms
>   arm64: RMI: Prevent Device mappings for Realms
>   HACK: Restore per-CPU cpu_armpmu pointer
>   arm_pmu: Provide a mechanism for disabling the physical IRQ
>   arm64: RMI: Enable PMU support with a realm guest
>   KVM: arm64: Expose KVM_ARM_VCPU_REC to user space
>   arm64: RMI: Enable realms to be created
> 
> Suzuki K Poulose (3):
>   kvm: arm64: Include kvm_emulate.h in kvm/arm_psci.h
>   kvm: arm64: Don't expose unsupported capabilities for realm guests
>   arm64: RMI: Allow checking SVE on VM instance
> 
>  Documentation/virt/kvm/api.rst       |   78 +-
>  arch/arm64/include/asm/kvm_emulate.h |   31 +
>  arch/arm64/include/asm/kvm_host.h    |   13 +-
>  arch/arm64/include/asm/kvm_rmi.h     |  137 +++
>  arch/arm64/include/asm/rmi_cmds.h    |  508 ++++++++
>  arch/arm64/include/asm/rmi_smc.h     |  269 +++++
>  arch/arm64/include/asm/virt.h        |    1 +
>  arch/arm64/kernel/cpufeature.c       |    1 +
>  arch/arm64/kvm/Kconfig               |    2 +
>  arch/arm64/kvm/Makefile              |    2 +-
>  arch/arm64/kvm/arch_timer.c          |   37 +-
>  arch/arm64/kvm/arm.c                 |  179 ++-
>  arch/arm64/kvm/guest.c               |   95 +-
>  arch/arm64/kvm/hypercalls.c          |    4 +-
>  arch/arm64/kvm/inject_fault.c        |    5 +-
>  arch/arm64/kvm/mmio.c                |   16 +-
>  arch/arm64/kvm/mmu.c                 |  214 +++-
>  arch/arm64/kvm/pmu-emul.c            |    6 +
>  arch/arm64/kvm/psci.c                |   30 +
>  arch/arm64/kvm/reset.c               |   13 +-
>  arch/arm64/kvm/rmi-exit.c            |  207 ++++
>  arch/arm64/kvm/rmi.c                 | 1663 ++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c            |   53 +-
>  arch/arm64/kvm/vgic/vgic-init.c      |    2 +-
>  arch/arm64/kvm/vgic/vgic-v2.c        |    6 +-
>  arch/arm64/kvm/vgic/vgic-v3.c        |   14 +-
>  arch/arm64/kvm/vgic/vgic.c           |   55 +-
>  arch/arm64/kvm/vgic/vgic.h           |   20 +-
>  arch/arm64/mm/fault.c                |   28 +-
>  drivers/perf/arm_pmu.c               |   20 +
>  include/kvm/arm_arch_timer.h         |    2 +
>  include/kvm/arm_pmu.h                |    4 +
>  include/kvm/arm_psci.h               |    2 +
>  include/linux/perf/arm_pmu.h         |    7 +
>  include/uapi/linux/kvm.h             |   42 +-
>  35 files changed, 3650 insertions(+), 116 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kvm_rmi.h
>  create mode 100644 arch/arm64/include/asm/rmi_cmds.h
>  create mode 100644 arch/arm64/include/asm/rmi_smc.h
>  create mode 100644 arch/arm64/kvm/rmi-exit.c
>  create mode 100644 arch/arm64/kvm/rmi.c
> 
> -- 
> 2.43.0
> 
> 

