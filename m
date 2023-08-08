Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB64774B3E
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 22:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbjHHUny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 16:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234422AbjHHUnf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 16:43:35 -0400
Received: from mail-oi1-x249.google.com (mail-oi1-x249.google.com [IPv6:2607:f8b0:4864:20::249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0E3D92AD
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 09:31:48 -0700 (PDT)
Received: by mail-oi1-x249.google.com with SMTP id 5614622812f47-3a79a9395dfso20999b6e.1
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 09:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691512275; x=1692117075;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HGXHZ3drdzK75vM8gHoxCvKjL0tQ6wzVt3s6s+3IffU=;
        b=Pqy7yR/h1JfVyYBndU/ff2WNqRF/Cn024xB+7NRlHPhGu0/SiyrAmfRd5OmdT6Eotn
         4fFa7nfny115Uv4b3qFCXr9CzKTRjmyhZ+ovCd+5t6fTAh1+XdfQE2wHYzu/NO2hRjvE
         zKbE6voNKutiA+4PAJKrDd/YCTQcLX6HZ9EzDL2yj3kUmUafe/D+78PuXLRmqYeztauI
         BY5PnSHdm5SHZLqcHfzK8OBampZNBjxpLrrUKPxTgGyP9qGvgJDscLUmCCzHW+IMd5K0
         kz/st7RYocW5PnRhcpmA+zi62bUtZVlsHuBZntsdUt8ZTVc4/dJvOt25umgvUNWr4DLo
         ciRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691512275; x=1692117075;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HGXHZ3drdzK75vM8gHoxCvKjL0tQ6wzVt3s6s+3IffU=;
        b=VE5TWyio++GKoqNfCAd1nkszqOPzm1YcxXGiTEpWzKMFkBL5M2S62Y94zmBA8rjxX7
         bqIrE7sDFs6/Y9tttKzYaqvTsV7qtnUoq2qkP8Pa8dBSN2HcnZzgEFBJY/xC0usT2rye
         QK8lPBHSrGYsWlc2ZFm9xelEjNwW36eMbyaLmpLGPKtSrKZlATJxFMcY8AxtPu8ZHew4
         VDHILVfp3LJ4KlFunEjGa7FL6EYSwDAJYXmY12HBf6JGOlwv8vd69ysoQf4+P6Pm40uo
         m6AJFY890JGxbiWGvhispmweKlMnd52HPZ7fW7hMwc7KsUhq4UXdem4KLsZQigDuD0b3
         vQ2Q==
X-Gm-Message-State: AOJu0YxF2cYG2CO8BT9Rwpltfk4tBfs+zrQ6bFtJYb6Oy4Z8AwNv94fS
        s9GApHQiwT5LmPsCbxlEVhCL2r/9EWo=
X-Google-Smtp-Source: AGHT+IHIu+df+uNKRHuZ1U7hdYtwjQKpOkRRORgxpZw3jGTJRzS8amVnvOKjBjsEBYetabpmhnKN6Bq+h1o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:1e88:0:b0:d10:a33d:36b6 with SMTP id
 e130-20020a251e88000000b00d10a33d36b6mr118914ybe.0.1691505071871; Tue, 08 Aug
 2023 07:31:11 -0700 (PDT)
Date:   Tue, 8 Aug 2023 14:31:10 +0000
In-Reply-To: <20230808114006.73970-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20230808114006.73970-1-likexu@tencent.com>
Message-ID: <ZNJRrqk1cFFo5BoP@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove unused "const u8 *new" for kvm_mmu_track_write()
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 08, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> The incoming parameter @new has not been required since commit 0e0fee5c539b
> ("kvm: mmu: Fix race in emulated page table writes"). And the callback
> kvmgt_page_track_write() registered by KVMGT still formally consumes it.
> 
> No functional change intended.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>

No need to give me credit, you spotted the unnecessary param, all I did was confirm
that it wasn't needed.

> -void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> -			 int bytes)
> +void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes)
>  {
>  	gfn_t gfn = gpa >> PAGE_SHIFT;
>  	struct kvm_mmu_page *sp;
> diff --git a/arch/x86/kvm/mmu/page_track.h b/arch/x86/kvm/mmu/page_track.h
> index 62f98c6c5af3..ea5dfd53b5c4 100644
> --- a/arch/x86/kvm/mmu/page_track.h
> +++ b/arch/x86/kvm/mmu/page_track.h
> @@ -52,7 +52,7 @@ static inline void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,

Please remove it from the entire kvm_page_track_write() chain.  Yes, it will be
a larger patch and need an ack from the KVMGT folks, but there is no reason to
only do a partial cleanup
