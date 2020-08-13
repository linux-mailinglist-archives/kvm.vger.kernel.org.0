Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDBD243E84
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 19:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgHMRwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 13:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgHMRwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 13:52:24 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC3DC061757
        for <kvm@vger.kernel.org>; Thu, 13 Aug 2020 10:52:24 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id h22so5476671otq.11
        for <kvm@vger.kernel.org>; Thu, 13 Aug 2020 10:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k8yck4RdxUV1UPISOKBseddHGlGtyaOeMcKpGKtvB5c=;
        b=HHUdhxL4MGJXkKRiv5isZeF1DkyMTSw2yBABrfsO4Xva8T2zhq3GQMK3f5sW7YoGHx
         23D2UVUUIlyJxdJ9o+ngPoLZFL2OGto96L5+Ip2NErBzR3s56SJDTnDE3I25F+BBDKSv
         yse8+HTv56nArcjdoR3nUsOhVt9Y/WtgQ7ysCncj6YtFq3Lv2SR5fCloxjrzlmVxNewQ
         ki1AxnIxj2wq/I6qJUvqVOmFawfFSLrqwta/oi/0Eh6h91Oyhz+5GVyMHarpmpJNGI4q
         A2m9I7im1yC7QJBtfj/4m+diDBkN5enPS2zyUR8cW/jvYpB3sSt3PLx3EsfP8zLBTlTK
         vszg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k8yck4RdxUV1UPISOKBseddHGlGtyaOeMcKpGKtvB5c=;
        b=W/f2FhUqRhMCE/iwpCvlYVFUN5bCeXlg14q+KlhrrJ7QGNsjiP3cSUzF87E6W6eMQB
         b3iSeHI2hkUGqpbtVYau8bsoiLdOwC1RZ3HltD7KKk2igZQyExMmqRd/VOXyUKJNodZ0
         lv2YYm2wBxNcVtZKmjW6JGov+WLKLZl4ZxYJno5y5aX4+ouHEL2E0XcLRxpCeyl+d6Oo
         NkL6oyl31e2DOp/kvQBKL6mMWXBXFWLDA7Yh97nP4XIlJTpIyS61Cn2xb7CIUkBrN+gc
         QpBX8JdxK9G4nDVxRUMkBqCgeCOCEhubOdydre8XN3vlEnL0rzhvmY3vv8A8BftLKWC8
         i3SA==
X-Gm-Message-State: AOAM533WB/lxiZLxUpsqFA8/mtoRTaI1wjDbFU0M4R5zy+KG2RmjRbpn
        cwPUxgVycnPDGcxQCPmDI5Ix1yjoLKTpJ7zvYxPozw==
X-Google-Smtp-Source: ABdhPJyEFFAL1NxJEK/txJK2vu6Y2XY3X3D1k5/2k0C7zRHTi5Vb1j4WYuZEzG0GPL9KBEF4kKGfI6p6awvXRFkM4Q8=
X-Received: by 2002:a9d:22ca:: with SMTP id y68mr5263764ota.56.1597341143209;
 Thu, 13 Aug 2020 10:52:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200807084841.7112-1-chenyi.qiang@intel.com> <20200807084841.7112-8-chenyi.qiang@intel.com>
 <CALMp9eTAo3WO5Vk_LptTDZLzymJ_96=UhRipyzTXXLxWJRGdXg@mail.gmail.com> <1481a482-c20b-5531-736c-de0c5d3d611c@intel.com>
In-Reply-To: <1481a482-c20b-5531-736c-de0c5d3d611c@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 13 Aug 2020 10:52:11 -0700
Message-ID: <CALMp9eQ5HhhXaEVKwnn6N6xxd2QOkNkE7ysiwq+3P=HB-Y1uzg@mail.gmail.com>
Subject: Re: [RFC 7/7] KVM: VMX: Enable PKS for nested VM
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 12, 2020 at 9:54 PM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
>
>
>
> On 8/11/2020 8:05 AM, Jim Mattson wrote:
> > On Fri, Aug 7, 2020 at 1:47 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
> >>
> >> PKS MSR passes through guest directly. Configure the MSR to match the
> >> L0/L1 settings so that nested VM runs PKS properly.
> >>
> >> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> >> ---

> >> +           (!vmx->nested.nested_run_pending ||
> >> +            !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS)))
> >> +               vmcs_write64(GUEST_IA32_PKRS, vmx->nested.vmcs01_guest_pkrs);
> >
> > This doesn't seem right to me. On the target of a live migration, with
> > L2 active at the time the snapshot was taken (i.e.,
> > vmx->nested.nested_run_pending=0), it looks like we're going to try to
> > overwrite the current L2 PKRS value with L1's PKRS value (except that
> > in this situation, vmx->nested.vmcs01_guest_pkrs should actually be
> > 0). Am I missing something?
> >
>
> We overwrite the L2 PKRS with L1's value when L2 doesn't support PKS.
> Because the L1's VM_ENTRY_LOAD_IA32_PKRS is off, we need to migrate L1's
> PKRS to L2.

I'm thinking of the case where vmx->nested.nested_run_pending is
false, and we are processing a KVM_SET_NESTED_STATE ioctl, yet
VM_ENTRY_LOAD_IA32_PKRS *is* set in the vmcs12.
