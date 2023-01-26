Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6304667D3A6
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 18:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjAZR6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 12:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjAZR6V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 12:58:21 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FDDF9
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 09:58:20 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id y21-20020a5ec815000000b00707f2611335so1351314iol.3
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 09:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NmgYwSmidr82FwutV6dspIi/c221nC1BTFRlHd5K4gs=;
        b=AJV8npnrjSgJLZwSzs6VZ1iHkyxZN3r1OxtvBWUrmcVVa7RFehUe45meyFfjk8tmp8
         04OeZvMdWVGZ+DeoHDWPsgFTgpTFHfZKL9bARjDccZ9SbZzOeSO0rfgui+AXO7cV859U
         932pygw8fw7IfI5ba6CkAullVsqhLd6xBTW8FGYUS4SfKu1nTj3FBbsx1OiRYLshJsGO
         t5RQP4Z01gj2BNRbCjRIpkraGJvlnnAMHJNrYbKN29fw/ExopsYl0RswGm9+9sPE50wu
         L1nMCwJsYGKg8bJwgsGMkjT/py8UW9yR+c0b+2Vg7xcJ5hly0m26VRhqfXBYGNecVNsk
         Uovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NmgYwSmidr82FwutV6dspIi/c221nC1BTFRlHd5K4gs=;
        b=eEexrRoqpZ3hCcFZKnA6OxG3kDpTPlk5L2qd0zAGrPGE5HCFwA6VoKE4vYyqUCi05e
         WotLFx+WXLoiK0tofAS+A8M38jc/PGxpUtKdocYFkEs9L6tAfCWKkinLqJWC9gX4Tsih
         dERSTaaamLAkwjb9DqwY+ty0Mk70miM3DCcc7A1Emc1m0ax/rX8mcaVoBf2/x8h/UUIR
         lFw1Joz8e3aCn7U7pI3jibiDCieUUlz91G3XxvUbMLwUQR4MuLwBBEe3Gxu7BNphkBsQ
         v8h4cGdbqZsX02ADGtLvLcIrkSdXPtPCo3TvP6gspgTyx5PYkezPMSyoDept7yBoKI5q
         za9g==
X-Gm-Message-State: AO0yUKXCJI9/Nf7BFCE943Crdh5WEn3og5HP74lhrmqdYqzNv8DrPFEi
        K0qH0F41oAXqW39wdxqmsxxzOkUGvqnYNSYkqA==
X-Google-Smtp-Source: AK7set9RXoW+vLrfkKD2p6H8sZp2UxSk5VNDr/VkZ4M7AKhSPVDmazB2PPmnyBPR8aCrnF+jcM6qqTUChcqeooOS0g==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6e02:10c4:b0:310:9eb2:9002 with
 SMTP id s4-20020a056e0210c400b003109eb29002mr1265960ilj.0.1674755899549; Thu,
 26 Jan 2023 09:58:19 -0800 (PST)
Date:   Thu, 26 Jan 2023 17:58:18 +0000
In-Reply-To: <Y8cIzKf52fzf0/d4@google.com> (message from Ricardo Koller on
 Tue, 17 Jan 2023 12:45:00 -0800)
Mime-Version: 1.0
Message-ID: <gsnth6wdqith.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 3/3] KVM: selftests: Print summary stats of memory latency distribution
From:   Colton Lewis <coltonlewis@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, seanjc@google.com, bgardon@google.com,
        oupton@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ricardo Koller <ricarkol@google.com> writes:

> Latency distribution (ns) = min:   732, 50th:   792, 90th:   901, 99th:
>                                  ^^^
> nit: would prefer to avoid the spaces

The spaces are there so each number has a fixed width and makes the
lines easy to visually compare because the numbers are aligned to the
same columns. No way to avoid some extra spaces and preserve this
property. What if a number is a different length than expected?  I chose
a uniform width I was confident would always fit a measurement of the
max.
