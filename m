Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFFDD5EE13F
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 18:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbiI1QMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 12:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbiI1QMj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 12:12:39 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C2C6DF93
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 09:12:38 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so2137815pjl.0
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 09:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=SX46qqsXP6rNXBfhWbDF1CWQd9NesON2YiNX3aiOXY0=;
        b=fzDC1W22cfZ4eDT1CC0OBYGcpwDVGaIUNn9gpp+5Om3tsWLsgyETbIAFuKLDILPNOF
         NEEiTgMTRAUHTfaXUgf3Yr6pWUc0h8FDYlycrjTCqUs2iP6brpgSe2PUc3K/KC2zDHyN
         y+EjT27JXL79rXS7ZeoidlEdf3yPQlonDfwh1D5RMd/M4SKBv3uFQK7SpAzozqBJjMJT
         bSbDSUNDFa9pQlgJxRwPcRQJIIG1LlttRThlG3BNyEouNJCP0aREDQsErYXBSFSkfBrA
         FCT42XP9Mrup9YwTWBjCl/U7F5pEbpKrIXeGIuwX/lIkG+uDAe+1SRLTOjqh490JtHor
         Gu/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=SX46qqsXP6rNXBfhWbDF1CWQd9NesON2YiNX3aiOXY0=;
        b=i0KH9fxTtTQ5HMRi1MtTMJoSJPhAp0gpdJ3he5hBfKLAHJzJspo/ydXnth9x0WMWMv
         /ZIIC7o9x+rF8oS7wDJ8jqHFHnrQy8nq30NYTy0MeBjYWgzqiaBZBm/l51WRdBZOweqj
         iB3eAiJwiF17TrgDXWi7U4PMuSR6QkKNwrkABJK4tNxn34SbNpqD5WwL1S/gA100cOQ0
         PumPOJWOk8QlJZvh/WOK8FEmW/XCRcY5bE7MGEn6ba7Ag+EYY4w9QKQnrKBAeOgavVLP
         vS0BtGphUs04z4JIVwYYkAiEcQZeKidcXpsXbTwoAYVmueu4FM8nnh54kHEDArqGqY4Y
         whBQ==
X-Gm-Message-State: ACrzQf18tdUy1AYnPl8Ou4sv4smWX7Jt4QfpzwFRrg27O48n4LVylSsa
        QW524/e/AESz8EyTy7sJJN7jfg==
X-Google-Smtp-Source: AMsMyM4CQonqEyArDPEJ70zxw16cAnQiwAeyZhblK/Tv64BVxU1faRMq7OaiZPq+tjiBxsdTcgQMaw==
X-Received: by 2002:a17:903:2305:b0:178:380f:5246 with SMTP id d5-20020a170903230500b00178380f5246mr554123plh.146.1664381558359;
        Wed, 28 Sep 2022 09:12:38 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d128-20020a623686000000b0053e66f57334sm4194923pfa.112.2022.09.28.09.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 09:12:37 -0700 (PDT)
Date:   Wed, 28 Sep 2022 16:12:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: disable on 32-bit unless CONFIG_BROKEN
Message-ID: <YzRycXDnWgMDgbD7@google.com>
References: <20220926165112.603078-1-pbonzini@redhat.com>
 <YzMt24/14n1BVdnI@google.com>
 <ed74c9a9d6a0d2fd2ad8bd98214ad36e97c243a0.camel@redhat.com>
 <15291c3f-d55c-a206-9261-253a1a33dce1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15291c3f-d55c-a206-9261-253a1a33dce1@redhat.com>
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

On Wed, Sep 28, 2022, Paolo Bonzini wrote:
> On 9/28/22 09:10, Maxim Levitsky wrote:
> > I also think that outside KVM developers nobody should be using KVM on 32 bit host.
> > 
> > However for_developement_  I think that 32 bit KVM support is very useful, as it
> > allows to smoke test the support for 32 bit nested hypervisors, which I do once in a while,
> > and can even probably be useful to some users (e.g running some legacy stuff in a VM,
> > which includes a hypervisor, especially to run really legacy OSes / custom bare metal software,
> > using an old hypervisor) - or in other words, 32 bit nested KVM is mostly useless, but
> > other 32 bit nested hypervisors can be useful.
> > 
> > Yes, I can always use an older 32 bit kernel in a guest with KVM support, but as long
> > as current kernel works, it is useful to use the same kernel on host and guest.
> 
> Yeah, I would use older 32 bit kernels just like I use RHEL4 to test PIT
> reinjection. :)  But really the ultimate solution to this would be to
> improve kvm-unit-tests so that we can compile vmx.c and svm.c for 32-bit.

Agreed.  I too use 32-bit KVM to validate KVM's handling of 32-bit L1 hypervisors,
but the maintenance cost is painfully high.
