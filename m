Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354D9243987
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 13:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgHML6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 07:58:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54723 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726564AbgHML4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 07:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597319770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EZlOhHYV75r7YTUyN5H+sCzjVVAp8wKOhPwk4M3cflE=;
        b=ZXCH/R3Ni1eLV7dh7vzaWHGjOMKRNhwACQOoiCd+i4FjZMhLKHszWpT8E7sFKDVPYEsv8C
        7lUYNG4QKGJEMw+l7tvXQjKg+8/uPz14dolDTHVM4GZGsp8oLzhibKnc6qcxqLWV1xQvyM
        zGbaLkQ9WbbMgyxovQLlZ563/Fj9GCU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-6mdBu0UtOVe8NY5wdR4Hqw-1; Thu, 13 Aug 2020 07:48:01 -0400
X-MC-Unique: 6mdBu0UtOVe8NY5wdR4Hqw-1
Received: by mail-wm1-f71.google.com with SMTP id p23so1880383wmc.2
        for <kvm@vger.kernel.org>; Thu, 13 Aug 2020 04:48:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EZlOhHYV75r7YTUyN5H+sCzjVVAp8wKOhPwk4M3cflE=;
        b=kDMyZ9uv4l29+BseuBBnskn5KsfJ8wHk5g2EGQzl8+CoC2t2naQrnRxE4JF9+veffl
         Xo2WliLPP8aLUxHNjE15h2Mc4E5056EHNYXkp7pfz18osdFaagcRZz9qM6Oh12rCSoRL
         64E2bCPU8p3Wmz3z9vdprJtsAZLggc+SIkeG573MJDY+hv3isK5VbUPw0sYGUDnSb0W7
         5Fzr0facO66pJYw7PaEFcpJKvzl5yX6/69VTL3ewY+Ch1UoHgt20LtsVZoaN6nPAoAmX
         QTPMLLzTasGs4aXCAqmVs03WRtLoIZb/YlKeHfHGeh8ZfrQZNeq6m7j2HevqN4HyMdWj
         +UeQ==
X-Gm-Message-State: AOAM5331a8U+9DHlUYlip2AFcr1M1xtpxSMLe1ViMb5nwvdSnTHmqXOV
        P0m1kXSCmcgphV+Dv3TpeaHpFIKonsNPBxaXhndX+TAPJZ5jxKhrngCV3XYbT+6bWNchYR9zQt/
        m9ybN5Mc+HPs9
X-Received: by 2002:adf:f511:: with SMTP id q17mr3637050wro.414.1597319280148;
        Thu, 13 Aug 2020 04:48:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8RW5csMCCrSiBHobEDZMj9QmiDMAx1geqH7u8cSNLCG6KlEWPnnMnrhh1csceZBt9Jv8I0Q==
X-Received: by 2002:adf:f511:: with SMTP id q17mr3637032wro.414.1597319279937;
        Thu, 13 Aug 2020 04:47:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:51ad:9349:1ff0:923e? ([2001:b07:6468:f312:51ad:9349:1ff0:923e])
        by smtp.gmail.com with ESMTPSA id b14sm10751480wrj.93.2020.08.13.04.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 04:47:59 -0700 (PDT)
Subject: Re: [RFC PATCH 6/7] core/metricfs: expose x86-specific irq
 information through metricfs
To:     Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Adams <jwadams@google.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>
References: <20200807212916.2883031-1-jwadams@google.com>
 <20200807212916.2883031-7-jwadams@google.com>
 <87mu2yluso.fsf@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2500b04e-a890-2621-2f19-be08dfe2e862@redhat.com>
Date:   Thu, 13 Aug 2020 13:47:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <87mu2yluso.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/20 12:11, Thomas Gleixner wrote:
>> Add metricfs support for displaying percpu irq counters for x86.
>> The top directory is /sys/kernel/debug/metricfs/irq_x86.
>> Then there is a subdirectory for each x86-specific irq counter.
>> For example:
>>
>>    cat /sys/kernel/debug/metricfs/irq_x86/TLB/values
> What is 'TLB'? I'm not aware of any vector which is named TLB.

There's a "TLB" entry in /proc/interrupts.

Paolo

