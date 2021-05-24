Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C7B38EEC4
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 17:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbhEXPzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 11:55:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32674 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234180AbhEXPwM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 11:52:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621871443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g160OH7EsS9HKxq02reBhGGs/7a9LKDKn/dWea9bc8Q=;
        b=K8R3BWTOJkDNa5p6HZzdAcuDKXNv5GX0SOAwiPi4wSIkd8UnbsdRBNXM5ax9+5KJqrfsNZ
        4XxQXwZcFSQunfcSlaOXTZCbH9mlsE8sFwJVUuh8aHwJoqIEqg/bo3rxguCyjI/owVerux
        jGF/4r8f5sDVJhY5pka9iIlGQ/J1jI4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-oNZkfkyINSiVdK4JHEjDlg-1; Mon, 24 May 2021 11:50:42 -0400
X-MC-Unique: oNZkfkyINSiVdK4JHEjDlg-1
Received: by mail-ed1-f71.google.com with SMTP id m6-20020aa7c4860000b029038d4e973878so11593004edq.10
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 08:50:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g160OH7EsS9HKxq02reBhGGs/7a9LKDKn/dWea9bc8Q=;
        b=Mo6jWNSe9slttyf+84y0Q2S6oPJnvNNbY56PqyUkn5r8vAkCbeJx8XlJof2S+xvg6L
         6cvlvdPWJcm8XE427OT89Q2nOv32wYGAobDx26UUfbIzt/kvDzNufjSOrv/k5kRsdluN
         qLKgQFzFYDtOMxzVHPQV4A+I5kmzUpy/w8/N6Bn+lPbD0Q2rpj6EZwH/C981h6aYSzKH
         xa7J36y7or2ox6Gal/b4wcMll1eb3ZTPsHGZNZLNzebHlJB8p/d6Mnqrwl9AYJpyNpHy
         Todxp0JTZmwZUwkXKY5J71psiA/IaSfIAADP13dimKQrOgegPIhkeodliYizFtOXqzV9
         gvKQ==
X-Gm-Message-State: AOAM531nkCXGC7LWiKSRJhJywNtlSi2xjiNPGxg/g3nXh7KLqtzVaUNA
        7WLiBCBVeLqTYW/pPMkPDJyW7fIqAnBbEkpvjfQvV+2pAddS0ZNVzhrJfSd21Yfjc/mXeMkBPg+
        xS8wDUJ8j9O+KrNLdK5USwdfdNF1T+E4mV8Km93Z0NmMEGTq1p867ajNta/b+XhBL
X-Received: by 2002:a17:906:914d:: with SMTP id y13mr23903820ejw.489.1621871440440;
        Mon, 24 May 2021 08:50:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrAASdfwL52MWFTvZQ7NcWTdkjjNykUEUc3YZ7GL2w+++GPncWsJDsMz4+aiW70oQHBEDDWQ==
X-Received: by 2002:a17:906:914d:: with SMTP id y13mr23903803ejw.489.1621871440175;
        Mon, 24 May 2021 08:50:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g22sm8039348ejz.46.2021.05.24.08.50.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 08:50:39 -0700 (PDT)
Subject: Re: [PATCH 00/12] KVM: nVMX: Fix vmcs02 PID use-after-free issue
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20210520230339.267445-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8e7c51b7-b0ef-079c-659c-e8a4526da022@redhat.com>
Date:   Mon, 24 May 2021 17:50:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210520230339.267445-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/21 01:03, Jim Mattson wrote:
> When the VMCS12 posted interrupt descriptor isn't backed by an L1
> memslot, kvm will launch vmcs02 with a stale posted interrupt
> descriptor. Before commit 6beb7bd52e48 ("kvm: nVMX: Refactor
> nested_get_vmcs12_pages()"), kvm would have silently disabled the
> VMCS02 "process posted interrupts" VM-execution control. Both
> behaviors are wrong, though the use-after-free is more egregious.
> 
> Empirical tests on actual hardware reveal that a posted interrupt
> descriptor without any backing memory/device has PCI bus error
> semantics (reads return all 1's and writes are discarded). However,
> kvm can't tell an unbacked address from an MMIO address. Normally, kvm
> would ask userspace for an MMIO completion, but that's complicated for
> a posted interrupt descriptor access. There are already a number of
> cases where kvm bails out to userspace with KVM_INTERNAL_ERROR via
> kvm_handle_memory_failure, so that seems like the best route to take.
> 
> It would be relatively easy to invoke kvm_handle_memory_failure at
> emulated VM-entry, but that approach would break existing
> kvm-unit-tests. Moreover, the issue doesn't really come up until the
> vCPU--in virtualized VMX non-root operation--received the posted
> interrupt notification vector indicated in its VMCS12.
> 
> Sadly, it's really hard to arrange for an exit to userspace from
> vmx_complete_nested_posted_interrupt, which is where kvm actually
> needs to access the unbacked PID. Initially, I added a new kvm request
> for a userspace exit on the next guest entry, but Sean hated that
> approach. Based on his suggestion, I added the plumbing to get back
> out to userspace in the event of an error in
> vmx_complete_nested_posted_interrupt. This works in the case of an
> unbacked PID, but it doesn't work quite as well in the case of an
> unbacked virtual APIC page (another case where kvm was happy to just
> silently ignore the problem and attempt to muddle its way through.) In
> that case, this series is an incremental improvement, but it's not a
> complete fix.
> 
> Jim Mattson (12):
>    KVM: x86: Remove guest mode check from kvm_check_nested_events
>    KVM: x86: Wake up a vCPU when kvm_check_nested_events fails
>    KVM: nVMX: Add a return code to vmx_complete_nested_posted_interrupt
>    KVM: x86: Add a return code to inject_pending_event
>    KVM: x86: Add a return code to kvm_apic_accept_events
>    KVM: nVMX: Fail on MMIO completion for nested posted interrupts
>    KVM: nVMX: Disable vmcs02 posted interrupts if vmcs12 PID isn't
>      mappable
>    KVM: selftests: Move APIC definitions into a separate file
>    KVM: selftests: Hoist APIC functions out of individual tests
>    KVM: selftests: Introduce x2APIC register manipulation functions
>    KVM: selftests: Introduce prepare_tpr_shadow
>    KVM: selftests: Add a test of an unbacked nested PI descriptor

Patch 2 is the only one that seems wrong to me, and I am actually not 
sure why it is part of this series.  It seems to me that it overlaps 
"kvm: x86: move srcu lock out of kvm_vcpu_check_block​", for which both 
Sean and I had some discussions on how to remove the side effects that 
kvm_check_nested_events has on kvm_vcpu_is_runn{able,ing}.

Otherwise looks good, and I've already queued patches 8-10.  Holler if I 
should just apply patches 1 and 3-12.

Paolo

