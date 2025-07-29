Return-Path: <kvm+bounces-53596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 38868B14757
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 06:53:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5174D540BD1
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 04:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55ACF22AE76;
	Tue, 29 Jul 2025 04:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZLlNA4VJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8066378F5E
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 04:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753764790; cv=none; b=lu0KvYDNtO9+GZ3THEz/gKlPArzG1g+f2m/mP6o9jo8l9dflXSnsbHAq6PBLkhy8bNdQEISmPsn8PncTn7uoDKGYvlvIeCNh9rnpYXijar33hj/ce1Bn+aykuxDpd0Jj/1R4nk+1RByikxmbnvykvPS1gElBk2j0EcJMtEJXtxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753764790; c=relaxed/simple;
	bh=JeIzu/vv0Xyf6BMdhzq1eRIZbdak9DThRpsJxiByLDs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=TsCbFz9du2aneYefhOgqLyIXO78cMe7CDpUsMMOsUbubsXgTRz24Rc4UVd5dJybBt4NdI8JTocMo2uFv7yOxbyWrUjQ4WahiJ2eNEPcmGvO51P0d+IjCQHrmL5S7wmADiauODhmQ9pQ58T3WVyAjaNo0DNhWphRSOA+cw6wAAtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZLlNA4VJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E170C4CEEF;
	Tue, 29 Jul 2025 04:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753764790;
	bh=JeIzu/vv0Xyf6BMdhzq1eRIZbdak9DThRpsJxiByLDs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ZLlNA4VJJ0ExQdkEY2SMmvHnMS7henZTELiiB/kSahqFh8FCjBKhMleEjphF72EKw
	 ptBuKUovecKvqUIjbIQc4DcnE6WVm3KvjN4yA2MktjTZJPGRldsN6E5weDBopebooz
	 JiG6qjdk/caWPuN1/B2yqM45wciGTInirEB6S5oLErvV5CvjjGPcFLuv8T9EPXYAx5
	 wFig01D+DwfavhyYRGlQpeto+A4ZWa44YpIfnkKSFjaxwAb8HuqOiyyiWmGXNdlrij
	 MQoqr6tlAFdpB/IzmmQVFJiiOefEPIgRKzmXv2Bl2mTYLhTMIl3cjJqSAyObn9AQoI
	 xVtwZvof4yWIw==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 02/10] vfio: Rename some functions
In-Reply-To: <aIZuAlHQRdi5PUqY@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-2-aneesh.kumar@kernel.org>
 <aIZuAlHQRdi5PUqY@google.com>
Date: Tue, 29 Jul 2025 10:23:03 +0530
Message-ID: <yq5ams8nbntc.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Mostafa Saleh <smostafa@google.com> writes:

> On Sun, May 25, 2025 at 01:19:08PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> We will add iommufd support in later patches. Rename the old vfio
>> method as legacy vfio.
>> 
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> ---
>>  vfio/core.c | 31 ++++++++++++++++---------------
>>  1 file changed, 16 insertions(+), 15 deletions(-)
>> 
>> diff --git a/vfio/core.c b/vfio/core.c
>> index c6b305c30cf7..424dc4ed3aef 100644
>> --- a/vfio/core.c
>> +++ b/vfio/core.c
>> @@ -282,7 +282,7 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region)
>>  	}
>>  }
>>  
>> -static int vfio_configure_device(struct kvm *kvm, struct vfio_device *vdev)
>> +static int legacy_vfio_configure_device(struct kvm *kvm, struct vfio_device *vdev)
>>  {
>>  	int ret;
>>  	struct vfio_group *group = vdev->group;
>> @@ -340,12 +340,12 @@ err_close_device:
>>  	return ret;
>>  }
>>  
>> -static int vfio_configure_devices(struct kvm *kvm)
>> +static int legacy_vfio_configure_devices(struct kvm *kvm)
>>  {
>>  	int i, ret;
>>  
>>  	for (i = 0; i < kvm->cfg.num_vfio_devices; ++i) {
>> -		ret = vfio_configure_device(kvm, &vfio_devices[i]);
>> +		ret = legacy_vfio_configure_device(kvm, &vfio_devices[i]);
>>  		if (ret)
>>  			return ret;
>>  	}
>> @@ -429,7 +429,7 @@ static int vfio_configure_reserved_regions(struct kvm *kvm,
>>  	return ret;
>>  }
>>  
>> -static int vfio_configure_groups(struct kvm *kvm)
>> +static int legacy_vfio_configure_groups(struct kvm *kvm)
>>  {
>>  	int ret;
>>  	struct vfio_group *group;
>> @@ -454,7 +454,7 @@ static int vfio_configure_groups(struct kvm *kvm)
>>  	return 0;
>>  }
>>  
>> -static struct vfio_group *vfio_group_create(struct kvm *kvm, unsigned long id)
>> +static struct vfio_group *legacy_vfio_group_create(struct kvm *kvm, unsigned long id)
>>  {
>>  	int ret;
>>  	struct vfio_group *group;
>> @@ -512,10 +512,11 @@ static void vfio_group_exit(struct kvm *kvm, struct vfio_group *group)
>>  	if (--group->refs != 0)
>>  		return;
>>  
>> -	ioctl(group->fd, VFIO_GROUP_UNSET_CONTAINER);
>> -
>>  	list_del(&group->list);
>> -	close(group->fd);
>> +	if (group->fd != -1) {
>> +		ioctl(group->fd, VFIO_GROUP_UNSET_CONTAINER);
>> +		close(group->fd);
>> +	}
>
> That seems unrelated to the rename, maybe it's better to move that when
> IOMMUFD is supported as it's related to it.
>

Sure. Will make the change as part of iommufd patch.

-aneesh

