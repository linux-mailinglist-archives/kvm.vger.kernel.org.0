Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B906ACFB6
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 22:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjCFVDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 16:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCFVDL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 16:03:11 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5702A6CB
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 13:03:07 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id h14-20020aa786ce000000b005a89856900eso6061702pfo.14
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 13:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678136587;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ox5t39D8exC5MlTd4JKWoX/S1r8DXoScCVAm6FqL7rY=;
        b=C73M/Vr/LvBWIy2A4y6akc9ekZE1IzX0hS9k6ydmmcw1pBIQnX3oMOqM08l+vhdubI
         W/klV34mIMX5MMQkFvzY7Nn9YzHeM1iQgoeTSGDI1mN81Yt5pvweGh+dcr87gRJBFrig
         UL2VkP1MMvFWWqkeBEHHcHGLaLSurWflL4sbArBXtYjS98PZMzHEy+/4En5hxRxD2gBI
         8wuPO6vindgIyAG7yoVWkuDRp9XD16JUHlo3RbYu7J7Q+BRKJSB6wo9k5dixU91MIoat
         2jCD03fKpTjZx4fyca8yzhTF2Ps9Otj8v/vZkeSL804mXmENb1ezkNtYHesnub9S1I0Q
         VgsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678136587;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ox5t39D8exC5MlTd4JKWoX/S1r8DXoScCVAm6FqL7rY=;
        b=m6SHX053Z0oe+rX+nykvmzvC6ju9uug1yPy/MQAo2NcNaUQ9G6sGOIXeA7ruQDFVCq
         bdI2dWxaDDegoB75lnncJDJooxIBDewH705xrxbAUnacEzQdbSM81Q/aVwZ0xRWDk/Cb
         oq2ecwIiHlA5JvjlTKu2cs99OHIzkjCbqFWO6JgXkjmGCDgjORTy1/ikDtgD9nBmwOwD
         GBTB0VUv8PJQKuS8HEljMMpXvzEoetfer3CxKq3HHgjVyF3VpCoWCTZfe4mqGfsfw/0q
         fQl88oCISLai2QGFr4nskFjzh8nYjul7YzfBJ66mzP2pXC+gJydkO2Zsm0JHh77ylbLR
         FMMQ==
X-Gm-Message-State: AO0yUKX2j0jyiqOgT/cU6QiB1D1X7FXULBJ3xGiQMAQEpLCZDY8m88js
        l2GJCqGi2H/G3e3+E6vDu72vU9rD1d4=
X-Google-Smtp-Source: AK7set9hIxIkU3escohvWsYYYndDS+3klnxI0ZZaiw7LXTPm2s7ZFZRivFThSsQGycmto2kn0atbZTJEmAc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2c1:b0:19a:5953:e85a with SMTP id
 s1-20020a17090302c100b0019a5953e85amr4854488plk.2.1678136587513; Mon, 06 Mar
 2023 13:03:07 -0800 (PST)
Date:   Mon, 6 Mar 2023 13:03:06 -0800
In-Reply-To: <000b01d94b66$4be1d8e0$e3a58aa0$@fastmail.fm>
Mime-Version: 1.0
References: <000b01d94b66$4be1d8e0$e3a58aa0$@fastmail.fm>
Message-ID: <ZAZVCosmv+KXA8mO@google.com>
Subject: Re: QUESTION: INT1 instruction for breakpoints
From:   Sean Christopherson <seanjc@google.com>
To:     billz@fastmail.fm
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023, billz@fastmail.fm wrote:
> Is it possible to use the INT1 (instead of INT3) instruction for breakpoints
> under KVM? It does not seem that this instruction causes a KVM_EXIT_DEBUG (or
> any other exit) and it is silently skipped instead.
> 
> If it is possible, how should I configure the KVM API to receive such exits?

#DBs from INT1, a.k.a. ICEBP, should be forwarded to userspace if KVM_GUESTDBG_USE_HW_BP
is set.
