Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBE561FD81
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbiKGS16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbiKGS14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:27:56 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A1F108
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 10:27:55 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id d10so11415305pfh.6
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 10:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+iBvU2UQj9bZ2gzUljEVe8v8u/eQ0GDuqYtysdhencY=;
        b=A7IcD4QrqNXDJ8FoYG5GnTbgfgsKhB26fG7p5Ogc63sdVNg2zWmpsSs8zNI5NjkXhU
         P4rKz0rAs2Q2hk3xecIpv6ebWVvmA5ZY7bcMYlVrTLaLwk3eqQ/pHrVCDAobnfO1F0ZJ
         jKaooVbVZKCt32y/syBZ39VZwHOWJOWqcqQtVh2Kt2vQktr33y5HRgZUmkDnZhBg0Ih/
         GhP0FAzjtWGxrlGOfK3dzjZcA0oN4bA13g6J6VFops7DDDUjibhFDpJMOqGO9HEgYWF6
         Fsg3BhnaPKSlgW3WMlr9pYcfWLLtA289qvGRXwJM5R79MrdU9719XODvsYvMJhf9f7LR
         R0VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+iBvU2UQj9bZ2gzUljEVe8v8u/eQ0GDuqYtysdhencY=;
        b=G/1g6mfydxRPNzJs7OMHNW9H5jhUVq7gXxZ6HNj8YgJlbjGRkXnHFWzUbuarzmADbp
         jmyYok0SRT6Y61lLVdid3lVHQxH87LXOW5HsKenG5lSR5ttZJnxJbHCCeKvSkKc9L/CH
         /frhlx9Onk6E/CndGEk0YvPzEepkjWr1eHiFdrTsp/d+zQ78sVBbKog9QJYQnouAeRUz
         zWzaPlEo4WgsDM+cyjbnuUoKIOvxAi0Rde1s0mHA08bcnVk6Fe0WuBs9T4ek7ymX3rLj
         JLcwXtlH2+6L2xVdU2B2cgCbfQkwxhZoc7g35m3SlN5XjMUaLpc2uoK6obamLdzopvll
         yotQ==
X-Gm-Message-State: ANoB5pmHhE4VuTK2vrrPTOfasD++JuMRpsTTMMHWDnN0Mx1aY+RJQPmy
        QwLW+oFfuqzmyZSoDL+kqf3OhuYcyBzw7w==
X-Google-Smtp-Source: AA0mqf5amlU6JrBKS4Yk0oqeghtLeGdAH4BaMyja7iuu1SnKfEqMLfxDxcMsRvT5Jy7J8APi0lUh2g==
X-Received: by 2002:a63:4a4c:0:b0:470:75a0:e8c3 with SMTP id j12-20020a634a4c000000b0047075a0e8c3mr6109376pgl.589.1667845674849;
        Mon, 07 Nov 2022 10:27:54 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id 70-20020a17090a09cc00b001f8c532b93dsm4633247pjo.15.2022.11.07.10.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 10:27:54 -0800 (PST)
Date:   Mon, 7 Nov 2022 10:27:50 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] KVM: selftests: Test Hyper-V extended hypercall
 enablement
Message-ID: <Y2lOJqLaLIBxEP7P@google.com>
References: <20221105045704.2315186-1-vipinsh@google.com>
 <20221105045704.2315186-4-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221105045704.2315186-4-vipinsh@google.com>
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

On Fri, Nov 04, 2022 at 09:57:01PM -0700, Vipin Sharma wrote:
> Test Extended hypercall CPUID enablement

nit: Use complete sentences and provide more details on what exactly
is being tested.

The rest of the commit messages look pretty good so I assume you just
forgot to fill this one in fully before sending to the mailing list :)

> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/hyperv.h  | 4 ++++
>  tools/testing/selftests/kvm/x86_64/hyperv_features.c | 9 +++++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> index b66910702c0a..075fd29071a6 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> @@ -110,6 +110,7 @@
>  #define HV_ACCESS_STATS				BIT(8)
>  #define HV_DEBUGGING				BIT(11)
>  #define HV_CPU_MANAGEMENT			BIT(12)
> +#define HV_ENABLE_EXTENDED_HYPERCALLS		BIT(20)
>  #define HV_ISOLATION				BIT(22)
>  
>  /* HYPERV_CPUID_FEATURES.EDX */
> @@ -164,6 +165,9 @@
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
>  
> +/* Extended hypercalls */
> +#define HV_EXT_CALL_QUERY_CAPABILITIES		0x8001
> +
>  #define HV_FLUSH_ALL_PROCESSORS			BIT(0)
>  #define HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES	BIT(1)
>  #define HV_FLUSH_NON_GLOBAL_MAPPINGS_ONLY	BIT(2)
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index 05b32e550a80..6b443ce456b6 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -602,6 +602,15 @@ static void guest_test_hcalls_access(void)
>  			hcall->expect = HV_STATUS_SUCCESS;
>  			break;
>  		case 19:
> +			hcall->control = HV_EXT_CALL_QUERY_CAPABILITIES;
> +			hcall->expect = HV_STATUS_ACCESS_DENIED;
> +			break;
> +		case 20:
> +			feat->ebx |= HV_ENABLE_EXTENDED_HYPERCALLS;
> +			hcall->control = HV_EXT_CALL_QUERY_CAPABILITIES | HV_HYPERCALL_FAST_BIT;
> +			hcall->expect = HV_STATUS_INVALID_PARAMETER;
> +			break;
> +		case 21:
>  			kvm_vm_free(vm);
>  			return;
>  		}
> -- 
> 2.38.1.273.g43a17bfeac-goog
> 
