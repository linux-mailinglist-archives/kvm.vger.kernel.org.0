Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F9C4D8C45
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237648AbiCNTYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236868AbiCNTX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:23:59 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA9532ED;
        Mon, 14 Mar 2022 12:22:47 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id e13so14415410plh.3;
        Mon, 14 Mar 2022 12:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wxWVBqAwSimMHPPoVsE8iiK5XG62lXlYEoF21TEz/VE=;
        b=UxB1dwnCfbPwOnkcGR0t/WlWGvrbGYrGxHVs4cIfn69g2LpczFgLotebMjPDmQybqu
         vTv0MJoqDvYO+OdSHLEXJF46IAWBnhhIdoJDLQ1RCLh7SrHIa2n2AfZQu0kBjzaVvEwW
         sTmcK+KPHufk7i7abgyfSpEdq+Og7or9Eba69+U8lJ6rMV6NjjBsOkNkzETq+s2Sqjq0
         VzG+qtdTa++dpsoXk7Y4tpMbjjmfurFIJv8NWvF9rBjbeuPntMq1LoBvOttSNEUxLTdz
         AgSrA93hOfluPmypcSeRpmMT+fZzvlw+5wwY1/kIwOO0n/DS+RG9F8LYrwnrjr24C6ou
         H/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wxWVBqAwSimMHPPoVsE8iiK5XG62lXlYEoF21TEz/VE=;
        b=X+9K/wdbMqFFkr9lq4mqumPvnrwnv+VH4XXnYOu5L3nkIIsCWVUbbGwnlyVED+ZtdX
         KovYRzZ0lqxFQZR1YqPhRRDArD8h+K9/RLbTabBjCjwJ04NO0Ly0f3nq4uJ1rTEpDWki
         hkS0jqOsc0EOAea4TYD98s5yz6Zsj/KwY2M/GhRTHQFohq5lHldgFyR6nkuJA35mihBJ
         bm2SGlv/V0BbkR3/A5E+WXbInOlHmPQsyjum1yZIGIQkVUez+G/eUjeduIdybmuIkZxR
         lriZyZjnE4HcrJ5x++SIFLoi3cdG39qlZNtuWmlK2NUKGD+UNlj74VHc7t46KHiKu0v9
         0zjA==
X-Gm-Message-State: AOAM533eIzhiT39htT8xnKo5j6DhYkApqjGAMgBVRnitO57yzdmlpkJs
        +H1OKda5nXHKe57Wu8In8DM=
X-Google-Smtp-Source: ABdhPJwTrOnMbZPKA3mn3QaNImQENuztLWVj4XLGzdm6wj78wBbf3aF5jw+f0A8itaCLlKwLPYFgFA==
X-Received: by 2002:a17:903:120c:b0:14f:3f4a:f832 with SMTP id l12-20020a170903120c00b0014f3f4af832mr25271153plh.157.1647285767276;
        Mon, 14 Mar 2022 12:22:47 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id d11-20020a056a0024cb00b004f725ecf900sm22004254pfv.97.2022.03.14.12.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 12:22:46 -0700 (PDT)
Date:   Mon, 14 Mar 2022 12:22:45 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 005/104] KVM: x86: Refactor KVM VMX module
 init/exit functions
Message-ID: <20220314192245.GC1964605@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <8a8ec76f1700114d739623b2860630eacd277ab6.1646422845.git.isaku.yamahata@intel.com>
 <d1c7ee86-8093-d04f-747d-aabbc1452801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1c7ee86-8093-d04f-747d-aabbc1452801@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thanks for review.

On Sun, Mar 13, 2022 at 02:54:15PM +0100,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> > -static int __init vmx_init(void)
> > -{
> > -	int r, cpu;
> > +	if (sizeof(struct vcpu_vmx) > *vcpu_size)
> > +		*vcpu_size = sizeof(struct vcpu_vmx);
> > +	if (__alignof__(struct vcpu_vmx) > *vcpu_align)
> > +		*vcpu_align = __alignof__(struct vcpu_vmx);
> 
> Please keep these four lines in vt_init, and rename the rest of
> vmx_pre_kvm_init to hv_vp_assist_page_init.  Likewise, rename
> vmx_post_kvm_exit to hv_vp_assist_page_exit.
> 
> Adjusting the vcpu_size and vcpu_align for TDX (I guess) can be added later
> when TDX ops are introduced.

sure. I'll make it like
  vcpu_size = max(sizeof(struct vcpu_vmx), sizeof(vcpu_tdx));
  ...


Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
