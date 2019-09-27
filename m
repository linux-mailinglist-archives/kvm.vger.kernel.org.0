Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C28C0A3C
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 19:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfI0RXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 13:23:04 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34375 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfI0RXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 13:23:04 -0400
Received: by mail-io1-f68.google.com with SMTP id q1so18363309ion.1
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 10:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ao+xap4GbP/5WztUi4GCpoZMBHOIjpE6Dylsbyorx8U=;
        b=UOVBN9KSQCKmzAnpEiAHbDq+SCNdvdkaBgUmXsSrIb+Zx3KL91Ti9JIs4OWASw19tJ
         KpD6BwZSnLUpm/2OghPSzSKh5cz11Qyfu4XGLK2K6zY9frEHjmb5lLAGkWWi1Lvrpa7Y
         YBx6JqCRuMNHCYj2WE1NtPGoULJbYqz5E2Rr6YCi8IdWh4w6IXyV74hgCBMwEWMUrvof
         n8rjJDHb8oql3usKq1sbsKXKlnLFak5ncN3GYN9HAUTFV63X2WIWs+1fZFs12FRcYaRk
         HyvTVH7h3T+l07/+agTUk+Sfs03zOOgLjspmsn+I6jtu+O4ULkWQTdaE8ziZtg6DkNvm
         +xLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ao+xap4GbP/5WztUi4GCpoZMBHOIjpE6Dylsbyorx8U=;
        b=mMwNRTTXv4WPZT4y+yMNFh8mnNUnxnG02m/OE/PcdlSDBa/aPHSopsxPQoFqp/tfO7
         ijQZxlubS8MH40HkPkTrwtnneONOFIgtziOj1oKUGHGYFya23+5V/LZFDQASa8tL0pho
         SBsCtLEQDta8RFFBpab/mHGl6Udaz0nS8dxyxgn2pevfcpEYMDpiK8rEpRT66KbDLWT2
         M71RTd1QhXjDGg2k43AWHoXu5rvip0HLMXuD7SwM0ZlJQdScmi4N0bhBiwtO+lwhgMi9
         ZCIPjmVjdTbGz+MK/1AY3i/H4sGwkUJ6djGf5wV6hv6xdb/nKj5BI8QoqgzFuT1lYGv6
         vQOg==
X-Gm-Message-State: APjAAAVhIListxpFKYDnnYxgjrxcRy3UHjhm/QwIYWJrIzmwkTGGnZf8
        6+graIRUUQ6+ODPnO4YYLnP6d93iW5qrFB8sliGZCQ==
X-Google-Smtp-Source: APXvYqwg8lfhdkvRKJFtaXdqV24CllwIvM1AlzzHyhKA7g4IMcNX+2A9nYrcHzqlfXTcXmExH2fcmeztAQRlrb+Rpis=
X-Received: by 2002:a5d:9a86:: with SMTP id c6mr9499061iom.118.1569604982814;
 Fri, 27 Sep 2019 10:23:02 -0700 (PDT)
MIME-Version: 1.0
References: <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com>
 <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com>
 <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com> <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com>
 <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com>
 <56e7fad0-d577-41db-0b81-363975dc2ca7@redhat.com> <87ftkh6e19.fsf@vitty.brq.redhat.com>
 <6e6f46fe-6e11-c5e3-d80c-327f77b91907@redhat.com> <87d0fl6bv4.fsf@vitty.brq.redhat.com>
 <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com> <20190927152608.GC25513@linux.intel.com>
 <87a7ap68st.fsf@vitty.brq.redhat.com> <59934fa75540d493dabade5a3e66b7ed159c4aae.camel@intel.com>
 <e4a17cfb-8172-9ad8-7010-ee860c4898bf@redhat.com> <CALMp9eQcHbm6nLAQ_o8dS4B+2k6B0eHxuGvv6Ls_-HL9PC4mhQ@mail.gmail.com>
 <11f63bd6-50cc-a6ce-7a36-a6e1a4d8c5e9@redhat.com>
In-Reply-To: <11f63bd6-50cc-a6ce-7a36-a6e1a4d8c5e9@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 27 Sep 2019 10:22:51 -0700
Message-ID: <CALMp9eSO+X2hL5VEnE2YfiwWkQvcOGone=ECwe_1LzuuPocL0Q@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 9:32 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 27/09/19 18:10, Jim Mattson wrote:
> > On Fri, Sep 27, 2019 at 9:06 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 27/09/19 17:58, Xiaoyao Li wrote:
> >>> Indeed, "KVM_GET_MSR_INDEX_LIST" returns the guest msrs that KVM supports and
> >>> they are free from different guest configuration since they're initialized when
> >>> kvm module is loaded.
> >>>
> >>> Even though some MSRs are not exposed to guest by clear their related cpuid
> >>> bits, they are still saved/restored by QEMU in the same fashion.
> >>>
> >>> I wonder should we change "KVM_GET_MSR_INDEX_LIST" per VM?
> >>
> >> We can add a per-VM version too, yes.
>
> There is one problem with that: KVM_SET_CPUID2 is a vCPU ioctl, not a VM
> ioctl.
>
> > Should the system-wide version continue to list *some* supported MSRs
> > and *some* unsupported MSRs, with no rhyme or reason? Or should we
> > codify what that list contains?
>
> The optimal thing would be for it to list only MSRs that are
> unconditionally supported by all VMs and are part of the runtime state.
>  MSRs that are not part of the runtime state, such as the VMX
> capabilities, should be returned by KVM_GET_MSR_FEATURE_INDEX_LIST.
>
> This also means that my own commit 95c5c7c77c06 ("KVM: nVMX: list VMX
> MSRs in KVM_GET_MSR_INDEX_LIST", 2019-07-02) was incorrect.
> Unfortunately, that commit was done because userspace (QEMU) has a
> genuine need to detect whether KVM is new enough to support the
> IA32_VMX_VMFUNC MSR.
>
> Perhaps we can make all MSRs supported unconditionally if
> host_initiated.  For unsupported performance counters it's easy to make
> them return 0, and allow setting them to 0, if host_initiated (BTW, how
> did you pick 32?  is there any risk of conflicts with other MSRs?).

32 comes from INTEL_PMC_MAX_GENERIC. There are definitely conflicts.
(Sorry; this should have occurred to me earlier.) 32 event selectors
would occupy indices [0x186, 0x1a6). But on the architectural MSR
list, only indices up through 0x197 are "reserved" (presumably for
future event selectors). 32 GP counters would occupy indices [0xc1,
0xe1). But on the architectural MSR list, only indices up through 0xc8
are defined for GP counters. None are marked "reserved" for future
expansion, but none in the range (0xc8, 0xe1) are defined either.

Perhaps INTEL_MAX_PMC_GENERIC should be reduced to 18. If we removed
event selectors and counters above 18, would my original approach
work?



> I'm not sure of the best set of values to allow for VMX caps, especially
> with the default0/default1 stuff going on for execution controls.  But
> perhaps that would be the simplest thing to do.
>
> One possibility would be to make a KVM_GET_MSR_INDEX_LIST variant that
> is a system ioctl and takes a CPUID vector.  I'm worried that it would
> be tedious to get right and hardish to keep correct---so I'm not sure
> it's a good idea.
>
> Paolo
