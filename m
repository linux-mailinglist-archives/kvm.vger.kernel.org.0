Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00953798B3
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 23:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbhEJVD3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 17:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbhEJVD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 17:03:28 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1375CC061574
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 14:02:21 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id v191so14474306pfc.8
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 14:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=45NUfNFNptvMg6JTtEiEAtq0rD4KjNhuaSZ4UKjowxM=;
        b=XkvV82WvRXO64kiRraW9QAeJzi177K0R8eeVI7F2FbVP6xOjEftm6FuZihuX5YG95Z
         ZgMEyUzwxTRZwOQvSjyOlcCf1UlE5D7xozB2ARQkJI9+jntLzGwOJX7K4miq9RoKn1Y7
         BTyoT5falJYMo6Ysa9Wd6iXJ3owIbxE+TA1uK3OezcB/k44c0WsWRTkhB6bXoDzUj8eG
         rOZ4COMsI/uwXrbu9Iij3n/mTN7/0UbKUExiNOk142Gw1vZwVb4FNfxJJNS+LI+nKHZU
         HFMQ7sZvrI39V2Dc09jmdiQjI2LQSyioa3ouKt+zk13il41cQvPmtzzONhhvDo9uKyPv
         SIGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=45NUfNFNptvMg6JTtEiEAtq0rD4KjNhuaSZ4UKjowxM=;
        b=Z72Z0/mt9FPi+Oak7YNStF3jpxW/95gXl8OBWW+wC+KJAvVDKEPB9yz4Lnu4KxcL7G
         T6440lkw5fFWJydN3RYpb5+6a9e6wQAw6iQPTjebvf9Rtd42aUnfIe6HHyMbR+I+Uboq
         IE9ii5hkaYD92kXrAOjmUQQbIt4ixBODpfl/vmIc7mfPGmgU9u1ozHMgAQ58sFTX70iL
         9iGOnr4v2TbxdExU/XRBXjYzK4ShYT0ib3LEkYtyUJcDnUGLpHHEOTegPTAPwqi7Uk4P
         X1gaopj1xzHSUwXApsy8eDYhAhFDYWY+vgEjb+YgagIQ6SsJ7om8rZWvQdQe1T5lnH76
         lzYQ==
X-Gm-Message-State: AOAM53321nYjaQwTU9NSX3aftDUy0E2ZAaMq+u6ZAGlxHUFA8Gmj3wQD
        ooVWkhmkMtX6gzx21Q5FJaa/5A==
X-Google-Smtp-Source: ABdhPJzZTuM44zAfoBZUi9Bj2lDne3SvasMsj8yS5dnz/amFPTp89Usk8uPjTYlehmVU6DVhcqDOHg==
X-Received: by 2002:aa7:90d5:0:b029:28e:df57:47ff with SMTP id k21-20020aa790d50000b029028edf5747ffmr27631557pfk.74.1620680540337;
        Mon, 10 May 2021 14:02:20 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id e20sm324207pjt.8.2021.05.10.14.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 14:02:19 -0700 (PDT)
Date:   Mon, 10 May 2021 21:02:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 2/2] KVM: x86: Allow userspace to update tracked sregs
 for protected guests
Message-ID: <YJmfV1sO8miqvQLM@google.com>
References: <20210507165947.2502412-1-seanjc@google.com>
 <20210507165947.2502412-3-seanjc@google.com>
 <5f084672-5c0d-a6f3-6dcf-38dd76e0bde0@amd.com>
 <YJla8vpwqCxqgS8C@google.com>
 <12fe8f83-49b4-1a22-7903-84e45f16c372@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12fe8f83-49b4-1a22-7903-84e45f16c372@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021, Tom Lendacky wrote:
> On 5/10/21 11:10 AM, Sean Christopherson wrote:
> > On Fri, May 07, 2021, Tom Lendacky wrote:
> >> On 5/7/21 11:59 AM, Sean Christopherson wrote:
> >>> Allow userspace to set CR0, CR4, CR8, and EFER via KVM_SET_SREGS for
> >>> protected guests, e.g. for SEV-ES guests with an encrypted VMSA.  KVM
> >>> tracks the aforementioned registers by trapping guest writes, and also
> >>> exposes the values to userspace via KVM_GET_SREGS.  Skipping the regs
> >>> in KVM_SET_SREGS prevents userspace from updating KVM's CPU model to
> >>> match the known hardware state.
> >>
> >> This is very similar to the original patch I had proposed that you were
> >> against :)
> > 
> > I hope/think my position was that it should be unnecessary for KVM to need to
> > know the guest's CR0/4/0 and EFER values, i.e. even the trapping is unnecessary.
> > I was going to say I had a change of heart, as EFER.LMA in particular could
> > still be required to identify 64-bit mode, but that's wrong; EFER.LMA only gets
> > us long mode, the full is_64_bit_mode() needs access to cs.L, which AFAICT isn't
> > provided by #VMGEXIT or trapping.
> 
> Right, that one is missing. If you take a VMGEXIT that uses the GHCB, then
> I think you can assume we're in 64-bit mode.

But that's not technically guaranteed.  The GHCB even seems to imply that there
are scenarios where it's legal/expected to do VMGEXIT with a valid GHCB outside
of 64-bit mode:

  However, instead of issuing a HLT instruction, the AP will issue a VMGEXIT
  with SW_EXITCODE of 0x8000_0004 ((this implies that the GHCB was updated prior
  to leaving 64-bit long mode).

In practice, assuming the guest is in 64-bit mode will likely work, especially
since the MSR-based protocol is extremely limited, but ideally there should be
stronger language in the GHCB to define the exact VMM assumptions/behaviors.

On the flip side, that assumption and the limited exposure through the MSR
protocol means trapping CR0, CR4, and EFER is pointless.  I don't see how KVM
can do anything useful with that information outside of VMGEXITs.  Page tables
are encrypted and GPRs are stale; what else could KVM possibly do with
identifying protected mode, paging, and/or 64-bit?

> > Unless I'm missing something, that means that VMGEXIT(VMMCALL) is broken since
> > KVM will incorrectly crush (or preserve) bits 63:32 of GPRs.  I'm guessing no
> > one has reported a bug because either (a) no one has tested a hypercall that
> > requires bits 63:32 in a GPR or (b) the guest just happens to be in 64-bit mode
> > when KVM_SEV_LAUNCH_UPDATE_VMSA is invoked and so the segment registers are
> > frozen to make it appear as if the guest is perpetually in 64-bit mode.
> 
> I don't think it's (b) since the LAUNCH_UPDATE_VMSA is done against reset-
> state vCPUs.
> 
> > 
> > I see that sev_es_validate_vmgexit() checks ghcb_cpl_is_valid(), but isn't that
> > either pointless or indicative of a much, much bigger problem?  If VMGEXIT is
> 
> It is needed for the VMMCALL exit.
> 
> > restricted to CPL0, then the check is pointless.  If VMGEXIT isn't restricted to
> > CPL0, then KVM has a big gaping hole that allows a malicious/broken guest
> > userspace to crash the VM simply by executing VMGEXIT.  Since valid_bitmap is
> > cleared during VMGEXIT handling, I don't think guest userspace can attack/corrupt
> > the guest kernel by doing a replay attack, but it does all but guarantee a
> > VMGEXIT at CPL>0 will be fatal since the required valid bits won't be set.
> 
> Right, so I think some cleanup is needed there, both for the guest and the
> hypervisor:
> 
> - For the guest, we could just clear the valid bitmask before leaving the
>   #VC handler/releasing the GHCB. Userspace can't update the GHCB, so any
>   VMGEXIT from userspace would just look like a no-op with the below
>   change to KVM.

Ah, right, the exit_code and exit infos need to be valid.

> - For KVM, instead of returning -EINVAL from sev_es_validate_vmgexit(), we
>   return the #GP action through the GHCB and continue running the guest.

Agreed, KVM should never kill the guest in response to a bad VMGEXIT.  That
should always be a guest decision.

> > Sadly, the APM doesn't describe the VMGEXIT behavior, nor does any of the SEV-ES
> > documentation I have.  I assume VMGEXIT is recognized at CPL>0 since it morphs
> > to VMMCALL when SEV-ES isn't active.
> 
> Correct.
> 
> > 
> > I.e. either the ghcb_cpl_is_valid() check should be nuked, or more likely KVM
> 
> The ghcb_cpl_is_valid() is still needed to see whether the VMMCALL was
> from userspace or not (a VMMCALL will generate a #VC).

Blech.  I get that the GHCB spec says CPL must be provided/checked for VMMCALL,
but IMO that makes no sense whatsover.

If the guest restricts the GHCB to CPL0, then the CPL field is pointless because
the VMGEXIT will only ever come from CPL0.  Yes, technically the guest kernel
can proxy a VMMCALL from userspace to the host, but the guest kernel _must_ be
the one to enforce any desired CPL checks because the VMM is untrusted, at least
once you get to SNP.

If the guest exposes the GHCB to any CPL, then the CPL check is worthless because
guest userspace can simply lie about the CPL.  And exposing the GCHB to userspace
completely undermines guest privilege separation since hardware doesn't provide
the real CPL, i.e. the VMM, even it were trusted, can't determine the origin of
the VMGEXIT.
