Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5818E81E
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 11:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731312AbfHOJY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 05:24:29 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53452 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730073AbfHOJY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 05:24:28 -0400
Received: by mail-wm1-f67.google.com with SMTP id 10so730894wmp.3
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2019 02:24:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=x84LMNNTuJo9sta6FIQCvGMribLZzm6UX96aqLVwiNc=;
        b=HEaH/Foyz9O9FSNig0veHLR8GEmLziwW7t+0vViLn8C5xKzro8ExSalq6/0Maq7SM4
         rx/deFmDpkKcX0HULJf0F03TQj41/cgNED6PoHlUrux8P0pJD6eznhpvGHXhBfVmwxKW
         prAhdLhs/BCHSQCDFlI09hNdHMuvZO012PR6IbxRzWtBhRr7sjR5NvRxpmtrBFV4RU7y
         yBpWrco0A1dXLKsDZW44q067JNeaHj2A/yOAPwSnMLqy1mi7R4F6Fnp0JTgpbn2qHReY
         EPsTdgOFjJZVUG4euz2mlg/EjCe9y7IBaZHo1gLtJbr/squM7eDNkqwmQygc8ovtgRvx
         JSRg==
X-Gm-Message-State: APjAAAUP2X6+h4VA9bHKMy1VXSljvkVoG1wXoEHwMBCAWWH81EQDcYr5
        /F4xqHliREE2hws12idZ4EOWkQ==
X-Google-Smtp-Source: APXvYqx8qgEzJjuKDHGRJH3OXvRcljUB1bEcjCi+jKW6Fepk1pJNTIPKClD4tx/zHPFs5fNXuLh86Q==
X-Received: by 2002:a1c:61d4:: with SMTP id v203mr1865635wmb.164.1565861066691;
        Thu, 15 Aug 2019 02:24:26 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id p7sm989293wmh.38.2019.08.15.02.24.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 15 Aug 2019 02:24:26 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v4 2/7] x86: kvm: svm: propagate errors from skip_emulated_instruction()
In-Reply-To: <20190815001952.GA24750@linux.intel.com>
References: <20190813135335.25197-1-vkuznets@redhat.com> <20190813135335.25197-3-vkuznets@redhat.com> <20190813180759.GF13991@linux.intel.com> <87d0h89jk3.fsf@vitty.brq.redhat.com> <20190815001952.GA24750@linux.intel.com>
Date:   Thu, 15 Aug 2019 11:24:25 +0200
Message-ID: <87wofe93xy.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Wed, Aug 14, 2019 at 11:34:52AM +0200, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>>
>> > x86_emulate_instruction() doesn't set vcpu->run->exit_reason when emulation
>> > fails with EMULTYPE_SKIP, i.e. this will exit to userspace with garbage in
>> > the exit_reason.
>> 
>> Oh, nice catch, will take a look!
>
> Don't worry about addressing this.  Paolo has already queued the series,
> and I've got a patch set waiting that purges emulation_result entirely
> that I'll post once your series hits kvm/queue.

Sometimes being slow and lazy pays off :-)

Thanks a lot!

-- 
Vitaly
