Return-Path: <kvm+bounces-32811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 556DF9DFC75
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 09:54:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 180ADB211F1
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 08:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D96101F9F79;
	Mon,  2 Dec 2024 08:54:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC2BF1D6DD8;
	Mon,  2 Dec 2024 08:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733129662; cv=none; b=jwi/syPBeoANXohLcv1OiX22h2ehDwDKUplx1PqXmKULfGpTq9pIandw9mjdo6KV1etmmpa2nDvmtHjc/8IfXPatpBwcJG8rvJbE7e0/iNaLE5GKLQ11YWzjK8qM8KS+H2PkRWCf7eDQtHEnE72gEoiIP3H+3MC1LvcxeXyPQ2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733129662; c=relaxed/simple;
	bh=R6Fv08YSF9tjEaXOB/g1hNUtf8CGUiQoNMyz9uhE03s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VKhJqsdMyGpePeHBzqVr2GVADkfpXj2snkLpHYC79gar+X5uS/HQ3/ivywNjIl3TVVjA/eAooJtmoB0CSdN0nvbawiu9KKP9gsogcgTPbRZemZ/oYa8++qjj0e2zBbkNJrNhzFU+T+N0qESDTkqn9bvnz0aSV5uZewO6dSRz4/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABE041063;
	Mon,  2 Dec 2024 00:54:46 -0800 (PST)
Received: from [10.57.90.186] (unknown [10.57.90.186])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A3BA3F71E;
	Mon,  2 Dec 2024 00:54:13 -0800 (PST)
Message-ID: <01205247-ffcd-439f-b00f-d8e70720d049@arm.com>
Date: Mon, 2 Dec 2024 08:54:11 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/43] arm64: Support for Arm CCA in KVM
To: Itaru Kitayama <itaru.kitayama@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20241004152804.72508-1-steven.price@arm.com>
 <Z01BYOgsLXV5yULk@vm3>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <Z01BYOgsLXV5yULk@vm3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Itaru,

On 02/12/2024 05:10, Itaru Kitayama wrote:
> On Fri, Oct 04, 2024 at 04:27:21PM +0100, Steven Price wrote:
>> This series adds support for running protected VMs using KVM under the
>> Arm Confidential Compute Architecture (CCA).
...
> 
> On FVP, the v5+v7 kernel is unable to execute virt-manager:
> 
> Starting install...
> Allocating 'test9.qcow2'                                    |    0 B  00:00 ...
> Removing disk 'test9.qcow2'                                 |    0 B  00:00
> ERROR    internal error: process exited while connecting to monitor: 2024-12-04T18:56:11.646168Z qemu-system-aarch64: -accel kvm: ioctl(KVM_CREATE_VM) failed: Invalid argument
> 2024-12-04T18:56:11.646520Z qemu-system-aarch64: -accel kvm: failed to initialize kvm: Invalid argument
> Domain installation does not appear to have been successful.

Can you check that the kernel has detected the RMM being available, you
should have a message like below when the host kernel is booting:

kvm [1]: RMI ABI version 1.0

My guess is that you've got mismatched versions of the RMM and TF-A. The
interface between those two components isn't stable and there were
breaking changes fairly recently. And obviously if the RMM hasn't
initialised successfully then confidential VMs won't be available.

> Below is my virt-manager options:
> 
> virt-install --machine=virt --arch=aarch64 --name=test9 --memory=2048 --vcpu=1 --nographic --check all=off --features acpi=off --virt-type kvm --boot kernel=Image-cca,initrd=rootfs.cpio,kernel_args='earlycon console=ttyAMA0 rdinit=/sbin/init rw root=/dev/vda acpi=off' --qemu-commandline='-M virt,confidential-guest-support=rme0,gic-version=3 -cpu host -object rme-guest,id=rme0 -nodefaults' --disk size=4 --import --osinfo detect=on,require=off
> 
> Userland is Ubuntu 24.10, the VMM is Linaro's cca/2024-11-20:
> 
> https://git.codelinaro.org/linaro/dcap/qemu/-/tree/cca/2024-11-20?ref_type=heads

I don't think this is the latest QEMU tree, Jean-Philippe posted an
update last week:

https://lore.kernel.org/qemu-devel/20241125195626.856992-2-jean-philippe@linaro.org/

I'm not sure if there were any important updates there, but there are
detailed instructions that might help.

Regards,
Steve


