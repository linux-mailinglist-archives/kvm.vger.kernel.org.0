Return-Path: <kvm+bounces-72561-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CHFdAbstp2mbfgAAu9opvQ
	(envelope-from <kvm+bounces-72561-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 19:51:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B2031F57D5
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 19:51:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3D2A6303F1F0
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 18:51:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 837B248166A;
	Tue,  3 Mar 2026 18:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2Y3eOVNr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27ADC3537F9
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 18:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772563885; cv=none; b=XO/yrc4zVBYlMXT2grNuC9y3QlJDZQOCkvoYUTfDr58gcpkpGjwTH0rO6ON/38CV1FgZBK4wEmI9Sd5lW5OZrk9AlBaq71CNQPM5ZPI1XxdAaAlwkXASsxpKJ5x7NdjHlUX3i+H/Tkv+ev2mEHzf2Jz0bKrN2+P4jGuS9X299WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772563885; c=relaxed/simple;
	bh=saFrkHD9A0jl8FG23ePEQhYjIEsy4y0Or5I6Qiz+iBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cn88RVfowps5qVzqx8PdAS+Mm9UjB5KkeOnPhTX1QMmttwq5agJGAJ2+8jW6kX0Gm/l8EWo6/Q8uEYLX1gHvxaNBQNwrweReuMt/0/Z/AZeyaZIaSpPb/4n8telW2MSzV5Q/SKL8Be5QMu4atgAX4UISEz82klybE997ivjtpv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2Y3eOVNr; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ae49120e97so92905ad.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 10:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772563881; x=1773168681; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HlPLV02PSXP+edDlOLBCujALxcDghVDbBowN1loqhmY=;
        b=2Y3eOVNrE9i94IMY37bCnR9E5j0FL8OyqcPButlz/YyBNuYK01DiaLOhdrOGXn+yYD
         Xe7QsaxNT+02T5cJFKkqgw4F3q03SDU1zxnMlwnjDJtUYL8y2LNJl2fWYvK6KEzmlg6h
         QGliMVerZmzzyaaXN0oy0aPotGORrHkqLZmE3vdsK6wxOUO2JWYQ/AeqkQ0zhxnt/jfV
         Yzk0Ot6afS0rhej2XK9Xptlm98gVXiotYIZb8or39QpqzWGx0gLsvP15D4Q1IJVv6Rya
         hQBNAMQRzE9DFwk6CJ7AwmhGtOzlvfALf1uRvgr1Hhd78W4CN/o6qwxWx2uD8uIzNnws
         f5HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772563881; x=1773168681;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HlPLV02PSXP+edDlOLBCujALxcDghVDbBowN1loqhmY=;
        b=Nl0zCch9Xv+j8Qn0mDL3Nobj/hWt0rPSkrEcmL//DQOpHVPEkn2Sy9cDTadNftpYEk
         lo/rZiNtL1c6giCwPYQcQ/Luxlh/XNoKtiusft2TgL6d0QZc41OhZyxI8EM7Kl/Kz0s9
         yogenOkIx6Yk/tJS/a0z9nqYavzpm0lf+Sp+Rdyz3YNW/NorkscmPTgcxbPuZqmk+t+P
         ZGBuw2uiQ798wXsIZKhR9xFpD+wOgLk/uJRwOT4Qxi0N3LMkt0mXgEniMFO/Tq0a9Qjh
         nxvk+KpRCqA70AOYJhG9ldM6CszDF4cfWsu4nxUb5SzCuPwpViBqMG3PIQGtM00e+Za3
         PbPg==
X-Forwarded-Encrypted: i=1; AJvYcCU+DWwhg7SvmMZHqpotw5cXu2IcESJmpjZ1RmZ5BLfcY7Fr5mtopZ4+xq4GbfIuAgG1BWg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLhIV2FWSsxYiDTBPStAktDBXZhByDNHoQs/BzVNRpGZvsmxt8
	IU00XfeiF0+O4O+0M8+E6x88knVu9fR4d+FdS1NiTR9kqAedVfbN0InJdiQfzHzBiA==
X-Gm-Gg: ATEYQzxFEjAqPt5K24EPZ1YZltzWGDitCgRQ7mWOhCG9/x2qX4BXLrZWMMS8LHwiclS
	V03W1VGjWaZKTug0iXuxryVavj+QbrWTjX9LEXuoHEkCgm94DMkYRB0O0EQRX0vtrOwnCMvc7r4
	R7m/YQrANykgAIYB09wp+Zq7AQoey3JKTxC3ZQ0FLxIv6phTwc7q2SJht9CkbWDdldeB7IfYoLH
	FVOicIn1a47NipcxG6UBpAP5MQvzFo6QTZ9Sws0WfjPXECE3E++EU2+GM7q5l9wod1HQ/xAO48c
	aseg3mKC2q5NhAkE7hktYJFEsHD9YZwXzxLJZXqh+Zp/jGKTKhxvSW9/cZpqIgYO8xxTAl6iZdD
	HtvvDCX3BTNvrQgLD1ObsfBbU12Vy2EdcZwa2kNUcJQQuSm112A7uHRI+XyA4LjvdJldxQRfdbS
	2kmK52iGTrVznjY4BohFGn3Mv8LX6SkabkjpIKzlYfpu5ypiR00apnMla40fnDrg==
X-Received: by 2002:a17:903:fae:b0:2a0:867c:60e2 with SMTP id d9443c01a7336-2ae3b5554c6mr7299895ad.19.1772563880765;
        Tue, 03 Mar 2026 10:51:20 -0800 (PST)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5db596sm183363085ad.35.2026.03.03.10.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 10:51:20 -0800 (PST)
Date: Tue, 3 Mar 2026 18:51:16 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Ankit Soni <Ankit.Soni@amd.com>
Cc: David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, YiFei Zhu <zhuyifei@google.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, 
	Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Pranjal Shrivastava <praan@google.com>, 
	Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 11/14] iommufd-lu: Persist iommu hardware pagetables for
 live update
Message-ID: <n56v7llotm7jlkev4rsrm6l36vpzyufrx273ay5455hfauttzn@kn3oydrbhill>
References: <20260203220948.2176157-1-skhawaja@google.com>
 <20260203220948.2176157-12-skhawaja@google.com>
 <srgagoecgejftgvvqstjiwazi6blsljqyae3v5dlyj7nlv5lii@rjigll2eosuj>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <srgagoecgejftgvvqstjiwazi6blsljqyae3v5dlyj7nlv5lii@rjigll2eosuj>
X-Rspamd-Queue-Id: 8B2031F57D5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72561-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[skhawaja@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 05:56:15AM +0000, Ankit Soni wrote:
>Hi,
>
>On Tue, Feb 03, 2026 at 10:09:45PM +0000, Samiullah Khawaja wrote:
>> From: YiFei Zhu <zhuyifei@google.com>
>>
>> The caller is expected to mark each HWPT to be preserved with an ioctl
>> call, with a token that will be used in restore. At preserve time, each
>> HWPT's domain is then called with iommu_domain_preserve to preserve the
>> iommu domain.
>>
>> The HWPTs containing dma mappings backed by unpreserved memory should
>> not be preserved. During preservation check if the mappings contained in
>> the HWPT being preserved are only file based and all the files are
>> preserved.
>>
>> The memfd file preservation check is not enough when preserving iommufd.
>> The memfd might have shrunk between the mapping and memfd preservation.
>> This means that if it shrunk some pages that are right now pinned due to
>> iommu mappings are not preserved with the memfd. Only allow iommufd
>> preservation when all the iopt_pages are file backed and the memory file
>> was seal sealed during mapping. This guarantees that all the pages that
>> were backing memfd when it was mapped are preserved.
>>
>> Once HWPT is preserved the iopt associated with the HWPT is made
>> immutable. Since the map and unmap ioctls operates directly on iopt,
>> which contains an array of domains, while each hwpt contains only one
>> domain. The logic then becomes that mapping and unmapping is prohibited
>> if any of the domains in an iopt belongs to a preserved hwpt. However,
>> tracing to the hwpt through the domain is a lot more tedious than
>> tracing through the ioas, so if an hwpt is preserved, hwpt->ioas->iopt
>> is made immutable.
>>
>> When undoing this (making the iopts mutable again), there's never
>> a need to make some iopts mutable and some kept immutable, since
>> the undo only happen on unpreserve and error path of preserve.
>> Simply iterate all the ioas and clear the immutability flag on all
>> their iopts.
>>
>> Signed-off-by: YiFei Zhu <zhuyifei@google.com>
>> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
>> ---
>>  drivers/iommu/iommufd/io_pagetable.c    |  17 ++
>>  drivers/iommu/iommufd/io_pagetable.h    |   1 +
>>  drivers/iommu/iommufd/iommufd_private.h |  25 ++
>>  drivers/iommu/iommufd/liveupdate.c      | 300 ++++++++++++++++++++++++
>>  drivers/iommu/iommufd/main.c            |  14 +-
>>  drivers/iommu/iommufd/pages.c           |   8 +
>>  include/linux/kho/abi/iommufd.h         |  39 +++
>>  7 files changed, 403 insertions(+), 1 deletion(-)
>>  create mode 100644 include/linux/kho/abi/iommufd.h
>>
>> +
>> +static int iommufd_save_hwpts(struct iommufd_ctx *ictx,
>> +			      struct iommufd_lu *iommufd_lu,
>> +			      struct liveupdate_session *session)
>> +{
>> +	struct iommufd_hwpt_paging *hwpt, **hwpts = NULL;
>> +	struct iommu_domain_ser *domain_ser;
>> +	struct iommufd_hwpt_lu *hwpt_lu;
>> +	struct iommufd_object *obj;
>> +	unsigned int nr_hwpts = 0;
>> +	unsigned long index;
>> +	unsigned int i;
>> +	int rc = 0;
>> +
>> +	if (iommufd_lu) {
>> +		hwpts = kcalloc(iommufd_lu->nr_hwpts, sizeof(*hwpts),
>> +				GFP_KERNEL);
>> +		if (!hwpts)
>> +			return -ENOMEM;
>> +	}
>> +
>> +	xa_lock(&ictx->objects);
>> +	xa_for_each(&ictx->objects, index, obj) {
>> +		if (obj->type != IOMMUFD_OBJ_HWPT_PAGING)
>> +			continue;
>> +
>> +		hwpt = container_of(obj, struct iommufd_hwpt_paging, common.obj);
>> +		if (!hwpt->lu_preserve)
>> +			continue;
>> +
>> +		if (hwpt->ioas) {
>> +			/*
>> +			 * Obtain exclusive access to the IOAS and IOPT while we
>> +			 * set immutability
>> +			 */
>> +			mutex_lock(&hwpt->ioas->mutex);
>> +			down_write(&hwpt->ioas->iopt.domains_rwsem);
>> +			down_write(&hwpt->ioas->iopt.iova_rwsem);
>
>Taking mutex/rwsem under spin-lock is not a good idea.

Agreed. I will move this out by taking a reference on the object and
then setting it separately without xa_lock.
>
>> +
>> +			hwpt->ioas->iopt.lu_map_immutable = true;
>> +
>> +			up_write(&hwpt->ioas->iopt.iova_rwsem);
>> +			up_write(&hwpt->ioas->iopt.domains_rwsem);
>> +			mutex_unlock(&hwpt->ioas->mutex);
>> +		}
>> +
>> +		if (!hwpt->common.domain) {
>> +			rc = -EINVAL;
>> +			xa_unlock(&ictx->objects);
>> +			goto out;
>> +		}
>> +
>> +		if (!iommufd_lu) {
>> +			rc = check_iopt_pages_preserved(session, hwpt);
>> +			if (rc) {
>> +				xa_unlock(&ictx->objects);
>> +				goto out;
>> +			}
>> +		} else if (iommufd_lu) {
>
>Redundant else_if().

Will remove
>
>-Ankit
>
>> +			hwpts[nr_hwpts] = hwpt;
>> +			hwpt_lu = &iommufd_lu->hwpts[nr_hwpts];
>> +
>> +			hwpt_lu->token = hwpt->lu_token;
>> +			hwpt_lu->reclaimed = false;
>> +		}
>> +
>> +		nr_hwpts++;
>> +	}
>> +	xa_unlock(&ictx->objects);
>> +

Thanks for looking into this.

Sami

