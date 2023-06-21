Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F3B737E37
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 11:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjFUJQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 05:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjFUJQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 05:16:33 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0EAE4D;
        Wed, 21 Jun 2023 02:16:31 -0700 (PDT)
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 081071EC0645;
        Wed, 21 Jun 2023 11:16:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1687338990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=fI4K8Q/io77w6bwiDKBNg2gNYXZ0qce2M/7aadNkERY=;
        b=NC0f3uCJoMjFh+SJvvtI3/CBfXtdZh/LTG3aydeR6bHNDvjpjK2qxl0y5xh018/+U0lwk7
        KrGI4WRKca2Ddy0sPzDbxqYrUJGl7uCjwzi3qu3fKIDLi1nN7TavH15xKnm0eD61+boalt
        phPsKYwSqvyik7xgwVGdhJKqljnc25w=
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ZIP4NY-AI2Be; Wed, 21 Jun 2023 09:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1687338987; bh=fI4K8Q/io77w6bwiDKBNg2gNYXZ0qce2M/7aadNkERY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DnzWgH4s65gVXoHcEoH/FiuLI57PSlNdcO7BHD7AiqDg5Ne41G5S2z1A0ESKW8KhC
         zjmGH4F+ox7qQyiCy85AzymObJcixiAKYc0XFgafArcY2zjxCKLvbZuMnR5kVmC0zQ
         NWqOSWnId4cJu4keK0mECeYvsv5on253FZhdyb4GWCPSj03g/7ZAGz5OMbNfXON4Bc
         paruBiy4iZDLq7cq596SzlYmtR9dYUnAn0B1/22qVcE7HPsDh5NGWHJaL9EktazY1j
         fz1JHeZgvQXkyk7GGknnpiVxx7UT3Bfvc66dLJWlHFAaB7Nsdg3lzF8akjfcoOxNIj
         aNk9j0WNmHS7S1fjPAQc3OZW2ytSJ0xKg+MV5jgGfkqSry9i9hx9ey74YEU2iFy6vz
         yXfgSbuvaS7UYJBRet6JMh1+39qO+W9OAbjuCQXqE7iSOrFQQMx33c//qXH+hCNktH
         ePeyqdfqFPWn1kDKDTUrcR1i5EHYAIpb2JTObPZb297GlpSaEJ5AYvyqIg+0Ue5dw2
         GH4KZg77UvBgfivI9IHcoPpR0Lfq8DnZUpBh/vjXJtrIK8LJV1F7P66BBDUGKEIAxF
         P0VQmhCRtJp/sBPXl+8iD3aY3JkXZe60cyGczseLAg8argYAuhqcz0eFa5Wazx/Ds1
         ZHO3DK95miUU+DmSiGNfPScg=
Received: from zn.tnic (p200300EA971DC592329c23FfFea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971d:c592:329c:23ff:fea6:a903])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 08FF640E0145;
        Wed, 21 Jun 2023 09:15:46 +0000 (UTC)
Date:   Wed, 21 Jun 2023 11:15:41 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH RFC v9 07/51] x86/sev: Add the host SEV-SNP
 initialization support
Message-ID: <20230621091541.GEZJK/veTnfhOnX8ci@fat_crate.local>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-8-michael.roth@amd.com>
 <12f95b38-427c-6810-373a-ba2062c43882@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <12f95b38-427c-6810-373a-ba2062c43882@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 12, 2023 at 08:34:02AM -0700, Dave Hansen wrote:
> On 6/11/23 21:25, Michael Roth wrote:
> > +	/*
> > +	 * Calculate the amount the memory that must be reserved by the BIOS to
> > +	 * address the whole RAM, including the bookkeeping area. The RMP itself
> > +	 * must also be covered.
> > +	 */
> > +	max_rmp_pfn = max_pfn;
> > +	if (PHYS_PFN(rmp_end) > max_pfn)
> > +		max_rmp_pfn = PHYS_PFN(rmp_end);
> 
> Could you say a little here about how this deals with memory hotplug?

Does SNP hw even support memory hotplug?

I think in order to support that, you'd need some special dance because
of the RMP table etc...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
