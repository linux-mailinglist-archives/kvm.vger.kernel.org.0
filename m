Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24E17114FC6
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 12:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbfLFLa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 06:30:56 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33489 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726102AbfLFLa4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Dec 2019 06:30:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575631855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0GVLdwTKojga49goErV7EvUaG8cPg8NjTUzdsUGd3MQ=;
        b=cB2PF24KlIDTKmPn0yJRJdg5LU5EXBEETi7qufhZxApPTIhpcN76qiAFvA8wnsU0BSejqj
        Y8RXafQyRha+61vM7ua0T8FkV1FXwC2uhf10uhwAQ9U2F7hsWqseY8RE8XTVgfNdS0bky/
        T09a8awkmcA5QgkX9ci18qP7Iv/l+hA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-RZXU7RfuNH668cDaLGCa9w-1; Fri, 06 Dec 2019 06:30:52 -0500
Received: by mail-wr1-f70.google.com with SMTP id h30so3017081wrh.5
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 03:30:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0GVLdwTKojga49goErV7EvUaG8cPg8NjTUzdsUGd3MQ=;
        b=Id8MAUkSjqXNr+GXmIB3aIicScpZu64pUnmBme7RpWs0eMgtjtEOZKN18Q5gXuyjDt
         tIEyYdiqn88q2L64pEsKDBsdMtHGXMLTqEa55hVx9V0x82hzhjbvP7BB7MvlBpD80uhM
         GQWuAN3Xrk3dB1sr31/Op0zJsGagiI0AZ+cotKf5JtIVsZbMr4L6qMYlDqPQiEmkmrlN
         1Q7W/+VYHygv02mbc30vUuqse5Ol6NUz6vIt3V7/BHeyvn+5rR5hlFrlSike2qNCrMca
         7yfOWL3D3MJprbNw/QsRQ3W2TZFkuZGteVOEvlmPB1eA3XoL4bqo50gKxAdVDEK8vYL4
         h/tw==
X-Gm-Message-State: APjAAAUyhkQPbklWMc7MqFw+fAjbMD2b9DSRhuXeavsq+c8Yb1Pa1/EW
        9sITuQdiYkD7fDhUq3h/rlqsxbyYDzYdruI0iRwdV7lDfZGrC9pXb3vOlLaWWS3GlbgPLyiXRKg
        ZrpNGw9c5J9z6
X-Received: by 2002:a7b:ce81:: with SMTP id q1mr10525965wmj.47.1575631851394;
        Fri, 06 Dec 2019 03:30:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqynRGIHlMgA8YY5/klhSTkuhxKg/Eci9pUTuMB5YYon8XwwZJQKRj44uOXurmEUTMQwmChIZw==
X-Received: by 2002:a7b:ce81:: with SMTP id q1mr10525941wmj.47.1575631851095;
        Fri, 06 Dec 2019 03:30:51 -0800 (PST)
Received: from [10.201.49.168] (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id z8sm15809068wrq.22.2019.12.06.03.30.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2019 03:30:50 -0800 (PST)
Subject: Re: [PATCH] target/i386: skip kvm_msr_entry_add when kvm_vmx_basic is
 0
To:     Catherine Ho <catherine.hecx@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Zhong, Yang" <yang.zhong@intel.com>
References: <3a1c97b2-789f-dd21-59ba-f780cf3bad92@redhat.com>
 <1575627817-24625-1-git-send-email-catherine.hecx@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9c86f277-f13c-b33d-41e5-0ed32aaf75d7@redhat.com>
Date:   Fri, 6 Dec 2019 12:30:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1575627817-24625-1-git-send-email-catherine.hecx@gmail.com>
Content-Language: en-US
X-MC-Unique: RZXU7RfuNH668cDaLGCa9w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/12/19 11:23, Catherine Ho wrote:
> Commit 1389309c811b ("KVM: nVMX: expose VMX capabilities for nested
> hypervisors to userspace") expands the msr_based_features with
> MSR_IA32_VMX_BASIC and others. Then together with an old kernel before
> 1389309c811b, the qemu call KVM_GET_MSR_FEATURE_INDEX_LIST and got the
> smaller kvm_feature_msrs. Then in kvm_arch_get_supported_msr_feature(),
> searching VMX_BASIC will be failed and return 0. At last kvm_vmx_basic
> will be assigned to 0.
> 
> Without this patch, it will cause a qemu crash (host kernel 4.15
> ubuntu 18.04+qemu 4.1):
> qemu-system-x86_64: error: failed to set MSR 0x480 to 0x0
> target/i386/kvm.c:2932: kvm_put_msrs: Assertion `ret ==
> cpu->kvm_msr_buf->nmsrs' failed.
> 
> This fixes it by skipping kvm_msr_entry_add when kvm_vmx_basic is 0
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Catherine Ho <catherine.hecx@gmail.com>
> ---
>  target/i386/kvm.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index a8c44bf..8cf84a2 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -2632,8 +2632,13 @@ static void kvm_msr_entry_add_vmx(X86CPU *cpu, FeatureWordArray f)
>                                           f[FEAT_VMX_SECONDARY_CTLS]));
>      kvm_msr_entry_add(cpu, MSR_IA32_VMX_EPT_VPID_CAP,
>                        f[FEAT_VMX_EPT_VPID_CAPS] | fixed_vmx_ept_vpid);
> -    kvm_msr_entry_add(cpu, MSR_IA32_VMX_BASIC,
> +
> +    if (kvm_vmx_basic) {
> +	/* Only add the entry when host supports it */
> +        kvm_msr_entry_add(cpu, MSR_IA32_VMX_BASIC,
>                        f[FEAT_VMX_BASIC] | fixed_vmx_basic);
> +    }
> +
>      kvm_msr_entry_add(cpu, MSR_IA32_VMX_MISC,
>                        f[FEAT_VMX_MISC] | fixed_vmx_misc);
>      if (has_msr_vmx_vmfunc) {
> 

Yang Zhong from Intel also sent a similar patch.  Thanks very much to
both of you.

Paolo

