Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E379034B247
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 23:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhCZWrJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 18:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229969AbhCZWqn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 18:46:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A214961A21;
        Fri, 26 Mar 2021 22:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616798803;
        bh=Wm2cdmh8jurooirWZ/ts+cDzC6mutuJ2k4F8lj5bCxI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QNGcgjv68Z/fo6F78HoYrYy3OBszT5C5uDy2AGEqk2xPQ0t9QdUH0bZhxbDnGVfhP
         5GJ8NNnuIcLf0TpsSu3Jh6suvITERruDpzYbFZVr3JB58CFG6ZMPhamwGj5vuGBfww
         V4aS4Gv2EMDsvjV9krs4YLYxXhE0zwDfRLUQIRZ2YAgzzDLAeQ1BPtBENeF+jb/tEX
         WvIi6Cylg84aFojnQH1znDyF25IJINiEybRTGhkBtS/mYv69xIU97bDYAvKh1WVSip
         FpAi7WFtd6oPa3uHA1whFH+vYiHjTgaPxWSFw9j6FIZa/fXH4ImFgmKYBv6kWB4apU
         brNAlXzHU/z5Q==
Date:   Sat, 27 Mar 2021 00:46:12 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, jmattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
Subject: Re: [PATCH v3 00/25] KVM SGX virtualization support
Message-ID: <YF5kNPP2VyzcTuTY@kernel.org>
References: <cover.1616136307.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1616136307.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 08:29:27PM +1300, Kai Huang wrote:
> This series adds KVM SGX virtualization support. The first 14 patches starting
> with x86/sgx or x86/cpu.. are necessary changes to x86 and SGX core/driver to
> support KVM SGX virtualization, while the rest are patches to KVM subsystem.
> 
> This series is based against latest tip/x86/sgx, which has Jarkko's NUMA
> allocation support.
> 
> You can also get the code from upstream branch of kvm-sgx repo on github:
> 
>         https://github.com/intel/kvm-sgx.git upstream
> 
> It also requires Qemu changes to create VM with SGX support. You can find Qemu
> repo here:
> 
> 	https://github.com/intel/qemu-sgx.git upstream
> 
> Please refer to README.md of above qemu-sgx repo for detail on how to create
> guest with SGX support. At meantime, for your quick reference you can use below
> command to create SGX guest:
> 
> 	#qemu-system-x86_64 -smp 4 -m 2G -drive file=<your_vm_image>,if=virtio \
> 		-cpu host,+sgx_provisionkey \
> 		-sgx-epc id=epc1,memdev=mem1 \
> 		-object memory-backend-epc,id=mem1,size=64M,prealloc
> 
> Please note that the SGX relevant part is:
> 
> 		-cpu host,+sgx_provisionkey \
> 		-sgx-epc id=epc1,memdev=mem1 \
> 		-object memory-backend-epc,id=mem1,size=64M,prealloc
> 
> And you can change other parameters of your qemu command based on your needs.

Please also put tested-by from me to all patches (including pure KVM
patches):

Tested-by: Jarkko Sakkinen <jarkko@kernel.org>

I did the basic test, i.e. run selftest in a VM. I think that is
sufficient at this point.

/Jarkko
