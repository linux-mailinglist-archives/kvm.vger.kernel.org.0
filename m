Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE4D4E67D2
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 18:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239345AbiCXRbN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 13:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbiCXRbL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 13:31:11 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BE955745
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 10:29:40 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso5756553pjb.5
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 10:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xkTTX4lGVmunWcx6XE9IvQD+TCrd2C88fOUNhq2ndSg=;
        b=THw1o7ZnSyk0YJ3+tdQ+3l7/v1PLdEKzmivbzPVqRxFfvHoKime1xOmdRwtdhv01Dd
         WFgcJs+3vN+f96VddAKhBPaZF97NhGO85qDYoJ/CzICeQHOsK+JxL/yw4kX/aKY/ykMT
         QLNAEM3+oyQVSAmV4EDEuK0XtEBx6DsEmy8GRK4klrt/ZoCprz58zg11LNuI5Z7ZQpIm
         9QfRJVUBEyIyvZ9ICII7bn6pMXSR20ECHCFOyY5bdNVi/tbAOGmupdjK3tM1VwX40Zge
         tQ8iBfJPq3qPSa3MRSw37P+BXFTt2E6ROMkTNaMS1ItW6FjdEp+/1i0JUWBRiQqb3qdL
         IpKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xkTTX4lGVmunWcx6XE9IvQD+TCrd2C88fOUNhq2ndSg=;
        b=b8l2rR65V0vebMLe59OE48TjabbCQ+oHg0PSSMfNgc/09LINPTlFvakwoyDrcp2fsY
         ECf9/eXy1r2ZMewOVhITUIilgArXJL484lgt96wnTDfEFCX4sL9hvOzYce98cz1+buQr
         ua9xAL5F6snYRdFPs9aeciX5vNnmaJuL3Wnj372W8KcWW3qlBXMgpKD73q764SEMGY0N
         FghuNPGpQDeAI7L7CoTxh8NpKSmt0WJK+fhpG9yGmeCDu839QfGTVR0srmpfkrAUDDV4
         /yBLuNESlsHX0gLFBbviJphgBIpiTA0Gr4q9lEuQ5zXsc0z4/CHby9qRlRluMFQRNapC
         CQrg==
X-Gm-Message-State: AOAM531niaily+cD4qvWetFu1vnpr7vNASfZ3fQ1JNJKI6faae62EuEa
        S1Dx1qlWd6bUKi2QsO6K51tg83u0U1zGpw==
X-Google-Smtp-Source: ABdhPJzOMu6mvyY1YouBquvjkuhDjA6k7BFTNwshrVqNe7o2tIILDiNi07FpzF3EpqnQGjzU1BXq9A==
X-Received: by 2002:a17:90b:4c8c:b0:1c6:f86d:a6f5 with SMTP id my12-20020a17090b4c8c00b001c6f86da6f5mr19717021pjb.15.1648142979296;
        Thu, 24 Mar 2022 10:29:39 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id k3-20020a056a00168300b004f7e60da26csm4368286pfc.182.2022.03.24.10.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 10:29:38 -0700 (PDT)
Date:   Thu, 24 Mar 2022 10:29:35 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, maz@kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 2/4] KVM: selftests: add is_cpu_online() utility
 function
Message-ID: <Yjyqf5oAxZzC7g7H@google.com>
References: <20220322172319.2943101-1-ricarkol@google.com>
 <20220322172319.2943101-3-ricarkol@google.com>
 <YjyoJu0/Saowtrbc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjyoJu0/Saowtrbc@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 24, 2022 at 05:19:34PM +0000, Sean Christopherson wrote:
> On Tue, Mar 22, 2022, Ricardo Koller wrote:
> > Add is_cpu_online() utility function: a wrapper for
> > "/sys/devices/system/cpu/cpu%d/online".
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  tools/testing/selftests/kvm/include/test_util.h |  2 ++
> >  tools/testing/selftests/kvm/lib/test_util.c     | 16 ++++++++++++++++
> >  2 files changed, 18 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> > index 99e0dcdc923f..14084dc4e152 100644
> > --- a/tools/testing/selftests/kvm/include/test_util.h
> > +++ b/tools/testing/selftests/kvm/include/test_util.h
> > @@ -143,4 +143,6 @@ static inline void *align_ptr_up(void *x, size_t size)
> >  	return (void *)align_up((unsigned long)x, size);
> >  }
> >  
> > +bool is_cpu_online(int pcpu);
> > +
> >  #endif /* SELFTEST_KVM_TEST_UTIL_H */
> > diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> > index 6d23878bbfe1..81950e6b6d10 100644
> > --- a/tools/testing/selftests/kvm/lib/test_util.c
> > +++ b/tools/testing/selftests/kvm/lib/test_util.c
> > @@ -334,3 +334,19 @@ long get_run_delay(void)
> >  
> >  	return val[1];
> >  }
> > +
> > +bool is_cpu_online(int pcpu)
> > +{
> > +	char p[128];
> > +	FILE *fp;
> > +	int ret;
> > +
> > +	snprintf(p, sizeof(p), "/sys/devices/system/cpu/cpu%d/online", pcpu);
> 
> I don't think this is sufficient for the use in patch 03; the CPU could be online
> but disallowed for use by the current task.  I think what you want instead is a
> combination of get_nprocs_conf() + sched_getaffinity() + CPU_ISSET().

Good point. I was just thinking about the more common situation where a
user tries to use a CPU that doesn't even exist. Will fix in v4.

Thanks,
Ricardo
