Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F6015F6F9
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 20:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388324AbgBNTkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 14:40:37 -0500
Received: from mga05.intel.com ([192.55.52.43]:59394 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729633AbgBNTkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 14:40:37 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 11:40:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,441,1574150400"; 
   d="scan'208";a="238451500"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by orsmga006.jf.intel.com with ESMTP; 14 Feb 2020 11:40:36 -0800
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id B9EC13018B1; Fri, 14 Feb 2020 11:40:36 -0800 (PST)
From:   Andi Kleen <ak@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 08/62] x86/boot/compressed/64: Add IDT Infrastructure
References: <20200211135256.24617-1-joro@8bytes.org>
        <20200211135256.24617-9-joro@8bytes.org>
Date:   Fri, 14 Feb 2020 11:40:36 -0800
In-Reply-To: <20200211135256.24617-9-joro@8bytes.org> (Joerg Roedel's message
        of "Tue, 11 Feb 2020 14:52:02 +0100")
Message-ID: <87k14p5557.fsf@linux.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Joerg Roedel <joro@8bytes.org> writes:
> +	addq    $8, %rsp
> +
> +	/*
> +	 * Make sure we return to __KERNEL_CS - the CS selector on
> +	 * the IRET frame might still be from an old BIOS GDT
> +	 */
> +	movq	$__KERNEL_CS, 8(%rsp)

This doesn't make sense. Either it's running on the correct CS
before the exception or not. Likely there's some other problem
here that you patched over with this hack.

-Andi
