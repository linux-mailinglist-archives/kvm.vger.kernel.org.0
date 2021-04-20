Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60424365FC7
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 20:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbhDTSwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 14:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbhDTSwP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 14:52:15 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4226C06174A;
        Tue, 20 Apr 2021 11:51:43 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0e52007e52f348b4f8182c.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:5200:7e52:f348:b4f8:182c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8703E1EC0322;
        Tue, 20 Apr 2021 20:51:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1618944701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=1/08QvFBESiLDZ1lDU0OA85JZLqZemtdYwP+q1CI9AM=;
        b=DlpIMtrY2CbqJ9H49PMKORNw8FUSHmHHvwlMUilw97ZtLGKeK/XArShk5FJf04yfkiGXkC
        FOHmY7AwLAOsvOflMyzcL/mzxEHXOwfuD0k+zzNlZ5ciKLIEiZzn6Q1zwnP+b0Hk7O7+NV
        ejCPIj+vosrcF0Xzb0rKW+qKpwINPPA=
Date:   Tue, 20 Apr 2021 20:51:39 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v13 00/12] Add AMD SEV guest live migration support
Message-ID: <20210420185139.GI5029@zn.tnic>
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <65ebdd0c-3224-742b-d0dd-5003309d1d62@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <65ebdd0c-3224-742b-d0dd-5003309d1d62@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Paolo,

On Tue, Apr 20, 2021 at 01:11:31PM +0200, Paolo Bonzini wrote:
> I have queued patches 1-6.
> 
> For patches 8 and 10 I will post my own version based on my review and
> feedback.

can you pls push that tree up to here to a branch somewhere so that ...
 
> For guest patches, please repost separately so that x86 maintainers will
> notice them and ack them.

... I can take a look at the guest bits in the full context of the
changes?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
