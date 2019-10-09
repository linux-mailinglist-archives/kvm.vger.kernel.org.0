Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B4BD0AF4
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 11:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbfJIJVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 05:21:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56646 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730595AbfJIJVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 05:21:55 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1E45D7E422
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 09:21:55 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id v17so811132wru.12
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 02:21:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3tiCUrFM7UgQAaYpJ9O5BDQtkAGta+t5JLpREvoir9o=;
        b=RWu/hAoiWKLBIMvB46QLwBi/hbl1jBHc55JOdrlaXSjfjSUl06R6TQ6Bu9Yw5Vaw7X
         pCeP2ILw0eVFBvc5Moc9tf2rOBMJSFGHSeqHnBg5lQL2UxK57Dea3B/d5ecO3umhkuTo
         vYHpKIXOrixmYFd1B5AOC6ijS6PBlg9PcA0i+Dfre30gfIyVjddSPvrPATI7yxiz1Bqn
         4miRTuAobQaRzk0A+j8HdS8ECRh4gmv+TzXhIs31vHgyryIGhMVc/EXohnSv9jGv3MTQ
         oIv0GmYX3bWTnxyKdnxFfVKl5ompFdfe3Bifu1G+G/ezy/LfN7DIKChQacjOGL5I/g7o
         15zA==
X-Gm-Message-State: APjAAAUEJVNd5hCsXbcn69R8NhOfeIDaekIk5clr9x0FG3ePlQrezjEv
        lqGPMSaeQyT4jfzOg3RPw53aBO55/VlBXMi5Bs091lkiiOefnCOSwllsVmXrc5dovazse9jhm/2
        mjrQqaCuK4VyA
X-Received: by 2002:a5d:6383:: with SMTP id p3mr2022218wru.117.1570612913652;
        Wed, 09 Oct 2019 02:21:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyt4jidLqSxvWUpFVvEmT+Zc0ViyZ4kyo/v4ezLgFfgvWATdcGptPkPtWtKPREHv7Wr2f1eHQ==
X-Received: by 2002:a5d:6383:: with SMTP id p3mr2022201wru.117.1570612913395;
        Wed, 09 Oct 2019 02:21:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f4b0:55d4:57da:3527? ([2001:b07:6468:f312:f4b0:55d4:57da:3527])
        by smtp.gmail.com with ESMTPSA id 59sm2695456wrc.23.2019.10.09.02.21.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 02:21:52 -0700 (PDT)
Subject: Re: [PATCH v3 09/16] kvm: x86: hyperv: Use APICv deactivate request
 interface
To:     "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1568401242-260374-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1568401242-260374-10-git-send-email-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <449c5ea4-9353-1822-10e6-7b10f5a1a6f3@redhat.com>
Date:   Wed, 9 Oct 2019 11:21:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1568401242-260374-10-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/09/19 21:01, Suthikulpanit, Suravee wrote:
> +	 *
> +	 * Since this requires updating
> +	 * APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
> +	 * also take srcu lock.

This comment is incorrect, it says you are entering a read-side critical
section to update the data structure.  It's only needed because
kvm_make_apicv_deactivate_request expects that it needs to unlock and
relock kvm->srcu.

Paolo

>  	 */
> -	kvm_vcpu_deactivate_apicv(vcpu);
> +	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> +	kvm_make_apicv_deactivate_request(vcpu, true);
> +	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
> +

