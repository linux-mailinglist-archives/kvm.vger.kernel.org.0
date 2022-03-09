Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F145E4D2F96
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 14:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbiCINBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 08:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbiCINBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 08:01:12 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE653177777;
        Wed,  9 Mar 2022 05:00:13 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id bi12so4842197ejb.3;
        Wed, 09 Mar 2022 05:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ztB7lSK3t314M/GM0bFqDAkVpPrga15HiDgNZRTpDq4=;
        b=okL11a4SHWU0806w+ZNokDNKRH8vWCp2YDU27o+G81sMETF0PxFH/ileBw8/nlkuXY
         qXOq7hQIu1+5u7uBwYl5upbUWySCbiWEayGKfDuZKVSCq4FUMIOOhsRVvCu06I7zgb3u
         TE5WfQGaDc4H1X4ZbsyMQIyHpnyE3xqYHvLKwNsaar2hl5hDhdlgpW49gIkcaYW0LIFn
         CWRrShm2hG+9wLjMwxqI4bHKTcVuYgcrULzZiDhgmcjoCvlf25trmCPmz4Cf82ujxHDW
         W9xT3ENGnksm/qFjJEK7z0Lz3bxzE5yVkQBXpoE0fOWjj3NZC/wY0bQdmsYTWTmJSIFy
         lfaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ztB7lSK3t314M/GM0bFqDAkVpPrga15HiDgNZRTpDq4=;
        b=Y6a2kBSN4WngWUO4doQLt6PN/gNdJtVl5rCDGAn01/pPCdTETTnCymxnZ+6HgmAwW1
         eV2FnI8XnroG/SSP22Zn/T89FlBykvRvj1gGvn36vvJza208X2+fxvE+VYr64fToMaYI
         ob4k1xq8v5tponBWeiP91hHzlGx/yYSfwWzXx65yP4x2l6OkAsymBVvjIC31Pe7nBlpx
         05iw7tzFM0Nkgsnpjk4NUn0Kn91pB/2XrYMHeREIaFL+TFhGTKeCmmnXdeaMMOGVO7bh
         0WqmH5A0WLZY8DOw8n2/hI10jr6+e0HGes6YryYuAY1jlRl+ONvCvpHiv//7Mh/8ZdYC
         FYEw==
X-Gm-Message-State: AOAM53067/Qa/f0seemfT22nmDmR2yldyoNmTjTRJSVYVzi46JNaNE6y
        LqpBOetDCLRQMDJ+8s15VXM=
X-Google-Smtp-Source: ABdhPJzQ49XvpchTx0YTT6mdHFuY0zV1OjDTqU9eYV22H+1q52k/tpuNavHaPNg5O98DI0UZFhJFEw==
X-Received: by 2002:a17:907:1687:b0:6b5:a9f7:4eca with SMTP id hc7-20020a170907168700b006b5a9f74ecamr17895964ejc.535.1646830812441;
        Wed, 09 Mar 2022 05:00:12 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id n4-20020a056402060400b00415a1f9a4dasm779603edv.91.2022.03.09.05.00.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 05:00:11 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <bdbd5050-bce1-33db-20d1-b3023aec4df7@redhat.com>
Date:   Wed, 9 Mar 2022 14:00:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 2/7] KVM: x86: nSVM: implement nested LBR
 virtualization
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>
References: <20220301143650.143749-1-mlevitsk@redhat.com>
 <20220301143650.143749-3-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301143650.143749-3-mlevitsk@redhat.com>
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

On 3/1/22 15:36, Maxim Levitsky wrote:
> @@ -565,8 +565,19 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>   		vmcb_mark_dirty(svm->vmcb, VMCB_DR);
>   	}
>   
> -	if (unlikely(svm->vmcb01.ptr->control.virt_ext & LBR_CTL_ENABLE_MASK))
> +	if (unlikely(svm->lbrv_enabled && (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
> +
> +		/* Copy LBR related registers from vmcb12,
> +		 * but make sure that we only pick LBR enable bit from the guest.
> +		 */
> +
> +		svm_copy_lbrs(vmcb12, svm->vmcb);
> +		svm->vmcb->save.dbgctl &= LBR_CTL_ENABLE_MASK;

This should be checked against DEBUGCTL_RESERVED_BITS instead in 
__nested_vmcb_check_save; remember to add dbgctl to struct 
vmcb_save_area_cached too.

Paolo

> +		svm_update_lbrv(&svm->vcpu);
> +
> +	} else if (unlikely(svm->vmcb01.ptr->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
>   		svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
> +	}
>   }

