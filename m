Return-Path: <kvm+bounces-61935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1885CC2F04E
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 03:48:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 347E34E438D
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 02:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CF1025B1FF;
	Tue,  4 Nov 2025 02:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ulXY+Dx0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317561D554;
	Tue,  4 Nov 2025 02:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762224464; cv=none; b=T+Gp/EcXrY0WuW4inkxJQOjH3DxreNYvCw9Ki7HuCsY3SQzZ2ampfrUdgpMmAXpa2bB9JVa/qeNBojC0QAKd8dg2j2FV1aUg3gr8a9JRsD5fI/ym9EhdoOz5vlTfi5RwlN/xNAD/vmiBC53rC/074/CIQ28lvojp26teHGJkrLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762224464; c=relaxed/simple;
	bh=Aq0A4s+Uy/ELDjmPRsdvDGJIZkiNPNcjd+vWWv0awuo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=f5NzeLt30b9DmpbfAkQHQh/RkXirr5dI4GuE3fANYOVAo85loc6vRVI6LGljsapRrUbeOqjNXBzgOX2vXQuHDRl59eigOgD8Dao9mJ+7WF4T2Us2fRKHn7iVwSklKLY+rchyhvQW5osAVvvOP3iFjrkH13nd0pORdmzUEhF2nlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ulXY+Dx0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB6DC4CEE7;
	Tue,  4 Nov 2025 02:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762224463;
	bh=Aq0A4s+Uy/ELDjmPRsdvDGJIZkiNPNcjd+vWWv0awuo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ulXY+Dx074aqU438BK/rGe0ov/CSzMgaQbm+CTcEmwZDGUg+PqhGSMSrkIzjumw/E
	 66czt4Xn8IpTygJ7r0A3dM0xxQIoI7FepogiQXjQ882RimY4Z/ZtvC1aiY1jOsZYsO
	 +Kpfaz7P8mz13jPg4WStd2QCIDp+e3Yw+NyesBfw=
Date: Mon, 3 Nov 2025 18:47:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: <ankita@nvidia.com>
Cc: <aniketa@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
 <mochs@nvidia.com>, <skolothumtho@nvidia.com>, <linmiaohe@huawei.com>,
 <nao.horiguchi@gmail.com>, <david@redhat.com>,
 <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
 <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
 <guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
 <kevin.tian@intel.com>, <alex@shazbot.org>, <cjia@nvidia.com>,
 <kwankhede@nvidia.com>, <targupta@nvidia.com>, <zhiw@nvidia.com>,
 <dnigam@nvidia.com>, <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-edac@vger.kernel.org>,
 <Jonathan.Cameron@huawei.com>, <ira.weiny@intel.com>,
 <Smita.KoralahalliChannabasappa@amd.com>, <u.kleine-koenig@baylibre.com>,
 <peterz@infradead.org>, <linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 0/3] mm: Implement ECC handling for pfn with no
 struct page
Message-Id: <20251103184742.441e98e93c5ed36320c4f41a@linux-foundation.org>
In-Reply-To: <20251102184434.2406-1-ankita@nvidia.com>
References: <20251102184434.2406-1-ankita@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 2 Nov 2025 18:44:31 +0000 <ankita@nvidia.com> wrote:

> Poison (or ECC) errors can be very common on a large size cluster.
> The kernel MM currently handles ECC errors / poison only on memory page
> backed by struct page. The handling is currently missing for the PFNMAP
> memory that does not have struct pages. The series adds such support.
> 
> Implement a new ECC handling for memory without struct pages. Kernel MM
> expose registration APIs to allow modules that are managing the device
> to register its device memory region. MM then tracks such regions using
> interval tree.

Thanks.  My knowledge of this material is weaker than usual :( But the
series looks good to my eye so I'll toss it into mm.git's mm-new branch
for some testing exposure.  If that goes OK then I'll later move it
into the mm-unstable branch where it will get linux-next esposure.  At
that point I'll monitor reviewer and tester feedback (please).



