Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7559122A398
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 02:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733109AbgGWA1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 20:27:36 -0400
Received: from mga04.intel.com ([192.55.52.120]:45594 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbgGWA1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 20:27:36 -0400
IronPort-SDR: +AlG84Y8voED0Gn0hwWY699/T3MqzESI5cYMcuTlNMY/ulGfoOMwJlyEEgCMeZ8K5Vl15buyfP
 luIdnLsynWsA==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="147937368"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="147937368"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 17:27:35 -0700
IronPort-SDR: mUsxL8sQNCI2nqU9PjsugOEtvJJ/JuZvfRlVQNTW2AN+P5CJict0Mn8mE17aHsrlhaevk8GK7n
 ItHJI9nAl0hA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="328382238"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga007.jf.intel.com with ESMTP; 22 Jul 2020 17:27:35 -0700
Date:   Wed, 22 Jul 2020 17:27:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v11 01/13] KVM: Cache as_id in kvm_memory_slot
Message-ID: <20200723002735.GN9114@linux.intel.com>
References: <20200708193408.242909-1-peterx@redhat.com>
 <20200708193408.242909-2-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708193408.242909-2-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 08, 2020 at 03:33:56PM -0400, Peter Xu wrote:
> Cache the address space ID just like the slot ID.  It will be used in
> order to fill in the dirty ring entries.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
