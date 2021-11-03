Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CA2443B0C
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 02:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhKCBei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 21:34:38 -0400
Received: from mga04.intel.com ([192.55.52.120]:40360 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229844AbhKCBef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 21:34:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10156"; a="230132426"
X-IronPort-AV: E=Sophos;i="5.87,203,1631602800"; 
   d="scan'208";a="230132426"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2021 18:31:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,203,1631602800"; 
   d="scan'208";a="638435076"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga001.fm.intel.com with ESMTP; 02 Nov 2021 18:31:56 -0700
Message-ID: <32f506647ff99f58441ed1281c1db84599d48c8c.camel@linux.intel.com>
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        kvm@vger.kernel.org
Date:   Wed, 03 Nov 2021 09:31:56 +0800
In-Reply-To: <CALMp9eQruRB3WEuwe2PEyEmbYUcJC_vR86Dd_wPTuqjb212h+w@mail.gmail.com>
References: <0b94844844521fc0446e3df0aa02d4df183f8107.camel@linux.intel.com>
         <YTI7K9RozNIWXTyg@google.com>
         <64aad01b6bffd70fa3170cf262fe5d7c66f6b2d4.camel@linux.intel.com>
         <YVx6Oesi7X3jfnaM@google.com>
         <CALMp9eRyhAygfh1piNEDE+WGVzK1cTWJJR1aC_zqn=c2fy+c-A@mail.gmail.com>
         <YVySdKOWTXqU4y3R@google.com>
         <CALMp9eQvRYpZg+G7vMcaCq0HYPDfZVpPtDRO9bRa0w2fyyU9Og@mail.gmail.com>
         <YVy6gj2+XsghsP3j@google.com>
         <CALMp9eT+uAvPv7LhJKrJGDN31-aVy6DYBrP+PUDiTk0zWuCX4g@mail.gmail.com>
         <YVzeJ59/yCpqgTX2@google.com>
         <20211008082302.txckaasmsystigeu@linux.intel.com>
         <85da4484902e5a4b1be645669c95dba7934d98b5.camel@linux.intel.com>
         <CALMp9eTSkK2+-W8AVRdYv3MEsMKj-Xc2-v7DsavJRh5FLsVuCQ@mail.gmail.com>
         <3360abf3841a5d3234ac5983dd2df62b24e5fc47.camel@linux.intel.com>
         <CALMp9eQruRB3WEuwe2PEyEmbYUcJC_vR86Dd_wPTuqjb212h+w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-10-29 at 12:53 -0700, Jim Mattson wrote:
> On Fri, Oct 8, 2021 at 5:05 PM Robert Hoo <robert.hu@linux.intel.com>
> wrote:
> > 
> > On Fri, 2021-10-08 at 16:49 -0700, Jim Mattson wrote:
> > > We have some internal patches for virtualizing VMCS shadowing
> > > which
> > > may break if there is a guest VMCS field with index greater than
> > > VMX_VMCS_ENUM.MAX_INDEX. I plan to upstream them soon.
> > 
> > OK, thanks for letting us know.:-)
> 
> After careful consideration, we're actually going to drop these
> patches rather than sending them upstream.

OK.

Hi, Paolo, Sean and Jim,

Do you think our this series patch are still needed or can be dropped
as well?

Thanks.

