Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0FF444381
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 15:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhKCOaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 10:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbhKCOaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 10:30:04 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D2FC06120B;
        Wed,  3 Nov 2021 07:27:25 -0700 (PDT)
Received: from zn.tnic (p200300ec2f13290006136262b125c835.dip0.t-ipconnect.de [IPv6:2003:ec:2f13:2900:613:6262:b125:c835])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 127091EC0567;
        Wed,  3 Nov 2021 15:27:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1635949644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=PN13d60ZQ5g2G8iEXh3tkIMCVCu0bXX1/VFUYwMyhZo=;
        b=hRLfXtHgTs4/Lm9rNp+SY306FCQskMF/7tpsnJV3kuA2NqDuTzGrs+Bjpdfm1FnKyEzrBI
        uuDrkCL5NNlFxWSJ0YptWv30kTilcRNvxBXYdwApFSD4DYkUsQyysd1uuiAl7uqSlEYbm+
        4WjnKmhIKmrbObBfRMq3Z6Hgu8bgyFI=
Date:   Wed, 3 Nov 2021 15:27:23 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Eric Biederman <ebiederm@xmission.com>,
        kexec@lists.infradead.org, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 03/12] x86/sev: Save and print negotiated GHCB
 protocol version
Message-ID: <YYKcS2OIzAV+MTzr@zn.tnic>
References: <20210913155603.28383-1-joro@8bytes.org>
 <20210913155603.28383-4-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210913155603.28383-4-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021 at 05:55:54PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Save the results of the GHCB protocol negotiation into a data structure
> and print information about versions supported and used to the kernel
> log.

Which is useful for?

> +/*
> + * struct sev_ghcb_protocol_info - Used to return GHCB protocol
> + *				   negotiation details.
> + *
> + * @hv_proto_min:	Minimum GHCB protocol version supported by Hypervisor
> + * @hv_proto_max:	Maximum GHCB protocol version supported by Hypervisor
> + * @vm_proto:		Protocol version the VM (this kernel) will use
> + */
> +struct sev_ghcb_protocol_info {

Too long a name - ghcb_info is perfectly fine.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
