Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701C97D7AF3
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 04:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbjJZCgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 22:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjJZCgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 22:36:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFC012F;
        Wed, 25 Oct 2023 19:36:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BCFC433CB;
        Thu, 26 Oct 2023 02:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698287812;
        bh=LBVZhaeW6URQlbztVArsjMfHnEivxm0gNeW9b+4uxUY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eW6iceniXu3Ffgu1UweUFktui6RyVIq7qDzoKXTlM2TitHXFMMgJ3fkZ9GtwDaVtz
         FvJPfqDZns+dlSfcwy6MFjZoOw2d4ZaNr/lu3MnFNqVxJIiaeoPwa3FDX/KtXvbGNb
         Y059piHI5naPI/WGQ6F09KlJOvG+C76w2Kyb/83NS8pFBHSTYM8KS4iETbD5Mnu1YQ
         y651QPEi5iQGUE3YIj0bjcdqkITS7AC0P9Hu/BlZTUfHNvgV/hYxZX9k/2w390tl1C
         kGs+3Bg+Gd0M+FzkEiD0pqVrkMH+LrprxF1yJomT95VpswLdr7FnF16K5Vr7mEl2Fy
         iCS0Bs6TqjpFQ==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-507ad511315so555257e87.0;
        Wed, 25 Oct 2023 19:36:52 -0700 (PDT)
X-Gm-Message-State: AOJu0YzjtuCUgJwpjlaP9UI5R/wit6W20+1FfeS//m8QyLTaWyzD+dbx
        rbXRD7vXKpZWNrCkzbhx7mJ7xn795oJ5ZHJbefQ=
X-Google-Smtp-Source: AGHT+IEJm64k8zz1qwwSZBzF8xmGdZN3VVlcqXMTYBwBwJ955QK5mEmGWCA+iioc4r1gJ31+xvfExuA7ByJgMKvT+ag=
X-Received: by 2002:ac2:5edb:0:b0:4ff:ae42:19e2 with SMTP id
 d27-20020ac25edb000000b004ffae4219e2mr12246988lfq.58.1698287810378; Wed, 25
 Oct 2023 19:36:50 -0700 (PDT)
MIME-Version: 1.0
References: <20231005091825.3207300-1-chenhuacai@loongson.cn>
 <CAAhV-H7VN_r-SzEMK6LHqXzVbNemZYuYYLb2mri=EGZ7qb3C3A@mail.gmail.com> <791d3b77-8a4d-4c5e-88db-f38843d37098@redhat.com>
In-Reply-To: <791d3b77-8a4d-4c5e-88db-f38843d37098@redhat.com>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Thu, 26 Oct 2023 10:36:38 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7vuFhcOf7SaJ1C9Jv6E0LjYkY_TzKSRCXCDTag1f+OEQ@mail.gmail.com>
Message-ID: <CAAhV-H7vuFhcOf7SaJ1C9Jv6E0LjYkY_TzKSRCXCDTag1f+OEQ@mail.gmail.com>
Subject: Re: [GIT PULL] LoongArch KVM changes for v6.7
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@loongson.cn>, kvm@vger.kernel.org,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 26, 2023 at 7:54=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On 10/25/23 04:10, Huacai Chen wrote:
> > Hi, Paolo, Excuse me, but this is just a gentle reminder. The 6.7 merge
> > window is coming soon, have you missed this PR mail? Or should I rebase
> > to 6.6-rc7 to send a new PR (a randconfig build error is fixed in 6.6-r=
c7)?
>
> Hi,
>
> I am expecting some changes to Kconfig for 6.7 and wanted to pull this
> second, to solve the conflicts.
>
> There is no need to rebase, but it would be useful to point me to the
> fix in 6.6-rc7.
OK, thanks. And the commit 449c2756c2323c9e32b2a2fa9 ("LoongArch:
Export symbol invalid_pud_table for modules building") fixes the
randconfig build error.

Huacai

>
> Paolo
>
