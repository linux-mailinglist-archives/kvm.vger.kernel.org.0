Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81C3481DDA
	for <lists+kvm@lfdr.de>; Thu, 30 Dec 2021 16:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240069AbhL3PwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Dec 2021 10:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbhL3PwU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Dec 2021 10:52:20 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3591BC061574
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 07:52:20 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id g2so21732751pgo.9
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 07:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rg3Dw7HIQNkZ4tMVuCk4rJ0vvorTfQcRD/7VUe4E9/c=;
        b=O3tcfLurCO23R2bKQDETuq3OV4xrR/pOReu8NmFvHPrY1AhyeH8V5a+NFksqpoKClz
         wFKen2ZUV1V7YV3TE/AKugDdDAnMBYlOKOg8dEH1I73TyordxrFENlxicWIjZHJOaAbB
         0JIlMSvyhwa0I9zKVQQ+Q3g8n+sla2dEsT8c2n1EnJ3I/t77mAhKVvWPktr7VQHtsnsE
         OLjqVXKpzCZJQ7+r49rq44VHlwtRwxNMnOSB0zv2GX86NM19zNL5Oc339wX7UZWmdAjG
         MAknHiOt4Ia7PejqG4L1jD68wQIoElIxSZbRxfDHQ7NqM3ro/5oes0dLsZ85v/YPWdbt
         FpcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rg3Dw7HIQNkZ4tMVuCk4rJ0vvorTfQcRD/7VUe4E9/c=;
        b=vioPYxcrmt+axpOA7ZOfHvZPJX4D6ajTpQX2igu86D5u1r9g9sRYi4TWW9zh4yXbHW
         PwjSUF9mmqi0sd1902B67Mzm3f3d2gqrkGFubq/4rKNo7m1K8KhqJ2me3lYZHRmkWeBP
         WXJRKVe2hf/3qzMyUQcNIUJKt5a8pQuOWk7UlmNWI9UKH+0vE2j4kKth+y3I3Ki3ojpG
         kbRIKKgqq4oEMAS05pCgyEUl2dXvNRy5MirUFiU9LT8Zc4NZ0c0KtSZLmO9voV10z1Gl
         CPxn5COWiQGLIVaquUKd587lTs3A/UVnE9cBEfEjEOQQ5om1PJBKaYmmWeArMI/EiPJ/
         N9fA==
X-Gm-Message-State: AOAM531lT6pKqLWDW9m10pPfSAKwHTbr2vGb/4v2iEtHVsSE5r19gfSx
        dWMq7VcnPTnIRNicyLv3y1qf587BUcKeeg==
X-Google-Smtp-Source: ABdhPJxg4B9KPNYWT8sBF5Z6jZ4JvWECc6PFiAC2Ps6Cmv0ZvzyT+jsNfBFvWwXu891WU+ykKw0agA==
X-Received: by 2002:a63:2bc1:: with SMTP id r184mr27602524pgr.426.1640879539588;
        Thu, 30 Dec 2021 07:52:19 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d1sm28881603pfj.90.2021.12.30.07.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 07:52:18 -0800 (PST)
Date:   Thu, 30 Dec 2021 15:52:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zhenzhong Duan <zhenzhong.duan@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH] x86: Assign a canonical address before
 execute invpcid
Message-ID: <Yc3VryxgJbXXwyy3@google.com>
References: <20211230101452.380581-1-zhenzhong.duan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211230101452.380581-1-zhenzhong.duan@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 30, 2021, Zhenzhong Duan wrote:
> Occasionally we see pcid test fail as INVPCID_DESC[127:64] is
> uninitialized before execute invpcid.
> 
> According to Intel spec: "#GP If INVPCID_TYPE is 0 and the linear
> address in INVPCID_DESC[127:64] is not canonical."
> 
> Assign desc's address which is guaranteed to be a real memory
> address and canonical.
> 
> Fixes: b44d84dae10c ("Add PCID/INVPCID test")
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> ---
>  x86/pcid.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/x86/pcid.c b/x86/pcid.c
> index 527a4a9..4828bbc 100644
> --- a/x86/pcid.c
> +++ b/x86/pcid.c
> @@ -75,6 +75,9 @@ static void test_invpcid_enabled(int pcid_enabled)
>      struct invpcid_desc desc;
>      desc.rsv = 0;
>  
> +    /* Initialize INVPCID_DESC[127:64] with a canonical address */
> +    desc.addr = (u64)&desc;

Casting to a u64 is arguably wrong since the address is an unsigned long.  It
doesn't cause problems because the test is 64-bit only, but it's a bit odd.

What about just replacing "desc.rsv = 0" with "memset(&desc, 0, sizeof(desc))"?

> +
>      /* try executing invpcid when CR4.PCIDE=0, desc.pcid=0 and type=0..3
>       * no exception expected
>       */
> -- 
> 2.25.1
> 
