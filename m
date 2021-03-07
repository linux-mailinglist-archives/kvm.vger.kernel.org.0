Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3FA330512
	for <lists+kvm@lfdr.de>; Sun,  7 Mar 2021 23:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbhCGWuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Mar 2021 17:50:16 -0500
Received: from mga07.intel.com ([134.134.136.100]:48931 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230341AbhCGWuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Mar 2021 17:50:03 -0500
IronPort-SDR: idmNM8PHrrPE7S0CUQs1imn2m9Hef9vWn2GxtGdIKUwckAK6Hw8Uk5DSG4dDucVBUpCm4g2QJf
 ZH5maHoxJ98Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="251963195"
X-IronPort-AV: E=Sophos;i="5.81,231,1610438400"; 
   d="scan'208";a="251963195"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2021 14:50:02 -0800
IronPort-SDR: t2TgmVgIRzyCY1eaGBDsNyFb86KvKjYMEPvb4sXTI7WgGA6ou91hu1D/wvrfFWXhRpmexM3YlI
 LUMqFt4tCZ3Q==
X-IronPort-AV: E=Sophos;i="5.81,231,1610438400"; 
   d="scan'208";a="402595373"
Received: from ggkanher-mobl4.amr.corp.intel.com ([10.252.142.177])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2021 14:49:58 -0800
Message-ID: <df1986285d014837dce015003e3c2d5675c891bd.camel@intel.com>
Subject: Re: [PATCH 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Date:   Mon, 08 Mar 2021 11:49:43 +1300
In-Reply-To: <22f8a4be-b0ec-dfc5-cf05-a2586ce7557c@intel.com>
References: <cover.1614590788.git.kai.huang@intel.com>
         <bbfc8c833a62e4b55220834320829df1e17aff41.1614590788.git.kai.huang@intel.com>
         <20210301100037.GA6699@zn.tnic>
         <3fce1dd2abd42597bde7ae9496bde7b9596b2797.camel@intel.com>
         <20210301103043.GB6699@zn.tnic>
         <7603ef673997b6674f785d333a4f263c749d2cf3.camel@intel.com>
         <20210301105346.GC6699@zn.tnic>
         <e509c6c1e3644861edafb18e4045b813f9f344b3.camel@intel.com>
         <20210301113257.GD6699@zn.tnic>
         <0adc41774945bf9d6e6a72a93b83c80aa8c59544.camel@intel.com>
         <op.0zmwm1ogwjvjmi@arkane-mobl1.gar.corp.intel.com>
         <22f8a4be-b0ec-dfc5-cf05-a2586ce7557c@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-03-02 at 07:58 -0800, Dave Hansen wrote:
> On 3/2/21 7:48 AM, Haitao Huang wrote:
> > 
> > Hi Haitao, Jarkko,
> > 
> > Do you have more concrete use case of needing "sgx2" in /proc/cpuinfo?
> 
> Kai, please remove it from your series.  I'm not hearing any arguments
> remotely close enough to what Boris would require in order to keep it.

Yes I will do. Thanks.

