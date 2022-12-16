Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEA664E6BB
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 05:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiLPEhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 23:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiLPEhd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 23:37:33 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32FB1147E;
        Thu, 15 Dec 2022 20:37:31 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id r18so986096pgr.12;
        Thu, 15 Dec 2022 20:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XLygs21yUm+BsQ9K/jaILqjtoVN7cCv+GmldKd5jCoY=;
        b=atuW7kj1tICjX6XOEoGlMKRElIbgy8WI/deoKifcFx1519QZRpDCOoxmKj7EgE2l4w
         PKzJI7L2ZbVuy2LOhWOolJwT0c6HGC5z3GYIC7j6xM/AunIUu1/hMOhZv9S06C7VFhC1
         4Q2nDbmd0YUF9RndxPqP2p/GdMMZ3K4yhoxZk3FVJ0hYXbi4IN4jZVfHJrGPnQoXbTYJ
         YAB5z7iNwRy7E4EGbWHbVIEyT9ICXQ8iqfiE3z4SLn1NrJW7NLywpAeLKJB/g9wvfmaM
         r5jcdkMrnO+dY5EbBAyyZATVFCQYX6igkBalPuLJ6BkhstYEmOV58RsJNRueXOX7Ax8G
         6CbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XLygs21yUm+BsQ9K/jaILqjtoVN7cCv+GmldKd5jCoY=;
        b=1RDrx1hZ8KHNAUD1/NRRTJ1CPTNhPrld6r2CD6nnJSi5rEybp6koCneM3aNZte9UBO
         cmDjJ7ObK2xdG8AixelWloZR1cGFaWt+L23EdMB1GSOiKHoLErguHgiF04Q24K6kjbD5
         JYKpKNAJPInTwyfZgymWBhR8UVMAwWJA3TlJ8iuR6zH16YLbK3AbPB0gt6yB/sytYR7z
         9dE/ikpFRmcOiB+qpcLUFGuTdO1j9+qdCFa5ifoItvkfjSFE2vGjal+EbK/6hRegywLh
         HDE5OPllMYS9sV6BAQmdjbenUXor3mHmKymQM3O0RYgsCJqIKaQxUJBTuQez460TA7iR
         2Zmw==
X-Gm-Message-State: AFqh2kqo1LdKxAEzULNywHgPzgjgnME/mdLFRsdSc6n6vPpAdXnpMm9V
        qM3EpT/p1resnd9qPpoHFbF1TFpJvVYrvz4OC/mm9WQjBiU=
X-Google-Smtp-Source: AMrXdXt5JWumad1PiboheGKsXmVaNjeH8snNXdAqZ+Iojn+pij8j6t8nwEgKCk6P8kauAlDPnokzu+Szv1Dew2bD4rM=
X-Received: by 2002:a63:584c:0:b0:484:2672:2c6a with SMTP id
 i12-20020a63584c000000b0048426722c6amr142358pgm.535.1671165451321; Thu, 15
 Dec 2022 20:37:31 -0800 (PST)
MIME-Version: 1.0
References: <639b23c8.DdUNqMCLdxZ7gLv2%lkp@intel.com>
In-Reply-To: <639b23c8.DdUNqMCLdxZ7gLv2%lkp@intel.com>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Fri, 16 Dec 2022 13:37:20 +0900
Message-ID: <CAMZ6RqJ7-GTPe7tNdhTYCF6OrnagfNL_7EXrhn5HD=YB8dtCGw@mail.gmail.com>
Subject: Re: [linux-next:master] BUILD REGRESSION 459c73db4069c27c1d4a0e20d055b837396364b8
To:     kernel test robot <lkp@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
        linux-xfs@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-can@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, kvm@vger.kernel.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue. 15 Dec. 2022 at 22:57, kernel test robot <lkp@intel.com> wrote:
> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> branch HEAD: 459c73db4069c27c1d4a0e20d055b837396364b8  Add linux-next specific files for 20221215
>
> Error/Warning reports:

(...)

> Documentation/networking/devlink/etas_es58x.rst: WARNING: document isn't included in any toctree

A patch for this warning is on its way:
  https://lore.kernel.org/linux-next/20221213051136.721887-1-mailhol.vincent@wanadoo.fr/T/#u

(...)

Yours sincerely,
Vincent Mailhol
