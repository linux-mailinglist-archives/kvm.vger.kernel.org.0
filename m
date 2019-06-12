Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F6342BD5
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 18:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729938AbfFLQNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 12:13:05 -0400
Received: from mail.skyhub.de ([5.9.137.197]:45874 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729375AbfFLQNF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 12:13:05 -0400
Received: from zn.tnic (p200300EC2F0A6800329C23FFFEA6A903.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:6800:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 557641EC01D4;
        Wed, 12 Jun 2019 18:13:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1560355984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=qUTk2w5S4pVc4lMegwbHgFHGvseB57PMY7gYmFXfocI=;
        b=Lc6pUKNDryoss30NsggC722CXtcP1jG+T1DC2jP7MJGe9b6C5aXSi+Cg/I+YaSexa0rNQR
        UVDAnn7dxbJMiG0Gfrmvm3Hbc/qcsmM436yfn65G6VclaioCK4fuoqcgQ1hKOMqmuQleTd
        T4jY9OCOaCaPK8IhNt/yq4rWxRSX4gs=
Date:   Wed, 12 Jun 2019 18:12:55 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     joro@8bytes.org, pbonzini@redhat.com, mingo@redhat.com,
        hpa@zytor.com, kvm@vger.kernel.org, syzkaller@googlegroups.com
Subject: Re: kernel BUG at arch/x86/kvm/x86.c:361! on AMD CPU
Message-ID: <20190612161255.GN32652@zn.tnic>
References: <37952f51-7687-672c-45d9-92ba418c9133@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <37952f51-7687-672c-45d9-92ba418c9133@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 30, 2019 at 02:25:23PM -0400, George Kennedy wrote:
> To arch/x86/kvm/svm.c maintainers,
> 
> Syzkaller hit this bug on an AMD CPU.
> 
> The host was running Ubuntu 18.04. The VM was running 5.2.0-rc1+

Can't trigger it here on 5.2.0-rc4+ host and guest after running it for
a half an hour.

Maybe the ubuntu host kernel is missing some fixes...

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
