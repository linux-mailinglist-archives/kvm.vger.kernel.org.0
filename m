Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9641E79AC
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 11:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgE2Jq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 05:46:29 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26267 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgE2Jq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 05:46:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590745587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c+leqpeTrumKeh1c2JExtWY5OXp54DEmGZGQhLJ+T4Y=;
        b=BwCHjcMKklYMYYpHI2RjPddn1fJNEbPXX1zUTtOjhbSo1sjHApYMCmqolvBv3zWQge6wNv
        mXFzoRf6cqf5sXhgF+k+aZsDnJ+uO73re62Ig4YE96Kuwxw4+BiGY29EKuq/bjONVOksdH
        HALyOBNMXUjVzPdssnE4yRR1n1laZE8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-DuW-xs_JOtqAQG7YOEgb4w-1; Fri, 29 May 2020 05:46:20 -0400
X-MC-Unique: DuW-xs_JOtqAQG7YOEgb4w-1
Received: by mail-wm1-f71.google.com with SMTP id p24so478606wmc.1
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 02:46:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c+leqpeTrumKeh1c2JExtWY5OXp54DEmGZGQhLJ+T4Y=;
        b=e+iBiO5TMpDNBendsgff8xxN7iu6JO3iYdUt/cxHbo5ylddQX8AuRq3/tMBFuqfeCp
         aSt3tHNn5dhaehlpGBKGmxiS2GLvDeIJhVXczkMQL3LvYZZgmDioH5iYfX/uIJmij2m1
         L16alitPac5S/s6AxuCwIFucMRVgZ6UC1OXM9RllVvKT8vAaLblHnXOZvakxrpBI9C3H
         A5T075T6P7ib5wqY/xoF6YDoiQ8SnFEXhzwJqPWWjbCsxKwrSfCofqDy/clljXGhYC9W
         qyTlIU4vFzZO1xEb16fJGvN2cvTpTMVYrebaa1NhuNd4aMkJCOrcjlE9zHpRgC6D+g4V
         wG3Q==
X-Gm-Message-State: AOAM53049U/G6wHq9nt4HcsXT4tB7Ir37SeaW87ETOZzxuUUrvsAnBbD
        geoeDtbRgdcn7t8tO87SkFexvEK6pNp3cVK3ziWAjFpINZ26l4wNIeMTssXO39LR8BQo5T26JBr
        7VcChzVYyzrR6
X-Received: by 2002:a05:600c:2215:: with SMTP id z21mr7899197wml.48.1590745579072;
        Fri, 29 May 2020 02:46:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMdKr+hl34UjIJs3032EJvfo8XamYkponiqVFszundSsrOqpTjDamw/Q332VY9AoQWVOVG7Q==
X-Received: by 2002:a05:600c:2215:: with SMTP id z21mr7899168wml.48.1590745578735;
        Fri, 29 May 2020 02:46:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b096:1b7:7695:e4f7? ([2001:b07:6468:f312:b096:1b7:7695:e4f7])
        by smtp.gmail.com with ESMTPSA id x24sm9590731wrd.51.2020.05.29.02.46.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 02:46:18 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Replace zero-length array with flexible-array
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200507185618.GA14831@embeddedor>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8f797bee-ec06-d1cb-b917-902769e64ab4@redhat.com>
Date:   Fri, 29 May 2020 11:46:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200507185618.GA14831@embeddedor>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/20 20:56, Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
> 
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
> 
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
> 
> sizeof(flexible-array-member) triggers a warning because flexible array
> members have incomplete type[1]. There are some instances of code in
> which the sizeof operator is being incorrectly/erroneously applied to
> zero-length arrays and the result is zero. Such instances may be hiding
> some bugs. So, this work (flexible-array member conversions) will also
> help to get completely rid of those sorts of issues.
> 
> This issue was found with the help of Coccinelle.
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  arch/x86/kvm/vmx/vmcs.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
> index 481ad879197b..5c0ff80b85c0 100644
> --- a/arch/x86/kvm/vmx/vmcs.h
> +++ b/arch/x86/kvm/vmx/vmcs.h
> @@ -19,7 +19,7 @@ struct vmcs_hdr {
>  struct vmcs {
>  	struct vmcs_hdr hdr;
>  	u32 abort;
> -	char data[0];
> +	char data[];
>  };
>  
>  DECLARE_PER_CPU(struct vmcs *, current_vmcs);
> 

Queued, thanks.

Paolo

