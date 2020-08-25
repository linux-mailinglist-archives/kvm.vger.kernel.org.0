Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D310A250DF6
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 02:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgHYA6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 20:58:01 -0400
Received: from mga12.intel.com ([192.55.52.136]:21049 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgHYA6A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 20:58:00 -0400
IronPort-SDR: WhDgKZoJGs/pI6xQWRhA0z5g/W6yrQBDP0tjADxn5q8LNkTO3Zi2qn1KvYiWXS9YkTqFnkmdbP
 UByjO5L6Pg0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="135565419"
X-IronPort-AV: E=Sophos;i="5.76,350,1592895600"; 
   d="scan'208";a="135565419"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 17:57:59 -0700
IronPort-SDR: cYYF3vklfp76byvzjvjxPUqb0Sq5ZPMeQMQUTQwElUy1pYxNudaHu3rKDAR3HN4U6ffTZf8qNn
 S4vHnbm888LA==
X-IronPort-AV: E=Sophos;i="5.76,350,1592895600"; 
   d="scan'208";a="281352518"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 17:57:58 -0700
Date:   Mon, 24 Aug 2020 17:57:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 1/2] KVM: LAPIC: Return 0 when getting the tscdeadline
 timer if the lapic is hw disabled
Message-ID: <20200825005757.GD15046@sjchrist-ice>
References: <1597213838-8847-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1597213838-8847-1-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 12, 2020 at 02:30:37PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Return 0 when getting the tscdeadline timer if the lapic is hw disabled.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
