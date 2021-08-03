Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253093DEEE9
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 15:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbhHCNOQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 09:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236218AbhHCNOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 09:14:15 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8BBC061757
        for <kvm@vger.kernel.org>; Tue,  3 Aug 2021 06:14:03 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d1so23705729pll.1
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 06:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cD44nlfYqtKH4XtlGBmcc3+xGCi39N7kSG0uWYgAZyI=;
        b=KlyBn5EQFqcP6S++rF+krNoapVKRi0cFbUCjNnNLnv99HYe2sr5W/LXZTuDD/VbMN1
         L6sTknsyFtEvEYrpuMrq2fPAbVNIhS4Dbs7UMXsUmU4l21oiulqjVBhULldXbbKAq4S9
         i/yMsiRNqBea+akFov+0ycZYUjzcXXjIUGONK7fUa5SFzVC7PCAhn3VEEm7DDJb9mGms
         dhnZslm3n/pcRYkj5ZEgL/o0nQGwUpI3kJlt/cQ/JfAMAQ+G71FhqoY0RMevXII3HEMQ
         H38S4jpPFi2CdF+UhDp0x+v6r/pv0zv4u2VMTn1HQYKjQIFNpmdwe1QEXm59e74GVQ4n
         9x0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cD44nlfYqtKH4XtlGBmcc3+xGCi39N7kSG0uWYgAZyI=;
        b=UbZYDcneM51wSi2FX/8syPJ6ncfaYX6FGgL22MRQxOXNaQGKyvbsvcw/suKeCzND+a
         et5mnWWBf/H7TfK9xH1tkWwC32WVEpr39cYZWDoTEbPIz9FzMepVaHkX6AhDbOGcThP9
         IxZ5lZKSPoE5pucd6E+YEHih3JjS2L976pu9mhSUXrJuTEqR/XVost5FT0EOsPdGL6d1
         hpSmbN9h+xWrRcIYVw+BHgdQjiGsIh5/5GC6wbtX1kc/lNEejKRfae67SDGlHijBMXIZ
         9QMdrRFChac455Xqqjvoao0x1CPax6r/dDNkWVrQ8mi7RU2PKARsPEb11NmD6KPsrp/X
         1w9A==
X-Gm-Message-State: AOAM531CGmKbmXJl/8DUft5KMNTckB241w2wXVZflLuqjPIjdOBthwqC
        c2pm0VEwhdA10wFeuBLwbxBECg==
X-Google-Smtp-Source: ABdhPJxArDiDqJWfF+hAlpH49SYTbceqjzyGkAMccHwv5dmC+Qc2kK7ALgsBIo+uT3XMKGBETVPs1Q==
X-Received: by 2002:a65:6248:: with SMTP id q8mr1584659pgv.279.1627996442817;
        Tue, 03 Aug 2021 06:14:02 -0700 (PDT)
Received: from [192.168.10.153] (219-90-184-65.ip.adam.com.au. [219.90.184.65])
        by smtp.gmail.com with UTF8SMTPSA id w18sm15193753pjg.50.2021.08.03.06.14.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 06:14:02 -0700 (PDT)
Message-ID: <a0665d21-a390-6263-0018-09b4cb57e87b@ozlabs.ru>
Date:   Tue, 3 Aug 2021 23:13:57 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:90.0) Gecko/20100101
 Thunderbird/90.0
Subject: Re: [RFC PATCH kernel] KVM: Stop leaking memory in debugfs
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     "Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
References: <20210730043217.953384-1-aik@ozlabs.ru>
 <YQklgq4NkL4UToVY@kroah.com>
 <CABgObfb+M9Qeow1EZy+eQwM1jwoZY3zdPJfZW+Q+MoWmkaqcFw@mail.gmail.com>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <CABgObfb+M9Qeow1EZy+eQwM1jwoZY3zdPJfZW+Q+MoWmkaqcFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 03/08/2021 22:52, Paolo Bonzini wrote:
> On Tue, Aug 3, 2021 at 1:16 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Fri, Jul 30, 2021 at 02:32:17PM +1000, Alexey Kardashevskiy wrote:
>>>        snprintf(dir_name, sizeof(dir_name), "%d-%d", task_pid_nr(current), fd);
>>>        kvm->debugfs_dentry = debugfs_create_dir(dir_name, kvm_debugfs_dir);
>>> +     if (IS_ERR_OR_NULL(kvm->debugfs_dentry)) {
>>> +             pr_err("Failed to create %s\n", dir_name);
>>> +             return 0;
>>> +     }
>>
>> It should not matter if you fail a debugfs call at all.
>>
>> If there is a larger race at work here, please fix that root cause, do
>> not paper over it by attempting to have debugfs catch the issue for you.
> 
> I don't think it's a race, it's really just a bug that is intrinsic in how
> the debugfs files are named.  You can just do something like this:
> 
> #include <unistd.h>
> #include <stdio.h>
> #include <fcntl.h>
> #include <sys/wait.h>
> #include <sys/ioctl.h>
> #include <linux/kvm.h>
> #include <stdlib.h>
> int main() {
>          int kvmfd = open("/dev/kvm", O_RDONLY);
>          int fd = ioctl(kvmfd, KVM_CREATE_VM, 0);
>          if (fork() == 0) {
>                  printf("before: %d\n", fd);
>                  sleep(2);
>          } else {
>                  close(fd);
>                  sleep(1);
>                  int fd = ioctl(kvmfd, KVM_CREATE_VM, 0);
>                  printf("after: %d\n", fd);
>                  wait(NULL);
>          }
> }

oh nice demo :)

although I still think there was a race when I saw it as there was no 
fork() in the picture but continuous create/destroy VM in 16 threads on 
16 VCPUs with no KVM_RUN in between.

> 
> So Alexey's patch is okay and I've queued it, though with pr_warn_ratelimited
> instead of pr_err.

Makes sense with your reproducer. Thanks,


-- 
Alexey
