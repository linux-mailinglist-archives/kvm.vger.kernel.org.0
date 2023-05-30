Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40017717123
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 01:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbjE3XAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 19:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjE3XAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 19:00:13 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89788EC;
        Tue, 30 May 2023 16:00:10 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-64d41d8bc63so4019806b3a.0;
        Tue, 30 May 2023 16:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685487610; x=1688079610;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MhkmwhzVFv1bWKBw06RWKQ85zcFA8OuFNsMQdUaAwlA=;
        b=SpDnqS/gyx977+0QYAk/5vk8jfE9dMGQ/M551BHZsK8DyLDbQTZRbPNaqHbUTosgD6
         08mbQ8xhC4Fy7Xw6nbGvifDdJKh7CngQLD9t/qNgpIP/JrBJA+be7GG2JNhe/X78KC/+
         IAmI2BctwsmQcvJ3IZHLoqgL4ezJyvzZZ3eRN0AEMA1VgNAq3gF+FlSu7Ej7/Oi2VKsg
         TQ6K1prEtMK9KZnPn04boP7vhVdcrAYeKt55BCJvU1++ntA/fsjRi/NVyX7IUyY+E/G/
         VjNYKh/QC1B6Fd9cBDkFfqTZHECT95nqNjikec+Dup1/yrhyNmEGQlnWn2lCWG7wwCyB
         RT8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685487610; x=1688079610;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MhkmwhzVFv1bWKBw06RWKQ85zcFA8OuFNsMQdUaAwlA=;
        b=Ox2sLzwMTzelxYY/S33nPs9gUwyEywa0oij69SBV1HqbWesZHK2CzbMfd9pjsRqJQi
         u6P1hiu6tUhOBhvdwVyREdVxlvRccqNfhKEZdfw6Dl1IKnZARGE4eKN5pBSmr8JN913+
         Isp161CjefT402JaXYeje8amc8hpYJwhX7rioYlVkRs8bMAKw+mDnctfe9c3n9z+8Odo
         +osuIh711a2RaDIqIMpMpLB9ugtmRbpva1yNF1BZ1mVmFPNw5q8yWO18LAVAwEPfCLvS
         +4YfkR5CpWg6C90nB8ob4o5DmpRJdVGKJ+sEXyjifFwb5b4bJjvdBcbyLY5h1tf52pNm
         zE0Q==
X-Gm-Message-State: AC+VfDxG4Q0IkWnHxbLprtoorepqe7bi1uE2CKkI8cEx8H0WVt4sJECN
        NpOmbxPZopVxAPYFLh6Zj4Q=
X-Google-Smtp-Source: ACHHUZ4Cx4GU4obSH7OFW8nhQ1JqeI8yoGHRoZr5v+gFueWC79mKY1HhqEJk3ylQNB7PNEm6qlUQ5g==
X-Received: by 2002:a05:6a21:6704:b0:10a:9f45:e3f with SMTP id wh4-20020a056a21670400b0010a9f450e3fmr3879785pzb.12.1685487609828;
        Tue, 30 May 2023 16:00:09 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id e2-20020a63ee02000000b00514256c05c2sm9445520pgi.7.2023.05.30.16.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 16:00:09 -0700 (PDT)
Date:   Tue, 30 May 2023 16:00:07 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v13 021/113] KVM: TDX: Make pmu_intel.c ignore guest TD
 case
Message-ID: <20230530230007.GF1234772@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <017a06174fa054ae264a2caba6f7f55e00f258e8.1678643052.git.isaku.yamahata@intel.com>
 <20230402115019.000046fd@gmail.com>
 <36fb638a-c9ff-0139-3e8e-7e8ff0bbff1f@gmail.com>
 <20230528082602.GC1234772@ls.amr.corp.intel.com>
 <cd8b6ea4-1293-c57c-1bed-4f6dbdbc2722@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cd8b6ea4-1293-c57c-1bed-4f6dbdbc2722@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 29, 2023 at 10:19:16PM +0800,
Like Xu <like.xu.linux@gmail.com> wrote:

> On 28/5/2023 4:26 pm, Isaku Yamahata wrote:
> > On Wed, Apr 19, 2023 at 04:21:21PM +0800,
> > Like Xu <like.xu.linux@gmail.com> wrote:
> > 
> > > On 2/4/2023 4:50 pm, Zhi Wang wrote:
> > > > Hi Like:
> > > > 
> > > > Would you mind to take a look on this patch? It would be nice to have
> > > > a r-b also from you. :)
> > > > 
> > > > On Sun, 12 Mar 2023 10:55:45 -0700
> > > > isaku.yamahata@intel.com wrote:
> > > > 
> > > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > > 
> > > > > Because TDX KVM doesn't support PMU yet (it's future work of TDX KVM
> > > > > support as another patch series) and pmu_intel.c touches vmx specific
> > > 
> > > It would be nice to have pmu support for tdx-guest from the very beginning.
> > 
> > It's supported in the public github repo.
> > https://github.com/intel/tdx/tree/kvm-upstream-workaround
> > As this patch series has 100+ patches, I don't want to bloat this patch more.
> 
> I presume we are talking about 873e2391e729...63761adbf5aa for TD pmu:
> 
> A quick glance brought me at least these comments:
> 
> (1) how does intel_pmu_save/restore() handle the enabled host LBR/PEBS ?

It's not handled yet. We need to save/restore those MSRs.


> (2) guest PMI injection may be malicious and could the current guest pmu
> driver handle it ?

This isn't specific to PMI.  Malicious VMM can inject any interrupt to the
guest at any time.  Guest should be prepared for it.


> (3) how do we handle the case when host counters can be enabled before TDENTER
> for debuggable TD and support the case like "perf-kvm for both guest and host" ?

On TDEXIT, those are disabled. VMM has to restore MSRs and enable it again.
There is a window where events can be missed.


> My point is actually, changes to perf/core should be CC to the perf reviewers
> as early as possible to prevent key player from killing the direction.

Sure, agreed.


> > > > > structure in vcpu initialization, as workaround add dummy structure to
> > > > > struct vcpu_tdx and pmu_intel.c can ignore TDX case.
> > > 
> > > If the target is not to provide a workaround, how about other variants:
> > > 	- struct lbr_desc lbr_desc;
> > > 	- pebs ds_buffer;
> > > ?
> > > 
> > > We also need tdx selftest to verify the unavailability of these features.
> > > Also, it would be great to have TDX's "System Profiling Mode" featue back in
> > > the specification.
> 
> Detailed TD (plus debuggable) PMU selftest would clearly speed up the review
> process.

The existing KVM PMU selftest can be utilized. Or do you have something else in
mind?

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
