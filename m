Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1705263B623
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 00:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbiK1XvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 18:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234725AbiK1XvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 18:51:15 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E1A28E3A
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 15:51:14 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id w23so11746934ply.12
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 15:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oVgoeAVnfsk2iXYG0JTdu0THjStYeYpgj9cQZUW7cks=;
        b=ZWgV6HJIMapNybCv4vR6zXDsW6Z7GIO+i/wZEeRsIK8vPOSFXAioyWuCwuOKWrl5yD
         Nni6kSMkTP5RwO4ue+RjMY/l20JLoL+rB8a92x1ucdJjD+orCMDfUTWPyfhAJ9KfOmbK
         BxW2kgEhqa+jUNkXQoPBqUjp4hjnhUjT6Pxq9J+3TAdFvSqxKnsnF83lek83CJTdfGoH
         6+mljQF+SC5lQ+cNDQ13IXoDXg3ExOEVH/sUG2CIfrYPoi1cMTzbWraOOI0pbFb3fAVy
         cFzEpEmy7dGhKyQhZRampL5tVSD+egmW/f9LgGTnIWfRKZzxas6kkiv6RMa77MYEZhKn
         l/hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oVgoeAVnfsk2iXYG0JTdu0THjStYeYpgj9cQZUW7cks=;
        b=M1KOy0gp4woNbRDstwQaWnVS82leXzovGF4lbbnmIdSQCkYayzAO0VF6er2dspd6Qa
         lhXxplx7RG3n//FieodyniGs7GjfQSsC56DmXBT6ppFSqycogxsIsK2Mzti+wR5vYcuD
         tN/28VEb+xzvleD/u7FGMAs6l6vWo2DO2K/rTYnVyNyWbEOJsZjmf3QsFRNj0m3HNxdf
         ISVRuWh3+lky7o2/oGrhQ6gXl+dLPPlQtinBEDGsFQiqbndtTfxTMpB2DtP8t41YM5dQ
         Oak65U3H74RUN7qGnNwkC8c8bfzkkrNbZ0PWRC04m24LSXTRtDNqH9HRDhnn83lhmm+3
         yn5w==
X-Gm-Message-State: ANoB5pnPqa+OnzWXjlUPGEBRvkc8howUix4cVAfW09tAmjZXBTEt04ta
        9EunqhfvThBOCO0mj/V2/8WQSHck+CXQlQ==
X-Google-Smtp-Source: AA0mqf4NTXD1EHu2Cevt0auVcetSPnQ6e77T7FE4dlWd2ySwt8m5T4jr2ialJIYYV92GIt+aZwM2Gg==
X-Received: by 2002:a17:902:7688:b0:186:971b:b7e5 with SMTP id m8-20020a170902768800b00186971bb7e5mr49187518pll.54.1669679473706;
        Mon, 28 Nov 2022 15:51:13 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 123-20020a630781000000b00470275c8d6dsm7159081pgh.10.2022.11.28.15.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 15:51:13 -0800 (PST)
Date:   Mon, 28 Nov 2022 23:51:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH v10 034/108] KVM: x86/mmu: Add Suppress VE bit to
 shadow_mmio_{value, mask}
Message-ID: <Y4VJbfxwk2zQhkf5@google.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <1c480a48c2697054b1cfe068fa073f4035648f9a.1667110240.git.isaku.yamahata@intel.com>
 <a0d5878b7280372fa2de49156d58f69fa07659cc.camel@intel.com>
 <20221117180220.GJ2350331@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221117180220.GJ2350331@ls.amr.corp.intel.com>
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

On Thu, Nov 17, 2022, Isaku Yamahata wrote:
> On Wed, Nov 09, 2022 at 11:48:30AM +0000,
> "Huang, Kai" <kai.huang@intel.com> wrote:
> 
> > On Sat, 2022-10-29 at 23:22 -0700, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > Because TDX will need shadow_mmio_mask to be VMX_SUPPRESS_VE | RWX	
> > > shadow_mmio_value to be 0, make VMX EPT case use same value for TDX
> > > shadow_mmio_mask.  
> > > 
> > 
> > TDX need to use different mmio_mask/value doesn't mean they need to be changed
> > for VMX guest.  I think the true purpose here is to still be able to use a
> > global shadow_mmio_mask for both TDX and VMX guests.  So please explicitly call
> > out.  
> 
> That's right. With this change, per-VM shadow_mmio_{value, mask} can be avoided.
> The common value can be used for both VMX and TDX.

No, the mask can be global, but the value needs to be per-VM.  VMX needs to
generate an EPT misconfig, but TDX needs to generate an EPT violation to get the
automagic #VE reflection.
