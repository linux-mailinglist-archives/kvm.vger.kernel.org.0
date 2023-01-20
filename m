Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8B86748F1
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 02:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjATBk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 20:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjATBkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 20:40:25 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D530E9EE26
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 17:40:23 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id w2so2892584pfc.11
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 17:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=B93pafDYiLEzdeFpoSwk6ASMlzCL9xGgaEmz8elDYkE=;
        b=tmyKvc9Yi6bdrHRRM3gAqJqs1CzR1XX05zMF9AHW7o1g8CWfq25rGeVC46PYzv+QQb
         G+FFXjaoKNOC9lUG9nQ8YldisNIgUf+da+3wUYpfXHWDv6Hekx4GBTnTEmhVY2u6xY27
         z3yUKZ3I9m2D7TUe5q/k6SAPomZVlbLzyYhz3IxiySZb6xMMQEPi8rvCXbqTVAytxDjJ
         dTsJPiH5Mr/IutzNznAv9WQcTlADk4CLKkyza6j3e9NO7NHS1fwemD3AD/19E9hb+3kw
         zmi7mYUAc+q8GwjrleYQng8J8+I8VZ7OKV3ycKnnxrmzR13hfdso8R+4itSyFIG8EXlk
         g3+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B93pafDYiLEzdeFpoSwk6ASMlzCL9xGgaEmz8elDYkE=;
        b=kNBSuh7Br0gaCICZkJZTYP/RVJ0D7NJXLo9t/HHkfqszLTLXyJuGsSDdmQAaK0pNjC
         /FgdYs8Hz03S3u1JUnDAQ6WvDvFLcOYHYVMIoOdgs0Tw3COczsbnFPXf7/sJjEumfMkd
         Ubv3dp6PqC+H8D8m5HXdqflN8y7usCeZFepQp5ZINI/oxBX+lSDrDYWdCMBoXUsH4jgw
         Mi1TZK21gH5e6w4iJS0bAmKgofjpwOUqgRRspqGREgZscCobm15vBBOpqNQr3pRFe9iz
         A7TkjOGi9VojQvXsdHc5KMCmSE83jGlQs8B9Bg3eQwHKbTK/LO0vf2A75yPTud5IWzCX
         7Ilw==
X-Gm-Message-State: AFqh2krAYStRzrAYFpasPoJia7km3vb4TEG7PIFY645B9Z4FsSlz5+Im
        DEWL6tCCi1VAEUKHQzRxUcSVlLHYa32Fk1vA1VnCmw==
X-Google-Smtp-Source: AMrXdXtX2ox98SuCBvArhlrqg1uXGxl5FHrJkf+XqM9+ca+Dt/RYaG6/dAfE1iGhutrPd+ArCj6PYRCWWDT4bL8xKQc=
X-Received: by 2002:a05:6a00:4c14:b0:580:f2b8:213c with SMTP id
 ea20-20020a056a004c1400b00580f2b8213cmr1309897pfb.8.1674178822730; Thu, 19
 Jan 2023 17:40:22 -0800 (PST)
MIME-Version: 1.0
References: <20221214194056.161492-1-michael.roth@amd.com> <20221214194056.161492-63-michael.roth@amd.com>
 <CAAH4kHZVaeL57bGAzeDjJDTumsnb96iAYBdhm7cs_8TjBg+v3w@mail.gmail.com> <d09e13c2-3a3d-924b-05b3-560fe1121516@amd.com>
In-Reply-To: <d09e13c2-3a3d-924b-05b3-560fe1121516@amd.com>
From:   Dionna Amalie Glaze <dionnaglaze@google.com>
Date:   Thu, 19 Jan 2023 17:40:10 -0800
Message-ID: <CAAH4kHYOtzgqSTZQFcRiZwPLCkLAThjsCMdjUCdsBTiP=W0Vxw@mail.gmail.com>
Subject: Re: [PATCH RFC v7 62/64] x86/sev: Add KVM commands for instance certs
To:     "Kalra, Ashish" <ashish.kalra@amd.com>
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
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, harald@profian.com
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

On Thu, Jan 19, 2023 at 2:18 PM Kalra, Ashish <ashish.kalra@amd.com> wrote:
>
> Hello Dionna,
>
> Do you also have other updates to this patch with regard to review
> comments from Dov ?
>

Apart from the PAGE_ALIGN change, the result of the whole discussion
appears to only need the following immediately before the
copy_from_user of certs_uaddr in the snp_set_instance_certs function:

/* The size could shrink and leave garbage at the end. */
memset(sev->snp_certs_data, 0, SEV_FW_BLOB_MAX_SIZE);

I don't believe there is an off-by-one with the page shifting for the
number of pages because snp_certs_len is already rounded up to the
nearest page size. Any other change wrt the way the blob size is
decided between the guest and host should come later.

-- 
-Dionna Glaze, PhD (she/her)
