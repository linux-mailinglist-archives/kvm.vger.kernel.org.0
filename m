Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC60392F78
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 15:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236443AbhE0N03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 09:26:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34697 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236381AbhE0N0Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 09:26:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622121891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kfbV+6RYjMBpxFHPRxjhDgMU/+kk3qm9nnrSy4peRIk=;
        b=J1r9+gGqJQjS42nb869aJKV+Buacy5DI3/J3xvMkPwxH0qTRN0Cd54Pu0GxZ5XyoSTfaw5
        fbuXhBJCXQvkuXiKK0goUW9kCXndeOtekypswjniNnNsN5d3IBOyXBF2EyvABbS3SPw5qp
        B6jmKJx6D1rpQlFob0RR5M/+V/UO6zQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-KBmNJIyQMXymWrUkQsTW1w-1; Thu, 27 May 2021 09:24:47 -0400
X-MC-Unique: KBmNJIyQMXymWrUkQsTW1w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC5D864169;
        Thu, 27 May 2021 13:24:45 +0000 (UTC)
Received: from work-vm (ovpn-114-249.ams2.redhat.com [10.36.114.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C36019C66;
        Thu, 27 May 2021 13:24:39 +0000 (UTC)
Date:   Thu, 27 May 2021 14:24:37 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Claudio Fontana <cfontana@suse.de>
Cc:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Windows fails to boot after rebase to QEMU master
Message-ID: <YK+dlWz8H+dUm95Y@work-vm>
References: <20210521091451.GA6016@u366d62d47e3651.ant.amazon.com>
 <20210524055322-mutt-send-email-mst@kernel.org>
 <YK6hunkEnft6VJHz@work-vm>
 <d71fee00-0c21-c5e8-dbc6-00b7ace11c5a@suse.de>
 <YK9Y64U0wjU5K753@work-vm>
 <16a5085f-868b-7e1a-f6de-1dab16103a66@redhat.com>
 <YK9jOdCPUGQF4t0D@work-vm>
 <855c9f5c-a8e8-82b4-d71e-db9c966ddcc3@suse.de>
 <3b8f2f3b-0254-22c1-6391-44569c8ff821@suse.de>
 <d43ca6d9-d00c-6c2e-6838-36554de3fba5@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d43ca6d9-d00c-6c2e-6838-36554de3fba5@suse.de>
User-Agent: Mutt/2.0.7 (2021-05-04)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Claudio Fontana (cfontana@suse.de) wrote:
> On 5/27/21 12:53 PM, Claudio Fontana wrote:
> > On 5/27/21 11:48 AM, Claudio Fontana wrote:
> >> On 5/27/21 11:15 AM, Dr. David Alan Gilbert wrote:
> >>> * Philippe Mathieu-Daud� (philmd@redhat.com) wrote:
> >>>> On 5/27/21 10:31 AM, Dr. David Alan Gilbert wrote:
> >>>>> * Claudio Fontana (cfontana@suse.de) wrote:
> >>>>>> On 5/26/21 9:30 PM, Dr. David Alan Gilbert wrote:
> >>>>>>> * Michael S. Tsirkin (mst@redhat.com) wrote:
> >>>>>>>> On Fri, May 21, 2021 at 11:17:19AM +0200, Siddharth Chandrasekaran wrote:
> >>>>>>>>> After a rebase to QEMU master, I am having trouble booting windows VMs.
> >>>>>>>>> Git bisect indicates commit f5cc5a5c1686 ("i386: split cpu accelerators
> >>>>>>>>> from cpu.c, using AccelCPUClass") to have introduced the issue. I spent
> >>>>>>>>> some time looking at into it yesterday without much luck.
> >>>>>>>>>
> >>>>>>>>> Steps to reproduce:
> >>>>>>>>>
> >>>>>>>>>     $ ./configure --enable-kvm --disable-xen --target-list=x86_64-softmmu --enable-debug
> >>>>>>>>>     $ make -j `nproc`
> >>>>>>>>>     $ ./build/x86_64-softmmu/qemu-system-x86_64 \
> >>>>>>>>>         -cpu host,hv_synic,hv_vpindex,hv_time,hv_runtime,hv_stimer,hv_crash \
> >>>>>>>>>         -enable-kvm \
> >>>>>>>>>         -name test,debug-threads=on \
> >>>>>>>>>         -smp 1,threads=1,cores=1,sockets=1 \
> >>>>>>>>>         -m 4G \
> >>>>>>>>>         -net nic -net user \
> >>>>>>>>>         -boot d,menu=on \
> >>>>>>>>>         -usbdevice tablet \
> >>>>>>>>>         -vnc :3 \
> >>>>>>>>>         -machine q35,smm=on \
> >>>>>>>>>         -drive if=pflash,format=raw,readonly=on,unit=0,file="../OVMF_CODE.secboot.fd" \
> >>>>>>>>>         -drive if=pflash,format=raw,unit=1,file="../OVMF_VARS.secboot.fd" \
> >>>>>>>>>         -global ICH9-LPC.disable_s3=1 \
> >>>>>>>>>         -global driver=cfi.pflash01,property=secure,value=on \
> >>>>>>>>>         -cdrom "../Windows_Server_2016_14393.ISO" \
> >>>>>>>>>         -drive file="../win_server_2016.qcow2",format=qcow2,if=none,id=rootfs_drive \
> >>>>>>>>>         -device ahci,id=ahci \
> >>>>>>>>>         -device ide-hd,drive=rootfs_drive,bus=ahci.0
> >>>>>>>>>
> >>>>>>>>> If the issue is not obvious, I'd like some pointers on how to go about
> >>>>>>>>> fixing this issue.
> >>>>>>>>>
> >>>>>>>>> ~ Sid.
> >>>>>>>>>
> >>>>>>>>
> >>>>>>>> At a guess this commit inadvertently changed something in the CPU ID.
> >>>>>>>> I'd start by using a linux guest to dump cpuid before and after the
> >>>>>>>> change.
> >>>>>>>
> >>>>>>> I've not had a chance to do that yet, however I did just end up with a
> >>>>>>> bisect of a linux guest failure bisecting to the same patch:
> >>>>>>>
> >>>>>>> [dgilbert@dgilbert-t580 qemu]$ git bisect bad
> >>>>>>> f5cc5a5c168674f84bf061cdb307c2d25fba5448 is the first bad commit
> >>>>>>> commit f5cc5a5c168674f84bf061cdb307c2d25fba5448
> >>>>>>> Author: Claudio Fontana <cfontana@suse.de>
> >>>>>>> Date:   Mon Mar 22 14:27:40 2021 +0100
> >>>>>>>
> >>>>>>>     i386: split cpu accelerators from cpu.c, using AccelCPUClass
> >>>>>>>     
> >>>>>>>     i386 is the first user of AccelCPUClass, allowing to split
> >>>>>>>     cpu.c into:
> >>>>>>>     
> >>>>>>>     cpu.c            cpuid and common x86 cpu functionality
> >>>>>>>     host-cpu.c       host x86 cpu functions and "host" cpu type
> >>>>>>>     kvm/kvm-cpu.c    KVM x86 AccelCPUClass
> >>>>>>>     hvf/hvf-cpu.c    HVF x86 AccelCPUClass
> >>>>>>>     tcg/tcg-cpu.c    TCG x86 AccelCPUClass
> >>>>
> >>>> Well this is a big commit... I'm not custom to x86 target, and am
> >>>> having hard time following the cpu host/max change.
> >>>>
> >>>> Is it working when you use '-cpu max,...' instead of '-cpu host,'?
> >>>
> >>> No; and in fact the cpuid's are almost entirely different with and
> >>> without this patch! (both with -cpu host).  It looks like with this
> >>> patch we're getting the cpuid for the TCG cpuid rather than the host:
> >>>
> >>> Prior to this patch:
> >>> :/# cat /proc/cpuinfo
> >>> processor       : 0
> >>> vendor_id       : GenuineIntel
> >>> cpu family      : 6
> >>> model           : 142
> >>> model name      : Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz
> >>> stepping        : 10
> >>> microcode       : 0xe0
> >>> cpu MHz         : 2111.998
> >>> cache size      : 16384 KB
> >>> physical id     : 0
> >>> siblings        : 1
> >>> core id         : 0
> >>> cpu cores       : 1
> >>> apicid          : 0
> >>> initial apicid  : 0
> >>> fpu             : yes
> >>> fpu_exception   : yes
> >>> cpuid level     : 22
> >>> wp              : yes
> >>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss syscall nx pdpe1gb rdtscp lm constant
> >>> _tsc arch_perfmon rep_good nopl xtopology cpuid tsc_known_freq pni pclmulqdq vmx ssse3 fma cx16 pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_tim
> >>> er aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch cpuid_fault invpcid_single pti ssbd ibrs ibpb stibp tpr_shadow vnmi flexpriority ept vpid
> >>> ept_ad fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm mpx rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 xsaves arat umip md_clear arch_ca
> >>> pabilities
> >>> vmx flags       : vnmi preemption_timer invvpid ept_x_only ept_ad ept_1gb flexpriority tsc_offset vtpr mtf vapic ept vpid unrestricted_guest shadow_vmcs pml
> >>> bugs            : cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf mds swapgs taa srbds
> >>> bogomips        : 4223.99
> >>> clflush size    : 64
> >>> cache_alignment : 64
> >>> address sizes   : 39 bits physical, 48 bits virtual
> >>> power management:
> >>>
> >>> With this patch:
> >>> processor       : 0
> >>> vendor_id       : AuthenticAMD
> >>> cpu family      : 6
> >>> model           : 6
> >>> model name      : QEMU TCG CPU version 2.5+
> >>> stepping        : 3
> >>> cpu MHz         : 2111.998
> >>> cache size      : 512 KB
> >>> physical id     : 0
> >>> siblings        : 1
> >>> core id         : 0
> >>> cpu cores       : 1
> >>> apicid          : 0
> >>> initial apicid  : 0
> >>> fpu             : yes
> >>> fpu_exception   : yes
> >>> cpuid level     : 13
> >>> wp              : yes
> >>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss syscall nx pdpe1gb rdtscp lm nopl cpu
> >>> id tsc_known_freq pni pclmulqdq vmx ssse3 fma cx16 pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_
> >>> lm abm 3dnowprefetch invpcid_single ssbd ibrs ibpb stibp vmmcall fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm mpx rdseed adx smap clflushopt
> >>>  xsaveopt xsavec xgetbv1 xsaves arat umip md_clear arch_capabilities
> >>> bugs            : fxsave_leak sysret_ss_attrs spectre_v1 spectre_v2 spec_store_bypass taa
> >>> bogomips        : 4223.99
> >>> TLB size        : 1024 4K pages
> >>> clflush size    : 64
> >>> cache_alignment : 64
> >>> address sizes   : 40 bits physical, 48 bits virtual
> >>> power management:
> >>>
> >>> cpuid.f5cc5a5c16
> >>>
> >>> CPU 0:
> >>>    0x00000000 0x00: eax=0x0000000d ebx=0x68747541 ecx=0x444d4163 edx=0x69746e65
> >>>    0x00000001 0x00: eax=0x00000663 ebx=0x00000800 ecx=0xfffab223 edx=0x0f8bfbff
> >>>    0x00000002 0x00: eax=0x00000001 ebx=0x00000000 ecx=0x0000004d edx=0x002c307d
> >>>    0x00000003 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x00000004 0x00: eax=0x00000121 ebx=0x01c0003f ecx=0x0000003f edx=0x00000001
> >>>    0x00000004 0x01: eax=0x00000122 ebx=0x01c0003f ecx=0x0000003f edx=0x00000001
> >>>    0x00000004 0x02: eax=0x00000143 ebx=0x03c0003f ecx=0x00000fff edx=0x00000001
> >>>    0x00000004 0x03: eax=0x00000163 ebx=0x03c0003f ecx=0x00003fff edx=0x00000006
> >>>    0x00000005 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000003 edx=0x00000000
> >>>    0x00000006 0x00: eax=0x00000004 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x00000007 0x00: eax=0x00000000 ebx=0x009c4fbb ecx=0x00000004 edx=0xac000400
> >>>    0x00000008 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x00000009 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x0000000a 0x00: eax=0x07300402 ebx=0x00000000 ecx=0x00000000 edx=0x00008603
> >>>    0x0000000b 0x00: eax=0x00000000 ebx=0x00000001 ecx=0x00000100 edx=0x00000000
> >>>    0x0000000b 0x01: eax=0x00000000 ebx=0x00000001 ecx=0x00000201 edx=0x00000000
> >>>    0x0000000c 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x0000000d 0x00: eax=0x0000001f ebx=0x00000440 ecx=0x00000440 edx=0x00000000
> >>>    0x0000000d 0x01: eax=0x0000000f ebx=0x000003c0 ecx=0x00000000 edx=0x00000000
> >>>    0x0000000d 0x02: eax=0x00000100 ebx=0x00000240 ecx=0x00000000 edx=0x00000000
> >>>    0x0000000d 0x03: eax=0x00000040 ebx=0x000003c0 ecx=0x00000000 edx=0x00000000
> >>>    0x0000000d 0x04: eax=0x00000040 ebx=0x00000400 ecx=0x00000000 edx=0x00000000
> >>>    0x40000000 0x00: eax=0x40000001 ebx=0x4b4d564b ecx=0x564b4d56 edx=0x0000004d
> >>>    0x40000001 0x00: eax=0x01007afb ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x80000000 0x00: eax=0x80000008 ebx=0x68747541 ecx=0x444d4163 edx=0x69746e65
> >>>    0x80000001 0x00: eax=0x00000663 ebx=0x00000000 ecx=0x00000121 edx=0x2d93fbff
> >>>    0x80000002 0x00: eax=0x554d4551 ebx=0x47435420 ecx=0x55504320 edx=0x72657620
> >>>    0x80000003 0x00: eax=0x6e6f6973 ebx=0x352e3220 ecx=0x0000002b edx=0x00000000
> >>>    0x80000004 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x80000005 0x00: eax=0x01ff01ff ebx=0x01ff01ff ecx=0x40020140 edx=0x40020140
> >>>    0x80000006 0x00: eax=0x00000000 ebx=0x42004200 ecx=0x02008140 edx=0x00808140
> >>>    0x80000007 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x80000008 0x00: eax=0x00003028 ebx=0x0100d000 ecx=0x00000000 edx=0x00000000
> >>>    0x80860000 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0xc0000000 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>
> >>>
> >>> cpuid.0ac2b19743
> >>>
> >>> CPU 0:
> >>>    0x00000000 0x00: eax=0x00000016 ebx=0x756e6547 ecx=0x6c65746e edx=0x49656e69
> >>>    0x00000001 0x00: eax=0x000806ea ebx=0x00000800 ecx=0xfffab223 edx=0x0f8bfbff
> >>>    0x00000002 0x00: eax=0x00000001 ebx=0x00000000 ecx=0x0000004d edx=0x002c307d
> >>>    0x00000003 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x00000004 0x00: eax=0x00000121 ebx=0x01c0003f ecx=0x0000003f edx=0x00000001
> >>>    0x00000004 0x01: eax=0x00000122 ebx=0x01c0003f ecx=0x0000003f edx=0x00000001
> >>>    0x00000004 0x02: eax=0x00000143 ebx=0x03c0003f ecx=0x00000fff edx=0x00000001
> >>>    0x00000004 0x03: eax=0x00000163 ebx=0x03c0003f ecx=0x00003fff edx=0x00000006
> >>>    0x00000005 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000003 edx=0x00000000
> >>>    0x00000006 0x00: eax=0x00000004 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x00000007 0x00: eax=0x00000000 ebx=0x009c4fbb ecx=0x00000004 edx=0xac000400
> >>>    0x00000008 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x00000009 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x0000000a 0x00: eax=0x07300402 ebx=0x00000000 ecx=0x00000000 edx=0x00008603
> >>>    0x0000000b 0x00: eax=0x00000000 ebx=0x00000001 ecx=0x00000100 edx=0x00000000
> >>>    0x0000000b 0x01: eax=0x00000000 ebx=0x00000001 ecx=0x00000201 edx=0x00000000
> >>>    0x0000000c 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x0000000d 0x00: eax=0x0000001f ebx=0x00000440 ecx=0x00000440 edx=0x00000000
> >>>    0x0000000d 0x01: eax=0x0000000f ebx=0x000003c0 ecx=0x00000000 edx=0x00000000
> >>>    0x0000000d 0x02: eax=0x00000100 ebx=0x00000240 ecx=0x00000000 edx=0x00000000
> >>>    0x0000000d 0x03: eax=0x00000040 ebx=0x000003c0 ecx=0x00000000 edx=0x00000000
> >>>    0x0000000d 0x04: eax=0x00000040 ebx=0x00000400 ecx=0x00000000 edx=0x00000000
> >>>    0x0000000e 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x0000000f 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x00000010 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x00000011 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x00000012 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x00000013 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x00000014 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x00000015 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x00000016 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x40000000 0x00: eax=0x40000001 ebx=0x4b4d564b ecx=0x564b4d56 edx=0x0000004d
> >>>    0x40000001 0x00: eax=0x01007afb ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x80000000 0x00: eax=0x80000008 ebx=0x756e6547 ecx=0x6c65746e edx=0x49656e69
> >>>    0x80000001 0x00: eax=0x000806ea ebx=0x00000000 ecx=0x00000121 edx=0x2c100800
> >>>    0x80000002 0x00: eax=0x65746e49 ebx=0x2952286c ecx=0x726f4320 edx=0x4d542865
> >>>    0x80000003 0x00: eax=0x37692029 ebx=0x3536382d ecx=0x43205530 edx=0x40205550
> >>>    0x80000004 0x00: eax=0x392e3120 ebx=0x7a484730 ecx=0x00000000 edx=0x00000000
> >>>    0x80000005 0x00: eax=0x01ff01ff ebx=0x01ff01ff ecx=0x40020140 edx=0x40020140
> >>>    0x80000006 0x00: eax=0x00000000 ebx=0x42004200 ecx=0x02008140 edx=0x00808140
> >>>    0x80000007 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0x80000008 0x00: eax=0x00003027 ebx=0x0100d000 ecx=0x00000000 edx=0x00000000
> >>>    0x80860000 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>    0xc0000000 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> >>>
> >>
> >> I started looking at it.
> >>
> >> Claudio
> >>
> > 
> > I wonder how I missed this, the initialization functions for max_x86_cpu_initfn and kvm_cpu_max_instance_init end up being called in the wrong order.
> > 
> 
> 
> Just to check whether this is actually the issue we are talking about, Sid et al, could you try this?
> 
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index c496bfa1c2..810c46281b 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -4252,6 +4252,7 @@ static void max_x86_cpu_initfn(Object *obj)
>      object_property_set_str(OBJECT(cpu), "model-id",
>                              "QEMU TCG CPU version " QEMU_HW_VERSION,
>                              &error_abort);
> +    accel_cpu_instance_init(CPU(cpu));
>  }
> 
>  static const TypeInfo max_x86_cpu_type_info = {
> ------------------------------------------------------------------------------------------
> 
> Does this band-aid happen to cover-up the issue?

I think it mostly does - thanks; however the address widths are still
wrong:

address sizes	: 40 bits physical, 48 bits virtual

where as my little laptop can only think in 39bits physical; so I think
that's still coming through from the TCG def.

Dave

> 
> I need to think about the proper fix though, any suggestions Paolo, Eduardo?
> 
> The pickle here is that we'd need to call the accelerator specific initialization of the x86 accel-cpu only after the x86 cpu subclass initfn,
> otherwise the accel-specific cpu initialization code has no chance to see the subclass (max) trying to set ->max_features.
> 
> C.
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

