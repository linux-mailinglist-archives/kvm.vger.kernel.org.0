Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0456C8959
	for <lists+kvm@lfdr.de>; Sat, 25 Mar 2023 00:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjCXXgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 19:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbjCXXgk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 19:36:40 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9B41026A
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 16:36:39 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id o4-20020a056a00214400b00627ddde00f4so1668242pfk.4
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 16:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679700998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9+bxQZg6PDmWiMBXrimu+ZOwUvVgSMKhB14ekjMCWPU=;
        b=CEGlBJ5BlnEIDNcgMlLP8r55Ug7QNFkulbNGpDh/e46codqXSG41UnRVkqH2Naeygk
         3QTBnoZVYJD55lXISzaNq8Zm4gmxeKL5wZ/8el2pkLQGICz4F6oL8OE4vg9q2YMtBbcy
         44gvjItlGnZ2ko7c96vTL/WP5BDuBAdu813mS7GKw+njT3VibU+4DHJtkGmmnK298ulC
         tJO5zJYpeGMpRy9EC1Uk4HkGPt3UoU+4kagqzwEnI19brJ3qavsOD1SVe6+GgcvTkXv8
         Zte63oZR7jmq3tWWKWcIo6C4mTdfl+U3C3/Vq1H2pz4PuN+FLGLWeUeqM6yGQIrLLFJm
         u18Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679700998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9+bxQZg6PDmWiMBXrimu+ZOwUvVgSMKhB14ekjMCWPU=;
        b=Qvi6ppRtzp4whfSaMD5m0wGrCKjENjT9mP7tRNSSowlpYb14RHaO+UYwfDUi2ZO633
         EkzvB5wUOcea6MAROCR4/LCA0RCjnis8UWxmFSgF5ASqckmsQpsSEdxo3bwP55ZTcILR
         xweeboYdW/SEB0UunUyoD6K+MFEpk+oiElqfAyT6LW/IusyVBjlvY8OlDGL/WrUNliyC
         XUX+7vXLhqt6Bqpvb5l5xcsUTH0UxOguvKYRg84Ec75JNop1I2sKxk7ued14O5xdCReo
         jMXJ7r0/MXIGzG1YMsCcz9ZBiuIQl5kdRlOu/imVg1ZQ6PIlmVS0Rv7pZ3QbIqTUfRHL
         NZIg==
X-Gm-Message-State: AAQBX9dpNGkmXCSYnZVmbJgOJC1nWFNlmFO/DHPBtGAOQjNOCdXKecws
        uc92zsc3A4/6P6j03YxC9L9OR4JtNrA=
X-Google-Smtp-Source: AKy350Z4OKZ4keoWUFEZGvLPmRqRSVFrgSpNGOqcihJTxDTaIoXSCy4utCJyWpdxc+eY+qG4Yxm0ZUcOXIA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce81:b0:1a1:c945:4b2c with SMTP id
 f1-20020a170902ce8100b001a1c9454b2cmr1718863plg.7.1679700998624; Fri, 24 Mar
 2023 16:36:38 -0700 (PDT)
Date:   Fri, 24 Mar 2023 16:35:49 -0700
In-Reply-To: <20230224192832.1286267-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230224192832.1286267-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <167969125057.2755761.11781780031326714228.b4-ty@google.com>
Subject: Re: [PATCH] KVM: MIPS: Make kvm_mips_callbacks const
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Feb 2023 11:28:32 -0800, Sean Christopherson wrote:
> Make kvm_mips_callbacks fully const as it's now hardcoded to point at
> kvm_vz_callbacks, the only remaining the set of callbacks.
> 
> 

Applied to kvm-x86 generic, thanks!

[1/1] KVM: MIPS: Make kvm_mips_callbacks const
      https://github.com/kvm-x86/linux/commit/7ffc2e89518a

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
