Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F79662BDA
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 17:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbjAIQ4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 11:56:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237370AbjAIQ4H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 11:56:07 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2023DBC7
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 08:55:39 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id p24so10136140plw.11
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 08:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=81sjJWzHO6Ovjo5Gl60AAk0+/2Zuzb6zOrT24WH6r3o=;
        b=OOJuw8OWU9nGb+CL4TUgcpiaj0SA2J1CLUj7NLENcLFdDRo7NoHkTYncpkkO8iVYRl
         74LR+OZkKxRfS5/+S70XDs2suGpDD6t9Hkh0kUhKuWlV9iwZpbsPPDe3G2gtcCd3m4nw
         jkzOl8rELfTy/SlBdk23Ea03QIoTSoMfnf+EXS6eQOBKw7jDv0FTj3yFjQUvJjfapk4T
         kf0Zy5ZqxRUUFZpsVxuA5H0Hw8apONfzLomEcmRWF/IHy93TJuSvzGiXQ8CJ/tb6x6h9
         egX2evheI9vwF5TD/jWWy9FQg5kL0XyYYoEFICAoU2fjCkLhF9MUnLleCSPuBSDqBe0M
         DX8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=81sjJWzHO6Ovjo5Gl60AAk0+/2Zuzb6zOrT24WH6r3o=;
        b=fR0KKPSw5wNSYxcCxfmDc3i/yaOJ2yb0OMCd7UaqeOoQtp5gBEpmGDhfFT5L5w4uL8
         zkORWAFmU3qvXbHM2QwxH9Ev0OiEH97Oebe95Gk8lRrREWNy5TP3KVA8T9vOeEoQI/uR
         YhjTQ1sU9tiyoN812fwYZ8c3UTGYOA5pCoNeY7H4Pc5yKwyjJctfUKFnuQAD9s9XnhnY
         wTij11EmfqaEM0pKSxw4gckdOlXUc2fubGEaoSpIjFZCvZ0JAzzwh0Nxov5dyFXA7lBJ
         ArzNcQubjFqVXC2PIkL1TUKK77Ci9VSxTpVmzkWu++sNzR4dMycWT7rWjq0zs8ngUs6i
         cUGA==
X-Gm-Message-State: AFqh2kpR4InZGUTbyjVdMrW52m2zS17G/XbrWujgX+ADCIcK1suqR2wd
        92q7lpCedkx5jeULsLHYHrrzgonWiHh3iFbVKjy6uQ==
X-Google-Smtp-Source: AMrXdXsPdoZHVqBzLP7WRcXcNC4Xd6GTdeUcwaefhv8fy9Lwb6M6BmFfgkXiH/ADLsV/yr8LRaT3J6DHlJCmHzvZGPY=
X-Received: by 2002:a17:902:82cb:b0:192:a04b:c624 with SMTP id
 u11-20020a17090282cb00b00192a04bc624mr2581882plz.134.1673283338843; Mon, 09
 Jan 2023 08:55:38 -0800 (PST)
MIME-Version: 1.0
References: <20221214194056.161492-1-michael.roth@amd.com> <20221214194056.161492-63-michael.roth@amd.com>
 <1c02cc0d-9f0c-cf4a-b012-9932f551dd83@linux.ibm.com>
In-Reply-To: <1c02cc0d-9f0c-cf4a-b012-9932f551dd83@linux.ibm.com>
From:   Dionna Amalie Glaze <dionnaglaze@google.com>
Date:   Mon, 9 Jan 2023 08:55:27 -0800
Message-ID: <CAAH4kHbhFezeY3D_qoMQBLuFzWNDQF2YLQ-FW_dp5itHShKUWw@mail.gmail.com>
Subject: Re: [PATCH RFC v7 62/64] x86/sev: Add KVM commands for instance certs
To:     Dov Murik <dovmurik@linux.ibm.com>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        tobin@ibm.com, bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        harald@profian.com
Content-Type: text/plain; charset="UTF-8"
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

> > +
> > +static int snp_set_instance_certs(struct kvm *kvm, struct kvm_sev_cmd *argp)
> > +{
> [...]
>
> Here we set the length to the page-aligned value, but we copy only
> params.cert_len bytes.  If there are two subsequent
> snp_set_instance_certs() calls where the second one has a shorter
> length, we might "keep" some leftover bytes from the first call.
>
> Consider:
> 1. snp_set_instance_certs(certs_addr point to "AAA...", certs_len=8192)
> 2. snp_set_instance_certs(certs_addr point to "BBB...", certs_len=4097)
>
> If I understand correctly, on the second call we'll copy 4097 "BBB..."
> bytes into the to_certs buffer, but length will be (4096 + PAGE_SIZE -
> 1) & PAGE_MASK which will be 8192.
>
> Later when fetching the certs (for the extended report or in
> snp_get_instance_certs()) the user will get a buffer of 8192 bytes
> filled with 4097 BBBs and 4095 leftover AAAs.
>
> Maybe zero sev->snp_certs_data entirely before writing to it?
>

Yes, I agree it should be zeroed, at least if the previous length is
greater than the new length. Good catch.


> Related question (not only for this patch) regarding snp_certs_data
> (host or per-instance): why is its size page-aligned at all? why is it
> limited by 16KB or 20KB? If I understand correctly, for SNP, this buffer
> is never sent to the PSP.
>

The buffer is meant to be copied into the guest driver following the
GHCB extended guest request protocol. The data to copy back are
expected to be in 4K page granularity.

> [...]
> >
> > -#define SEV_FW_BLOB_MAX_SIZE 0x4000  /* 16KB */
> > +#define SEV_FW_BLOB_MAX_SIZE 0x5000  /* 20KB */
> >
>
> This has effects in drivers/crypto/ccp/sev-dev.c
>                                                                (for
> example in alloc_snp_host_map).  Is that OK?
>

No, this was a mistake of mine because I was using a bloated data
encoding that needed 5 pages for the GUID table plus 4 small
certificates. I've since fixed that in our user space code.
We shouldn't change this size and instead wait for a better size
negotiation protocol between the guest and host to avoid this awkward
hard-coding.


-- 
-Dionna Glaze, PhD (she/her)
