Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477552EC1BF
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 18:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbhAFRH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 12:07:57 -0500
Received: from mga14.intel.com ([192.55.52.115]:42859 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727855AbhAFRH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 12:07:56 -0500
IronPort-SDR: KJWLzT4G4egqitajn4jcy2aSWLEa8mo5F+tkypFTMalZrpgrkPGZu/1w/5qezL/Y/TfwFtFgvV
 LCkBioBJA6ng==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="176527682"
X-IronPort-AV: E=Sophos;i="5.79,327,1602572400"; 
   d="scan'208";a="176527682"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 09:07:15 -0800
IronPort-SDR: apMhbfGjSW5CxbwMvbcurVwRs2QdrAI34uNOkcZwe47pQN5li7thLGtQ4oANM1NpKdNgQSoAiv
 tjlBva4soTWg==
X-IronPort-AV: E=Sophos;i="5.79,327,1602572400"; 
   d="scan'208";a="565878061"
Received: from ansukerk-mobl1.amr.corp.intel.com (HELO [10.209.131.99]) ([10.209.131.99])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 09:07:14 -0800
Subject: Re: [RFC PATCH 00/23] KVM SGX virtualization support
To:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, mattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
References: <cover.1609890536.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <1772bbf4-54bd-e43f-a71f-d72f9a6a9bad@intel.com>
Date:   Wed, 6 Jan 2021 09:07:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1609890536.git.kai.huang@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/21 5:55 PM, Kai Huang wrote:
> - Virtual EPC
> 
> "Virtual EPC" is the EPC section exposed by KVM to guest so SGX software in
> guest can discover it and use it to create SGX enclaves. KVM exposes SGX to 
> guest via CPUID, and exposes one or more "virtual EPC" sections for guest.
> The size of "virtual EPC" is passed as Qemu parameter when creating the
> guest, and the base address is calcualted internally according to guest's

				^ calculated

> configuration.

This is not a great first paragraph to introduce me to this feature.

Please remind us what EPC *is*, then you can go and talk about why we
have to virtualize it, and how "virtual EPC" is different from normal
EPC.  For instance:

SGX enclave memory is special and is reserved specifically for enclave
use.  In bare-metal SGX enclaves, the kernel allocates enclave pages,
copies data into the pages with privileged instructions, then allows the
enclave to start.  In this scenario, only initialized pages already
assigned to an enclave are mapped to userspace.

In virtualized environments, the hypervisor still needs to do the
physical enclave page allocation.  The guest kernel is responsible for
the data copying (among other things).  This means that the job of
starting an enclave is now split between hypervisor and guest.

This series introduces a new misc device: /dev/sgx_virt_epc.  This
device allows the host to map *uninitialized* enclave memory into
userspace, which can then be passed into a guest.

While it might be *possible* to start a host-side enclave with
/dev/sgx_enclave and pass its memory into a guest, it would be wasteful
and convoluted.

> core/driver to allow userspace (Qemu) to allocate "raw" EPC, and use it as
> "virtual EPC" for guest. Obviously, unlike EPC allocated for host SGX driver,
> virtual EPC allocated via /dev/sgx_virt_epc doesn't have enclave associated,
> and how virtual EPC is used by guest is compeletely controlled by guest's SGX

					   ^ completely

Please run a spell checker on this thing.

> software.
> 
> Implement the "raw" EPC allocation in the x86 core-SGX subsystem via
> /dev/sgx_virt_epc rather than in KVM. Doing so has two major advantages:
> 
>   - Does not require changes to KVM's uAPI, e.g. EPC gets handled as
>     just another memory backend for guests.
> 
>   - EPC management is wholly contained in the SGX subsystem, e.g. SGX
>     does not have to export any symbols, changes to reclaim flows don't
>     need to be routed through KVM, SGX's dirty laundry doesn't have to
>     get aired out for the world to see, and so on and so forth.
> 
> The virtual EPC allocated to guests is currently not reclaimable, due to
> reclaiming EPC from KVM guests is not currently supported. Due to the
> complications of handling reclaim conflicts between guest and host, KVM
> EPC oversubscription, which allows total virtual EPC size greater than
> physical EPC by being able to reclaiming guests' EPC, is significantly more
> complex than basic support for SGX virtualization.

It would also help here to remind the reader that enclave pages have a
special reclaim mechanism separtae from normal page reclaim, and that
mechanism is disabled for these pages.

Does the *ABI* here preclude doing oversubscription in the future?

> - Support SGX virtualization without SGX Launch Control unlocked mode
> 
> Although SGX driver requires SGX Launch Control unlocked mode to work, SGX

Although the bare-metal SGX driver requires...

Also, didn't we call this "Flexible Launch Control"?

> virtualization doesn't, since how enclave is created is completely controlled
> by guest SGX software, which is not necessarily linux. Therefore, this series
> allows KVM to expose SGX to guest even SGX Launch Control is in locked mode,

... "expose SGX to guests even if" ...

> or is not present at all. The reason is the goal of SGX virtualization, or
> virtualization in general, is to expose hardware feature to guest, but not to
> make assumption how guest will use it. Therefore, KVM should support SGX guest
> as long as hardware is able to, to have chance to support more potential use
> cases in cloud environment.

This is kinda long-winded and misses a lot of important context.  How about:

SGX hardware supports two "launch control" modes to limit which enclaves
can run.  In the "locked" mode, the hardware prevents enclaves from
running unless they are blessed by a third party.  In the unlocked mode,
the kernel is in full control of which enclaves can run.  The bare-metal
SGX code refuses to launch enclaves unless it is in the unlocked mode.

This sgx_virt_epc driver does not have such a restriction.  This allows
guests which are OK with the locked mode to use SGX, even if the host
kernel refuses to.

> - Support exposing SGX2
> 
> Due to the same reason above, SGX2 feature detection is added to core SGX code
> to allow KVM to expose SGX2 to guest, even currently SGX driver doesn't support
> SGX2, because SGX2 can work just fine in guest w/o any interaction to host SGX
> driver.
> 
> - Restricit SGX guest access to provisioning key
> 
> To grant guest being able to fully use SGX, guest needs to be able to create
> provisioning enclave.

"enclave" or "enclaves"?

> However provisioning key is sensitive and is restricted by

	^ the

> /dev/sgx_provision in host SGX driver, therefore KVM SGX virtualization follows
> the same role: a new KVM_CAP_SGX_ATTRIBUTE is added to KVM uAPI, and only file
> descriptor of /dev/sgx_provision is passed to that CAP by usersppace hypervisor
> (Qemu) when creating the guest, it can access provisioning bit. This is done by
> making KVM trape ECREATE instruction from guest, and check the provisioning bit

		^ trap

> in ECREATE's attribute.

The grammar in that paragraph is really off to me.  Can you give it
another go?

