Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D5A36C9E3
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 18:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237720AbhD0Q7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 12:59:31 -0400
Received: from mail.skyhub.de ([5.9.137.197]:55026 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238110AbhD0Q73 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 12:59:29 -0400
Received: from zn.tnic (p200300ec2f0c5e0085f018e791730569.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:5e00:85f0:18e7:9173:569])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EF26C1EC046E;
        Tue, 27 Apr 2021 18:58:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1619542725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=lz3XSWEbf7jwA4LTaOYIQoyDisqfXg243NLJRhz6mzo=;
        b=Ht+705dCSPNBGI6RRwsNQUtroQ4dTA1OvVv+n8qThewcXxJUFIiGaL7XrEVMZcQIIyeeQI
        0EmgRWNg0G0EqrlE+RuAcDpkNnn8qirJiUZsELpCc9U/qNEqO7p50p4TfSuvmrF/l30v4t
        /sUoaTdCmM9hgUmCYl7jOhkLtwJLfNI=
Date:   Tue, 27 Apr 2021 18:58:42 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, tglx@linutronix.de, jroedel@suse.de,
        thomas.lendacky@amd.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 1/3] x86/sev-es: Rename sev-es.{ch} to sev.{ch}
Message-ID: <YIhCwtMA6WnDNvxt@zn.tnic>
References: <20210427111636.1207-1-brijesh.singh@amd.com>
 <20210427111636.1207-2-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210427111636.1207-2-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27, 2021 at 06:16:34AM -0500, Brijesh Singh wrote:
> The SEV-SNP builds upon the SEV-ES functionality while adding new hardware
> protection. Version 2 of the GHCB specification adds new NAE events that
> are SEV-SNP specific. Rename the sev-es.{ch} to sev.{ch} so that we can
> consolidate all the SEV-ES and SEV-SNP in a one place.

No "we":

... so that all SEV* functionality can be consolidated in one place."

Rest looks good.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
