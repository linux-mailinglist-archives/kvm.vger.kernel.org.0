Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8FEF59E99E
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 19:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiHWR11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 13:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234257AbiHWRZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 13:25:26 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AF79DFA3
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 08:00:43 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id t11-20020a17090a510b00b001fac77e9d1fso14796397pjh.5
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 08:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=404w8Q0GUcT0rENXKmDpJVSnK0XAgs8EeeVxYBtVK5w=;
        b=pjbU1DNRuzFKfM3bVCR72fNfK18CmfQeaWWhEwLlagZBGIHQGgc78z2GLBcYfzFnh5
         MLQtZ+EQwCpEc7mDqUeE+dWT1U2aXtQnxj+yBm1OYUg1inzODwqqpwfFiDZUfA7lWck1
         6Lg0N8zzE5QykCaFRB52HWPN/6bl8eojsnmKAzwzmcEll6nm6S2NCjKVGfIAKIoZbZOp
         4WzSNA154aebcQ/mLz3+o6z6Joxvum4461Zo8+HMpV3T8MaxpJFZd0zikDl0sy7s8xV9
         rLH/bVTVdZ3+JzbWWPhJUw+y54cAw14w5gXKbwsP7AGHkbzH+igVo1KQqc+O+jB5mx3H
         XMcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=404w8Q0GUcT0rENXKmDpJVSnK0XAgs8EeeVxYBtVK5w=;
        b=IihX037YgqOPJPCDq1WQJ8kQvHwy+w9w16K+W5ZDX4JYg8ColaEyqfam7RQ02RZ0a2
         5f78mzSTDdUwGpO2aptgbIHf17lopxq0eYHE3PTc0n0KWwj/fe0wAXYcytgnxXue0fdv
         s1wvCRVJBnERtv4BFIKqfdcHd5WRevlx1dauy7NtJzjS2wvDVtv2HOXfAM1xlMposd64
         KXnff8oPydju4dizP/dyXE8EPUxbQaW2rXIWhNo7MgzuB+9uGdsE+GvkrkUIfLEbBFoK
         0EBKJoE/+PG3U2YR2AE/45k1potCreOmyzbr4mGybQ4oHl2DOjl8So0BsodPQQoO3Uxw
         UriA==
X-Gm-Message-State: ACgBeo0oHwz9C/isRWNyzQ9+xHpKTAor9xjT2x3rdRvPEqBZMylCHW3x
        Tt7aCJJ0XNgWCzrxLtlz0cLr0g==
X-Google-Smtp-Source: AA6agR4d3595DOI6WKObS0WNK+FlELwpg2j3CyYVfMT6yezKGffMJE55R9o1Ho9Ha/5/M0ik5usocg==
X-Received: by 2002:a17:90b:1a85:b0:1fb:1f0b:dd43 with SMTP id ng5-20020a17090b1a8500b001fb1f0bdd43mr3697750pjb.213.1661266842529;
        Tue, 23 Aug 2022 08:00:42 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x124-20020a623182000000b00534cb3872edsm10864022pfx.166.2022.08.23.08.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 08:00:42 -0700 (PDT)
Date:   Tue, 23 Aug 2022 15:00:38 +0000
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
Message-ID: <YwTrlgeqoAqyH0KF@google.com>
References: <Yv5ZFgztDHzzIQJ+@google.com>
 <875yiptvsc.fsf@redhat.com>
 <Yv59dZwP6rNUtsrn@google.com>
 <87czcsskkj.fsf@redhat.com>
 <YwOm7Ph54vIYAllm@google.com>
 <87edx8xn8h.fsf@redhat.com>
 <YwO2fSCGXnE/9mc2@google.com>
 <878rngxjb7.fsf@redhat.com>
 <YwPLt2e7CuqMzjt1@google.com>
 <87wnazwh1r.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wnazwh1r.fsf@redhat.com>
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

On Tue, Aug 23, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Mon, Aug 22, 2022, Vitaly Kuznetsov wrote:
> >> QEMU's migration depends on the assumption that identical QEMU's command
> >> lines create identical (from guest PoV) configurations. Assume we have
> >> (simplified)
> >> 
> >> "-cpu CascadeLake-Sever,hv-evmcs"
> >> 
> >> on both source and destination but source host is newer, i.e. its KVM
> >> knows about TSC Scaling in eVMCS and destination host has no idea about
> >> it. If we just apply filtering upon vCPU creation, guest visible MSR
> >> values are going to be different, right? Ok, assuming QEMU also migrates
> >> VMX feature MSRs (TODO: check if that's true), we will be able to fail
> >> mirgration late (which is already much worse than not being able to
> >> create the desired configuration on destination, 'fail early') if we use
> >> in-KVM filtering to throw an error to userspace. But if we blindly
> >> filter control MSRs on the destination, 'TscScaling' will just disapper
> >> undreneath the guest. This is unlikely to work.
> >
> > But all of that holds true irrespetive of eVMCS.  If QEMU attempts to migrate a
> > nested guest from a KVM that supports TSC_SCALING to a KVM that doesn't support
> > TSC_SCALING, then TSC_SCALING is going to disappear and VM-Entry on the dest will
> > fail.  I.e. QEMU _must_ be able to detect the incompatibility and not attempt
> > the migration.  And with that code in place, QEMU doesn't need to do anything new
> > for eVMCS, it Just Works.
> 
> I'm obviously missing something. "-cpu CascadeLake-Sever" presumes
> cetain features, including VMX features (e.g. TSC_SCALING), an attempt
> to create such vCPU on a CPU which doesn't support it will lead to
> immediate failure. So two VMs created on different hosts with
> 
> -cpu CascadeLake-Sever
> 
> are guaranteed to look exactly the same from guest PoV. This is not true
> for '-cpu CascadeLake-Sever,hv-evmcs' (if we do it the way you suggest)
> as 'hv-evmcs' will be a *different* filter on each host (which is going
> to depend on KVM version, not even on the host's hardware).

We're talking about nested VMX, i.e. exposing TSC_SCALING to L1.  QEMU's CLX
definition doesn't include TSC_SCALING.  In fact, none of QEMU's predefined CPU
models supports TSC_SCALING, precisely because KVM didn't support exposing the
feature to L1 until relatively recently.

$ git grep VMX_SECONDARY_EXEC_TSC_SCALING
target/i386/cpu.h:#define VMX_SECONDARY_EXEC_TSC_SCALING              0x02000000
target/i386/kvm/kvm.c:    if (f[FEAT_VMX_SECONDARY_CTLS] & VMX_SECONDARY_EXEC_TSC_SCALING) {

> >> In any case, what we need, is an option for VMM (read: QEMU) to create
> >> the configuration with 'TscScaling' filtered out even KVM supports the
> >> bit in eVMCS. This way the guest will be able to migrate backwards to an
> >> older KVM which doesn't support it, i.e.
> >> 
> >> '-cpu CascadeLake-Sever,hv-evmcs'
> >>  creates the 'origin' eVMCS configuration, no TscScaling
> >> 
> >> '-cpu CascadeLake-Sever,hv-evmcs,hv-evmcs-2022' creates the updated one.

Ah, I see what you're worried about.  Your concern is that QEMU will add a VMX
feature to a predefined CPU model, but only later gain eVMCS support, and so
"CascadeLake-Server,hv-evmcs" will do different things depending on the KVM
version.

But again, that's already reality.  Run "-cpu CascadeLake-Server" against a KVM
from before commits:

  28c1c9fabf48 ("KVM/VMX: Emulate MSR_IA32_ARCH_CAPABILITIES")
  1eaafe91a0df ("kvm: x86: IA32_ARCH_CAPABILITIES is always supported")

and it will fail.  There are undoubtedly many other features that are similarly
affected, just go back far enough in KVM time.

Or simply run "-cpu CascadeLake-Server" on pre-CLX hardware.  Anything that KVM
doesn't fully emulate will not be present.

> > Again, this conundrum exists irrespective of eVMCS.  Properly solve the problem
> > for regular nVMX and eVMCS should naturally work.
> 
> I don't think we have this problem for VMX features as named CPU models
> in QEMU encode all of them explicitly, they *must* be present whenever
> such vCPU is created.

Yes, and if KVM doesn't support features that CascadeLake-Server requires, spawning
the VM will fail on the destination, as it should.  My point is that this behavior
is not unique to eVMCS.

QEMU/Libvirt must also be prepared for rejection, because it is flat out impossible
to ensure that KVM+hardware supports a specific feature.

> >> KVM_CAP_HYPERV_ENLIGHTENED_VMCS is bad as it only takes 'eVMCS' version
> >> as a parameter (as we assumed it will always change when new fields are
> >> added, but that turned out to be false). That's why I suggested
> >> KVM_CAP_HYPERV_ENLIGHTENED_VMCS2.
> >
> > Enumerating features via versions is such a bad API though, e.g. if there's a
> > bug with nested TSC_SCALING, userspace can't disable just nested TSC_SCALING
> > without everything else under the inscrutable "hv-evmcs-2022" being collateral
> > damage.
> 
> Why? Something like 
> 
> "-cpu CascadeLake-Sever,hv-evmcs,hv-evmcs-2022,-vmx-tsc-scaling" 
> 
> should work well, no? 'hv-evmcs*' are just filters, if the VMX feature
> is not there -- it's not there.

Because it's completely unnecessary, adds non-trivial maintenance burden to KVM,
and requires explicit documentation to explain to userspace what "hv-evmcs-2022"
means.

It's unnecessary because if the user is concerned about eVMCS features showing up
in the future, then they should do:

  -cpu CascadeLake-Server,hv-evmcs,-vmx-tsc-scaling,-<any other VMX features not eVMCS-friendly>

If QEMU wants to make that more user friendly, then define CascadeLake-Server-eVMCS
or whatever so that the features that are unlikely be supported for eVMCS are off by
default.  This is no different than QEMU not including nested TSC_SCALING in any of
the predefined models; the developers _know_ KVM doesn't widely support TSC_SCALING,
so it was omitted, even though a real CLX CPU is guaranteed to support TSC_SCALING.

It's non-trivial maintenance for KVM because it would require defining new versions
every time an eVMCS field is added, allowing userspace to specify and restrict
features based on arbitrary versions, and do all of that without conflicting with
whatever PV enumeration Microsoft adds.
