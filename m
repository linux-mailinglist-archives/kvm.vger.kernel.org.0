Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0845059D83A
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 12:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351404AbiHWJj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 05:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351505AbiHWJik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 05:38:40 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F30C5F9BC;
        Tue, 23 Aug 2022 01:40:52 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id e19so12193157pju.1;
        Tue, 23 Aug 2022 01:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=BjyTp1rYXZbh0tG3MYfP1QG1fJZgUbfQ/sbIoo651Uo=;
        b=HfohDmdWLWKSq9YTwl/9HcIjQ9n+PpwN9SG+tgxAKvwcdnDOaUmbnpsPXomnO8pDbQ
         jvvh+MxiSNkiupFmYdS8P9u7hLDB9h2j4CKJm0hlx6k9K1NUogQ5S5mElTOIA21veSN4
         NIZ/7iWsMluW2jJm3UX/BtK4T8TYEYuAxwUNU8gxdjn+6RUrrMb4A7RM1mxTV/q4AK61
         6tM2NUbuYhq/NnMbl6h6cugoCGeoE65SorFq+eDb7tDlXlcHcVn5RKnEkgVPFV6dkGl9
         X9z8ZDtWhiZfPatTbCtCA8VYuMDrEnLjn6koUJVw56JaWnT7Cq44tygpTZ6NuS0OFtOH
         U1wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=BjyTp1rYXZbh0tG3MYfP1QG1fJZgUbfQ/sbIoo651Uo=;
        b=cGvR/1B5X5VdP9M3LNlQ6p26EuNaNwk5DU/C1drqstxWm08AI7EvfttDNQvgEmB1/t
         JhF/3E082mCcZ99uZRhcHweZsnLKZ2dkExKSfNQjguo1LD8Hw9p/attkIcxAjSwFTIcK
         yaGO5DKnCVKi6ctpA24xmxbn7yP0QSD3XJ9/c8PdpaxyJ38OFOdrSNGexhCPRTlSUI0l
         8GqLvW5OKDcTqtlhm4biDguJjmPYfFUkyGH/QUaVERJLZbbrRIRvpKjKYwE3Qcxd9Dzh
         XmYeFO/+T2wpGGBh2X3NkAc45S/0UNP9/9jC65MaCWv5s2f7MPrkS9aPeE6YYrKn2WFP
         zIIQ==
X-Gm-Message-State: ACgBeo0dnBl3+NfMlsYq/c6YFPfK7qLOTD5TD/m1rTcgDa5TKEDqSbWC
        +Y311LOAmPXVM6vJI2DRp4I=
X-Google-Smtp-Source: AA6agR7bqHHDTFsoQJM3fNgJxY16Za603VCMAuEoJ2sYDxB9TB6siix6ySC1b7udrSjQA7v1iONuDw==
X-Received: by 2002:a17:90b:1bd1:b0:1fb:5640:ffa4 with SMTP id oa17-20020a17090b1bd100b001fb5640ffa4mr2212440pjb.220.1661244005306;
        Tue, 23 Aug 2022 01:40:05 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id k17-20020a170902c41100b001709b9d292esm10001850plk.268.2022.08.23.01.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 01:40:04 -0700 (PDT)
Date:   Tue, 23 Aug 2022 01:40:03 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH 03/18] KVM: Drop kvm_count_lock and instead protect
 kvm_usage_count with kvm_lock
Message-ID: <20220823084003.GF2147148@ls.amr.corp.intel.com>
References: <cover.1660974106.git.isaku.yamahata@intel.com>
 <6b07c02dd361f834fea442eb8dae53f23618f983.1660974106.git.isaku.yamahata@intel.com>
 <YwQ6wTmbja4h2TYZ@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YwQ6wTmbja4h2TYZ@gao-cwp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 23, 2022 at 10:26:09AM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> On Fri, Aug 19, 2022 at 11:00:09PM -0700, isaku.yamahata@intel.com wrote:
> >From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> >Because kvm_count_lock unnecessarily complicates the KVM locking convention
> >Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock for
> >simplicity.
> >
> >Opportunistically add some comments on locking.
> >
> >Suggested-by: Sean Christopherson <seanjc@google.com>
> >Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> >---
> > static cpumask_var_t cpus_hardware_enabled;
> >@@ -4999,6 +4998,8 @@ static void hardware_enable_nolock(void *junk)
> > 	int cpu = raw_smp_processor_id();
> > 	int r;
> > 
> >+	WARN_ON_ONCE(preemptible());
> >+
> > 	if (cpumask_test_cpu(cpu, cpus_hardware_enabled))
> > 		return;
> > 
> >@@ -5015,10 +5016,10 @@ static void hardware_enable_nolock(void *junk)
> > 
> > static int kvm_starting_cpu(unsigned int cpu)
> > {
> >-	raw_spin_lock(&kvm_count_lock);
> >+	mutex_lock(&kvm_lock);
> 
> kvm_starting_cpu() is called with interrupt disabled. So we cannot use
> sleeping locks (e.g., mutex) here.


So your patch to move it to online section [1] is needed.
I thought I can pullin only some of your patches.  But whole your patches are
needed.

[1] https://lore.kernel.org/lkml/20220317091539.GA7257@gao-cwp/T/#mcc0fd81e7a19601e7c3ce451582c516d38f977f6
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
