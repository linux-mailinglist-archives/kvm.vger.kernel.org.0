Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88636D9384
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 12:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236618AbjDFKCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 06:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236471AbjDFKCY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 06:02:24 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAB52D44;
        Thu,  6 Apr 2023 03:01:41 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-4dd9da1c068so494140e87.0;
        Thu, 06 Apr 2023 03:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680775299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jD09oc1p3GE1KfBGdCsMW1hPcGKRBlTNFuXfntk8i7w=;
        b=LaOOGjH9D5EyoPRtf56olfEC03Rn/Z+kT/2G60G8CKc9qn0V0YogntvwiN9IjLq5KG
         yQmYok4Vcs4tfRCf5O36xBGaprYrDVhCMolhNLFtdLyX/tHT5paGEftO4r0fYe+3Dix4
         /oizT6gf0uRfagQz3unUi8ZyRwDXAcyTR8FZ67IaE83Xh4I0+icZR5KBBhBmtwJKKMlx
         F9Gtxu1ZeLMR/NCYmLJoehy8D3uQm0Iyrorye/O2M7SShrbcWJ5I2QH2OjRwjsdezo+z
         yYiqmmZz6n3Yhmb+Z4l5XotOX2p/8VhgQDYCR0Gza5UzllftkfhcxJkJfIE4UrtWEl4J
         7dxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680775299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jD09oc1p3GE1KfBGdCsMW1hPcGKRBlTNFuXfntk8i7w=;
        b=vV5CnNgy+elGl7LUXFhrimcK6HK51k0igazWCn9LU5JfK3TnhqHKhQkm7CAw39zeqr
         pKlfpIPLmIC3lKqYW8HDM9t7UTec4NMKFT0IEHfN1piM3BIJPgDvDBgvu1hRvDB5d6fT
         /YDYk2MiASQlxvU+B5vQ4ULb93UkGDnLkskFH1GRQSVACMIvSiQy8K8CvErMFtHpfWYV
         QQN6tLGZdD+OVkFEjGaoxD4C8K7NpO+Bkn7dn55mL1wLLno0jLS3WHqj12ZpDqP5mfjg
         T+/ssgom3cLo1D3x+/mriWAfR5fRhMiMVIUmYkLl35FLeUU2F/Bzo3Wk3p4Ws+X2AAIN
         dqtg==
X-Gm-Message-State: AAQBX9fHnR8RrGuAdDgZPfwAfWqNOuo3vAiNNUgP6s+Iq6b5c5IJaV+7
        tSW5wSEHET4pUpAjaS1QgIk=
X-Google-Smtp-Source: AKy350Ygr9+VHcZszjIOQd1qvo6t1oPQUn6GWglIregwGdmytnOM9fgRw3TiItoQJkLDcOqdWp2/sw==
X-Received: by 2002:a05:651c:1a0c:b0:295:a024:f3e2 with SMTP id by12-20020a05651c1a0c00b00295a024f3e2mr1897664ljb.5.1680775299435;
        Thu, 06 Apr 2023 03:01:39 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id z14-20020a2e9b8e000000b00298a81f5d70sm214859lji.136.2023.04.06.03.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 03:01:39 -0700 (PDT)
Date:   Thu, 6 Apr 2023 13:01:19 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
Message-ID: <20230406130119.000011fe.zhi.wang.linux@gmail.com>
In-Reply-To: <ZC4qF90l77m3X1Ir@google.com>
References: <20230405005911.423699-1-seanjc@google.com>
        <d0af618169ebc17722e7019ca620ec22ee0b49c3.camel@intel.com>
        <ZC4qF90l77m3X1Ir@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Apr 2023 19:10:40 -0700
Sean Christopherson <seanjc@google.com> wrote:

> On Wed, Apr 05, 2023, Huang, Kai wrote:
> > On Tue, 2023-04-04 at 17:59 -0700, Sean Christopherson wrote:
> > > *** WARNING *** ABI breakage.
> > > 
> > > Stop adjusting the guest's CPUID info for the allowed XFRM (a.k.a. XCR0)
> > > for SGX enclaves.  Past me didn't understand the roles and responsibilities
> > > between userspace and KVM with respect to CPUID leafs, i.e. I thought I was
> > > being helpful by having KVM adjust the entries.
> > 
> > Actually I am not clear about this topic.
> > 
> > So the rule is KVM should never adjust CPUID entries passed from userspace?
> 
> Yes, except for true runtime entries where a CPUID leaf is dynamic based on other
> CPU state, e.g. CR4 bits, MISC_ENABLES in the MONITOR/MWAIT case, etc.
> 
> > What if the userspace passed the incorrect CPUID entries?  Should KVM sanitize
> > those CPUID entries to ensure there's no insane configuration?  My concern is if
> > we allow guest to be created with insane CPUID configurations, the guest can be
> > confused and behaviour unexpectedly.
> 
> It is userspace's responsibility to provide a sane, correct setup.  The one
> exception is that KVM rejects KVM_SET_CPUID{2} if userspace attempts to define an
> unsupported virtual address width, the argument being that a malicious userspace
> could attack KVM by coercing KVM into stuff a non-canonical address into e.g. a
> VMCS field.
> 
> The reason for KVM punting to userspace is that it's all but impossible to define
> what is/isn't sane.  A really good example would be an alternative we (Google)
> considered for the "smaller MAXPHYADDR" fiasco, the underlying problem being that
> migrating a vCPU with MAXPHYADDR=46 to a system with MAXPHYADDR=52 will incorrectly
> miss reserved bit #PFs.
> 
> Rather than teach KVM to try and deal with smaller MAXPHYADDRs, an idea we considered
> was to instead enumerate guest.MAXPHYADDR=52 on platforms with host.MAXPHYADDR=46 in
> anticipation of eventual migration.  So long as userspace doesn't actually enumerate
> memslots in the illegal address space, KVM would be able to treat such accesses as
> emulated MMIO, and would only need to intercept #PF(RSVD).
> 
> Circling back to "what's sane", enumerating guest.MAXPHYADDR > host.MAXPHYADDR
> definitely qualifies as insane since it really can't work correctly, but in our
> opinion it was far superior to running with allow_smaller_maxphyaddr=true.
> 
> And sane is not the same thing as architecturally legal.  AMX is a good example
> of this.  It's _technically_ legal to enumerate support for XFEATURE_TILE_CFG but
> not XFEATURE_TILE_DATA in CPUID, but illegal to actually try to enable TILE_CFG
> in XCR0 without also enabling TILE_DATA.  KVM should arguably reject CPUID configs
> with TILE_CFG but not TILE_DATA, and vice versa, but then KVM is rejecting a 100%
> architecturally valid, if insane, CPUID configuration.  Ditto for nearly all of
> the VMX control bits versus their CPUID counterparts.
> 
> And sometimes there are good reasons to run a VM with a truly insane configuration,
> e.g. for testing purposes.
> 
> TL;DR: trying to enforce "sane" CPUID/feature configuration is a gigantic can of worms.

Interesting point. I was digging the CPUID virtualization OF TDX/SNP.
It would be nice to have a conclusion of what is "sane" and what is the
proper role for KVM, as firmware/TDX module is going to validate the "sane"
CPUID.

TDX/SNP requires the CPUID to be pre-configured and validated before creating
a CC guest. (It is done via TDH.MNG.INIT in TDX and inserting a CPUID page in
SNP_LAUNCH_UPDATE in SNP).

IIUC according to what you mentioned, KVM should be treated like "CPUID box"
for QEMU and the checks in KVM is only to ensure the requirements of a chosen
one is literally possible and correct. KVM should not care if the combination, the usage of the chosen ones is insane or not, which gives QEMU flexibility.

As the valid CPUIDs have been decided when creating a CC guest, what should be
the proper behavior (basically any new checks?) of KVM for the later
SET_CPUID2? My gut feeling is KVM should know the "CPUID box" is reduced
at least, because some KVM code paths rely on guest CPUID configuration.
