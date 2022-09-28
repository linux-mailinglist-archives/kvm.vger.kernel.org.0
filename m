Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6545D5EE978
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 00:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbiI1Wgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 18:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234737AbiI1WgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 18:36:12 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC63109126
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 15:35:35 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id u69so13488638pgd.2
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 15:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=qi4+Odnd+B+DOmVNg49D9tTKQveUHaxn81Miu97zn5M=;
        b=V1bQIqaarDCtNQLJyHlr0qrN3mtCzvPRXlQETHivGvxtjmYQPC0ly45PcRQkTGPSQ/
         ajpzGumv3eDOPASdvUFdudph7hChQ87cwf56riIB3ItIJiLUPZr7N07T16xeCPyo9a0v
         qm11MkmFzNDwRFufu06RnZ42HAmT3bs0yBHQQ6M5wSjt/at798K5Ysfmx+I/QaWcGUL5
         U8q+J9ODIwrIdL3MSFR5CLKUSeoTjXNqp5WQ9y/+mDxYdHYNsZcOcXw9/rNjmMRinyvY
         xsY+99uazg+wFv+hmt5W9flRRMmoOBfCEzE26/uq6DQpKTEa6RwDvcFqKRmfI+9pzUiO
         sLnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=qi4+Odnd+B+DOmVNg49D9tTKQveUHaxn81Miu97zn5M=;
        b=OJbP8HmIWP+WA9l+8wkxeCquq7lhwSwGcvrq/KC92ibfJYuRgLXcePcbBSYzh8V6Lr
         l92N/+yQJxpFiguWUwmBGEL270cTZz9o/PtS9aTAjEQbvC/ueNPu/6A28g0FXoFfZuOI
         mdtHVGI7U/84OHzNf+K0tPRhu2tLxCLPsXbc5Y8vpBSbKuvYmsFPiWuT0FPmykaCOVeh
         NTFjYqrFIEejN0LQ4rnuAHvSsxDvBSvydJSPpExsaa9MPDKBd3qQZg97NqGNqZ/5EaKK
         Bigjqh/8jalIljM9BCQcVjnrdNf3OYCxVkfLCzBk0WQ3DpAniIlF3iX5qK5K/GT3zf3K
         JgEQ==
X-Gm-Message-State: ACrzQf0QCJqY4IboftbiI2ySt6HHC+mU9QZsq3uhKNZKV/BKjjzU+8/3
        xqELtGBhew2TCqE0uLAy+9bRsQ==
X-Google-Smtp-Source: AMsMyM7u2jWkToCftOZSPnKa9AXPbalq+pXrd6EAccH9JbAOG2yY1DOUk4E0xjAY9H2+wwSJ7GMOBw==
X-Received: by 2002:a63:1c13:0:b0:43b:f037:9d98 with SMTP id c19-20020a631c13000000b0043bf0379d98mr60114pgc.454.1664404534872;
        Wed, 28 Sep 2022 15:35:34 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s13-20020aa78bcd000000b0053e9ecf58f0sm4475226pfd.20.2022.09.28.15.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 15:35:34 -0700 (PDT)
Date:   Wed, 28 Sep 2022 22:35:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH v3 07/28] KVM: x86: Inhibit APIC memslot if x2APIC and
 AVIC are enabled
Message-ID: <YzTMM+bYVSNmEatL@google.com>
References: <20220920233134.940511-1-seanjc@google.com>
 <20220920233134.940511-8-seanjc@google.com>
 <e84ebf0a7ac9322bd0cfa742ef6dd2bbfdac0df9.camel@redhat.com>
 <YzHawRN8vpEzP7XD@google.com>
 <bcc3c67abc3b2c3d896b800c5f8f7295b7238271.camel@redhat.com>
 <YzR3PaZokwIPDoXb@google.com>
 <2ca1b7c59e2abe661dd03309ad13eca7d692ff05.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ca1b7c59e2abe661dd03309ad13eca7d692ff05.camel@redhat.com>
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

On Wed, Sep 28, 2022, Maxim Levitsky wrote:
> On Wed, 2022-09-28 at 16:33 +0000, Sean Christopherson wrote:
> > Similarly, is there a good reason for having nested_svm_vmexit() invoke
> > kvm_vcpu_update_apicv() directly?  I'm confused by the "so that other vCPUs can
> > start to benefit from it right away".  The nested inhibit is per-vCPU and so
> > should only affect the current vCPU, no?  I.e. for all intents and purposes, using
> > a request should be functionally equivalent.
> 
> It is kind of the other way around:
> 
> The mere fact of switching to vmcb02 *inhibits* the AVIC on the current vCPU,
> but the AVIC inhibit is there only to set the is_running bits in the physid table
> and in IOMMU to prevent its *peers* to try and send interrupts to it via AVIC.
> 
> It is the reason why APICv doesn't need it - the posted interrupts still work
> just fine when a vCPU doens't use APICv, or uses a different posted interrupt vector
> when it uses the nested APICv.

Gotcha, the "other vCPUs" part is where I got confused.

> So it makes sense to remove that inhibit as soon as possible that the peers
> could stop getting 'unaccellerated IPI' vmexits for nothing.

But practically speaking, the delay between the nested VM-Exit and servicing the
request is minimal.  Might be a moot point if nested AVIC is supported, i.e. an
inline update may be "required" at that point.

Not a sticking point by any means, but if possible, it would be nice to have a
single call site for the per-vCPU APICv update.

> However back to the discussion, I don't think this is a problem.
> 
> We can just call both the kvm_vcpu_update_apicv() and a new function that
> does the memslot disable from KVM_REQ_APICV_UPDATE, then 
> plain kvm_vcpu_update_apicv() won't need to drop the srcu lock.
> 
> It is pretty much the same that you proposed, just instead of piggybacking on 
> KVM_REQ_UNBLOCK, I proposed to piggyback on KVM_REQ_APICV_UPDATE.

Yep, easy to do after converting the x2APIC toggling to use a request.

Thanks!
