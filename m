Return-Path: <kvm+bounces-61936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A55BC2F05A
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 03:49:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F92518841DF
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 02:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7500F25F98B;
	Tue,  4 Nov 2025 02:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E4bWQ1iW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88914225760;
	Tue,  4 Nov 2025 02:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762224573; cv=none; b=ha8oqe2PODNmn1nA4YJ6c7WhQTGObXMUeZw2Z/agLX16Up9donniojhPCYqc26Xb+ooDdqLHIr17Ou7Zpy21iwK/qGI38g0PaOcn7PEXIkP74wnEl8Rc4/qpsqYA5PwoUA1t1Aoa2AJbAJOJqpITSo5LflpbZAbM3wvfcZ8/ITw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762224573; c=relaxed/simple;
	bh=pmS6+6nbTBZg9Sai36VoJ0kR5C4vAImQr4aXsiuJMfg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=VEcCbGj5pBQ9tFF+wWb5RU204XUGOWh2dGPufDWHU7a6q4lnPXBtQxIj6t/ulC/M265Mv7znZ10EkdZuF1Lsv5fSsGJSehcbcNxnFHkVla7eLqtUKuQI1Et87kq3lfEm7JXM7Rk2sKwPDsGIe2NIm5fZ2rMxzSfXZg9oRcdnza4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E4bWQ1iW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C63C4CEFD;
	Tue,  4 Nov 2025 02:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762224573;
	bh=pmS6+6nbTBZg9Sai36VoJ0kR5C4vAImQr4aXsiuJMfg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=E4bWQ1iWrF2MTS5TlMy71BcsCjBBiB4zv35Huf2oBjnnV4AKlELWYwFgF+4XHEHBQ
	 X9DB5Nh6+7hxZK3QvZ5cRZgZ2yYhrBac8xcfiuP58LFnzMZAigjWZxenfMdKdCjsaA
	 wh/U3UkzpxyO+7QcmVE1dT9KmfK3NR40orjT58io=
Date: Mon, 3 Nov 2025 18:49:31 -0800
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
Subject: Re: [PATCH v5 2/3] mm: handle poisoning of pfn without struct pages
Message-Id: <20251103184931.5a8e0be8f959ba2a0b6b814b@linux-foundation.org>
In-Reply-To: <20251102184434.2406-3-ankita@nvidia.com>
References: <20251102184434.2406-1-ankita@nvidia.com>
	<20251102184434.2406-3-ankita@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 2 Nov 2025 18:44:33 +0000 <ankita@nvidia.com> wrote:

> diff --git a/include/linux/memory-failure.h b/include/linux/memory-failure.h
> new file mode 100644

OK.  I assume there is a bunch of memory-failure material which can now
be moved into the new memory-failure.h.

