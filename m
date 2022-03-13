Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B734D75BF
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 15:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbiCMOM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 10:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234571AbiCMOMz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 10:12:55 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D722F1BEAF;
        Sun, 13 Mar 2022 07:11:47 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 19so7850047wmy.3;
        Sun, 13 Mar 2022 07:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mG5HH6nqD1iO3ujIo5ypOCSibOJXtCmf7BdHByX18qs=;
        b=hl41bOxZH1F73UO71NgC1fWGtfIpWPVDtTg8teHRgkV8FomDdZ2iL8ib7dOPq1e7DA
         5fSJtrGBPYPvcgrfa+qQJPugeHWl2QRVzr+gl+2u+j1mQ7NLxLWy1PwiCSTXdUgu3T3d
         eqeIS99ZpyHGGwLH1Dw7CYmsZyk6BAtnQcsJ3fvV9Njd1PxrHsx2Ehwcj1BLY7OCtWRS
         KURPkhGBIxVyeIOFa/cRRdNQ6w4B/MBbFZnXKhSflO/T+IggljcGl/jtWcGh9lRJDJ+0
         ukotl368CgZ5tzS7vVGAvHRxkDhurtqHu/knrM0RFiy5/7V7LBF7WpeofQIW+INbuR8+
         XZCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mG5HH6nqD1iO3ujIo5ypOCSibOJXtCmf7BdHByX18qs=;
        b=BO5PhjPIP+XPYQwz9xwwEax3CbpVkLVeHt+Yszekfu7fSwZdT3sstktXMO3Ga52qgS
         QQ3oYu3pFz2f4KmzWm2ihTWdkIQ7QPd4UXuhxOzn3CcgfktDBO4WaXEX0IXjwA0A35X9
         LDlAqp+vjf5FiVTkV4Gf6q7EtQdq2sTZohgj3Ml9WIrc6BV4EXYeH97fleh00JyBk83p
         Vnri3xsi8DO7g8nnootGOqACaiwJgAWU/IhSV8PSfnT3j7vIVudsOxRGkkhT9PTmzYDW
         l2+j6s20NJGk7HIL9rnr/daOuHsec5hwpwsNdNxCIFNQM+oDTfryWzA2C743z+aJtytP
         eTVA==
X-Gm-Message-State: AOAM531pYWG6jKFdFcfHcHwAdiCnMU47/MrK97hioz4mY/zO9z421AK9
        plBzoiSLLpBi0goMOE2fOvqW6JwROBQ=
X-Google-Smtp-Source: ABdhPJz9tN2MsP/yVeC8XG9FmG2IMtNZjQKCwrh8pxPv2fs/fHH3vjhVIaKzxiof0ksQY5Cy7DPmrA==
X-Received: by 2002:a05:600c:4f95:b0:38a:165:f2af with SMTP id n21-20020a05600c4f9500b0038a0165f2afmr4641756wmq.16.1647180706456;
        Sun, 13 Mar 2022 07:11:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id k17-20020a05600c1c9100b00386bb6e9c50sm25991598wms.45.2022.03.13.07.11.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 07:11:46 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <8c5a9392-d6e0-35c7-73e1-d37b2f013d18@redhat.com>
Date:   Sun, 13 Mar 2022 15:11:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v5 015/104] KVM: TDX: add a helper function for KVM to
 issue SEAMCALL
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <5cf00a5f5d108443a081ef95db9c7695be99c7d4.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <5cf00a5f5d108443a081ef95db9c7695be99c7d4.1646422845.git.isaku.yamahata@intel.com>
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

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TODO: Consolidate seamcall helper function with TDX host/guest patch series.
> For now, this is kept to make this patch series compile/work.
> 
> A VMM interacts with the TDX module using a new instruction (SEAMCALL).  A
> TDX VMM uses SEAMCALLs where a VMX VMM would have directly interacted with
> VMX instructions.  For instance, a TDX VMM does not have full access to the
> VM control structure corresponding to VMX VMCS.  Instead, a VMM induces the
> TDX module to act on behalf via SEAMCALLs.
> 
> Add a helper function for KVM C code to execute SEAMCALL instruction to
> hide its SEAMCALL ABI details.  Although the x86 TDX host patch series
> defines a similar wrapper, the KVM TDX patch series defines its own because
> KVM TDX case is performance-critical, unlike the x86 TDX one that does
> one-time initialization.  The difference is that the KVM TDX one is defined
> as a static inline function without an error check that is known to not
> happen so that compiler can optimize it better.  The wrapper fiction in the
> x86 TDX host patch is defined as a function written in assembly code with
> error check so that it can detect errors that can occur only during the
> initialization.

I assume whatever survives of this patch will be merged in the previous one.

Paolo

> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/seamcall.h | 23 +++++++++++++++++++++++
>   1 file changed, 23 insertions(+)
>   create mode 100644 arch/x86/kvm/vmx/seamcall.h
> 
> diff --git a/arch/x86/kvm/vmx/seamcall.h b/arch/x86/kvm/vmx/seamcall.h
> new file mode 100644
> index 000000000000..604792e9a59f
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/seamcall.h
> @@ -0,0 +1,23 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __KVM_VMX_SEAMCALL_H
> +#define __KVM_VMX_SEAMCALL_H
> +
> +#ifdef CONFIG_INTEL_TDX_HOST
> +
> +#ifdef __ASSEMBLY__
> +
> +.macro seamcall
> +	.byte 0x66, 0x0f, 0x01, 0xcf
> +.endm
> +
> +#else
> +
> +struct tdx_module_output;
> +u64 kvm_seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9, u64 r10,
> +		struct tdx_module_output *out);
> +
> +#endif /* !__ASSEMBLY__ */
> +
> +#endif	/* CONFIG_INTEL_TDX_HOST */
> +
> +#endif /* __KVM_VMX_SEAMCALL_H */

