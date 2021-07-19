Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC873CCE4C
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 09:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234728AbhGSHQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 03:16:26 -0400
Received: from mga04.intel.com ([192.55.52.120]:39757 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234789AbhGSHQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 03:16:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10049"; a="209102776"
X-IronPort-AV: E=Sophos;i="5.84,251,1620716400"; 
   d="scan'208";a="209102776"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2021 00:13:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,251,1620716400"; 
   d="scan'208";a="499789742"
Received: from michael-optiplex-9020.sh.intel.com (HELO localhost) ([10.239.159.182])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Jul 2021 00:13:16 -0700
Date:   Mon, 19 Jul 2021 15:27:08 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        like.xu.linux@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH v6 04/12] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for
 guest Arch LBR
Message-ID: <20210719072708.GA23208@intel.com>
References: <1626425406-18582-1-git-send-email-weijiang.yang@intel.com>
 <1626425406-18582-5-git-send-email-weijiang.yang@intel.com>
 <CALMp9eQR1u_iXWEg+EEtL0_4mVC_T4d_3QqWy-8a4gncN7CmHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQR1u_iXWEg+EEtL0_4mVC_T4d_3QqWy-8a4gncN7CmHQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 16, 2021 at 04:33:36PM -0700, Jim Mattson wrote:
> On Fri, Jul 16, 2021 at 1:36 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> >
> > From: Like Xu <like.xu@linux.intel.com>
> >
> > The number of Arch LBR entries available is determined by the value
> > in host MSR_ARCH_LBR_DEPTH.DEPTH. The supported LBR depth values are
> > enumerated in CPUID.(EAX=01CH, ECX=0):EAX[7:0]. For each bit "n" set
> > in this field, the MSR_ARCH_LBR_DEPTH.DEPTH value of "8*(n+1)" is
> > supported.
> >
> > On a guest write to MSR_ARCH_LBR_DEPTH, all LBR entries are reset to 0.
> > KVM writes guest requested value to the native ARCH_LBR_DEPTH MSR
> > (this is safe because the two values will be the same) when the Arch LBR
> > records MSRs are pass-through to the guest.
> >
> > Signed-off-by: Like Xu <like.xu@linux.intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> 
> It might be worth noting that KVM_SET_MSRS cannot be used to emulate a
> wrmsr instruction in the guest, but maybe that's already implicit.
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>

Thanks Jim. Yes, guest wrmsr read/write emulation shares none-host initiated path.
