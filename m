Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481AF5A3F71
	for <lists+kvm@lfdr.de>; Sun, 28 Aug 2022 21:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiH1T36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 15:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiH1T3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 15:29:54 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEF8AE53
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 12:29:50 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id x80so2342765pgx.0
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 12:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=TqJbg/rrm3nucdrwVtoq7wfJ4YFDUNA9zK2XyD1K2XY=;
        b=BheQtYiIoRrlpWTztJ2v5llo456WTtARObJvLX1PSCf/FGlfpxKAVS8v/6/tJc9jfn
         gnxGqIi//fu0j/j17GGsDd317KWrnjlGpaq1wS83BxmTIyNO8LPcjrJ3UlRLQa3TrWxv
         +reste2v/J32z59VC9vHA0KzRv05L9qiAT4YlDqRVGOQKBiDRMC39glZ1Rfb0N4gHBt7
         eB54PHWOca+ES5TdZEmYJKSyW+aTqDH8OlO/O0NZJVW8AJjr6GAOehmNE9ucO06ps9Uu
         lc2EALa/sWbjtyKl7Xo9unUKlQgeWS4jDKJnUBhBp4mIAbi5QJJPTmo72Ss4bMKnjasa
         xWWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=TqJbg/rrm3nucdrwVtoq7wfJ4YFDUNA9zK2XyD1K2XY=;
        b=MpEsv05dXDL+dSgl0Gm8cTyClJ7xGpGP5ej/6fCi3qGbQG4V7RtERnaDo2UwddW5jp
         siZ9cSMhRTtbrf5Attg2a9VKC/8ZPsPBfkOVoXiHnS0p63BVDUbX0yMgwKGrflcOBAuJ
         lRzvOOsJyQZstRjmDddzoJIz+QyH53/Y9443CRMRpyWftbJcS4dY3Ka6wEq5Re86JKuj
         eZAEz1+AfhNpttfXRPS10v9GF86uzGH/yeR/Ry1tOOYuDz8djGOSf5DqvOl0c9mzlr6V
         Nru/QV+OkYfrfNY+lO18/82SXzzR0PqewB6KzmMlczDvwbiq2B8NPNmkdkkRuOTtSE+7
         qJpQ==
X-Gm-Message-State: ACgBeo1Hrlg2khD8UjEDUPAe38P0nx0LauPMsaeWjhVds3PlbxPdYFko
        6q3zbwHghJwGYGHRE7LXKzIqJw==
X-Google-Smtp-Source: AA6agR5LNkSAH7/hAPX5+g8t9Qv+Hi0ONnBT6mmQaz5UiN5x5Vb91/d+m/lze1W9Wr9q6zqU7RDetA==
X-Received: by 2002:a63:4a50:0:b0:41d:a203:a45d with SMTP id j16-20020a634a50000000b0041da203a45dmr11375936pgl.451.1661714990333;
        Sun, 28 Aug 2022 12:29:50 -0700 (PDT)
Received: from google.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
        by smtp.gmail.com with ESMTPSA id d144-20020a621d96000000b00537a6c78ef1sm5576824pfd.190.2022.08.28.12.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 12:29:49 -0700 (PDT)
Date:   Sun, 28 Aug 2022 19:29:46 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 4/5] selftests: KVM: Add support for posted interrupt
 handling in L2
Message-ID: <YwvCKuWX9PLEbe0Q@google.com>
References: <20220802230718.1891356-1-mizhang@google.com>
 <20220802230718.1891356-5-mizhang@google.com>
 <Ywa/ZhbEJwo6gkRr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ywa/ZhbEJwo6gkRr@google.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022, Sean Christopherson wrote:
> > +
> > +void prepare_virtual_apic(struct vmx_pages *vmx, struct kvm_vm *vm)
> > +{
> > +	vmx->virtual_apic = (void *)vm_vaddr_alloc_page(vm);
> > +	vmx->virtual_apic_hva = addr_gva2hva(vm, (uintptr_t)vmx->virtual_apic);
> > +	vmx->virtual_apic_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->virtual_apic);
> > +}
> > +
> > +void prepare_posted_intr_desc(struct vmx_pages *vmx, struct kvm_vm *vm)
> > +{
> > +	vmx->posted_intr_desc = (void *)vm_vaddr_alloc_page(vm);
> > +	vmx->posted_intr_desc_hva =
> > +		addr_gva2hva(vm, (uintptr_t)vmx->posted_intr_desc);
> > +	vmx->posted_intr_desc_gpa =
> > +		addr_gva2gpa(vm, (uintptr_t)vmx->posted_intr_desc);
> 
> Let these poke out, or capture the field in a local var.  Actually, posted_intr_desc
> is a void *, is casting even necessary?
> 
Will do. Yeah, casting is necessary here because add_ga2gpa takes
'vm_vaddr_t' which is the 'long unsigned int', so we have to cast it.
> 
> > +}
> > -- 
> > 2.37.1.455.g008518b4e5-goog
> > 
