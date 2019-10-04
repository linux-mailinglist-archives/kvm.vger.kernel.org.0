Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE04CB972
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 13:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbfJDLrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 07:47:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbfJDLrC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 07:47:02 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 52DF9B62C
        for <kvm@vger.kernel.org>; Fri,  4 Oct 2019 11:47:01 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id s19so1512128wmj.0
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2019 04:47:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+JwHgoEwrxaFZwrDe7mi7c34P6AQjAcW/4AJU211S7o=;
        b=ryN/3Jn8DzAIPYgYuwmYJK0AYRqiqWMyG4HIeiLfJ8rPGD2laOX2hVEl8AkFqAi1wj
         dCUUnxpIOsn+a0L/PhhJ4JKyXTgicRFImelTFic8MmjNyoziIf9tNfYNwggdihE0vcE+
         //Vpzmn1xOxb3gY6Z6U496+NfaH/WT3FqDgDHW6T1eaiDurAniZugLtpLEpWGnjBCCdE
         Sz+7wLZF+N8e43L3Gjc+wdQL5pBGr584gXuFjiHmr8eDieZbFqWihJ2zWDb1jYTJX/Sd
         YuOM3LB+TV+FC4mtyOQZJXqrqBqPDRgm9OyZztxQh9GpOLdHwpcRI+XTkl8IVPT2OJKv
         htrA==
X-Gm-Message-State: APjAAAUUfa2ywxOGMls0FCmNUIpqpEeIo/ObFoSpvohQDhdfQDLWyR54
        YJ3aG5J60fRHYgHQ6hUB/4r1SoMNWECHAO++ptGnl6g31qffi+atCRmeFiQgvql59BCDf4/RBEZ
        PK3nFC8ctpDop
X-Received: by 2002:a1c:61d6:: with SMTP id v205mr9957507wmb.35.1570189619910;
        Fri, 04 Oct 2019 04:46:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyH/UQA0Hna+4tQRdNy2xgtBfIwlleCnezIJHKLxXIn6EMeOpPWe6+zaMeL8aGp+kphYLAp6g==
X-Received: by 2002:a1c:61d6:: with SMTP id v205mr9957481wmb.35.1570189619580;
        Fri, 04 Oct 2019 04:46:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e56d:fbdf:8b79:c79c? ([2001:b07:6468:f312:e56d:fbdf:8b79:c79c])
        by smtp.gmail.com with ESMTPSA id y186sm11299530wmb.41.2019.10.04.04.46.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2019 04:46:58 -0700 (PDT)
Subject: Re: DANGER WILL ROBINSON, DANGER
To:     Mircea CIRJALIU - MELIU <mcirjaliu@bitdefender.com>,
        Jerome Glisse <jglisse@redhat.com>
Cc:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        Matthew Wilcox <willy@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>
References: <DB7PR02MB3979D1143909423F8767ACE2BBB60@DB7PR02MB3979.eurprd02.prod.outlook.com>
 <20191002192714.GA5020@redhat.com>
 <ab461f02-e6cd-de0f-b6ce-0f5a95798eaa@redhat.com>
 <20191002141542.GA5669@redhat.com>
 <f26710a4-424f-730c-a676-901bae451409@redhat.com>
 <20191002170429.GA8189@redhat.com>
 <dd0ca0d3-f502-78a1-933a-7e1b5fb90baa@redhat.com>
 <20191003154233.GA4421@redhat.com>
 <d62a6720-e069-4e03-6a3a-798c020786f7@redhat.com>
 <DB7PR02MB39796440DC81A5B53E86F029BB9F0@DB7PR02MB3979.eurprd02.prod.outlook.com>
 <20191003183108.GA3557@redhat.com>
 <afe2cf69-5c2c-95af-88ce-f3814fece2e2@redhat.com>
 <DB7PR02MB39795E622880231C8F8A6478BB9E0@DB7PR02MB3979.eurprd02.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7ccbc431-0ca6-0049-fe60-ad232c628209@redhat.com>
Date:   Fri, 4 Oct 2019 13:46:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <DB7PR02MB39795E622880231C8F8A6478BB9E0@DB7PR02MB3979.eurprd02.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/10/19 11:41, Mircea CIRJALIU - MELIU wrote:
> I get it so far. I have a patch that does mirroring in a separate VMA.
> We create an extra VMA with VM_PFNMAP/VM_MIXEDMAP that mirrors the 
> source VMA in the other QEMU and is refreshed by the device MMU notifier.

So for example on the host you'd have a new ioctl on the kvm file
descriptor.  You pass a size and you get back a file descriptor for that
guest's physical memory, which is mmap-able up to the size you specified
in the ioctl.

In turn, the file descriptor would have ioctls to map/unmap ranges of
the guest memory into its mmap-able range.  Accessing an unmapped range
produces a SIGSEGV.

When asked via the QEMU monitor, QEMU will create the file descriptor
and pass it back via SCM_RIGHTS.  The management application can then
use it to hotplug memory into the destination...

> Create a new memslot based on the mirror VMA, hotplug it into the guest as
> new memory device (is this possible?) and have a guest-side driver allocate 
> pages from that area.

... using the existing ivshmem device, whose BAR can be accessed and
mmap-ed from the guest via sysfs.  In other words, the hotplugging will
use the file descriptor returned by QEMU when creating the ivshmem device.

We then need an additional mechanism to invoke the map/unmap ioctls from
the guest.  Without writing a guest-side driver it is possible to:

- pass a socket into the "create guest physical memory view" ioctl
above.  KVM will then associate that KVMI socket with the newly created
file descriptor.

- use KVMI messages to that socket to map/unmap sections of memory

> Redirect (some) GFN->HVA translations into the new VMA based on a table 
> of addresses required by the introspector process.

That would be tricky because there are multiple paths (gfn_to_page,
gfn_to_pfn, etc.).

There is some complication in this because the new device has to be
plumbed at multiple levels (KVM, QEMU, libvirt).  But it seems like a
very easily separated piece of code (except for the KVMI socket part,
which can be added later), so I suggest that you contribute the KVM
parts first.

Paolo
