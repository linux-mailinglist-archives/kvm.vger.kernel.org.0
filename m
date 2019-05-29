Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3CD2E40F
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 20:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfE2SIW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 14:08:22 -0400
Received: from mga18.intel.com ([134.134.136.126]:64735 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfE2SIW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 14:08:22 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 11:08:21 -0700
X-ExtLoop1: 1
Received: from alison-desk.jf.intel.com ([10.54.74.53])
  by fmsmga004.fm.intel.com with ESMTP; 29 May 2019 11:08:20 -0700
Date:   Wed, 29 May 2019 11:12:11 -0700
From:   Alison Schofield <alison.schofield@intel.com>
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>, linux-mm@kvack.org,
        kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 43/62] syscall/x86: Wire up a system call for MKTME
 encryption keys
Message-ID: <20190529181211.GA32533@alison-desk.jf.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-44-kirill.shutemov@linux.intel.com>
 <20190529072136.GD3656@rapoport-lnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529072136.GD3656@rapoport-lnx>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 29, 2019 at 10:21:37AM +0300, Mike Rapoport wrote:
> On Wed, May 08, 2019 at 05:44:03PM +0300, Kirill A. Shutemov wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > encrypt_mprotect() is a new system call to support memory encryption.
> > 
> > It takes the same parameters as legacy mprotect, plus an additional
> > key serial number that is mapped to an encryption keyid.
> 
> Shouldn't this patch be after the encrypt_mprotect() is added?

COND_SYSCALL(encrypt_mprotect) defined in kernel/sys_ni.c, allowed
it to build in this order, but the order is not logical. Thanks for
pointing it out. I will reorder the two patches.

Alison

