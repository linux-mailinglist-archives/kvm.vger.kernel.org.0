Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374F9740C14
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbjF1I67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:58:59 -0400
Received: from mx18.pku.edu.cn ([162.105.129.181]:22535 "EHLO pku.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232035AbjF1IWB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 04:22:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pku.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:References:MIME-Version:Content-Type:
        Content-Disposition:In-Reply-To; bh=2TuRVB6UrpKR/H+eKdPp49cVqkS/
        qTK9lPInkHmcSIE=; b=QhcKvj+NDKHtPd5PlhIMKmfrZV+Kd+IlcUkKo1rs/MC7
        aPCOqriRFzGelPyU0hW79RebYEv/FlHurtXOeFXNrtnvkOtpvaUEumlCQcCBf4rc
        t0bF84M1ny+NR/CLOUwh11i6HY3PAs6g+jpUSfJPHlgA2FUaiIFlD8HRTbFFAZ0=
Received: from localhost (unknown [10.7.61.172])
        by front01 (Coremail) with SMTP id 5oFpogCXn5da7ZtkOi9ZCw--.31623S2;
        Wed, 28 Jun 2023 16:20:52 +0800 (CST)
Date:   Wed, 28 Jun 2023 16:20:42 +0800
From:   Ruihan Li <lrh2000@pku.edu.cn>
To:     syzbot <syzbot+644848628d5e12d5438c@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, seanjc@google.com, stern@rowland.harvard.edu,
        syzkaller-bugs@googlegroups.com, Ruihan Li <lrh2000@pku.edu.cn>
Subject: Re: [syzbot] [kernel?] kernel BUG in workingset_activation (2)
Message-ID: <227x4knhpjl2vk66ht7kqjh7fsotzxszycuounstjvrkktzvu2@k7un4x5yco62>
References: <000000000000a2c79f05ed84c7f9@google.com>
 <0000000000001e68bd05ff2bfbbf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000001e68bd05ff2bfbbf@google.com>
X-CM-TRANSID: 5oFpogCXn5da7ZtkOi9ZCw--.31623S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtr47uF48AFWfZFyDZFy8uFg_yoWkAFg_Wr
        4UGF97K397Ar1UArsYyrnaqw4kWa97WFyFgFn3Xrs2ka9xJayxGFs7WF48G348Jr43X34D
        K34aqrWDtwsIvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbfxFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAac4AC62xK8xCEY4
        vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE-syl42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VWkJr
        1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
        6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQZ23UUUUU=
X-CM-SenderInfo: yssqiiarrvmko6sn3hxhgxhubq/1tbiAgELBVPy78PRJAA-sK
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 01:00:45AM -0700, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit 0143d148d1e882fb1538dc9974c94d63961719b9
> Author: Ruihan Li <lrh2000@pku.edu.cn>
> Date:   Mon May 15 13:09:55 2023 +0000
> 
>     usb: usbfs: Enforce page requirements for mmap
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10a65abd280000
> start commit:   59d0d52c30d4 AMerge tag 'netfs-fixes-20221115' of git://gi..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=11d3fa0b3feb5055
> dashboard link: https://syzkaller.appspot.com/bug?extid=644848628d5e12d5438c
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14fdf3f1880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17b54702880000
> 
> If the result looks correct, please mark the issue as fixed by replying with:
> 
> #syz fix: usb: usbfs: Enforce page requirements for mmap
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Correct.

#syz fix: usb: usbfs: Enforce page requirements for mmap

Thanks,
Ruihan Li

