Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659FD5E84CF
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 23:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiIWVYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 17:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiIWVXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 17:23:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68555122A42
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 14:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663968225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dzXh0+CoJNH91B/Mg2iO2pFEjhzK8NyAmEI4nXxYRnc=;
        b=TZhYHoX0Lu5MLj8T9VCfjgnwjBU5/vW1SyIeue7TXqFXmGke9kAsRlyaDzRtiayXh1gAY/
        PSrFIm+X/v47MxjFtwSMO3cxP2W27ht4laOFKndRwAKdVGA3HuuIEOaaGbwhGwDzkGwze4
        TcQRDdTuIUbXrrflcvP9V9FtVFbG0LY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-569-fBkptf16Pwmo-xVPg1H_OA-1; Fri, 23 Sep 2022 17:23:36 -0400
X-MC-Unique: fBkptf16Pwmo-xVPg1H_OA-1
Received: by mail-qk1-f200.google.com with SMTP id bk21-20020a05620a1a1500b006be9f844c59so902515qkb.9
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 14:23:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=dzXh0+CoJNH91B/Mg2iO2pFEjhzK8NyAmEI4nXxYRnc=;
        b=VA1XdOkaSS4R7ieAF5PC4c6apSt03QzFMc5HDNxjSVX4MScsZ2PBMKXK+YNOBNnBuU
         vA3DsX0XmMj8leaPQP+kuqb4COsHUe9qQrBxiEhgBUioi6QDzvgLsrsjoyzqcK9A0hWk
         bRzVC5HEEfhwH918TNzTuRkssCdwpNM05/B6OJ7bYhWl3B7DVwDpKclLjYdqsbwK6w7z
         5JSYM9zUZ1IHveeJqWsOESjbujGaaOhIwwY9ykYU9Im7bJlDPXXrwjBd+QX2qdiqXXPA
         cTPQmE53wT89jUysLoHbD5NgHLv1BFOZOU2ayeD1j+YIbHn2FbgELJRdx38WlJBQ1sr7
         s3lg==
X-Gm-Message-State: ACrzQf1SuW0zPrzVm+TxkZ8bXx+PMcVYemlK1Wto7TpfRAyvdG5ah3hs
        eUB6e5UeVyMITiSk3W/4NnfG3jNBGmY7RszTo8o5WlA7mZS5pSyLBtRPq7CqDxSRFdtZyjDLJ8Y
        d9VAQ5SJV3xBK2r4hJJ3D1LOzEkfe
X-Received: by 2002:a05:6214:20e2:b0:4ac:b9a6:17be with SMTP id 2-20020a05621420e200b004acb9a617bemr8449754qvk.104.1663968216183;
        Fri, 23 Sep 2022 14:23:36 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5lnCVE0oF1CeOwhWMt+zra+pW8iEWs2xYytQYPLLN6K6WHAULJ7rvF08Tq1RB6zdF4hB5Qv0ei81ym5VjyNj4=
X-Received: by 2002:a05:6214:20e2:b0:4ac:b9a6:17be with SMTP id
 2-20020a05621420e200b004acb9a617bemr8449743qvk.104.1663968215982; Fri, 23 Sep
 2022 14:23:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220922170133.2617189-1-maz@kernel.org> <20220922170133.2617189-3-maz@kernel.org>
 <YyzYI/bvp/JnbcxS@xz-m1.local> <87czbmjhbh.wl-maz@kernel.org> <Yy36Stppz4tYBPiP@x1n>
In-Reply-To: <Yy36Stppz4tYBPiP@x1n>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 23 Sep 2022 23:23:24 +0200
Message-ID: <CABgObfakosSMDYnT+W1zFJCRwPcM7VaY-FJzRs_9NivvhfjnyA@mail.gmail.com>
Subject: Re: [PATCH 2/6] KVM: Add KVM_CAP_DIRTY_LOG_RING_ORDERED capability
 and config option
To:     Peter Xu <peterx@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        KVM ARM <kvmarm@lists.cs.columbia.edu>,
        kvm <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ben Gardon <bgardon@google.com>, Shuah Khan <shuah@kernel.org>,
        Andrew Jones <andrew.jones@linux.dev>,
        Will Deacon <will@kernel.org>,
        David Matlack <dmatlack@google.com>,
        Zhenyu Zhang <zhenyzha@redhat.com>,
        Shan Gavin <shan.gavin@gmail.com>,
        Guowen Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Il ven 23 set 2022, 20:26 Peter Xu <peterx@redhat.com> ha scritto:
>
> > Someone will show up with an old userspace which probes for the sole
> > existing capability, and things start failing subtly. It is quite
> > likely that the userspace code is built for all architectures,
>
> I didn't quite follow here.  Since both kvm/qemu dirty ring was only
> supported on x86, I don't see the risk.

Say you run a new ARM kernel on old userspace, and the new kernel uses
KVM_CAP_DIRTY_LOG_RING. Userspace will try to use the dirty page ring
buffer even though it lacks the memory barriers that were just
introduced in QEMU.

The new capability means "the dirty page ring buffer is supported and,
by the way, you're supposed to do everything right with respect to
ordering of loads and stores; you can't get away without it like you
could on x86".

Paolo

>
> Assuming we've the old binary.
>
> If to run on old kernel, it'll work like before.
>
> If to run on new kernel, the kernel will behave stricter on memory barriers
> but should still be compatible with the old behavior (not vice versa, so
> I'll understand if we're loosing the ordering, but we're not..).
>
> Any further elaboration would be greatly helpful.
>
> Thanks,
>
> > and we
> > want to make sure that userspace actively buys into the new ordering
> > requirements. A simple way to do this is to expose a new capability,
> > making the new requirement obvious. Architectures with relaxed
> > ordering semantics will only implement the new one, while x86 will
> > implement both.
>
> --
> Peter Xu
>

