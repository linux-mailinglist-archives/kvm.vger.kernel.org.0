Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6740D1EE52F
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 15:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgFDNVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 09:21:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25580 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728055AbgFDNVA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 09:21:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591276858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w2fWETB1TaNz9IcATv1ANUA4w7IHk/OTfNxTX41Bqeg=;
        b=DYXohEECgWyXyYcBg59OabJUfOvUiBI/KDzOTW34qF+7tQCKtF5hRCukT4ngUy3zlXdHEz
        W5rLvuoPv9ptTEWMc4BrW1ywRZht22uMTJx1uKeQn/7PNjfNNW1+DBDNN0f7NS4BoCRgER
        QBJMQs93rsbpUpLcwfzEXiWMyn+4dXM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-Hhnu135ENHePlRFeH7XaYg-1; Thu, 04 Jun 2020 09:20:57 -0400
X-MC-Unique: Hhnu135ENHePlRFeH7XaYg-1
Received: by mail-wm1-f72.google.com with SMTP id f62so1789717wme.3
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 06:20:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w2fWETB1TaNz9IcATv1ANUA4w7IHk/OTfNxTX41Bqeg=;
        b=b8n2mAa/K52Ej0YVuVFnCjM13zDc54zDVLIbGJubx/gfeqUHwFn+2UhMKuWcY77vsS
         aHJd3zU6Wm79TVcTUKGPOeFqrJRGc4EL/x3R5w0wmQbDzncIotkAwiO9VEAmez3NW1mO
         DbMfgWITt/lU/JG0KxgU7vyf8LjCGz70X1n5l8p/43Gm1xaCOdssNrirzfer9BgIr0S8
         k6lkF9W7utNQC+LvjrqbCHiSYr9ZNJts/80plL4xJD299slU6PxAtRj7oUJhhVF9zp86
         pJK0NDYdIxzgSmR6smD5v3vag1shDPTtjUZMD4HuUDc4gTV7ea9JeK2Rq5JkbZbndbwL
         PVZw==
X-Gm-Message-State: AOAM532Ly2b5NGizI5Yd6ZWhgfz+GJao0j6VEp+d3rvcwJLJUXW1welk
        kQJLg9guIrJuKJjlV487k6B9kA6U8/nF4YDbpXIl1fsMkzhwC2DxeTa+Sj+mh/gWWHtOES5N7gn
        I/l8GK34MbkpB
X-Received: by 2002:adf:fec8:: with SMTP id q8mr4638997wrs.2.1591276855840;
        Thu, 04 Jun 2020 06:20:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7bVhcWIgCtyiIS/HcBgCGmNBSEIn+XtgiwQg8Y7cLzf42w5pKcKysY6nUP5xQe0z5YU0Inw==
X-Received: by 2002:adf:fec8:: with SMTP id q8mr4638981wrs.2.1591276855606;
        Thu, 04 Jun 2020 06:20:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id a1sm7316698wmj.29.2020.06.04.06.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 06:20:54 -0700 (PDT)
Subject: Re: WARNING in kvm_inject_emulated_page_fault
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com
Cc:     syzbot <syzbot+2a7156e11dc199bdbd8a@syzkaller.appspotmail.com>,
        bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        wanpengli@tencent.com, x86@kernel.org
References: <000000000000c8a76e05a73e3be3@google.com>
 <874krrf6ga.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c15b3ad0-0062-f106-0746-d018cf33adbb@redhat.com>
Date:   Thu, 4 Jun 2020 15:20:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <874krrf6ga.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/20 12:53, Vitaly Kuznetsov wrote:
> Exception we're trying to inject comes from
> 
>  nested_vmx_get_vmptr()
>   kvm_read_guest_virt()
>    kvm_read_guest_virt_helper()
>      vcpu->arch.walk_mmu->gva_to_gpa()
> 
> but it seems it is only set if GVA to GPA convertion fails. In case it
> doesn't, we can still fail kvm_vcpu_read_guest_page() and return
> X86EMUL_IO_NEEDED but nested_vmx_get_vmptr() doesn't case what we return
> and does kvm_inject_emulated_page_fault(). This can happen when VMXON
> parameter is MMIO, for example.
> 
> How do fix this? We can either properly exit to userspace for handling
> or, if we decide that handling such requests makes little sense, just
> inject #GP if exception is not set, e.g. 
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 9c74a732b08d..a21e2f32f59b 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4635,7 +4635,11 @@ static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
>                 return 1;
>  
>         if (kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e)) {
> -               kvm_inject_emulated_page_fault(vcpu, &e);
> +               if (e.vector == PF_VECTOR)
> +                       kvm_inject_emulated_page_fault(vcpu, &e);
> +               else
> +                       kvm_inject_gp(vcpu, 0);
> +
>                 return 1;
>         }
> 

Yes, this is a plausible fix (with a comment explaining that we are 
taking a shortcut).  Perhaps a better check would be 

	r = kvm_read_guest_virt(vcpu, gva, vmpointer, sizeof(*vmpointer), &e);
	if (r != X86EMUL_CONTINUE) {
		if (r == X86EMUL_PROPAGATE_FAULT) {
			kvm_inject_emulated_page_fault(vcpu, &e);
		} else {
			/* ... */
			kvm_inject_gp(vcpu, 0);
		}
		return 1;
	}

Are you going to send a patch?

Paolo

