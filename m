Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E6779F906
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbjINDuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjINDuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:50:14 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5BD193;
        Wed, 13 Sep 2023 20:50:10 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1bf11b1c7d0so12391575ad.0;
        Wed, 13 Sep 2023 20:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694663410; x=1695268210; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kWLjIiBFHAPD99USdA8G+SnnWHVFRCtu/yWG2bUDOR0=;
        b=ccsDqUYVBNAUL01Zhv38ITjMVzZ9kurc96qT6+LYPfdYJfE5WB9ZcPkayE3rrCPZiy
         jL7Jx91244nF81FFUupruOks68grTf6M0vfE9a/mmkEmLV6d8FbiGo6q4JNWP3ZrQnwE
         U8b8A95Ry3QHiQe30VjLONMWwewuIfxtEuz36n0WNyJw5S45GdEq16+7KCWZ3D812c5G
         EYZhcMa5E0ovc+GmysZUudFGan3VLdulMmfEHfxIJ2bDQs9LAi9umEXLBZdUX9K3Vugu
         JawnDXVCZ1DJPR9sgbySy6x9SmYGbvGhQl75iWXTuroDaz7sBV6d1qxY6r7Ues/5BdSc
         WoVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694663410; x=1695268210;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kWLjIiBFHAPD99USdA8G+SnnWHVFRCtu/yWG2bUDOR0=;
        b=lnEYVkM7/WUZCpjjLdDIX0/augziUh4APKmRolc4FaDInQo5kJi57Nw4K9ycGRh5iI
         DuOtw6E8VEZvEldCsHAiIpXYlZxcQGqcXy/oLCJ7AiXw9aYdhQoT2hpMBXKeEo9Y2E0l
         uGWYe2abCc1JQfGWDqBmTG2/zXjqUmb2FQxKuN7v6GWXrDppgch1wDaP5eq/3bkXSGDj
         0VMIMTq+8aeeDsV3Ol+tgJXgL8WJXmO4b+Fe8QlQooYalIppukWqwfo8YLEGU9FOVBOk
         eiNF7Q32GNGm4chRIp5HhiObjeO5lOkKelT9fbtzNXamYIiWKMLszPek2VhGpSZne6um
         +Esw==
X-Gm-Message-State: AOJu0YxDbGKGlKAN1sGYAqCK2wkM+W7tGXSPhHTO4hHsnQ+9tANSvSDw
        XIM45CT1xBzTlWqS7EUVou4=
X-Google-Smtp-Source: AGHT+IFuz8hrGM3jP7zUM9akV5F9cp0bnNxU8tq8pyBDoSeX21nshNwtq4YDB31y4e5BInEfkwyohQ==
X-Received: by 2002:a17:902:d4c3:b0:1c3:e3b1:98f9 with SMTP id o3-20020a170902d4c300b001c3e3b198f9mr982088plg.24.1694663409827;
        Wed, 13 Sep 2023 20:50:09 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jw1-20020a170903278100b001bc676df6a9sm388238plb.132.2023.09.13.20.50.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Sep 2023 20:50:09 -0700 (PDT)
Message-ID: <3912b026-7cd2-9981-27eb-e8e37be9bbad@gmail.com>
Date:   Thu, 14 Sep 2023 11:50:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v6] KVM: x86/tsc: Don't sync user-written TSC against
 startup values
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20230913103729.51194-1-likexu@tencent.com>
 <5367c45df8e4730564ed7a55ed441a6a2d6ab0f9.camel@infradead.org>
 <2eaf612b-1ce3-0dfe-5d2e-2cf29bba7641@gmail.com>
 <ZQHLcs3VGyLUb6wW@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZQHLcs3VGyLUb6wW@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/9/2023 10:47 pm, Sean Christopherson wrote:
> On Wed, Sep 13, 2023, Like Xu wrote:
>> I'll wait for a cooling off period to see if the maintainers need me to post v7.
> 
> You should have waiting to post v5, let alone v6.  Resurrecting a thread after a
> month and not waiting even 7 hours for others to respond is extremely frustrating.

You are right. I don't seem to be keeping up with many of other issues. Sorry 
for that.
Wish there were 48 hours in a day.

Back to this issue: for commit message, I'd be more inclined to David's 
understanding,
but you have the gavel; and for proposed code diff, how about the following changes:

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1a4def36d5bb..9a7dfef9d32d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1324,6 +1324,7 @@ struct kvm_arch {
  	int nr_vcpus_matched_tsc;

  	u32 default_tsc_khz;
+	bool user_set_tsc;

  	seqcount_raw_spinlock_t pvclock_sc;
  	bool use_master_clock;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6c9c81e82e65..faaae8b3fec4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2714,8 +2714,9 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, 
u64 offset, u64 tsc,
  	kvm_track_tsc_matching(vcpu);
  }

-static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
+static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
  {
+	u64 data = user_value ? *user_value : 0;
  	struct kvm *kvm = vcpu->kvm;
  	u64 offset, ns, elapsed;
  	unsigned long flags;
@@ -2728,27 +2729,45 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, 
u64 data)
  	elapsed = ns - kvm->arch.last_tsc_nsec;

  	if (vcpu->arch.virtual_tsc_khz) {
+		/*
+		 * Force synchronization when creating or hotplugging a vCPU,
+		 * i.e. when the TSC value is '0', to help keep clocks stable.
+		 * If this is NOT a hotplug/creation case, skip synchronization
+		 * on the first write from userspace so as not to misconstrue
+		 * state restoration after live migration as an attempt from
+		 * userspace to synchronize.
+		 */
  		if (data == 0) {
-			/*
-			 * detection of vcpu initialization -- need to sync
-			 * with other vCPUs. This particularly helps to keep
-			 * kvm_clock stable after CPU hotplug
-			 */
  			synchronizing = true;
-		} else {
+		} else if (kvm->arch.user_set_tsc) {
  			u64 tsc_exp = kvm->arch.last_tsc_write +
  						nsec_to_cycles(vcpu, elapsed);
  			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
  			/*
-			 * Special case: TSC write with a small delta (1 second)
-			 * of virtual cycle time against real time is
-			 * interpreted as an attempt to synchronize the CPU.
+			 * Here lies UAPI baggage: when a user-initiated TSC write has
+			 * a small delta (1 second) of virtual cycle time against the
+			 * previously set vCPU, we assume that they were intended to be
+			 * in sync and the delta was only due to the racy nature of the
+			 * legacy API.
+			 *
+			 * This trick falls down when restoring a guest which genuinely
+			 * has been running for less time than the 1 second of imprecision
+			 * which we allow for in the legacy API. In this case, the first
+			 * value written by userspace (on any vCPU) should not be subject
+			 * to this 'correction' to make it sync up with values that only
+			 * from the kernel's default vCPU creation. Make the 1-second slop
+			 * hack only trigger if the user_set_tsc flag is already set.
+			 *
+			 * The correct answer is for the VMM not to use the legacy API.
  			 */
  			synchronizing = data < tsc_exp + tsc_hz &&
  					data + tsc_hz > tsc_exp;
  		}
  	}

+	if (user_value)
+		kvm->arch.user_set_tsc = true;
+
  	/*
  	 * For a reliable TSC, we can match TSC offsets, and for an unstable
  	 * TSC, we add elapsed time in this computation.  We could let the
@@ -3777,7 +3796,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct 
msr_data *msr_info)
  		break;
  	case MSR_IA32_TSC:
  		if (msr_info->host_initiated) {
-			kvm_synchronize_tsc(vcpu, data);
+			kvm_synchronize_tsc(vcpu, &data);
  		} else {
  			u64 adj = kvm_compute_l1_tsc_offset(vcpu, data) - vcpu->arch.l1_tsc_offset;
  			adjust_tsc_offset_guest(vcpu, adj);
@@ -5536,6 +5555,7 @@ static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
  		tsc = kvm_scale_tsc(rdtsc(), vcpu->arch.l1_tsc_scaling_ratio) + offset;
  		ns = get_kvmclock_base_ns();

+		kvm->arch.user_set_tsc = true;
  		__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched);
  		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);

@@ -11959,7 +11979,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
  	if (mutex_lock_killable(&vcpu->mutex))
  		return;
  	vcpu_load(vcpu);
-	kvm_synchronize_tsc(vcpu, 0);
+	kvm_synchronize_tsc(vcpu, NULL);
  	vcpu_put(vcpu);

  	/* poll control enabled by default */
-- 
2.42.0
