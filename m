Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFE8680A8
	for <lists+kvm@lfdr.de>; Sun, 14 Jul 2019 20:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbfGNSQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Jul 2019 14:16:52 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48096 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbfGNSQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Jul 2019 14:16:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zu9VDO3r7C4z6bPiJPIw5Tkj2wZpny80iXDdtymKYFo=; b=EzYn0T6mC7FKpTJ8RU1irxwHC
        abpmpCrn+ITOcYgj8BJxZSu6aQ8Ii0YPXkA/exU0YQAy7O0m7+zOGJ3xNtG1HVipow4mEY+2R1QFW
        yUWv1Dom4OKQzrTOt/MbgsA7dNej/caTkqZhPY4jTEfuejInIA0Otu3kOtE0Y3OFmGhYzyRNA53ot
        8i1Xw/ye+rilRjaF2MiA8RFIjxQIlV1yRtosHFLPp461r/jWR4weAEdfgWYgXPKwsg7h9oaNby5Uw
        Fhn/WXJUh22ci0+2oOYbAzeIHC8bxLEX5nMuy4O4wttLhW0+1HBbETWT8w+KVWUyajs2GLcky3C/l
        obC02yThg==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=[192.168.1.17])
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hmj3K-000704-J9; Sun, 14 Jul 2019 18:16:50 +0000
Subject: Re: [PATCH, RFC 57/62] x86/mktme: Overview of Multi-Key Total Memory
 Encryption
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-58-kirill.shutemov@linux.intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <a2d2ac19-1dfe-6f85-df83-d72de4d5fcbf@infradead.org>
Date:   Sun, 14 Jul 2019 11:16:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190508144422.13171-58-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/8/19 7:44 AM, Kirill A. Shutemov wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Provide an overview of MKTME on Intel Platforms.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  Documentation/x86/mktme/index.rst          |  8 +++
>  Documentation/x86/mktme/mktme_overview.rst | 57 ++++++++++++++++++++++
>  2 files changed, 65 insertions(+)
>  create mode 100644 Documentation/x86/mktme/index.rst
>  create mode 100644 Documentation/x86/mktme/mktme_overview.rst


> diff --git a/Documentation/x86/mktme/mktme_overview.rst b/Documentation/x86/mktme/mktme_overview.rst
> new file mode 100644
> index 000000000000..59c023965554
> --- /dev/null
> +++ b/Documentation/x86/mktme/mktme_overview.rst
> @@ -0,0 +1,57 @@
> +Overview
> +=========
...
> +--
> +1. https://software.intel.com/sites/default/files/managed/a5/16/Multi-Key-Total-Memory-Encryption-Spec.pdf
> +2. The MKTME architecture supports up to 16 bits of KeyIDs, so a
> +   maximum of 65535 keys on top of the “TME key” at KeyID-0.  The
> +   first implementation is expected to support 5 bits, making 63

Hi,
How do 5 bits make 63 keys available?

> +   keys available to applications.  However, this is not guaranteed.
> +   The number of available keys could be reduced if, for instance,
> +   additional physical address space is desired over additional
> +   KeyIDs.


thanks.
-- 
~Randy
