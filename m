Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5687C42B816
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 08:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238181AbhJMG5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 02:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238165AbhJMG45 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 02:56:57 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF4DC061570;
        Tue, 12 Oct 2021 23:54:55 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0ce200d6cfbc8b4a6526d3.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:e200:d6cf:bc8b:4a65:26d3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 117BB1EC0295;
        Wed, 13 Oct 2021 08:54:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634108092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=p04VCTzFvUn3mYJD4pdT22xbIu9DApWJKxw8y3+hnfA=;
        b=fYVjvVM4ahC5dWIK0i6xUX61Dc2KqkARFVgcHIYOALs0yB6hZX2nBWEQZl2df0h96jqWM8
        gTMZtjjjCpNCvZw4z4qymwvUI4WX6Si/QVtDRHC3TFMqayXFY66/IOj2rmMeU7v1zfDTse
        1J24JQDlFxiX2NzSqPATQaPdp6MJyv8=
Date:   Wed, 13 Oct 2021 08:54:51 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@linux.intel.com, seanjc@google.com, x86@kernel.org,
        yang.zhong@intel.com, jarkko@kernel.org
Subject: Re: [PATCH v2 0/2] x86: sgx_vepc: implement ioctl to EREMOVE all
 pages
Message-ID: <YWaCu2Us+H+BSbYW@zn.tnic>
References: <20211012105708.2070480-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211012105708.2070480-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12, 2021 at 06:57:06AM -0400, Paolo Bonzini wrote:
> If possible, I would like these patches to be included in 5.15 through
> either the x86 or the KVM tree.

You mean here 5.16, right?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
