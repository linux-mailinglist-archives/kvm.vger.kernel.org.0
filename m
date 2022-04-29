Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC102514F15
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 17:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378279AbiD2PW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 11:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377888AbiD2PWZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 11:22:25 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A9AD4CAB
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 08:19:06 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id bd19-20020a17090b0b9300b001d98af6dcd1so10784438pjb.4
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 08:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xSk7VUlXdBjZdOCMukIj9F0Tza954Uc/e0STIAsfUPQ=;
        b=a9RdUW7z0muZ9KAQ/OmL0N5vXUXhmwSGWWNfWrF5NuiyyX7lFgwtD6Ycp8E9E9F4zw
         ncvulfSYWJzM1SyUd/huaBgkFSB2eEUGFjEPprZheO1lXo6l+uOHrQGlfDjATg9XlB8Z
         hw/R0LQ/w5TJl/x3zDWOcjiNFXfTB6THJr03Lgwehe8H0zbKzbYzBQ1vzsR/vYWhSAE2
         rB3V9Fqyez/2VP3VE/JUOZkwo8id0Yq2zCatBtVU5zWJYKq2oIPbgudl1U42KjTeXad8
         C5EDomTdHiByuUki3Sfb6pyvQLq1etL58FsTQLwGsk8gihniMAp2bktYrbB11Ue8EdiT
         9ocQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xSk7VUlXdBjZdOCMukIj9F0Tza954Uc/e0STIAsfUPQ=;
        b=F3yppPNcc/biWgGoUtL3QYkr27URa7uRielyDz9O6YUI8HT5YwG0MbaBplqaLYUydC
         WbZq/bB5u5Vfj850E4FoaNQ0YfSyc0fN5R34bN+zI+ArYmf5pfIv4nlqvI0QqtSbegB3
         ng+dzPqivGFa8YAJLbRMSwgxbzPS251xOBnsCEQJkbcUY+4mGabBKx5thcN79tYVX2y1
         wmczMbjAmmZIGpTm1PIgpjeu31t5r04Ptaqhr5nkInd5HUHbG+8XpNL8Dqna338gboWi
         6dw7+/YjXU1+Xxdg0MiOVR8gGqr0fRjdhJKlm3zqY5tZsnFEhe1ggtysCYeUT3HCvjTj
         HUPg==
X-Gm-Message-State: AOAM5319yhMIK4MseB0FlvKx8b2qgjiV2+JG/kLiTzH7xRJiY/CDelyp
        nIe9Q5nFMVICw5g3tsXGhST7br/4UGk+ScimDy7KunfAXF0=
X-Google-Smtp-Source: ABdhPJyxufYag5NMXXyzwGx2UHHnYvtvBYlDpgHE66jx68/umK0ZkdaKz5EaiAU0RESndeaddbPOGWskTxCtkMAW8V8=
X-Received: by 2002:a17:90b:4b01:b0:1d2:abf5:c83f with SMTP id
 lx1-20020a17090b4b0100b001d2abf5c83fmr4406744pjb.93.1651245545644; Fri, 29
 Apr 2022 08:19:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649219184.git.kai.huang@intel.com> <522e37eb-68fc-35db-44d5-479d0088e43f@intel.com>
 <CAPcyv4g5E_TOow=3pFJXyFr=KLV9pTSnDthgz6TuXvru4xDzaQ@mail.gmail.com>
 <de9b8f4cef5da03226158492988956099199aa60.camel@intel.com>
 <CAPcyv4iGsXkHAVgf+JZ4Pah_fkCZ=VvUmj7s3C6Rkejtdw_sgQ@mail.gmail.com> <92af7b22-fa8a-5d42-ae15-8526abfd2622@intel.com>
In-Reply-To: <92af7b22-fa8a-5d42-ae15-8526abfd2622@intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 29 Apr 2022 08:18:54 -0700
Message-ID: <CAPcyv4iG977DErCfYTqhVzuZqjtqFHK3smnaOpO3p+EbxfvXcQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/21] TDX host kernel support
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 7:39 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 4/28/22 19:58, Dan Williams wrote:
> > That only seems possible if the kernel is given a TDX capable physical
> > address map at the beginning of time.
>
> TDX actually brings along its own memory map.  The "EAS"[1]. has a lot
> of info on it, if you know where to find it.  Here's the relevant chunk:
>
> CMR - Convertible Memory Range -
>         A range of physical memory configured by BIOS and verified by
>         MCHECK. MCHECK verificatio n is intended to help ensure that a
>         CMR may be used to hold TDX memory pages encrypted with a
>         private HKID.
>
> So, the BIOS has the platform knowledge to enumerate this range.  It
> stashes the information off somewhere that the TDX module can find it.
> Then, during OS boot, the OS makes a SEAMCALL (TDH.SYS.CONFIG) to the
> TDX module and gets the list of CMRs.
>
> The OS then has to reconcile this CMR "memory map" against the regular
> old BIOS-provided memory map, tossing out any memory regions which are
> RAM, but not covered by a CMR, or disabling TDX entirely.
>
> Fun, eh?

Yes, I want to challenge the idea that all core-mm memory must be TDX
capable. Instead, this feels more like something that wants a
hugetlbfs / dax-device like capability to ask the kernel to gather /
set-aside the enumerated TDX memory out of all the general purpose
memory it knows about and then VMs use that ABI to get access to
convertible memory. Trying to ensure that all page allocator memory is
TDX capable feels too restrictive with all the different ways pfns can
get into the allocator.
