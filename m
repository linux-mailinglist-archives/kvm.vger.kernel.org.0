Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06AD2B2094
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 17:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgKMQgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 11:36:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53972 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726156AbgKMQgp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 11:36:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605285402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DXM+YNcOD8if4Hqk/gCshYNZ43vDbXR5Ny0EBkdoibE=;
        b=i5qTPbhPIoQmc01jsxmsji/UDtlaZuh7ZRW7VzB9UT3tjttcupIUBRX2aASlyIVueJ2WRt
        40ljsZG7cURJpyudAxF0bxnL4ifckUYCxa8LW/MMf6JgHK19Z7vt9dXCMCUN+OvbVUjZKi
        xTalVRCMzgsDFSctGZiv+bCGvilE5Ds=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-sFKjeBWxPfm57u8B69JoFg-1; Fri, 13 Nov 2020 11:36:41 -0500
X-MC-Unique: sFKjeBWxPfm57u8B69JoFg-1
Received: by mail-wr1-f71.google.com with SMTP id y2so4138496wrl.3
        for <kvm@vger.kernel.org>; Fri, 13 Nov 2020 08:36:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DXM+YNcOD8if4Hqk/gCshYNZ43vDbXR5Ny0EBkdoibE=;
        b=QssDv1YFnVkIsHfTT9qppdjz0NrD9oggfDbfvxUFquhRYY5NQuumpFG2IPaQXDZuws
         +e0XhXppSgCNmjbLf9xkD95u5hJdYzqMLiZnTShnaC6DRJHfukOPMpeLK3fhgZ4ne6IU
         o/zds+R1fOyhj7jLyoQAvN6gxO3C4uGqNdUSU+rJa40gaG2R2IXRmpw8/2u4Nvjbohj0
         nvsNebQ32jKbytg54+Id7ortoXPCMWVg6N8ibmGzzTgMN6DnGrNzRjTcAQ7YE1IcPpVC
         XtV4lMEW86pp4y/IqbWyCgPaaTOhZTZ1+pUvUD6qNb0+B63cSGyyqBShzfCZoGEwaBZB
         9yJg==
X-Gm-Message-State: AOAM531hmwpc6sJHTA+GJOLO4JmF2zTmSqO9EDCl3NJH4chgHGZ/DT4z
        EETysXZJKpFihqKE1Z7rnIJTaoS6RWbSgjbW/O3r9a9KOQ/MIhvxQxCxMiKJef1dXjmMEmFB2dS
        sYRM9xvbcx6L7
X-Received: by 2002:a7b:c24b:: with SMTP id b11mr3220837wmj.109.1605285394864;
        Fri, 13 Nov 2020 08:36:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwLKBSCtz7wrKpxOjeU5076QwW05LR6c0u8x1KksyZXDYHDbaDtBz98RhVXL34slseJXL6kbQ==
X-Received: by 2002:a7b:c24b:: with SMTP id b11mr3220520wmj.109.1605285389698;
        Fri, 13 Nov 2020 08:36:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b14sm11369728wrs.46.2020.11.13.08.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 08:36:28 -0800 (PST)
Subject: Re: [PATCH v2 02/11] KVM: selftests: Remove deadcode
To:     Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20201111122636.73346-1-drjones@redhat.com>
 <20201111122636.73346-3-drjones@redhat.com> <20201112181921.GS26342@xz-x1>
 <CANgfPd_R_Rjn+QT_yiUwpCUK3TUfmhSN6XpZ5=L17mhrtMi7Zw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7dc78143-2a99-d268-09ba-9db7b2fb1104@redhat.com>
Date:   Fri, 13 Nov 2020 17:36:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd_R_Rjn+QT_yiUwpCUK3TUfmhSN6XpZ5=L17mhrtMi7Zw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/11/20 19:34, Ben Gardon wrote:
> I didn't review this patch closely enough, and assumed the clear dirty
> log was still being done because of
> afdb19600719 KVM: selftests: Use a single binary for dirty/clear log test
> 
> Looking back now, I see that that is not the case.
> 
> I'd like to retract my endorsement in that case. I'd prefer to leave
> the dead code in and I'll send another series to actually use it once
> this series is merged. I've already written the code to use it and
> time the clearing, so it seems a pity to remove it now.
> 
> Alternatively I could just revert this commit in that future series,
> though I suspect not removing the dead code would reduce the chances
> of merge conflicts. Either way works.
> 
> I can extend the dirty log mode functions from dirty_log_test for
> dirty_log_perf_test in that series too.

For now I'll follow Peter's suggestion to always test manual clear:

-------------- 8< ------------
Subject: [PATCH] KVM: selftests: always use manual clear in 
dirty_log_perf_test

Nothing sets USE_CLEAR_DIRTY_LOG anymore, so anything it surrounds
is dead code.

However, it is the recommended way to use the dirty page bitmap
for new enough kernel, so use it whenever KVM has the
KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 capability.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c 
b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 85c9b8f73142..9c6a7be31e03 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -27,6 +27,7 @@
  #define TEST_HOST_LOOP_N		2UL

  /* Host variables */
+static u64 dirty_log_manual_caps;
  static bool host_quit;
  static uint64_t iteration;
  static uint64_t vcpu_last_completed_iteration[MAX_VCPUS];
@@ -88,10 +89,6 @@ static void *vcpu_worker(void *data)
  	return NULL;
  }

-#ifdef USE_CLEAR_DIRTY_LOG
-static u64 dirty_log_manual_caps;
-#endif
-
  static void run_test(enum vm_guest_mode mode, unsigned long iterations,
  		     uint64_t phys_offset, int wr_fract)
  {
@@ -106,10 +103,8 @@ static void run_test(enum vm_guest_mode mode, 
unsigned long iterations,
  	struct timespec get_dirty_log_total = (struct timespec){0};
  	struct timespec vcpu_dirty_total = (struct timespec){0};
  	struct timespec avg;
-#ifdef USE_CLEAR_DIRTY_LOG
  	struct kvm_enable_cap cap = {};
  	struct timespec clear_dirty_log_total = (struct timespec){0};
-#endif

  	vm = create_vm(mode, nr_vcpus, guest_percpu_mem_size);

@@ -120,11 +115,11 @@ static void run_test(enum vm_guest_mode mode, 
unsigned long iterations,
  	host_num_pages = vm_num_host_pages(mode, guest_num_pages);
  	bmap = bitmap_alloc(host_num_pages);

-#ifdef USE_CLEAR_DIRTY_LOG
-	cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
-	cap.args[0] = dirty_log_manual_caps;
-	vm_enable_cap(vm, &cap);
-#endif
+	if (dirty_log_manual_caps) {
+		cap.cap = KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
+		cap.args[0] = dirty_log_manual_caps;
+		vm_enable_cap(vm, &cap);
+	}

  	vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
  	TEST_ASSERT(vcpu_threads, "Memory allocation failed");
@@ -190,17 +185,17 @@ static void run_test(enum vm_guest_mode mode, 
unsigned long iterations,
  		pr_info("Iteration %lu get dirty log time: %ld.%.9lds\n",
  			iteration, ts_diff.tv_sec, ts_diff.tv_nsec);

-#ifdef USE_CLEAR_DIRTY_LOG
-		clock_gettime(CLOCK_MONOTONIC, &start);
-		kvm_vm_clear_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap, 0,
-				       host_num_pages);
+		if (dirty_log_manual_caps) {
+			clock_gettime(CLOCK_MONOTONIC, &start);
+			kvm_vm_clear_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap, 0,
+					       host_num_pages);

-		ts_diff = timespec_diff_now(start);
-		clear_dirty_log_total = timespec_add(clear_dirty_log_total,
-						     ts_diff);
-		pr_info("Iteration %lu clear dirty log time: %ld.%.9lds\n",
-			iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
-#endif
+			ts_diff = timespec_diff_now(start);
+			clear_dirty_log_total = timespec_add(clear_dirty_log_total,
+							     ts_diff);
+			pr_info("Iteration %lu clear dirty log time: %ld.%.9lds\n",
+				iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
+		}
  	}

  	/* Tell the vcpu thread to quit */
@@ -220,12 +215,12 @@ static void run_test(enum vm_guest_mode mode, 
unsigned long iterations,
  		iterations, get_dirty_log_total.tv_sec,
  		get_dirty_log_total.tv_nsec, avg.tv_sec, avg.tv_nsec);

-#ifdef USE_CLEAR_DIRTY_LOG
-	avg = timespec_div(clear_dirty_log_total, iterations);
-	pr_info("Clear dirty log over %lu iterations took %ld.%.9lds. (Avg 
%ld.%.9lds/iteration)\n",
-		iterations, clear_dirty_log_total.tv_sec,
-		clear_dirty_log_total.tv_nsec, avg.tv_sec, avg.tv_nsec);
-#endif
+	if (dirty_log_manual_caps) {
+		avg = timespec_div(clear_dirty_log_total, iterations);
+		pr_info("Clear dirty log over %lu iterations took %ld.%.9lds. (Avg 
%ld.%.9lds/iteration)\n",
+			iterations, clear_dirty_log_total.tv_sec,
+			clear_dirty_log_total.tv_nsec, avg.tv_sec, avg.tv_nsec);
+	}

  	free(bmap);
  	free(vcpu_threads);
@@ -284,16 +279,10 @@ int main(int argc, char *argv[])
  	int opt, i;
  	int wr_fract = 1;

-#ifdef USE_CLEAR_DIRTY_LOG
  	dirty_log_manual_caps =
  		kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
-	if (!dirty_log_manual_caps) {
-		print_skip("KVM_CLEAR_DIRTY_LOG not available");
-		exit(KSFT_SKIP);
-	}
  	dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
  				  KVM_DIRTY_LOG_INITIALLY_SET);
-#endif

  #ifdef __x86_64__
  	guest_mode_init(VM_MODE_PXXV48_4K, true, true);

