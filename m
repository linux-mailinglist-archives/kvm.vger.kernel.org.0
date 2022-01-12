Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D304748C793
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 16:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354794AbiALPtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 10:49:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51554 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354788AbiALPtN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Jan 2022 10:49:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642002552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7itWgmWnZ91DtB2i3ZIJIZlEIAIGcoEdB/2ozTQ8AS0=;
        b=U6aPLzEOOYxfbkmAWbsQjtBR3TfpkkXOorMT9tXDvlWKpu8Ct8SrEvA59f2cPyydPGL/XK
        6c5g8n4FuLFfoEc9PNdPfcvAaZCxHWE+gMJhPxW0unn2+XQ/x8KL2xfamGry9JVJudOLpE
        pKpFPWaBf2opyh54zko6z7tM6bb0If8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-wFMj0zT8NJKAOJTb42MbgA-1; Wed, 12 Jan 2022 10:49:11 -0500
X-MC-Unique: wFMj0zT8NJKAOJTb42MbgA-1
Received: by mail-ed1-f69.google.com with SMTP id ec25-20020a0564020d5900b003fc074c5d21so2578664edb.19
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 07:49:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7itWgmWnZ91DtB2i3ZIJIZlEIAIGcoEdB/2ozTQ8AS0=;
        b=O7fqdmbyvz5qrUOTMugY71r4E58tfJDqlYV+ePCJfG8BeJfqdEfnGv6kfaHk9btDP5
         zRyOidYgSKOutDsj6dArrVlKgwv2lURw+zgP/wcNO/a4TzfeCj3arujWkU5S9bDP7xfX
         0Hdv+fz0G2L+284tsVfJSzojn1E5819maBHKc+j8yeNpeEU0qTaOG+iD0cKeywJPQCcN
         KgbypOD7PsVZBTBsEf8ji6i8NXFBD1CTeB73lS4UP6CH9/ZFvBGX4Fxk8nCsjTtV6Lt5
         /NWIU8QyMtxqA4vZiEAkHeRrVJitXByt8B1UQ2s9/xvE24zbplECOT8i5DXQdDeHDk9w
         nPiw==
X-Gm-Message-State: AOAM533noevv8YzV+eix7Ma8lQuJfSiknct/RQxo5O24lJU1faEjJ6sh
        1JSHAQImEFITZ9FEVbiWlaAT06P8/ke4W5AJNETA6pHSybq3rq90MwMrVOGXo6L60/JCo28qsCn
        7YT2/LcvRVOhh
X-Received: by 2002:a17:907:1b24:: with SMTP id mp36mr248067ejc.487.1642002550446;
        Wed, 12 Jan 2022 07:49:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw40+QE09WlkrEISryOAcx48Ytgv3S0ky6bH1FTMs6+heuN9ei+cd5PFh5muS1eK7XPLuqb+w==
X-Received: by 2002:a17:907:1b24:: with SMTP id mp36mr248052ejc.487.1642002550234;
        Wed, 12 Jan 2022 07:49:10 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id f13sm31284ejf.53.2022.01.12.07.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 07:49:09 -0800 (PST)
Date:   Wed, 12 Jan 2022 16:49:07 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oupton@google.com
Subject: Re: [kvm-unit-tests PATCH v2] arm64: debug: mark test_[bp,wp,ss] as
 noinline
Message-ID: <20220112154907.gjuhetv4db6kbqwh@gator>
References: <20220112152155.2600645-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112152155.2600645-1-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022 at 07:21:55AM -0800, Ricardo Koller wrote:
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
> index 54f059d..e9f8056 100644
> --- a/arm/debug.c
> +++ b/arm/debug.c
> @@ -264,7 +264,7 @@ static void do_migrate(void)
>  	report_info("Migration complete");
>  }
>  
> -static void test_hw_bp(bool migrate)
> +static noinline void test_hw_bp(bool migrate)
>  {
>  	extern unsigned char hw_bp0;
>  	uint32_t bcr;
> @@ -310,7 +310,7 @@ static void test_hw_bp(bool migrate)
>  
>  static volatile char write_data[16];
>  
> -static void test_wp(bool migrate)
> +static noinline void test_wp(bool migrate)
>  {
>  	uint32_t wcr;
>  	uint32_t mdscr;
> @@ -353,7 +353,7 @@ static void test_wp(bool migrate)
>  	}
>  }
>  
> -static void test_ss(bool migrate)
> +static noinline void test_ss(bool migrate)
>  {
>  	extern unsigned char ss_start;
>  	uint32_t mdscr;
> -- 
> 2.34.1.575.g55b058a8bb-goog
>

Applied to arm/queue.

Thanks,
drew 

