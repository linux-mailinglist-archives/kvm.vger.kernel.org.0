Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB4346DF29
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 01:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241292AbhLIAGf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 19:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238246AbhLIAGe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 19:06:34 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C82C0617A1
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 16:03:02 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so5562012pju.3
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 16:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X62bE6CLRrDuAya/H+kftwzmeQrc/YHKc2dwHO0HL5o=;
        b=Lh7N3FyYDemct+c/y/0ovna7PQvMnUPIJBk1YkcB4n4GWv4rK+B3EaN5IJBAZbkpfE
         cFUurmkHNt+wJrC/DuHyrC4WIzM9R2xe9QiXoNvn+uvH0rOvxtaR8JxzGipJ7FmCrZWT
         /YxCEOb4DQbovGk7ZQeCNgfxBwX61dmLzfVF8hWRDl47ldGCz5AZufBKO8tVYD5X71RN
         N3wsYCmuam1uwueQNbmZPEMITSEhRO2/gtkNxb4mGSs1CSGWQAeqj5r7Y/MUY2R5K0J1
         wu2VC4ANQywCuEUjf7/kuEdImsuzZVgm8p2LyYRNstkeU9pm3Im+F3lNaICBbypsewEs
         EvXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X62bE6CLRrDuAya/H+kftwzmeQrc/YHKc2dwHO0HL5o=;
        b=xHylebQy844sq6bX3MtPTFFQuZrl75y74hKgGTKxJqFrDfMHzVAYh3CJkclNJBWKy2
         Op5EAJuqkcek9CW+zYs7jR4AqmA9crh3OZv82I+V5RIhsGv2pRVBJ6f1idjxHby6tlP+
         OmC+VYQAFu5WDuT3KAmy0vuM/BXaOzg6kYC8KnF0LK5jyx7jma+MZK3xMK81sstyPeA1
         ji0WLWsR3uvQap2t+vVbPy6hwSwZqzmNSVIOB4b5KJ64+pHVhOKYtFTdX4+gv74zrxow
         qe7IeqmgGv3tAXk0DVWRxWtRJqhUEn3HRe90RTki7IFYeoYKK5FoLAtplU1AYiG39dxZ
         F2GA==
X-Gm-Message-State: AOAM533GloJrXDFZ+KaLXBrHpfUy5oLarqZhJ051SezCuqwtIYOdPe2x
        jVYW7qZUqSq+I+bNjh5fhlFOVA==
X-Google-Smtp-Source: ABdhPJxH/D11w+IIasOz+qq6RnU8SkmixF5ZjKPn9Z/OesRd3tEiiUAdcxOjQzxnciR5zUlAbVbh3Q==
X-Received: by 2002:a17:90a:1b26:: with SMTP id q35mr11073204pjq.212.1639008181593;
        Wed, 08 Dec 2021 16:03:01 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id lt5sm3743029pjb.43.2021.12.08.16.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 16:03:01 -0800 (PST)
Date:   Thu, 9 Dec 2021 00:02:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/26] KVM: x86: Halt and APICv overhaul
Message-ID: <YbFHsYJ5ua3J286o@google.com>
References: <20211208015236.1616697-1-seanjc@google.com>
 <39c885fc6455dd0aa2f8643e725422851430f9ec.camel@redhat.com>
 <8c6c38f3cc201e42629c3b8e5cf8cdb251c9ea8d.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c6c38f3cc201e42629c3b8e5cf8cdb251c9ea8d.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 09, 2021, Maxim Levitsky wrote:
> Also got this while trying a VM with passed through device:
> 
> [mlevitsk@amdlaptop ~]$[   34.926140] usb 5-3: reset full-speed USB device number 3 using xhci_hcd
> [   42.583661] FAT-fs (mmcblk0p1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
> [  363.562173] VFIO - User Level meta-driver version: 0.3
> [  365.160357] vfio-pci 0000:03:00.0: vfio_ecap_init: hiding ecap 0x1e@0x154
> [  384.138110] BUG: kernel NULL pointer dereference, address: 0000000000000021
> [  384.154039] #PF: supervisor read access in kernel mode
> [  384.165645] #PF: error_code(0x0000) - not-present page
> [  384.177254] PGD 16da9d067 P4D 16da9d067 PUD 13ad1a067 PMD 0 
> [  384.190036] Oops: 0000 [#1] SMP
> [  384.197117] CPU: 3 PID: 14403 Comm: CPU 3/KVM Tainted: G           O      5.16.0-rc4.unstable #6
> [  384.216978] Hardware name: LENOVO 20UF001CUS/20UF001CUS, BIOS R1CET65W(1.34 ) 06/17/2021
> [  384.235258] RIP: 0010:amd_iommu_update_ga+0x32/0x160
> [  384.246469] Code: <4c> 8b 62 20 48 8b 4a 18 4d 85 e4 0f 84 ca 00 00 00 48 85 c9 0f 84
> [  384.288932] RSP: 0018:ffffc9000036fca0 EFLAGS: 00010046
> [  384.300727] RAX: 0000000000000000 RBX: ffff88810b68ab60 RCX: ffff8881667a6018
> [  384.316850] RDX: 0000000000000001 RSI: ffff888107476b00 RDI: 0000000000000003

RDX, a.k.a. ir_data is NULL.  This check in svm_ir_list_add() 

	if (pi->ir_data && (pi->prev_ga_tag != 0)) {

implies pi->ir_data can be NULL, but neither avic_update_iommu_vcpu_affinity()
nor amd_iommu_update_ga() check ir->data for NULL.

amd_ir_set_vcpu_affinity() returns "success" without clearing pi.is_guest_mode

	/* Note:
	 * This device has never been set up for guest mode.
	 * we should not modify the IRTE
	 */
	if (!dev_data || !dev_data->use_vapic)
		return 0;

so it's plausible svm_ir_list_add() could add to the list with a NULL pi->ir_data.

But none of the relevant code has seen any meaningful changes since 5.15, so odds
are good I broke something :-/
