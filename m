Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAB5553EA1
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 00:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354582AbiFUWjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 18:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbiFUWjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 18:39:13 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65AEA326C0
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 15:39:12 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id o18so6706569plg.2
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 15:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r8bgAc6icZs5MEglX2LAcpATmTJLiwMYojxJuozcJTk=;
        b=ldFXC/3uRupJ6uQCKUJ5T6DExNrh45wh4bdCqSFoZh3JIjkkeAZ+zsdTFzPdFG0w9n
         VyOrh3jgkTyiMO07bayBKvGO0QNHt5Ae+uuM2HnnKGuOtFH4+CRGmEvxQSxSMf63KUbX
         mlq3XcnSvqOt5CZzS/LuPJL6juWfiEp1DJdJW12WDm26+VMSpFjkIVt9Af/EGSXLsYM1
         Xcud4uSLnPNLFOWC4XD34U7Tjg9O2wvXvT8avB1WRGtaRtQN+UKqx1iBkx/4/tNkGOvi
         bpAoXTUaCJTeUi0BauNjOOOSUBP3/kChiPDajJDamk7IUVcnFWQitjmVSQAEb5emmAF+
         v7Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r8bgAc6icZs5MEglX2LAcpATmTJLiwMYojxJuozcJTk=;
        b=XkGe1aMr7TZv7sZuG1htwvBKSggfzrtT7RsyZDgDQQducJtgMefSTQC997SvcKgPCv
         8wz9s2tVaINraejluaZHorAeT98l/B9tF3eB0qNjnIZ2TR2FFKX8KPUqHgwiyKpF7twu
         5gucjmRHO6J/vkOPIBoAqkku7jtRq2bz5gSdI9dMIrpbWra8T1VNUv29iRkVxTgto5hw
         a8uJscuzn1Jy9wXc6oaOUEZWDDnl69NFL1aNYl46GJuiZUBJQo8by00+gEfGhT1eCdtv
         RcZquPasQg2E9ODJglf2HbInWP+ziqmU5Q82AzXrNbPPP0l1Bl4Cm/pfYOaJxBW7P6kd
         qh7A==
X-Gm-Message-State: AJIora8E7FdQoTpc4GDgmFe0L5cZw45tXyIrZuLK2HXO3QR3FQPc7a07
        2EDRxOmLkRQbz6vleydXHhSo/lBR9DyZ2w==
X-Google-Smtp-Source: AGRyM1vjqSL/U+M9dUA6NdASbGAWdeAlpgqcYBL+nHgN3d0EayoFKuFUhs4U+cKAEizv4BC3tJUaZQ==
X-Received: by 2002:a17:90a:520c:b0:1ec:ba51:1710 with SMTP id v12-20020a17090a520c00b001ecba511710mr9963635pjh.114.1655851151604;
        Tue, 21 Jun 2022 15:39:11 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id b9-20020a170902bd4900b0016782c55790sm9183148plx.232.2022.06.21.15.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 15:39:11 -0700 (PDT)
Date:   Tue, 21 Jun 2022 15:39:08 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 20/23] lib: Avoid external dependency
 in libelf
Message-ID: <YrJIjLhCaR6jZcl5@google.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-21-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-21-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:56:02PM +0100, Nikos Nikoleris wrote:
> There is just a small number of definitions we need from
> uapi/linux/elf.h and asm/elf.h and the relocation code is
> self-contained.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  arm/efi/reloc_aarch64.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arm/efi/reloc_aarch64.c b/arm/efi/reloc_aarch64.c
> index fa0cd6b..3f6d9a6 100644
> --- a/arm/efi/reloc_aarch64.c
> +++ b/arm/efi/reloc_aarch64.c
> @@ -34,8 +34,7 @@
>      SUCH DAMAGE.
>  */
>  
> -#include "efi.h"
> -#include <elf.h>
> +#include <efi.h>
>  
>  efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t image,
>  		       efi_system_table_t *sys_tab)
> -- 
> 2.25.1
>

Reviewed-by: Ricardo Koller <ricarkol@google.com>
