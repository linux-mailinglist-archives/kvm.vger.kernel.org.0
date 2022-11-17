Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE5562E463
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 19:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240485AbiKQShy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 13:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234811AbiKQShw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 13:37:52 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9C585175;
        Thu, 17 Nov 2022 10:37:51 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id q71so2742940pgq.8;
        Thu, 17 Nov 2022 10:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0bNNhIjjo42ZghHEKpZWRcH3jdudHDP1Mg2unknxtog=;
        b=WNiqHWUzPIdSPyCtDtG2/h/7AoNmrGE1k4BsgxTFMUVfsQHVus4i5ReuZ5b0h8FuSI
         2LuNpfn/p+ixSTb0FK7OwgPITuHGEd5FQ7+g7HYVN52t1Vnon4pIKFBUq1y9A8mr4MHz
         6WQwhSBeFcUuUbULAHZaq6coRpX7LnaB+y9k4vXgKOJmljsLkxWx6LWCEC+x/xzElOmD
         LOKT5FBlzSwiWmAdQgnPQUlnAR86oO9Hi58waJ6BL3DCnoLTieI/g5dWligh4wCXPuMS
         mTMobhwGhtJbFafM/xXjBvgfdnwSQKMKpoxyCDIZKrxxvPeMuP3D6TghqpIVyb3meDc+
         pLww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0bNNhIjjo42ZghHEKpZWRcH3jdudHDP1Mg2unknxtog=;
        b=F056Kisesx1MKDySC3/6vpx7aln5KYoQLXG4uK2tdnZgdLQG3XPhz4S08mo31kowm5
         EVYlDfdeRv6Mewau8wMffRF473NndNEsR3mIUPu+RUiomycL7W8Dm1ZFaNjNSkKFgXJ7
         bXEqeCF4XOfQZLx9ORY3Ij7xhQqF2byKBi3sLv0Ytw1zgbcLAXJCnscq7jthp91JwYLH
         wM8yorzXhC1zpmxGbcCIWKzJ5QxvU8vnTEFSNkHXYu5RlycyYZbn65WoAKwFNQmF42cn
         PEbA2AVjfJGUqhHk4bzGagktzRPScMMxBGG0EDAkiwWrw9lPucg3rRaT2hoarBdvfILb
         DysA==
X-Gm-Message-State: ANoB5pktHJwhG1g+sldT1yAJBFzacqBaS3accECXKTbhFu9Iy2z8Gg58
        JdeWoHZnrTWgIhWWH0/hepg=
X-Google-Smtp-Source: AA0mqf4r6yrijH+RSLcXZSbgZrRSUpw9nDzGX/X/pxbNSJ/RSk8qShLWx6KqCi1zYY6LNJjGu3bbTQ==
X-Received: by 2002:a63:1e49:0:b0:46b:1590:2625 with SMTP id p9-20020a631e49000000b0046b15902625mr3057403pgm.569.1668710271326;
        Thu, 17 Nov 2022 10:37:51 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id j8-20020a170902da8800b00176ba091cd3sm1736307plx.196.2022.11.17.10.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 10:37:50 -0800 (PST)
Date:   Thu, 17 Nov 2022 10:37:49 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 041/108] KVM: x86/tdp_mmu: refactor kvm_tdp_mmu_map()
Message-ID: <20221117183749.GK2350331@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <ae532ffde75be94062f03dab8b538fa64d1dfc74.1667110240.git.isaku.yamahata@intel.com>
 <f9dcc09e6569b2d47c039a44bfb83c22e30365bb.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f9dcc09e6569b2d47c039a44bfb83c22e30365bb.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 16, 2022 at 09:42:34AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Sat, 2022-10-29 at 23:22 -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Factor out non-leaf SPTE population logic from kvm_tdp_mmu_map().  MapGPA
> > hypercall needs to populate non-leaf SPTE to record which GPA, private or
> > shared, is allowed in the leaf EPT entry.
> 
> Is this patch still valid/needed since you have changed to use XArray to store
> whether GFN is private or shared?

Because tdp_mmu_populate_nonleaf() won't be touched any more, this patch doesn't
have any benefit. Will drop it.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
