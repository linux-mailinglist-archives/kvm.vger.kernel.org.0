Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3E175CADE
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 17:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbjGUPDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 11:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbjGUPDt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 11:03:49 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C8619B6
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 08:03:47 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ccabb20111dso1948867276.3
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 08:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689951827; x=1690556627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wGn4OEfk0vlFKfnPCtDfZtJXmjzGnHvHPk0kd4K2tXA=;
        b=Ioebs51XNQGVx+HNBJD56Sq5VN01fat7uctItv+GLEJ+TONxR28cDNyHCFwj+WROYW
         rJ6Bp4gf6/SLJ/F8NiWPU0pvVSPXHJtJNW0XeHbBpgQHNFAl/DPRrfpBakuYhOHtW9/q
         R72bG9sDjZoBH3Iops33gju1DTZ4RGFD3+CujnoNO7nbFIyUZelmRmvnslZzEauowKtQ
         GCTvI3o2LtyiNZMphqusgubRpB6iqtwwMgc64UgRb+azFcgFCuzEkdztUXVhKeN/v5NW
         /Lc+XFZUoVQa92AOkSU1WBBzOs5Uf+yJmhmMXfjdP8hE+xocPiThIxKvVEl3YZXDKjNT
         vukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689951827; x=1690556627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wGn4OEfk0vlFKfnPCtDfZtJXmjzGnHvHPk0kd4K2tXA=;
        b=CjyoIlmACHq7zPFyd0qj2U+nbXZhA9NToBPGVt8MS5VJSHlYgvcEmm3B9qIG1fRolf
         nsSLIPPFFE7oYKv2sUn6i2djyX4EwOS4E7yhnag8FEQg/rsJvb8JHSluAe63S7PbVbHs
         xzoVEa3kjyKbLOrdEC09+C9zrxYUvsFMQH8vZ/7UEt3uzxswwNKAb0kzOPbx+xNYT71/
         0zm5k8Lclfd53c7LqPgYXayCRUk/pIxpFUugu02tzSwyrknXqteXk1uuU/FDsQ/CCoSe
         PaHgAzmvdVujmto+7b/uOPA2HlbxYX/ENnkAmOYSWiQ1inzq95nB31SptJREp9Gc7wVF
         /nGw==
X-Gm-Message-State: ABy/qLbbADt8sYq341VpXn1HDlbh/rAiEU8unImxGZrPaEti3EXfKn4e
        MPectRZjJaPfOZceeuLkD7uNHpsHjP4=
X-Google-Smtp-Source: APBJJlFJfUKU5XpPQmS1+W0Z0ow8sVEzJhMr/4/s/4mlG4MeWZohLWBxPcVay/b6xljyRIT8cJuteIPJI3U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aa05:0:b0:cf0:e2a2:eb3b with SMTP id
 s5-20020a25aa05000000b00cf0e2a2eb3bmr13141ybi.4.1689951827185; Fri, 21 Jul
 2023 08:03:47 -0700 (PDT)
Date:   Fri, 21 Jul 2023 08:03:45 -0700
In-Reply-To: <e84129b1-603b-a6c4-ade5-8cf529929675@linux.intel.com>
Mime-Version: 1.0
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
 <20230719144131.29052-3-binbin.wu@linux.intel.com> <20230720235352.GH25699@ls.amr.corp.intel.com>
 <e84129b1-603b-a6c4-ade5-8cf529929675@linux.intel.com>
Message-ID: <ZLqeUXerpNlri7Px@google.com>
Subject: Re: [PATCH v10 2/9] KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to
 check CR3's legality
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        chao.gao@intel.com, kai.huang@intel.com, David.Laight@aculab.com,
        robert.hu@linux.intel.com, guang.zeng@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 21, 2023, Binbin Wu wrote:
> 
> 
> On 7/21/2023 7:53 AM, Isaku Yamahata wrote:
> > On Wed, Jul 19, 2023 at 10:41:24PM +0800,
> > Binbin Wu <binbin.wu@linux.intel.com> wrote:
> > 
> > > Add and use kvm_vcpu_is_legal_cr3() to check CR3's legality to provide
> > > a clear distinction b/t CR3 and GPA checks. So that kvm_vcpu_is_legal_cr3()
> > > can be adjusted according to new feature(s).
> > > 
> > > No functional change intended.
> > > 
> > > Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> > > ---
> > >   arch/x86/kvm/cpuid.h      | 5 +++++
> > >   arch/x86/kvm/svm/nested.c | 4 ++--
> > >   arch/x86/kvm/vmx/nested.c | 4 ++--
> > >   arch/x86/kvm/x86.c        | 4 ++--
> > >   4 files changed, 11 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> > > index f61a2106ba90..8b26d946f3e3 100644
> > > --- a/arch/x86/kvm/cpuid.h
> > > +++ b/arch/x86/kvm/cpuid.h
> > > @@ -283,4 +283,9 @@ static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
> > >   	return vcpu->arch.governed_features.enabled & kvm_governed_feature_bit(x86_feature);
> > >   }
> > > +static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> > > +{
> > > +	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
> > > +}
> > > +
> > The remaining user of kvm_vcpu_is_illegal_gpa() is one left.  Can we remove it
> > by replacing !kvm_vcpu_is_legal_gpa()?
> 
> There are still two callsites of kvm_vcpu_is_illegal_gpa() left (basing on
> Linux 6.5-rc2), in handle_ept_violation() and nested_vmx_check_eptp().
> But they could be replaced by !kvm_vcpu_is_legal_gpa() and then remove
> kvm_vcpu_is_illegal_gpa().
> I am neutral to this.

I'm largely neutral on this as well, though I do like the idea of having only
"legal" APIs.  I think it makes sense to throw together a patch, we can always
ignore the patch if end we up deciding to keep kvm_vcpu_is_illegal_gpa().
