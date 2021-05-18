Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36003880DD
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 21:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351999AbhERT67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 15:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351993AbhERT67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 15:58:59 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBCFC061573
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 12:57:40 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id p6so5707309plr.11
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 12:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JvjDB9x37KbkhXGo+mBIOIKWP7D/vvjksKE9jNsnqVM=;
        b=XlBzqimzzkY84/NrA1P3tJSm49jxfiKijMeSOBsbwBNlL6+dhVZ9sUpEyWvvnBMr52
         sT0udTR/tCkm+5hqS3C1BG00fWJon8JhQezqR32DuJvJTc1eZdxx94zztu0kzi7ooAdI
         7cq2ep8B5IM6VMgaWLuLIkEklwTqmuexNpLzIsepNCI7vuseTs6whFcCu53wXSHlNiP2
         gMRw4iKefuEP7ZG/RNntgFHUBIIiM5G+jjoQlDgFWQBO/bLTxcFD5EYXb6ifEnxDlXH6
         kFQKgVxLSHtAR1LrrAwWRYEpbjYVKKINihgKCXncmNOLzFL4LHLh2NieKWVMS5S8LQUs
         c9AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JvjDB9x37KbkhXGo+mBIOIKWP7D/vvjksKE9jNsnqVM=;
        b=e4xtairpKh6ZsZnCF6qZkoRRnqE/AhQLmZPhM1iaLZ2Os6mRJBwcy4dSGstNo/P3uR
         rjvPOG+5qn5ObPuTcUF187a9jQCL7LZin07WOSEjMSR+AHZ+GA+YvhS+XbYimkRBhJYL
         p+knYcu41fcvf2wr0EY2/bhPC3oyKfDIit2EDC+oE/0KkFhJAc1sd+tda1eJQNNqfPcJ
         wmIZx8eYZcd6mNI+ZLQpyv1akMLqpMWW3YWebYSu5IyrOaCWUCHsIL4LQ3T+frQubdGT
         3P5LotQJFud4njwXhpoz4xY5bfSAe6eQCpo4bc/B1uOx1xgevwwWFUM8ao1BM4dTJ79L
         EUAQ==
X-Gm-Message-State: AOAM533OaP8efmDpMHiuJmhhcW8P++Jw4EIc2zLUZ3uqMvtI16uEsVQE
        JppbjjxlE08GuMUmwI36jduWkA==
X-Google-Smtp-Source: ABdhPJwk6T7X0m8/MN/fEIPyLCYo2XlEldnEZomo4j04VpS+puwXQbF5lr58CXwqsju89hCz1oFTWQ==
X-Received: by 2002:a17:90a:4593:: with SMTP id v19mr6917000pjg.207.1621367859939;
        Tue, 18 May 2021 12:57:39 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id g202sm6072346pfb.54.2021.05.18.12.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 12:57:39 -0700 (PDT)
Date:   Tue, 18 May 2021 19:57:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] KVM: SVM: Drop unneeded CONFIG_X86_LOCAL_APIC
 check for AVIC
Message-ID: <YKQcL4ThiuCqWMIf@google.com>
References: <20210518144339.1987982-1-vkuznets@redhat.com>
 <20210518144339.1987982-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518144339.1987982-2-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 18, 2021, Vitaly Kuznetsov wrote:
> AVIC dependency on CONFIG_X86_LOCAL_APIC is dead code since
> commit e42eef4ba388 ("KVM: add X86_LOCAL_APIC dependency").
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
