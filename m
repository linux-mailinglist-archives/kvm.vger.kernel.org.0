Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92523397BEE
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 23:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbhFAVzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 17:55:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21050 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234698AbhFAVzu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 17:55:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622584447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TLmTFs79Kk/HdqD2U3Jsivs3GJU2uRn31j0/SZFo+5Y=;
        b=CZz+aERLjfH5M645R6+VPZh+PxvBh/Fpg2G7nFz0Nodw0KtVSox8uvTNnJAlcLKAbS+gq+
        la2xgZ83+TN9fNNev+og522oiX9mvbvJDd9pGA/rGR8lPimbFNMBI3w9Cicw135LMGGTt4
        q/B/dXfJR0JRU1lFDkk8klWQzksv4eo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-_jN1rs2aMiqh_DH2_CK8Lw-1; Tue, 01 Jun 2021 17:54:06 -0400
X-MC-Unique: _jN1rs2aMiqh_DH2_CK8Lw-1
Received: by mail-qk1-f198.google.com with SMTP id u9-20020a05620a4549b02902e956c2a3c8so184015qkp.20
        for <kvm@vger.kernel.org>; Tue, 01 Jun 2021 14:54:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=TLmTFs79Kk/HdqD2U3Jsivs3GJU2uRn31j0/SZFo+5Y=;
        b=suXMXML5r9I+1vL9nPcAe9C2cHYLfomXVwFu1boZJhj7aSBWDb6faREgPXbvdN/WKn
         YX6m4mEkUAtYWdrHNp+BM5yPolauVibZ/ikyYjo+dst++6sgMAsSViw+b/T3/b+zLPCG
         vI6cvo1dSnsmtLvjR+g4PZ5mZzc/KW0dAqLoG7f3hG+lkCZgM219pcjp6DmSp4SPr+dn
         Et6WD+9JdxxfekdEm81t/6M1SvjzlJ+l3/ZzUAbDCkWfSnR52xl5sBd9Md59JKo+86so
         ChXWwEJzJmp5gL4MijQUQ2vYuzIQ6YblwM69LgIIf3vyZH7WorUDPOFulrF6yVsuB2tH
         0aeA==
X-Gm-Message-State: AOAM533mgk5Ds3QVMjePo4WYaHg94a28LkxykE8ibrJl8yufmA5vZJcV
        XRSlos0dWnlFMImQXXzhWayRlu2LumRom0ztadRW9R2v+srHQ+jYPOZwjdwRfRSgrHiCWZ/mz+g
        aM0RnYGAzmC7a
X-Received: by 2002:ac8:698b:: with SMTP id o11mr12834843qtq.148.1622584445794;
        Tue, 01 Jun 2021 14:54:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzw3PnREwzRNFGSUnTvVgUPY8IkQ4jACsTTBjVGul0hqJfwLurKsrUBHidzwlCZJ8f3TECqFA==
X-Received: by 2002:ac8:698b:: with SMTP id o11mr12834820qtq.148.1622584445481;
        Tue, 01 Jun 2021 14:54:05 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-61-184-147-118-108.dsl.bell.ca. [184.147.118.108])
        by smtp.gmail.com with ESMTPSA id i1sm11121297qtg.81.2021.06.01.14.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 14:54:04 -0700 (PDT)
Date:   Tue, 1 Jun 2021 17:54:03 -0400
From:   Peter Xu <peterx@redhat.com>
To:     huangy81@chinatelecom.cn
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Chuan Zheng <zhengchuan@huawei.com>
Subject: Re: [PATCH v1 0/6] support dirtyrate at the granualrity of vcpu
Message-ID: <YLase9l34N7i1C6S@t490s>
References: <cover.1622479161.git.huangy81@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1622479161.git.huangy81@chinatelecom.cn>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 01, 2021 at 01:02:45AM +0800, huangy81@chinatelecom.cn wrote:
> From: Hyman Huang(黄勇) <huangy81@chinatelecom.cn>
> 
> Since the Dirty Ring on QEMU part has been merged recently, how to use
> this feature is under consideration.
> 
> In the scene of migration, it is valuable to provide a more accurante
> interface to track dirty memory than existing one, so that the upper
> layer application can make a wise decision, or whatever. More importantly,
> dirtyrate info at the granualrity of vcpu could provide a possibility to
> make migration convergent by imposing restriction on vcpu. With Dirty
> Ring, we can calculate dirtyrate efficiently and cheaply.
> 
> The old interface implemented by sampling pages, it consumes cpu 
> resource, and the larger guest memory size become, the more cpu resource
> it consumes, namely, hard to scale. New interface has no such drawback.

Yong,

Thanks for working on this!

Some high-level comments:

- The layout of the patch looks a bit odd.  E.g., you introduced the new "vcpu"
  qmp parameter in patch 3, however it's not yet implemented, meanwhile I feel
  like you squashed mostly all the rest into patch 6.  It's okay to use a
  single big patch, but IMHO better to not declare that flag in QMP before it's
  working, so ideally that should be the last patch to do that.

  From that POV: patch 1/2/4 look ok to be separated; perhaps squash patch
  3/5/6 into one single patch to enable the new method as the last one?

- You used "vcpu" across the patchset to show the per-vcpu new method.  Shall
  we rename it globally to "per_vcpu" or "vcpu_based"?  A raw "vcpu" looks more
  like a struct pointer not a boolean.

- Using memory_global_dirty_log_start|stop() may not be wise too IMHO, at least
  we need to make sure it's not during migration, otherwise we could call the
  stop() before migration ends then that'll be a problem..

  Maybe we can start to make global_dirty_log a bitmask? Then we define:

    GLOBAL_DIRTY_MIGRATION
    GLOBAL_DIRTY_DIRTY_RATE

  All references to global_dirty_log should mostly be untouched because any bit
  set there should justify that global dirty logging is enabled (either for
  migration or for dirty rate measurement).

  Migration starting half-way of dirty rate measurement seems okay too even
  taking things like init-all-set into account, afaict.. as long as dirty rate
  code never touches the qemu dirty bitmap, but only do the accounting when
  collecting the pages...

  Feel free to think more about it on any other potential conflict with
  migration, but in general seems working to me.

- Would you consider picking up my HMP patch and let HMP work from the 1st day?

- Please Cc the author of dirty rate too (Chuan Zheng <zhengchuan@huawei.com>),
  while I already started to do so in this email.

Thanks,

-- 
Peter Xu

