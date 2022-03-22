Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D424E44EF
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238123AbiCVRYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239519AbiCVRY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:24:28 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19090237;
        Tue, 22 Mar 2022 10:23:00 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id i186so2375524wma.3;
        Tue, 22 Mar 2022 10:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=aRoVcBOHgM/bPJSJSqXhRaIwaT3UuhMY9GonRHMXbqEfftdO0iIwyyW/iDkbCVTA+e
         lNKBzC3Po3YV8/FIHb59G0SaTYApGQwOdaAk4JTTI7rQHrvX5CjAp9Z1C0G/2MtNXuoN
         fndArZZiBp/+Eq/1j1NXFzXmsohvZ6Gd/hULxlIoJwVu1E13X+DZKiPiOLpgPqbpeCi3
         SRMNMfnWD0WRbvPh7VfsNnyZaFN/DcfZrmwCKiEpobCRDKDF3ffHqcJkK6b0OxT7vGFx
         Z+QEBaeN8aIOtMOuNbKHShBjLjpMu6c7mKNsF/lRhxu6zS/+f6RC7pU+LzFAykulzgOH
         Nwuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=nFcJcbB4al7BodMrwwyrwm4BHZah9OWMxzJj49kxy9Lv8uGA09QlzdKa+7FYi7zp/B
         +TkN/ZAoBP8Jfu0tee+CX9ej6teTP58w8fy80mK0+m3+3DL2cgVv3zfBHWFhoH9RQV7X
         dEgulhxNcp6Vi4KG6a4viIDwhRDttGygy/zt2X3nGirjkFmrAeGDa4CYXnetV2yduD1N
         cv2ipPLnQAzUTkIgW4phf3JyZV0rXr7mSZBqOOYIh4HaCf3AZIRCUwc6mnbsRxwzW2Ab
         JX2AB1J18DgkCAvUnujZn91nyMC3rOswc1w7Y1/xa7VHp3qdVOwmqqYKDYVTNexpXuhE
         OrkQ==
X-Gm-Message-State: AOAM5334kEM1ENFjewL0Ca8tV1DiFpeUvfCAsZsHclDzyQ8cS6g+yem5
        yYc9TahiNMhJLo25nDVXxEYwWYa65xk=
X-Google-Smtp-Source: ABdhPJxEAXXzHubn+advKnJbYKpYFmUIB3ii3RqP1kAQOxL/SWRw9xfmj4/gWfLzVzKc22HV24m2+A==
X-Received: by 2002:a1c:e908:0:b0:38c:782c:2a62 with SMTP id q8-20020a1ce908000000b0038c782c2a62mr4742238wmc.135.1647969778541;
        Tue, 22 Mar 2022 10:22:58 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d15-20020a056000186f00b0020384249361sm18516828wri.104.2022.03.22.10.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 10:22:57 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] KVM: x86: Fix clang -Wimplicit-fallthrough in do_host_cpuid()
Date:   Tue, 22 Mar 2022 18:22:52 +0100
Message-Id: <20220322172252.269813-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220322152906.112164-1-nathan@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


