Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8206734EEF
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 11:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjFSJA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 05:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjFSJAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 05:00:55 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2C39B;
        Mon, 19 Jun 2023 02:00:54 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4f845ca2d92so718883e87.1;
        Mon, 19 Jun 2023 02:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687165253; x=1689757253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V75CwKkoMS9GVL1WDBw8U7VzaszOLOs5Vwr/ePxHWAs=;
        b=nFy1j8fEblfOtQ9ROMm9sQQfY+F7p8fn0NlZPyYFude7xSsfEKkk07PhsUrOuno7vS
         CimR8dDTdd4cX/rc6knXJV6/J5+EGSCeGsO+bUuSj97EIxfmmRTpHN8CnudxNzPbtkaU
         aL4NJg5AE1/qLvsncvPtRC/y8yozOkNDE43OhLKHr2erFXpLUGhi6ElAGvgKuEIJ9BNu
         SlQM35IoIAIACJoHR6pkr0d5FwNSSDFkJVmBUQJNOqf25BeHD7BkLnxE9ubieBcrxp0i
         5DzkGdqvgfmN+CtL3BuHrxYwGXpxArxtF7cxAVIJFoHXrFFLGeywBPtOofYXtGD+cC9h
         RC3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687165253; x=1689757253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V75CwKkoMS9GVL1WDBw8U7VzaszOLOs5Vwr/ePxHWAs=;
        b=Jepuj3avUvaqRNY9tdkFmXeI/7MPmY23lM6PPXC0Tt6dCCB6RFkktOLIwYLOg8zBeL
         NxoJ7lYjtM3mgRB3uTUUxuCeZwqqbkc1763eJzj09zlmfVldAoGxVY/VWG+Y7MKx4Vt0
         Z/9g8zdvbCIZAOQ3uN2oggJg/zLjK0pPP5a4ky6gb0M5MIgIl+9V9koGyWkbp/2giES5
         GhTZi8YfkyY6rATmoIomgGXSyqtAflYdGA8tGvV/WFWznYzhvZIfJdm9I/JR5qMsZoHZ
         YGuPsbHtu7lbW7HGczgqtUb9oP9ktn8/bCxc9yhp9vK5GUZF36szz0qLvqycG49UAjY1
         ZSNg==
X-Gm-Message-State: AC+VfDz7KSoSQHctYeJvwS8KprmM/vXkp2JA0x5oyi6hGzyFTdV5aOdi
        ITEm1w/4GcTsjzeDEJBFEHN0NIrQwOQ=
X-Google-Smtp-Source: ACHHUZ5LWGe6gI5kmyP5XAeV564r+VmRjYajDuEmT6KFvFUB1O72TxULrEgF5jia4by+SK1cWBjsCQ==
X-Received: by 2002:a05:6512:25a:b0:4f7:6a87:f16f with SMTP id b26-20020a056512025a00b004f76a87f16fmr3606802lfo.4.1687165252532;
        Mon, 19 Jun 2023 02:00:52 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id u25-20020a056512041900b004f24ee39661sm4164551lfk.137.2023.06.19.02.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 02:00:52 -0700 (PDT)
Date:   Mon, 19 Jun 2023 12:00:51 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 0/6] KVM: Documentation: Update document description for
 kvm_mmu_page and kvm_mmu_page_role
Message-ID: <20230619120051.00001f0f.zhi.wang.linux@gmail.com>
In-Reply-To: <20230618000856.1714902-1-mizhang@google.com>
References: <20230618000856.1714902-1-mizhang@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 18 Jun 2023 00:08:50 +0000
Mingwei Zhang <mizhang@google.com> wrote:

> When reading the KVM MMU documentation for nested virtualization, I feel
> that the description of kvm_mmu_page (and kvm_mmu_page_role) has been
> lagging for around 1-2 years. The descriptions for several fields in struct
> kvm_mmu_page and struct kvm_mmu_page_role are missing. So I think it might
> be good to add them to make it consistent with the current code.
>

This is so nice. A trivial comment, maybe refining the tittle of PATCH 1-6 a
bit: "Add the missing comment of xxxx into xxxx". It is a little bit confusing
by just looking at the titles at the first glance, more like some members are
missing, not the comments. :)

> Note that there are still some fields not added in this series:
>  - kvm_mmu_page.nx_huge_page_disallowed
>  - kvm_mmu_page.possible_nx_huge_page_link
>  - kvm_mmu_page.hash_link
>  - kvm_mmu_page.link
> 
> For the above, I thought the description might be just better to be
> inlined or there is already good description inlined.
> 
> Mingwei Zhang (6):
>   KVM: Documentation: Add the missing guest_mode in kvm_mmu_page_role
>   KVM: Documentation: Update the field name gfns in kvm_mmu_page
>   KVM: Documentation: Add the missing ptep in kvm_mmu_page
>   KVM: Documentation: Add the missing tdp_mmu_root_count into
>     kvm_mmu_page
>   KVM: Documentation: Add the missing mmu_valid_gen into kvm_mmu_page
>   KVM: Documentation: Add the missing tdp_mmu_page into kvm_mmu_page
> 
>  Documentation/virt/kvm/x86/mmu.rst | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> 
> base-commit: 265b97cbc22e0f67f79a71443b60dc1237ca5ee6

