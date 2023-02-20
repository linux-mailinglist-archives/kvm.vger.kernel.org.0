Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F3269D464
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 20:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbjBTT6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 14:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbjBTT6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 14:58:19 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4F41C587
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 11:58:12 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id f2so2591907qtv.5
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 11:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O7rkSAN5LAMQyeEaKY1rCygZe9FB1uxO0LO3uAv87QU=;
        b=hInwNusK1f2xWu38WC2TBIVbF8f2TO5jkZeMa3ENjF8+qZQNIQ1MTr6rSdq3y+Btjj
         6BIDSl7yj7uHqrzdyIoI/UMjBzPuslcrV+Q+GrjgBiWT7ywPd/P6BVOdzmIbFW4XirzN
         1GDvraFCY30SpfM/41Ra/eV1LxnCL5I0RalU3w7+qykDmmPnkBpbd2IUljWw+cw/LPp1
         2S1c8I9Tp2jZhgBraFlDDBdvp/sZMrxZalVFVA2qIdXMtkbA6E5Hen2YunYwcGVLmwbt
         w1U+aLxo8qFs9hnIoTnklHuBLNGbOiMibwiz17Hw2Y2Gdy/LSEkir86U3fL3Y0qWBBy5
         n8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O7rkSAN5LAMQyeEaKY1rCygZe9FB1uxO0LO3uAv87QU=;
        b=1q/yaqIuG/3vHMUA9L0BtsnmJu7p1DBlPzHs1J6Kt4PUQZQ4VbTYJM7Vs5s3qh8mUV
         blNEto6wLTu6gMEVVRgYafbutVpj5HFr9JXooDvyYqhEWlbleEexeJHX2zMdfNqnAr9M
         hXbfjYUlL1LfzB12gjzTXXoKADlv4ddOqn5oULvwqS3r9fzbWdinQdUIxVom00rgCFT8
         AysIroUjfQGUwqBBh8L+NFarrGroKU66yA0dvIXuzprMivp9H9czCSdcQ3P82n4AoaTo
         Sm6Z94vnXd5A8PudXL5zUEiTINRdl3tLaWVrFN9fsXL8tErGtqYCvWVyJrFFBRmg+cGv
         etmw==
X-Gm-Message-State: AO0yUKUdVIWfvmPDmY0uAD0dDubfM1RDXQeRGKEvJqXnPi7aZUYLLQnz
        KWgKR3o/O05E4xgPgAnaEm+mCA==
X-Google-Smtp-Source: AK7set/sYxfkHmLO+xORTsRgDUCiomQwgSGXUzHB9SZzOE2YWrMYkjAsLwH9nBABUIsDsOgaxEchJw==
X-Received: by 2002:ac8:7c43:0:b0:3b8:340b:1aab with SMTP id o3-20020ac87c43000000b003b8340b1aabmr19284007qtv.25.1676923091286;
        Mon, 20 Feb 2023 11:58:11 -0800 (PST)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id q202-20020a3743d3000000b0073b341148b3sm9483000qka.121.2023.02.20.11.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 11:58:10 -0800 (PST)
Date:   Mon, 20 Feb 2023 11:57:59 -0800 (PST)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To:     Michael Roth <michael.roth@amd.com>
cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH RFC v8 18/56] x86/fault: fix handle_split_page_fault()
 to work with memfd backed pages
In-Reply-To: <20230220183847.59159-19-michael.roth@amd.com>
Message-ID: <29e9ed33-52eb-fbb4-5358-76939df747a9@google.com>
References: <20230220183847.59159-1-michael.roth@amd.com> <20230220183847.59159-19-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Feb 2023, Michael Roth wrote:

> From: Hugh Dickins <hughd@google.com>

No.

> 
> When the address is backed by a memfd, the code to split the page does
> nothing more than remove the PMD from the page tables. So immediately
> install a PTE to ensure that any other pages in that 2MB region are
> brought back as in 4K pages.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

No.  Suggested-by would be okay.

> Cc: Hugh Dickins <hughd@google.com>

Thanks.  I'm really sorry to be such a jobsworth,
and have nothing more constructive to say than I did before in
https://lore.kernel.org/linux-mm/7f2228c4-1586-2934-7b92-1a9d23b6046@google.com/
(please re-read), but adding a Signed-off-by where none was given is wrong;
and I'm not ever going to comprehend enough of the context to give it.

Best of luck for the series,
Hugh

> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  mm/memory.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index e68da7e403c6..33c9020ba1f8 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4999,6 +4999,11 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>  static int handle_split_page_fault(struct vm_fault *vmf)
>  {
>  	__split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);
> +	/*
> +	 * Install a PTE immediately to ensure that any other pages in
> +	 * this 2MB region are brought back in as 4K pages.
> +	 */
> +	__pte_alloc(vmf->vma->vm_mm, vmf->pmd);
>  	return 0;
>  }
>  
> -- 
> 2.25.1
