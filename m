Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95DE392DE2
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 14:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbhE0MZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 08:25:11 -0400
Received: from mail.skyhub.de ([5.9.137.197]:33996 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234410AbhE0MZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 08:25:11 -0400
Received: from zn.tnic (p200300ec2f0f0200feb4df54292f983f.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:200:feb4:df54:292f:983f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7CC271EC01DF;
        Thu, 27 May 2021 14:23:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1622118217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=XmPZBX9quvpk0nriJ9voXMcog/6QnU2qkiYE1ANKHdM=;
        b=MehT+vNxndiAuJk5SqOte+CQFxNPHQD3le5s/qF9DvFyzrQpAL/X5Rjc4LCKYcSIwmM4vf
        1c+BomWYBxyeugJTfBId24lmvaidt8QLTKLZvJ5DqIUojQx6sncr/ToCW/vAGsXe+G2jsH
        t7VAj52oGLWysFxkc89avI71oEVvdxk=
Date:   Thu, 27 May 2021 14:23:35 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 16/20] x86/kernel: Validate rom memory
 before accessing when SEV-SNP is active
Message-ID: <YK+PR5mf/H6TNDt7@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-17-brijesh.singh@amd.com>
 <YK+HMZIgZWwCYKzq@zn.tnic>
 <588df124-6213-22c4-384f-49fa368bb7ed@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <588df124-6213-22c4-384f-49fa368bb7ed@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 27, 2021 at 07:12:00AM -0500, Brijesh Singh wrote:
> Let me know if you still think that snp_prep_memory() helper is required.

Yes, I still do think that because you can put the comment and all
the manupulation of parameters in there and have a single oneliner in
probe_roms.c:

	snp_prep_memory(...);

and have the details in sev.c where they belong.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
