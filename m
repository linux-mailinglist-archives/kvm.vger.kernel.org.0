Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C2C229EB5
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 19:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729830AbgGVRpk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 13:45:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:47250 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgGVRpj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 13:45:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9CB3EACBD;
        Wed, 22 Jul 2020 17:45:45 +0000 (UTC)
Date:   Wed, 22 Jul 2020 19:45:35 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Erdem Aktas <erdemaktas@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 00/75] x86: SEV-ES Guest Support
Message-ID: <20200722174535.GJ6132@suse.de>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200715092456.GE10769@hirez.programming.kicks-ass.net>
 <20200715093426.GK16200@suse.de>
 <20200715095556.GI10769@hirez.programming.kicks-ass.net>
 <20200715101034.GM16200@suse.de>
 <CAAYXXYxJf8sr6fvbZK=t6o_to4Ov_yvZ91Hf6ZqQ-_i-HKO2VA@mail.gmail.com>
 <20200721124957.GD6132@suse.de>
 <CAAYXXYwVV_g8pGL52W9vxkgdNxg1dNKq_OBsXKZ_QizdXiTx2g@mail.gmail.com>
 <20200722090442.GI6132@suse.de>
 <CAAYXXYxRzO+hFvge4sKvNyH64iW9N2eLNbbKOR2DZf0DDL6CUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAYXXYxRzO+hFvge4sKvNyH64iW9N2eLNbbKOR2DZf0DDL6CUw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 22, 2020 at 09:54:40AM -0700, Erdem Aktas wrote:
> I am using a custom, optimized and stripped down version, OVMF build.
> Do you think it is because of the OVMF or grub?

Not sure, I havn't looked into how grub decides which entry point to
use.

> In my case, there are 2 places where the CPUID is called: the first
> one is to decide if long mode is supported, along with few other
> features like SSE support and the second one is to retrieve the
> encryption bit location.

Yes, it is basically the verify_cpu() function that is causing the
trouble. If you want to work around it you can comment it out in that
path for testing purposes.

Regards,

	Joerg

