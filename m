Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4289424BA82
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 14:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgHTMKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 08:10:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:48346 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728925AbgHTMKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 08:10:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DDDCEAC23;
        Thu, 20 Aug 2020 12:10:58 +0000 (UTC)
Date:   Thu, 20 Aug 2020 14:10:29 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Mike Stunes <mstunes@vmware.com>
Cc:     Joerg Roedel <joro@8bytes.org>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v5 00/75] x86: SEV-ES Guest Support
Message-ID: <20200820121029.GD3354@suse.de>
References: <20200724160336.5435-1-joro@8bytes.org>
 <B65392F4-FD42-4AA3-8AA8-6C0C0D1FF007@vmware.com>
 <20200730122645.GA3257@8bytes.org>
 <F5603CBB-31FB-4EE8-B67A-A1F2DBEE28D8@vmware.com>
 <20200818150746.GA3319@8bytes.org>
 <6F9275F4-D5A4-4D30-8729-A57989568CA7@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6F9275F4-D5A4-4D30-8729-A57989568CA7@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mike,

On Thu, Aug 20, 2020 at 12:58:13AM +0000, Mike Stunes wrote:
> Yes, I still see the issue — APs are offline after boot. I’ll spend
> some time seeing if I can figure out what the problem is. Thanks!

Thanks. I think the first step here would be to find out where on the
APs (which RIP) the first #VC exception happens. I guess in the #VC
entry code it triggers the next exception when trying to execute the
fsgsbase instructions.

Regards,

	Joerg
