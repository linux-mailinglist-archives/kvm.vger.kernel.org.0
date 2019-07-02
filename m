Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE925D9A9
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 02:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfGCAuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 20:50:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbfGCAuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 20:50:13 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A37833082E8F;
        Tue,  2 Jul 2019 22:23:49 +0000 (UTC)
Received: from amt.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EF5B1001B01;
        Tue,  2 Jul 2019 22:23:49 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 69655105161;
        Tue,  2 Jul 2019 18:36:46 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x62LagnA026629;
        Tue, 2 Jul 2019 18:36:42 -0300
Date:   Tue, 2 Jul 2019 18:36:42 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] Documentation: kvm: document CPUID bit for
 MSR_KVM_POLL_CONTROL
Message-ID: <20190702213638.GA26621@amt.cnet>
References: <1562086673-30242-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562086673-30242-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 02 Jul 2019 22:23:49 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 02, 2019 at 06:57:53PM +0200, Paolo Bonzini wrote:
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  Documentation/virtual/kvm/cpuid.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
> index 979a77ba5377..2bdac528e4a2 100644
> --- a/Documentation/virtual/kvm/cpuid.txt
> +++ b/Documentation/virtual/kvm/cpuid.txt
> @@ -66,6 +66,10 @@ KVM_FEATURE_PV_SEND_IPI            ||    11 || guest checks this feature bit
>                                     ||       || before using paravirtualized
>                                     ||       || send IPIs.
>  ------------------------------------------------------------------------------
> +KVM_FEATURE_PV_POLL_CONTROL        ||    12 || host-side polling on HLT can
> +                                   ||       || be disabled by writing
> +                                   ||       || to msr 0x4b564d05.
> +------------------------------------------------------------------------------
>  KVM_FEATURE_PV_SCHED_YIELD         ||    13 || guest checks this feature bit
>                                     ||       || before using paravirtualized
>                                     ||       || sched yield.
> -- 
> 1.8.3.1

ACK
