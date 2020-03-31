Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFEB8199C61
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 19:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731177AbgCaRB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 13:01:59 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33667 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731159AbgCaRB6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 13:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585674117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/WHw8oOWDIxC8XeDcMhkyUwZZlaaYDSKPuWYoRppwiQ=;
        b=I9bOIOHDtGb36lRs8zNpnMUu8K9AEkNUWZsVKAQbcQDaKhyZar0bbtRKb2Gbp9w64gqG2F
        uf8gFpnlRPKfi2Ahalyf41YJpsDIhYc0kCDA9lJkfo4kxHkSaf8icSYaVFYeVnrhmbVuhd
        P+vKtTSEV4MwvVXZPEulivNtlSy3Zbs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-WDVO_Ke8O56NhYPjN7VThg-1; Tue, 31 Mar 2020 13:01:55 -0400
X-MC-Unique: WDVO_Ke8O56NhYPjN7VThg-1
Received: by mail-wr1-f71.google.com with SMTP id y1so12119613wrp.5
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 10:01:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/WHw8oOWDIxC8XeDcMhkyUwZZlaaYDSKPuWYoRppwiQ=;
        b=isxoeFXErCL2lP7jxp0n/MTELXnamawr/OUQQLeFH3+5natrxn0zoLgRVfCt5lF/XE
         Ep5jG85KArPASIfbaXoZ2O3HggS0vBGPoOS0j+zhpPbouQSdIeaQI1C66Zh13YtOHJ6f
         oMw1eohVyJ+l1Ll59ULMxAe7V4L7wZ8q8+JvRUl2HOLVkZtBpVdDKf9FOHZqC5LRV1y+
         JXtExWS17tgsaRZZmIMzer3IkXpHxKtDzeoH/dSDc40hOPcywmATVIwnoAB93nb7+aHw
         WNXEVlU24DdenQyIbEpQPzBuc+mUpMcJ041hsoKA9c++jybESFYe6pBMdLTrwiTirJKB
         0K4w==
X-Gm-Message-State: ANhLgQ15updoqq5pIsUuBLn0OMfnv6bTgN5DdzVpPbFZ1+aaxE2AdUxa
        HsXlq8xgCafTW3KVcZOsjJhHGnX0Mh4Wa2sAPGXkv+ET8WLhqPoDgCYg2T4w5kVHE7dTXKODFt8
        78IDGjMwZeTjc
X-Received: by 2002:a1c:196:: with SMTP id 144mr4541292wmb.100.1585674114157;
        Tue, 31 Mar 2020 10:01:54 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs2VpdbMVdp2kGL+7sxIGD6e9hplUqv6UigSkQa6rednfpCm+gJKqAe6WPEkvGMCaGk1pKMIA==
X-Received: by 2002:a1c:196:: with SMTP id 144mr4541265wmb.100.1585674113893;
        Tue, 31 Mar 2020 10:01:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b55d:5ed2:8a41:41ea? ([2001:b07:6468:f312:b55d:5ed2:8a41:41ea])
        by smtp.gmail.com with ESMTPSA id v129sm4618391wmg.1.2020.03.31.10.01.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 10:01:53 -0700 (PDT)
Subject: Re: [PATCH] x86: vmx: Fix "EPT violation - paging structure" test
To:     Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org
References: <20200321050555.4212-1-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0f65fdd9-414e-befc-0043-2b199f5755c1@redhat.com>
Date:   Tue, 31 Mar 2020 19:01:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200321050555.4212-1-namit@vmware.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/03/20 06:05, Nadav Amit wrote:
> Running the tests with more than 4GB of memory results in the following
> failure:
> 
>   FAIL: EPT violation - paging structure
> 
> It appears that the test mistakenly used get_ept_pte() to retrieve the
> guest PTE, but this function is intended for accessing EPT and not the
> guest page tables. Use get_pte_level() instead of get_ept_pte().
> 
> Tested on bare-metal only.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  x86/vmx_tests.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index be5c952..1f97fe3 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -1312,12 +1312,14 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
>  	u64 guest_cr3;
>  	u32 insn_len;
>  	u32 exit_qual;
> -	static unsigned long data_page1_pte, data_page1_pte_pte, memaddr_pte;
> +	static unsigned long data_page1_pte, data_page1_pte_pte, memaddr_pte,
> +			     guest_pte_addr;
>  
>  	guest_rip = vmcs_read(GUEST_RIP);
>  	guest_cr3 = vmcs_read(GUEST_CR3);
>  	insn_len = vmcs_read(EXI_INST_LEN);
>  	exit_qual = vmcs_read(EXI_QUALIFICATION);
> +	pteval_t *ptep;
>  	switch (exit_reason.basic) {
>  	case VMX_VMCALL:
>  		switch (vmx_get_test_stage()) {
> @@ -1364,12 +1366,11 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
>  			ept_sync(INVEPT_SINGLE, eptp);
>  			break;
>  		case 4:
> -			TEST_ASSERT(get_ept_pte(pml4, (unsigned long)data_page1,
> -						2, &data_page1_pte));
> -			data_page1_pte &= PAGE_MASK;
> -			TEST_ASSERT(get_ept_pte(pml4, data_page1_pte,
> -						2, &data_page1_pte_pte));
> -			set_ept_pte(pml4, data_page1_pte, 2,
> +			ptep = get_pte_level((pgd_t *)guest_cr3, data_page1, /*level=*/2);
> +			guest_pte_addr = virt_to_phys(ptep) & PAGE_MASK;
> +
> +			TEST_ASSERT(get_ept_pte(pml4, guest_pte_addr, 2, &data_page1_pte_pte));
> +			set_ept_pte(pml4, guest_pte_addr, 2,
>  				data_page1_pte_pte & ~EPT_PRESENT);
>  			ept_sync(INVEPT_SINGLE, eptp);
>  			break;
> @@ -1437,7 +1438,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
>  					  (have_ad ? EPT_VLT_WR : 0) |
>  					  EPT_VLT_LADDR_VLD))
>  				vmx_inc_test_stage();
> -			set_ept_pte(pml4, data_page1_pte, 2,
> +			set_ept_pte(pml4, guest_pte_addr, 2,
>  				data_page1_pte_pte | (EPT_PRESENT));
>  			ept_sync(INVEPT_SINGLE, eptp);
>  			break;
> 

Queued, thanks.

Paolo

