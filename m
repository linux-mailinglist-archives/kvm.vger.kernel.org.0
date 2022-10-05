Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7053B5F59C5
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 20:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiJESUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 14:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiJESUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 14:20:44 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFEF72B58
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 11:20:42 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id u24so9094331plq.12
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 11:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b6zzNw/YjH3RxSUvMPTYr8To/FV4imd1UZZMrOjTqao=;
        b=ewr67jbi1lQIleM8nptOdHKnoaAk1apDGASF7WlKrATX0r/jv5thVXkvNu6T2Io2Qz
         FJHfFxvKtj4dnMXVVIg9CTEBtMYnNxfwqK2oKhCJ3Jx3e2y4qrhK4ur5XzqADOvB5ROZ
         +mfTo2KxFTZ7TX+AK0PxBK7iF/meIsd8bJWIHR7Q/ywf+LKbWfPEmGI4hqeBTQM/LvwO
         WlOCJbv1sfZhsKv5fy5VOLWIiwQUh89WzR1S2xbyS3XhI2YOibbUroXfX/c9BDq7B57U
         +z0AINN3Efqc06dNzAVEiUtr/4nGov8EKW8Ydn8VIyR7Q5aPSYbDNFOcnMMGlALWBUeO
         klFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6zzNw/YjH3RxSUvMPTYr8To/FV4imd1UZZMrOjTqao=;
        b=Ez0ednCJvZDo1UVsgeCJE2ya/K4UjwzXkPWW2ml6NhK15K5AjUVwXcfwYw7OU0EkTf
         8vVpKXsXax9+I46MWr8YEMetWVdf6JOEMhlKXbtW37uLA44svBRZhv2KeWc8Ag/lrJOQ
         9VQXhQk1CH9I9p/PY7TK9KKemz99XB87xsIiIF362GqekbSySkuWXcJofI6gZLKWdYwo
         Bz5SbPHZ1zCJu/qyOoOMeun+ZRFOs4OQlZeSfuY36f+R6Tm0n2frOW1FpLW92ilPJkwg
         3F1EbwaAd4WRasH13K0iD2nLhMBRb8/ri1SqpfR9OXWGcDtq13oX8xVNI/k9FY4o4xzV
         oEEA==
X-Gm-Message-State: ACrzQf3N+qyLfhiyeD0PAWHpicVIy0W5PFZdYdg6d1qnJjKJzXAMohqa
        PK8c7u26mMcHdd0RHODYFlO9Wg==
X-Google-Smtp-Source: AMsMyM62Fch38nQ+xgGrRlTYEiO2c1L4XNclfYribautCoNr6damcDJC7SHKc+pc0Rst1dkMVvDxdA==
X-Received: by 2002:a17:903:11cf:b0:178:a8f4:d511 with SMTP id q15-20020a17090311cf00b00178a8f4d511mr937878plh.72.1664994041964;
        Wed, 05 Oct 2022 11:20:41 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i10-20020a170902cf0a00b00177f25f8ab3sm10803052plg.89.2022.10.05.11.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 11:20:41 -0700 (PDT)
Date:   Wed, 5 Oct 2022 18:20:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zixuan Wang <zxwang@fb.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        shankaran@fb.com, somnathc@fb.com, marcorr@google.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        zxwang42@gmail.com
Subject: Re: [kvm-unit-tests RFC PATCH 1/5] efi: Compile standalone binaries
 for EFI
Message-ID: <Yz3K9UXuut25wj2h@google.com>
References: <20220816175413.3553795-1-zxwang@fb.com>
 <20220816175413.3553795-2-zxwang@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816175413.3553795-2-zxwang@fb.com>
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
> Currently the standalone binaries do not work with EFI as the scripts
> are not aware of EFI-related files. More specifically, the scripts only
> search for .flat files, but EFI binaries are .efi files.
> 
> This patch fixes this by introducing a new 'efi' option for

Avoid this patch, and phrase changelogs as command.  E.g.

  Introduce an "efi" option in unittests.cfg <reasoning...>

> unittests.cfg. This patch does not contain any modifications to use this
> new efi option. Those updates will be folded into the follow-up patch.
> 
> Signed-off-by: Zixuan Wang <zxwang@fb.com>
> ---
>  scripts/common.bash     | 24 ++++++++++++++++++++++--
>  scripts/mkstandalone.sh | 17 ++++++++++++++++-
>  x86/unittests.cfg       |  3 +++
>  3 files changed, 41 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/common.bash b/scripts/common.bash
> index 7b983f7..7af9d62 100644
> --- a/scripts/common.bash
> +++ b/scripts/common.bash
> @@ -1,5 +1,21 @@
>  source config.mak
>  
> +function unittest_enabled()
> +{
> +	test_name="$1"
> +	test_efi="$2"
> +
> +	if [ -z "${test_name}" ]; then
> +		false
> +	elif [ "${CONFIG_EFI}" == "y" ] && [ "${test_efi}" == "no" ]; then
> +		false
> +	elif [ "${CONFIG_EFI}" == "n" ] && [ "${test_efi}" == "only" ]; then

Having to tag every test as EFI-friendly is going to get annoying, and without
context it's not super obvious that "efi = yes" means EFI-friendly _and_ legacy-
friendly.

Rather than "efi = {yes,no,only}", what about "efi = {unsupported,required}"?
I.e. tag only tests that don't support all flavors of firmware.
