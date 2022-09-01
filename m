Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C769F5A9D84
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 18:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbiIAQwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 12:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbiIAQwn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 12:52:43 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7452C979F5;
        Thu,  1 Sep 2022 09:52:42 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id w88-20020a17090a6be100b001fbb0f0b013so3238972pjj.5;
        Thu, 01 Sep 2022 09:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=EyYzuAJICZEJkeXJX1j7tTOYHHP3WGLUevJ1ub5HhfA=;
        b=bJYn0c4dA5o6LdUBFOu/jowBMOlO1js31IW99n1CfFxdw/+1+TLvhTiuB1Qhv7Mo9y
         WRums3uISzLpDmLGIn23q+DxIrCeQa1xSNKNlHo+VFq417Slm+uxi4y+hGuFYaj05Jug
         yylzuj47la/WnOnr64saKhbbW2MkmcMaPhXFSdAs3YIlCZkrdn2sKVBt7OFO5US37ShH
         5ZqJp9tXHLvU9e6YGH6mCqgzDbeb6TCY+MTLLn0oWO/pjw1E/dXgiO4dNBdup3W4O3hz
         dQLNmbBonzIA4BhH5zUNDf4xqi7ZCMD3DkqzsIMizLfYy15YPzXFUKW9PthwwU3qB8ot
         sR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=EyYzuAJICZEJkeXJX1j7tTOYHHP3WGLUevJ1ub5HhfA=;
        b=ryQbcJCN1odW/kaLn7TjaO3RsijW5YFnbjDDCTTFp5UAqzo7yv9wrw2cceXEZCrc4u
         6lueAJZ6xJNPCYz/sS8IQXIZhpkniXx1+ZD/RXBgz9Aas+gbLTfwuhkmP2OthbmSr28y
         btmCPHLwLSlamE5NuGOcLpe6aAeRpz0YQTFvnTM05ViDfhOWWAGMMzyiXSlzCanq0Dkq
         lqVkkEeEnjmxTxT3za+AtYckNog38BW7BBp9Z7K9YK0C+kazpv7s1xQgPzbsoskBRcuE
         BIhUeXMBZ7XE1ElLRTew67LoHEU+cs5IdgA/OF2x2YnSVE4rblq4u0cgNrCJCsJxvAVG
         fYvQ==
X-Gm-Message-State: ACgBeo0pbo8MlG8JgddtrwVhGXCENwoAeoVL8vMnRMVoP4lTXuksJFfT
        Tzbm03J163+k/JfLS48p198=
X-Google-Smtp-Source: AA6agR67jmgSj2wsMKqv5E1HqgxQ3iSX+z5Id4efYN9RgT1LfhGxXwSgcEzKspAbxSmw7jMWpykDWQ==
X-Received: by 2002:a17:903:244f:b0:175:34d6:97a8 with SMTP id l15-20020a170903244f00b0017534d697a8mr11727714pls.100.1662051161743;
        Thu, 01 Sep 2022 09:52:41 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id s3-20020a170902ea0300b00174c5fb500dsm9301380plg.116.2022.09.01.09.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 09:52:41 -0700 (PDT)
Date:   Thu, 1 Sep 2022 09:52:40 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Gao, Chao" <chao.gao@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v2 05/19] KVM: Rename and move CPUHP_AP_KVM_STARTING to
 ONLINE section
Message-ID: <20220901165240.GG2711697@ls.amr.corp.intel.com>
References: <cover.1661860550.git.isaku.yamahata@intel.com>
 <d2c8815a56be1712e189ddcbea16c8b6cbc53e4a.1661860550.git.isaku.yamahata@intel.com>
 <YxBOoWckyP1wvzMZ@gao-cwp>
 <933858c97f69bcf6fb00ea5dcb2ec9fa368eced3.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <933858c97f69bcf6fb00ea5dcb2ec9fa368eced3.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 10:58:04AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Thu, 2022-09-01 at 14:18 +0800, Gao, Chao wrote:
> > On Tue, Aug 30, 2022 at 05:01:20AM -0700, isaku.yamahata@intel.com wrote:
> > > From: Chao Gao <chao.gao@intel.com>
> > > 
> > > The CPU STARTING section doesn't allow callbacks to fail. Move KVM's
> > > hotplug callback to ONLINE section so that it can abort onlining a CPU in
> > > certain cases to avoid potentially breaking VMs running on existing CPUs.
> > > For example, when kvm fails to enable hardware virtualization on the
> > > hotplugged CPU.
> > > 
> > > Place KVM's hotplug state before CPUHP_AP_SCHED_WAIT_EMPTY as it ensures
> > > when offlining a CPU, all user tasks and non-pinned kernel tasks have left
> > > the CPU, i.e. there cannot be a vCPU task around. So, it is safe for KVM's
> > > CPU offline callback to disable hardware virtualization at that point.
> > > Likewise, KVM's online callback can enable hardware virtualization before
> > > any vCPU task gets a chance to run on hotplugged CPUs.
> > > 
> > > KVM's CPU hotplug callbacks are renamed as well.
> > > 
> > > Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> > > Signed-off-by: Chao Gao <chao.gao@intel.com>
> > 
> > Isaku, your signed-off-by is missing.
> > 
> > > Link: https://lore.kernel.org/r/20220216031528.92558-6-chao.gao@intel.com
> > > ---
> > > include/linux/cpuhotplug.h |  2 +-
> > > virt/kvm/kvm_main.c        | 30 ++++++++++++++++++++++--------
> > > 2 files changed, 23 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> > > index f61447913db9..7972bd63e0cb 100644
> > > --- a/include/linux/cpuhotplug.h
> > > +++ b/include/linux/cpuhotplug.h
> > > @@ -185,7 +185,6 @@ enum cpuhp_state {
> > > 	CPUHP_AP_CSKY_TIMER_STARTING,
> > > 	CPUHP_AP_TI_GP_TIMER_STARTING,
> > > 	CPUHP_AP_HYPERV_TIMER_STARTING,
> > > -	CPUHP_AP_KVM_STARTING,
> > > 	CPUHP_AP_KVM_ARM_VGIC_INIT_STARTING,
> > > 	CPUHP_AP_KVM_ARM_VGIC_STARTING,
> > > 	CPUHP_AP_KVM_ARM_TIMER_STARTING,
> > 
> > The movement of CPUHP_AP_KVM_STARTING changes the ordering between
> > CPUHP_AP_KVM_STARTING and CPUHP_AP_KVM_ARM_* above [1]. We need
> > the patch [2] from Marc to avoid breaking ARM.
> > 
> > [1] https://lore.kernel.org/lkml/87sfsq4xy8.wl-maz@kernel.org/
> > [2] https://lore.kernel.org/lkml/20220216031528.92558-5-chao.gao@intel.com/
> 
> How about Isaku just to take your series directly (+his SoB) and add additional
> patches?

Ok will do.  Although I hoped to slim it down, I've ended up to take most of it.
four out of six.  Now why not two more.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
