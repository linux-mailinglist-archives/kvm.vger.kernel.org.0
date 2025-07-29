Return-Path: <kvm+bounces-53597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1870B1475A
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 06:59:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1A807A3422
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 04:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B94722AE76;
	Tue, 29 Jul 2025 04:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vEGeRVBa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650BE78F34
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 04:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753765150; cv=none; b=bYDpZF6Dhn5m4sZO2ufT3wC2YsQFVSDz2RJZuG8fB7xBXlf1Oh8E8FItodFFPeFiOBYTBTGcRfiajSVhQ32qhzeRNQ27kPAh3rt79rK8eyOULrcxN+1kfUYoWhrH7Pf49cyDKuFLSsSjxfkTzyBdZ71QNFbJ5yPE0RM94BFfx2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753765150; c=relaxed/simple;
	bh=OGHML/72d9kJnWTVsS50xdQUsgPR+uC+iOLiQ/eoOqQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=te+AMCUQSJgbr657Gs9pIRt7a7n1ON8o+g+TsU++4GgtugWuy2XtD96Eziskyxfh+2abylh5aZLYiwiP7eKOCbZhrqgMzO0TcymvutH+owfUy8NeCSkJUgvzmYAg8ZlgBzsHL6d6V2JlyGBsj7wBLLeouxjAnmWins2Hldsd1VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vEGeRVBa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77A5C4CEEF;
	Tue, 29 Jul 2025 04:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753765149;
	bh=OGHML/72d9kJnWTVsS50xdQUsgPR+uC+iOLiQ/eoOqQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=vEGeRVBardNxiixDlc32dyxmSCitI4Q0uDQC+K2RkCx7ORMG3bFTVnEVDXCDliVRt
	 oJXn8aQY293o+Diwmy9sjLJmINzTK5OuLC5cou4E7jZZtc6Pe+o2hz70FrlYZbXf1V
	 HIlEHn8ZoDACrz26eu3Bi5gFdrXTxCl8Jha9nG/X8CeynVz8qY1Ls+FyxYJatF2oo4
	 VAIajD+WU5gXZ/lDBqewTabpUc3lhI3XufHEJrT+MjmucAJDD0wo7IYFc7O9lVEbuz
	 pCo7PigQvuZ20wMIFN04YAaz0oqhSoAZn1iDTNerLx1S1uLTGjllcODlAPOGHCG3FU
	 ucbHaWOuEsCQQ==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 03/10] vfio: Create new file legacy.c
In-Reply-To: <aIZulgInZXazv8oY@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-3-aneesh.kumar@kernel.org>
 <aIZulgInZXazv8oY@google.com>
Date: Tue, 29 Jul 2025 10:29:04 +0530
Message-ID: <yq5ajz3rbnjb.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mostafa Saleh <smostafa@google.com> writes:

> On Sun, May 25, 2025 at 01:19:09PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> Move legacy vfio config methodology to legacy.c. Also add helper
>> vfio_map/unmap_mem_range which will be switched to function pointers in
>> the later patch.
>>=20
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> ---
>>  Makefile           |   1 +
>>  include/kvm/vfio.h |  14 ++
>>  vfio/core.c        | 342 ++------------------------------------------
>>  vfio/legacy.c      | 347 +++++++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 372 insertions(+), 332 deletions(-)
>>  create mode 100644 vfio/legacy.c
>>=20
>> diff --git a/Makefile b/Makefile
>> index 60e551fd0c2a..8b2720f73386 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -65,6 +65,7 @@ OBJS	+=3D pci.o
>>  OBJS	+=3D term.o
>>  OBJS	+=3D vfio/core.o
>>  OBJS	+=3D vfio/pci.o
>> +OBJS	+=3D vfio/legacy.o
>>  OBJS	+=3D virtio/blk.o
>>  OBJS	+=3D virtio/scsi.o
>>  OBJS	+=3D virtio/console.o
>> diff --git a/include/kvm/vfio.h b/include/kvm/vfio.h
>> index ac7b6226239a..67a528f18d33 100644
>> --- a/include/kvm/vfio.h
>> +++ b/include/kvm/vfio.h
>> @@ -126,4 +126,18 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio=
_region *region);
>>  int vfio_pci_setup_device(struct kvm *kvm, struct vfio_device *device);
>>  void vfio_pci_teardown_device(struct kvm *kvm, struct vfio_device *vdev=
);
>>=20=20
>> +int vfio_map_mem_range(struct kvm *kvm, __u64 host_addr, __u64 iova, __=
u64 size);
>> +int vfio_unmap_mem_range(struct kvm *kvm, __u64 iova, __u64 size);
>> +
>> +struct kvm_mem_bank;
>> +int vfio_map_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, void =
*data);
>> +int vfio_unmap_mem_bank(struct kvm *kvm, struct kvm_mem_bank *bank, voi=
d *data);
>> +int vfio_configure_reserved_regions(struct kvm *kvm, struct vfio_group =
*group);
>> +int legacy_vfio__init(struct kvm *kvm);
>> +int legacy_vfio__exit(struct kvm *kvm);
>> +
>> +extern int kvm_vfio_device;
>> +extern struct list_head vfio_groups;
>> +extern struct vfio_device *vfio_devices;
>> +
>>  #endif /* KVM__VFIO_H */
>> diff --git a/vfio/core.c b/vfio/core.c
>> index 424dc4ed3aef..2af30df3b2b9 100644
>> --- a/vfio/core.c
>> +++ b/vfio/core.c
>> @@ -4,14 +4,11 @@
>>=20=20
>>  #include <linux/list.h>
>>=20=20
>> -#define VFIO_DEV_DIR		"/dev/vfio"
>> -#define VFIO_DEV_NODE		VFIO_DEV_DIR "/vfio"
>>  #define IOMMU_GROUP_DIR		"/sys/kernel/iommu_groups"
>>=20=20
>> -static int vfio_container;
>> -static int kvm_vfio_device;
>> -static LIST_HEAD(vfio_groups);
>> -static struct vfio_device *vfio_devices;
>> +int kvm_vfio_device;
>
> kvm_vfio_device shouldn=E2=80=99t be VFIO/IOMMUFD specific, so that leads=
 to
> duplication in both files, I suggest move it=E2=80=99s management to the =
vfio/core.c
> (and don=E2=80=99t extern the fd) And either export a function to add dev=
ices or maybe,
> better doing it once from vfio__init()
>
>> +LIST_HEAD(vfio_groups);
> =E2=80=9Cvfio_groups=E2=80=9D seems not to be used by the core code, mayb=
e it=E2=80=99s better to have a
> static version in each file?
> Also, as that is not really used for IOMMUFD, it seems to move group logi=
c into
> legacy file. Instead of making iommufd populating groups so the core code=
 handle
> the group exit.
>

I am also using the groups for reserved region configuration.

static int iommufd_configure_reserved_mem(struct kvm *kvm)
{
	int ret;
	struct vfio_group *group;

	list_for_each_entry(group, &vfio_groups, list) {
		ret =3D vfio_configure_reserved_regions(kvm, group);
		if (ret)
			return ret;
	}
	return 0;
}

An updated version of these patches can be found at
https://gitlab.arm.com/linux-arm/kvmtool-cca/-/tree/cca/tdisp-upstream-post=
-v1

>
>> +struct vfio_device *vfio_devices;
>>=20=20
>
> Similarly for =E2=80=9Cvfio_devices=E2=80=9D, it=E2=80=99s only allocated=
/freed in core code, but never used.
> But no strong opinion about that.
>
> Thanks,
> Mostafa
>

-aneesh

