Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C41182E21
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 11:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgCLKrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 06:47:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25245 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725268AbgCLKrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 06:47:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584010024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jFUekOHLeU3qhKAelLhiGNZn7By4cr3rg4OGbqyF5AY=;
        b=TSAcg3wIG8PF1Y4RK2vA7ylzYgROE8mPRixUL+D0YiIXTQiunaHSzLbdwhSFeDt8ebZvCx
        kt0dn03QTRQ/1B9KvhunhB291KnvgqzEeD506djmoEYXGmtQDfCGMAn5cfs+jEboiuZUy9
        uyTKUI6UVhJP2k2qfHzpah1C/1jZPnU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-CHZh_GaSO5eqF-RoeIMULA-1; Thu, 12 Mar 2020 06:47:02 -0400
X-MC-Unique: CHZh_GaSO5eqF-RoeIMULA-1
Received: by mail-wr1-f70.google.com with SMTP id c16so2429907wrt.2
        for <kvm@vger.kernel.org>; Thu, 12 Mar 2020 03:47:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=jFUekOHLeU3qhKAelLhiGNZn7By4cr3rg4OGbqyF5AY=;
        b=ij/8KHYQnVuZaFuJlBZyt+Dpb3ESvAVFNNajfJwT+RjqCXQAZo/VgAk4tnQaz2tmkF
         X7jPN4eu4QekVpPi7JxkuX+iXZxEc2JX5SnTkFoSd6PWrKdF6GiOl75Gq5KtBiauGLGO
         F2ZeBWGBRYKc03kJ1M4bc5o/Z/zZR0LZ5I7jYjGSDlMcPx+0KdydY7ndkM/CSBFtc9gI
         lMFPXpVEHNtGCm1mfid2jX/DmEzRsyQlk+z1eIpa9tigmSeTZHasCUpmGl6WZaIU0JLQ
         xua8r1xRhdsQVjC2tqUE5y+Jy+Gli5mPW937hVHusM++GV8+tMRf9sdpKDdAY1az+kfE
         ThZA==
X-Gm-Message-State: ANhLgQ3q97lJ2QWt/mrRJCp+Zsoot2HabNNVJQiUvWTUZLVBEkpZncIO
        2OORLyqAp/udoYhf9YwrC61B/NLr/dkt8nvKmwNuFYInkZi/d5T4HqzaeYsVo8tceAeNvGL5wXS
        eCNtHtCOKg2vb
X-Received: by 2002:a5d:6902:: with SMTP id t2mr10355961wru.135.1584010021312;
        Thu, 12 Mar 2020 03:47:01 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvJ796LfTJ3Q47GHjf+W7qnwRPZ8R2Y/nYN4pbop/6b1UDyakvgvEax5sb5O6CBLc2RosEqkA==
X-Received: by 2002:a5d:6902:: with SMTP id t2mr10355942wru.135.1584010021071;
        Thu, 12 Mar 2020 03:47:01 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a7sm10544307wmb.0.2020.03.12.03.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 03:47:00 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
Cc:     wanpengli@tencent.com, x86@kernel.org, kvm@vger.kernel.org
Subject: Re: Some warnings occur in hyperv.c.
In-Reply-To: <CAB5KdOaiqS_nXq8_HfMH1PmjThFzmYNBcBrMnC3Utkw6-OPUfQ@mail.gmail.com>
References: <CAB5KdOaiqS_nXq8_HfMH1PmjThFzmYNBcBrMnC3Utkw6-OPUfQ@mail.gmail.com>
Date:   Thu, 12 Mar 2020 11:47:00 +0100
Message-ID: <87o8t1rgt7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Haiwei Li <lihaiwei.kernel@gmail.com> writes:

> Hi, When i build kvm, some warnings occur. Just like:
>
> /home/kernel/data/linux/arch/x86/kvm//hyperv.c: In function ‘kvm_hv_flush_tlb’:
> /home/kernel/data/linux/arch/x86/kvm//hyperv.c:1436:1: warning: the
> frame size of 1064 bytes is larger than 1024 bytes
> [-Wframe-larger-than=]
>  }
>  ^
> /home/kernel/data/linux/arch/x86/kvm//hyperv.c: In function ‘kvm_hv_send_ipi’:
> /home/kernel/data/linux/arch/x86/kvm//hyperv.c:1529:1: warning: the
> frame size of 1112 bytes is larger than 1024 bytes
> [-Wframe-larger-than=]
>  }
>  ^
>
> Then i get the two functions in hyperv.c. Like:
>
> static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
>                            bool ex, bool fast)
> {
>         struct kvm *kvm = current_vcpu->kvm;
>         struct hv_send_ipi_ex send_ipi_ex;
>         struct hv_send_ipi send_ipi;
>         u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
>         DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
>         unsigned long *vcpu_mask;
>         unsigned long valid_bank_mask;
>         u64 sparse_banks[64];
>         int sparse_banks_len;
>         u32 vector;
>         bool all_cpus;
>
> static u64 kvm_hv_flush_tlb(struct kvm_vcpu *current_vcpu, u64 ingpa,
>                             u16 rep_cnt, bool ex)
> {
>         struct kvm *kvm = current_vcpu->kvm;
>         struct kvm_vcpu_hv *hv_vcpu = &current_vcpu->arch.hyperv;
>         struct hv_tlb_flush_ex flush_ex;
>         struct hv_tlb_flush flush;
>         u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
>         DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
>         unsigned long *vcpu_mask;
>         u64 valid_bank_mask;
>         u64 sparse_banks[64];
>         int sparse_banks_len;
>         bool all_cpus;
>
> The definition of sparse_banks for X86_64 is 512 B.  So i tried to
> refactor it by
> defining it for both tlb and ipi. But no preempt disable in the flow.
> How can i do?

I don't think preemption is a problem here if you define a per-vCPU
buffer: we can never switch to serving some new request for the same
vCPU before finishing the previous one so this is naturally serialized.

To not waste memory I'd suggest you allocate this buffer dinamically
upon first usage. We can also have a union for struct
hv_tlb_flush*/struct hv_send_ipi* as these also can't be used
simultaneously.

-- 
Vitaly

