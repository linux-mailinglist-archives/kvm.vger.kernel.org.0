Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9898327DDF
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 13:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhCAMJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 07:09:18 -0500
Received: from mga12.intel.com ([192.55.52.136]:45440 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232806AbhCAMJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 07:09:16 -0500
IronPort-SDR: eJYIWi8s7yqcreM+DdFJW/oj1gy6OJFeM1evRzN7rFD49ki43uH6giuKs44x9U3vuHe9ZEGjOp
 gQxRGl3xhzfw==
X-IronPort-AV: E=McAfee;i="6000,8403,9909"; a="165674457"
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="165674457"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 04:08:31 -0800
IronPort-SDR: x2LYCeO81ERh0Y8qbWt3KswwfQRQelD3R1rr4l0w2buEGtLkjAAWeL1Y+Z/2MvazMKFsxHDYuV
 jdMLjzJU5PFg==
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="368580584"
Received: from sanand-mobl.amr.corp.intel.com ([10.251.13.183])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 04:08:27 -0800
Message-ID: <66f1f4e39de4314f9c1b7a6d7cd6914e42a20217.camel@intel.com>
Subject: Re: [PATCH 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Date:   Tue, 02 Mar 2021 01:08:25 +1300
In-Reply-To: <20210301115854.GE6699@zn.tnic>
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
         <20210301115854.GE6699@zn.tnic>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-03-01 at 12:58 +0100, Borislav Petkov wrote:
> On Tue, Mar 02, 2021 at 12:43:06AM +1300, Kai Huang wrote:
> > To confirm, if we suppress both "sgx1" and "sgx2" in /proc/cpuinfo, we
> > don't need to add "why to suppress" in commit message, right?
> 
> You should always explain in a patch why you're doing the change. So
> that a reviewer knows. And then people in the future can follow why
> you've made that decision. Always.

Got it. Thanks.


