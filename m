Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC683A5F85
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 11:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbhFNJzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 05:55:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41041 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232709AbhFNJza (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 05:55:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623664407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4kx9Q3nsVnRINu0vIrWoo9nXjPPqt9AsqYqJM+8URyI=;
        b=DmD/zzSyyUI6UUPShMbzTxNeTo/xOFNgRuLH8zvd5h0q5W3o9M/ziOX1UUGjGGaVMZ9WoP
        mcGiC1AiHS2I1M558nxIrQ4oQGaB9g2+2zTL58I/xRc3avbhZVbBrTqAXkuF9jWouL478/
        QU4KNwQ6Fyz3piVQwMfvIiZkExrV7so=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-5YiaZPLaOa-WLVtXIPxkvg-1; Mon, 14 Jun 2021 05:53:26 -0400
X-MC-Unique: 5YiaZPLaOa-WLVtXIPxkvg-1
Received: by mail-ed1-f69.google.com with SMTP id f12-20020a056402150cb029038fdcfb6ea2so19906776edw.14
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 02:53:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4kx9Q3nsVnRINu0vIrWoo9nXjPPqt9AsqYqJM+8URyI=;
        b=Jpm1KsBMyIDOcsjYkN92SH0VZS01X+OW6A2WeS6t9+lnovznZl+aOFG4EJf9VqoqkY
         /e1ShkOahZ9Qb6McrIdi7KNq6ccbqK3va99tT5vA6QTlNKW5349qQID8XPrJe5wzCh+D
         UmlMkmTcKH4nmzh9Z1AZ/bD6d75lLXsDl+kQVrkPzEpHdm/L4lHmyuRWWtmyQx9hjVQY
         xT25NdJuXsMEy+6DUxDhMf01VsTjIfJ3TrHvSzw5U0vRKmsaLI4pw1uzMoXfz2PZG3b2
         GmdT5OznutzmyKTGa0gOTYEowj2tSwdJI0KL260VV0T0B14QJFKrV7jsmyo9/5t24CQK
         s95Q==
X-Gm-Message-State: AOAM531wFGyXzTsEjdyJuaeb8Ra0Lam3MD3GgoNQGO5cBY/5xcEsScCg
        BzT2RczUn3eCnZikobrDhZ3fbSCoCbl5PSOQdMWT2RcLH/EdiMDatdz0lc61Suf+IC2UsYLNAT/
        NQ+rxgeszvzcq
X-Received: by 2002:aa7:dd1a:: with SMTP id i26mr16204803edv.358.1623664405038;
        Mon, 14 Jun 2021 02:53:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDkQ0JPU1g5M6jhW9DnavBLG6plfx7uGDLrqTbEtcjhKBQcyMeEBajFaPx2nWsm5OdUYvaJg==
X-Received: by 2002:aa7:dd1a:: with SMTP id i26mr16204789edv.358.1623664404859;
        Mon, 14 Jun 2021 02:53:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p10sm8486235edy.86.2021.06.14.02.53.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 02:53:24 -0700 (PDT)
Subject: Re: [PATCH 0/4] Remove duplicated stats definitions for debugfs
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Fuad Tabba <tabba@google.com>
References: <20210614025351.365284-1-jingzhangos@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dc48637c-e683-a64a-b744-bd5fe2037f31@redhat.com>
Date:   Mon, 14 Jun 2021 11:53:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210614025351.365284-1-jingzhangos@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/06/21 04:53, Jing Zhang wrote:
> This is a follow-up patchset to binary stats interface patchset as below:
> https://lore.kernel.org/kvm/20210611124624.1404010-1-jingzhangos@google.com
> 
> This patchset contains a commit to fix some missing stats and add static
> check to make sure we have the right number of stats descriptors and add an
> 'offset' field in stats descriptor to make sure the or order of stats
> descriptors is not relevant to the order of stats in vm/vcpu stats
> structure. This will totally avoid the possibility of missing stats and
> mismatched stats definitions.
> 
> The binary stats interface defines stats in another array of descriptors,
> while the original stats debugfs interface uses array of kvm_stats_debugfs
> item. To remove the duplicated stats definition, this patchset would
> utilize only the stats descriptors to provide stats information to debugfs
> interface. This patchset adds a 'mode' flag to support the read/write mode
> of stats, which can be used to indicate the file permission of debugfs
> stats files. It removes the usage of kvm_stats_debugfs_item and all the
> debugfs_entries defined in all archs.
> 
> The patch also fixes an issue that read only stats could be cleared in
> global level, though not permitted in VM level in the original debugfs
> code.

Thanks for putting this together quickly.  I think we can drop the mode, 
see the suggestion in patch 2.

It's probably best to fold the v8 for the stats functionality, these 
patches (squashed appropriately) and Fuad's remars in a single posting. 
  But I'm quite confident that it can make it in 5.14.

Paolo

