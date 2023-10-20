Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6437D1966
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 00:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjJTW5G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 18:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjJTW5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 18:57:04 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B09CD78
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 15:56:57 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7ed6903a6so17840047b3.2
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 15:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697842616; x=1698447416; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rBorPAF5YM6f/ewkW/XoPGAnJG2YiyHkn8S2mtLJ9Tg=;
        b=rH+D/C4iOEYBe1XPrZ4cbMokvMrCvVqkAaPd7IZQ8hfFdq5mJcga5rkLPp5hBlyJQD
         UCJhjou2uR6TWaTcXGU7thcvIWa0mo8LDHN6dZ1vOWWNhw+rGbGqJfsiMJF8gFQeNnav
         kK7q6BTI2WjRu8opEUQTiXNsJFo4wXRTe3FzsCu3v9yCJObejKLZ8TODsJQvkaeziMAb
         UU5eKcvulY9ZT0vZjVKdUDT1rTiPFjeu2zIfaDhy6TOJqALSYSzLIpAVQEmnEdC/F/CO
         6ifJal9AfVFHwH+wNxBh6OSpm3ZrgAE7oPiYm335g3gpjL68Ny7/rPuZbECPcNsAZXeB
         irkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697842616; x=1698447416;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rBorPAF5YM6f/ewkW/XoPGAnJG2YiyHkn8S2mtLJ9Tg=;
        b=Wd2pmYndL+cG5QPT7RLvp0BV5ZVi4lsMrNJAvNh03oIiRK0rhsASErUIqkhMTV3NhM
         5gBVmsz+EqIiHHQB1kWCVwsrGNt0APZkSzom4ZOpyFaycp8xROTEXgYT5C3xybtVsFo9
         4JySHIybh1hHpfC70rQgMLUd4hbX+gpeqq/lNiUnLkeE6+pSCNBVpa67itAzSzehsusr
         4kk+z/5qAQT5P2FRqdqF8mecsYORztSk988sxcb/PNo1vM+9hwIMKHRvKGa2v6bxvh+d
         RzOPoFABc0icJ7jXMa/pWCTOM5gHGtWkIp4Zdj2QMetn40qpkQXO21HczccXrkzmDoqe
         GRXQ==
X-Gm-Message-State: AOJu0YzjXMNepC/o443DRmX5I1I+/VFpMMIAxQTiE5pz3WXuCjO10Kjo
        16z2F3W9ftnI6I6P85EqrY+k9nKcUfA=
X-Google-Smtp-Source: AGHT+IFMaxIjPJYCd3kxYxbiADUpGTt63hGGpTu90ol6tTPoEvRJBzrQgOtGBV5ldguzLt8WKQ0RhnTdKuA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ac89:0:b0:d9a:bfd1:2c49 with SMTP id
 x9-20020a25ac89000000b00d9abfd12c49mr68347ybi.0.1697842616647; Fri, 20 Oct
 2023 15:56:56 -0700 (PDT)
Date:   Fri, 20 Oct 2023 15:56:23 -0700
In-Reply-To: <20231019043336.8998-1-liangchen.linux@gmail.com>
Mime-Version: 1.0
References: <20231019043336.8998-1-liangchen.linux@gmail.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <169773016212.2012031.11160812861776407782.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: remove the unused assigned_dev_head from kvm_arch
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        Liang Chen <liangchen.linux@gmail.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Oct 2023 12:33:36 +0800, Liang Chen wrote:
> Legacy device assignment was dropped years ago. This field is not used
> anymore.

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: remove the unused assigned_dev_head from kvm_arch
      https://github.com/kvm-x86/linux/commit/122ae01c5159

--
https://github.com/kvm-x86/linux/tree/next
