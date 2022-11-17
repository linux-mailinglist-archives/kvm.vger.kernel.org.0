Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84AD162E5C7
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 21:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbiKQUYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 15:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiKQUYa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 15:24:30 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA489140DC;
        Thu, 17 Nov 2022 12:24:29 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y10so1495790plp.3;
        Thu, 17 Nov 2022 12:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kSpu5sc5U8jHoWQxjZChOPhUIMdGYPDGSrrgGj2BtkA=;
        b=IIO4tJm0jxiNKt2ynxLjMXbPNAEbxyL3w7pgZ17A0UgiCUhEmRQ65tShIODeOioXsG
         1KwxkZY+du560KcmS+fOsQfpk+TBGw/pn8QKPuZNlp4IScwVILAIDITku4tDylE34zEI
         aM26sjinYaZekaSCx9pNl6rmyKqijAZo+WAECj4BBxyvFprY3Obk8p76qC5RKAIwVS/Z
         hLz+2TQHeD5OIvBDabXnlASQdbQYJTka1ksMEzQKi6+79QmCNgS9Cw16307Cd2nw6dze
         I4l42NbYiQoYaidFVPnqwwXYFB7a8rk8kVe358zXbNxSjGPf6OYHRGbr+d3Xd0iCNwPS
         ErzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kSpu5sc5U8jHoWQxjZChOPhUIMdGYPDGSrrgGj2BtkA=;
        b=438x51/4MR5/M+tf9sEYxiUbMKg61LX1TUvlZ5kpyC3vk6chGn7cTfdSZU0J49OYkU
         NlMi4QF3pMBKnZXIV7yot9QvavUUDCdukbYPjeelRVJJDseRE26PZacyOCLa4yvMgXsk
         cBU5NA4eMo5MoJXq31heJsLv+VCDMZ1yFUQqt2obxTcDAS1aPS/PETfh4q6HDqijp/4Q
         l0/H2FtH1GJxxbC8J/6nwL/yP4ynLl8Tv4+qIutSc9BnFfbtcXTX11Ho+8L+ve47sd7x
         /FuLZgRN/ZVmL60E5Ih9K6ZQn1fiEoRbiNflfuXeqHXxV+5QHHIuHXfhzpeZ9/yXjjmP
         QZMA==
X-Gm-Message-State: ANoB5plSx8pchJTmaroFl3N7t79J6NzG1kLm0PH4X8YPSH7XzHSh+RpE
        xEGKzWmPdZ/fPMa7lfusuvmv6fcorh0=
X-Google-Smtp-Source: AA0mqf5foWhdwXWOmAt9rpLN5hvmsqBo2cUGVi/8M999BsCRjATexZQpuc3btyTtOCtEBDmP+17qEg==
X-Received: by 2002:a17:902:c652:b0:186:9890:97d1 with SMTP id s18-20020a170902c65200b00186989097d1mr4429506pls.114.1668716669056;
        Thu, 17 Nov 2022 12:24:29 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id ie4-20020a17090b400400b0020af2bab83fsm1310182pjb.23.2022.11.17.12.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 12:24:28 -0800 (PST)
Date:   Thu, 17 Nov 2022 12:24:27 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v10 076/108] KVM: TDX: handle vcpu migration over logical
 processor
Message-ID: <20221117202427.GC2751024@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <782f74f7d5375a36b2857be59262c1c4c4cf16a7.1667110240.git.isaku.yamahata@intel.com>
 <b6276f58-8ff5-9a3c-e6c7-c38f2ddb682a@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b6276f58-8ff5-9a3c-e6c7-c38f2ddb682a@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 15, 2022 at 10:28:20AM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> On 10/30/2022 2:23 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > For vcpu migration, in the case of VMX, VCMS
> 
> typo, VMCS
> 
> 
> >   is flushed on the source pcpu,
> > and load it on the target pcpu.  There are corresponding TDX SEAMCALL APIs,
> > call them on vcpu migration.  The logic is mostly same as VMX except the
> > TDX SEAMCALLs are used.
> > 
> > When shutting down the machine, (VMX or TDX) vcpus needs to be shutdown on
> > each pcpu.  Do the similar for TDX with TDX SEAMCALL APIs.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/kvm/vmx/main.c    |  43 +++++++++++--
> >   arch/x86/kvm/vmx/tdx.c     | 121 +++++++++++++++++++++++++++++++++++++
> >   arch/x86/kvm/vmx/tdx.h     |   2 +
> >   arch/x86/kvm/vmx/x86_ops.h |   6 ++
> >   4 files changed, 168 insertions(+), 4 deletions(-)
> > 
> > 
> > @@ -176,6 +214,41 @@ static void tdx_reclaim_td_page(struct tdx_td_page *page)
> >   	}
> >   }
> > +static void tdx_flush_vp(void *arg)
> > +{
> > +	struct kvm_vcpu *vcpu = arg;
> > +	u64 err;
> > +
> > +	lockdep_assert_irqs_disabled();
> > +
> > +	/* Task migration can race with CPU offlining. */
> > +	if (vcpu->cpu != raw_smp_processor_id())
> > +		return;
> > +
> > +	/*
> > +	 * No need to do TDH_VP_FLUSH if the vCPU hasn't been initialized.  The
> > +	 * list tracking still needs to be updated so that it's correct if/when
> > +	 * the vCPU does get initialized.
> > +	 */
> > +	if (is_td_vcpu_created(to_tdx(vcpu))) {
> > +		err = tdh_vp_flush(to_tdx(vcpu)->tdvpr.pa);
> 
> Need to retry here if tdh.vp.flush fails due to tdx operand busy?
> 
> If such failure occurs, the next vp enter will fail after the vCPU migrated
> to another LP, how is it hanlded?


No need to retry.  TDX Resources needed for TDH.VP.FLUSH are, TDVPR as exclusive,
TDR as shared, and TDCS as shared.

This vp flush function is called when destructing vcpu/TD or vcpu migration.  No
other thread uses TDVPR in those cases.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
