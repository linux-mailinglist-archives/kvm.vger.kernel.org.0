Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7E0435450
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 22:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhJTUIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 16:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbhJTUIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 16:08:30 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79555C061749
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 13:06:15 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q5so23500669pgr.7
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 13:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MKbSiQoqQYsuOuLmGSZx9qeFGagmtkSznBfqvzwCr20=;
        b=oWvkO2QyLTKbL3kRYWcPg7tgbfGzY1eVVmr0avXsKUvtK0zjRGYuP1Cp8Sk7HlvFAl
         5Wjeix2SPDz7iKkpMn1pTDU2uI2T5TrwkPA4V4T+v6M7EVKgrFG7/f9rDnJvqPsWikOw
         HE3ZNvBTFvtACJWRIfzu897BKE42TssUNPVkjqGdKT+B6FxKbt2SkCIUZy5S2WcYtsuY
         P3SwS70u9Xhl8RoXQu+pXcrJLVQfiVo5ewJW4sKZT8gDUkiZPHQheT5jr5I29trdz4H4
         Pf+5cZwhsPy/HJeXKcPjt6ZFvPEIGLf9vcykODe/ekDs/AmmMZlrYmDuCP+ry7sr0Hzy
         KMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MKbSiQoqQYsuOuLmGSZx9qeFGagmtkSznBfqvzwCr20=;
        b=lqEI4ab7RE72iysRJ21yZGxoFXbGMhCqIH/OoQ85s7xFhbqP1Kg8rK+hCpAcPAJDCL
         44i4hQLqy6xKY6Io0uqasCC2cSql7ypAr7Prjk8V4RaJ4ZCj3tNx5bxZM2L8O2zlHEV9
         LsarFAakqmVh9gIbR01BJnJyfWozmXaAXcimq6/icFwc/6FPv4dEABZbDo+apVJHTbNA
         nYI1zU1X/+v9Vc/MwacjGWg556UH6f6HsMx7cpZtGB8uYuzUIcusyPv75YMi1qB9Islr
         rTTdproGgNpOwqe1z+CI7xmE7mAAHPa++L1Cq5QGzCjbFaNQRMar5M92jG4ZQsjyCwaE
         +yYQ==
X-Gm-Message-State: AOAM5319u93IvH3pe9+z9oFn9s+UoKtajJsS0Uvflq+P7sPJSHXGlqJc
        I/rEECk2VjuXpuqFyuCN4weEaw==
X-Google-Smtp-Source: ABdhPJwkmr8z9qpcZqn9Gup3ohWEcvQz30HULKPBunxChx2pWIrMwHuFyjsaW3Cd5q0YNLxUT6pa2Q==
X-Received: by 2002:a63:ac55:: with SMTP id z21mr1064840pgn.200.1634760374799;
        Wed, 20 Oct 2021 13:06:14 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id oj1sm3239214pjb.49.2021.10.20.13.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 13:06:14 -0700 (PDT)
Date:   Wed, 20 Oct 2021 20:06:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, zxwang42@gmail.com,
        marcorr@google.com, jroedel@suse.de, varad.gautam@suse.com
Subject: Re: [PATCH v2 kvm-unit-tests 2/2] replace tss_descr global with a
 function
Message-ID: <YXB2spOaSQhaF0Vb@google.com>
References: <20211020192732.960782-1-pbonzini@redhat.com>
 <20211020192732.960782-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020192732.960782-3-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021, Paolo Bonzini wrote:
> +typedef struct {
> +	gdt_entry_t common;
>  	uint32_t base4;
>  	uint32_t zero;
> -} __attribute__((__packed__));
> +} __attribute__((__packed__)) gdt_entry16_t;

I doubt I am the only one that is going to misread this as "GDT entry in 16-bit
mode" without thinking critically about what "16" might mean.

Why not this, or some variant thereof?  The gdt64 part is a bit gross, but I
don't think it's likely to be misinterpreted.

	gdt64_system_entry_t;
