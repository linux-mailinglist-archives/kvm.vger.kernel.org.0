Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709852F8131
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 17:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbhAOQuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 11:50:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbhAOQuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 11:50:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0966B222B3;
        Fri, 15 Jan 2021 16:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610729409;
        bh=4TPOAVSgQzirc/H2ZzkAHJamp1LB/G2EZTjrlQgOIPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W9I5fyXDifpCokLdlk55lMXiZZdA6FEdy7X+0rBPXD58WQeNxYQC9Vq50pglm27wo
         I0IT03Fd4XAKRs7443r00rHe+8xTml2A3GjthT/FY1j00c4TC4g/Bgt6YQiFvDwtzK
         HF13w1f6PHYHa2+xq2Up0PC5qmZz5wQcn55VscpByT9cQPY4izRGWfVaOvQYWF3Q7+
         6zsIbAUnh4wmzNHO5YgnunKg9t8wXFKaiyBv8FkjMqdyliQy887QaBflM7zJOrO0gO
         cRyjUjCdjLdf3pGdyB66FmjeEgzo1Wl9GCsU95c1C0KeUmDhVXqr39INQQ72dO0PbW
         TFGs1/HdHXd0A==
Date:   Fri, 15 Jan 2021 16:50:04 +0000
From:   Will Deacon <will@kernel.org>
To:     Quentin Perret <qperret@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        android-kvm@google.com, kernel-team@android.com
Subject: Re: [PATCH] KVM: Documentation: Fix spec for KVM_CAP_ENABLE_CAP_VM
Message-ID: <20210115165004.GA14556@willie-the-truck>
References: <20210108165349.747359-1-qperret@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108165349.747359-1-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 08, 2021 at 04:53:49PM +0000, Quentin Perret wrote:
> The documentation classifies KVM_ENABLE_CAP with KVM_CAP_ENABLE_CAP_VM
> as a vcpu ioctl, which is incorrect. Fix it by specifying it as a VM
> ioctl.
> 
> Fixes: e5d83c74a580 ("kvm: make KVM_CAP_ENABLE_CAP_VM architecture agnostic")
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 70254eaa5229..68898b623d86 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1328,7 +1328,7 @@ documentation when it pops into existence).
>  
>  :Capability: KVM_CAP_ENABLE_CAP_VM
>  :Architectures: all
> -:Type: vcpu ioctl
> +:Type: vm ioctl
>  :Parameters: struct kvm_enable_cap (in)
>  :Returns: 0 on success; -1 on error

I tripped over this as well, so:

Acked-by: Will Deacon <will@kernel.org>

Will
