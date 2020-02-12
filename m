Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7945515AA1A
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 14:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgBLNdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 08:33:05 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33477 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725887AbgBLNdB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 08:33:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581514380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e4bOQL/UoLkr49ZKqo0O/BFOCGX6CyzTc0e1NCwjejI=;
        b=B4/Pu0NBsO8Lbadh00u5j5T6TwGTBQ+EH2wUsUehFB1GG4MoiPhdThc4Xt8fr/0XX0O+Me
        9BhO2+yYLG5nv6pjpjhcxt36dhY7ZJ3Q8XgNk8a4o0s08RJuID0uC8/xKxYMPjTtwauZ2l
        JVHz+s0ZZjJIQv1YJ//vvsqyplNAvGs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-AzvQwYN8MsKTsOJXymU9qQ-1; Wed, 12 Feb 2020 08:32:59 -0500
X-MC-Unique: AzvQwYN8MsKTsOJXymU9qQ-1
Received: by mail-wr1-f72.google.com with SMTP id u18so811036wrn.11
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 05:32:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e4bOQL/UoLkr49ZKqo0O/BFOCGX6CyzTc0e1NCwjejI=;
        b=DUxtO+w9r0cw6ahyNO33nK8iZXpVgUtb6YR2yXjlYy31ZShtaBqqPGeFMp1RkwaywV
         qDNaNYc0ndQy92wiH1bbl30gG4HrQKfc7Nc6c7nIDpTwevhgzUEeRBJSWYW1acI+1aHV
         UCaSkLJh59pDL5aTGKkB4pBYFGqyNz249dt07qkJxxQpMfdgqF8KULoRQE2CMeAghPA/
         QBdni2dKF1JYmiUXU01jHnGuc988T8QznYIY5ufBJ1DhdHfC9fgEQfw0O32jWXnX7F1a
         mSPkBDBm9Guw8iIdD7y4OYNZ+Xh5Wm5zn6as3dJ/jThmMqnUqwFRVsGF9aXDLVWbIfIH
         lCyQ==
X-Gm-Message-State: APjAAAXcTa0+99+CuWuijhvuRAif1r1tRmTxt3OIgZ+/blSST9K2KrPp
        Hpv+hS0WxYn0cdvmoJcZNDWuU2P1UfUIyFsLOb0XElyt6CyRRYS9XeqFprDhVRQtn+9DlJKigy1
        EB7dgzdy9JnGB
X-Received: by 2002:a1c:a382:: with SMTP id m124mr12809072wme.90.1581514378071;
        Wed, 12 Feb 2020 05:32:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqxAiJj4wSVeSVUkZduqtNVDQSCnCIY2kaA/PLl2NFBnzNHI2iwUhcPTT8a9mdJu8hwpEpD2/Q==
X-Received: by 2002:a1c:a382:: with SMTP id m124mr12809048wme.90.1581514377743;
        Wed, 12 Feb 2020 05:32:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:652c:29a6:517b:66d9? ([2001:b07:6468:f312:652c:29a6:517b:66d9])
        by smtp.gmail.com with ESMTPSA id a198sm768814wme.12.2020.02.12.05.32.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 05:32:56 -0800 (PST)
Subject: Re: [PATCH RFC 1/4] KVM: Provide kvm_flush_remote_tlbs_common()
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mips@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200207223520.735523-1-peterx@redhat.com>
 <20200207223520.735523-2-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c83a9193-d91b-0f64-d0c9-40b2bad86bdc@redhat.com>
Date:   Wed, 12 Feb 2020 14:33:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200207223520.735523-2-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/20 23:35, Peter Xu wrote:
> It's exactly kvm_flush_remote_tlbs() now but a internal wrapper of the
> common code path.  With this, an arch can then optionally select
> CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL=y and will be able to use the
> common flushing code.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>

Slightly more efficient, making it an inline function:

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e89eb67356cb..f92180eeffc6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -802,9 +802,18 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
 int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 
-void kvm_flush_remote_tlbs(struct kvm *kvm);
+void kvm_flush_remote_tlbs_common(struct kvm *kvm);
 void kvm_reload_remote_mmus(struct kvm *kvm);
 
+#ifdef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
+void kvm_flush_remote_tlbs(struct kvm *kvm);
+#else
+static inline void kvm_flush_remote_tlbs(struct kvm *kvm)
+{
+	kvm_flush_remote_tlbs_common(kvm);
+}
+#endif
+
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
 bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70f03ce0e5c1..027259af883e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -303,8 +303,7 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
 	return called;
 }
 
-#ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
-void kvm_flush_remote_tlbs(struct kvm *kvm)
+void kvm_flush_remote_tlbs_common(struct kvm *kvm)
 {
 	/*
 	 * Read tlbs_dirty before setting KVM_REQ_TLB_FLUSH in
@@ -328,8 +327,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 		++kvm->stat.remote_tlb_flush;
 	cmpxchg(&kvm->tlbs_dirty, dirty_count, 0);
 }
-EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
-#endif
+EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs_common);
 
 void kvm_reload_remote_mmus(struct kvm *kvm)
 {

