Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C862360814E
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 00:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJUWFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 18:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiJUWFI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 18:05:08 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DE35A175
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 15:05:06 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id j188so4760980oih.4
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 15:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E9Hi7xe9mNjMM8Rl5ailEOjxrPhL0i5OBm59MJ6WOaU=;
        b=fHEOa5WZs7by0EJj9/DHwtdnLYQEJdAWw7lR0mD20jiKV0F+fAiKWmk9IWzvWWYyPs
         t4oGu/3Myxcoqe4XfcVUhBGUP8VW3AbqBUBkNQxz4ck0wX1LH7NvJEQWRPMsUY5RUXYz
         cEoHkbpi+2gsQ8Td+acjtvhPboGj/VnsZ1bK5QhyrHLwXsngDHJCVYP7IuKi71v6yaN+
         53DVczkPfyRWGcrIZxYDMct5B3Y5k10JXugE6KGRxd9U0lObCiKsChenKyAan12bCQW+
         lak2IwAsW80hZmfp771jWjQGLK+pAAcy6k666+Xq8wGVST3U7x4hJtSa7hw21VEFZSTi
         gqUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E9Hi7xe9mNjMM8Rl5ailEOjxrPhL0i5OBm59MJ6WOaU=;
        b=OKBqCWXMOqxdBFWTkeRBONX1Xh9N+4F+wLHdsWTA8D/fWrbcWFA4rAJ0dqYqe3zkKD
         Hv/yJy1eRzo2M9HIQm5G9QtyGdGxu9Pb/Gew4aHOxT3PFzB4Gi6PNWExhyX72QILJ0Eu
         tsWxyzNTvK1ssyhQBnSNmiyMLguxLJar81x6AGHuVJQ+QxulLbM4AMU72a5KOrc5mTXl
         7HsiBf9ZEP4X6sJ7oA/hKTNvUYE7TOTOIFDXymQ649U3hO14G9CPSmnMPtAHpeUoWvP6
         8iFzEt/ErRNIPKNLrrr7HfF+YC3Fb18T3ItGf1U4g7clGA/mdKoIHXeh6A5WyPWVF/O1
         Mo2g==
X-Gm-Message-State: ACrzQf3W8tn10sF511va8b07/s15Pm0uk6h0B2PufOTwli0HS/uokC8P
        Gzbx6kpfEQ4+kNuiW87JfBORTA1b+pF5/g==
X-Google-Smtp-Source: AMsMyM6iIi0gsKZXyV9jgdZu5ybIg+ilY+yN48Up7+kOtQAF9Nvq8ch/IxhQPS8kwb0fO+/jRes0vA==
X-Received: by 2002:a17:90a:e7c8:b0:20d:6c60:c38 with SMTP id kb8-20020a17090ae7c800b0020d6c600c38mr24668018pjb.26.1666389894966;
        Fri, 21 Oct 2022 15:04:54 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 7-20020a17090a174700b00212c9dae41fsm301344pjm.16.2022.10.21.15.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 15:04:54 -0700 (PDT)
Date:   Fri, 21 Oct 2022 22:04:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     vkuznets@redhat.com, pbonzini@redhat.com, dmatlack@google.com,
        kvm@vger.kernel.org, shujunxue@google.com, terrytaehyun@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Add Hyperv extended hypercall support in KVM
Message-ID: <Y1MXgjtPT9U6Cukk@google.com>
References: <20221021185916.1494314-1-vipinsh@google.com>
 <Y1L9Z8RgIs8yrU6o@google.com>
 <CAHVum0eoA5j7EPmmuuUb2y7XOU1jRpFwJO90tc+QBy0JNUtBsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0eoA5j7EPmmuuUb2y7XOU1jRpFwJO90tc+QBy0JNUtBsQ@mail.gmail.com>
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

On Fri, Oct 21, 2022, Vipin Sharma wrote:
> On Fri, Oct 21, 2022 at 1:13 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Fri, Oct 21, 2022, Vipin Sharma wrote:
> > > Hyperv hypercalls above 0x8000 are called as extended hypercalls as per
> > > Hyperv TLFS. Hypercall 0x8001 is used to enquire about available
> > > hypercalls by guest VMs.
> > >
> > > Add support for HvExtCallQueryCapabilities (0x8001) and
> > > HvExtCallGetBootZeroedMemory (0x8002) in KVM.
> > >
> > > A guest VM finds availability of HvExtCallQueryCapabilities (0x8001) by
> > > using CPUID.0x40000003.EBX BIT(20). If the bit is set then the guest VM
> > > make hypercall HvExtCallQueryCapabilities (0x8001) to know what all
> > > extended hypercalls are supported by hypervisor.
> > >
> > > A userspace VMM can query capability KVM_CAP_HYPERV_EXT_CALL_QUERY to
> > > know which extended hypercalls are supported in KVM. After which the
> > > userspace will enable capabilities for the guest VM.
> > >
> > > HvExtCallQueryCapabilities (0x8001) is handled by KVM in kernel,
> >
> > Does this really need to be handle by KVM?  I assume this is a rare operation,
> > e.g. done once during guest boot, so performance shouldn't be a concern.  To
> > avoid breaking existing userspace, KVM can forward HV_EXT_CALL_GET_BOOT_ZEROED_MEMORY
> > to userspace if and only if HV_ENABLE_EXTENDED_HYPERCALLS is enabled in CPUID,
> > but otherwise KVM can let userspace deal with the "is this enabled" check.
> 
> There are 4 more extended hypercalls mentioned in TLFS but there is no
> detail about them in the document. From the linux source code one of
> the hypercall HvExtCallMemoryHeatHint (0x8003) is a repetitive call.
> In the file drivers/hv/hv_balloon.c
>           status = hv_do_rep_hypercall(HV_EXT_CALL_MEMORY_HEAT_HINT,
> nents, 0,  hint, NULL);
> 
> This makes me a little bit wary that these hypercalls or any future
> hypercalls can have high calling frequency by Windows guest. Also, it
> is not clear which calls can or cannot be satisfied by userspace
> alone.

If future support needs to be moved into KVM, e.g. for performance reasons, then
we can do that if necessary.  

> So, I am not sure if the default exit to userspace for all of the
> extended hypercalls will be future proof, therefore, I went with the
> approach of only selectively exiting to userspace based on hypercall.

But punting on everything _might_ be future proof, whereas the only way that
selectively exiting ends up being future proof is if no one ever wants to support
another extended hypercall.
