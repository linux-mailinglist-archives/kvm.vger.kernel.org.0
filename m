Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD234587BF0
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 14:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236709AbiHBMFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 08:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbiHBMFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 08:05:02 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537C54D831;
        Tue,  2 Aug 2022 05:05:01 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id b4so3224756pji.4;
        Tue, 02 Aug 2022 05:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qyEwXxMaOKekMZmxVgrwx2owp7s+c/QpxgELmUBwdds=;
        b=WXmyltDcRe/cYXCKLMAxw9Kc74xm9XPFJtETTDp9hDecuDxSqW6A14BhpFRCMFvdU+
         KQMJOEOJBywydxaHrWmXSVDdaR5s6N48/UpiBzLFolwLBo3deLSeXlO3GGM/h7Qpz63/
         30aCEdz9jGmIQ1lsqt2PXlsLwlxS3J5/p04yciTtHhoODr+Lwt9plgsFkrV2xCRxwTjl
         JQemr9a0IWW7QJ1F+SK8A8Fg242f+3NSsGG+yRdk+2gChFtrTbDRsKc0QTEQyMvb9Iri
         ucd7AR9ng4G2pl5LOEvw3gza6YKEwwHlPmnaYBOGuODVx0KsLjnhFQLFYkiVURNNC272
         eJoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qyEwXxMaOKekMZmxVgrwx2owp7s+c/QpxgELmUBwdds=;
        b=wIn9lqDkF9SPy3YkCUhknrUI/wQNYo9c6Jghm5T65D7cFxALu55+ir6nhce51jdCAN
         U85k3rNdGDkr30rnhqTvHoQkEqXL/dU+INDn9UUBQFtQ1rg1YR7F0TFramu/Vjg/qfTZ
         V76+yZlBiyCS/kFEK7Jh5ZVB4fg/TfSFMBaVsICve8THYEBGVYGlcw0wDTJwYQxvypHr
         mzI/dso0fH3VFyxst612zMekaEsaAu7of59jvuQTGl1jD1c9cgTCQp+3ggQ287rrJS3K
         jgjRNk4Til6ked6heBISKT1s6Z6BHrrR8c3t/ggPNaQy9Mca2MaSENYZOk5xkZuCIZ2d
         hT/Q==
X-Gm-Message-State: ACgBeo2kjpTUkj3+k3lYPhfgAf7Sn914nAeoyeoggKoM7a8gmYmSWpy9
        +pN7ByfvomnBHKa/Qs+OPGZdCclbSJL0yw==
X-Google-Smtp-Source: AA6agR45SpU5HyP7zRUCcdKj+jlnWQLqb7qBakdoycthdG/nzyxFU3TGuq+6RFsNqu4AFgXb2sTutA==
X-Received: by 2002:a17:903:32c4:b0:16f:e2e:5cd6 with SMTP id i4-20020a17090332c400b0016f0e2e5cd6mr337094plr.62.1659441900780;
        Tue, 02 Aug 2022 05:05:00 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v186-20020a622fc3000000b0052cc561f320sm8799990pfv.54.2022.08.02.05.04.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Aug 2022 05:05:00 -0700 (PDT)
Message-ID: <dcc187d2-f55b-a5cd-0664-a6fc78b7966f@gmail.com>
Date:   Tue, 2 Aug 2022 20:04:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH 3/3] KVM: VMX: Adjust number of LBR records for
 PERF_CAPABILITIES at refresh
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220727233424.2968356-1-seanjc@google.com>
 <20220727233424.2968356-4-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20220727233424.2968356-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/7/2022 7:34 am, Sean Christopherson wrote:
> -bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
> -{
> -	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
> -
> -	return lbr->nr && (vcpu_get_perf_capabilities(vcpu) & PMU_CAP_LBR_FMT);
> -}
> -
>   static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
>   {
>   	struct x86_pmu_lbr *records = vcpu_to_lbr_records(vcpu);
> @@ -590,7 +583,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>   	bitmap_set(pmu->all_valid_pmc_idx,
>   		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
>   
> -	if (cpuid_model_is_consistent(vcpu))
> +	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
> +	if (cpuid_model_is_consistent(vcpu) &&
> +	    (perf_capabilities & PMU_CAP_LBR_FMT))
>   		x86_perf_get_lbr(&lbr_desc->records);

As one of evil source to add CPUID walk in the critical path:

The x86_perf_get_lbr() is one of the perf interfaces, KVM cannot always trust
that the number of returned lbr_desc->records.nr is always > 0,  and if not,
we have to tweak perf_capabilities inside KVM which violates user input again.

Do you have more inputs to address this issue ?

>   	else
>   		lbr_desc->records.nr = 0;
