Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F12352A30
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 13:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbhDBLWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 07:22:39 -0400
Received: from mail.skyhub.de ([5.9.137.197]:44384 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhDBLWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 07:22:39 -0400
Received: from zn.tnic (p200300ec2f0a2000d08570fd96272a9c.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:2000:d085:70fd:9627:2a9c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C9B491EC04C2;
        Fri,  2 Apr 2021 13:22:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617362556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=XNJt2Jt+xM+DSW82BdVmvQI5O4/vZHzsbF5tnI5RPtE=;
        b=b/4fkw1pYEcD57bfSztxDerHvkWeDb9CAeH9a/pVGbP4K0Zq295yEWeGGGdhjaJZe+mMdv
        +4ONt+N8EcwKReVAfRrr/Ix+3oV0nnAiYRIAGdFmU1o2ezpNgTCBTMB0veQkVNLTKj0RUP
        b2SrW5mY7sZKgaFRw+7HgwajEUPkIjA=
Date:   Fri, 2 Apr 2021 13:22:35 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 07/25] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <20210402112235.GF28499@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <d35d17a02bbf8feef83a536cec8b43746d4ea557.1616136308.git.kai.huang@intel.com>
 <20210402094816.GC28499@zn.tnic>
 <20210403000810.93638fb4b468ab28faaf11fd@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210403000810.93638fb4b468ab28faaf11fd@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 03, 2021 at 12:08:10AM +1300, Kai Huang wrote:
> Do you want me to send updated patch?

No need. If I do, I'll ask kindly, otherwise you don't have to do
anything.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
