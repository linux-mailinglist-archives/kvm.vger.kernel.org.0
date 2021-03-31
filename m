Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BCE34F941
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 08:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbhCaGwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 02:52:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:32931 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233801AbhCaGvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 02:51:44 -0400
IronPort-SDR: nT8LELN3J8FAXvFlH/4IFBdY0MQjkci5evUlIgUeLdxbzudcj8Heo4626yNw0duArmBBqpqx5R
 ss0NEUx0PsjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="188671798"
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="188671798"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 23:51:44 -0700
IronPort-SDR: iW1q8JeezhyiUx+5NiGB4Y/MpMVn6fxdop4H0aMl8EVidsEQMkTEu3WTOsNdV5Gy5Jl6bYl5zw
 5ZJFeX3zcRmg==
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="527648485"
Received: from mwamucix-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.24.224])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 23:51:40 -0700
Date:   Wed, 31 Mar 2021 19:51:38 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Boris Petkov <bp@alien8.de>
Cc:     seanjc@google.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        jarkko@kernel.org, luto@kernel.org, dave.hansen@intel.com,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH v3 05/25] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-Id: <20210331195138.2af97ec1bb4b5e4202f2600d@intel.com>
In-Reply-To: <D4ECF8D3-C483-4E75-AD41-2CEFDF56B12D@alien8.de>
References: <cover.1616136307.git.kai.huang@intel.com>
        <0c38ced8c8e5a69872db4d6a1c0dabd01e07cad7.1616136308.git.kai.huang@intel.com>
        <20210326150320.GF25229@zn.tnic>
        <20210331141032.db59586da8ba2cccf7b46f77@intel.com>
        <D4ECF8D3-C483-4E75-AD41-2CEFDF56B12D@alien8.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 Mar 2021 08:44:23 +0200 Boris Petkov wrote:
> On March 31, 2021 3:10:32 AM GMT+02:00, Kai Huang <kai.huang@intel.com> wrote: 
> 
> > The admin will be aware of
> >such EPC
> >allocation disjoint situation, and deploy host enclaves/KVM SGX guests
> >accordingly.
> 
> The admin will be aware because...
> 
> 1) he's following our discussion?
> 
> 2) he'll read the commit messages and hopefully understand?
> 
> 3) we *actually* have documentation somewhere explaining how we envision that stuff to be used?
> 
> Or none of the above and he'll end up doing whatever and then he'll eventually figure out that we don't support that use case but he's doing it already anyway and we don't break userspace so we have to support it now and we're stuck somewhere between a rock and a hard place?
> 
> Hmm, I think we have enough misguided use cases as it is - don't need another one.

How about adding explanation to Documentation/x86/sgx.rst?
