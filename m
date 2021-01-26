Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8F4304379
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 17:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391403AbhAZQMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 11:12:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:1690 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403926AbhAZQFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 11:05:30 -0500
IronPort-SDR: /JfHikwDSfEdOacNyOqKHSUll4dt+N0iZvtJqVPWy9jPp6imrr3wu651wthQgh4rZwmy2qUn3T
 3eCx3SD5EfuQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="176413932"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="176413932"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 08:04:38 -0800
IronPort-SDR: syfrDdNL14eOwtMAhmqv70Yeyx20dYlltSmmu1ixHLNOv7NL0MnEXdBFSOXgsVi3EKeVfCi/O6
 QYsEB0VtLRXQ==
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="369146692"
Received: from ekfraser-mobl1.amr.corp.intel.com (HELO [10.209.173.94]) ([10.209.173.94])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 08:04:34 -0800
Subject: Re: [RFC PATCH v3 04/27] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
To:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
References: <cover.1611634586.git.kai.huang@intel.com>
 <d93adaec3d4371638f4ea2d9c6efb28e22eafcb3.1611634586.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <8250aedb-a623-646d-071a-75ece2c41c09@intel.com>
Date:   Tue, 26 Jan 2021 08:04:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d93adaec3d4371638f4ea2d9c6efb28e22eafcb3.1611634586.git.kai.huang@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/26/21 1:30 AM, Kai Huang wrote:
> From: Jarkko Sakkinen <jarkko@kernel.org>
> 
> Encapsulate the snippet in sgx_free_epc_page() concerning EREMOVE to
> sgx_reset_epc_page(), which is a static helper function for
> sgx_encl_release().  It's the only function existing, which deals with
> initialized pages.

Yikes.  I have no idea what that is saying.  Here's a rewrite:

EREMOVE takes a pages and removes any association between that page and
an enclave.  It must be run on a page before it can be added into
another enclave.  Currently, EREMOVE is run as part of pages being freed
into the SGX page allocator.  It is not expected to fail.

KVM does not track how guest pages are used, which means that SGX
virtualization use of EREMOVE might fail.

Break out the EREMOVE call from the SGX page allocator.  This will allow
the SGX virtualization code to use the allocator directly.  (SGX/KVM
will also introduce a more permissive EREMOVE helper).

> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index ee50a5010277..a78b71447771 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -389,6 +389,16 @@ const struct vm_operations_struct sgx_vm_ops = {
>  	.access = sgx_vma_access,
>  };
>  
> +
> +static void sgx_reset_epc_page(struct sgx_epc_page *epc_page)
> +{
> +	int ret;
> +
> +	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
> +	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
> +		return;
> +}
> +
>  /**
>   * sgx_encl_release - Destroy an enclave instance
>   * @kref:	address of a kref inside &sgx_encl
> @@ -412,6 +422,7 @@ void sgx_encl_release(struct kref *ref)
>  			if (sgx_unmark_page_reclaimable(entry->epc_page))
>  				continue;
>  
> +			sgx_reset_epc_page(entry->epc_page);
>  			sgx_free_epc_page(entry->epc_page);
>  			encl->secs_child_cnt--;
>  			entry->epc_page = NULL;
> @@ -423,6 +434,7 @@ void sgx_encl_release(struct kref *ref)
>  	xa_destroy(&encl->page_array);
>  
>  	if (!encl->secs_child_cnt && encl->secs.epc_page) {
> +		sgx_reset_epc_page(encl->secs.epc_page);
>  		sgx_free_epc_page(encl->secs.epc_page);
>  		encl->secs.epc_page = NULL;
>  	}
> @@ -431,6 +443,7 @@ void sgx_encl_release(struct kref *ref)
>  		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
>  					   list);
>  		list_del(&va_page->list);
> +		sgx_reset_epc_page(va_page->epc_page);
>  		sgx_free_epc_page(va_page->epc_page);
>  		kfree(va_page);
>  	}
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index f330abdb5bb1..21c2ffa13870 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -598,16 +598,14 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
>   * sgx_free_epc_page() - Free an EPC page
>   * @page:	an EPC page
>   *
> - * Call EREMOVE for an EPC page and insert it back to the list of free pages.
> + * Put the EPC page back to the list of free pages. It's the callers

"caller's"

> + * responsibility to make sure that the page is in uninitialized state In other

Period after "state", please.

> + * words, do EREMOVE, EWB or whatever operation is necessary before calling
> + * this function.
>   */

OK, so if you're going to say "the caller must put the page in
uninitialized state", let's also add a comment to the place that *DO*
that, like the shiny new sgx_reset_epc_page().
