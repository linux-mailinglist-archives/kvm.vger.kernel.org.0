Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCEC366DBE
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 16:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbhDUOJ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 10:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235556AbhDUOJz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 10:09:55 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898E9C06174A;
        Wed, 21 Apr 2021 07:09:22 -0700 (PDT)
Received: from zn.tnic (p200300ec2f10df00c08862b6cef04697.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:df00:c088:62b6:cef0:4697])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 21E941EC0472;
        Wed, 21 Apr 2021 16:09:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1619014161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ZfkIEoLCYYeqT0DWvC4dbCTLP4x3C4Fg9fPx42gHBKQ=;
        b=orAHDPFS/VWptFN2+wwRZTWP+yAMRVZZfOBIIaNLP3aZnzNVjyxMeQhUBZj7Ba9DFQKYzj
        K24i9W6oYEaIDx+gJBLGq8+vA654XyfybcB9NqV84BoyjH1SjMRQLFkorH+NciS/wRoIK0
        sPK1vfoHdNNaAlD2j6fHIXFw8nm2DN4=
Date:   Wed, 21 Apr 2021 16:09:18 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v13 09/12] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <20210421140918.GA5004@zn.tnic>
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <f2340642c5b8d597a099285194fca8d05c9843bd.1618498113.git.ashish.kalra@amd.com>
 <20210421100508.GA11234@zn.tnic>
 <f63735b4-8ec2-fdb4-0bac-8ee0921268b0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f63735b4-8ec2-fdb4-0bac-8ee0921268b0@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021 at 02:00:42PM +0200, Paolo Bonzini wrote:
> The words are right but the order is wrong (more like "hypercall to set some
> memory's encrypted/decrypted state").  Perhaps?
> kvm_hypercall_set_page_enc_status.

Yap.

> page_encryption_changed does not sound bad to me though, it's a
> notification-like function name. Maybe notify_page_enc_status_changed?

Yap again. Those are better.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
