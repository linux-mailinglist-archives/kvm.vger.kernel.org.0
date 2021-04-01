Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726BA3513D1
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 12:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbhDAKn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 06:43:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59602 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233665AbhDAKn5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 06:43:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617273836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=06eBF4o9d28G+6vg65LbOreOw6UgB9u15+hd9KC5gTQ=;
        b=YMwEcccAYCXnRB+WD0F3+sU2GzRgz+Ltzlt4r02UdXsJK5MfgWyhLgYtttyapbuMO8Q2qi
        Q5ZVdsOC5lZvDx1/ayypE6tAqOjKOvcZ6CAjE7gwhuenNTEBXA5/NugBRkO59LW8Wk4ZcI
        6uH1QYmHbggOdIegu+DachoVesuKvjU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-CULAZxaYPKWdb_rUzm7MZg-1; Thu, 01 Apr 2021 06:43:55 -0400
X-MC-Unique: CULAZxaYPKWdb_rUzm7MZg-1
Received: by mail-ej1-f72.google.com with SMTP id di5so2045917ejc.1
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 03:43:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=06eBF4o9d28G+6vg65LbOreOw6UgB9u15+hd9KC5gTQ=;
        b=JSBMLXsyhTvVgB/yxkxHGS7R2CzTUDMaDd/J1KiCy/wKauJO5xmtof5RdlI+Q5uzca
         caQz0UdH18dg0j87ZD48JhUU5mheMvG8pe8Ongh4VaGDeOX2h31d+P4gVk9yO1Hm6vmP
         x29LRRAEtEte6u5J9yDJQlJJB8AlBR2nh/IC1mr57g9kptqrAF+hB/I2DZmfTOuRGs2G
         sGjFcbInxK0e5i05F28FJPz1kTLC42UigJ/ppNXeYxdCluL3cn2L5EDl7bBhtkw+BOkZ
         rwgISpOo8LUMaNBmhyKDa96rMa2GL67ineNw10hSAnu0iuS1Pq2oki42YMpyhioZAvIN
         CIiA==
X-Gm-Message-State: AOAM533nhOMXww7lP4KdkDH/FzdC3TYSDb97ZMb9G+YpK7BPE7fhIeZa
        aXlHsdU17WtublU1zdWl5KumeCoCtPPxNa9OYY8feZ70n7Z/8cIUFm27NHpSheTXL6nO8KYsygr
        FVajRa17ewyET
X-Received: by 2002:a05:6402:35c9:: with SMTP id z9mr9099994edc.94.1617273834229;
        Thu, 01 Apr 2021 03:43:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyaEuHHzciANwnLmu0x2hIKZoVzKLp+pSGWi/TjhOef41m8Xy6dIdyT4us53vS/TpmgrvFbJw==
X-Received: by 2002:a05:6402:35c9:: with SMTP id z9mr9099988edc.94.1617273834091;
        Thu, 01 Apr 2021 03:43:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id la15sm2574423ejb.46.2021.04.01.03.43.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 03:43:53 -0700 (PDT)
Subject: Re: [PATCH 00/13] More parallel operations for the TDP MMU
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210331210841.3996155-1-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <880ebe32-2ea5-6369-be2c-ce5d93746292@redhat.com>
Date:   Thu, 1 Apr 2021 12:43:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210331210841.3996155-1-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/21 23:08, Ben Gardon wrote:
> Now that the TDP MMU is able to handle page faults in parallel, it's a
> relatively small change to expand to other operations. This series allows
> zapping a range of GFNs, reclaiming collapsible SPTEs (when disabling
> dirty logging), and enabling dirty logging to all happen under the MMU
> lock in read mode.
> 
> This is partly a cleanup + rewrite of the last few patches of the parallel
> page faults series. I've incorporated feedback from Sean and Paolo, but
> the patches have changed so much that I'm sending this as a separate
> series.
> 
> Ran kvm-unit-tests + selftests on an SMP kernel + Intel Skylake, with the
> TDP MMU enabled and disabled. This series introduces no new failures or
> warnings.
> 
> I know this will conflict horribly with the patches from Sean's series
> which were just queued, and I'll send a v2 to fix those conflicts +
> address any feedback on this v1.

Mostly looks good (the only substantial remark is from Sean's reply to 
patch 7); I've made a couple adjustments to the patches I had queued to 
ease the fixing of conflicts.  The patches should hit kvm/queue later 
today, right after I send my 5.11 pull request to Linus.

I have also just sent a completely unrelated remark on the existing page 
fault function, which was prompted by reviewing these patches.  If you 
agree, I can take care of the change or you can include it in v2, as you 
prefer (I don't expect conflicts).

Paolo

