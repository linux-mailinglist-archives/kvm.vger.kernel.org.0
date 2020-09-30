Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE7A27E0FD
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 08:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgI3GYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 02:24:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32971 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbgI3GYW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Sep 2020 02:24:22 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601447062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sQlVHYMhn8vBG9J1bK/w3aggY2ujDQ0L8SzsncwRqMk=;
        b=K7gDlwaOa11D+a4scmitk2khPoYkYcQygkx2D1bpeWuNgdjFYAYhm+yAPEcrBM482V6117
        yhBosNSRpHS6i/OaKQ9cSjkO2qfUqTipDBjavL43m2KjEOIY4uKkQi868pmlmBD+QLzvsv
        WgLGyxbczKvZjpa40RWqWIN5dEWjPmY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-oyJCMXu-N_iARBMSAh_Kqw-1; Wed, 30 Sep 2020 02:24:19 -0400
X-MC-Unique: oyJCMXu-N_iARBMSAh_Kqw-1
Received: by mail-wr1-f69.google.com with SMTP id v5so207817wrs.17
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 23:24:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sQlVHYMhn8vBG9J1bK/w3aggY2ujDQ0L8SzsncwRqMk=;
        b=sLJCrKk168wct84naT8YrrQoH6MWxyOFAMa+xWlNXdu+hVYbLbhUf7ojU5yNbc5tFh
         tmeNeQ80xP1JZSxlwFdPyW4B4ZNpdAjEmP4DncrMdImHu64122DYLv+m6mBoCHMvjTQ3
         2DwpYMyQyGHFEsrYgN88o3xxrVmxiGk2DvFDwf8wT2CumeLPtNgJoSiL1Jx3bb8dqgIj
         1IWZprTG/5bQuy5Aeqn/eTHVQwtfQPD5PqgdkdvMCSH0UKdavC4etDsgoYmUU+XUgHu1
         U9ySDL7eD8fTmvrJI9vOBYNbVV2daZU01ad58UCoOSSyXYegjTTXE+kvGVHjmuRciRIa
         gEWg==
X-Gm-Message-State: AOAM530sbKzb6EsBwfDNYTdG8GI1uXtHN1ke5sEUDuNTc2Ba6cgJuT2y
        doU86uiKz7puImhP1j+wFi3EBoTniAgS6SeSWCJJHw+HdaEZYd+Ykj0iEKvJOgL8ZyqrluCE6SR
        1CHJKSDoBI/Ow
X-Received: by 2002:a5d:66c1:: with SMTP id k1mr1256569wrw.34.1601447058625;
        Tue, 29 Sep 2020 23:24:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGcdxJdjm9pMwDJq9hEe59B3jvrWEmZgnX+vF1hzorRoj7r5nqs307SpW+Di5YlvUMjSDFTA==
X-Received: by 2002:a5d:66c1:: with SMTP id k1mr1256535wrw.34.1601447058417;
        Tue, 29 Sep 2020 23:24:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:75e3:aaa7:77d6:f4e4? ([2001:b07:6468:f312:75e3:aaa7:77d6:f4e4])
        by smtp.gmail.com with ESMTPSA id 63sm1246438wrc.63.2020.09.29.23.24.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 23:24:17 -0700 (PDT)
Subject: Re: [PATCH 02/22] kvm: mmu: Introduce tdp_iter
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-3-bgardon@google.com>
 <20200930052336.GD29405@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <61d23bc0-771d-9110-6528-3658a55ccba6@redhat.com>
Date:   Wed, 30 Sep 2020 08:24:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200930052336.GD29405@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/20 07:24, Sean Christopherson wrote:
> Maybe use the params, if only to avoid the line wrap?
> 
> 	iter->gfn = goal_gfn - (goal_gfn % KVM_PAGES_PER_HPAGE(root_level));
> 
> Actually, peeking further into the file, this calculation is repeated in both
> try_step_up and try_step_down,  probably worth adding a helper of some form.

Also it's written more concisely as

	iter->gfn = goal_gfn & -KVM_PAGES_PER_HPAGE(iter->level);

> 
> 
> 	bool done;
> 
> 	if (try_step_down(iter))
> 		return;
> 
> 	do {
> 		done = try_step_side(iter);
> 	} while (!done && try_step_up(iter));
> 
> 	iter->valid = done;

I pointed out something similar in my review, my version was

	bool done;

	if (try_step_down(iter))
		return;

	do {
		if (try_step_side(iter))
			return;
	} while (try_step_up(iter));
	iter->valid = false;

Paolo

