Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D85E750038
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 09:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbjGLHjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 03:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbjGLHjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 03:39:13 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD5A1736
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 00:39:05 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id af79cd13be357-7659dc74d91so737770185a.0
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 00:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689147544; x=1691739544;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XSX0ZeahrnvaNzmAmLu1Myl1kkkc43Ed8hsVxXzZnHk=;
        b=Xc1zEFC8DCNmixs1/zkhfCqJps/uIsjK6PGyLi6h6ni+hgVUs/Gi4QTTMpkgYLRkEj
         I6hO2uVzdMuLrCxDXinlzAGGUm8JcME4ArgYz8DUnjjq8d8bPW6DYvGhZSFCw1tziSvb
         G8Qyr+iS6Rxz9OW597/v5MYMkdY9JHPt0siZGqqmDNsEJNCGlkNFn7jjd5Yje/N0Jw1H
         1njoXSh8LVAeVscTx8iXdsW2159FXc3lNJdafG+yCL4MSMAwdjbxhkM2KiQm0Yb0laUn
         wX7mvP6psMKy/NvVF+e7cw/llATqalTbC7CxU8lGniXIqeoSYp0FiXileEzsu45fW+u1
         AAAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689147544; x=1691739544;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XSX0ZeahrnvaNzmAmLu1Myl1kkkc43Ed8hsVxXzZnHk=;
        b=Bv5ZSaS3yv9AzUnJ6Pcpi7Gm2nKpT3DFw7iECUNh1IYrCGSYASXRjnQiO2M/CKftc8
         +U0po3GfVd4ey6D86PrfWDaRTZ86mEB1+eAC7SXqFcrUdGr0BVAHfXnAcAVYUFEUqvRO
         GCW4STaTuy6uITSVRTcbn2qcK6oc6mcRceOvPxmiE+o3iOt2jTT44pXq7tlN9n2iEKLi
         fU/oIZkH9DhGJbwwta/SeXVL8dt5ZAqnOEUZxULz0tRnzUKZmDFCw+kQgLxNKUuNub0j
         JNtbZR6/Kqi+JzpQCfy3AVUW1pWFqXi3DpQb74VcLfj3bC1m9AqDZQqYtej0XykakiOC
         up5g==
X-Gm-Message-State: ABy/qLbDujcHe7XpaDvpZ5OzD86dR+D5erEPAoKONZTvVrfr3lTxQddx
        mhmuyv+fJjBjVknkRUYN53034WSbN/l1Yqhb+r8=
X-Google-Smtp-Source: APBJJlFrj3n9O+IC5o5U/Vdm2ZEHCWl3GpvFvnlnL7/2UwV+QaWaoZFiBtsN+N/vG8v4+hBL7Yumx4bR63S/iXDetJc=
X-Received: by 2002:a05:620a:bc5:b0:767:40c5:cde3 with SMTP id
 s5-20020a05620a0bc500b0076740c5cde3mr21047830qki.62.1689147544398; Wed, 12
 Jul 2023 00:39:04 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:5a05:b0:365:9c9:ce6c with HTTP; Wed, 12 Jul 2023
 00:39:04 -0700 (PDT)
Reply-To: markwillima00@gmail.com
From:   Mark willins <parkings2014@gmail.com>
Date:   Wed, 12 Jul 2023 00:39:04 -0700
Message-ID: <CAJOam4fvSuGHeG=5eXwcQQnoHfY96q3DG142SO8jD0WR7Kdn-Q@mail.gmail.com>
Subject: Re: Greetings!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

Good day,


The HSBC Bank is a financial institution in United Kingdom. We
promotes long-term,sustainable and broad-based economic growth in
developing and emerging countries by providing financial support like
loans and investment to large, small and
medium-sized companies (SMEs) as well as fast-growing enterprises
which in turn helps to create secure and permanent jobs and reduce
poverty.

If you need fund to promotes your business, project(Project Funding),
Loan, planning, budgeting and expansion of your business(s) , do not
hesitate to indicate your interest as we are here to serve you better
by granting your request.


Thank you
Mr:Mark
