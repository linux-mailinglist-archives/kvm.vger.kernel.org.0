Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4E4487B01
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 18:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348461AbiAGRI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 12:08:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240470AbiAGRI4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 12:08:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641575335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W5E//EkxyUr9K8+lVRMvOlJDgAaGmOrJeciI09SYa5Y=;
        b=Qc9BXjAPupDvntUU8ReqQcRD7rKOKf5NGeh8SVlzYhLHTfcJ0RMqBfBpnd++W87SdDB6qL
        aqPOd/ZpcH84yEB00j94pnkT9YBEC8ls2zZeFX0eC/S2kdzFeJd048Vusj6dZr5ACIdflt
        QA9WiQbH9Hs/fHskqaiQy0qycOpSCtk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-TbZAICngMuKAK_LC3sxRrA-1; Fri, 07 Jan 2022 12:08:53 -0500
X-MC-Unique: TbZAICngMuKAK_LC3sxRrA-1
Received: by mail-ed1-f70.google.com with SMTP id y10-20020a056402358a00b003f88b132849so5213525edc.0
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 09:08:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W5E//EkxyUr9K8+lVRMvOlJDgAaGmOrJeciI09SYa5Y=;
        b=GWV9YGqtShemq7qesqfGypboUoVcWTvTaHkXAGbLOdf18MSUUWr25l0RKR8H5p2TEw
         2nd6N77D9qP7BhMzTgj2katiFhWLeA5itVOGhuxgdw40UdBT+DEUy/3KnRTajfWaZUwB
         hPv6K7MT5+NiXK13RiFf4onbS2tLARiCSM+mdxf+1VSpiFE9Sta9T7Jmo4iHlYysmCP1
         j0yR7c6KhEzgDwXsQF0LkP/ezB8FXO88Vi5eS3fO9ygvADCeF5F3aR8h9oohAGYjoLk/
         IgGky/9wPSTQuoveOb6NKWNA+S/M54SoL5wKumd/krdNQWlC6n4UjWDs0zanPSuQ2DQB
         H6aQ==
X-Gm-Message-State: AOAM531+UmFAKh0SpH/rHWfuU7j9Dwho1oP/NWKnxjOq5sgn1JzxRw+6
        YOiRErTVIoYIHIXxtSZ1nPUXezGJvea1WsDVJZUQPuyEaRqeYdPdHY2d4HLPxhGGSeZSM4ejAw8
        lsdM49obMuW50
X-Received: by 2002:a17:907:1692:: with SMTP id hc18mr50762246ejc.558.1641575332576;
        Fri, 07 Jan 2022 09:08:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzKiJjTdncqFRbTGuEUs7lsUg4iJVlfqzEVwkkiFsbwO+TR8/xX3O0iZkZXQbxCwm67L9dYRg==
X-Received: by 2002:a17:907:1692:: with SMTP id hc18mr50762231ejc.558.1641575332329;
        Fri, 07 Jan 2022 09:08:52 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id d7sm2289533edt.74.2022.01.07.09.08.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 09:08:51 -0800 (PST)
Message-ID: <6867e529-a85d-72fe-4577-55a4e793ba31@redhat.com>
Date:   Fri, 7 Jan 2022 18:08:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2] KVM: x86: Check for rmaps allocation
Content-Language: en-US
To:     Nikunj A Dadhania <nikunj@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vasant.hegde@amd.com,
        brijesh.singh@amd.com
References: <20220105040337.4234-1-nikunj@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220105040337.4234-1-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/22 05:03, Nikunj A Dadhania wrote:
> With TDP MMU being the default now, access to mmu_rmaps_stat debugfs
> file causes following oops:
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 7 PID: 3185 Comm: cat Not tainted 5.16.0-rc4+ #204
> RIP: 0010:pte_list_count+0x6/0x40
>   Call Trace:
>    <TASK>
>    ? kvm_mmu_rmaps_stat_show+0x15e/0x320
>    seq_read_iter+0x126/0x4b0
>    ? aa_file_perm+0x124/0x490
>    seq_read+0xf5/0x140
>    full_proxy_read+0x5c/0x80
>    vfs_read+0x9f/0x1a0
>    ksys_read+0x67/0xe0
>    __x64_sys_read+0x19/0x20
>    do_syscall_64+0x3b/0xc0
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>   RIP: 0033:0x7fca6fc13912
> 
> Return early when rmaps are not present.
> 
> Reported-by: Vasant Hegde <vasant.hegde@amd.com>
> Tested-by: Vasant Hegde <vasant.hegde@amd.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
> 
> v1: https://lore.kernel.org/kvm/20220104092814.11553-1-nikunj@amd.com/T/#u
> 
> Check the rmaps inside kvm_mmu_rmaps_stat_show() as the rmaps can be
> allocated dynamically (Peter Xu)
> 
>   arch/x86/kvm/debugfs.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
> index 543a8c04025c..9240b3b7f8dd 100644
> --- a/arch/x86/kvm/debugfs.c
> +++ b/arch/x86/kvm/debugfs.c
> @@ -95,6 +95,9 @@ static int kvm_mmu_rmaps_stat_show(struct seq_file *m, void *v)
>   	unsigned int *log[KVM_NR_PAGE_SIZES], *cur;
>   	int i, j, k, l, ret;
>   
> +	if (!kvm_memslots_have_rmaps(kvm))
> +		return 0;
> +
>   	ret = -ENOMEM;
>   	memset(log, 0, sizeof(log));
>   	for (i = 0; i < KVM_NR_PAGE_SIZES; i++) {

Queued, thanks.

Paolo

