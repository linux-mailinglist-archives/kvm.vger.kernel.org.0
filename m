Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B048B42B953
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 09:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238594AbhJMHkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 03:40:49 -0400
Received: from mail.skyhub.de ([5.9.137.197]:60854 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238584AbhJMHko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 03:40:44 -0400
Received: from zn.tnic (p200300ec2f0ce200d6cfbc8b4a6526d3.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:e200:d6cf:bc8b:4a65:26d3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3A1D81EC0295;
        Wed, 13 Oct 2021 09:38:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634110720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=njSyXwVusHuX6wt5kubdslRQRkmoPZmU+9aLX9g4MD8=;
        b=kv62qMJSQ8hV2x+h4AxvtOmwSureaRDEPZs5rzaVcdZYkQCCGSRGjCx4EEyC05wdwfEmoi
        h1e7aKGibHzNv25tsqUJ20qjC0/EFO+Qg4bLPWY7g0y5cwi4inknvvD0jIZNvi5+F9WnV9
        WauHkvTNsBJz5m3094l6bcWJlU6DoSc=
Date:   Wed, 13 Oct 2021 09:38:38 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@linux.intel.com, seanjc@google.com, x86@kernel.org,
        yang.zhong@intel.com, jarkko@kernel.org
Subject: Re: [PATCH v2 0/2] x86: sgx_vepc: implement ioctl to EREMOVE all
 pages
Message-ID: <YWaM/nwTemct0zVJ@zn.tnic>
References: <20211012105708.2070480-1-pbonzini@redhat.com>
 <YWaCu2Us+H+BSbYW@zn.tnic>
 <a99ed8a3-249d-5cf5-1567-56c4014678f1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a99ed8a3-249d-5cf5-1567-56c4014678f1@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021 at 09:15:27AM +0200, Paolo Bonzini wrote:
> No, I mean 5.15 because it literally cannot break anything that was working
> previously and the functionality provided by the ioctl (resetting VMs) is
> important.  But it wouldn't be a big issue if it was 5.16 only.

Ok, lemme queue it for 5.16 then.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
