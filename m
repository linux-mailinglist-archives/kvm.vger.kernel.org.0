Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A51D304491
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 18:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbhAZREV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 12:04:21 -0500
Received: from mga18.intel.com ([134.134.136.126]:46175 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389352AbhAZHI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 02:08:58 -0500
IronPort-SDR: peUS+ZqQt6RStb7rl0IXbCxdFvbwIdIid0iAOL1uw8yg+fmWPS+j3zmwHSbeLRKGrYWcFNiYww
 JYIsKPMqbTAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="167531744"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208,223";a="167531744"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 23:08:14 -0800
IronPort-SDR: Q3I5rRy6WazZB77Jv8v0af6ftaxEdCZK8PN9val+y7fUo6aKrwGM02knAOUwCrKbeGyQyEoqlU
 3e3svh8Vgqog==
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208,223";a="387717337"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 23:08:12 -0800
Subject: Re: [PATCH v3 00/17] KVM: x86/pmu: Add support to enable Guest PEBS
 via DS
To:     "Liuxiangdong (Aven, Cloud Infrastructure Service Product Dept.)" 
        <liuxiangdong5@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiexiangyou <xiexiangyou@huawei.com>,
        Wei Wang <wei.w.wang@intel.com>, kvm <kvm@vger.kernel.org>,
        Like Xu <like.xu@linux.intel.com>,
        "Fangyi (Eric)" <eric.fangyi@huawei.com>
References: <EEC2A80E7137D84ABF791B01D40FA9A601EC200E@DGGEMM506-MBX.china.huawei.com>
 <584b4e9a-37e7-1f2a-0a67-42034329a9dc@linux.intel.com>
 <600ED9F7.1060503@huawei.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <f4dcb068-2ddf-428f-50ad-39f65cad3710@intel.com>
Date:   Tue, 26 Jan 2021 15:08:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <600ED9F7.1060503@huawei.com>
Content-Type: multipart/mixed;
 boundary="------------66C0CC432936994DA8A4C3CF"
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a multi-part message in MIME format.
--------------66C0CC432936994DA8A4C3CF
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2021/1/25 22:47, Liuxiangdong (Aven, Cloud Infrastructure Service 
Product Dept.) wrote:
> Thanks for replying,
>
> On 2021/1/25 10:41, Like Xu wrote:
>> + kvm@vger.kernel.org
>>
>> Hi Liuxiangdong,
>>
>> On 2021/1/22 18:02, Liuxiangdong (Aven, Cloud Infrastructure Service 
>> Product Dept.) wrote:
>>> Hi Like,
>>>
>>> Some questions about 
>>> https://lore.kernel.org/kvm/20210104131542.495413-1-like.xu@linux.intel.com/ 
>>> <https://lore.kernel.org/kvm/20210104131542.495413-1-like.xu@linux.intel.com/> 
>>>
>>
>> Thanks for trying the PEBS feature in the guest,
>> and I assume you have correctly applied the QEMU patches for guest PEBS.
>>
> Is there any other patch that needs to be apply? I use qemu 5.2.0. 
> (download from github on January 14th)

Two qemu patches are attached against qemu tree
(commit 31ee895047bdcf7387e3570cbd2a473c6f744b08)
and then run the guest with "-cpu,pebs=true".

Note, this two patch are just for test and not finalized for qemu upstream.

>
>>> 1)Test in IceLake
>>
>> In the [PATCH v3 10/17] KVM: x86/pmu: Expose CPUIDs feature bits PDCM, 
>> DS, DTES64, we only support Ice Lake with the following x86_model(s):
>>
>> #define INTEL_FAM6_ICELAKE_X        0x6A
>> #define INTEL_FAM6_ICELAKE_D        0x6C
>>
>> you can check the eax output of "cpuid -l 1 -1 -r",
>> for example "0x000606a4" meets this requirement.
> It's INTEL_FAM6_ICELAKE_X

Yes, it's the target hardware.

> cpuid -l 1 -1 -r
>
> CPU:
>    0x00000001 0x00: eax=0x000606a6 ebx=0xb4800800 ecx=0x7ffefbf7 
> edx=0xbfebfbff
>
>>>
>>> HOST:
>>>
>>> CPU family:                      6
>>>
>>> Model:                           106
>>>
>>> Model name:                      Intel(R) Xeon(R) Platinum 8378A CPU $@ $@
>>>
>>> microcode: sig=0x606a6, pf=0x1, revision=0xd000122
>>
>> As long as you get the latest BIOS from the provider,
>> you may check 'cat /proc/cpuinfo | grep code | uniq' with the latest one.
> OK. I'll do it later.
>>
>>>
>>> Guest:  linux kernel 5.11.0-rc2
>>
>> I assume it's the "upstream tag v5.11-rc2" which is fine.
> Yes.
>>
>>>
>>> We can find pebs/intel_pt flag in guest cpuinfo, but there still exists 
>>> error when we use perf
>>
>> Just a note, intel_pt and pebs are two features and we can write
>> pebs records to intel_pt buffer with extra hardware support.
>> (by default, pebs records are written to the pebs buffer)
>>
>> You may check the output of "dmesg | grep PEBS" in the guest
>> to see if the guest PEBS cpuinfo is exposed and use "perf record
>> –e cycles:pp" to see if PEBS feature actually  works in the guest.
>
> I apply only pebs patch set to linux kernel 5.11.0-rc2, test perf in 
> guest and dump stack when return -EOPNOTSUPP

Yes, you may apply the qemu patches and try it again.

>
> (1)
> # perf record -e instructions:pp
> Error:
> instructions:pp: PMU Hardware doesn't support 
> sampling/overflow-interrupts. Try 'perf stat'
>
> [  117.793266] Call Trace:
> [  117.793270]  dump_stack+0x57/0x6a
> [  117.793275]  intel_pmu_setup_lbr_filter+0x137/0x190
> [  117.793280]  intel_pmu_hw_config+0x18b/0x320
> [  117.793288]  hsw_hw_config+0xe/0xa0
> [  117.793290]  x86_pmu_event_init+0x8e/0x210
> [  117.793293]  perf_try_init_event+0x40/0x130
> [  117.793297]  perf_event_alloc.part.22+0x611/0xde0
> [  117.793299]  ? alloc_fd+0xba/0x180
> [  117.793302]  __do_sys_perf_event_open+0x1bd/0xd90
> [  117.793305]  do_syscall_64+0x33/0x40
> [  117.793308]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> Do we need lbr when we use pebs?

No, lbr ane pebs are two features and we enable it separately.

>
> I tried to apply lbr patch 
> set(https://lore.kernel.org/kvm/911adb63-ba05-ea93-c038-1c09cff15eda@intel.com/) 
> to kernel and qemu, but there is still other problem.
> Error:
> The sys_perf_event_open() syscall returned with 22 (Invalid argument) for 
> event
> ...

We don't need that patch for PEBS feature.

>
> (2)
> # perf record -e instructions:ppp
> Error:
> instructions:ppp: PMU Hardware doesn't support 
> sampling/overflow-interrupts. Try 'perf stat'
>
> [  115.188498] Call Trace:
> [  115.188503]  dump_stack+0x57/0x6a
> [  115.188509]  x86_pmu_hw_config+0x1eb/0x220
> [  115.188515]  intel_pmu_hw_config+0x13/0x320
> [  115.188519]  hsw_hw_config+0xe/0xa0
> [  115.188521]  x86_pmu_event_init+0x8e/0x210
> [  115.188524]  perf_try_init_event+0x40/0x130
> [  115.188528]  perf_event_alloc.part.22+0x611/0xde0
> [  115.188530]  ? alloc_fd+0xba/0x180
> [  115.188534]  __do_sys_perf_event_open+0x1bd/0xd90
> [  115.188538]  do_syscall_64+0x33/0x40
> [  115.188541]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> This is beacuse x86_pmu.intel_cap.pebs_format is always 0 in 
> x86_pmu_max_precise().
>
> We rdmsr MSR_IA32_PERF_CAPABILITIES(0x00000345)  from HOST, it's f4c5.
> From guest, it's 2000
>
>>>
>>> # perf record –e cycles:pp
>>>
>>> Error:
>>>
>>> cycles:pp: PMU Hardware doesn’t support sampling/overflow-interrupts. 
>>> Try ‘perf stat’
>>>
>>> Could you give some advice?
>>
>> If you have more specific comments or any concerns, just let me know.
>>
>>>
>>> 2)Test in Skylake
>>>
>>> HOST:
>>>
>>> CPU family:                      6
>>>
>>> Model:                           85
>>>
>>> Model name:                      Intel(R) Xeon(R) Gold 6146 CPU @
>>>
>>>                                    3.20GHz
>>>
>>> microcode        : 0x2000064
>>>
>>> Guest: linux 4.18
>>>
>>> we cannot find intel_pt flag in guest cpuinfo because 
>>> cpu_has_vmx_intel_pt() return false.
>>
>> You may check vmx_pebs_supported().
> It's true.
>>
>>>
>>> SECONDARY_EXEC_PT_USE_GPA/VM_EXIT_CLEAR_IA32_RTIT_CTL/VM_ENTRY_LOAD_IA32_RTIT_CTL 
>>> are both disable.
>>>
>>> Is it because microcode is not supported?
>>>
>>> And, isthere a new macrocode which can support these bits? How can we 
>>> get this?
>>
>> Currently, this patch set doesn't support guest PEBS on the Skylake
>> platforms, and if we choose to support it, we will let you know.
>>
> And now, we want to use pebs in skylake. If we develop based on pebs 
> patch set, do you have any suggestions?

- At least you need to pin guest memory such as "-overcommit mem-lock=true" 
for qemu
- You may rewrite the patches 13 - 17 for Skylake specific because the 
records format is different with Ice Lake.

> I think microcode requirements need to be satisfied.  Can we use 
> https://github.com/intel/Intel-Linux-Processor-Microcode-Data-Files ?

You may try it at your risk and again,
this patch set doesn't support guest PEBS on the Skylake platforms currently.

>
>> ---
>> thx,likexu
>>
>>>
>>> Thanks,
>>>
>>> Liuxiangdong
>>>
>>
> Thanks. Liuxiangdong
>


--------------66C0CC432936994DA8A4C3CF
Content-Type: text/plain; charset=UTF-8;
 name="0001-target-i386-Expose-PEBS-capabilities-in-the-FEAT_PER.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-target-i386-Expose-PEBS-capabilities-in-the-FEAT_PER.pa";
 filename*1="tch"

RnJvbSAyNGEwNGI4MDBkMjRlM2I0OTNlNTA5NGY4ODY0OTQwMjkyMzE0N2EyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBMaWtlIFh1IDxsaWtlLnh1QGxpbnV4LmludGVsLmNv
bT4KRGF0ZTogRnJpLCA0IFNlcCAyMDIwIDEwOjE5OjI3ICswODAwClN1YmplY3Q6IFtQQVRD
SCAxLzJdIHRhcmdldC9pMzg2OiBFeHBvc2UgUEVCUyBjYXBhYmlsaXRpZXMgaW4gdGhlCiBG
RUFUX1BFUkZfQ0FQQUJJTElUSUVTCgpUaGUgSUEzMl9QRVJGX0NBUEFCSUxJVElFUyBNU1Ig
cHJvdmlkZXMgZW51bWVyYXRpb24gb2YgYSB2YXJpZXR5IG9mClBFQlMgZmVhdHVyZSBpbnRl
cmZhY2VzOgoKLSBQRUJTVHJhcFs2XTogVHJhcC9GYXVsdC1saWtlIGluZGljYXRvciBvZiBQ
RUJTIHJlY29yZGluZyBhc3Npc3Q7Ci0gUEVCU0FyY2hSZWdzWzddOiBJbmRpY2F0b3Igb2Yg
UEVCUyBhc3Npc3Qgc2F2ZSBhcmNoaXRlY3R1cmFsIHJlZ2lzdGVyczsKLSBQRUJTX0ZNVFti
aXRzIDExOjhdOiBTcGVjaWZpZXMgdGhlIGVuY29kaW5nIG9mIHRoZSBsYXlvdXQgb2YgUEVC
UyByZWNvcmRzOwotIFBFQlNfQkFTRUxJTkUgW2JpdCAxNF06IElmIHNldCwgdGhlIGZvbGxv
d2luZyBpcyB0cnVlOgogICAgKDEpIEV4dGVuZGVkIFBFQlMgaXMgc3VwcG9ydGVkLiBBbGwg
Y291bnRlcnMgc3VwcG9ydCB0aGUgUEVCUyBmYWNpbGl0eSwKICAgIGFuZCBhbGwgZXZlbnRz
IGNhbiBnZW5lcmF0ZSBQRUJTIHJlY29yZHMgd2hlbiBQRUJTIGlzIGVuYWJsZWQuCiAgICAo
MikgQWRhcHRpdmUgUEVCUyBpcyBzdXBwb3J0ZWQuIFRoZSBQRUJTX0RBVEFfQ0ZHIE1TUiBh
bmQgYWRhcHRpdmUgcmVjb3JkCiAgICBlbmFibGUgYml0cyBhcmUgc3VwcG9ydGVkLgoKU2ln
bmVkLW9mZi1ieTogTGlrZSBYdSA8bGlrZS54dUBsaW51eC5pbnRlbC5jb20+Ci0tLQogdGFy
Z2V0L2kzODYvY3B1LmMgfCA2ICsrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9u
cygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS90YXJnZXQvaTM4Ni9jcHUuYyBi
L3RhcmdldC9pMzg2L2NwdS5jCmluZGV4IDcyYTc5ZTYwMTkuLjE0MjYyYzdiZjcgMTAwNjQ0
Ci0tLSBhL3RhcmdldC9pMzg2L2NwdS5jCisrKyBiL3RhcmdldC9pMzg2L2NwdS5jCkBAIC0x
MTM2LDkgKzExMzYsOSBAQCBzdGF0aWMgRmVhdHVyZVdvcmRJbmZvIGZlYXR1cmVfd29yZF9p
bmZvW0ZFQVRVUkVfV09SRFNdID0gewogICAgICAgICAudHlwZSA9IE1TUl9GRUFUVVJFX1dP
UkQsCiAgICAgICAgIC5mZWF0X25hbWVzID0gewogICAgICAgICAgICAgTlVMTCwgTlVMTCwg
TlVMTCwgTlVMTCwKLSAgICAgICAgICAgIE5VTEwsIE5VTEwsIE5VTEwsIE5VTEwsCi0gICAg
ICAgICAgICBOVUxMLCBOVUxMLCBOVUxMLCBOVUxMLAotICAgICAgICAgICAgTlVMTCwgImZ1
bGwtd2lkdGgtd3JpdGUiLCBOVUxMLCBOVUxMLAorICAgICAgICAgICAgTlVMTCwgTlVMTCwg
InBlYnMtdHJhcCIsICJwZWJzLWFyY2gtcmVnIiwKKyAgICAgICAgICAgICJwZWJzLWZtdC0w
IiwgInBlYnMtZm10LTEiLCAicGVicy1mbXQtMiIsICJwZWJzLWZtdC0zIiwKKyAgICAgICAg
ICAgIE5VTEwsICJmdWxsLXdpZHRoLXdyaXRlIiwgInBlYnMtYmFzZWxpbmUiLCBOVUxMLAog
ICAgICAgICAgICAgTlVMTCwgTlVMTCwgTlVMTCwgTlVMTCwKICAgICAgICAgICAgIE5VTEws
IE5VTEwsIE5VTEwsIE5VTEwsCiAgICAgICAgICAgICBOVUxMLCBOVUxMLCBOVUxMLCBOVUxM
LAotLSAKMi4yOS4yCgo=
--------------66C0CC432936994DA8A4C3CF
Content-Type: text/plain; charset=UTF-8;
 name="0002-target-i386-add-cpu-pebs-true-support-to-enable-gues.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0002-target-i386-add-cpu-pebs-true-support-to-enable-gues.pa";
 filename*1="tch"

RnJvbSBiZTUyNDY2OTRhYWYyMTMyMzk2ZWUwYjkwN2U2NzlmNWM5Y2NkMDg5IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBMaWtlIFh1IDxsaWtlLnh1QGxpbnV4LmludGVsLmNv
bT4KRGF0ZTogRnJpLCA0IFNlcCAyMDIwIDEwOjQyOjI4ICswODAwClN1YmplY3Q6IFtQQVRD
SCAyLzJdIHRhcmdldC9pMzg2OiBhZGQgLWNwdSxwZWJzPXRydWUgc3VwcG9ydCB0byBlbmFi
bGUgZ3Vlc3QKIFBFQlMKClRoZSBQRUJTIGZlYXR1cmUgd291bGQgYmUgZW5hYmxlZCBvbiB0
aGUgZ3Vlc3QgaWY6Ci0gdGhlIEtWTSBpcyBlbmFibGVkIGFuZCB0aGUgUE1VIGlzIGVuYWJs
ZWQgYW5kLAotIHRoZSBtc3ItYmFzZWQtZmVhdHVyZSBJQTMyX1BFUkZfQ0FQQUJJTElUSUVT
IGlzIHN1cHBvcnRlcmQgYW5kLAotIHRoZSBzdXBwb3J0ZWQgcmV0dXJuZWQgdmFsdWUgZm9y
IFBFQlMgZnJvbSB0aGlzIG1zciBpcyBub3QgemVyby4KClRoZSBQRUJTIGZlYXR1cmUgd291
bGQgYmUgZGlzYWJsZWQgb24gdGhlIGd1ZXN0IGlmOgotIHRoZSBtc3ItYmFzZWQtZmVhdHVy
ZSBJQTMyX1BFUkZfQ0FQQUJJTElUSUVTIGlzIHVuc3VwcG9ydGVyZCBPUiwKLSBxZW11IHNl
dCB0aGUgSUEzMl9QRVJGX0NBUEFCSUxJVElFUyBtc3IgZmVhdHVyZSB3aXRob3V0IHBlYnNf
Zm10IHZhbHVlcyBPUiwKLSB0aGUgcmVxdWVzdGVkIGd1ZXN0IHZjcHUgbW9kZWwgZG9lc24n
dCBzdXBwb3J0IFBEQ00uCgpTaWduZWQtb2ZmLWJ5OiBMaWtlIFh1IDxsaWtlLnh1QGxpbnV4
LmludGVsLmNvbT4KLS0tCiBody9pMzg2L3BjLmMgICAgICAgICAgfCAgMSArCiB0YXJnZXQv
aTM4Ni9jcHUuYyAgICAgfCAyMCArKysrKysrKysrKysrKysrKysrKwogdGFyZ2V0L2kzODYv
Y3B1LmggICAgIHwgIDcgKysrKysrKwogdGFyZ2V0L2kzODYva3ZtL2t2bS5jIHwgMTAgKysr
KysrKysrKwogNCBmaWxlcyBjaGFuZ2VkLCAzOCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0
IGEvaHcvaTM4Ni9wYy5jIGIvaHcvaTM4Ni9wYy5jCmluZGV4IDU0NThmNjFkMTAuLjhlOWMx
Yjc1NDUgMTAwNjQ0Ci0tLSBhL2h3L2kzODYvcGMuYworKysgYi9ody9pMzg2L3BjLmMKQEAg
LTMzMCw2ICszMzAsNyBAQCBHbG9iYWxQcm9wZXJ0eSBwY19jb21wYXRfMV81W10gPSB7CiAg
ICAgeyAiTmVoYWxlbS0iIFRZUEVfWDg2X0NQVSwgIm1pbi1sZXZlbCIsICIyIiB9LAogICAg
IHsgInZpcnRpby1uZXQtcGNpIiwgImFueV9sYXlvdXQiLCAib2ZmIiB9LAogICAgIHsgVFlQ
RV9YODZfQ1BVLCAicG11IiwgIm9uIiB9LAorICAgIHsgVFlQRV9YODZfQ1BVLCAicGVicyIs
ICJvbiIgfSwKICAgICB7ICJpNDQwRlgtcGNpaG9zdCIsICJzaG9ydF9yb290X2J1cyIsICIw
IiB9LAogICAgIHsgInEzNS1wY2lob3N0IiwgInNob3J0X3Jvb3RfYnVzIiwgIjAiIH0sCiB9
OwpkaWZmIC0tZ2l0IGEvdGFyZ2V0L2kzODYvY3B1LmMgYi90YXJnZXQvaTM4Ni9jcHUuYwpp
bmRleCAxNDI2MmM3YmY3Li45ZGZmYzg1NTQyIDEwMDY0NAotLS0gYS90YXJnZXQvaTM4Ni9j
cHUuYworKysgYi90YXJnZXQvaTM4Ni9jcHUuYwpAQCAtNDIyOCw2ICs0MjI4LDEyIEBAIHN0
YXRpYyBib29sIGxtY2Vfc3VwcG9ydGVkKHZvaWQpCiAgICAgcmV0dXJuICEhKG1jZV9jYXAg
JiBNQ0dfTE1DRV9QKTsKIH0KIAorc3RhdGljIGlubGluZSBib29sIGxicl9zdXBwb3J0ZWQo
dm9pZCkKK3sKKyAgICByZXR1cm4ga3ZtX2VuYWJsZWQoKSAmJiAoa3ZtX2FyY2hfZ2V0X3N1
cHBvcnRlZF9tc3JfZmVhdHVyZShrdm1fc3RhdGUsCisgICAgICAgIE1TUl9JQTMyX1BFUkZf
Q0FQQUJJTElUSUVTKSAmIFBFUkZfQ0FQX1BFQlNfRk9STUFUKTsKK30KKwogI2RlZmluZSBD
UFVJRF9NT0RFTF9JRF9TWiA0OAogCiAvKioKQEAgLTQzMzIsNiArNDMzOCw5IEBAIHN0YXRp
YyB2b2lkIG1heF94ODZfY3B1X2luaXRmbihPYmplY3QgKm9iaikKICAgICB9CiAKICAgICBv
YmplY3RfcHJvcGVydHlfc2V0X2Jvb2woT0JKRUNUKGNwdSksICJwbXUiLCB0cnVlLCAmZXJy
b3JfYWJvcnQpOworICAgIGlmIChsYnJfc3VwcG9ydGVkKCkpIHsKKyAgICAgICAgb2JqZWN0
X3Byb3BlcnR5X3NldF9ib29sKE9CSkVDVChjcHUpLCAicGVicyIsIHRydWUsICZlcnJvcl9h
Ym9ydCk7CisgICAgfQogfQogCiBzdGF0aWMgY29uc3QgVHlwZUluZm8gbWF4X3g4Nl9jcHVf
dHlwZV9pbmZvID0gewpAQCAtNTU0NSw2ICs1NTU0LDEwIEBAIHZvaWQgY3B1X3g4Nl9jcHVp
ZChDUFVYODZTdGF0ZSAqZW52LCB1aW50MzJfdCBpbmRleCwgdWludDMyX3QgY291bnQsCiAg
ICAgICAgIH0KICAgICAgICAgaWYgKCFjcHUtPmVuYWJsZV9wbXUpIHsKICAgICAgICAgICAg
ICplY3ggJj0gfkNQVUlEX0VYVF9QRENNOworICAgICAgICAgICAgaWYgKGNwdS0+ZW5hYmxl
X3BlYnMpIHsKKyAgICAgICAgICAgICAgICB3YXJuX3JlcG9ydCgiUEVCUyBpcyB1bnN1cHBv
cnRlZCBzaW5jZSBndWVzdCBQTVUgaXMgZGlzYWJsZWQuIik7CisgICAgICAgICAgICAgICAg
ZXhpdCgxKTsKKyAgICAgICAgICAgIH0KICAgICAgICAgfQogICAgICAgICBicmVhazsKICAg
ICBjYXNlIDI6CkBAIC02NjEwLDYgKzY2MjMsMTIgQEAgc3RhdGljIHZvaWQgeDg2X2NwdV9y
ZWFsaXplZm4oRGV2aWNlU3RhdGUgKmRldiwgRXJyb3IgKiplcnJwKQogICAgICAgICB9CiAg
ICAgfQogCisgICAgaWYgKCFjcHUtPm1heF9mZWF0dXJlcyAmJiBjcHUtPmVuYWJsZV9wZWJz
ICYmCisgICAgICAgICEoZW52LT5mZWF0dXJlc1tGRUFUXzFfRUNYXSAmIENQVUlEX0VYVF9Q
RENNKSkgeworICAgICAgICB3YXJuX3JlcG9ydCgicmVxdWVzdGVkIHZjcHUgbW9kZWwgZG9l
c24ndCBzdXBwb3J0IFBEQ00gZm9yIFBFQlMuIik7CisgICAgICAgIGV4aXQoMSk7CisgICAg
fQorCiAgICAgaWYgKGNwdS0+dWNvZGVfcmV2ID09IDApIHsKICAgICAgICAgLyogVGhlIGRl
ZmF1bHQgaXMgdGhlIHNhbWUgYXMgS1ZNJ3MuICAqLwogICAgICAgICBpZiAoSVNfQU1EX0NQ
VShlbnYpKSB7CkBAIC03MTkyLDYgKzcyMTEsNyBAQCBzdGF0aWMgUHJvcGVydHkgeDg2X2Nw
dV9wcm9wZXJ0aWVzW10gPSB7CiAjZW5kaWYKICAgICBERUZJTkVfUFJPUF9JTlQzMigibm9k
ZS1pZCIsIFg4NkNQVSwgbm9kZV9pZCwgQ1BVX1VOU0VUX05VTUFfTk9ERV9JRCksCiAgICAg
REVGSU5FX1BST1BfQk9PTCgicG11IiwgWDg2Q1BVLCBlbmFibGVfcG11LCBmYWxzZSksCisg
ICAgREVGSU5FX1BST1BfQk9PTCgicGVicyIsIFg4NkNQVSwgZW5hYmxlX3BlYnMsIGZhbHNl
KSwKIAogICAgIERFRklORV9QUk9QX1VJTlQzMigiaHYtc3BpbmxvY2tzIiwgWDg2Q1BVLCBo
eXBlcnZfc3BpbmxvY2tfYXR0ZW1wdHMsCiAgICAgICAgICAgICAgICAgICAgICAgIEhZUEVS
Vl9TUElOTE9DS19ORVZFUl9OT1RJRlkpLApkaWZmIC0tZ2l0IGEvdGFyZ2V0L2kzODYvY3B1
LmggYi90YXJnZXQvaTM4Ni9jcHUuaAppbmRleCBkMjNhNWIzNDBhLi5lYWM4ZDhjNjhlIDEw
MDY0NAotLS0gYS90YXJnZXQvaTM4Ni9jcHUuaAorKysgYi90YXJnZXQvaTM4Ni9jcHUuaApA
QCAtMzU0LDYgKzM1NCwxMiBAQCB0eXBlZGVmIGVudW0gWDg2U2VnIHsKICNkZWZpbmUgQVJD
SF9DQVBfVFNYX0NUUkxfTVNSCQkoMTw8NykKIAogI2RlZmluZSBNU1JfSUEzMl9QRVJGX0NB
UEFCSUxJVElFUyAgICAgIDB4MzQ1CisjZGVmaW5lIFBFUkZfQ0FQX1BFQlNfVFJBUCAgICAg
ICAgICAgICBCSVRfVUxMKDYpCisjZGVmaW5lIFBFUkZfQ0FQX0FSQ0hfUkVHICAgICAgICAg
ICAgICBCSVRfVUxMKDcpCisjZGVmaW5lIFBFUkZfQ0FQX1BFQlNfRk9STUFUICAgICAgICAg
ICAweGYwMAorI2RlZmluZSBQRVJGX0NBUF9QRUJTX0JBU0VMSU5FICAgICAgICAgQklUX1VM
TCgxNCkKKyNkZWZpbmUgUEVSRl9DQVBfUEVCU19NQVNLCShQRVJGX0NBUF9QRUJTX1RSQVAg
fCBQRVJGX0NBUF9BUkNIX1JFRyB8IFwKKwlQRVJGX0NBUF9QRUJTX0ZPUk1BVCB8IFBFUkZf
Q0FQX1BFQlNfQkFTRUxJTkUpCiAKICNkZWZpbmUgTVNSX0lBMzJfVFNYX0NUUkwJCTB4MTIy
CiAjZGVmaW5lIE1TUl9JQTMyX1RTQ0RFQURMSU5FICAgICAgICAgICAgMHg2ZTAKQEAgLTE3
MDgsNiArMTcxNCw3IEBAIHN0cnVjdCBYODZDUFUgewogICAgICAqIGNhcGFiaWxpdGllcykg
ZGlyZWN0bHkgdG8gdGhlIGd1ZXN0LgogICAgICAqLwogICAgIGJvb2wgZW5hYmxlX3BtdTsK
KyAgICBib29sIGVuYWJsZV9wZWJzOwogCiAgICAgLyogTE1DRSBzdXBwb3J0IGNhbiBiZSBl
bmFibGVkL2Rpc2FibGVkIHZpYSBjcHUgb3B0aW9uICdsbWNlPW9uL29mZicuIEl0IGlzCiAg
ICAgICogZGlzYWJsZWQgYnkgZGVmYXVsdCB0byBhdm9pZCBicmVha2luZyBtaWdyYXRpb24g
YmV0d2VlbiBRRU1VIHdpdGgKZGlmZiAtLWdpdCBhL3RhcmdldC9pMzg2L2t2bS9rdm0uYyBi
L3RhcmdldC9pMzg2L2t2bS9rdm0uYwppbmRleCA2ZGMxZWUwNTJkLi44ZmUxZDJmZWVhIDEw
MDY0NAotLS0gYS90YXJnZXQvaTM4Ni9rdm0va3ZtLmMKKysrIGIvdGFyZ2V0L2kzODYva3Zt
L2t2bS5jCkBAIC0yNzA1LDYgKzI3MDUsMTMgQEAgc3RhdGljIHZvaWQga3ZtX21zcl9lbnRy
eV9hZGRfcGVyZihYODZDUFUgKmNwdSwgRmVhdHVyZVdvcmRBcnJheSBmKQogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIE1TUl9JQTMyX1BFUkZfQ0FQQUJJ
TElUSUVTKTsKIAogICAgIGlmIChrdm1fcGVyZl9jYXApIHsKKyAgICAgICAgaWYgKCFjcHUt
PmVuYWJsZV9wZWJzKSB7CisgICAgICAgICAgICBrdm1fcGVyZl9jYXAgJj0gflBFUkZfQ0FQ
X1BFQlNfTUFTSzsKKyAgICAgICAgfQorICAgICAgICBpZiAoIShrdm1fcGVyZl9jYXAgJiBQ
RVJGX0NBUF9QRUJTX01BU0spICYmIGNwdS0+ZW5hYmxlX3BlYnMpIHsKKyAgICAgICAgICAg
IHdhcm5fcmVwb3J0KCJNU1JfSUEzMl9QRVJGX0NBUEFCSUxJVElFUyByZXBvcnRlZCBieSBL
Vk0gZG9lcyBub3Qgc3VwcG9ydCBQRUJTLiIpOworICAgICAgICAgICAgZXhpdCgxKTsKKyAg
ICAgICAgfQogICAgICAgICBrdm1fbXNyX2VudHJ5X2FkZChjcHUsIE1TUl9JQTMyX1BFUkZf
Q0FQQUJJTElUSUVTLAogICAgICAgICAgICAgICAgICAgICAgICAga3ZtX3BlcmZfY2FwICYg
ZltGRUFUX1BFUkZfQ0FQQUJJTElUSUVTXSk7CiAgICAgfQpAQCAtMjc0NCw2ICsyNzUxLDkg
QEAgc3RhdGljIHZvaWQga3ZtX2luaXRfbXNycyhYODZDUFUgKmNwdSkKIAogICAgIGlmICho
YXNfbXNyX3BlcmZfY2FwYWJzICYmIGNwdS0+ZW5hYmxlX3BtdSkgewogICAgICAgICBrdm1f
bXNyX2VudHJ5X2FkZF9wZXJmKGNwdSwgZW52LT5mZWF0dXJlcyk7CisgICAgfSBlbHNlIGlm
ICghaGFzX21zcl9wZXJmX2NhcGFicyAmJiBjcHUtPmVuYWJsZV9wZWJzKSB7CisgICAgICAg
IHdhcm5fcmVwb3J0KCJLVk0gZG9lc24ndCBzdXBwb3J0IE1TUl9JQTMyX1BFUkZfQ0FQQUJJ
TElUSUVTIGZvciBQRUJTLiIpOworICAgICAgICBleGl0KDEpOwogICAgIH0KIAogICAgIGlm
IChoYXNfbXNyX3Vjb2RlX3JldikgewotLSAKMi4yOS4yCgo=
--------------66C0CC432936994DA8A4C3CF--
