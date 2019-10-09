Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5041CD0A02
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 10:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbfJIIiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 04:38:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfJIIiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 04:38:13 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A059CC054907
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 08:38:12 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id k4so775614wru.1
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 01:38:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6sCDH8nIKuAbvdBSReQkc1Tfo1aumnautyMnOnbULKw=;
        b=SiprImX2CwdZ4kPgfhJzj7iQVtseE+HUEfXMe44/toFlKIROwzY1tt84Lx122pR++W
         jF2ZSNfGExpiUQ6YiboJJ8HLFXvWyL/pFhUhljazdhqfN4CKqArFe7kTKtYK6WD9TO27
         3C3OKnd2OvPz0GzAQqBeoHYrN6cya0eemjnrBY169CQLgxEIyGtICeiW+4i4YE2Md44X
         9+2Lb0EpUqcH4mYQBJpKsGx4Rx69S0RagdoZ9qkO/kqrIWHy4VR59naYEal6HwU648+q
         TNg8ERME8ZooYFcQQEXe7Zwwvqso1l77yRRNt+Sc8uXqbmXy2he6X/FzNDcnl2yHool3
         m/PA==
X-Gm-Message-State: APjAAAWPUxMsstvZf/fEbqZ7GzPnjdvccXx3YaZFZ55qUvXopAE+dv9A
        6s/6HuYrNYESJN1f4rZNTBDNjJFYjyilRrfYrtsX5I+kzcjKoo6Nmdh6IJskPQK4JedK91xkvSA
        b+IcB/GKyGB3t
X-Received: by 2002:a1c:3884:: with SMTP id f126mr1648372wma.162.1570610291195;
        Wed, 09 Oct 2019 01:38:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxQZaix6vJKYl2c9qjg9YpvxY0MzDGVuhPitYZByc1tDk3IGmYtrO+zhOBVanBCC7oo9lFJ2g==
X-Received: by 2002:a1c:3884:: with SMTP id f126mr1648349wma.162.1570610290915;
        Wed, 09 Oct 2019 01:38:10 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id q10sm3014658wrd.39.2019.10.09.01.38.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 01:38:10 -0700 (PDT)
Subject: Re: [PATCH v3 04/16] kvm: x86: Add support for activate/de-activate
 APICv at runtime
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
 <1568401242-260374-5-git-send-email-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5a5b13e9-4efa-b35c-dc22-003ff3109b07@redhat.com>
Date:   Wed, 9 Oct 2019 10:38:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1568401242-260374-5-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/09/19 21:00, Suthikulpanit, Suravee wrote:
> +	kvm_for_each_vcpu(i, v, kvm)
> +		kvm_clear_request(KVM_REQ_APICV_DEACTIVATE, v);
> +
> +	if (kvm_x86_ops->pre_update_apicv_exec_ctrl)
> +		kvm_x86_ops->pre_update_apicv_exec_ctrl(vcpu, true);
> +
> +	kvm->arch.apicv_state = APICV_ACTIVATED;
> +
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_ACTIVATE);
> +
> +	mutex_unlock(&kvm->arch.apicv_lock);

I think a lot of this logic can be simplified.  In particular, I would have:

- a single KVM_REQ_APICV_TOGGLE request that unifies
kvm_vcpu_activate_apicv and kvm_vcpu_deactivate_apicv.  The invariant is
that, at the end of the function, (vcpu->arch.apicv_active ==
(kvm->arch.apicv_state = APICV_ACTIVATED)).  The apicv_lock then becomes
an rwsem, so that kvm_activate_apic and kvm_deactivate_apic will
down_write it, while the processing of KVM_REQ_APICV_TOGGLE can
down_read it.

- the srcu_read_unlock/srcu_read_lock should be hidden in
svm_request_activate_avic/svm_request_deactivate_avic.  Everything else
should only take struct kvm*, following what you've started with patch
1.  In particular kvm_vcpu_deactivate_apicv should be changed to take a
struct kvm*, so that Hyper-V can do kvm_deactivate_apic(kvm,
APIC_DISABLED).  Hyper-V should not care about
srcu_read_lock/srcu_read_unlock.  avic_setup_access_page and
avic_destroy_access_page also can be changed to take struct kvm*.

Paolo
