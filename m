Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6C07ECDE8
	for <lists+kvm@lfdr.de>; Sat,  2 Nov 2019 10:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfKBJ5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Nov 2019 05:57:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfKBJ5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Nov 2019 05:57:55 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A153281DE7
        for <kvm@vger.kernel.org>; Sat,  2 Nov 2019 09:57:54 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id z9so7069844wrq.11
        for <kvm@vger.kernel.org>; Sat, 02 Nov 2019 02:57:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SnHbm5y0Oc/bW/z1BoC7Pi238VT3ZqMdoywC0g3dFqE=;
        b=Oj7SjXge7+/GzYVLj8S5fkfFgcqTPnUwbH+qrAB7YlbUkGfO+uFFqnTxbfTqchxWIi
         R/CBBnqndtY4o4T2pdn2i9C4U3j/jzXOt+Hx0fZJs+9X0/VN6oFbZ1Gygx0dhrLroNvy
         jABKduEikNWzZn1Hoa1o7TuycXe1sja+osptqT4/ax8Mg0ZHarmx6MqG5AklzNYg/s/5
         d7/ltfEhQ5fJR0Z/xdSACCi/HDy5rL36l7k+PPxTJ0X/g6yyKgjCcFUn5Txrhg0LSeQ2
         jZ0JTpSAMzOHi2zCEIlK/kZas9LAUkegasL/M/fIpHHeKJMxbVq0eog6kSNUHoDunr1x
         m63g==
X-Gm-Message-State: APjAAAWfBd0eK+5uOeq8cilPYixj/IImwz3Zx40jTwlHgHfI74vORza2
        iI4g4shBpwUsEoWkHkrqBuEeL+rqas6hBMgqNkAqCK+yuHOHLSSRI+ubqDYo+BvNkeRMojhaZJw
        2XhRqt11Ej4lD
X-Received: by 2002:a1c:30b:: with SMTP id 11mr13328565wmd.171.1572688673231;
        Sat, 02 Nov 2019 02:57:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwMtBcN4tvFrgKHDyWSQtioXzaXI4x0h0y0bnWOcsBB94u0qohWSD5sllxyRxSFBaO4a4+hVw==
X-Received: by 2002:a1c:30b:: with SMTP id 11mr13328541wmd.171.1572688672941;
        Sat, 02 Nov 2019 02:57:52 -0700 (PDT)
Received: from [192.168.42.35] (mob-31-159-163-247.net.vodafone.it. [31.159.163.247])
        by smtp.gmail.com with ESMTPSA id l14sm10780581wrr.37.2019.11.02.02.57.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Nov 2019 02:57:52 -0700 (PDT)
Subject: Re: [PATCH v4 13/17] kvm: i8254: Deactivate APICv when using
 in-kernel PIT re-injection mode.
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1572648072-84536-14-git-send-email-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <70fb2b49-2198-bde4-a38b-f37bc8bc9847@redhat.com>
Date:   Sat, 2 Nov 2019 10:57:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1572648072-84536-14-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/11/19 23:41, Suthikulpanit, Suravee wrote:
> +	/*
> +	 * AMD SVM AVIC accelerates EOI write and does not trap.
> +	 * This cause in-kernel PIT re-inject mode to fail
> +	 * since it checks ps->irq_ack before kvm_set_irq()
> +	 * and relies on the ack notifier to timely queue
> +	 * the pt->worker work iterm and reinject the missed tick.
> +	 * So, deactivate APICv when PIT is in reinject mode.
> +	 */
>  	if (reinject) {
> +		kvm_request_apicv_update(kvm, false, APICV_DEACT_BIT_PIT_REINJ);
>  		/* The initial state is preserved while ps->reinject == 0. */
>  		kvm_pit_reset_reinject(pit);
>  		kvm_register_irq_ack_notifier(kvm, &ps->irq_ack_notifier);
>  		kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
>  	} else {
> +		kvm_request_apicv_update(kvm, true, APICV_DEACT_BIT_PIT_REINJ);
>  		kvm_unregister_irq_ack_notifier(kvm, &ps->irq_ack_notifier);
>  		kvm_unregister_irq_mask_notifier(kvm, 0, &pit->mask_notifier);

This is not too nice for Intel which does support (through the EOI exit
mask) APICv even if PIT reinjection active.

We can work around it by adding a global mask of inhibit reasons that
apply to the vendor, and initializing it as soon as possible in vmx.c/svm.c.

Then kvm_request_apicv_update can ignore reasons that the vendor doesn't
care about.

Paolo
