Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDC21F5D69
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 22:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgFJUxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 16:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgFJUxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 16:53:52 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EC6C03E96B
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 13:53:52 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id y11so4261640ljm.9
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 13:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wkhkcPvpAeE4x4kAO1HjblduVWOEiZ+eHHO4eca07FY=;
        b=IgN05Fh0uREALZZU/s8t66dRm0ApTxlnvcL6Nnx/SwIGy9zTKN1m9HDCNywJFvcZ2U
         1xEVjk51dwqTD6l0sgKb+Vtjqr4s6SbTFzUJ0kDAKBXdGB7diNzJzQphVdL+BPgjm0Ga
         CNO9Wx8KMuwTuBeK1fJ+X3/7/j11L4DzwfyzA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wkhkcPvpAeE4x4kAO1HjblduVWOEiZ+eHHO4eca07FY=;
        b=K1u+bXYBMhYzwF/K/REFjfAriVcndaI61ZSRFunKHV9TN0gT2qsvc2CYvdED+6z8eP
         iaNxLTF5yt7LYNInHXRIk6zqBCkLdk3ml8IVyofg/PHLF/ks11AV1spGQE7qGKg+Uu+A
         q4TrIrcMnVzlKj/b8mXdNHierq30NzMqAgKqYiGiLZGqLnowK0/mN2LA+mjlw6ChovWU
         k7pR7gwK2IcaCeiRhKdNOSpORj4aZoYE6gGQvj1UwDP1lGxK1keHuwegX+ZNRa26cWMd
         WoB1yROCdeeiyMIXkpcbbneD5yZtTL7atP2ia4+1s0WpSo/yyxiIKlrAYckKEENxVZeK
         O1+A==
X-Gm-Message-State: AOAM532Iu/b+XNxXRTVqZzavulGEkuya5hyy8TD7dFSKtdG+By0HHgvm
        W04JuGq8y/4sPEf/IWjB1h4Vs+7Y2v0=
X-Google-Smtp-Source: ABdhPJyH+jRtdoRAoMDSlYtPmvQFHSG5Txodgcu6XjfapqmgHYt0h94x3z2VEdZNlct941IGPFnNMQ==
X-Received: by 2002:a2e:911:: with SMTP id 17mr2820841ljj.411.1591822430350;
        Wed, 10 Jun 2020 13:53:50 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id c78sm265792lfd.63.2020.06.10.13.53.49
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 13:53:50 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id r125so2244489lff.13
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 13:53:49 -0700 (PDT)
X-Received: by 2002:a2e:b5d7:: with SMTP id g23mr2510079ljn.70.1591822118508;
 Wed, 10 Jun 2020 13:48:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200610004455-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200610004455-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 10 Jun 2020 13:48:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiyR6X=SkHXMM3BWcePBryF4pmBNYMFWAnz5CfZwAp_Wg@mail.gmail.com>
Message-ID: <CAHk-=wiyR6X=SkHXMM3BWcePBryF4pmBNYMFWAnz5CfZwAp_Wg@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: features, fixes
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        anshuman.khandual@arm.com, anthony.yznaga@oracle.com,
        arei.gonglei@huawei.com, Qian Cai <cai@lca.pw>,
        clabbe@baylibre.com, Dan Williams <dan.j.williams@intel.com>,
        David Miller <davem@davemloft.net>,
        David Hildenbrand <david@redhat.com>, dyoung@redhat.com,
        Markus Elfring <elfring@users.sourceforge.net>,
        Alexander Potapenko <glider@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        guennadi.liakhovetski@linux.intel.com,
        Johannes Weiner <hannes@cmpxchg.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, hulkci@huawei.com,
        imammedo@redhat.com, Jason Wang <jasowang@redhat.com>,
        Juergen Gross <jgross@suse.com>, kernelfans@gmail.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <lenb@kernel.org>, lingshan.zhu@intel.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel test robot <lkp@intel.com>, longpeng2@huawei.com,
        matej.genci@nutanix.com, Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>, osalvador@suse.com,
        Oscar Salvador <osalvador@suse.de>,
        pankaj.gupta.linux@gmail.com, pasha.tatashin@soleen.com,
        Pasha Tatashin <pavel.tatashin@microsoft.com>,
        Rafael Wysocki <rafael@kernel.org>,
        Wei Yang <richard.weiyang@gmail.com>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        Mike Rapoport <rppt@linux.ibm.com>,
        stable <stable@vger.kernel.org>, stefanha@redhat.com,
        teawaterz@linux.alibaba.com, Vlastimil Babka <vbabka@suse.cz>,
        zou_wei@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 9, 2020 at 9:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
>   I also upgraded the machine I used to sign
> the tag (didn't change the key) - hope the signature is still ok. If not
> pls let me know!

All looks normal as far as I can tell,

                Linus
