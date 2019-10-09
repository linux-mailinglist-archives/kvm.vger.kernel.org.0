Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61971D1CFB
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 01:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732450AbfJIXoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 19:44:25 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43656 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732438AbfJIXoY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 19:44:24 -0400
Received: by mail-io1-f66.google.com with SMTP id v2so9466109iob.10
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 16:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1rIDTbz4/jxXG5RR4Vf/DrkF9W2wHj/3R7V9+nN/Cgk=;
        b=SkdgJBy3nNZy/b9Zk4J02rek8Ec/NlC8IyIbm0wxODNk21+BPAIrJfZLF1hTOBwivy
         fe9H1XsSyAG4uSgVf4tkh42w7SRnMbKOxiT8GgwZwPcxLeCVwWnJta3XekeXHWDc+cOY
         90hKg6xvnlxuaD78Swvp7GyzyB7ZB4iVgrYvnG8YrsTw6j4fI/jbx//9E669v6G3Zgrf
         ldG2tWQIPAjS8fBPzAPzh/RbGOf/JiyiSYII8cXmmcihKd7NGWgJPlOwiEc2RR9ylCal
         oydPOt/LNGyhRTskiPOAkmW+blBp93TgnEbHJX9XgZkXfuijccI7a3twItSMkhXnP9Xf
         sKkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1rIDTbz4/jxXG5RR4Vf/DrkF9W2wHj/3R7V9+nN/Cgk=;
        b=MC2R0VdCfN5bAGOten78DL4XOUWO0La4pixMZ8i+YQF4ZB55E7FOrxtRORfN9a9UQ5
         WTtzu/lYcxwyyWmh4hYAC8J6qqVUz7WD54RRGKxeXruq3OJuvtnFApb/R8EcYO6c9bTc
         JciqaA7TPDYzfLA/qNfgj6hZJws1MmVL9qCfIXd2hqf0BicvvRgYtJVg6Nfq9oZd2M2q
         rMZ5PE8COa4JisS3Rouxfd5lmlZEWyYcDl57iNvqN0n+qAblIM1TmZwQtqTOISSGdN/Y
         xgxZkbyBJWRxsoyyK0heY01sF4OYLmlwreqMsqt2oF5jvrl6lmdJu3QFdIpVOhWWElb6
         3Juw==
X-Gm-Message-State: APjAAAUS89oZhmWf28d0QW2WYhQPPnZK5gXwQMccMMUMOx781DRNMI+H
        o3fGrdjUhvs+ctBKO1xfQE9Cco+DlpzasDydJhACoA==
X-Google-Smtp-Source: APXvYqzigVj1v/bsFRp0OAAJ+PMPjptR7xVT6vHd9hK/qs0mnSkflu92HUavKfsT6uOtB8V50rBK/BqaPx9TpiJCuIM=
X-Received: by 2002:a02:a99d:: with SMTP id q29mr6398547jam.18.1570664662189;
 Wed, 09 Oct 2019 16:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <20191009004142.225377-1-aaronlewis@google.com>
 <20191009004142.225377-6-aaronlewis@google.com> <f3bcebe3-d82d-7578-0dd9-95391fe522e0@redhat.com>
In-Reply-To: <f3bcebe3-d82d-7578-0dd9-95391fe522e0@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 9 Oct 2019 16:44:11 -0700
Message-ID: <CALMp9eSqy2k2xJo+j2eFf5LNTGctywSt9bFq33iX4nR1gErFcQ@mail.gmail.com>
Subject: Re: [Patch 6/6] kvm: tests: Add test to verify MSR_IA32_XSS
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 8, 2019 at 11:32 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/10/19 02:41, Aaron Lewis wrote:
> >   * Set value of MSR for VCPU.
> >   */
> > -void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
> > -     uint64_t msr_value)
> > +void vcpu_set_msr_expect_result(struct kvm_vm *vm, uint32_t vcpuid,
> > +                             uint64_t msr_index, uint64_t msr_value,
> > +                             int result)
> >  {
> >       struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> >       struct {
> > @@ -899,10 +901,30 @@ void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
> >       buffer.entry.index = msr_index;
> >       buffer.entry.data = msr_value;
> >       r = ioctl(vcpu->fd, KVM_SET_MSRS, &buffer.header);
> > -     TEST_ASSERT(r == 1, "KVM_SET_MSRS IOCTL failed,\n"
> > +     TEST_ASSERT(r == result, "KVM_SET_MSRS IOCTL failed,\n"
> >               "  rc: %i errno: %i", r, errno);
> >  }
>
> This is a library, so the functions to some extent should make sense
> even outside tests.  Please make a function _vcpu_set_msr that returns
> the result of the ioctl; it can still be used in vcpu_set_msr, and the
> tests can TEST_ASSERT what they want.
>
> > +uint32_t kvm_get_cpuid_max_basic(void)
> > +{
> > +     return kvm_get_supported_cpuid_entry(0)->eax;
> > +}
> > +
> > +uint32_t kvm_get_cpuid_max_extended(void)
>
> I would leave the existing function aside, and call this one
> kvm_get_cpuid_max_amd() since CPUID leaves at 0x80000000 are allocated
> by AMD.

The existing function *is* the one that gives the largest
AMD-allocated leaf. Note that Intel documents CPUID.80000000:EAX as
"Maximum Input Value for Extended Function CPUID Information," and AMD
documents this as "Largest extended function."

> Otherwise looks good.
>
> Paolo
>
