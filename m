Return-Path: <kvm+bounces-67085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E347CCF60F3
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 01:09:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D9AD33063F9A
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 00:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A00F125A9;
	Tue,  6 Jan 2026 00:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mRZZiiHw"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C603A1E6D
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 00:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767658141; cv=none; b=I6ufGBNgExe2qP9i/kzNxtvkhVnu2v5m6tcAHDRjZ6ho0vHcRzDI2YXgixy5XPRKBo+4lEX/4/WY5BFBUR/qCP2iOQUlwLBRYU223xsfFfchLpPVzPfiwhGftkTrE03I/CFuta5hw5bPaQUn3qcCRJvrYK0P1MftwZppy49Dg6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767658141; c=relaxed/simple;
	bh=a82xTthIcNehQpZ6rOGsATibYTCrmxAP5sovfwtE100=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jLsIEv4JksrqCWKbA78KrieEN7DAFLTeNVg+b8Zc/g8VgHAKEJEQGTjmWVIUu3FiwfnY9UeuwIZ/idGOS2+HFsBtz8gM6MgMYwLDzhV+gBx0iBP39uRNOtKyapOFk/NmdqbPzKr8QbfJywK+4qkALDYqWZZk6Bh716bAdaWzqFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mRZZiiHw; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <2779d6a2-d734-4334-befc-99f958e1d1ef@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767658127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CKXdtHAZxkL4dbdBsFp4H2lxuKZOEn/tbI1ZRL1PIoQ=;
	b=mRZZiiHwbDumZLLsIkopVpbarNOTKTnJPB8xLZGcwE7Ybhzd8Yt/TGxbLlTz4CDYMyNZz6
	UqVXDzVNpv53OnCuWigg/lV8KL8ARRDFapjmyvwOOg1VWAINwHs51v1lF4ky9AB4jo1fwD
	WbLWxgufYJ+Bx7GXloJw8TB8In11NWg=
Date: Mon, 5 Jan 2026 16:07:55 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 19/21] vfio: selftests: Expose low-level helper routines
 for setting up struct vfio_pci_device
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
 Adithya Jayachandran <ajayachandra@nvidia.com>, Alex Mastro
 <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
 David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Josh Hilke <jrhilke@google.com>,
 Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
 Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org,
 Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>,
 Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Philipp Stanner <pstanner@redhat.com>, Pratyush Yadav <pratyush@kernel.org>,
 Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <shuah@kernel.org>, Tomita Moeko <tomitamoeko@gmail.com>,
 Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
 Yi Liu <yi.l.liu@intel.com>, Yunxiang Li <Yunxiang.Li@amd.com>
References: <20251126193608.2678510-1-dmatlack@google.com>
 <20251126193608.2678510-20-dmatlack@google.com>
 <f0439348-dca7-4f1b-9d96-b5a596c9407d@linux.dev>
 <CALzav=duUuUaFLmTnRR41ZiWZKxbRAcb9LGvA5S8g2b5_Liv4g@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <CALzav=duUuUaFLmTnRR41ZiWZKxbRAcb9LGvA5S8g2b5_Liv4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 1/5/26 9:54 AM, David Matlack wrote:
> On Sat, Dec 27, 2025 at 8:04 PM Zhu Yanjun <yanjun.zhu@linux.dev> wrote:
>> 在 2025/11/26 11:36, David Matlack 写道:
>>> @@ -349,9 +351,20 @@ struct vfio_pci_device *__vfio_pci_device_init(const char *bdf,
>>>        device->bdf = bdf;
>>>        device->iommu = iommu;
>>>
>>> +     return device;
>>> +}
>>> +
>> In the latest kernel, this part changes too much.
> Can you clarify what you mean by "changes too much"? What is the issue?

I tried to apply this commit to the linux and linux-next repositories 
and run tests.

However, I’m unable to apply [PATCH 19/21] vfio: selftests: Expose 
low-level helper routines for setting up struct vfio_pci_device, because 
the related source code has changed significantly in both linux and 
linux-next.

If you plan to resend this patch series based on the latest linux or 
linux-next, please feel free to ignore this comment.

I look forward to testing the updated patch series once it is available.

Best Regards,

Yanjun.Zhu


