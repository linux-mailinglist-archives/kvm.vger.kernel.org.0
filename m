Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF593653D1
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 10:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhDTIPJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 04:15:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21555 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229543AbhDTIPJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 04:15:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618906478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KV7dmFGzJ9Zbd3oVTLLc6xUZJD2xaL8s1NYktGrSB24=;
        b=TTciNWvdPwXlb87fnn4MHth758GHEm8QCmPS08uaHt/NQicNOPkbO3FYh09/gWJ46vUk3i
        /M5keVax4z+eTtWDCgi4Rg2Ed45Xjie3wJPPb1467K9f02orcRC46WMkPtmM67fvolbKyR
        UmDCLv4mRNMWYHYcvrFT3GaBV1gEY10=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-p_UVqVYGPsuMuMBpMtH-YQ-1; Tue, 20 Apr 2021 04:14:35 -0400
X-MC-Unique: p_UVqVYGPsuMuMBpMtH-YQ-1
Received: by mail-ed1-f70.google.com with SMTP id r4-20020a0564022344b0290382ce72b7f9so12689836eda.19
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 01:14:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KV7dmFGzJ9Zbd3oVTLLc6xUZJD2xaL8s1NYktGrSB24=;
        b=im3C07vos0QHRK5V0q3nM1+JuGW7qR7SeQaTZmZemSDazbDUCDnxyKlRRU47mNNd8I
         6K+/LO9c9YMxdeBP2QeTKhshJcK9X1yXfOsUwt06FVysrUSIOPmiCVD/UY+WkWG9iJHt
         V34NyejcQkpNAOccy5x3HjRAhpATebY520r9T6EBkm1PYPUo0v+PkT8ui1xHN/GMT3L1
         WLpofp2+TL4zRidqpzSYXsAh4uz1pe0eKRMjLbxXRWQG+hko54LIINoz87Op1mA8kJvb
         dlQ/2wPtSFY4GsQwfSNukksWtsK0hBIXYqWkleLQns8E6laBY0p6ZBXJv32hDpYER8Yp
         tQbQ==
X-Gm-Message-State: AOAM533HLGEF4eUKJWNr2w31mGS6utoZXBduu97aIhczO5Zg3UuH8H76
        9L10LvVItlpNsG2QSNo0uErxLpAO8B0Pb2zg9ZDDSsqvNB5OZo3jrH5siqAz1IuNYw8Vuck/Pi7
        OBKLPueJYOcuV
X-Received: by 2002:a17:906:cc46:: with SMTP id mm6mr26886835ejb.138.1618906474616;
        Tue, 20 Apr 2021 01:14:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpPEvnbrPRPj33zVTbsposR+idCfDNOhL0ex/+4AT2yKt35m84lN5qHgNaytwrjmAsayKPCQ==
X-Received: by 2002:a17:906:cc46:: with SMTP id mm6mr26886811ejb.138.1618906474397;
        Tue, 20 Apr 2021 01:14:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k19sm11468335ejk.117.2021.04.20.01.14.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 01:14:33 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] KVM: selftests: Wait for vcpu thread before signal
 setup
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210417143602.215059-1-peterx@redhat.com>
 <20210417143602.215059-3-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <372e505d-7d1d-2614-fe30-55be9ac2bf49@redhat.com>
Date:   Tue, 20 Apr 2021 10:14:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210417143602.215059-3-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/04/21 16:36, Peter Xu wrote:
> The main thread could start to send SIG_IPI at any time, even before signal
> blocked on vcpu thread.  Reuse the sem_vcpu_stop to sync on that, so when
> SIG_IPI is sent the signal will always land correctly as an -EINTR.
> 
> Without this patch, on very busy cores the dirty_log_test could fail directly
> on receiving a SIG_USR1 without a handler (when vcpu runs far slower than main).
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>

This should be a better way to do the same:

----------- 8< ------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: selftests: Wait for vcpu thread before signal setup

The main thread could start to send SIG_IPI at any time, even before signal
blocked on vcpu thread.  Therefore, start the vcpu thread with the signal
blocked.

Without this patch, on very busy cores the dirty_log_test could fail directly
on receiving a SIGUSR1 without a handler (when vcpu runs far slower than main).

Reported-by: Peter Xu <peterx@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index ffa4e2791926..048973d50a45 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -527,9 +527,8 @@ static void *vcpu_worker(void *data)
  	 */
  	sigmask->len = 8;
  	pthread_sigmask(0, NULL, sigset);
+	sigdelset(sigset, SIG_IPI);
  	vcpu_ioctl(vm, VCPU_ID, KVM_SET_SIGNAL_MASK, sigmask);
-	sigaddset(sigset, SIG_IPI);
-	pthread_sigmask(SIG_BLOCK, sigset, NULL);
  
  	sigemptyset(sigset);
  	sigaddset(sigset, SIG_IPI);
@@ -858,6 +857,7 @@ int main(int argc, char *argv[])
  		.interval = TEST_HOST_LOOP_INTERVAL,
  	};
  	int opt, i;
+	sigset_t sigset;
  
  	sem_init(&sem_vcpu_stop, 0, 0);
  	sem_init(&sem_vcpu_cont, 0, 0);
@@ -916,6 +916,11 @@ int main(int argc, char *argv[])
  
  	srandom(time(0));
  
+	/* Ensure that vCPU threads start with SIG_IPI blocked.  */
+	sigemptyset(&sigset);
+	sigaddset(&sigset, SIG_IPI);
+	pthread_sigmask(SIG_BLOCK, sigset, NULL);
+
  	if (host_log_mode_option == LOG_MODE_ALL) {
  		/* Run each log mode */
  		for (i = 0; i < LOG_MODE_NUM; i++) {


> ---
>   tools/testing/selftests/kvm/dirty_log_test.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 510884f0eab8..25230e799bc4 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -534,6 +534,12 @@ static void *vcpu_worker(void *data)
>   	sigemptyset(sigset);
>   	sigaddset(sigset, SIG_IPI);
>   
> +	/*
> +	 * Tell the main thread that signals are setup already; let's borrow
> +	 * sem_vcpu_stop even if it's not for it.
> +	 */
> +	sem_post(&sem_vcpu_stop);
> +
>   	guest_array = addr_gva2hva(vm, (vm_vaddr_t)random_array);
>   
>   	while (!READ_ONCE(host_quit)) {
> @@ -785,6 +791,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>   
>   	pthread_create(&vcpu_thread, NULL, vcpu_worker, vm);
>   
> +	sem_wait_until(&sem_vcpu_stop);
> +
>   	while (iteration < p->iterations) {
>   		/* Give the vcpu thread some time to dirty some pages */
>   		usleep(p->interval * 1000);
> 

