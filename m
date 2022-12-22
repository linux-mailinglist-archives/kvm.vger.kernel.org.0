Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A638653EAE
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 12:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbiLVLHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 06:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiLVLHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 06:07:05 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FF7B861;
        Thu, 22 Dec 2022 03:07:03 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id u5so1554526pjy.5;
        Thu, 22 Dec 2022 03:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h6mz2+TJk75pl/IHAm10L/0pRIsQfq7tPXLKA9z6M9k=;
        b=C9e7HHX7KQFUA6lfo8okxSW1MNIIYEZrcQDq/jcOU7HIFUZdfPtjoUOcoIKTpejuGw
         hQzEKchwUi6vobwf1GVn4ByeqMtAap083N2rx2An/Ur3GpUhhtuAL8i0DOLFFW+ACDlu
         5IyeP49CFF9Oxe9/mFX4Fktz3p3zVCbmzX1RcU26Nsr5L9mAS7Ohf+F+Kl8nEHDV8nh9
         RDLnNa3cnQxf6yHgt41Hs8t8rtIpCOmuOPvHQ5ua7E9hh7V6CAW8osIFUiWXlbV0bpiA
         yGsQdqwmSSI4KN7mt4FY1rW6t+JbFecn9JXk58eKNTADPo/P7B0s99e8q6hgINtNsxrW
         aeqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h6mz2+TJk75pl/IHAm10L/0pRIsQfq7tPXLKA9z6M9k=;
        b=yREj25y8TTfot0dwQTOJAgY1tg9NjcW9oGCI6eFh5S6bAz/Om1JJN68VLxz0SjSm3e
         kU3dUH9oz56yJb+OKp/j8i0+pXpDGPm+aoLLOG2BIPRLQbG9hJeLMbnq61zohhw+s6+Y
         LS6daNFI7xuq7fZSOsKfDZ0XPdOEbuZcJ/f/OAPXsB2UlsJeWsK9T6f+xSRfuKFI0TJV
         pLvLuYZQSV6N8mtkNfNxWtuxjoVGiBPZcgYLA2yEbFcCp9IXObF3kQJzFaEbU7Sc83F6
         EeI3fbEGX0IcE8b3tBbJ/8AfsphlvqkiAgom8ecxp9ohdBGbyZcKiYx8ppgM1YJh1Zd8
         FGwg==
X-Gm-Message-State: AFqh2kqN4AKkgyy5CgmdJtHrYsUn0P1gxYKuLPq0CrRrHyREitjJJhOO
        Srf7k8JXtLyU6rBTIYCTi2E=
X-Google-Smtp-Source: AMrXdXvsWLCU21xhndWSKe6hPT60gl6j2XbmHk+n3dLaoJ3kjejrCEmgZPcc534h0Y1f5zTpanmKlw==
X-Received: by 2002:a17:903:138a:b0:189:dc47:fe40 with SMTP id jx10-20020a170903138a00b00189dc47fe40mr6464871plb.15.1671707222734;
        Thu, 22 Dec 2022 03:07:02 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id o13-20020a170902d4cd00b00189812a5397sm249213plg.180.2022.12.22.03.07.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 03:07:02 -0800 (PST)
Message-ID: <e96d7310-69c0-1e76-fad5-fde818a2c41a@gmail.com>
Date:   Thu, 22 Dec 2022 19:06:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH v2 10/15] KVM: x86/vmx: Check Arch LBR config when return
 perf capabilities
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kan.liang@linux.intel.com, wei.w.wang@intel.com, seanjc@google.com,
        pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-11-weijiang.yang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221125040604.5051-11-weijiang.yang@intel.com>
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
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b28be793de29..59bdd9873fb5 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2360,6 +2360,10 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
>   		if (guest_efer != host_efer)
>   			exec_control |= VM_ENTRY_LOAD_IA32_EFER;
>   	}
> +
> +	if (cpu_has_vmx_arch_lbr())
> +		exec_control &= ~VM_ENTRY_LOAD_IA32_LBR_CTL;

Please verify that (arch) lbr is not available in the nested test case.
Thus when we support nested lbr, the developer will be aware of the need for 
test case updates

> +
>   	vm_entry_controls_set(vmx, exec_control);
>   
>   	/*
