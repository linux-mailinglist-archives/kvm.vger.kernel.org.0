Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6350494578
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 02:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344371AbiATBT1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 20:19:27 -0500
Received: from mga12.intel.com ([192.55.52.136]:30865 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344114AbiATBTZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 20:19:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642641565; x=1674177565;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A4MPUh9GXgjVKWatkIRWK6YEFxJhxOztspGnCiWhkEM=;
  b=KVWXtl/K7c67DD4bEWchOkj9rJKiR/rrEzTQF59FN5emz3wgwS4rxPod
   jz2yPSxAaP8iH7E2p1lZLq9AJGE8fRaRejGLr0pCPnLNXiZ4XbAXH1dPo
   jRMHpm9tqrSzGJXwmn0++FgpBw0gupD1ZJZu/uHWNbdFCifBN8jgEvNJI
   Jbx3PuZ2pZnBJ6/aMIAhC5w8/YsQfzaESgVSUzyOBKuKtrxoZ+dI2TmBo
   13mWBgmDajNNTVRfPIAVTGB2lT4aLuPx2VwEYhrpzViOVuZWaqw+yCK8R
   KdmALWzGKw04RqTbLAsdUMNmp90EK07gQC79cs19bgL2RtPPB/suec39x
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="225222995"
X-IronPort-AV: E=Sophos;i="5.88,301,1635231600"; 
   d="scan'208";a="225222995"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 17:19:24 -0800
X-IronPort-AV: E=Sophos;i="5.88,301,1635231600"; 
   d="scan'208";a="532561347"
Received: from yangzhon-virtual.bj.intel.com (HELO yangzhon-Virtual) ([10.238.145.56])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 19 Jan 2022 17:19:23 -0800
Date:   Thu, 20 Jan 2022 09:04:05 +0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, yang.zhong@intel.com
Subject: Re: [PATCH 0/2] kvm selftest cleanup
Message-ID: <20220120010405.GA26825@yangzhon-Virtual>
References: <20220118140144.58855-1-yang.zhong@intel.com>
 <990cf64b-1515-df67-5691-fd45c71abc3a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <990cf64b-1515-df67-5691-fd45c71abc3a@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 19, 2022 at 07:35:05PM +0100, Paolo Bonzini wrote:
> On 1/18/22 15:01, Yang Zhong wrote:
> >Patch 1 to sync KVM_CAP_XSAVE2 to 208, and patch 2 only cleanup
> >processor.c file with tabs as Sean requested before. Those two
> >patches were based on latest Linux release(commit id: e3a8b6a1e70c).
> >
> >Yang Zhong (2):
> >   kvm: selftests: Sync KVM_CAP_XSAVE2 from linux header
> >   kvm: selftests: Use tabs to replace spaces
> >
> >  tools/include/uapi/linux/kvm.h                |  2 +-
> >  .../selftests/kvm/lib/x86_64/processor.c      | 70 +++++++++----------
> >  2 files changed, 36 insertions(+), 36 deletions(-)
> >
> 
> Hi,
> 
> I sent a slightly more complete version of both patches.
>

  Thanks Paolo, :).

  Yang
 
> Thanks,
> 
> Paolo
