Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2363F5E633
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 16:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfGCOO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 10:14:26 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51102 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfGCOO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 10:14:26 -0400
Received: by mail-wm1-f66.google.com with SMTP id n9so2412789wmi.0
        for <kvm@vger.kernel.org>; Wed, 03 Jul 2019 07:14:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WEU9J4f4LicY5+G8hi8mfSV2AgtX7u94Zg0dhqNyNTY=;
        b=lFs5yCPogAEaA7SeeowIDMviv1g0lHq+4DJdLCMCtVU+Xbf+K0g013ds2lYi4eUBAj
         qOwfy+9950osuLVbiEwVJ7WO7GxAf8r6katymTZGthhpwzuEz7uGEiXt/wq0i0KaER/o
         wUHp9wYZIv7KgdIUhS0AD0nUViniRpFOQ+89vUTlxZ04gDZFhkE6IxijQ6DkvbldHRXK
         m7E8ItZDi8591Xt53zph+AEoFGcI3YL0kiwNYVYG/uPvxuKuuPo8vcwA0nL8PxShcwqn
         upUzrkcR5yHOxyIp5l2Q8DYnQiwo8NVoccfdS0KBGm5k8tVjbO7MEwidgNjgO5KX8/ms
         th1g==
X-Gm-Message-State: APjAAAVO4SqjXPdewfSvTTTN4XAk6EksKKFFeCc0+SxZnC4qBkvZ5WuF
        eq67voEnP9bVyUxzLOKi8OqcsA==
X-Google-Smtp-Source: APXvYqxWJTH50ot0zo+dXmDmM1jQCcRtivVoVxZbuVBIWGJ9ZjIgNO8eZw3CTYU6sbPTVLyKRiVoDw==
X-Received: by 2002:a1c:770d:: with SMTP id t13mr8092226wmi.79.1562163263930;
        Wed, 03 Jul 2019 07:14:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:6c1d:63cc:b81d:e1a9? ([2001:b07:6468:f312:6c1d:63cc:b81d:e1a9])
        by smtp.gmail.com with ESMTPSA id q7sm1819496wrx.6.2019.07.03.07.14.23
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 07:14:23 -0700 (PDT)
Subject: Re: [PATCH v4 2/2] KVM: LAPIC: remove the trailing newline used in
 the fmt parameter of TP_printk
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1560474949-20497-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b76ce740-69ea-c290-28f8-d2d8a683bdbd@redhat.com>
Date:   Wed, 3 Jul 2019 16:14:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1560474949-20497-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/06/19 03:15, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> The trailing newlines will lead to extra newlines in the trace file
> which looks like the following output, so remove it.
> 
> qemu-system-x86-15695 [002] ...1 15774.839240: kvm_hv_timer_state: vcpu_id 0 hv_timer 1
> 
> qemu-system-x86-15695 [002] ...1 15774.839309: kvm_hv_timer_state: vcpu_id 0 hv_timer 1
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/trace.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 4d47a26..b5c831e 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -1365,7 +1365,7 @@ TRACE_EVENT(kvm_hv_timer_state,
>  			__entry->vcpu_id = vcpu_id;
>  			__entry->hv_timer_in_use = hv_timer_in_use;
>  			),
> -		TP_printk("vcpu_id %x hv_timer %x\n",
> +		TP_printk("vcpu_id %x hv_timer %x",
>  			__entry->vcpu_id,
>  			__entry->hv_timer_in_use)
>  );
> 

Queued 2/2, thanks.

Paolo
