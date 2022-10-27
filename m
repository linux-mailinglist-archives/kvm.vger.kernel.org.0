Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C35760FC7E
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 17:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235861AbiJ0P4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 11:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbiJ0P4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 11:56:23 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCFF1956D7
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 08:56:22 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9so1950125pll.7
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 08:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gvzrghwrfzUsJYhqUBxViutsbs1gyQ5GEUkX/9osrFs=;
        b=FI+Sju9NW67lHQnyqb4cvmQVM4dJHtnh2R/XUliFBUNti1vbqC/ESoFnvuli+QpmOx
         HnHTLVYTK2tWkuFvzLFDv3q5cngZOe/eWRGb2b32vWzXUG3xO8eMnBFNj36shPDJE9FB
         FXc4KrH59g8aQGixuopEjEalG80hc9FHT4A4cR1JmHJ6KLvQd6ZyvKcP7gpth6JeQEf+
         dRqxeqI5m6g4KaLrrAFbYp9WC4nE9epTCec6UMQ+6q6Q9wtnAUUP8ian3iiiJha3K2yc
         6Czcjmes2afRP/i80waUU/xBx594UnAC5SI45hJx4r8dwnAeNVlKUnmqxwQy/aJhAkBo
         dw1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gvzrghwrfzUsJYhqUBxViutsbs1gyQ5GEUkX/9osrFs=;
        b=B2a95TRoSx7z06mIGxgE+D+fouNgVukxHKs76Mg+SWgLz5zRy+fmW76sElMKRBRO1m
         j0ar3T/h9xU1U0F0Vq+aR6Z8U78iY2tnPSKUzg0ByAtUSkqHfAjw0kqZSnrGTUHgT+OZ
         5OO5BmVvsL/5Krb4KRAwir/KLnoDoK+DJK89MojixIpMnlMUPB3nk5jJfvV8tHuQLIqV
         CaZxX9YsEi5Y6NPKdkcYqFClSOB9V0U7LIv04qVyQ/4tWYFg+nTm0PjB3zU/QKakPgss
         z6sFgh2Y3oCB97Vf2oW8fNObmk9Q3JFSWG+wiBzMAjToW4za60KpoAtfZ7XSLokgy4DL
         HcqQ==
X-Gm-Message-State: ACrzQf374pDo03AnfLhEShJ0ZAI2hWwzJb4+m83ujIoUGpYlaLbtPo/G
        cjCSfK7gND5h5brEkkvHY1NI+g==
X-Google-Smtp-Source: AMsMyM5xrFACLrT57xNv7hENaHFzZdV/frxmH+f+50gFbfJembX614Hy6eQFClt2SKA2D8c9An8cww==
X-Received: by 2002:a17:90b:4a09:b0:20c:316d:e58b with SMTP id kk9-20020a17090b4a0900b0020c316de58bmr11008214pjb.217.1666886181859;
        Thu, 27 Oct 2022 08:56:21 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id rj9-20020a17090b3e8900b0020b21019086sm9918490pjb.3.2022.10.27.08.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 08:56:21 -0700 (PDT)
Date:   Thu, 27 Oct 2022 15:56:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     Vipin Sharma <vipinsh@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 5/5] KVM: selftests: Allowing running
 dirty_log_perf_test on specific CPUs
Message-ID: <Y1qqIgVdZi7qSUD0@google.com>
References: <20221021211816.1525201-1-vipinsh@google.com>
 <20221021211816.1525201-6-vipinsh@google.com>
 <DS0PR11MB637351B52E5F8752E7DA16A4DC309@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Y1lV0l4uDjXdKpkL@google.com>
 <DS0PR11MB6373E6CA4DDFFD47B64CB719DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB6373E6CA4DDFFD47B64CB719DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
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
> On Wednesday, October 26, 2022 11:44 PM, Sean Christopherson wrote:
> > > I think it would be better to do the thread pinning at the time when
> > > the thread is created by providing a pthread_attr_t attr, e.g. :
> > >
> > > pthread_attr_t attr;
> > >
> > > CPU_SET(vcpu->pcpu, &cpu_set);
> > > pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), &cpu_set);
> > > pthread_create(thread, attr,...);
> > >
> > > Also, pinning a vCPU thread to a pCPU is a general operation which
> > > other users would need. I think we could make it more general and put
> > > it to kvm_util.
> > 
> > We could, but it taking advantage of the pinning functionality would require
> > plumbing a command line option for every test, 
> 
> I think we could make this "pinning" be optional (no need to force everyone
> to use it).

Heh, it's definitely optional.

> > If we go this route in the future, we'd need to add a worker trampoline as the
> > pinning needs to happen in the worker task itself to guarantee that the pinning
> > takes effect before the worker does anything useful.  That should be very
> > doable.
> 
> The alternative way is the one I shared before, using this:
> 
> /* Thread created with attribute ATTR will be limited to run only on
>    the processors represented in CPUSET.  */
> extern int pthread_attr_setaffinity_np (pthread_attr_t *__attr,
>                                  size_t __cpusetsize,
>                                  const cpu_set_t *__cpuset)
> 
> Basically, the thread is created on the pCPU as user specified.
> I think this is better than "creating the thread on an arbitrary pCPU
> and then pinning it to the user specified pCPU in the thread's start routine".

Ah, yeah, that's better.

> > I do like the idea of extending __vcpu_thread_create(), but we can do that once
> > __vcpu_thread_create() lands to avoid further delaying this series.
> 
> Sounds good. I can move some of those to vcpu_thread_create() once it's ready later.
> 
> >  struct perf_test_args {
> > @@ -43,8 +41,12 @@ struct perf_test_args {
> >  	bool nested;
> >  	/* True if all vCPUs are pinned to pCPUs */
> >  	bool pin_vcpus;
> > +	/* The vCPU=>pCPU pinning map. Only valid if pin_vcpus is true. */
> > +	uint32_t vcpu_to_pcpu[KVM_MAX_VCPUS];
> 
> How about putting the pcpu id to "struct kvm_vcpu"? (please see below code
> posed to shows how that works). This is helpful when we later make this more generic,
> as kvm_vcpu is used by everyone.

I don't think "pcpu" belongs in kvm_vcpu, even in the long run.  The vast, vast
majority of tests will never care about pinning, which means that vcpu->pcpu can't
be used for anything except the actual pinning.   And for pinning, the "pcpu"
doesn't need to be persistent information, i.e. doesn't need to live in kvm_vcpu.

> Probably we also don't need "bool pin_vcpus".

Yeah, but for selftests shaving bytes is not exactly top priority, and having a
dedicated flag avoids the need for magic numbers.  If Vipin had used -1, I'd
probably be fine with that, but I'm also totally fine using a dedicated flag too.

> We could initialize pcpu_id to -1 to indicate that the vcpu doesn't need
> pinning (this is also what I meant above optional for other users).
> 
> Put the whole changes together (tested and worked fine), FYI:

The big downside of this is forcing all callers of perf_test_create_vm() to pass
in NULL.  I really want to move away from this pattern as it makes what should be
simple code rather difficult to read due to having a bunch of "dead" params
dangling off the end of function calls.
