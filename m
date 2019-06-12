Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1106043071
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 21:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbfFLTwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 15:52:02 -0400
Received: from mail.skyhub.de ([5.9.137.197]:49394 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbfFLTwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 15:52:02 -0400
Received: from zn.tnic (p200300EC2F0A6800329C23FFFEA6A903.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:6800:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B4B7C1EC0997;
        Wed, 12 Jun 2019 21:52:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1560369121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=GUepEpOvj47QrSQxWDV4sX7Wy3tb1AdwOgkXN4qPVac=;
        b=f/V1Sd+xOmD2rwK5mJf0v6+ZrcG5V3EwY3c5Vft+DHZgc+aIt7T35D8xQpPIwFsVGAI48r
        tcBaOL/eWzz5/1SH9Gwt+8CdoA+INSu1VQb6FS1TOvrU6F2xEryBq74hmvQBWngMb9f/x/
        2mKogbU2H5E+W3VYoinET3PppTxVSlA=
Date:   Wed, 12 Jun 2019 21:51:52 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     joro@8bytes.org, pbonzini@redhat.com, mingo@redhat.com,
        hpa@zytor.com, kvm@vger.kernel.org, syzkaller@googlegroups.com
Subject: Re: kernel BUG at arch/x86/kvm/x86.c:361! on AMD CPU
Message-ID: <20190612195152.GQ32652@zn.tnic>
References: <37952f51-7687-672c-45d9-92ba418c9133@oracle.com>
 <20190612161255.GN32652@zn.tnic>
 <af0054d1-1fc8-c106-b503-ca91da5a6fee@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <af0054d1-1fc8-c106-b503-ca91da5a6fee@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 12, 2019 at 02:45:34PM -0400, George Kennedy wrote:
> The crash can still be reproduced with VM running Upstream 5.2.0-rc4 

That's clear.

> and host running Ubuntu on AMD CPU.

That's the important question: why can't I trigger it with 5.2.0-rc4+ as
the host and you can with the ubuntu kernel 4.15 or so. I.e., what changed
upstream or does the ubuntu kernel have out-of-tree stuff?

Maybe kvm folks would have a better idea. That kvm_spurious_fault thing
is for:

/*
 * Hardware virtualization extension instructions may fault if a
 * reboot turns off virtualization while processes are running.
 * Trap the fault and ignore the instruction if that happens.
 */
asmlinkage void kvm_spurious_fault(void);

but you're not rebooting...

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
