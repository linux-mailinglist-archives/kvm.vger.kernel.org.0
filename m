Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20A69E7DD
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 18:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfD2QgG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 12:36:06 -0400
Received: from mail.skyhub.de ([5.9.137.197]:38380 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728520AbfD2QgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Apr 2019 12:36:05 -0400
Received: from zn.tnic (p200300EC2F073600329C23FFFEA6A903.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:3600:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B87D01EC027B;
        Mon, 29 Apr 2019 18:36:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1556555763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=fismiO90X9ow0flqEFvKG4xZhSvKMbYdUPumKyUhM9Q=;
        b=HIYiXKVApvDpTbHt+PlhAFHoIKD7hjuzVMbirqjxzgyuu3MmYXciLwQeByWfBXIi8n7ZGG
        JmqEiMLFwgc5z7qaUypuJWTpYU3D/FWlSEOzl2WFSZfumc32qPYes0/yxrryhUSKtuex8Y
        eN+dlETiFUgSwoU/eKGsdygENq9nAQY=
Date:   Mon, 29 Apr 2019 18:36:02 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 01/10] KVM: SVM: Add KVM_SEV SEND_START command
Message-ID: <20190429163602.GE2324@zn.tnic>
References: <20190424160942.13567-1-brijesh.singh@amd.com>
 <20190424160942.13567-2-brijesh.singh@amd.com>
 <20190426141042.GF4608@zn.tnic>
 <e6f8da38-b8dd-a9c5-a358-5f33b6ea7b37@amd.com>
 <20190426204327.GM4608@zn.tnic>
 <2b63d983-a622-3bec-e6ac-abfd024e19c0@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2b63d983-a622-3bec-e6ac-abfd024e19c0@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 29, 2019 at 03:01:24PM +0000, Singh, Brijesh wrote:
> Practically I don't see any reason why caller would do that but
> theoretically it can. If we cache the len then we also need to consider
> adding another flag to hint whether userspace ever requested length.
> e.g an application can compute the length of session blob by looking at
> the API version and spec and may never query the length.
> 
> > I mean I'm still thinking defensively here but maybe the only thing that
> > would happen here with a bigger buffer is if the kmalloc() would fail,
> > leading to eventual failure of the migration.
> > 
> > If the code limits the allocation to some sane max length, the migration
> > won't fail even if userspace gives it too big values...

So what about this? Limiting to a sane length...

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
