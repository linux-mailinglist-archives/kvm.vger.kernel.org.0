Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677B51B04C2
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 10:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgDTIrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 04:47:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21120 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725773AbgDTIrY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 04:47:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587372442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HbB4dFblI4nSgTZkQmOILmsy2bt4PNUY80Flmj8Lzl0=;
        b=e9RP1nATvPksdJbO7QjBR4yeIw2LJoB8/4H/tU8jJ4TpNbCfsLaTtUe8SmSJzNPOSmpyhB
        GHz9fzVMLjxPigsoMsIVbFtt/QUBxmaGczgVt6wBi63c7pLvbQmKT8RCDmt8inRacn8saL
        i9/OCqAtdFacL6PBxaVcQGRmkdXvsa4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-PvlbMDYMM1euSXjWMkrM3A-1; Mon, 20 Apr 2020 04:47:20 -0400
X-MC-Unique: PvlbMDYMM1euSXjWMkrM3A-1
Received: by mail-wr1-f71.google.com with SMTP id a3so5406491wro.1
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 01:47:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HbB4dFblI4nSgTZkQmOILmsy2bt4PNUY80Flmj8Lzl0=;
        b=uAlCfn8G+g3yqNFJaGWRD8jFktTEl9b61bevHfyNEw/5wQh1YPpdMPR8U2TMw8PYwt
         3EEeWvQJiqw5vntkxKoPVcJz4kRmlf0oduwxfZvXVAzRkbNug2fTg9W7uN6aIFBnCW/z
         uxA9HWDkXSpbeCbbHVfHovalCBtSNgJ+dRksjjfmK7ijnFUwNn3zEXeEOkYpS0V/QkBk
         1S5ZHg37yqQNe3xye7j0pmazbFI3Uo0TA8uR6mS0a+4qd2d6gM/CkEodqywqIYlOE7do
         owF8POziq1KN9MEFsRcPyPXWelcb5DcPlSI0aQjjyCNIlM9V5fS+j+JRpupaWNeaF9Hp
         +GEw==
X-Gm-Message-State: AGi0PuZLsDns1SJUhIf1U1vHmtaj6uXMw9sQZDc1ByrPpJkwVPw/+xvF
        TYlCzcX4MWIpDqXIVDFFaMU6A/NYaTZxrnBudaY52XK/dhYV3xliJYO6uBJwWCgqdKz7BjRwi0z
        K7pQU+kLTv6kh
X-Received: by 2002:adf:f084:: with SMTP id n4mr17933034wro.252.1587372438729;
        Mon, 20 Apr 2020 01:47:18 -0700 (PDT)
X-Google-Smtp-Source: APiQypIQKIa8NoerU8Gs+f1YIbzGfr00jazQ0JAuCubChZ7eiigPoEuXv07nc8JJRA7S+0bhRS0rDw==
X-Received: by 2002:adf:f084:: with SMTP id n4mr17933020wro.252.1587372438535;
        Mon, 20 Apr 2020 01:47:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t16sm458850wmi.27.2020.04.20.01.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 01:47:18 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: x86: check_nested_events is never NULL
In-Reply-To: <20200417164413.71885-2-pbonzini@redhat.com>
References: <20200417164413.71885-1-pbonzini@redhat.com> <20200417164413.71885-2-pbonzini@redhat.com>
Date:   Mon, 20 Apr 2020 10:47:16 +0200
Message-ID: <87a736tugb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Both Intel and AMD now implement it, so there is no need to check if the
> callback is implemented.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 59958ce2b681..0492baeb78ab 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7699,7 +7699,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
>  	 * from L2 to L1 due to pending L1 events which require exit
>  	 * from L2 to L1.
>  	 */
> -	if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events) {
> +	if (is_guest_mode(vcpu)) {
>  		r = kvm_x86_ops.check_nested_events(vcpu);
>  		if (r != 0)
>  			return r;
> @@ -7761,7 +7761,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
>  		 * proposal and current concerns.  Perhaps we should be setting
>  		 * KVM_REQ_EVENT only on certain events and not unconditionally?
>  		 */
> -		if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events) {
> +		if (is_guest_mode(vcpu)) {
>  			r = kvm_x86_ops.check_nested_events(vcpu);
>  			if (r != 0)
>  				return r;
> @@ -8527,7 +8527,7 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>  
>  static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
>  {
> -	if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events)
> +	if (is_guest_mode(vcpu))
>  		kvm_x86_ops.check_nested_events(vcpu);
>  
>  	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&

While the callback is implemented for both VMX and SVM, it can still be
NULL when !nested (thus patch subject is a bit misleading) but
is_guest_mode() implies this is not the case.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

