Return-Path: <kvm+bounces-55567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C9C3B327F8
	for <lists+kvm@lfdr.de>; Sat, 23 Aug 2025 11:49:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 097991B68542
	for <lists+kvm@lfdr.de>; Sat, 23 Aug 2025 09:49:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27BEE2222C0;
	Sat, 23 Aug 2025 09:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DaUY7S6z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCB11DE89B
	for <kvm@vger.kernel.org>; Sat, 23 Aug 2025 09:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755942561; cv=none; b=mN1JUXJH+tEOt9fFBv8o2OXGG0RaNwMaOyk5nQWirAIfWKoLW0sZyHjDgLkbz6yM8eLB3aJQX3vvw253v/wbXcW5Y1/tCkHc2G+lm5le8FNFakd8Y/9LHJ9eW0Z7zOzPKkY4PQs2FEf/k1yaVIM+iNGKXmeIvSOA8z4Yefour/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755942561; c=relaxed/simple;
	bh=HASuy6wOSb6ZkYHRnHmYDpLtw776pHCOM/ht1RxioX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QgT3+ojLOkSYOnqIl+pN6JwOs4Ksx03mbysg7Qhavja5fSXHoh/cRdXV2zvO5+CZsYsTc6qrwx2tXos2vQCduHczON054VA+WqQ8zt1DGMZgS5Oclb8cZ3oNOELMaoaVlxc0NCq69H80iLTgOrzAgRuA/CVf+W1FuQh40vEXg0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DaUY7S6z; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755942559; x=1787478559;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HASuy6wOSb6ZkYHRnHmYDpLtw776pHCOM/ht1RxioX0=;
  b=DaUY7S6zUxSxJrJlX0QR/s/6bawPIly/d+z9ThPGi/Gg7vSDraQULHS+
   2nB14skbMePvDC0+1+FhBPjoqdTqtm5HQpQotlOZ2imZRpoImFhN6JD/U
   8iR/zAtoAzZRQAyAilUN1i0viwtuQbJkzraXflPLOn5kpS7AKfs4IQR4N
   gtQxmeNw7EVRgyeIBiK510gQSLHxQBKMsQaWG0cVlRG87ytVN53NkjMfc
   1F8s/SX61xF6NIdLiosozfMqd4MBxDHDffm+Sx53Ow/mN/2Yf/aMQBwxw
   YxjwSDIEPxOwY/Q3SzVVte/PiVLu6z5++AQkYQm5Xtjgrc9lFTyZvJul9
   Q==;
X-CSE-ConnectionGUID: aRgvhNi5T2+ZRvh/Nhf9kQ==
X-CSE-MsgGUID: 9xS6s7vUQFCcgS/xIVKlRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="45804846"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="45804846"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2025 02:49:18 -0700
X-CSE-ConnectionGUID: vxNUc4PkSJqDTZYbdpSzTQ==
X-CSE-MsgGUID: 4rQMmBxETKCBUAibYLLZYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="169248388"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa008.fm.intel.com with ESMTP; 23 Aug 2025 02:49:15 -0700
Date: Sat, 23 Aug 2025 18:11:01 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, mst@redhat.com,
	cohuck@redhat.com, pbonzini@redhat.com, mtosatti@redhat.com,
	seanjc@google.com, hpa@zytor.com, andrew.cooper3@citrix.com,
	chao.gao@intel.com
Subject: Re: [PATCH v1 1/1] target/i386: Save/restore the nested flag of an
 exception
Message-ID: <aKmTtaOlPewxllUZ@intel.com>
References: <20250723182211.1299776-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723182211.1299776-1-xin@zytor.com>

On Wed, Jul 23, 2025 at 11:22:11AM -0700, Xin Li (Intel) wrote:
> Date: Wed, 23 Jul 2025 11:22:11 -0700
> From: "Xin Li (Intel)" <xin@zytor.com>
> Subject: [PATCH v1 1/1] target/i386: Save/restore the nested flag of an
>  exception
> X-Mailer: git-send-email 2.50.1
> 
> Save/restore the nested flag of an exception during VM save/restore
> and live migration to ensure a correct event stack level is chosen
> when a nested exception is injected through FRED event delivery.
> 
> The event stack level used by FRED event delivery depends on whether
> the event was a nested exception encountered during delivery of an
> earlier event, because a nested exception is "regarded" as happening
> on ring 0.  E.g., when #PF is configured to use stack level 1 in
> IA32_FRED_STKLVLS MSR:
>   - nested #PF will be delivered on the stack pointed by IA32_FRED_RSP1
>     MSR when encountered in ring 3 and ring 0.
>   - normal #PF will be delivered on the stack pointed by IA32_FRED_RSP0
>     MSR when encountered in ring 3.
>   - normal #PF will be delivered on the stack pointed by IA32_FRED_RSP1
>     MSR when encountered in ring 0.
> 
> As such Qemu needs to track if an event is a nested event during VM
> context save/restore and live migration.
> 
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> ---
>  linux-headers/asm-x86/kvm.h |  4 +++-
>  linux-headers/linux/kvm.h   |  1 +
>  target/i386/cpu.c           |  1 +
>  target/i386/cpu.h           |  1 +
>  target/i386/kvm/kvm.c       | 35 +++++++++++++++++++++++++++++++++++
>  target/i386/kvm/kvm_i386.h  |  1 +
>  target/i386/machine.c       |  1 +
>  7 files changed, 43 insertions(+), 1 deletion(-)

> diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
> index 5f83e8850a..7e765b6833 100644
> --- a/target/i386/kvm/kvm_i386.h
> +++ b/target/i386/kvm/kvm_i386.h
> @@ -54,6 +54,7 @@ typedef struct KvmCpuidInfo {
>  bool kvm_is_vm_type_supported(int type);
>  bool kvm_has_adjust_clock_stable(void);
>  bool kvm_has_exception_payload(void);
> +bool kvm_has_exception_nested_flag(void);
>  void kvm_synchronize_all_tsc(void);
>  
>  void kvm_get_apic_state(DeviceState *d, struct kvm_lapic_state *kapic);
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index dd2dac1d44..a452d2c97e 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -458,6 +458,7 @@ static const VMStateDescription vmstate_exception_info = {
>          VMSTATE_UINT8(env.exception_injected, X86CPU),
>          VMSTATE_UINT8(env.exception_has_payload, X86CPU),
>          VMSTATE_UINT64(env.exception_payload, X86CPU),
> +        VMSTATE_UINT8(env.exception_is_nested, X86CPU),

A new field needs to bump up the version of vmstate_exception_info, but
I'm afraid this will break backward-migration compatibility. So what
about adding a subsction? For example,

diff --git a/target/i386/machine.c b/target/i386/machine.c
index a452d2c97e4c..6ce3cb8af6a6 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -433,6 +433,24 @@ static bool steal_time_msr_needed(void *opaque)
     return cpu->env.steal_time_msr != 0;
 }

+static bool exception_nested_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+
+    return cpu->env.exception_is_nested;
+}
+
+static const VMStateDescription vmstate_exceprtion_nested = {
+    .name = "cpu/exception_nested",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = exception_nested_needed,
+    .fields = (const VMStateField[]) {
+        VMSTATE_UINT8(env.exception_is_nested, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 static bool exception_info_needed(void *opaque)
 {
     X86CPU *cpu = opaque;
@@ -458,8 +476,11 @@ static const VMStateDescription vmstate_exception_info = {
         VMSTATE_UINT8(env.exception_injected, X86CPU),
         VMSTATE_UINT8(env.exception_has_payload, X86CPU),
         VMSTATE_UINT64(env.exception_payload, X86CPU),
-        VMSTATE_UINT8(env.exception_is_nested, X86CPU),
         VMSTATE_END_OF_LIST()
+    },
+    .subsections = (const VMStateDescription * const []) {
+        &vmstate_exceprtion_nested,
+        NULL,
     }
 };

---
In addition, I think it's better to update header files in a seperate
patch.

Thanks,
Zhao



