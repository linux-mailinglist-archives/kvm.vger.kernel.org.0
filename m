Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4483C5859
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 13:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355817AbhGLIqI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 04:46:08 -0400
Received: from mga03.intel.com ([134.134.136.65]:33556 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355641AbhGLIoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 04:44:07 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10042"; a="209986440"
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="209986440"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 01:41:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="501997078"
Received: from michael-optiplex-9020.sh.intel.com (HELO localhost) ([10.239.159.182])
  by fmsmga002.fm.intel.com with ESMTP; 12 Jul 2021 01:41:16 -0700
Date:   Mon, 12 Jul 2021 16:55:19 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        like.xu.linux@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/13] KVM: x86: Add arch LBR MSRs to msrs_to_save_all
 list
Message-ID: <20210712085519.GA12162@intel.com>
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
 <1625825111-6604-4-git-send-email-weijiang.yang@intel.com>
 <CALMp9eTKNG_b6Te=aV_Qd3ADXzf8RkvDhGfWtopQGAf51eHMbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eTKNG_b6Te=aV_Qd3ADXzf8RkvDhGfWtopQGAf51eHMbg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 09, 2021 at 11:24:46AM -0700, Jim Mattson wrote:
> On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> >
> > Arch LBR MSR_ARCH_LBR_DEPTH and MSR_ARCH_LBR_CTL are {saved|restored}
> > by userspace application if they're available.
> >
> > Suggested-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
Thanks Jim for review!
