Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF74F18BAC0
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 16:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgCSPPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 11:15:07 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:43301 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726912AbgCSPPG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 11:15:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584630905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bo5DLSfTIO55szrTrrWpDLgWWQB+Imxl4yoST1QLG/Y=;
        b=PAJWX0I38+ozvd3d4z9jLmgpJ9eBcSJPUukcizQ9NSKN1vIIWFB0F548T5rYLm33zkyvo1
        btn7vikysNqJx5bqdEaEhhAggQBemdCU86uMr8t5eqkWTe4q5rZVu+LW410HneDuNca5Qf
        mEbrSJ6AeVrHxGqIuQnzYYoPIJvOOqw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-hhGhlM-UMQ267ipYb8JhaQ-1; Thu, 19 Mar 2020 11:15:00 -0400
X-MC-Unique: hhGhlM-UMQ267ipYb8JhaQ-1
Received: by mail-wr1-f70.google.com with SMTP id h17so1156118wru.16
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 08:15:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bo5DLSfTIO55szrTrrWpDLgWWQB+Imxl4yoST1QLG/Y=;
        b=UGjJoW9qlMDzIFqse0wrvTMZNwffbuSjRbnsKEEK+2ouDyy8LcZxizoYHxcECBPvz6
         oaFeNzlrxN0dVJK/PR8nL109LptY0o5q5rs0PBYUSpGZ64zN2gJrN9o8T3WHRSWZBI/2
         B3tahdboydnQTtYO/tp1UCdm0sj2ciTVMduVSjXLXVVdEGu0v1FTqahzgo1tqAwj9ygM
         9KDJCKbMrCp6ghQX29NkoBBvnaPLdKuc2GWAle7x6jA+zsD2NjGysP2H0hXP71yaYAq8
         xZU3RwtGkszNqYYMQbpkYDZEz0fzDEofxoy3ymDRm61Z9RkN+EArpbw6uEYkfNLwZ+f6
         88GQ==
X-Gm-Message-State: ANhLgQ0hYjBBgdurkvyFgKkMZuCsjV0Rn3Sw7yJLVVn/aEiMZu3nKwgj
        wU/U8DRfrXmoR//kbbXPaIC6A2cvbjkVP8UxFEY+AGNjozCNIwVMGhLlDOl/gQVvB4mFeViA7jK
        XvEzmfze9K2Rq
X-Received: by 2002:a5d:6091:: with SMTP id w17mr4829442wrt.402.1584630899489;
        Thu, 19 Mar 2020 08:14:59 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuA4dSKVZDCrUWm80Ekbq5QYYRsE1mC+1AVs2HaGMk0uIM2odsiyH+IG+8lqvhKWYlX8DB8Gw==
X-Received: by 2002:a5d:6091:: with SMTP id w17mr4829409wrt.402.1584630899185;
        Thu, 19 Mar 2020 08:14:59 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id y10sm3539341wma.9.2020.03.19.08.14.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 08:14:58 -0700 (PDT)
Subject: Re: WARNING in vcpu_enter_guest
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        syzbot <syzbot+00be5da1d75f1cc95f6b@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, rkrcmar@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
References: <000000000000f965b8059877e5e6@google.com>
 <00000000000081861f05a132b9cd@google.com>
 <20200319144952.GB11305@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <20be9560-fce7-1495-3a83-e2b56dbc2389@redhat.com>
Date:   Thu, 19 Mar 2020 16:14:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200319144952.GB11305@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/03/20 15:49, Sean Christopherson wrote:
> On Thu, Mar 19, 2020 at 03:35:16AM -0700, syzbot wrote:
>> syzbot has found a reproducer for the following crash on:
>>
>> HEAD commit:    5076190d mm: slub: be more careful about the double cmpxch..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=143ca61de00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=9f894bd92023de02
>> dashboard link: https://syzkaller.appspot.com/bug?extid=00be5da1d75f1cc95f6b
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10bb4023e00000
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+00be5da1d75f1cc95f6b@syzkaller.appspotmail.com
> Reproduced with a little tweaking of the reproducer, debug in progress.
> 

I think the WARN_ON at x86.c:2447 is just bogus.  You can always get it
to trigger if garbage is passed to KVM_SET_CLOCK.

Paolo

