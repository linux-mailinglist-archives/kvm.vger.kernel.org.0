Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C9B60ECE8
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 02:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJ0ARs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 20:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiJ0ARr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 20:17:47 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5464EE4E50
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 17:17:46 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id f193so16734076pgc.0
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 17:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b99mcTI/VZrc8bG+pMy1xJ4O0KYbQCRsdNm7m+gEkn4=;
        b=TEYi+4fYE/y37HieFZEFXvmeb20UsxUdPTKdAgPhs3ZAgbORrKG9Ur1LwBbwV7mYaj
         dzp/i0OapJ9aI9S3Sl9s/aINbrxdY4gnPvGjri2wFmQZ8R6G3xbLOOGJdh4mwvnz7IQ1
         R4bBTwzyOSzl/m+7loeV9eqdGNElDAHnH/Rb8tMqVRe3buM3WLhBvyV9ExyF/naExMh+
         lNOj1bRM1UaTnEWcwFe3fDpX0x4l2yM5GHuB4BDgUHdF5GwXpwATZPkK3h4kr+7ZPpzn
         bQ8ddXAW7CwlJHA4ClvLx1FC16jN241avl1b8VJ1fzZ7D9ykjrRNRqBmo3j6hhamkssU
         kZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b99mcTI/VZrc8bG+pMy1xJ4O0KYbQCRsdNm7m+gEkn4=;
        b=JcJiBEpwacvhWktPrwBytnPPVCvZDOtfrMZaQ1ZENsH5VaeznXauLXusjpnHVBOWap
         YIkqKeXfZxLda90tkJ6yWqH5tp/p3i8OicVoI7aEQyyKr5l7rKRuNJ91l/sE1VbTPEbS
         bpFPGVwS9664l8of6al79cCaJQlbvsPyDWxRsQQPOtxmil3LhRzjg8rVT9Ps0r8YnsR/
         2AJbAkemjpszxp5SNgcmFdspSUH9VOqc5v8x5icK2sJrO1QQJVEeUkg7R0tC0LTHXFSJ
         6Wn1xtM425/qXce3qY1dqPmXWMWsEzNKweZe2hvY2025duajWkFc4GEs1ht4cSVXW/Ls
         sDpQ==
X-Gm-Message-State: ACrzQf1NJk1P6FJ69IF4cD5Ev974pIkRl7YUdWER4qAhk7h6VpBQw4cy
        rFfO6dolwyiIy9ubXAY2XQ4dTw==
X-Google-Smtp-Source: AMsMyM7jauTsOt/eHVwDN3iJvaDK5P5WEV/SdHHcr+Lqak9C8saoa4BfSHv16VacDs1LUr3wmwB1FA==
X-Received: by 2002:a05:6a00:2342:b0:56b:e64c:e065 with SMTP id j2-20020a056a00234200b0056be64ce065mr16588757pfj.32.1666829865508;
        Wed, 26 Oct 2022 17:17:45 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t8-20020a17090a3e4800b0020b2082e0acsm1646253pjm.0.2022.10.26.17.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 17:17:45 -0700 (PDT)
Date:   Thu, 27 Oct 2022 00:17:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, vipinsh@google.com,
        ajones@ventanamicro.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 09/18] KVM: selftests/steal_time: vcpu related code
 consolidation and cleanup
Message-ID: <Y1nOJQWys3gUp+oB@google.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
 <20221024113445.1022147-10-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024113445.1022147-10-wei.w.wang@intel.com>
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

On Mon, Oct 24, 2022, Wei Wang wrote:
> Remove the unnecessary definition of array of the vcpu pointers and
> re-use the one from the kvm_vm struct (i.e. vm->vcpus[]). Use the helper
> function to create the time stealing thread with name.

One thing per patch.

> Also add a check of the pthread_join return value.
> 
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> ---
>  tools/testing/selftests/kvm/steal_time.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> index db8967f1a17b..857ed2c073fc 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -8,7 +8,6 @@
>  #include <stdio.h>
>  #include <time.h>
>  #include <sched.h>
> -#include <pthread.h>
>  #include <linux/kernel.h>
>  #include <asm/kvm.h>
>  #include <asm/kvm_para.h>
> @@ -241,7 +240,7 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
>  
>  int main(int ac, char **av)
>  {
> -	struct kvm_vcpu *vcpus[NR_VCPUS];
> +	struct kvm_vcpu **vcpus;
>  	struct kvm_vm *vm;
>  	pthread_attr_t attr;
>  	pthread_t thread;
> @@ -250,7 +249,7 @@ int main(int ac, char **av)
>  	long stolen_time;
>  	long run_delay;
>  	bool verbose;
> -	int i;
> +	int i, r;
>  
>  	verbose = ac > 1 && (!strncmp(av[1], "-v", 3) || !strncmp(av[1], "--verbose", 10));
>  
> @@ -262,7 +261,8 @@ int main(int ac, char **av)
>  	pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset);
>  
>  	/* Create a VM and an identity mapped memslot for the steal time structure */
> -	vm = vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
> +	vm = vm_create_with_vcpus(NR_VCPUS, guest_code, NULL);
> +	vcpus = vm->vcpus;

Just use vm->vcpus directly and drop the local variable, it's not that much more
churn and this looks quite odd.
