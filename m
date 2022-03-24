Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D904E67A5
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 18:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352215AbiCXRVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 13:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345269AbiCXRVK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 13:21:10 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D347E23162
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 10:19:38 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id t5so4482614pfg.4
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 10:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AlNuoUD39JW7fYG/U4MZObcSsVepwhRD404jTn/DU2Y=;
        b=lVnCH9NNR/upTexZBbXM3APxsXUf9fZwGu7lAZqyqAi89Vgkj97jjUkgM1OvdGeIso
         4CJMQYE4ODpjkhdTvrFmFiNKILN4spQUP1Iv4dnWyiaEONv70fJmt3bqR7hkG1iYEPKO
         XhriOuuwC4yjhs2KLBX36Ft6RPblHVN3dZ7SFWFGJxhHJ/2bWc4W3tdrODjC4DHrRP+6
         w6zhMFvhApz8Pb3jBJBypvqhjy7ByZTMplytBGZCw3zTkxMu39iMSUcQ3VL8UWmShUH3
         2tawQZypgjDNTWmqGJQXIAfTXiqR42hv4CU4ktKlJ5YfvqmIO9+7hAsH9DK51QrgI3bo
         3RBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AlNuoUD39JW7fYG/U4MZObcSsVepwhRD404jTn/DU2Y=;
        b=qp1gCFo8yZMV3IqXQ84C9sHmQI/42N/IkGCbeGuuG3pypZT3DfbOjeAFhyflGZDUk8
         xaRjvyM1LvM2sEEIbcQyCOIDLremC8rJ9oS84QqWs3QdUo0OrviYc56wn8xOqiXik846
         RYVTWoC3B5DO1Yrj2V6D0sBNoBecz0MudP6/T0NtYfXdfW23i3r/L5EOAhSULMj2NjoN
         OvGQ297U2IGtSAKby3GAT05gGPOrhg39NoRbwL91EZkVdaLU9ZT7TpHK+qbYmkOIsBxn
         n+ewqrwCriuSwHMUmxY2A5kWuQr3jArMBT73J7tTfGjb8WRcDb3QhCgfaJmkUu+muiDJ
         FRXw==
X-Gm-Message-State: AOAM5307nsxHz8b3uICDawYZvrO3/4x0EVdInQR7ISFoONXM6CBqBkDx
        VtpOt1pge0JbH8v+Qw8AdmqZkzV3Mnl3UQ==
X-Google-Smtp-Source: ABdhPJyf7y92+DjD9Mv03aglLgiyiM6jKEZyl+y/I0yl5B6pCx3hFOZFHeGqGBfW870gVXWSLO3Rpg==
X-Received: by 2002:a63:dc44:0:b0:381:5720:88a5 with SMTP id f4-20020a63dc44000000b00381572088a5mr4883596pgj.219.1648142378049;
        Thu, 24 Mar 2022 10:19:38 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s3-20020a056a00194300b004f6da3a1a3bsm4248970pfk.8.2022.03.24.10.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 10:19:37 -0700 (PDT)
Date:   Thu, 24 Mar 2022 17:19:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, maz@kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 2/4] KVM: selftests: add is_cpu_online() utility
 function
Message-ID: <YjyoJu0/Saowtrbc@google.com>
References: <20220322172319.2943101-1-ricarkol@google.com>
 <20220322172319.2943101-3-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322172319.2943101-3-ricarkol@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 22, 2022, Ricardo Koller wrote:
> Add is_cpu_online() utility function: a wrapper for
> "/sys/devices/system/cpu/cpu%d/online".
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/include/test_util.h |  2 ++
>  tools/testing/selftests/kvm/lib/test_util.c     | 16 ++++++++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index 99e0dcdc923f..14084dc4e152 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -143,4 +143,6 @@ static inline void *align_ptr_up(void *x, size_t size)
>  	return (void *)align_up((unsigned long)x, size);
>  }
>  
> +bool is_cpu_online(int pcpu);
> +
>  #endif /* SELFTEST_KVM_TEST_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index 6d23878bbfe1..81950e6b6d10 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -334,3 +334,19 @@ long get_run_delay(void)
>  
>  	return val[1];
>  }
> +
> +bool is_cpu_online(int pcpu)
> +{
> +	char p[128];
> +	FILE *fp;
> +	int ret;
> +
> +	snprintf(p, sizeof(p), "/sys/devices/system/cpu/cpu%d/online", pcpu);

I don't think this is sufficient for the use in patch 03; the CPU could be online
but disallowed for use by the current task.  I think what you want instead is a
combination of get_nprocs_conf() + sched_getaffinity() + CPU_ISSET().
