Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F8C5BB278
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 20:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiIPSwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 14:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIPSwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 14:52:35 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22627B8A56
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 11:52:34 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id jm11so22226435plb.13
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 11:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=di38Vx0xcwobovXFuqa+aqs6mrMaWt2alUPAsQ25AHE=;
        b=HMcch5JkSHJGz9ZQUqTzI4QHZMH3bJxFOKm3B2upHhnBl8/9dF5xCiieB6xk0c+KIl
         q/UQNLIza5wPp9U3ZRDC11bREH40xKg9rwbBLS/9/Ngdpi9jalz5O98gp9u2AmKOwT84
         PvyXmUaQlLAt3Ta2OHtGUN9Vj0lbmm/pMUAwf7Z3KykezFtqcQz6mZZeR6IVSwkyBA3d
         EluQsbFtgxctVh2rodhtkv1Aw5XtjXzP3lzDieu3mil82A92fnXrZMquY428RedIw3Dz
         ZXEjrLpT0t0t35F5zT6pv9mEso44N9Xs3fE4HlTNQTj9jFY7LTvDHbHlzv8x7dAtaPNP
         4NLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=di38Vx0xcwobovXFuqa+aqs6mrMaWt2alUPAsQ25AHE=;
        b=M8INZtqkbul4cBZU8o6FIRdn/n4hM8D1qVFsnGqkE5e/aJfRgbAmi5uq4f7M8M5mtu
         tIPn/TKeVD6ke7he1P+i2SYQAk+XJHhvv+KWK1g3PB91M6W8ki/s2DF8U06eiXFw8WAM
         0PnVYLcpWiaBnLc7fp4ZPtvsDk0RYHiEUSGXY/zqHF2iuSVxsPqrMgsNjmavDS6Pl6zJ
         ByyCOUSk9VPPuswwEWnbTGdFE19TQ2JC8BHUWr6mnn2QYMjRU29uz4PovYUSaquKRHFk
         1bHdakipK/aa/Zz5pUM/gzgfhgPgx/UMp1NGTDNjFBrgygW2+ssNACsc0+JZfWuQvLBV
         OzBw==
X-Gm-Message-State: ACrzQf3/L/rlhYZyshgCQ7XwfQekeG0QLTlIeKCZ2tch0AJN+YVFFJeq
        Dbvy0ekB+kxG9lIVPCwfbXAf6w==
X-Google-Smtp-Source: AMsMyM79oWhOrC1Z2hhvwMa6jwFt0c4Pf+jX7H0OuYkUP5Y9m5sL72liu9kfyo9lakjZU8wMGvW9tA==
X-Received: by 2002:a17:90b:1b4d:b0:202:c05f:6ea0 with SMTP id nv13-20020a17090b1b4d00b00202c05f6ea0mr7040678pjb.7.1663354353552;
        Fri, 16 Sep 2022 11:52:33 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a10-20020a170902ecca00b0016c574aa0fdsm15487240plh.76.2022.09.16.11.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 11:52:32 -0700 (PDT)
Date:   Fri, 16 Sep 2022 18:52:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH v2 13/23] KVM: x86: Disable APIC logical map if vCPUs are
 aliased in logical mode
Message-ID: <YyTF7SsMjm+pClqh@google.com>
References: <20220903002254.2411750-1-seanjc@google.com>
 <20220903002254.2411750-14-seanjc@google.com>
 <aedb7677-528a-75b7-6517-ab1865515ad4@amd.com>
 <YyGF6T/N1l3i7Ded@google.com>
 <59c2085e-1f0a-fe7d-8146-6c1bc570c97b@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59c2085e-1f0a-fe7d-8146-6c1bc570c97b@amd.com>
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

On Wed, Sep 14, 2022, Suthikulpanit, Suravee wrote:
> > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > > index 6b2f538b8fd0..75748c380ceb 100644
> > > > --- a/arch/x86/kvm/lapic.c
> > > > +++ b/arch/x86/kvm/lapic.c
> > > > @@ -303,12 +303,13 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
> > > >    		if (!mask)
> > > >    			continue;
> > > > -		if (!is_power_of_2(mask)) {
> > > > +		ldr = ffs(mask) - 1;
> > > > +		if (!is_power_of_2(mask) || cluster[ldr]) {
> > > 
> > > Should this be checking if the cluster[ldr] is pointing to the same struct
> > > apic instead? For example:
> > > 
> > > 		if (!is_power_of_2(mask) || cluster[ldr] != apic)
> > > 
> > >  From my observation, the kvm_recalculate_apic_map() can be called many
> > > times, and the cluster[ldr] could have already been assigned from the
> > > previous invocation. So, as long as it is the same, it should be okay.
> > 
> > No, because cluster[ldr] can never match "apic".  kvm_recalculate_apic_map()
> > creates and populates a _new_ kvm_apic_map every time, it doesn't do an in-place
> > update of the current map.
> 
> Yes, the _new_ is getting created and initialized every time we call
> kvm_recalculate_apic_map(), and then passed into
> kvm_apic_map_get_logical_dest() along with the reference of cluster and mask
> to get populated based on the provided ldr. Please note that the
> new->phys_map[x2apic_id] is already assigned before the calling of

Ooh, this is what I was missing.  LDR is read-only for x2APIC, and so KVM simply
uses the phys_map and computes the phys_map indices by reversing the x2APIC=>LDR
calculation.

So it's so much not that _can_ "apic" can match "cluster[ldr]", it's actually that
"apic" _must_ match "cluster[ldr]" for this flow.  Overwriting the cluster entry
is all kinds of pointless.  It's either unnecessary (no bugs) or it breaks things
(bugs in either LDR calculation or logical dest math).

Rather than add an exception to the cluster[] check, which is very confusing for
xAPIC, the whole flow can be skipped for x2APIC, with a sanity check that the LDR
does indeed align with the x2APIC ID.

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 76a19bf1eb55..e9d7c647e8a7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -347,6 +347,12 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
                }
                new->logical_mode = logical_mode;
 
+               /* I'll add a comment here. */
+               if (apic_x2apic_mode(apic)) {
+                       WARN_ON_ONCE(ldr != kvm_apic_calc_x2apic_ldr(x2apic_id));
+                       continue;
+               }
+
                if (WARN_ON_ONCE(!kvm_apic_map_get_logical_dest(new, ldr,
                                                                &cluster, &mask))) {
                        new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;

Alternatively, the x2APIC handling could be done after kvm_apic_map_get_logical_dest(),
e.g. so that KVM can sanity check mask+cluster[ldr], but that's annoying to implement
and IMO it's overkill since the we can just as easily verify the math via tests on top
of the LDR sanity check.

I'll do a better job of verifying that APICv + x2APIC yields the correct inhibits.
I verified x2APIC functional correctness, and that APICv + xAPIC yielded the correct
inhibits, but I obviously didn't verify APICv + x2APIC yielded the correct inhibits.

Thanks much!
