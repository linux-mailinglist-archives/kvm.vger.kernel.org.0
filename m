Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0FB16C72DA
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbjCWWP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjCWWP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:15:26 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA988B2
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:15:25 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id p3-20020a17090a74c300b0023f69bc7a68so3508360pjl.4
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679609725;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o+ylr/mOA4BODFKJbYlALqz8w1nJ4f5MeaN1bApR/jE=;
        b=ATX4N5q3l1nX9PV91evb3WU0STr9/jdM/snusO6wBEcteYunulqcsKnOIwjro/gSJF
         GKC6SNXvys0zWLlP0TePikbn/Wbx8LKggQ96aO+SoDGfbi+yVxm6WIo8Zri9kHB3Cf+/
         FiBqwY0VADKV0Suyb2GNxFk5IqBl24KTMApGjnRHm5iJuFk0Ubn7zHZNdr92YemH+I0i
         vbq9izWJHeeVI/Y+KSdX0wwHSPdbQ4cmOEyBN/90C1EWARLATmMHa4h2WduQe4Xyacq6
         HbyEPnhnLLBQT2gWz0/9iHBh4c1OZrivrObggg7eDgZST47l47laRXxFVSZOLjFAWysS
         IQVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679609725;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o+ylr/mOA4BODFKJbYlALqz8w1nJ4f5MeaN1bApR/jE=;
        b=FiDHPfHTEDh9CaQTdlCsb/mOPJVOXe3Di59oLYPQZwYYs8X1pVHGobWT3OEnUxrPaH
         NoMCnnrvjChfX/c+A91ve7rOFK/FH+jKEZ3cHqdOl0ApUE1M3MZzrnM0XA4Rr7Y1aC2G
         5e+ZjbZpRX0PL/vYBvDv5SUnjjrmcL2DpgbfI8ua4pOCiug3p9j4FHwYp2EwPfSaZJ9X
         YYAjdqJx1gZr/MAU8XXsYBDQH407l9jsLGY5roTlXC9JqrEwrvTMyY+bz9nhXG6QdGTA
         0E3tQNixp2Bt55r4MyJyjf830S0rmsUIBRJeBCsVGzkq1NSPmvTSLauFr9koKQQ2V3Q5
         yQ7w==
X-Gm-Message-State: AAQBX9c4dD1ksTtWL63Hl02gRww08A+ygotwaJvzIqLmY4UeK4hKi9+b
        Sk/Z5oKseJ5qqvvuRFvFxL7KqQ==
X-Google-Smtp-Source: AKy350akhAgaOXgQONm7ST17i7vfpiD194fM49OYzlB12+MvnMGdHfOrKKPod7Cmc5024KoJROYD+A==
X-Received: by 2002:a17:903:32cc:b0:1a1:f5dd:2dde with SMTP id i12-20020a17090332cc00b001a1f5dd2ddemr383893plr.44.1679609725156;
        Thu, 23 Mar 2023 15:15:25 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id m16-20020a170902bb9000b0019e88d9bed3sm12733395pls.210.2023.03.23.15.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 15:15:24 -0700 (PDT)
Date:   Thu, 23 Mar 2023 15:15:20 -0700
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 12/18] KVM: x86/mmu: Allocate NUMA aware page tables
 on TDP huge page splits
Message-ID: <ZBzPeETL7/R1Qwwe@google.com>
References: <20230306224127.1689967-1-vipinsh@google.com>
 <20230306224127.1689967-13-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306224127.1689967-13-vipinsh@google.com>
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 06, 2023 at 02:41:21PM -0800, Vipin Sharma wrote:
> +
> +void *kvm_mmu_get_free_page(gfp_t gfp, int nid)
> +{
> +#ifdef CONFIG_NUMA

Is this #ifdef necessary? alloc_pages_node() is defined regardless of
CONFIG_NUMA.

> +	struct page *page;
> +
> +	if (nid != NUMA_NO_NODE) {
> +		page = alloc_pages_node(nid, gfp, 0);
> +		if (!page)
> +			return (void *)0;
> +		return page_address(page);
> +	}
> +#endif /* CONFIG_NUMA */
> +	return (void *)__get_free_page(gfp);
> +}
> +
