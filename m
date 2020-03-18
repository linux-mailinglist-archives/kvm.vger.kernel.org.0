Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCA61899DC
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 11:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgCRKrv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 06:47:51 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:34434 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbgCRKrv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 06:47:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584528469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=20Pma11u+V3QJ12jl7Iqp+bmqwni4dt/3uPHazTMKo8=;
        b=aqL98optVhRQR1h3g4qnKzcU8QFITi4jDVsGJ/FRzJOrTb3geNWNsaVRxZ5EMT88fMx59z
        ACM45rXaUccQ4m9fBQ7Xn3l723oB4BZNrsJjhn3Bs7JLgKKboh4ssvXjVq4MGDr8huKGIh
        TchIcPwTQ7UNgd/bZtN6h0ffaVeXRmQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-js4UBce0NKqH1Q8yTgt7Pw-1; Wed, 18 Mar 2020 06:47:48 -0400
X-MC-Unique: js4UBce0NKqH1Q8yTgt7Pw-1
Received: by mail-wr1-f72.google.com with SMTP id t10so5826189wrp.15
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 03:47:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=20Pma11u+V3QJ12jl7Iqp+bmqwni4dt/3uPHazTMKo8=;
        b=MaqnyiIK0mD/xq02B5Nc3LmXswwcU6RdAmECt89DxITU9aKlBv/VhB55hAUQd9il7h
         7OuvlicSqr+Wb/sQotXRe76IebYG8L2JjwTXJws0OYpYZ9IP+rrh1CNhMQX8GkOQJZMh
         NXACOzexOKZQbrlEdiRMeLTHI0KR+wn+Of2z+teiSTcpxmtfgDd1nf1TVxce7aPrUBKt
         H6tBo5b+B950w/KaohyunSkRIr0lvTX3au+teAh7eRx+hW659EJGBMM8W2/ZBp1aqY8F
         5Q7uV3RHZLRxtlgs7unmE3weVi75eyO/8RIbxLVwq64WXODfzXs8SjqQQeBvLdSLaSrR
         0LEA==
X-Gm-Message-State: ANhLgQ37xd/enZRUtuD4nRIaCAtKHNt9ktiv7iNT4PEo+MOZ0/9r071E
        J8jt4J1RGJaUKfZJx+xUJwAINTDkPKhDTf8FTQ9mh06oRKBoUwDsYq23GWPATkfm2EBstG4xUr8
        iK7M7kViUY7tz
X-Received: by 2002:a1c:3585:: with SMTP id c127mr4574222wma.124.1584528466990;
        Wed, 18 Mar 2020 03:47:46 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuAtZOmBxaL+oCC9HAvrwkuL2dQBy3C1WKZmpeb/R7KpwuLMA+nd6TV9Ou+ZyizLHgON8YK3w==
X-Received: by 2002:a1c:3585:: with SMTP id c127mr4574198wma.124.1584528466730;
        Wed, 18 Mar 2020 03:47:46 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id p10sm8545688wru.4.2020.03.18.03.47.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 03:47:46 -0700 (PDT)
Subject: Re: [PATCH] kvm: support to get/set dirty log initial-all-set
 capability
To:     Jay Zhou <jianjay.zhou@huawei.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     mst@redhat.com, cohuck@redhat.com, peterx@redhat.com,
        wangxinxin.wang@huawei.com, weidong.huang@huawei.com,
        liu.jinsong@huawei.com
References: <20200304025554.2159-1-jianjay.zhou@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <18e7b781-8a52-d78a-a653-898445a5ee53@redhat.com>
Date:   Wed, 18 Mar 2020 11:47:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200304025554.2159-1-jianjay.zhou@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/03/20 03:55, Jay Zhou wrote:
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
>  #endif /* __LINUX_KVM_H */
> 

Queued, thanks.

Paolo

