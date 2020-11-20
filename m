Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F266C2BB839
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 22:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgKTVSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 16:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbgKTVS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Nov 2020 16:18:29 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4281C0613CF;
        Fri, 20 Nov 2020 13:18:27 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id 1so11326100wme.3;
        Fri, 20 Nov 2020 13:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gyNq+CXGsH0qwkvX6VyZpOW+xtz/kz2LyOf6/jkzaO0=;
        b=ehMwCniHhcWcyq6QySNwedlwnXYGa9deIPoyuONBTcSfF1FK8u/PL9bJ6Ivzmw97L7
         es8dC7wve9Gj4FH7Bku6rHJaJwFj5pfaK8oL0YZbUt6yW7TkLxlnskqzr/0nigNQejej
         31uUxyrDVHao3tUMNruC8EXD4h5sZxOA1bmnFamo84NFMiTfTUBS7DKt+63TqiE2ZlHH
         9uVZxffrCFe7ucCXTVHqop+bHNzRtmUXaiS3GhOqM4t5KJYBrFmvQEvr+lzv8Zj1m7H7
         uy6W36pavFI1h0qtlmGfHjXEfePkfw0IzcewzRmEOfY/nvKRhB0DMfOsN9+Pg2tmBMGt
         edVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gyNq+CXGsH0qwkvX6VyZpOW+xtz/kz2LyOf6/jkzaO0=;
        b=g/cgkig2ofI8NbirkuiHJTiT54vnE64V+2R6lIqEhfPcCrcJ6Nnjz3LMTFLrVQyF8V
         Z6HlW/z++GaZk6O0z3PTuWpZRBFJ52Zu1c6MfUdEtx7HrCYKgj1m0S3xDyfegOSUWeS5
         5aszQIC0yloUgkGgLa07dIBpG1Niymc1hqkGM6wn4s5hCXimyXcZOCAMg8DCy/j/Y3De
         AaF20UyBll3kaMkSmgeKMd+NHn7sC6DsTne4YkMmYhOGQB7TgvdQinZNi8K1hSP3icVX
         HzFGLeRUJFwsZqUa0ODXuDI6HbcX+8iAUv5fIzh4oy1SVaB9GGBB+XOSUQsuvy3wKjYk
         2WYQ==
X-Gm-Message-State: AOAM5336DboXfMm1eN/Rc3o2f3rBDJM2fQVmLWlFaptRL6ocngSl0PAf
        f0SiyQInMsozvpaGHKgZM6Y=
X-Google-Smtp-Source: ABdhPJy54UaB/Is5YjbhHOh/4TR/x7nVnHPWkMhJBXmzcWxv+thgpOMjrr4M7YOcmS0x8HNw60Afyw==
X-Received: by 2002:a05:600c:2158:: with SMTP id v24mr12266035wml.107.1605907106503;
        Fri, 20 Nov 2020 13:18:26 -0800 (PST)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id o4sm5516370wmh.33.2020.11.20.13.18.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 13:18:25 -0800 (PST)
Subject: Re: [PATCH v2] drivers/virt: vmgenid: add vm generation id driver
To:     Alexander Graf <graf@amazon.de>
Cc:     Mike Rapoport <rppt@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Catangiu, Adrian Costin" <acatan@amazon.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jann Horn <jannh@google.com>, Willy Tarreau <w@1wt.eu>,
        "MacCarthaigh, Colm" <colmmacc@amazon.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "bonzini@gnu.org" <bonzini@gnu.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Weiss, Radu" <raduweis@amazon.com>,
        "oridgar@gmail.com" <oridgar@gmail.com>,
        "ghammer@redhat.com" <ghammer@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Qemu Developers <qemu-devel@nongnu.org>,
        KVM list <kvm@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Linux API <linux-api@vger.kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        linux-s390 <linux-s390@vger.kernel.org>,
        "areber@redhat.com" <areber@redhat.com>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Andrey Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        "gil@azul.com" <gil@azul.com>,
        "asmehra@redhat.com" <asmehra@redhat.com>,
        "dgunigun@redhat.com" <dgunigun@redhat.com>,
        "vijaysun@ca.ibm.com" <vijaysun@ca.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Adrian Reber <areber@redhat.com>
References: <3E05451B-A9CD-4719-99D0-72750A304044@amazon.com>
 <300d4404-3efe-880e-ef30-692eabbff5f7@de.ibm.com>
 <da1a1fa7-a1de-d0e6-755b-dd587687765e@amazon.de>
 <20201119173800.GD8537@kernel.org>
 <1cdb6fac-0d50-3399-74a6-24c119ebbaa5@amazon.de>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
Message-ID: <106f56ca-49bc-7cad-480f-4b26656e90ce@gmail.com>
Date:   Fri, 20 Nov 2020 21:18:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1cdb6fac-0d50-3399-74a6-24c119ebbaa5@amazon.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

+Cc Eric, Adrian

On 11/19/20 6:36 PM, Alexander Graf wrote:
> On 19.11.20 18:38, Mike Rapoport wrote:
>> On Thu, Nov 19, 2020 at 01:51:18PM +0100, Alexander Graf wrote:
>>> On 19.11.20 13:02, Christian Borntraeger wrote:
>>>> On 16.11.20 16:34, Catangiu, Adrian Costin wrote:
>>>>> - Background
>>>>>
>>>>> The VM Generation ID is a feature defined by Microsoft (paper:
>>>>> http://go.microsoft.com/fwlink/?LinkId=260709) and supported by
>>>>> multiple hypervisor vendors.
>>>>>
>>>>> The feature is required in virtualized environments by apps that work
>>>>> with local copies/caches of world-unique data such as random values,
>>>>> uuids, monotonically increasing counters, etc.
>>>>> Such apps can be negatively affected by VM snapshotting when the VM
>>>>> is either cloned or returned to an earlier point in time.
>>>>>
>>>>> The VM Generation ID is a simple concept meant to alleviate the issue
>>>>> by providing a unique ID that changes each time the VM is restored
>>>>> from a snapshot. The hw provided UUID value can be used to
>>>>> differentiate between VMs or different generations of the same VM.
>>>>>
>>>>> - Problem
>>>>>
>>>>> The VM Generation ID is exposed through an ACPI device by multiple
>>>>> hypervisor vendors but neither the vendors or upstream Linux have no
>>>>> default driver for it leaving users to fend for themselves.
[..]

>>> The only piece where I'm unsure is how this will interact with CRIU.
>>
>> To C/R applications that use /dev/vmgenid CRIU need to be aware of it.
>> Checkpointing and restoring withing the same "VM generation" shouldn't be
>> a problem, but IMHO, making restore work after genid bump could be
>> challenging.
>>
>> Alex, what scenario involving CRIU did you have in mind?
> 
> You can in theory run into the same situation with containers that this
> patch is solving for virtual machines. You could for example do a
> snapshot of a prewarmed Java runtime with CRIU to get full JIT speeds
> starting from the first request.
> 
> That however means you run into the problem of predictable randomness
> again.
> 
>>
>>> Can containers emulate ioctls and device nodes?
>>
>> Containers do not emulate ioctls but they can have /dev/vmgenid inside
>> the container, so applications can use it the same way as outside the
>> container.
> 
> Hm. I suppose we could add a CAP_ADMIN ioctl interface to /dev/vmgenid
> (when container people get to the point of needing it) that sets the
> generation to "at least X". That way on restore, you could just call
> that with "generation at snapshot"+1.
> 
> That also means we need to have this interface available without virtual
> machines then though, right?

Sounds like a good idea.
I guess, genvmid can be global on host, rather than per-userns or
per-process for simplicity. Later if somebody will have a bottleneck on
restore when every process on the machine wakes up from read() it could
be virtualized, but doing it now sounds too early.

ioctl() probably should go under
checkpoint_restore_ns_capable(current_user_ns()), rather than
CAP_SYS_ADMIN (I believe it should be safe from DOS as only CRIU should
run with this capability, but worth to document this).

Thanks,
         Dmitry
