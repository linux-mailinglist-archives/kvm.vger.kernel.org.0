Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D924288CB
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 10:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbhJKIdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 04:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234885AbhJKIdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 04:33:18 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF15C061570
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 01:31:17 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id r18so64715837edv.12
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 01:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ansIydpls6m1U5UqWIdad2N3UObWfiebM00TNpZEqAY=;
        b=TIWW8982Q+BdDqaM+mbj+l/YQzuXk531tbljt7vKgGO9oa/m8fg73KmkkPhMtWptos
         ulMn8Z97rq9fVwI/cCS7AHVvwYFC0U8+L5O15p1gHwJIwxk8PyExzCY7do7+gNMyMkfQ
         zLCSiytz3l/7g40aZmz9Vec4iFuLHhzmZ0sMFdwv3m5fmjHABBXj6aQDWXKjFyFUEmrv
         Gfz/Nht0CmY59WiNTNmr3dbE9W7TbhbX4MX83U0M/c9aA8k4FC2uhxKO7nda7r/3Dbp3
         ojVqZv7rGe14KAMMNHrUFENvh4V0yLPJiCQEz8vzf6/msjMW9+voaJgZxCdP9sP8flFi
         58xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ansIydpls6m1U5UqWIdad2N3UObWfiebM00TNpZEqAY=;
        b=B2pBT+JbI9ua6rT/N+pDYTpQgw102cTewNFLaqsVqDApOghLEn+xA4bsIjR4FVAHS6
         oHkgm8XXKPnDPurHcWSb4d8nN8e4DWEVyDXriKODQ8DW1KhNbzfem4US9w8oZ7vLKXOj
         b0+zG7NROoO3PXrAH9eG/mLhJVjD7RNp6uJtGHLLOmdNcE6JkycHHzzQAWt7Q4N1s9Wj
         75k9ycK2xFviZlCO11omebett2SMTTvSlnnRAAbQFc/CYDQ2ZiX8V+WFWeO50gwFT0HQ
         8UQIZKcRm8YJVOIiUjel4uPA/YfVMnBwO5TrfDdh8Nf2Ijsja1hAKOyBjW+OAg0nzczH
         fMWQ==
X-Gm-Message-State: AOAM532XImqfLhyy0+IRSJM2YL7hJywZTtCTOzxXeppmEK790iATkU1Z
        zMRor8+/OmSX6IoRWrpWZAQ2EtAjIK/L/b0pXNcv
X-Google-Smtp-Source: ABdhPJwHWWKZMdVRBY+KhM8/Mxsd0heuNb4mPMfuhZ9nQLKKdmY9GMewTg3InfLsWTn8tTMygJdLGsym8GZLZpSCJgI=
X-Received: by 2002:a17:906:ce25:: with SMTP id sd5mr22450654ejb.398.1633941076108;
 Mon, 11 Oct 2021 01:31:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210831103634.33-1-xieyongji@bytedance.com> <6163E8A1.8080901@huawei.com>
In-Reply-To: <6163E8A1.8080901@huawei.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 11 Oct 2021 16:31:05 +0800
Message-ID: <CACycT3tBCdqPfLCTX4-ZDSos_hYPyBQu0xRHRu=ksaFk0k7_hA@mail.gmail.com>
Subject: Re: [PATCH v13 00/13] Introduce VDUSE - vDPA Device in Userspace
To:     Liuxiangdong <liuxiangdong5@huawei.com>
Cc:     "Fangyi (Eric)" <eric.fangyi@huawei.com>, yebiaoxiang@huawei.com,
        x86@kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Xiaodong,

On Mon, Oct 11, 2021 at 3:32 PM Liuxiangdong <liuxiangdong5@huawei.com> wrote:
>
> Hi, Yongji.
>
> I tried vduse with null-blk:
>
>    $ qemu-storage-daemon \
>        --chardev socket,id=charmonitor,path=/tmp/qmp.sock,server,nowait \
>        --monitor chardev=charmonitor \
>        --blockdev
> driver=host_device,cache.direct=on,aio=native,filename=/dev/nullb0,node-name=disk0
> \
>        --export
> type=vduse-blk,id=test,node-name=disk0,writable=on,name=vduse-null,num-queues=16,queue-size=128
>
> The qemu-storage-daemon is yours
> (https://github.com/bytedance/qemu/tree/vduse)
>
> And then, how can we use this vduse-null (dev/vduse/vduse-null) in vm(QEMU)?
>

Then we need to attach this device to vdpa bus via vdpa tool [1]:

# vdpa dev add vduse-null mgmtdev vduse

With the virtio-vdpa module loaded, we will see the block device in host.

And if we'd like to use it in a VM, we need to load the vhost-vdpa
module (a /dev/vhost-vdpa-0 char device will be presented) and build a
new qemu binary with the source code in
https://github.com/bytedance/qemu/tree/vhost-vdpa-blk. Then we can use
the below command line to start a VM with the vhost-vdpa-blk device:

./qemu-system-x86_64 -M pc -cpu host --enable-kvm -smp 8 \
-m 4G -object memory-backend-file,id=mem,size=4G,mem-path=/dev/shm,share=on \
-numa node,memdev=mem -monitor vc -serial stdio -no-user-config -nodefaults \
-vnc 0.0.0.0:1 -k en-us -vga cirrus \
-device vhost-vdpa-blk-pci,num-queues=1,vdpa-dev=/dev/vhost-vdpa-0

[1] https://man7.org/linux/man-pages/man8/vdpa-dev.8.html

Thanks,
Yongji
