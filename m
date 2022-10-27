Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67A460FAE3
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 16:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbiJ0OzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 10:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235924AbiJ0OzB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 10:55:01 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F9130541
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 07:54:59 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id b185so1769047pfb.9
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 07:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kPYnXX3okow1kRCKteMrz1kZILFzqyga2dfyqPNexuw=;
        b=cEfkDhbsG3tWzlruT2T+yhVrvDC0e4ykbkS6TUSvMJMueQ6BVIDiPTsqqcYZtsTc+8
         LrYzP001ez9kpMJ/QQd4Gu+VMdkTELU1EMtFejqQc/LP9szyilchAjELqL/mwXd8ndzw
         fywoH45H9zctKGaXnyld1myb4JXGwSCqPQYXLXtMcFJYgtPD5EdFILCHZgFvPMCs4Uow
         +CVTppidf6VdXwZikxsTU+BJ+3ezaYvp6t/gSF/OTniNM53VRtW/XuAZ1+wZLTDliLEV
         oqhC5aYEj4e5JZFE6h8T/Rq2k9QV3HQwEqmq84tVGXIDG3D9shf5SWJICcQjADFliAMU
         lhKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kPYnXX3okow1kRCKteMrz1kZILFzqyga2dfyqPNexuw=;
        b=KZyog6dTVx9egL1ojxmGs+KUovTRnieVgIxcKJMG/uvv7FzI+gqNRjBYxKmUkdju4r
         rEhxZFDfv73EmLeTH2pEi11Zs+Fi00qCTDQ1dTXCtn4tdSp9yj4HC+qdAXiHl0ZfWaUp
         9g8c+wPHKwFpdLrSP367yEYvLTafHQwcNnNlc5azHbEVmXtND3tf8LLtClUDq+iO4Nhb
         EFyue+IUefwmDFQNk1z8Q2FQyj0pCGv8YjlbXusMEByN/rA5ZgGpwgYIAE1wCfBLM3tm
         iAhOig4CyY52NLDg4RIEwW1oP1MKB2yxOEvPSYpzOTEpLPi4ieGQ6wWzQlZZl8/EcL/w
         6Edw==
X-Gm-Message-State: ACrzQf0vBq+4iiAAvykLevyoDC5D7FPg1BNBTpStiesufLgqPTvE6Twk
        pknyeH7qjbWsdhGxmeNqw5kXUg==
X-Google-Smtp-Source: AMsMyM77yVvmwPODxDgAB3imONWVBFbWeOxtNYJsvGc7QT0gYGTWB6Y7DO0uZ0fKfEYkiUdl/H/obw==
X-Received: by 2002:a63:c112:0:b0:443:94a1:f09 with SMTP id w18-20020a63c112000000b0044394a10f09mr42823906pgf.396.1666882499230;
        Thu, 27 Oct 2022 07:54:59 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 5-20020a170902e9c500b0018691ce1696sm1310297plk.131.2022.10.27.07.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 07:54:58 -0700 (PDT)
Date:   Thu, 27 Oct 2022 14:54:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "vipinsh@google.com" <vipinsh@google.com>,
        "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 03/18] KVM: selftests/kvm_util: helper functions for
 vcpus and threads
Message-ID: <Y1qbv/HdkuILzNSa@google.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
 <20221024113445.1022147-4-wei.w.wang@intel.com>
 <Y1nMQp11RKTDX7HX@google.com>
 <DS0PR11MB6373FBC16E8515174E444692DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB6373FBC16E8515174E444692DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27, 2022, Wang, Wei W wrote:
> On Thursday, October 27, 2022 8:10 AM, Sean Christopherson wrote:
> > > +void vm_vcpu_threads_create(struct kvm_vm *vm,
> > > +		void *(*start_routine)(void *), uint32_t private_data_size)
> > 
> > I vote (very strongly) to not deal with allocating private data.  The private data
> > isn't strictly related to threads, and the vast majority of callers don't need private
> > data, i.e. the param is dead weight in most cases.
> > 
> > And unless I'm missing something, it's trivial to move to a separate helper,
> > though honestly even that seems like overkill.
> > 
> > Wait, looking further, it already is a separate helper...  Forcing a bunch of
> > callers to specify '0' just to eliminate one function call in a handful of cases is not
> > a good tradeoff.
> 
> The intention was to do the allocation within one vm_for_each_vcpu()
> iteration when possible. Just a micro-optimization, but no problem, we can keep
> them separate if that looks better (simpler).

Keep them separate, that level of optimization is not something that's ever going
to be noticeable.

I don't want to say that performance is an afterthought for KVM selftests, but in
common code it's definitely way down the list of priorities because even the most
naive implementation for things like configuring vCPUs is going to have a runtime
measured in milliseconds.
