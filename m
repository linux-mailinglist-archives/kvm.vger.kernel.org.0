Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E61A215C5B
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 18:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbgGFQ5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 12:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbgGFQ5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 12:57:12 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B85FC061755
        for <kvm@vger.kernel.org>; Mon,  6 Jul 2020 09:57:12 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id v6so26428864iob.4
        for <kvm@vger.kernel.org>; Mon, 06 Jul 2020 09:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nDn9vPn5GINPXREDIdRWJG8bKIAtOxgg0iX2CEr6z0A=;
        b=cLKHl2NcYyQK7yYRfELGyHOVwgYuZM0agJW2RJsTpQQ+/kivi1YYYW99XFVcmWuW0A
         vZswRqV5OUlU88mBqAJgBTxe9QVKFv9mNCPWvvlMW/eeVE4EZ/zOVwUL3Du/02mQgHWL
         1KKlMUFDBFRfPTzdNS1q6bUMzvhp7WE5lSiNWOvKo89+QLIQ0+lagdvPMcqBUwdVAV/i
         QdyDXcjFsIHgDF3vUtTCSOSunHFNXqtVz+iB1pi9VmbhIA+dm2zh3GSwDrM5Wtr86xDJ
         60iLp9dxbQUpmKQnd5DL7b9pYbK2On6WNedEw1HzCwXT7a6iA4dMOFEAmOieSu837qaF
         EdOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nDn9vPn5GINPXREDIdRWJG8bKIAtOxgg0iX2CEr6z0A=;
        b=pjejQbs+hEuCT+HSvrH2PaIpRi69a4p8kYPuwlATLfkAHgb52gYx3k9Ax2CB+NiJDE
         UPDjH81UObXHg9+GuMpvbSjuOWxo06TnVCXycw75ProANBsn6sCKH/v6eVaAo4LJs9e9
         6C6dQIfXpFPU93ol3pds0gf4pXJmhdOufjw73RmCPFkEkaj+BGQX/ssSNEgNoVQeF++F
         nkG0n9jU8ddC2NthQBMQw2cnhhU9CC0ni8/8TJYV74WfNMHnYu1QrxmvXuNf2iu0q0+g
         z5/F7CZgFrtSmD+2nNrrEMfDJCzo3bkPhL5lpWSLvtBUe7JtaPGO7SMnkhUJDt0JmCKu
         Wk1w==
X-Gm-Message-State: AOAM531bKCT5JScdF2Bpp46+blzrCmgStudfEhoHIOLQ6XmT+sU+aL8K
        8zMJ4DZnwd2bnNbHXaeQJTG7smEbGLBxUU+Gugi9xA==
X-Google-Smtp-Source: ABdhPJzUCqvVAXix9A09hBd+8Kkqa59oJxn322M7478w21b3F5JnhKfMFMuvkeIqXTqlGY1Tl7HRecgHmArTrBMh0gY=
X-Received: by 2002:a05:6602:2e0e:: with SMTP id o14mr26317253iow.164.1594054631147;
 Mon, 06 Jul 2020 09:57:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200706164324.81123-1-imbrenda@linux.ibm.com> <20200706164324.81123-2-imbrenda@linux.ibm.com>
In-Reply-To: <20200706164324.81123-2-imbrenda@linux.ibm.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jul 2020 09:57:00 -0700
Message-ID: <CALMp9eTkMxZSgZXOY15QMo1gtbvEW1Y=OwMKppAMu10D9QYJnQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/4] lib/vmalloc: fix pages count local
 variable to be size_t
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, frankja@linux.ibm.com,
        thuth@redhat.com, David Hildenbrand <david@redhat.com>,
        drjones@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 6, 2020 at 9:43 AM Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:
>
> Since size is of type size_t, size >> PAGE_SHIFT might still be too big
> for a normal unsigned int.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
