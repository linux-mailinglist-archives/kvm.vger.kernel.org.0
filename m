Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5039B40A74D
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 09:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240665AbhINHZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 03:25:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:60742 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230108AbhINHZv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 03:25:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10106"; a="209140145"
X-IronPort-AV: E=Sophos;i="5.85,292,1624345200"; 
   d="scan'208";a="209140145"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2021 00:24:34 -0700
X-IronPort-AV: E=Sophos;i="5.85,292,1624345200"; 
   d="scan'208";a="543828297"
Received: from yangzhon-virtual.bj.intel.com (HELO yangzhon-Virtual) ([10.238.144.101])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 14 Sep 2021 00:24:27 -0700
Date:   Tue, 14 Sep 2021 15:10:30 +0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, yang.zhong@intel.com
Subject: Re: [RFC/RFT PATCH 0/2] x86: sgx_vepc: implement ioctl to EREMOVE
 all pages
Message-ID: <20210914071030.GA28797@yangzhon-Virtual>
References: <20210913131153.1202354-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913131153.1202354-1-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021 at 09:11:51AM -0400, Paolo Bonzini wrote:
> Based on discussions from the previous week(end), this series implements
> a ioctl that performs EREMOVE on all pages mapped by a /dev/sgx_vepc
> file descriptor.  Other possibilities, such as closing and reopening
> the device, are racy.
> 
> The patches are untested, but I am posting them because they are simple
> and so that Yang Zhong can try using them in QEMU.
> 

  Paolo, i re-implemented one reset patch in the Qemu side to call this ioctl(),
  and did some tests on Windows and Linux guest, the Windows/Linux guest reboot 
  work well.

  So, it is time for me to send this reset patch to Qemu community? or wait for
  this kernel patchset merged? thanks! 
     
  Yang


> Paolo
> 
> Paolo Bonzini (2):
>   x86: sgx_vepc: extract sgx_vepc_remove_page
>   x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE ioctl
> 
>  arch/x86/include/uapi/asm/sgx.h |  2 ++
>  arch/x86/kernel/cpu/sgx/virt.c  | 48 ++++++++++++++++++++++++++++++---
>  2 files changed, 47 insertions(+), 3 deletions(-)
> 
> -- 
> 2.27.0
