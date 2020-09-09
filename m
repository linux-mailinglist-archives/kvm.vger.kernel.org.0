Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345DD26346E
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 19:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbgIIRU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 13:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730889AbgIIRUM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 13:20:12 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD02C061573;
        Wed,  9 Sep 2020 10:20:11 -0700 (PDT)
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id BDBD037C;
        Wed,  9 Sep 2020 17:20:09 +0000 (UTC)
Date:   Wed, 9 Sep 2020 11:20:08 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Connor Kuehl <ckuehl@redhat.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: kvm: fix referenced ioctl symbol
Message-ID: <20200909112008.23859385@lwn.net>
In-Reply-To: <20200819211952.251984-1-ckuehl@redhat.com>
References: <20200819211952.251984-1-ckuehl@redhat.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Aug 2020 16:19:52 -0500
Connor Kuehl <ckuehl@redhat.com> wrote:

> The actual symbol that is exported and usable is
> 'KVM_MEMORY_ENCRYPT_OP', not 'KVM_MEM_ENCRYPT_OP'
> 
> $ git grep -l KVM_MEM_ENCRYPT_OP
> Documentation/virt/kvm/amd-memory-encryption.rst
> 
> $ git grep -l KVM_MEMORY_ENCRYPT_OP
> Documentation/virt/kvm/api.rst
> arch/x86/kvm/x86.c
> include/uapi/linux/kvm.h
> tools/include/uapi/linux/kvm.h
> 
> While we're in there, update the KVM API category for
> KVM_MEMORY_ENCRYPT_OP. It is called on a VM file descriptor.
> 
> Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
> ---
>  Documentation/virt/kvm/amd-memory-encryption.rst | 6 +++---
>  Documentation/virt/kvm/api.rst                   | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 2d44388438cc..09a8f2a34e39 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -53,11 +53,11 @@ key management interface to perform common hypervisor activities such as
>  encrypting bootstrap code, snapshot, migrating and debugging the guest. For more
>  information, see the SEV Key Management spec [api-spec]_
>  
> -The main ioctl to access SEV is KVM_MEM_ENCRYPT_OP.  If the argument
> -to KVM_MEM_ENCRYPT_OP is NULL, the ioctl returns 0 if SEV is enabled
> +The main ioctl to access SEV is KVM_MEMORY_ENCRYPT_OP.  If the argument
> +to KVM_MEMORY_ENCRYPT_OP is NULL, the ioctl returns 0 if SEV is enabled
>  and ``ENOTTY` if it is disabled (on some older versions of Linux,
>  the ioctl runs normally even with a NULL argument, and therefore will
> -likely return ``EFAULT``).  If non-NULL, the argument to KVM_MEM_ENCRYPT_OP
> +likely return ``EFAULT``).  If non-NULL, the argument to KVM_MEMORY_ENCRYPT_OP
>  must be a struct kvm_sev_cmd::
>  
>         struct kvm_sev_cmd {
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index eb3a1316f03e..506c8426c583 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4211,7 +4211,7 @@ H_GET_CPU_CHARACTERISTICS hypercall.
>  
>  :Capability: basic
>  :Architectures: x86
> -:Type: system
> +:Type: vm
>  :Parameters: an opaque platform specific structure (in/out)
>  :Returns: 0 on success; -1 on error
>  
So this appears to have fallen through the cracks.  It looks correct to
me, so I've applied it, thanks.

jon
