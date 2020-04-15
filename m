Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981451AA1B7
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 14:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370192AbgDOMpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 08:45:53 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58312 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2898222AbgDOMp3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 08:45:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586954726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vAlovoyi5PA4D+Fqa/NczMkBNI951G2MPlQuUiIGWTU=;
        b=UPst2DT+sWNMdSry38jqC5Kw5oxVE+DPyIusIOWAT0NOwtQdoPMA+w99NnCE57zlUfa8NG
        yaWodOC2cQEG90AlS3iUzeUYtoFJ22j2tDgvqOuCitQ/hPsQFCfKP217Nqp3diGLOqBPIV
        g2bYG0Ar71TzO6LEZ1CZO+ME2I42q60=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-UF2F98UvPPuH7W6GfA0eXw-1; Wed, 15 Apr 2020 08:45:19 -0400
X-MC-Unique: UF2F98UvPPuH7W6GfA0eXw-1
Received: by mail-wr1-f71.google.com with SMTP id j16so9822247wrw.20
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 05:45:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vAlovoyi5PA4D+Fqa/NczMkBNI951G2MPlQuUiIGWTU=;
        b=aYNNJGwouUB78Ub8g0KJ+fuFA+HDMtdzkWupU6QDH9ccic3JamHArmmkYzPPToY4El
         Ah/D2dK6QZsl97dqOsuTFasT4GH+XsXcKSGoF2YmVoEjvpOPnp0Or4F8N+A1QAIvJLlO
         Yhs8gXs+tRNi1b3LSHZ0uymeG7B57cffnxcWN16pD/UwRmtyRLGr5gd2W29UePSvnxpo
         li1KjM6EGxpmCl3V5k58GStPOr5U0JaVA/S9btMF2Q8XWYvFVOk4hAIvUGT8GndKybsA
         ZGMKzw73HBrKmDXkk5Mi2lWuS3Nua/2LSEY/qkjocHniPJqTJlVFmE4ThGaLQFCisD/v
         CyFA==
X-Gm-Message-State: AGi0PuYiymalYOVkI23VCYOUKdcHkvuhaq3TfMRW7ZMjKOM3h4j6YKO9
        wnknSoxVhI4sxrX/Ktw4JBxthgHA7l04EGQg2kr0BtKTCkEh+GWrDMlSAnNuI+Lule9moF5OYs0
        VkHzNMRUSpF7F
X-Received: by 2002:adf:e942:: with SMTP id m2mr28849933wrn.364.1586954717747;
        Wed, 15 Apr 2020 05:45:17 -0700 (PDT)
X-Google-Smtp-Source: APiQypJKPyYvpGgkRePJv+9rAQwzxja3UlK/XUhK4cNv9GoxnsNJrHaNpgzSFb37TbJIKtZpEkFYyQ==
X-Received: by 2002:adf:e942:: with SMTP id m2mr28849913wrn.364.1586954717511;
        Wed, 15 Apr 2020 05:45:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e? ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
        by smtp.gmail.com with ESMTPSA id g186sm23460498wme.7.2020.04.15.05.45.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 05:45:16 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: SVM: Implement check_nested_events for NMI
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Cathy Avery <cavery@redhat.com>
Cc:     wei.huang2@amd.com, Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200414201107.22952-1-cavery@redhat.com>
 <87zhbdw02i.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7e4bfa85-559e-79b0-268f-1a3024559b34@redhat.com>
Date:   Wed, 15 Apr 2020 14:45:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87zhbdw02i.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/20 11:49, Vitaly Kuznetsov wrote:
> Not directly related to this series but I just noticed that we have the
> following comment in inject_pending_event():
> 
> 	/* try to inject new event if pending */
> 	if (vcpu->arch.exception.pending) {
>                 ...
> 		if (vcpu->arch.exception.nr == DB_VECTOR) {
> 			/*
> 			 * This code assumes that nSVM doesn't use
> 			 * check_nested_events(). If it does, the
> 			 * DR6/DR7 changes should happen before L1
> 			 * gets a #VMEXIT for an intercepted #DB in
> 			 * L2.  (Under VMX, on the other hand, the
> 			 * DR6/DR7 changes should not happen in the
> 			 * event of a VM-exit to L1 for an intercepted
> 			 * #DB in L2.)
> 			 */
> 			kvm_deliver_exception_payload(vcpu);
> 			if (vcpu->arch.dr7 & DR7_GD) {
> 				vcpu->arch.dr7 &= ~DR7_GD;
> 				kvm_update_dr7(vcpu);
> 			}
> 		}
> 
> 		kvm_x86_ops.queue_exception(vcpu);
> 	}
> 
> As we already implement check_nested_events() on SVM, do we need to do
> anything here? CC: Jim who added the guardian (f10c729ff9652).

It's (still) okay because we don't use check_nested_events() for exceptions.

Regarding this series, I think we should implement the NMI injection
test for VMX and see if it requires the same change as patch 2.

Paolo

