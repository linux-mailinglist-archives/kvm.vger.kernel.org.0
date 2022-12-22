Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A221B653EBB
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 12:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbiLVLKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 06:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235379AbiLVLJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 06:09:56 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D5A28720;
        Thu, 22 Dec 2022 03:09:54 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id n65-20020a17090a2cc700b0021bc5ef7a14so1559754pjd.0;
        Thu, 22 Dec 2022 03:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PS18Odh7yIwGitQspmqvEHIFeSofJlERTxp58aaKy5s=;
        b=JNfL6+soyHU08XT3Q00FBuAnFCrt2YhCmg6H0GelUhB2DDwlJk9QiOIm5+CjFxC0JK
         d3FkKEnHMSGlIvygDeT1iyZAgtk19dX595URUVTChdSuQ/Tt0+I7hmDzP9jO/P3yuiHf
         cni/Ic2/jc89PZCahqR16mNk56jy7KhIKSgg1/T8T4IwUwQub9yW8nOhyfaKhz/0S71k
         QoQI3eHSegX/rtTmlFyWI09WDLptLHGibsMhZHME57XMkdzrOvFsntIoVwnC2r9eXMm9
         Ron9OpCuYSaB2NJrMmb+PNwMJxu20Rmf2vxiRy+EoctCjbSp0/OLfBWUUrO0i5w9znSN
         UzIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PS18Odh7yIwGitQspmqvEHIFeSofJlERTxp58aaKy5s=;
        b=GNYO7iUHKkoxkyAKXPDPMJVHjh/PlxFAPYEjGxANSH27erIXkD+1LnL/+iPnzrPUS2
         Zg6TW/IjhIgbsS8o5rjATfXZ5Hv8v1vJOh0TNAgmXRqwopyiO4QFxj3lr8N5L29XaOyC
         YRByJDqe4kPmHQUNmjroBdZFc3JpFVQX0pDwQylHD3QH9ucMVrMR6jrLalbsd0BbWbDT
         9ap0zYUSuxoGUN6jcYve3gkvmZ5qEh7Ju4l48ShlplmENF0dB1Bz+kIdHeHDi70PV4Vm
         xlM6T9DWSXh3Cm36csyZi5GLQk2cGJzw3uJavj79GpNrCH2c5BU5KvdbDNCa5Gc2dR1K
         6wLA==
X-Gm-Message-State: AFqh2kpu394AZ3wYMZqAFQZsYGF6a5BwVsP35i+zUxcBlePr3Bvutq4Q
        xJCCd8LAz7BABPIRiTFJwnfWTybiKBba7Gka
X-Google-Smtp-Source: AMrXdXtHjQXwPpxASxolDnhbQYO8T3qdfZRDFMMyilqqoxuvFUBTdi6eaNm5RT2AJtvwleQPpsnr9Q==
X-Received: by 2002:a05:6a20:8e10:b0:a4:a73e:d1e2 with SMTP id y16-20020a056a208e1000b000a4a73ed1e2mr8261977pzj.57.1671707394004;
        Thu, 22 Dec 2022 03:09:54 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w185-20020a6230c2000000b0057621a437d7sm443905pfw.116.2022.12.22.03.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 03:09:53 -0800 (PST)
Message-ID: <8f0fec41-d302-b261-ce5a-83692f1238b6@gmail.com>
Date:   Thu, 22 Dec 2022 19:09:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH v2 06/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for guest
 Arch LBR
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kan.liang@linux.intel.com, wei.w.wang@intel.com, seanjc@google.com,
        pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-7-weijiang.yang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221125040604.5051-7-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/11/2022 12:05 pm, Yang Weijiang wrote:
>   static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   {
>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> @@ -377,6 +402,14 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	case MSR_ARCH_LBR_DEPTH:
>   		msr_info->data = lbr_desc->records.nr;
>   		return 0;
> +	case MSR_ARCH_LBR_CTL:
> +		if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR)) {
> +			WARN_ON_ONCE(!msr_info->host_initiated);

Why we need this warning even in the format of WARN_ON_ONCE() ?
And why not for MSR_ARCH_LBR_DEPTH msr ?

> +			msr_info->data = 0;
> +		} else {
> +			msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
> +		}
> +		return 0;
