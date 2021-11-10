Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6C644BB47
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 06:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhKJFin (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 00:38:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:15754 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhKJFim (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 00:38:42 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10163"; a="230072213"
X-IronPort-AV: E=Sophos;i="5.87,222,1631602800"; 
   d="scan'208";a="230072213"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2021 21:35:55 -0800
X-IronPort-AV: E=Sophos;i="5.87,222,1631602800"; 
   d="scan'208";a="669673375"
Received: from liuqimin-mobl.ccr.corp.intel.com (HELO localhost) ([10.255.29.94])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2021 21:35:52 -0800
Date:   Wed, 10 Nov 2021 13:35:48 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>,
        Jim Mattson <jmattson@google.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
Message-ID: <20211110053548.tewdtkebhl77dmye@linux.intel.com>
References: <YVy6gj2+XsghsP3j@google.com>
 <CALMp9eT+uAvPv7LhJKrJGDN31-aVy6DYBrP+PUDiTk0zWuCX4g@mail.gmail.com>
 <YVzeJ59/yCpqgTX2@google.com>
 <20211008082302.txckaasmsystigeu@linux.intel.com>
 <85da4484902e5a4b1be645669c95dba7934d98b5.camel@linux.intel.com>
 <CALMp9eTSkK2+-W8AVRdYv3MEsMKj-Xc2-v7DsavJRh5FLsVuCQ@mail.gmail.com>
 <3360abf3841a5d3234ac5983dd2df62b24e5fc47.camel@linux.intel.com>
 <CALMp9eQruRB3WEuwe2PEyEmbYUcJC_vR86Dd_wPTuqjb212h+w@mail.gmail.com>
 <32f506647ff99f58441ed1281c1db84599d48c8c.camel@linux.intel.com>
 <YYr3R8ehb/1tsCDj@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYr3R8ehb/1tsCDj@google.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 09, 2021 at 10:33:43PM +0000, Sean Christopherson wrote:
> On Wed, Nov 03, 2021, Robert Hoo wrote:
> > On Fri, 2021-10-29 at 12:53 -0700, Jim Mattson wrote:
> > > On Fri, Oct 8, 2021 at 5:05 PM Robert Hoo <robert.hu@linux.intel.com>
> > > wrote:
> > > > 
> > > > On Fri, 2021-10-08 at 16:49 -0700, Jim Mattson wrote:
> > > > > We have some internal patches for virtualizing VMCS shadowing
> > > > > which
> > > > > may break if there is a guest VMCS field with index greater than
> > > > > VMX_VMCS_ENUM.MAX_INDEX. I plan to upstream them soon.
> > > > 
> > > > OK, thanks for letting us know.:-)
> > > 
> > > After careful consideration, we're actually going to drop these
> > > patches rather than sending them upstream.
> > 
> > OK.
> > 
> > Hi, Paolo, Sean and Jim,
> > 
> > Do you think our this series patch are still needed or can be dropped
> > as well?
> 
> IMO we should drop this series and take our own erratum.
> 

Thanks, Sean.

Do we need a patch in kvm-unit-test to depricate the check against
the max index from MSR_IA32_VMX_VMCS_ENUM?

B.R.
Yu
