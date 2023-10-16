Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5C27CB6EC
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 01:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbjJPXSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 19:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbjJPXSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 19:18:31 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD41F9B
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 16:18:29 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-53eeb28e8e5so2603a12.1
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 16:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697498308; x=1698103108; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iC/11YtDunCM076LJgjQ2zeYYGBdalGng9NijQt/KpE=;
        b=IuuE9+tiI9vptKLBXW05Y/4G3HnoZV3ASU28YUzQc4rggL0sN3wAQj5HVO0sRRHU3X
         OvmBFdLdnJai0D3Qh7VuehMfYiQn/CBNk30N7/TVaKhFX1iQ+BejLblYZlBLturiyhof
         c776O8ILeo0y/umlWs/6xWVJhDQDvBVONT+SfZamJoBYoyv6rW0sHUkJVxUv6LiZ/HBx
         A/xiba4kmXRfDBaUp0Cg/UT0Ig32he/kPloGmKeHL5TvMqL3LNsC3M2F5gEC11ulr9Fi
         hpETNzBdnct66ahPELcrBcZamuXm+t3XPz4W0NSxDj5q4MHhR4+aKWSjwdKjOKcHQYj/
         l+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697498308; x=1698103108;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iC/11YtDunCM076LJgjQ2zeYYGBdalGng9NijQt/KpE=;
        b=mnt8o+MI2L7LxAiFShRmlAZEMfhbYNQAnSgra9iC0SUh5aQzVQL5jX38lzL1VMmlJi
         C66qZJ0iEDMLZq7aI321Ypc40Pwo+5ZvveV/4/GsSQI6mw9gqajLRNdUD2vMJZNyW7qU
         At6PHaT5vwr2Yv313QjgWs1mkAQdN1eLd6lAMkrYmrOt272yz6hlasGvKoBh4E6dMZAD
         Qpn/EOkwI78NiPbrDZjn98+/IXnTgbnJBViAgRupzxAWdfCcN9vTBHV0uRLszmReO7Xm
         FJ1tAKY+ALDGFgx9xWgWba++B22TgDC6PdxoYTOvBiZv3w+1ahw/2AVsbrOXq6uF+/pH
         clzA==
X-Gm-Message-State: AOJu0Yyoyh38JXKZooyKjutUKC8Z1oHy0vnhF9T5nY9XCvHZo3vJZshm
        jkbimA/HgaNjpQfrWEhvUetmxVLrsVrQRBoQuwq6cQ==
X-Google-Smtp-Source: AGHT+IHSDQVFWveLXyGf0tUPijXYrSYM2YYlGt8C3Vmqr3FgJBMJpfYl60pFDrziom8VotGlWJVPTuF/S05fQjy7/O0=
X-Received: by 2002:a50:8ad6:0:b0:522:4741:d992 with SMTP id
 k22-20020a508ad6000000b005224741d992mr50659edk.4.1697498308135; Mon, 16 Oct
 2023 16:18:28 -0700 (PDT)
MIME-Version: 1.0
References: <20231016132819.1002933-1-michael.roth@amd.com> <20231016132819.1002933-49-michael.roth@amd.com>
In-Reply-To: <20231016132819.1002933-49-michael.roth@amd.com>
From:   Dionna Amalie Glaze <dionnaglaze@google.com>
Date:   Mon, 16 Oct 2023 16:18:16 -0700
Message-ID: <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
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
        jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        pankaj.gupta@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +
> +       /*
> +        * If a VMM-specific certificate blob hasn't been provided, grab the
> +        * host-wide one.
> +        */
> +       snp_certs = sev_snp_certs_get(sev->snp_certs);
> +       if (!snp_certs)
> +               snp_certs = sev_snp_global_certs_get();
> +

This is where the generation I suggested adding would get checked. If
the instance certs' generation is not the global generation, then I
think we need a way to return to the VMM to make that right before
continuing to provide outdated certificates.
This might be an unreasonable request, but the fact that the certs and
reported_tcb can be set while a VM is running makes this an issue.

-- 
-Dionna Glaze, PhD (she/her)
