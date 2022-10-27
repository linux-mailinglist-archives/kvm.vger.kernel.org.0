Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63BD60FFC6
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 20:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236392AbiJ0SDi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 14:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbiJ0SDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 14:03:12 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B8C31217
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 11:03:11 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q1so2251600pgl.11
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 11:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M/NOGyD6//JTTMCPo06TOVsgOnCWYNu+jvzp7cicNDo=;
        b=drkGf6+R5fW8aDhSOnDoaSVPYWXOshWNGay7f0fni3hLnXfgvmiAVRtLIUYjH2/e6z
         /ap+zwtbA17Fwmxz7EXYevEGZ4OHnkFQK0U88KZEexHL2VcxuevPKGcWHbgHJVqeSzkC
         taih6YL7k9V8HGsQIGq40NTHaW34KKkAQ5Fg0gh5E6oTb1uOp8GpGDwP1ZP26rosWH1Q
         IB3uDgW+nzM9Taahd4jaStzDM0VZKa0g+WdTNg9QCEyWl2n8q5or+DC6Dn7AHADo7NI4
         fg9Ke01n/M7URvEGtcuXiePe09yRpCd8aO3w+QSxj+tO1ybaw/MoHXWNEJ+KCEGRkYrl
         RFfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M/NOGyD6//JTTMCPo06TOVsgOnCWYNu+jvzp7cicNDo=;
        b=MpjpvFPLqwPpsiv4bww1KojWUam8CA7p4ueW+1p5CxHMGXut8GvDxcs1OypNFF93/J
         CGyU5jIS7YB7APVAw4JRZxsel9Jeab0ApMTRvPZq1gZSpViQ+YkGo/rmWmfOT6CS14AU
         zAnOrqS6crKtLQdh4orPhpvVUvJwcFBV7vTv+RG7tuXZFwi/hShxoHr+MYZnhLE5P9nN
         +clt5c7jsRzDWGjuwQeCExgeZ5TjGkIerI+2QuImHCJVGYvol/yu9R0m5fVVzQF0MV+U
         wJn6s6djGuHVs9+YoNETVXKF37AP5A564RKbdiI1Wy3Z/pdYXl/V7S8S30Yq/k2pd8G5
         vL/w==
X-Gm-Message-State: ACrzQf0bFX/qr6+iCE+HIjMJboXUWfODdnvUCu/nTlYgZVwf3/QvD6Oo
        DSuL8avv0vhAlXRhgt/5jZ86qA==
X-Google-Smtp-Source: AMsMyM6T48xRezEY6WQ9+v5Br/JbDLVI9XYW2CIi/GZrbDnaOGwi/poofMKKhaELjRV86eId/P7Xcg==
X-Received: by 2002:a05:6a00:2187:b0:56c:7e85:c8f9 with SMTP id h7-20020a056a00218700b0056c7e85c8f9mr7007195pfi.75.1666893791007;
        Thu, 27 Oct 2022 11:03:11 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p14-20020a17090adf8e00b0020af2bab83fsm1276579pjv.23.2022.10.27.11.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 11:03:10 -0700 (PDT)
Date:   Thu, 27 Oct 2022 18:03:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "vipinsh@google.com" <vipinsh@google.com>,
        "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ikalvarado@google.com" <ikalvarado@google.com>
Subject: Re: [PATCH v1 05/18] KVM: selftests/hardware_disable_test: code
 consolidation and cleanup
Message-ID: <Y1rH2uSEa3tMNhCG@google.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
 <20221024113445.1022147-6-wei.w.wang@intel.com>
 <Y1nNzO2tC+DCyKWI@google.com>
 <DS0PR11MB6373F09A7A51FBF417876449DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB6373F09A7A51FBF417876449DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
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

On Thu, Oct 27, 2022, Wang, Wei W wrote:
> On Thursday, October 27, 2022 8:16 AM, Sean Christopherson wrote:
> > > diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c
> > >  static void run_test(uint32_t run)
> > >  {
> > >  	struct kvm_vcpu *vcpu;
> > >  	struct kvm_vm *vm;
> > >  	cpu_set_t cpu_set;
> > > -	pthread_t threads[VCPU_NUM];
> > >  	pthread_t throw_away;
> > > -	void *b;
> > > +	pthread_attr_t attr;
> > >  	uint32_t i, j;
> > > +	int r;
> > >
> > >  	CPU_ZERO(&cpu_set);
> > >  	for (i = 0; i < VCPU_NUM; i++)
> > >  		CPU_SET(i, &cpu_set);
> > 
> > Uh, what is this test doing?  I assume the intent is to avoid spamming all
> > pCPUs in the system, but I don't get the benefit of doing so.
> 
> IIUIC, it is to test if the condition race between the 2 paths:
> #1 kvm_arch_hardware_disable->drop_user_return_notifiers() and
> #2 fire_user_return_notifiers->kvm_on_user_return
> has been solved by disabling interrupts in kvm_on_user_return.
> 
> To stress the tests, it creates a bunch of threads (continuously making syscalls
> to trigger #2 above) to be scheduled on the same pCPU that runs a vCPU, and
> then VM is killed, which triggers #1 above. 
> They fork to test 512 times hoping there is chance #1 and #2 above can happen
> at the same time without an issue.

But why does it matter what pCPU a vCPU is running on?  Wouldn't the probability
of triggering a race between kvm_on_user_return() and hardware_disable() be
_higher_ if there are more pCPUs returning to userspace?
