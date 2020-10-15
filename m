Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636D428EBB5
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 05:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730298AbgJODoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 23:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbgJODoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 23:44:17 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E76EC061755
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 20:44:16 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id p15so1631146ljj.8
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 20:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HHTEFLARrai9jAcwvYx9rODqAnP/mRVKE4w7Ff4URe4=;
        b=qfZILCfxkUpQvE6YU3Z9UodjGZTM49N99Qs09Qi/4D5OgMHut9bruj5fsGafj+WSqd
         IzSk2arafb2CF6N468LF2DMB9Ru6VOsUrx9OcRJnPaGGsxkEQlQEFe5Iruz9ANnaL6qo
         bFrI68ljv6tVt4AR+c/yd/G4suzPxvqoS+5sfzfdLVbRfwnsTEhIx5p60B2AylA92DYL
         lKwZtP2S8JaHJAQeuulu5cQ2npU0PtTcVhmbsSsDcsjyI4LIW95dIePKGAen64iJDxMS
         7/cvyDiaoN5ikqwUy82WUUjLha/tTcqc+TG96F+SsaIDxH6/WVUQR1Xu7K80mlEnsf3P
         mf3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HHTEFLARrai9jAcwvYx9rODqAnP/mRVKE4w7Ff4URe4=;
        b=ttCwmvvPVY3Mu732UAx9nqLfCKjqip2a6v54Gs5T66aWRN2clzPqU0cqchVh0NQXH9
         CMman4ZSeco6ZC9zNYLdAEwMhi7yP/Wu6hxmO6qlQd1GvhDnyZnH6b9YWE48GKO648Z1
         mizOHHTVI9pJ28etWaylE1h7gq+a3u0r4qnLckcHwyFkortf7wz/k630XV32v4DvXelZ
         Kxvhj+NOxo2Q9RFS8rNwR2KoMVWOAooQgnJBwIg+6FGXHWe2sPjlZJYPpI2ABVC+suVu
         JoTq14oXhzbto65O3cyYC73BWwGx8fMLqqKog+QPrOV6JSudOsXoODj526DFhp34Y9Nt
         tgQQ==
X-Gm-Message-State: AOAM531J1okavP0Z9weDRxzCUeqV8p6UyE0Jvbx2pM+lI+bTudS2rddu
        vubeFOs6xAdwq+OmYOdu+Dd9QvqnWQvmg6FfDzA=
X-Google-Smtp-Source: ABdhPJwrojk583U17UFreB26E6EJBzeY9pns7nnbhf5WVPSQWFljj9y5nCaSrAUUweCPWKFxAyW3SN3Koo6Xjpsvyx8=
X-Received: by 2002:a2e:b006:: with SMTP id y6mr419563ljk.462.1602733454595;
 Wed, 14 Oct 2020 20:44:14 -0700 (PDT)
MIME-Version: 1.0
References: <CA+-xGqMd4_58_+QKetjOsubBqrDnaYF+YWE3TC3kEcNGxPiPfg@mail.gmail.com>
 <47ead258320536d00f9f32891da3810040875aff.camel@redhat.com>
 <CA+-xGqOm2sWbxR=3W1pWrZNLOt7EE5qiNWxMz=9=gmga15vD2w@mail.gmail.com>
 <20201012165428.GD26135@linux.intel.com> <CA+-xGqPkkiws0bxrzud_qKs3ZmKN9=AfN=JGephfGc+2rn6ybw@mail.gmail.com>
 <20201013045245.GA11344@linux.intel.com> <CA+-xGqO4DtUs3-jH+QMPEze2GrXwtNX0z=vVUVak5HOpPKaDxQ@mail.gmail.com>
 <20201013070329.GC11344@linux.intel.com> <CA+-xGqO37RzQDg5dnE_3NWMp6+u2L02GQDqoSr3RdedoMBugrg@mail.gmail.com>
 <626a8667-be00-96b7-f21d-1ec7648ee1e6@redhat.com>
In-Reply-To: <626a8667-be00-96b7-f21d-1ec7648ee1e6@redhat.com>
From:   harry harry <hiharryharryharry@gmail.com>
Date:   Wed, 14 Oct 2020 23:43:54 -0400
Message-ID: <CA+-xGqMdVm1tqDMt9PTOxi80oEW_3pFiQaH+WvQfpZ9K1QJKDw@mail.gmail.com>
Subject: Re: Why guest physical addresses are not the same as the
 corresponding host virtual addresses in QEMU/KVM? Thanks!
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, qemu-devel@nongnu.org,
        mathieu.tarral@protonmail.com, stefanha@redhat.com,
        libvir-list@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo and Sean,

It is clear to me now. Thanks much for your reply and help.


Best regards,
Harry
