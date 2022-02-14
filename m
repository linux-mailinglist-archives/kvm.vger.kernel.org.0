Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F70C4B5082
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 13:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353460AbiBNMpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 07:45:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353457AbiBNMpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 07:45:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D564C4AE2B
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 04:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644842712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sbm1VTC3JhjTbI1XGcL/FCBt58VsOFaZiAy3YNtZbdY=;
        b=IdqMzAXcCCN5Rza16Pmvc37CiFffSeKXMvWL83Hobs476X56PcFDrCtVBTgbDTwzsPKwxz
        NOcHmeME008Nu/Qx4NmIFtHOUStmXPZdkRJ5tUXem9jyx4qLTFXOKkpkQ+yUDjq5fiUxaj
        WXcVzb944CKeRwBqqYzIK7DS6AZO+Ns=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-522-rxiNHfa0PcWGOqYh7DpyYg-1; Mon, 14 Feb 2022 07:45:10 -0500
X-MC-Unique: rxiNHfa0PcWGOqYh7DpyYg-1
Received: by mail-ed1-f69.google.com with SMTP id j10-20020a05640211ca00b004090fd8a936so5551567edw.23
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 04:45:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sbm1VTC3JhjTbI1XGcL/FCBt58VsOFaZiAy3YNtZbdY=;
        b=ppwW3Wm24zdjXQ147NdLDZLr51hCtrLLcTQSZKQHkzwQZuwaxeeht85BHUXE8bmOVG
         BMwjr40UQFHmbdIlNocAD2VrFnKyjIT2VQo7BJ0hD4Pde/gYGJaVnYEfRakBhGCWBkSR
         I8e6VffNp8bM8TEstuI80L2F0hdgPp4c6y5rcdClWSBIMD2siFGDw/VEBIjddPF7h13K
         bLcU7HbngZcAQ4DfdrFI1md/48xCcCdoVWPSEBwD/mTr6KHByHWZCCBAiD86P5JDRbci
         nuu+Mfa5ulNzzYC8H58neh6NmlIsly4QRH6Q2z8cGAyGTMI49F+qKiOctzOji7uJpi+q
         Y2eg==
X-Gm-Message-State: AOAM531+8Ltjh5D+iCjw8XSE3hGvusudiLI2GGoLGNw+XzV8j6K5HTz8
        Hq4gL0izRmW2rxJttAICSzPkE1TnytbANMXQVXLfVdaA9VM7/UOmIjcP5Fvq7j6JPuXywtM5JIM
        fwdKMIhnw8Vyy
X-Received: by 2002:aa7:cb87:: with SMTP id r7mr15294634edt.284.1644842709605;
        Mon, 14 Feb 2022 04:45:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJww4MrquSizZ0fRpyz4vvqNlrtrzd1cpOjpomwhZfSCkpSBaUUsraSYW8QXI+KBHQzoYIKFFQ==
X-Received: by 2002:aa7:cb87:: with SMTP id r7mr15294618edt.284.1644842709430;
        Mon, 14 Feb 2022 04:45:09 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id 29sm2243226ejk.107.2022.02.14.04.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 04:45:08 -0800 (PST)
Message-ID: <98ff16cb-0cf8-a8e1-a69e-1a5db30def9b@redhat.com>
Date:   Mon, 14 Feb 2022 13:45:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Don't truncate the PerfEvtSeln MSR when
 creating a perf event
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>
References: <20220203014813.2130559-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220203014813.2130559-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/22 02:48, Jim Mattson wrote:
> AMD's event select is 3 nybbles, with the high nybble in bits 35:32 of
> a PerfEvtSeln MSR. Don't drop the high nybble when setting up the
> config field of a perf_event_attr structure for a call to
> perf_event_create_kernel_counter().
> 
> Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
> Reported-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/kvm/pmu.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 2c98f3ee8df4..80f7e5bb6867 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -95,7 +95,7 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
>   }
>   
>   static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
> -				  unsigned config, bool exclude_user,
> +				  u64 config, bool exclude_user,
>   				  bool exclude_kernel, bool intr,
>   				  bool in_tx, bool in_tx_cp)
>   {
> @@ -181,7 +181,8 @@ static int cmp_u64(const void *a, const void *b)
>   
>   void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>   {
> -	unsigned config, type = PERF_TYPE_RAW;
> +	u64 config;
> +	u32 type = PERF_TYPE_RAW;
>   	struct kvm *kvm = pmc->vcpu->kvm;
>   	struct kvm_pmu_event_filter *filter;
>   	bool allow_event = true;

Queued both, thanks.

Paolo

