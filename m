Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6393660E3
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 22:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbhDTU2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 16:28:46 -0400
Received: from mail.skyhub.de ([5.9.137.197]:59450 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233801AbhDTU2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 16:28:45 -0400
Received: from zn.tnic (p200300ec2f0e5200ad6c103155f7ad28.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:5200:ad6c:1031:55f7:ad28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AD0721EC04A6;
        Tue, 20 Apr 2021 22:28:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1618950492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=0UCi4quETiMG1+QcsYsCXvrF/c0+jnokLMWbAR4d9RY=;
        b=enwJ0gF61TCy69SQQ303M+KVE3IuhiU8POfp/uap9HvNW8KL/FGoT8xLIKM+J2uqhh3zMY
        nooC6gbTTLSqH1KEkJmT/oRKcPAWvCskBKdFFjT6ZP1k2B1Q17dRLh61QIk0bnA4ESnDrY
        4mobSOvLWWMR5RpwB/RJmVGPji/LqVk=
Date:   Tue, 20 Apr 2021 22:28:09 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v13 00/12] Add AMD SEV guest live migration support
Message-ID: <20210420202809.GK5029@zn.tnic>
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <65ebdd0c-3224-742b-d0dd-5003309d1d62@redhat.com>
 <20210420185139.GI5029@zn.tnic>
 <4deae424-85c1-57a7-3952-23d1d65e30ab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4deae424-85c1-57a7-3952-23d1d65e30ab@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021 at 09:08:26PM +0200, Paolo Bonzini wrote:
> Yup, for now it's all at kvm/queue and it will land in kvm/next tomorrow
> (hopefully).  The guest interface patches in KVM are very near the top.

Thx, I'll have a look tomorrow.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
