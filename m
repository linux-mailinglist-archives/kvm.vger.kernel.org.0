Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293947253BA
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 07:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbjFGFyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 01:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233780AbjFGFx6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 01:53:58 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DE390;
        Tue,  6 Jun 2023 22:53:57 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-64d44b198baso194111b3a.0;
        Tue, 06 Jun 2023 22:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686117237; x=1688709237;
        h=in-reply-to:references:message-id:content-transfer-encoding:cc:to
         :from:subject:date:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b9p0m2NvKT3cZmqPkFsE+AtBiAL9OCBr7TGAbcichu4=;
        b=jFP46XWufvIf3gr10NWNEJKcizv7NqvEjIahxEMLBXlFmlhzqSyz3zyAG53RSeBqlm
         2HWlj1t9N8SC4Hzl9NY4gHiKBNxTjie4mEzNTFCPT1OT/zPxM1hMiDlY0/ehX8H2R2bw
         fp6k+CPkZxtkoGjcxDdJoSEvMhuOqlc8oDwtzvuXtQhFrHaaDb69sd+wo9AcEXlvHNuZ
         STofx7NwMjuWxUunmyQwPuJGvRM9NGpkf8f7DOLXPj7nzBaBpNGgH39mEfVw07Tz586N
         AO7vTloRO6Q7k/ThcJi0kL3aU+rYv4tN181ygWUUrKJYB08RO8x2odvF0FMjoI0BrtXU
         AZtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686117237; x=1688709237;
        h=in-reply-to:references:message-id:content-transfer-encoding:cc:to
         :from:subject:date:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b9p0m2NvKT3cZmqPkFsE+AtBiAL9OCBr7TGAbcichu4=;
        b=kNpa8Jnvn7b3seIrLXlp34OPIapw5DbskKgUH6/iESs9drGvTuchz7G1QaqnsDmXZN
         cgSQ79HYGr8yQCYZEiBZ86bUEPPDGTzAdHLeC8pHS4eXNHlv13yvVQZJBZrAKRUml7R1
         HtXM2f9K9bNBG18kiS5H7UYhMA64JNuHr7b2N7J4PS2h1/HdbHXGKbYd9DusA7waWJZ8
         554eD0qeTh6trCMQaMUO9Ne5dqDxP0AzhTFA+5sa77wd+kwEhvWUuy5ump+FZ0JWDQPS
         0OZnAhvLw/46eO0HYcXfei0OhDyqPsYbrz7bIuHm9IfmeiJeryFf2VzlajbcsmdZCBkJ
         n4KQ==
X-Gm-Message-State: AC+VfDz5CWC1WaVeqDblsurnmxXURjL1jckPsWzrs81j/XC87p15meE6
        /HfLnVQPZTsz5a9zcj+ik7KxMBERurQ0nA==
X-Google-Smtp-Source: ACHHUZ4680Um19V/5LAOXB+CrQ9+yfVd2mnz+GmqeZGDj24KdFC1jM2f7R8fD/rJ1IrDoQR5g8JNxw==
X-Received: by 2002:a05:6a00:189a:b0:652:a559:b2c5 with SMTP id x26-20020a056a00189a00b00652a559b2c5mr6028184pfh.13.1686117236975;
        Tue, 06 Jun 2023 22:53:56 -0700 (PDT)
Received: from localhost ([1.146.33.32])
        by smtp.gmail.com with ESMTPSA id p9-20020a62ab09000000b0063d2d9990ecsm7622983pff.87.2023.06.06.22.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 22:53:56 -0700 (PDT)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 07 Jun 2023 15:53:49 +1000
Subject: Re: [RFC PATCH v2 0/6] KVM: PPC: Nested PAPR guests
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Jordan Niethe" <jpn@linux.vnet.ibm.com>,
        <linuxppc-dev@lists.ozlabs.org>
Cc:     <kvm@vger.kernel.org>, <kvm-ppc@vger.kernel.org>,
        <mikey@neuling.org>, <paulus@ozlabs.org>,
        <kautuk.consul.1980@gmail.com>, <vaibhav@linux.ibm.com>,
        <sbhat@linux.ibm.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <CT6641NE8LNV.20P6CCOLXZEP@wheely>
X-Mailer: aerc 0.14.0
References: <20230605064848.12319-1-jpn@linux.vnet.ibm.com>
In-Reply-To: <20230605064848.12319-1-jpn@linux.vnet.ibm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon Jun 5, 2023 at 4:48 PM AEST, Jordan Niethe wrote:
> There is existing support for nested guests on powernv hosts however the
> hcall interface this uses is not support by other PAPR hosts.

I kind of liked it being called nested-HV v1 and v2 APIs as short and
to the point, but I suppose that's ambiguous with version 2 of the v1
API, so papr is okay. What's the old API called in this scheme, then?
"Existing API" is not great after patches go upstream.

And, you've probably explained it pretty well but slightly more of
a background first up could be helpful. E.g.,

  A nested-HV API for PAPR has been developed based on the KVM-specific
  nested-HV API that is upstream in Linux/KVM and QEMU. The PAPR API
  had to break compatibility to accommodate implementation in other
  hypervisors and partitioning firmware.

And key overall differences

  The control flow and interrupt processing between L0, L1, and L2
  in the new PAPR API are conceptually unchanged. Where the old API
  is almost stateless, the PAPR API is stateful, with the L1 registering
  L2 virtual machines and vCPUs with the L0. Supervisor-privileged
  register switching duty is now the responsibility for the L0, which
  holds canonical L2 register state and handles all switching. This
  new register handling motivates the "getters and setters" wrappers
  ...

Thanks,
Nick
