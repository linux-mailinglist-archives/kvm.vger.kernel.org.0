Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E526DE74A
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 10:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbfJUI7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 04:59:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbfJUI7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 04:59:08 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 86BA2C05168C
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 08:59:08 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id x9so545557wrq.5
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 01:59:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ydaHKAhxNtxQS4VcAKhbtvq4PL0/S2Byn9H2tf5UTNA=;
        b=CMfqnBRH0JqatlqkrK57515a5KedGJrMgWqjYDrklxSgrBtruWIJ0peEsBMv5GIK0D
         2hba67qF9wXoxpp2KCUzZrLYyMwHHeLU6e3e+ikB0FYR2YjZC5+R63Y/YjRMxdEChcdj
         XWyCEJsxrFyIPBc9a9C5uTN+mYAr6CgOxXJBTx0YEwO4bTPe1ymcSe497KlVvqI9vah7
         wtrFGwiB/NW+bLeVG8a3NOV1qWNw9UQHO9pkLj8bDJehzKnbupjdPPAFJUUT6Hak3QJZ
         QaXQPpl96AMod+v9ZD/LlEwtiGgCGElaPNBygBEvKJ7We97sVO7AaPFjeSTsUsDGzqSa
         Iebg==
X-Gm-Message-State: APjAAAUTLexYve+dSm5CqFIe2wOb+VBS4nIl9DhrOfv0aLteSFsf+t/a
        GnIGj1EDg6x83j2v5mL72j8UXA9X4rmAye/12XFYDtCHg42cFmVMGC2owYS+QFbESjVnf+PVJYi
        kGjCUPLQlaBc0
X-Received: by 2002:adf:e30a:: with SMTP id b10mr17977911wrj.44.1571648347076;
        Mon, 21 Oct 2019 01:59:07 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzvTfGD2A4X2sMdz7QRyHNFtWkUa7wDlh66llhXCckLy8S8kW8+WYi24WlZubZvheN7zmlhjg==
X-Received: by 2002:adf:e30a:: with SMTP id b10mr17977887wrj.44.1571648346781;
        Mon, 21 Oct 2019 01:59:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:566:fc24:94f2:2f13? ([2001:b07:6468:f312:566:fc24:94f2:2f13])
        by smtp.gmail.com with ESMTPSA id z9sm14958800wrl.35.2019.10.21.01.59.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 01:59:06 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: remove redundant code in kvm_arch_vm_ioctl
To:     Miaohe Lin <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1571647973-18657-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e7b65d0a-8c68-10b6-5178-decfcea54e04@redhat.com>
Date:   Mon, 21 Oct 2019 10:59:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1571647973-18657-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/19 10:52, Miaohe Lin wrote:
> If we reach here with r = 0, we will reassign r = 0
> unnecesarry, then do the label set_irqchip_out work.
> If we reach here with r != 0, then we will do the label
> work directly. So this if statement and r = 0 assignment
> is redundant. We remove them and therefore we can get rid
> of odd set_irqchip_out lable further pointed out by tglx.

While Thomas's suggestion certainly makes sense, I prefer to keep the
get and set cases similar to each other, so I queued your v1 patch.
Thanks for making the KVM code cleaner!

Paolo

> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/x86.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 661e2bf38526..cd4ca8c2f7de 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4913,13 +4913,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		}
>  
>  		r = -ENXIO;
> -		if (!irqchip_kernel(kvm))
> -			goto set_irqchip_out;
> -		r = kvm_vm_ioctl_set_irqchip(kvm, chip);
> -		if (r)
> -			goto set_irqchip_out;
> -		r = 0;
> -	set_irqchip_out:
> +		if (irqchip_kernel(kvm))
> +			r = kvm_vm_ioctl_set_irqchip(kvm, chip);
>  		kfree(chip);
>  		break;
>  	}
> 

