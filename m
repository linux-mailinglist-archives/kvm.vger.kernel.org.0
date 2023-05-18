Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FF8708353
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 15:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbjERN6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 09:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbjERN6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 09:58:05 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D79E5C;
        Thu, 18 May 2023 06:58:03 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1ac4910e656so9481505ad.0;
        Thu, 18 May 2023 06:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684418283; x=1687010283;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BtLnEeIrEBHNDXbArGbL4j4GJnqryBP0SQagmrUgrGg=;
        b=kTcm+d4G7iqgpvTCfkI3b8fGaNtfV9vlBKbGmmUuo0RMbGD2m2AidjTUMhIzZu+Shi
         y40uBY5VpePtJquZl7rd5RgW+JN3/JG83sG4SJp7GqAI3/1rRmevjv0qbQ5Fs6qjKGES
         HuE8br/BCOtvlrNLEO42LO5GcZfja9+EmJGnsXa0n3mqdQU+Y3HZp4qXsRTNvf0alzZx
         2rf0REXxXY2UudAEvG+c3jbHjnvJCITs9NeUSYlktSQYwjjHKNS6ZKoh7lTCqQXV7H18
         DgkAj6w7Ry9b6cD2qMlUfvePGhkrzWpxXY/5SHbbBu7wlrBE3wS/6m+1bEsGiCobAoc0
         3dig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684418283; x=1687010283;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BtLnEeIrEBHNDXbArGbL4j4GJnqryBP0SQagmrUgrGg=;
        b=ED33hnudwErmJIrwiKrFb9htzdcJFquBmeVRjn4P/gLzR1fkz8T1W//wXTr07dHXeP
         AcW1m7kDHF6xmY5Z3MZBBco4adowrETg3XKjm4WyxTMnBKHJdGrF3gd0DdarvkL1Wz96
         7ktAUupOqeB5k3oe6DrnEW4+FZioCF2t09/eRXJ/d4tjNnSiMr4LZF4tTpDSme5CcVx/
         OyR6ZQYYh5DXxw7m6HicMeoZpD9Djj1VsPaEvUeEmwamSr36tkIJR/G7NP/eGcaBYVCJ
         3rZbRMVyDeqsjAA8QS0vu4pZc9vjkWKAciNcUSSk4aXgmCzPSPqXxVxefunbuBHOLa/p
         XYZQ==
X-Gm-Message-State: AC+VfDywKiPpm4mRWlpXtfE6J+nptuwN13iVB2i2RE3KAM40vliXMlTp
        6UAGozdiz02DzxKqa7WxwKXWkX/obfk=
X-Google-Smtp-Source: ACHHUZ6VFuYSvVwA8jyZtwv0QujHXFDBLs+DPUqwJcKSgez51mKzVABj42QGXWnCnc9nv9JhjU9mlg==
X-Received: by 2002:a17:902:e848:b0:1a9:57b4:9d5a with SMTP id t8-20020a170902e84800b001a957b49d5amr2548268plg.31.1684418282737;
        Thu, 18 May 2023 06:58:02 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-78.three.co.id. [180.214.233.78])
        by smtp.gmail.com with ESMTPSA id e1-20020a170902744100b001a1adbe215asm1463703plt.142.2023.05.18.06.58.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 06:58:02 -0700 (PDT)
Message-ID: <71288f04-546c-9af3-e29a-eb3c44e0d948@gmail.com>
Date:   Thu, 18 May 2023 20:57:52 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Fwd: Persistent rt_sigreturn segfaults on KVM VMs after upgrade to
 5.15
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I notice a regression report on Bugzilla [1]. Quoting from it:

> I'm experiencing sporadic but persistent segmentation faults on the KVM VMs I manage. These faults began appearing after upgrading from Linux Kernel 4.x to 5.15.59. I further upgraded to 5.15.91 and transitioned the userspace from Debian 10 (buster) to Debian 11 (bullseye), yet the issues persist. Notably, the libc has also changed in the process as seen in the following error logs:
> 
> 
> post.sh[21952]: bad frame in rt_sigreturn frame:000072db65961bb8 ip:6c25f82a9a5d sp:72db65962168 orax:ffffffffffffffff in libc-2.28.so[6c25f8294000+147000]
> 
> cron[7626]: bad frame in rt_sigreturn frame:000073ddebeb6ff8 ip:72ad9f44d594 sp:73ddebeb75a8 orax:ffffffffffffffff in libc-2.28.so[72ad9f3a9000+147000]
> 
> cron[64687]: bad frame in rt_sigreturn frame:000073265764b038 ip:67c7b5a0f14a sp:73265764b5f0 orax:ffffffffffffffff in libc-2.31.so[67c7b596f000+159000]
> 
> worker.py[54568]: bad frame in rt_sigreturn frame:000078eef6591cf8 ip:6c9f9b2a604e sp:78eef6592298 orax:ffffffffffffffff in libpthread-2.31.so[6c9f9b29a000+10000]
> 
> 
> The segmentation faults occur 1-3 times daily across approximately 1000 VMs running on hundreds of (supermicro, intel cpu) bare-metal servers. Currently, there's no reliable way for me to reproduce the issue. I initially considered this bug - https://www.spinics.net/lists/linux-tip-commits/msg61293.html - as a possible cause, but judging from the comments it likely isn't.
> 
> The best approximation to a reproducer I have is a Python script that initiates several child processes and continuously sends them a sigusr1 signal. Still, it takes a few hours to trigger the issue even when running this script on several hundred VMs.
> 
> Switching to the 6.x kernel isn't immediately feasible as these are production systems with specific requirements. The transition is planned but will likely take several months.
> 
> I'm looking for suggestions on how to more reliably reproduce this problem. Then I could try different old and new kernels and maybe narrow it down.

See bugzilla for the full thread.

Anyway, I'm adding it to regzbot:

#regzbot introduced: v4.19..v5.15 https://bugzilla.kernel.org/show_bug.cgi?id=217457
#regzbot title: bad frame in rt_sigreturn (libc-related?) regression after 5.15 upgrade

Thanks.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=217457

-- 
An old man doll... just what I always wanted! - Clara
