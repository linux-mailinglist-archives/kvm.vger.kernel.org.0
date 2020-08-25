Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D14251208
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 08:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbgHYGY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 02:24:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:39740 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726940AbgHYGY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 02:24:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A98B5AC23;
        Tue, 25 Aug 2020 06:24:57 +0000 (UTC)
Date:   Tue, 25 Aug 2020 08:24:23 +0200
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
Subject: Re: [PATCH v6 00/76] x86: SEV-ES Guest Support
Message-ID: <20200825062423.GS3354@suse.de>
References: <20200824085511.7553-1-joro@8bytes.org>
 <D0B35ACA-7220-45DD-B524-0AFD6BE7BA3D@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D0B35ACA-7220-45DD-B524-0AFD6BE7BA3D@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mike,

On Tue, Aug 25, 2020 at 12:21:03AM +0000, Mike Stunes wrote:
> Thanks for the new update! I still see the same FSGSBASE behavior on our platform.
> 
> That is, APs come up offline; masking out either FSGSBASE or RDPID from the
> guest's CPUID results in all CPUs online.
> 
> Is that still expected with this patch set? (As you mentioned in an earlier reply,
> I’m testing on a Rome system.)

The RDPID fix (removing RDPID usage from paranoid_entry) is probably not
yet merged into the base you have been using. But removing RDPID from
CPUID should make things work until the fix is merged.

Regards,

	Joerg
