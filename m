Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECD178B81E
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 14:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbfHMMJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 08:09:55 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53034 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbfHMMJz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 08:09:55 -0400
Received: by mail-wm1-f68.google.com with SMTP id o4so1143053wmh.2
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 05:09:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gDECUkDx4MmZTU2TRfkEx9c0GNMHS7ThvPK76SizlZs=;
        b=sXgHahlV/EZQIoqcH4qjNwV+3KNwlhjmlefugAGZ9Wm6J4WlrgnhUdwPPQsDUnqFp2
         jFZHPlJpe4RJxtAAvd90p2QMIaaUnDVAWtVqnyhxGT7rv2rI9GA+AnY2he2euzT7HoMK
         xQHA62eaxPFwY5T7IIkHtqvCfO2SS23qul9yTDX02ttM6vmJP7C5TIed70aPIc/vRRdJ
         Yr7Fk6OqByR6jpUuF3vFLrnLkr/IQnYA0nd7vprWSOGifEl1p2i0YzsycVhSS1WVstDA
         5d2Cnz5W9O8YEZTZDCz06jZNiW6v5m0T2VIoaxAwzdMG2lyaSJBomCgLmLwxxue5/Gj1
         aomQ==
X-Gm-Message-State: APjAAAVyYQZ2fqqE+v3CLQGpeFHh28OzJyegOy99US1qjnpjp2P7pQLU
        gkUOew7VvSehp8a736scu5DZqQ==
X-Google-Smtp-Source: APXvYqzB612TQbc7of6OKwGZTQDBF2YBSrRWlPNUTz0Jo1N+YWu/anTDovRV4uYtYUMMFIBRr0LWzQ==
X-Received: by 2002:a1c:c00e:: with SMTP id q14mr2852175wmf.142.1565698193218;
        Tue, 13 Aug 2019 05:09:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5193:b12b:f4df:deb6? ([2001:b07:6468:f312:5193:b12b:f4df:deb6])
        by smtp.gmail.com with ESMTPSA id g26sm1123736wmh.32.2019.08.13.05.09.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 05:09:52 -0700 (PDT)
Subject: Re: [RFC PATCH v6 01/92] kvm: introduce KVMI (VM introspection
 subsystem)
To:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>,
        =?UTF-8?Q?Mircea_C=c3=aerjaliu?= <mcirjaliu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-2-alazar@bitdefender.com>
 <20190812202030.GB1437@linux.intel.com>
 <5d52a5ae.1c69fb81.5c260.1573SMTPIN_ADDED_BROKEN@mx.google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5fa6bd89-9d02-22cd-24a8-479abaa4f788@redhat.com>
Date:   Tue, 13 Aug 2019 14:09:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5d52a5ae.1c69fb81.5c260.1573SMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/19 13:57, Adalbert Lazăr wrote:
>> The refcounting approach seems a bit backwards, and AFAICT is driven by
>> implementing unhook via a message, which also seems backwards.  I assume
>> hook and unhook are relatively rare events and not performance critical,
>> so make those the restricted/slow flows, e.g. force userspace to quiesce
>> the VM by making unhook() mutually exclusive with every vcpu ioctl() and
>> maybe anything that takes kvm->lock. 
>>
>> Then kvmi_ioctl_unhook() can use thread_stop() and kvmi_recv() just needs
>> to check kthread_should_stop().
>>
>> That way kvmi doesn't need to be refcounted since it's guaranteed to be
>> alive if the pointer is non-null.  Eliminating the refcounting will clean
>> up a lot of the code by eliminating calls to kvmi_{get,put}(), e.g.
>> wrappers like kvmi_breakpoint_event() just check vcpu->kvmi, or maybe
>> even get dropped altogether.
> 
> The unhook event has been added to cover the following case: while the
> introspection tool runs in another VM, both VMs, the virtual appliance
> and the introspected VM, could be paused by the user. We needed a way
> to signal this to the introspection tool and give it time to unhook
> (the introspected VM has to run and execute the introspection commands
> during this phase). The receiving threads quits when the socket is closed
> (by QEMU or by the introspection tool).
> 
> It's a bit unclear how, but we'll try to get ride of the refcount object,
> which will remove a lot of code, indeed.

You can keep it for now.  It may become clearer how to fix it after the
event loop is cleaned up.

>>
>>> +void kvmi_create_vm(struct kvm *kvm)
>>> +{
>>> +	init_completion(&kvm->kvmi_completed);
>>> +	complete(&kvm->kvmi_completed);
>> Pretty sure you don't want to be calling complete() here.
> The intention was to stop the hooking ioctl until the VM is
> created. A better name for 'kvmi_completed' would have been
> 'ready_to_be_introspected', as kvmi_hook() will wait for it.
> 
> We'll see how we can get ride of the completion object.

The ioctls are not accessible while kvm_create_vm runs (only after
kvm_dev_ioctl_create_vm calls fd_install).  Even if it were, however,
you should have placed init_completion much earlier, otherwise
wait_for_completion would access uninitialized memory.

Paolo
