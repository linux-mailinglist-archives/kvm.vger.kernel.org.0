Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CFD1F6547
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 12:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgFKKDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 06:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbgFKKDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 06:03:20 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B23C08C5C1;
        Thu, 11 Jun 2020 03:03:20 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 3A161869; Thu, 11 Jun 2020 12:03:13 +0200 (CEST)
Date:   Thu, 11 Jun 2020 12:03:10 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 25/75] x86/sev-es: Add support for handling IOIO
 exceptions
Message-ID: <20200611100310.GA32093@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-26-joro@8bytes.org>
 <20200520062055.GA17090@linux.intel.com>
 <20200603142325.GB23071@8bytes.org>
 <20200603230716.GD25606@linux.intel.com>
 <20200604101502.GA20739@8bytes.org>
 <20200604145932.GB30223@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604145932.GB30223@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 04, 2020 at 07:59:33AM -0700, Sean Christopherson wrote:
> But SEV already broke it, no?

True, but with SEV-ES is can be fixed again, and all SEV hardware also
supports SEV-ES.

Regards,

	Joerg
