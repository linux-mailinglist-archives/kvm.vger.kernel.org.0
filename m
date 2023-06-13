Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42FEB72E9D9
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 19:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbjFMRb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 13:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbjFMRbv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 13:31:51 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BAE1FC4;
        Tue, 13 Jun 2023 10:31:21 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-65131e85be4so6148572b3a.1;
        Tue, 13 Jun 2023 10:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686677481; x=1689269481;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9gwggrrTCd3fmtnE+bDUolvMX6NQ3t3WZmbENaeJBoM=;
        b=PISkHaBuS3mRUYJlO4nJJs7GW6ULLaJcmEcYK1UIEEcfaZPNHdb7TIS1uQAL9tSLPJ
         GscNqJZNr+ILzf+T2SYDXkT216YFYs97ZituBxQxKE4B5sYouyWgEvUdDpuGMpoNBp0v
         WBSwt8+sT7HEcKUYZH/ue4Ljlzc5PkDElKr0qyYWSRqc48HNdJINpbj2WlSvpVN+yHtV
         f6t8D/SPU7JHpM7mJ/0XM7KPTstiKv3TwCXXAsIgrJZW69wkn7mPS+B7vGu3CpaJ/j3M
         nKeHTApU5NehqHJTbdaHZidg+oFytWYhqJMAN8QaFWWp2Q76S9aLqLg6PVkCYL1JDo+l
         QofQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686677481; x=1689269481;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9gwggrrTCd3fmtnE+bDUolvMX6NQ3t3WZmbENaeJBoM=;
        b=Zwfp/f7qCt7oIZr8uo7OC0Hx1fnpOPCGkh0sYrYdKJMC5WEpqOMARtOE6TMjgDvFwd
         RgjDtLEFXz7R0r34gmSv1Mpgk5a/DcAecp0VcvUutGMH+luMSD1w0UvSE1uszabwIpdx
         0ZhgrpTbsyVL1wjBaPI4bq7O3uXrdFc1CJe8USuNVvoVqmw9znq++LpoE5IPOSqCVP5l
         LGAUAMrIldvSiT7PIethO0e1bLAdB/BZ5VfXK0j17FCvkweM3GsKQhPTGa0AyIaSzdTn
         g1JGfLvAjZa3d8kw7cKDk1Vhb7SbCTgW9vQWMw/1IHaxR5eGJjw18u6YfYtGk/fk3Yfq
         fZMw==
X-Gm-Message-State: AC+VfDwjZxkgMQvErCYIxhqchaT5juS+groV0hcjnTRNilsxmD17aajQ
        u/TYOq9etYcd5ssaS5gXYX4=
X-Google-Smtp-Source: ACHHUZ4wIeo/npYX82XmWso98Ha4rFtX2QJThPCERDu1LAATOythu3zoC4U4Z9S8/aK8iNpxx06pkQ==
X-Received: by 2002:a05:6a20:8e13:b0:10b:4539:fa0a with SMTP id y19-20020a056a208e1300b0010b4539fa0amr17104140pzj.1.1686677480710;
        Tue, 13 Jun 2023 10:31:20 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id v12-20020aa7850c000000b00639fc7124c2sm1059516pfn.148.2023.06.13.10.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 10:31:19 -0700 (PDT)
Date:   Tue, 13 Jun 2023 10:31:18 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chen, Bo2" <chen.bo@intel.com>, "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v14 111/113] RFC: KVM: x86, TDX: Add check for setting
 CPUID
Message-ID: <20230613173118.GO2244082@ls.amr.corp.intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <00f3770050fb0751273a48eb17804a7a1a697e75.1685333728.git.isaku.yamahata@intel.com>
 <05da9ce1eacab59e81801acca146b5f4949b98ac.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <05da9ce1eacab59e81801acca146b5f4949b98ac.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023 at 11:57:35PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Sun, 2023-05-28 at 21:20 -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Add a hook to setting CPUID for additional consistency check of
> > KVM_SET_CPUID2.
> > 
> > Because intel TDX or AMD SNP has restriction on the value of cpuid.  Some
> > value can't be changed after boot.  Some can be only set at the VM
> > creation time and can't be changed later.  Check if the new values are
> > consistent with the old values.
> 
> You might want to use some grammar tool to check against the changelog.
> 
> Also, personally I think it's better to briefly mention why we choose this
> design but not another (e.g., why we just don't make KVM remember all CPUIDs in
> TDH.MNG.INIT and simply ignores/rejects further KVM_SET_CPUID2).  It would be
> helpful for the reviewer, or some git blamer in the future.
> 

> And why this patch is placed at the very bottom of this series? This logic
> should belong to TD creation part which should be at a relative earlier position
> in this series.

Because this is nice-to-have, not necessary for this patch series to work.  


> > @@ -32,6 +32,13 @@ struct kvm_tdx {
> >  	atomic_t tdh_mem_track;
> >  
> >  	u64 tsc_offset;
> > +
> > +	/*
> > +	 * For KVM_SET_CPUID to check consistency. Remember the one passed to
> > +	 * TDH.MNG_INIT
> > +	 */
> > +	int cpuid_nent;
> > +	struct kvm_cpuid_entry2 *cpuid;
> 
> Since these CPUIDs may only be part of the vcpu's CPUIDs, you may want a more
> specific name, for instance, consistent_cpuid?
> 
> Also if you want this be common to AMD, then perhaps the comment should be
> improved too to be more generic.

Because I don't see apparent constraint on cpuid for SEV case in the spec, I
doubt they want it.  Please correct me if I'm wrong.

Given tdx_vcpu_check_cpuid() doesn't do much meaningful check, let's postpone
this patch for now.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
