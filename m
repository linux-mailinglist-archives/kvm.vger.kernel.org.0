Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91A930A3EE
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 10:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhBAJDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 04:03:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25360 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232658AbhBAJC6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 04:02:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612170074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q2S7KmoEGwvcciLJxV74TxOXB1pGheiXKnwkSrkdCOg=;
        b=fB4TeXiE/EggQBqSFCr4bNT0XvGhgHQRtgOAcxVHQJFcsSyqMnqnPc6+EEWRBodr/o1o5k
        q180nFeRe2ianjVZu7hJxO6xSqRQOxmgxf2ZMzJ1mJ4RGt1itsrct7AuMxRWGl9zRD6gRN
        YbIu0LcqjC+JtizDjDI1T0SQdDO1i18=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-66RPsVmWPVaTWpvJsFCwgg-1; Mon, 01 Feb 2021 04:01:13 -0500
X-MC-Unique: 66RPsVmWPVaTWpvJsFCwgg-1
Received: by mail-ej1-f72.google.com with SMTP id ia14so210030ejc.8
        for <kvm@vger.kernel.org>; Mon, 01 Feb 2021 01:01:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q2S7KmoEGwvcciLJxV74TxOXB1pGheiXKnwkSrkdCOg=;
        b=pTytD907j3W0lR43XEvJIVAW49yZZ8rI4n/wtSmHn0XusQaWvyNJ8VjGl+ip0EH7cZ
         JCLTIwOz0pFwkWdkG5r4TqxB2/UirFbJe4Jc1tsQY9ko7g69SXsxSueNaHc72J/9ob6T
         7R6vFmn8YEOzHXnvTmyrY5w17Kxxbsb6i4c+y4+RC2AZqRRXIi/G5KfsyCBbfSGobB8g
         ODPLGAXyDdADoGCo1++0OuJ2U0hyum1tMI7Qb7YSEP+kQC7/qI70hXUWHE4WtUG/9XBi
         /XYBIhZgNhEwZ2mR3fPdGU2VJl/HT9hOWW2GQfJ2pvGKeMV9ZjyVw1Y8hScG8KYTwYj7
         xajg==
X-Gm-Message-State: AOAM530CbGyLgA02Iyv58gLmH+2rlHbK4Czrg0oRhEX4zYL5XbAL9QT0
        PUJ0oPp85K989sqBbnrn6uIm4MAjjNwmZH8O+X73SYTSC5neXyQReHUQqj9gE3pt2bxmVygY2ru
        w02X8R6A4Tvtc
X-Received: by 2002:a50:a684:: with SMTP id e4mr17453434edc.148.1612170071981;
        Mon, 01 Feb 2021 01:01:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwv4bkf41HeR2HEB6dyR4YTrLaPrlywE4fQjlcW01Bm3fjf+ciYSoGvNn60FwB2kKz+0Da0SA==
X-Received: by 2002:a50:a684:: with SMTP id e4mr17453413edc.148.1612170071789;
        Mon, 01 Feb 2021 01:01:11 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r22sm8252880edp.9.2021.02.01.01.01.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 01:01:10 -0800 (PST)
Subject: Re: [PATCH] KVM: Replace DEFINE_SIMPLE_ATTRIBUTE with
 DEFINE_DEBUGFS_ATTRIBUTE
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1612168685-33799-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <47e26d54-7663-656e-1033-5e161848c274@redhat.com>
Date:   Mon, 1 Feb 2021 10:01:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1612168685-33799-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/21 09:38, Jiapeng Chong wrote:
> Fix the following coccicheck warning:
> 
> ./arch/x86/kvm/debugfs.c:44:0-23: WARNING: vcpu_tsc_scaling_frac_fops
> should be defined with DEFINE_DEBUGFS_ATTRIBUTE.
> 
> ./arch/x86/kvm/debugfs.c:36:0-23: WARNING: vcpu_tsc_scaling_fops should
> be defined with DEFINE_DEBUGFS_ATTRIBUTE.
> 
> ./arch/x86/kvm/debugfs.c:27:0-23: WARNING: vcpu_tsc_offset_fops should
> be defined with DEFINE_DEBUGFS_ATTRIBUTE.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>   arch/x86/kvm/debugfs.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
> index 7e818d6..9c0e29e 100644
> --- a/arch/x86/kvm/debugfs.c
> +++ b/arch/x86/kvm/debugfs.c
> @@ -15,7 +15,7 @@ static int vcpu_get_timer_advance_ns(void *data, u64 *val)
>   	return 0;
>   }
>   
> -DEFINE_SIMPLE_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_advance_ns, NULL, "%llu\n");
> +DEFINE_DEBUGFS_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_advance_ns, NULL, "%llu\n");
>   
>   static int vcpu_get_tsc_offset(void *data, u64 *val)
>   {
> @@ -24,7 +24,7 @@ static int vcpu_get_tsc_offset(void *data, u64 *val)
>   	return 0;
>   }
>   
> -DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_offset_fops, vcpu_get_tsc_offset, NULL, "%lld\n");
> +DEFINE_DEBUGFS_ATTRIBUTE(vcpu_tsc_offset_fops, vcpu_get_tsc_offset, NULL, "%lld\n");
>   
>   static int vcpu_get_tsc_scaling_ratio(void *data, u64 *val)
>   {
> @@ -33,7 +33,7 @@ static int vcpu_get_tsc_scaling_ratio(void *data, u64 *val)
>   	return 0;
>   }
>   
> -DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_fops, vcpu_get_tsc_scaling_ratio, NULL, "%llu\n");
> +DEFINE_DEBUGFS_ATTRIBUTE(vcpu_tsc_scaling_fops, vcpu_get_tsc_scaling_ratio, NULL, "%llu\n");
>   
>   static int vcpu_get_tsc_scaling_frac_bits(void *data, u64 *val)
>   {
> @@ -41,7 +41,8 @@ static int vcpu_get_tsc_scaling_frac_bits(void *data, u64 *val)
>   	return 0;
>   }
>   
> -DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bits, NULL, "%llu\n");
> +DEFINE_DEBUGFS_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bits,
> +			  NULL, "%llu\n");
>   
>   void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
>   {
> 

If you wanted to do this, you would have to use 
debugfs_create_file_unsafe() as well.

In practice, nobody does that because it's not a performance-sensitive 
path and it's not worth the maintenance cost of using a less safe API.

Paolo

