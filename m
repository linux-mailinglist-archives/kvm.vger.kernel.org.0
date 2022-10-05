Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B36C5F59D4
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 20:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiJESZG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 14:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiJESZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 14:25:04 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B45B108B
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 11:25:03 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d24so16091609pls.4
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 11:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CUW1KYmFopFdsPTZcWygrx33GipuP5wuO3THECfGVaI=;
        b=lbh02NDtPX+m/svKiFI4pGnWNgyDzo0vOnkLlBGvKxQCDzXo7UuIfKTxDRbdw1Ppv4
         f9PheA49IMbONigpuYl0nRWrlIwS5Ep0DdZqBcNEV+o1coGT626i/4W2XUfXEVOEr0dM
         1qjwxlQnq0Ft0CjO3FaegKjXACJAEPoo3JEzjr8D0DuEwCn2/HiO0KvKns6y8OIVJQ9l
         SARMYzM7RLjheyMWSUR9L/SJN3MgKvA2MFFaE+QL6QUEkJfaG1So+oTBGX0zarzemCCs
         qsrxtCd/Qug0+DSvQR1EGoRw29NBt7Ra6kc5Ic3125sbc14CqHBrxLvV604E3VG5XF9M
         Us2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CUW1KYmFopFdsPTZcWygrx33GipuP5wuO3THECfGVaI=;
        b=B9Jutya1EgW84oVGhJBZWYzCgu9lR2kQi0n9lCgugakwfNqFz5I9Xh0z/SNSw10N2l
         ZkU24a/Hm2fujwWhvIJ6zbAB/fV4pjX/dIQapcJ7a9Bsx5K24DipkE9oJMHbW5Ll2U+p
         3Bd/yy02Nhc+lkF4f/VsnZS7xqiXVfvOY23M0Eg3JnCiPzbjA3UHb8ex1zWS0wFh+Loi
         GLI4k9KanNuPJJVfRwzxHBsUQPmJ6eQYCyiPGTbB77UrRfQY0BymsFYYyvynMYoOf5zP
         BwkfIJlmbB6m+1Xdq/shnBpYxZ68sA6RTm/sMsvmeerYstbNMQ7L/8ewnQ/I+fW+8Dg3
         x4Kw==
X-Gm-Message-State: ACrzQf38GKxgkIKmUlX5XV+UfDAspOTeQxcrfuyNDNv1ZtjRTJSe4U+Y
        WvPuTH2nj+EXvMZzAWqDaCJvXg==
X-Google-Smtp-Source: AMsMyM5CRhfAtPVMGpuu7ouPoc7ZjeK7GI9zyjU0pozMAB+re04TEMupJbZjBvBHSZ7kvv/Bau2YPQ==
X-Received: by 2002:a17:902:ec89:b0:178:3ea4:2960 with SMTP id x9-20020a170902ec8900b001783ea42960mr972216plg.160.1664994302885;
        Wed, 05 Oct 2022 11:25:02 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q13-20020a170902dacd00b0017825ab5320sm10832251plx.251.2022.10.05.11.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 11:25:02 -0700 (PDT)
Date:   Wed, 5 Oct 2022 18:24:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zixuan Wang <zxwang@fb.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        shankaran@fb.com, somnathc@fb.com, marcorr@google.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        zxwang42@gmail.com
Subject: Re: [kvm-unit-tests RFC PATCH 2/5] x86/efi: Fix efi runner scripts
 for standalone
Message-ID: <Yz3L+nZv8ozvZ/z3@google.com>
References: <20220816175413.3553795-1-zxwang@fb.com>
 <20220816175413.3553795-3-zxwang@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816175413.3553795-3-zxwang@fb.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022, Zixuan Wang wrote:
> Fix the efi runner scripts to run in the standalone mode:

Capitalize EFI for consistency.

> 1. Define the `x86/run` qemu runner as a function because `x86/run` is
> embedded into the standalone and cannot be called using its file name.
> 
> 2. Disabling the `config.mak` checks in the standalone mode as it's not
> available.

s/Disabling/Disable

> 
> 3. Use the dummy test file name provided by standalone's EFI_DUMMY
> variable, because the dummy test case is embedded into the standalone
> files and exported as a tmp file at run time.

This patch probably needs to be split into three patches, one for each of the
above changes.  A changelog that contains a list of things that are fixed is usually
a good hint that the patch is bundling too many things together.
