Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060DE72E37A
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 14:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240639AbjFMM5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 08:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241003AbjFMM5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 08:57:40 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8617A191;
        Tue, 13 Jun 2023 05:57:37 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b203360d93so67438251fa.3;
        Tue, 13 Jun 2023 05:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686661056; x=1689253056;
        h=content-transfer-encoding:in-reply-to:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XeFbrqjcv72tXKY+nTQZPqYsLbKLXvzDbqnXIJWbTaI=;
        b=F8VnRb8baWHgKP7PGJySntfa4HuH266ABbFf9nId1exOyhM/HnnQ/GywEd0BxhfGHu
         X+luqaQSHaFKkz1nXryWggrcRnyk+KUEytNhbL6ujbuN6Wi7hS+9PUmXykJz6BUUNSMc
         9BAKSdiAzBDZVwqMvhzHJRovQ6NmXSRibBDtOnER+gnqh03i+9/ivgzNOWlvXlGhGpBG
         POOMoB+I3FweB+xZvaCgAUWBaL76Z6t98IcdTiKOmvBtAVNxBi2xprk/qzjXw4anLsmO
         Hd1h4rEz9BCi8Iqch0RFz8FQAnX6d46OFwT02Bwt50ZCv+YtKZDH8qrEpSRWEbxReAoa
         INzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686661056; x=1689253056;
        h=content-transfer-encoding:in-reply-to:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XeFbrqjcv72tXKY+nTQZPqYsLbKLXvzDbqnXIJWbTaI=;
        b=fP04zqp1nudxwX8vsSNKGN/9vV0g8yzj6GKvuQlY5waJwf31c4LNqnApNqQg0StZPv
         XjeSV9iCp25S+ZLuPW5jyssOLduBeSBrgP+q2glny4YyyZfOV7F/DvOxQuERNnYVhsiE
         xThxBAB1qgovH3aIEDfMyy9eB6Ji+XuELBgW1Cwsgm7sdO2sV6l2GKGP0rzEvCw9yqZ/
         dO26GJxwypERpXJjO33hYi3DyLfNGb7HpFHroB6RlxBmSJbjVfxT9qN8MZdjnvgVhraS
         ejOjXCJJEtjowo9w6+JSMlWUx0+IDfoLjjPIDsRpiNBO5T5kTW+4jW5D1Cbn2O5wltDo
         LHCA==
X-Gm-Message-State: AC+VfDxAAcmFGPXVN7BqaLiUdHrRIiZGUVm/2rnJDtAwGgo8bMNGwHUY
        aBZTcd9c+9J66mSJepA2giRSazAYNalFBs9KPQM=
X-Google-Smtp-Source: ACHHUZ58fdvqqZGzZ2BJ69HvjsawvXZXVqX8mWvk/TZrT9Ybw87KzskU5alAos2BM+DSCl/BlFmKEw==
X-Received: by 2002:a2e:241a:0:b0:2b1:e958:efa0 with SMTP id k26-20020a2e241a000000b002b1e958efa0mr3743952ljk.50.1686661055572;
        Tue, 13 Jun 2023 05:57:35 -0700 (PDT)
Received: from ?IPV6:2a0b:6204:4302:5f00:4dab:3483:4506:9a0e? ([2a0b:6204:4302:5f00:4dab:3483:4506:9a0e])
        by smtp.gmail.com with ESMTPSA id r7-20020a2eb607000000b0029c96178425sm2165663ljn.19.2023.06.13.05.57.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 05:57:35 -0700 (PDT)
From:   "bibo, mao" <bibo.mao@gmail.com>
X-Google-Original-From: "bibo, mao" <maobibo@loongson.cn>
Message-ID: <5442b28a-12d9-bacb-3983-ad4cc0c79689@loongson.cn>
Date:   Tue, 13 Jun 2023 20:57:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v13 10/30] LoongArch: KVM: Implement vcpu ENABLE_CAP ioctl
 interface
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>, tangyouling@loongson.cn,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20230609090832.2131037-1-zhaotianrui@loongson.cn>
 <20230609090832.2131037-11-zhaotianrui@loongson.cn>
In-Reply-To: <20230609090832.2131037-11-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Bibo Mao <maobibo@loongson.cn>

Regards
Bibo, Mao

在 2023/6/9 17:08, Tianrui Zhao 写道:
> Implement LoongArch vcpu KVM_ENABLE_CAP ioctl interface.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>   arch/loongarch/kvm/vcpu.c | 19 +++++++++++++++++++
>   1 file changed, 19 insertions(+)
> 
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index b0cce413762d..da97b77da8eb 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -186,6 +186,16 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>   	return 0;
>   }
>   
> +static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
> +				     struct kvm_enable_cap *cap)
> +{
> +	/*
> +	 * FPU is enable by default, do not support any other caps,
> +	 * and later we will support such as LSX cap.
> +	 */
> +	return -EINVAL;
> +}
> +
>   long kvm_arch_vcpu_ioctl(struct file *filp,
>   			 unsigned int ioctl, unsigned long arg)
>   {
> @@ -209,6 +219,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   			r = _kvm_get_reg(vcpu, &reg);
>   		break;
>   	}
> +	case KVM_ENABLE_CAP: {
> +		struct kvm_enable_cap cap;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&cap, argp, sizeof(cap)))
> +			break;
> +		r = kvm_vcpu_ioctl_enable_cap(vcpu, &cap);
> +		break;
> +	}
>   	default:
>   		r = -ENOIOCTLCMD;
>   		break;
