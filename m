Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBC73A7493
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 05:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhFODDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 23:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbhFODDs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 23:03:48 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66909C0617AF;
        Mon, 14 Jun 2021 20:01:44 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id x196so16678122oif.10;
        Mon, 14 Jun 2021 20:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lbogKHW8qkKdGG4ctidnUD+FZuRlje0jwgTya1yLZHg=;
        b=X7ekhUySfyrlRCdPDw/Egqzv7vbiolEHNPnzmqO7fUlO+/7gvmKgPMqc1FK7EMjPzV
         2MwjNcrADpX3M9K5iGiziyeRju65eYqDCJXGGgiOdQ8I9ppRsdq8As9IHfdAp9mWFV+T
         zWaS3BlP2EP8kmolk0N469EDqkznplPXvE+6bK0tmRge/jwNCGoeNeISZXamiS/UG6cq
         P3ijHqleogyY4vgO/JY0wabhEWGfc7eD7ilk7sXpLno/aDV03tZllCRe1wWibYGvANG5
         6CFqIFSYwrhfwczVdgcecox/FTZCj9/hHmDJGDgS1bHIdIaxB8mE2/f5youniiHbYa1b
         Anvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lbogKHW8qkKdGG4ctidnUD+FZuRlje0jwgTya1yLZHg=;
        b=KaMH3DMXHzxgHxCPhfBy29r0bdMc4HyuN/Zwv0L4dxnEgcKN6tqYYIKJ6MiYARoiWC
         mWwKNYp5sQsq7xdAmu1NFAV3apzb1lec/Bcc9R0lyWIDLD9NgeEigUdJOdLr3pYBO88F
         vn3YHZLOTkif4byrzb/qwhLjvCwM5TyzCGbsS4XLKeOUyJF1+eqzDjBnl4yDPjE+Out9
         vy9P77v8FE8BPE3O9GkKaO4At56v0j8AEjjrijzlhoCs5iCTdS+cSjE+h72jqwUtxGvq
         nqcGquenYPPn0lG2rQ6qisMXbjv5hIlEwwiVUAb+342L0pNFMCz4TcROQadehYQIjVsH
         Ob1w==
X-Gm-Message-State: AOAM532W+X+Z2XLYUYO3gRoU3b6CaIfCpuoXuz96uZX3ZuKBdMr6xmN8
        Sej2/ZrWJaCdf5RC6T54+wMOAkhO7Nc=
X-Google-Smtp-Source: ABdhPJxDBwIMy8iwqDMz6AAOdUim8Bj9gK04mPA0FlYScIl9x96g48ZX/tIHm5ZzOjcDppMf/dyBFg==
X-Received: by 2002:a17:90a:aa8c:: with SMTP id l12mr2077416pjq.90.1623719444134;
        Mon, 14 Jun 2021 18:10:44 -0700 (PDT)
Received: from localhost ([2601:647:4600:1ed4:adaa:7ff5:893e:b91])
        by smtp.gmail.com with ESMTPSA id n129sm13416200pfn.167.2021.06.14.18.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 18:10:43 -0700 (PDT)
Date:   Mon, 14 Jun 2021 18:10:42 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Erdem Aktas <erdemaktas@google.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86 <x86@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@linux.intel.com>
Subject: Re: [RFC PATCH 64/67] KVM: TDX: Add "basic" support for building and
 running Trust Domains
Message-ID: <20210615011042.GA4075334@private.email.ne.jp>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
 <b7004ea31380e113f38965f21f86a10cb7be1dc9.1605232743.git.isaku.yamahata@intel.com>
 <CAAYXXYwHp-wiAsSjfsLngriGZpdQHUVY6o7zdGrN2fNm_RJZAQ@mail.gmail.com>
 <CAAYXXYxX_ns-D_OJCOkA+jgzSV6Hb=oHyLDb5fYMwF-2X5QAgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAYXXYxX_ns-D_OJCOkA+jgzSV6Hb=oHyLDb5fYMwF-2X5QAgQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 10, 2021 at 07:33:29PM -0700,
Erdem Aktas <erdemaktas@google.com> wrote:

> some more feedback on KVM_TDX_INIT_MEM_REGION:
> 
> KVM_TDX_INIT_MEM_REGION requires a source and destination address
> which is a little counterintuitive (debatable). I think this requires
> better documentation to explain the usage better. I was wrongly
> expecting to provide the guest memory which has the code as a pointer
> and expecting it to be in-place measured and encrypted.
> 
> KVM_TDX_INIT_MEM_REGION crashes the host when:
> * Target gpa is not valid or not backed by a page
> * When source and destination overlap


Thanks for feedback.
On next respin, I'm going to document new API more.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
