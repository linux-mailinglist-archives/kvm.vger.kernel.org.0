Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40012269A52
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 02:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgIOASp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 20:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgIOASf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 20:18:35 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1941FC061788
        for <kvm@vger.kernel.org>; Mon, 14 Sep 2020 17:18:34 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id m7so1902688oie.0
        for <kvm@vger.kernel.org>; Mon, 14 Sep 2020 17:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KhgVcsHc94obbDVKUJ+qEP3xCNWjV0/BWSFoFHTkB/8=;
        b=h7LWvYjhOGcy3EICRanM/5wdiE9GI46hq2Za41F6+EThsb9BvKvctAFwH2T1mVxz8J
         S3xhDaG5idt/GUhINYBwzl15Lddx49T3qODRmgUVoDZ0meI6LJqwreLrydsBcro1XPQE
         WT7HAZiWLzQ+EA3DgTVM3naw/DqTSbRQC0pPiXvp/WHACA8Ez5+xIqu4nwQNMtu14Nkl
         0/SWNkxELjiF7fMRAd17leV3pqHsBGLDbytFzcR7nUrD4yKxYajktndviOOLh5vj+CCu
         Lkg1jIzjo3XdA4NNJeMinEOJm7M+MPrsFFdpvPHEWE9r0fPOS9TuYirZSQa0hQ/6lvzO
         mpVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KhgVcsHc94obbDVKUJ+qEP3xCNWjV0/BWSFoFHTkB/8=;
        b=nhx8dXAro6vpckOYwGcTeoNbawf2xUzLb+y5F4XmMya44RWX7AD5rPOk8xtVTzNc2k
         18RIFjRtQkDSpwACajePCltK6sTgUov/ap+bb49Ntp8Idgb43X5qAGbZ7EpDUNS7Fidj
         nO3YHMp2bi3ZZ34f8/CkPmDXdAiNIQQrgGGUIPD58uUKE1UFzlETqZ4IG6336uRt12Ov
         sjS0j7j258u1n95UxCh2Hc6lmrE6I8hkTqdZsIt3MP1QVpURhX43mLsbmDnRc0Fx5UZH
         A2cek289ts0B8vx1xkjNf67lS2WHcyMO96vuO1iqeDUSVSZvf1AVPJYiuUJCkGip0dCf
         9iAg==
X-Gm-Message-State: AOAM5333y0e1UZSNy/0+qpcYMjEIbbhVYhbKeaDVKdeM8gnT+toOYqOt
        GVwiziRcUZsF11GeWKhia2LU5COYChvtewdGDrbV3g==
X-Google-Smtp-Source: ABdhPJwI7HlaEKNiJPcVHgyyTKZUO2cKXcEotIgiKgDwqGQovNQyURDUfqZBTWLrwzkw4BfvjDYWk80WP7Bm63A9q7s=
X-Received: by 2002:aca:4b12:: with SMTP id y18mr1380754oia.28.1600129107145;
 Mon, 14 Sep 2020 17:18:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200829005720.5325-1-krish.sadhukhan@oracle.com>
 <CALMp9eSiB=NkuZJV+m-j-KcxqVzkqTf5fUS7r9vBSaY8TyK_Rg@mail.gmail.com> <a825c6db-cf50-9189-ceee-e57b2d64d585@redhat.com>
In-Reply-To: <a825c6db-cf50-9189-ceee-e57b2d64d585@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 14 Sep 2020 17:18:15 -0700
Message-ID: <CALMp9eTUT-tsGu0gfVcR8VTcq7aVH87PsegnsbU6TXOoLHkfMA@mail.gmail.com>
Subject: Re: [PATCH] nSVM: Add a test for the P (present) bit in NPT entry
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 11, 2020 at 8:36 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 31/08/20 23:55, Jim Mattson wrote:
> > Moreover, older AMD hardware never sets bits 32 or 33 at all.
>
> Interesting, I didn't know this.  Is it documented at all?

You'll have to find an old version of the APM. For example, see page
56 of http://www.0x04.net/doc/amd/33047.pdf (this was back when SVM
was a separate document).
