Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9921EE8A4
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 18:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbgFDQdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 12:33:40 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30751 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729641AbgFDQdk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 12:33:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591288419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rS8D/JFOWrRwFrYArK0CJleHBlqLOjsoPyc8lfn6ZAc=;
        b=P6M6uEQEzWS5cWoFZwAwnR51aCp3AAYeL4O7/xO72PIMm47XeIOveOSOM8EgvZfoV4UPsN
        ZTeXWDD2lxNtH1nEOh1jXrO/LMKO3oEAVnG3syANMBmnb0fxJZ9tHv2Uwr/tReOd4XuSFB
        /GjWci1a7MvHFG43UvEQZpJPsErLH+I=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-IYHLbv6VNSW5x-k7vhcwmg-1; Thu, 04 Jun 2020 12:33:37 -0400
X-MC-Unique: IYHLbv6VNSW5x-k7vhcwmg-1
Received: by mail-wr1-f70.google.com with SMTP id w4so2644860wrl.13
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 09:33:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rS8D/JFOWrRwFrYArK0CJleHBlqLOjsoPyc8lfn6ZAc=;
        b=CasNmE9dy745TbXzLO1KNsVsRWcuTcuuI9vL5i299PKaKcsDUSIWK9uOQEmRMsmiXa
         w5Bd+vYoRmmvsVNoot0z9Vojn9hoCi3yT99AXrn1weDTn4II29kolwky+ilx1ZMOiAea
         6gV5fhRPfs2ZSXZ5ME1mBRVLrXE+N9ldsFY/NMfAefBMaaHogXB92iLdvt+UFIYnNSV/
         gGq7132neRdlG/oB2Zm1wTNtMeA555mzXdojMXefzIvPlF7MfsJa2OJUSv6CTbKYUjFd
         DDNOMCRbbQec21P3eHcZU5MbMM2FrUgCurJ3JarFIGwXBhnX7cvzpMSwsNK4Su3/GS4+
         ho/Q==
X-Gm-Message-State: AOAM533TExjUM7wRzUWyC1SuPtyfDUaoqw8MCuYo9JSTw4hCw+pUKzhq
        L6WMAsYsLYeK220HeaS7cdnmDU6mILTRqjzPMB+kdxrreQCngdqiQ3PdoKSDFah/8wgpXHQf24D
        eCcA2kAuj/Ym1
X-Received: by 2002:a1c:2457:: with SMTP id k84mr4481317wmk.96.1591288416180;
        Thu, 04 Jun 2020 09:33:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGLvx77NfrsgkT65LvDduqV0L/xtQtvXitGjis7X05sQbwKlDzt50915nPUtGkF1/DNBuxzQ==
X-Received: by 2002:a1c:2457:: with SMTP id k84mr4481298wmk.96.1591288415922;
        Thu, 04 Jun 2020 09:33:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id v2sm8619411wrn.21.2020.06.04.09.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 09:33:35 -0700 (PDT)
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 5.8
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Wei Liu <wei.liu@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
References: <20200603173857.1345-1-pbonzini@redhat.com>
 <CAHk-=wjC21siUGvy9zpVOHfLRe4rwiT-ntqqj3zN73qtveKjpQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8ffbd4d8-5baf-c2ee-8728-cc73794ed863@redhat.com>
Date:   Thu, 4 Jun 2020 18:33:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjC21siUGvy9zpVOHfLRe4rwiT-ntqqj3zN73qtveKjpQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/20 00:17, Linus Torvalds wrote:
> On Wed, Jun 3, 2020 at 10:39 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>> There could be minor conflicts depending on the order you're processing 5.8
>> pull requests.
> It would have been good if you had actually pointed to the reports
> from linux-next.
> 
> As it was, the hyper-v pull request did do that (thanks Wei Liu), so I
> could verify my merge against what had been reported and this didn't
> take me by surprise, but it would have good to see that kind of detail
> from the kvm pull too..

Ok, I'll keep it in mind.  Based on today's report from Stephen, you
will get also a conflict with the s390 tree, and a semantic change
(build failure) when Thomas sends his large IRQ rework, due to the
removal of the second argument to do_machine_check.

Paolo

