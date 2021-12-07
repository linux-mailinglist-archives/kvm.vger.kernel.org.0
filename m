Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A743846B1E6
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 05:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236048AbhLGEgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 23:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233659AbhLGEgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 23:36:46 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4126BC061746
        for <kvm@vger.kernel.org>; Mon,  6 Dec 2021 20:33:17 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id 35-20020a9d08a6000000b00579cd5e605eso16601135otf.0
        for <kvm@vger.kernel.org>; Mon, 06 Dec 2021 20:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=63DboHosSXRDMTjyFISb3dOMA9HC6l2H00hxIyp0tfM=;
        b=njFR5yaBH8cZJed/IwZF4UoporI2N9GbUizjT2SQkfR/kWVOAvo47/Dkj/g072/3eI
         +GK0a8I15HKoLFYFPOIbGrrA8324VLzrs06mryph2m61i8oHawBfqYRhZ3e0M7HZXHQg
         211C4tVDc6siJhj7XjuHUNiIwpN63IffJMCXGufgpGkJZtX45hgKYM6PrXWiCb3o7wa1
         0sQBpQMfIRxnig+vnsDjkQyqJ05dVIssjbUZeUZN1bB8TeEI5ADySdzgu3J8e0xbhOwM
         5nffch/gNt6tBSNzPrMucbcGrVFDBDKYNwWUEDhqZ5sfZOra68imH0FcN6wuo4u28eAj
         6/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=63DboHosSXRDMTjyFISb3dOMA9HC6l2H00hxIyp0tfM=;
        b=NowpH9YbCUrwS6FW78HSnsocKEYAAlv/wRJzmnyXBItHz4fbGrAHtCFfg10nqmovct
         mmdYR/BqIPtOCovwf9iiWyICHlbxVTIdycXSGliuBr2D2MwyWv0oAFR9WDHI4xpZaHc4
         QcwXyWyzKmenzyuh0RA8UJJ9cFZfGwGVF7RNzrUDFvYtbsFh3SfS0/v3TIoqNsCA9RC/
         IMFt5Yg2Ei+906pJ+gXLAZJimlXFkOXVdwx4z12VJEbAsdpnaFqCQKHKa/oFS65bD+cA
         4sOeLAwdi4qmii92Uzy/OCji3xobhj5lkS8qWwz+vKwmwzqUSGOCLRUvr68wuU+KafYq
         3Amg==
X-Gm-Message-State: AOAM530GoyCAhMUZr7TeO1l8G8AzUW72oysrnYBZzczuA3dBx28TBPFY
        pni6gH9neG6fgmRdv7cl578uAT096moapFeOlobugQ==
X-Google-Smtp-Source: ABdhPJzMmKqLVVROEaGDxZspW1gQwBy0Dn8UcsIHfFxJ6hseqmbOIQCw29ZGJT4XkTiFhUhvfCbHqirA1FbdlrKPXL8=
X-Received: by 2002:a05:6830:601:: with SMTP id w1mr32565877oti.267.1638851596246;
 Mon, 06 Dec 2021 20:33:16 -0800 (PST)
MIME-Version: 1.0
References: <20211207010801.79955-1-krish.sadhukhan@oracle.com> <20211207010801.79955-2-krish.sadhukhan@oracle.com>
In-Reply-To: <20211207010801.79955-2-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Dec 2021 20:33:05 -0800
Message-ID: <CALMp9eS9_z6_47nRTaj4+dygzwA0-DsUT2UGMqjb-GnqEWHEuQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: nSVM: Test MBZ bits in nested CR3 (nCR3)
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 6, 2021 at 6:03 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> According to section "Nested Paging and VMRUN/#VMEXIT" in APM vol 2, the
> following guest state is illegal:
>
>         "Any MBZ bit of nCR3 is set"
>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  arch/x86/include/asm/svm.h | 3 +++
>  arch/x86/kvm/svm/nested.c  | 3 ++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index b00dbc5fac2b..a769e3343b07 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -216,9 +216,12 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  #define SVM_VM_CR_SVM_LOCK_MASK 0x0008ULL
>  #define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
>
> +#define SVM_CR3_LONG_MBZ_MASK   0xfff0000000000000U
> +
>  #define SVM_NESTED_CTL_NP_ENABLE       BIT(0)
>  #define SVM_NESTED_CTL_SEV_ENABLE      BIT(1)
>  #define SVM_NESTED_CTL_SEV_ES_ENABLE   BIT(2)
> +#define SVM_NESTED_CR3_MBZ_MASK        SVM_CR3_LONG_MBZ_MASK

A fixed mask isn't sufficient. According to the APM, "All CR3 bits are
writable, except for unimplemented physical address bits, which must
be cleared to 0." In this context, that means that the MBZ bits for L1
are all bits above L1's physical address width, given by
CPUID.80000008H:EAX[7:0] (or 36, if this CPUID leaf doesn't exist).
