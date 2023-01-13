Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755E466980A
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 14:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241766AbjAMNHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 08:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241665AbjAMNG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 08:06:59 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151F611A;
        Fri, 13 Jan 2023 04:55:11 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id o7so22029732ljj.8;
        Fri, 13 Jan 2023 04:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xalR/ir655qeRseiVE4P585Bye5lQQNNDDYwDuo4SIE=;
        b=oh6ybk8PhTUWE92m+MMPdFdxpV7LuNfsUuGykNvGYkohtJVS0fkgJryO2HwUN6UF6G
         ZUIVUhnu9N+KHSwq30U0kMzoWmkFjN3U0w0xr9QTjKkDLX5nfMM1WAyCKPPLRTl0GAre
         BL0GNqJVoLD7DQrALmVM2ikl2lvOoOChVsyToKFO1W9ZPN4O2kAGAREIFwFbCTvi33CH
         YUhwDGn7K7/8gXstCOKwVUGWl7/ES9x12fi0kwQCECe541u9WIrccixMD82xq9mhn/vN
         E6clG8po+YLLkGVsk1YwgOFsxtg1x9Yw4K2u1oTKr4+HrlhyA1nAPQjcZR2lQtPAPTrU
         RC1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xalR/ir655qeRseiVE4P585Bye5lQQNNDDYwDuo4SIE=;
        b=DfJhII4E+DpoMO3n3pXko/2AmrPm/3hC6/Ll+CNknIZjRDSoos8tA6U9J7SufLYUiE
         FidjH4GXwZeBBeOYK8fnIex0ByJTxVQoFuVCBSiMbYdtQ8yz3A7JQnyd/DNEOmcaoQGo
         lypKRBvYfgZl8ozoLFFIvHfyi0k7veMCBwFiUcw64VZM1c29DcvC1FqaFRojDaNC8lMW
         fn5zTzzwIss4rRR0w8ZmhFzoeomtsJkvxKQtYKt6XsFUXonqZ+51tqsEkLQfoYWfBl/f
         cWMpYzNN/9ceFwI3ez3vFCsxTo6BgIgGgP6dkgZz/xL8f/GbKQqNuycKFMcHzhg1XDiS
         Yj9Q==
X-Gm-Message-State: AFqh2kqFl6X41NwWXjYsVr0V/qZhfdoGgsOGVFhwD9UA8JmtBAzx/S4V
        zj1UWnsTXQEER6VthiKhlNFSRlW2fSU=
X-Google-Smtp-Source: AMrXdXu3v6yClWLc1DVZ1oit56eWJfk3iMrEBisr4S2fQ+/vRjdI/U8Qu58rqoSCsDrt0JI1ntBElw==
X-Received: by 2002:a05:651c:1955:b0:281:bff:3667 with SMTP id bs21-20020a05651c195500b002810bff3667mr3209414ljb.1.1673614509135;
        Fri, 13 Jan 2023 04:55:09 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id g17-20020a2eb5d1000000b0027fd93e9043sm2528210ljn.113.2023.01.13.04.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 04:55:08 -0800 (PST)
Date:   Fri, 13 Jan 2023 14:55:07 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v11 017/113] KVM: Support KVM_CAP_MAX_VCPUS for
 KVM_ENABLE_CAP
Message-ID: <20230113145507.0000115c@gmail.com>
In-Reply-To: <01e061779b88ce4d32bbe483ed2bd3224cd8e330.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
        <01e061779b88ce4d32bbe483ed2bd3224cd8e330.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Jan 2023 08:31:25 -0800
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX attestation includes the maximum number of vcpu that the guest can
> accommodate.  For that, the maximum number of vcpu needs to be specified
> instead of constant, KVM_MAX_VCPUS.  Make KVM_ENABLE_CAP support
> KVM_CAP_MAX_VCPUS.
> 
> Suggested-by: Sagi Shahar <sagis@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  virt/kvm/kvm_main.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a235b628b32f..1cfa7da92ad0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4945,7 +4945,27 @@ static int kvm_vm_ioctl_enable_cap_generic(struct
> kvm *kvm, }
>  
>  		mutex_unlock(&kvm->slots_lock);
> +		return r;
> +	}
> +	case KVM_CAP_MAX_VCPUS: {

Better mention the KVM_CAP_MAX_VCPUS defined in XXX patch in the comments.

> +		int r;
>  
> +		if (cap->flags || cap->args[0] == 0)
> +			return -EINVAL;
> +		if (cap->args[0] >  kvm_vm_ioctl_check_extension(kvm,
> KVM_CAP_MAX_VCPUS))
> +			return -E2BIG;
> +
> +		mutex_lock(&kvm->lock);
> +		/* Only decreasing is allowed. */
> +		if (cap->args[0] > kvm->max_vcpus)
> +			r = -E2BIG;
> +		else if (kvm->created_vcpus)
> +			r = -EBUSY;
> +		else {
> +			kvm->max_vcpus = cap->args[0];
> +			r = 0;
> +		}
> +		mutex_unlock(&kvm->lock);
>  		return r;
>  	}
>  	default:

