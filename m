Return-Path: <kvm+bounces-69365-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oE5QJTJNemkp5AEAu9opvQ
	(envelope-from <kvm+bounces-69365-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:53:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E2A5A7474
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:53:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 559513010606
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 17:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E66E137104D;
	Wed, 28 Jan 2026 17:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FGnlO07Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAAD36F417
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769622793; cv=pass; b=XaE2j+9HVpeb0bMphrdZ/Ea6KEP3qaUmSYswbPkEXfUJsz+NDBES7L9JkMHiqa8BTmVPuSlaIAQtaORSvVy7nHXAhbgAxO5UJZB/Ed+/tiQMBN7QI2DmwL2sWX+4rzQBfxLK49QnnOKflU/xgEKB+xJ65gfB4SNhOunneqGPSMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769622793; c=relaxed/simple;
	bh=0JNyYRfD4pK3Gn5sKXp0ZdkKSMwLlaan3pWRhsoE9hQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PLbaU4i9FMIDuFf5DqD/eC7xgT9Vtk7i4qzFuCw45yOFsmIsLNvDCjhOGgEO8pnEaeIcCUOK6k9D6yzq2RIzlaCTwsfmC2mgjK6tR78JqBOjZklSl30m9trDHx1t7l1xHW0jzpvoFDzjhN+/mRzWD/MpLUI6s6gT8eaZSISf2W8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FGnlO07Y; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50299648ae9so5421cf.1
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 09:53:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769622789; cv=none;
        d=google.com; s=arc-20240605;
        b=jXSegq3E4ruZLBxYGUWHHIa+KDKvlBdpumlvwqSOxEaVJuyTsgBcJ+bZjTeqGla3dV
         uceviwzbxPIn6IN8lZyVR0fcX9HM/IWVybv0e+rAymNdFT1Z4HFSj/aZFisVeTMkZXsZ
         aGkn44bpoiIvTH9HvKCL8xepqOaY0yc5QgC9Ze9YvKoGxoFS+nosI696u6B70nb7dVpu
         9UI0MMSH1Ap+1O12dLHw8wApO1gZ4Ky9c7/mBK8giCi6VDJaT75HrAYJ/6J+ysR8lDI5
         9ofCPh/u6dNiSS+J/hTU5tnzxQddr86wqGd2ZSxud8pxzwh5e5IGW/EbHmISgSfU16Hi
         OqKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OWg7kuA2s1ZghD76X/T/DMqAQsZITYOyFuy/en9KwNw=;
        fh=Y/6hVdYnIqXEOxaDC0AUc9aKkpMANBt2wnquyTx9eKQ=;
        b=c1l5BPZv75Jo4z5ra3BMOLbYGIv9X7KDkMkx5qZkR9bv5BO/yMSOlwO8Spm1rVV4Fk
         iS/s5+/FUlsCdd5NYWOhFAJYL/Waxcm6iRmKwTgyxtxGNr3pQbw0d0ubPvs2pRud74d9
         lsBof8n0D6cr8n/9IRctuYkup5ReAc059DEE7KnSLSnemh1Moxb0V6/8MNpFbe6F+mS2
         tbM1O52634pjmw8PAzzxrTH4Lca0NAwgIQmmwfnHfPBF6mbAJ6YSB2TDvfvPnHEroB+r
         K6Z3+TGHkRUeR5M5v7bJk8C0GMW+1DbAZ2Q2arSaC+I/pgRrokF3jTPZULeNX8SNuhHo
         /QPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769622789; x=1770227589; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OWg7kuA2s1ZghD76X/T/DMqAQsZITYOyFuy/en9KwNw=;
        b=FGnlO07YuXObf11GpiU7OOvJs9M8LOsttZaS49KzjbwIUXI5b3YPje3XrSAOCCfx59
         oCL70lREa45yHkectaB1/9InWqUkn5YcFacDw61X/m858s5YWlKI3tgwuaxoVa2azY2j
         F7Lc1MI16xjlQVfAWy6GdGo8Kt70dSqZmSTqDAJLTzObhldj0s9f6ymkdQKK5p9mGPhY
         ZKQryOiPfpvurD60rD2mSo/sLNMCw+AmenYC+Dn9PrF4ZUJGzaGJbKJZyu0yhvry/PlQ
         8H2DLCMf0G8vNQggT1agGh6tGVvgedpGQ2yECRqIdSEEjn/oyKGCnH7qb3djv3ATVOzP
         d1Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769622789; x=1770227589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OWg7kuA2s1ZghD76X/T/DMqAQsZITYOyFuy/en9KwNw=;
        b=aXGlrWpjqkTuxsuLfGeQmvpEBy6FQCszzOAORW4BaxAre3X8v5PMv/0fVehZiivCQP
         dMa2TfQTgbDUmRv8LTuhbKZMV2vVK7UIRHFzTRkNXpAZzO3RQU7On3t0MQHf7r+SGVEB
         tjS80/08qUwSRamhxh+ledf96ILlW8aXWhFr7roMZg14X9b4IzZ6mgnlCzCqq2LqZFY9
         SWwP+9uuKVaDFJb+jXa9ju120ijMmzUfYPZ4ixOW5IOWtYcj6R5FuVsvlECrMpQhjgd5
         G+P9pvUiX5hEEuuINedlSb4VK3DFbWPk4k14pzlySJd7anIv9Da9+gOjmKg3KfYkJAJB
         6wow==
X-Forwarded-Encrypted: i=1; AJvYcCX4u6v+Xgy+oRbNzWgWDXpYTGC3ZAGyZNN5P+vuUkd0tjLxzEN6LiBoO5PqNzI6wMet/w4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxR/8j2+/JNiZlUIRKh0ImeF1Fu2ZR47lbI22/TtCcXBGZ5hZys
	Crh0In6RpG8svDr1MLQ+RqQv+EKvqnc0odjzom1QVLObYbSIyMphEAqMbBXbiboZeDYykpai1/i
	5+FL+V8qKWuEK2c14jb9a7hjM4iMno0+KE2+9/3EM
X-Gm-Gg: AZuq6aIj+XzvWmvOXXvf4H3DdS8WakmILfl8NnXyFWqDvs2V5z4k8VOUUZIqSab4vf4
	B30SfWge1vXWDnU3JXw0zqPpLCY1mXulL0KNxBTLY/NEPS4xxmyGmyDEhKMpBiDlKmaaEsT8nrW
	LW3jO/tYinWByWZ2XRbk1bo2Qwi3IpdfmJEkZpd4V46/1vZrYrJfO5QjGPw0S8OX4ssu9sYHzvN
	LErIPmjK8rz8+LccDSrtH5cBb7TunWMBk1l+oX2xhVfP2399r/AP7FI1XgEEi8fX6wOnkz99djh
	BCHtRxcD4A2yIIInSrESYb60vHCu
X-Received: by 2002:a05:622a:207:b0:4f3:54eb:f26e with SMTP id
 d75a77b69052e-5032f44b381mr25111221cf.1.1769622789108; Wed, 28 Jan 2026
 09:53:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260123145645.90444-1-chao.gao@intel.com>
In-Reply-To: <20260123145645.90444-1-chao.gao@intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Wed, 28 Jan 2026 11:52:57 -0600
X-Gm-Features: AZwV_QjcsrND87lEXRg4pv4cTGfcU_Ck3XA1UdyCiBp-d69y5I0sJ7mdSftPq8M
Message-ID: <CAAhR5DG7EOpmKYV4WmiyNYr14rKMNuTcqgvoaeZt5-==kSPmuw@mail.gmail.com>
Subject: Re: [PATCH v3 00/26] Runtime TDX Module update support
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com, 
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com, 
	yilun.xu@linux.intel.com, vannapurve@google.com, paulmck@kernel.org, 
	nik.borisov@suse.com, zhenzhong.duan@intel.com, seanjc@google.com, 
	rick.p.edgecombe@intel.com, kas@kernel.org, dave.hansen@linux.intel.com, 
	vishal.l.verma@intel.com, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sagis@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69365-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[google.com:+]
X-Rspamd-Queue-Id: 3E2A5A7474
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 9:00=E2=80=AFAM Chao Gao <chao.gao@intel.com> wrote=
:
>
> Hi Reviewers,
>
> With this posting, I'm hoping to collect more Reviewed-by or Acked-by tag=
s.
> Dave, since this version is still light on acks, it might not be ready fo=
r
> your review.
>
> Changelog:
> v2->v3:
>  - Make this series self-contained and independently runnable, testable a=
nd
>    reviewable by
>
>    * Including dependent patches such as TDX Module version exposure and =
TDX
>      faux device creation

I see "x86/virt/tdx: Retrieve TDX module version" and "x86/virt/tdx:
Print TDX module version during init" in the github link but I don't
see them as part of this series. Were they posted/accepted as part of
a different series?

Trying to build this series without them fails since
tdx_sysinfo.version is undefined.

>
>    * Removing dependency on Sean's VMXON cleanups for now, the tdx-host d=
evice
>      simply checks that the TDX module is initialized, regardless of when=
 or
>      who performed the initialization.
>
>      Note: If the KVM module is unloaded, all services exposed by the tdx=
-host
>      device will fail. This shouldn't be a big issue since proper errors =
will
>      be returned to userspace, similar to other failure cases.
>
>  - Handle updates during update-sensitive times and documented expectatio=
ns for
>    TDX Module updates
>  - Rework how updates are aborted when errors occur midway
>  - Map Linux error codes to firmware upload error codes
>  - Preserve bit 63 in P-SEAMLDR SEAMCALL leaf numbers and display them in=
 hex
>  - Do not fail the entire tdx-host device when update features encounter =
errors
>  - Drop superfluous is_visible() function for P-SEAMLDR sysfs nodes
>  - Add support for sigstruct sizes up to 16KB
>  - Move CONFIG_INTEL_TDX_MODULE_UPDATE kconfig entry under TDX_HOST_SERVI=
CES
>  - Various cleanups and changelog improvements for clarity and consistenc=
y
>  - Collect review tags from ZhenZhong and Jonathan
>  - v2: https://lore.kernel.org/linux-coco/20251001025442.427697-1-chao.ga=
o@intel.com/
>
> This series adds support for runtime TDX Module updates that preserve
> running TDX guests. It is also available at:
>
>   https://github.com/gaochaointel/linux-dev/commits/tdx-module-updates-v3=
/
>
> =3D=3D Background =3D=3D
>
> Intel TDX isolates Trusted Domains (TDs), or confidential guests, from th=
e
> host. A key component of Intel TDX is the TDX Module, which enforces
> security policies to protect the memory and CPU states of TDs from the
> host. However, the TDX Module is software that require updates.
>
> =3D=3D Problems =3D=3D
>
> Currently, the TDX Module is loaded by the BIOS at boot time, and the onl=
y
> way to update it is through a reboot, which results in significant system
> downtime. Users expect the TDX Module to be updatable at runtime without
> disrupting TDX guests.
>
> =3D=3D Solution =3D=3D
>
> On TDX platforms, P-SEAMLDR[1] is a component within the protected SEAM
> range. It is loaded by the BIOS and provides the host with functions to
> install a TDX Module at runtime.
>
> Implement a TDX Module update facility via the fw_upload mechanism. Given
> that there is variability in which module update to load based on feature=
s,
> fix levels, and potentially reloading the same version for error recovery
> scenarios, the explicit userspace chosen payload flexibility of fw_upload
> is attractive.
>
> This design allows the kernel to accept a bitstream instead of loading a
> named file from the filesystem, as the module selection and policy
> enforcement for TDX Modules are quite complex (see more in patch 8). By
> doing so, much of this complexity is shifted out of the kernel. The kerne=
l
> need to expose information, such as the TDX Module version, to userspace.
> Userspace must understand the TDX Module versioning scheme and update
> policy to select the appropriate TDX Module (see "TDX Module Versioning"
> below).
>
> In the unlikely event the update fails, for example userspace picks an
> incompatible update image, or the image is otherwise corrupted, all TDs
> will experience SEAMCALL failures and be killed. The recovery of TD
> operation from that event requires a reboot.
>
> Given there is no mechanism to quiesce SEAMCALLs, the TDs themselves must
> pause execution over an update. The most straightforward way to meet the
> 'pause TDs while update executes' constraint is to run the update in
> stop_machine() context. All other evaluated solutions export more
> complexity to KVM, or exports more fragility to userspace.
>
> =3D=3D How to test this series =3D=3D
>
> First, load kvm-intel.ko and tdx-host.ko if they haven't been loaded:
>
>  # modprobe -r kvm_intel
>  # modprobe kvm_intel tdx=3D1
>  # modprobe tdx-host
>
> Then, use the userspace tool below to select the appropriate TDX module a=
nd
> install it via the interfaces exposed by this series:
>
>  # git clone https://github.com/intel/tdx-module-binaries
>  # cd tdx-module-binaries
>  # python version_select_and_load.py --update
>
> =3D=3D Other information relevant to Runtime TDX Module updates =3D=3D
>
> =3D=3D=3D TDX Module versioning =3D=3D=3D
>
> Each TDX Module is assigned a version number x.y.z, where x represents th=
e
> "major" version, y the "minor" version, and z the "update" version.
>
> Runtime TDX Module updates are restricted to Z-stream releases.
>
> Note that Z-stream releases do not necessarily guarantee compatibility. A
> new release may not be compatible with all previous versions. To address =
this,
> Intel provides a separate file containing compatibility information, whic=
h
> specifies the minimum module version required for a particular update. Th=
is
> information is referenced by the tool to determine if two modules are
> compatible.
>
> =3D=3D=3D TCB Stability =3D=3D=3D
>
> Updates change the TCB as viewed by attestation reports. In TDX there is
> a distinction between launch-time version and current version where
> runtime TDX Module updates cause that latter version number to change,
> subject to Z-stream constraints.
>
> The concern that a malicious host may attack confidential VMs by loading
> insecure updates was addressed by Alex in [3]. Similarly, the scenario
> where some "theoretical paranoid tenant" in the cloud wants to audit
> updates and stop trusting the host after updates until audit completion
> was also addressed in [4]. Users not in the cloud control the host machin=
e
> and can manage updates themselves, so they don't have these concerns.
>
> See more about the implications of current TCB version changes in
> attestation as summarized by Dave in [5].
>
> =3D=3D=3D TDX Module Distribution Model =3D=3D=3D
>
> At a high level, Intel publishes all TDX Modules on the github [2], along
> with a mapping_file.json which documents the compatibility information
> about each TDX Module and a userspace tool to install the TDX Module. OS
> vendors can package these modules and distribute them. Administrators
> install the package and use the tool to select the appropriate TDX Module
> and install it via the interfaces exposed by this series.
>
> [1]: https://cdrdv2.intel.com/v1/dl/getContent/733584
> [2]: https://github.com/intel/tdx-module-binaries
> [3]: https://lore.kernel.org/all/665c5ae0-4b7c-4852-8995-255adf7b3a2f@ama=
zon.com/
> [4]: https://lore.kernel.org/all/5d1da767-491b-4077-b472-2cc3d73246d6@ama=
zon.com/
> [5]: https://lore.kernel.org/all/94d6047e-3b7c-4bc1-819c-85c16ff85abf@int=
el.com/
>
> Chao Gao (25):
>   x86/virt/tdx: Print SEAMCALL leaf numbers in decimal
>   x86/virt/tdx: Use %# prefix for hex values in SEAMCALL error messages
>   coco/tdx-host: Introduce a "tdx_host" device
>   coco/tdx-host: Expose TDX Module version
>   x86/virt/tdx: Prepare to support P-SEAMLDR SEAMCALLs
>   x86/virt/seamldr: Introduce a wrapper for P-SEAMLDR SEAMCALLs
>   x86/virt/seamldr: Retrieve P-SEAMLDR information
>   coco/tdx-host: Expose P-SEAMLDR information via sysfs
>   coco/tdx-host: Implement FW_UPLOAD sysfs ABI for TDX Module updates
>   x86/virt/seamldr: Block TDX Module updates if any CPU is offline
>   x86/virt/seamldr: Verify availability of slots for TDX Module updates
>   x86/virt/seamldr: Allocate and populate a module update request
>   x86/virt/seamldr: Introduce skeleton for TDX Module updates
>   x86/virt/seamldr: Abort updates if errors occurred midway
>   x86/virt/seamldr: Shut down the current TDX module
>   x86/virt/tdx: Reset software states after TDX module shutdown
>   x86/virt/seamldr: Log TDX Module update failures
>   x86/virt/seamldr: Install a new TDX Module
>   x86/virt/seamldr: Do TDX per-CPU initialization after updates
>   x86/virt/tdx: Establish contexts for the new TDX Module
>   x86/virt/tdx: Update tdx_sysinfo and check features post-update
>   x86/virt/tdx: Enable TDX Module runtime updates
>   x86/virt/seamldr: Extend sigstruct to 16KB
>   x86/virt/tdx: Avoid updates during update-sensitive operations
>   coco/tdx-host: Set and document TDX Module update expectations
>
> Kai Huang (1):
>   x86/virt/tdx: Move low level SEAMCALL helpers out of <asm/tdx.h>
>
>  .../ABI/testing/sysfs-devices-faux-tdx-host   |  76 ++++
>  arch/x86/include/asm/seamldr.h                |  29 ++
>  arch/x86/include/asm/tdx.h                    |  66 +--
>  arch/x86/include/asm/tdx_global_metadata.h    |   5 +
>  arch/x86/kvm/vmx/tdx_errno.h                  |   2 -
>  arch/x86/virt/vmx/tdx/Makefile                |   1 +
>  arch/x86/virt/vmx/tdx/seamcall.h              | 125 ++++++
>  arch/x86/virt/vmx/tdx/seamldr.c               | 398 ++++++++++++++++++
>  arch/x86/virt/vmx/tdx/tdx.c                   | 153 ++++---
>  arch/x86/virt/vmx/tdx/tdx.h                   |  11 +-
>  arch/x86/virt/vmx/tdx/tdx_global_metadata.c   |  13 +
>  drivers/virt/coco/Kconfig                     |   2 +
>  drivers/virt/coco/Makefile                    |   1 +
>  drivers/virt/coco/tdx-host/Kconfig            |  22 +
>  drivers/virt/coco/tdx-host/Makefile           |   1 +
>  drivers/virt/coco/tdx-host/tdx-host.c         | 260 ++++++++++++
>  16 files changed, 1064 insertions(+), 101 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-devices-faux-tdx-host
>  create mode 100644 arch/x86/include/asm/seamldr.h
>  create mode 100644 arch/x86/virt/vmx/tdx/seamcall.h
>  create mode 100644 arch/x86/virt/vmx/tdx/seamldr.c
>  create mode 100644 drivers/virt/coco/tdx-host/Kconfig
>  create mode 100644 drivers/virt/coco/tdx-host/Makefile
>  create mode 100644 drivers/virt/coco/tdx-host/tdx-host.c
>
> --
> 2.47.3
>
>

