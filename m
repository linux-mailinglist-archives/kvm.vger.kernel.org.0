Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B397684C1
	for <lists+kvm@lfdr.de>; Sun, 30 Jul 2023 12:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjG3KK1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Jul 2023 06:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjG3KKZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Jul 2023 06:10:25 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F34199B
        for <kvm@vger.kernel.org>; Sun, 30 Jul 2023 03:10:24 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1b8ad8383faso30316505ad.0
        for <kvm@vger.kernel.org>; Sun, 30 Jul 2023 03:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690711824; x=1691316624;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7vbeat7gc1TyWboucLMJalCXXcPp9smqPJ03/W7eXSI=;
        b=j63J9JaSlJIUF3sFV5WmTAMBIoHyYuOkNwkIpkJTij4KBS5mab7ZUiy4LAXSDDwkUj
         LITuA89SuPsgaXdTI30Xl/ZwvNJ2BLYgJzqaOpYct9U3vCLGDmwTojfwiRMHAGdvkRHi
         yXwztAWCc9t7BqvzcVqOM0pv+DEDOXU6lj/k6VRQsLJ+GBtKxUfgJJqGMhNBLWxQGP0S
         p7w2dZa1BOxcALrAsaE/rM9HMzAWOYitun0k8v+waZx/mZaLvqLUDzUKdwFUQMVR3HDC
         kFTyeEkCTJgF0JD6E6b4T9sdWWeV0YL1dxH0IUOEDgNE0CO2eZgxXu+O8robTjfCAy53
         W6cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690711824; x=1691316624;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7vbeat7gc1TyWboucLMJalCXXcPp9smqPJ03/W7eXSI=;
        b=kDo2Mma+T/c9MLLG0jbRAS2jRJzdyDP43J9O+eEn6tIq44yxZzlf/vnB0PBj2ag77Y
         UWZZJgNuKokFO8vdzu50PhZjVYiOVNW/PbCbw3vamDxJ0QyCbVB3GVw95OnCeTOb697u
         2rjcKEfSdRQPrrak3QpycV48Gj4QcMVJND2iDqqQ2ooyXodgv5tmXA06wAaZOE9koM8G
         G4pZyUdeo2jOs+3EX8aCohvHi7YlNwDXdmvErVDIZHc8XOYvoCAsv5illV92Yfyt49D+
         HO7kq6V0t5xecJGE3GE2eIWad6WSHF7GiyvYDBxfdf1ZU30r8QYQ0D3cSKgIX0ya4icE
         HrNA==
X-Gm-Message-State: ABy/qLZbiudJPrthxVIzIzGQnqYXbKkWe/hqWoHzhkMzbBTpSH8nmyTF
        30zxQ4KN+DL0r+STfkrcg8A=
X-Google-Smtp-Source: APBJJlEBrgkD2QYBcps3fbNIU4lA96u0yMPXej/dwdD6CAG3iCQPZaRyytvsoXRZeACgNm5t1xfbuw==
X-Received: by 2002:a17:902:e542:b0:1b6:6f12:502e with SMTP id n2-20020a170902e54200b001b66f12502emr8710163plf.49.1690711824038;
        Sun, 30 Jul 2023 03:10:24 -0700 (PDT)
Received: from localhost (110-174-143-94.tpgi.com.au. [110.174.143.94])
        by smtp.gmail.com with ESMTPSA id jh22-20020a170903329600b001a6f7744a27sm6426015plb.87.2023.07.30.03.10.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Jul 2023 03:10:23 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 30 Jul 2023 20:10:19 +1000
Message-Id: <CUFFBJ9KF120.11CLOEQAA477Z@wheely>
From:   "Nicholas Piggin" <npiggin@gmail.com>
To:     "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>
Cc:     <linuxppc-dev@lists.ozlabs.org>,
        "Laurent Vivier" <lvivier@redhat.com>
Subject: Re: [kvm-unit-tests v4 00/12] powerpc: updates, P10, PNV support
X-Mailer: aerc 0.15.2
References: <20230608075826.86217-1-npiggin@gmail.com>
 <f2d4d019-4a77-7ba9-d564-6e39b194a5d8@redhat.com>
In-Reply-To: <f2d4d019-4a77-7ba9-d564-6e39b194a5d8@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon Jul 3, 2023 at 11:27 PM AEST, Thomas Huth wrote:
> On 08/06/2023 09.58, Nicholas Piggin wrote:
> > Posting again, a couple of patches were merged and accounted for review
> > comments from last time.
>
> Sorry for not being very responsive ... it's been a busy month.

Hah that's okay, I'll say the same thing. I was meaning to get
back to Joel and your comments but lots on all of a sudden, sigh.

> Anyway, I've now merged the first 5 patches and the VPA test since they l=
ook=20
> fine to me.
>
> As Joel already wrote, there is an issue with the sprs patch, I also get =
an=20
> error with the PIR register on the P8 box that I have access to as soon a=
s I=20
> apply the "Specify SPRs with data rather than code" patch. It would be go=
od=20
> to get that problem resolved before merging the remaining patches...

Thanks for this, yes needs a bit more polish. I'll try to get to
it now that qemu is mostly done for 8.1.

Thanks,
Nick
