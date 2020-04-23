Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BDE1B63DC
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 20:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbgDWSd2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 14:33:28 -0400
Received: from mga06.intel.com ([134.134.136.31]:22390 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730169AbgDWSd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 14:33:27 -0400
IronPort-SDR: 1verVb01tOLkRgwZzkbtqVUlRi2BYSu/OWL/yxupw/U8KnQRH8MktmM/qjqqCozuJ1bweC2JK6
 gvSjaRMZeHAw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 11:33:17 -0700
IronPort-SDR: rQgMM7Kk1Q32Ba271Rrh4caLAxLod1oUmCzH5KJ+GqPchZB+a193CtLJqwpgJccgfRo1rHw9q2
 YOIUt5KP4OqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="301292193"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Apr 2020 11:33:16 -0700
Date:   Thu, 23 Apr 2020 11:33:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, vkuznets@redhat.com, wei.huang2@amd.com
Subject: Re: [PATCH 2/2] KVM: x86: check_nested_events if there is an
 injectable NMI
Message-ID: <20200423183315.GM17824@linux.intel.com>
References: <20200414201107.22952-1-cavery@redhat.com>
 <20200414201107.22952-3-cavery@redhat.com>
 <20200423144209.GA17824@linux.intel.com>
 <467c5c66-8890-02ba-2e9a-c28365d9f2c6@redhat.com>
 <28f3db39-4561-7873-09dc-a27ebe5501b6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28f3db39-4561-7873-09dc-a27ebe5501b6@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 05:45:07PM +0200, Paolo Bonzini wrote:
> On 23/04/20 17:36, Cathy Avery wrote:
> > 
> > You will have to forgive me as I am new to KVM and any help would be
> > most appreciated.
> 
> No problem---this is a _really_ hairy part.  At least every time we make
> some changes it suddenly starts making more sense (both hacks and bugs
> decrease over time).

LOL, no kidding, what sadist gave Cathy nested NMI as a ramp task? :-D
