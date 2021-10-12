Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042A342AB10
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 19:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhJLRsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 13:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhJLRsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 13:48:17 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF92C061570;
        Tue, 12 Oct 2021 10:46:15 -0700 (PDT)
Received: from zn.tnic (p200300ec2f19420044c1262ed1e42b8c.dip0.t-ipconnect.de [IPv6:2003:ec:2f19:4200:44c1:262e:d1e4:2b8c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 06B2D1EC047E;
        Tue, 12 Oct 2021 19:46:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634060774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=x5jmEYoOWbIrx2JArtKtCDt/YV7kBkWkVjZ7M0GZpRo=;
        b=OMOnnbtzuMLuJy+sTPLw5T/gkqxM0OExXMmNLgTnv+3n3CltiX/gh3PQ+vONw0Deppiuee
        XOmDKN5BSv8UvEw2+hNL51feihcbSn7VnV5twVArLFycT40m0xjFCePNKH6x0TsX1RGMSm
        hkucMlo9uP6TNx8Xu3erbkt1SP636m0=
Date:   Tue, 12 Oct 2021 19:46:11 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch 26/31] x86/fpu: Move fpstate functions to api.h
Message-ID: <YWXJ41WPh6udVXmE@zn.tnic>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.846280577@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211011223611.846280577@linutronix.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12, 2021 at 02:00:37AM +0200, Thomas Gleixner wrote:
> Move function declarations which need to be globaly available to api.h
> where they belong.

"globally"

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
