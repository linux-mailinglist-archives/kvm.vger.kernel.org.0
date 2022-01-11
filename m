Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0E548B791
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 20:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238819AbiAKToj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 14:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238702AbiAKTnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 14:43:00 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90208C061759
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 11:42:59 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id hv15so698923pjb.5
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 11:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/FgK5IAnk6FTMgJ52e8i7lV+7gxkfwjZm7Vn+Nisr9w=;
        b=cyRc7pebHjcqfec09Gg909vXcbxF1ItyjKOkz4RPd7uTitdC93xRVMXxRaWVXPW1F/
         6+OynK/dadT9Zax5twqvJQGuHy6WfhiYET1qpIPZFHwkBaAoDRPWPyuwxgCU9C0yNGTC
         uX+wSWZHEuAIO5uT1RYqxdJaFnWbjJBYk7yJ5oH9WMnpW2vkBrXhZtk5RkS3N2FenERI
         +MrPTpfmORE3846hdHowtS/7RNHWsZWbod3Dd+60iCXf4XlW3FL5DRxnaFPanygmO0U/
         d97tE0NvDBnWT+ZGoDV4nd0Le9apc6wyAXt1WGWNJqHk00pHWioCOvfKnxxsax/EqhZ0
         eLOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/FgK5IAnk6FTMgJ52e8i7lV+7gxkfwjZm7Vn+Nisr9w=;
        b=YytvA6k2hYdAHP5w0FZ7xuA5RPl3Pd6gTF/AyS9rbcPbOPZFw+dREOOBf/zv6i3Nj4
         dI62XXBUUO6ExcMppUJweu6w6D1AxYMdAv1BZ67GxMyHHb+5orirmg7Fs9NRQAi3lQLO
         h15wIbhgoq4CILtM2/N9N4aYYn0qH4kpYqHDoJNvlK02WEBIvID0h9sLNMAtWeKqmbQG
         B+m6W7r+usYhIalVo9irvld40K8OrBYYwHYGsthkoAcjJ0qnTvIypCFpoNGZs+Ulmhxo
         Myj01apuWljEkYGy6IKqxL6XpU7ZkkHJJE/ZtCnx+zOzCyPgdSdUmsi5DrE7N1knN/v4
         JIQg==
X-Gm-Message-State: AOAM531sy5eJ5qV6e4WX7byjIomCveTluzK3CYQ1s56ZFkHl/3IF1qba
        /xbIJYIfFwFicqUDXZiYZl+vgRTBCS4h9g==
X-Google-Smtp-Source: ABdhPJzaDuTd4GVMQuDQLn3fOUD2ETpVmwUGMlFIET+66unTNa39QrLyGOYIClARpmqJlRGFyDu8zA==
X-Received: by 2002:a17:902:a70b:b0:149:75ae:4d63 with SMTP id w11-20020a170902a70b00b0014975ae4d63mr6305902plq.50.1641930178932;
        Tue, 11 Jan 2022 11:42:58 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o11sm145586pgk.36.2022.01.11.11.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 11:42:58 -0800 (PST)
Date:   Tue, 11 Jan 2022 19:42:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org
Subject: Re: [kvm-unit-tests PATCH] arm64: debug: mark test_[bp, wp, ss] as
 noinline
Message-ID: <Yd3dvorNkP7eercw@google.com>
References: <20220111041103.2199594-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111041103.2199594-1-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022, Ricardo Koller wrote:
> Clang inlines some functions (like test_ss) which define global labels
> in inline assembly (e.g., ss_start). This results in:
> 
>     arm/debug.c:382:15: error: invalid symbol redefinition
>             asm volatile("ss_start:\n"
>                          ^
>     <inline asm>:1:2: note: instantiated into assembly here
>             ss_start:
>             ^
>     1 error generated.
> 
> Fix these functions by marking them as "noinline".
> 
> Cc: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
> This applies on top of: "[kvm-unit-tests PATCH 0/3] arm64: debug: add migration tests for debug state"
> which is in https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue.
> 
>  arm/debug.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arm/debug.c b/arm/debug.c
> index 54f059d..6c5b683 100644
> --- a/arm/debug.c
> +++ b/arm/debug.c
> @@ -264,7 +264,7 @@ static void do_migrate(void)
>  	report_info("Migration complete");
>  }
>  
> -static void test_hw_bp(bool migrate)
> +static __attribute__((noinline)) void test_hw_bp(bool migrate)

Use "noinline", which was added by commit 16431a7 ("lib: define the "noinline" macro").
