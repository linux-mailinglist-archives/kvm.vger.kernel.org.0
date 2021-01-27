Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971AA305BD9
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 13:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237920AbhA0Moy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 07:44:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59802 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237387AbhA0Mly (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 07:41:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611751228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QUziTB7yjFCtXkFHnLPvHhuspDqt9BvMkArF+T1jL44=;
        b=c6+OHF3eaPYH7lGGo8ZDJn622l3vmB8jLsNIDQCotczYF/jHVQi3ZDuLwUSLwUB4uwgKmj
        MlH6xwDNbofn4ad6BrVT8xvj3QS39IGQWSOZYD0WzgdhtARtkOdHJ+SGvP/3j+jkO079HX
        8rlcqCFSD/aQGNeL85B26vnoJ76Bho4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-YbEm37ucOHSLrczz_InnWw-1; Wed, 27 Jan 2021 07:40:26 -0500
X-MC-Unique: YbEm37ucOHSLrczz_InnWw-1
Received: by mail-ed1-f69.google.com with SMTP id u26so348484edv.18
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 04:40:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QUziTB7yjFCtXkFHnLPvHhuspDqt9BvMkArF+T1jL44=;
        b=lsBu9Q5HVZxPsSuo43R7NZxzwPhEEixq7tby/Qpyfvxs2s+1tuiC9tdXAYC+c3V9gS
         qT2XilzXOM2uHAjf1Lgs21kNJykxy42GZH7GPSRR19NCann1VNgWHVRWCxUe1nFOv3Wb
         3/HumEzPcuoQRoAFut4SHmWq0wSq6khpdcRZ1xgbJO9Sh7/nQi4A643DCZY/xRBrOZrO
         kiCO7fL3RfvAWe5Bl+Yaorox46Ocx5LwWUFVO6qDo/Fih71XymMQph8fY1Yo41Vq446P
         IX0weARRyHd9ss/mFbU9qtoaZLOTvYLyAOGAcpgjOLSnWeVehehE5xRMmPfItdcAyH5M
         i3Yg==
X-Gm-Message-State: AOAM530HGaiH1nxL7qxDTjPSYU2utywvykcmly4w5TSlogYhoxxbyDjo
        BfgplkYh8HapXZzPo234R/ZtPpnXLtp8asS8ib0mUh/i0oHN/J0EyjzGcDFw8NWkbbUiSk3lxuE
        P2qEhHNak/UaY
X-Received: by 2002:a17:907:20aa:: with SMTP id pw10mr6561867ejb.314.1611751225510;
        Wed, 27 Jan 2021 04:40:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzuit+bGcgdhTrzCjhYmAEkv/7WLRGt5ic9fu4MFMY/cWcP+ETzolxbU4HANZFGkHEb8dAalQ==
X-Received: by 2002:a17:907:20aa:: with SMTP id pw10mr6561858ejb.314.1611751225382;
        Wed, 27 Jan 2021 04:40:25 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w18sm767764ejq.59.2021.01.27.04.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 04:40:24 -0800 (PST)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-20-bgardon@google.com> <YAnUhCocizx97FWL@google.com>
 <YAnzB3Uwn3AVTXGN@google.com>
 <335d27f7-0849-de37-f380-a5018c5c5535@redhat.com>
 <YBCRcalZJwAlkO9F@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 19/24] kvm: x86/mmu: Protect tdp_mmu_pages with a lock
Message-ID: <bb1fcf44-09ca-73b1-5bbc-49f8bc51c8c1@redhat.com>
Date:   Wed, 27 Jan 2021 13:40:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBCRcalZJwAlkO9F@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/01/21 23:02, Sean Christopherson wrote:
>> You can do the deferred freeing with a short write-side critical section to
>> ensure all readers have terminated.
>
> Hmm, the most obvious downside I see is that the zap_collapsible_sptes() case
> will not scale as well as the RCU approach.  E.g. the lock may be heavily
> contested when refaulting all of guest memory to (re)install huge pages after a
> failed migration.

The simplest solution is to use a write_trylock on the read_unlock() 
path; if it fails, schedule a delayed work item 1 second in the future 
so that it's possible to do some batching.

(The work item would also have to re-check the llist after each iteration.)

Paolo

