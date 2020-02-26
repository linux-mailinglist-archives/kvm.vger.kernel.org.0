Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 753BF16F8DF
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 08:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgBZH7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 02:59:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38800 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726587AbgBZH7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 02:59:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582703947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KQBpQ+EHhf3d1IEE8i6K16t2pRCzfBxIFy/tzHa0/30=;
        b=I+ksqFcIrl7Qc9OWRK8m4Z2YDKca7kbSAkKmna52Vfn18/+MEM2i4Pwghu/+aBGtfI3NkF
        tsx52B1hceyCeFDVTfqH4+8/3YM3Lc6HyMyy2za6+uX7+9nFlHLKeTw1R34b88GOfMsUBG
        rIWnL02U44doywof2IYLDfnczmsIPSo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-3gCFt4ssOT2bHyG4FfrPWg-1; Wed, 26 Feb 2020 02:59:06 -0500
X-MC-Unique: 3gCFt4ssOT2bHyG4FfrPWg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CD5E1005512;
        Wed, 26 Feb 2020 07:59:05 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B60C28C07D;
        Wed, 26 Feb 2020 07:59:04 +0000 (UTC)
Date:   Wed, 26 Feb 2020 08:59:02 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     morbo@google.com
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/7] pci: use uint32_t for unsigned long
 values
Message-ID: <20200226075902.3ngaicupvy6ibirr@kamzik.brq.redhat.com>
References: <20200226074427.169684-1-morbo@google.com>
 <20200226074427.169684-3-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226074427.169684-3-morbo@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 25, 2020 at 11:44:22PM -0800, morbo@google.com wrote:
> From: Bill Wendling <morbo@google.com>
> 
> The "pci_bar_*" functions use 64-bit masks, but the results are assigned
> to 32-bit variables. Use 32-bit masks, since we're interested only in
> the least significant 4-bits.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---
>  lib/linux/pci_regs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/linux/pci_regs.h b/lib/linux/pci_regs.h
> index 1becea8..3bc2b92 100644
> --- a/lib/linux/pci_regs.h
> +++ b/lib/linux/pci_regs.h
> @@ -96,8 +96,8 @@
>  #define  PCI_BASE_ADDRESS_MEM_TYPE_1M	0x02	/* Below 1M [obsolete] */
>  #define  PCI_BASE_ADDRESS_MEM_TYPE_64	0x04	/* 64 bit address */
>  #define  PCI_BASE_ADDRESS_MEM_PREFETCH	0x08	/* prefetchable? */
> -#define  PCI_BASE_ADDRESS_MEM_MASK	(~0x0fUL)
> -#define  PCI_BASE_ADDRESS_IO_MASK	(~0x03UL)
> +#define  PCI_BASE_ADDRESS_MEM_MASK	(~0x0fU)
> +#define  PCI_BASE_ADDRESS_IO_MASK	(~0x03U)
>  /* bit 1 is reserved if address_space = 1 */
>  
>  /* Header type 0 (normal devices) */
> -- 
> 2.25.0.265.gbab2e86ba0-goog
>

This file comes directly from the Linux source. If it's not changed
there, then it shouldn't change here.

Thanks,
drew 

