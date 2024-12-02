Return-Path: <kvm+bounces-32815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F059DFF2D
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 11:43:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DC02161663
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 10:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 189071FCCF7;
	Mon,  2 Dec 2024 10:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vhuZPDWq"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561AF1FC7C6
	for <kvm@vger.kernel.org>; Mon,  2 Dec 2024 10:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733136185; cv=none; b=uoDocnuy1VrSey6lwMDC3wz0MX3xah61PwQmxgPbk8w+9oIEJo+ohPm/1YH8Lg+TdVkHtknhzibYBqlTmkO+rsfaTYuNWEgtz9a/eplUXIDXaNXfKnQcHgUkf49E2ufe/JZ0u4PHnvdPccMhSrKRVYeNSLbG0IXvfMhpdvsC3zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733136185; c=relaxed/simple;
	bh=o3AswsMzM/79o6tFWYS0sumS3t3POsKEw6EKmmBb4wA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=aOt71zL8tH6rm2AgkxqpmSqq5bU9RWwCR0c6pJvOzfOSaiFlPOuhpOrug4KHE49MBdxbse28/v/E2wWNZ67gNW2WSAHzQ8ERZbFfQ1/Tje0ZJ8KOk3er12QGG9oJI5DozDEbpuxKAx1VKbpzQlFQAse8eywMe8RT53eD8xOtym4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vhuZPDWq; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733136179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3XDTr/NR5SD4RF/6LFpn9c+Bv/YVG8nMFpd1E2zXJR4=;
	b=vhuZPDWqgm76+q6ewLyMPCFh8xtFQfXZpnLlBP0GtCbRbGS5yT0vzIKcSESow+4tTUjouB
	g08a9i5/NwhtOCRQkg+Av6KW+WHzXN8pNNRJsbcJ+Q0GCe/WY+fj+dLLEkg2Ci3n4L8xgO
	IUyrOUDIcHYs9nOTbaUGL5ln6UQ2oNQ=
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH v5 00/43] arm64: Support for Arm CCA in KVM
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
In-Reply-To: <20241202102632.GB1704077@myrica>
Date: Mon, 2 Dec 2024 19:42:35 +0900
Cc: kvm@vger.kernel.org,
 kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>,
 Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4313C668-D48C-4443-917E-67A112BE1C37@linux.dev>
References: <20241004152804.72508-1-steven.price@arm.com>
 <Z01BYOgsLXV5yULk@vm3> <01205247-ffcd-439f-b00f-d8e70720d049@arm.com>
 <20241202102632.GB1704077@myrica>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Steven Price <steven.price@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Jean, Steven,

> On Dec 2, 2024, at 19:26, Jean-Philippe Brucker =
<jean-philippe@linaro.org> wrote:
>=20
> On Mon, Dec 02, 2024 at 08:54:11AM +0000, Steven Price wrote:
>> Hi Itaru,
>>=20
>> On 02/12/2024 05:10, Itaru Kitayama wrote:
>>> On Fri, Oct 04, 2024 at 04:27:21PM +0100, Steven Price wrote:
>>>> This series adds support for running protected VMs using KVM under =
the
>>>> Arm Confidential Compute Architecture (CCA).
>> ...
>>>=20
>>> On FVP, the v5+v7 kernel is unable to execute virt-manager:
>>>=20
>>> Starting install...
>>> Allocating 'test9.qcow2'                                    |    0 B =
 00:00 ...
>>> Removing disk 'test9.qcow2'                                 |    0 B =
 00:00
>>> ERROR    internal error: process exited while connecting to monitor: =
2024-12-04T18:56:11.646168Z qemu-system-aarch64: -accel kvm: =
ioctl(KVM_CREATE_VM) failed: Invalid argument
>>> 2024-12-04T18:56:11.646520Z qemu-system-aarch64: -accel kvm: failed =
to initialize kvm: Invalid argument
>>> Domain installation does not appear to have been successful.
>>=20
>> Can you check that the kernel has detected the RMM being available, =
you
>> should have a message like below when the host kernel is booting:
>>=20
>> kvm [1]: RMI ABI version 1.0
>>=20
>> My guess is that you've got mismatched versions of the RMM and TF-A. =
The
>> interface between those two components isn't stable and there were
>> breaking changes fairly recently. And obviously if the RMM hasn't
>> initialised successfully then confidential VMs won't be available.
>>=20
>>> Below is my virt-manager options:
>>>=20
>>> virt-install --machine=3Dvirt --arch=3Daarch64 --name=3Dtest9 =
--memory=3D2048 --vcpu=3D1 --nographic --check all=3Doff --features =
acpi=3Doff --virt-type kvm --boot =
kernel=3DImage-cca,initrd=3Drootfs.cpio,kernel_args=3D'earlycon =
console=3DttyAMA0 rdinit=3D/sbin/init rw root=3D/dev/vda acpi=3Doff' =
--qemu-commandline=3D'-M =
virt,confidential-guest-support=3Drme0,gic-version=3D3 -cpu host -object =
rme-guest,id=3Drme0 -nodefaults' --disk size=3D4 --import --osinfo =
detect=3Don,require=3Doff
>>>=20
>>> Userland is Ubuntu 24.10, the VMM is Linaro's cca/2024-11-20:
>>>=20
>>> =
https://git.codelinaro.org/linaro/dcap/qemu/-/tree/cca/2024-11-20?ref_type=
=3Dheads
>=20
> Indeed, QEMU branch 2024-11-20 has to be used with an older version of =
the
> KVM patch and older RMM. For KVM v5+v7 you need the most recent QEMU
> branch, confusingly called cca/v3 (because it's the third patch =
series).
>=20
> Thanks,
> Jean

I wasn=E2=80=99t applying with the updated Shrinkwrap=E2=80=99s overlay =
file when building TF-RMM.
With the correct VMM as you guys mentioned (cca/v3) I was able to start =
the installation via
the virt-install interacting with the Ubuntu 24.10=E2=80=99s monolitihc =
libvirtd.

Thanks,
Itaru.

>=20
>>=20
>> I don't think this is the latest QEMU tree, Jean-Philippe posted an
>> update last week:
>>=20
>> =
https://lore.kernel.org/qemu-devel/20241125195626.856992-2-jean-philippe@l=
inaro.org/
>>=20
>> I'm not sure if there were any important updates there, but there are
>> detailed instructions that might help.
>>=20
>> Regards,
>> Steve



