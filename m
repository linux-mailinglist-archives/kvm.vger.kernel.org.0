Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0B01E9292
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 18:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgE3QUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 May 2020 12:20:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31581 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729038AbgE3QUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 May 2020 12:20:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590855612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Y07FflDlYJVMUyysoTwcpFsx8MSfGOT4BCyFdsShZo=;
        b=KxhJu2rxyR/JjgsVkGmLp/7d2x8lBn5P8hHTyOuWFCR8I8/s2aT4ZOLXWmPhn18Sj65bHq
        KMD/YklI2TbMGkdlPK179MycKeBmCgN5JOsdSxk0DvyfdlZgeZDp0SuPLoILqMF/ZvjHia
        VbIzFSA8lKZI9gk/ItzxGXUPUldmOAs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-ZSv6TI51OCe_Vej57rqE3g-1; Sat, 30 May 2020 12:20:08 -0400
X-MC-Unique: ZSv6TI51OCe_Vej57rqE3g-1
Received: by mail-wr1-f70.google.com with SMTP id j16so2344810wre.22
        for <kvm@vger.kernel.org>; Sat, 30 May 2020 09:20:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1Y07FflDlYJVMUyysoTwcpFsx8MSfGOT4BCyFdsShZo=;
        b=a9oxMp+kMBmnIew0mjK7FYibsueX37ensmspVob07FmVG217iKf3nrfqiSpe5q6dxZ
         xmnPhukmHObU94y2Pybf4G95LRkgGlwR1B52Rmzbemc0059LhGE/ahKW35nN1sFwZcJp
         2W43/LLr2tCyH5pVM/BaGa+XtSN6kNJh2d5KH2s5eIplZ+aQOxKwAp9GnOkrCkNKu4fw
         coNKyXUAvW7HFqaMibX7vbNUtgqX9dxGIkxT7SDpOWWjG/vxB603pOqvLsTI1llWQLLj
         +FIfxXyDHPSOiZnwRDNe88er9T0oQAuMVEE858WjJLMlNR+vHg3EuEt3C+N+/GszRx4L
         +irg==
X-Gm-Message-State: AOAM532OGkGNI4R96YRsIgXGQXg4cBwnf7Z+FHBZQQ3AKF3rF5ixIJ1/
        BdWMefUK4QDrnDptUeIEB0jMTqox9gEXb9PiQorOrCAzpTxgv/HuSGhzmneP9ONlbNzfE3DUv13
        gmnreQzcHUOuF
X-Received: by 2002:adf:e68a:: with SMTP id r10mr13854867wrm.384.1590855607371;
        Sat, 30 May 2020 09:20:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXlElKTzRL6bFu/3rQrgfAs1k3BodxDyJgVmRXgSjiwdnIdN6gv3xiEGh0NHUK0QqpPIYfTw==
X-Received: by 2002:adf:e68a:: with SMTP id r10mr13854851wrm.384.1590855607156;
        Sat, 30 May 2020 09:20:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id b8sm14890619wrs.36.2020.05.30.09.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 09:20:06 -0700 (PDT)
Subject: Re: [PATCH 8/9] x86: kvm_hv_set_msr(): use __put_user() instead of
 32bit __clear_user()
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
References: <20200528234025.GT23230@ZenIV.linux.org.uk>
 <20200529232723.44942-1-viro@ZenIV.linux.org.uk>
 <20200529232723.44942-8-viro@ZenIV.linux.org.uk>
 <CAHk-=wgq2dzOdN4_=eY-XwxmcgyBM_esnPtXCvz1zStZKjiHKA@mail.gmail.com>
 <20200530143147.GN23230@ZenIV.linux.org.uk>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <81563af6-6ea2-3e21-fe53-9955910e303a@redhat.com>
Date:   Sat, 30 May 2020 18:20:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200530143147.GN23230@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Fri, May 29, 2020 at 04:52:59PM -0700, Linus Torvalds wrote:
>> It looks like the argument for the address being validated is that it
>> comes from "gfn_to_hva()", which should only return
>> host-virtual-addresses. That may be true.

Yes, the access_ok is done in __kvm_set_memory_region and gfn_to_hva()
returns a page-aligned address so it's obviously ok for a u32.

But I have no objections to removing the __ because if a read or write
is in the hot path it will use kvm_write_guest_cached and similar.

Paolo

>> But "should" is not "does", and honestly, the cost of gfn_to_hva() is
>> high enough that then using that as an argument for removing
>> "access_ok()" smells.



