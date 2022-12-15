Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214A964E3A1
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 23:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiLOWKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 17:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiLOWKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 17:10:44 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC66660D5;
        Thu, 15 Dec 2022 14:10:41 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id g10so404346plo.11;
        Thu, 15 Dec 2022 14:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eBqqWBko6lQhmmKy2O6HdShYMXa+V0zYB+4SIox4AvE=;
        b=W05t2VJBYYIMY5AOhsbNEtsIxfpd9VdaxQPdlNUO1dPRqJ6bkWHP8j639NKsLWNeqc
         1yPqpIAZ3oBi+cEIrLYibOpF2gdOvZd1KYtC0x3Y9zaAFCyCSaObD3LX1BzogmVw2OK+
         q7HmsjowWhak/Vc6BCEHGvusSOo2/cO/MMnps+2XzU+y1MdAAT0D3zXrAwucwPcro6LB
         V5L3DOTq7Qm5SRXp3BXpFBCuYQ5jHnKoVfAqhUFwc4bPEiPKlbgi3R4XgURnbIcEcQzs
         W3hoZC57cGcyI/DDuyfmfyoi9kf9wOyVyv8Hg3L7zglochwPbGrJyxF346ty3RueZvDi
         RJlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eBqqWBko6lQhmmKy2O6HdShYMXa+V0zYB+4SIox4AvE=;
        b=IgvNmU3Ka7fQp1qinTa/+MQA7PxsjeRI8WLW/xdhNNkhpMiqcMLML5Fhqxc87aHgYj
         +2lCzVir3Z83uHMnWoihtgDIJEzRzo1Nl3UbnwpdNKH5eclFqLquIr4EgVFKFg0f/xm9
         6AC5vhoyw5R4nQkVq7wQlxnr6LZGdvxRzLiR0gfog4b4Z2jKm+KF8WHj4u5Qm/WW8zL1
         MffhRp5tTLy0/Jp5MXLDHAgmVQy4wtJaj1pq00KHP41YRKyWIO8PvGO7x1s4BlkCddNv
         6sAdrdhBTc11tVzwRDtUeo6RH+lWuB87iS6j/6FGaD821OqRN/AOi1PxNf7fWf1ZnzQm
         8CtQ==
X-Gm-Message-State: ANoB5pm7xddqqjxeMfCbxPuL5BRYRdfcENIVjuxN+TA0pSc1roNHFZ1j
        ZyR6EFQb8GYvTT94eS0Qj7o=
X-Google-Smtp-Source: AA0mqf5IGb5ZmhWFeEwqCEq2jYw83hlOuDNX0mC6OJrUJn7rMOsKQjKiX4yMxbfQCrdE4EvMtfQ7pQ==
X-Received: by 2002:a17:902:e884:b0:18f:ac9f:29f6 with SMTP id w4-20020a170902e88400b0018fac9f29f6mr23844579plg.50.1671142240799;
        Thu, 15 Dec 2022 14:10:40 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id e5-20020a170902784500b001782aab6318sm135300pln.68.2022.12.15.14.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 14:10:40 -0800 (PST)
Date:   Thu, 15 Dec 2022 14:10:38 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v10 046/108] KVM: Add flags to struct kvm_gfn_range
Message-ID: <20221215221038.GH3632095@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <880c1016c29624964baee580985b6a736fc7d656.1667110240.git.isaku.yamahata@intel.com>
 <ce1b2bc760daf9cc07591bdc4d3e83e40391f468.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ce1b2bc760daf9cc07591bdc4d3e83e40391f468.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 10:51:31AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Sat, 2022-10-29 at 23:22 -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > kvm_unmap_gfn_range() needs to know the reason of the callback for TDX.
> > mmu notifier, set memattr ioctl or restrictedmem notifier.  Based on the
> > reason, TDX changes the behavior.  For mmu notifier, it's the operation on
> > shared memory slot to zap shared PTE.  For set memattr, private<->shared
> > conversion, zap the original PTE.  For restrictedmem, it's a hint that TDX
> > can ignore.
> 
> Could you elaborate why restricted memfd notifier can be ignored? IIUC if
> userspace punch a hole, the pages within the hole will be de-allocated.  So why
> can such notifier be ignored?

Because set-memory-attribute ioctl is expected to follow the callback from
restrictedmem.  So set memory attributes can do de-allocation. I wanted to avoid
zapping twice.

With v9 UPM, the restrictedmem callback was triggered for both allocation and
punch-hole.
With v10 UPM, the callback is triggered only for punch-hole. With v10 callback
semantics, probably this can be cleaned up slightly.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
