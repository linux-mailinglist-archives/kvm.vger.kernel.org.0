Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D09C40169A
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 08:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbhIFGva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 02:51:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239796AbhIFGv2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 02:51:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630911024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aypnITcWlLv4lCfRDaFN+Jti+hI0KIdPR67H8ACIpZ4=;
        b=HEbhdMxcEspjdqlL+xj5YAqB1RjIKrWvZ5tPJwaB/3NFaepMR7QK033II4kbWwI5pAI6fC
        fHhCQeVnvOgOk1fC8psFRQcxZOBHbSxs9ePArWiYf3kcRDlxz9p2tmn/gKmMBHZ43ELJPJ
        RaGxzLci9WN2dPCJvrN/H7BDwZr+Al8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-aG7PgguUPQWM8NjuC4_Wkw-1; Mon, 06 Sep 2021 02:50:22 -0400
X-MC-Unique: aG7PgguUPQWM8NjuC4_Wkw-1
Received: by mail-ed1-f71.google.com with SMTP id o11-20020a056402038b00b003c9e6fd522bso3066801edv.19
        for <kvm@vger.kernel.org>; Sun, 05 Sep 2021 23:50:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aypnITcWlLv4lCfRDaFN+Jti+hI0KIdPR67H8ACIpZ4=;
        b=l1YB0YrWuDxKVtrsx8AuAnxV++B1sDnz+6lsdq2ej/ChfjQkVroNcfPEgTOMp7DNz+
         u0Z+xDowP2bOJqV8HvxtvUrD2gI9RnvTG0xj8E67MWmZMElXU5BdIte56Q7f4sg0V2f0
         x7AL/1el8ISlau/QVktywKZUxgGG7EYxDxM5XDB/NsKrCIKJwP6wDpu4Lc3T4thYD/pj
         7DNO3+SieHqk1PIBIBn1wG/o7Kq6N2pq0KTRV9Na6ZqknyReMSNLE52kGW/EhpNKe57I
         vWVaarVKPqwnUedcDk8Bw0Uc2Wr4FozkA+0FDbXQmLZVaZdLNIUW7axRyo8hKi4pd886
         zUgg==
X-Gm-Message-State: AOAM533hgcy8GGG303Mm+6XAwxuaBPLAF4yjCGkQAjdsfqjBbimp1QRv
        EyHuJqWVm+FW7psYrOi1t2M7eRrcPeWClzc99Jt25I0qiL4rFr59OpW2qiAd+OXL6sLM4ujr+Ad
        PyqcUtLDk4juM
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr11963679ejc.69.1630911021492;
        Sun, 05 Sep 2021 23:50:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFIYjYkzsq7JAWCJ17zM3GVn179l8k5sV9FWmnoDh3D865k+M2BuOeZrF4Haf7EvH4sDARIg==
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr11963663ejc.69.1630911021357;
        Sun, 05 Sep 2021 23:50:21 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id b15sm3305728ejq.83.2021.09.05.23.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 23:50:21 -0700 (PDT)
Date:   Mon, 6 Sep 2021 08:50:19 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        maciej.szmigiero@oracle.com, maz@kernel.org, oupton@google.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH 1/2] KVM: selftests: make memslot_perf_test arch
 independent
Message-ID: <20210906065019.mdlqorvyqizdrksd@gator.home>
References: <20210903231154.25091-1-ricarkol@google.com>
 <20210903231154.25091-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903231154.25091-2-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021 at 04:11:53PM -0700, Ricardo Koller wrote:
> memslot_perf_test uses ucalls for synchronization between guest and
> host. Ucalls API is architecture independent: tests do not need know
> what kind of exit they generate on a specific arch.  More specifically,
> there is no need to check whether an exit is KVM_EXIT_IO in x86 for the
> host to know that the exit is ucall related, as get_ucall() already
> makes that check.
> 
> Change memslot_perf_test to not require specifying what exit does a
> ucall generate. Also add a missing ucall_init.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/memslot_perf_test.c | 56 +++++++++++--------
>  1 file changed, 34 insertions(+), 22 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

