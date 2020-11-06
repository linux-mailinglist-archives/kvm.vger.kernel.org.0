Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2102A953E
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 12:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgKFL2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 06:28:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45960 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726422AbgKFL2B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 06:28:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604662079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1K9i9ruS4jIL2U02/jKI0wpm/jerg32NJ/aU93RO2t4=;
        b=aS8itcEViMzaKScIaNdpTowNu2pTVmy+3wRIbsamYlMLRgkou9lWPj0oJCWwu9Dn085nAQ
        LKC6IibkyuzlYE3lwM0aEwSQAUdweq8Iw3TnskVefHZq6ka+4RbuZqjm50z698oyDs8mPR
        kQLXJk3hwkXWBaBjDuL5P2K6sovzgec=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-LbSIKa1rNR6FXysXS5LtyA-1; Fri, 06 Nov 2020 06:27:57 -0500
X-MC-Unique: LbSIKa1rNR6FXysXS5LtyA-1
Received: by mail-wr1-f72.google.com with SMTP id q1so368895wrn.5
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 03:27:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1K9i9ruS4jIL2U02/jKI0wpm/jerg32NJ/aU93RO2t4=;
        b=r/4QjcDV8clyRZEkO/5xt6KY5z2u28xAtLNPxInLkr1tu/EPjf6xJr7Nw6JoiMqrMS
         kwNJOIAoJc5/QBu2tEEeEAFgnD9xr5UGVAklhqVW1hD9gtAtOIFkVhbCUILep+g3AjEx
         8piGsnHIYjwheN3q7G5rjeMBn9m3Tvqt1JpC4njqBohf03G5I6Y2d5kTTeCxe7T1ERhW
         CyNyefkgekHD8GF6atXjdk8uOMwjL64qoDg7dkXUnl5z3Ut9L3XxRwIXhSg3ThEFOByC
         Y+qlWOXsPhSevJpE/Qts4FZBopCele5cgsi+NyuTHe3Nh5IHijWJ/l1U9QQ4bP4xI4fN
         j+Sg==
X-Gm-Message-State: AOAM532+tTx68DGvg/Ea+wVyhTl5Pz2KFVBHOCog9fganO35t8VdFHpD
        iF98yJpr6+KnupDWimKykA2Nwxx/PFM6fADzg+LJysmWTEN3fnfsglVFlJLscL+D8S7VORnOA0Q
        EJ7KN3WLFukWC
X-Received: by 2002:adf:f7ce:: with SMTP id a14mr2169913wrq.294.1604662076342;
        Fri, 06 Nov 2020 03:27:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxlfeJ13M9lkzLsMZd4j/Z/aop2vh/k594tSsXCb3Xu5Tds0c8Jw/J5IxWRW/wjJRnnVBMPfQ==
X-Received: by 2002:adf:f7ce:: with SMTP id a14mr2169895wrq.294.1604662076168;
        Fri, 06 Nov 2020 03:27:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id p13sm1671750wrt.73.2020.11.06.03.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 03:27:55 -0800 (PST)
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <20201001012044.5151-1-peterx@redhat.com>
 <20201001012239.6159-1-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v13 13/14] KVM: selftests: Let dirty_log_test async for
 dirty ring test
Message-ID: <6d5eb99e-e068-e5a6-522f-07ef9c33127f@redhat.com>
Date:   Fri, 6 Nov 2020 12:27:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201001012239.6159-1-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/20 03:22, Peter Xu wrote:
> +
> +static void vcpu_sig_handler(int sig)
> +{
> +	TEST_ASSERT(sig == SIG_IPI, "unknown signal: %d", sig);
> +}
> +

Unless you also use run->immediate_exit in vcpu_kick, this is racy.  The 
alternative is to _not_ set up a signal handler and instead block the 
signal.  KVM_SET_SIGNAL_MASK unblocks the signal inside the VM and on 
-EINTR sigwait accepts the signal (removes it from the set of pending 
signal).

This is a bit more complicated, but I think it's a good idea to do it 
this way for documentation purposes.  Here is the patch:

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c 
b/tools/testing/selftests/kvm/dirty_log_test.c
index 4b404dfdc2f9..9a5b876b74af 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -172,11 +172,6 @@ static pthread_t vcpu_thread;
  /* Only way to pass this to the signal handler */
  static struct kvm_vm *current_vm;

-static void vcpu_sig_handler(int sig)
-{
-	TEST_ASSERT(sig == SIG_IPI, "unknown signal: %d", sig);
-}
-
  static void vcpu_kick(void)
  {
  	pthread_kill(vcpu_thread, SIG_IPI);
@@ -484,13 +479,26 @@ static void *vcpu_worker(void *data)
  	struct kvm_vm *vm = data;
  	uint64_t *guest_array;
  	uint64_t pages_count = 0;
-	struct sigaction sigact;
+	struct kvm_signal_mask *sigmask = alloca(offsetof(struct 
kvm_signal_mask, sigset)
+						 + sizeof(sigset_t));
+	sigset_t *sigset = (sigset_t *) &sigmask->sigset;

  	current_vm = vm;
  	vcpu_fd = vcpu_get_fd(vm, VCPU_ID);
-	memset(&sigact, 0, sizeof(sigact));
-	sigact.sa_handler = vcpu_sig_handler;
-	sigaction(SIG_IPI, &sigact, NULL);
+
+	/*
+	 * SIG_IPI is unblocked atomically while in KVM_RUN.  It causes the
+	 * ioctl to return with -EINTR, but it is still pending and we need
+	 * to accept it with the sigwait.
+	 */
+	sigmask->len = 8;
+	pthread_sigmask(0, NULL, sigset);
+	vcpu_ioctl(vm, VCPU_ID, KVM_SET_SIGNAL_MASK, sigmask);
+	sigaddset(sigset, SIG_IPI);
+	pthread_sigmask(SIG_BLOCK, sigset, NULL);
+
+	sigemptyset(sigset);
+	sigaddset(sigset, SIG_IPI);

  	guest_array = addr_gva2hva(vm, (vm_vaddr_t)random_array);

@@ -500,6 +508,11 @@ static void *vcpu_worker(void *data)
  		pages_count += TEST_PAGES_PER_LOOP;
  		/* Let the guest dirty the random pages */
  		ret = ioctl(vcpu_fd, KVM_RUN, NULL);
+		if (ret == -EINTR) {
+			int sig = -1;
+			sigwait(sigset, &sig);
+			assert(sig == SIG_IPI);
+		}
  		log_mode_after_vcpu_run(vm, ret, errno);
  	}

