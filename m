Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8F9B53DB
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 19:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730876AbfIQRSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 13:18:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46529 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730851AbfIQRSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 13:18:37 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C41AC049E10
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 17:18:36 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id z205so1508080wmb.7
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 10:18:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CzdzjDs1PS5s1r26tWjnHvjUliGuiGe3yhX4kLQL7+c=;
        b=Weltwlgf7xKrEMi8MQKTbGlAs5hee+i4jxsKiWRAxm858TLhGyhQc6W5s5J8fbRX8O
         iENqwHaX7S343ok/FPZJm4erOLr66crGvTeefIyzSvlTIaXQMgfwzea5mO3G6B/VTCkw
         SyN7g0vd2wA9d/n23TGSGFr8ERXP6P9ZCJAxncCFHe8WwWM8752lB27fCI7DJC88qhMb
         hDdTCEq1PAUzQFALeMI/B8kXpevUfTlzarXYhkV4CHEXEwxGc/AWIfHTXijKgM0d5vzn
         d+sAWdsYfO8Rp2rDG/i7NroreY26PDThWRJgLc4N9DwTClp1tD278pkZDtOkzSgil+hq
         AWOw==
X-Gm-Message-State: APjAAAXjBDq8o2r+eXtAuB0g2wFj9e5nXt2Z1CRtqbh0ay2ciI79PyL9
        f//VXBSnjqoGmom+M8BNKOZWHPrgH9pCugtkjTI7890MLNwUhn8jPnIQ+DxcvQ6zp65or5puLqI
        aWKA3PwbSMZi2
X-Received: by 2002:a05:600c:2052:: with SMTP id p18mr4341225wmg.13.1568740714968;
        Tue, 17 Sep 2019 10:18:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyZJ8SQPxCUeDeSltgjjv/+2lWN6pyzNKs4z2B/WxLTQIkeThwpFZrZjf+Y9TYVkv4mFihBKg==
X-Received: by 2002:a05:600c:2052:: with SMTP id p18mr4341206wmg.13.1568740714697;
        Tue, 17 Sep 2019 10:18:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id s12sm4981466wra.82.2019.09.17.10.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2019 10:18:34 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Use DEFINE_DEBUGFS_ATTRIBUTE for debugfs files
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        up2wing@gmail.com, wang.liang82@zte.com.cn,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1563780839-14739-1-git-send-email-wang.yi59@zte.com.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <31eec57f-2bc8-0ea0-e5fb-6b21ce902aae@redhat.com>
Date:   Tue, 17 Sep 2019 19:18:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1563780839-14739-1-git-send-email-wang.yi59@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/07/19 09:33, Yi Wang wrote:
> We got these coccinelle warning:
> ./arch/x86/kvm/debugfs.c:23:0-23: WARNING: vcpu_timer_advance_ns_fops
> should be defined with DEFINE_DEBUGFS_ATTRIBUTE
> ./arch/x86/kvm/debugfs.c:32:0-23: WARNING: vcpu_tsc_offset_fops should
> be defined with DEFINE_DEBUGFS_ATTRIBUTE
> ./arch/x86/kvm/debugfs.c:41:0-23: WARNING: vcpu_tsc_scaling_fops should
> be defined with DEFINE_DEBUGFS_ATTRIBUTE
> ./arch/x86/kvm/debugfs.c:49:0-23: WARNING: vcpu_tsc_scaling_frac_fops
> should be defined with DEFINE_DEBUGFS_ATTRIBUTE
> 
> Use DEFINE_DEBUGFS_ATTRIBUTE() rather than DEFINE_SIMPLE_ATTRIBUTE()
> to fix this.
> 
> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>

It sucks though that you have to use a function with "unsafe" in the name.

Greg, is the patch doing the right thing?

Paolo

> ---
>  arch/x86/kvm/debugfs.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
> index 329361b..24016fb 100644
> --- a/arch/x86/kvm/debugfs.c
> +++ b/arch/x86/kvm/debugfs.c
> @@ -20,7 +20,7 @@ static int vcpu_get_timer_advance_ns(void *data, u64 *val)
>  	return 0;
>  }
>  
> -DEFINE_SIMPLE_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_advance_ns, NULL, "%llu\n");
> +DEFINE_DEBUGFS_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_advance_ns, NULL, "%llu\n");
>  
>  static int vcpu_get_tsc_offset(void *data, u64 *val)
>  {
> @@ -29,7 +29,7 @@ static int vcpu_get_tsc_offset(void *data, u64 *val)
>  	return 0;
>  }
>  
> -DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_offset_fops, vcpu_get_tsc_offset, NULL, "%lld\n");
> +DEFINE_DEBUGFS_ATTRIBUTE(vcpu_tsc_offset_fops, vcpu_get_tsc_offset, NULL, "%lld\n");
>  
>  static int vcpu_get_tsc_scaling_ratio(void *data, u64 *val)
>  {
> @@ -38,7 +38,7 @@ static int vcpu_get_tsc_scaling_ratio(void *data, u64 *val)
>  	return 0;
>  }
>  
> -DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_fops, vcpu_get_tsc_scaling_ratio, NULL, "%llu\n");
> +DEFINE_DEBUGFS_ATTRIBUTE(vcpu_tsc_scaling_fops, vcpu_get_tsc_scaling_ratio, NULL, "%llu\n");
>  
>  static int vcpu_get_tsc_scaling_frac_bits(void *data, u64 *val)
>  {
> @@ -46,20 +46,20 @@ static int vcpu_get_tsc_scaling_frac_bits(void *data, u64 *val)
>  	return 0;
>  }
>  
> -DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bits, NULL, "%llu\n");
> +DEFINE_DEBUGFS_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bits, NULL, "%llu\n");
>  
>  int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
>  {
>  	struct dentry *ret;
>  
> -	ret = debugfs_create_file("tsc-offset", 0444,
> +	ret = debugfs_create_file_unsafe("tsc-offset", 0444,
>  							vcpu->debugfs_dentry,
>  							vcpu, &vcpu_tsc_offset_fops);
>  	if (!ret)
>  		return -ENOMEM;
>  
>  	if (lapic_in_kernel(vcpu)) {
> -		ret = debugfs_create_file("lapic_timer_advance_ns", 0444,
> +		ret = debugfs_create_file_unsafe("lapic_timer_advance_ns", 0444,
>  								vcpu->debugfs_dentry,
>  								vcpu, &vcpu_timer_advance_ns_fops);
>  		if (!ret)
> @@ -67,12 +67,12 @@ int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
>  	}
>  
>  	if (kvm_has_tsc_control) {
> -		ret = debugfs_create_file("tsc-scaling-ratio", 0444,
> +		ret = debugfs_create_file_unsafe("tsc-scaling-ratio", 0444,
>  							vcpu->debugfs_dentry,
>  							vcpu, &vcpu_tsc_scaling_fops);
>  		if (!ret)
>  			return -ENOMEM;
> -		ret = debugfs_create_file("tsc-scaling-ratio-frac-bits", 0444,
> +		ret = debugfs_create_file_unsafe("tsc-scaling-ratio-frac-bits", 0444,
>  							vcpu->debugfs_dentry,
>  							vcpu, &vcpu_tsc_scaling_frac_fops);
>  		if (!ret)
> 

