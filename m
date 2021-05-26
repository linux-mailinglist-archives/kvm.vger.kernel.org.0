Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4759391A9B
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 16:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235047AbhEZOrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 10:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234990AbhEZOrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 10:47:31 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8A7C061574
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 07:45:59 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d20so718189pls.13
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 07:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jhVdbmgm1lLnPz0WLG5kfrPAWOMseIxTJMTOG3ldHco=;
        b=KZmn3JoJ3MgiDHsqFAqDiayBRSyeFgr9B7QixllS96eLmYGy9j4re6IaJRgkzuN+9m
         cg7sbHgGMjRRsGOTEv6Bn3WJlkOk45fBrhcW8NC4w+NRSMRSJ/BjpTLEYYzsvDYFrtTq
         YXi7NI6Dnl5CKlnwuWMAlXsX8QELvN+r+SvJdszKRpeqgiho+wTZVzwdOmvKpupV5FRN
         YuAhD21IWPhEv2m8EWlmOcszmXPZlrXM4IBwGxDV1bf+G4VLVitPFSnBMDr29NEzZctm
         xDwibJHXW3k26QjRWhNuO+gtrYmxD2LkJSvhD9tya5NHPhNfFXVtws3pTecxeMq8IWea
         drMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jhVdbmgm1lLnPz0WLG5kfrPAWOMseIxTJMTOG3ldHco=;
        b=GEXSG2IOkn+id71DSP3fNg7xAjXJWUacPHPy2OCxgWKvkjaphlVLoi/RVgmODjxCvo
         EjBsT4rv/ltnOUKKGY+npGNXpPgNb5bi9kTiVP1FzCV/v5rq5ZKc5pYZBzlC2H3d4EFR
         SAjFwTo8BVVCeYHF3vrEfngOo3QK81FWLjVYnGky24QLHfqefSZqvRckv0gOXp0V6Hcm
         lrnVM3D3c3uhkFgPMqvdzIpCkygD3Wb+MzuC2GSsdMDq3cSbobU6L6ZxVHeUxB+9pqTf
         uqqukk9KNyKnTPOSD0lkMD+0GYJjEhzZ67Sef4jmDN0RtBEUiW8PmvA1UrfimFvM4rjT
         OtSA==
X-Gm-Message-State: AOAM530UwwGk9yNU7FwTFSvphsAX4lcnDW1azaVnii0AdzenWA9aqUh0
        rFvXIGNegqDLVi7RSYNouhNYOzG9GVebEg==
X-Google-Smtp-Source: ABdhPJyKaEu2+D4H7KO3klO6M2DDkdwRxTZABhPz1NYeFBDPPSznufNXbFOgkmNpetA6N4JSKdjpIg==
X-Received: by 2002:a17:90b:4ad2:: with SMTP id mh18mr35351540pjb.148.1622040358626;
        Wed, 26 May 2021 07:45:58 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 125sm15803924pfg.52.2021.05.26.07.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 07:45:58 -0700 (PDT)
Date:   Wed, 26 May 2021 14:45:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove the repeated declaration
Message-ID: <YK5fIpDl79xk6jb4@google.com>
References: <1621910615-29985-1-git-send-email-zhangshaokun@hisilicon.com>
 <YK0hPadppDR1sPaD@google.com>
 <b0e4d53e-c59e-bebc-a6c3-22f89e1c0a5f@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0e4d53e-c59e-bebc-a6c3-22f89e1c0a5f@hisilicon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021, Shaokun Zhang wrote:
> Hi Sean,
> 
> On 2021/5/26 0:09, Sean Christopherson wrote:
> > Rather than simply delete the extra declaration, what about converting this to
> > static inline and opportunistically deleting the duplicate?  The implementation
> 
> It seems that you want to make it static inline in mmu_internal.h, right?

Yep.

> > is a single operation and this is MMU-internal, i.e. there's no need to export
> > and limited exposure of nx_huge_pages to other code.
> 
> If is_nx_huge_page_enabled is inline in mmu_internal.h, nx_huge_pages will be
> external in mmu_internal.h and exposed to other code. Do I miss something?

Yes, it will be theoretically exposed to other code, but as the name suggests,
mmu_internal.h should not be included by anything outside of mmu/, and of course
we can reject patches that try to access nx_guest_pages directly.
