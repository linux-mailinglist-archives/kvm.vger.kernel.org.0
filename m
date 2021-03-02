Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE57332A6D0
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448953AbhCBPwe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:52:34 -0500
Received: from mga04.intel.com ([192.55.52.120]:29018 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239662AbhCBAfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 19:35:04 -0500
IronPort-SDR: +5S460RINKlMSk9d8lc8f8fjseZUfMVxdXWamCDzuMvjiB95H8vJJtaKiUISat76zNvwBBR2tL
 hbk0yuKAl8TQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="184202209"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="184202209"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 16:34:11 -0800
IronPort-SDR: wm68+FVE8fzTcwP9ORFXnGnBOjQIQpWxBr0qaCMzAxMqvx/ooSqFxg792i2nT5eSqem/BTBqhp
 /uMKKdBmUCeA==
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427144573"
Received: from yueliu2-mobl.amr.corp.intel.com ([10.252.139.111])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 16:34:03 -0800
Message-ID: <4f12b97a49f5803af06b8a8be36d8c45094a5ab1.camel@intel.com>
Subject: Re: [PATCH 09/25] x86/sgx: Move ENCLS leaf definitions to sgx.h
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Date:   Tue, 02 Mar 2021 13:34:00 +1300
In-Reply-To: <YD0VbJ1fUoZmt4Ca@google.com>
References: <cover.1614590788.git.kai.huang@intel.com>
         <e8eb1ac6272ef7698ce6fbdc43e43bf38f25c494.1614590788.git.kai.huang@intel.com>
         <YD0VbJ1fUoZmt4Ca@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-03-01 at 08:25 -0800, Sean Christopherson wrote:
> On Mon, Mar 01, 2021, Kai Huang wrote:
> > And because they're architectural.
> 
> Heh, this snarky sentence can be dropped, it was a lot more clever when these
> were being moved to sgx_arch.h.

Sure. Reasonable to me.

> 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Acked-by: Dave Hansen <dave.hansen@intel.com>
> > Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/include/asm/sgx.h      | 15 +++++++++++++++
> >  arch/x86/kernel/cpu/sgx/encls.h | 15 ---------------
> >  2 files changed, 15 insertions(+), 15 deletions(-)


