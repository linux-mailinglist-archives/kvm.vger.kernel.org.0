Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458A5463BBC
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 17:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243920AbhK3Qat (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 11:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244030AbhK3Qa3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 11:30:29 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EF8C061574;
        Tue, 30 Nov 2021 08:27:09 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id z5so24012550edd.3;
        Tue, 30 Nov 2021 08:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gseVlYCCu9tLJSTOHUcBNWkzNUHx5NAVjG9KtVrF/70=;
        b=evCZzS0VaSrgQVmqh2o+0NLlibjGGYOSqiDMLtkbyRCf6zAMwzRtuRW+18pgaYtclP
         f7rI8tFdZRP69pDOxdjr9q0KvklCtNp+ubOoHTMylPKYS3KniZ/krHIcdB4LaFnFJGFK
         mRd3Co3z2xxUv/utFUVgAFunHzOYhGFWLbuzQoM7MN9EqW5DWMklB3Ss1cPSfDWLgCVl
         RI44aNzZLrmci8U06uAQSnbY3VXT+KAkhLU5iTS5uqU3Dv9avlSKZ48neamRtTLngWd8
         jXRl+KsvWhUrI73HT0cskYR10YbL6omMO+gzWNCsrKwkWRYy3PMMkXpEurvjACOlTN3r
         pDxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gseVlYCCu9tLJSTOHUcBNWkzNUHx5NAVjG9KtVrF/70=;
        b=Q8/whHjnJD8qE5jzS6wjtanRGKqLqVaeiUyJHyPA1Vw1IbVI7JvTxL+OjcJgaMPgeN
         qMPvegfOqE3VjQiqf6AqldtCgXo2cGKnXSa7+tUMsvBWfnj8K6Q0FDNatgyDUcA2morf
         Ucj0qsodE6vaZB47WGHcQ+lNS8M3hHY4BroIPq5ATZVeIpOTZ5jCs/CzilcKSH0RjuYH
         g50QIlrfxLfp+smRzp0Oveo393YctJNuAQGAmH2dKWpiiqzDNZRGlVTN3cWP7jYeTRJO
         7hT2GV3RF3q6sSEa5ft/L3SHcksWDc1Alv/fka5ATwYaYzGvYiap795WPbT8PTvag3e2
         i+CQ==
X-Gm-Message-State: AOAM532FsbCMiClDa+EfGHrEsMd4Ytjx3WrLLkl7VdTugVrOEeTy6Uxx
        4Rj3I0X9z05I9HqHC/ca0AcR+6GK2DM=
X-Google-Smtp-Source: ABdhPJzVyOCSGpRPVxDg1bgQ9dpiLa+XdW4dLaMlSMGX75wPCKXmOPQV7MApgugUEEDTh5PuUbPWmg==
X-Received: by 2002:a17:907:2d21:: with SMTP id gs33mr72020ejc.549.1638289628406;
        Tue, 30 Nov 2021 08:27:08 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id g1sm9163514eje.105.2021.11.30.08.27.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 08:27:07 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <527c1261-8f21-bcbe-e28e-652a1e37ab14@redhat.com>
Date:   Tue, 30 Nov 2021 17:27:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Q. about KVM and CPU hotplug
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <BL1PR11MB54295ADE4D7A81523EA50B2D8C679@BL1PR11MB5429.namprd11.prod.outlook.com>
 <3d3296f0-9245-40f9-1b5a-efffdb082de9@redhat.com> <8735ndd9hd.ffs@tglx>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <8735ndd9hd.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/21 15:05, Thomas Gleixner wrote:
> Why is this hotplug callback in the CPU starting section to begin with?

Just because the old notifier implementation used CPU_STARTING - in fact 
the commit messages say that CPU_STARTING was added partly *for* KVM 
(commit e545a6140b69, "kernel/cpu.c: create a CPU_STARTING cpu_chain 
notifier", 2008-09-08).

> If you stick it into the online section which runs on the hotplugged CPU
> in thread context:
> 
> 	CPUHP_AP_ONLINE_IDLE,
> 
> -->   	CPUHP_AP_KVM_STARTING,
> 
> 	CPUHP_AP_SCHED_WAIT_EMPTY,
> 
> then it is allowed to fail and it still works in the right way.

Yes, moving it to the online section should be fine; it wouldn't solve 
the TDX problem however.  Failure would rollback the hotplug and forbid 
hotplug altogether when TDX is loaded, which is not acceptable.

Paolo

> When onlining a CPU then there cannot be any vCPU task run on the
> CPU at that point.
> 
> When offlining a CPU then it's guaranteed that all user tasks and
> non-pinned kernel tasks have left the CPU, i.e. there cannot be a vCPU
> task around either.

