Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BAD36C87A
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 17:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237566AbhD0PPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 11:15:36 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:33735 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236578AbhD0PPf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 11:15:35 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id E9D381940ACD;
        Tue, 27 Apr 2021 11:14:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 27 Apr 2021 11:14:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=tj0LVf
        hJSNdorV650wiLh2qFHVZClezs2YTF435ywCY=; b=KJLR6Fkr9QyWaHzs5KXppX
        kCWHm34QzLhX2IFC/hSyo5qZ9FbXZi5Jm4Wn3uXTpkaqAMp246jKhoIfi1Cojubh
        abm93/Xr30JlAMND2jzL/GXI/UsB41EORexnZ9WbtWDdA0XATmlCyAUGEIM5J4i6
        epFEnYh+DFt5UyzXEZ8BGZKTRuqnrha6h4eIIn1I4zpr/2EdP3KFwG/7MX0eCvRL
        +dvDeAtAOsdm08Zc8omiSzNlJCnCwsfyr3P7FEW6hEiWmagW1LqQUTAOgv/A9sco
        V74zluMF9SOqnaDYvUI4TOLWUwoUn/imiu01C2paUITBen5+PcQwLVUOGk1+GAHg
        ==
X-ME-Sender: <xms:aSqIYE6_isfn4uOjT1gHJjwUzj6AcpoWinnkhSMgK1ephKwZ8zOPEQ>
    <xme:aSqIYF6k0eXtWwdSf9L7LL3n7wJhulVgLgRpSjiO-80M6O1EUzpF9XLXwh4-8e5cE
    eIVDRd0Zpy2zR5kgFs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddvtddgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepvffujghfhfffkfggtgesthdtredttddttdenucfhrhhomhepffgrvhhiugcu
    gfgumhhonhgushhonhcuoegumhgvsegumhgvrdhorhhgqeenucggtffrrghtthgvrhhnpe
    fhkeeguedtvdegffffteehjedvjeeitefgfefgffdugeffffegudehgeetgeelkeenucfk
    phepkedurddukeejrddviedrvdefkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegumhgvsegumhgvrdhorhhg
X-ME-Proxy: <xmx:aSqIYDfI9zXT4s0nd7K-U3N6wtfhMH61lMo0E-wyFYWnhxW5day-iQ>
    <xmx:aSqIYJIV-SHkBCyueEmfqBoO1xtTBuwUi_mT6eAiFTP2m9dCeDQ1BA>
    <xmx:aSqIYIIfS_tu1xf5BJbyCge_hO-W5HIGZk3vFaPS1jSW6pDbCmR7iA>
    <xmx:ayqIYBdA4HZ8AvAJPOeHCoR2WE-58xKkmvU6afp2Kd-_u-BC6F6vG8l0Z2Q>
Received: from disaster-area.hh.sledj.net (disaster-area.hh.sledj.net [81.187.26.238])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue, 27 Apr 2021 11:14:47 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 686a8429;
        Tue, 27 Apr 2021 15:14:46 +0000 (UTC)
To:     Hikaru Nishida <hikalium@chromium.org>, kvm@vger.kernel.org
Cc:     suleiman@google.com, Hikaru Nishida <hikalium@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [RFC PATCH 2/6] x86/kvm: Add a struct and constants for virtual
 suspend time injection
In-Reply-To: <20210426090644.2218834-3-hikalium@chromium.org>
References: <20210426090644.2218834-1-hikalium@chromium.org>
 <20210426090644.2218834-3-hikalium@chromium.org>
X-HGTTG: zarquon
From:   David Edmondson <dme@dme.org>
Date:   Tue, 27 Apr 2021 16:14:46 +0100
Message-ID: <cunh7jrkbdl.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday, 2021-04-26 at 18:06:41 +09, Hikaru Nishida wrote:

> This patch adds definitions that are needed by both host and guest

s/This patch adds/Add/

> to implement virtual suspend time injection.
> This patch also adds #include <linux/kvm_host.h> in

s/This patch also adds/Also add/

> kernel/time/timekeeping.c to make necesarily functions which will be

s/necesarily/necessary/

> introduced in later patches available.
>
> Signed-off-by: Hikaru Nishida <hikalium@chromium.org>
> ---
>
>  arch/x86/include/uapi/asm/kvm_para.h | 6 ++++++
>  kernel/time/timekeeping.c            | 1 +
>  2 files changed, 7 insertions(+)
>
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 950afebfba88..13788b01094f 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -33,6 +33,7 @@
>  #define KVM_FEATURE_PV_SCHED_YIELD	13
>  #define KVM_FEATURE_ASYNC_PF_INT	14
>  #define KVM_FEATURE_MSI_EXT_DEST_ID	15
> +#define KVM_FEATURE_HOST_SUSPEND_TIME	16
>  
>  #define KVM_HINTS_REALTIME      0
>  
> @@ -54,6 +55,7 @@
>  #define MSR_KVM_POLL_CONTROL	0x4b564d05
>  #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
>  #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
> +#define MSR_KVM_HOST_SUSPEND_TIME      0x4b564d08
>  
>  struct kvm_steal_time {
>  	__u64 steal;
> @@ -64,6 +66,10 @@ struct kvm_steal_time {
>  	__u32 pad[11];
>  };
>  
> +struct kvm_host_suspend_time {
> +	__u64   suspend_time_ns;
> +};
> +
>  #define KVM_VCPU_PREEMPTED          (1 << 0)
>  #define KVM_VCPU_FLUSH_TLB          (1 << 1)
>  
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 6aee5768c86f..ff0304de7de9 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -22,6 +22,7 @@
>  #include <linux/pvclock_gtod.h>
>  #include <linux/compiler.h>
>  #include <linux/audit.h>
> +#include <linux/kvm_host.h>
>  
>  #include "tick-internal.h"
>  #include "ntp_internal.h"
> -- 
> 2.31.1.498.g6c1eba8ee3d-goog

dme.
-- 
Too much information, running through my brain.
