Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885C820D776
	for <lists+kvm@lfdr.de>; Mon, 29 Jun 2020 22:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732836AbgF2TaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 15:30:18 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34979 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732801AbgF2TaP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Jun 2020 15:30:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593459006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h8YsmMSc+uzBm3Tq2wPliCvFYeKmpScCtqag1mgAOwg=;
        b=bvr4JcpPlYQtxmf2w9p804yueqCmImcWAf2GCQVWea977pNyT5MDKvDJWW8hCYiI2gJ7Dw
        rKOgYsp97RI7OX7zqufJUjCP7jk5KoE5+J22JvzD2pUpDaNj52EIPcWvJEAXTDvg7B+1pE
        GNfJh92yIHnIlF9Y2w06Nf1KJ4ycUVM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-1Ueb0ZVGNJqSdJbths4QzQ-1; Mon, 29 Jun 2020 11:25:32 -0400
X-MC-Unique: 1Ueb0ZVGNJqSdJbths4QzQ-1
Received: by mail-wm1-f69.google.com with SMTP id o13so18537830wmh.9
        for <kvm@vger.kernel.org>; Mon, 29 Jun 2020 08:25:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h8YsmMSc+uzBm3Tq2wPliCvFYeKmpScCtqag1mgAOwg=;
        b=rvnHe25CIZ+E++17U71gpXX+vphip63KwBAT6bA+TjbSkvjrY8FZVycYeS4DiznVl7
         q+a+6FUrr0Ahaw74sY3zE3bTFx/l7uN/pH23YkOx++1YNBR6MThDHqOa+SIPtH8qi8BU
         Y1E4QNGzWFE6sVRUpAhXOptCSQ9NYxCtbqtRggG2ApxXqVhZec/iU3ngV1bTl0E28PG9
         A7t+o6j4udlkMVenFc7ZLjfUM00CCM+7nlwkQ7A8xaV5GEZXRIgNy7GrDkFg0tGKLlZU
         uY4DROqyOt1vugGW5miwlNQVO5IAncil68CldSh3r9gmZ5Yu8mADhVBNnw1a8Ei2Xb/I
         EYKA==
X-Gm-Message-State: AOAM5308s20mUn/b+LPqkFzec0z72fVFe5EcYwDrb4dZ7/u4siae582v
        1dKGWGfA4JNxQLaeJik6OPgKvHvDaUI0PRMk4bwkRbfj77z8kHOtlREl0Jn7/Wzdrh1rvkHrD1D
        vcqwjSQnHdudQ
X-Received: by 2002:a7b:c3d0:: with SMTP id t16mr18595464wmj.117.1593444330177;
        Mon, 29 Jun 2020 08:25:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5S/sa8P6liiPedMfDgcEMB4JDiBtcXYBUqvs6MOq7NCpJOsBsi1tIcIuRMKcNnUvLGRGqdw==
X-Received: by 2002:a7b:c3d0:: with SMTP id t16mr18595450wmj.117.1593444329937;
        Mon, 29 Jun 2020 08:25:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b0e5:c632:a580:8b9a? ([2001:b07:6468:f312:b0e5:c632:a580:8b9a])
        by smtp.gmail.com with ESMTPSA id q7sm91034wrs.27.2020.06.29.08.25.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 08:25:29 -0700 (PDT)
Subject: Re: KASAN: out-of-bounds Read in kvm_arch_hardware_setup
To:     syzbot <syzbot+e0240f9c36530bda7130@syzkaller.appspotmail.com>,
        bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, sean.j.christopherson@intel.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
References: <000000000000a0784a05a916495e@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <04786ba2-4934-c544-63d1-4d5d36dc5822@redhat.com>
Date:   Mon, 29 Jun 2020 17:25:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <000000000000a0784a05a916495e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The reproducer has nothing to do with KVM:

	# https://syzkaller.appspot.com/bug?id=c356395d480ca736b00443ad89cd76fd7d209013
	# See https://goo.gl/kgGztJ for information about syzkaller reproducers.
	#{"repeat":true,"procs":1,"sandbox":"","fault_call":-1,"close_fds":false,"segv":true}
	r0 = openat$fb0(0xffffffffffffff9c, &(0x7f0000000180)='/dev/fb0\x00', 0x0, 0x0)
	ioctl$FBIOPUT_VSCREENINFO(r0, 0x4601, &(0x7f0000000000)={0x0, 0x80, 0xc80, 0x0, 0x2, 0x1, 0x4, 0x0, {0x0, 0x0, 0x1}, {0x0, 0x0, 0xfffffffc}, {}, {}, 0x0, 0x40})

but the stack trace does.  On the other hand, the address seems okay:

	kvm_cpu_caps+0x24/0x50

and there are tons of other kvm_cpu_cap_get calls that aren't causing
KASAN to complain.  The variable is initialized from

	kvm_arch_hardware_setup
	  hardware_setup (in arch/x86/kvm/vmx/vmx.c)
	    vmx_set_cpu_caps
	      kvm_set_cpu_caps

with a simple memcpy that writes the entire array.  Does anyone understand
what is going on here?

Paolo

On 27/06/20 22:01, syzbot wrote:
> BUG: KASAN: out-of-bounds in kvm_cpu_cap_get arch/x86/kvm/cpuid.h:292 [inline]
> BUG: KASAN: out-of-bounds in kvm_cpu_cap_has arch/x86/kvm/cpuid.h:297 [inline]
> BUG: KASAN: out-of-bounds in kvm_init_msr_list arch/x86/kvm/x86.c:5362 [inline]
> BUG: KASAN: out-of-bounds in kvm_arch_hardware_setup+0xb05/0xf40 arch/x86/kvm/x86.c:9802
> Read of size 4 at addr ffffffff896c3134 by task syz-executor614/6786
> 
> CPU: 1 PID: 6786 Comm: syz-executor614 Not tainted 5.7.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1e9/0x30e lib/dump_stack.c:118
>  print_address_description+0x66/0x5a0 mm/kasan/report.c:383
>  __kasan_report mm/kasan/report.c:513 [inline]
>  kasan_report+0x132/0x1d0 mm/kasan/report.c:530
>  kvm_cpu_cap_get arch/x86/kvm/cpuid.h:292 [inline]
>  kvm_cpu_cap_has arch/x86/kvm/cpuid.h:297 [inline]
>  kvm_init_msr_list arch/x86/kvm/x86.c:5362 [inline]
>  kvm_arch_hardware_setup+0xb05/0xf40 arch/x86/kvm/x86.c:9802
>  </IRQ>
> 
> The buggy address belongs to the variable:
>  kvm_cpu_caps+0x24/0x50
> 
> Memory state around the buggy address:
>  ffffffff896c3000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffffffff896c3080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> ffffffff896c3100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>                                         ^
>  ffffffff896c3180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffffffff896c3200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ==================================================================

