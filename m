Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03445574063
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 02:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbiGNAO4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 20:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiGNAOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 20:14:50 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E31D11C22;
        Wed, 13 Jul 2022 17:14:49 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id s21so715889pjq.4;
        Wed, 13 Jul 2022 17:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ii6n5f/fOOUgR7/Y+drLs3iaf97b0TdLdk/emGlXIF8=;
        b=ozPeQ7X1kcTmBBScHFKnFfyDyNw/sFsnuWoQBn24wlNUkRMey86RifvZVHAeWEWRAJ
         AD7u1b6TakJrQk0gpILsEdOdG6RiLTMvbWfI7mDeAa8h6H0IbzUTovEQHdXFicZLuufl
         s+lPFRm9tWVjFjzG45N7F+OFl7AOui5juvhYJzN1J+o/GusFi50xdTieNjUPo0eT3i8n
         OiZfWIXO2tfXWEO4XSCB4zNc7KGzDQqzPRHTVxx3UplO4QaiYJoQFRMFI80hnWRozODj
         hxObSEk7cmBmnqb8oATNr/Uo+gYGBmukMQrXmAQ/ot7dk7KKegxqEor5uLPL7weLA5JQ
         Z9/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ii6n5f/fOOUgR7/Y+drLs3iaf97b0TdLdk/emGlXIF8=;
        b=orRJSemPEgTkEJmG2hL9N+dfePCHpJIZMWAAwxZqk0x2CErZuQ3bOMBUYsw7smPOXM
         GLZSQ9WTTLltJJm962Wvda9dSf38s+cv9PVENOD5U77qKmdp89SE+jeTcisviE64lKGj
         bbGfZ166F+BR7DxOZnRVOWkMT0+a3sHCAjhiz6m9wxTWammt4WPq9JMKBPKhWIumDcyh
         /pYKIGsFd2/zwyGdwFZSX2ysS66Co45pOrf1Xw91ydJbm3pk8WfFnwrMX3C8WBUYbGzH
         xy8XPG93Lw18aTCj1SSLVSMZHAQ0iMMrc3p48PoTkHS1chMzC1oHk4dj2GMoTCnBo4RA
         DMHQ==
X-Gm-Message-State: AJIora/n8U03yC2Eoe7436jABbKG3a5VUEU13fCq5vI+Skmo0D/5mzzT
        CWwSvbCINHT4vXb3CjMBHGI=
X-Google-Smtp-Source: AGRyM1srwOoc40LfXUKfHHlDlrYs/ZQxb0FsBwcv06gOviPYR31PBxK8XOk5oKfAMOGt0qVpUMw0Zw==
X-Received: by 2002:a17:903:32c1:b0:16c:35b2:18c3 with SMTP id i1-20020a17090332c100b0016c35b218c3mr5599782plr.126.1657757688598;
        Wed, 13 Jul 2022 17:14:48 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id c14-20020a170902c2ce00b0016c84677aa2sm28094pla.9.2022.07.13.17.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 17:14:48 -0700 (PDT)
Date:   Wed, 13 Jul 2022 17:14:46 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v7 033/102] KVM: x86/mmu: Add address conversion
 functions for TDX shared bits
Message-ID: <20220714001446.GR1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <69f4b4942d5f17fad40a8d08556488b8e4b7954d.1656366338.git.isaku.yamahata@intel.com>
 <6cc36b662dffaf0aa2a2f389f073daa2d63a530b.camel@intel.com>
 <20220713045225.GP1379820@ls.amr.corp.intel.com>
 <e4a106ba016d790af60ed72492695ab2b905ede1.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e4a106ba016d790af60ed72492695ab2b905ede1.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 13, 2022 at 10:41:33PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> 
> > > 
> > > And by applying this patch, nothing will prevent you to turn on INTEL_TDX_HOST
> > > and KVM_INTEL, which also turns on KVM_MMU_PRIVATE.
> > > 
> > > So 'kvm_arch::gfn_shared_mask' is guaranteed to be 0?  If not, can legal
> > > (shared) GFN for normal VM be potentially treated as private?
> > > 
> > > If yes, perhaps explicitly call out in changelog so people don't need to worry
> > > about?
> > 
> > struct kvm that includes struct kvm_arch is guaranteed to be zero.
> > 
> > Here is the updated commit message.
> > 
> > Author: Isaku Yamahata <isaku.yamahata@intel.com>
> > Date:   Tue Jul 12 00:10:13 2022 -0700
> > 
> >     KVM: x86/mmu: Add address conversion functions for TDX shared bit of GPA
> >     
> >     TDX repurposes one GPA bit (51 bit or 47 bit based on configuration) to
> >     indicate the GPA is private(if cleared) or shared (if set) with VMM.  If
> >     GPA.shared is set, GPA is converted existing conventional EPT pointed by
> >     EPTP.  If GPA.shared bit is cleared, GPA is converted by TDX module.
> >     VMM has to issue SEAMCALLs to operate.
> 
> Sorry what does "GPA is converted ..." mean?

Oops. typo. I meant GPA is covered by ...

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
