Return-Path: <kvm+bounces-53108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0F84B0D750
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 12:28:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1164E560F41
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 10:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 564252E041D;
	Tue, 22 Jul 2025 10:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iJgvImDG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E95919DF62
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 10:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753180072; cv=none; b=nUmzKVj5+VAiOitDPfBnunzzTVtXxIPiTEEhaSQaIUam4LpL9L5OqvlcCYbOXhvyNuXthjsWTGsj6NdzJHlBcAlckV91z7nLkPpfznclaGoI894PeDUMGR/8fBXNsoZUSRitbp098G3jLOx9lCZPlGrcppiYwYxVijIEsqZF/Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753180072; c=relaxed/simple;
	bh=0oohQ0hNIsFUCSCqaUvq/anc1Io/07XFkoPOd6qFB3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pRFiXlr++H9BYGAqVU18bwGOGj7JESFkbKVA2I+3UW90xB5p9WUy7Ftu1oUmWvE1ybj4mp9Iohfcb4FTUXwYV6ynG8LC4lj3UpnMaGe+oKRvrfSqSD/db1/tlsvGmjy7eWG1jWTB7Jor/ghGVlCVTjAgG32Uq4M6s3ntjof8Ais=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iJgvImDG; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753180070; x=1784716070;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0oohQ0hNIsFUCSCqaUvq/anc1Io/07XFkoPOd6qFB3I=;
  b=iJgvImDGpxTr1hiYSM7yWlWO0RZZF00GcE9hh8M30QI3aDOU1GmRjZEK
   gFUi9xZEzTltOE14RoGgFYuQqC2Bs93TKgs8H+8YeiyTqyEETcsba6iOP
   GhkV+QFO1ntVN2u610QB38kSa3l6BPD5O6gzIJBWK0q8/Vut2OXLbTHz4
   aaplEyDsPnlc4ogzmIP5pAA7YCxpDagvblbl5ph55YJaY8E7RzTNNMREO
   FKjUl2j02KY7yNMxuax4HuOreZzkXBCjDGXnrOlM4YAmiWtWK1+mbo2an
   B7LTXM8Mbms6tlrCz02/D3WL+LlwMiYMU8Nz4Oac06QnnstA41/t7KTW0
   A==;
X-CSE-ConnectionGUID: 9c2xzGX9R5Wtr6ZJggOZ6A==
X-CSE-MsgGUID: HFSGT8HRTbu7Sbx+eOXJYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="66105870"
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="66105870"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 03:27:49 -0700
X-CSE-ConnectionGUID: eyBcmkkXQBKxkoZAuVP2Cw==
X-CSE-MsgGUID: AIyp5B30Twy7/oJzw363Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="159149139"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 03:27:47 -0700
Message-ID: <3f58125c-183f-49e0-813e-d4cb1be724e8@intel.com>
Date: Tue, 22 Jul 2025 18:27:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Disable hypercall patching quirk by default
To: Mathias Krause <minipli@grsecurity.net>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>
References: <20250619194204.1089048-1-minipli@grsecurity.net>
 <41a5767e-42d7-4877-9bc8-aa8eca6dd3e3@intel.com>
 <b8336828-ce72-4567-82df-b91d3670e26c@grsecurity.net>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <b8336828-ce72-4567-82df-b91d3670e26c@grsecurity.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/22/2025 5:21 PM, Mathias Krause wrote:
> On 22.07.25 05:45, Xiaoyao Li wrote:
>> On 6/20/2025 3:42 AM, Mathias Krause wrote:
>>> KVM has a weird behaviour when a guest executes VMCALL on an AMD system
>>> or VMMCALL on an Intel CPU. Both naturally generate an invalid opcode
>>> exception (#UD) as they are just the wrong instruction for the CPU
>>> given. But instead of forwarding the exception to the guest, KVM tries
>>> to patch the guest instruction to match the host's actual hypercall
>>> instruction. That is doomed to fail as read-only code is rather the
>>> standard these days. But, instead of letting go the patching attempt and
>>> falling back to #UD injection, KVM injects the page fault instead.
>>>
>>> That's wrong on multiple levels. Not only isn't that a valid exception
>>> to be generated by these instructions, confusing attempts to handle
>>> them. It also destroys guest state by doing so, namely the value of CR2.
>>>
>>> Sean attempted to fix that in KVM[1] but the patch was never applied.
>>>
>>> Later, Oliver added a quirk bit in [2] so the behaviour can, at least,
>>> conceptually be disabled. Paolo even called out to add this very
>>> functionality to disable the quirk in QEMU[3]. So lets just do it.
>>>
>>> A new property 'hypercall-patching=on|off' is added, for the very
>>> unlikely case that there are setups that really need the patching.
>>> However, these would be vulnerable to memory corruption attacks freely
>>> overwriting code as they please. So, my guess is, there are exactly 0
>>> systems out there requiring this quirk.
>>
>> The default behavior is patching the hypercall for many years.
>>
>> If you desire to change the default behavior, please at least keep it
>> unchanged for old machine version. i.e., introduce compat_property,
>> which sets KVMState->hypercall_patching_enabled to true.
> 
> Well, the thing is, KVM's patching is done with the effective
> permissions of the guest which means, if the code in question isn't
> writable from the guest's point of view, KVM's attempt to modify it will
> fail. This failure isn't transparent for the guest as it sees a #PF
> instead of a #UD, and that's what I'm trying to fix by disabling the quirk.
> 
> The hypercall patching was introduced in Linux commit 7aa81cc04781
> ("KVM: Refactor hypercall infrastructure (v3)") in v2.6.25. Until then
> it was based on a dedicated hypercall page that was handled by KVM to
> use the proper instruction of the KVM module in use (VMX or SVM).
> 
> Patching code was fine back then, but the introduction of DEBUG_RO_DATA
> made the patching attempts fail and, ultimately, lead to Paolo handle
> this with commit c1118b3602c2 ("x86: kvm: use alternatives for VMCALL
> vs. VMMCALL if kernel text is read-only").
> 
> However, his change still doesn't account for the cross-vendor live
> migration case (Intel<->AMD), which will still be broken, causing the
> before mentioned bogus #PF, which will just lead to misleading Oops
> reports, confusing the poor souls, trying to make sense of it.
> 
> IMHO, there is no valid reason for still having the patching in place as
> the .text of non-ancient kernel's  will be write-protected, making
> patching attempts fail. And, as they fail with a #PF instead of #UD, the
> guest cannot even handle them appropriately, as there was no memory
> write attempt from its point of view. Therefore the default should be to
> disable it, IMO. This won't prevent guests making use of the wrong
> instruction from trapping, but, at least, now they'll get the correct
> exception vector and can handle it appropriately.

But you don't accout for the case that guest kernel is built without 
CONFIG_STRICT_KERNEL_RWX enabled, or without CONFIG_DEBUG_RO_DATA, or 
for whatever reason the guest's text is not readonly, and the VM needs 
to be migrated among different vendors (Intel <-> AMD).

Before this patch, the above usecase works well. But with this patch, 
the guest will gets #UD after migrated to different vendors.

I heard from some small CSPs that they do want to the ability to live 
migrate VMs among Intel and AMD host.

>>
>>> [1] https://lore.kernel.org/kvm/20211210222903.3417968-1-
>>> seanjc@google.com/
>>> [2] https://lore.kernel.org/kvm/20220316005538.2282772-2-
>>> oupton@google.com/
>>> [3] https://lore.kernel.org/kvm/80e1f1d2-2d79-22b7-6665-
>>> c00e4fe9cb9c@redhat.com/
>>>
>>> Cc: Oliver Upton <oliver.upton@linux.dev>
>>> Cc: Sean Christopherson <seanjc@google.com>
>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
>>> ---
>>>    include/system/kvm_int.h |  1 +
>>>    qemu-options.hx          | 10 ++++++++++
>>>    target/i386/kvm/kvm.c    | 38 ++++++++++++++++++++++++++++++++++++++
>>>    3 files changed, 49 insertions(+)
>>>
>>> diff --git a/include/system/kvm_int.h b/include/system/kvm_int.h
>>> index 756a3c0a250e..fd7129824429 100644
>>> --- a/include/system/kvm_int.h
>>> +++ b/include/system/kvm_int.h
>>> @@ -159,6 +159,7 @@ struct KVMState
>>>        uint64_t kvm_eager_split_size;  /* Eager Page Splitting chunk
>>> size */
>>>        struct KVMDirtyRingReaper reaper;
>>>        struct KVMMsrEnergy msr_energy;
>>> +    bool hypercall_patching_enabled;
>>
>> IMHO, we can just name it "hypercall_patching".
>>
>> Since it's a boolean type, true means enabled and false means disabled.
> 
> Ok, makes sense.
> 
>>
>>>        NotifyVmexitOption notify_vmexit;
>>>        uint32_t notify_window;
>>>        uint32_t xen_version;
>>> diff --git a/qemu-options.hx b/qemu-options.hx
>>> index 1f862b19a676..c2e232649c19 100644
>>> --- a/qemu-options.hx
>>> +++ b/qemu-options.hx
>>> @@ -231,6 +231,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
>>>        "                dirty-ring-size=n (KVM dirty ring GFN count,
>>> default 0)\n"
>>>        "                eager-split-size=n (KVM Eager Page Split chunk
>>> size, default 0, disabled. ARM only)\n"
>>>        "                notify-vmexit=run|internal-error|
>>> disable,notify-window=n (enable notify VM exit and set notify window,
>>> x86 only)\n"
>>> +    "                hypercall-patching=on|off (enable KVM's VMCALL/
>>> VMMCALL hypercall patching quirk, x86 only)\n"
>>>        "                thread=single|multi (enable multi-threaded TCG)\n"
>>>        "                device=path (KVM device path, default /dev/
>>> kvm)\n", QEMU_ARCH_ALL)
>>>    SRST
>>> @@ -313,6 +314,15 @@ SRST
>>>            open up for a specified of time (i.e. notify-window).
>>>            Default: notify-vmexit=run,notify-window=0.
>>>    +    ``hypercall-patching=on|off``
>>> +        KVM tries to recover from the wrong hypercall instruction
>>> being used by
>>> +        a guest by attempting to rewrite it to the one supported
>>> natively by
>>> +        the host CPU (VMCALL on Intel, VMMCALL for AMD systems).
>>> However, this
>>> +        patching may fail if the guest memory is write protected,
>>> leading to a
>>> +        page fault getting propagated to the guest instead of an illegal
>>> +        instruction exception. As this may confuse guests, it gets
>>> disabled by
>>> +        default (x86 only).
>>> +
>>>        ``device=path``
>>>            Sets the path to the KVM device node. Defaults to ``/dev/
>>> kvm``. This
>>>            option can be used to pass the KVM device to use via a file
>>> descriptor
>>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>>> index 56a6b9b6381a..6f5f3b95e553 100644
>>> --- a/target/i386/kvm/kvm.c
>>> +++ b/target/i386/kvm/kvm.c
>>> @@ -3224,6 +3224,19 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
>>>        return 0;
>>>    }
>>>    +static int kvm_vm_disable_hypercall_patching(KVMState *s)
>>> +{
>>> +    int valid_quirks = kvm_vm_check_extension(s,
>>> KVM_CAP_DISABLE_QUIRKS2);
>>> +
>>> +    if (valid_quirks & KVM_X86_QUIRK_FIX_HYPERCALL_INSN) {
>>> +        return kvm_vm_enable_cap(s, KVM_CAP_DISABLE_QUIRKS2, 0,
>>> +                                 KVM_X86_QUIRK_FIX_HYPERCALL_INSN);
>>> +    }
>>> +
>>> +    warn_report("kvm: disabling hypercall patching not supported");
>>
>> It's not clear it's 1) KVM doesn't support/has FIX_HYPERCALL_INSN quirk
>> or 2) KVM has FIX_HYPERCALL_INSN quirk but doesn't allow it to be
>> disabled, when KVM_X86_QUIRK_FIX_HYPERCALL_INSN is not returned in
>> KVM_CAP_DISABLE_QUIRKS2.
>>
>> If it's case 1), it can be treated as hypercall patching is disabled
>> thus no warning is expected.
>>
>> So, I think it requires a new cap in KVM to return the enabled quirks.
> 
> KVM_CAP_DISABLE_QUIRKS2 fixes that bug of KVM_CAP_DISABLE_QUIRKS by
> doing just that: returning the mask of supported quirks when queried via
> KVM_CHECK_EXTENSION. So if KVM_X86_QUIRK_FIX_HYPERCALL_INSN is in that
> mask, it can also be disabled. If that attempt fails (for whatever
> reason), it's an error, which makes kvm_vm_enable_cap() return a
> non-zero value, triggering the warn_report("kvm: failed to disable
> hypercall patching quirk") in the caller.
> 
> If KVM_X86_QUIRK_FIX_HYPERCALL_INSN is missing in the
> KVM_CAP_DISABLE_QUIRKS2 mask, it may either be that KVM is too old to
> even have the hypercall patching (pre-v2.6.25) or does do the patching,
> just doesn't have KVM_X86_QUIRK_FIX_HYPERCALL_INSN yet, which came in
> Linux commit f1a9761fbb00 ("KVM: x86: Allow userspace to opt out of
> hypercall patching"), which is v5.19.
> 
> Ignoring pre-v2.6.25 kernels for a moment, we can assume that KVM will
> do the patching. So the lack of KVM_X86_QUIRK_FIX_HYPERCALL_INSN but
> having 'hypercall_patching_enabled == false' indicates that the user
> wants to disable it but QEMU cannot do so, because KVM lacks the
> extension to do so. This, IMO, legitimizes the warn_report("kvm:
> disabling hypercall patching not supported") -- as it's not supported.

The minimum supported kernel version is 4.5 (see commit f180e367fce4).
So pre-v2.6.25 kernels is not the case.

Surely we can list all the cases of different versions of KVM starting 
from v4.5 and draw the conclusion that the semantics of "valid_quirks & 
KVM_X86_QUIRK_FIX_HYPERCALL_INSN == 0" means KVM enables the hypercall 
patching quirk but don't provide the interface for userspace to disable 
it. So the code logic is correct.

My statement of "I think it requires a new cap in KVM to return the 
enabled quirks" is more for generic consideration. i.e., QEMU can know 
whether a quirk is enabled or not without analysing the detailed history 
of KVM.

Of course, it's more of the requirement on KVM to provide new interface 
and Current QEMU can do nothing on it. That is, current implementation 
of this PATCH is OK to me.

>>
>>> +    return 0;
>>
>> I think return 0 here is to avoid the warn_report() in the caller. But
>> for the correct semantics, we need to return -1 to indicate that it
>> fails to disable the hypercall patching?
> 
> No, returning 0 here is very much on purpose, as you noticed, to avoid
> the warn_report() in the caller. The already issued warn_report() is the
> correct one for this case.

We can use @Error to pass the error log instead of the trick on return 
value.

e.g.,

--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3228,17 +3228,24 @@ static int kvm_vm_enable_energy_msrs(KVMState *s)
      return 0;
  }

-static int kvm_vm_disable_hypercall_patching(KVMState *s)
+static int kvm_vm_disable_hypercall_patching(KVMState *s, Error **errp)
  {
      int valid_quirks = kvm_vm_check_extension(s, KVM_CAP_DISABLE_QUIRKS2);
+    int ret = -1;

      if (valid_quirks & KVM_X86_QUIRK_FIX_HYPERCALL_INSN) {
-        return kvm_vm_enable_cap(s, KVM_CAP_DISABLE_QUIRKS2, 0,
-                                 KVM_X86_QUIRK_FIX_HYPERCALL_INSN);
+        ret = kvm_vm_enable_cap(s, KVM_CAP_DISABLE_QUIRKS2, 0,
+                                KVM_X86_QUIRK_FIX_HYPERCALL_INSN);
+        if (ret) {
+            error_setg_errno(errp, -ret, "kvm: failed to disable "
+                             "hypercall patching quirk: %s",
+                             strerror(-ret));
+        }
+    } else {
+        error_setg(errp, "kvm: disabling hypercall patching not 
supported");
      }

-    warn_report("kvm: disabling hypercall patching not supported");
-    return 0;
+    return ret;
  }

  int kvm_arch_init(MachineState *ms, KVMState *s)
@@ -3381,8 +3388,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
      }

      if (s->hypercall_patching_enabled == false) {
-        if (kvm_vm_disable_hypercall_patching(s)) {
-            warn_report("kvm: failed to disable hypercall patching quirk");
+        if (kvm_vm_disable_hypercall_patching(s, &local_err)) {
+            error_report_err(local_err);
          }
      }

> I guess, it's a question of if disabling hypercall patching is a hard
> requirement or can soft-fail. I decided for the latter, as hypercall
> patching shouldn't be needed in most cases, so if it cannot be disabled,
> it's mostly fine to start the VM still.
> 
>>
>>> +}
>>> +
>>>    int kvm_arch_init(MachineState *ms, KVMState *s)
>>>    {
>>>        int ret;
>>> @@ -3363,6 +3376,12 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>>>            }
>>>        }
>>>    +    if (s->hypercall_patching_enabled == false) {
>>> +        if (kvm_vm_disable_hypercall_patching(s)) {
>>> +            warn_report("kvm: failed to disable hypercall patching
>>> quirk");
>>> +        }
>>> +    }
>>> +
>>>        return 0;
>>>    }
>>>    @@ -6456,6 +6475,19 @@ void kvm_request_xsave_components(X86CPU
>>> *cpu, uint64_t mask)
>>>        }
>>>    }
>>>    +static bool kvm_arch_get_hypercall_patching(Object *obj, Error **errp)
>>> +{
>>> +    KVMState *s = KVM_STATE(obj);
>>> +    return s->hypercall_patching_enabled;
>>> +}
>>> +
>>> +static void kvm_arch_set_hypercall_patching(Object *obj, bool value,
>>> +                                            Error **errp)
>>> +{
>>> +    KVMState *s = KVM_STATE(obj);
>>> +    s->hypercall_patching_enabled = value;
>>> +}
>>> +
>>>    static int kvm_arch_get_notify_vmexit(Object *obj, Error **errp)
>>>    {
>>>        KVMState *s = KVM_STATE(obj);
>>> @@ -6589,6 +6621,12 @@ static void
>>> kvm_arch_set_xen_evtchn_max_pirq(Object *obj, Visitor *v,
>>>      void kvm_arch_accel_class_init(ObjectClass *oc)
>>>    {
>>> +    object_class_property_add_bool(oc, "hypercall-patching",
>>> +                                   kvm_arch_get_hypercall_patching,
>>> +                                   kvm_arch_set_hypercall_patching);
>>> +    object_class_property_set_description(oc, "hypercall-patching",
>>> +                                          "Enable hypercall patching
>>> quirk");
>>> +
>>>        object_class_property_add_enum(oc, "notify-vmexit",
>>> "NotifyVMexitOption",
>>>                                       &NotifyVmexitOption_lookup,
>>>                                       kvm_arch_get_notify_vmexit,
>>
> 
> Thanks,
> Mathias


