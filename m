Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759246A7618
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 22:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjCAVXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 16:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCAVXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 16:23:11 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47057E3B8;
        Wed,  1 Mar 2023 13:23:10 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id m6so19510697lfq.5;
        Wed, 01 Mar 2023 13:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677705788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5FeJ+IDtaGU0Dng3JPzlo8N148iZPjSnDaT2NDjs7iw=;
        b=U8CpE6oQW0T0yL/b9SkOw8+im0wm0VFjDpBzKhqnbc90OvihHMA8b3Swuuy9QqpKMe
         M+zFCU5cpADOmoJbYfb0etx9J0WIpBgFCtv13HBtqqQWPUMRzvD540wG5oR1npPqHhcs
         XHdM9ObzYlw1GwwKb7RGDEgk3dCUQEgEg9hPh05KETDEJcy5nuIlhCM5Lvuof3p6zEMM
         NO6CZHki9sKwqzWnZRUdOQT9s+Pa0Atf+qamboT7QHXS+kvTpz7o11xBU8WEkEMRHhns
         OdzCe5cUufbtOfHlr/uaxn2eo3wfc57z+O/pojBy519Ra4o7lNhCJF1hAKcXPmnI3qrF
         k7Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677705788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5FeJ+IDtaGU0Dng3JPzlo8N148iZPjSnDaT2NDjs7iw=;
        b=ZtK9SSnE8y4vsc/tCvF8m+fVGTge3U/rJjZrlurzaNcM/6u9+nDlA9INKmm7S+C7Xg
         zYlrTPNYK2WkklqROQghvRbBqHshY0kjcg1eWtlH4JkizhtKjhLsp/O1ypZ2DT1tZfWA
         i9cbXtmbU8rrfRKASHdVlSlXthbKy+gHWqUVuJmDhpeWEPRQohviBLnIRuMC4XpLW/KU
         dIKOniu2/XVj/g2rVDxzv7o7zM37o4Y2LXnnk5p6fpub94AecdvsyNlMngbyIoNwEez9
         2kyuWcmVdctHNc5ZNBTcXKjNbT1jb3dsGen1WeTL751BVKVBf+m1XApNShHCf43ASne7
         PzoA==
X-Gm-Message-State: AO0yUKWe8j9BOHqEE83rVrnbTWfDxFZqQZbK6k73CWz6vHK8OiFXPknW
        YuUVJBjc4yCKaFSDW0QmYmg=
X-Google-Smtp-Source: AK7set9Husvr/raZBgcJeLI0L1kUHYIjgMkrgLJmOKKElIcO7WhwF5Z9WCFNJJAEq103LkvXE98QNg==
X-Received: by 2002:ac2:44a9:0:b0:4d2:c70a:fe0a with SMTP id c9-20020ac244a9000000b004d2c70afe0amr1752508lfm.2.1677705788430;
        Wed, 01 Mar 2023 13:23:08 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id p3-20020a19f003000000b004db2bda9527sm1858821lfc.121.2023.03.01.13.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 13:23:08 -0800 (PST)
From:   Zhi Wang <zhi.wang.linux@gmail.com>
X-Google-Original-From: Zhi Wang <zhi.wang.linux@intel.com>
Date:   Wed, 1 Mar 2023 23:23:06 +0200
To:     Michael Roth <michael.roth@amd.com>
Cc:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: Re: [PATCH RFC v8 53/56] KVM: SVM: Make VMSAVE target area memory
 allocation SNP safe
Message-ID: <20230301232306.00005f86@intel.com>
In-Reply-To: <20230220183847.59159-54-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-54-michael.roth@amd.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Feb 2023 12:38:44 -0600
Michael Roth <michael.roth@amd.com> wrote:

> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Implement a workaround for an SNP erratum where the CPU will incorrectly
> signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
> RMP entry of the VMSAVE target page.
> 
> When SEV-SNP is globally enabled, the CPU marks the VMSAVE target page
> as "InUse" while the VMSAVE instruction is executing. If another
> CPU writes to a different page in the same 2MB region while the VMSAVE
> is executing, the CPU will throw an RMP violation #PF.
> 
> Use the snp safe generic allocator for allocating the VMSA target
> page which will ensure that the page returned is not a hugepage, as it
> is already being used for the allocating the VMCB, VMSA and AVIC backing
> page.
> 

This should be merged with patch where implements the snp_safe_alloc_page().

> Co-developed-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> Reported-by: Alper Gun <alpergun@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3fe5f13b5f3a..8bda31a61757 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -665,7 +665,7 @@ static int svm_cpu_init(int cpu)
>  	int ret = -ENOMEM;
>  
>  	memset(sd, 0, sizeof(struct svm_cpu_data));
> -	sd->save_area = alloc_page(GFP_KERNEL | __GFP_ZERO);
> +	sd->save_area = snp_safe_alloc_page(NULL);
>  	if (!sd->save_area)
>  		return ret;
>  

