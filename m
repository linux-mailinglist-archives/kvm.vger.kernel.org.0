Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF60188958
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 16:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgCQPoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 11:44:03 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:51991 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726016AbgCQPoC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Mar 2020 11:44:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584459841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zz0ms3Eihc2fcVoVwqE4GEUMo82JTr0zPIOflOsJZfs=;
        b=W+hQnZ2yY/x/AvNi0DsThmsYf10MjmB6A+I7pNX3rGfjPeR+PvSBz/Oo3okccPQ/is4zIV
        M9Hobewb6IxWniNGMWnUC1PRPlAf/XQ5F7+oq0zUnomqAkrYrzyCZ00hRTQ+2uXp/FdsOg
        i0p4+xqeeUlI2+qmg3v3xFQdiCkDhf8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-PKnv-ZkwMpCR9BC_ZgGJwA-1; Tue, 17 Mar 2020 11:43:59 -0400
X-MC-Unique: PKnv-ZkwMpCR9BC_ZgGJwA-1
Received: by mail-wm1-f71.google.com with SMTP id z26so91504wmk.1
        for <kvm@vger.kernel.org>; Tue, 17 Mar 2020 08:43:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zz0ms3Eihc2fcVoVwqE4GEUMo82JTr0zPIOflOsJZfs=;
        b=pbANuxh60CqRnABzLwa6pcNE1xwYEkgaxhzBzf+0H6ppTSR7OEWf/I4A04QPNwtLjJ
         OvLHYQ51GLNnDFtymShD1MRcjx367LdESsYSEekCmo9pC4hlG1LcyoP3t1FqwnrbD1r4
         7HfT/JFE5RV/DIJppfjk4wW2u+J7QHENE647GZX8E7urWSPNRPto0sVMR0re+810GtaV
         6GlsZeB/gkE1gWBzvZjMLKgc7uS5+A02PKCMqBuW7AvDfrbSRFQdVdz5B8dSYougWZMu
         ou9MH/o1Z1y5NEl1N6Nb/odHuK3g1M0OiVtZR/BY0cYl2PGPSSbi/MR9wSPqZK/+mMMk
         XDhg==
X-Gm-Message-State: ANhLgQ3L/XaSI2Fps8mvak6KWLeH9gcq3/P3R98WJw5KIXwyU5imHU+1
        KPFp0lFvSxR5mataguwc6j5f07ZarG8NVWu+ekWIa1X+C/lALi8uXZ8GpKriATjdlXD3WTT8t+f
        Thw+g6InHapJr
X-Received: by 2002:a1c:ac46:: with SMTP id v67mr5744106wme.153.1584459838407;
        Tue, 17 Mar 2020 08:43:58 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvW7kmPWyYHsXhQCU7ZYoGvwFv8GK6bKzxR21Oi1PTvZ3V5/QtUeuO+bebdYdTpVEwEEaaBqw==
X-Received: by 2002:a1c:ac46:: with SMTP id v67mr5744089wme.153.1584459838065;
        Tue, 17 Mar 2020 08:43:58 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.227])
        by smtp.gmail.com with ESMTPSA id g14sm4363471wme.32.2020.03.17.08.43.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 08:43:57 -0700 (PDT)
Subject: Re: [Patch v1] x86: Fix the logical destination mode test
To:     Nitesh Narayan Lal <nitesh@redhat.com>, kvm@vger.kernel.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, thuth@redhat.com,
        nilal@redhat.com
References: <1583795750-33197-1-git-send-email-nitesh@redhat.com>
 <20200310140323.GA7132@fuller.cnet>
 <4993e419-5eef-46ba-5dd0-e35c7103190b@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <83de50d8-2dbc-6378-48f0-94d43a43d098@redhat.com>
Date:   Tue, 17 Mar 2020 16:43:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <4993e419-5eef-46ba-5dd0-e35c7103190b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/03/20 23:27, Nitesh Narayan Lal wrote:
> 
> On 3/10/20 10:03 AM, Marcelo Tosatti wrote:
>> On Mon, Mar 09, 2020 at 07:15:50PM -0400, Nitesh Narayan Lal wrote:
>>> There are following issues with the ioapic logical destination mode test:
>>>
>>> - A race condition that is triggered when the interrupt handler
>>>   ioapic_isr_86() is called at the same time by multiple vCPUs. Due to this
>>>   the g_isr_86 is not correctly incremented. To prevent this a spinlock is
>>>   added around ‘g_isr_86++’.
>>>
>>> - On older QEMU versions initial x2APIC ID is not set, that is why
>>>   the local APIC IDs of each vCPUs are not configured. Hence the logical
>>>   destination mode test fails/hangs. Adding ‘+x2apic’ to the qemu -cpu params
>>>   ensures that the local APICs are configured every time, irrespective of the
>>>   QEMU version.
>>>
>>> - With ‘-machine kernel_irqchip=split’ included in the ioapic test
>>>   test_ioapic_self_reconfigure() always fails and somehow leads to a state where
>>>   after submitting IOAPIC fixed delivery - logical destination mode request we
>>>   never receive an interrupt back. For now, the physical and logical destination
>>>   mode tests are moved above test_ioapic_self_reconfigure().
>>>
>>> Fixes: b2a1ee7e ("kvm-unit-test: x86: ioapic: Test physical and logical destination mode")
>>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>> Looks good to me.
> 
> Hi,
> 
> I just wanted to follow up and see if there are any more suggestions for me to
> improve this patch before it can be merged.

Thanks Nitesh, I have queued it now.

Paolo

