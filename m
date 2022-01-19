Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E69493F88
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 19:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356607AbiASSDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 13:03:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345674AbiASSDA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 13:03:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642615380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=czyQcT5AvdpFdccMDnqOJP5PsUxctttwWttnV2WSAI4=;
        b=T8gJ1i0aTtAdERDiXt4BeCytBiK3KhfgQQy9Gq7Wy33WoF52ZUe1UW1dpuvLrqAZdZVAQB
        mbM9i88E0JobMJbh78/r6smiQDdfg3k/CFFEMRiopgN6fK8/XeV8daj3NXQucuCFGqgUIe
        b/Dq+MExsOJjzxQeUHntfBfnK5am6XA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-c18338kFMECs_G-HKN1-Ag-1; Wed, 19 Jan 2022 13:02:58 -0500
X-MC-Unique: c18338kFMECs_G-HKN1-Ag-1
Received: by mail-wm1-f71.google.com with SMTP id v190-20020a1cacc7000000b0034657bb6a66so1559041wme.6
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 10:02:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=czyQcT5AvdpFdccMDnqOJP5PsUxctttwWttnV2WSAI4=;
        b=qnrGMs92NxLNY7uGtzBcKvUUSrBeOSYUUdGVkjkQ+lej8jzWP2n68o3ck0gvyXYLwB
         CdArKmz/01ryxBUDs2hJqrpBknC4kBBet8GHRqPmvK5tUNWJJgUhL0tcnaq/NCQKT1/1
         2aH3yyE3ddGd1ruCQ+zftx4UV0v0SArXKH36O27vTRJqZQTbd4ZaHSETZvzyxIBNbWgA
         SnZgGKadn88vT591PYj21Ebi8LWwqW51P4NtT1r+G+QIgJksRMMWe/shfCoIOBPUi2EL
         OvHuXlFaIRhEmhI8tLGQfcNYM/2fKmNcaxfYNmsmqsGMmjne6+CYRcDHHGgIm6HRHF8D
         6LpA==
X-Gm-Message-State: AOAM532rHlbR8bIBMBIFT1xRur9XtARBXeGJH2hKijLiiuWlxT+SkojI
        EDrZbwRrcfMlkFFzaIeF33aEHj92mOcnWkRvq8CB/32G7GZNjCDZADPEIuoTrrmIQ2C2+hyMQSC
        xGcsjheSR8BM2
X-Received: by 2002:adf:d1e9:: with SMTP id g9mr16362036wrd.94.1642615377585;
        Wed, 19 Jan 2022 10:02:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzWiK4YX1B5gdEVQZODtrmTI10OiMW4QGl94Z1D+eFnE79lslF625dzQ56217EHdanwhn1q9A==
X-Received: by 2002:adf:d1e9:: with SMTP id g9mr16361991wrd.94.1642615376863;
        Wed, 19 Jan 2022 10:02:56 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id u7sm233710wmc.11.2022.01.19.10.02.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 10:02:56 -0800 (PST)
Message-ID: <7a0bc562-9f25-392d-5c05-9dbcd350d002@redhat.com>
Date:   Wed, 19 Jan 2022 19:02:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
Content-Language: en-US
To:     Tejun Heo <tj@kernel.org>, Vipin Sharma <vipinsh@google.com>
Cc:     =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        seanjc@google.com, lizefan.x@bytedance.com, hannes@cmpxchg.org,
        dmatlack@google.com, jiangshanlai@gmail.com, kvm@vger.kernel.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211222225350.1912249-1-vipinsh@google.com>
 <20220105180420.GC6464@blackbody.suse.cz>
 <CAHVum0e84nUcGtdPYQaJDQszKj-QVP5gM+nteBpSTaQ2sWYpmQ@mail.gmail.com>
 <Yeclbe3GNdCMLlHz@slm.duckdns.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yeclbe3GNdCMLlHz@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/22 21:39, Tejun Heo wrote:
> So, these are normally driven by the !populated events. That's how everyone
> else is doing it. If you want to tie the kvm workers lifetimes to kvm
> process, wouldn't it be cleaner to do so from kvm side? ie. let kvm process
> exit wait for the workers to be cleaned up.

It does.  For example kvm_mmu_post_init_vm's call to
kvm_vm_create_worker_thread is matched with the call to
kthread_stop in kvm_mmu_pre_destroy_vm.
  
According to Vpin, the problem is that there's a small amount of time
between the return from kthread_stop and the point where the cgroup
can be removed.  My understanding of the race is the following:

user process			kthread			management
------------			-------			----------
							wait4()
exit_task_work()
   ____fput()
     kvm_mmu_pre_destroy_vm()
       kthread_stop();
         wait_for_completion();
				exit_signals()
				  /* set PF_EXITING */
				exit_mm()
				  exit_mm_release()
				    complete_vfork_done()
				      complete();
cgroup_exit()
   cgroup_set_move_task()
     css_set_update_populated()
exit_notify()
   do_notify_parent()
							<wakeup>
							rmdir()
							  cgroup_destroy_locked()
							    cgroup_is_populated()
							    return -EBUSY
				cgroup_exit()
				  cgroup_set_move_task()
				    css_set_update_populated()

I cannot find the code that makes it possible to rmdir a cgroup
if PF_EXITING is set.

Paolo

