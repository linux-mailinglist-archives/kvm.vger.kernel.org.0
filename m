Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C549C59C674
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 20:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiHVSdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 14:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237588AbiHVSc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 14:32:56 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8283F4BA64
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 11:32:30 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso14861674pjk.0
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 11:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=3pKOuS9bPCfHx4b2cjVQc088kaA5gmugVVhXnoWl0R4=;
        b=sU5v9o7Maz94cphiUk0iGtYwZ8KgUY4HSf9XbHNsFwxHC8SpRbMTv/X+qxPZGvDsDE
         K6BFujPXC48leKW1lCzKWMK+si2TFy9/Cm/Lhx6r1OtvxzaT5ARQwxfsmb8hIMSHRW7b
         lSpNszsvnbTDk+8nNGK3gV8uA1jALtymYVTInzRaSsPvbJTIHoEe9nmrC9RgnPGlFzj9
         MialtQ15T2tbbFUtllvwY/gsgSHxGNjnOkCiAh8R3zeW4NdgxCcoWnTKH5OczqsWzre6
         wM2h9jqXOzm3GSSsJDB0FpIIKqpd1SxhjC/+H5D3VCtROl1xDQI/8rDkC/BS2kkANKEz
         cd7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=3pKOuS9bPCfHx4b2cjVQc088kaA5gmugVVhXnoWl0R4=;
        b=diFSTSfomkGQYobrXhZweElwM4IM4ylIfG+nkPmhpAfd4Uoz9IsVfg6GosJ/N+HN4N
         8TgYdEcoTbXLjAjfniJ0corwNsTkJbjMpm8R9MwhRZdZaLlxECVkVaapYAUXjqwlzArG
         Jy/LC+TKVlTZKI8xr7wSBZZ5OEAaElbGmQ/vMrTaZKgMSBpt9DZP/C7+0xArRXWVjqjs
         m6gAWoJIx/gxBKLVlAkGx8snPS8bpvPv+tlXj/QpF+7gXp4BQUo+52kwJtb3vVsoU2nj
         N2Ra9k4lydwi28kYmpvUR5fJx9ePPYXeWUpS+uu/kKtH+MuGJ6sEhwIPls4fZ4zdp+ZQ
         ojbA==
X-Gm-Message-State: ACgBeo20DGycMDi6v0tC0TlJ41UGGbgrxq1F5aNIMxwJ8OS13e8Okf6w
        ejoDaFa5WYkVTdrlxIvmRIf94w==
X-Google-Smtp-Source: AA6agR5t8vY6wHth/oFQzUUROc10MQ6sPeWK+Nlnqjg1jl3To2ype6CO7nYnon+0rfKqNYo16+sJHQ==
X-Received: by 2002:a17:90b:3b85:b0:1fb:18f6:c65f with SMTP id pc5-20020a17090b3b8500b001fb18f6c65fmr9748839pjb.217.1661193147720;
        Mon, 22 Aug 2022 11:32:27 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x15-20020a170902ec8f00b0016be527753bsm787162plg.264.2022.08.22.11.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 11:32:27 -0700 (PDT)
Date:   Mon, 22 Aug 2022 18:32:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/26] x86/hyperv: Update 'struct hv_enlightened_vmcs'
 definition
Message-ID: <YwPLt2e7CuqMzjt1@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-4-vkuznets@redhat.com>
 <Yv5ZFgztDHzzIQJ+@google.com>
 <875yiptvsc.fsf@redhat.com>
 <Yv59dZwP6rNUtsrn@google.com>
 <87czcsskkj.fsf@redhat.com>
 <YwOm7Ph54vIYAllm@google.com>
 <87edx8xn8h.fsf@redhat.com>
 <YwO2fSCGXnE/9mc2@google.com>
 <878rngxjb7.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rngxjb7.fsf@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 22, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Mon, Aug 22, 2022, Vitaly Kuznetsov wrote:
> >> My initial implementation was inventing 'eVMCS revision' concept:
> >> https://lore.kernel.org/kvm/20220629150625.238286-7-vkuznets@redhat.com/
> >> 
> >> which is needed if we don't gate all these new fields on CPUID.0x4000000A.EBX BIT(0).
> >> 
> >> Going forward, we will still (likely) need something when new fields show up.
> >
> > My comments from that thread still apply.  Adding "revisions" or feature flags
> > isn't maintanable, e.g. at best KVM will end up with a ridiculous number of flags.
> >
> > Looking at QEMU, which I strongly suspect is the only VMM that enables
> > KVM_CAP_HYPERV_ENLIGHTENED_VMCS, it does the sane thing of enabling the capability
> > before grabbing the VMX MSRs.
> >
> > So, why not simply apply filtering for host accesses as well?
> 
> (I understand that using QEMU to justify KVM's behavior is flawed but...)
> 
> QEMU's migration depends on the assumption that identical QEMU's command
> lines create identical (from guest PoV) configurations. Assume we have
> (simplified)
> 
> "-cpu CascadeLake-Sever,hv-evmcs"
> 
> on both source and destination but source host is newer, i.e. its KVM
> knows about TSC Scaling in eVMCS and destination host has no idea about
> it. If we just apply filtering upon vCPU creation, guest visible MSR
> values are going to be different, right? Ok, assuming QEMU also migrates
> VMX feature MSRs (TODO: check if that's true), we will be able to fail
> mirgration late (which is already much worse than not being able to
> create the desired configuration on destination, 'fail early') if we use
> in-KVM filtering to throw an error to userspace. But if we blindly
> filter control MSRs on the destination, 'TscScaling' will just disapper
> undreneath the guest. This is unlikely to work.

But all of that holds true irrespetive of eVMCS.  If QEMU attempts to migrate a
nested guest from a KVM that supports TSC_SCALING to a KVM that doesn't support
TSC_SCALING, then TSC_SCALING is going to disappear and VM-Entry on the dest will
fail.  I.e. QEMU _must_ be able to detect the incompatibility and not attempt
the migration.  And with that code in place, QEMU doesn't need to do anything new
for eVMCS, it Just Works.

> In any case, what we need, is an option for VMM (read: QEMU) to create
> the configuration with 'TscScaling' filtered out even KVM supports the
> bit in eVMCS. This way the guest will be able to migrate backwards to an
> older KVM which doesn't support it, i.e.
> 
> '-cpu CascadeLake-Sever,hv-evmcs'
>  creates the 'origin' eVMCS configuration, no TscScaling
> 
> '-cpu CascadeLake-Sever,hv-evmcs,hv-evmcs-2022' creates the updated one.

Again, this conundrum exists irrespective of eVMCS.  Properly solve the problem
for regular nVMX and eVMCS should naturally work.

> KVM_CAP_HYPERV_ENLIGHTENED_VMCS is bad as it only takes 'eVMCS' version
> as a parameter (as we assumed it will always change when new fields are
> added, but that turned out to be false). That's why I suggested
> KVM_CAP_HYPERV_ENLIGHTENED_VMCS2.

Enumerating features via versions is such a bad API though, e.g. if there's a
bug with nested TSC_SCALING, userspace can't disable just nested TSC_SCALING
without everything else under the inscrutable "hv-evmcs-2022" being collateral
damage.
