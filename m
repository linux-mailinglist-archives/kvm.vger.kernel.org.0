Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500132C5517
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 14:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390088AbgKZNNj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 08:13:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27491 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390080AbgKZNNj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Nov 2020 08:13:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606396417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HvROoBrLm2Fl8g98GGvDWrhSf1YkmYUSt3gbqPxqL3Q=;
        b=PxZtIrBNyvmnhuMK7EffexDwbrrIwVOhzZBEzzDZX5a5zyFZIxzM5vvXlcx0HTC7pvVh3G
        OgjD8knVvDEbV8lYp55FCBZE8a4QxH5fKK4vpiJgFZAUlhqKigFigrYWeR234QDHLFYMMR
        Kpp+yxl0YW4fHUCj22ZBs5t8j9sm9XY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-sz6VQbisOX-QM2AesT_WqQ-1; Thu, 26 Nov 2020 08:13:35 -0500
X-MC-Unique: sz6VQbisOX-QM2AesT_WqQ-1
Received: by mail-wm1-f71.google.com with SMTP id o17so1347047wmd.9
        for <kvm@vger.kernel.org>; Thu, 26 Nov 2020 05:13:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HvROoBrLm2Fl8g98GGvDWrhSf1YkmYUSt3gbqPxqL3Q=;
        b=cVwoq8RJBzekn/m2/9QO8IKyk3twEQh3P6E1Dc6lK9R6P5AcsAZVW/+grB5+nmxP3z
         NWJt4i/0GjDeIni8SsELlc9cnaAftcvlo647pALHL3Ffp1CPHuLwBLp9Wti/Q3c5ZNIz
         L0yDyeDsOpElqIw5FmMaeMaaYDA3KpeiaiunijPGdSxMWoDwcBPDk93+maSc/8vNiN0L
         /aaPkkIYmdZMk6PMLi71+ty7RaLCqvgqGnms+lUzaWWxdgVf+6xTtVQDWPr5CUedOhf7
         xSoxvAqKcM/2exGmxNCG6AFXsY92D6H3ayXgOMcgjxmQhbVV6MHGVSX1YigoJsrNZjFI
         860A==
X-Gm-Message-State: AOAM531QX2yN5SXbAUL4B4Ab/BlPu9XUhYsfwyrXkin/9DcDjQQdO4/z
        3K8RyXJNYz0GsajjehY9LkOc6vVYdHuyqj/jPrtGVpNOAbDNBuNqrESajlT/VR9ZjqmwrJmKr/n
        7GG2PvPgdujpq
X-Received: by 2002:a5d:6689:: with SMTP id l9mr3788755wru.134.1606396413650;
        Thu, 26 Nov 2020 05:13:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw2X5TqtaP+sYxCew3Mpv22W83pXgju8y+0wnsNP81+5lKMBRCSHdFKhHZSz8ASdg7+HoupcA==
X-Received: by 2002:a5d:6689:: with SMTP id l9mr3788736wru.134.1606396413447;
        Thu, 26 Nov 2020 05:13:33 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b3sm8607472wrp.57.2020.11.26.05.13.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2020 05:13:32 -0800 (PST)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>, liam.merwick@oracle.com,
        wanpeng.li@hotmail.com
References: <20201123192223.3177490-1-oupton@google.com>
 <4788d64f-1831-9eb9-2c78-c5d9934fb47b@redhat.com>
 <CAOQ_QsiUAVob+3hnAURJF-1+GdRF9HMtuxpKWCB-3m-abRGqxw@mail.gmail.com>
 <CAOQ_QshMoc9W9g6XRuGM4hCtMdvUxSDpGAhp3vNxhxhWTK-5CQ@mail.gmail.com>
 <20201124015515.GA75780@google.com>
 <e140ed23-df91-5da2-965a-e92b4a54e54e@redhat.com>
 <20201124212215.GA246319@google.com>
 <d5f4153b-975d-e61d-79e8-ed86df346953@redhat.com>
 <20201125011416.GA282994@google.com>
 <13e802d5-858c-df0a-d93f-ffebb444eca1@redhat.com>
 <20201125183236.GB400789@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 11/11] KVM: nVMX: Wake L2 from HLT when nested
 posted-interrupt pending
Message-ID: <89fe1772-36c7-7338-69aa-25d84a9febe8@redhat.com>
Date:   Thu, 26 Nov 2020 14:13:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201125183236.GB400789@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/11/20 19:32, Sean Christopherson wrote:
> I'm pretty sure the exiting vCPU needs to wait
> for all senders to finish their sequence, otherwise pi_pending could be left
> set, but spinning on pi_pending is wrong.

What if you set it before?

static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
						int vector)
{
	struct vcpu_vmx *vmx = to_vmx(vcpu);

	if (is_guest_mode(vcpu) &&
	    vector == vmx->nested.posted_intr_nv) {
		/*
		 * Set pi_pending after ON.
		 */
		smp_store_release(&vmx->nested.pi_pending, true);
		if (!kvm_vcpu_trigger_posted_interrupt(vcpu, true)) {
			/*
			 * The guest was not running, let's try again
			 * on the next vmentry.
			 */
			<set PINV in L1 vIRR>
			kvm_make_request(KVM_REQ_EVENT, vcpu);
			kvm_vcpu_kick(vcpu);
			vmx->nested.pi_pending = false;
		}
		write_seqcount_end(&vmx->nested.pi_pending_sc);
		return 0;
	}
	return -1;
}

On top of this:

- kvm_x86_ops.hwapic_irr_update can be deleted.  It is already done 
unconditionally by vmx_sync_pir_to_irr before every vmentry.  This gives 
more freedom in changing vmx_sync_pir_to_irr and vmx_hwapic_irr_update.

- VCPU entry must check if max_irr == vmx->nested.posted_intr_nv, and if 
so send a POSTED_INTR_NESTED_VECTOR self-IPI.

Combining both (and considering that AMD doesn't do anything interesting 
in vmx_sync_pir_to_irr), I would move the whole call to 
vmx_sync_pir_to_irr from x86.c to vmx/vmx.c, so that we know that 
vmx_hwapic_irr_update is called with interrupts disabled and right 
before vmentry:

  static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
  {
	...
-	vmx_hwapic_irr_update(vcpu, max_irr);
         return max_irr;
  }

-static void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
+static void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu)
  {
+	int max_irr;
+
+	WARN_ON(!irqs_disabled());
+	max_irr = vmx_sync_pir_to_irr(vcpu);
         if (!is_guest_mode(vcpu))
                 vmx_set_rvi(max_irr);
+	else if (max_irr == vmx->nested.posted_intr_nv) {
+		...
+	}
  }

and in vmx_vcpu_run:

+	if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
+		vmx_hwapic_irr_update(vcpu);


If you agree, feel free to send this (without the else of course) as a 
separate cleanup patch immediately.

Paolo

