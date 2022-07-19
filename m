Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904BB57A344
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 17:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbiGSPfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 11:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237501AbiGSPfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 11:35:37 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EF0481C9;
        Tue, 19 Jul 2022 08:35:33 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id n4-20020a17090a73c400b001f1e87432c2so3379145pjk.3;
        Tue, 19 Jul 2022 08:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=UclPjRtdOz+JB3MGmSCiWOP3Nyp1MqXa2Tu7St3ZYEw=;
        b=VeaHRLR2ohg/rX6Q4nsJA+xJIpAiBUUJeYNVVO+FgIqY1Xm/6TgNhoiML5wnIS4qjn
         T68WGFcGA+E74i5mqeISw+Tkm0aAnjrux4m+xzObZc5jF7Ca+ziAGUiiJQ+EJLEUK5Rk
         9tcB/Vdcn1cltA+gV50KColR/yl4ulYgra2lLIz/kwn9p7PIQjUwr+ZbnVH7tboW5Lnc
         Got7mO75VXD/r1ks0i/7V1XwQOOds1tRov8rPaDl8GfijJyx5/a30lpPc4wJzU6tx5gB
         yUmJHk7P3+lNZGH12hBYPCZdS3QD4vjuR4oCP8OgUTG2JkOgJwdso+P8I0losgs8KP/l
         nLRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=UclPjRtdOz+JB3MGmSCiWOP3Nyp1MqXa2Tu7St3ZYEw=;
        b=wMu6nEmYDdhPBzyyXdvrSoc3oWQbgR0kznwj7STmta+mphJKW82meK54HHp7/X5DeI
         /d4Ozn8xqtDYRYiulJRTyiVpHzm2ytUriAgGocuF9k8RK7b0RKJKzDoHqAW7NlYMELbM
         fNRFGG7wm+T+iEhGXxdjovDhcTCv0JpV3JYIOOtt3oQyB9PAOYVCJnv/L+axypK9QpKk
         Xm+IU6kFtxGTEYj420ACb/1Sn7rMn+hTJhJotF7nBEzHwjTrZlSomewpMC8OONDBonH5
         iU6gJZvVHg1lEgR6v+iGGQETYa98Hg3Sqn6bDDipkZ1pJfwGaavtsi1/ko8bJV7Htzkl
         0WWg==
X-Gm-Message-State: AJIora9ljunzRk0FuX3QRmVkKNZgYean4GelpTv4dcThok5haOXZXJNz
        lOGbcKM/LDsSvZtsAPnD2KE=
X-Google-Smtp-Source: AGRyM1uwHBz/pVTQVTgrBUY4TRaD1QMeUUSXu5K1CHQwZKarfm3DBfvdnMoQQglDJhj7LnsWbnh8Sg==
X-Received: by 2002:a17:902:f606:b0:168:ecca:44e with SMTP id n6-20020a170902f60600b00168ecca044emr33389241plg.144.1658244932750;
        Tue, 19 Jul 2022 08:35:32 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id e15-20020a056a0000cf00b005255489187fsm11606247pfj.135.2022.07.19.08.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 08:35:31 -0700 (PDT)
Date:   Tue, 19 Jul 2022 08:35:30 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 044/102] KVM: x86/mmu: Add a private pointer to struct
 kvm_mmu_page
Message-ID: <20220719153530.GZ1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <392839e09c48ff4e14a598ff6ed8bd56429bf17b.1656366338.git.isaku.yamahata@intel.com>
 <41fb3e95a9635757a79e73e38ecc3c7b3a37fd8d.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <41fb3e95a9635757a79e73e38ecc3c7b3a37fd8d.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 01, 2022 at 11:12:44PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > For private GPA, CPU refers a private page table whose contents are
> > encrypted.  The dedicated APIs to operate on it (e.g. updating/reading its
> > PTE entry) are used and their cost is expensive.
> > 
> > When KVM resolves KVM page fault, it walks the page tables.  To reuse the
> > existing KVM MMU code and mitigate the heavy cost to directly walk
> > encrypted private page table, allocate a more page to mirror the existing
> > KVM page table.  Resolve KVM page fault with the existing code, and do
> > additional operations necessary for the mirrored private page table.  To
> > distinguish such cases, the existing KVM page table is called a shared page
> > table (i.e. no mirrored private page table), and the KVM page table with
> > mirrored private page table is called a private page table.  The
> > relationship is depicted below.
> > 
> > Add private pointer to struct kvm_mmu_page for mirrored private page table
> > and add helper functions to allocate/initialize/free a mirrored private
> > page table page.  Also, add helper functions to check if a given
> > kvm_mmu_page is private.  The later patch introduces hooks to operate on
> > the mirrored private page table.
> > 
> >               KVM page fault                     |
> >                      |                           |
> >                      V                           |
> >         -------------+----------                 |
> >         |                      |                 |
> >         V                      V                 |
> >      shared GPA           private GPA            |
> >         |                      |                 |
> >         V                      V                 |
> >  CPU/KVM shared PT root  KVM private PT root     |  CPU private PT root
> >         |                      |                 |           |
> >         V                      V                 |           V
> >      shared PT            private PT <----mirror----> mirrored private PT
> >         |                      |                 |           |
> >         |                      \-----------------+------\    |
> >         |                                        |      |    |
> >         V                                        |      V    V
> >   shared guest page                              |    private guest page
> >                                                  |
> >                            non-encrypted memory  |    encrypted memory
> >                                                  |
> > PT: page table
> > 
> > Both CPU and KVM refer to CPU/KVM shared page table.  Private page table
> > is used only by KVM.  CPU refers to mirrored private page table.
> 
> Shouldn't the private page table maintained by KVM be "mirrored private PT"?
> 
> To me "mirrored" normally implies it is fake, or backup which isn't actually
> used.  But here "mirrored private PT" is actually used by hardware.
> 
> And to me, "CPU and KVM" above are confusing.  For instance, "Both CPU and KVM
> refer to CPU/KVM shared page table" took me at least one minute to understand,
> with the help from the diagram -- otherwise I won't be able to understand.
> 
> I guess you can just say somewhere:
> 
> 1) Shared PT is visible to KVM and it is used by CPU;
> 1) Private PT is used by CPU but it is invisible to KVM;
> 2) Mirrored private PT is visible to KVM but not used by CPU.  It is used to
> mirror the actual private PT which is used by CPU.

I removed "mirror" word and use protected for encrypted page table.


    KVM: x86/mmu: Add a private pointer to struct kvm_mmu_page
    
    For private GPA, CPU refers a private page table whose contents are
    encrypted.  The dedicated APIs to operate on it (e.g. updating/reading its
    PTE entry) are used and their cost is expensive.
    
    When KVM resolves KVM page fault, it walks the page tables.  To reuse the
    existing KVM MMU code and mitigate the heavy cost to directly walk
    protected (encrypted) page table, allocate one more page to copy the
    protected page table for KVM MMU code to directly walk.  Resolve KVM page
    fault with the existing code, and do additional operations necessary for
    the protected page table.  To distinguish such cases, the existing KVM page
    table is called a shared page table (i.e. not associated with protected
    page table), and the page table with protected page table is called a
    private page table.  The relationship is depicted below.
    
    Add a private pointer to struct kvm_mmu_page for protected page table and
    add helper functions to allocate/initialize/free a protected page table
    page.  Also, add helper functions to check if a given kvm_mmu_page is
    private.  The later patch introduces hooks to operate on the protected page
    table.
    
                  KVM page fault                     |
                         |                           |
                         V                           |
            -------------+----------                 |
            |                      |                 |
            V                      V                 |
         shared GPA           private GPA            |
            |                      |                 |
            V                      V                 |
        shared PT root      private PT root          |    protected PT root
            |                      |                 |           |
            V                      V                 |           V
         shared PT            private PT ----propagate----> protected PT
            |                      |                 |           |
            |                      \-----------------+------\    |
            |                                        |      |    |
            V                                        |      V    V
      shared guest page                              |    private guest page
                                                     |
                               non-encrypted memory  |    encrypted memory
                                                     |
    PT: page table
    - Shared PT is visible to KVM and it is used by CPU.
    - Protected PT is used by CPU but it is invisible to KVM.
    - Private PT is visible to KVM but not used by CPU.  It is used to
      propagate PT change to the actual protected PT which is used by CPU.
    
    Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
