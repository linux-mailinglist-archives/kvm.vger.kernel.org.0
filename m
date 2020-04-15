Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A88F1A9981
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 11:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895998AbgDOJvl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 05:51:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54830 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2895874AbgDOJti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 05:49:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586944176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qaGXYPrjx6asVnwUlRwgPZ9xv0d8gA5/xd4DP6F32Eg=;
        b=f+XE5fH3w+CTeU7C/7DW0Rh5upeav7Dq8MYzb5UOOVQChq7gj+eSinhy0HBhwUHmYR2EVJ
        L7jsnziyvb2oXbp/SQJ5zjM7NGYnYBzt9thN0HW8U9LbH8o2veIbnC0Ss6pLvg3BX8XgwN
        pVTaoNQPlHdOoLU2/Jx57q4ZepS00Qo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-zuQkAaVWNDSyFX0f3eWziQ-1; Wed, 15 Apr 2020 05:49:28 -0400
X-MC-Unique: zuQkAaVWNDSyFX0f3eWziQ-1
Received: by mail-wm1-f71.google.com with SMTP id q5so3647541wmc.9
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 02:49:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=qaGXYPrjx6asVnwUlRwgPZ9xv0d8gA5/xd4DP6F32Eg=;
        b=sHWtBQlszF3VTcg9vcWAwDjliTzL73PCvYwfCiC+6YJLr/m1zCvaNgAOmbnMV6emJR
         +3ISLN04hGHAW2cpxX3dDvWRgL3ONr/+47hOhMJz4yIXkhvSxGllzfrt5lWKeOBdcwzx
         wt7HOK4YO5ek44FMvV5EWP9C2wOKnjGQOZPrQZYY/y31wY0IZ8+xWAhrywVMn2dwscO3
         b+QgdrA8bynYE8RMVxL+wN/FJ7RSL5Vq//+CxkczY5K4Xk64Q7QZuEEHo4nMva3FCkkl
         kiYKEeQDcp0KtKZEuEmtc5wfHtwvGiFzcq6TVLPz/45fXqT+RvYiSXpxMLqX8T13/AVe
         6CWQ==
X-Gm-Message-State: AGi0Pube+Fw8REPdrHa2q3YnUx0aX+uqCwNCf8+2OZiwUiUV1O6PbPeT
        npKVi24jvZmQ5PZfoXajd431uUpwR5i/VuYUkUpsu6U6hDPq7ucDdCsgzn0KnTwrS2lBFqQoZi1
        KQV2R+M0R3WUy
X-Received: by 2002:a05:6000:1008:: with SMTP id a8mr22513582wrx.189.1586944166845;
        Wed, 15 Apr 2020 02:49:26 -0700 (PDT)
X-Google-Smtp-Source: APiQypK6iom3TxtitcFG3fEyEhV0IQri7rGaW4po1K8ddZ+k0gAwKo+5fXC8PqAQAruae6CWSJ1r4g==
X-Received: by 2002:a05:6000:1008:: with SMTP id a8mr22513570wrx.189.1586944166653;
        Wed, 15 Apr 2020 02:49:26 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l15sm21578535wmi.48.2020.04.15.02.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 02:49:26 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Cathy Avery <cavery@redhat.com>, pbonzini@redhat.com
Cc:     wei.huang2@amd.com, Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: SVM: Implement check_nested_events for NMI
In-Reply-To: <20200414201107.22952-1-cavery@redhat.com>
References: <20200414201107.22952-1-cavery@redhat.com>
Date:   Wed, 15 Apr 2020 11:49:25 +0200
Message-ID: <87zhbdw02i.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cathy Avery <cavery@redhat.com> writes:

> Moved nested NMI exit to new check_nested_events.
> The second patch fixes the NMI pending race condition that now occurs.
>
> Cathy Avery (2):
>   KVM: SVM: Implement check_nested_events for NMI
>   KVM: x86: check_nested_events if there is an injectable NMI
>

Not directly related to this series but I just noticed that we have the
following comment in inject_pending_event():

	/* try to inject new event if pending */
	if (vcpu->arch.exception.pending) {
                ...
		if (vcpu->arch.exception.nr == DB_VECTOR) {
			/*
			 * This code assumes that nSVM doesn't use
			 * check_nested_events(). If it does, the
			 * DR6/DR7 changes should happen before L1
			 * gets a #VMEXIT for an intercepted #DB in
			 * L2.  (Under VMX, on the other hand, the
			 * DR6/DR7 changes should not happen in the
			 * event of a VM-exit to L1 for an intercepted
			 * #DB in L2.)
			 */
			kvm_deliver_exception_payload(vcpu);
			if (vcpu->arch.dr7 & DR7_GD) {
				vcpu->arch.dr7 &= ~DR7_GD;
				kvm_update_dr7(vcpu);
			}
		}

		kvm_x86_ops.queue_exception(vcpu);
	}

As we already implement check_nested_events() on SVM, do we need to do
anything here? CC: Jim who added the guardian (f10c729ff9652).

>  arch/x86/kvm/svm/nested.c | 21 +++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c    |  2 +-
>  arch/x86/kvm/svm/svm.h    | 15 ---------------
>  arch/x86/kvm/x86.c        | 15 +++++++++++----
>  4 files changed, 33 insertions(+), 20 deletions(-)

-- 
Vitaly

