Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B4C4F49B2
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444083AbiDEWU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457467AbiDEQDQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 12:03:16 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCB73B295;
        Tue,  5 Apr 2022 08:48:57 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id p26-20020a05600c1d9a00b0038ccbff1951so1497822wms.1;
        Tue, 05 Apr 2022 08:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=A0FjBEpfdUc2aMXGxH1WIchkePURSO+P+PD9Wm9NGP0=;
        b=de+iQACJDntQIFyVxDxW4OrrQwlo2Zxp5d8eJLvzPHLzA1KwtwhbnT+AeX8F/vuAMb
         j+xXSO5fTCnXuBxXlckCplXKHUyx2ysLrYClJJhuveU++JdqQTh/N/PxSIMYMBFWjVys
         3/rG49+/l85lGHJt9RUBZ0WgUs1hk/OSjwYvgBOY+U1HI4Pxq5xr1G8ekWeDFVAWl5U3
         dNCmy7j3DObCw4y7RgevyioB4XBRhZkerg2aLSLPgSN2HyF01a+SJKHsGIrAEXTgoMH+
         Pg/D0Y5b8skQuuGBcE5bkSIomGh0bL/rJ5ZR9BX+duwyIN1eZf0nJtNhhzKpo/424zAw
         sEmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=A0FjBEpfdUc2aMXGxH1WIchkePURSO+P+PD9Wm9NGP0=;
        b=G7zjliX79bkSMGG1oU773ELhoDFSfuo9MZKPZkBcbmD1FhTKycUNUwc843beOxIFvb
         wGxSjuFSEsTMyIo8OPGd/aO269uRkgp2ksK+eT0OAP+lm6Q90gdpIbx1sMtxsIq3gO8z
         bGryGOtCMLyQnrL32xuMoE6lyybn4+HOVxnH/fQ3hIh07zmZgMQ2UQMnrLnfZcK2f8xm
         yp6Hbr7+RDcycFReCsCevglGJg5OX10w7jsUo4786b9c+wieQgqo4PfKPOBVxwi2OsaD
         RUUb1UT2GCV/qjhw1ZQ3FxRUu90M3+w6W2cF59WWNlFJLU/2B/bmdskP/O/o0iwa9l/P
         nPIA==
X-Gm-Message-State: AOAM531B8p15pnRnh8fu9/90E24y6rbNWC+EEiNM/JvqErHmSfklK9mG
        PjeHxFNfQqh4LYpbng32070=
X-Google-Smtp-Source: ABdhPJy4G3ivTYsyI2foaN8va9EG3/g2rVGg49E9xdhQxUpyfj3gymEsoseDyfjIMGb2kqNEYIh6Fg==
X-Received: by 2002:a05:600c:4f43:b0:38c:b270:f9af with SMTP id m3-20020a05600c4f4300b0038cb270f9afmr3761818wmq.36.1649173735827;
        Tue, 05 Apr 2022 08:48:55 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id a11-20020a056000188b00b00204109f7826sm14041183wri.28.2022.04.05.08.48.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 08:48:55 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <efbe06a7-3624-2a5a-c1c4-be86f63951e3@redhat.com>
Date:   Tue, 5 Apr 2022 17:48:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 101/104] KVM: TDX: Silently ignore INIT/SIPI
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <d0eb8fa53e782a244397168df856f9f904e4d1cd.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <d0eb8fa53e782a244397168df856f9f904e4d1cd.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> +		if (kvm_init_sipi_unsupported(vcpu->kvm))
> +			/*
> +			 * TDX doesn't support INIT.  Ignore INIT event.  In the
> +			 * case of SIPI, the callback of
> +			 * vcpu_deliver_sipi_vector ignores it.
> +			 */
>   			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> -		else
> -			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
> +		else {
> +			kvm_vcpu_reset(vcpu, true);
> +			if (kvm_vcpu_is_bsp(apic->vcpu))
> +				vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> +			else
> +				vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
> +		}

Should you check vcpu->arch.guest_state_protected instead of 
special-casing TDX?  KVM_APIC_INIT is not valid for SEV-ES either, if I 
remember correctly.

Paolo
