Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F374E2C37
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 16:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350204AbiCUP3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 11:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350179AbiCUP3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 11:29:13 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0AA1637E2;
        Mon, 21 Mar 2022 08:27:47 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id qa43so30481281ejc.12;
        Mon, 21 Mar 2022 08:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aLOeU6WpgD0PL1DxU3mLFrPMooW422SjAuE/Y9O4C7Y=;
        b=kHXuDFc3XLD+ccOUFGUYgxoeu0hLCe4kZBdPoE0BWxAATHREykdDgjFpilpwCOAUkS
         ze9vvTQXAdNq3RJ8bm0cXmkJcq1OXVmNZd2WyhDrK0IFWBR5194jpKmTypzD/kbTcUGP
         ZaNFD78HnBxuKPisa0mSpoBW0LsYkj5pYjBpVyQ20V1RqfbPQ1YEFtKTtC2CLGmCxM+F
         dfofV4s/Qy6osIaonjxpGdAioukKOPWQVy/V/dvvQC0JlKnT9B1e2OD0dWZVGJmAD80N
         cxab8tu7290NcX4UNNOpSLHaShg5zh6dYpWBoiFqSC6z2HFi0dMfDiIhksucRZ3GvRGi
         Q1LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aLOeU6WpgD0PL1DxU3mLFrPMooW422SjAuE/Y9O4C7Y=;
        b=gYHkFeav+w9blvQTzhPvNmQnuBWM05Ozwcez/2ERMEDjWQ77enRycVfAQmATGfHyE6
         GU2ZCo6ztW8H8Op35luysbwe0W4mGzs+EbOpyaBBNuriDINQ/bf2BB1Zcx3YE0dZCxiU
         smgVlTcw3Gr1y8aNMs8/sf92el+hu8IUXSciJQCtB7g8LRJwfV7cR7a2cNDMIY/56Sih
         YKaXIVqfrsWCeLhm8cHhtVR3xJhKvgy58faKCRutnoccdREtrZf5d3tkeAVEQNp0GIK4
         q4n90VDZre9cWRKNJaNxJFfX/JQcvV5IcRMNaK9T8i6+WNWKiJwfrDqTrhXhYkaTxeIy
         lb8Q==
X-Gm-Message-State: AOAM5306XD0JF8tJoOKtghrIRn9hrHXllbayAm3EIAVED27Anyr2gM37
        tiXdJ+g61Hxq3iza1ZhPsptWNfluP58=
X-Google-Smtp-Source: ABdhPJzwjTTAAiPPtKV5sp+yKADmJUcTpiZo6kWCim0vVzTeuErWFOlPSuEpSMcwzYBh9o7GV0cK/Q==
X-Received: by 2002:a17:907:c16:b0:6da:7d72:1357 with SMTP id ga22-20020a1709070c1600b006da7d721357mr21680979ejc.251.1647876465189;
        Mon, 21 Mar 2022 08:27:45 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id y15-20020a170906518f00b006df87a2bb16sm6334445ejk.89.2022.03.21.08.27.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 08:27:44 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <f8500809-610e-ce44-9906-785b7ddc0911@redhat.com>
Date:   Mon, 21 Mar 2022 16:27:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
References: <20220321150214.1895231-1-pgonda@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220321150214.1895231-1-pgonda@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/21/22 16:02, Peter Gonda wrote:
> SEV-ES guests can request termination using the GHCB's MSR protocol. See
> AMD's GHCB spec section '4.1.13 Termination Request'. Currently when a
> guest does this the userspace VMM sees an KVM_EXIT_UNKNOWN (-EVINAL)
> return code from KVM_RUN. By adding a KVM_EXIT_SHUTDOWN_ENTRY to kvm_run
> struct the userspace VMM can clearly see the guest has requested a SEV-ES
> termination including the termination reason code set and reason code.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Looks good, but it has to also add a capability.

> +		/* KVM_EXIT_SHUTDOWN_ENTRY */

Just KVM_EXIT_SHUTDOWN.

Paolo

> +		struct {
> +			__u64 reason;
> +			__u32 ndata;
> +			__u64 data[16];
> +		} shutdown;
>   		/* KVM_EXIT_FAIL_ENTRY */
>   		struct {
>   			__u64 hardware_entry_failure_reason;

