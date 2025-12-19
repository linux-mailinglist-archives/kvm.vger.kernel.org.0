Return-Path: <kvm+bounces-66320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 955C8CCF93E
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 12:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7194C300EFF4
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 11:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84AC6317715;
	Fri, 19 Dec 2025 11:32:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BBB318120;
	Fri, 19 Dec 2025 11:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766143978; cv=none; b=CiuPtEf2byrKzwMz02Wp7u3p9Fo0uH3fncTT7Yo64IbaPeWPySzDNx8kOT/oXwFiNV14xPVBsCuT2HIxHP4NFSw6QUkv6SD5ZPPSXSISG6LT7i1/S7ComisGD1mqH2UT3zOaeP+N0a1ACV2tutSz6hot3R9CgjjaN7DlZ+02WFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766143978; c=relaxed/simple;
	bh=zsGtn4YBzXG1VfglMkgDfgLaf4t1KSCz+999jmvI7B0=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y6B/o16o8MUrUlpiSSwhb42dHRO99Izs7yo+hiS1B+mNMYDzeDE0JSk7sbLG08vvaR+18AbvJep6RRBtDo7PyrsWwshzZJ3z//rZxrSuYQ8muvzNRBtl6OycKYVXDNGCqdBdS8NfxzcsezqWsNFBmpUSxR9R37Zk05ZEJKWnR6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dXlkW0YQ1zJ46C5;
	Fri, 19 Dec 2025 19:32:19 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 957F440539;
	Fri, 19 Dec 2025 19:32:51 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 19 Dec
 2025 11:32:50 +0000
Date: Fri, 19 Dec 2025 11:32:49 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-pci@vger.kernel.org>,
	<chao.gao@intel.com>, <dave.jiang@intel.com>, <baolu.lu@linux.intel.com>,
	<yilun.xu@intel.com>, <zhenzhong.duan@intel.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@linux.intel.com>,
	<dan.j.williams@intel.com>, <kas@kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v1 06/26] x86/virt/tdx: Add tdx_page_array helpers for
 new TDX Module objects
Message-ID: <20251219113249.000040b1@huawei.com>
In-Reply-To: <20251117022311.2443900-7-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
	<20251117022311.2443900-7-yilun.xu@linux.intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Mon, 17 Nov 2025 10:22:50 +0800
Xu Yilun <yilun.xu@linux.intel.com> wrote:

> Add struct tdx_page_array definition for new TDX Module object
> types - HPA_ARRAY_T and HPA_LIST_INFO. They are used as input/output
> parameters in newly defined SEAMCALLs. Also define some helpers to
> allocate, setup and free tdx_page_array.
> 
> HPA_ARRAY_T and HPA_LIST_INFO are similar in most aspects. They both
> represent a list of pages for TDX Module accessing. There are several
> use cases for these 2 structures:
> 
>  - As SEAMCALL inputs. They are claimed by TDX Module as control pages.
>  - As SEAMCALL outputs. They were TDX Module control pages and now are
>    released.
>  - As SEAMCALL inputs. They are just temporary buffers for exchanging
>    data blobs in one SEAMCALL. TDX Module will not hold them as control
>    pages.
> 
> The 2 structures both need a 'root page' which contains a list of HPAs.
> They collapse the HPA of the root page and the number of valid HPAs
> into a 64 bit raw value for SEAMCALL parameters. The root page is
> always a medium for passing data pages, TDX Module never keeps the root
> page.
> 
> A main difference is HPA_ARRAY_T requires singleton mode when
> containing just 1 functional page (page0). In this mode the root page is
> not needed and the HPA field of the raw value directly points to the
> page0. But in this patch, root page is always allocated for user
> friendly kAPIs.
> 
> Another small difference is HPA_LIST_INFO contains a 'first entry' field
> which could be filled by TDX Module. This simplifies host by providing
> the same structure when re-invoke the interrupted SEAMCALL. No need for
> host to touch this field.
> 
> Typical usages of the tdx_page_array:
> 
> 1. Add control pages:
>  - struct tdx_page_array *array = tdx_page_array_create(nr_pages);
>  - seamcall(TDH_XXX_CREATE, array, ...);
> 
> 2. Release control pages:
>  - seamcall(TDX_XXX_DELETE, array, &nr_released, &released_hpa);
>  - tdx_page_array_ctrl_release(array, nr_released, released_hpa);
> 
> 3. Exchange data blobs:
>  - struct tdx_page_array *array = tdx_page_array_create(nr_pages);
>  - seamcall(TDX_XXX, array, ...);
>  - Read data from array.
>  - tdx_page_array_free(array);
> 
> 4. Note the root page contains 512 HPAs at most, if more pages are
>    required, refilling the tdx_page_array is needed.
> 
>  - struct tdx_page_array *array = tdx_page_array_alloc(nr_pages);
>  - for each 512-page bulk
>    - tdx_page_array_fill_root(array, offset);
>    - seamcall(TDH_XXX_ADD, array, ...);
> 
> In case 2, SEAMCALLs output the released page array in the form of
> HPA_ARRAY_T or PAGE_LIST_INFO. tdx_page_array_ctrl_release() is
> responsible for checking if the output pages match the original input
> pages. If failed to match, the safer way is to leak the control pages,
> tdx_page_array_ctrl_leak() should be called.
> 
> The usage of tdx_page_array will be in following patches.
> 
> Co-developed-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

One trivial comment below. I'm not going to look into tdx specifics
enough to do a detailed review of this patch.

> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 09c766e60962..9a5c32dc1767 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c

> +static bool tdx_page_array_validate_release(struct tdx_page_array *array,
> +					    unsigned int offset,
> +					    unsigned int nr_released,
> +					    u64 released_hpa)
> +{
> +	unsigned int nents;
> +	u64 *entries;
> +	int i;
> +
> +	if (offset >= array->nr_pages)
> +		return false;
> +
> +	nents = umin(array->nr_pages - offset, TDX_PAGE_ARRAY_MAX_NENTS);
> +
> +	if (nents != nr_released) {
> +		pr_err("%s nr_released [%d] doesn't match page array nents [%d]\n",
> +		       __func__, nr_released, nents);
> +		return false;
> +	}
> +
> +	/*
> +	 * Unfortunately TDX has multiple page allocation protocols, check the
> +	 * "singleton" case required for HPA_ARRAY_T.
> +	 */
> +	if (page_to_phys(array->pages[0]) == released_hpa &&
> +	    array->nr_pages == 1)
> +		return true;
> +
> +	/* Then check the "non-singleton" case */
> +	if (page_to_phys(array->root) == released_hpa) {
> +		entries = (u64 *)page_address(array->root);

page_address() returns a void * so the cast here isn't needed and (to me
at least) doesn't add value from readability point of view.

I haven't checked later patches, but if this code doesn't change to use
entries outside this scope then,
		u64 *entries = page_address(array->root);
would be nice to restrict the scope and make the type here immediately
visible.

> +		for (i = 0; i < nents; i++) {
> +			struct page *page = array->pages[offset + i];
> +			u64 val = page_to_phys(page);
> +
> +			if (val != entries[i]) {
> +				pr_err("%s entry[%d] [0x%llx] doesn't match page hpa [0x%llx]\n",
> +				       __func__, i, entries[i], val);
> +				return false;
> +			}
> +		}
> +
> +		return true;
> +	}
> +
> +	pr_err("%s failed to validate, released_hpa [0x%llx], root page hpa [0x%llx], page0 hpa [%#llx], number pages %u\n",
> +	       __func__, released_hpa, page_to_phys(array->root),
> +	       page_to_phys(array->pages[0]), array->nr_pages);
> +
> +	return false;
> +}


