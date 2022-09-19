Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7CB5BD536
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 21:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiIST3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 15:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiIST3T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 15:29:19 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CB946222
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 12:29:18 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id fv3so720837pjb.0
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 12:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=Dmji6WgZ7xPVoBunBQhcBqAmOM/CFg7OpLk7cNx+uc8=;
        b=d46SJWkeiDSnWutSydUXgew9qteyyKBJCMX7dT5wUkhHj4yXZv4QSaRTIP4boV4OZS
         mqqvUXpLbkFGFkEiK9eCv8NFZWCoTAo9PrUSCWWjDS0J9ObVikPpB8KA8INU02Fx2geN
         4gv66dh4SsimsRuPojY+fAYWWpG3lwY4HG58utPl9/e/tqA0+l/CHvTfGY0IZc0DysFu
         VbKS1pLZ81rhkZy7gjWxVsgKyRcU9kksvq7WFw14UIMaVQOsLb0ysekH4z9BDrzhYOZG
         3vgc7MuKNxAdMSb9tcc1X3lI4BIDOJkleeXpa1nQdnQOctRTynfDks7LaEow+Swb+fNm
         /NSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Dmji6WgZ7xPVoBunBQhcBqAmOM/CFg7OpLk7cNx+uc8=;
        b=hz3twXzUG7VzL2dF1keOqLFh3xSIds5O8pdvWZRm/793uiw5eBvB7xb1CZYYM0zQIv
         XyTuK8NK7fOdbwfpsiFJyTaEYBHRDwthfSMGUEF5xg4QDaTN5QOXbNvLLzqh6WzZXFEV
         3ifuF8lml/X4Wff8mEhxj+DqPbx7iOl8HJyGTcI3dSvUXXhqR5RogAyqmhbMR0T+hZcr
         QZ8Sm66+c6AmtpZynmnxqCdLLcueT1XMkNhC14uYwROuWOGk3gXUyXjquhED/fTEYc6/
         CjKe3ItqxtXMxda83+u45O7fAb9gimXp0kJyoJ7xfv/TAg7QNZWeXJ5ANW5P96ni8Tnk
         b3Wg==
X-Gm-Message-State: ACrzQf3Agxa8MdjQ2LnNRAXj8LQGiiN6cMWLghY3+i5nVCGSv3rSLziI
        fMrNgGJsNu7o7Va2Wc5MZsHOMg==
X-Google-Smtp-Source: AMsMyM5Oqrj1KGICJ2V8qLt8Rn5ylazcb1hHMnzGoS7sR/Pu1B8N4zBf1uOM+cWrKxXEfgatHaqV0g==
X-Received: by 2002:a17:90b:1e49:b0:203:38c:365a with SMTP id pi9-20020a17090b1e4900b00203038c365amr33037441pjb.133.1663615757758;
        Mon, 19 Sep 2022 12:29:17 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id c199-20020a624ed0000000b0053ea0e5556esm20738942pfb.186.2022.09.19.12.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 12:29:17 -0700 (PDT)
Date:   Mon, 19 Sep 2022 12:29:13 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, alexandru.elisei@arm.com, eric.auger@redhat.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v6 09/13] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YyjDCWCJ5j8c6T2h@google.com>
References: <20220906180930.230218-1-ricarkol@google.com>
 <20220906180930.230218-10-ricarkol@google.com>
 <YyZDBIQsux1g97zl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YyZDBIQsux1g97zl@google.com>
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

On Sat, Sep 17, 2022 at 09:58:28PM +0000, Oliver Upton wrote:
> On Tue, Sep 06, 2022 at 06:09:26PM +0000, Ricardo Koller wrote:
> > Add a new test for stage 2 faults when using different combinations of
> > guest accesses (e.g., write, S1PTW), backing source type (e.g., anon)
> > and types of faults (e.g., read on hugetlbfs with a hole). The next
> > commits will add different handling methods and more faults (e.g., uffd
> > and dirty logging). This first commit starts by adding two sanity checks
> > for all types of accesses: AF setting by the hw, and accessing memslots
> > with holes.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> 
> Hey Ricardo,
> 
> You'll need to update .gitignore for this patch. Additionally, building
> this test throws the following compiler warning:
> 
> In function ‘load_exec_code_for_test’,
>     inlined from ‘run_test’ at aarch64/page_fault_test.c:745:2:
> aarch64/page_fault_test.c:545:9: warning: array subscript ‘long unsigned int[0]’ is partly outside array bounds of ‘unsigned char[1]’ [-Warray-bounds]
>   545 |         memcpy(code, c, 8);
>       |         ^~~~~~~~~~~~~~~~~~
> 
> I've fixed both of these in the appended diff, feel free to squash.

Thanks, will do that.

> 
> --
> Thanks,
> Oliver
> 
> From 0a5d3710b9043ae8fe5a9d7cc48eb854d1b7b746 Mon Sep 17 00:00:00 2001
> From: Oliver Upton <oliver.upton@linux.dev>
> Date: Sat, 17 Sep 2022 21:38:11 +0000
> Subject: [PATCH] fixup! KVM: selftests: aarch64: Add aarch64/page_fault_test
> 
> ---
>  tools/testing/selftests/kvm/.gitignore               |  1 +
>  .../testing/selftests/kvm/aarch64/page_fault_test.c  | 12 +++---------
>  2 files changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index d625a3f83780..7a9022cfa033 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -3,6 +3,7 @@
>  /aarch64/debug-exceptions
>  /aarch64/get-reg-list
>  /aarch64/hypercalls
> +/aarch64/page_fault_test
>  /aarch64/psci_test
>  /aarch64/vcpu_width_config
>  /aarch64/vgic_init
> diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> index 60a6a8a45fa4..5ef2a7b941ec 100644
> --- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> @@ -512,7 +512,7 @@ void fail_vcpu_run_mmio_no_syndrome_handler(int ret)
>  	events.fail_vcpu_runs += 1;
>  }
>  
> -extern unsigned char __exec_test;
> +extern uint64_t __exec_test;
>  
>  void noinline __return_0x77(void)
>  {
> @@ -526,7 +526,7 @@ void noinline __return_0x77(void)
>   */
>  static void load_exec_code_for_test(struct kvm_vm *vm)
>  {
> -	uint64_t *code, *c;
> +	uint64_t *code;
>  	struct userspace_mem_region *region;
>  	void *hva;
>  
> @@ -536,13 +536,7 @@ static void load_exec_code_for_test(struct kvm_vm *vm)
>  	assert(TEST_EXEC_GVA - TEST_GVA);
>  	code = hva + 8;
>  
> -	/*
> -	 * We need the cast to be separate in order for the compiler to not
> -	 * complain with: "‘memcpy’ forming offset [1, 7] is out of the bounds
> -	 * [0, 1] of object ‘__exec_test’ with type ‘unsigned char’"
> -	 */
> -	c = (uint64_t *)&__exec_test;
> -	memcpy(code, c, 8);
> +	*code = __exec_test;

I remember trying many ways of getting the compiler to not complain, I
must have tried this (wonder what happened). Anyway, gcc and clang are
happy with it.

>  }
>  
>  static void setup_abort_handlers(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
> -- 
> 2.37.3.968.ga6b4b080e4-goog
> 
