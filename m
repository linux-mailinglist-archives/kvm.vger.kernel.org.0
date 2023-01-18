Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B216728C2
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 20:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjARTxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 14:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjARTxS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 14:53:18 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F88058983
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 11:53:17 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id b17so131683pld.7
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 11:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7VGvfuzKywX7ABleZD8/gpW4Lo7pw6QlP4XHSkX/Guo=;
        b=YhOIm0CM7swLSju0MvkVZ+NDWGsvAiXteDdyQK6mcngpY0Rb2yxAFxX3QUD4oG7KRo
         /cWIqRbHTqpcycJGBA+Wc25t9EJYqnCb9XQxjVuQmnlCOpnoJ4Uq7wHkgdX5cIbi4L8L
         9YK/z/EUsT3dFcnw2PeyObgGmodhVBnexzAqhb5KEF7eR1BcMjHmFbKtS4tzVLbYx75X
         urmzOjQKe64WuXMVdbUOsm678hUJJqzIvTjZ+BU5yGWklcDsKaLIhBOvrJUS6rxVvzOe
         YfvgeYEVhJu4RH/6J7eFI8ndw3xJK0jmnkmSychMICKdbU7q0cTQ3B17/mLPZ8RltOEF
         Tb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7VGvfuzKywX7ABleZD8/gpW4Lo7pw6QlP4XHSkX/Guo=;
        b=aoIp7l4gZX491rKBU8TgyIAJ5x/6iVcBBZC3hNoNkU3eC9LcPJIT7gTL/SLpJVtKnO
         R6Z0I6DvVeNHIZ3AgIQOCUvykxvbvzudqA4fzdjG7gue1k2JiXywUMcofSKcfjaSQxZ2
         teEKy8Fol0hthhVtTrEjio1zwP0DyFaRLy3LEtjQHU1g/vsSDLA0N4iofqsVRfnv2WX4
         I36LqgBpYj4p8ES3ssBBY+n+Ob7q7h1wUKQgmi+KTwIYuPIhqkRmFe9SOXidZL8coogc
         oAByzXYvmxDLUPN8WRZ2OrYuyOBehkW/fZC3WyOYrpb+JCffcZ+KdelarMyr/OwM5wOj
         wcKA==
X-Gm-Message-State: AFqh2kpaYeQDhzfjOp41TADQZ+UDXcidp55YVoG+jLn4VGsnkNkclb8g
        Cq4360ZFyRREDQTkBf8HNpVmPg==
X-Google-Smtp-Source: AMrXdXuWGLI/Sd2idZjjLgF6CXGWepwVZGEI1bnsA9xLzuLphvtEfWkAqsiGa4+GnuH1NX+ku7Opbw==
X-Received: by 2002:a17:902:c189:b0:191:1543:6b2f with SMTP id d9-20020a170902c18900b0019115436b2fmr3479372pld.3.1674071596754;
        Wed, 18 Jan 2023 11:53:16 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y1-20020a17090a474100b002262dd8a39bsm1672775pjg.49.2023.01.18.11.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 11:53:16 -0800 (PST)
Date:   Wed, 18 Jan 2023 19:53:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     kvm@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: Fw: [linux-next:master] BUILD REGRESSION
 9ce08dd7ea24253aac5fd2519f9aea27dfb390c9
Message-ID: <Y8hOJhFVn2sv0tsF@google.com>
References: <20230117132800.b18b01c3895c26e8d3d003aa@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117132800.b18b01c3895c26e8d3d003aa@linux-foundation.org>
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

+Kees, I'm guessing this came in through a hardening branch[*].  I assume using
__DECLARE_FLEX_ARRAY isn't an option since this is a uapi header. :-/

[*] https://lore.kernel.org/all/20230105190548.never.323-kees@kernel.org


On Tue, Jan 17, 2023, Andrew Morton wrote:
> a KVM build error here.
> 
> Begin forwarded message:
> 
> Date: Wed, 18 Jan 2023 00:44:23 +0800
> From: kernel test robot <lkp@intel.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: netdev@vger.kernel.org, linux-scsi@vger.kernel.org, linux-gpio@vger.kernel.org, linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org, Linux Memory Management List <linux-mm@kvack.org>
> Subject: [linux-next:master] BUILD REGRESSION 9ce08dd7ea24253aac5fd2519f9aea27dfb390c9
> 
> 
> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> branch HEAD: 9ce08dd7ea24253aac5fd2519f9aea27dfb390c9  Add linux-next specific files for 20230117
> 
> Error/Warning reports:
> 
> https://lore.kernel.org/oe-kbuild-all/202301100332.4EaKi4d1-lkp@intel.com
> https://lore.kernel.org/oe-kbuild-all/202301171414.xpf8WpXn-lkp@intel.com
> https://lore.kernel.org/oe-kbuild-all/202301171511.4ZszviYP-lkp@intel.com
> 
> Error/Warning: (recently discovered and may have been fixed)
> 
> Documentation/mm/unevictable-lru.rst:186: WARNING: Title underline too short.
> ERROR: modpost: "kunit_running" [drivers/gpu/drm/vc4/vc4.ko] undefined!
> arch/arm/kernel/entry-armv.S:485:5: warning: "CONFIG_ARM_THUMB" is not defined, evaluates to 0 [-Wundef]
> drivers/gpu/drm/ttm/ttm_bo_util.c:364:32: error: implicit declaration of function 'vmap'; did you mean 'kmap'? [-Werror=implicit-function-declaration]
> drivers/gpu/drm/ttm/ttm_bo_util.c:429:17: error: implicit declaration of function 'vunmap'; did you mean 'kunmap'? [-Werror=implicit-function-declaration]
> drivers/scsi/qla2xxx/qla_mid.c:1094:51: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'unsigned int' [-Wformat=]
> drivers/scsi/qla2xxx/qla_mid.c:1189:6: warning: no previous prototype for 'qla_trim_buf' [-Wmissing-prototypes]
> drivers/scsi/qla2xxx/qla_mid.c:1221:6: warning: no previous prototype for '__qla_adjust_buf' [-Wmissing-prototypes]
> libbpf: failed to find '.BTF' ELF section in vmlinux
> usr/include/asm/kvm.h:508:17: error: expected specifier-qualifier-list before '__DECLARE_FLEX_ARRAY'
