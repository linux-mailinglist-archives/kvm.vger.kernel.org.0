Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDDC2AB82
	for <lists+kvm@lfdr.de>; Sun, 26 May 2019 19:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbfEZRxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 May 2019 13:53:55 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41523 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727985AbfEZRxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 May 2019 13:53:54 -0400
Received: by mail-wr1-f65.google.com with SMTP id u16so10729645wrn.8
        for <kvm@vger.kernel.org>; Sun, 26 May 2019 10:53:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3E6kp+r7OBI+9gX6jKnLvemsSLfWQYZx5SlrWEsr91k=;
        b=ivKPEOf70BFCAejpM8u35lF6Z5a0cH7hQABjnF44bNmSNh02mz/0A1eWdr0h1QAusC
         OjsRQijiVmbjRn/SN8pPSuXc8d8seVIgHhf5uBvVrXc01hUYEDtpROY57XtEwHXysvF7
         xNEXXjuIngFUWoPOM3eWgC1oMh32K7hYDPQ6wBbWpKisZaSBGQewdtCQYBJvkQ+2BH9e
         vWQSpTxD5FOLmPAG9f7FoFi6Lks2EaT+euUQHo4CYsYHfQDTrgFSLYhijLorRHJC3Pv+
         L71q7/OMIPD2ubFtZY1ohZaPhYZB8ki+jUQRW1gyIXcIsTgawlN8g5TbEunUC25jcOjJ
         VT/g==
X-Gm-Message-State: APjAAAViA5hQtSoJXNvhPI2C3h/iwfycTUd/uplsqszb9kAsuoyH2m4d
        f5qMOANFLLTLBHrv7l7a2T7cdmY2MY0=
X-Google-Smtp-Source: APXvYqzQOxQEM8sgEkxzsO2Ks3B+FO1y/Lc06FIhA94o3VdiVhvDVjoDuFE1oO8eaQRV+PbB7yXgnA==
X-Received: by 2002:adf:8062:: with SMTP id 89mr678539wrk.97.1558893232941;
        Sun, 26 May 2019 10:53:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7428:5a9c:3100:a747? ([2001:b07:6468:f312:7428:5a9c:3100:a747])
        by smtp.gmail.com with ESMTPSA id n10sm418987wrr.11.2019.05.26.10.53.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 10:53:52 -0700 (PDT)
Subject: Re: [GIT PULL] KVM changes for Linux 5.2-rc2
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM list <kvm@vger.kernel.org>
References: <1558864555-53503-1-git-send-email-pbonzini@redhat.com>
 <CAHk-=wi3YcO4JTpkeENETz3fqf3DeKc7-tvXwqPmVcq-pgKg5g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2d55fd2a-afbf-1b7c-ca82-8bffaa18e0d0@redhat.com>
Date:   Sun, 26 May 2019 19:53:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAHk-=wi3YcO4JTpkeENETz3fqf3DeKc7-tvXwqPmVcq-pgKg5g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/05/19 17:51, Linus Torvalds wrote:
> On Sun, May 26, 2019 at 2:56 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>>   https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
> 
> This says it's a tag, but it's not. It's just a commit pointer (also
> called a "lightweight tag", because while it technically is exactly
> the same thing as a branch, it's obviously in the tag namespace and
> git will _treat_ it like a tag).
> 
> Normally your tags are proper signed tags. So I'm not pulling this,
> waiting for confirmation.

Shell history shows that I typed

	git push kvm +HEAD:tags/for-linus

(which matches the "git push kvm +HEAD:queue" that I often do, and
therefore can be explained by muscle memory).

The interesting thing is that not only git will treat lightweight tags
like, well, tags: in addition, because I _locally_ had a tag object that
pointed to the same commit and had the same name, git-request-pull
included my local tag's message in its output!  I wonder if this could
be considered a bug.

I have now pushed the actual tag object to the same place.

Paolo

