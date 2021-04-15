Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83ACB360B96
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 16:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbhDOOOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 10:14:31 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:53088 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbhDOOO3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 10:14:29 -0400
Received: by mail-wm1-f45.google.com with SMTP id y204so11165737wmg.2;
        Thu, 15 Apr 2021 07:14:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hz1ZY9HWxRoofHmlH+XWpgXg6c/7rbXj8kFMXTJUiXE=;
        b=tjLQUD2dfF+TL5y6KmArEWZx+pHJJbT1aZ3cLHWdsF0JCK6dMa4eJUSMssMK19hvc3
         TOBGtjq9X8eFfP58y7RA5JWl7tFJU+SwDuMJckSilh6PnJMcKTrBUXGD+2CMf6oRBgA4
         fZOEf9t161iPaIMYhEw6w/7NbUqFhsamxheUhdbfcXLAncX9KXf0GsoT6Tl99XP5HslH
         RA5WrjjpyBoEjwNFwmDqtNZ/Ib6Y56rwmVe53fB9yjRTMd6oUV/+CFg26dsJv7TtcKg6
         YKo7f8oJ4Dmk1ywf+s0IlGAfGF43WnW7abpaGOuazk1Lkn6a6gRmyrBfuQyIWaywM36s
         J54w==
X-Gm-Message-State: AOAM5323HewuuEMHcuEeNWbgFI6SMdIFckZc7mShSv4AjDMnVwEKWQOu
        jeBXNmeRHcN+TvGmmPlXtXY=
X-Google-Smtp-Source: ABdhPJwRJ+quRmCDl1pvKPCwx18Jq+JqjVXi9jMcrkxPA4UL5EwVUWMch3ilw837jkMX1O4b+f4iog==
X-Received: by 2002:a7b:c195:: with SMTP id y21mr3405656wmi.178.1618496045398;
        Thu, 15 Apr 2021 07:14:05 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id v18sm2798213wmh.28.2021.04.15.07.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 07:14:04 -0700 (PDT)
Date:   Thu, 15 Apr 2021 14:14:03 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH RFC 01/22] asm-generic/hyperv: add
 HV_STATUS_ACCESS_DENIED definition
Message-ID: <20210415141403.hftsza3ucrf262tq@liuwe-devbox-debian-v2>
References: <20210413122630.975617-1-vkuznets@redhat.com>
 <20210413122630.975617-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413122630.975617-2-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 13, 2021 at 02:26:09PM +0200, Vitaly Kuznetsov wrote:
> From TLFSv6.0b, this status means: "The caller did not possess sufficient
> access rights to perform the requested operation."
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

This can be applied to hyperv-next right away. Let me know what you
think.

Wei.

> ---
>  include/asm-generic/hyperv-tlfs.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
> index 83448e837ded..e01a3bade13a 100644
> --- a/include/asm-generic/hyperv-tlfs.h
> +++ b/include/asm-generic/hyperv-tlfs.h
> @@ -187,6 +187,7 @@ enum HV_GENERIC_SET_FORMAT {
>  #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
>  #define HV_STATUS_INVALID_ALIGNMENT		4
>  #define HV_STATUS_INVALID_PARAMETER		5
> +#define HV_STATUS_ACCESS_DENIED			6
>  #define HV_STATUS_OPERATION_DENIED		8
>  #define HV_STATUS_INSUFFICIENT_MEMORY		11
>  #define HV_STATUS_INVALID_PORT_ID		17
> -- 
> 2.30.2
> 
