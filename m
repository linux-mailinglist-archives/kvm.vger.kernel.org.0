Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81AD63E641
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 01:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiLAAPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 19:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiLAAOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 19:14:45 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D44A1A13
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 16:08:32 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id f9so186158pgf.7
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 16:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HLw4qTVWdAcqXZTcX50u+GL+gPdh2nwrJt4ClcSfb0A=;
        b=micZlJaDl9vlyNpNs01hnWZas5iT+1w+nSzGnXorW50OkKMkUozWylKxSgKaeInpbH
         GKBuEHxxuoTqxWUqGH7f+sXcWaMVZZOO045EETEYAo1oQutZLLOHU66EzbeUnyD6N29j
         qh2L/1ExsNHyPBrsYJK9wsf3hjOb+8ylDYWBw17Y+94U8NYZvY49ougcCCF/av8JWzUK
         wosJnMvG3Egeo9Y+HUOZEOXPTD+4CCmY2zIO2uKR4u0VhBZND5gHu/ozYHR4zBWbjNMS
         OtGMNFFJx7F7DCzHyGKzcT6NdTv3k/lJoi1qZNO/ybLg2tzPUj4XEcml9EANSlyS9Gfd
         wMzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HLw4qTVWdAcqXZTcX50u+GL+gPdh2nwrJt4ClcSfb0A=;
        b=Wh61/0gLoh20RMGbTvL26m0aK4XPFBurCTDv8Dna172Xtw1VkNQPzjmDV2zp6aiBKp
         W+MhN/1vFFRu8vuuSEJm0pWws+aqdaghECOhTEofj8L/yfFPdxv0615pCburNGLwRWYB
         vFD2VmRlMWc5KC3lkI8iouRkjWGe1Rx0EDhYfdaghImW4uD8WXrZGyg+8o8H7dt1GJY6
         zvN4TFMNA33A+lsDcdHbGBDU63tMi431v26bJlP0OmTlyAqxXMAlB68aTVVswlg1kjCo
         1hp8owsh4hjJtY0OsMfCK63b7q02Jp6L0y2pnTXJd/HpMYOCnmK4/ZCPMBYwVG9OD2a3
         +plg==
X-Gm-Message-State: ANoB5pk3klo5+kaaFamBbiLFICu/hzVKBTjntRCfTjC25M3JPn9n1UQN
        jyyavIWUdpNE4vSNwVSpPzyG8Q==
X-Google-Smtp-Source: AA0mqf5c9EH8Ducv1+oMWMXVFzQC9505vdvU2+naCCAlmHJ8nkF8u++QRTPzatvNeyhq0MnK75ZFlQ==
X-Received: by 2002:aa7:90c6:0:b0:573:ede1:a46b with SMTP id k6-20020aa790c6000000b00573ede1a46bmr44564397pfk.58.1669853311638;
        Wed, 30 Nov 2022 16:08:31 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t8-20020a170902e84800b00187022627d7sm2113451plg.36.2022.11.30.16.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 16:08:31 -0800 (PST)
Date:   Thu, 1 Dec 2022 00:08:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Advertise that the SMM_CTL MSR is not supported
Message-ID: <Y4fwe35utWwqycCv@google.com>
References: <20221007221644.138355-1-jmattson@google.com>
 <Y0Cn4p6DjgO2skrL@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0Cn4p6DjgO2skrL@google.com>
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

On Fri, Oct 07, 2022, Sean Christopherson wrote:
> On Fri, Oct 07, 2022, Jim Mattson wrote:
> > CPUID.80000021H:EAX[bit 9] indicates that the SMM_CTL MSR (0xc0010116)
> > is not supported. This defeature can be advertised by
> > KVM_GET_SUPPORTED_CPUID regardless of whether or not the host
> > enumerates it.
> 
> Might be worth noting that KVM will only enumerate the bit if the host happens to
> have a max extend leaf > 80000021.
> > 
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 2796dde06302..b748fac2ae37 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -1199,8 +1199,12 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >  		 * Other defined bits are for MSRs that KVM does not expose:
> >  		 *   EAX      3      SPCL, SMM page configuration lock
> >  		 *   EAX      13     PCMSR, Prefetch control MSR
> > +		 *
> > +		 * KVM doesn't support SMM_CTL.
> > +		 *   EAX       9     SMM_CTL MSR is not supported
> >  		 */
> >  		entry->eax &= BIT(0) | BIT(2) | BIT(6);
> 
> I don't suppose I can bribe you to add a kvm_only_cpuid_leafs entry for these? :-)

Ha!  Someone else must have heard me whining :-)

https://lore.kernel.org/all/20221129235816.188737-5-kim.phillips@amd.com
