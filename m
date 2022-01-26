Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096F149D31E
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 21:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiAZUHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 15:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiAZUHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 15:07:38 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A0BC061747
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 12:07:38 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id p125so374543pga.2
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 12:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DFPbCzFKgxQWuOxXDy4LqnA2tAk83/d+qYRfzdS9NDo=;
        b=TP7ylFU44strBzOztNYqY0AiAUjmiqBhnHSVWaVt6Q97YGju/ko9HtELlc96RNzQmk
         c5GRHSiwHCY2L3QnUZv3HpittI8Tv5XjZ1uwXje7ZZ3ioZcNjM2Wya4p7B3F6pPsGiTI
         olHecr9ms1I9Ed80tJ6DQNuaU0DMsvwWSB8k1opAy7K+N5YxYNAfZhCHDYL1zjUReiin
         gs0glcoIN0z1O/FuZTQKDcD5h3tjAfUdmsk99D+P8lW61cksG60aU5Hr6pjw8/5YwyFD
         M9KacrqevRkUbNjiPhJXREJLJonwvyw38dBnvoajgs5Xi2jBI0gxf5Gfb6Ap9DV2/bGz
         x/Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DFPbCzFKgxQWuOxXDy4LqnA2tAk83/d+qYRfzdS9NDo=;
        b=SqH8QwD9FnaErC2Pebzslu2/eECQR+PmGLzxhfa5kbO7I0tWNYfxOtFguSfM+0j5nG
         7at0C9IKYtrw0uphZ+OJCslMiaAKpKSiM69Do4xWZy4Mu6os7+ft+U3ozO34YIyjDOiy
         Au5ond2ZVaP3MI/0OPa8Vym4cXSXgsn1wFy7uY7POthJeLaQx4G0HoUEw8Vw0yN/+2MA
         TP7PtPVMLIgZ0YeFEpUqQ19xEXlQko5HuVSHHgyHRrusvobKulhUQJj1iZf15X/WHbqe
         ubZU2fU2XwTmL67+BYOlpfl4lcP70rikBN7UJLkZqvCD7ZHBU1MfvIw1ziQLnAX6LsNZ
         B+0Q==
X-Gm-Message-State: AOAM533PPfuZglKmA9iD3DELhlZOc9FefnA+WavNP6jFj1g8aAafF12A
        NgUTBUjFknBfWnWHQpNiRUWGNw==
X-Google-Smtp-Source: ABdhPJw3PkdqBDJWONWWZfBkpDUrnMNOkcHKBvNPxcp8RFeoeqA9FCCpVA61RqaqORBl8dSzqaamHQ==
X-Received: by 2002:a63:cc05:: with SMTP id x5mr378850pgf.163.1643227657367;
        Wed, 26 Jan 2022 12:07:37 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f15sm2811295pfn.19.2022.01.26.12.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 12:07:36 -0800 (PST)
Date:   Wed, 26 Jan 2022 20:07:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+ead0473557070d5432cd@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Subject: Re: [syzbot] memory leak in kvm_vcpu_ioctl_set_cpuid2
Message-ID: <YfGqBUYWj6nBxntP@google.com>
References: <000000000000be3e4505d681aa17@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000be3e4505d681aa17@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    0809edbae347 Merge tag 'devicetree-fixes-for-5.17-1' of gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17982967b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cc8d6c95ce1d56de
> dashboard link: https://syzkaller.appspot.com/bug?extid=ead0473557070d5432cd
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1402f91fb00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ba591fb00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+ead0473557070d5432cd@syzkaller.appspotmail.com

#syz fix: KVM: x86: Free kvm_cpuid_entry2 array on post-KVM_RUN KVM_SET_CPUID{,2}
