Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68194D301B
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 14:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbiCINl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 08:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiCINl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 08:41:58 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B9253E3F;
        Wed,  9 Mar 2022 05:40:59 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id qa43so5016208ejc.12;
        Wed, 09 Mar 2022 05:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yQPro/ZZq4Z2+zQbw1vmGDhSFsoXvhfSW1a3kVwMmqk=;
        b=T/8MMCxhNR4vgP/TTTjbmL/a765bsasToeqBrN6BhcuRTjcqRGJKShIIup6YvdvrPS
         HQSCuEBp6bXAsIF7hHf1YmhIZmUZQxXIICwr8iY8ZWDGzmaf+qKjdf+PIy8mSZfPe7yt
         C/YQ0ROdDmLYOxcVfpRQYAxuoNqfCBsIW4sKFUunOYxSNZQwGRfHRQQYnp5vv2kmKkDN
         Yodq6hqunL/FR7E4qDH0K/0bWR3TKy3WeUTnfoZsuw5YTfnD2qhAZtj1FeSNMGKfSoYw
         +0oBdC1YaybEgw6cK6L8MwfXzXCGOdp4AXW1Nk/fK7DOS3Ec0Qmob5Bl+c0ZubUkUGVD
         q4lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yQPro/ZZq4Z2+zQbw1vmGDhSFsoXvhfSW1a3kVwMmqk=;
        b=EW+flK7WhqN3eGFj5p551aTsvQ+kZxgKREp0pezkFp6vhNJTLQxUFaMkkG1u3/4HGN
         Sogv+pO8QLZn+afDSJb9Y/DtqtRtGewVaSitEQzkrHiDRC2GnKEANUsQRKyO7OHRsz/c
         6WYtYscCGvdRfuZjQveYSTaLTEta4UEBf4dn3ib5HwOaALY3qwC0QYZXV3I01HWUMS1K
         OCeVFuLMoNgDbdd4d/33rppdeRuA1NbQznK4PWkETS4R+NHVhKPhmMfCb3pwRSiwsorO
         vJS4NonjNhCY1KUHI9hGrOxriRqgUvHsEFZlfIp8ZOMBmsw/UellmIs1w4DFs70VPHf9
         aQUQ==
X-Gm-Message-State: AOAM533BRgAzhg9caHC+VUwK7Szh/oTJ0Cd3XBS9/3Y0zAb7qLRedou8
        R0oekXhf6R8JZVHFln22MlA=
X-Google-Smtp-Source: ABdhPJzeC++DqhYXBrOihICGqsNWQoBI4/fCKO1wsdxMMcQaONh1WAhbvtVefCFapK95Oq4uGdbypg==
X-Received: by 2002:a17:906:69c5:b0:6cf:d164:8b32 with SMTP id g5-20020a17090669c500b006cfd1648b32mr17827227ejs.233.1646833258157;
        Wed, 09 Mar 2022 05:40:58 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id u19-20020a17090617d300b006cea86ca384sm763785eje.40.2022.03.09.05.40.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 05:40:57 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <8c5fe4f6-49bd-c87a-e76d-64417a1370c0@redhat.com>
Date:   Wed, 9 Mar 2022 14:40:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 5/7] KVM: x86: nSVM: implement nested vGIF
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
 <20220301143650.143749-6-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220301143650.143749-6-mlevitsk@redhat.com>
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

The patch is good but I think it's possibly to rewrite some parts in an 
easier way.

On 3/1/22 15:36, Maxim Levitsky wrote:
> 
> +	if (svm->vgif_enabled && (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK))
> +		int_ctl_vmcb12_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
> +	else
> +		int_ctl_vmcb01_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);

To remember for later: svm->vmcb's V_GIF_ENABLE_MASK is always the same 
as vgif:

- if it comes from vmcb12, it must be 1 (and then vgif is also 1)

- if it comes from vmcb01, it must be equal to vgif (because 
V_GIF_ENABLE_MASK is set in init_vmcb and never touched again).

>   
> +static bool nested_vgif_enabled(struct vcpu_svm *svm)
> +{
> +	if (!is_guest_mode(&svm->vcpu) || !svm->vgif_enabled)
> +		return false;
> +	return svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK;
> +}
> +
>   static inline bool vgif_enabled(struct vcpu_svm *svm)
>   {
> -	return !!(svm->vmcb->control.int_ctl & V_GIF_ENABLE_MASK);
> +	struct vmcb *vmcb = nested_vgif_enabled(svm) ? svm->vmcb01.ptr : svm->vmcb;
> +
> +	return !!(vmcb->control.int_ctl & V_GIF_ENABLE_MASK);
>   }
>   

Slight simplification:

- before the patch, vgif_enabled() is just "vgif", because 
V_GIF_ENABLE_MASK is set in init_vmcb and copied to vmcb02

- after the patch, vgif_enabled() is also just "vgif".  Outside guest 
mode the same reasoning applies.  If L2 has enabled vGIF,  vmcb01's 
V_GIF_ENABLE is equal to vgif per the previous bullet.  If L2 has not 
enabled vGIF, vmcb02's V_GIF_ENABLE uses svm->vmcb's int_ctl field which 
is always the same as vgif (see remark above).

You can make this simplification a separate patch.

>  static inline void enable_gif(struct vcpu_svm *svm)
>  {
> +	struct vmcb *vmcb = nested_vgif_enabled(svm) ? svm->vmcb01.ptr : svm->vmcb;
> +
>  	if (vgif_enabled(svm))
> -		svm->vmcb->control.int_ctl |= V_GIF_MASK;
> +		vmcb->control.int_ctl |= V_GIF_MASK;
>  	else
>  		svm->vcpu.arch.hflags |= HF_GIF_MASK;
>  }
>  
>  static inline void disable_gif(struct vcpu_svm *svm)
>  {
> +	struct vmcb *vmcb = nested_vgif_enabled(svm) ? svm->vmcb01.ptr : svm->vmcb;
> +
>  	if (vgif_enabled(svm))
> -		svm->vmcb->control.int_ctl &= ~V_GIF_MASK;
> +		vmcb->control.int_ctl &= ~V_GIF_MASK;
>  	else
>  		svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
> +
>  }

Looks good.  For a little optimization however you could write

static inline struct vmcb *get_vgif_vmcb(struct vcpu_svm *svm)
{
	if (!vgif)
		return NULL;
	if (!is_guest_mode(&svm->vcpu)
		return svm->vmcb01.ptr;
	if ((svm->vgif_enabled && (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK))
		return svm->vmcb01.ptr;
	else
		return svm->nested.vmcb02.ptr;
}

and then

	struct vmcb *vmcb = get_vgif_vmcb(svm);
	if (vmcb)
		/* use vmcb->control.int_ctl */
	else
		/* use hflags */

Paolo

>  
> +static bool nested_vgif_enabled(struct vcpu_svm *svm)
> +{
> +	if (!is_guest_mode(&svm->vcpu) || !svm->vgif_enabled)
> +		return false;
> +	return svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK;
> +}
> +

