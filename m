Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E2D5F6D3B
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 19:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbiJFRsf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 13:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJFRse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 13:48:34 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A341EC1D8A
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 10:48:29 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d10so2710913pfh.6
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 10:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c4h/StqWma673GjgxtCmSoM47qdbFDg3VL6SuKsQ6BE=;
        b=nhO2hUX/eRPyjJJ2HXBkgKUYrt6o8hp+EfcVVdgjDno+AFQlY0DoDARKO+EYWmX+7k
         A0V79SZNf8sMdBjzEeWEhkK9RRiKP+Ub1EFL/3Un4kQ3esMq5O6uRjdbUspq553SCzH0
         IfJ1xU4nLfWm3I6t2YfB8wxRqXQ8Hld5eCSxGTnV/SrKEyACusLCZMc1YiUD007zKFvn
         wQY0YDs/y9rLegtmjM22+P5DpoxzEBRfX+1Zme/qPfe4lXcREKflD1Kc2FitCHX5SX1Q
         djSFwKVst7GBDcDl4jX35En0B+k3GyF9OzrEVDqXo5c44SXGpvK+RUPfTBMSRnx/rje5
         KWtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c4h/StqWma673GjgxtCmSoM47qdbFDg3VL6SuKsQ6BE=;
        b=utrI3OYcURUNPQaAIPIlP0mohc1kDeRwiMYhx/NQMA2mkeLueCpCVtOAlhgeHzX+P4
         Sz22jiD/HxsfQB7htsS76ODjQorznXaisYNReKzF5OY0lVjZjFtOh3wL9WNNNZiz0k57
         pEnOZRDw/IVCvOBEp+pjnapSfYY5vFtXOoF/1Yzd5B2JT+ujEhasxp/AvA/ZER5fWhDf
         GZmDG62IdoF6qb79zQmgYt3alH7AzKjhzZcb6xrbyJEMJC6Baj50KqtGbn5L7ukalBhc
         YF+aMV/EUYElVxJf8ANlXM2eMjs8DVvaXGwOxONBF0jDpI7ndVbnAt1KYnMEI4x8YoWL
         wS5A==
X-Gm-Message-State: ACrzQf0JQKAZZQaO2OpaBRnH80ZolUybT5CCxVeyl9FVmmzUoFnod3tk
        gN94NuXxT0A7w0Tkj0kcxZtJ1w==
X-Google-Smtp-Source: AMsMyM53eLmj+ROQjPtJ1EtlC79usM+RuinHeOPjwZwNnkfUpb5jNbiPyOkiT+PAqZgAlopX3E+ewA==
X-Received: by 2002:a05:6a00:1884:b0:562:6536:4844 with SMTP id x4-20020a056a00188400b0056265364844mr844500pfh.2.1665078508939;
        Thu, 06 Oct 2022 10:48:28 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y37-20020a634965000000b0041c30def5e8sm28635pgk.33.2022.10.06.10.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 10:48:18 -0700 (PDT)
Date:   Thu, 6 Oct 2022 17:48:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev
Subject: Re: [V4 3/8] KVM: selftests: add hooks for managing encrypted guest
 memory
Message-ID: <Yz8U2k7Tu8QQNhhq@google.com>
References: <20220829171021.701198-1-pgonda@google.com>
 <20220829171021.701198-4-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829171021.701198-4-pgonda@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 29, 2022, Peter Gonda wrote:
> +static vm_paddr_t
> +_vm_phy_pages_alloc(struct kvm_vm *vm, size_t num, vm_paddr_t paddr_min,

Do not wrap before the function name.  Linus has a nice explanation/rant on this[*].
Note to self, add a Vim macro for this...

[*] https://lore.kernel.org/all/CAHk-=wjoLAYG446ZNHfg=GhjSY6nFmuB_wA8fYd5iLBNXjo9Bw@mail.gmail.com

> +		    uint32_t memslot, bool encrypt)
>  {
>  	struct userspace_mem_region *region;
>  	sparsebit_idx_t pg, base;
> @@ -1152,12 +1156,22 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
>  		abort();
>  	}
>  
> -	for (pg = base; pg < base + num; ++pg)
> +	for (pg = base; pg < base + num; ++pg) {
>  		sparsebit_clear(region->unused_phy_pages, pg);
> +		if (encrypt)

prefer s/encrypt/private, and s/encrypted_phy_pages/private_phy_pages.  pKVM
doesn't rely on encryption, and it's not impossible that x86 will someday gain
similar functionality.  And "encrypted" is also technically wrong for SEV and TDX,
as shared memory can also be encrypted with a common key.

> +			sparsebit_set(region->encrypted_phy_pages, pg);
> +	}
>  
>  	return base * vm->page_size;
>  }
>  
> +vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> +			      vm_paddr_t paddr_min, uint32_t memslot)
> +{
> +	return _vm_phy_pages_alloc(vm, num, paddr_min, memslot,
> +				   vm->memcrypt.enc_by_default);

enc_by_default yields a bizarre API.  The behavior depends on whether or not the
VM is protected, and whether or not the VM wants to protect memory by default.

For simplicity, IMO vm_phy_pages_alloc() should allocate memory as private if the
VM supports protected memory, i.e. just have vm->protected or whatever and use
that here.

> +}
> +
>  vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
>  			     uint32_t memslot)
>  {
> @@ -1741,6 +1755,10 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
>  			region->host_mem);
>  		fprintf(stream, "%*sunused_phy_pages: ", indent + 2, "");
>  		sparsebit_dump(stream, region->unused_phy_pages, 0);
> +		if (vm->memcrypt.enabled) {

vm->protected

> +			fprintf(stream, "%*sencrypted_phy_pages: ", indent + 2, "");
> +			sparsebit_dump(stream, region->encrypted_phy_pages, 0);
> +		}
>  	}
>  	fprintf(stream, "%*sMapped Virtual Pages:\n", indent, "");
>  	sparsebit_dump(stream, vm->vpages_mapped, indent + 2);
> @@ -1989,3 +2007,31 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
>  		break;
>  	}
>  }
> +
> +void vm_set_memory_encryption(struct kvm_vm *vm, bool enc_by_default, bool has_enc_bit,
> +			      uint8_t enc_bit)
> +{
> +	vm->memcrypt.enabled = true;
> +	vm->memcrypt.enc_by_default = enc_by_default;
> +	vm->memcrypt.has_enc_bit = has_enc_bit;
> +	vm->memcrypt.enc_bit = enc_bit;
> +}
> +
> +const struct sparsebit *
> +vm_get_encrypted_phy_pages(struct kvm_vm *vm, int slot, vm_paddr_t *gpa_start,
> +			   uint64_t *size)

Bad wrap.

> +{
> +	struct userspace_mem_region *region;
> +
> +	if (!vm->memcrypt.enabled)

This seems rather silly, why not TEST_ASSERT()?

> +		return NULL;
> +
> +	region = memslot2region(vm, slot);
> +	if (!region)

Same here, TEST_ASSERT() seems more appropriate.

Actually, I can't envision a use outside of SEV.  AFAIK, no other architecture
does the whole "launch update" thing.  I.e. just open code this in sev_encrypt().
The more generic API that will be useful for other VM types will be to query if a
specific GPA is private vs. shared.

> +		return NULL;
> +
> +	*size = region->region.memory_size;
> +	*gpa_start = region->region.guest_phys_addr;
> +
> +	return region->encrypted_phy_pages;
> +}
> -- 
> 2.37.2.672.g94769d06f0-goog
> 
