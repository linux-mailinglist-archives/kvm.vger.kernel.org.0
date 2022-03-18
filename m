Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89894DE1F4
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 20:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240384AbiCRTwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 15:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236940AbiCRTv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 15:51:59 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11AEA2EA0C0
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 12:50:35 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id b7so6512442ilm.12
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 12:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i5lpELvn9UAgjq8kf2t3SHXpw/E6d+VBxOLDQ3BjfZw=;
        b=IojSybv9g7oDrsYR7RLQba7F90K/n71kzFhJ8aHF60YiICIJBv4Hj29OlDXoDUEgdn
         VZ7rxl6OCE4NoLBk+D2t3NJo8qdZcFFid2loNN6+cXLW5I91GlZUuqeBWUcYXEw71suU
         kHiQsQ++h9/V0pgdH1fX7iA9pxt085tM9idAIBuCDQsiuiL88XmOEdSSFrNKBQYwCeZx
         Ob0XjeO6l7eDLXfsvoW2mT/i917jHFkPCxk2XoYmoFwoll22BqT81fEKYlu85PG+3w8h
         aLHkq3Ill2tqpJxqysxBRZeCg3kZwMFZdYnj0mP0TtX893QljHULKPp+JMIC2iJYjIzO
         k88Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i5lpELvn9UAgjq8kf2t3SHXpw/E6d+VBxOLDQ3BjfZw=;
        b=NSkZtv78wths7mP6sJ6SgT55lcPUeESvNkxhn5choR7TRbC2eBnhuK+7RAMnXeGorN
         q7y0J2M6zk+1xhRU+YJmrD12PVghAIEmRRzrlgN4q4mA6ysX91qAvee3Je8O/y2sQDLB
         gveeWPAWYjdkORfgn/UyJlqbGW6dKuJlS94eJoKv5DpiDMMKk3BMzr65Rt29DdtBKDqF
         hiGOCRJtU3z+VvK3G0efCDIPYhZUnqi1mAc9yj11zDMCTGJOFbm6S2/kSP0AY+bnFLbL
         T3z0g9ZNyskjcOR/0pY6uQIvC1kIOyfJKg+RBbdnqYfqUT58QJyV3FmHYVb1J4MZeenv
         EcfA==
X-Gm-Message-State: AOAM530Pgf82l4BYO313GHmED32XLXz/gaWGen6EH+/TGY1EPCTm4lXW
        MpnM++5bEBd9+A1ryBp9LrBUeg==
X-Google-Smtp-Source: ABdhPJyd/ri0FWxkHGqpG/vTq71qInBCkDF8gwXvOUcDedFZ3CP06rYtJ6L8odLeXPn+UlE/1WfCag==
X-Received: by 2002:a92:ab04:0:b0:2c7:aa89:d17e with SMTP id v4-20020a92ab04000000b002c7aa89d17emr5081942ilh.108.1647633034170;
        Fri, 18 Mar 2022 12:50:34 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id y6-20020a056e02174600b002c7f247b3a7sm3006237ill.54.2022.03.18.12.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 12:50:33 -0700 (PDT)
Date:   Fri, 18 Mar 2022 19:50:30 +0000
From:   Oliver Upton <oupton@google.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Dongli Si <sidongli1997@gmail.com>
Subject: Re: [RESEND PATCH kvmtool] x86/cpuid: Stop masking the CPU vendor
Message-ID: <YjTihu0ULnfiumEi@google.com>
References: <20220317192853.60205-1-oupton@google.com>
 <20220318105438.0614cfda@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318105438.0614cfda@donnerap.cambridge.arm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On Fri, Mar 18, 2022 at 10:54:38AM +0000, Andre Przywara wrote:
> On Thu, 17 Mar 2022 19:28:53 +0000
> Oliver Upton <oupton@google.com> wrote:
> 
> Hi Oliver,
> 
> thanks for the patch, this overlaps with our recent discussion here:
> https://lore.kernel.org/kvm/20220226060048.3-1-sidongli1997@gmail.com/

Oops! I missed this thread. Sorry about that.

> > commit bc0b99a ("kvm tools: Filter out CPU vendor string") replaced the
> > processor's native vendor string with a synthetic one to hack around
> > some interesting guest MSR accesses that were not handled in KVM. In
> > particular, the MC4_CTL_MASK MSR was accessed for AMD VMs, which isn't
> > supported by KVM. This MSR relates to masking MCEs originating from the
> > northbridge on real hardware, but is of zero use in virtualization.
> 
> Yes, in general this applies to all kind of errata workarounds tied to
> certain F/M/S values, something totally expected. We have the same
> situation on Arm, actually, although the kernel tries to avoid IMPDEF
> system register accesses.
> 
> > Speaking more broadly, KVM does in fact do the right thing for such an
> > MSR (#GP), and it is annoying but benign that KVM does a printk for the
> > MSR.
> 
> Yes, but the printk is the lesser of our problems, the #GP is typically
> more of an issue. Fortunately other VMMs have this problem as well, so the
> kernel itself learned to ignore certain MSR #GPs (rdmsrl_safe()), so we
> are good now. Back then this #GP lead to a kernel crash, IIRC.

Right, I was more alluding to the fact that the only sensible thing to
do in KVM is to #GP. Sinking reads/writes is a fast path into undefined
behavior.

Excellent detective work on the other thread, BTW. I flopped searching
around for this MSR.

> > Masking the CPU vendor string is far from ideal, and gets in the
> > way of testing vendor-specific CPU features.
> 
> Not only that, it's mostly wrong and now unsustainable, see the early
> kernel messages when running on an unknown vendor. Also glibc compiled for
> a higher ISA level is now a showstopper.
> At least the AMD CPUID spec clearly says that its CPUID register mapping
> are only valid for the AMD vendor string, and I believe Intel relies on
> that as well. I wouldn't know of conflicting assignments between the two,
> though, but we now miss many features by exposing an unknown vendor.

I did not know about the glibc dependency, that hurts!

> > Stop the shenanigans and
> > expose the vendor ID as returned by KVM_GET_SUPPORTED_CPUID.
> 
> Yes, that's the right thing to do.
> 
> So can you please:
> 1) make this a revert of the original kvmtool patch
> 2) Mention the glibc error in the commit message, so that search engines
> turn this up?
> 3) Copy in some part of my explanation (either from this message or the
> reply to the thread mentioned above).
> 
> If you don't feel like it or don't have time, let me know. I originally
> wanted to send the revert myself, but got distracted.

I'd be glad to send it out, I was actually bitten by the vendor string
issue when hacking around with [1].

[1] https://patchwork.kernel.org/project/kvm/cover/20220316005538.2282772-1-oupton@google.com/

--
Thanks,
Oliver
