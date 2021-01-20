Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7592FC600
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 01:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbhATAnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 19:43:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:60845 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbhATAm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 19:42:58 -0500
IronPort-SDR: 3LwUqUeGBBvSrfKCE9bHGzWuWMaZXbk0/HgFZeYMhnWh5YCYHK2fz7QQA3qlUvErB5hPD7BFF3
 JtTtangYrRCA==
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="166114562"
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="166114562"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 16:42:15 -0800
IronPort-SDR: +jV1jCLkHO6vYTcEz8qLu1kTqf974GR/oEO7Y11RPAcC5nuV/PESPHKHMbQBQ9LS/2uQYbRA47
 YgMwpM8xnEFw==
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="384151957"
Received: from hzhan36-mobl.amr.corp.intel.com ([10.251.22.237])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 16:42:11 -0800
Message-ID: <04624eb0a4cb0ea091ad9f2c0ba8ac3ad5411c89.camel@intel.com>
Subject: Re: [RFC PATCH v2 02/26] x86/sgx: Remove a warn from
 sgx_free_epc_page()
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Date:   Wed, 20 Jan 2021 13:42:09 +1300
In-Reply-To: <YAaZIdxQFHA1XdW4@kernel.org>
References: <cover.1610935432.git.kai.huang@intel.com>
         <85da2c1ce068b77ee9f31f6de9f3a34c36c410eb.1610935432.git.kai.huang@intel.com>
         <YAaZIdxQFHA1XdW4@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-01-19 at 10:32 +0200, Jarkko Sakkinen wrote:
> On Mon, Jan 18, 2021 at 04:26:50PM +1300, Kai Huang wrote:
> > From: "jarkko@kernel.org" <jarkko@kernel.org>
>         ~~~~~~~~~~~~~~~~~~~
>         Jarkko Sakkinen
> 
> > Remove SGX_EPC_PAGE_RECLAIMER_TRACKED check and warning.  This cannot
> > happen, as enclave pages are freed only at the time when encl->refcount
> > triggers, i.e. when both VFS and the page reclaimer have given up on
> > their references.
> > 
> > Signed-off-by: jarkko@kernel.org <jarkko@kernel.org>
>                  ~~~~~~~~~~~~~~~~~
>                  Jarkko Sakkinen
> 
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> 
> Sorry about this. I was reconfiguring my environment (or actually was
> moving it to another machine), and forgot to set user.name. I'll send you
> in private replacements with a legit name.

Sure. No problem. Thanks.




