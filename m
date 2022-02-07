Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBF84AC58D
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 17:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351365AbiBGQ3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 11:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351190AbiBGQQn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 11:16:43 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68736C0401D9
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 08:16:42 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso7049579pjt.4
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 08:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r5BkdnCSajJYnPXhZUqmm3cNTaK+0gcrgKWZLgS5EGs=;
        b=WRZAOyN7Ijczhs803XsRhiMLkjuu5Fh8uouF+34kA0ht5c2bPTib7csH3iOvCve+nq
         m3TKxLMdNWJetL3dcKcvNZEDv3639vC14cDvk/bPVZUh/smWYXJ77cqc/Qcg/dUaVh6j
         uzIRnYYPuz3AEom56S85oL7qsAXEuVV7lkqsxU3pTCeoqtWSH7lL/0JIEtn+2hjFSRWq
         5qW2pnDTpCWBHjEdGnq+g3T47QHR4jP8chmdjCJ0bYet4rsyfZyxpbuLnFqxZFCbmFLa
         Oh/SMAdqT42Wjo8h+qAeno193jTWJlxln4ZJ24bDSwzZdYoiJQV0Q9nIYk694a7yKWGw
         FKZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r5BkdnCSajJYnPXhZUqmm3cNTaK+0gcrgKWZLgS5EGs=;
        b=3PWzX7vBTVVUTWbVp6OJb+j0+YEPCogjR7uvFb4s10yXzdBMBj7Nd5i7oi+ZmumqWH
         WmLPGgyeFogqzs7lPnddSi6dbGV10RERL65xjwv2jEOsUoFevNG2qdqoj17+YTYqeWTC
         a1qi7i+VbAGlBf66YsB4XAf8kRj3ltSPPd+BF1F3MQMdENaUHzyjbrlVNDpoTYVuYCvi
         owh4Bfss3UY3BCO3yhItAWbjBNshhifOCLudZdX0IJfKoFUSpIJiIp0ZdkRNVFP9rOWJ
         GWARJTKcF12voLO8wfIkCNIiRDpXZ1YRwB9NZStZL2QO1muT/7xC/DKLlNCMZ6sz7Ihf
         DPRQ==
X-Gm-Message-State: AOAM530ac++avNvdB2R8mrZSQQnw/2OTNaMlzahnAAD/vfu8+5ynJiMu
        ggtX74S+UbPKHkJ/gEh4gwBaNA==
X-Google-Smtp-Source: ABdhPJxh9KeB3jV1PV+knXJ7UWCli6Yf29jvixzGdHwVWJg5mm2BUb6k+7gPOWSf0SMZSt0+cyCgQw==
X-Received: by 2002:a17:902:b184:: with SMTP id s4mr330727plr.7.1644250601703;
        Mon, 07 Feb 2022 08:16:41 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 13sm12370602pfm.161.2022.02.07.08.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 08:16:41 -0800 (PST)
Date:   Mon, 7 Feb 2022 16:16:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kbuild-all@lists.01.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH 04/11] KVM: SVM: Use common kvm_apic_write_nodecode() for
 AVIC write traps
Message-ID: <YgFF5afpQZ1qQR5X@google.com>
References: <20220204214205.3306634-5-seanjc@google.com>
 <202202050720.YPm113nN-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202202050720.YPm113nN-lkp@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 05, 2022, kernel test robot wrote:
> All errors (new ones prefixed by >>):
> 
>    arch/x86/kvm/svm/avic.c: In function 'avic_unaccel_trap_write':
> >> arch/x86/kvm/svm/avic.c:486:35: error: 'svm' undeclared (first use in this function); did you mean 'sem'?
>      486 |   if (avic_handle_apic_id_update(&svm->vcpu))
>          |                                   ^~~
>          |                                   sem
>    arch/x86/kvm/svm/avic.c:486:35: note: each undeclared identifier is reported only once for each function it appears in
> 
> 
> vim +486 arch/x86/kvm/svm/avic.c
> 
> ef0f64960d012cb Joerg Roedel        2020-03-31  478  
> 528172fca9c0e8f Sean Christopherson 2022-02-04  479  static int avic_unaccel_trap_write(struct kvm_vcpu *vcpu)
> ef0f64960d012cb Joerg Roedel        2020-03-31  480  {
> 528172fca9c0e8f Sean Christopherson 2022-02-04  481  	u32 offset = to_svm(vcpu)->vmcb->control.exit_info_1 &
> ef0f64960d012cb Joerg Roedel        2020-03-31  482  				AVIC_UNACCEL_ACCESS_OFFSET_MASK;
> ef0f64960d012cb Joerg Roedel        2020-03-31  483  
> ef0f64960d012cb Joerg Roedel        2020-03-31  484  	switch (offset) {
> ef0f64960d012cb Joerg Roedel        2020-03-31  485  	case APIC_ID:
> ef0f64960d012cb Joerg Roedel        2020-03-31 @486  		if (avic_handle_apic_id_update(&svm->vcpu))
> ef0f64960d012cb Joerg Roedel        2020-03-31  487  			return 0;

Doh, I did all my testing with avic_handle_apic_id_update() completely removed
(because it's broken), but obviously forgot to rebuild without that patch when
posting.
