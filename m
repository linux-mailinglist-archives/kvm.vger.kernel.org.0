Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFF073619E
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 04:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjFTCoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 22:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjFTCoh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 22:44:37 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4DAE74
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 19:44:36 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-763a2e39b88so113384285a.1
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 19:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687229076; x=1689821076;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LfUNRUM1h2YyuDNdLgmHc3JvRKvju4SHuCqjDXIk+uc=;
        b=bC3AfGTQCUYFohvPkc4osyRXMzjjHYkDArvFOabW9zNPBUQOOq4ppfLK/JxFduK3Uz
         OrojvYYuTK/vAWl2lY4RL86o8C6W76b4g8my6f5tYxLouqz3o/F5CU1IMAroLnxaVwkm
         WnSWscZ6qcdqJK6gGwFz8JOpNfn3QqwRWrXpG73q3jA692UkiGbfjORWYzOCkp0773xE
         YK9ajY9qFP9KImfrIl+nkXEIapxJJskUzqM1GUgW6ywWpMqtKrY9sfjbgWK7zk+M7r+t
         Mj+MPzW3CL8uotm6zhD+1IbHU801DBPjN1d//kpPbSJSW383LLcki5V+Nq/UmD2o0i3m
         Hngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687229076; x=1689821076;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LfUNRUM1h2YyuDNdLgmHc3JvRKvju4SHuCqjDXIk+uc=;
        b=X82U69XLlr0aVQw8638StGx2p4/PvDDgaSE/NfKPiWyiPro2MYWdkXQi4i6I9sRz+v
         QsER78sVvTsy+MGOiW7beI8Nbx2b2jc/2aOpdI3rR7EPh1CGl5Hf1JPf8P20Z0MJNqz4
         P9KbWpde5dh5TNvmYrpSL5gRm61qZe/I71PDDHn9+dt4fm8OYU/d0ZoLK9TpP2UNFNcw
         zVZhmDZO+ApDPggbQ+9zgFoa3V1L+8vgk39s3YUrCyLqw6Tmv3V/wVC5gkKpFsm0/qN2
         3FdNIOdn/qTQAxCmktPqDBz7lONUgju36BYwDsC07M+H02QO3E77a9Hstid2a2XN58nE
         MNYg==
X-Gm-Message-State: AC+VfDziQR6IdQcQ9zuINSTmrnPImW1Q6SzFz5aYfnpggJh9dExsdwJN
        ZKZargW1L4OvlCl2TPFmgtg97aDq1Bg=
X-Google-Smtp-Source: ACHHUZ4hB8VltlKYkQ7lgdVOdmNZdYf1Ired4GhNDWRF0gJLtQ7F2RZrt3wZiREni2gqvCMujgRHYw==
X-Received: by 2002:a05:620a:1b8b:b0:760:7da5:ef2a with SMTP id dv11-20020a05620a1b8b00b007607da5ef2amr12265723qkb.36.1687229075937;
        Mon, 19 Jun 2023 19:44:35 -0700 (PDT)
Received: from [172.27.224.21] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id n4-20020a170903110400b001b55c0548dfsm460364plh.97.2023.06.19.19.44.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 19:44:35 -0700 (PDT)
Message-ID: <7ca95d15-43c8-b9f5-a419-07bb4c27862f@gmail.com>
Date:   Tue, 20 Jun 2023 10:44:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v4 16/16] KVM: selftests: Handle memory fault exits in
 demand_paging_test
Content-Language: en-US
To:     Anish Moorthy <amoorthy@google.com>, seanjc@google.com,
        oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
References: <20230602161921.208564-1-amoorthy@google.com>
 <20230602161921.208564-17-amoorthy@google.com>
From:   Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <20230602161921.208564-17-amoorthy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/2023 12:19 AM, Anish Moorthy wrote:
[...]
>   static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
>   {
>   	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
>   	int vcpu_idx = vcpu_args->vcpu_idx;
>   	struct kvm_run *run = vcpu->run;
> -	struct timespec start;
> -	struct timespec ts_diff;
> +	struct timespec last_start;
> +	struct timespec total_runtime = {};
>   	int ret;
>   
> -	clock_gettime(CLOCK_MONOTONIC, &start);
>   
> -	/* Let the guest access its memory */
> -	ret = _vcpu_run(vcpu);
> -	TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
> -	if (get_ucall(vcpu, NULL) != UCALL_SYNC) {
> -		TEST_ASSERT(false,
> -			    "Invalid guest sync status: exit_reason=%s\n",
> -			    exit_reason_str(run->exit_reason));
> -	}
> +	while (true) {
> +		clock_gettime(CLOCK_MONOTONIC, &last_start);
> +		/* Let the guest access its memory */
> +		ret = _vcpu_run(vcpu);
> +		TEST_ASSERT(ret == 0
> +			    || (errno == EFAULT
> +				&& run->exit_reason == KVM_EXIT_MEMORY_FAULT),
> +			    "vcpu_run failed: %d\n", ret);
>   
> -	ts_diff = timespec_elapsed(start);
> +		total_runtime = timespec_add(total_runtime,
> +					     timespec_elapsed(last_start));
> +		if (ret != 0 && get_ucall(vcpu, NULL) != UCALL_SYNC) {
> +
> +			if (run->exit_reason == KVM_EXIT_MEMORY_FAULT) {
> +				ready_page(run->memory_fault.gpa);
> +				continue;
> +			}
> +
> +			TEST_ASSERT(false,
> +				    "Invalid guest sync status: exit_reason=%s\n",
> +				    exit_reason_str(run->exit_reason));
> +		}
> +		break;
> +	}
>   	PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vcpu_idx,
> -		       ts_diff.tv_sec, ts_diff.tv_nsec);
> +			total_runtime.tv_sec, total_runtime.tv_nsec);
>   }

Can include number of #PF handled by vcpu worker in PER_VCPU_DEBUG output.

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c 
b/tools/testing/selftests/kvm/demand_paging_test.c
index 4b79c88cb22d..8841150b0e2b 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -91,7 +91,7 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
         struct timespec last_start;
         struct timespec total_runtime = {};
         int ret;
-
+       int pages = 0;

         while (true) {
                 clock_gettime(CLOCK_MONOTONIC, &last_start);
@@ -108,6 +108,7 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)

                         if (run->exit_reason == KVM_EXIT_MEMORY_FAULT) {
                                 ready_page(run->memory_fault.gpa);
+                               pages++;
                                 continue;
                         }

@@ -117,8 +118,8 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
                 }
                 break;
         }
-       PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vcpu_idx,
-                       total_runtime.tv_sec, total_runtime.tv_nsec);
+       PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds, %d page faults 
handled\n", vcpu_idx,
+                       total_runtime.tv_sec, total_runtime.tv_nsec, pages);
  }


