Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19386426C6F
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 16:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbhJHOL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 10:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237830AbhJHOL3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 10:11:29 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0650DC061755
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 07:09:34 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id d11so10128560ilc.8
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 07:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=OAyahn7hTcOi0w3EhYRbF/EsHfrIHNXVi748AsP0i3I=;
        b=h7zLI6WEEbVQxFe1z67p3QtoaCqLwhz/c99O3EInT8dLR/8kumNQfj+kJrWw8ZfWtH
         yF0uHhvP2tXfDTUFK2+R25GrkugKuqwhfcOClCcqjJHseUIGzU4yuWGpnG2+ndfEH9XL
         LvoddvOTmK4m5X444cGaNwCVGJlbeo2688tBDtRmAR5hapSc/DSSOOZmCaGdmWMwk203
         ZvErcy88QtIq47Nh1BhHwyhuNoGdSQBX313duoew4Zb0ji9NG2ss0BNmYH7uNI8KlL/3
         4r05YTV07esPZdmzRxLfjObEx1OEg4d5H6ATGgOQpqEDi0mvMCAqRM2jMhld9a2YXQn2
         cKsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=OAyahn7hTcOi0w3EhYRbF/EsHfrIHNXVi748AsP0i3I=;
        b=e8ZTuQDR8hyb7fkNoZUU5WFIVUOrf90JaJfNS0p94oWfut+AyKgYy6e3xecE5gUwy5
         4bs+SsdIH8Kdp7oNuCP803vsLxyGffEKUyKAT7Ont5/7VxkKNTZbevKHFqkj/NUjYPrE
         tewrErEfZlsauQ6AF4CmQgAvxExBAMdqStl7r7pqXlp/gd7b8QwWthFXBiFmPCILSnDz
         Nmx0YSqil3s0fKfkFoTvmo36piQZkHRBsIwx+QNE8fbP45d+gJa1pMdT/unJjR6PD1P0
         NP6Zucxz4OA3Fodqmg8pF3wYkHBYP4l/VIfqfua8Ey+mmLisXeOp9Xt35MEq+Im7wYdm
         zhRw==
X-Gm-Message-State: AOAM53149WKRRKd9oIcgYeurT5+IPdrsKuG9oBxmk2yrN1B78goNiXkN
        MpFWGj3hb39yaEGE7mQ94A2PFyP0x63KcE3CNg1z4cpilGs=
X-Google-Smtp-Source: ABdhPJydRG71ui1pa2OgmiiriomgA/+3l96QZgmeJQpB4sBmBWrvu/a8KnUc0+JssnqiV9TXUn2HrxfQPTpkrvGM5f8=
X-Received: by 2002:a05:6e02:184f:: with SMTP id b15mr8267781ilv.187.1633702173215;
 Fri, 08 Oct 2021 07:09:33 -0700 (PDT)
MIME-Version: 1.0
From:   "Y.G Kumar" <ygkumar17@gmail.com>
Date:   Fri, 8 Oct 2021 19:39:22 +0530
Message-ID: <CAD4ZjH2Gmac9qEA7dRUUMuVKXJp3+TsO8n+x4FZWy=0OFvUewA@mail.gmail.com>
Subject: Need Information
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I am trying to understand the concept of cpu steal time. I have a few
questions about it.

According to the link
https://scoutapm.com/blog/understanding-cpu-steal-time-when-should-you-be-worried
 , it is defined as follows:

"Steal time is the percentage of time a virtual CPU waits for a real
CPU while the hypervisor is servicing another virtual processor."

I have two questions regarding that.

1. What do we mean by "percentage of time" ? Which time is it alluding
to ? Is it the "cpu time" allocated by the scheduler to that kvm
process ? Or, is it the general waiting time that vcpu process has to
wait in the run queue before getting the cpu for execution ? If this
is true, then it is normal for that vcpu process like any other
process on the system to wait in the runqueue. Then what is this fuss
about ?

2. How can we read this steal time ? Can we see it from within the vm
and from the hypervisor host also ?  If so, how ?  Does this mean that
we cant see the "st" field if we execute the top command on a server
without any hypervisor ? Please explain.

Thanks
Kumar
