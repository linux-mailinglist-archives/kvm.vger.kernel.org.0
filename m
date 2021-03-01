Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05011327C6B
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 11:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbhCAKln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 05:41:43 -0500
Received: from mga04.intel.com ([192.55.52.120]:50296 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234619AbhCAKlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 05:41:04 -0500
IronPort-SDR: Rk9q/8hRGf7VkeAatb2r8/M67bXf7/ftm6qI2u/ebKzIzxHNvsSSeIDOl4WGgHbJ86lrLMzV1q
 3IIQLWg3bWtg==
X-IronPort-AV: E=McAfee;i="6000,8403,9909"; a="183979510"
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="183979510"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 02:40:08 -0800
IronPort-SDR: GaiOkz5gyJCKZ91ddRGKNhnOfqGp7mrCPkU/lbJiKrSN64P232mI2W5THs8rmY6qLwNKbSNRJ8
 H6dGUCRlxDhw==
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="368557579"
Received: from jscomeax-mobl.amr.corp.intel.com ([10.252.139.76])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 02:40:05 -0800
Message-ID: <7603ef673997b6674f785d333a4f263c749d2cf3.camel@intel.com>
Subject: Re: [PATCH 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Date:   Mon, 01 Mar 2021 23:40:02 +1300
In-Reply-To: <20210301103043.GB6699@zn.tnic>
References: <cover.1614590788.git.kai.huang@intel.com>
         <bbfc8c833a62e4b55220834320829df1e17aff41.1614590788.git.kai.huang@intel.com>
         <20210301100037.GA6699@zn.tnic>
         <3fce1dd2abd42597bde7ae9496bde7b9596b2797.camel@intel.com>
         <20210301103043.GB6699@zn.tnic>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-03-01 at 11:30 +0100, Borislav Petkov wrote:
> On Mon, Mar 01, 2021 at 11:19:15PM +1300, Kai Huang wrote:
> > "sgx2" is useful because it adds additional functionality.
> 
> Useful for what?

SGX2 means "Enclave Dynamic Memory Management", which supports dynamically
adding/removing EPC pages, plus changing page permission, after enclave is
initialized. So it allows enclave author to write enclave in more flexible way, and
also utilize EPC resource more efficiently.

> 
> People have got to start explaining "why" something is useful and put
> that "why" in the commit message.
> 

Yes I can add "why" into commit message, but isn't the comment after X86_FEATURE_SGX2
enough? I think people who are interested in SGX will know what SGX2 is and why SGX2
is useful.

