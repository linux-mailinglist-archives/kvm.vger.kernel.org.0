Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC541215C66
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 18:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgGFQ6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 12:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729384AbgGFQ6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 12:58:42 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9933C061755
        for <kvm@vger.kernel.org>; Mon,  6 Jul 2020 09:58:42 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t18so13585613ilh.2
        for <kvm@vger.kernel.org>; Mon, 06 Jul 2020 09:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I148QVWGSnT8aY3ZhwEgh0p5Ry6vnMwPKgHHHUUvL9M=;
        b=cGmcxhhmu13xy6h9ZWRk47I/f6CoSYXPtfKePKEuc+4DwnIsl3Uwq6jqYdgkv4p++P
         mw83r0VuIcfkjv+5tdkFOJdttzoJEEjQNIeVfWXuJJCIMmIBCLedztU0D8DRHcOCxhb0
         MAA7q3t8KImhJTvanicotZdnsHotjViivVZRSCrXQzhnTM14wottw5ZBOeNPUeojOiQZ
         ZVTkctCOWEX2sXoYdaST2ihAenxVJRJH6qZCyBM0QKcNeFc0v+3D0xV5k0uKkwdFw47R
         qjGjtfbGPUja7G7fbMAcAFODfFSO/G7nOhZ1mrcb4wmyMTtUUZEQKn2mdPNvq0ZguwKL
         /AWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I148QVWGSnT8aY3ZhwEgh0p5Ry6vnMwPKgHHHUUvL9M=;
        b=n//0g2Ejx4gc9Ngcnxpr7jqyPeecbHuop5ab+rP/zWUCZAuDiKS11d8DucSn7hNdBJ
         pYDx76BkCrKFMm5GZ+y4NEVatJK8rsoNXYSj7UjJXo7m3wHVTbEMX49Gpl6X6VD6nZil
         fbr3BUHMDqvWdGsVogIYzwq4N4mOakUD2pvVYgUvqZldGm2krq1Aw2tDvr+YDR2KeNZD
         sh8xJ2h0unWFhYOoVGH4GOLcYNfqq4ARU3963sbHVk5/2Uc4b0jGYtjjLSF0O91Z3Zeh
         bJziunoI3GKM1t/d2FJRqKoCp9/Ceokev71yCgQ5Aby6SDdH4rgjZagcSai0ov2evQsZ
         lydg==
X-Gm-Message-State: AOAM532pCnAqu9q43Fi4zb8VShMMn8s9QH8DnP3OHm8dk2vb/aPPXXdx
        cy9u6fZM6mcv1uZPGaPmLbQ+Ki5dIIuUbMlm5px+xw==
X-Google-Smtp-Source: ABdhPJyhImZRgfT2TwZNlaX0aHjl0BeC+SH38/q9BTrKivgZ9aZJQeEHgi7e4XwOvuLOx5mxrHFvyjJveEok8fiWtXI=
X-Received: by 2002:a92:b685:: with SMTP id m5mr31643812ill.118.1594054721868;
 Mon, 06 Jul 2020 09:58:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200706164324.81123-1-imbrenda@linux.ibm.com> <20200706164324.81123-3-imbrenda@linux.ibm.com>
In-Reply-To: <20200706164324.81123-3-imbrenda@linux.ibm.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jul 2020 09:58:30 -0700
Message-ID: <CALMp9eSzbPiN_nCH7pVGKADkEFyXoo7pfVFj06zms6TrGahcXw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/4] lib/alloc_page: change some
 parameter types
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
> For size parameters, size_t is probably semantically more appropriate
> than unsigned long (although they map to the same value).
>
> For order, unsigned long is just too big. Also, get_order returns an
> unsigned int anyway.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
