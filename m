Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE58E3338B5
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 10:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhCJJ1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 04:27:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:5514 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231650AbhCJJ1R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 04:27:17 -0500
IronPort-SDR: v0dXUVXvIRQvGhyfs+H15jwOoxyHCTe0TiIQ/gXN4aS85ktGqbZuqjz2LD7NyhW3+NrgfHYJog
 OgrCxkJxNgJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="208226165"
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="208226165"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 01:27:14 -0800
IronPort-SDR: ysRAFg8NY0/1jEIhIleol71g4qBZpKD7537pWIT8VULSCRdP286zcesNTls46sZ+//6f44BDcs
 LdtiwhriQeAQ==
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="410117039"
Received: from arashid-mobl.amr.corp.intel.com ([10.255.230.40])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 01:27:08 -0800
Message-ID: <76cb4216a7a689883c78b4622c86bd9c3faaa465.camel@intel.com>
Subject: Re: [PATCH v2 00/25] KVM SGX virtualization support
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, jethro@fortanix.com,
        b.thiel@posteo.de, jmattson@google.com, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, corbet@lwn.net
Date:   Wed, 10 Mar 2021 22:27:05 +1300
In-Reply-To: <20210309093037.GA699@zn.tnic>
References: <cover.1615250634.git.kai.huang@intel.com>
         <20210309093037.GA699@zn.tnic>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-03-09 at 10:30 +0100, Borislav Petkov wrote:
> On Tue, Mar 09, 2021 at 02:38:49PM +1300, Kai Huang wrote:
> > This series adds KVM SGX virtualization support. The first 14 patches starting
> > with x86/sgx or x86/cpu.. are necessary changes to x86 and SGX core/driver to
> > support KVM SGX virtualization, while the rest are patches to KVM subsystem.
> 
> Ok, I guess I'll queue 1-14 once Sean doesn't find anything
> objectionable then give Paolo an immutable commit to base the KVM stuff
> ontop.
> 
> Unless folks have better suggestions, ofc.
> 
> Thx.
> 

Hi Boris,

Sorry that we found a bug in below patch in series:

[PATCH v2 03/25] x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()

that I made a mistake when copying & pasting, which results in SECS page and va_page
not being freed correctly in sgx_encl_release().

Sorry for the mistake. I will send out another version with that fixed.

