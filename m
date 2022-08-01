Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F331C586CC1
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 16:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbiHAOYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 10:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiHAOYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 10:24:36 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9413224F03
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 07:24:33 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y15so10571132plp.10
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 07:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=tW6qq+W48P5M+KtfQ4JxdstkrsLn/NIPiomhXp8i0SA=;
        b=TkwTI2Nt0hYRxTyl+DCt/NZ/cUFNsidcK/8OZ+tfFMIeuu6b0zr8J7CooSPMgwSqKs
         9iB2KsIGfdKkyzmddfetp9OfwxD8/gs+8zgAtgyMiUkjlxSVrp4N9a4JhJIfgt9guM+y
         JxtWENX3+GUYZSQc67gnzcSWCwFrp4aGzkabxqqO+EDz7hZYj7bJ0hkWINm97ruuRhUd
         CFXl0TgZCIYUyFG6PO7y3or60Uyv8H5HetlT4Wz+Few/YEpPbJKpeVcWWoYxxrbi0ZJ1
         V1pBq1tvEZWeWM0ii5V5Rs4DIiII0/9QrvdOUILy1bPk5/B0Bgm46524ie4jANnrq5L1
         HCpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=tW6qq+W48P5M+KtfQ4JxdstkrsLn/NIPiomhXp8i0SA=;
        b=DkANUWJJMjVdTFmO496NBWRRjlS+nKzSGHuizldRSAMJNb2kNBRvhT6HvVNPPH6Sra
         JhdvYCDbKwVcoJGuZRFfm11evn7Knd4Kw9/NMilbHNtBJos7i5XSrn+s2Wp9Rq4aiz8H
         XKg1xS1UP4tl8/zR0/Hnjz35jLpgDj3a7/h3iNKPbklDTsJfL4z5NyqdUv97tKjHgfuk
         S5MM23Bt0l42+5TQZiyABoyJW2Pihc02mArxLG+5NEZYPoxLQ6jUMBDTqnD6LqYujd8n
         XtK+yMl3yg0bD7ZGYwVYt93e9/98a/opRHUn3vpWaRwp/Z5NIA4fLtyjljQdQge4FLKH
         S7YQ==
X-Gm-Message-State: ACgBeo1D3Riy0CJMl/b5cVb46fUQ42mXQ66a0ga9tBW43Z9NT7+xmJ1N
        auDoSMw3PX1qRnCfDh/1ZX9pZg==
X-Google-Smtp-Source: AA6agR7vXw6w5TMyFIDYpSRuuGmTc3NqqWMOrahWxgrJzIJTM3BJ6v0SF9vZ2vJDbIWiXv7ScppiYQ==
X-Received: by 2002:a17:903:41cd:b0:16e:e0c0:96d1 with SMTP id u13-20020a17090341cd00b0016ee0c096d1mr7600096ple.169.1659363872457;
        Mon, 01 Aug 2022 07:24:32 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z15-20020a634c0f000000b0041b2f37c571sm7507263pga.34.2022.08.01.07.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 07:24:32 -0700 (PDT)
Date:   Mon, 1 Aug 2022 14:24:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: remove unused variable
Message-ID: <YufiHFcbyxf4SpUY@google.com>
References: <20220801114524.1249307-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801114524.1249307-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 01, 2022, Paolo Bonzini wrote:
> The last use of 'pfn' went away with the same-named argument to
> host_pfn_mapping_level; now that the hugepage level is obtained
> exclusively from the host page tables, kvm_mmu_zap_collapsible_spte
> does not need to know host pfns at all.
> 
> Fixes: a8ac499bb6ab ("KVM: x86/mmu: Don't require refcounted "struct page" to create huge SPTEs")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

I was slow, but not thaat slow.  :-)

https://lore.kernel.org/all/20220727201029.2758052-1-seanjc@google.com

For giggles,

Reviewed-by: Sean Christopherson <seanjc@google.com>
