Return-Path: <kvm+bounces-7034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B4D483D062
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 00:10:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56B85291B6B
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 23:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 272F512B9A;
	Thu, 25 Jan 2024 23:10:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CC5E134A0;
	Thu, 25 Jan 2024 23:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706224222; cv=none; b=dVBbGVNXVTLcbG0+rf85UZjJyX64UfWhsww5vGIwaY0z3Pq9BEjm2eUD7wHI3dbkAwJuSx0jn5FtS8XnIlMNTIBwovTJi/fA6m4dVI76x7nItYmAWQm9b/dubDkuQMJshF9+sHLbPDYwOXEEIGoyOi2Dlx2UYSDXEa726zDqSps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706224222; c=relaxed/simple;
	bh=WjAquZ3WjL/xwJBFncZOshEyjxA/1dzJMiU7mPslkcI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UuTqixFl/BFvyISeyHELthrpPdGvLsahL1Hr3drakRZexy4CxT1zRzCivv58jVt/aJSzlwbmHhd/USgcsldjjsAtXblnAFd9nBBa+RWxpT11hWNAvs6SblZun8IqPrlMKPu8kMnWz6pgHyExhwdGgSJ4+555l/PaC5VYTHT4EUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B5FB31FB;
	Thu, 25 Jan 2024 15:11:03 -0800 (PST)
Received: from [10.57.48.67] (unknown [10.57.48.67])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3670C3F5A1;
	Thu, 25 Jan 2024 15:10:18 -0800 (PST)
Message-ID: <cbde8e52-f1a9-4c45-b82c-f3ca13b96991@arm.com>
Date: Thu, 25 Jan 2024 23:10:16 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] virtio: uapi: Drop __packed attribute in
 linux/virtio_pci.h:
Content-Language: en-GB
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Feng Liu <feliu@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20240124172345.853129-1-suzuki.poulose@arm.com>
 <20240125174705-mutt-send-email-mst@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240125174705-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25/01/2024 22:48, Michael S. Tsirkin wrote:
> On Wed, Jan 24, 2024 at 05:23:45PM +0000, Suzuki K Poulose wrote:
>> Commit 92792ac752aa ("virtio-pci: Introduce admin command sending function")
>> added "__packed" structures to UAPI header linux/virtio_pci.h. This triggers
>> build failures in the consumer userspace applications without proper "definition"
>> of __packed (e.g., kvmtool build fails).
>>
>> Moreover, the structures are already packed well, and doesn't need explicit
>> packing, similar to the rest of the structures in all virtio_* headers. Remove
>> the __packed attribute.
>>
>> Fixes: commit 92792ac752aa ("virtio-pci: Introduce admin command sending function")
> 
> 
> Proper form is:
> 
> Fixes: 92792ac752aa ("virtio-pci: Introduce admin command sending function")

Apologies, for messing that up.

> 
>> Cc: Feng Liu <feliu@nvidia.com>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Cc: Yishai Hadas <yishaih@nvidia.com>
>> Cc: Alex Williamson <alex.williamson@redhat.com>
>> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
>>   include/uapi/linux/virtio_pci.h | 10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
>> index ef3810dee7ef..a8208492e822 100644
>> --- a/include/uapi/linux/virtio_pci.h
>> +++ b/include/uapi/linux/virtio_pci.h
>> @@ -240,7 +240,7 @@ struct virtio_pci_cfg_cap {
>>   #define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ		0x5
>>   #define VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO		0x6
>>   
>> -struct __packed virtio_admin_cmd_hdr {
>> +struct virtio_admin_cmd_hdr {
>>   	__le16 opcode;
>>   	/*
>>   	 * 1 - SR-IOV
>> @@ -252,20 +252,20 @@ struct __packed virtio_admin_cmd_hdr {
>>   	__le64 group_member_id;
>>   };
>>   
>> -struct __packed virtio_admin_cmd_status {
>> +struct virtio_admin_cmd_status {
>>   	__le16 status;
>>   	__le16 status_qualifier;
>>   	/* Unused, reserved for future extensions. */
>>   	__u8 reserved2[4];
>>   };
>>   
>> -struct __packed virtio_admin_cmd_legacy_wr_data {
>> +struct virtio_admin_cmd_legacy_wr_data {
>>   	__u8 offset; /* Starting offset of the register(s) to write. */
>>   	__u8 reserved[7];
>>   	__u8 registers[];
>>   };
>>   
>> -struct __packed virtio_admin_cmd_legacy_rd_data {
>> +struct virtio_admin_cmd_legacy_rd_data {
>>   	__u8 offset; /* Starting offset of the register(s) to read. */
>>   };
>>   
>> @@ -275,7 +275,7 @@ struct __packed virtio_admin_cmd_legacy_rd_data {
>>   
>>   #define VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO 4
>>   
>> -struct __packed virtio_admin_cmd_notify_info_data {
>> +struct virtio_admin_cmd_notify_info_data {
>>   	__u8 flags; /* 0 = end of list, 1 = owner device, 2 = member device */
>>   	__u8 bar; /* BAR of the member or the owner device */
>>   	__u8 padding[6];
> 
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> I will queue this.

Thanks
Suzuki

> 
>> -- 
>> 2.34.1
> 


