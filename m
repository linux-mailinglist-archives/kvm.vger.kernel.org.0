Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9855C19586E
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 14:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgC0N62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 09:58:28 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:49499 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727125AbgC0N62 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Mar 2020 09:58:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585317507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2kyXkvLp9YDncmRxhMgSh9mzjMHZOfG7EsYALiBiRp8=;
        b=Mj4YSht6KWur7bJA9qMcaHXpLTlYWqn9KOTP82ZRc/0iAqYrimO+qOFSoRxZtr7uoa+Xnx
        PyZyO7nbcwjOTMX7g8PHA4voAENPXP5WVGors1qL5Olfv2IZqR2KYxW2TC4WEn5+DGU+GH
        Nn1lj2qBxYAvnokvywD7wUZRYEV39j8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-H_Ifc70tOgm1sujAHFmPfg-1; Fri, 27 Mar 2020 09:58:25 -0400
X-MC-Unique: H_Ifc70tOgm1sujAHFmPfg-1
Received: by mail-wm1-f72.google.com with SMTP id m4so4399961wmi.5
        for <kvm@vger.kernel.org>; Fri, 27 Mar 2020 06:58:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=2kyXkvLp9YDncmRxhMgSh9mzjMHZOfG7EsYALiBiRp8=;
        b=mT6o2k+YC35jH00JEVeuEClQ7H/a2i7KvuldIU8IQmWuc3hdPioMwFSWoKCH4wfcfp
         E6wScBTcCtnauk8sosTYrZy2JvYFo7VE6yFo34AB8RtVXrAVOpm770ZXoSH+FRo7UqDk
         i9vlEOAQmi8S9uLEvAkkqwSe16/ryFxOBszM1j/TEazYyP68uBbQBT92A0xpRRRuCvOn
         DQqh78sMbdtOrhbPgmrxV9BldT0xuFIMvX+BQOJONAh6Nmnam3sP697ViFKFPYlNTels
         iaNpxTdt8voTpb1l9ciUy/58iHq2/mBCVy8R9uzTh0DbPDSDulVrf0eza8bK3glfaUHH
         1d9A==
X-Gm-Message-State: ANhLgQ3PsJW+2lfyggR1c1P6jZOnUuKYy49n0Mkg6C/NN8LTqQYOGt2f
        GT0Ju/ACP3ZCjOxlqE+anQwOIvG/lLdV+brEnyYiAnbvXGc53HUR/ppFUyRs4EV4m2W+NFhn77S
        H/Hb6crbggsec
X-Received: by 2002:a7b:c5cd:: with SMTP id n13mr5301719wmk.125.1585317504091;
        Fri, 27 Mar 2020 06:58:24 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsLVznJGrbyiOBrvbA1owzFy1saFYsCcL1h0l/sU783K3pRQpPTn0aJ1m7h6Lwrsh/Agynblw==
X-Received: by 2002:a7b:c5cd:: with SMTP id n13mr5301704wmk.125.1585317503859;
        Fri, 27 Mar 2020 06:58:23 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b67sm8133491wmh.29.2020.03.27.06.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 06:58:23 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     xitler adole <zqyleo@gmail.com>
Cc:     kvm@vger.kernel.org
Subject: Re: problems about EPT in kvm
In-Reply-To: <CA+9FcC=PGZ76Tj5Sn1se-GkjpiQDUunKM0fzpdKRzvivTkiEqw@mail.gmail.com>
References: <CA+9FcC=PGZ76Tj5Sn1se-GkjpiQDUunKM0fzpdKRzvivTkiEqw@mail.gmail.com>
Date:   Fri, 27 Mar 2020 14:58:22 +0100
Message-ID: <874ku95281.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

xitler adole <zqyleo@gmail.com> writes:

> Dear developer:
>
> I am facing confusing problems, there is no way for me to figure it
> out, so I have to ask for help:
>
> 1.  I am using the <asm/kvm_host.h> <linux/kvm_host.h> for using kvm
> in my module, but there are always some function undefined like
> kvm_arch_mmu_notifier_invalidate_range. Are those functions not
> visiable from outside?

kvm_arch_mmu_notifier_invalidate_range() is not exported to other
modules with EXPORT_SYMBOL_GPL() so you won't be able to call it.

>
> 2.   With the ept technology, If I use "alloc_page" inside the guest
> virtual machine, and use "page_to_pfn" to get the pfn of the certain
> page, Is the pfn I get the gfn or the pfn of the host machine?

You'll get gfn. Basically, the guest doesn't know that it runs as guest.

>
> 3.  I want to modify the EPT table, so that I can make the gva point
> to certain hpa just to share information between vm, Given the
> condition that I can not modify the kvm code, Is that possible?

You have two level of translation:

GVA -> GPA
GPA -> HPA

so to make it happen you'll need a maping inside the guest (GVA -> GPA)
+ an entry in EPT (GPA -> HPA).

-- 
Vitaly

