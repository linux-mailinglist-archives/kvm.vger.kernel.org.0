Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3FC1C5E6E
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 19:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbgEERMo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 13:12:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30706 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729777AbgEERMn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 13:12:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588698762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TWi1/ExgoalyHAzreZR6yoN0Ak47l5IuTf5AyOZQ3ik=;
        b=J3VbiBvlbnW/bOjWdmtfYynu79rzK+vlINoDwmWcaTKqja1XSdBgUmE138nPcSu/GA1oG8
        gZhG5MJiDv9m5GCO9jAlIHxYDeQWbLo6DlHtEPVOCg19hyRgUNw9t9AgpYNAFfalsAg7Eo
        T9dnKWzV1zUCCbROrM2Fw4UWXyEufP0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-o22COhwcNFq3DDs8H1qKzQ-1; Tue, 05 May 2020 13:12:40 -0400
X-MC-Unique: o22COhwcNFq3DDs8H1qKzQ-1
Received: by mail-wr1-f71.google.com with SMTP id f2so1543371wrm.9
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 10:12:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TWi1/ExgoalyHAzreZR6yoN0Ak47l5IuTf5AyOZQ3ik=;
        b=jWa1xNMpB7PlAUHLiu6c4uGOOo6VeA3IKyNtD/lZAampdsMyq7v88R5nAcjLxPMRAx
         9tbTK7k4sP3FRH+sz/OsSC90mas/WfENyKQJEFiPm1ogRtpy5BzuEq5U/tuEyo4N0bgF
         IFh/2SygGA++xiyQ/KjPx34rGDcuQ6BC2/+OFbPaUEMvf1i4vP37oQAxXg6lxeYOjdv6
         2o7wSHXyh+BFMb7yJy2olLnGIEblTbjybC0PRYkZhRlDfvbbbhyl+IqgIz0Ff6f/BCnx
         UUP2Z83mkMyMF9Dx2AmhXnq/f11eko78viOR5nlTOsDGwUZkmfZXWP4V0cZGLO6L9RMh
         ZA4A==
X-Gm-Message-State: AGi0PuY74P26kD5PY66gCwe0c9mEMPFquHDF8nEfNdPlcubBQKKt8vti
        h0/wge+9B5rnMGoKbB3QYsyhB7nRJL5O6yiXnQKXPk/c6Ymc+rXQ4no32o5ghyMoTuCLQOtEEFf
        RdJW3HK6tFM/Q
X-Received: by 2002:adf:a297:: with SMTP id s23mr4902257wra.54.1588698759216;
        Tue, 05 May 2020 10:12:39 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ+wioukX6WMwi3IK6WjkRtFHM+jyaRgxTXMYD/QERUdMXHggoBt0hb8YQ1Vh2W9SGOmrpABw==
X-Received: by 2002:adf:a297:: with SMTP id s23mr4902243wra.54.1588698759017;
        Tue, 05 May 2020 10:12:39 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id 5sm1798016wmz.16.2020.05.05.10.12.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 10:12:38 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Declare KVM_CAP_SET_GUEST_DEBUG properly
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200505154750.126300-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <127c6e28-2dea-8f28-7200-2185d0d49505@redhat.com>
Date:   Tue, 5 May 2020 19:12:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200505154750.126300-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/20 17:47, Peter Xu wrote:
> KVM_CAP_SET_GUEST_DEBUG should be supported for x86 however it's not declared
> as supported.  My wild guess is that userspaces like QEMU are using "#ifdef
> KVM_CAP_SET_GUEST_DEBUG" to check for the capability instead, but that could be
> wrong because the compilation host may not be the runtime host.
> 
> The userspace might still want to keep the old "#ifdef" though to not break the
> guest debug on old kernels.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
> 
> I also think both ppc and s390 may need similar thing, but I didn't touch them
> yet because of not confident enough to cover all cases.

Indeed, I'll squash this:

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index e15166b0a16d..ad2f172c26a6 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -521,6 +521,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_IMMEDIATE_EXIT:
+	case KVM_CAP_SET_GUEST_DEBUG:
 		r = 1;
 		break;
 	case KVM_CAP_PPC_GUEST_DEBUG_SSTEP:
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 5dcf9ff12828..d05bb040fd42 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -545,6 +545,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_AIS:
 	case KVM_CAP_S390_AIS_MIGRATION:
 	case KVM_CAP_S390_VCPU_RESETS:
+	case KVM_CAP_SET_GUEST_DEBUG:
 		r = 1;
 		break;
 	case KVM_CAP_S390_HPAGE_1M:

