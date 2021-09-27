Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13174192A8
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 12:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbhI0LBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbhI0LBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:01:08 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34C3C061575;
        Mon, 27 Sep 2021 03:59:30 -0700 (PDT)
Received: from zn.tnic (p200300ec2f088a001ce91a9f1eb42005.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:8a00:1ce9:1a9f:1eb4:2005])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 223971EC05A1;
        Mon, 27 Sep 2021 12:59:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632740365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=DtmAu6IdCf7DA6yalrNpK/1g3x01UkY0+ydrL5s2WoY=;
        b=dLIzuWxuUDzAMTMJB4QLoawI8xTKtzhkqOhmX1x0Aw21lVIbB4wqpwc2+wAbQraSVyIe0l
        QbPAdfhE/JZkOj6wr12+6QsLnLxdInC+ITZnspx4BxkYZSjlwXcSpgxv/f4xf5SryL3L/a
        OujVWuff/az7EGYuwDriPA2D1thDAbA=
Date:   Mon, 27 Sep 2021 12:59:24 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Babu Moger <babu.moger@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        pbonzini@redhat.com, hpa@zytor.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tony.luck@intel.com, peterz@infradead.org,
        kyung.min.park@intel.com, wei.huang2@amd.com, jgross@suse.com,
        andrew.cooper3@citrix.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Expose Predictive Store Forwarding Disable
Message-ID: <YVGkDPbQmdwSw6Ff@zn.tnic>
References: <163244601049.30292.5855870305350227855.stgit@bmoger-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <163244601049.30292.5855870305350227855.stgit@bmoger-ubuntu>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 08:15:28PM -0500, Babu Moger wrote:
> Linux kernel does not have the interface to enable/disable PSFD yet. Plan
> here is to expose the PSFD technology to KVM so that the guest kernel can
> make use of it if they wish to.

Why should the guest kernel expose it if we said that for now we want to
disable it with the SSBD control?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
