Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF4D39C2A4
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 23:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhFDVmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 17:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbhFDVl7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 17:41:59 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6738C061767
        for <kvm@vger.kernel.org>; Fri,  4 Jun 2021 14:40:12 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id u18so8365235pfk.11
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 14:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Apz9kADdS6tO9dIKRnFDk6v5kyO/H66ieysUGAxyWHU=;
        b=owVZHgOfWuJ+odAefuXoSXdTWiMsc30DXpTmzfwjNRy/J+Z0bRSeXBD0/FmlSa4HtH
         W3x6+0RdLTtJRjV3mUXAt7TP+z7mWMlkYF2Nv4HTZeLIX2T+ifeoHLB4/zL9FOxL/Plh
         BK3oq30Gy/V7LLxMEXQGUwxyzffAZnY17Mx+q3y8i5ey2URI3u6TtnoBx73XX/+LHuoU
         D74aa36AIyWXzSTndHqglW5T4tWTCQhMMjj6AjVwOYkzaCV30h9jHDhPckrQMK0fznZk
         pDnRSm25nF1le61VWpRb9Pebsv3z86pTazl9Vs8ds8qHFJkSTXXbv2aBhJcJcRMc7xTv
         AnsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Apz9kADdS6tO9dIKRnFDk6v5kyO/H66ieysUGAxyWHU=;
        b=R1jVjY+91uyiEoCZ75ETqlLcAXiUzRCZFhfynyqgq7Bw/v/OWICtgQlcmW3os/zpJ2
         ITuxFJhOPn+jelMOut7h2oKgLYwWV5WGldVgQAo6MLAKDBnaNx/AwY/pZHB6d95ecL15
         aFdP9X3GEyHgMT2N+g81MLkIQetoVgPHr7DnYVpl3xtwlQgRPPqciThwE1WzTwckWyFZ
         YsnQIhLNjNWywv05WFp/qT9yem1xP6VAYIb7sTqEhfoclJ6PH7IMyBStLeQkMbXZ2mKm
         i4cEnZ4nFEE9TJBDsm/tMz/s1by+KsAjhNZw818v+Ha/EjvfM5GG+UScY68d04crO9gD
         NWQw==
X-Gm-Message-State: AOAM533V45AVhB55vW37VH2TR3xyBtSD2zSSpW/+epvRW8CH2LSELuTc
        CsnLtCoX5R9mNK1xXTYMwoCgWFeNWjvBqQ==
X-Google-Smtp-Source: ABdhPJz/LsdYhFPkB/Il9Z8Ij1iw0sNIyu7LcJdxvHUcoFG67Qi3mg+g9kqJJm/ctmZtYmPZXlZ3LA==
X-Received: by 2002:a65:4948:: with SMTP id q8mr6900890pgs.375.1622842812142;
        Fri, 04 Jun 2021 14:40:12 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id t17sm5097309pji.9.2021.06.04.14.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 14:40:11 -0700 (PDT)
Date:   Fri, 4 Jun 2021 21:40:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Subject: Re: [kvm-unit-tests PATCH V2] x86: Add a test to check effective
 permissions
Message-ID: <YLqdt11W6R4FgoIY@google.com>
References: <YLkh3bQ106M9nV3k@google.com>
 <20210603225851.26621-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603225851.26621-1-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 04, 2021, Lai Jiangshan wrote:
> @@ -326,6 +335,7 @@ static pt_element_t ac_test_alloc_pt(ac_pool_t *pool)
>  {
>      pt_element_t ret = pool->pt_pool + pool->pt_pool_current;
>      pool->pt_pool_current += PAGE_SIZE;
> +    memset(va(ret), 0, PAGE_SIZE);

Should this go in a separate patch?  This seems like a bug fix.

>      return ret;
>  }
>  
> +static int check_effective_sp_permissions(ac_pool_t *pool)
> +{
> +	unsigned long ptr1 = 0x123480000000;
> +	unsigned long ptr2 = ptr1 + 2 * 1024 * 1024;
> +	unsigned long ptr3 = ptr1 + 1 * 1024 * 1024 * 1024;
> +	unsigned long ptr4 = ptr3 + 2 * 1024 * 1024;

I belatedly remembered we have SZ_2M and SZ_1G, I think we can use those here
instead of open coding the math.
