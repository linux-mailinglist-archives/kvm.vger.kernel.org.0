Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC8D3653B8
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 10:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhDTIH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 04:07:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34158 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229551AbhDTIHy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 04:07:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618906043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EbjQNPsOmd61SNUpmUILydUwe8xQv3dWwe1PfTSygNQ=;
        b=IDDuuQzbAtgygr5j6HoXkqBXAjkh8bnw9d07DUgCPS49KNHhzZo6zifGQ3frmYbhJMkq12
        xV5pnRYRZv5hlR3FuGODGUA/OO3IyZj8UCl0fF3yDszCznbrLru3f9Gd6IsEoowLa7Mo85
        BaRKJydYN/pViC76rBbnO0vKPWdvTrc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-Ii6RUDfZM1qzpGCFSI0oEQ-1; Tue, 20 Apr 2021 04:07:21 -0400
X-MC-Unique: Ii6RUDfZM1qzpGCFSI0oEQ-1
Received: by mail-ed1-f69.google.com with SMTP id n18-20020a0564020612b02903853320059eso3648670edv.0
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 01:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EbjQNPsOmd61SNUpmUILydUwe8xQv3dWwe1PfTSygNQ=;
        b=c5i5tFDyY6/U1gmZ35zqBbWZbcq1/y6Prln4TOPn7Pzygc5MrEVHQ5JHskMRwlOFZv
         0/8/0LtcwVL3FHA24T3ggTrB2gemB7PR35XxxFcOLWmHpMvoIih2E488NByDlWe15vlw
         ddpEh4foYfPAxQK7hAAVNZZ8vYNM/t/ddKE91mZsmvDaOTXbkSDycSucqFND9xcP03pV
         EcqlsufMfOuZHY5ZgFoEeFxQvEesNydqGfhQvPpK+zNPYfih/krdncAjmj5bci2EiS0M
         IrmUhYg/9DV+TG2YFu7w5wJobG6lbKW+yKYVtNO4HRTeU1Tm9RtTVp+bb72iCmu99dkI
         n66Q==
X-Gm-Message-State: AOAM53317rXkTvewF0kBfjfzTYDqt8cjTsabM44ElpbHuV3ArQk4cdNB
        du/iZ6CQMJmFWTbll5DCpB6pO+EyZ9EbX5Upjk3tHPw0QgLVJkDxscchCd3nRJG4cR4/o0bvP/X
        cl2O6YrHrKC5P
X-Received: by 2002:a17:906:1749:: with SMTP id d9mr25347657eje.12.1618906040320;
        Tue, 20 Apr 2021 01:07:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzestOU1Hx/42FM/Q3tA4Y7DK3c7QFqfr3eVFbwu9JBEgEh6CabEu6bBrY3mmy/2UZJSk8H2Q==
X-Received: by 2002:a17:906:1749:: with SMTP id d9mr25347637eje.12.1618906040103;
        Tue, 20 Apr 2021 01:07:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g26sm11921805ejz.70.2021.04.20.01.07.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 01:07:17 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] KVM: selftests: Sync data verify of dirty logging
 with guest sync
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210417143602.215059-1-peterx@redhat.com>
 <20210417143602.215059-2-peterx@redhat.com> <20210418124351.GW4440@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <60b0c96c-161d-676d-c30a-a7ffeccab417@redhat.com>
Date:   Tue, 20 Apr 2021 10:07:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210418124351.GW4440@xz-x1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/04/21 14:43, Peter Xu wrote:
> ----8<-----
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 25230e799bc4..d3050d1c2cd0 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -377,7 +377,7 @@ static void dirty_ring_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
>          /* A ucall-sync or ring-full event is allowed */
>          if (get_ucall(vm, VCPU_ID, NULL) == UCALL_SYNC) {
>                  /* We should allow this to continue */
> -               ;
> +               vcpu_handle_sync_stop();
>          } else if (run->exit_reason == KVM_EXIT_DIRTY_RING_FULL ||
>                     (ret == -1 && err == EINTR)) {
>                  /* Update the flag first before pause */
> ----8<-----
> 
> That's my intention when I introduce vcpu_handle_sync_stop(), but forgot to
> add...

And possibly even this (untested though):

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index ffa4e2791926..918954f01cef 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -383,6 +383,7 @@ static void dirty_ring_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
  		/* Update the flag first before pause */
  		WRITE_ONCE(dirty_ring_vcpu_ring_full,
  			   run->exit_reason == KVM_EXIT_DIRTY_RING_FULL);
+		atomic_set(&vcpu_sync_stop_requested, false);
  		sem_post(&sem_vcpu_stop);
  		pr_info("vcpu stops because %s...\n",
  			dirty_ring_vcpu_ring_full ?
@@ -804,8 +805,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
  		 * the flush of the last page, and since we handle the last
  		 * page specially verification will succeed anyway.
  		 */
-		assert(host_log_mode == LOG_MODE_DIRTY_RING ||
-		       atomic_read(&vcpu_sync_stop_requested) == false);
+		assert(atomic_read(&vcpu_sync_stop_requested) == false);
  		vm_dirty_log_verify(mode, bmap);
  		sem_post(&sem_vcpu_cont);
  

You can submit all these as a separate patch.

Paolo

