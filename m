Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8393D4FEB
	for <lists+kvm@lfdr.de>; Sun, 25 Jul 2021 22:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhGYTzw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jul 2021 15:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhGYTzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jul 2021 15:55:52 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24232C061757;
        Sun, 25 Jul 2021 13:36:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id D918C2E6;
        Sun, 25 Jul 2021 20:36:21 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net D918C2E6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1627245382; bh=PWJqoRENwRfHbihAwLZLmHYgX4yVLVVGbNyyEZbIyM4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Uk3oi7fUfB1+rPVN4shaOs8zTN7+0hE7QY9VhD347yQq+A/BEFwLnSe/FDM2nEJpQ
         IqVbCFmMEVjw8/Z+Z0yiJQjad1fvc135pW+Le7n63O8kDyzos4F7Z7zfNs/+nJUI3z
         zwe+6mEIjkemi7G+qpiBhQsRZ6ptx8QDGFWsvla6UsdNrlcBvaSYId9ZLp7uqTwHXw
         KgxZt+nRFB9Plzlkp/ZiBEkxAUFFO9RK1qNrUsB0l9nGcubF0zLuhxtSMr9AzjZZer
         YbEqyUf/VF3NgUHKKepPH84ZO5SizCDwr7gsaEW8M3mCQyNcg2+MJwdRB2aCmkuw6a
         saGsVjE6talyw==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, kvm@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/3] Get rid of some undesirable characters
In-Reply-To: <cover.1626947264.git.mchehab+huawei@kernel.org>
References: <cover.1626947264.git.mchehab+huawei@kernel.org>
Date:   Sun, 25 Jul 2021 14:36:21 -0600
Message-ID: <87fsw2uo56.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mauro Carvalho Chehab <mchehab+huawei@kernel.org> writes:

> Hi Jon,
>
> While rebasing my docs tree, I noticed that there are three remaining
> patches from my past series that replace some UTF-8 chars by ASCII
> ones that aren't applied yet. Not sure what happened here.
>
> Anyway, those are the missing ones.
>
> Mauro Carvalho Chehab (3):
>   docs: sound: kernel-api: writing-an-alsa-driver.rst: replace some
>     characters
>   docs: firmware-guide: acpi: dsd: graph.rst: replace some characters
>   docs: virt: kvm: api.rst: replace some characters
>
>  .../firmware-guide/acpi/dsd/graph.rst         |  2 +-
>  .../kernel-api/writing-an-alsa-driver.rst     |  2 +-
>  Documentation/virt/kvm/api.rst                | 28 +++++++++----------
>  3 files changed, 16 insertions(+), 16 deletions(-)

Applied, thanks.

jon
