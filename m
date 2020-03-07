Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F0F17CD57
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2020 10:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgCGJs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Mar 2020 04:48:59 -0500
Received: from mout.web.de ([212.227.15.3]:45965 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbgCGJs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Mar 2020 04:48:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1583574507;
        bh=NfYTLzzJkZUdCjUySaSerm1xfcOdkle+o2cN/pwHHvI=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=FoT6pFGPuFPu/Ab0sk/+Q8WlnXmAVnZh0PBMbIQLtTLz2gFPmlpRdewGU69GMZZeG
         1RDW2n/JAek1ORfQToPEDI4624K7T4kBdXPoSw502OG4r5ALU8sQNcDROGand65+wb
         qYDMT66X0hnDX8QSOUrZd4FdGIy5KM65iOE9oU/k=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.55.156]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MCqmp-1j0rHc0RZz-009jrJ; Sat, 07
 Mar 2020 10:48:27 +0100
Subject: Re: [PATCH 6/6] KVM: x86: Add requested index to the CPUID tracepoint
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-7-sean.j.christopherson@intel.com>
From:   Jan Kiszka <jan.kiszka@web.de>
Message-ID: <00827dc7-3338-ce1a-923a-784284cb26db@web.de>
Date:   Sat, 7 Mar 2020 10:48:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302195736.24777-7-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:l1aUPNuFvYp9CoUQMSZJV7f6WzEVM9scmarRJ+A48HNxbxkcGoW
 b33bxhIDH7cGv+BPRBUj0bkevbMX622nbNj79UZpUOZKAg6kb+YE7+/BoTChoh8pKlXfKWS
 noh+Y+JaL7fRHvLv9Vq4ToClCGX3IJbN1+AzuSqjg/54G1h9xM//qE4BOVBEYHhX/B5mI0q
 yCZ3yqzsTKx4YzGdTHwlg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wxVnwk6qj7E=:vxZjq4j7XV57YYVd4YaPlQ
 WO1mR12AXAlyxAfonBYpuPnieU8mMSggPKPLCIC5u4WRMG+/K/i+ocK3J8vklu58888xuESNd
 FnMpt6kh8xELgdtRoQeABwat7u30oYc5YYExLBsQkTiUFFiIrXyzIMTfy20P+F36T1hB/bSW0
 S+wtanM5OXtxthsqV10Ae3L5uSvrvrdJXf+93RkLKYGCYz/ysykv9vci1LkNpfLhrT3eKd7T3
 n6g62rYDlSWOCN3woJBGV/mE0gfOR5icq+zGVu+Baxa2HYI2+OPWqcDEofoxBDkCSt7LkCi1w
 jkYlUuu4ddlf1SbhsCIdWYwWWevEawhVD1k+CEXTk1isfYLKMoDiuBuqP8xMjusrsvACZLUwR
 /xAENSrZRiwcDuBJ2bhyyKgI+sR2gN2ZudPlYtYi6dBxvZMvuxoyEfwsQZUeLiUeDkcTwTMez
 CZBaOR1Lc1NL+2HgLw6bcqGdYo7LMUWqhn1ia85VFIoL6iqQI8NUuS+c8ssbUufzqdNB5cHWO
 yBbCRUW62wOTWMcHfeLtfKKwFSrJxXrCkhL9WPp9m3smoG84ojtFNZohi03y1agiBEhXldzpZ
 eLonSxVlM8mAM9lRgMUkFt5ALABuKxO/+Ud4cHNS41ZN18ciFP9r9DN8Yyknl5ooDNmACK3aU
 L7p3xSB2eTxrnLIaT4RFNBlMCnJkg5WiPfNWWwnlRMNVs+r0qtfTWB3Hvwi97LNjXhjHYDAsh
 oW8K2CpuvxBy+ttWDM/T4qQjJ6XsfMRfo9ES2nfji6nDCq/sMppKai2xVgU79VN8DxUu+tgpz
 poqHdS9jd6syqPU3s2vWS9EDSTVm6obk3cDm8BZwhH3bfF3gewK1aggBHl+rLPyFzCFvP43X7
 XY07a1P+EUqSAZm7lWODPnd4lkqqBExuVKuZoFaGnED6/aK8JCkNwp3U1ESjzgVq9odiTVSIg
 ZvNZiCQ33zRvZtpcIMPiLEi99a6YKSM+N33M7M8ycGQUg5ihVeL5vW9Z2hsaRudA9gejjQRAf
 7zCvvOqGar1pu+nEMd/2BAN2b1SbcFPXyeQywpPv5Nghu6doLeiRRRExS5J7KRFvtSTNgmrVM
 V+es3X4XMRFlN7TSQd/+ZpQu9tkX4MhHwxWFsj5WK0n3hvZe7Yx7nF1yLhH3lQydQyuY0MNUq
 WZymSnrNgdw/yNmbkdd3eohpX+aBAUTc4zrVw7f2VEDuO8dTzDZOirNN+R/PSHbryaVwgczYc
 diJVkPoBlDlzD9YCe
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.03.20 20:57, Sean Christopherson wrote:
> Output the requested index when tracing CPUID emulation; it's basically
> mandatory for leafs where the index is meaningful, and is helpful for
> verifying KVM correctness even when the index isn't meaningful, e.g. the
> trace for a Linux guest's hypervisor_cpuid_base() probing appears to
> be broken (returns all zeroes) at first glance, but is correct because
> the index is non-zero, i.e. the output values correspond to random index
> in the maximum basic leaf.
>
> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: Jan Kiszka <jan.kiszka@siemens.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   arch/x86/kvm/cpuid.c |  3 ++-
>   arch/x86/kvm/trace.h | 13 ++++++++-----
>   2 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b0a4f3c17932..a3c9f6bf43f3 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1047,7 +1047,8 @@ void kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u3=
2 *ebx,
>   			}
>   		}
>   	}
> -	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, exact_entry_exists);
> +	trace_kvm_cpuid(function, index, *eax, *ebx, *ecx, *edx,
> +			exact_entry_exists);
>   }
>   EXPORT_SYMBOL_GPL(kvm_cpuid);
>
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index f194dd058470..aa372d0119f0 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -151,12 +151,14 @@ TRACE_EVENT(kvm_fast_mmio,
>    * Tracepoint for cpuid.
>    */
>   TRACE_EVENT(kvm_cpuid,
> -	TP_PROTO(unsigned int function, unsigned long rax, unsigned long rbx,
> -		 unsigned long rcx, unsigned long rdx, bool found),
> -	TP_ARGS(function, rax, rbx, rcx, rdx, found),
> +	TP_PROTO(unsigned int function, unsigned int index, unsigned long rax,
> +		 unsigned long rbx, unsigned long rcx, unsigned long rdx,
> +		 bool found),
> +	TP_ARGS(function, index, rax, rbx, rcx, rdx, found),
>
>   	TP_STRUCT__entry(
>   		__field(	unsigned int,	function	)
> +		__field(	unsigned int,	index		)
>   		__field(	unsigned long,	rax		)
>   		__field(	unsigned long,	rbx		)
>   		__field(	unsigned long,	rcx		)
> @@ -166,6 +168,7 @@ TRACE_EVENT(kvm_cpuid,
>
>   	TP_fast_assign(
>   		__entry->function	=3D function;
> +		__entry->index		=3D index;
>   		__entry->rax		=3D rax;
>   		__entry->rbx		=3D rbx;
>   		__entry->rcx		=3D rcx;
> @@ -173,8 +176,8 @@ TRACE_EVENT(kvm_cpuid,
>   		__entry->found		=3D found;
>   	),
>
> -	TP_printk("func %x rax %lx rbx %lx rcx %lx rdx %lx, cpuid entry %s",
> -		  __entry->function, __entry->rax,
> +	TP_printk("func %x idx %x rax %lx rbx %lx rcx %lx rdx %lx, cpuid entry=
 %s",
> +		  __entry->function, __entry->index, __entry->rax,
>   		  __entry->rbx, __entry->rcx, __entry->rdx,
>   		  __entry->found ? "found" : "not found")
>   );
>

What happened to this patch in your v2 round?

Jan
