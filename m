Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9FD5EB650
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 02:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiI0AhX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 20:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiI0AhW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 20:37:22 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA2E6A4A8
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 17:37:21 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id a80so8283513pfa.4
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 17:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=yK1wUEHaFlDc/Sjgqcdy+Ekxm5BkDyOr+Wjgykrs1lA=;
        b=j2KDt9ueIU1q0hjN84tZOT8JOAZ3lehkvQB9wEhlW8vbwgoWB1LThbT5kkm1k2Th1o
         aSDJT4JXnIxKVbFjmQjsErwASSTwls0mpaaPrTDaJarKTax8ApJthDo0GbsIAM9cWnRf
         VWNx1xaU0mk74GSgRVYpplzqBWazvX8R5Rl/5cvgFoxvK3NCM+VYD6KRVq8bQMoOSgby
         6GqCYv8cx4lrKKtUB7bM/bkTQG2pLYtnNbRLtLxeRr8Iz2OIHC4G+U2enViR+wnWoKNl
         hdwqx1UHM1lHAol7LwG/co2KLKpKV7yFUpWgSjaaOY+SnDOEmLSC7Z1nkRcy/UVUw22G
         71ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=yK1wUEHaFlDc/Sjgqcdy+Ekxm5BkDyOr+Wjgykrs1lA=;
        b=AAdDGgLOHknGcMLJnZMfpe4+gVsJvZHP3PtsaWOkJQI2LqzJUjF5t+nfb8KgV1SLBn
         FghCn2jPUXjoiKr2YTmjxuV22Cse4iJFM9KivMR+ZsC3IPVjBSIztr0Xdoa4/i02LvSj
         QYEeOeKSEA8EkFJZniRe7bBSbbt2QzniG3fu8sB2qRe3LvDdHNzkNiTR069jiNs492qo
         wNJ/7FWcNAm5ijayttyW0Z5sP42AjJ9Vr1C8z9Em4v1rvD3cZa+fbQy03HwQDb3Imy8h
         qQQAcV5g/wO7QGCQaKiYcWcu8FRXIuYlG/9GmjzBvK2oevEH43ZSvP2CkSJBV1mouw8V
         J+pg==
X-Gm-Message-State: ACrzQf2mcQ9KBJneikbGbN/GOBwjZKIhsfpHft6PBe23Gp0mbRbJMDy7
        Np//+aqnGucbc0aSxIDbeMd+Hw==
X-Google-Smtp-Source: AMsMyM47ZbQm4iuNZO0wTcxfjuiWpZ6wmmEoXJz6WS+2ZtfI5u+pIL5/nMfJ2yZ6W/uV+ZT+sNVxVA==
X-Received: by 2002:a05:6a00:2488:b0:540:e5e5:ba48 with SMTP id c8-20020a056a00248800b00540e5e5ba48mr26577855pfv.51.1664239041313;
        Mon, 26 Sep 2022 17:37:21 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q15-20020a170902f78f00b0016c9e5f291bsm48560pln.111.2022.09.26.17.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 17:37:20 -0700 (PDT)
Date:   Tue, 27 Sep 2022 00:37:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     ovidiu.panait@windriver.com, kvm@vger.kernel.org,
        liam.merwick@oracle.com, mizhang@google.com, pbonzini@redhat.com,
        thomas.lendacky@amd.com, michael.roth@amd.com, pgonda@google.com,
        marcorr@google.com, alpergun@google.com, jarkko@kernel.org,
        jroedel@suse.de, bp@alien8.de, rientjes@google.com
Subject: Re: [PATCH 5.4 1/1] KVM: SEV: add cache flush to solve SEV cache
 incoherency issues
Message-ID: <YzJFvWPb1syXcVQm@google.com>
References: <20220926145247.3688090-1-ovidiu.panait@windriver.com>
 <20220927000729.498292-1-Ashish.Kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927000729.498292-1-Ashish.Kalra@amd.com>
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

On Tue, Sep 27, 2022, Ashish Kalra wrote:
> With this patch applied, we are observing soft lockup and RCU stall issues on
> SNP guests with 128 vCPUs assigned and >=10GB guest memory allocations.

...

> From the call stack dumps, it looks like migrate_pages() > The invocation of
> migrate_pages() as in the following code path does not seem right: 
>     
>     do_huge_pmd_numa_page
>       migrate_misplaced_page
>         migrate_pages
>     
> as all the guest memory for SEV/SNP VMs will be pinned/locked, so why is the
> page migration code path getting invoked at all ?

LOL, I feel your pain.  It's the wonderful NUMA autobalancing code.  It's been a
while since I looked at the code, but IIRC, it "works" by zapping PTEs for pages that
aren't allocated on the "right" node without checking if page migration is actually
possible.

The actual migration is done on the subsequent page fault.  In this case, the
balancer detects that the page can't be migrated and reinstalls the original PTE.

I don't know if using FOLL_LONGTERM would help?  Again, been a while.  The workaround
I've used in the past is to simply disable the balancer, e.g.

  CONFIG_NUMA_BALANCING=n

or
  
  numa_balancing=disable

on the kernel command line.
