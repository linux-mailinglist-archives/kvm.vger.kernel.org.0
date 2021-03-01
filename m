Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64098327D77
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 12:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbhCALn4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 06:43:56 -0500
Received: from mga06.intel.com ([134.134.136.31]:24176 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233784AbhCALny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 06:43:54 -0500
IronPort-SDR: BxYUPim6W4doxxudPHHFJghO/bncfnLEH3jRIlmTjd5aXILMbmFiSng/yisu+2o4j4ykt79iRU
 skG1PJYcd0aA==
X-IronPort-AV: E=McAfee;i="6000,8403,9909"; a="247845143"
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="247845143"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 03:43:12 -0800
IronPort-SDR: wIUzBrdcqZC5vNIMvqSOcoDLuV5Xjyea8BQMKuyuexXycz5IvGu77L9NlgDlL2cqvSf0FE0b4z
 PAljjsFc2rrQ==
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="405653458"
Received: from sanand-mobl.amr.corp.intel.com ([10.251.13.183])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 03:43:09 -0800
Message-ID: <0adc41774945bf9d6e6a72a93b83c80aa8c59544.camel@intel.com>
Subject: Re: [PATCH 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Date:   Tue, 02 Mar 2021 00:43:06 +1300
In-Reply-To: <20210301113257.GD6699@zn.tnic>
References: <cover.1614590788.git.kai.huang@intel.com>
         <bbfc8c833a62e4b55220834320829df1e17aff41.1614590788.git.kai.huang@intel.com>
         <20210301100037.GA6699@zn.tnic>
         <3fce1dd2abd42597bde7ae9496bde7b9596b2797.camel@intel.com>
         <20210301103043.GB6699@zn.tnic>
         <7603ef673997b6674f785d333a4f263c749d2cf3.camel@intel.com>
         <20210301105346.GC6699@zn.tnic>
         <e509c6c1e3644861edafb18e4045b813f9f344b3.camel@intel.com>
         <20210301113257.GD6699@zn.tnic>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-03-01 at 12:32 +0100, Borislav Petkov wrote:
> On Tue, Mar 02, 2021 at 12:28:27AM +1300, Kai Huang wrote:
> > I think some script can utilize /proc/cpuinfo. For instance, admin can have
> > automation tool/script to deploy enclave (with sgx2) apps, and that script can check
> > whether platform supports sgx2 or not, before it can deploy those enclave apps. Or
> > enclave author may just want to check /proc/cpuinfo to know whether the machine can
> > be used for testing sgx2 enclave or not.
> 
> This doesn't sound like a concrete use of this. So you can hide it
> initially with "" until you guys have a use case. Exposing it later is
> always easy vs exposing it now and then not being able to change it
> anymore.
> 

Hi Haitao, Jarkko,

Do you have more concrete use case of needing "sgx2" in /proc/cpuinfo?

Hi Boris,

To confirm, if we suppress both "sgx1" and "sgx2" in /proc/cpuinfo, we don't need to
add "why to suppress" in commit message, right?


