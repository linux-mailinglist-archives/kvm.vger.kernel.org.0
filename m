Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E02C40D4A0
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 10:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbhIPIfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 04:35:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40929 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235069AbhIPIfy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Sep 2021 04:35:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631781273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ysgxFh+Uq2Xc4lpxlU3Gi7GGna/jURbkzsCYWw4VARM=;
        b=fgd6oFW783/t2HkdyLUkl8Lsg6T+BPQ4dAMSjdlPbKb2rRm8aBiY5UiqHPf1g1e2UsxlCT
        f+ZowyEve8iu+Hcg1F7syAnlj51920tK9NM9A363uGnetsSrUy4ENlBifcb4P7FrjjlwY0
        PbrjPBj4pE/aQJoEFQW1TKGQUwJrS/4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-MoedIpDbN0aldEBd_UvpaA-1; Thu, 16 Sep 2021 04:34:32 -0400
X-MC-Unique: MoedIpDbN0aldEBd_UvpaA-1
Received: by mail-ed1-f69.google.com with SMTP id o23-20020a509b17000000b003d739e2931dso2927887edi.4
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 01:34:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ysgxFh+Uq2Xc4lpxlU3Gi7GGna/jURbkzsCYWw4VARM=;
        b=IhtBfbR6Vdaz1Y2Opg0QGF9jWnidH7AtNIR4vjBgrs0b9jWvihqVAl6h7vG4HDwp0d
         Bgq5hQxNegAN0CD4s5dAcE8QzjIVn3Q5y7gk7Ljapn/qRCXM9cNqHe3YqyD6UZgjR4n7
         75T78EImpaVLVd6EP3pqBpxaDT4QQ4I0jmxpISM95wI5ppxh/5YDlf5GbfQPcuw/yeVq
         q62XKtIeJvnbCCcy+B9x3W9gz6Q9Rd5Xf8O650p3edONZZxE0YP/dz1wIBDeNDvKJ84B
         Rwda1lsEsha4R5lB6BfiDs9cfbL/jhGsgGbo6I97V1+wqYJ0qjGRDZHq3zU1+8XAxRLi
         vzmg==
X-Gm-Message-State: AOAM531CI2GVSCPgCb8ud+pxGx9QU0IqoakaC67zq8o1iMFhvH/7Sn0D
        GyG7qs/MLdCO4mRCSBbbqBslsalzl0zAIymSweXpWg0ptTcjOg0yFFDq6tbq9WFotXss2fKu7pq
        ufsod3H/TDSX4
X-Received: by 2002:a50:d84c:: with SMTP id v12mr5084703edj.203.1631781271441;
        Thu, 16 Sep 2021 01:34:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4/W8Bt0P12BC1fBHHvgQVlm/tm55MGjLwhcze3VUm+n6sGA1LHo1TEnQqUl7eTNVymjGErQ==
X-Received: by 2002:a50:d84c:: with SMTP id v12mr5084693edj.203.1631781271271;
        Thu, 16 Sep 2021 01:34:31 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id t24sm1090758edr.84.2021.09.16.01.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 01:34:30 -0700 (PDT)
Date:   Thu, 16 Sep 2021 10:34:28 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>
Subject: Re: [PATCH 1/3] KVM: selftests: Change backing_src flag to -s in
 demand_paging_test
Message-ID: <20210916083428.tkocvvhdlugrts7t@gator.home>
References: <20210915213034.1613552-1-dmatlack@google.com>
 <20210915213034.1613552-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915213034.1613552-2-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021 at 09:30:32PM +0000, David Matlack wrote:
> Every other KVM selftest uses -s for the backing_src, so switch
> demand_paging_test to match.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  tools/testing/selftests/kvm/demand_paging_test.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

