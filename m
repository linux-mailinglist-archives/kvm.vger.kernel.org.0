Return-Path: <kvm+bounces-72559-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gEcFM2wrp2nSfAAAu9opvQ
	(envelope-from <kvm+bounces-72559-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 19:41:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 461BB1F568A
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 19:41:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C1F3730234EF
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 18:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88EAC494A13;
	Tue,  3 Mar 2026 18:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DZ1X/22M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A3D47ECED
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 18:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772563293; cv=none; b=k6IJP4KbvDWkFyJ5GSZ7n2m5Ny7TNv5ptZRijWau5exdT4VPQ5JVkp2Moav8RY1RI1cgv9yzJEUAIG5cTAU6GQi3giHpKxfGv0o0H/3yKy60pMwWGulTY06w8swblccHzWrTeWiYxjhUoTUqoRPXMAmdyKWGk9gFZvan2/fP8Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772563293; c=relaxed/simple;
	bh=AOQWvUqJv4lNcUO8YIDTbhsNhv0Q3kF0idwcy68u+oU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NIq5H9+6smUJLdryzoH1AYidhTmcEU38WhubNitlZTWcof/RLg5MMVWQEq6HBugwcO1mYYbaGnbw4HQoinJiaQPIzqdfJ/FTxAXSn/8uFl9OVasn7S7hFF3q10+U2KCwbkSDQqmZlo5znlNY4DgRMhf1uOEK96fXzDEKYuyBxp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DZ1X/22M; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ae3f822163so92995ad.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 10:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772563291; x=1773168091; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u30Jc93NSo6jjaBUVn4MMoIkiqIVphQIkXw+rRzsOT0=;
        b=DZ1X/22MJkNAI2sIPsSIy78fjwKbyhplxV1Ou1Ee5llgT7U4xwQT/6wFFGupZv19Hm
         ZL1p6sUHXRQgIAxq82tpXN9i8m7W/ZFXTWZI9oHo+FXn78Z6PRQ6PpgU9RBjfPJJwtJw
         Li1akmLuv2AI7riUlR6aSgzlrBZlxHXHIkotENnzxwiyrRMJ9h9hd4Xp8t3pLhLCp+dr
         muNbUm2ukftA0wi/MTDybRz1cAP6OEZYNhTxjIPmg7VofNIR2gK005IWOXjSfbvDyhUV
         ac5oZ1xS8T34m+ZLA0Rbq6pEIK67bU3BwvVnS7o4LJCzsoNeL9ZgIrF3jSswPmQjZrDE
         w1Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772563291; x=1773168091;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u30Jc93NSo6jjaBUVn4MMoIkiqIVphQIkXw+rRzsOT0=;
        b=c9jJ1SJzpzUt6FmyEowoOLYa5udg9vyRIXTfkm71LdlcRoUSNuKMbJmgzZp7tFbrJW
         Hm6LFZe4o1YiUKi1TMCRIVkPkAK/NcpJMiWD4KIEfgX90vbs1YoFDFnp2M4XqtPWpPEW
         Rq0Dn9EcchrNw+0JGPBa8bhjGlWcyOu7RRI7nInq3zc+KBtxXS365epyCaG6iICDpRZc
         kJtGWh/oQEjY3ZxQnqU8cLr3Wrz1XYiipvgYT9Obyv/e8KcK5FccuqIJ6DB2aoWQ1akt
         rRUzd8J3UVBSn1aRhEs29TGf1AlmDtGIE921E3wxdhbKrf4L9H7OS0UOTmLKS5hNRrLr
         BD1A==
X-Forwarded-Encrypted: i=1; AJvYcCX4l7Hsm7UQqPnnqNtDkMdRdFmYO0QgoYtdpeacnyg0O2IHL2dhjOn6jY/6HfbeV4EGfII=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh1g2O9Jy07IWHVgSsgG4Rz2tVlb3zv6P5NFb3wyloM1CEHdUP
	DO1GjPHKISbVxQXdpOg92UybBfPeyVyQTqdqy4n3K1JkO6IvT0UtXw9TKeg59SO9tQ==
X-Gm-Gg: ATEYQzximYDlQY7a5njBrdSy+6s6DSLJCcEPiMOxXdMpim+pt+gNuEq+GNmuw8wtIAp
	6iKZU95c7RTsJCATqDsjIQhiaywp2VELxXWmf8RGKFDzTnSJvnZv6oDmzFr7vpJDhKNqMD5Mlvl
	3cbdMIy1dyEgnGFNdhRw5fnJsqN8uLE03gBUYtOwKtQfmGa1WxV+i+FrP8Fuh4V+WelnGtSLxN/
	b/UxSLLPozw4P3ShTZDiZBcCOBncklCE0J6G0GNgN6CbChGJsNMXwoCdjcwWqElJM590UeeWh6C
	CysGfrdLCAO1I3gMt4i/88bQq4YBiuz3eG7iGz4t924LHxnSPfGJmZewyHzwXXGM/pQxx0ww4PW
	a/3LiqR6w3OsKcd3B6xgLS21010QgKuN2FELdsQqaJwuLvfYViLLSMPVWzS5FIG+nZBj1FgcOc4
	cqajSAwMqLo5OJ8Q4pqfLzSB2YBKAP+vK1vb/Vo0KWKoXLVyCoOlGoLsXzUDRk0A==
X-Received: by 2002:a17:902:e847:b0:2ae:4808:bd99 with SMTP id d9443c01a7336-2ae4808bec6mr6306545ad.2.1772563290740;
        Tue, 03 Mar 2026 10:41:30 -0800 (PST)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3599c4e2f85sm3486410a91.17.2026.03.03.10.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 10:41:30 -0800 (PST)
Date: Tue, 3 Mar 2026 18:41:26 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Ankit Soni <Ankit.Soni@amd.com>
Cc: David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>, 
	Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>, 
	Shuah Khan <shuah@kernel.org>, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Pranjal Shrivastava <praan@google.com>, 
	Vipin Sharma <vipinsh@google.com>, YiFei Zhu <zhuyifei@google.com>
Subject: Re: [PATCH 04/14] iommu/pages: Add APIs to
 preserve/unpreserve/restore iommu pages
Message-ID: <af4h6wh75qdvgu27td43ndlxdyb5drq2pf7tssdsln3q5gce6f@6su7ylrgomhz>
References: <20260203220948.2176157-1-skhawaja@google.com>
 <20260203220948.2176157-5-skhawaja@google.com>
 <d3wmnc43r3mir2emoitj432j3bfdw362dqmkvywa2qvu5tskb4@oqjkseil5i54>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d3wmnc43r3mir2emoitj432j3bfdw362dqmkvywa2qvu5tskb4@oqjkseil5i54>
X-Rspamd-Queue-Id: 461BB1F568A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72559-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[skhawaja@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 04:42:02PM +0000, Ankit Soni wrote:
>On Tue, Feb 03, 2026 at 10:09:38PM +0000, Samiullah Khawaja wrote:
>> IOMMU pages are allocated/freed using APIs using struct ioptdesc. For
>> the proper preservation and restoration of ioptdesc add helper
>> functions.
>>
>> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
>> ---
>>  drivers/iommu/iommu-pages.c | 74 +++++++++++++++++++++++++++++++++++++
>>  drivers/iommu/iommu-pages.h | 30 +++++++++++++++
>>  2 files changed, 104 insertions(+)
>>
>> diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
>> index 3bab175d8557..588a8f19b196 100644
>> --- a/drivers/iommu/iommu-pages.c
>> +++ b/drivers/iommu/iommu-pages.c
>> @@ -6,6 +6,7 @@
>>  #include "iommu-pages.h"
>>  #include <linux/dma-mapping.h>
>>  #include <linux/gfp.h>
>> +#include <linux/kexec_handover.h>
>>  #include <linux/mm.h>
>>
>>  #define IOPTDESC_MATCH(pg_elm, elm)                    \
>> @@ -131,6 +132,79 @@ void iommu_put_pages_list(struct iommu_pages_list *list)
>>  }
>>  EXPORT_SYMBOL_GPL(iommu_put_pages_list);
>>
>> +#if IS_ENABLED(CONFIG_IOMMU_LIVEUPDATE)
>> +void iommu_unpreserve_page(void *virt)
>> +{
>> +	kho_unpreserve_folio(ioptdesc_folio(virt_to_ioptdesc(virt)));
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_unpreserve_page);
>> +
>> +int iommu_preserve_page(void *virt)
>> +{
>> +	return kho_preserve_folio(ioptdesc_folio(virt_to_ioptdesc(virt)));
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_preserve_page);
>> +
>> +void iommu_unpreserve_pages(struct iommu_pages_list *list, int count)
>> +{
>> +	struct ioptdesc *iopt;
>> +
>> +	if (!count)
>> +		return;
>> +
>> +	/* If less than zero then unpreserve all pages. */
>> +	if (count < 0)
>> +		count = 0;
>> +
>> +	list_for_each_entry(iopt, &list->pages, iopt_freelist_elm) {
>> +		kho_unpreserve_folio(ioptdesc_folio(iopt));
>> +		if (count > 0 && --count ==  0)
>> +			break;
>> +	}
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_unpreserve_pages);
>> +
>> +void iommu_restore_page(u64 phys)
>> +{
>> +	struct ioptdesc *iopt;
>> +	struct folio *folio;
>> +	unsigned long pgcnt;
>> +	unsigned int order;
>> +
>> +	folio = kho_restore_folio(phys);
>> +	BUG_ON(!folio);
>> +
>> +	iopt = folio_ioptdesc(folio);
>
>iopt->incoherent = false; should be here?
>

Yes this should be set here. I will update this.
>> +
>> +	order = folio_order(folio);
>> +	pgcnt = 1UL << order;
>> +	mod_node_page_state(folio_pgdat(folio), NR_IOMMU_PAGES, pgcnt);
>> +	lruvec_stat_mod_folio(folio, NR_SECONDARY_PAGETABLE, pgcnt);
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_restore_page);
>> +
>> +int iommu_preserve_pages(struct iommu_pages_list *list)
>> +{
>> +	struct ioptdesc *iopt;
>> +	int count = 0;
>> +	int ret;
>> +
>> +	list_for_each_entry(iopt, &list->pages, iopt_freelist_elm) {
>> +		ret = kho_preserve_folio(ioptdesc_folio(iopt));
>> +		if (ret) {
>> +			iommu_unpreserve_pages(list, count);
>> +			return ret;
>> +		}
>> +
>> +		++count;
>> +	}
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_preserve_pages);
>> +
>> +#endif
>> +
>>  /**
>>   * iommu_pages_start_incoherent - Setup the page for cache incoherent operation
>>   * @virt: The page to setup
>> diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
>> index ae9da4f571f6..bd336fb56b5f 100644
>> --- a/drivers/iommu/iommu-pages.h
>> +++ b/drivers/iommu/iommu-pages.h
>> @@ -53,6 +53,36 @@ void *iommu_alloc_pages_node_sz(int nid, gfp_t gfp, size_t size);
>>  void iommu_free_pages(void *virt);
>>  void iommu_put_pages_list(struct iommu_pages_list *list);
>>
>> +#if IS_ENABLED(CONFIG_IOMMU_LIVEUPDATE)
>> +int iommu_preserve_page(void *virt);
>> +void iommu_unpreserve_page(void *virt);
>> +int iommu_preserve_pages(struct iommu_pages_list *list);
>> +void iommu_unpreserve_pages(struct iommu_pages_list *list, int count);
>> +void iommu_restore_page(u64 phys);
>> +#else
>> +static inline int iommu_preserve_page(void *virt)
>> +{
>> +	return -EOPNOTSUPP;
>> +}
>> +
>> +static inline void iommu_unpreserve_page(void *virt)
>> +{
>> +}
>> +
>> +static inline int iommu_preserve_pages(struct iommu_pages_list *list)
>> +{
>> +	return -EOPNOTSUPP;
>> +}
>> +
>> +static inline void iommu_unpreserve_pages(struct iommu_pages_list *list, int count)
>> +{
>> +}
>> +
>> +static inline void iommu_restore_page(u64 phys)
>> +{
>> +}
>> +#endif
>> +
>>  /**
>>   * iommu_pages_list_add - add the page to a iommu_pages_list
>>   * @list: List to add the page to
>> --
>> 2.53.0.rc2.204.g2597b5adb4-goog
>>

Sami

