Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2264957A9FC
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 00:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240294AbiGSWqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 18:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234340AbiGSWp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 18:45:58 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8249D4D4E0
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 15:45:57 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id a184so14798809vsa.1
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 15:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=YeEFrOpnueqp49lpSsCtkyhW66cD5QzqZPU5hyS5TkM=;
        b=T9CQ0qZSCkxryTp1rw281zppCH5MJSqm3c6+xEdbwVgghK9DnWCtEGcPLbhWdV2icx
         hj/ef6YSlwKx4Hb0UekivkxtXoa8YnLrSN3TCo+SEiKuOViFjHmUh/DptjSmGM+hjz7b
         y0XjLgbwjRaxvhTXFDjFO34+5Bi+um0+qY+K/iBmuGkxkxTsxGm2dRh/tXhmyhJ6Rsg+
         izYiHJSNGVb3dgEUSYNXXhu+GN3t2QWmzbTcAoyFDsvGzII30XiLoZDWAbb+ysw0qFnz
         qiHL4HNj8VYsD8t1kwCqDlPxUQqMWAD5YIHyY5gvptUv9WjAbNOAIiEBM7Rn7HXQNM2m
         dP/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=YeEFrOpnueqp49lpSsCtkyhW66cD5QzqZPU5hyS5TkM=;
        b=HNTlDbhSa3N01oW/Z2jHFZ/+a2aCjh/MCGF3Ah35DNvmJoKM5j6/BzTugYkCDvhuqe
         DVJvD2rA7LTpwzSk3dEa9yA0aF6/P0vLh3AaiOc7yqcr64a8dQePjpI2w/oTJga//L+y
         Lmw+Gib+oHmruw23yEPYgboBf74+CwCoGlW8+gZJ+hX5ZOP+YrIo5y8J2ekyL/J5lvn5
         lx8wgytXFcsovA8o707W63C5Vg/Y2ugosavYRwdAxrbWeVy4AokGBLRkPqeMgqex7IRk
         XRtokvDJto8xb1IBN79QuuWYjNEpcD+UEoXLFNxM/LsHDV0Y2pLQKP2pA7R/LeGzTUlt
         WvoA==
X-Gm-Message-State: AJIora9juWmAe6gu43NqnrmumtMQXMRVqqu/Oj3/dCo6LwIRnPsQAJKQ
        fPIHEQJDfNKFs8Bh2JfazQtusXoXkYxB+lJryDg=
X-Google-Smtp-Source: AGRyM1u0yKbjrXdunxefvn2ycH4Ii2fQoXuiMtq7G0h1nRec9rGOG4bUG/+lv0Kx4+4AHhUAYdPberNXaOxhBnNOklM=
X-Received: by 2002:a67:d89b:0:b0:357:63ba:5fc0 with SMTP id
 f27-20020a67d89b000000b0035763ba5fc0mr12791006vsj.9.1658270756348; Tue, 19
 Jul 2022 15:45:56 -0700 (PDT)
MIME-Version: 1.0
Sender: sanounicole70@gmail.com
Received: by 2002:a59:8d06:0:b0:2d2:447:2bb6 with HTTP; Tue, 19 Jul 2022
 15:45:55 -0700 (PDT)
From:   Lisa Williams <lw23675851@gmail.com>
Date:   Tue, 19 Jul 2022 23:45:55 +0100
X-Google-Sender-Auth: C4nHu5alcvUPlpGBqGukCxZkn8M
Message-ID: <CAJVju37y9cddu6MNQa-FTnjKCxs7VeWUGfpPK3_M1gQW7WJ_Vw@mail.gmail.com>
Subject: My name is Dr Lisa Williams
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dear,

My name is Dr Lisa Williams from the United States.I am a French and
American nationality (dual) living in the U.S and sometimes in France
for Work Purpose.

I hope you consider my friend request. I will share some of my pics
and more details about myself when I get your response.

Thanks

With love
Lisa
