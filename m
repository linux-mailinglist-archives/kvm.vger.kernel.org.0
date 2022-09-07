Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655A55B0802
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 17:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiIGPI0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 11:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIGPIX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 11:08:23 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829F3B5167
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 08:08:19 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id c198so5063640pfc.13
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 08:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=Sijq7jei1YFFEUTbO1jB6ms6P8qMwH8jdC+A+CFVOjg=;
        b=B/INToqfY8tuYhNZRrTEVfnye7JEYPP3h5k4X0eJmGKbHEkEvX3r2743efN+9in3wj
         oHupkruNSOyZJS0ZeuwCrgBEIMWfCPaTor7FNKcu3eiZHtAXiXacL9x6Wg8Vp7v4cUIh
         I1W7SOVjJJjSgvq/nmg2lQ0XgyMjw0pzACDNanRO9uUt52bbTp9XEG/AdB34cnDBRd4y
         kezCiRB3PJQ0iSdG1e3Tj3a1Ud8/d3oFF0IVT9xJ4lpHXbUg6hHuXNPKPQw4V0M07cP7
         3oMAoDg/3p9+gSSv4ciEsmL0Y40+x0w3S5guVwdwy6/6EOKYlyUk/bXdfj7jqP4m/0YA
         vRFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Sijq7jei1YFFEUTbO1jB6ms6P8qMwH8jdC+A+CFVOjg=;
        b=wEyGpNMkABWoYn/xhjUb4WGtmLhYACL5UUyd7UAOYW+3+aKfVdkKjpQF/uWB9UtifG
         2zIaIOreiYjJRbCGnSy4Sn7NFip4YBuGeRylARyXo6/S0i9ZHLsMXMZEGgqJ0HzYHmZN
         tH8C5mSOAicht5UKmu9SNiqbijKpj2SpQYOtHCUAci49qLQi4iq0tdh43vOV8XPhABj6
         6fQS5CA312ayB5v6tzL5FVClQSu3tbFNbZ2Glc4foq+LlmsDov6aa3AF02AqXmyzSceL
         NI7MNga1bFY1JFr43vjDDU+3nVtfbb+40f9VT310KFEpfUkQUCemX/VL7q6jhe1jBWfW
         /J2A==
X-Gm-Message-State: ACgBeo2jkc42eoIWTSgUTKZ4tVOPvfZylE64f5uDZ/7s55RwZsCIu2fq
        JVuU0somfZOWxOQ8E+ju76hV86GNU4yL4w==
X-Google-Smtp-Source: AA6agR5K9YxJ5HIgMMmPVoVd2PO6kO/CM7uljd/vM8bVWHluY2MZsFgdwdjE6A3Hjy90HNtPgF96aA==
X-Received: by 2002:a63:87:0:b0:42e:16f2:7a40 with SMTP id 129-20020a630087000000b0042e16f27a40mr3733607pga.302.1662563298829;
        Wed, 07 Sep 2022 08:08:18 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d2-20020a170902b70200b0017685f53537sm10043977pls.186.2022.09.07.08.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 08:08:18 -0700 (PDT)
Date:   Wed, 7 Sep 2022 15:08:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     =?utf-8?B?RnJhbnRpxaFlayDFoHVtxaFhbA==?= <frantisek@sumsal.cz>
Cc:     kvm@vger.kernel.org
Subject: Re: BUG: soft lockup - CPU#0 stuck for 26s! with nested KVM on 5.19.x
Message-ID: <Yxiz3giU/WEftPp6@google.com>
References: <a861d348-b3fd-fd1d-2427-0a89ae139948@sumsal.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a861d348-b3fd-fd1d-2427-0a89ae139948@sumsal.cz>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 07, 2022, František Šumšal wrote:
> Hello!
> 
> In our Arch Linux part of the upstream systemd CI I recently noticed an
> uptrend in CPU soft lockups when running one of our tests. This test runs
> several systemd-nspawn containers in succession and sometimes the underlying
> VM locks up due to a CPU soft lockup

By "underlying VM", do you mean L1 or L2?  Where

    L0 == Bare Metal
    L1 == Arch Linux (KVM, 5.19.5-arch1-1/5.19.7-arch1-1)
    L2 == Arch Linux (nested KVM or QEMU TCG, 5.19.5-arch1-1/5.19.7-arch1-1)

> (just to clarify, the topology is: CentOS Stream 8 (baremetal,
> 4.18.0-305.3.1.el8) -> Arch Linux (KVM, 5.19.5-arch1-1/5.19.7-arch1-1) ->
> Arch Linux (nested KVM or QEMU TCG, happens with both,
> 5.19.5-arch1-1/5.19.7-arch1-1) -> nspawn containers).

Since this repros with TCG, that rules out nested KVM as the cuplrit.

> I did some further testing, and it reproduces even when the baremetal is my
> local Fedora 36 machine (5.17.12-300.fc36.x86_64).
> 
> Unfortunately, I can't provide a simple and reliable reproducer, as I can
> reproduce it only with that particular test and not reliably (sometimes it's
> the first iteration, sometimes it takes an hour or more to reproduce).
> However, I'd be more than glad to collect more information from one such
> machine, if possible.

...

> Also, in one instance, the machine died with:

Probably unrelated, but same question as above: which layer does "the machine"
refer to?
