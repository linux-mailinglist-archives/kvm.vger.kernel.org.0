Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B27C21DA25
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 17:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbgGMPeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 11:34:25 -0400
Received: from ms.lwn.net ([45.79.88.28]:35536 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729927AbgGMPeZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 11:34:25 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 2D5FB2E2;
        Mon, 13 Jul 2020 15:34:25 +0000 (UTC)
Date:   Mon, 13 Jul 2020 09:34:24 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: kvm: Replace HTTP links with HTTPS ones
Message-ID: <20200713093424.0e89d176@lwn.net>
In-Reply-To: <20200713114719.33839-1-grandmaster@al2klimov.de>
References: <20200713114719.33839-1-grandmaster@al2klimov.de>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Jul 2020 13:47:19 +0200
"Alexander A. Klimov" <grandmaster@al2klimov.de> wrote:

>  Documentation/virt/kvm/amd-memory-encryption.rst | 6 +++---
>  Documentation/virt/kvm/mmu.rst                   | 2 +-
>  Documentation/virt/kvm/nested-vmx.rst            | 2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> index 57c01f531e61..2d44388438cc 100644
> --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> @@ -270,6 +270,6 @@ References
>  See [white-paper]_, [api-spec]_, [amd-apm]_ and [kvm-forum]_ for more info.
>  
>  .. [white-paper] http://amd-dev.wpengine.netdna-cdn.com/wordpress/media/2013/12/AMD_Memory_Encryption_Whitepaper_v7-Public.pdf
> -.. [api-spec] http://support.amd.com/TechDocs/55766_SEV-KM_API_Specification.pdf
> -.. [amd-apm] http://support.amd.com/TechDocs/24593.pdf (section 15.34)
> -.. [kvm-forum]  http://www.linux-kvm.org/images/7/74/02x08A-Thomas_Lendacky-AMDs_Virtualizatoin_Memory_Encryption_Technology.pdf
> +.. [api-spec] https://support.amd.com/TechDocs/55766_SEV-KM_API_Specification.pdf
> +.. [amd-apm] https://support.amd.com/TechDocs/24593.pdf (section 15.34)
> +.. [kvm-forum]  https://www.linux-kvm.org/images/7/74/02x08A-Thomas_Lendacky-AMDs_Virtualizatoin_Memory_Encryption_Technology.pdf
> diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/mmu.rst
> index 46126ecc70f7..1c030dbac7c4 100644
> --- a/Documentation/virt/kvm/mmu.rst
> +++ b/Documentation/virt/kvm/mmu.rst
> @@ -480,4 +480,4 @@ Further reading
>  ===============
>  
>  - NPT presentation from KVM Forum 2008
> -  http://www.linux-kvm.org/images/c/c8/KvmForum2008%24kdf2008_21.pdf
> +  https://www.linux-kvm.org/images/c/c8/KvmForum2008%24kdf2008_21.pdf
> diff --git a/Documentation/virt/kvm/nested-vmx.rst b/Documentation/virt/kvm/nested-vmx.rst
> index 89851cbb7df9..6ab4e35cee23 100644
> --- a/Documentation/virt/kvm/nested-vmx.rst
> +++ b/Documentation/virt/kvm/nested-vmx.rst
> @@ -22,7 +22,7 @@ its implementation and its performance characteristics, in the OSDI 2010 paper
>  "The Turtles Project: Design and Implementation of Nested Virtualization",
>  available at:
>  
> -	http://www.usenix.org/events/osdi10/tech/full_papers/Ben-Yehuda.pdf
> +	https://www.usenix.org/events/osdi10/tech/full_papers/Ben-Yehuda.pdf

Applied, thanks.

jon
