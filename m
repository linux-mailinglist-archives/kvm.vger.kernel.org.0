Return-Path: <kvm+bounces-21075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5912929A64
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 02:48:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EE411C20B76
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 00:48:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1F7A1C36;
	Mon,  8 Jul 2024 00:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M/0oSxoW"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA599812
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 00:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720399688; cv=none; b=YqvnDdE+oKCUGNcAelzSSdwIMlGwbFH77ZXN68s+XPjN//ex1/rXgGoXFpQoi5KdVPeAqW5vpNP8uUNQebqTcsnVLWAY3Jojs1dUkAY/9A2BeL03bi/pF8N3iFCTk+6XpUpfuCmJ4LQBsGCn0dJIEZeA9yFuADvK2aN2tw2mazo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720399688; c=relaxed/simple;
	bh=f6qGioRsyn9uhGA9FebTmGgZNz9tgz9fGqqE5XcRkRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xq3a3u/W28/Yigj7KKkpfsLcPJ/Tc09fLETBHF6NtgygqeLVzmJnVzRDzVo2is2shE8ln0bhk8g7cwhPePn7bSGPrOFf0+ZCB7uj8j2zeQob54/p9iy3xLqszK85HwugvzZHOqZrR5/1pL5+BEa6PEqWvyJLfQ623e+GVs5+pBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M/0oSxoW; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: steven.price@arm.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720399683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4VqaCKhmSvsIIfQgRlt9NyheIU3+VMVh2mzlMHRF2pw=;
	b=M/0oSxoW0w/WgmfthKAVRlZWxA75J2a6AU1Ji2362YaZS7s7DWfN/uYbDco41qKYKvmFiP
	LcZ1/LwImQXgyNVpAHAV/J0wBYDeMK0DeZuQep7va8y/HJh7rRdJXIZP9SUp8z7WXboIK2
	YQ/v/2VZF9jJofKjmpyQDZlGgaCvlio=
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: maz@kernel.org
X-Envelope-To: will@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: oliver.upton@linux.dev
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: joey.gouly@arm.com
X-Envelope-To: alexandru.elisei@arm.com
X-Envelope-To: christoffer.dall@arm.com
X-Envelope-To: tabba@google.com
X-Envelope-To: linux-coco@lists.linux.dev
X-Envelope-To: gankulkarni@os.amperecomputing.com
Date: Mon, 8 Jul 2024 09:47:52 +0900
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [v2] Support for Arm CCA VMs on Linux
Message-ID: <Zos3OMcQ3EW-UBQ4@vm3>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <ZnkOfTVAaCJ_-_bG@vm3>
 <c6b49c81-58ba-40fc-9e17-892fdd79431d@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6b49c81-58ba-40fc-9e17-892fdd79431d@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Steven,

On Wed, Jun 26, 2024 at 02:39:27PM +0100, Steven Price wrote:
> On 24/06/2024 07:13, Itaru Kitayama wrote:
> > Hi Steven,
> > On Fri, Apr 12, 2024 at 09:40:56AM +0100, Steven Price wrote:
> >> We are happy to announce the second version of the Arm Confidential
> >> Compute Architecture (CCA) support for the Linux stack. The intention is
> >> to seek early feedback in the following areas:
> >>  * KVM integration of the Arm CCA;
> >>  * KVM UABI for managing the Realms, seeking to generalise the
> >>    operations where possible with other Confidential Compute solutions;
> >>  * Linux Guest support for Realms.
> >>
> >> See the previous RFC[1] for a more detailed overview of Arm's CCA
> >> solution, or visible the Arm CCA Landing page[2].
> >>
> >> This series is based on the final RMM v1.0 (EAC5) specification[3].
> >>
> >> Quick-start guide
> >> =================
> >>
> >> The easiest way of getting started with the stack is by using
> >> Shrinkwrap[4]. Currently Shrinkwrap has a configuration for the initial
> >> v1.0-EAC5 release[5], so the following overlay needs to be applied to
> >> the standard 'cca-3world.yaml' file. Note that the 'rmm' component needs
> >> updating to 'main' because there are fixes that are needed and are not
> >> yet in a tagged release. The following will create an overlay file and
> >> build a working environment:
> >>
> >> cat<<EOT >cca-v2.yaml
> >> build:
> >>   linux:
> >>     repo:
> >>       revision: cca-full/v2
> >>   kvmtool:
> >>     repo:
> >>       kvmtool:
> >>         revision: cca/v2
> >>   rmm:
> >>     repo:
> >>       revision: main
> >>   kvm-unit-tests:
> >>     repo:
> >>       revision: cca/v2
> >> EOT
> >>
> >> shrinkwrap build cca-3world.yaml --overlay buildroot.yaml --btvar GUEST_ROOTFS='${artifact:BUILDROOT}' --overlay cca-v2.yaml
> >>
> >> You will then want to modify the 'guest-disk.img' to include the files
> >> necessary for the realm guest (see the documentation in cca-3world.yaml
> >> for details of other options):
> >>
> >>   cd ~/.shrinkwrap/package/cca-3world
> >>   /sbin/e2fsck -fp rootfs.ext2 
> >>   /sbin/resize2fs rootfs.ext2 256M
> >>   mkdir mnt
> >>   sudo mount rootfs.ext2 mnt/
> >>   sudo mkdir mnt/cca
> >>   sudo cp guest-disk.img KVMTOOL_EFI.fd lkvm Image mnt/cca/
> >>   sudo umount mnt 
> >>   rmdir mnt/
> >>
> >> Finally you can run the FVP with the host:
> >>
> >>   shrinkwrap run cca-3world.yaml --rtvar ROOTFS=$HOME/.shrinkwrap/package/cca-3world/rootfs.ext2
> >>
> >> And once the host kernel has booted, login (user name 'root') and start
> >> a realm guest:
> >>
> >>   cd /cca
> >>   ./lkvm run --realm --restricted_mem -c 2 -m 256 -k Image -p earlycon
> >>
> >> Be patient and you should end up in a realm guest with the host's
> >> filesystem mounted via p9.
> >>
> >> It's also possible to use EFI within the realm guest, again see
> >> cca-3world.yaml within Shrinkwrap for more details.
> > 
> > I am trying to see if libvirt can work with the CCA-aware KVM with minimal Ubuntu22.10 filesystem, however virt-install triggers a system failure:
> > 
> > $ sudo virt-install -v --name f39 --ram 4096        --disk path=fedora40.img,cache=none --nographics --os-variant fedora38         --import --arch aarch64 --vcpus 4
> > [sudo] password for realm:
> > [ 3694.176579] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000e00
> > [ 3694.176687] Mem abort info:
> > [ 3694.176745]   ESR = 0x0000000096000004
> > [ 3694.176817]   EC = 0x25: DABT (current EL), IL = 32 bits
> > [ 3694.176907]   SET = 0, FnV = 0
> > [ 3694.176978]   EA = 0, S1PTW = 0
> > [ 3694.177049]   FSC = 0x04: level 0 translation fault
> > [ 3694.177132] Data abort info:
> > [ 3694.177189]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
> > [ 3694.177276]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
> > [ 3694.177370]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> > [ 3694.177544] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000880f6e000
> > [ 3694.177649] [0000000000000e00] pgd=0000000000000000, p4d=0000000000000000
> > [ 3694.177788] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
> > [ 3694.177887] Modules linked in:
> > [ 3694.177966] CPU: 2 PID: 540 Comm: qemu-system-aar Not tainted 6.10.0-rc1-00058-gd901c27a1783 #149
> > [ 3694.178105] Hardware name: FVP Base RevC (DT)
> > [ 3694.178180] pstate: 61400009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> > [ 3694.178315] pc : kvm_vm_ioctl_check_extension+0x1fc/0x3c4
> > [ 3694.178447] lr : kvm_vm_ioctl_check_extension_generic+0x34/0x12c
> > [ 3694.178587] sp : ffff800081523cb0
> > [ 3694.178657] x29: ffff800081523cb0 x28: 0000000000000051 x27: 0000000000000000
> > [ 3694.178840] x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
> > [ 3694.179019] x23: 000000000000000a x22: 0000000000000051 x21: ffff000801075f00
> > [ 3694.179200] x20: ffff000801075f01 x19: 000000000000ae03 x18: 0000000000000000
> > [ 3694.179383] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> > [ 3694.179565] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
> > [ 3694.179745] x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
> > [ 3694.179923] x8 : 0000000000000000 x7 : ffff000801075f18 x6 : 00000000401c5820
> > [ 3694.180106] x5 : 000000000000000a x4 : 0000000000000800 x3 : 0000000000000000
> > [ 3694.180285] x2 : 000000000000000b x1 : 0000000100061001 x0 : 0000000000000001
> > [ 3694.180465] Call trace:
> > [ 3694.180523]  kvm_vm_ioctl_check_extension+0x1fc/0x3c4
> > [ 3694.180656]  kvm_vm_ioctl_check_extension_generic+0x34/0x12c
> > [ 3694.180794]  kvm_dev_ioctl+0x3c8/0x8b8
> > [ 3694.180938]  __arm64_sys_ioctl+0xac/0xf0
> > [ 3694.181079]  invoke_syscall+0x48/0x114
> > [ 3694.181220]  el0_svc_common.constprop.0+0x40/0xe0
> > [ 3694.181367]  do_el0_svc+0x1c/0x28
> > [ 3694.181507]  el0_svc+0x34/0xd8
> > [ 3694.181608]  el0t_64_sync_handler+0x120/0x12c
> > [ 3694.181723]  el0t_64_sync+0x190/0x194
> > [ 3694.181865] Code: 17ffffbd 97fffc9d 12001c00 17ffff91 (39780060)
> > [ 3694.181955] ---[ end trace 0000000000000000 ]---
> > 
> > I'd appreciate it if you could take a look at it.
> 
> Thanks for the bug report. I believe this is because 
> kvm_vm_ioctl_check_extension() is being called with kvm==NULL and I've 
> missed some checks. I believe the following should get things working - 
> and it's probably better than attempting to remember to check with the 
> NULL kvm at each call site.
> 
> ---8<----
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 27c58bbdf50b..c85e5f566506 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -602,7 +602,7 @@ static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
>  
>  static inline bool kvm_is_realm(struct kvm *kvm)
>  {
> -       if (static_branch_unlikely(&kvm_rme_is_available))
> +       if (static_branch_unlikely(&kvm_rme_is_available) && kvm)
>                 return kvm->arch.is_realm;
>         return false;
>  }
> ---8<----

Sorry for my late reply I was away entire last week.

With the fix above, I was able to use the virt-install command on FVP without an issue.

Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>

Thanks,
Itaru.

> 
> Thanks,
> Steve

