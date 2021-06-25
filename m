Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4963B3B4A8B
	for <lists+kvm@lfdr.de>; Sat, 26 Jun 2021 00:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhFYWZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 18:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbhFYWZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 18:25:24 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDA1C061574;
        Fri, 25 Jun 2021 15:23:03 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0dae0029e536978a2ce722.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:ae00:29e5:3697:8a2c:e722])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0D5DE1EC0595;
        Sat, 26 Jun 2021 00:23:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1624659782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=+EONHP3FxD4di+ShTJpnxsP/RC0RC7lxCcSSvwzWleg=;
        b=XDbsYazIHmjnMgA3eyoGZqu/0xS08Ey48sCw1KZiBKmlSI5s/uqHtWMAUwaLSnq0H8ibeW
        w78zxDlsg3xQakcGUF7JmKlV9jVDGJzmyS6LmFoBTIEZ5NPwK7+sR6I2vtXfDvaO2XX4xf
        +52R+PXgRLTXdFdgJbUEVBugJmgNy0M=
Date:   Sat, 26 Jun 2021 00:22:52 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com,
        seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        brijesh.singh@amd.com
Subject: Re: [PATCH v4 5/5] x86/kvm: Add guest support for detecting and
 enabling SEV Live Migration feature.
Message-ID: <YNZXPEPxv54UmzNj@zn.tnic>
References: <cover.1623421410.git.ashish.kalra@amd.com>
 <8c581834c77284d5b9465b3388f07fa100f9fc4e.1623421410.git.ashish.kalra@amd.com>
 <CABayD+ckOsM4+sab00SggrH3_iFaiV-7h9tHHuL1J-o6_YQVKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABayD+ckOsM4+sab00SggrH3_iFaiV-7h9tHHuL1J-o6_YQVKA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 25, 2021 at 02:02:32PM -0700, Steve Rutherford wrote:
> Boris, do you have any thoughts on the kexec aspect of this change?

I'm suspecting you're asking here the wrong guy - I think you mean
Paolo.

But if I were to give some thoughts on this, I'd first request that this
patch be split because it is doing a bunch of things at once.

Then, I have no clue what "kexec support for SEV Live Migration" is. So
this whole use case would need a lot more detailed explanation of all
the moving parts and the "why" and the "because" and so on...

But I'm no virt guy so perhaps this all makes sense to virt folks.

Oh, and there's silly stuff like

+static int __init setup_efi_kvm_sev_migration(void)
{
	...
	return true;
}

returning a bool but that's minor.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
