Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88926265EA
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 01:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbiKLASe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 19:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbiKLASc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 19:18:32 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C254E0D5
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 16:18:29 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gw22so5707599pjb.3
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 16:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BltPvPAmHtl7utKNnS+hSG3e7Q2hwDLmN28Mis71BjM=;
        b=ihXl+Lit+9X0nRxA2Gtm5l/WGvA/aJA5XkvSKznBo5ioJqPewp8RSDbyREb7Z6EjUM
         gm3DJytEHoymvvMqjQpASz4pZdZm7DuH4C1B6M9fm9ih1EoW6wUYkbKpVub1U7NWqDBj
         KR+UvYumaY6yzG5WyBQq4r4aUCFqxz1mctCqNdCeOzoMAdLsOgSPeMVPSM1cNJobtO41
         OIRW+JnvltDxaxcya/6HiFANJKhAoJEh36OfQsAfElBchbkYuVHwNuTerkmjBDdrWQZN
         6Nn53XoOrt/Fm5UcFwn5Em2pFIxOiYsJGVsfQXCT8RBqN1A3VDHFNP9qu4I52aAekLKT
         /znA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BltPvPAmHtl7utKNnS+hSG3e7Q2hwDLmN28Mis71BjM=;
        b=pNE+QPqJuleEGFBWHq+5nj6PRNshfHrYH1r9Y9dFl/75pfngeMsNgfcO31KIjkLbJo
         HPVRFyi5Er+z8f4r4c3mPFeFR0lVS3W7DWOnAhSuFBMRPWSK9jOjdaaP11+neNQDlHjU
         NuyLIzJMtJ0SDNbTT7PKlh1XV6XiEhGTZhgf4Qd8WPmFx9YkoRZyOou2nDTxkbM5E0Pc
         oopTJGQMwrW4SoSnj+pNQq1BoQXHWb0FpKanoTfvx+T5uy5qlAfZ9QFJfqfV1j41BoGw
         dcvRJFU7X1Cd450A6qbA2W1chKHnoRkoFDvTcLlVtlRcq/SW0VwvJ9hfIBx5HjyD6+GM
         TYHg==
X-Gm-Message-State: ANoB5pmN3lV88AYHolajLfo/tmXpf8w16Upsd/Zvt9MWkYo5XG6oMr7r
        kPGiYM9xk0HMwRUonmFqqK3r4Q==
X-Google-Smtp-Source: AA0mqf6Rv6a4Qx8bNbK/7DZ5vdIuU2Id03hLVAf075VLC9gKFaG+y2jRfMKKMSCm2B3eTNiHsnrjKQ==
X-Received: by 2002:a17:902:e8c8:b0:188:7675:ff9b with SMTP id v8-20020a170902e8c800b001887675ff9bmr4453723plg.45.1668212308974;
        Fri, 11 Nov 2022 16:18:28 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902d50700b00186e34524e3sm2317428plg.136.2022.11.11.16.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 16:18:28 -0800 (PST)
Date:   Sat, 12 Nov 2022 00:18:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        shuah@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
        ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
        will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, peterx@redhat.com, oliver.upton@linux.dev,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v10 3/7] KVM: Support dirty ring in conjunction with
 bitmap
Message-ID: <Y27mUerBVW5+loCf@google.com>
References: <20221110104914.31280-1-gshan@redhat.com>
 <20221110104914.31280-4-gshan@redhat.com>
 <Y20q3lq5oc2gAqr+@google.com>
 <1cfa0286-9a42-edd9-beab-02f95fc440ad@redhat.com>
 <86h6z5plhz.wl-maz@kernel.org>
 <d11043b5-ff65-0461-146e-6353cf66f737@redhat.com>
 <Y27T+1Y8w0U6j63k@google.com>
 <c95c9912-0ca9-88e5-8b51-0c6826cf49b9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c95c9912-0ca9-88e5-8b51-0c6826cf49b9@redhat.com>
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

On Sat, Nov 12, 2022, Gavin Shan wrote:
> Hi Sean,
> 
> On 11/12/22 7:00 AM, Sean Christopherson wrote:
> > On Sat, Nov 12, 2022, Gavin Shan wrote:
> > > On 11/11/22 11:19 PM, Marc Zyngier wrote:
> > > > On Thu, 10 Nov 2022 23:47:41 +0000,
> > > > Gavin Shan <gshan@redhat.com> wrote:
> > > > But that I don't get. Or rather, I don't get the commit message that
> > > > matches this hunk. Do we want to catch the case where all of the
> > > > following are true:
> > > > 
> > > > - we don't have a vcpu,
> > > > - we're allowed to log non-vcpu dirtying
> > > > - we *only* have the ring?
> > 
> > As written, no, because the resulting WARN will be user-triggerable.  As mentioned
> > earlier in the thread[*], if ARM rejects KVM_DEV_ARM_ITS_SAVE_TABLES when dirty
> > logging is enabled with a bitmap, then this code can WARN.
> > 
> 
> I assume you're saying to reject the command when dirty ring is enabled
> __without__ a bitmap. vgic/its is the upper layer of dirty dirty.

I was stating that that is an option.  I was not opining anything, I truly don't
care whether or not KVM_DEV_ARM_ITS_SAVE_TABLES is rejected.

> To me, it's a bad idea for the upper layer needs to worry too much about the
> lower layer.

That ship sailed when we added kvm_arch_allow_write_without_running_vcpu().
Arguably, it sailed when the dirty ring was added, which solidified the requirement
that writing guest memory "must" be done with a running vCPU.

> > > > If so, can we please capture that in the commit message?
> > > > 
> > > 
> > > Nice catch! This particular case needs to be warned explicitly. Without
> > > the patch, kernel crash is triggered. With this patch applied, the error
> > > or warning is dropped silently. We either check memslot->dirty_bitmap
> > > in mark_page_dirty_in_slot(), or check it in kvm_arch_allow_write_without_running_vcpu().
> > > I personally the later one. Let me post a formal patch on top of your
> > > 'next' branch where the commit log will be improved accordingly.
> > 
> > As above, a full WARN is not a viable option unless ARM commits to rejecting
> > KVM_DEV_ARM_ITS_SAVE_TABLES in this scenario.  IMO, either reject the ITS save
> > or silently ignore the goof.  Adding a pr_warn_ratelimited() to alert the user
> > that they shot themselves in the foot after the fact seems rather pointless if
> > KVM could have prevented the self-inflicted wound in the first place.
> > 
> > [*] https://lore.kernel.org/all/Y20q3lq5oc2gAqr+@google.com
> > 
> 
> Without a message printed by WARN, kernel crash or pr_warn_ratelimited(), it
> will be hard for userspace to know what's going on, because the dirty bits
> have been dropped silently.I think we still survive since we have WARN
> message for other known cases where no running vcpu context exists.

That WARN is to catch KVM bugs.  No KVM bugs, no WARN.  WARNs must not be user
triggerable in the absence of kernel bugs.  This is a kernel rule, not a KVM thing,
e.g. see panic_on_warn.

printk() is useless for running at any kind of scale as userspace can't take action
on "failure", e.g. unless userspace has a priori knowledge of the _exact_ error
message then human intervention is required (there are other issues as well).

A ratelimited printk() makes things even worse because then a failing VM may not
get its "failure" logged, i.e. the printk() is even less actionable.

And user triggerable printks() need to be ratelimited to prevent a malicious or
broken userspace from flooding the kernel log.  Thus, this "failure" would need
to be ratelimited, making it all but useless for anyone but developers.

> So if I'm correct, what we need to do is to improve the commit message to
> address Marc's concerns here? :)

Yes, Marc is saying that it's not strictly wrong for userspace to not dirty log
the ITS save, so rejecting KVM_DEV_ARM_ITS_SAVE_TABLES is a bad option. 
