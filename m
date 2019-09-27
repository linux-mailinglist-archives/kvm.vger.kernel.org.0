Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1BDC0911
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 18:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfI0QCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 12:02:09 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40566 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbfI0QCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 12:02:08 -0400
Received: by mail-io1-f67.google.com with SMTP id h144so17603635iof.7
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 09:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lgAkk/YaVOjIm+eYoirnfpTGVi4GTRsy5eJmu7zQ35M=;
        b=BqBbqn1v6BmDj80XgHueQfDT2g8OiaP8+NPPh+sl4i4CnrYqtnxxdv+h6I7Q2C/l2T
         Saadv4tE19a3iwbCVOyoYMs8noKK7KGUyPU41lJJUD6xE1/gs636wHaX+QqvZP4j8YrA
         YEQOvkEvhfvstBudhmys/ZpKCjB06Czqb+fy4qAUadsv5jUvHi13iiuYFjpb699KLAi5
         8dA31ACK1Ua/zfUNHwskFeILW39Db9V1gqf4MD7bWzc0V2lrrC/fKeZjq+1Qke1k4Ezn
         HhopI3/wC618fZErDUxFx7lghzYwYXSNM/v0E5UpzuBY4rOyXDmIs2Sgui8mPeo4uRZB
         XQHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lgAkk/YaVOjIm+eYoirnfpTGVi4GTRsy5eJmu7zQ35M=;
        b=SUSLcoE55ROW4s/HiWjXGLy+nuYmFpOwuf5AXgG9iBppgIa9XCCs3/QyxHGrXaXAnL
         0qFF+cf10NruQIipqwE5E35QnDGHOd8SUhmz7jyMRg4KOzNVXonGNv3ZjU2OmgAhyRDR
         UDyIulQKfweEib2gYIKNzyTqKk/fhUVIE+Sz+3ChBBO/uhZo/J0T/XXSRIa03SD+afM2
         LWmKTzYhWQq5oHiN7b9URk9ovKEBySa0arc5WaEBMtnhDdRd1Rzw08Us8aRe0FEQQhli
         k+avMBQhE1gq0HpuyvpIz2fE/Sb1AGddKX3F9TBOOl8lgdYOunXjOzBeJSvWoSHk5v8v
         iEfw==
X-Gm-Message-State: APjAAAV3k+CR2ENU3VWn3Hh7TSrURZfn7Njqfo3ZFflOA8nb0jcWFztz
        cNkwySCDZV/k7J4hdAmzjf4nx1I+/ijSAq33GS+jsg==
X-Google-Smtp-Source: APXvYqwKBik3py7QHelQi1j9yqNr6X9seM8w1k1A2J3dgKRVd3txN4UH++9q5EB7yTpsxrY2YTVnE7EV+rNZJ4Of4ZI=
X-Received: by 2002:a92:4a0d:: with SMTP id m13mr5429319ilf.119.1569600126204;
 Fri, 27 Sep 2019 09:02:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190927155413.31648-1-vkuznets@redhat.com>
In-Reply-To: <20190927155413.31648-1-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 27 Sep 2019 09:01:55 -0700
Message-ID: <CALMp9eRRavuTr44XnL-ySWy7B5=Dir1Vt+oMp1+EiFbpNy6Mig@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: x86: clarify what is reported on
 KVM_GET_MSRS failure
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 8:54 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> When KVM_GET_MSRS fail the report looks like
>
> ==== Test Assertion Failure ====
>   lib/x86_64/processor.c:1089: r == nmsrs
>   pid=28775 tid=28775 - Argument list too long
>      1  0x000000000040a55f: vcpu_save_state at processor.c:1088 (discriminator 3)
>      2  0x00000000004010e3: main at state_test.c:171 (discriminator 4)
>      3  0x00007fb8e69223d4: ?? ??:0
>      4  0x0000000000401287: _start at ??:?
>   Unexpected result from KVM_GET_MSRS, r: 36 (failed at 194)
>
> and it's not obvious that '194' here is the failed MSR index and that
> it's printed in hex. Change that.
>
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
