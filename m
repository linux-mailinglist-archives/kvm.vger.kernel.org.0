Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F27FF641A12
	for <lists+kvm@lfdr.de>; Sun,  4 Dec 2022 01:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiLDAM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Dec 2022 19:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLDAMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Dec 2022 19:12:52 -0500
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A2110B51;
        Sat,  3 Dec 2022 16:12:51 -0800 (PST)
Received: by mail-vk1-f182.google.com with SMTP id b81so3851058vkf.1;
        Sat, 03 Dec 2022 16:12:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jqWnxoQvZbiditV/1/nr8cwEgzJwVCMstnT64OiZh8U=;
        b=tf+T9u907uk5YtRTeDl5/oBrKpXNZkXD7WbM2DVBly+K2gg5BnpdtEIfAlgWpNl8VK
         wwX7BjZI9y8lMdruIroKRGPxLye5x5NA0DN5xS+OrXzWVREj6vI3vzQDQageXtQFB1Cw
         IEPv6Jcggx6t2Z3qMgwNxTZMjn9zfi90Q1VgqQ+tbkNOwb+WkPv7aYWKCzkBx+CDovRP
         LBzR/jNR1Wh9Gus+6mCnMXl+huuwhg+x4EQ3mFXQhdMiK2wswpVIsZ1Wuy1qeAIAtNy7
         hUB8MkEJsxB5NDpn88pjSr+qHYAULvAFj6Cq+tCfl0rY50XEWj9AkOXDJniqVWdpdxL5
         LPvA==
X-Gm-Message-State: ANoB5pm3iK8+yDAHAxKqNvlUC2+wINsc/N3wufmhip+t4cJve5iE8Bng
        c08DcG1MDtd2YVRANog4RBeRpfB1ZpOjhL5D
X-Google-Smtp-Source: AA0mqf6cYJb6IiG2F2p/KITmH1zdKYD+ftKQbXZfuKmTYpgItos/yTYSNg6UFwRwGZnClivQ8on0yQ==
X-Received: by 2002:a05:6122:2017:b0:3bc:c10d:d61c with SMTP id l23-20020a056122201700b003bcc10dd61cmr23610760vkd.24.1670112770056;
        Sat, 03 Dec 2022 16:12:50 -0800 (PST)
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com. [209.85.217.42])
        by smtp.gmail.com with ESMTPSA id t16-20020ab06890000000b00418dce92951sm1481709uar.29.2022.12.03.16.12.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Dec 2022 16:12:49 -0800 (PST)
Received: by mail-vs1-f42.google.com with SMTP id 3so7111157vsq.7;
        Sat, 03 Dec 2022 16:12:49 -0800 (PST)
X-Received: by 2002:a05:6102:3c82:b0:3aa:17f4:d63d with SMTP id
 c2-20020a0561023c8200b003aa17f4d63dmr35558496vsv.22.1670112769083; Sat, 03
 Dec 2022 16:12:49 -0800 (PST)
MIME-Version: 1.0
From:   "mb@lab.how" <mb@lab.how>
Date:   Sat, 3 Dec 2022 17:12:38 -0700
X-Gmail-Original-Message-ID: <CAEdEoBYXHq9cCzsbMYTpG1B41Yz=-QAjFx7bJDOnPanN5Tmo7A@mail.gmail.com>
Message-ID: <CAEdEoBYXHq9cCzsbMYTpG1B41Yz=-QAjFx7bJDOnPanN5Tmo7A@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfio/pci: Remove console drivers
To:     alex.williamson@redhat.com
Cc:     airlied@linux.ie, dri-devel@lists.freedesktop.org,
        kraxel@redhat.com, kvm@vger.kernel.org, lersek@redhat.com,
        linux-kernel@vger.kernel.org, tzimmermann@suse.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I hope it is ok to reply to this old thread. Unfortunately, I found a
problem only now after upgrading to 6.0.

My setup has multiple GPUs (2), and I depend on EFIFB to have a working console.
pre-patch behavior, when I bind the vfio-pci to my secondary GPU both
the passthrough and the EFIFB keep working fine.
post-patch behavior, when I bind the vfio-pci to the secondary GPU,
the EFIFB disappears from the system, binding the console to the
"dummy console".
Whenever you try to access the terminal, you have the screen stuck in
whatever was the last buffer content, which gives the impression of
"freezing," but I can still type.
Everything else works, including the passthrough.

I can only think about a few options:

- Is there a way to have EFIFB show up again? After all it looks like
the kernel has just abandoned it, but the buffer is still there. I
can't find a single message about the secondary card and EFIFB in
dmesg, but there's a message for the primary card and EFIFB.
- Can we have a boolean controlling the behavior of vfio-pci
altogether or at least controlling the behavior of vfio-pci for that
specific ID? I know there's already some option for vfio-pci and VGA
cards, would it be appropriate to attach this behavior to that option?

Thanks,

Carlos Augusto
