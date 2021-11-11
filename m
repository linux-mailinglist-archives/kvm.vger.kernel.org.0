Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F1B44D232
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 08:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhKKHJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 02:09:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26992 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229861AbhKKHJ2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 02:09:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636614397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6FPPIWSEmE31KLIl9Vrcf0Gv1iU2go7pRZ4yE5vVRuE=;
        b=f+hZCRFYQze2OnDQqwb5+vlL+XjjoRJMB1XFliuscGYuV7wgMC+69fmHXrvg+/h8qDvOCW
        lZy3mB3RBbUbEGYxwe14iDjhdQOLGlW4iRxuDRE7MZSp4T1kGvPooJJyK/YOVZn9xpDe2n
        7C5jwFtLJ8iak3xsYSRbNvJ7B2qXL34=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-c7iy5uoFNrWmXX9KIwpwdg-1; Thu, 11 Nov 2021 02:06:35 -0500
X-MC-Unique: c7iy5uoFNrWmXX9KIwpwdg-1
Received: by mail-ed1-f69.google.com with SMTP id z1-20020a05640235c100b003e28c89743bso4540354edc.22
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 23:06:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6FPPIWSEmE31KLIl9Vrcf0Gv1iU2go7pRZ4yE5vVRuE=;
        b=Y/tqwhZcrLmZgzpNqUH/lFD7o0NZ9i6patciXd2HyGbZZGH1Kzn7nAHI8wrEMQ2jv7
         yVOcZHFoo1nzX8ODa/a60bpngtp2RoVSobLqcT2Z1VJhEmcr1JC31T2voOQWp8U2FS7/
         CaEGNM7B7fl+inwj9H92eZ5KhuC/nRfPSyBQzFN77IPF91M3qv5UgGY50P0sA9kgDLMP
         osWRRM9VqttKrFADJyDjyadeu9QnurrtnMC7zx900rXBHRgO4E0lDLqk2JefFdft0Ppx
         dI8OCmEYT3YlO87VL8vI8JouikPyTrBsbqX9ahV1fU+m4dO91ktpKRNwhWNPDqcpZePd
         7O9g==
X-Gm-Message-State: AOAM531dR7QWxeO288bNFowBaMQ3jgwRA3G52f+EYyGbCmfgG8aU6rD4
        WiNtTrJzU4ng4v7WwS9gCg3repVes9VJYKvxoRDQpvwX0Fo1eI4r6j80cq235ZvszOLhOI9w+n3
        6KdEnToU74M2I
X-Received: by 2002:a17:907:d14:: with SMTP id gn20mr6439670ejc.73.1636614394520;
        Wed, 10 Nov 2021 23:06:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwSO380yB499Wry7ErnQwuOiC7wRh8mA4LjnJkL1cH4gVeth+BH5b/QMKIh3woi+nd3LDIOqA==
X-Received: by 2002:a17:907:d14:: with SMTP id gn20mr6439640ejc.73.1636614394282;
        Wed, 10 Nov 2021 23:06:34 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id o14sm1002526edj.15.2021.11.10.23.06.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 23:06:33 -0800 (PST)
Message-ID: <2c924ef5-2ff9-c9a8-f28c-8bedaf8b1af6@redhat.com>
Date:   Thu, 11 Nov 2021 08:06:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC 11/19] KVM: x86/mmu: Factor shadow_zero_check out of
 make_spte
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
References: <20211110223010.1392399-1-bgardon@google.com>
 <20211110223010.1392399-12-bgardon@google.com>
 <80407e4a-36e1-e606-ed9f-74429f850e77@redhat.com>
 <CANgfPd8hzDU+v52t9Kr=b48utC1p_j3yJ8gHzo-uifAxHbh-eQ@mail.gmail.com>
 <YYxvSfUPTXbclpSa@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YYxvSfUPTXbclpSa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/21 02:18, Sean Christopherson wrote:
> But what would you actually move?  Even shadow_zero_check barely squeaks by,
> e.g. if NX is ever used to for NPT, then maybe it stops being a per-VM setting.

Hmm, I think it would still be per-VM, just like 32-bit shadow page tables
are always built for EFER.NXE=CR4.PAE=1.  Anyway, the rough sketch is to have
three structs:

* struct kvm_mmu_kind has the function pointers and the state that is
needed to operate on page tables

* struct kvm_mmu has the function pointers and the state that is
needed while the vCPU runs, including the role

* struct kvm_paging_context has the stuff related to emulation;
shadow page tables of course needs it but EPT/NPT do not (with
either the old or the new MMU)

So you'd have a "struct kvm_mmu_kind direct_mmu" in struct kvm_arch (for
either legacy EPT/NPT or the new MMU), and

	struct kvm_mmu_kind shadow_mmu;
	struct kvm_mmu root_mmu;		/* either TDP or shadow */
	struct kvm_mmu tdp12_mmu;		/* always shadow */
	struct kvm_mmu *mmu;			/* either &kvm->direct_mmu or &vcpu->shadow_mmu */
	struct kvm_paging_context root_walk;	/* maybe unified with walk01 below? dunno yet */
	struct kvm_paging_context walk01;
	struct kvm_paging_context walk12;
	struct kvm_paging_context *walk;	/* either &vcpu->root_walk or &vcpu->walk12 */

in struct kvm_vcpu_arch.  struct kvm_mmu* has a pointer to
struct kvm_mmu_kind*; however, if an spte.c function does not need
the data in struct kvm_mmu_state*, it can take a struct kvm_mmu_kind*
and it won't need a vCPU.  Likewise the TDP MMU knows its kvm_mmu_kind
is always in &kvm->direct_mmu so it can take a struct kvm* if the struct
kvm_mmu_state* is not needed.

The first part of the refactoring would be to kill the nested_mmu
and walk_mmu, replacing them by &vcpu->walk12 and vcpu->walk
respectively.  The half-useless nested_mmu has always bothered me,
I was going to play with it anyway because I want to remove the
kvm_mmu_reset_context from CR0.WP writes, I'll see if I get
something useful out of it.

Paolo

