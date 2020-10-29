Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FBB29F2E8
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 18:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgJ2RUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 13:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgJ2RUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 13:20:51 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93A9C0613CF;
        Thu, 29 Oct 2020 10:20:51 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id z6so2603644qkz.4;
        Thu, 29 Oct 2020 10:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bgET2vKXyCysvHtuVXHC8x2bsoHr9I9pVPGZuJ2I2ok=;
        b=kCwHtNb0aDqVERdhKoxZMhicLRZ2QR3PolGpflI38e1AZzBFPmngVCvkULn12HaIpd
         xNZsE0KTf8SFsTeciNeDfLB2b8eo7aWwi+oWAp/jGZANfyHEmSTDAiXW3x245FjthbK+
         cNyymvnYwa4RgDaOm832TsIoNGN5VteNRutW9xIM3LOXzwfrz3rFIbB2qhaahGSK3KWZ
         rcjSGv+Lrv3xXtp7IhxItj2ThU4R1TxkB1brB4zm0qayhFjR52RmdpupiWUa8/437Az6
         Z5hmy1fEbRMjrq5fMw2J1qv+hvc2qIZX/q2dYGHrv1hoTM8Kgy/UG1ajYtjFlzWenf9F
         /BdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=bgET2vKXyCysvHtuVXHC8x2bsoHr9I9pVPGZuJ2I2ok=;
        b=PuClkGl0pB78zr0m2LspFo1DPMrsifWAoPRU58VwsHOmXNCdg6ZXIrGwVyBsIK2Sbf
         jNJvc3xbrUnvHTd3HLJARpWjlK0N9deC/a8H6oipyMPtlLzetTMk3BIsPckJSh3GY/Wo
         49+oY0x4amY489fIhsM5RAPnDPF2UjwJagF0igwBbh+qZCb4Ez8k3+843+6fX5SkDjXt
         AMeRsiNR/qxTlLaj3eDrprQmfZySfSF+Z8SoacFWq6BhzcrQFNi1l8uR3KRN01uPQP8i
         jYYMm4jcV/LWLTy5oTd78YETXZbkvQV4uoWYHObwdqVGUDGuvVCnrgWAYlr9GayJ2N7M
         wuew==
X-Gm-Message-State: AOAM533Kz/RR9Ng5oN4cJKqraFrzB+p9Gnem/CmMUaIf/ksolQhD+LMj
        pQNUxed42kiccxNpM9KAF64=
X-Google-Smtp-Source: ABdhPJxpj2lHqddfkMCdJsg7kjoxJdmwW/wIVKjCyqCU3W25AK0ciYoXUlV7HQMe/OgzwbBLEfxGlQ==
X-Received: by 2002:a05:620a:130a:: with SMTP id o10mr4612780qkj.63.1603992050890;
        Thu, 29 Oct 2020 10:20:50 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id m33sm1432097qtb.65.2020.10.29.10.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 10:20:50 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Thu, 29 Oct 2020 13:20:48 -0400
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        David Laight <David.Laight@ACULAB.COM>,
        'Arnd Bergmann' <arnd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH] [v2] x86: apic: avoid -Wshadow warning in header
Message-ID: <20201029172048.GA2571425@rani.riverdale.lan>
References: <20201028212417.3715575-1-arnd@kernel.org>
 <38b11ed3fec64ebd82d6a92834a4bebe@AcuMS.aculab.com>
 <20201029165611.GA2557691@rani.riverdale.lan>
 <93180c2d-268c-3c33-7c54-4221dfe0d7ad@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <93180c2d-268c-3c33-7c54-4221dfe0d7ad@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 29, 2020 at 05:59:54PM +0100, Paolo Bonzini wrote:
> On 29/10/20 17:56, Arvind Sankar wrote:
> >> For those two just add:
> >> 	struct apic *apic = x86_system_apic;
> >> before all the assignments.
> >> Less churn and much better code.
> >>
> > Why would it be better code?
> > 
> 
> I think he means the compiler produces better code, because it won't
> read the global variable repeatedly.  Not sure if that's true,(*) but I
> think I do prefer that version if Arnd wants to do that tweak.
> 
> Paolo
> 
> (*) if it is, it might also be due to Linux using -fno-strict-aliasing
> 

Nope, it doesn't read it multiple times. I guess it still assumes that
apic isn't in the middle of what it points to: it would reload the
address if the first element of *apic was modified, but doesn't for
other elements. Interesting.
