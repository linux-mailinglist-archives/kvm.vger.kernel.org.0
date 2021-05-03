Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A6237161A
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 15:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbhECNnX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 09:43:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60284 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234374AbhECNnV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 09:43:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620049348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IOqsilqvn+aRNNXngzMn1OYzuH7ToC3yrg+kEaYj+1g=;
        b=DfSyFZzkjK6crwUZDl72B4zuy/n9jpuppsOeFpwDJuLFZEwwunNfnOVRAipva6ld2iTuP7
        CfLxHZh6IxCft/aaiR+3ymbcZsdo/sZPSUlHtj8XzvYGq4QZvz4UMQNG8WP9MIlQCzhOdn
        q72TcE4+S6g2t3x3aXlwvMNpN2++4iM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-9jv1Q2NwOKSC4WpTI8jSVA-1; Mon, 03 May 2021 09:42:24 -0400
X-MC-Unique: 9jv1Q2NwOKSC4WpTI8jSVA-1
Received: by mail-ed1-f72.google.com with SMTP id bm3-20020a0564020b03b0290387c8b79486so4523913edb.20
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 06:42:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IOqsilqvn+aRNNXngzMn1OYzuH7ToC3yrg+kEaYj+1g=;
        b=SvsjzxET5L/IDdh6mOQOxPCcdi26hbk2gJOfbbX5mJS6hOtBwecBlhIM36gDO8X866
         klQaa7I3YLwNTj90cAiVF71OCUnP2+w+TdVgVXGs3I6WfECAbjTh12dsmYr8g9Os2yRw
         Il1iD7ax80zPkqerHa+XjavHUJ1LbX7YEem9YBtzPmcuZvX6dnnGgA9Ri8DeykSE3kmf
         AkrfKvVd5/GbSO0CjNH+KLCs6m3R28dZNzSDcNpOjTMz1EwMAw8TenEZwGaYeD7+tnMx
         FQlV+dOdDpaTxkDJrW2HxUqian6i3+/toPZAgdlMjJDQY1hMdqJNWcQBF6BrL5uy8IKx
         VdSQ==
X-Gm-Message-State: AOAM530/w/N116jRHM3zy1rc6al/ODswrABfgbQQPoSshBu2skQXJfeq
        YekSFRyJr0eLyNMPcHkhPpZ/fJtIgJBVBym5RGQ6qzBtdcDl5e+UGxSFlzZ5dhHjD0UeWkJjOYL
        5ScTplb+EdouY
X-Received: by 2002:a50:82e2:: with SMTP id 89mr19872358edg.0.1620049343334;
        Mon, 03 May 2021 06:42:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzk3YnveQIawNQR3cb7zFFkOhqqtODvwbejBqHjpAgxGkRH2eHVwNnMVOHCGoASejb2epmncQ==
X-Received: by 2002:a50:82e2:: with SMTP id 89mr19872346edg.0.1620049343181;
        Mon, 03 May 2021 06:42:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c25sm12614554edt.43.2021.05.03.06.42.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 06:42:22 -0700 (PDT)
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210429211833.3361994-1-bgardon@google.com>
 <20210429211833.3361994-2-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/7] KVM: x86/mmu: Track if shadow MMU active
Message-ID: <e9090079-2255-5a70-f909-89f6f65c12ed@redhat.com>
Date:   Mon, 3 May 2021 15:42:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210429211833.3361994-2-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/21 23:18, Ben Gardon wrote:
> +void activate_shadow_mmu(struct kvm *kvm)
> +{
> +	kvm->arch.shadow_mmu_active = true;
> +}
> +

I think there's no lock protecting both the write and the read side.
Therefore this should be an smp_store_release, and all checks in
patch 2 should be an smp_load_acquire.

Also, the assignments to slot->arch.rmap in patch 4 (alloc_memslot_rmap)
should be an rcu_assign_pointer, while __gfn_to_rmap must be changed like so:

+	struct kvm_rmap_head *head;
...
-	return &slot->arch.rmap[level - PG_LEVEL_4K][idx];
+	head = srcu_dereference(slot->arch.rmap[level - PG_LEVEL_4K], &kvm->srcu,
+				 lockdep_is_held(&kvm->slots_arch_lock));
+       return &head[idx];

Paolo

