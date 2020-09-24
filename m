Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2569276559
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 02:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgIXAo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 20:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXAo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 20:44:59 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D93C0613CE;
        Wed, 23 Sep 2020 17:44:58 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id u126so1804307oif.13;
        Wed, 23 Sep 2020 17:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iE6yXlyf1DVd+ZEGXTSWH2BLIq8GOaZ6tnNLO+mCeH0=;
        b=aENKeakrCzmun8yUSrs26HkYKnevJ98tJzcn1tTTY/za5fDh+UJOW8+7NGiIZdudeL
         g8Py9ZwiRNjulG9pmPcy2Jz6tovf3zBI69vqX7wMVsKatB41ahj/YNOp6BPjRxg5Ip0D
         y22VEj21stgPmvIduGsXmNGzExT/GvHeXh56ud0sJGsb6lZhWaLobbeY+jC409GSBWLc
         M+guEmvvvfAkxG4xPcMKRiscidGwlm137Cd5YDHsBjG2neXLu2BdmkveeWTXxXxcj313
         ivZ9UOt4oFRUIZw4s9TMthC3cQaf0xvoJdPvnQgpPcoFPceEB5qzIPSiO+yolriTmfYV
         aaBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iE6yXlyf1DVd+ZEGXTSWH2BLIq8GOaZ6tnNLO+mCeH0=;
        b=iojQ3gnQEf5m0yEZ9KvGfwWWHyAMXznq11rsmUWYMNK0VwWGPlVddc/ce8rfX4Bmkw
         Xq3uwjIVWGh7kx2Ab8dgbfXdVJ+RTUreo3g3y5G7JAf6rQKej+9cimykH3eysJORIYbK
         /PJ0jKWW4/dX11JSc8FwyBCvlJFxieqDdDbOQ37Mi7j6juqC44jDGzDSZqSGdiiE6I8Q
         bP4aks3kGelTn+/wGogWZm2ERHdyUH1umS/owEDWXBetJy5DrA5MBoAT9SXthLIs+Jm/
         hAA9ZFF4tajtrFoy1MqiyVojeWgV05bWGBDIa3sSqzXs+PxmvdZxvvqAZRxOqo+3nB3F
         vJHw==
X-Gm-Message-State: AOAM533M8ju+xZdKmXe2fATnsPHeGfpC2omCRTS/xu6cUoFKw+QeJs/8
        o8nD11OY+KMP0Ype1EOclDutyHLRTHMleGL08MY=
X-Google-Smtp-Source: ABdhPJxtAT2lzrJ/JvsYNKN584hdngDJLasFy5DAfsI9Avczxw+RSfp/XT0ZDBxtlN/AdVX7T5/7x92ngrUwmropvKY=
X-Received: by 2002:aca:aa84:: with SMTP id t126mr1187343oie.5.1600908298296;
 Wed, 23 Sep 2020 17:44:58 -0700 (PDT)
MIME-Version: 1.0
References: <f3031602-db3b-c4fe-b719-d402663b0a2b@gmail.com>
In-Reply-To: <f3031602-db3b-c4fe-b719-d402663b0a2b@gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 24 Sep 2020 08:44:47 +0800
Message-ID: <CANRm+CyjMAr67Bjm+Y6u6N2jj52Np8NTjt_j4v_y0A2gOUL3BA@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Add tracepoint for cr_interception
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Sep 2020 at 19:29, Haiwei Li <lihaiwei.kernel@gmail.com> wrote:
>
> From: Haiwei Li <lihaiwei@tencent.com>
>
> Add trace_kvm_cr_write and trace_kvm_cr_read for svm.
>
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>

Reviewed-by: Wanpeng Li <wanpengli@tencent.com>
