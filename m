Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DE62C7A54
	for <lists+kvm@lfdr.de>; Sun, 29 Nov 2020 18:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgK2Rfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Nov 2020 12:35:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58078 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728462AbgK2Rff (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 29 Nov 2020 12:35:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606671248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Baf2YabTsa2IfZZmu8SPbdZascUUB96+ibE6qUCU1Gc=;
        b=OcFNQ8Q0Cd66CIJO+fd/hzSsFKTxj7yn/w3Ki3tEzQXczI7jT73cO1CXLE5JNvmZ6rIYTg
        5xB1fMDsU+CaTUd1QWtapL2wFrZxQMyCHbDnZBumLxmXlKbuF2MNI1RdsfX2011faP474+
        AivSLGSkSnZLMDee2sHzRNovMaRYFOs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-R_G7cXFGPbuZ0Xep05l8ww-1; Sun, 29 Nov 2020 12:34:06 -0500
X-MC-Unique: R_G7cXFGPbuZ0Xep05l8ww-1
Received: by mail-wm1-f71.google.com with SMTP id o17so6070644wmd.9
        for <kvm@vger.kernel.org>; Sun, 29 Nov 2020 09:34:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Baf2YabTsa2IfZZmu8SPbdZascUUB96+ibE6qUCU1Gc=;
        b=YDzvn1yw06NB5og5WbmRroEI+87O0q8AowCRsOeq1Stk2zfa1Uy+1F0koC+jhtEce0
         Xe8nspgDT2GKKyROSLB7UaucWy72krRkrsXMKZj9p499a6++GWuMl3L/aiuzXPnptB+6
         FrozPF5c9/BfaK4ntL272EfkdOMXxja98J6+FZo/azuosQBzJ6k06A2WVWswkuvM6+1w
         m89BTLn0kZwsv8AEwQ9guKjbOXRogAvhmrffYdnNkJTM6TpMaCfz5ZrBDYuEHIcUwmiL
         9LTdJZJIPxie5LS5zwHpb1jM6+odz1n4hYQGu+FIK/f8tALjISXkAMjvHYCCDRHgBTZg
         NXog==
X-Gm-Message-State: AOAM533M6BSV7h8RMin24cz1iLI1i+y1TpNzlESxkds2wRED6JhbKc1G
        vL6e1JUcOml3Wl7c5SOXmpHwET9NKut1FGDMAkM3hcohvcXkNE0bAasJJOTsTd13Dhds9gQbWK9
        mf4bXLSBrvHZs
X-Received: by 2002:a1c:4d0a:: with SMTP id o10mr19426256wmh.107.1606671245225;
        Sun, 29 Nov 2020 09:34:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy21n5+1MquKPMw6OBo6U5LqUAw3wOmx072b/JbOC0N0bjRNE96mnvZ3UYX3LcDBBupYSjL2g==
X-Received: by 2002:a1c:4d0a:: with SMTP id o10mr19426239wmh.107.1606671244962;
        Sun, 29 Nov 2020 09:34:04 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id m4sm4842595wmi.41.2020.11.29.09.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Nov 2020 09:34:04 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 5.9 22/33] vhost scsi: add lun parser helper
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201125153550.810101-1-sashal@kernel.org>
 <20201125153550.810101-22-sashal@kernel.org>
 <25cd0d64-bffc-9506-c148-11583fed897c@redhat.com>
 <20201125180102.GL643756@sasha-vm>
 <9670064e-793f-561e-b032-75b1ab5c9096@redhat.com>
 <20201129041314.GO643756@sasha-vm>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7a4c3d84-8ff7-abd9-7340-3a6d7c65cfa7@redhat.com>
Date:   Sun, 29 Nov 2020 18:34:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201129041314.GO643756@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/11/20 05:13, Sasha Levin wrote:
>> Which doesn't seem to be suitable for stable either...  Patch 3/5 in 
> 
> Why not? It was sent as a fix to Linus.

Dunno, 120 lines of new code?  Even if it's okay for an rc, I don't see 
why it is would be backported to stable releases and release it without 
any kind of testing.  Maybe for 5.9 the chances of breaking things are 
low, but stuff like locking rules might have changed since older 
releases like 5.4 or 4.19.  The autoselection bot does not know that, it 
basically crosses fingers that these larger-scale changes cause the 
patches not to apply or compile anymore.

Maybe it's just me, but the whole "autoselect stable patches" and 
release them is very suspicious.  You are basically crossing fingers and 
are ready to release any kind of untested crap, because you do not trust 
maintainers of marking stable patches right.  Only then, when a backport 
is broken, it's maintainers who get the blame and have to fix it.

Personally I don't care because I have asked you to opt KVM out of 
autoselection, but this is the opposite of what Greg brags about when he 
touts the virtues of the upstream stable process over vendor kernels.

Paolo

>> the series might be (vhost scsi: fix cmd completion race), so I can 
>> understand including 1/5 and 2/5 just in case, but not the rest.  Does 
>> the bot not understand diffstats?
> 
> Not on their own, no. What's wrong with the diffstats?
> 

