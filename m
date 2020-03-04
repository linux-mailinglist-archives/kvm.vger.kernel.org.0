Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F30721793F2
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 16:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388243AbgCDPsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 10:48:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32453 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387459AbgCDPsK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 10:48:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583336889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G05ODUMwGaZtTydQIga3NfVZQOwHv7Y4Bw0+tGX480w=;
        b=VtRQqe7llgG1LKqu+AMWMeTPbsSO2AMMKqtJH7lk7ztn7Q1SATR1kiwSGN4JFvzaGBR1ux
        fGT/K0yj3MTeLMJ3RSPpEKwioPawq3LMudQhi37LZ2FEEzM+P44vxVnDcXeopUEK1htptI
        5EN6o3t8p/+i1BvwjdVYHI65dklUNbE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-wR6KDOkxPJeJ3WETbr0gvw-1; Wed, 04 Mar 2020 10:48:08 -0500
X-MC-Unique: wR6KDOkxPJeJ3WETbr0gvw-1
Received: by mail-qk1-f198.google.com with SMTP id w6so1582521qki.13
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2020 07:48:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G05ODUMwGaZtTydQIga3NfVZQOwHv7Y4Bw0+tGX480w=;
        b=FtDKk1YIt2u3ELmN0IB3krXYsa3TQ2mH8gkhzeOhx2zXqPCIBKUsP8y10F1dN75pxb
         JkD8jQ0n4jIuv+x2J+Lvb3Lb+KshX+h8uRWMeUCo4TpQ91kDZpqvmp9aqtwGYTsFt9rM
         Ag3mlUrSDG7R0m/08eBqNhYyZ6K9Ke5R6uLSrlq5CeQWhL823ut/ztvApqWkLy7us50h
         Rq5TBDp1ddrO8EYuKlLTc4O/PSBBBDLUbJdDNp9IaHcRfxKHKQLDlxpE2DogrVaAAHsO
         OyzKa1Gw16RVY9+M7FTMiKyMNw7pTZpvAz+lD3G6wePkr3HgrSSq6vxgKBw1O3BUwuYn
         C/Fg==
X-Gm-Message-State: ANhLgQ05xAuDWQtA0Tm8LNN+/8qrjCpJ7iT/Z2rHSctQfU1A/HI6npU+
        dnmhiTrLUzfludb/4mIScFn4/J/JHJ553LT20+2pST1Ff3XCqKARmV5Dlrkb3KXzExpHAgDtwGW
        ZBnIF8+g7+QYg
X-Received: by 2002:ac8:344f:: with SMTP id v15mr2949271qtb.58.1583336887612;
        Wed, 04 Mar 2020 07:48:07 -0800 (PST)
X-Google-Smtp-Source: ADFU+vs9S0eYXlfqZXtPUdipXSfLtn/EG8NyXkF23m7/jaeOXsDnXYsxmHRqgNzn6iJLCPWk1rgB8g==
X-Received: by 2002:ac8:344f:: with SMTP id v15mr2949250qtb.58.1583336887323;
        Wed, 04 Mar 2020 07:48:07 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id v6sm5639721qkg.102.2020.03.04.07.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 07:48:06 -0800 (PST)
Date:   Wed, 4 Mar 2020 10:48:05 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jay Zhou <jianjay.zhou@huawei.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mst@redhat.com, cohuck@redhat.com, wangxinxin.wang@huawei.com,
        weidong.huang@huawei.com, liu.jinsong@huawei.com
Subject: Re: [PATCH] kvm: support to get/set dirty log initial-all-set
 capability
Message-ID: <20200304154805.GC7146@xz-x1>
References: <20200304025554.2159-1-jianjay.zhou@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200304025554.2159-1-jianjay.zhou@huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 04, 2020 at 10:55:54AM +0800, Jay Zhou wrote:
> Since the new capability KVM_DIRTY_LOG_INITIALLY_SET of
> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 has been introduced in the
> kernel, tweak the userspace side to detect and enable this
> capability.
> 
> Signed-off-by: Jay Zhou <jianjay.zhou@huawei.com>
> ---
>  accel/kvm/kvm-all.c       | 21 ++++++++++++++-------
>  linux-headers/linux/kvm.h |  3 +++
>  2 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 439a4efe52..45ab25be63 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -100,7 +100,7 @@ struct KVMState
>      bool kernel_irqchip_required;
>      OnOffAuto kernel_irqchip_split;
>      bool sync_mmu;
> -    bool manual_dirty_log_protect;
> +    uint64_t manual_dirty_log_protect;
>      /* The man page (and posix) say ioctl numbers are signed int, but
>       * they're not.  Linux, glibc and *BSD all treat ioctl numbers as
>       * unsigned, and treating them as signed here can break things */
> @@ -1882,6 +1882,7 @@ static int kvm_init(MachineState *ms)
>      int ret;
>      int type = 0;
>      const char *kvm_type;
> +    uint64_t dirty_log_manual_caps;
>  
>      s = KVM_STATE(ms->accelerator);
>  
> @@ -2007,14 +2008,20 @@ static int kvm_init(MachineState *ms)
>      s->coalesced_pio = s->coalesced_mmio &&
>                         kvm_check_extension(s, KVM_CAP_COALESCED_PIO);
>  
> -    s->manual_dirty_log_protect =
> +    dirty_log_manual_caps =
>          kvm_check_extension(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
> -    if (s->manual_dirty_log_protect) {
> -        ret = kvm_vm_enable_cap(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0, 1);
> +    dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
> +                              KVM_DIRTY_LOG_INITIALLY_SET);
> +    s->manual_dirty_log_protect = dirty_log_manual_caps;
> +    if (dirty_log_manual_caps) {
> +        ret = kvm_vm_enable_cap(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0,
> +                                   dirty_log_manual_caps);
>          if (ret) {
> -            warn_report("Trying to enable KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 "
> -                        "but failed.  Falling back to the legacy mode. ");
> -            s->manual_dirty_log_protect = false;
> +            warn_report("Trying to enable capability %"PRIu64" of "
> +                        "KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 but failed. "
> +                        "Falling back to the legacy mode. ",
> +                        dirty_log_manual_caps);
> +            s->manual_dirty_log_protect = 0;
>          }
>      }
>  
> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> index 265099100e..3cb71c2b19 100644
> --- a/linux-headers/linux/kvm.h
> +++ b/linux-headers/linux/kvm.h
> @@ -1628,4 +1628,7 @@ struct kvm_hyperv_eventfd {
>  #define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
>  #define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
>  
> +#define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
> +#define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
> +

The patch looks ok, though ideally I think we need to wait until the
kernel patch got pushed then we'll be sure these macros won't be
overwrite by other ./scripts/update-linux-headers.sh updates (or
another patch to call the update script to fetch the macros...).

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks,

-- 
Peter Xu

