Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDAD1F35EB
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 10:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgFIIJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 04:09:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40803 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728005AbgFIIJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 04:09:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591690179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dmBfFa1okgL8mK6WpRu2kczX17zWDHtWXMl37dV2NG8=;
        b=GeLcyculw4muJ8iWPI1MzbbGOnkR3O7gNoD+cNL/NQhoiHqbejNIajeejhDwhZ1t8Krnxa
        ebkbRKFIf1pZhH1NmEWo1yiOjbtYpQDjkGB4DwY0rRcFaPTyXt8tis92TO84FfvE+N/Jgf
        B2LWHiIbjq/dkUspI4FkXYlhWoakFIs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-H0nC1WT6NSCs9d3XAnxG7Q-1; Tue, 09 Jun 2020 04:09:37 -0400
X-MC-Unique: H0nC1WT6NSCs9d3XAnxG7Q-1
Received: by mail-wr1-f71.google.com with SMTP id i6so6667388wrr.23
        for <kvm@vger.kernel.org>; Tue, 09 Jun 2020 01:09:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dmBfFa1okgL8mK6WpRu2kczX17zWDHtWXMl37dV2NG8=;
        b=tFMVksYkv9zY0j8hGGjEc78SM8ZMekYUrlwDqdTZfB0VAg8R/veVjIMNpDfZDvj6TR
         Ke5klCqpnwJCCNJta/1DCiNrvmJ3saZhdOk4Da7oq1hEgtIkJebDmG6wm3OdFLs5eJhS
         J6iRnnuV98Cca/rtLrcVg6ZHvKGuT8WcbVEdbZonZ0DF89FiYLyeGTuo5ctALRw8Pzrx
         oBQctB459VPxcF3RZOcg1pFQFEY42Uf3NWkR7TgNyjeDS5Sotbw9dVyPtZCrYwQNRmVp
         xRzjjWIa0j9R/o0shKV6zbyMNsFPXJ98/b78bZJaBYi950bz+bpxXIC4UKzOvvH2G5lV
         3aEg==
X-Gm-Message-State: AOAM530anNttyppBgPyFJpZyJyQC8z9lCXB96j4kfwZfFsqmWDCjuyBG
        w+RExTHpS3cao4EJIIt92bym27myH/onUNw87LNfRIHhv6zo5BIXuHJ1YlspLgXVhWRtxg1+LZv
        aTgPJ6ofEEirK
X-Received: by 2002:a1c:b654:: with SMTP id g81mr2738168wmf.128.1591690176235;
        Tue, 09 Jun 2020 01:09:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZUyacbcjJw4tmav0I1ZZnOB3ijdGOGFXBb6eJoHNcLp5aBfqt/RQaHL3CrTNgSXo1NaZNWA==
X-Received: by 2002:a1c:b654:: with SMTP id g81mr2738142wmf.128.1591690175960;
        Tue, 09 Jun 2020 01:09:35 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.172.168])
        by smtp.gmail.com with ESMTPSA id w15sm2030017wmk.30.2020.06.09.01.09.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2020 01:09:35 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: fix calls to is_intercept
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Qian Cai <cai@lca.pw>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200608121428.9214-1-pbonzini@redhat.com>
 <87wo4hbu0q.fsf@vitty.brq.redhat.com>
 <500129791dd00349acb5919d75fa9de7e0c112d1.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <196ae774-7237-94b7-3b50-399571f255d8@redhat.com>
Date:   Tue, 9 Jun 2020 10:09:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <500129791dd00349acb5919d75fa9de7e0c112d1.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/20 09:30, Maxim Levitsky wrote:
> And if I understand correctly that bug didn't affect anything I tested
> because your recent patches started to avoid the usage of the interrupt
> window unless L1 clears the usage of the interrupt intercept which is
> rare.
> 
> Looks correct to me, and I guess this could have being avoided have C
> enforced the enumeration types.

Yes, another possibility could be to unify SVM_EXIT_* and INTERCEPT_*
enums.  For example we could have something like

	union {
		u32 all[5];
		struct {
			u32 cr, dr, exceptions;
		};
	} intercept;

and use __set/clear/test_bit_le() in set/clr/is_intercept.

Paolo

