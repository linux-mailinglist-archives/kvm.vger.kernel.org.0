Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D56945BEF
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 13:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbfFNL5B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 07:57:01 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33744 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbfFNL5B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 07:57:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sguVOcCD8xzkuKBxAXbNwLoTIO2Bzo3Eiksza5G7pQs=; b=cSm5PBNCt4M8uJZY1qjBxCUXr
        H5O87c2TUu73yBZbv+rbeId9QKYO7rcOoardZx9weKhgS+3hIMIFgLL4gq0VjjQ41UCQ0DZTJEvBE
        v9L26qxOd+/i6m3ddYrH901cECMuXIRsttSXQbJ/ac3UCFB6SWlLjHy/J0weQblA0TThiRJPQeWkB
        rU+VGSfcBuXDneU9uteMmYGcC+aTCn5DvWUt2neAkStNKIfgqTFlWpBFp4a4oUAtJ7MonQrarCOB8
        l1CAdU/xZhFdBlq06gHnV/SuU6BN5256YqvNgiiialsn3ZXhyRUV73I2u1viT0U+EGpE+8IZxyp4+
        NfcckPLsg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbkp7-0003dw-4X; Fri, 14 Jun 2019 11:56:49 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A68CE20A29B4F; Fri, 14 Jun 2019 13:56:47 +0200 (CEST)
Date:   Fri, 14 Jun 2019 13:56:47 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 49/62] mm, x86: export several MKTME variables
Message-ID: <20190614115647.GI3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-50-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508144422.13171-50-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:44:09PM +0300, Kirill A. Shutemov wrote:
> From: Kai Huang <kai.huang@linux.intel.com>
> 
> KVM needs those variables to get/set memory encryption mask.
> 
> Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  arch/x86/mm/mktme.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/mm/mktme.c b/arch/x86/mm/mktme.c
> index df70651816a1..12f4266cf7ea 100644
> --- a/arch/x86/mm/mktme.c
> +++ b/arch/x86/mm/mktme.c
> @@ -7,13 +7,16 @@
>  
>  /* Mask to extract KeyID from physical address. */
>  phys_addr_t mktme_keyid_mask;
> +EXPORT_SYMBOL_GPL(mktme_keyid_mask);
>  /*
>   * Number of KeyIDs available for MKTME.
>   * Excludes KeyID-0 which used by TME. MKTME KeyIDs start from 1.
>   */
>  int mktme_nr_keyids;
> +EXPORT_SYMBOL_GPL(mktme_nr_keyids);
>  /* Shift of KeyID within physical address. */
>  int mktme_keyid_shift;
> +EXPORT_SYMBOL_GPL(mktme_keyid_shift);
>  
>  DEFINE_STATIC_KEY_FALSE(mktme_enabled_key);
>  EXPORT_SYMBOL_GPL(mktme_enabled_key);

NAK, don't export variables. Who owns the values, who enforces this?
