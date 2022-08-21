Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CAF59B148
	for <lists+kvm@lfdr.de>; Sun, 21 Aug 2022 04:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236072AbiHUCFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Aug 2022 22:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbiHUCFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Aug 2022 22:05:37 -0400
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB1C18350
        for <kvm@vger.kernel.org>; Sat, 20 Aug 2022 19:05:36 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id i67so3988166vkb.2
        for <kvm@vger.kernel.org>; Sat, 20 Aug 2022 19:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=o2rScCjvXVxWvz35qYLyGk2pLCsnGqfLECgC0wg1Bvk=;
        b=pLCYwbzEZ12ocj/L4TxjXxjpUsjYtYGDgOr+pIAtoluJ+mgOBBVLDa+OU5CkBzOf4j
         DXW2De6hYt7MGB++7JZ8hYrhYRCTTFfr+nD9gzvYRm8oL2Y4IaNooPn/gwqDsQxCtqLT
         9OL6UNbicG/pDj0L6lznSd2EZ+a62pE5N1DSDkHWxm26kNxZTKai8IWF+dVByOEqyhog
         bBlSeLlYrzCu2GFmtZQIO4SD3kMGoRyJtU+ld/K357pqxoZxDbNYw95wPAxbP4ln7V3B
         pvNX+8hlwDvILzl1UA1gtf4F/4wFm1pabAt3ooWkaNJXs6VghpmOCIY5LnXDIfftIEcO
         G+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=o2rScCjvXVxWvz35qYLyGk2pLCsnGqfLECgC0wg1Bvk=;
        b=33WrvKTgQmuDXhJAzQG/bX0fAO7IbPP1dH+1bJMKvrZG0PFf47w/cDdHyA5584MxQ6
         vOrLE2Pw2fJKdZEuh3GuXB29S76uGe38n9cPy2JWK647duAp2Gv/8KCwZ3LEl7k8Njlt
         K5dxYhXfJWpGXZVWqKz8wlJ6BtX8/X3X3ebhxDnSViQsYo1J6CZiz9azRqGjFy0iVjcv
         iRbXIupXa1v/fqowLLJHpsaEaXIVL5Y7X+9X6aZOsA1LKnUjRzLJjINBhXH7A9xOQFrQ
         ec4qPJuWP0OLJOYNhiJfmNmyda4EWycLRBZYBE+lh5mcFhX9CXvSeqqlm8Q2mC9+a5ux
         jTLg==
X-Gm-Message-State: ACgBeo2mGd9z6Qx5pfK1VxszDmnJfvLwwWRVplvTb0bAki43POUFerqa
        iN3BT90fXRrSt929lYA0rLZD+G0LzOCuMDQTtRY=
X-Google-Smtp-Source: AA6agR4Xg3gCQo/iEnn+LX8dkvh+/clPMt9J53qz/CRS2vKYBZsKNrmUaMIZIWth/LdqWEpnAOwnhveae6voZbTQEeg=
X-Received: by 2002:a1f:d7c5:0:b0:38b:77e8:8efa with SMTP id
 o188-20020a1fd7c5000000b0038b77e88efamr1535642vkg.7.1661047535399; Sat, 20
 Aug 2022 19:05:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:6052:0:0:0:0:0 with HTTP; Sat, 20 Aug 2022 19:05:34
 -0700 (PDT)
Reply-To: wijh555@gmail.com
From:   "Prof. Chin Guang" <confianzayrentabilidad@gmail.com>
Date:   Sat, 20 Aug 2022 19:05:34 -0700
Message-ID: <CANrrfX5u6+m2s1NWFTOWshyxSRf-CZYFp1=GxTaWfyMb0tCawQ@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

-- 
The Board Directors want to know if you are in good health doing great and
with the hope that this mail will meet you in good condition, We are
privileged and delighted to reach you via email" And we are urgently
waiting to hear from you. and again your number is not connecting.

Sincerely,
Prof. Chin Guang
