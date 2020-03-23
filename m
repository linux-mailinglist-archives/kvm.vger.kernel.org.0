Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD5718F22F
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 10:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgCWJxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 05:53:25 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:52053 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727752AbgCWJxZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 05:53:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584957204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VPD/Jl19hS8LZpj/pgb6n0uGZoGyOvZALf7c52VQrx0=;
        b=M8Qc5BB2PNsvHbRy7T+7eBpesAJkyc6nSktbwho/j8RqzQsH5WlDaRU5Nl2Z0oNWGSEhbI
        NrceOWRW8Ntx1rJtk6kmeHTh+nSHa0sW0IlPJMMTX5d2shZF2y2E3JrzckmtsmtD4dDvcI
        bLLaQ8l8yesDTXEBGWGYqjugNlxFSDw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-uzbLIV-EMsC4rvL0b9BBLQ-1; Mon, 23 Mar 2020 05:53:22 -0400
X-MC-Unique: uzbLIV-EMsC4rvL0b9BBLQ-1
Received: by mail-wr1-f71.google.com with SMTP id f15so1710830wrt.4
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 02:53:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VPD/Jl19hS8LZpj/pgb6n0uGZoGyOvZALf7c52VQrx0=;
        b=VdR+skxdUBOxFebFOVdrTa1a4XgFmZviCTOeXOHoDS0tAit5UF992wVu6Jru3TqZLc
         gjw37KSeIWjTAa36OUmmBQYQ28e6E/jG6WMhk686BCsYtDlh2xys9UJ6jwPzG7n06yqB
         RCtlwRyWpZwpyNES0PpsL8oKILizwyrM4bo8CyCZMOlGRKz0iJpA+xIJP5qF966vod2i
         3J+6hmX0VVQCuMLX0QjGRVvTCvlc2b+lVlA+oGRz2+YVPYzNoGjpF8dfJD46khkHzaHA
         JNNssFzt85zYF+bvpPzcbeth5/aEuhF/a2ru3bREUoc6tqR4OgroUEkVt1I9RSIi57Fw
         kgKA==
X-Gm-Message-State: ANhLgQ24iwibfFzgi8DYJV09HWRSub5cuwwQVdIK0gesxONrTHvoCYOZ
        o4lulz4vRbBCK7eQe5vRuSu4cBRqahcZGIvzhXjJw230xl/8/tRmpCro6hMcN8+cNszsB1e7SFY
        IxngM981Mw8/v
X-Received: by 2002:a1c:3241:: with SMTP id y62mr27598457wmy.66.1584957201449;
        Mon, 23 Mar 2020 02:53:21 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtwCAOGgPAR0vwL4cDhzymGqUrzBFlAq+C1qd3tAwY4wzCvAxHsdZwLP/SPzxu8jkejeHa20A==
X-Received: by 2002:a1c:3241:: with SMTP id y62mr27598435wmy.66.1584957201245;
        Mon, 23 Mar 2020 02:53:21 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v7sm21926822wml.18.2020.03.23.02.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 02:53:20 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jon Doron <arilou@gmail.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v9 1/6] x86/kvm/hyper-v: Explicitly align hcall param for kvm_hyperv_exit
In-Reply-To: <20200320172839.1144395-2-arilou@gmail.com>
References: <20200320172839.1144395-1-arilou@gmail.com> <20200320172839.1144395-2-arilou@gmail.com>
Date:   Mon, 23 Mar 2020 10:53:19 +0100
Message-ID: <87zhc79z3k.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jon Doron <arilou@gmail.com> writes:

> The problem the patch is trying to address is the fact that 'struct
> kvm_hyperv_exit' has different layout on when compiling in 32 and 64 bit
> modes.
>
> In 64-bit mode the default alignment boundary is 64 bits thus
> forcing extra gaps after 'type' and 'msr' but in 32-bit mode the
> boundary is at 32 bits thus no extra gaps.
>
> This is an issue as even when the kernel is 64 bit, the userspace using
> the interface can be both 32 and 64 bit but the same 32 bit userspace has
> to work with 32 bit kernel.
>
> The issue is fixed by forcing the 64 bit layout, this leads to ABI
> change for 32 bit builds and while we are obviously breaking '32 bit
> userspace with 32 bit kernel' case, we're fixing the '32 bit userspace
> with 64 bit kernel' one.
>
> As the interface has no (known) users and 32 bit KVM is rather baroque
> nowadays, this seems like a reasonable decision.
>
> Signed-off-by: Jon Doron <arilou@gmail.com>
> ---
>  Documentation/virt/kvm/api.rst | 2 ++
>  include/uapi/linux/kvm.h       | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index ebd383fba939..4872c47bbcff 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5025,9 +5025,11 @@ EOI was received.
>    #define KVM_EXIT_HYPERV_SYNIC          1
>    #define KVM_EXIT_HYPERV_HCALL          2
>  			__u32 type;
> +			__u32 pad1;
>  			union {
>  				struct {
>  					__u32 msr;
> +					__u32 pad2;
>  					__u64 control;
>  					__u64 evt_page;
>  					__u64 msg_page;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4b95f9a31a2f..7ee0ddc4c457 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -189,9 +189,11 @@ struct kvm_hyperv_exit {
>  #define KVM_EXIT_HYPERV_SYNIC          1
>  #define KVM_EXIT_HYPERV_HCALL          2
>  	__u32 type;
> +	__u32 pad1;
>  	union {
>  		struct {
>  			__u32 msr;
> +			__u32 pad2;
>  			__u64 control;
>  			__u64 evt_page;
>  			__u64 msg_page;

Already said that on v8 but the tag got lost,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

