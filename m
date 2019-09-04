Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 305D7A91A0
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389086AbfIDSUm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 14:20:42 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41836 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732951AbfIDSUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 14:20:41 -0400
Received: by mail-io1-f66.google.com with SMTP id r26so4935419ioh.8
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 11:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hkO/cT8OhPb0cUChS921L7qchHYLxkhPmyWw2Bm54kQ=;
        b=gWGoe/wITdXy1DoZUsQmmFZvnXybvPj9ICfCe7eStcH8oTsA8+ifaCkS4oxyhodeka
         OFZvYN7VWFQDPb6svxhEzraPs0vLyYOpDhbsu4gLyXpmF5cmhBEKIpNAhlc9dlD+pEiV
         hYr41mV5tjuIw3zlcidfynm+3+CUj3QoIgzmwzdxaz66tAp4lHcbt1KiQjoU6lvhW7h3
         yiNkAqHYfvWQH57qjQljfGVui73xKuyVW1V1A+sfTWhwRZEcgqa/qGdKgc3uccnJo8Yp
         XKSx73SDCmTh4WG8Fuan4WRyvEYfJ0TSsYXB4xnayFnTmlh+v0PM7vELqMXExig6dbGr
         HH1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hkO/cT8OhPb0cUChS921L7qchHYLxkhPmyWw2Bm54kQ=;
        b=noJPP/RPdbG0ZxF1ainOo+lNhshqZozQP5UBWsU+EfF+Ll1EnJhUG3xASX8LNK9PJQ
         nupB2T+DykHkxWWOhdl2VgmGywryS3bs6gg9dnjzj8bsu5Rq38NpaSipiq0lN0JosvfG
         o1bc3o+gqHjlqSyh5qOcNX0Iv/RZO/zPlzjTjus02Hr3R4sSV5ZuCR7z5wTcCrog6ben
         i17xTvvBQd6bzCdwWRTpBWGGQ18whDD4sDoK5HagSZ58DKmoUHQoaRpxLNJmU1PHxArF
         HylEiKaXpAYi8nF2Hh0S1jTFObO8u6wj3sAXjRip6tEoGtz/NySai6mH2oA0PvYcUg2p
         niWw==
X-Gm-Message-State: APjAAAVk8gHUdRoKhHYR7AWSHJvk5ffx9fNPjjpm7ck8h2fYcoGCjsyQ
        pqc3kAdv6RtOqR+P7qy+NvoYw7UYQRhTutPtpS8dcg==
X-Google-Smtp-Source: APXvYqxJt/Il0shfMVa0WEHc/FC4UDsyNAn6DgClzWo4WKeUQZ6lapzeMl20JN5ZTCjVHVSBOqco4qIDnJSpmyi9PpE=
X-Received: by 2002:a5d:8e15:: with SMTP id e21mr441096iod.296.1567621240232;
 Wed, 04 Sep 2019 11:20:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
 <20190829205635.20189-3-krish.sadhukhan@oracle.com> <CALMp9eSekWEvvgwhMXWOtRZG1saQDOaKr+_4AacuM9JtH5guww@mail.gmail.com>
 <a4882749-a5cc-f8cd-4641-dd61314e6312@oracle.com> <CALMp9eTBPRT+Re9rZzmutAiy62qSMQRfMrnyiYkNHkCKDy-KPQ@mail.gmail.com>
 <CALMp9eRWSvg22JPUKOssOHwOq=uXn6GumXP1-LB2ZiYbd0N6bQ@mail.gmail.com>
 <e229bea2-acb2-e268-6281-d8e467c3282e@oracle.com> <CALMp9eTObQkBrKpN-e=ejD8E5w3WpbcNkXt2gJ46xboYwR+b7Q@mail.gmail.com>
 <e8a4477c-b3a9-b4e4-1283-99bdaf7aa29b@oracle.com>
In-Reply-To: <e8a4477c-b3a9-b4e4-1283-99bdaf7aa29b@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 4 Sep 2019 11:20:28 -0700
Message-ID: <CALMp9eTO_ChOHQ4paR1SgmxnpSGZrMjHTa2aUWHSCn0+tCGvAA@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 4, 2019 at 11:07 AM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 9/4/19 9:44 AM, Jim Mattson wrote:
> > On Tue, Sep 3, 2019 at 5:59 PM Krish Sadhukhan
> > <krish.sadhukhan@oracle.com> wrote:
> >>
> >>
> >> On 09/01/2019 05:33 PM, Jim Mattson wrote:
> >>
> >> On Fri, Aug 30, 2019 at 4:15 PM Jim Mattson <jmattson@google.com> wrot=
e:
> >>
> >> On Fri, Aug 30, 2019 at 4:07 PM Krish Sadhukhan
> >> <krish.sadhukhan@oracle.com> wrote:
> >>
> >> On 08/29/2019 03:26 PM, Jim Mattson wrote:
> >>
> >> On Thu, Aug 29, 2019 at 2:25 PM Krish Sadhukhan
> >> <krish.sadhukhan@oracle.com> wrote:
> >>
> >> According to section "Checks on Guest Control Registers, Debug Registe=
rs, and
> >> and MSRs" in Intel SDM vol 3C, the following checks are performed on v=
mentry
> >> of nested guests:
> >>
> >>       If the "load debug controls" VM-entry control is 1, bits 63:32 i=
n the DR7
> >>       field must be 0.
> >>
> >> Can't we just let the hardware check guest DR7? This results in
> >> "VM-entry failure due to invalid guest state," right? And we just
> >> reflect that to L1?
> >>
> >> Just trying to understand the reason why this particular check can be
> >> deferred to the hardware.
> >>
> >> The vmcs02 field has the same value as the vmcs12 field, and the
> >> physical CPU has the same requirements as the virtual CPU.
> >>
> >> Actually, you're right. There is a problem. With the current
> >> implementation, there's a priority inversion if the vmcs12 contains
> >> both illegal guest state for which the checks are deferred to
> >> hardware, and illegal entries in the VM-entry MSR-load area. In this
> >> case, we will synthesize a "VM-entry failure due to MSR loading"
> >> rather than a "VM-entry failure due to invalid guest state."
> >>
> >> There are so many checks on guest state that it's really compelling to
> >> defer as many as possible to hardware. However, we need to fix the
> >> aforesaid priority inversion. Instead of returning early from
> >> nested_vmx_enter_non_root_mode() with EXIT_REASON_MSR_LOAD_FAIL, we
> >> could induce a "VM-entry failure due to MSR loading" for the next
> >> VM-entry of vmcs02 and continue with the attempted vmcs02 VM-entry. If
> >> hardware exits with EXIT_REASON_INVALID_STATE, we reflect that to L1,
> >> and if hardware exits with EXIT_REASON_INVALID_STATE, we reflect that
> >> to L1 (along with the appropriate exit qualification).
> >>
> >>
> >> Looking at nested_vmx_exit_reflected(), it seems we do return to L1 if=
 the error is EXIT_REASON_INVALID_STATE. So if we fix the priority inversio=
n, this should work then ?
> > Yes.
> >
> >> The tricky part is in undoing the successful MSR writes if we reflect
> >> EXIT_REASON_INVALID_STATE to L1. Some MSR writes can't actually be
> >> undone (e.g. writes to IA32_PRED_CMD), but maybe we can get away with
> >> those. (Fortunately, it's illegal to put x2APIC MSRs in the VM-entry
> >> MSR-load area!) Other MSR writes are just a bit tricky to undo (e.g.
> >> writes to IA32_TIME_STAMP_COUNTER).
> >>
> >>
> >> Let's say that the priority inversion issue is fixed. In the scenario =
in which the Guest state is fine but the VM-entry MSR-Load area contains an=
 illegal entry,  you are saying that the induced "VM-entry failure due to M=
SR loading"  will be caught during the next VM-entry of vmcs02. So how far =
does the attempted VM-entry of vmcs02  continue with an illegal MSR-Load en=
try and how do get to the next VM-entry of vmcs02 ?
> > Sorry; I don't understand the questions.
>
>
> Let's say that all guest state checks are deferred to hardware and that
> they all will pass. Now, the VM-entry MSR-load area contains an illegal
> entry and we modify nested_vmx_enter_non_root_mode() to induce a
> "VM-entry failure due to MSR loading" for the next VM-entry of vmcs02. I
> wanted to understand how that induced error ultimately leads to a
> VM-entry failure ?

One possible implementation is as follows:

While nested_vmx_load_msr() is processing the vmcs12 VM-entry MSR-load
area, it finds an error in entry <i>. We could set up the vmcs02
VM-entry MSR-load area so that the first entry has <i+1> in the
reserved bits, and the VM-entry MSR-load count is greater than 0.
Since the reserved bits must be one, when we try to launch/resume the
vmcs02 in vmx_vcpu_run(), it will result in "VM-entry failure due to
MSR loading." We can then reflect that to the guest, setting the
vmcs12 exit qualification field from the reserved bits in the first
entry of the vmcs02 VM-entry MSR-load area, rather than passing on the
exit qualification field from the vmcs02. Of course, this doesn't work
if <i> is MAX_UINT32, but I suspect you've already got bigger problems
in that case.

>
> >> There are two other scenarios there:
> >>
> >>      1. Guest state is illegal and VM-entry MSR-Load area contains an =
illegal entry
> >>      2. Guest state is illegal but VM-entry MSR-Load area is fine
> >>
> >> In these scenarios, L2 will exit to L1 with EXIT_REASON_INVALID_STATE =
and finally this will be returned to L1 userspace. Right ?  If so, we do we=
 care about reverting MSR-writes  because the SDM section 26.8 say,
> >>
> >>          "Processor state is loaded as would be done on a VM exit (see=
 Section 27.5)"
> > I'm not sure how the referenced section of the SDM is relevant. Are
> > you assuming that every MSR in the VM-entry MSR load area also appears
> > in the VM-exit MSR load area? That certainly isn't the case.
> >
> >> Alternatively, we could perform validity checks on the entire vmcs12
> >> VM-entry MSR-load area before writing any of the MSRs. This may be
> >> easier, but it would certainly be slower. We would have to be wary of
> >> situations where processing an earlier entry affects the validity of a
> >> later entry. (If we take this route, then we would also have to
> >> process the valid prefix of the VM-entry MSR-load area when we reflect
> >> EXIT_REASON_MSR_LOAD_FAIL to L1.)
> > Forget this paragraph. Even if all of the checks pass, we still have
> > to undo all of the MSR-writes in the event of a deferred "VM-entry
> > failure due to invalid guest state."
> >
> >> Note that this approach could be extended to permit the deferral of
> >> some control field checks to hardware as well.
> >>
> >>
> >> Why can't the first approach be used for VM-entry controls as well ?
> > Sorry; I don't understand this question either.
>
>
> Since you mentioned,
>
>      "Note that this approach could be extended to permit the deferral
> of some control field checks..."
>
> So it seemed that only the second approach was applicable to deferring
> VM-entry control checks to hardware. Hence I asked why the first
> approach can't be used.

By "this approach," I meant the deferred delivery of an error
discovered in software.

> >
> >>   As long as the control
> >> field is copied verbatim from vmcs12 to vmcs02 and the virtual CPU
> >> enforces the same constraints as the physical CPU, deferral should be
> >> fine. We just have to make sure that we induce a "VM-entry failure due
> >> to invalid guest state" for the next VM-entry of vmcs02 if any
> >> software checks on guest state fail, rather than immediately
> >> synthesizing an "VM-entry failure due to invalid guest state" during
> >> the construction of vmcs02.
> >>
> >>
> >> Is it OK to keep this Guest check in software for now and then remove =
it once we have a solution in place ?
> > Why do you feel that getting the priority correct is so important for
> > this one check in particular? I'd be surprised if any hypervisor ever
> > assembled a VMCS that failed this check.
